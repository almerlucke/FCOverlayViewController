//
//  FCOverlay.h
//  FCOverlayViewController
//
//  Created by Almer Lucke on 05/12/13.
//  Copyright (c) 2013 Farcoding. All rights reserved.
//


#import <Foundation/Foundation.h>

/**
 *  Use one of the presentOverlayWithViewController methods to present a view controller in a new window
 *  outside the current view controller chain. The window level can be set, default is UIWindowLevelNormal.
 *
 *  A single overlay can be dismissed from the presented view controller with
 *  [self.presentingViewController dismissViewControllerAnimated:animated completion:completion] or with a call to
 *  [FCOverlayViewController dismissOverlayAnimated:animated completion:completion].
 *
 *  The two class methods to dismiss the overlay(s) are convenience methods so the overlay(s) can be dismissed from
 *  any part of the application.
 */
@interface FCOverlay : NSObject

/**
 *  Present a view controller in a new window (UIWindowLevelNormal)
 *
 *  @param controller
 *  @param animated
 *  @param completion
 */
+ (void)presentOverlayWithViewController:(UIViewController *)controller
                                animated:(BOOL)animated
                              completion:(void (^)())completion;

/**
 *  Present a view controller in a new window with a specific window level
 *
 *  @param controller
 *  @param windowLevel
 *  @param animated
 *  @param completion
 */
+ (void)presentOverlayWithViewController:(UIViewController *)controller
                             windowLevel:(UIWindowLevel)windowLevel
                                animated:(BOOL)animated
                              completion:(void (^)())completion;

/**
 *  Dismiss topmost overlaid view controller, this can also be accomplished by
 *  calling dismissViewControllerAnimated on the presentingViewController of 
 *  the presented overlayed view controller
 *
 *  @param animated
 *  @param completion
 */
+ (void)dismissOverlayAnimated:(BOOL)animated completion:(void (^)())completion;

/**
 *  Dismiss all overlays immediately
 */
+ (void)dismissAllOverlays;

@end
