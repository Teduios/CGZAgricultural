//
//  CGZTechList.m
//  农业资讯
//
//  Created by Tarena on 16/6/25.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import "CGZTechList.h"

@implementation CGZTechList

+(NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"content":@"description",@"ID":@"id"};
}
@end
