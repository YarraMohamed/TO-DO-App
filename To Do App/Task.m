//
//  Task.m
//  To Do App
//
//  Created by Yara Mohamed on 23/04/2025.
//

#import "Task.h"

@implementation Task

- (void)encodeWithCoder:(nonnull NSCoder *)coder { 
    [coder encodeObject:_taskName forKey:@"taskName"];
    [coder encodeObject:_desc forKey:@"desc"];
    [coder encodeInt:_priority forKey:@"priority"];
    [coder encodeInt:_status forKey:@"status"];
    [coder encodeObject:_date forKey:@"date"];
    
}

- (id)initWithCoder:(nonnull NSCoder *)coder {
    self = [super init];
    if(self){
        _taskName = [coder decodeObjectForKey:@"taskName"];
        _desc = [coder decodeObjectForKey:@"desc"];
        _priority = [coder decodeIntForKey:@"priority"];
        _status = [coder decodeIntForKey:@"status"];
        _date = [coder decodeObjectForKey:@"date"];
    }
    return self;
}

+ (BOOL)supportsSecureCoding{
    return YES;
}

@end
