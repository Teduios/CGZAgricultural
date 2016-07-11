//
//  CGZDataManager.h
//  农业资讯
//
//  Created by happy on 16/6/24.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CGZDataManager : NSObject

+ (NSArray*)getMenuData;

+ (NSArray*)getClassifyData;

+ (NSArray*)getAllCitiesData;

+ (NSArray*)getAllCoundData;

+ (void)deleteSqliteData:(NSString *)title;
@end
