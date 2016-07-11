//
//  CGZTechnicalClassification.h
//  农业资讯
//
//  Created by Tarena on 16/6/24.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYModel.h"

@interface CGZTechnicalClassification : NSObject<YYModel>
@property (nonatomic,copy) NSString *content;
@property (nonatomic,assign) NSNumber *ID;
@property (nonatomic,copy) NSString *keywords;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,assign) NSNumber *seq;
@property (nonatomic,assign) NSNumber *techclass;
@property (nonatomic,copy) NSString *title;
+(NSDictionary<NSString *,id> *)modelCustomPropertyMapper;
@end
