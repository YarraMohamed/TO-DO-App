//
//  DetailsViewController.m
//  To Do App
//
//  Created by Yara Mohamed on 23/04/2025.
//

#import "DetailsViewController.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UISegmentedControl *priority;
@property (weak, nonatomic) IBOutlet UISegmentedControl *status;
@property (weak, nonatomic) IBOutlet UIDatePicker *date;
@property (weak, nonatomic) IBOutlet UIButton *edit;


@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _textView.layer.borderWidth = 0.5;
    _textView.layer.borderColor = UIColor.lightGrayColor.CGColor;
    
    _name.text = _task.taskName;
    _textView.text = _task.desc;
    _priority.selectedSegmentIndex = _task.priority;
    _status.selectedSegmentIndex = _task.status;
    _date.date = _task.date;
    
    _defaults = [NSUserDefaults standardUserDefaults];
    NSError *error;
    NSData *savedData = [_defaults objectForKey:@"tasksArray"];
    NSSet *set = [NSSet setWithArray:@[
        [NSMutableArray class],
        [NSString class],
        [NSDate class],
        [Task class],
    ]];
    _tasksArray = [NSKeyedUnarchiver unarchivedObjectOfClasses:set fromData:savedData error:&error];
    [_date setMinimumDate:_task.date];
    if(_index == 2){
        [_status setEnabled:NO forSegmentAtIndex:0];
    }
    if(_index == 3){
        [_priority setEnabled:NO];
        [_status setEnabled:NO];
        [_date setEnabled:NO];
        [_edit setEnabled:NO];
        [_name setUserInteractionEnabled:NO];
        [_textView setUserInteractionEnabled:NO];
    }
}

- (IBAction)edit:(id)sender {
    int index = 0;
    Task *newTask = [Task new];
    for(int i=0;i<_tasksArray.count;i++){
        if(_tasksArray[i].taskName == _task.taskName
           && _tasksArray[i].date == _task.date && _tasksArray[i].priority == _task.priority){
            index = i;
        }
    }
    newTask.taskName = _name.text;
    newTask.desc = _textView.text;
    newTask.priority = _priority.selectedSegmentIndex;
    newTask.status = _status.selectedSegmentIndex;
    newTask.date = _date.date;
    
    [_tasksArray replaceObjectAtIndex:index withObject:newTask];
    
    NSError *error;
    NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:_tasksArray requiringSecureCoding:YES error:&error];
    
    [_defaults setObject:archivedData forKey:@"tasksArray"];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Confirmation" message:@"Item updated successfully" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}


@end
