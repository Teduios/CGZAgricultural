//
//  CGZCityTableViewController.m
//  农业资讯
//
//  Created by happy on 16/6/28.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import "CGZCityTableViewController.h"
#import "CGZDataManager.h"
#import "CGZCity.h"
#import "MBProgressHUD+KR.h"

@interface CGZCityTableViewController ()<UISearchBarDelegate>
@property (nonatomic,strong) NSArray *cityDataArray;
@end

@implementation CGZCityTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //注册单元格
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.cityDataArray = [CGZDataManager getAllCitiesData];
    [self setupBarItem];
}
- (void)setupBarItem {
    UISearchBar *bar = [[UISearchBar alloc]init];
    bar.placeholder = @"请输入省名、城市名";
    bar.delegate = self;
    self.navigationItem.titleView = bar;
    //item
    UIBarButtonItem *fakeItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.rightBarButtonItem = fakeItem;
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    NSMutableArray *array = [NSMutableArray array];
    for (CGZCity *city in self.cityDataArray) {
        if ([city.city isEqualToString:searchBar.text] || [city.prov isEqualToString:searchBar.text]) {
            [array addObject:city];
        }
    }
    if (array.count > 0) {
        self.cityDataArray = array;
        [self.tableView reloadData];
    } else {
        [MBProgressHUD showError:@"没有对应的省市,请重新输入"];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CGZCity *city = self.cityDataArray[indexPath.row];
    [self.delegate cityTableView:city];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cityDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    CGZCity *city = self.cityDataArray[indexPath.row];
    cell.textLabel.text = city.city;
    return cell;
}

//- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//    
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
