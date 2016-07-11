//
//  CGZNetworkingTool.m
//  农业资讯
//
//  Created by Tarena on 16/6/24.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import "CGZNetworkingTool.h"
#import "CGZTechnicalClassification.h"
#import "YYModel.h"
#import "CGZTechList.h"
#import "CGZTechNews.h"

typedef void (^TEMPBLOCK)(NSArray *classifyData);

@interface CGZNetworkingTool ()
@property (nonatomic,copy) TEMPBLOCK tempBlock;
@property (nonatomic,strong) NSURL *url;
@property (nonatomic,strong) Class class;
@end

@implementation CGZNetworkingTool
static CGZNetworkingTool *_networkingTool = nil;
+ (CGZNetworkingTool *)sharedNetworkTool {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _networkingTool = [[CGZNetworkingTool alloc]init];
    });
    return _networkingTool;
}
+(instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _networkingTool = [super allocWithZone:zone];
    });
    return _networkingTool;
}

- (void)getTechnicalClassificationData:(BLOCK)block{
    self.tempBlock = block;
    self.urlPrefix = @"http://www.tngou.net/api/tech/classify";
    self.class = [CGZTechnicalClassification class];
    [self getNetworkData];
}

- (void)getTechListData:(BLOCK)block {
    self.tempBlock = block;
    self.urlPrefix = @"http://www.tngou.net/api/tech/list";
    self.class = [CGZTechList class];
    [self getNetworkData];
}

- (void)getTechNewsData:(BLOCK)block {
    self.tempBlock = block;
    self.urlPrefix = @"http://www.tngou.net/api/tech/news";
    self.class = [CGZTechNews class];
    [self getNetworkData];
}

- (void)getWeatherData:(BLOCK)block {
    self.tempBlock = block;
    self.urlPrefix = @"https://api.heweather.com/x3/weather?";
    [self getWeather];
}
/** 请求获取网络数据 */
- (void)getNetworkData {
    if (self.urlPostfix) {
        self.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",self.urlPrefix,self.urlPostfix]];
    } else {
        self.url = [NSURL URLWithString:self.urlPrefix];
    }
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:_url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSData *data = [NSData dataWithContentsOfURL:location];
        if (!error) {
            NSError *error1 = nil;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error1];
            if (self.class == [CGZTechNews class]) {
                NSArray *array = [self parsePlist:self.class array:dic[@"list"]];
                self.tempBlock(array);
            } else {
                NSArray *array = [self parsePlist:self.class array:dic[@"tngou"]];
                self.tempBlock(array);
            }
        }
    }];
    [downloadTask resume];
}
/** 数组套字典的解析 */
- (NSArray*)parsePlist:(Class)class array:(NSArray*)array {
    NSMutableArray *dataArray = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        id newInstance = [[class alloc]init];
        [newInstance yy_modelSetWithDictionary:dic];
        [dataArray addObject:newInstance];
    }
    return [dataArray copy];
}

- (void)getWeather {
    if (self.urlPostfix) {
        self.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",self.urlPrefix,self.urlPostfix]];
    } else {
        self.url = [NSURL URLWithString:self.urlPrefix];
    }
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:_url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSData *data = [NSData dataWithContentsOfURL:location];
        if (!error) {
            NSError *error1 = nil;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error1];
            NSArray *array = dic[@"HeWeather data service 3.0"];
            self.tempBlock(array);
        }
    }];
    [downloadTask resume];
}













@end
