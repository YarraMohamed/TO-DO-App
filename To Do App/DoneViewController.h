//
//  DoneViewController.h
//  To Do App
//
//  Created by Yara Mohamed on 23/04/2025.
//

#import <UIKit/UIKit.h>
#import "Task.h"

NS_ASSUME_NONNULL_BEGIN

@interface DoneViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property NSMutableArray<Task *> *lowTasks;
@property NSMutableArray <Task *> *mediumTasks;
@property NSMutableArray <Task *> *highTasks;
@property NSMutableArray <Task *> *all;
@property NSMutableArray<Task *> *done;
@property NSUserDefaults *defaults;
@property BOOL seprated;

@end

NS_ASSUME_NONNULL_END
