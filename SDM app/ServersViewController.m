//
//  ServersViewController.m
//  SDM app
//
//  Copyright © 2017 Priyanka Pundru. All rights reserved.
//

#import "ServersViewController.h"
#import "SDMConstants.h"
#import "ServerTableViewCell.h"

static NSString *serverTableViewCellIdentifier = @"ServerTableViewCell";

@interface ServersViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *settingTableView;
@property (strong, nonatomic) NSArray *dataSource;
@end

@implementation ServersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   // _dataSource = @[@"Help Desk"];
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.navigationController setNavigationBarHidden:NO];
    self.settingTableView.tableFooterView = footerView;
    [self.settingTableView registerNib:[UINib nibWithNibName:@"ServerTableViewCell"
                                               bundle:nil] forCellReuseIdentifier:serverTableViewCellIdentifier];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeButtonTapped:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ServerTableViewCell *cell = (ServerTableViewCell *)
    [tableView dequeueReusableCellWithIdentifier:serverTableViewCellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;

    if (indexPath.row % 3 == 0) {
        [cell.timeLabel setBackgroundColor:[UIColor greenColor]];
    }else if (indexPath.row % 3 == 1){
        [cell.timeLabel setBackgroundColor:[UIColor yellowColor]];
    }
    else{
        [cell.timeLabel setBackgroundColor:[UIColor grayColor]];
    }
//    static NSString *cellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    
//    if (cell == nil)
//    {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
//                                      reuseIdentifier:cellIdentifier];
//        cell.backgroundColor = [UIColor clearColor];
//    }
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//
//    cell.textLabel.text = _dataSource [indexPath.row];
//    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UILabel *sectionLabel = [[UILabel alloc ] initWithFrame:
                             CGRectMake(5, 0, tableView.frame.size.width, 40.0f)];
    [sectionLabel setBackgroundColor:RGBCOLOR(239.0, 239.0, 244.0)];
    sectionLabel.text = @"Servers";
    [sectionLabel setFont:[UIFont systemFontOfSize:14]];
    [sectionLabel setTextColor:[UIColor darkGrayColor]];
    return  sectionLabel;
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

@end
