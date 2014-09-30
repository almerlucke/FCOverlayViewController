//
//  FCOverlay.m
//  FCOverlayViewController
//
//  Created by Almer Lucke on 05/12/13.
//  Copyright (c) 2013 Farcoding. All rights reserved.
//


#import "FCOverlay.h"
#import "FCOverlayViewController.h"


// Private queue entry class
@interface FCOverlayQueueEntry : NSObject
@property (nonatomic, strong) UIViewController *controller;
@property (nonatomic, weak) UIWindow *fromWindow;
@property (nonatomic) BOOL animated;
@property (nonatomic, copy) void (^completion)();
@property (nonatomic) UIWindowLevel windowLevel;
@end

@implementation FCOverlayQueueEntry
@end





@interface FCOverlay ()
{
    // queue for overlays that should be presented but can not because there is already
    // an overlay presented
    NSMutableArray *_overlayQueue;
}
@end


@implementation FCOverlay

#pragma mark - Initialize

- (instancetype)init
{
    if ((self = [super init])) {
        _overlayQueue = [NSMutableArray array];
    }
    
    return self;
}

+ (FCOverlay *)sharedInstance
{
    static dispatch_once_t _onceToken;
    static FCOverlay *_singleton = nil;
    
    dispatch_once(&_onceToken, ^{
        _singleton = [[FCOverlay alloc] init];
    });
    
    return _singleton;
}


#pragma mark - Queue/Dequeue

- (void)emptyQueue
{
    _overlayQueue = [NSMutableArray array];
}

- (void)dequeue
{
    if ([_overlayQueue count] > 0) {
        // remove the previously presented overlay
        [_overlayQueue removeObjectAtIndex:0];
        
        // get next in line
        FCOverlayQueueEntry *entry = [_overlayQueue firstObject];
        if (entry) {
            [[self class] presentOverlayWithViewController:entry.controller
                                               windowLevel:entry.windowLevel
                                                fromWindow:entry.fromWindow
                                                  animated:entry.animated
                                                    queued:YES
                                                completion:entry.completion];
        }
    }
}

+ (void)dequeue
{
    [[self sharedInstance] dequeue];
}

- (void)queueOverlayWithViewController:(UIViewController *)controller
                           windowLevel:(UIWindowLevel)windowLevel
                            fromWindow:(UIWindow *)fromWindow
                              animated:(BOOL)animated
                            completion:(void (^)())completion
{
    FCOverlayQueueEntry *entry = [FCOverlayQueueEntry new];
    entry.controller = controller;
    entry.animated = animated;
    entry.completion = completion;
    entry.windowLevel = windowLevel;
    entry.fromWindow = fromWindow;
    
    if ([_overlayQueue count] == 0) {
        // present immediately
        [[self class] presentOverlayWithViewController:controller
                                           windowLevel:windowLevel
                                            fromWindow:fromWindow
                                              animated:animated
                                                queued:YES
                                            completion:completion];
    }
    
    // add to the end of the queue
    [_overlayQueue addObject:entry];
}

+ (void)queueOverlayWithViewController:(UIViewController *)controller
                              animated:(BOOL)animated
                            completion:(void (^)())completion
{
    [self queueOverlayWithViewController:controller
                             windowLevel:UIWindowLevelNormal
                              fromWindow:nil
                                animated:animated
                              completion:completion];
}

+ (void)queueOverlayWithViewController:(UIViewController *)controller
                           windowLevel:(UIWindowLevel)windowLevel
                              animated:(BOOL)animated
                            completion:(void (^)())completion
{
    [[self sharedInstance] queueOverlayWithViewController:controller
                                              windowLevel:windowLevel
                                               fromWindow:nil
                                                 animated:animated
                                               completion:completion];
}

+ (void)queueOverlayWithViewController:(UIViewController *)controller
                           windowLevel:(UIWindowLevel)windowLevel
                            fromWindow:(UIWindow *)fromWindow
                              animated:(BOOL)animated
                            completion:(void (^)())completion
{
    [[self sharedInstance] queueOverlayWithViewController:controller
                                              windowLevel:windowLevel
                                               fromWindow:fromWindow
                                                 animated:animated
                                               completion:completion];
}


#pragma mark - Present

+ (void)presentOverlayWithViewController:(UIViewController *)controller
                                animated:(BOOL)animated
                              completion:(void (^)())completion
{
    [self presentOverlayWithViewController:controller
                               windowLevel:UIWindowLevelNormal
                                fromWindow:nil
                                  animated:animated
                                    queued:NO
                                completion:completion];
}

+ (void)presentOverlayWithViewController:(UIViewController *)controller
                             windowLevel:(UIWindowLevel)windowLevel
                                animated:(BOOL)animated
                              completion:(void (^)())completion
{
    [self presentOverlayWithViewController:controller
                               windowLevel:windowLevel
                                fromWindow:nil
                                  animated:animated
                                    queued:NO
                                completion:completion];
}

+ (void)presentOverlayWithViewController:(UIViewController *)controller
                             windowLevel:(UIWindowLevel)windowLevel
                              fromWindow:(UIWindow *)fromWindow
                                animated:(BOOL)animated
                              completion:(void (^)())completion
{
    [self presentOverlayWithViewController:controller
                               windowLevel:windowLevel
                                fromWindow:fromWindow
                                  animated:animated
                                    queued:NO
                                completion:completion];
}

+ (void)presentOverlayWithViewController:(UIViewController *)controller
                             windowLevel:(UIWindowLevel)windowLevel
                              fromWindow:(UIWindow *)fromWindow
                                animated:(BOOL)animated
                                  queued:(BOOL)queued
                              completion:(void (^)())completion
{
    // the new window frame is set to mainScreen bounds
    CGRect windowFrame = [UIScreen mainScreen].bounds;
    
    // create a new window
    UIWindow *newWindow = [[UIWindow alloc] initWithFrame:windowFrame];
    
    // create in-between view controller to present the overlaid view controller
    FCOverlayViewController *overlayController = [[FCOverlayViewController alloc] initWithWindow:newWindow
                                                                                      fromWindow:fromWindow
                                                                                  viewController:controller
                                                                                        animated:animated
                                                                                          queued:queued
                                                                                      completion:completion];
    
    // set new window properties and make key and visible
    newWindow.backgroundColor = [UIColor clearColor];
    newWindow.rootViewController = overlayController;
    newWindow.windowLevel = windowLevel;
    [newWindow makeKeyAndVisible];
}

#pragma mark - Dismiss

+ (void)dismissOverlayAnimated:(BOOL)animated completion:(void (^)())completion
{
    NSArray *windows = [UIApplication sharedApplication].windows;
    NSEnumerator *reverseEnumerator = [windows reverseObjectEnumerator];
    BOOL dismissedOverlay = NO;
    
    // dismiss the first overlay we find in the window hierarchy
    // windows are sorted on window level so the last window in the array
    // is the one that is shown on top of all other windows
    for (UIWindow *window in reverseEnumerator) {
        if ([window.rootViewController isKindOfClass:[FCOverlayViewController class]]) {
            [window.rootViewController dismissViewControllerAnimated:animated completion:completion];
            dismissedOverlay = YES;
            break;
        }
    }
    
    if (!dismissedOverlay) {
        if (completion) completion();
    }
}

+ (void)dismissAllOverlays
{
    // first empty the queued overlays
    [[self sharedInstance] emptyQueue];
    
    NSArray *windows = [UIApplication sharedApplication].windows;
    NSEnumerator *reverseEnumerator = [windows reverseObjectEnumerator];
    
    // loop through all active windows and dismiss if they are presented by FCOverlay
    for (UIWindow *window in reverseEnumerator) {
        if ([window.rootViewController isKindOfClass:[FCOverlayViewController class]]) {
            [window.rootViewController dismissViewControllerAnimated:NO completion:nil];
        }
    }
}

@end
