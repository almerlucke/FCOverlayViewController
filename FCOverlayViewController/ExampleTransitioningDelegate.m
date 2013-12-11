//
//  ExampleTransitioningDelegate.m
//  FCOverlayViewController
//
//  Created by Almer Lucke on 11/12/13.
//  Copyright (c) 2013 Farcoding. All rights reserved.
//


#import "ExampleTransitioningDelegate.h"
#import "ExampleTransitioning.h"


@implementation ExampleTransitioningDelegate

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                   presentingController:(UIViewController *)presenting
                                                                       sourceController:(UIViewController *)source
{
    ExampleTransitioning *transitioning = [ExampleTransitioning new];
    return transitioning;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    ExampleTransitioning *transitioning = [ExampleTransitioning new];
    transitioning.reverse = YES;
    return transitioning;
}

@end
