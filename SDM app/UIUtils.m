//
//  UIUtils.m
//  SDM app
//
//  Copyright © 2017 Priyanka Pundru. All rights reserved.
//

#import "UIUtils.h"
#import <Foundation/Foundation.h>
#include <ifaddrs.h>
#include <arpa/inet.h>

static NSInteger const UIAlertActionCancelButtonIndex = 0;
static NSInteger const UIAlertActionFirstOtherButtonsIndex = 1;

@implementation UIUtils

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message
               buttonTitle:(NSString *)buttonTitle  isCancelRequired:(BOOL)isCancelRequired alertActionBlock:(UIAlertControllerCompletionBlock)alertActionBlock
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:buttonTitle
                                                        style:UIAlertActionStyleDefault handler:
                                ^(UIAlertAction *action) {
                                                            if (alertActionBlock) {
                                                                alertActionBlock(alertController, action,UIAlertActionFirstOtherButtonsIndex);
                                                            }}]];
    if (isCancelRequired) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Text_Cancel", nil)
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction *action){
                                                                 if (alertActionBlock) {
                                                                     alertActionBlock(alertController, action, UIAlertActionCancelButtonIndex);
                                                                 }}];
        [alertController addAction:cancelAction];
    }
    
    [[[[UIApplication sharedApplication] keyWindow] rootViewController]
     presentViewController:alertController animated:YES completion:nil];
}

+ (NSString *)getIPAddress
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    
    return address;
}

@end
