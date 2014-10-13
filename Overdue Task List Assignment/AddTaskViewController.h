//
//  AddTaskViewController.h
//  Overdue Task List Assignment
//
//  Created by Alex Langley on 10/8/14.
//  Copyright (c) 2014 Truu Bruu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"

@protocol AddTaskViewControllerDelegate <NSObject>

-(void)didCancel;
-(void)didAddTask:(Task *)task;

@end

@interface AddTaskViewController : UIViewController <UITextViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) id <AddTaskViewControllerDelegate> delegate;

@property (strong, nonatomic) IBOutlet UITextField *taskNameTextField;
@property (strong, nonatomic) IBOutlet UITextView *taskDescriptionTextView;
@property (strong, nonatomic) IBOutlet UIDatePicker *addTaskDatePicker;

- (IBAction)addTaskButtonTapped:(UIButton *)sender;
- (IBAction)addTaskCancelButtonTapped:(UIButton *)sender;


@end
