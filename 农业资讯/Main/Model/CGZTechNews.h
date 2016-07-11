//
//  CGZTechNews.h
//  农业资讯
//
//  Created by Tarena on 16/6/26.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYModel.h"

@interface CGZTechNews : NSObject<YYModel>
@property (nonatomic,copy) NSString *content;
@property (nonatomic,assign) NSNumber *ID;
@property (nonatomic,copy) NSString *keywords;
@property (nonatomic,assign) NSNumber *count;
@property (nonatomic,assign) NSNumber *tclass;
@property (nonatomic,assign) NSNumber *techclass;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *img;
@property (nonatomic,copy) NSString *message;

+(NSDictionary<NSString *,id> *)modelCustomPropertyMapper;
@end
