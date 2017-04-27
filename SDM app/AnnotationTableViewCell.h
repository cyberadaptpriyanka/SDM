//
//  AnnotationTableViewCell.h
//  SDM app
//
//  Copyright © 2017 Priyanka Pundru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnnotationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

@end
