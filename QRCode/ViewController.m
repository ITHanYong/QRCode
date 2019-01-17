//
//  ViewController.m
//  QRCode
//
//  Created by Mac on 2019/1/17.
//  Copyright © 2019年 Mac. All rights reserved.
//

//屏幕尺寸
#define SCREENH                     [UIScreen mainScreen].bounds.size.height
#define SCREENW                     [UIScreen mainScreen].bounds.size.width

#import "ViewController.h"
#import "QRcodeView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"二维码" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.frame = CGRectMake(100, 100, 80, 30);
    btn.backgroundColor = [UIColor blueColor];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 15;
    
    [self.view addSubview:btn];
    
}

-(void)click{
    //二维码
    QRcodeView *code = [QRcodeView qrcodeView:CGRectMake(0, 0, SCREENW, SCREENH)];
    [code show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
