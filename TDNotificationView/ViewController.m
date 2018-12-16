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

    // Initialize the notification view
    notificationView = [[TDNotificationView alloc] init];
}

- (UIImage *)imageFromColor:(UIColor *)color withSize:(CGSize)imageSize
{
    CGRect rect = CGRectMake(0, 0, imageSize.width, imageSize.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

// Show notification 1
- (IBAction)showNotificcation1:(id)sender
{
    UIImage *view1 = [self imageFromColor:[UIColor yellowColor] withSize:CGSizeMake(100, 200)];
    UIImage *view2 = [self imageFromColor:[UIColor orangeColor] withSize:CGSizeMake(150, 150)];
    UIImage *view3 = [self imageFromColor:[UIColor greenColor]  withSize:CGSizeMake(50, 100)];

    // Show the help view
    NSString *titleString = @"Vapor Quality";
    NSString *messageString = @"Quality (x) is the mass fraction of vapor in a liquid/vapor mixture. Quality can be calculated by dividing the mass of the vapor by the total mass of the mixture.";
    [notificationView setEnableAuxView:YES];
//    [notificationView setEnableHandleAnimation:NO];
//    [notificationView setAuxHandleTint:[UIColor clearColor]];
//    [notificationView setHandleLineTint:[UIColor whiteColor]];
    [notificationView setAuxViewsArray:@[view1, view2, view3]];
    [notificationView showNotificationWithTitle:titleString andMessage:messageString];
}

@end
