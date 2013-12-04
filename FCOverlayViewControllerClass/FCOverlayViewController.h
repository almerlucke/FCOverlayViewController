//
//  FCOverlayViewController.h
//
//  Created by Almer Lucke on 10/11/13.
//  Copyright (c) 2013 Farcoding. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Use the presentOverlayWithViewController class method to present a view controller in a new window
 *  on top of everything else. The window level is set to normal so the status bar is not covered.
 *
 *  The overlay can be dismissed from the presented view controller with 
 *  [self.presentingViewController dismissViewControllerAnimated:animated completion:completion] OR with a call to
 *  [FCOverlayViewController dismissOverlayAnimated:animated completion:completion]. 
 *
 *  The two class methods to dismiss the overlay(s) are convenience methods so the overlay(s) can be dismissed from
 *  any part of the application.
 *
 *  All auto rotation methods are forwarded to the presented view controller to allow the presented view controller
 *  to decide which rotations are allowed
 */

@interface FCOverlayViewController : UIViewController

/**
 *  Present a view controller in a new window, use FCOverlayViewController as in between root view controller
 *  to be able to present the given view controller in an animated way.
 *
 *  @param controller
 *  @param animated
 *  @param completion
 */
+ (void)presentOverlayWithViewController:(UIViewController *)controller
                                animated:(BOOL)animated
                              completion:(void (^)())completion;

/**
 *  Dismiss topmost overlay view controller plus it's window, this can also be accomplished by
 *  calling dismissViewControllerAnimated on the presentingViewController of the presented overlayed view controller.
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
