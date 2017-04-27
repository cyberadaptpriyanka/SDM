//
//  SDMMapSettings.m
//  SDM app
//
//  Copyright © 2017 Priyanka Pundru. All rights reserved.
//

#import "SDMMapSettings.h"

@implementation SDMMapSettings

+ (instancetype)defaultSettings {
    SDMMapSettings *newSettings = [[super alloc] init];
    if (newSettings) {
        newSettings.calloutOffset = 10.0f;
        
        newSettings.shouldRoundifyCallout = YES;
        newSettings.calloutCornerRadius = 5.0f;
        
        newSettings.shouldAddCalloutBorder = YES;
        newSettings.animationType = SDMCalloutAnimationZoomIn;
        newSettings.animationDuration = 0.25;
    }
    return newSettings;
}

@end
