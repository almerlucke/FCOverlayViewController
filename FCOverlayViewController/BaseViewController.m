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


@interface BaseViewController ()
@end

@implementation BaseViewController

- (IBAction)showOverlay:(id)sender
{
    ExampleViewController *exampleController = [[ExampleViewController alloc] init];
    
    [FCOverlay presentOverlayWithViewController:exampleController
                                    windowLevel:UIWindowLevelNormal
                                       animated:YES
                                     completion:nil];
}

- (IBAction)showAlert:(id)sender
{
    AlertViewController *alertController = [[AlertViewController alloc] init];
    
    alertController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [FCOverlay presentOverlayWithViewController:alertController
                                    windowLevel:UIWindowLevelAlert
                                       animated:NO
                                     completion:nil];
}

@end
