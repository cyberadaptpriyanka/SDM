//
//  PickerView.m
//  scope
//
//  Created by Priyanka Pundru. on 8/25/16.
//  Copyright © 2016 Digisight Technologies Inc. All rights reserved.
//

#import "PickerView.h"

@interface PickerView () <UIPickerViewDataSource, UIPickerViewDelegate>
{
    NSArray *dataArray;
    UIPickerView *pickerView;
}
@end

@implementation PickerView

//PickerView Initializer with pickerType and dataArray to be displayed
- (id)initWithDelegate:(id<PickerViewDelegate>)delegate  pickerArray:(NSArray *)pickerArray
{
    if ((self = [super init])) {
        dataArray = [[NSArray alloc] initWithArray:pickerArray];
        self.pickerViewDelegate = delegate;
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setDataSource:self];
        [self setDelegate:self];
        self.showsSelectionIndicator = YES;
    }
    
    return self;
}

#pragma mark - UIPickerView DataSource
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    return [dataArray count];
}

#pragma mark - UIPickerView Delegate

// these methods return  NSString to display the row for the component.
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return dataArray[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component {
    if ([self.pickerViewDelegate respondsToSelector:@selector(selectedPickerWithRow:inComponent:)]) {
        [self.pickerViewDelegate selectedPickerWithRow:row inComponent:component];
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel* titleLabel = (UILabel*)view;
    if (!titleLabel){
        titleLabel = [[UILabel alloc] init];
        titleLabel.adjustsFontSizeToFitWidth = YES;
        titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    titleLabel.text = dataArray[row];
    
    return titleLabel;
}

@end
