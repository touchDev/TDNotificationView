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
    UIView                  *notificationView;
    UIView                  *alertView;
    UIView                  *auxView;
    UIPageControl           *pageController;
}

// Public properties
@property (nonatomic)       UIColor                 *mainBackgroundColor;   // default: whiteColor
@property (nonatomic)       UIColor                 *auxHandleTint;         // default: 90% whiteColor
@property (nonatomic)       UIColor                 *handleLineTint;        // default: grayColor
@property (nonatomic)       UIColor                 *auxViewTint;           // default: 90% whiteColor
@property (nonatomic)       BOOL                    enableAuxView;          // default: NO
@property (nonatomic)       NVAnimationStyle        animationStyle;         // default: NVExpandInPlace | (Only for alert view)
@property (nonatomic)       BOOL                    enableHandleAnimation;  // default: NO
@property (nonatomic)       NSArray                 *auxViewsArray;         // default: nil
@property (nonatomic)       UIViewContentMode       auxViewContentMode;     // default: UIViewContentModeCenter

// Public methods
- (void)showNotificationWithTitle:(NSString *)titleString andMessage:(NSString *)messageString;
//- (void)showAlertWithTitle:(NSString *)titleString andMessage:(NSString *)messageString;

@end

// Notification Layout
//
// +------------------------------------+
// |  Notification View                 |
// |  +------------------------------+  |
// |  | Aux Handle View              |  |
// |  +------------------------------+  |
// |  | Message View                 |  |
// |  |                              |  |
// |  +------------------------------+  |
// |  | Aux View                     |  |
// |  |                              |  |
// |  +------------------------------+  |
// +------------------------------------+
