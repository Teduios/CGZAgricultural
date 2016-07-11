//
//  CGZLeftViewController.m
//  农业资讯
//
//  Created by Tarena on 16/6/23.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import "CGZLeftViewController.h"
#import "CGZDataManager.h"
#import "CGZMenu.h"
#import "CGZTechnicalClassification.h"
#import "CGZBaseNaviController.h"
#import "CGZTechListViewController.h"
#import "CGZTechNewsViewController.h"
#import "CGZTechList.h"
#import "CGZBaseNaviController.h"
#import "CGZBaseTabBarViewController.h"
#import "CGZMainMenuViewController.h"
#import "CGSetUpTableViewController.h"

@interface CGZLeftViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *menuTableView;
@property (weak, nonatomic) IBOutlet UITableView *classlifyTableView;
@property (nonatomic,strong) NSArray *menuArray;
@property (nonatomic,strong) NSArray *classArray;
@property (weak, nonatomic) IBOutlet UIImageView *backgrounpImage;

@end

@implementation CGZLeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTableView];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIImageView setBackGroundImageView:self.backgrounpImage];
}
#pragma mark -- 与tableview相关的方法
- (void)setTableView {
    self.menuTableView.delegate = self;
    self.menuTableView.dataSource = self;
    self.menuArray = [CGZDataManager getMenuData];
    self.classlifyTableView.delegate = self;
    self.classlifyTableView.dataSource = self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.menuTableView) {
        return self.menuArray.count;
    } else {
        return self.classArray.count;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.menuTableView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"menuCell" forIndexPath:indexPath];
        CGZMenu *menu = self.menuArray[indexPath.row];
        cell.textLabel.text = menu.title;
        cell.imageView.image = [UIImage imageNamed:menu.imageName];
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"classCell" forIndexPath:indexPath];
        CGZTechnicalClassification *classlify = self.classArray[indexPath.row];
        cell.textLabel.text = classlify.name;
        return cell;
    }
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == self.menuTableView) {
        switch (indexPath.row) {
            case 0:
            {
                self.classArray = [CGZDataManager getClassifyData];
                [self.classlifyTableView reloadData];
                break;
            }
            case 1:
            {
                self.classArray = nil;
                [self.classlifyTableView reloadData];
                CGZBaseNaviController *navi = [self.storyboard instantiateViewControllerWithIdentifier:@"weather"];
                [self presentViewController:navi animated:YES completion:nil];
                break;
            }
            case 2:
            {
                self.classArray = nil;
                [self.classlifyTableView reloadData];
                CGZBaseNaviController *navi = [self.storyboard instantiateViewControllerWithIdentifier:@"collect"];
                [self presentViewController:navi animated:YES completion:nil];
                [self.sideMenuViewController hideMenuViewController];
                break;
            }
            default:
                self.classArray = nil;
                [self.classlifyTableView reloadData];
                CGZBaseNaviController *navi = [self.storyboard instantiateViewControllerWithIdentifier:@"setting"];
                [self presentViewController:navi animated:YES completion:nil];
                [self.sideMenuViewController hideMenuViewController];
                break;
        }
    } else {
//        NSIndexPath *menuIndexPath = [self.menuTableView indexPathForSelectedRow];
//        if (menuIndexPath.row == 1) {
//            CGZTechListViewController *listController = [self.storyboard instantiateViewControllerWithIdentifier:@"techList"];
//            CGZBaseNaviController *navi = [[CGZBaseNaviController alloc]initWithRootViewController:listController];
//            CGZTechnicalClassification *classlify = self.classArray[indexPath.row];
//            listController.ID = [classlify.ID intValue];
//            listController.ListTitle = classlify.name;
//            [self presentViewController:navi animated:YES completion:nil];
//            [self.sideMenuViewController hideMenuViewController];
//        } else if(menuIndexPath.row == 2) {
            CGZBaseNaviController *navi = [self.storyboard instantiateViewControllerWithIdentifier:@"techNew"];
            CGZTechNewsViewController *newController = (CGZTechNewsViewController*)navi.topViewController;
            CGZTechnicalClassification *classlify = self.classArray[indexPath.row];
            [CGZNetworkingTool sharedNetworkTool].urlPostfix = [NSString stringWithFormat:@"?id=%d&rows=10",[classlify.ID intValue]];
            NSLog(@"%d",[classlify.ID intValue]);
            [[CGZNetworkingTool sharedNetworkTool]getTechListData:^(NSArray *classifyData) {
                CGZTechList *techList = classifyData[9];
                newController.ID = [techList.ID intValue];
                NSLog(@"%d",newController.ID);
                [self presentViewController:navi animated:YES completion:nil];
            }];
            [self.sideMenuViewController hideMenuViewController];
//        }
    }
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
