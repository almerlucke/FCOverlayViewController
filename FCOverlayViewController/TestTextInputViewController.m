//
//  TestTextInputViewController.m
//  FCOverlayViewController
//
//  Created by Almer Lucke on 30/09/14.
//  Copyright (c) 2014 Farcoding. All rights reserved.
//

#import "TestTextInputViewController.h"

@interface TestTextInputViewController ()
@property (nonatomic, weak) UITextField *textField;
@end

@implementation TestTextInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blueColor];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 100, 40)];
    self.textField = textField;
    [self.view addSubview:self.textField];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"dismiss" forState:UIControlStateNormal];
    button.frame = CGRectMake(10, 60, 100, 40);
    [button addTarget:self action:@selector(dismissMe) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)dismissMe
{
    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(didDismissTestTextInputViewController:)]) {
            [self.delegate didDismissTestTextInputViewController:self];
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.textField becomeFirstResponder];
}

@end
