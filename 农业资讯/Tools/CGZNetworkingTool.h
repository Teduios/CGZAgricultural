//
//  CGZNetworkingTool.h
//  农业资讯
//
//  Created by Tarena on 16/6/24.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^BLOCK)(NSArray *classifyData);

@interface CGZNetworkingTool : NSObject
@property (nonatomic,strong) NSString *urlPrefix;
@property (nonatomic,strong) NSString *urlPostfix;
/** 创建网路工具的单列对象 */
+ (CGZNetworkingTool *)sharedNetworkTool;
/** 获取技术分类的数据 */
- (void)getTechnicalClassificationData:(BLOCK)block;
/** 获取技术列表的数据 */
- (void)getTechListData:(BLOCK)block;
/** 获取技术新闻数据 */
- (void)getTechNewsData:(BLOCK)block;
/** 获取天气新闻 */
- (void)getWeatherData:(BLOCK)block;
@end
