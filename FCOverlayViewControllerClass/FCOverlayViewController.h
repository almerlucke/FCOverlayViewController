//
//  FCOverlayViewController.h
//
//  Created by Almer Lucke on 10/11/13.
//  Copyright (c) 2013 Farcoding. All rights reserved.
//


#import <Foundation/Foundation.h>


/**
 *  In-between view controller to allow animating the presentation of the actual view controller to be presented. 
 *  This class also makes sure the new window will not be deallocated until the presented view controller is dismissed.
 *  All auto rotation methods are forwarded to the presented view controller to allow the presented view controller
 *  to decide which rotations are allowed
 */
@interface FCOverlayViewController : UIViewController

/**
 *  This method should never be called by any other class then the FCOverlay class.
 *
 *  @param newWindow      the new key and visible window
 *  @param viewController the view controller to be presented
 *  @param animated       animate the presentation or not
 *  @param queued         was queued or not
 *  @param completion     called when the presentation is finished
 *
 *  @return In-between FCOverlayViewController instance
 */
- (instancetype)initWithWindow:(UIWindow *)window
                viewController:(UIViewController *)viewController
                      animated:(BOOL)animated
                        queued:(BOOL)queued
                    completion:(void (^)(void))completion;



- (instancetype)initWithWindow:(UIWindow *)window
                    fromWindow:(UIWindow *)fromWindow
                viewController:(UIViewController *)viewController
                      animated:(BOOL)animated
                        queued:(BOOL)queued
                    completion:(void (^)(void))completion;

@end
