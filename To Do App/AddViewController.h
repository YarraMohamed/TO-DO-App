//
//  AddViewController.h
//  To Do App
//
//  Created by Yara Mohamed on 23/04/2025.
//

#import <UIKit/UIKit.h>
#import "Task.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddViewController : UIViewController
@property NSUserDefaults *defaults;
@property NSMutableArray<Task *> *tasksArray;

@end

NS_ASSUME_NONNULL_END
