//
//  TDNotificationView.m
//  TDNotificationView
//
//  Created by Babak Samareh on 2018-12-11.
//  Copyright © 2018 Babak Samareh. All rights reserved.
//

#import "TDNotificationView.h"

@implementation TDNotificationView

// Initialization
- (id)init
{
    // Set defaults
    if (self = [super init])
    {
        [self setMainBackgroundColor:[UIColor whiteColor]];
        [self setAuxHandleTint:[UIColor colorWithWhite:0.93 alpha:1.0]];
        [self setHandleLineTint:[UIColor grayColor]];
        [self setAuxViewTint:[UIColor colorWithWhite:0.93 alpha:1.0]];
        [self setCornerRadius:10.0];
        [self setTitleFont:[UIFont systemFontOfSize:16.0 weight:UIFontWeightSemibold]];
        [self setMessageFont:[UIFont systemFontOfSize:14.0 weight:UIFontWeightLight]];
        [self setAnimationOption:UIViewAnimationOptionCurveEaseOut];
        [self setEnableAuxView:NO];
        [self setAnimationStyle:NVExpandAndCenter];
        [self setEnableHandleAnimation:NO];
        [self setAuxViewsArray:nil];
        [self setAuxViewContentMode:UIViewContentModeCenter];
    }
    
    return self;
}

// Show notification
- (void)showNotificationWithTitle:(NSString *)titleString andMessage:(NSString *)messageString
{
    // Get the main app window
    UIView *keyWindow = [UIApplication sharedApplication].keyWindow;
    if (!keyWindow) keyWindow = [[UIApplication sharedApplication].windows objectAtIndex:0];
    
    // Get dimensions
    float frameWidth = keyWindow.frame.size.width;
    float frameHeight = keyWindow.frame.size.height;

#pragma Black Mask
    
    // Create the black mask layer
    blackMask = [[UIView alloc] initWithFrame:keyWindow.bounds];
    [blackMask setBackgroundColor:[UIColor blackColor]];
    [blackMask setAlpha:0.0];
    
    // Add tag gesture to black mask to dismiss the pickerView
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeNotificationView)];
    [blackMask addGestureRecognizer:singleFingerTap];
    
    // Add the black mask to the window
    [keyWindow addSubview:blackMask];
    
#pragma Aux View Handle
    
    if (self.enableAuxView)
    {
        // Add auxViewHandle
        auxViewHandle = [[UIView alloc] initWithFrame:CGRectMake(0.0, self.enableHandleAnimation?30.0:0.0, frameWidth, 30.0)];
        [auxViewHandle setUserInteractionEnabled:YES];
        [auxViewHandle setBackgroundColor:self.auxHandleTint];
        
        // Add the handle
        UIBezierPath *handlePath = [UIBezierPath bezierPath];
        [handlePath moveToPoint:CGPointMake(auxViewHandle.frame.size.width/2.0-13.0, auxViewHandle.frame.size.height/2.0)];
        [handlePath addLineToPoint:CGPointMake(auxViewHandle.frame.size.width/2.0+13.0, auxViewHandle.frame.size.height/2.0)];
        
        CAShapeLayer *handleShapeLayer = [[CAShapeLayer alloc] init];
        [handleShapeLayer setPath:handlePath.CGPath];
        [handleShapeLayer setLineWidth:4.5];
        [handleShapeLayer setLineCap:kCALineCapRound];
        [handleShapeLayer setStrokeColor:self.handleLineTint.CGColor];
        [auxViewHandle.layer addSublayer:handleShapeLayer];
    }

#pragma Message View
    
    // Create the message view
    UIView *messageView = [[UIView alloc] initWithFrame:CGRectMake(0.0, self.enableAuxView?30.0:0.0, frameWidth, 0.0)];
    [messageView setBackgroundColor:self.mainBackgroundColor];
    
    // Adjust round corners
    if (self.enableAuxView && CGColorGetAlpha(self.auxHandleTint.CGColor) == 0.0)
    {
        [messageView setClipsToBounds:YES];
        [[messageView layer] setCornerRadius:self.cornerRadius];
        [[messageView layer] setMaskedCorners:kCALayerMinXMinYCorner|kCALayerMaxXMinYCorner];
    }
    
    // Add the close button
    UIButton *notificationViewClose = [UIButton buttonWithType:UIButtonTypeSystem];
    [notificationViewClose setFrame:CGRectMake(frameWidth-40.0, 0.0, 40.0, 40.0)];
    [notificationViewClose addTarget:self action:@selector(closeNotificationView) forControlEvents:UIControlEventTouchUpInside];
    [notificationViewClose setContentMode:UIViewContentModeCenter];
    [notificationViewClose setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [notificationViewClose setTintColor:[UIColor blackColor]];
    [messageView addSubview:notificationViewClose];
    
    // Add the sign view
    UIImageView *signView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 30.0, 40.0, 40.0)];
    [signView setCenter:CGPointMake(frameWidth/2.0, signView.center.y)];
    [signView setContentMode:UIViewContentModeCenter];
    [signView setImage:[UIImage imageNamed:@"notification"]];
    [messageView addSubview:signView];
    
    // Add the title label
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30.0, CGRectGetMaxY(signView.frame)+20.0, frameWidth-2*30.0, 0.0)];
    [titleLabel setText:titleString];
    [titleLabel setNumberOfLines:0];
    [titleLabel setFont:self.titleFont];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel sizeToFit];
    [titleLabel setCenter:CGPointMake(frameWidth/2.0, titleLabel.center.y)];
    [messageView addSubview:titleLabel];
    
    // Add the message label
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(30.0, CGRectGetMaxY(titleLabel.frame)+20.0, frameWidth-2*30.0, 0.0)];
    [messageLabel setText:messageString];
    [messageLabel setNumberOfLines:0];
    [messageLabel setFont:self.messageFont];
    [messageLabel setTextAlignment:NSTextAlignmentCenter];
    [messageLabel sizeToFit];
    [messageLabel setCenter:CGPointMake(frameWidth/2.0, messageLabel.center.y)];
    [messageView addSubview:messageLabel];
    
    // Adjust messageView height
    CGRect messageViewFrame = messageView.frame;
    messageViewFrame.size.height = CGRectGetMaxY(messageLabel.frame)+30.0;
    [messageView setFrame:messageViewFrame];
    
#pragma Main View
    
    // Create the mainView
    mainView = [[UIView alloc] initWithFrame:CGRectMake(0.0, frameHeight, frameWidth, CGRectGetMaxY(messageView.frame))];
    [mainView setBackgroundColor:[UIColor clearColor]];
    [mainView setClipsToBounds:YES];
    [[mainView layer] setCornerRadius:self.cornerRadius];
    [[mainView layer] setMaskedCorners:kCALayerMinXMinYCorner|kCALayerMaxXMinYCorner];
    
    // Add subviews to mainView
    [mainView addSubview:messageView];
    [mainView insertSubview:auxViewHandle belowSubview:messageView];
    
    // Add swipe down gesture
    UISwipeGestureRecognizer *swipeDownNotificationView = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hideNotificationAuxView:)];
    [swipeDownNotificationView setDirection:UISwipeGestureRecognizerDirectionDown];
    [mainView addGestureRecognizer:swipeDownNotificationView];

    // Add swipe up gesture to mainView
    UISwipeGestureRecognizer *swipeUpNotificationView = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showNotificationAuxView:)];
    [swipeUpNotificationView setDirection:UISwipeGestureRecognizerDirectionUp];
    [mainView addGestureRecognizer:swipeUpNotificationView];
    
    // Add view to window
    [keyWindow insertSubview:mainView aboveSubview:blackMask];
    
#pragma Animate Views

    // Animate the black mask
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:self.animationOption
                     animations:^{[self->blackMask setAlpha:0.3];}
                     completion:nil];

    // Move the mainView into the view
    CGRect mainViewFrame = mainView.frame;
    mainViewFrame.origin.y -= mainView.frame.size.height;
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:self.animationOption
                     animations:^{[self->mainView setFrame:mainViewFrame];}
                     completion:nil];

    // Move the auxViewHandle into the view if animated
    if (self.enableHandleAnimation)
    {
        CGRect auxViewHandleFrame = auxViewHandle.frame;
        auxViewHandleFrame.origin.y -= auxViewHandleFrame.size.height;
        [UIView animateWithDuration:0.25
                              delay:0.40
                            options:self.animationOption
                         animations:^{[self->auxViewHandle setFrame:auxViewHandleFrame];}
                         completion:nil];
    }
}

// Show notification aux view
- (void)showNotificationAuxView:(UISwipeGestureRecognizer *)swipeUpGesture
{
    // Do nothing if auxView already open
    if (auxView) return;

    // Disable touch
    [mainView setUserInteractionEnabled:NO];
    
    // Find the height for aux view
    float maxItemHeight = 0.0;
    for (UIImage *image in self.auxViewsArray)
    {
        float itemHeight = 0.0;
        if (image.size.width > mainView.frame.size.width) itemHeight = image.size.height*mainView.frame.size.width/image.size.width;
        else itemHeight = image.size.height;
        maxItemHeight = MAX(maxItemHeight, itemHeight);
    }
    
    // Add the scroll view
    UIScrollView *auxScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, mainView.frame.size.width, maxItemHeight)];
    [auxScrollView setDelegate:self];
    [auxScrollView setPagingEnabled:NO];
    [auxScrollView setScrollEnabled:NO];
    [auxScrollView setShowsVerticalScrollIndicator:NO];
    [auxScrollView setShowsHorizontalScrollIndicator:NO];
    [auxScrollView setContentSize:CGSizeMake([self.auxViewsArray count]*mainView.frame.size.width, maxItemHeight)];

    // Add subviews to auxScrollView
    for (int i = 0; i < [self.auxViewsArray count]; i++)
    {
        UIImageView *itemImageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*mainView.frame.size.width, 0.0, mainView.frame.size.width, maxItemHeight)];
        [itemImageView setContentMode:self.auxViewContentMode];
        [itemImageView setImage:[self.auxViewsArray objectAtIndex:i]];
        [auxScrollView addSubview:itemImageView];
    }

    // Add a page indicator if more than 1 item is added
    if ([self.auxViewsArray count] > 1)
    {
        // Enable paging
        [auxScrollView setPagingEnabled:YES];
        [auxScrollView setScrollEnabled:YES];

        // Add the page controller
        pageController = [[UIPageControl alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY(auxScrollView.frame), mainView.frame.size.width, 50.0)];
        [pageController setNumberOfPages:[self.auxViewsArray count]];
        [pageController setBackgroundColor:self.auxViewTint];
        [pageController setPageIndicatorTintColor:[UIColor clearColor]];
        [pageController setCurrentPageIndicatorTintColor:[UIColor clearColor]];
        [pageController setCurrentPage:0];
    }

    // Calculate the added height
    float addedHeight = maxItemHeight+pageController.frame.size.height;
    
    // Add the auxView and add subviews to it
    auxView = [[UIView alloc] initWithFrame:CGRectMake(0.0, mainView.frame.size.height, mainView.frame.size.width, addedHeight)];
    [auxView setBackgroundColor:self.auxViewTint];
    [auxView addSubview:auxScrollView];
    [auxView addSubview:pageController];
    [mainView addSubview:auxView];

    // Stretch the mainView and enable touch
    CGRect mainViewFrame = mainView.frame;
    mainViewFrame.size.height += addedHeight;
    mainViewFrame.origin.y -= addedHeight;
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:self.animationOption
                     animations:^{[self->mainView setFrame:mainViewFrame];}
                     completion:^(BOOL finished){[self->mainView setUserInteractionEnabled:YES];}];

    // Show pageController
    [UIView animateWithDuration:0.25
                          delay:0.25
                        options:self.animationOption
                     animations:^{[self->pageController setPageIndicatorTintColor:[UIColor lightGrayColor]];
                                  [self->pageController setCurrentPageIndicatorTintColor:[UIColor blackColor]];}
                     completion:nil];
}

// Hide notification aux view
- (void)hideNotificationAuxView:(UISwipeGestureRecognizer *)swipeDownGesture
{
    // Do nothing if auxView already close
    if (!auxView) return;

    // Disable touch
    [mainView setUserInteractionEnabled:NO];

    // Get the auxView height
    float auxViewHeight = auxView.frame.size.height;
    
    // Shrink the mainView, remove auxView, and enable touch
    CGRect mainViewFrame = mainView.frame;
    mainViewFrame.size.height -= auxViewHeight;
    mainViewFrame.origin.y += auxViewHeight;
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:self.animationOption
                     animations:^{[self->mainView setFrame:mainViewFrame];}
                     completion:^(BOOL finished){
                         [self->mainView setUserInteractionEnabled:YES];
                         [self->auxView removeFromSuperview];
                         self->auxView = nil;}];
}

// Close notification view
- (void)closeNotificationView
{
    // Move the mainView out of the view and remove it
    CGRect mainViewFrame = mainView.frame;
    mainViewFrame.origin.y += mainView.frame.size.height;
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:self.animationOption
                     animations:^{[self->mainView setFrame:mainViewFrame];}
                     completion:^(BOOL finished){[self->mainView removeFromSuperview];}];
    
    // Animate the blackMask and remove it after completion
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:self.animationOption
                     animations:^{[self->blackMask setAlpha:0.0];}
                     completion:^(BOOL finished){[self->blackMask removeFromSuperview];}];
}

// Show alert
- (void)showAlertWithTitle:(NSString *)titleString andMessage:(NSString *)messageString
{
    // Get the main app window
    UIView *keyWindow = [UIApplication sharedApplication].keyWindow;
    if (!keyWindow) keyWindow = [[UIApplication sharedApplication].windows objectAtIndex:0];
    
    // Get dimensions
    float frameWidth = keyWindow.frame.size.width-50.0;
    
#pragma Black Mask
    
    // Create the black mask layer
    blackMask = [[UIView alloc] initWithFrame:keyWindow.bounds];
    [blackMask setBackgroundColor:[UIColor blackColor]];
    [blackMask setAlpha:0.0];
    
    // Add tag gesture to black mask to dismiss the pickerView
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeAlertView)];
    [blackMask addGestureRecognizer:singleFingerTap];
    
    // Add the black mask to the window
    [keyWindow addSubview:blackMask];
    
#pragma Message View
    
    // Create the message view
    UIView *messageView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, frameWidth, 0.0)];
    [messageView setBackgroundColor:self.mainBackgroundColor];
    
    // Add the close button
    UIButton *alertViewClose = [UIButton buttonWithType:UIButtonTypeSystem];
    [alertViewClose setFrame:CGRectMake(frameWidth-40.0, 0.0, 40.0, 40.0)];
    [alertViewClose addTarget:self action:@selector(closeAlertView) forControlEvents:UIControlEventTouchUpInside];
    [alertViewClose setContentMode:UIViewContentModeCenter];
    [alertViewClose setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [alertViewClose setTintColor:[UIColor blackColor]];
    [messageView addSubview:alertViewClose];
    
    // Add the sign view
    UIImageView *signView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 30.0, 40.0, 40.0)];
    [signView setCenter:CGPointMake(frameWidth/2.0, signView.center.y)];
    [signView setContentMode:UIViewContentModeCenter];
    [signView setImage:[UIImage imageNamed:@"warning"]];
    [messageView addSubview:signView];
    
    // Add the title label
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30.0, CGRectGetMaxY(signView.frame)+20.0, frameWidth-2*30.0, 0.0)];
    [titleLabel setText:titleString];
    [titleLabel setNumberOfLines:0];
    [titleLabel setFont:self.titleFont];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel sizeToFit];
    [titleLabel setCenter:CGPointMake(frameWidth/2.0, titleLabel.center.y)];
    [messageView addSubview:titleLabel];
    
    // Add the message label
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(30.0, CGRectGetMaxY(titleLabel.frame)+20.0, frameWidth-2*30.0, 0.0)];
    [messageLabel setText:messageString];
    [messageLabel setNumberOfLines:0];
    [messageLabel setFont:self.messageFont];
    [messageLabel setTextAlignment:NSTextAlignmentCenter];
    [messageLabel sizeToFit];
    [messageLabel setCenter:CGPointMake(frameWidth/2.0, messageLabel.center.y)];
    [messageView addSubview:messageLabel];
    
    // Adjust messageView height
    CGRect messageViewFrame = messageView.frame;
    messageViewFrame.size.height = CGRectGetMaxY(messageLabel.frame)+30.0;
    [messageView setFrame:messageViewFrame];
    
#pragma Main View
    
    // Create the mainView
    mainView = [[UIView alloc] initWithFrame:messageView.bounds];
    [mainView setCenter:CGPointMake(blackMask.frame.size.width/2.0, blackMask.frame.size.height/2.0)];
    [mainView setBackgroundColor:[UIColor clearColor]];
    [mainView setAlpha:0.0];
    [mainView setClipsToBounds:YES];
    [[mainView layer] setCornerRadius:self.cornerRadius];
    
    // Adjust round corners
    if (self.enableAuxView && CGColorGetAlpha(self.auxHandleTint.CGColor) != 0.0)
        [[mainView layer] setMaskedCorners:kCALayerMinXMinYCorner|kCALayerMaxXMinYCorner];

    // Add message view to main view
    [mainView addSubview:messageView];
    
    // Add swipe down gesture to mainView
    UISwipeGestureRecognizer *swipeDownMainView = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showAlertAuxView:)];
    [swipeDownMainView setDirection:UISwipeGestureRecognizerDirectionDown];
    [mainView addGestureRecognizer:swipeDownMainView];

    // Add swipe up gesture to mainView
    UISwipeGestureRecognizer *swipeUpMainView = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hideAlertAuxView:)];
    [swipeUpMainView setDirection:UISwipeGestureRecognizerDirectionUp];
    [mainView addGestureRecognizer:swipeUpMainView];
    
    // Add view to window
    [keyWindow insertSubview:mainView aboveSubview:blackMask];
    
#pragma Aux View Handle
    
    if (self.enableAuxView)
    {
        // Add auxViewHandle
        float auxY = self.enableHandleAnimation ? CGRectGetMaxY(mainView.frame)-30.0 : CGRectGetMaxY(mainView.frame);
        auxViewHandle = [[UIView alloc] initWithFrame:CGRectMake(mainView.frame.origin.x, auxY, frameWidth, 30.0)];
        [auxViewHandle setUserInteractionEnabled:YES];
        [auxViewHandle setBackgroundColor:self.auxHandleTint];
        [auxViewHandle setAlpha:0.0];
        [auxViewHandle setClipsToBounds:YES];
        [[auxViewHandle layer] setCornerRadius:self.cornerRadius];
        [[auxViewHandle layer] setMaskedCorners:kCALayerMinXMaxYCorner|kCALayerMaxXMaxYCorner];

        // Add the handle
        UIBezierPath *handlePath = [UIBezierPath bezierPath];
        [handlePath moveToPoint:CGPointMake(auxViewHandle.frame.size.width/2.0-13.0, auxViewHandle.frame.size.height/2.0)];
        [handlePath addLineToPoint:CGPointMake(auxViewHandle.frame.size.width/2.0+13.0, auxViewHandle.frame.size.height/2.0)];
        
        CAShapeLayer *handleShapeLayer = [[CAShapeLayer alloc] init];
        [handleShapeLayer setPath:handlePath.CGPath];
        [handleShapeLayer setLineWidth:4.5];
        [handleShapeLayer setLineCap:kCALineCapRound];
        [handleShapeLayer setStrokeColor:self.handleLineTint.CGColor];
        [auxViewHandle.layer addSublayer:handleShapeLayer];
        
        // Add swipe down gesture to auxViewHandle
        UISwipeGestureRecognizer *swipeDownAuxViewHandle = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showAlertAuxView:)];
        [swipeDownAuxViewHandle setDirection:UISwipeGestureRecognizerDirectionDown];
        [auxViewHandle addGestureRecognizer:swipeDownAuxViewHandle];

        // Add swipe up gesture to auxViewHandle
        UISwipeGestureRecognizer *swipeUpAuxViewHandle = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hideAlertAuxView:)];
        [swipeUpAuxViewHandle setDirection:UISwipeGestureRecognizerDirectionUp];
        [auxViewHandle addGestureRecognizer:swipeUpAuxViewHandle];

        // Add view to window
        [keyWindow insertSubview:auxViewHandle belowSubview:mainView];
    }
    
#pragma Animate Views
    
    // Animate the black mask
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:self.animationOption
                     animations:^{[self->blackMask setAlpha:0.3];}
                     completion:nil];
    
    // Move the mainView and auxViewHandle into the view
    if (self.enableHandleAnimation)
    {
        // Move the mainView into the view and set alpha for auxViewHandle
        [UIView animateWithDuration:0.25
                              delay:0.0
                            options:self.animationOption
                         animations:^{[self->mainView setAlpha:1.0];}
                         completion:^(BOOL finished){[self->auxViewHandle setAlpha:1.0];}];
        
        // Move the auxViewHandle into the view
        CGRect auxViewHandleFrame = auxViewHandle.frame;
        auxViewHandleFrame.origin.y += auxViewHandleFrame.size.height;
        [UIView animateWithDuration:0.25
                              delay:0.40
                            options:self.animationOption
                         animations:^{[self->auxViewHandle setFrame:auxViewHandleFrame];}
                         completion:nil];
    }
    
    else
    {
        // Move the mainView and auxViewHandle into the view
        [UIView animateWithDuration:0.25
                              delay:0.0
                            options:self.animationOption
                         animations:^{[self->mainView setAlpha:1.0]; [self->auxViewHandle setAlpha:1.0];}
                         completion:nil];
    }
}

// Show alert aux view
- (void)showAlertAuxView:(UISwipeGestureRecognizer *)swipeDownGesture
{
    // Do nothing if auxView already open
    if (auxView) return;
    
    // Disable touch
    [mainView setUserInteractionEnabled:NO];
    [auxViewHandle setUserInteractionEnabled:NO];
    
    // Find the height for aux view
    float maxItemHeight = 0.0;
    for (UIImage *image in self.auxViewsArray)
    {
        float itemHeight = 0.0;
        if (image.size.width > mainView.frame.size.width) itemHeight = image.size.height*mainView.frame.size.width/image.size.width;
        else itemHeight = image.size.height;
        maxItemHeight = MAX(maxItemHeight, itemHeight);
    }
    
    // Add a page indicator if more than 1 item is added
    if ([self.auxViewsArray count] > 1)
    {
        // Add the page controller
        pageController = [[UIPageControl alloc] initWithFrame:CGRectMake(0.0, 0.0, mainView.frame.size.width, 30.0)];
        [pageController setNumberOfPages:[self.auxViewsArray count]];
        [pageController setBackgroundColor:self.auxViewTint];
        [pageController setPageIndicatorTintColor:[UIColor clearColor]];
        [pageController setCurrentPageIndicatorTintColor:[UIColor clearColor]];
        [pageController setCurrentPage:0];
    }
    
    // Add the scroll view
    UIScrollView *auxScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, pageController.frame.size.height, mainView.frame.size.width, maxItemHeight)];
    [auxScrollView setDelegate:self];
    [auxScrollView setPagingEnabled:([self.auxViewsArray count] > 1 ? YES : NO)];
    [auxScrollView setScrollEnabled:([self.auxViewsArray count] > 1 ? YES : NO)];
    [auxScrollView setShowsVerticalScrollIndicator:NO];
    [auxScrollView setShowsHorizontalScrollIndicator:NO];
    [auxScrollView setContentSize:CGSizeMake([self.auxViewsArray count]*mainView.frame.size.width, maxItemHeight)];
    
    // Add subviews to auxScrollView
    for (int i = 0; i < [self.auxViewsArray count]; i++)
    {
        UIImageView *itemImageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*mainView.frame.size.width, 0.0, mainView.frame.size.width, maxItemHeight)];
        [itemImageView setContentMode:self.auxViewContentMode];
        [itemImageView setImage:[self.auxViewsArray objectAtIndex:i]];
        [auxScrollView addSubview:itemImageView];
    }
    
    // Calculate the added height
    float addedHeight = maxItemHeight+pageController.frame.size.height;
    
    // Add the auxView and add subviews to it
    auxView = [[UIView alloc] initWithFrame:CGRectMake(0.0, mainView.frame.size.height, mainView.frame.size.width, addedHeight)];
    [auxView setBackgroundColor:self.auxViewTint];
    [auxView addSubview:auxScrollView];
    [auxView addSubview:pageController];
    [mainView addSubview:auxView];
    
    // Stretch the mainView and enable touch
    CGRect mainViewFrame = mainView.frame;
    mainViewFrame.size.height += addedHeight;
    if (self.animationStyle == NVExpandAndCenter) mainViewFrame.origin.y -= addedHeight/2.0;
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:self.animationOption
                     animations:^{[self->mainView setFrame:mainViewFrame];}
                     completion:^(BOOL finished){[self->mainView setUserInteractionEnabled:YES];}];
    
    // Move the auxViewHandle and enable touch
    CGRect auxViewHandleFrame = auxViewHandle.frame;
    auxViewHandleFrame.origin.y += addedHeight;
    if (self.animationStyle == NVExpandAndCenter) auxViewHandleFrame.origin.y -= addedHeight/2.0;
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:self.animationOption
                     animations:^{[self->auxViewHandle setFrame:auxViewHandleFrame];}
                     completion:^(BOOL finished){[self->auxViewHandle setUserInteractionEnabled:YES];}];

    // Show pageController
    [UIView animateWithDuration:0.25
                          delay:0.25
                        options:self.animationOption
                     animations:^{
                         [self->pageController setPageIndicatorTintColor:[UIColor lightGrayColor]];
                         [self->pageController setCurrentPageIndicatorTintColor:[UIColor blackColor]];}
                     completion:nil];
}

// Hide alert aux view
- (void)hideAlertAuxView:(UISwipeGestureRecognizer *)swipeUpGesture
{
    // Do nothing if auxView already close
    if (!auxView) return;

    // Disable touch
    [mainView setUserInteractionEnabled:NO];
    [auxViewHandle setUserInteractionEnabled:NO];

    // Get the auxView height
    float auxViewHeight = auxView.frame.size.height;
    
    // Shrink the mainView, remove auxView, and enable touch
    CGRect mainViewFrame = mainView.frame;
    mainViewFrame.size.height -= auxViewHeight;
    if (self.animationStyle == NVExpandAndCenter) mainViewFrame.origin.y += auxViewHeight/2.0;
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:self.animationOption
                     animations:^{[self->mainView setFrame:mainViewFrame];}
                     completion:^(BOOL finished){
                         [self->mainView setUserInteractionEnabled:YES];
                         [self->auxView removeFromSuperview];
                         self->auxView = nil;}];
    
    // Move the auxViewHandle and enable touch
    CGRect auxViewHandleFrame = auxViewHandle.frame;
    auxViewHandleFrame.origin.y -= auxViewHeight;
    if (self.animationStyle == NVExpandAndCenter) auxViewHandleFrame.origin.y += auxViewHeight/2.0;
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:self.animationOption
                     animations:^{[self->auxViewHandle setFrame:auxViewHandleFrame];}
                     completion:^(BOOL finished){[self->auxViewHandle setUserInteractionEnabled:YES];}];
}

// Close alert view
- (void)closeAlertView
{
    // Move the mainView out of the view and remove it
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:self.animationOption
                     animations:^{[self->mainView setAlpha:0.0];}
                     completion:^(BOOL finished){[self->mainView removeFromSuperview];}];

    // Move the auxViewHandle out of the view and remove it
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:self.animationOption
                     animations:^{[self->auxViewHandle setAlpha:0.0];}
                     completion:^(BOOL finished){[self->auxViewHandle removeFromSuperview];}];
    
    // Animate the blackMask and remove it after completion
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:self.animationOption
                     animations:^{[self->blackMask setAlpha:0.0];}
                     completion:^(BOOL finished){[self->blackMask removeFromSuperview];}];
}

// Detect scrollView movements
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Update the page controller
    CGFloat width = scrollView.bounds.size.width;
    NSInteger page = (NSInteger)floor((scrollView.contentOffset.x*2.0+width)/(width*2.0));
    [pageController setCurrentPage:page];
}

@end
