//
//  SDMAnnotation.h
//  SDM app
//
//  Copyright © 2017 Priyanka Pundru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface SDMAnnotation : NSObject<MKAnnotation>
{
    CLLocationCoordinate2D coordinate;
    NSString *title;
    NSString *subtitle;
}

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *subtitle;
@property (nonatomic,copy) NSString *locationName;
@property (nonatomic, assign) CLLocationDegrees annotationLatitude;
@property (nonatomic, assign) CLLocationDegrees annotationLongitude;


- (instancetype)initWithLatitude:(CLLocationDegrees)latitude
                    andLongitude:(CLLocationDegrees)longitude;

@end
