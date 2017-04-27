//
//  SDMImageLabel.h
//  SDM app
//
//  Copyright © 2017 Priyanka Pundru. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface SDMImageLabel : UIView

@property (strong, nonatomic, readonly) UILabel *textLabel;
@property (strong, nonatomic, readonly) UIImageView *imageView;

@property (assign, nonatomic) CGFloat space;

@end
