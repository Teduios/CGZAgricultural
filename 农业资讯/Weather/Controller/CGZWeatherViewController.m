//
//  CGZWeatherViewController.m
//  农业资讯
//
//  Created by happy on 16/6/28.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import "CGZWeatherViewController.h"
#import "CGZCityTableViewController.h"
#import "CGZDataManager.h"
#import "CGZCound.h"
#import "UIImageView+WebCache.h"

@interface CGZWeatherViewController ()<cityTableViewDelegate>
@property (nonatomic,strong) NSArray *weatherDataArray;
@property (weak, nonatomic) IBOutlet UILabel *latLabel;
@property (weak, nonatomic) IBOutlet UILabel *lonLabel;
@property (weak, nonatomic) IBOutlet UILabel *temLabel;
@property (weak, nonatomic) IBOutlet UILabel *dicLabel;
@property (weak, nonatomic) IBOutlet UILabel *scLabel;
@property (weak, nonatomic) IBOutlet UILabel *qulityLabel;
@property (weak, nonatomic) IBOutlet UIImageView *condImageView;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *sugTextView;
@property (weak, nonatomic) IBOutlet UILabel *oneDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *threeDateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *oneImageView;
@property (weak, nonatomic) IBOutlet UIImageView *twoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *threeImageView;
@property (weak, nonatomic) IBOutlet UILabel *onetempLabel;
@property (weak, nonatomic) IBOutlet UILabel *threeTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoTempLabel;
@property (nonatomic,strong) NSString *ID;
@property (nonatomic,strong) NSArray *coundArray;
@end

@implementation CGZWeatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBarItem];
    self.ID = @"CN101230201";
    self.coundArray = [CGZDataManager getAllCoundData];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [CGZNetworkingTool sharedNetworkTool].urlPostfix = [NSString stringWithFormat:@"cityid=%@&key=51d3c56b6fa345a3b336faabee823d90",self.ID];
    __weak typeof(CGZWeatherViewController) *wvc = self;
    [[CGZNetworkingTool sharedNetworkTool] getWeatherData:^(NSArray *classifyData) {
        wvc.weatherDataArray = classifyData;
        dispatch_async(dispatch_get_main_queue(), ^{
            [wvc parseWeatherData];
        });
    }];
}
#pragma mark -- 与导航栏相关的方法
- (void)setupBarItem {
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"location"] style:UIBarButtonItemStyleDone target:self action:@selector(chooseCity)];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(backChick)];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.rightBarButtonItem = item;
}
- (void)chooseCity {
    CGZCityTableViewController *ctvc = [[CGZCityTableViewController alloc]init];
    ctvc.delegate = self;
    [self.navigationController pushViewController:ctvc animated:YES];
}
- (void)backChick {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -- 与天气相关的方法
- (void)cityTableView:(CGZCity *)city {
    self.cityNameLabel.text = city.city;
    self.latLabel.text = city.lat;
    self.lonLabel.text = city.lon;
    self.ID = city.ID;
//    NSLog(@"%@",city.city);
}


- (void)parseWeatherData {
    NSDictionary *dic = self.weatherDataArray[0];
    //空气质量指数
    NSDictionary *aqi = dic[@"aqi"];
    NSString *qlty = aqi[@"city"][@"qlty"];
    NSString *aq = aqi[@"city"][@"aqi"];
    NSString *aqiLabel = [NSString stringWithFormat:@"空气质量指数:%@ 空气质量:%@",aq,qlty];
    self.qulityLabel.text = aqiLabel;
    //当前的天气状况
    NSDictionary *now = dic[@"now"];
    //图片的状态
    NSString *txt = now[@"cond"][@"txt"];
    self.temLabel.text = txt;
    //温度
    NSString *tmp = now[@"tmp"];
    self.tempLabel.text = [NSString stringWithFormat:@"%@°",tmp];
    //风向风力
    NSString *dir = now[@"wind"][@"dir"];
    self.dicLabel.text = dir;
    NSString *sc = now[@"wind"][@"sc"];
    self.scLabel.text = [NSString stringWithFormat:@"%@级",sc];
//    NSString *scLabel = [NSString stringWithFormat:@"%@,风力%@级",dir,sc];
    //建议文本
    NSDictionary *suggestion = dic[@"suggestion"];
    NSString *suggesTextView = [NSString stringWithFormat:@"\t%@\n\t%@\n  \t%@\n\t%@\n\t%@\n\t%@\n\t%@",suggestion[@"comf"][@"txt"],suggestion[@"cw"][@"txt"],suggestion[@"drsg"][@"txt"],suggestion[@"flu"][@"txt"],suggestion[@"sport"][@"txt"],suggestion[@"trav"][@"txt"],suggestion[@"uv"][@"txt"]];
    self.sugTextView.text = suggesTextView;
    [self setCoundLabel:self.condImageView :txt];
    [self setOtherWeather:self.oneDateLabel :self.onetempLabel :self.oneImageView :1];
    [self setOtherWeather:self.twoDateLabel :self.twoTempLabel :self.twoImageView :2];
    [self setOtherWeather:self.threeDateLabel :self.threeTempLabel :self.threeImageView :3];
}

- (void)setCoundLabel:(UIImageView*)imageView :(NSString*)text{
    for (CGZCound *cound in self.coundArray) {
        if ([text isEqualToString:cound.txt]) {
            NSURL *url = [NSURL URLWithString:cound.icon];
            [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"weather_run"]];
            return;
        }
    }
}
- (void)setOtherWeather:(UILabel *)label :(UILabel*)label1 :(UIImageView*)imageView :(int)i {
    NSDictionary *dic = self.weatherDataArray[0];
    NSArray *daily_forecast = dic[@"daily_forecast"];
    NSString *txt = daily_forecast[i][@"cond"][@"txt_d"];
    NSString *date = daily_forecast[i][@"date"];
    NSString *max = daily_forecast[i][@"tmp"][@"max"];
    NSString *min = daily_forecast[i][@"tmp"][@"min"];
    label.text = date;
    label1.text = [NSString stringWithFormat:@"%@:%@°~%@°",txt,min,max];
    [self setCoundLabel:imageView :txt];
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
