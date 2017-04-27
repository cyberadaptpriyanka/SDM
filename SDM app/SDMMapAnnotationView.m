//
//  SDMAnnotationView.m
//  CustomCallout
//


#import "SDMMapAnnotationView.h"
#import "SDMMapSettings.h"
#import "UIUtils.h"
#import "AnnotationTableViewCell.h"

static NSString *annoationTableViewCellIdentifier = @"AnnotationTableViewCell";

@interface SDMMapAnnotationView () <UITableViewDelegate, UITableViewDataSource>
{
    BOOL _hasCalloutView;
    NSArray *dataArray;
    SDMAnnotation *sdmAnnotation;
}

@property(nonatomic, strong) SDMMapSettings *settings;
@property(nonatomic, strong) UITableView *tableView;
@end

@implementation SDMMapAnnotationView

- (instancetype)initWithAnnotation:(SDMAnnotation *)annotation
                   reuseIdentifier:(NSString *)reuseIdentifier
                           pinView:(UIView *)pinView
                       calloutView:(UIView *)calloutView
                          settings:(SDMMapSettings *)settings {
    
    NSAssert(pinView != nil, @"Pinview can not be nil");
    self = [super initWithAnnotation:annotation
                     reuseIdentifier:reuseIdentifier];
    if (self) {
        self.clipsToBounds = NO;
        [self validateSettings:settings];

        _hasCalloutView = (calloutView) ? YES : NO;
        self.canShowCallout = NO;
        self.pinView = pinView;
        self.pinView.userInteractionEnabled = YES;
        dataArray = @[@"Public IP Address", @"Private IP Address"];
        self.tableView = [[UITableView alloc] initWithFrame:calloutView.frame
                                                      style:UITableViewStylePlain];
        [self.tableView setBackgroundColor:[UIColor colorWithRed:245.0/255.0
                                                           green:245.0/255.0 blue:245.0/255.0 alpha:1]];
        [self.tableView registerNib:[UINib nibWithNibName:@"AnnotationTableViewCell"
                                                   bundle:nil] forCellReuseIdentifier:annoationTableViewCellIdentifier];
        sdmAnnotation = annotation;
        self.tableView.scrollEnabled = YES;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.calloutView.tag = 99;
        UIView *footerView = [[UIView alloc]initWithFrame:CGRectZero];
        [footerView setBackgroundColor:[UIColor clearColor]];
        self.tableView.tableFooterView = footerView;
        self.calloutView = calloutView;
        [self.calloutView addSubview:self.tableView];
        self.calloutView.hidden = YES;
        
        [self addSubview:self.pinView];
        [self addSubview:self.calloutView];
        self.frame = [self calculateFrame];
        self.calloutView.layer.borderWidth = 1.0f;
        self.layer.cornerRadius = 3.0f;
        self.calloutView.layer.borderColor = [UIColor whiteColor].CGColor;
        if (_hasCalloutView) {
            if (self.settings.shouldRoundifyCallout) {
                [self roundifyCallout];
            }
        }
        [self positionSubviews];
    }
    return self;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:
                          CGRectMake(0, 0, tableView.frame.size.width, 120)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10,
                                                               headerView.frame.size.width, 20)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor darkGrayColor];
    label.font = [UIFont systemFontOfSize:10];
    [label setText:@"CURRENT IP LOCATION"];
    [headerView addSubview:label];

    [headerView setBackgroundColor:[UIColor colorWithRed:245.0/255.0
                                                   green:245.0/255.0 blue:245.0/255.0 alpha:1]];
    
    UILabel *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 25,
                                                               headerView.frame.size.width, 70)];
    locationLabel.textAlignment = NSTextAlignmentCenter;
    locationLabel.textColor = [UIColor brownColor];
    locationLabel.font = [UIFont systemFontOfSize:24];
    [self getLocationName:locationLabel];
    
    [headerView addSubview:locationLabel];

    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake
                       (0, 95, headerView.frame.size.width, 25)];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.textColor = [UIColor whiteColor];
    label1.font = [UIFont boldSystemFontOfSize:12];
    [label1 setBackgroundColor:[UIColor colorWithRed:210.0/255.0
                                               green:210.0/255.0 blue:210.0/255.0 alpha:1]];
    [label1 setText:@"DISCONNECTED"];
    [headerView addSubview:label1];

    return  headerView;
}

- (void)getLocationName:(UILabel *)label
{
    CLGeocoder *ceo = [[CLGeocoder alloc]init];
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:sdmAnnotation.annotationLatitude
                                                longitude:sdmAnnotation.annotationLongitude];
    
    [ceo reverseGeocodeLocation: loc completionHandler:
     ^(NSArray *placemarks, NSError *error) {
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
         NSLog(@"placemark %@",placemark);
         //String to hold address
         NSLog(@"placemark %@",placemark.country);  // Give Country Name
         label.text = placemark.country;
     }];
}

- (nullable UIView *)tableView:(UITableView *)tableView
        viewForFooterInSection:(NSInteger)section;
{
    UIView *footerView = [[UIView alloc] initWithFrame:
                          CGRectMake(0, 0, tableView.frame.size.width, 85)];
    [footerView setBackgroundColor:[UIColor colorWithRed:245.0/255.0
                                                   green:245.0/255.0 blue:245.0/255.0 alpha:1]];

    UIView *blueView = [[UIView alloc] initWithFrame:
                          CGRectMake(10, 10, tableView.frame.size.width-20, 85)];
    [blueView setBackgroundColor:[UIColor colorWithRed:71.0/255.0
                                                   green:185.0/255.0 blue:227.0/255.0 alpha:1]];
    
    
    UILabel *serviceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 2,
                                                               blueView.frame.size.width, 30)];
    serviceLabel.textAlignment = NSTextAlignmentCenter;
    serviceLabel.textColor = [UIColor whiteColor];
    serviceLabel.numberOfLines = 2;
    serviceLabel.font = [UIFont systemFontOfSize:11];
    [serviceLabel setText:@"duesterwald.mobileactivedefense.com"];
    [blueView addSubview:serviceLabel];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 35,
                                                               blueView.frame.size.width, 20)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:16];
    [label setText:@"Connect"];
    [blueView addSubview:label];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, label.frame.size.height + 40,
                                                               blueView.frame.size.width, 15)];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.textColor = [UIColor blackColor];
    label1.font = [UIFont systemFontOfSize:11];
    
    CLGeocoder *ceo = [[CLGeocoder alloc]init];
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:sdmAnnotation.annotationLatitude
                                                longitude:sdmAnnotation.annotationLongitude];
    
    [ceo reverseGeocodeLocation: loc completionHandler:
     ^(NSArray *placemarks, NSError *error) {
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
         [label1 setText:placemark.administrativeArea];
     }];

    [blueView addSubview:label1];
    
    [footerView addSubview:blueView];
    
    return  footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 85;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 120.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:
(NSInteger)section {
    return [dataArray count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
(NSIndexPath *)indexPath {
    AnnotationTableViewCell *cell = (AnnotationTableViewCell *)
    [tableView dequeueReusableCellWithIdentifier:annoationTableViewCellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLabel.text = dataArray[indexPath.row];
    cell.logoImageView.image = [UIImage imageNamed:@"annotation"];
    if (indexPath.row == 2) {
        cell.detailLabel.text = @"duesterwald.mobileactivedefense.com";
    }
    else{
        cell.detailLabel.text = [UIUtils getIPAddress];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (CGRect)calculateFrame {
    return self.pinView.bounds;
}

- (void)positionSubviews {
    self.pinView.center = self.center;
    if (_hasCalloutView) {
        CGRect frame = self.calloutView.frame;
        frame.origin.y = -frame.size.height - self.settings.calloutOffset;
        frame.origin.x = (self.frame.size.width - frame.size.width) / 2.0;
        self.calloutView.frame = frame;
    }
}

- (void)roundifyCallout {
    self.calloutView.layer.cornerRadius = self.settings.calloutCornerRadius;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_hasCalloutView) {
        UITouch *touch = [touches anyObject];
        // toggle visibility
        if (touch.view == self.pinView) {
            if (self.calloutView.isHidden) {
                [self showCalloutView];
            } else {
                [self hideCalloutView];
            }
        } else if (touch.view == self.calloutView) {
            [self showCalloutView];
        } else {
            [self hideCalloutView];
        }
    }
}

- (void)hideCalloutView {
    if (_hasCalloutView) {
        if (!self.calloutView.isHidden) {
            switch (self.settings.animationType) {
                case SDMCalloutAnimationNone: {
                    self.calloutView.hidden = YES;
                } break;
                case SDMCalloutAnimationZoomIn: {
                    self.calloutView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                    [UIView animateWithDuration:self.settings.animationDuration animations:^{
                        self.calloutView.transform = CGAffineTransformMakeScale(0.25, 0.25);
                    } completion:^(BOOL finished) {
                        self.calloutView.hidden = YES;
                    }];
                } break;
                case SDMCalloutAnimationFadeIn: {
                    self.calloutView.alpha = 1.0;
                    [UIView animateWithDuration:self.settings.animationDuration animations:^{
                        self.calloutView.alpha = 0.0;
                    } completion:^(BOOL finished) {
                        self.calloutView.hidden = YES;
                    }];
                } break;
                default: {
                    self.calloutView.hidden = YES;
                } break;
            }
        }
    }
}

- (void)showCalloutView {
    if (_hasCalloutView) {
        if (self.calloutView.isHidden) {
            switch (self.settings.animationType) {
                case SDMCalloutAnimationNone: {
                    self.calloutView.hidden = NO;
                } break;
                case SDMCalloutAnimationZoomIn: {
                    self.calloutView.transform = CGAffineTransformMakeScale(0.025, 0.25);
                    self.calloutView.hidden = NO;
                    [UIView animateWithDuration:self.settings.animationDuration animations:^{
                        self.calloutView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                    } completion:nil];
                } break;
                case SDMCalloutAnimationFadeIn: {
                    self.calloutView.alpha = 0.0;
                    self.calloutView.hidden = NO;
                    [UIView animateWithDuration:self.settings.animationDuration animations:^{
                        self.calloutView.alpha = 1.0;
                    } completion:nil];
                } break;
                default: {
                    self.calloutView.hidden = NO;
                } break;
            }
        }
    }
}

#pragma mark - validate settings -

- (void)validateSettings:(SDMMapSettings *)settings {
    NSAssert(settings.calloutOffset >= 5.0, @"settings.calloutOffset should be atleast 5.0");
    if (settings.shouldRoundifyCallout) {
        NSAssert(settings.calloutCornerRadius >= 3.0, @"settings.calloutCornerRadius should be atleast 3.0");
    }
    
    if (settings.animationType != SDMCalloutAnimationNone) {
        NSAssert(settings.animationDuration > 0.0, @"settings.animationDuration should be greater than zero");
    }
    
    self.settings = settings;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitView = [super hitTest:point withEvent:event];
    if (hitView == self)
        return nil;
    return hitView;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    BOOL isCallout = (CGRectContainsPoint(self.calloutView.frame, point));
    BOOL isPin = (CGRectContainsPoint(self.pinView.frame, point));
    return isCallout || isPin;
}

#pragma mark - PinView

- (void)setPinView:(UIView *)pinView {
    //Removing old pinView
    [_pinView removeFromSuperview];
    
    //Adding new pinView to the view's hierachy
    _pinView = pinView;
    [self addSubview:_pinView];
    
    //Position the new pinView
    self.frame = [self calculateFrame];
    self.pinView.center = self.center;
}

- (void)setCalloutView:(UIView *)calloutView {
    //Removing old calloutView
    [_calloutView removeFromSuperview];
    
    //Adding new calloutView to the view's hierachy
    _calloutView = calloutView;
    [self addSubview:_calloutView];
    
    self.calloutView.hidden = YES;
    
    //Adding Border
    if (_hasCalloutView) {
        if (self.settings.shouldRoundifyCallout) {
            [self roundifyCallout];
        }
    }
    [self positionSubviews];
    
}

@end
