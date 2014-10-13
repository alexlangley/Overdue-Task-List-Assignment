//
//  TaskModel.m
//  Overdue Task List Assignment
//
//  Created by Alex Langley on 10/9/14.
//  Copyright (c) 2014 Truu Bruu. All rights reserved.
//

#import "Task.h"

@implementation Task

-(id)init {
    self = [self initWithData:nil];
    return self;
}

-(id)initWithData:(NSDictionary *)data  {
    self = [super init];
    
    if (self) {
        self.title = data[TASK_TITLE];
        self.desc = data[TASK_DESCRIPTION];
        self.date = data[TASK_DATE];
        self.completion = [data[TASK_COMPLETION] boolValue];  // dictionary would have NSNumber, need to convert
    }

    return self;
}
@end
