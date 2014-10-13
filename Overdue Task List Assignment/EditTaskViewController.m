//
//  EditTaskViewController.m
//  Overdue Task List Assignment
//
//  Created by Alex Langley on 10/8/14.
//  Copyright (c) 2014 Truu Bruu. All rights reserved.
//

#import "EditTaskViewController.h"

@interface EditTaskViewController ()

@end

@implementation EditTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.editTaskNameTextField.text = self.task.title;
    self.editTaskDescriptionTextView.text = self.task.desc;
    [self.editTaskDatePicker setDate:self.task.date animated:YES];
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

- (IBAction)saveButtonTapped:(UIBarButtonItem *)sender {
    [self updateTask];
    [self.delegate didUpdateTask];
}

#pragma mark - UITextField delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.editTaskNameTextField resignFirstResponder];
    return YES;
}

#pragma mark - UITextView delegate

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [self.editTaskDescriptionTextView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - Helper Method

-(void)updateTask {
    // update task details in all views
    self.task.title = self.editTaskNameTextField.text;
    self.task.desc = self.editTaskDescriptionTextView.text;
    self.task.date = self.editTaskDatePicker.date;
}

@end
