//
//  EditTaskViewController.h
//  Overdue Task List Assignment
//
//  Created by Alex Langley on 10/8/14.
//  Copyright (c) 2014 Truu Bruu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"

@protocol EditTaskViewControllerDelegate <NSObject>

-(void)didUpdateTask;

@end

@interface EditTaskViewController : UIViewController<UITextFieldDelegate, UITextViewDelegate>

- (IBAction)saveButtonTapped:(UIBarButtonItem *)sender;

@property (strong, nonatomic) Task *task;
@property (weak, nonatomic) id <EditTaskViewControllerDelegate> delegate;

@property (strong, nonatomic) IBOutlet UITextField *editTaskNameTextField;
@property (strong, nonatomic) IBOutlet UITextView *editTaskDescriptionTextView;
@property (strong, nonatomic) IBOutlet UIDatePicker *editTaskDatePicker;

@end
