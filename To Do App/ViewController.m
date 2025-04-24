//
//  ViewController.m
//  To Do App
//
//  Created by Yara Mohamed on 23/04/2025.
//

#import "ViewController.h"
#import "AddViewController.h"
#import "DetailsViewController.h"
#import "TableViewCell.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *search;
@property (weak, nonatomic) IBOutlet UIImageView *photo;

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated{
    _lowTasks = [NSMutableArray new];
    _mediumTasks = [NSMutableArray new];
    _highTasks = [NSMutableArray new];
    _toDo = [NSMutableArray new];
    _filteredTasks = [NSMutableArray new];
    
 
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
        if(_all[i].status == 0){
            [_toDo addObject:_all[i]];
            if(_all[i].priority == 0){
                [_lowTasks addObject:_all[i]];
            }else if(_all[i].priority == 1){
                [_mediumTasks addObject:_all[i]];
            }else{
                [_highTasks addObject:_all[i]];
            }
        }
    }
    
    
    if(_toDo.count == 0){
        [_tableView setHidden:YES];
        [_photo setHidden:NO];
    }else{
        [_tableView setHidden:NO];
        [_photo setHidden:YES];
    }
    
    [_tableView reloadData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(action)];
    
    _defaults = [NSUserDefaults standardUserDefaults];
    _isFiltered = false;
    _search.delegate = self;    
}

-(void) action {
    AddViewController *addVC = [self.storyboard instantiateViewControllerWithIdentifier:@"add"];
    [self.navigationController pushViewController:addVC animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(_isFiltered) return 1;
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(_isFiltered){
        return _filteredTasks.count  ;
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
    if(_isFiltered){
        return @"Tasks";
    }else{
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
    if(_isFiltered){
        task = _filteredTasks[indexPath.row];
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
    return  cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(editingStyle == UITableViewCellEditingStyleDelete){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Confirmation" message:@"Are you sure you want to delete this item?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [ UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [tableView beginUpdates];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            Task *task;
            switch (indexPath.section) {
                case 0:
                    task = self.lowTasks[indexPath.row];
                    [self.lowTasks removeObjectAtIndex:indexPath.row];
                    [self.toDo removeObject:task];
                    [self.all removeObject:task];
                    break;
                case 1:
                    task = self.mediumTasks[indexPath.row];
                    [self.mediumTasks removeObjectAtIndex:indexPath.row];
                    [self.toDo removeObject:task];
                    [self.all removeObject:task];
                    break;
                default:
                    task = self.highTasks[indexPath.row];
                    [self.highTasks removeObjectAtIndex:indexPath.row];
                    [self.toDo removeObject:task];
                    [self.all removeObject:task];
                    break;
            }
            
            NSError *error;
            NSData *archiveData = [NSKeyedArchiver archivedDataWithRootObject:self->_all requiringSecureCoding:YES error:&error];
            
            [self.defaults setObject:archiveData forKey:@"tasksArray"];
            
            if(self.toDo.count == 0 ){
                [self.tableView setHidden:YES];
                [self.photo setHidden:NO];
            }else{
                [self.tableView setHidden:NO];
                [self.photo setHidden:YES];
            }
            
            [tableView endUpdates];
            
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:action];
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailsViewController *detailsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"details"];
    Task *task = [Task new];
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
    detailsVC.index = 1;
    [self.navigationController pushViewController:detailsVC animated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length == 0) {
        _isFiltered = false;
        [_search endEditing:YES];
    }
    else {
        _isFiltered = true;
        [_filteredTasks removeAllObjects];
        
        for(Task *task in _all){
            if([task.taskName containsString:searchText]){
                [_filteredTasks addObject:task];
            }
        }
    }
    [self.tableView reloadData];
}

@end
