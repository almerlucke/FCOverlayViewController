//
//  ExampleTransitioning.m
//  FCOverlayViewController
//
//  Created by Almer Lucke on 11/12/13.
//  Copyright (c) 2013 Farcoding. All rights reserved.
//


#import "ExampleTransitioning.h"


@implementation ExampleTransitioning

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *container = [transitionContext containerView];
    
    if (self.reverse) {
        [container insertSubview:toViewController.view belowSubview:fromViewController.view];
    } else {
        toViewController.view.transform = CGAffineTransformMakeScale(0, 0);
        [container addSubview:toViewController.view];
    }
    
    [UIView animateKeyframesWithDuration:0.3 delay:0 options:0 animations:^{
        if (self.reverse) {
            fromViewController.view.transform = CGAffineTransformMakeScale(0, 0);
        } else {
            toViewController.view.transform = CGAffineTransformIdentity;
        }
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:finished];
    }];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3;
}

@end
