//
//  ViewController.h
//  SDM app
//
//  Created by Priyanka Pundru on 2/23/17.
//  Copyright © 2017 Priyanka Pundru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;

typedef void (^UIAlertControllerCompletionBlock) (UIAlertController *controller,
UIAlertAction *action, NSInteger buttonIndex);

@end

