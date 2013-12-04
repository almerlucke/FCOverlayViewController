//
//  FCOverlayViewController.m
//
//  Created by Almer Lucke on 10/11/13.
//  Copyright (c) 2013 Farcoding. All rights reserved.
//

#import "FCOverlayViewController.h"


@interface FCOverlayViewController ()
@property (nonatomic, strong) UIWindow *oldWindow;
@property (nonatomic, strong) UIWindow *currentWindow;
@property (nonatomic, strong) UIViewController *viewControllerToPresent;
@property (nonatomic) BOOL showAnimated;
@property (nonatomic, copy) void (^completionBlock)();
@end


@implementation FCOverlayViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.viewControllerToPresent) {
        // present the view controller
        [self presentViewController:self.viewControllerToPresent
                           animated:self.showAnimated
                         completion:self.completionBlock];
        
        // make sure we never present the view controller again (for example after it is dismissed)
        self.viewControllerToPresent = nil;
    }
}


#pragma mark - Auto Rotation

- (BOOL)shouldAutorotate
{
    // forward call to presented view controller
    return [self.presentedViewController shouldAutorotate];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    // forward call to presented view controller
    return [self.presentedViewController shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
}

- (NSUInteger)supportedInterfaceOrientations
{
    // forward call to presented view controller
    return [self.presentedViewController supportedInterfaceOrientations];
}


#pragma mark - Show/Hide Overlay

+ (void)dismissOverlayAnimated:(BOOL)animated completion:(void (^)())completion
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    if ([keyWindow.rootViewController isKindOfClass:[self class]]) {
        [keyWindow.rootViewController dismissViewControllerAnimated:animated completion:completion];
    } else {
        if (completion) completion();
    }
}

+ (void)dismissAllOverlays
{
    while (YES) {
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
        if ([keyWindow.rootViewController isKindOfClass:[self class]]) {
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
    FCOverlayViewController *overlayController = [[FCOverlayViewController alloc] init];
    
    // set up new window with frame of current window
    UIWindow *currentWindow = [UIApplication sharedApplication].keyWindow;
    CGRect windowFrame = currentWindow.frame;
    UIWindow *newWindow = [[UIWindow alloc] initWithFrame:windowFrame];
    
    // keep a pointer to the old window to be able to make it the key window again
    // keep a pointer to the new window to make sure it is not deallocated immediately
    overlayController.currentWindow = newWindow;
    overlayController.oldWindow = currentWindow;
    overlayController.showAnimated = animated;
    overlayController.viewControllerToPresent = controller;
    overlayController.completionBlock = completion;
    
    // set up new window
    newWindow.backgroundColor = [UIColor clearColor];
    newWindow.rootViewController = overlayController;
    newWindow.windowLevel = windowLevel;
    [newWindow makeKeyAndVisible];
}

/**
 *  Overwrite dismissViewControllerAnimated to be able to close the current window and
 *  restore the old window. View controllers that are overlayed should call
 *  [self.presentingViewController dismissViewControllerAnimated:flag completion:completion] to
 *  dismiss the overlay controller and corresponding window
 *
 *  @param flag
 *  @param completion
 */
- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    [super dismissViewControllerAnimated:flag completion:^{
        // restore old window
        [self.oldWindow makeKeyAndVisible];
        
        // break retain cycle by setting ptr's to nil
        self.oldWindow = nil;
        self.currentWindow.rootViewController = nil;
        
        // call completion block
        if (completion) completion();
    }];
}

@end
