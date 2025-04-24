//
//  DetailsViewController.h
//  To Do App
//
//  Created by Yara Mohamed on 23/04/2025.
//

#import <UIKit/UIKit.h>
#import "Task.h"
NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController
@property Task *task;
@property NSUserDefaults *defaults;
@property NSMutableArray<Task *> *tasksArray;
@property int index;

@end

NS_ASSUME_NONNULL_END
