//
//  CGZCityTableViewController.h
//  农业资讯
//
//  Created by happy on 16/6/28.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGZCity.h"

@protocol cityTableViewDelegate
- (void)cityTableView:(CGZCity*)city;
@end
@interface CGZCityTableViewController : UITableViewController
@property (nonatomic,weak) id<cityTableViewDelegate> delegate;
@end
