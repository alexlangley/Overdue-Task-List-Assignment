//
//  AddTaskViewController.m
//  Overdue Task List Assignment
//
//  Created by Alex Langley on 10/8/14.
//  Copyright (c) 2014 Truu Bruu. All rights reserved.
//

#import "AddTaskViewController.h"


@interface AddTaskViewController ()

@end

@implementation AddTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.taskNameTextField.delegate = self;
    self.taskDescriptionTextView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)addTaskButtonTapped:(UIButton *)sender {
    Task *newTask = [self returnNewTaskObject];
    [self.delegate didAddTask:newTask];
}

- (IBAction)addTaskCancelButtonTapped:(UIButton *)sender {
    [self.delegate didCancel];
}

#pragma mark - UITextField delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.taskNameTextField resignFirstResponder];
    return YES;
}

#pragma mark - UITextView delegate

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [self.taskDescriptionTextView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - Helper function

-(Task *)returnNewTaskObject {
    Task *addedTask = [[Task alloc] init];
    
    addedTask.title = self.taskNameTextField.text;
    addedTask.desc = self.taskDescriptionTextView.text;
    addedTask.date = self.addTaskDatePicker.date;
    addedTask.completion = NO;
    
    return addedTask;
}

@end
