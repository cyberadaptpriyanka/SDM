//
//  SDMMapSettings.h
//  SDM app
//
//  Copyright © 2017 Priyanka Pundru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SDMCalloutAnimation) {
    SDMCalloutAnimationNone,
    SDMCalloutAnimationFadeIn,
    SDMCalloutAnimationZoomIn
};

@interface SDMMapSettings : NSObject

@property(nonatomic, assign) CGFloat calloutOffset;

@property(nonatomic, assign) BOOL shouldRoundifyCallout;
@property(nonatomic, assign) CGFloat calloutCornerRadius;

@property(nonatomic, assign) BOOL shouldAddCalloutBorder;
@property(nonatomic, strong) UIColor *calloutBorderColor;
@property(nonatomic, assign) CGFloat calloutBorderWidth;

@property(nonatomic, assign) SDMCalloutAnimation animationType;
@property(nonatomic, assign) NSTimeInterval animationDuration;

+ (instancetype)defaultSettings;

@end

