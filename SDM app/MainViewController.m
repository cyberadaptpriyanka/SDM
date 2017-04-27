//
//  MainViewController.m
//  SDM app
//
//  Copyright © 2017 Priyanka Pundru. All rights reserved.
//

#import "MainViewController.h"
#import "SDMSideMenu.h"
#import "MapViewController.h"
#import "ServersViewController.h"
#import "StatusViewController.h"
#import <MessageUI/MessageUI.h>
#import "CustomWebViewController.h"

@interface MainViewController () <SDMSideMenuDelegate, SDMSideMenuDataSource, MFMailComposeViewControllerDelegate>
{
    NSMutableArray  *arrayForBool;
    NSArray *sectionTitleArray;
}
@property (nonatomic, strong) SDMSideMenu *sideMenu;
@property (nonatomic, strong) NSArray *menuItemsArray;

@end

@implementation MainViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.sideMenu = [[SDMSideMenu alloc] initWithSize:180];
    self.sideMenu.dataSource = self;
    self.sideMenu.delegate   = self;
    [self.sideMenu addSwipeGestureRecognition:self.view];
    _menuItemsArray = @[@"",@"Map View", @"Settings", @"Status", @"Privacy Policy",@"Feedback", @"Logout"];
    arrayForBool=[[NSMutableArray alloc] init];
    for (int i=0; i<[_menuItemsArray count]; i++) {
        [arrayForBool addObject:[NSNumber numberWithBool:NO]];
    }
    self.sideMenu.arrayForBool = arrayForBool;
    self.sideMenu.menuItemsArray = _menuItemsArray;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

-(IBAction)buttonMenuLeft:(id)sender
{
    [self.sideMenu show];
}

#pragma mark - SDMSideMenuDataSource

- (NSInteger)numberOfSectionsInSideMenu:(SDMSideMenu *)sideMenu
{
    return [_menuItemsArray count];
}

- (NSInteger)sideMenu:(SDMSideMenu *)sideMenu numberOfRowsInSection:(NSInteger)section
{
    if ([[arrayForBool objectAtIndex:section] boolValue] && section == 2) {
        return 1;
    }
    else
        return 0;
}

- (SDMSideMenuItem *)sideMenu:(SDMSideMenu *)sideMenu
      itemForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SDMSideMenuItem *item = [SDMSideMenuItem new];
    item.title = _menuItemsArray[indexPath.row];
    return item;
}

#pragma mark - SDMSideMenuDelegate

-(void)sideMenu:(SDMSideMenu *)sideMenu didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 1:
        {
            MapViewController *mapController = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
            [self.navigationController pushViewController:mapController animated:YES];
        }
            break;
        case 2:
        {
            if ([MFMailComposeViewController canSendMail])
            {
                MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
                mail.mailComposeDelegate = self;
                [mail setSubject:@"Need Help"];
                [mail setMessageBody:@"Here is some main text in the email!" isHTML:NO];
                [mail setToRecipients:@[self.emailString]];
                [self presentViewController:mail animated:YES completion:NULL];
            }
            else
            {
                NSLog(@"This device cannot send email");
            }
        }
            break;
        case 3:
        {
            StatusViewController *statusController = [[StatusViewController alloc] initWithNibName:@"StatusViewController" bundle:nil];
            [self.navigationController pushViewController:statusController animated:YES];
        }
            break;
            case 4:
        {
            NSURL *url = [NSURL URLWithString:@"https://www.cyberadapt.com/privacy-policy/"];
            CustomWebViewController *controller = [[CustomWebViewController alloc]
                                                   initWithURL:url];
            [self presentViewController:controller animated:YES completion:nil];
        }
            break;
        case 5:
        {
            ServersViewController *statusController = [[ServersViewController alloc] initWithNibName:@"ServersViewController" bundle:nil];
            [self presentViewController:statusController animated:YES completion:nil];
        }
        default:
            break;
    }
}

#pragma mark - MailComposer Delegate
- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultSent:
            NSLog(@"You sent the email.");
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

@end
