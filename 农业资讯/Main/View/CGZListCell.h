//
//  CGZListCell.h
//  农业资讯
//
//  Created by Tarena on 16/6/25.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CGZListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *imageUrl;

@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@end
