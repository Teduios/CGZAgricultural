//
//  UIScrollView+Refresh.h
//  HappyBuy
//
//  Created by lee on 16/3/28.
//  Copyright © 2016年 tedu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"

@interface UIScrollView (Refresh)
/** 添加头部刷新*/
-(void)addHeaderRefresh:(MJRefreshComponentRefreshingBlock)block;
/** 开始头部刷新*/
-(void)beginHeaderRefresh;
/** 结束头部刷新*/
-(void)endHeaderRefresh;

/** 添加底部刷新*/
-(void)addAutoFooterRefresh:(MJRefreshComponentRefreshingBlock)block;
/** 开始底部刷新*/
-(void)beginFooterRefresh;
/** 结束底部刷新*/
-(void)endFooterRefresh;
- (void)addBackFooterRefresh:(MJRefreshComponentRefreshingBlock)block;
@end
