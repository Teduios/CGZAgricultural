//
//  CGZDataManager.m
//  农业资讯
//
//  Created by happy on 16/6/24.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import "CGZDataManager.h"
#import "CGZMenu.h"
#import "CGZTechnicalClassification.h"
#import "YYModel.h"
#import "CGZCity.h"
#import "CGZCound.h"
#import <sqlite3.h>
#import "MBProgressHUD+KR.h"

@implementation CGZDataManager

+ (NSArray*)getMenuData {
    return [[self alloc] parsePlist:[CGZMenu class] fileName:@"Menu.plist"];
}

+ (NSArray*)getClassifyData {
    return [[self alloc] parsePlist:[CGZTechnicalClassification class] fileName:@"classify.plist"];
}
static NSArray *_cityArray = nil;
+ (NSArray*)getAllCitiesData {
    if (_cityArray == nil) {
        _cityArray = [[self alloc] parsePlist:[CGZCity class] fileName:@"city.plist"];
    }
    return _cityArray;
}
static NSArray *_coudArray = nil;
+ (NSArray*)getAllCoundData {
    if (_coudArray == nil) {
        _coudArray = [[self alloc] parsePlist:[CGZCound class] fileName:@"allCond.plist"];
    }
    return _coudArray;
}




/** 数组套字典的解析 */
- (NSArray*)parsePlist:(Class)class fileName:(NSString*)name {
    NSMutableArray *dataArray = [NSMutableArray array];
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    for (NSDictionary *dic in array) {
        id newInstance = [[class alloc]init];
//        [newInstance setValuesForKeysWithDictionary:dic];
        [newInstance yy_modelSetWithDictionary:dic];
        [dataArray addObject:newInstance];
    }
    return [dataArray copy];
}

+ (void)deleteSqliteData:(NSString*)title {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *dbFilePath = [documentPath stringByAppendingPathComponent:@"techNew.sqlite"];
    sqlite3 *db = NULL;
    int ret = sqlite3_open([dbFilePath cStringUsingEncoding:NSUTF8StringEncoding], &db);
    if (ret != SQLITE_OK) {
        NSLog(@"创建数据库文件失败:%s", sqlite3_errmsg(db));
    }
    NSString *deleteS = [NSString stringWithFormat:@"delete from new where title='%@'",title];
    const char *deleteStr = [deleteS cStringUsingEncoding:NSUTF8StringEncoding];
    char *errmsg = NULL;
    ret = sqlite3_exec(db, deleteStr, NULL, NULL, &errmsg);
    if (ret == SQLITE_OK ) {
        [MBProgressHUD showSuccess:@"移除成功"];
    } else {
        [MBProgressHUD showError:@"删除失败"];
    }
    sqlite3_close(db);
}



@end
