//
//  FCOverlayViewController.h
//
//  Created by Almer Lucke on 10/11/13.
//  Copyright (c) 2013 Farcoding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FCOverlayViewController : UIViewController

/**
 *  Present a view controller in a new window, use FCOverlayViewController as in between root view controller
 *  to be able to present the given view controller in an animated way
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
 *  calling dismissViewControllerAnimated on the presentingViewController of the presented overlayed view controller
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
