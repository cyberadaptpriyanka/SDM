//
//  StatusViewController.m
//  SDM app
//  Copyright © 2017 Priyanka Pundru. All rights reserved.
//

#import "StatusViewController.h"
#import <sys/utsname.h>
#import <MessageUI/MessageUI.h>

@interface StatusViewController () <MFMailComposeViewControllerDelegate>
{
    NSDate *fileDate;
    NSString *deviceType;
}
@property (weak, nonatomic) IBOutlet UIImageView *deviceImageView;
@property (weak, nonatomic) IBOutlet UILabel *deviceTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceVersionLabel;
@property (weak, nonatomic) IBOutlet UILabel *osVersionLabel;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation StatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self deviceName];
    self.title = @"My Device";
    
    fileDate = [NSDate date];
    NSString *fileName = [self getFileName];
    NSArray* documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString* documentDirectory = [documentDirectories objectAtIndex:0];
    NSString* documentDirectoryFilename = [documentDirectory stringByAppendingPathComponent:fileName];
    NSError *error;
    if ([[NSFileManager defaultManager] fileExistsAtPath:documentDirectoryFilename])
    {
        [[NSFileManager defaultManager] removeItemAtPath:
         documentDirectoryFilename error:&error];
    }
    [self createPDFfromUIView:self.contentView
  saveToDocumentsWithFileName:fileName];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (IBAction)sendStatusReport:(UIButton *)sender {
    
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailComposeViewController = [[MFMailComposeViewController alloc] init];
        mailComposeViewController.mailComposeDelegate = self;
        mailComposeViewController.title = @"Service Request Help";
        NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERNAME"];

        NSString *subject = [NSString stringWithFormat:@"Support request from %@ on server %@", username, @"duesterwald.mobileactivedefense.com"];
        [mailComposeViewController setSubject:subject];
        NSString* uniqueIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        NSString *body = [NSString stringWithFormat:@"\n           This is a support request from the iOS SDM app installed with the below specifications : \n\n           Device: %@\n           name: %@\n           S/N: %@ \n           Associated with user %@", deviceType, [[UIDevice currentDevice] name], uniqueIdentifier, username];

        [mailComposeViewController setMessageBody:body isHTML:NO];
        
        NSArray* documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
        NSString* documentDirectory = [documentDirectories objectAtIndex:0];
        NSString* documentDirectoryFilename = [documentDirectory stringByAppendingPathComponent:[self getFileName]];
        NSData *file = nil;
        if ([[NSFileManager defaultManager] fileExistsAtPath:documentDirectoryFilename])
        {
            file = [[NSData alloc] initWithContentsOfFile:documentDirectoryFilename];
            
            [mailComposeViewController addAttachmentData:file
                                                mimeType:@"application/pdf" fileName:[self getFileName]];
            [self presentViewController:mailComposeViewController
                               animated:YES completion:NULL];
        }
    }
}

- (NSString *)getFileName
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd'T'HH':'mm':'ss" ];
    NSString *stringDate = [dateFormatter stringFromDate:fileDate];
    
    NSString *fileName = [NSString stringWithFormat:@"VPNLog%@.pdf", stringDate];

    return fileName;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString*)deviceName
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString* code = [NSString stringWithCString:systemInfo.machine
                                        encoding:NSUTF8StringEncoding];
    NSDictionary* deviceNamesByCode = nil;
    
    if (!deviceNamesByCode) {
        deviceNamesByCode = @{@"i386" :@"Simulator",
                              @"x86_64" :@"Simulator",
                              @"iPod1,1" :@"iPod Touch",        // (Original)
                              @"iPod2,1" :@"iPod Touch",        // (Second Generation)
                              @"iPod3,1" :@"iPod Touch",        // (Third Generation)
                              @"iPod4,1" :@"iPod Touch",        // (Fourth Generation)
                              @"iPod7,1" :@"iPod Touch",        // (6th Generation)
                              @"iPad1,1" :@"iPad",              // (Original)
                              @"iPad2,1" :@"iPad 2",            //
                              @"iPad3,1" :@"iPad",              // (3rd Generation)
                              @"iPhone3,1" :@"iPhone 4",          // (GSM)
                              @"iPhone3,3" :@"iPhone 4",          // (CDMA/Verizon/Sprint)
                              @"iPhone4,1" :@"iPhone 4S",         //
                              @"iPhone5,1" :@"iPhone 5",          // (model A1428, AT&T/Canada)
                              @"iPhone5,2" :@"iPhone 5",          // (model A1429, everything else)
                              @"iPad3,4" :@"iPad",              // (4th Generation)
                              @"iPad2,5" :@"iPad Mini",         // (Original)
                              @"iPhone5,3" :@"iPhone 5c",         // (model A1456, A1532 | GSM)
                              @"iPhone5,4" :@"iPhone 5c",         // (model A1507, A1516, A1526 (China), A1529 | Global)
                              @"iPhone6,1" :@"iPhone 5s",         // (model A1433, A1533 | GSM)
                              @"iPhone6,2" :@"iPhone 5s",         // (model A1457, A1518, A1528 (China), A1530 | Global)
                              @"iPhone7,1" :@"iPhone 6 Plus",     //
                              @"iPhone7,2" :@"iPhone 6",          //
                              @"iPhone8,1" :@"iPhone 6S",         //
                              @"iPhone8,2" :@"iPhone 6S Plus",    //
                              @"iPhone8,4" :@"iPhone SE",         //
                              @"iPhone9,1" :@"iPhone 7",          //
                              @"iPhone9,3" :@"iPhone 7",          //
                              @"iPhone9,2" :@"iPhone 7 Plus",     //
                              @"iPhone9,4" :@"iPhone 7 Plus",     //
                              @"iPad4,1" :@"iPad Air",          // 5th Generation iPad (iPad Air) - Wifi
                              @"iPad4,2" :@"iPad Air",          // 5th Generation iPad (iPad Air) - Cellular
                              @"iPad4,4" :@"iPad Mini",         // (2nd Generation iPad Mini - Wifi)
                              @"iPad4,5" :@"iPad Mini",         // (2nd Generation iPad Mini - Cellular)
                              @"iPad4,7" :@"iPad Mini",         // (3rd Generation iPad Mini - Wifi (model A1599))
                              @"iPad6,7" :@"iPad Pro (12.9\")", // iPad Pro 12.9 inches - (model A1584)
                              @"iPad6,8" :@"iPad Pro (12.9\")", // iPad Pro 12.9 inches - (model A1652)
                              @"iPad6,3" :@"iPad Pro (9.7\")",  // iPad Pro 9.7 inches - (model A1673)
                              @"iPad6,4" :@"iPad Pro (9.7\")"   // iPad Pro 9.7 inches - (models A1674 and A1675)
                              };
    }
    
    NSString* deviceName = [deviceNamesByCode objectForKey:code];
    
    if (deviceName) {
        if ([code rangeOfString:@"iPod"].location != NSNotFound) {
            deviceName = @"iPod Touch";
            self.deviceTypeLabel.text = [NSString stringWithFormat:
                                         @"Device Type : %@", deviceName];
            self.deviceVersionLabel.text = [NSString stringWithFormat:
                                            @"Device Specific : %@", [deviceNamesByCode
                                                                      objectForKey:code]];
            deviceType = [deviceNamesByCode
                          objectForKey:code];
            self.deviceImageView.image = [UIImage imageNamed:@"iphone"];
        }
        else if([code rangeOfString:@"iPad"].location != NSNotFound) {
            deviceName = @"iPad";
            self.deviceTypeLabel.text = [NSString stringWithFormat:
                                         @"Device Type : %@", deviceName];
            self.deviceVersionLabel.text = [NSString stringWithFormat:
                                            @"Device Specific : %@", [deviceNamesByCode
                                                                      objectForKey:code]];

            self.deviceImageView.image = [UIImage imageNamed:@"ipad"];
            deviceType = [deviceNamesByCode
                          objectForKey:code];
        }
        else if([code rangeOfString:@"iPhone"].location != NSNotFound){
            deviceName = @"iPhone";
            self.deviceTypeLabel.text = [NSString stringWithFormat:
                                         @"Device Type : %@", deviceName];
            self.deviceVersionLabel.text = [NSString stringWithFormat:
                                            @"Device Specific : %@", [deviceNamesByCode
                                                                      objectForKey:code]];
            self.deviceImageView.image = [UIImage imageNamed:@"iphone"];
            deviceType = [deviceNamesByCode
                          objectForKey:code];
        }
        else {
            deviceName = @"Unknown";
        }
    }
    
    self.osVersionLabel.text = [NSString stringWithFormat:
                                    @"OS Version : %@", [[UIDevice currentDevice] systemVersion]];
    
    return deviceName;
}

-(NSMutableData *)createPDFDatafromUIView:(UIView*)aView
{
    // Creates a mutable data object for updating with binary data, like a byte array
    NSMutableData *pdfData = [NSMutableData data];
    
    // Points the pdf converter to the mutable data object and to the UIView to be converted
    UIGraphicsBeginPDFContextToData(pdfData, aView.bounds, nil);
    UIGraphicsBeginPDFPage();
    CGContextRef pdfContext = UIGraphicsGetCurrentContext();
    // draws rect to the view and thus this is captured by UIGraphicsBeginPDFContextToData
    
    [aView.layer renderInContext:pdfContext];
    // remove PDF rendering context
    UIGraphicsEndPDFContext();
    
    return pdfData;
}


-(NSString*)createPDFfromUIView:(UIView*)aView
    saveToDocumentsWithFileName:(NSString*)aFilename
{
    // Creates a mutable data object for updating with binary data, like a byte array
    NSMutableData *pdfData = [self createPDFDatafromUIView:aView];
    
    // Retrieves the document directories from the iOS device
    NSArray* documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    
    NSString* documentDirectory = [documentDirectories objectAtIndex:0];
    NSString* documentDirectoryFilename = [documentDirectory stringByAppendingPathComponent:aFilename];
    
    // instructs the mutable data object to write its context to a file on disk
    [pdfData writeToFile:documentDirectoryFilename atomically:YES];
    NSLog(@"documentDirectoryFileName: %@",documentDirectoryFilename);
    return documentDirectoryFilename;
}

#pragma mark - MailComposer Delegate
- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultSent:
           self.timer = [NSTimer scheduledTimerWithTimeInterval:5
                                              target:self selector:@selector(showStatusAlert)
                                            userInfo:nil repeats:NO];
            break;
        case MFMailComposeResultSaved:
            NSLog(@"You saved a draft of this email");
            break;
        case MFMailComposeResultCancelled:
            NSLog(@"You cancelled sending this email.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed:  An error occurred when trying to compose this email");
            break;
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)showStatusAlert
{
    [self.timer invalidate];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert"
                                                                             message:@"Please check your mail box for response. Select Delete Profile to remove the installed profiles." preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Delete Profile"
                                                        style:UIAlertActionStyleDefault handler:
                                ^(UIAlertAction *action) {
                                    NSURL *url = [NSURL URLWithString:@"App-prefs:root=General&path=ManagedConfigurationList"];
                                    if ([[UIApplication sharedApplication] canOpenURL:url]) {
                                        [[UIApplication sharedApplication] openURL:url];
                                    }
                                }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Ok"
                                                        style:UIAlertActionStyleDefault handler:
                                ^(UIAlertAction *action) {
                                }]];

    [self presentViewController:alertController animated:YES completion:nil];
}

@end
