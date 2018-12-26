//
//  ViewController.m
//  TDNotificationView
//
//  Created by Babak Samareh on 2018-12-10.
//  Copyright © 2018 Babak Samareh. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

// Show notification 1
- (IBAction)showNotification1:(id)sender
{
    // Load aux view images
    UIImage *view1 = [UIImage imageNamed:@"auxView1"];
    UIImage *view2 = [UIImage imageNamed:@"auxView2"];

    // Show the notification view
    NSString *titleString = @"Invalid Reference";
    NSString *messageString = @"Invalid reference state for the selected material. Please change the reference state in settings menu.";
    tdNotificationView = [[TDNotificationView alloc] init];
    [tdNotificationView setEnableAuxView:YES];
    [tdNotificationView setAuxViewContentMode:UIViewContentModeScaleAspectFit];
    [tdNotificationView setAuxViewsArray:@[view1, view2]];
    [tdNotificationView showNotificationWithTitle:titleString andMessage:messageString];
}

// Show notification 2
- (IBAction)showNotification2:(id)sender
{
    // Load aux view images
    UIImage *view1 = [UIImage imageNamed:@"auxView1"];
    UIImage *view2 = [UIImage imageNamed:@"auxView2"];
    
    // Show the notification view
    NSString *titleString = @"Invalid Reference";
    NSString *messageString = @"Invalid reference state for the selected material. Please change the reference state in settings menu.";
    tdNotificationView = [[TDNotificationView alloc] init];
    [tdNotificationView setEnableAuxView:YES];
    [tdNotificationView setAuxViewContentMode:UIViewContentModeScaleAspectFit];
    [tdNotificationView setEnableHandleAnimation:YES];
    [tdNotificationView setAuxHandleTint:[UIColor clearColor]];
    [tdNotificationView setHandleLineTint:[UIColor whiteColor]];
    [tdNotificationView setAuxViewsArray:@[view1, view2]];
    [tdNotificationView showNotificationWithTitle:titleString andMessage:messageString];
}

// Show alert 1
- (IBAction)showAlert1:(id)sender
{
    // Load aux view images
    UIImage *view1 = [UIImage imageNamed:@"auxView1"];
    UIImage *view2 = [UIImage imageNamed:@"auxView2"];

    // Show the help view
    NSString *titleString = @"Invalid Reference";
    NSString *messageString = @"Invalid reference state for the selected material. Please change the reference state in settings menu.";
    tdNotificationView = [[TDNotificationView alloc] init];
    [tdNotificationView setEnableAuxView:YES];
    [tdNotificationView setAuxViewContentMode:UIViewContentModeScaleAspectFit];
    [tdNotificationView setAuxViewsArray:@[view1, view2]];
    [tdNotificationView showAlertWithTitle:titleString andMessage:messageString];
}

// Show alert 2
- (IBAction)showAlert2:(id)sender
{
    // Load aux view images
    UIImage *view1 = [UIImage imageNamed:@"auxView1"];
    UIImage *view2 = [UIImage imageNamed:@"auxView2"];
    
    // Show the help view
    NSString *titleString = @"Invalid Reference";
    NSString *messageString = @"Invalid reference state for the selected material. Please change the reference state in settings menu.";
    tdNotificationView = [[TDNotificationView alloc] init];
    [tdNotificationView setEnableAuxView:YES];
    [tdNotificationView setAuxViewContentMode:UIViewContentModeScaleAspectFit];
    [tdNotificationView setEnableHandleAnimation:YES];
    [tdNotificationView setAuxHandleTint:[UIColor clearColor]];
    [tdNotificationView setHandleLineTint:[UIColor whiteColor]];
    [tdNotificationView setAuxViewsArray:@[view1, view2]];
    [tdNotificationView showAlertWithTitle:titleString andMessage:messageString];
}

@end
