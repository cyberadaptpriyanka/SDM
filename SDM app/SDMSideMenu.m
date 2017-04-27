
//
//  SDMSideMenu.h
//  SDM app
//
//  Created by Priyanka Pundru on 3/23/17.
//  Copyright © 2017 Priyanka Pundru. All rights reserved.
//

#import "SDMSideMenu.h"

@implementation SDMSideMenuItem

@synthesize icon;
@synthesize title;
@synthesize tag;

@end

@interface SDMSideMenu() <UITableViewDelegate, UITableViewDataSource>
{
    UITapGestureRecognizer *tapGesture;
}

@property (nonatomic, strong) UIView *overlay;

@end

@implementation SDMSideMenu

#pragma mark - Initialization

-(instancetype)initWithSize:(CGFloat)size
{
    if (self = [super init])
    {
        [self baseInit];
        self.size = size;
    }
    
    return self;
}

-(void)baseInit
{
    self.size = 180;
    self.rowHeight = 60;
    
    self.sectionTitleFont = [UIFont systemFontOfSize:15.];
    self.selectionColor = [UIColor colorWithWhite:1. alpha:.5];
    self.textColor = [UIColor whiteColor];
    self.iconsColor = [UIColor whiteColor];
    self.sectionTitleColor = [UIColor whiteColor];
}

-(void)initViews
{
    // Setup overlay
    self.overlay = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.overlay.alpha = 0;
    self.overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.overlay.backgroundColor = [UIColor colorWithWhite:0. alpha:.4];
    
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                         action:@selector(didTap:)];
    [self.overlay addGestureRecognizer:tapGesture];
    
    CGRect frame = [self frameHidden];
    
    self.view = [[UIView alloc] init];
    self.view.frame = frame;
    [self.view setBackgroundColor:[UIColor blackColor]];
    // Setup content table view
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                  style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.backgroundColor  = [UIColor clearColor];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.view addSubview:self.tableView];
}

#pragma mark - Appearance

-(void)show
{
    [self initViews];
   UIViewController *viewController = [[[[UIApplication sharedApplication]
                                         delegate] window] rootViewController];
    [viewController.view addSubview:self.overlay];
    [viewController.view addSubview:self.view];
    
    CGRect frame = [self frameShowed];
    
    [UIView animateWithDuration:0.275 animations:^
     {
         self.view.frame = frame;
         self.overlay.alpha = 1.0;
     } completion:^(BOOL finished)
     {
         if (_delegate && [_delegate respondsToSelector:
                           @selector(sideMenuDidShow:)])
             [_delegate sideMenuDidShow:self];
     }];
}

-(void)showWithSize:(CGFloat)size
{
    self.size = size;
    [self show];
}

-(void)hide
{
    [UIView animateWithDuration:0.275 animations:^
     {
         self.view.frame = [self frameHidden];
         self.overlay.alpha = 0.;
     }completion:^(BOOL finished)
     {
         if (_delegate && [_delegate respondsToSelector:@selector(sideMenuDidHide:)])
             [_delegate sideMenuDidHide:self];
         
         [self.view removeFromSuperview];
         [self.overlay removeFromSuperview];
         [self.overlay removeGestureRecognizer:tapGesture];
         self.overlay = nil;
         self.tableView = nil;
         self.view = nil;
     }];
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataSource numberOfSectionsInSideMenu:self];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource sideMenu:self numberOfRowsInSection:section];
}

//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *cellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    
//    UIImageView *imageViewIcon;
//    UILabel *titleLabel;
//    if (cell == nil)
//    {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
//                                     reuseIdentifier:cellIdentifier];
//        cell.backgroundColor = [UIColor clearColor];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
//    
//    SDMSideMenuItem *item = [self.dataSource sideMenu:self
//                                itemForRowAtIndexPath:indexPath];
//    
//    CGFloat contentHeight = cell.frame.size.height * .8;
//    CGFloat contentTopBottomPadding = cell.frame.size.height * .1;
//    
//    if (item.icon)
//    {
//        imageViewIcon = [cell.contentView viewWithTag:100];
//        
//        if (!imageViewIcon)
//        {
//            imageViewIcon = [[UIImageView alloc] initWithFrame:CGRectMake(12, contentTopBottomPadding, contentHeight, contentHeight)];
//            imageViewIcon.tag = 100;
//            [cell.contentView addSubview:imageViewIcon];
//        }
//        
//        imageViewIcon.image = item.icon;
//        
//        if (self.iconsColor)
//        {
//            imageViewIcon.image = [imageViewIcon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//            imageViewIcon.tintColor = self.iconsColor;
//        }
//    }
//    
//    titleLabel = [cell.contentView viewWithTag:200];
//    
//    if (!titleLabel)
//    {
//        CGFloat titleX = item.icon ? CGRectGetMaxX(imageViewIcon.frame) + 12 : 12;
//        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleX, contentTopBottomPadding, cell.frame.size.width - titleX - 15, contentHeight)];
//        titleLabel.tag = 200;
//        titleLabel.font = [UIFont systemFontOfSize:18.0];
//        titleLabel.adjustsFontSizeToFitWidth = YES;
//        [cell.contentView addSubview:titleLabel];
//    }
//    
//    titleLabel.text = item.title;
//    titleLabel.textColor = self.textColor;
//    
//    return cell;
//}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.arrayForBool replaceObjectAtIndex:indexPath.section withObject:[NSNumber numberWithBool:NO]];
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];

    if (_delegate && [_delegate respondsToSelector:@selector(sideMenu:didSelectRowAtIndexPath:)])
        [_delegate sideMenu:self didSelectRowAtIndexPath:indexPath];
    
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
        [self hide];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.rowHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sideMenu:titleForHeaderInSection:)])
        return [self.delegate sideMenu:self titleForHeaderInSection:section].uppercaseString;
    
    return nil;
}

#pragma mark - GestureRecognition

-(void)addSwipeGestureRecognition:(UIView *)view
{
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]
                                       initWithTarget:self action:@selector(didSwap:)];
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [view addGestureRecognizer:swipe];
}

-(void)didTap:(UIGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded)
        [self hide];
}

-(void)didSwap:(UISwipeGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded)
        [self showWithSize:self.size];
}

#pragma mark - Helpers

-(CGRect)frameHidden
{
    CGRect frame = CGRectZero;
    
    frame = CGRectMake(-self.size, 0, self.size,
                       [UIScreen mainScreen].bounds.size.height);
    return frame;
}

-(CGRect)frameShowed
{
    CGRect frame = self.view.frame;
    frame.origin.x = 0;
    return frame;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellid=@"hello";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
    }
    
    BOOL manyCells  = [[self.arrayForBool objectAtIndex:indexPath.section] boolValue];
    
    if(!manyCells)
    {
        cell.backgroundColor=[UIColor clearColor];
        cell.textLabel.text=@"";
    }
    else
    {
        cell.textLabel.text = @"Help Desk";
        cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
        cell.backgroundColor = [UIColor blackColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    }
    cell.textLabel.textColor=[UIColor whiteColor];
    
//    /********** Add a custom Separator with cell *******************/
//    UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(15, 40, self.tableView.frame.size.width-15, 1)];
//    separatorLineView.backgroundColor = [UIColor blackColor];
//    [cell.contentView addSubview:separatorLineView];
    
    return cell;
}

#pragma mark - Creating View for TableView Section

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 280,40)];
    sectionView.tag=section;
    UILabel *viewLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, self.tableView.frame.size.width-10, 40)];
    viewLabel.backgroundColor=[UIColor clearColor];
    viewLabel.textColor=[UIColor whiteColor];
    viewLabel.font=[UIFont systemFontOfSize:15];
    viewLabel.text=[_menuItemsArray objectAtIndex:section];
    [sectionView addSubview:viewLabel];
    
    UITapGestureRecognizer  *headerTapped = [[UITapGestureRecognizer alloc]
                                               initWithTarget:self action:@selector(sectionHeaderTapped:)];
    [sectionView addGestureRecognizer:headerTapped];
    
    return  sectionView;
}

#pragma mark - Table header gesture tapped

- (void)sectionHeaderTapped:(UITapGestureRecognizer *)gestureRecognizer{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0
                                                inSection:gestureRecognizer.view.tag];

        BOOL collapsed  = [[self.arrayForBool objectAtIndex:indexPath.section] boolValue];
        for (int i=0; i<[self.menuItemsArray count]; i++) {
            if (indexPath.section==i) {
                [self.arrayForBool replaceObjectAtIndex:i
                                             withObject:[NSNumber numberWithBool:!collapsed]];
            }
        }
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:gestureRecognizer.view.tag] withRowAnimation:UITableViewRowAnimationAutomatic];

    if ( !(indexPath.section == 2)) {
        [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
    }
}

@end
