//
//  CGZTechnicalClassification.m
//  农业资讯
//
//  Created by Tarena on 16/6/24.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import "CGZTechnicalClassification.h"

@implementation CGZTechnicalClassification
+(NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"content":@"description",@"ID":@"id"};
}

@end
