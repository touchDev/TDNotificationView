//
//  TDNotificationView.h
//  TDNotificationView
//
//  Created by Babak Samareh on 2018-12-11.
//  Copyright © 2018 Babak Samareh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

// Aux view animation style
typedef NS_ENUM(NSInteger, NVAnimationStyle)
{
    NVExpandInPlace,
    NVExpandAndCenter
};

@interface TDNotificationView : NSObject <UIScrollViewDelegate>
{
    UIView                  *blackMask;
    UIView                  *mainView;
    UIView                  *auxView;
    UIView                  *auxViewHandle;
    UIPageControl           *pageController;
}

// Public properties
@property (nonatomic)       UIColor                 *mainBackgroundColor;   // default: whiteColor
@property (nonatomic)       UIColor                 *auxHandleTint;         // default: 90% whiteColor
@property (nonatomic)       UIColor                 *handleLineTint;        // default: grayColor
@property (nonatomic)       UIColor                 *auxViewTint;           // default: 90% whiteColor
@property (nonatomic)       CGFloat                 cornerRadius;           // default: 10.0
@property (nonatomic)       UIFont                  *titleFont;             // default: Medium system font 15pt
@property (nonatomic)       UIFont                  *messageFont;           // default: Light system font 13pt
@property (nonatomic)       UIViewAnimationOptions  animationOption;        // default: UIViewAnimationOptionCurveEaseOut
@property (nonatomic)       BOOL                    enableAuxView;          // default: NO
@property (nonatomic)       NVAnimationStyle        animationStyle;         // default: NVExpandAndCenter | (Only for alert view)
@property (nonatomic)       BOOL                    enableHandleAnimation;  // default: NO
@property (nonatomic)       NSArray                 *auxViewsArray;         // default: nil
@property (nonatomic)       UIViewContentMode       auxViewContentMode;     // default: UIViewContentModeCenter

// Public methods
- (void)showNotificationWithTitle:(NSString *)titleString andMessage:(NSString *)messageString;
- (void)showAlertWithTitle:(NSString *)titleString andMessage:(NSString *)messageString;

@end

// Notification Layout
//
// App Key Window
// +------------------------------------+
// |                                    |
// |                                    |
// |  Main View                         |
// |  +------------------------------+  |
// |  | Aux Handle View              |  |
// |  +------------------------------+  |
// |  | Message View                 |  |
// |  |                              |  |
// |  +------------------------------+  |
// |  | Aux View                     |  |
// |  |                              |  |
// |--+------------------------------+--|

// Alert Layout
//
// App Key Window
// +------------------------------------+
// |                                    |
// |  Main View                         |
// |  +------------------------------+  |
// |  | Message View                 |  |
// |  |                              |  |
// |  +------------------------------+  |
// |  | Aux View                     |  |
// |  |                              |  |
// |  +------------------------------+  |
// |                                    |
// |  +------------------------------+  |
// |  | Aux Handle View              |  |
// |  +------------------------------+  |
// |                                    |
// +------------------------------------+
