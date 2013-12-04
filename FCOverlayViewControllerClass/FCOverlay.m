//
//  FCOverlay.m
//  FCOverlayViewController
//
//  Created by Almer Lucke on 05/12/13.
//  Copyright (c) 2013 Farcoding. All rights reserved.
//


#import "FCOverlay.h"
#import "FCOverlayViewController.h"


@implementation FCOverlay

+ (void)dismissOverlayAnimated:(BOOL)animated completion:(void (^)())completion
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    if ([keyWindow.rootViewController isKindOfClass:[FCOverlayViewController class]]) {
        [keyWindow.rootViewController dismissViewControllerAnimated:animated completion:completion];
    } else {
        if (completion) completion();
    }
}

+ (void)dismissAllOverlays
{
    while (YES) {
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        
        if ([keyWindow.rootViewController isKindOfClass:[FCOverlayViewController class]]) {
            [keyWindow.rootViewController dismissViewControllerAnimated:NO completion:nil];
        } else {
            break;
        }
    }
}

+ (void)presentOverlayWithViewController:(UIViewController *)controller
                                animated:(BOOL)animated
                              completion:(void (^)())completion
{
    [self presentOverlayWithViewController:controller
                               windowLevel:UIWindowLevelNormal
                                  animated:animated
                                completion:completion];
}

+ (void)presentOverlayWithViewController:(UIViewController *)controller
                             windowLevel:(UIWindowLevel)windowLevel
                                animated:(BOOL)animated
                              completion:(void (^)())completion
{
    // set up new window with frame of current window
    UIWindow *oldWindow = [UIApplication sharedApplication].keyWindow;
    CGRect windowFrame = oldWindow.frame;
    UIWindow *newWindow = [[UIWindow alloc] initWithFrame:windowFrame];
    
    // create in-between view controller to present the overlaid view controller
    FCOverlayViewController *overlayController = [[FCOverlayViewController alloc] initWithOldWindow:oldWindow
                                                                                          newWindow:newWindow
                                                                                     viewController:controller
                                                                                           animated:animated
                                                                                         completion:completion];
    
    // set new window properties and make key and visible
    newWindow.backgroundColor = [UIColor clearColor];
    newWindow.rootViewController = overlayController;
    newWindow.windowLevel = windowLevel;
    [newWindow makeKeyAndVisible];
}

@end
