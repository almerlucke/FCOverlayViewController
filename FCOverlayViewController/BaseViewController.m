//
//  BaseViewController.m
//  FCOverlayViewController
//
//  Created by Almer Lucke on 10/11/13.
//  Copyright (c) 2013 Farcoding. All rights reserved.
//

#import "BaseViewController.h"
#import "FCOverlayViewController.h"
#import "ExampleViewController.h"

@interface BaseViewController ()
@end

@implementation BaseViewController

- (IBAction)showOverlay:(id)sender
{
    ExampleViewController *exampleController = [[ExampleViewController alloc] init];
    
    [FCOverlayViewController presentOverlayWithViewController:exampleController
                                                     animated:YES
                                                   completion:nil];
}

@end
