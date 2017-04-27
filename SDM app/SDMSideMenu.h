
//
//  SDMSideMenu.h
//  SDM app
//
//  Created by Priyanka Pundru on 3/23/17.
//  Copyright © 2017 Priyanka Pundru. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SDMSideMenu, SDMSideMenuItem;
@protocol SDMSideMenuDataSource <NSObject>

@required
-(NSInteger)numberOfSectionsInSideMenu:(SDMSideMenu *)sideMenu;
-(NSInteger)sideMenu:(SDMSideMenu *)sideMenu numberOfRowsInSection:(NSInteger)section;
-(SDMSideMenuItem *)sideMenu:(SDMSideMenu *)sideMenu itemForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@class SDMSideMenu, SDMSideMenuItem;
@protocol SDMSideMenuDelegate <NSObject>

@optional
- (void)sideMenuDidShow:(SDMSideMenu *)sideMenu;
- (void)sideMenuDidHide:(SDMSideMenu *)sideMenu;
- (void)sideMenu:(SDMSideMenu *)sideMenu didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSString *)sideMenu:(SDMSideMenu *)sideMenu titleForHeaderInSection:(NSInteger)section;

@end

@interface SDMSideMenuItem : NSObject

@property (nonatomic, strong) UIImage  *icon;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) NSInteger *tag;

@end

@interface SDMSideMenu : NSObject

-(instancetype)initWithSize:(CGFloat)size;
@property (nonatomic, strong) id <SDMSideMenuDelegate> delegate;

@property (nonatomic, strong) id <SDMSideMenuDataSource> dataSource;
@property (nonatomic, assign) CGFloat size;

@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) NSArray *menuItemsArray;
@property (nonatomic, strong) NSMutableArray *arrayForBool;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) CGFloat rowHeight;
@property (nonatomic, strong) UIColor *selectionColor;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIFont *sectionTitleFont;
@property (nonatomic, strong) UIColor *sectionTitleColor;
@property (nonatomic, strong) UIColor *iconsColor;

-(void)addSwipeGestureRecognition:(UIView *)view;
-(void)show;
-(void)showWithSize:(CGFloat)size;
-(void)hide;

@end
