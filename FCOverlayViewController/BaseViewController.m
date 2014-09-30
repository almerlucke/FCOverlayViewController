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
#import "TestTextInputViewController.h"

@interface BaseViewController () <TestTextInputViewControllerDelegate>
@property (nonatomic, strong) ExampleTransitioningDelegate *transitioningDelegate;
@property (nonatomic, strong) UIImageView *catImageView;
@property (nonatomic, strong) UIButton *button1;
@property (nonatomic, strong) UIButton *button2;
@property (nonatomic, strong) UIButton *button3;
@end


@implementation BaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.transitioningDelegate = [ExampleTransitioningDelegate new];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.9 green:0.6 blue:0.6 alpha:1];
    
    self.catImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cat2"]];
    [self.view addSubview:self.catImageView];
    
    self.button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.button1 setTitle:@"Show overlay with custom transition" forState:UIControlStateNormal];
    [self.button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.button1 setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.button1.titleLabel.shadowOffset = CGSizeMake(1, 1);
    self.button1.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [self.button1 addTarget:self action:@selector(showOverlay:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button1];
    
    self.button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.button2 setTitle:@"Show custom alert" forState:UIControlStateNormal];
    [self.button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.button2 setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.button2.titleLabel.shadowOffset = CGSizeMake(1, 1);
    self.button2.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [self.button2 addTarget:self action:@selector(showAlert:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button2];

    self.button3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.button3 setTitle:@"Show queued alerts" forState:UIControlStateNormal];
    [self.button3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.button3 setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.button3.titleLabel.shadowOffset = CGSizeMake(1, 1);
    self.button3.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [self.button3 addTarget:self action:@selector(showQueuedAlerts:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button3];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGSize size = self.view.bounds.size;
    CGRect frame = self.catImageView.frame;
    frame.origin.x = floor((size.width - frame.size.width) / 2);
    frame.origin.y = floor((size.height - frame.size.height) / 2);
    self.catImageView.frame = frame;
    
    frame = self.button1.frame;
    frame.size.width = size.width;
    frame.size.height = 30;
    frame.origin.x = 0;
    frame.origin.y = 60;
    self.button1.frame = frame;
    
    frame = self.button2.frame;
    frame.size.width = size.width;
    frame.size.height = 30;
    frame.origin.x = 0;
    frame.origin.y = CGRectGetMaxY(self.button1.frame) + 40;
    self.button2.frame = frame;
    
    frame = self.button3.frame;
    frame.size.width = size.width;
    frame.size.height = 30;
    frame.origin.x = 0;
    frame.origin.y = CGRectGetMaxY(self.button2.frame) + 40;
    self.button3.frame = frame;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    static dispatch_once_t _once_token;
    
    dispatch_once(&_once_token, ^{
        TestTextInputViewController *testController = [[TestTextInputViewController alloc] init];
        testController.delegate = self;
        [self presentViewController:testController animated:YES completion:nil];
    });
}

- (void)didDismissTestTextInputViewController:(TestTextInputViewController *)controller
{
    ExampleViewController *exampleController = [[ExampleViewController alloc] init];
    
    exampleController.transitioningDelegate = self.transitioningDelegate;
    
    [FCOverlay presentOverlayWithViewController:exampleController
                                    windowLevel:UIWindowLevelNormal
                                     fromWindow:self.view.window
                                       animated:YES
                                     completion:nil];
}

- (IBAction)showOverlay:(id)sender
{
    ExampleViewController *exampleController = [[ExampleViewController alloc] init];
    
    exampleController.transitioningDelegate = self.transitioningDelegate;
    
    [FCOverlay presentOverlayWithViewController:exampleController
                                    windowLevel:UIWindowLevelNormal
                                     fromWindow:self.view.window
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
                                     fromWindow:self.view.window
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
                                   fromWindow:self.view.window
                                     animated:NO
                                   completion:nil];
    
    // queue the second alert
    alertController = [[AlertViewController alloc] init];
    
    alertController.alertTitleString = @"This is the second queued alert";
    alertController.alertMessageString = @"After this alert there will be no more alerts in the queue!";
    alertController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [FCOverlay queueOverlayWithViewController:alertController
                                  windowLevel:UIWindowLevelAlert
                                   fromWindow:self.view.window
                                     animated:NO
                                   completion:nil];
}

@end
