//
//  UIUtils.h
//  SDM app
//
//  Copyright © 2017 Priyanka Pundru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIUtils : NSObject
typedef void (^UIAlertControllerCompletionBlock) (UIAlertController *controller,
UIAlertAction *action, NSInteger buttonIndex);

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message
               buttonTitle:(NSString *)buttonTitle  isCancelRequired:(BOOL)isCancelRequired alertActionBlock:(UIAlertControllerCompletionBlock)alertActionBlock;
+ (NSString *)getIPAddress;

@end
