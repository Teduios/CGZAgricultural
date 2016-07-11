//
//  CGZBaseNaviController.m
//  农业资讯
//
//  Created by happy on 16/6/23.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import "CGZBaseNaviController.h"

@interface CGZBaseNaviController ()

@end

@implementation CGZBaseNaviController

- (void)viewDidLoad {
    [super viewDidLoad];
    UINavigationBar *navBar = [UINavigationBar appearance];
    navBar.tintColor = [UIColor blackColor];
    //    navBar.barTintColor = [UIColor colorWithRed:35/255.0 green:103/255.0 blue:255/255.0 alpha:1];
    navBar.backgroundColor = [UIColor whiteColor];
    //    navBar.barTintColor = [UIColor clearColor];
    [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:18]}];
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
