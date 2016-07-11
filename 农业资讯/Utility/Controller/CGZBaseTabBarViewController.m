//
//  CGZBaseTabBarViewController.m
//  农业资讯
//
//  Created by happy on 16/6/25.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import "CGZBaseTabBarViewController.h"

@interface CGZBaseTabBarViewController ()

@end

@implementation CGZBaseTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:35/255.0 green:103/255.0 blue:255/255.0 alpha:1],NSFontAttributeName:[UIFont systemFontOfSize:20]} forState:UIControlStateSelected];
    [[UITabBar appearance]setBackgroundColor:[UIColor whiteColor]];
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
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
