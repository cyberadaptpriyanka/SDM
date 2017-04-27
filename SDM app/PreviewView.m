//
//  PreviewView.m
//  SDM app
//
//  Copyright © 2017 Priyanka Pundru. All rights reserved.
//

#import "PreviewView.h"
#import "CameraFocusView.h"

@implementation PreviewView {
    CameraFocusView *_focusSquare;
}

- (IBAction)tapToFocus:(UITapGestureRecognizer *)gestureRecognizer {
    CGPoint touchPoint = [gestureRecognizer locationOfTouch:0 inView:self];
    if (!_focusSquare) {
        _focusSquare = [[CameraFocusView alloc] initWithTouchPoint:touchPoint];
        [self addSubview:_focusSquare];
        [_focusSquare setNeedsDisplay];
    }
    else {
        [_focusSquare updatePoint:touchPoint];
    }
    [_focusSquare animateFocusingAction];
}


@end
