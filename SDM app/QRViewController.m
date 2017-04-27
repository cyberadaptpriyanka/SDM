//
//  QRViewController.m
//  SDM app
//
//  Copyright © 2017 Priyanka Pundru. All rights reserved.
//

#import "QRViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "UIUtils.h"

@interface QRViewController () <AVCaptureMetadataOutputObjectsDelegate>

@property (weak, nonatomic) IBOutlet UIView *previewView;
@property (nonatomic) BOOL isReading;

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (weak, nonatomic) IBOutlet UIButton *startStopButton;

- (BOOL)startReading;
- (void)stopReading;

@end

@implementation QRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _isReading = YES;
    _captureSession = nil;
    if ([self startReading]) {
        [self.startStopButton setTitle:@"Stop" forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)startQRTapped:(id)sender {
    if (!_isReading) {
        if ([self startReading]) {
            [self.startStopButton setTitle:@"Stop" forState:UIControlStateNormal];
           // [_lblStatus setText:@"Scanning for QR Code..."];
        }
    }
    else{
        [self stopReading];
        [self.startStopButton setTitle:@"Start" forState:UIControlStateNormal];
    }
    
    _isReading = !_isReading;
}

- (BOOL)startReading {
    NSError *error;
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:
                                   captureDevice error:&error];
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    _captureSession = [[AVCaptureSession alloc] init];
    [_captureSession addInput:input];
    
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput:captureMetadataOutput];
    
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc]
                          initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:_previewView.layer.bounds];
    [_previewView.layer addSublayer:_videoPreviewLayer];

    [_captureSession startRunning];
    
    return YES;
}

- (void)stopReading
{
    [_captureSession stopRunning];
    _captureSession = nil;
    [_videoPreviewLayer removeFromSuperlayer];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            NSString *scannedResult = [(AVMetadataMachineReadableCodeObject *)metadataObj stringValue];
//            scannedResult = @"https://duesterwald.mobileactivedefense.com/mad-console/seam/resource/qrc/L5ZP6ZLKRmdkYEFxhpAa9FwAAAA";
            NSLog(@"Scanned Result :%@", scannedResult);
            if (scannedResult != nil) {
                [self rediretToTokenEnrollmentUrl:scannedResult];
            }

            [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
            [self performSelectorOnMainThread:@selector(setButtonTitle:)
                                   withObject:@"Start" waitUntilDone:NO];
            _isReading = NO;
        }
    }
}

- (void)rediretToTokenEnrollmentUrl:(NSString *)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    //Use the url string parameter to load the enrollment token url
    NSString *sourceString = @"/mad-console/seam/resource/qrc";
    
    NSRange range = [urlString rangeOfString:sourceString];
    BOOL found = ( range.location != NSNotFound );
    
    if (url && [url.scheme isEqualToString:@"https"] && found)
    {
        [[UIApplication sharedApplication] openURL:url];
    }
    else
    {
        [self setStartStopButton:nil];
        //Handle Invalid Url Scenario
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert"
                                                                                 message:@"The scanned QR code is invalid. Please try again later" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Ok"
                                                            style:UIAlertActionStyleDefault handler:
                                    ^(UIAlertAction *action) {
                                        [self dismissViewControllerAnimated:YES completion:nil];
                                    }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)setButtonTitle:(NSString *)title
{
    [self.startStopButton setTitle:title forState:UIControlStateNormal];
}

@end
