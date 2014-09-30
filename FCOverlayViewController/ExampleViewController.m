//
//  ShowMeViewController.m
//  WindowLevelPopup
//
//  Created by Almer Lucke on 10/11/13.
//  Copyright (c) 2013 Farcoding. All rights reserved.
//


#import "ExampleViewController.h"
#import "FCOverlay.h"


@interface ExampleViewController ()
@property (nonatomic, strong) UIButton *dismissButton;
@property (nonatomic, strong) UIButton *createNewButton;
@property (nonatomic, strong) UIButton *hideOneButton;
@property (nonatomic, strong) UIButton *hideAllButton;
@property (nonatomic, strong) UIImageView *catImageView;
@end


@implementation ExampleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.9 green:0.6 blue:0.6 alpha:1];
    
    self.catImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cat"]];
    [self.view addSubview:self.catImageView];
	
    self.dismissButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.dismissButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.dismissButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
    [self.dismissButton setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.dismissButton.titleLabel.shadowOffset = CGSizeMake(1, 1);
    [self.dismissButton setTitle:@"Dismiss" forState:UIControlStateNormal];
    [self.dismissButton addTarget:self action:@selector(hideMe) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.dismissButton];
    
    self.createNewButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.createNewButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.createNewButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
    [self.createNewButton setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.createNewButton.titleLabel.shadowOffset = CGSizeMake(1, 1);
    [self.createNewButton setTitle:@"Create new" forState:UIControlStateNormal];
    [self.createNewButton addTarget:self action:@selector(createNew) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.createNewButton];
    
    self.hideOneButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.hideOneButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
    [self.hideOneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.hideOneButton setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.hideOneButton.titleLabel.shadowOffset = CGSizeMake(1, 1);
    [self.hideOneButton setTitle:@"Hide one" forState:UIControlStateNormal];
    [self.hideOneButton addTarget:self action:@selector(hideOne) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.hideOneButton];
    
    self.hideAllButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.hideAllButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.hideAllButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
    [self.hideAllButton setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.hideAllButton.titleLabel.shadowOffset = CGSizeMake(1, 1);
    [self.hideAllButton setTitle:@"Hide all" forState:UIControlStateNormal];
    [self.hideAllButton addTarget:self action:@selector(hideAll) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.hideAllButton];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGSize size = self.view.bounds.size;
    CGRect frame;
    
    frame = self.catImageView.frame;
    frame.origin.x = floor((size.width - frame.size.width) / 2);
    frame.origin.y = floor((size.height - frame.size.height) / 2);
    self.catImageView.frame = frame;
    
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

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)hideMe
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)hideOne
{
    [FCOverlay dismissOverlayAnimated:YES completion:nil];
}

- (void)hideAll
{
    [FCOverlay dismissAllOverlays];
}

- (void)createNew
{
    ExampleViewController *showController = [[ExampleViewController alloc] init];
    
    [FCOverlay presentOverlayWithViewController:showController
                                    windowLevel:UIWindowLevelAlert
                                     fromWindow:self.view.window
                                       animated:YES
                                     completion:nil];
}

@end
