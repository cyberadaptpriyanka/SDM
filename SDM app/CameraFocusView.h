//
//  CameraFocusView.h
//  SDM app
//
//  Copyright © 2017 Priyanka Pundru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CameraFocusView : UIView

- (instancetype)initWithTouchPoint:(CGPoint)touchPoint;
- (void)updatePoint:(CGPoint)touchPoint;
- (void)animateFocusingAction;

@end
