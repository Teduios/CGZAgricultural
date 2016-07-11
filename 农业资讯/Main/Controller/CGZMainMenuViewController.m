//
//  CGZMainMenuViewController.m
//  农业资讯
//
//  Created by Tarena on 16/6/23.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import "CGZMainMenuViewController.h"
#import "CGZClassifyCell.h"
#import "CGZTechnicalClassification.h"
#import "CGZDataManager.h"
#import "CGZTechListViewController.h"

@interface CGZMainMenuViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSArray *dataArray;
@property (weak, nonatomic) IBOutlet UIImageView *backgrounpImage;

@end

@implementation CGZMainMenuViewController

- (IBAction)showLeftMenu:(id)sender {
    [self.sideMenuViewController presentLeftMenuViewController];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTableview];
    self.dataArray = [CGZDataManager getClassifyData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIImageView setBackGroundImageView:self.backgrounpImage];
}
#pragma mark -- 和tableview相关的方法
- (void)setTableview {
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.estimatedRowHeight = 80;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGZTechnicalClassification *classlify = self.dataArray[indexPath.row];
    CGZClassifyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"classlifyCell" forIndexPath:indexPath];
    cell.nameLabel.text = classlify.name;
    cell.titleLabel.text = classlify.title;
    cell.descriptionLabel.text = classlify.content;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CGZTechnicalClassification *classlify = self.dataArray[indexPath.row];
    [self performSegueWithIdentifier:@"techList" sender:classlify];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    CGZTechListViewController *listController = segue.destinationViewController;
    CGZTechnicalClassification *classlify = sender;
    listController.ID = [classlify.ID intValue];
    listController.ListTitle = classlify.name;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
