//
//  AVPlayerViewController+FullScreenView.m
//  SDM app
//
//  Created by Priyanka Pundru. on 4/4/17.
//  Copyright © 2017 Priyanka Pundru. All rights reserved.
//

#import "AVPlayerViewController+FullScreenView.h"

@implementation AVPlayerViewController (FullScreenView)

- (void)viewFullScreenMode {
    SEL fsSelector = NSSelectorFromString(@"_transitionToFullScreenViewControllerAnimated:completionHandler:");
    if ([self respondsToSelector:fsSelector]) {
        NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:fsSelector]];
        [inv setSelector:fsSelector];
        [inv setTarget:self];
        BOOL animated = YES;
        id completionBlock = nil;
        [inv setArgument:&(animated) atIndex:2];
        [inv setArgument:&(completionBlock) atIndex:3];
        [inv invoke];
    }
}

@end
