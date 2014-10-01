//
//  FCOverlayViewController.m
//
//  Created by Almer Lucke on 10/11/13.
//  Copyright (c) 2013 Farcoding. All rights reserved.
//


#import "FCOverlayViewController.h"
#import "FCOverlay.h"


// private interface
@interface FCOverlayViewController ()
@property (nonatomic, weak) UIWindow *previousWindow;
@property (nonatomic, strong) UIWindow *currentWindow;
@property (nonatomic, strong) UIViewController *viewControllerToPresent;
@property (nonatomic, copy) void (^completionBlock)();
@property (nonatomic) BOOL showAnimated;
@property (nonatomic) BOOL queued;
@property (nonatomic) BOOL shouldDismissWhenReady;
@end


@implementation FCOverlayViewController

#pragma mark - Initialize, Appearance and Loading

- (instancetype)initWithWindow:(UIWindow *)window
                viewController:(UIViewController *)viewController
                      animated:(BOOL)animated
                        queued:(BOOL)queued
                    completion:(void (^)(void))completion {
    if ((self = [super init])) {
        self.currentWindow = window;
        self.viewControllerToPresent = viewController;
        self.showAnimated = animated;
        self.completionBlock = completion;
        self.queued = queued;
    }
    
    return self;
}

- (instancetype)initWithWindow:(UIWindow *)window
                    fromWindow:(UIWindow *)fromWindow
                viewController:(UIViewController *)viewController
                      animated:(BOOL)animated
                        queued:(BOOL)queued
                    completion:(void (^)(void))completion {
    if ((self = [super init])) {
        self.previousWindow = fromWindow;
        self.currentWindow = window;
        self.viewControllerToPresent = viewController;
        self.showAnimated = animated;
        self.completionBlock = completion;
        self.queued = queued;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
}

// Do the actual presentation from viewDidAppear to make sure we don't get any complaints about
// view transitions in progress etc.
// This is the right way to present any view controller immediately from another view controller
// (viewDidLoad and viewWillAppear are NOT the methods you want to do this from)
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.viewControllerToPresent) {
        // present the view controller
		dispatch_async(dispatch_get_main_queue(), ^{
			[self presentViewController:self.viewControllerToPresent
					animated:self.showAnimated
					completion:^{

				if (self.completionBlock) {
					self.completionBlock();
				}

				if (self.shouldDismissWhenReady) {
					[self dismissViewControllerAnimated:NO completion:nil];
				}

			}];

			// make sure we never present the view controller again (for example after it is dismissed)
			self.viewControllerToPresent = nil;
		});
    }
}


#pragma mark - Status Bar

- (BOOL)prefersStatusBarHidden
{
    UIViewController *viewController = self.viewControllerToPresent;
    
    if (!viewController) {
        viewController = self.presentedViewController;
    }
    
    return [viewController prefersStatusBarHidden];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    UIViewController *viewController = self.viewControllerToPresent;
    
    if (!viewController) {
        viewController = self.presentedViewController;
    }
    
	return [viewController preferredStatusBarStyle];
}


#pragma mark - Auto Rotation

- (BOOL)shouldAutorotate
{
    UIViewController *viewController = self.viewControllerToPresent;
    
    if (!viewController) {
        viewController = self.presentedViewController;
    }
    
    // forward call to presented view controller
    return [viewController shouldAutorotate];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    UIViewController *viewController = self.viewControllerToPresent;
    
    if (!viewController) {
        viewController = self.presentedViewController;
    }
    
    // forward call to presented view controller
    return [viewController shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
}

- (NSUInteger)supportedInterfaceOrientations
{
    UIViewController *viewController = self.viewControllerToPresent;
    
    if (!viewController) {
        viewController = self.presentedViewController;
    }
    
    // forward call to presented view controller
    return [viewController supportedInterfaceOrientations];
}


#pragma mark - Show/Hide Overlay

// Overwrite dismissViewControllerAnimated to be able to close the current window and
// make the next window in line the top window. View controllers that are overlayed should call
// [self.presentingViewController dismissViewControllerAnimated:flag completion:completion] to
// dismiss the overlay controller and corresponding window
- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
	self.shouldDismissWhenReady = YES;

	if(self.presentedViewController && self.presentedViewController.isBeingPresented)
	{
		return;
	}

    [super dismissViewControllerAnimated:flag completion:^{
        UIWindow *keyWindow = nil;
        
        if (self.previousWindow) {
            keyWindow = self.previousWindow;
        } else {
            NSArray *windows = [UIApplication sharedApplication].windows;
            NSEnumerator *reverseEnumerator = [windows reverseObjectEnumerator];
            
            // get current key window
            UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
            
            // if we are the key window, find the next window in the hierarchy that
            // should be made key
            if (self.currentWindow == keyWindow) {
                for (UIWindow *window in reverseEnumerator) {
                    if (window.rootViewController && window.rootViewController != self) {
                        keyWindow = window;
                    }
                    
                    break;
                }
            }
        }
        
        // set window level to normal, this is needed to restore activity for
        // any _UIModalItemHostingWindow that are below us in the window hierarchy
        self.currentWindow.windowLevel = UIWindowLevelNormal;
        
        // restore key window
        [keyWindow makeKeyAndVisible];
        [keyWindow becomeFirstResponder];
        
        // break retain cycle by setting ptr's to nil
        self.currentWindow.rootViewController = nil;
        
        if (self.queued) {
            // dequeue the next queued overlay
            [FCOverlay dequeue];
        }

		self.shouldDismissWhenReady = NO;
        
        // call completion block
        if (completion) completion();
    }];
}



@end
