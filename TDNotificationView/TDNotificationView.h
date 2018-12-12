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

// Aux view handle style
typedef NS_ENUM(NSInteger, NVHandleStyle)
{
    NVHandleStyleLine,
    NVHandleStyleBox
};

@interface NotificationView : NSObject <UIScrollViewDelegate>
{
    UIWindow                *window;
    UIView                  *blackMask;
    UIView                  *notificationView;
    UIView                  *alertView;
    UIView                  *auxViewHandle;
    UIPageControl           *pageController;
}

// Public properties
@property(nonatomic)        BOOL                    enableAuxView;          // default: NO
@property(nonatomic)        NVAnimationStyle        animationStyle;         // default: NVExpandInPlace | (Only for alert view)
@property(nonatomic)        NVHandleStyle           handleStyle;            // default: NVHandleStyleBox
@property(nonatomic)        NSArray                 *auxViewsArray;         // default: nil
@property(nonatomic)        UIViewContentMode       auxViewContentMode;     // default: UIViewContentModeCenter

// Public methods
- (void)showNotificationWithTitle:(NSString *)titleString andMessage:(NSString *)messageString;
- (void)showAlertWithTitle:(NSString *)titleString andMessage:(NSString *)messageString;

@end
