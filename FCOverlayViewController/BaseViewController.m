//
//  BaseViewController.m
//  FCOverlayViewController
//
//  Created by Almer Lucke on 10/11/13.
//  Copyright (c) 2013 Farcoding. All rights reserved.
//


#import "BaseViewController.h"
#import "FCOverlay.h"
#import "ExampleViewController.h"
#import "AlertViewController.h"
#import "ExampleTransitioningDelegate.h"


@interface BaseViewController ()
@property (nonatomic, strong) ExampleTransitioningDelegate *transitioningDelegate;
@end


@implementation BaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.transitioningDelegate = [ExampleTransitioningDelegate new];
}

- (IBAction)showOverlay:(id)sender
{
    ExampleViewController *exampleController = [[ExampleViewController alloc] init];
    
    exampleController.transitioningDelegate = self.transitioningDelegate;
    
    [FCOverlay presentOverlayWithViewController:exampleController
                                    windowLevel:UIWindowLevelNormal
                                       animated:YES
                                     completion:nil];
}

- (IBAction)showAlert:(id)sender
{
    AlertViewController *alertController = [[AlertViewController alloc] init];
    
    alertController.alertTitleString = @"This is a custom alert";
    alertController.alertMessageString = @"It is presented with FCOverlay and it is great!";
    alertController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [FCOverlay presentOverlayWithViewController:alertController
                                    windowLevel:UIWindowLevelAlert
                                       animated:NO
                                     completion:nil];
}

- (IBAction)showQueuedAlerts:(id)sender
{
    AlertViewController *alertController = [[AlertViewController alloc] init];
    
    alertController.alertTitleString = @"This is the first queued alert";
    alertController.alertMessageString = @"After this alert will follow a new alert, alertception style!";
    alertController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
     // queue the first alert
    [FCOverlay queueOverlayWithViewController:alertController
                                  windowLevel:UIWindowLevelAlert
                                     animated:NO
                                   completion:nil];
    
    // queue the second alert
    alertController = [[AlertViewController alloc] init];
    
    alertController.alertTitleString = @"This is the second queued alert";
    alertController.alertMessageString = @"After this alert there will be no more alerts in the queue!";
    alertController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [FCOverlay queueOverlayWithViewController:alertController
                                  windowLevel:UIWindowLevelAlert
                                     animated:NO
                                   completion:nil];
}

@end
