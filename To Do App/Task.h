//
//  Task.h
//  To Do App
//
//  Created by Yara Mohamed on 23/04/2025.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Task : NSObject <NSCoding,NSSecureCoding>
@property NSString *taskName;
@property NSString *desc;
@property int priority ;
@property int status;
@property NSDate *date;


@end

NS_ASSUME_NONNULL_END
