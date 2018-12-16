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
        [self setEnableAuxView:NO];
        [self setAnimationStyle:NVExpandInPlace];
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
    
    // Animate the black mask
    [UIView animateWithDuration:0.25 animations:^{[self->blackMask setAlpha:0.3];}];
    
#pragma Message View
    
    // Create the message view
    UIView *messageView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, frameWidth, 0.0)];
    [messageView setBackgroundColor:self.mainBackgroundColor];
    
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
    [titleLabel setFont:[UIFont systemFontOfSize:15.0 weight:UIFontWeightMedium]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel sizeToFit];
    [titleLabel setCenter:CGPointMake(frameWidth/2.0, titleLabel.center.y)];
    [messageView addSubview:titleLabel];
    
    // Add the message label
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(30.0, CGRectGetMaxY(titleLabel.frame)+20.0, frameWidth-2*30.0, 0.0)];
    [messageLabel setText:messageString];
    [messageLabel setNumberOfLines:0];
    [messageLabel setFont:[UIFont systemFontOfSize:13.0 weight:UIFontWeightLight]];
    [messageLabel setTextAlignment:NSTextAlignmentCenter];
    [messageLabel sizeToFit];
    [messageLabel setCenter:CGPointMake(frameWidth/2.0, messageLabel.center.y)];
    [messageView addSubview:messageLabel];
    
    // Adjust messageView height
    CGRect messageViewFrame = messageView.frame;
    messageViewFrame.size.height = CGRectGetMaxY(messageLabel.frame)+30.0;
    [messageView setFrame:messageViewFrame];
    
#pragma Aux View Handle
    
    UIView *auxViewHandle = [[UIView alloc] initWithFrame:CGRectZero];
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
        
        // Adjust messageView origin
        messageViewFrame.origin.y += auxViewHandle.frame.size.height;
        [messageView setFrame:messageViewFrame];
    }
    
#pragma Notification View
    
    // Create the notification view
    notificationView = [[UIView alloc] initWithFrame:CGRectMake(0.0, frameHeight, frameWidth, messageView.frame.size.height+auxViewHandle.frame.size.height)];
    [notificationView setBackgroundColor:[UIColor clearColor]];
    
    // Create round corners
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    CGRect maskLayerRect = CGRectMake(0.0, 0.0, frameWidth, frameHeight);
    [maskLayer setPath:[UIBezierPath bezierPathWithRoundedRect:maskLayerRect byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:(CGSize){8.0, 8.0}].CGPath];
    if (self.enableAuxView && CGColorGetAlpha(self.auxHandleTint.CGColor) != 0.0) [[auxViewHandle layer] setMask:maskLayer];
    else [[messageView layer] setMask:maskLayer];
    
    // Add subviews
    [notificationView addSubview:auxViewHandle];
    [notificationView addSubview:messageView];
    
    // Add swipe up gesture to notoficationView
    UISwipeGestureRecognizer *swipeUpNotificationView = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showNotificationAuxView:)];
    [swipeUpNotificationView setDirection:UISwipeGestureRecognizerDirectionUp];
    [notificationView addGestureRecognizer:swipeUpNotificationView];
    
    // Add view to window
    [keyWindow insertSubview:notificationView aboveSubview:blackMask];

    // Move the notificationView into the view with blackMask
    CGRect notificationViewFrame = notificationView.frame;
    notificationViewFrame.origin.y -= auxViewHandle.frame.size.height+messageView.frame.size.height;
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{[self->notificationView setFrame:notificationViewFrame];}
                     completion:nil];

    // Move the auxViewHandle into the view if animated
    if (self.enableHandleAnimation)
    {
        CGRect auxViewHandleFrame = auxViewHandle.frame;
        auxViewHandleFrame.origin.y -= auxViewHandleFrame.size.height;
        [UIView animateWithDuration:0.25
                              delay:0.35
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{[auxViewHandle setFrame:auxViewHandleFrame];}
                         completion:nil];
    }
}

// Show notification aux view
- (void)showNotificationAuxView:(UISwipeGestureRecognizer *)swipeUpGesture
{
    // Disable touch
    [notificationView setUserInteractionEnabled:NO];
    
    // Remove swipe up gesture recognizer
    [notificationView removeGestureRecognizer:swipeUpGesture];
    
    // Add swipe down gesture
    UISwipeGestureRecognizer *swipeDownNotificationView = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hideNotificationAuxView:)];
    [swipeDownNotificationView setDirection:UISwipeGestureRecognizerDirectionDown];
    [notificationView addGestureRecognizer:swipeDownNotificationView];

    // Find the height for aux view
    float maxItemHeight = 0.0;
    for (UIImage *image in self.auxViewsArray)
    {
        float itemHeight = 0.0;
        if (image.size.width > notificationView.frame.size.width) itemHeight = image.size.height*notificationView.frame.size.width/image.size.width;
        else itemHeight = image.size.height;
        maxItemHeight = MAX(maxItemHeight, itemHeight);
    }
    
    // Add the scroll view
    UIScrollView *auxScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, notificationView.frame.size.width, maxItemHeight)];
    [auxScrollView setDelegate:self];
    [auxScrollView setPagingEnabled:NO];
    [auxScrollView setScrollEnabled:NO];
    [auxScrollView setShowsVerticalScrollIndicator:NO];
    [auxScrollView setShowsHorizontalScrollIndicator:NO];
    [auxScrollView setContentSize:CGSizeMake([self.auxViewsArray count]*notificationView.frame.size.width, maxItemHeight)];

    // Add subviews to auxScrollView
    for (int i = 0; i < [self.auxViewsArray count]; i++)
    {
        UIImageView *itemImageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*notificationView.frame.size.width, 0.0, notificationView.frame.size.width, maxItemHeight)];
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
        pageController = [[UIPageControl alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY(auxScrollView.frame), notificationView.frame.size.width, 30.0)];
        [pageController setNumberOfPages:[self.auxViewsArray count]];
        [pageController setBackgroundColor:self.auxViewTint];
        [pageController setPageIndicatorTintColor:[UIColor clearColor]];
        [pageController setCurrentPageIndicatorTintColor:[UIColor clearColor]];
        [pageController setCurrentPage:0];
    }

    // Calculate the added height
    float addedHeight = maxItemHeight+pageController.frame.size.height;
    
    // Add the auxView and add subviews to it
    auxView = [[UIView alloc] initWithFrame:CGRectMake(0.0, notificationView.frame.size.height, notificationView.frame.size.width, addedHeight)];
    [auxView setBackgroundColor:self.auxViewTint];
    [auxView addSubview:auxScrollView];
    [auxView addSubview:pageController];
    [notificationView addSubview:auxView];

    // Stretch the notificationView and enable touch
    CGRect notificationViewFrame = notificationView.frame;
    notificationViewFrame.size.height += addedHeight;
    notificationViewFrame.origin.y -= addedHeight;
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{[self->notificationView setFrame:notificationViewFrame];}
                     completion:^(BOOL finished){[self->notificationView setUserInteractionEnabled:YES];}];

    // Show pageController
    [UIView animateWithDuration:0.25
                          delay:0.25
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{[self->pageController setPageIndicatorTintColor:[UIColor lightGrayColor]];
                                  [self->pageController setCurrentPageIndicatorTintColor:[UIColor blackColor]];}
                     completion:nil];
}

// Hide notification aux view
- (void)hideNotificationAuxView:(UISwipeGestureRecognizer *)swipeDownGesture
{
    // Disable touch
    [notificationView setUserInteractionEnabled:NO];

    // Remove swipe down gesture recognizer
    [notificationView removeGestureRecognizer:swipeDownGesture];
    
    // Add swipe up gesture
    UISwipeGestureRecognizer *swipeUpNotificationView = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showNotificationAuxView:)];
    [swipeUpNotificationView setDirection:UISwipeGestureRecognizerDirectionUp];
    [notificationView addGestureRecognizer:swipeUpNotificationView];

    // Get the auxView height
    float auxViewHeight = auxView.frame.size.height;
    
    // Shrink the notificationView, remove auxView, and enable touch
    CGRect notificationViewFrame = notificationView.frame;
    notificationViewFrame.size.height -= auxViewHeight;
    notificationViewFrame.origin.y += auxViewHeight;
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{[self->notificationView setFrame:notificationViewFrame];}
                     completion:^(BOOL finished){
                         [self->notificationView setUserInteractionEnabled:YES];
                         [self->auxView removeFromSuperview];
                     }];
}

// Close notification view
- (void)closeNotificationView
{
    // Move the notificationView out of the view and remove it
    CGRect notificationViewFrame = notificationView.frame;
    notificationViewFrame.origin.y += notificationView.frame.size.height;
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{[self->notificationView setFrame:notificationViewFrame];}
                     completion:^(BOOL finished){[self->notificationView removeFromSuperview];}];
    
    // Animate the blackMask and remove it after completion
    [UIView animateWithDuration:0.25
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
