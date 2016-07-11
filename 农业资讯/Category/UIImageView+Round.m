//
//  UIImageView+Round.m
//  农业资讯
//
//  Created by happy on 16/6/26.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import "UIImageView+Round.h"

@implementation UIImageView (Round)
+ (void)setRoundImage:(UIImageView*)imageView Radius:(CGFloat)Radius {
    imageView.layer.cornerRadius = Radius;
    imageView.layer.masksToBounds = YES;
    imageView.layer.borderWidth = 5;
    imageView.layer.borderColor = [[UIColor whiteColor] CGColor];
}
@end
