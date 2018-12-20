# TDNotificationView
## A custom notification/alert view for iOS

[![license](https://img.shields.io/github/license/mashape/apistatus.svg)](https://github.com/babaksamareh/TD-DecimalKeyboard/blob/master/LICENSE)
![platform](https://img.shields.io/badge/Platform-iOS-orange.svg)
![language](https://img.shields.io/badge/Language-Objective--C-brightgreen.svg)

## About
*TDNotificationView* is a custom notification and alert view for iOS devices. It is highly customizeable and can be used as an alternative to the native iOS alerting system.

This project is maintained by **touchDev**.

## Installation
Just add `TDNotificationView.h`, `TDNotificationView.m`, and image assets to your project. To add the class to a view controller, make sure class header is added to the view's header file and the instance is locally defined, e.g., if your main view is called ViewController, add the following lines to `ViewController.h`:

``` objective-c
#import "TDNotificationView.h"

@interface ViewController : UIViewController
{
    // Notification view instance
    TDNotificationView *tdNotificationView;
}
```
Then, initialize TDNotificationView's instance in `ViewController.m`:
``` objective-c
- (void)viewDidLoad
{
    [super viewDidLoad];

    // Initialize the notification view
    tdNotificationView = [[TDNotificationView alloc] init];
}
```

## View Hierarchy

## Usage
TDNotificationView can be presented in two forms: *Notification* or *Alert*.

### Notification
Once TDNotificationView is initialized, notification view can be presented by using the `showNotificationWithTitle` method. In `ViewController.m` add the following line:
``` Objective-c
[tdNotificationView showNotificationWithTitle:titleString andMessage:messageString];
```
with `(NSString *)titleString` being the title and `(NSString *)messageString` being the message to be shown. 

### Alert
Alerts can be presented in a similar fashion. In `ViewController.m` add the following line:
``` Objective-c
[tdNotificationView showAlertWithTitle:titleString andMessage:messageString];
```
with `(NSString *)titleString` being the title and `(NSString *)messageString` being the message to be shown. 

## Configuration
TDNotificationView can be configured using the following public properties.<br>
*+Note: Configuration properties must be set before presenting the view.*

### -mainBackgroundColor
![type](https://img.shields.io/badge/type-UIColor-lightgrey.svg) ![default](https://img.shields.io/badge/default-whiteColor-green.svg)

### -auxHandleTint
![type](https://img.shields.io/badge/type-UIColor-lightgrey.svg) ![default](https://img.shields.io/badge/default-90%25%20whiteColor-green.svg)

### -handleLineTint
![type](https://img.shields.io/badge/type-UIColor-lightgrey.svg) ![default](https://img.shields.io/badge/default-greyColor-green.svg)

### -auxViewTint
![type](https://img.shields.io/badge/type-UIColor-lightgrey.svg) ![default](https://img.shields.io/badge/default-90%25%20whiteColor-green.svg)

### -titleFont
![type](https://img.shields.io/badge/type-UIFont-lightgrey.svg) ![default](https://img.shields.io/badge/default-Medium%20system%20font%2015pt-green.svg)

### -messageFont
![type](https://img.shields.io/badge/type-UIFont-lightgrey.svg) ![default](https://img.shields.io/badge/default-Light%20system%20font%2013pt-green.svg)

### -animationOption
![type](https://img.shields.io/badge/type-UIViewAnimationOptions-lightgrey.svg) ![default](https://img.shields.io/badge/default-UIViewAnimationOptionCurveEaseOut-green.svg)

### -enableAuxView
![type](https://img.shields.io/badge/type-BOOL-lightgrey.svg) ![default](https://img.shields.io/badge/default-NO-green.svg)

### -animationStyle
![type](https://img.shields.io/badge/type-NVAnimationStyle-lightgrey.svg) ![default](https://img.shields.io/badge/default-NVExpandAndCenter-green.svg)

### -enableHandleAnimation
![type](https://img.shields.io/badge/type-BOOL-lightgrey.svg) ![default](https://img.shields.io/badge/default-NO-green.svg)

### -auxViewsArray
![type](https://img.shields.io/badge/type-NSArray-lightgrey.svg) ![default](https://img.shields.io/badge/default-nil-green.svg)

### -auxViewContentMode
![type](https://img.shields.io/badge/type-UIViewContentMode-lightgrey.svg) ![default](https://img.shields.io/badge/default-UIViewContentModeCenter-green.svg)

## Follow us for the latest updates<br>
<a href="https://github.com/touchDev" >
<img src="https://img.shields.io/badge/touch-Dev-orange.svg?style=for-the-badge"></a>
