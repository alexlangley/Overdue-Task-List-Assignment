//
//  ViewController.h
//  Overdue Task List Assignment
//
//  Created by Alex Langley on 10/8/14.
//  Copyright (c) 2014 Truu Bruu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddTaskViewController.h"
#import "DetailTaskViewController.h"

@interface ViewController : UIViewController<AddTaskViewControllerDelegate,UITableViewDataSource,UITableViewDelegate,DetailTaskViewControllerDelegate>

@property (strong, nonatomic) NSMutableArray *taskObjects;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)reorderButtonTapped:(UIBarButtonItem *)sender;
- (IBAction)addTaskButtonTapped:(UIBarButtonItem *)sender;

@end

