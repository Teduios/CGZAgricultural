//
//  CGZTechNews.m
//  农业资讯
//
//  Created by Tarena on 16/6/26.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import "CGZTechNews.h"

@implementation CGZTechNews
+(NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"content":@"description",@"ID":@"id"};
}
@end
