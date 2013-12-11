//
//  AlertViewController.m
//  FCOverlayViewController
//
//  Created by Almer Lucke on 10/12/13.
//  Copyright (c) 2013 Farcoding. All rights reserved.
//


#import "AlertViewController.h"
#import <QuartzCore/QuartzCore.h>


@interface AlertViewController ()
@property (nonatomic, strong) UIView *alertView;
@property (nonatomic, strong) UILabel *alertTitle;
@property (nonatomic, strong) UILabel *alertMessage;
@property (nonatomic, strong) UIButton *dismissButton;
@end


@implementation AlertViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    
    [self.view addSubview:self.alertView];
    [self.alertView addSubview:self.alertTitle];
    [self.alertView addSubview:self.alertMessage];
    [self.alertView addSubview:self.dismissButton];
    
    self.alertView.alpha = 0;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self animateAlertView];
}

- (void)animateAlertView
{
    [UIView animateWithDuration:0.1 animations:^{self.alertView.alpha = 1.0;}];
    
    self.alertView.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1.0);
    
    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    bounceAnimation.values = [NSArray arrayWithObjects:
                              [NSNumber numberWithFloat:0.5],
                              [NSNumber numberWithFloat:1.1],
                              [NSNumber numberWithFloat:0.8],
                              [NSNumber numberWithFloat:1.0], nil];
    bounceAnimation.duration = 0.3;
    bounceAnimation.removedOnCompletion = NO;
    [self.alertView.layer addAnimation:bounceAnimation forKey:@"bounce"];
    
    self.alertView.layer.transform = CATransform3DIdentity;
}


#pragma mark - Layout

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGFloat paddingVertical = 10;
    CGFloat paddingHorizontal = 10;
    CGFloat subviewVerticalDistance = 10;
    CGFloat dismissButtonWidth = 100;
    CGFloat dismissButtonHeight = 24;
    CGSize viewSize = self.view.bounds.size;
    CGFloat alertViewWidth = 200;
    CGSize labelConstraint = CGSizeMake(alertViewWidth - 2 * paddingHorizontal, CGFLOAT_MAX);
    CGRect titleRect = [self.alertTitle.text boundingRectWithSize:labelConstraint
                                                          options:NSStringDrawingUsesLineFragmentOrigin
                                                       attributes:@{NSFontAttributeName:self.alertTitle.font}
                                                          context:nil];
    CGRect messageRect = [self.alertMessage.text boundingRectWithSize:labelConstraint
                                                              options:NSStringDrawingUsesLineFragmentOrigin
                                                           attributes:@{NSFontAttributeName:self.alertMessage.font}
                                                              context:nil];
    
    CGFloat alertViewHeight = titleRect.size.height + messageRect.size.height + dismissButtonHeight +
                              2 * paddingVertical + 2 * subviewVerticalDistance;
    
    self.alertView.frame = CGRectMake(floor((viewSize.width - alertViewWidth) / 2),
                                      floor((viewSize.height - alertViewHeight) / 2),
                                      alertViewWidth,
                                      alertViewHeight);
    
    self.alertTitle.frame = CGRectMake(floor((alertViewWidth - titleRect.size.width) / 2),
                                       paddingVertical,
                                       titleRect.size.width,
                                       titleRect.size.height);
    
    self.alertMessage.frame = CGRectMake(floor((alertViewWidth - messageRect.size.width) / 2),
                                         CGRectGetMaxY(self.alertTitle.frame) + subviewVerticalDistance,
                                         messageRect.size.width,
                                         messageRect.size.height);
    
    self.dismissButton.frame = CGRectMake(floor((alertViewWidth - dismissButtonWidth) / 2),
                                          CGRectGetMaxY(self.alertMessage.frame) + subviewVerticalDistance,
                                          dismissButtonWidth,
                                          dismissButtonHeight);
}


#pragma mark - Properties

- (void)setAlertTitleString:(NSString *)alertTitleString
{
    _alertTitleString = alertTitleString;
    self.alertTitle.text = alertTitleString;
}

- (void)setAlertMessageString:(NSString *)alertMessageString
{
    _alertMessageString = alertMessageString;
    self.alertMessage.text = alertMessageString;
}


#pragma mark - Actions

- (void)dismissButtonClicked
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Lazy Loading

- (UILabel *)alertTitle
{
    if (!_alertTitle) {
        _alertTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        _alertTitle.text = @"This is an alert";
        _alertTitle.font = [UIFont boldSystemFontOfSize:14];
        _alertTitle.textColor = [UIColor redColor];
        _alertTitle.backgroundColor = [UIColor clearColor];
        _alertTitle.textAlignment = NSTextAlignmentCenter;
        _alertTitle.numberOfLines = 0;
    }
    
    return _alertTitle;
}

- (UILabel *)alertMessage
{
    if (!_alertMessage) {
        _alertMessage = [[UILabel alloc] initWithFrame:CGRectZero];
        _alertMessage.text = @"This is an alert message. This alert was shown via FCOverlay!";
        _alertMessage.font = [UIFont systemFontOfSize:12];
        _alertMessage.textColor = [UIColor blackColor];
        _alertMessage.backgroundColor = [UIColor clearColor];
        _alertMessage.textAlignment = NSTextAlignmentCenter;
        _alertMessage.numberOfLines = 0;
    }
    
    return _alertMessage;
}

- (UIButton *)dismissButton
{
    if (!_dismissButton) {
        _dismissButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_dismissButton setTitle:@"Ok" forState:UIControlStateNormal];
        [_dismissButton addTarget:self action:@selector(dismissButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _dismissButton;
}

- (UIView *)alertView
{
    if (!_alertView) {
        _alertView = [[UIView alloc] initWithFrame:CGRectZero];
        _alertView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9];
        _alertView.layer.cornerRadius = 10.0;
        _alertView.layer.shadowColor = [UIColor blackColor].CGColor;
        _alertView.layer.shadowOpacity = 0.5;
        _alertView.layer.shadowRadius = 3;
        _alertView.layer.shadowOffset = CGSizeMake(0, 1);
    }
    
    return _alertView;
}

@end
