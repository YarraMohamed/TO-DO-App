//
//  DoneViewController.m
//  To Do App
//
//  Created by Yara Mohamed on 23/04/2025.
//

#import "DoneViewController.h"
#import "Task.h"
#import "DetailsViewController.h"
#import "TableViewCell.h"

@interface DoneViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *donePhoto;

@end

@implementation DoneViewController

- (void)viewWillAppear:(BOOL)animated{
    _lowTasks = [NSMutableArray new];
    _mediumTasks = [NSMutableArray new];
    _highTasks = [NSMutableArray new];
    _done = [NSMutableArray new];
    _seprated = NO;
    
    NSError *error;
    NSData *savedData = [_defaults objectForKey:@"tasksArray"];
    NSSet *set = [NSSet setWithArray:@[
        [NSMutableArray class],
        [NSString class],
        [NSDate class],
        [Task class],
    ]];
    
    _all = [NSKeyedUnarchiver unarchivedObjectOfClasses:set fromData:savedData error:&error];
    for(int i = 0; i<_all.count;i++){
        if(_all[i].status == 2){
            [_done addObject:_all[i]];
            if(_all[i].priority == 0){
                [_lowTasks addObject:_all[i]];
            }else if(_all[i].priority == 1){
                [_mediumTasks addObject:_all[i]];
            }else{
                [_highTasks addObject:_all[i]];
            }
        }
    }
    
    if(self.done.count == 0){
        [self.tableView setHidden:YES];
        [self.donePhoto setHidden:NO];
    }else{
        [self.tableView setHidden:NO];
        [self.donePhoto setHidden:YES];
    }
    [_tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *filter = [UIImage imageNamed:@"sort"];
    UIBarButtonItem *filterBtn = [[UIBarButtonItem alloc] initWithImage:filter style:UIBarButtonItemStylePlain target:self action:@selector(separeteSections)];
    self.navigationItem.rightBarButtonItem = filterBtn;
    
    _defaults = [NSUserDefaults standardUserDefaults];
}

-(void) separeteSections {
    
    if([self seprated] == NO){
        self.seprated = YES;
    }else{
        self.seprated = NO;
    }
    [_tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if([self seprated] == NO) return 1;
    else return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([self seprated] == NO){
        return _done.count;
    }else{
        switch (section) {
            case 0:
                return _lowTasks.count;
                break;
            case 1:
                return _mediumTasks.count;
                break;
            default:
                return _highTasks.count;
                break;
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if([self seprated] == NO) return @"Tasks";
    else{
        switch (section) {
            case 0:
                return @"Low";
                break;
            case 1:
                return @"Medium";
                break;
            default:
                return @"High";
                break;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    Task *task = [Task new];
    if ([self seprated] == NO) {
        task = _done[indexPath.row];
        cell.taskName.text = task.taskName;
    }else{
        if(indexPath.section == 0){
            task = _lowTasks[indexPath.row];
            cell.taskName.text = task.taskName;
        }else if(indexPath.section == 1){
            task = _mediumTasks[indexPath.row];
            cell.taskName.text = task.taskName;
        }else{
            task = _highTasks[indexPath.row];
            cell.taskName.text = task.taskName;
        }
    }

    if(task.priority == 0){
        UIImage *image = [UIImage imageNamed:@"low"];
        [cell.taskPhoto setImage:image];
    }else if(task.priority == 1){
        UIImage *image = [UIImage imageNamed:@"medium"];
        [cell.taskPhoto setImage:image];
    }else{
        UIImage *image = [UIImage imageNamed:@"high"];
        [cell.taskPhoto setImage:image];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Confirmation" message:@"Are you sure you want to delete this item?" preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            Task *taskToDelete;
  
            if (!self.seprated) {
                taskToDelete = self.done[indexPath.row];
                [self.done removeObjectAtIndex:indexPath.row];
            } else {
                switch (indexPath.section) {
                    case 0:
                        taskToDelete = self.lowTasks[indexPath.row];
                        [self.lowTasks removeObjectAtIndex:indexPath.row];
                        break;
                    case 1:
                        taskToDelete = self.mediumTasks[indexPath.row];
                        [self.mediumTasks removeObjectAtIndex:indexPath.row];
                        break;
                    default:
                        taskToDelete = self.highTasks[indexPath.row];
                        [self.highTasks removeObjectAtIndex:indexPath.row];
                        break;
                }
                [self.done removeObject:taskToDelete];
            }
            [self.all removeObject:taskToDelete];
            
            NSError *error;
            NSData *archiveData = [NSKeyedArchiver archivedDataWithRootObject:self.all requiringSecureCoding:YES error:&error];
            [self.defaults setObject:archiveData forKey:@"tasksArray"];
            
            [tableView beginUpdates];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView endUpdates];

            if(self.done.count == 0){
                [self.tableView setHidden:YES];
                [self.donePhoto setHidden:NO];
            }else{
                [self.tableView setHidden:NO];
                [self.donePhoto setHidden:YES];
            }

        }];

        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:confirm];
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailsViewController *detailsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"details"];
    Task *task = [Task new];
    if([self seprated] == NO){
        task = _done[indexPath.row];
        detailsVC.task = task;
    }else{
        switch (indexPath.section) {
            case 0:
                task = _lowTasks[indexPath.row];
                detailsVC.task = task;
                break;
            case 1:
                task = _mediumTasks[indexPath.row];
                detailsVC.task = task;
                break;
            default:
                task = _highTasks[indexPath.row];
                detailsVC.task = task;
                break;
        }
    }
    detailsVC.index = 3;
    [self.navigationController pushViewController:detailsVC animated:YES];
}


@end
