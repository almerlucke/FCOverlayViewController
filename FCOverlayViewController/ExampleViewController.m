//
//  ShowMeViewController.m
//  WindowLevelPopup
//
//  Created by Almer Lucke on 10/11/13.
//  Copyright (c) 2013 Farcoding. All rights reserved.
//

#import "ExampleViewController.h"
#import "FCOverlayViewController.h"

@interface ExampleViewController ()
@property (nonatomic, strong) UIButton *dismissButton;
@property (nonatomic, strong) UIButton *createNewButton;
@property (nonatomic, strong) UIButton *hideOneButton;
@property (nonatomic, strong) UIButton *hideAllButton;
@end

@implementation ExampleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
	
    self.dismissButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.dismissButton setTitle:@"dismiss" forState:UIControlStateNormal];
    [self.dismissButton addTarget:self action:@selector(hideMe) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.dismissButton];
    
    self.createNewButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.createNewButton setTitle:@"create new" forState:UIControlStateNormal];
    [self.createNewButton addTarget:self action:@selector(createNew) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.createNewButton];
    
    self.hideOneButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.hideOneButton setTitle:@"hide one" forState:UIControlStateNormal];
    [self.hideOneButton addTarget:self action:@selector(hideOne) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.hideOneButton];
    
    self.hideAllButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.hideAllButton setTitle:@"hide all" forState:UIControlStateNormal];
    [self.hideAllButton addTarget:self action:@selector(hideAll) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.hideAllButton];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGSize size = self.view.bounds.size;
    CGRect frame;
    
    frame.size = CGSizeMake(100, 30);
    frame.origin.x = floor((size.width - frame.size.width) / 2);
    frame.origin.y = floor((size.height - frame.size.height) / 2) - 80;
    self.dismissButton.frame = frame;
    
    frame.size = CGSizeMake(100, 30);
    frame.origin.x = floor((size.width - frame.size.width) / 2);
    frame.origin.y = floor((size.height - frame.size.height) / 2) - 40;
    self.createNewButton.frame = frame;
    
    frame.size = CGSizeMake(100, 30);
    frame.origin.x = floor((size.width - frame.size.width) / 2);
    frame.origin.y = floor((size.height - frame.size.height) / 2) + 10;
    self.hideOneButton.frame = frame;
    
    frame.size = CGSizeMake(100, 30);
    frame.origin.x = floor((size.width - frame.size.width) / 2);
    frame.origin.y = floor((size.height - frame.size.height) / 2) + 40;
    self.hideAllButton.frame = frame;
}

- (BOOL)shouldAutorotate
{
    // forward call to presented view controller
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
//    return UIInterfaceOrientationIsPortrait(toInterfaceOrientation);
    
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
//    UIInterfaceOrientationMask mask = UIInterfaceOrientationMaskPortrait;
    UIInterfaceOrientationMask mask = UIInterfaceOrientationMaskAll;
    
    return mask;
}

- (void)hideMe
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)hideOne
{
    [FCOverlayViewController dismissOverlayAnimated:YES completion:nil];
}

- (void)hideAll
{
    [FCOverlayViewController dismissAllOverlays];
}

- (void)createNew
{
    ExampleViewController *showController = [[ExampleViewController alloc] init];
    
    [FCOverlayViewController presentOverlayWithViewController:showController
                                                  windowLevel:UIWindowLevelAlert
                                                     animated:YES
                                                   completion:nil];
}

@end
