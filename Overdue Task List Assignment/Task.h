//
//  TaskModel.h
//  Overdue Task List Assignment
//
//  Created by Alex Langley on 10/9/14.
//  Copyright (c) 2014 Truu Bruu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Task : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *desc;
@property (strong, nonatomic) NSDate *date;
@property (nonatomic) BOOL completion;

-(id)initWithData:(NSDictionary *)data;

@end
