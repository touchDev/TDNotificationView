# TDNotificationView
## A custom notification/alert view for iOS

[![license](https://img.shields.io/github/license/mashape/apistatus.svg)](https://github.com/babaksamareh/TD-DecimalKeyboard/blob/master/LICENSE)
![platform](https://img.shields.io/badge/Platform-iOS-orange.svg)
![language](https://img.shields.io/badge/Language-Objective--C-brightgreen.svg)


## About
*TDNotificationView* is a custom notification and alert view for iOS devices. It is highly customizeable and can be used as an alternative to the native iOS alerting system.

This project is maintained by **touchDev**.

## Installation
Just add `TDNotificationView.h`, `TDNotificationView.m`, and image assets to your project. To add the class to a view controller, make sure class header is added to the view's header file and the instance is locally defined, e.g., if your main view is calles ViewController, add the following lines to `ViewController.h`:

```
#import "TDNotificationView.h"

@interface ViewController : UIViewController
{
    // Notification view instance
    TDNotificationView *tdNotificationView;
}
```
Then, initialize TDNotificationView's instance in `ViewController.m`:
```
- (void)viewDidLoad
{
    [super viewDidLoad];

    // Initialize the notification view
    tdNotificationView = [[TDNotificationView alloc] init];
}
```

## Configuration
TDNotificationView can be configured using the following public properties:

#### -mainBackgroundColor
Type: `UIColor`
Default Value: `whiteColor`
