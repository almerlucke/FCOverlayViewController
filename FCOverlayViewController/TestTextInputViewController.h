//
//  TestTextInputViewController.h
//  FCOverlayViewController
//
//  Created by Almer Lucke on 30/09/14.
//  Copyright (c) 2014 Farcoding. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TestTextInputViewController;

@protocol TestTextInputViewControllerDelegate <NSObject>

- (void)didDismissTestTextInputViewController:(TestTextInputViewController *)controller;

@end

@interface TestTextInputViewController : UIViewController
@property (nonatomic, weak) id<TestTextInputViewControllerDelegate> delegate;
@end
