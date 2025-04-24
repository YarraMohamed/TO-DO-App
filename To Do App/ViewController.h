//
//  ViewController.h
//  To Do App
//
//  Created by Yara Mohamed on 23/04/2025.
//

#import <UIKit/UIKit.h>
#import "Task.h"

@interface ViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property NSMutableArray<Task *> *lowTasks;
@property NSMutableArray <Task *> *mediumTasks;
@property NSMutableArray <Task *> *highTasks;
@property NSMutableArray <Task *> *toDo;
@property NSMutableArray <Task *> *all;
@property NSMutableArray<Task *> *filteredTasks;
@property NSUserDefaults *defaults;
@property BOOL isFiltered;


@end

