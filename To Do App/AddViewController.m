//
//  AddViewController.m
//  To Do App
//
//  Created by Yara Mohamed on 23/04/2025.
//

#import <UserNotifications/UserNotifications.h>
#import "AddViewController.h"
#import "Task.h"
@interface AddViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UISegmentedControl *priority;
@property (weak, nonatomic) IBOutlet UIDatePicker *Date;
@property (weak, nonatomic) IBOutlet UISwitch *switchView;

@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_Date setMinimumDate: [NSDate date]];
    _textView.layer.borderWidth = 0.5;
    _textView.layer.borderColor = UIColor.lightGrayColor.CGColor;

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
    if(_tasksArray == nil){
        _tasksArray = [NSMutableArray new];
    }
}

- (IBAction)addAction:(id)sender {
    Task *task = [Task new];
    [task setTaskName:_name.text];
    [task setDesc:_textView.text];
    [task setPriority:_priority.selectedSegmentIndex];
    [task setStatus:0];
    [task setDate:_Date.date];
    
    if(_name.text.length !=0){
        [_tasksArray addObject:task];
        
        NSError *error;
        NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:_tasksArray requiringSecureCoding:YES error:&error];
        
        [_defaults setObject:archivedData forKey:@"tasksArray"];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Success" message:@"Task is added successfully" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
        [alert addAction:confirm];
        [self presentViewController:alert animated:YES completion:nil];
        
        if (self.switchView.isOn) {
            UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
            [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound)
                                  completionHandler:^(BOOL granted, NSError * _Nullable error) {
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self scheduleNotification:self.Date.date:self.name.text];
                    });
                } else {
                    NSLog(@"Notification permission not granted.");
                }
            }];
        }

        
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Failure" message:@"Please enter valid data" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:confirm];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}

- (IBAction)SwitchChanged:(id)sender {
    if (self.switchView.isOn) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound)
                              completionHandler:^(BOOL granted, NSError * _Nullable error) {}];
    }
}


- (void)scheduleNotification:(NSDate *)date :(NSString *)TaskTitle {
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"Task Reminder";
    content.body = TaskTitle;
    content.sound = [UNNotificationSound defaultSound];

    NSTimeInterval timeInterval = [date timeIntervalSinceNow];
    if (timeInterval <= 0) {
        return;
    }

    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:timeInterval repeats:NO];

    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:[NSUUID UUID].UUIDString content:content trigger:trigger];

    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center addNotificationRequest:request withCompletionHandler:nil];
}



@end
