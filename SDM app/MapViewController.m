//
//  MapViewController.m
//  SDM app
//  Copyright © 2017 Priyanka Pundru. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "SDMMapSettings.h"
#import "SDMMapAnnotationView.h"
#import "SDMAnnotation.h"
#import "UIUtils.h"

@interface MapViewController () <MKMapViewDelegate, CLLocationManagerDelegate>
{
    double latitude_UserLocation, longitude_UserLocation;
}

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property(nonatomic, retain) CLLocationManager *objLocationManager;
@property (weak, nonatomic) IBOutlet UILabel *ipAdressLabel;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    _mapView.delegate = self;
    [self loadUserLocation];
    self.ipAdressLabel.text = [UIUtils getIPAddress];

    SDMAnnotation *annotation = [[SDMAnnotation alloc] initWithLatitude:33.80
                                                     andLongitude:43.670];
    [self.mapView addAnnotation:annotation];
    
    SDMAnnotation *annotation1 = [[SDMAnnotation alloc] initWithLatitude:32.47
                                                           andLongitude:53.50];
    [self.mapView addAnnotation:annotation1];
    
    SDMAnnotation *annotation2 = [[SDMAnnotation alloc] initWithLatitude:55.56
                                                            andLongitude:37.67];
    [self.mapView addAnnotation:annotation2];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (IBAction)cancelTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadUserLocation
{
    _objLocationManager = [[CLLocationManager alloc] init];
    _objLocationManager.delegate = self;
    _objLocationManager.distanceFilter = kCLDistanceFilterNone;
    _objLocationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    if ([_objLocationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [_objLocationManager requestWhenInUseAuthorization];
    }
    [_objLocationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_6_0)
{
    CLLocation *newLocation = [locations objectAtIndex:0];
    latitude_UserLocation = newLocation.coordinate.latitude;
    longitude_UserLocation = newLocation.coordinate.longitude;
    [_objLocationManager stopUpdatingLocation];
    [self loadMapView];
}

- (void)loadMapView
{
    [_mapView setMapType:MKMapTypeStandard];
    
    MKMapRect zoomRect = MKMapRectNull;
    for (id <MKAnnotation> annotation in _mapView.annotations)
    {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x,
                                            annotationPoint.y, 0.1, 0.1);
        zoomRect = MKMapRectUnion(zoomRect, pointRect);
    }
    [_mapView setVisibleMapRect:zoomRect animated:YES];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    [_objLocationManager stopUpdatingLocation];
}

#pragma mark - Mapview Delegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[SDMAnnotation class]]) {
        SDMAnnotation *sdmAnnotation = (SDMAnnotation *)annotation;
        UIImageView *pinView = nil;
        UIView *calloutView = nil;
        SDMMapAnnotationView *annotationView = (SDMMapAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:NSStringFromClass([SDMMapAnnotationView class])];
        
        if (!annotationView) {
            pinView = [[UIImageView alloc] initWithImage:
                       [UIImage imageNamed:@"annotation"]];
            calloutView = [[[NSBundle mainBundle] loadNibNamed:@"ServerAnnotationView"
                            owner:self options:nil] firstObject];
            annotationView = [[SDMMapAnnotationView alloc] initWithAnnotation:sdmAnnotation
                                                              reuseIdentifier:NSStringFromClass([SDMMapAnnotationView class]) pinView:pinView
                                                                  calloutView:calloutView
                                                                     settings:[SDMMapSettings defaultSettings]];
        }else {
            //Changing PinView's image to test the recycle
            pinView = (UIImageView *)annotationView.pinView;
            pinView.image = [UIImage imageNamed:@"annotation"];
        }
        return annotationView;
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:
(MKAnnotationView *)view
{

}

- (void)mapView:(MKMapView *)mapView
didUpdateUserLocation:(MKUserLocation *)userLocation
{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
