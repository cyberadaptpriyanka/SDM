//
//  PickerView.h
//
//

#import <UIKit/UIKit.h>

@protocol PickerViewDelegate <NSObject>

- (void)selectedPickerWithRow:(NSInteger)row inComponent:(NSInteger)component;

@end

@interface PickerView : UIPickerView

@property (nonatomic, assign) NSObject <PickerViewDelegate> *pickerViewDelegate;

- (id)initWithDelegate:(id<PickerViewDelegate>)delegate pickerArray:(NSArray *)pickerArray;

@end
