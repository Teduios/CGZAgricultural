//
//  CGZNewsDetailViewController.m
//  农业资讯
//
//  Created by happy on 16/6/26.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import "CGZNewsDetailViewController.h"
#import "UIImageView+WebCache.h"
#import <sqlite3.h>
#import "CGZTechNewSqlite.h"
#import "MBProgressHUD+KR.h"

@interface CGZNewsDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *newsImageView;
@property (weak, nonatomic) IBOutlet UITextView *newsContentText;
@property (weak, nonatomic) IBOutlet UIImageView *backgrounpImage;
@property (nonatomic,assign) BOOL exit;
@end

@implementation CGZNewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNewsView];
    [self setNaviItem];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIImageView setBackGroundImageView:self.backgrounpImage];
}
- (void)setNewsView {
    self.titleLabel.text = self.techNew.title;
    self.newsContentText.text = self.techNew.message;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://tnfs.tngou.net/image%@",self.techNew.img]];
    [self.newsImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"background0"]];
}
- (IBAction)backBtnChick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setNaviItem {
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"收藏" style:UIBarButtonItemStyleDone target:self action:@selector(addCollection)];
    self.navigationItem.rightBarButtonItem = rightItem;
}
- (void)addCollection {
    //1.创建数据库(文件: 路径+文件名字)
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    //db: database(数据库)
    NSString *dbFilePath = [documentPath stringByAppendingPathComponent:@"techNew.sqlite"];
    /*参数一：数据库文件所在路径
     参数二：给定数据库类型对象地址
     功能：既创建一个数据库文件；又把数据库文件打开(有权限对数据库进行操作)
     */
    sqlite3 *db = NULL;
    int ret = sqlite3_open([dbFilePath cStringUsingEncoding:NSUTF8StringEncoding], &db);
    if (ret != SQLITE_OK) {
        NSLog(@"创建数据库文件失败:%s", sqlite3_errmsg(db));
    }
    //2.创建表(SQL语句)
    //exec全称：execute
    /* 参数二：要执行的SQL语句
     */
    const char *createTable = "create table if not exists new (title text, message text, image text)";
    char *errmsg = NULL;
    ret = sqlite3_exec(db, createTable, NULL, NULL, &errmsg);
    if (ret != SQLITE_OK) {
        NSLog(@"创建表失败:%s", errmsg);
    }
    
    //查询操作
    /*参数一：数据库对象
     参数二：要执行的查询SQL语句
     参数三：每次最大要执行的SQL语句的字节数
     参数四：查询结果存在该参数中
     参数五：NULL(指向下次未执行的SQL语句部分)
     */
    const char *selectStr = "select * from new";
    sqlite3_stmt *stmt; //statement缩写
    ret = sqlite3_prepare(db, selectStr, -1, &stmt, NULL);
    if (ret == SQLITE_OK) {
        //获取成功；循环从stmt变量中取值
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            //如果调用的step方法的返回值等于SQLITE_ROW(100), 还有下一条记录；如果不等于，循环结束(没有记录)
            //根据不同字段的类型，选择不同的方法
            //id(参数二：字段对应的列下标)
            
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
            if ([self.techNew.title isEqualToString:newSqlite.title]) {
                sqlite3_finalize(stmt);
                sqlite3_close(db);
                [MBProgressHUD showError:@"该页收藏夹已经存在"];
                return;
            }
        }
        //手动调用方法释放stmt占用的内存
        sqlite3_finalize(stmt);
    }
    //如果数据库没有这个记录再执行插入操作
    NSData *data = UIImagePNGRepresentation(self.newsImageView.image);
    NSString *imageStr = [data base64EncodedStringWithOptions:0];
    NSString *str = [NSString stringWithFormat:@"insert into new (title,message,image) values ('%@','%@','%@')",self.techNew.title,self.techNew.message,imageStr];
    const char *insertStr = [str cStringUsingEncoding:NSUTF8StringEncoding];
    ret = sqlite3_exec(db, insertStr, NULL, NULL, &errmsg);
    if (ret != SQLITE_OK) {
        NSLog(@"无法插入数据:%s", errmsg);
    } else {
        [MBProgressHUD showSuccess:@"收藏成功"];
    }
    //收尾工作(打开数据库有一个连接; 不使用需要关闭数据库连接)
    sqlite3_close(db);
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
