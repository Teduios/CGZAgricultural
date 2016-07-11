//
//  CGZCollectDetailViewController.m
//  农业资讯
//
//  Created by Tarena on 16/7/1.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import "CGZCollectDetailViewController.h"

@interface CGZCollectDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;
@property (weak, nonatomic) IBOutlet UIImageView *background;

@end

@implementation CGZCollectDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [UIImageView setBackGroundImageView:self.background];
    [self setCollectView];
}
- (void)setCollectView {
    self.titleLabel.text = self.tnq.title;
    self.messageTextView.text = self.tnq.message;
    NSData *imageData = [[NSData alloc]initWithBase64EncodedString:self.tnq.imageStr options:0];
    self.imageView.image = [UIImage imageWithData:imageData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
