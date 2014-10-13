//
//  ViewController.m
//  Overdue Task List Assignment
//
//  Created by Alex Langley on 10/8/14.
//  Copyright (c) 2014 Truu Bruu. All rights reserved.
//

#import "ViewController.h"
#import "Task.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - Lazy Instantiation of Properties

-(NSMutableArray *)taskObjects {
    if (!_taskObjects)  {
        _taskObjects = [[NSMutableArray alloc] init];
    }
    return _taskObjects;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSArray *tasksArray = [[NSUserDefaults standardUserDefaults] arrayForKey:ADDED_TASK_OBJECTS_KEY];
    
    for (NSDictionary *dictionary in tasksArray) {
        Task *task = [self taskObjectForDictionary:dictionary];
        [self.taskObjects addObject:task];
    }
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView DataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    Task *task = self.taskObjects[indexPath.row];
    
    cell.textLabel.text = task.title;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *stringFromDate = [formatter stringFromDate:task.date];
    cell.detailTextLabel.text = stringFromDate;
    
    if (task.completion) {
        cell.backgroundColor = [UIColor greenColor];
    } else {
        BOOL isOverDue = [self isDateGreaterThanDate:[NSDate date] and:task.date];
        if (isOverDue) {
            cell.backgroundColor = [UIColor redColor];
        } else {
            cell.backgroundColor = [UIColor yellowColor];
        }
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ([self.taskObjects count]);
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark - UITableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // toggle task completion status
    
    Task *thisTask = self.taskObjects[indexPath.row];
    [self toggleCompletionOfTask:thisTask forIndexPath:indexPath];
    
    [self.tableView reloadData];
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"toDetailTaskVCSegue" sender:indexPath];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // delete the task from persistence data
        [self deleteTaskAtIndexPath:indexPath];

        // now taskObjects needs to be updated because the number of tasks has changed
        [self.taskObjects removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    Task *taskObject = [self.taskObjects objectAtIndex:sourceIndexPath.row]; // moving this one
    [self.taskObjects removeObjectAtIndex:sourceIndexPath.row];
    [self.taskObjects insertObject:taskObject atIndex:destinationIndexPath.row];
    
    [self saveTasks]; // persist in new order
}

#pragma mark - Button methods

- (IBAction)reorderButtonTapped:(UIBarButtonItem *)sender {
    if (self.tableView.editing == YES) {
        [self.tableView setEditing:NO animated:YES];
    } else {
        [self.tableView setEditing:YES animated:YES];
    }
}

- (IBAction)addTaskButtonTapped:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:@"toAddTaskVCSegue" sender:sender];
}

#pragma mark - Segues

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.destinationViewController isKindOfClass:[AddTaskViewController class]]) {
        AddTaskViewController *addTaskVC = segue.destinationViewController;
        addTaskVC.delegate = self;
    } else if ([segue.destinationViewController isKindOfClass:[DetailTaskViewController class]]) {
        DetailTaskViewController *detailTaskVC = segue.destinationViewController;
        NSIndexPath *path = sender;
        Task *task = self.taskObjects[path.row];
        detailTaskVC.task = task;
        detailTaskVC.delegate = self;
    }
}

#pragma mark - AddTaskViewController Delegate

-(void)didCancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)didAddTask:(Task *)task {
    [self.taskObjects addObject:task];
    
    // Do we already have any tasks stored?  If so, get a copy.
    NSMutableArray *existingTasks = [[[NSUserDefaults standardUserDefaults] arrayForKey:ADDED_TASK_OBJECTS_KEY] mutableCopy];
    
    // If we didn't already have any...
    if (!existingTasks) {
        existingTasks = [[NSMutableArray alloc] init];
    }
    
    [existingTasks addObject:[self taskObjectAsPropertyList:task]]; //convert and add
    
    // Clobber with new set
    [[NSUserDefaults standardUserDefaults] setObject:existingTasks forKey:ADDED_TASK_OBJECTS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
        
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.tableView reloadData];
}

#pragma mark - DetailTaskViewController Delegate

-(void)updateTask {
    [self saveTasks];
    [self.tableView reloadData];
}

#pragma mark - Helper Methods

// convert task object to property list
-(NSDictionary *)taskObjectAsPropertyList:(Task *)taskObject {
    NSDictionary *dictionary = @{TASK_TITLE:taskObject.title, TASK_DESCRIPTION:taskObject.desc, TASK_DATE:taskObject.date, TASK_COMPLETION:@(taskObject.completion)}; // BOOL must be converted to object for the dictionary;
    
    return dictionary;
}

-(Task *)taskObjectForDictionary:(NSDictionary *)dictionary {
    Task *task = [[Task alloc] initWithData:dictionary];;
    
    return task;
}

-(BOOL) isDateGreaterThanDate:(NSDate *)date and:(NSDate *)date2 {
    int interval1 = [date timeIntervalSince1970];
    int interval2 = [date2 timeIntervalSince1970 ];
    
    if (interval1 > interval2) {
        return YES;
    } else {
        return NO;
    }
}

-(void)toggleCompletionOfTask:(Task *)task forIndexPath:(NSIndexPath *)indexPath {
    // find particular task and get its details
    // remove particular task from NSUserDefaults
    // toggle completion status
    // add back to NSUserDefaults
    
    NSArray *tasksArray = [[NSUserDefaults standardUserDefaults] arrayForKey:ADDED_TASK_OBJECTS_KEY];
    
    NSMutableArray *mutableTasksArray = [[[NSMutableArray alloc] initWithArray:tasksArray] mutableCopy];
    
    [mutableTasksArray removeObjectAtIndex:indexPath.row];
    
    if (task.completion) {
        task.completion = NO;
    } else {
        task.completion = YES;
    }
    
    [mutableTasksArray insertObject:[self taskObjectAsPropertyList:task] atIndex:indexPath.row];
    
    [[NSUserDefaults standardUserDefaults] setObject:mutableTasksArray forKey:ADDED_TASK_OBJECTS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)deleteTaskAtIndexPath:(NSIndexPath *)indexPath {

    NSArray *tasksArray = [[NSUserDefaults standardUserDefaults] arrayForKey:ADDED_TASK_OBJECTS_KEY];
    
    NSMutableArray *mutableTasksArray = [[[NSMutableArray alloc] initWithArray:tasksArray] mutableCopy];
    
    [mutableTasksArray removeObjectAtIndex:indexPath.row];

    [[NSUserDefaults standardUserDefaults] setObject:mutableTasksArray forKey:ADDED_TASK_OBJECTS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)saveTasks {
    NSMutableArray *taskObjectsAsPropertyLists = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.taskObjects.count; i++) {
        // convert each task object to a property lists (NSObjects) then add to array that will be persisted
        [taskObjectsAsPropertyLists addObject:[self taskObjectAsPropertyList:self.taskObjects[i]]];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:taskObjectsAsPropertyLists forKey:ADDED_TASK_OBJECTS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
