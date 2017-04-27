//
//  ViewController.m
//  SDM app
//
//  Created by Priyanka Pundru on 2/23/17.
//  Copyright © 2017 Priyanka Pundru. All rights reserved.
//

#import "LoginViewController.h"
#import "APIManager.h"
#import "UIUtils.h"
#import "QRViewController.h"
#import "MapViewController.h"
#import "MainViewController.h"
#include <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "PickerView.h"

@interface LoginViewController () <UITextFieldDelegate, PickerViewDelegate>
{
    AVPlayerLayer *playerLayer;
    CMTime currentTime;
    PickerView *serverPickerView;
    NSArray *serverArray;
}

@property (weak, nonatomic) IBOutlet UIImageView *lockImageView;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *loginEffectView;
@property (weak, nonatomic) IBOutlet UIButton *goButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet UITextField *serverField;
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (nonatomic, retain) AVPlayerViewController *avPlayerViewcontroller;
@property (nonatomic, retain) AVPlayer *avPlayer;
@property (nonatomic , strong) UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIView *provisionview;

@end

@implementation LoginViewController

#pragma mark - View Loader Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    self.usernameField.delegate = self;
    self.passwordField.delegate = self;
    self.serverField.delegate = self;
    self.loginView.layer.cornerRadius = 3.0f;
    self.loginEffectView.layer.cornerRadius = 3.0f;
    self.loginEffectView.clipsToBounds = YES;

    self.activityIndicator.hidden = YES;
    [self.logoImageView setAlpha:0.0f];
    [self.welcomeLabel setAlpha:1.0f];

    [UIView animateWithDuration:3.0f animations:^{
        [self.logoImageView setAlpha:1.0f];
        [self.welcomeLabel setAlpha:0.0f];
    } completion:nil];
    
    NSString *resourceName = @"bgmovie";
    NSString* movieFilePath = [[NSBundle mainBundle]
                               pathForResource:resourceName ofType:@"mp4"];
    NSURL *fileURL = [NSURL fileURLWithPath:movieFilePath];
    
    self.avPlayer = [AVPlayer playerWithURL:fileURL];
    self.avPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    self.avPlayer.muted = true;
    playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.avPlayer];
    
    playerLayer.videoGravity = AVLayerVideoGravityResize;
    playerLayer.zPosition = -1;
    playerLayer.frame = [UIScreen mainScreen].bounds;

    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [[AVAudioSession sharedInstance] setCategory:
     AVAudioSessionModeMoviePlayback error:nil];
    self.backgroundImageView.hidden = YES;
   
    [self.view.layer insertSublayer:playerLayer
                              above:self.backgroundImageView.layer];
    
    [self.avPlayer play];
   // [self addPickerView];
    
    [self.passwordField setLeftView:[self containerViewWithImage:
                                     [UIImage imageNamed:@"password"]]];
    [self.passwordField setLeftViewMode:UITextFieldViewModeAlways];
    [self.usernameField setLeftView:[self containerViewWithImage:
                                     [UIImage imageNamed:@"username"]]];

    [self.usernameField setLeftViewMode:UITextFieldViewModeAlways];
    [self.serverField setLeftView:[self containerViewWithImage:
                                     [UIImage imageNamed:@"CyberadAPT"]]];

    [self.serverField setLeftViewMode:UITextFieldViewModeAlways];
    
    
    _goButton.layer.borderColor = [UIColor whiteColor].CGColor;
    _goButton.layer.borderWidth = 2.0;
    
//    self.goButton.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.8].CGColor;
       [self.provisionview setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.5]];
}

- (void)customizeLoginView
{
//    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:
//                                CGPointMake(self.loginView.frame.size.width/2, 0) radius:34.0f startAngle:0.0 endAngle:(M_PI) clockwise:YES];
//    
//    CAShapeLayer *outerLayer = [CAShapeLayer layer];
//    outerLayer.path = circlePath.CGPath;
//    outerLayer.fillRule = kCAFillRuleEvenOdd;
//    outerLayer.fillColor = [UIColor colorWithRed:0.0/255.0f green:0.0/255.0f
//                                           blue:0.0/255.0f alpha:0.3].CGColor;
//    outerLayer.opacity = 1.0f;
//    [self.loginView.layer addSublayer:outerLayer];
//    CAShapeLayer *stroke = [CAShapeLayer new];
//    stroke.frame = outerLayer.bounds;
//    stroke.path = circlePath.CGPath;
//    stroke.lineWidth = 1;
//    stroke.strokeColor = [UIColor colorWithWhite:1 alpha:0.4].CGColor;
//    stroke.fillColor = nil;
//    
//    [outerLayer addSublayer:stroke];
//    
//    UIBezierPath *semicirclePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.lockImageView.bounds.size.width/2, 0) radius:self.lockImageView.bounds.size.height + 10 startAngle:0.0 endAngle:(M_PI) clockwise:YES];
//    
//    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
//    shapeLayer.path = semicirclePath.CGPath;
//    
//    self.lockImageView.layer.mask = shapeLayer;
//    shapeLayer.fillColor = [UIColor colorWithWhite:1 alpha:0.4].CGColor;
//    shapeLayer.opacity = 1.0;
//    [self.lockImageView.layer addSublayer:shapeLayer];
    self.loginView.layer.borderWidth = 1.0f;
//    self.goButton.layer.borderWidth = 1.0f;
    self.loginView.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.4].CGColor;
//    self.goButton.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.4].CGColor;
//       _goButton.layer.borderWidth = 3.0;
//    _goButton.layer.borderColor = [UIColor whiteColor].CGColor;
 
     self.goButton.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.8].CGColor;

}

- (UIView *)containerViewWithImage:(UIImage *)image
{
    UIView *containerView = [[UIView alloc] init];
    [containerView setFrame:CGRectMake(0.0f, 0.0f, 34.0f,
                                       self.passwordField.frame.size.height)];
    [containerView setBackgroundColor:[UIColor clearColor]];
    
    UIImageView *icon = [[UIImageView alloc] init];
    [icon setImage:image];
    [icon setFrame:CGRectMake(5.0f, 5.0f, 20.0f,
                              self.passwordField.frame.size.height - 10.0f)];
    [icon setBackgroundColor:[UIColor clearColor]];
    
    [containerView addSubview:icon];

    return containerView;
}

- (void)addPickerView
{
    serverArray = @[@"migas.cyberadapt.com", @"duesterwald.mobileactivedefense.com"];
    serverPickerView = [[PickerView alloc] initWithDelegate:self pickerArray:serverArray];
    self.serverField.inputView = serverPickerView;
    [self.serverField setInputAccessoryView:self.toolBar];
    
    CGRect rect = [ [ UIScreen mainScreen ] bounds ];
    self.toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake
                    (0, 0, rect.size.width, 44)];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(donePickerButtonSelected)];
    
    UIBarButtonItem *spaceButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(closePickerButtonSelected)];
    
    NSArray *barItems = [NSArray arrayWithObjects:cancelButton,
                         spaceButton, doneButton, nil];
    [self.toolBar setItems:barItems animated:YES];
    [_serverField setInputAccessoryView:self.toolBar];
}

- (void)donePickerButtonSelected{
    [self.serverField resignFirstResponder];
}

- (void)closePickerButtonSelected{
    [self.serverField resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playVideo:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:self.avPlayer.currentItem];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appEnteredForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appEnteredBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self configureTextField:self.usernameField];
    [self configureTextField:self.passwordField];
    [self configureTextField:self.serverField];
    playerLayer.frame = [UIScreen mainScreen].bounds;
    [self setUploginControls];
    [self customizeLoginView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:AVPlayerItemDidPlayToEndTimeNotification];
}

- (IBAction)goButtonTapped:(id)sender {
    [self.view layoutIfNeeded];
    
    self.topConstraint.constant = 133;
    [UIView animateWithDuration:1
                     animations:^{
                         [self.view layoutIfNeeded];
                         self.goButton.hidden = YES;
                     }];
}

- (void) appEnteredForeground {
    [playerLayer setPlayer:NULL];
    [playerLayer setPlayer:self.avPlayer];
    [self playAt:currentTime];
}

- (void) appEnteredBackground {
    [self.avPlayer pause];
    currentTime = [self.avPlayer currentTime];
}

- (void)playAt: (CMTime)time {
    if(self.avPlayer.status == AVPlayerStatusReadyToPlay && self.avPlayer.currentItem.status == AVPlayerItemStatusReadyToPlay) {
        [self.avPlayer seekToTime:time toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
            [self.avPlayer play];
        }];
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self playAt:time];
        });
    }
}

- (void)playVideo:(NSNotification *)notification
{
    AVPlayerItem *playerItem = [notification object];
    [playerItem seekToTime:kCMTimeZero];
    [self.avPlayer play];
}

- (void)selectedPickerWithRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.serverField.text = serverArray[row];
}

- (IBAction)qrButtonTapped:(id)sender {
    QRViewController *controller = [[QRViewController alloc] initWithNibName:@"QRViewController" bundle:nil];
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark - View Configuration Helpers
- (void)configureTextField:(UITextField *)textField {
    CALayer *border = [CALayer layer];
    CGFloat borderWidth = 1.0;
    border.borderColor = [UIColor colorWithWhite:1.0 alpha:0.4].CGColor;
    border.frame = CGRectMake(28, 0, 1, textField.frame.size.height);
    border.borderWidth = borderWidth;
    [textField.layer addSublayer:border];
    textField.layer.borderWidth = 1.0f;
    textField.layer.cornerRadius = 2.0f;
    textField.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.4].CGColor;
    textField.layer.masksToBounds = YES;
}

- ( void )setUploginControls {
    [self.loginView setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.5]];
    [_usernameField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_passwordField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_usernameField setReturnKeyType:UIReturnKeyNext];
    [_passwordField setReturnKeyType:UIReturnKeyGo];
    [_usernameField setTintColor:[UIColor whiteColor]];
    [_passwordField setTintColor:[UIColor whiteColor]];
    [_usernameField setTextColor:[UIColor whiteColor]];
    [_passwordField setTextColor:[UIColor whiteColor]];
    [_serverField setTintColor:[UIColor whiteColor]];
    [_serverField setTextColor:[UIColor whiteColor]];
    [_usernameField setValue:[UIColor whiteColor]
                  forKeyPath:@"_placeholderLabel.textColor"];
    [_passwordField setValue:[UIColor whiteColor]
                  forKeyPath:@"_placeholderLabel.textColor"];
    [_serverField setValue:[UIColor whiteColor]
                  forKeyPath:@"_placeholderLabel.textColor"];

    _continueButton.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.4].CGColor;
    _continueButton.layer.borderWidth = 1.0;
    _continueButton.layer.cornerRadius = 2.0f;
    _lockImageView.layer.borderWidth = 4.0f;
    _lockImageView.layer.borderColor = [UIColor clearColor].CGColor;
}

#pragma mark - Continue Button Action
- (IBAction)loginTapped:(UIButton *)sender {
    MainViewController *mainController = [[MainViewController alloc] initWithNibName:
                                          @"MainViewController" bundle:nil];
    mainController.emailString = @"sdmhelpdesk.com";
    [self.navigationController pushViewController:mainController animated:NO];
    return;
    
    if ([self.usernameField.text length] > 0 && [self.passwordField.text length] > 0) {
        if ([self.serverField.text length] > 0) {
            [self.activityIndicator startAnimating];
            self.activityIndicator.hidden = NO;
            
            [[APIManager sharedAPIManager] loginWithUsername:self.usernameField.text  password:self.passwordField.text  completion:^(id data, NSError *error) {
                [self.activityIndicator stopAnimating];
                self.activityIndicator.hidden = YES;
                if (error != nil) {
                    [UIUtils showAlertWithTitle:@"Alert" message:@"Incorrect username/password combo." buttonTitle:@"Ok" isCancelRequired:NO alertActionBlock:^(UIAlertController *controller, UIAlertAction *action, NSInteger buttonIndex) {
                    }];
                }
                if (data != nil) {
                    NSError *error;
                    NSPropertyListFormat format;
                    NSDictionary* plist = (NSDictionary*) [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable
                                                                                                     format:&format error:&error];
                    if (plist != nil) {
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"USERNAME"];
                        [[NSUserDefaults standardUserDefaults] setObject:self.usernameField.text forKey:@"USERNAME"];
                        NSString *enrollmentUrl = [plist objectForKey:@"EnrollmentUrl"];
                        NSString *supportMail = @"";
                        if ([plist objectForKey:@"SupportMail"] != nil) {
                            supportMail = [plist objectForKey:@"SupportMail"];
                        }
                        
                        [self redirectToTokenEnrollmentUrl:enrollmentUrl supportMail:supportMail];
                    }
                    NSLog( @"plist is %@", plist );
                }
            }];
        }
        else{
            {
                //Show alert to enter valid login info
                [UIUtils showAlertWithTitle:@"Alert" message:@"Please enter valid server name." buttonTitle:@"Ok" isCancelRequired:NO alertActionBlock:^(UIAlertController *controller, UIAlertAction *action, NSInteger buttonIndex) {
                }];
            }
        }
    }
    else{
        //Show alert to enter valid login info
        [UIUtils showAlertWithTitle:@"Alert" message:@"Please enter valid username and password." buttonTitle:@"Ok" isCancelRequired:NO alertActionBlock:^(UIAlertController *controller, UIAlertAction *action, NSInteger buttonIndex) {
        }];
    }
}

- (void)redirectToTokenEnrollmentUrl:(NSString *)urlString supportMail:(NSString *)supportMail
{
    //Use the url string parameter to load the enrollment token url
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    MainViewController *mainController = [[MainViewController alloc] initWithNibName:
                              @"MainViewController" bundle:nil];
    mainController.emailString = supportMail;
    [self.navigationController pushViewController:mainController animated:NO];
}

#pragma mark - UITextField Delegate Methods
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.serverField)
    {
        if ([self.serverField.text isEqualToString:@""])
        {
            [self selectedPickerWithRow:0 inComponent:0];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Sample Response
/*
 <?xml version="1.0" encoding="UTF-8"?>
 <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd" >
 <plist version="1.0">
 <dict>
 <key>SdmProfileType</key>
 <string>IosAppEnrollment</string>
 <key>SdmProfileVersion</key>
 <integer>1</integer>
 <key>EnrollmentUrl</key>
 <string>https://duesterwald.mobileactivedefense.com/mad-console/seam/resource/qrc/L5ZP6ZLKRmdkYEFxhpAa9FwAAAA</string>
 </dict>
 </plist>
 */
@end
