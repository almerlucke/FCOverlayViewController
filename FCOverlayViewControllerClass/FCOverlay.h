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
 *  You can also use the queueOverlayWithViewController methods to make sure one overlay at a time is presented.
 *  When the current overlay is dismissed it will dequeue the next one from the queue. This can be used to mimic
 *  alert view behaviour (where the next is presented after the first is dismissed).
 *
 *  An overlay can be dismissed from the presented view controller with
 *  [self.presentingViewController dismissViewControllerAnimated:animated completion:completion] or with a call to
 *  [FCOverlay dismissOverlayAnimated:animated completion:completion]. The FCOverlay class method will find the top
 *  overlay and dismiss it.
 *
 *  For some reason calling [self dismissViewControllerAnimated:animated completion:completion] from the presented
 *  view controller does not work as expected. You would expect that the dismissViewControllerAnimated method of
 *  FCOverlayViewController (it overrides the superclass implementation) is called, but in reality the super method is 
 *  called bypassing the FCOverlayViewController override. I think this is a bug on the side of Apple, but maybe 
 *  I'm doing something wrong?
 *
 *  The two class methods to dismiss the overlay(s) are convenience methods so the overlay(s) can be dismissed from
 *  any part of the application.
 */
@interface FCOverlay : NSObject

/**
 *  Queue an overlay to be presented. If the queue is empty, present it immediately,
 *  otherwise put it in the queue for later presentation. Overlays which are queued
 *  are fetched fifo style from the queue when the currently presented overlay is dismissed
 *
 *  @param controller the view controller to present
 *  @param animated   show animated or not
 *  @param completion completion block called when finished presenting
 */
+ (void)queueOverlayWithViewController:(UIViewController *)controller
                              animated:(BOOL)animated
                            completion:(void (^)())completion;

/**
 *  Queue an overlay to be presented with a specific window level. If the queue is empty, present it immediately,
 *  otherwise put it in the queue for later presentation. Overlays which are queued
 *  are fetched fifo style from the queue when the currently presented overlay is dismissed
 *
 *  @param controller the view controller to present
 *  @param windowLevel the window level for the presented controller
 *  @param animated   show animated or not
 *  @param completion completion block called when finished presenting
 */
+ (void)queueOverlayWithViewController:(UIViewController *)controller
                           windowLevel:(UIWindowLevel)windowLevel
                              animated:(BOOL)animated
                            completion:(void (^)())completion;

/**
 *  Queue an overlay to be presented with a specific window level. If the queue is empty, present it immediately,
 *  otherwise put it in the queue for later presentation. Overlays which are queued
 *  are fetched fifo style from the queue when the currently presented overlay is dismissed
 *
 *  @param controller the view controller to present
 *  @param windowLevel the window level for the presented controller
 *  @param fromWindow the window presented from, this window is made key again after dismissal
 *  @param animated   show animated or not
 *  @param completion completion block called when finished presenting
 */
+ (void)queueOverlayWithViewController:(UIViewController *)controller
                           windowLevel:(UIWindowLevel)windowLevel
                            fromWindow:(UIWindow *)fromWindow
                              animated:(BOOL)animated
                            completion:(void (^)())completion;

/**
 *  Called from FCOverlayViewController when it has been dismissed. This method fetches and 
 *  presents the next overlay in the queue. You should not call this method directly!
 */
+ (void)dequeue;

/**
 *  Present a view controller in a new window (UIWindowLevelNormal)
 *
 *  @param controller the view controller to present
 *  @param animated show animated or not
 *  @param completion completion block called when finished presenting
 */
+ (void)presentOverlayWithViewController:(UIViewController *)controller
                                animated:(BOOL)animated
                              completion:(void (^)())completion;

/**
 *  Present a view controller in a new window with a specific window level
 *
 *  @param controller the view controller to present
 *  @param windowLevel the window level for the presented controller
 *  @param animated show animated or not
 *  @param completion completion block called when finished presenting
 */
+ (void)presentOverlayWithViewController:(UIViewController *)controller
                             windowLevel:(UIWindowLevel)windowLevel
                                animated:(BOOL)animated
                              completion:(void (^)())completion;

/**
 *  Present a view controller in a new window with a specific window level
 *
 *  @param controller the view controller to present
 *  @param windowLevel the window level for the presented controller
 *  @param fromWindow the window where we are presenting from, if set this window is made key again after dismissal
 *  @param animated show animated or not
 *  @param completion completion block called when finished presenting
 */
+ (void)presentOverlayWithViewController:(UIViewController *)controller
                             windowLevel:(UIWindowLevel)windowLevel
                              fromWindow:(UIWindow *)fromWindow
                                animated:(BOOL)animated
                              completion:(void (^)())completion;

/**
 *  Dismiss topmost overlaid view controller, this can also be accomplished by
 *  calling dismissViewControllerAnimated on the presentingViewController of 
 *  the presented overlayed view controller
 *
 *  @param animated dismiss animated or not
 *  @param completion completion block called when finished dismissing
 */
+ (void)dismissOverlayAnimated:(BOOL)animated completion:(void (^)())completion;

/**
 *  Dismiss all overlays immediately
 */
+ (void)dismissAllOverlays;

@end
