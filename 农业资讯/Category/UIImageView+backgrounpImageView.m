//
//  UIImageView+backgrounpImageView.m
//  农业资讯
//
//  Created by happy on 16/6/26.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import "UIImageView+backgrounpImageView.h"

@implementation UIImageView (backgrounpImageView)
+ (void)setBackGroundImageView:(UIImageView*)imageView {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"背景"])
    {
        imageView.image = [UIImage imageNamed:[[NSUserDefaults standardUserDefaults] objectForKey:@"背景"]];
    } else {
        imageView.image = [UIImage imageNamed:@"background0"];
    }
}
@end
