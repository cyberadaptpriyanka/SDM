//
//  SDMAnnotation.m
//  SDM app
//
//  Copyright © 2017 Priyanka Pundru. All rights reserved.
//

#import "SDMAnnotation.h"

@implementation SDMAnnotation

- (instancetype)initWithLatitude:(CLLocationDegrees)latitude
                    andLongitude:(CLLocationDegrees)longitude {
    self = [super init];
    
    if (self) {
        _annotationLatitude = latitude;
        _annotationLongitude = longitude;
    }
    
    return self;
}

- (CLLocationCoordinate2D)coordinate {
    CLLocationCoordinate2D annotationCoordinate;
    annotationCoordinate.latitude = self.annotationLatitude;
    annotationCoordinate.longitude = self.annotationLongitude;
    return annotationCoordinate;
}

@end
