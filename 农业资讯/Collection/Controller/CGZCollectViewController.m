//
//  CGZCollectViewController.m
//  农业资讯
//
//  Created by happy on 16/7/1.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import "CGZCollectViewController.h"
#import "CGZTechNewSqlite.h"
#import <sqlite3.h>
#import "CGZCollectDetailViewController.h"
#import "CGZDataManager.h"

@interface CGZCollectViewController () <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *backgrounpImage;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSArray *collectDataArray;
@end

@implementation CGZCollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [UIImageView setBackGroundImageView:self.backgrounpImage];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self getCollectData];
}
- (IBAction)backBtnChick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)getCollectData {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *dbFilePath = [documentPath stringByAppendingPathComponent:@"techNew.sqlite"];
    sqlite3 *db = NULL;
    int ret = sqlite3_open([dbFilePath cStringUsingEncoding:NSUTF8StringEncoding], &db);
    if (ret != SQLITE_OK) {
        NSLog(@"创建数据库文件失败:%s", sqlite3_errmsg(db));
    }
    const char *selectStr = "select * from new";
    sqlite3_stmt *stmt; //statement缩写
    ret = sqlite3_prepare(db, selectStr, -1, &stmt, NULL);
    if (ret == SQLITE_OK) {
        NSMutableArray *array = [NSMutableArray array];
        //获取成功；循环从stmt变量中取值
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            const unsigned char *title = sqlite3_column_text(stmt, 0);
            //name
            const unsigned char *message = sqlite3_column_text(stmt, 1);
            //class
            const unsigned char *imageStr = sqlite3_column_text(stmt, 2);
            //            printf("title:%s; message:%s; imageStr:%s\n", title, message, imageStr);
            CGZTechNewSqlite *newSqlite = [[CGZTechNewSqlite alloc]init];
            newSqlite.title = [NSString stringWithUTF8String:(const char *)title];
            newSqlite.message = [NSString stringWithUTF8String:(const char *)message];
            newSqlite.imageStr = [NSString stringWithUTF8String:(const char *)imageStr];
            [array addObject:newSqlite];
        }
        self.collectDataArray = [array copy];
        [self.tableView reloadData];
        //手动调用方法释放stmt占用的内存
        sqlite3_finalize(stmt);
    }
    //收尾工作(打开数据库有一个连接; 不使用需要关闭数据库连接)
    sqlite3_close(db);

}
#pragma mark -- 与tableview相关的方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.collectDataArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"colllectCell" forIndexPath:indexPath];
    CGZTechNewSqlite *tns = self.collectDataArray[indexPath.row];
    cell.textLabel.text = tns.title;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CGZTechNewSqlite *techNew = self.collectDataArray[indexPath.row];
    [self performSegueWithIdentifier:@"collect" sender:techNew];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[CGZCollectDetailViewController class]]) {
        CGZCollectDetailViewController *newsDetail = segue.destinationViewController;
        CGZTechNewSqlite *techNew = sender;
        newsDetail.tnq = techNew;
    }
}
/** 向左滑动删除收藏 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        CGZTechNewSqlite *tnq = self.collectDataArray[indexPath.row];
        [CGZDataManager deleteSqliteData:tnq.title];
        [self getCollectData];
        [tableView reloadData];
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
