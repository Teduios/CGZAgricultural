//
//  CGZTechNewsViewController.m
//  农业资讯
//
//  Created by Tarena on 16/6/26.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import "CGZTechNewsViewController.h"
#import "CGZTechNews.h"
#import "CGZNewsCell.h"
#import "UIImageView+WebCache.h"
#import "UIScrollView+Refresh.h"
#import "CGZNewsDetailViewController.h"

@interface CGZTechNewsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSMutableArray *newsArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,assign) int page;
@property (weak, nonatomic) IBOutlet UIImageView *backgrounpImage;

@end

@implementation CGZTechNewsViewController
- (NSMutableArray*)newsArray {
    if (_newsArray == nil) {
        _newsArray = [NSMutableArray array];
    }
    return _newsArray;
}
- (IBAction)backBtnChick:(id)sender {
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getNetworkingData];
    [self setNewTableView];
    [self addRefresh];
//    self.page = self.ID;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIImageView setBackGroundImageView:self.backgrounpImage];
    
}
#pragma mark -- 与刷新控件相关的方法
- (void)addRefresh {
    __weak typeof(CGZTechNewsViewController) *vc = self;
    [self.tableView addHeaderRefresh:^{
        vc.page = vc.ID;
        [vc getNetworkingData];
    }];
    [self.tableView beginHeaderRefresh];
    [self.tableView addAutoFooterRefresh:^{
        vc.page ++;
        [vc getNetworkingData];
    }];
}
#pragma mark -- 与网络相关的方法
- (void)getNetworkingData {
    [CGZNetworkingTool sharedNetworkTool].urlPostfix = [NSString stringWithFormat:@"?id=%d&rows=10",self.page];
    [[CGZNetworkingTool sharedNetworkTool] getTechNewsData:^(NSArray *classifyData) {
        //数组元素清零要放在此处，防止主线程在更新数据时，这边数据还没添加完，会造成数组越界
        if (self.page == self.ID) {
            [self.newsArray removeAllObjects];
        }
        [self.newsArray addObjectsFromArray:classifyData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.tableView endFooterRefresh];
            [self.tableView endHeaderRefresh];
        });
    }];
}

#pragma mark -- 和tableview相关的方法
- (void)setNewTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.newsArray.count;
}
static void *keycontent = &keycontent;
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newsCell" forIndexPath:indexPath];
    CGZTechNews *techNew = self.newsArray[indexPath.row];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://tnfs.tngou.net/image%@",techNew.img]];
    [cell.imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"background0"]];
    cell.textLabel.text = techNew.title;
    return cell;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (context == keycontent) {
        UIImageView *imageView = object;
//        [imageView setValue:[NSValue valueWithCGRect:CGRectMake(0, 0, 44, 44)] forKey:@"frame"];
        CGRect newRect = CGRectMake(10, 10, 40, 40);
        if (!CGRectEqualToRect(imageView.frame, newRect)) {
            imageView.frame = newRect;
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CGZTechNews *techNew = self.newsArray[indexPath.row];
    [self performSegueWithIdentifier:@"detailSegue" sender:techNew];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[CGZNewsDetailViewController class]]) {
        CGZNewsDetailViewController *newsDetail = segue.destinationViewController;
        CGZTechNews *techNew = sender;
        newsDetail.techNew = techNew;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell.imageView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionOld context:keycontent];
}
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell.imageView removeObserver:self forKeyPath:@"frame"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc {
    NSArray *cells = [self.tableView visibleCells];
    for (UITableViewCell *cell in cells) {
        [cell.imageView removeObserver:self forKeyPath:@"frame"];
           }
//    NSLog(@"texhNew被销毁了");
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
