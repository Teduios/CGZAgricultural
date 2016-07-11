//
//  CGZTechListViewController.m
//  农业资讯
//
//  Created by Tarena on 16/6/25.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import "CGZTechListViewController.h"
#import "CGZListCell.h"
#import "CGZTechList.h"
#import "UIImageView+WebCache.h"
#import "UIScrollView+Refresh.h"
#import "CGZTechNewsViewController.h"
#import "CGZBaseNaviController.h"

@interface CGZTechListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSMutableArray *listData;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,assign) int page;
@property (weak, nonatomic) IBOutlet UIImageView *backgrounpImage;

@end

@implementation CGZTechListViewController

- (NSMutableArray*)listData {
    if (_listData == nil) {
        _listData = [NSMutableArray array];
    }
    return _listData;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNetworkingParam];
    [self setListTableView];
    [self addRefresh];
    [self setNavigation];
    [UIImageView setBackGroundImageView:self.backgrounpImage];
}
- (void)setNetworkingParam {
    if (self.page == 1) {
        [self.listData removeAllObjects];
    }
    [CGZNetworkingTool sharedNetworkTool].urlPostfix = [NSString stringWithFormat:@"?id=%d&rows=10",self.ID];
    [[CGZNetworkingTool sharedNetworkTool]getTechListData:^(NSArray *classifyData) {
        [self.listData addObjectsFromArray:classifyData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        [self.tableView endFooterRefresh];
        [self.tableView endHeaderRefresh];
    }];
}
- (void)setNavigation {
    self.navigationItem.title = self.ListTitle;
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(backChick)];
    self.navigationItem.leftBarButtonItem = barItem;
}
- (void)backChick {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- 与刷新控件相关的方法
- (void)addRefresh {
    __weak typeof(CGZTechListViewController) *tlvc = self;
    [self.tableView addHeaderRefresh:^{
        tlvc.page = 1;
        [tlvc setNetworkingParam];
    }];
    [tlvc.tableView beginHeaderRefresh];
    [tlvc.tableView addAutoFooterRefresh:^{
        tlvc.page ++;
        [tlvc setNetworkingParam];
    }];
}
#pragma mark -- 与tableview相关的方法
- (void)setListTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.listData.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGZListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listCell" forIndexPath:indexPath];
    CGZTechList *techList = self.listData[indexPath.row];
    cell.titleLabel.text = techList.title;
    cell.contentTextView.text = techList.content;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://tnfs.tngou.net/image%@",techList.img]];
    [cell.imageUrl sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"background0"]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CGZBaseNaviController *navi = [self.storyboard instantiateViewControllerWithIdentifier:@"techNew"];
    CGZTechNewsViewController *tnvc = (CGZTechNewsViewController*)navi.topViewController;
    CGZTechList *techList = self.listData[indexPath.row];
    tnvc.ID = [techList.ID intValue];
    [self presentViewController:navi animated:YES completion:nil];
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
