//
//  SDMMapAnnotationView.h
//  SDM app
//
//  Copyright © 2017 Priyanka Pundru. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "SDMMapSettings.h"
#import "SDMAnnotation.h"

@interface SDMMapAnnotationView : MKAnnotationView

@property(nonatomic, strong) UIView *pinView;
@property(nonatomic, strong) UIView *calloutView;

- (instancetype)initWithAnnotation:(SDMAnnotation *)annotation
                   reuseIdentifier:(NSString *)reuseIdentifier
                           pinView:(UIView *)pinView
                       calloutView:(UIView *)calloutView
                          settings:(SDMMapSettings *)settings;

- (void)hideCalloutView;
- (void)showCalloutView;

@end
