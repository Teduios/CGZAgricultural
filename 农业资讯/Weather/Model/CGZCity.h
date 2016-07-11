//
//  CGZCity.h
//  农业资讯
//
//  Created by happy on 16/6/27.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYModel.h"

@interface CGZCity : NSObject<YYModel>
@property (nonatomic,copy) NSString *city;
@property (nonatomic,copy) NSString *cnty;
@property (nonatomic,copy) NSString *ID;
@property (nonatomic,copy) NSString *lat;
@property (nonatomic,copy) NSString *lon;
@property (nonatomic,copy) NSString *prov;

+(NSDictionary<NSString *,id> *)modelCustomPropertyMapper;
@end
