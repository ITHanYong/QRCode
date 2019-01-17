//
//  QRcodeView.m
//  QfMeetingManager
//
//  Created by Mac on 2018/10/24.
//  Copyright © 2018年 Mac. All rights reserved.
//

//颜色 + alpha
#define UIColorFromRGBA(rgbValue,a)    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

//颜色
#define UIColorFromRGB(rgbValue)    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//屏幕尺寸
#define SCREENH                     [UIScreen mainScreen].bounds.size.height
#define SCREENW                     [UIScreen mainScreen].bounds.size.width

#import "QRcodeView.h"
#import "QRCodeTool.h"

@interface QRcodeView()

@property (nonatomic, strong) UIView *blackView;//遮罩层

@property (nonatomic, strong) UIView *alertview;//弹窗视图

@property (nonatomic, strong) UIImageView *qrCodeImageView;//门禁二维码

@property (nonatomic, strong) UILabel *titleLabel;//标题

@property (nonatomic, strong) NSData *qrData;

@end

@implementation QRcodeView

static QRcodeView *qrcodeView = nil;
+(instancetype)qrcodeView:(CGRect)frame{
    qrcodeView = [[QRcodeView alloc] initWithFrame:frame];
    return qrcodeView;
}

+(instancetype)alloc{
    @synchronized ([QRcodeView class]) {
        qrcodeView = [super alloc];
    }
    return qrcodeView;
}

- (id)initWithFrame:(CGRect)frame{
    
    if ([super initWithFrame:frame]) {
        
        self.frame = frame;
        
        CGFloat width = frame.size.width < frame.size.height ? frame.size.width/4*3 : frame.size.height/4*3;
        self.blackView.frame = frame;
        self.alertview.frame = CGRectMake(0, 0, width, width);
        self.alertview.center = self.center;
        [self creatQFcodeView:width];
        
        self.backgroundColor = UIColorFromRGBA(0x666666, 0.5);
    }
    return self;
}

#pragma mark - 在此处请求接口获取数据生成二维码
-(void)requestUrl{
    
    NSString *data = @"<000045AA19535400F49A1C33BA36436A93D307903A5E7D7A333B0923>";
    self.qrData = [self convertHexStrToData:data];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
       //将16进制转成NSData 根据NSData生成二维码image
        self.qrCodeImageView.image = [QRCodeTool generateWithDefaultQRCodeData:self.qrData imageViewWidth:300];
    });
}


#pragma mark -  16进制转NSData
- (NSData *)convertHexStrToData:(NSString *)str
{
    if (!str || [str length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:20];
    NSRange range;
    if ([str length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    return hexData;
}


#pragma mark - 创建二维码视图
- (void)creatQFcodeView:(CGFloat)width
{
    self.qrCodeImageView.frame = CGRectMake(30, 22, width-60, width-60);
    self.titleLabel.frame = CGRectMake(self.qrCodeImageView.frame.origin.x, self.qrCodeImageView.frame.origin.y+self.qrCodeImageView.frame.size.height, self.qrCodeImageView.frame.size.width, 20);
    
    self.qrCodeImageView.backgroundColor = [UIColor orangeColor];
    
}

-(void)setTitle:(NSString *)title{
    _titleLabel.text = title;
}

-(void)setQrCodeImage:(UIImage *)qrCodeImage{
    _qrCodeImageView.image = qrCodeImage;
}

#pragma mark - 点击空白处弹窗消失
- (void)blackClick{
    [self dismiss];
}

#pragma mark - 弹框消失
- (void)dismiss{
    
    [self removeFromSuperview];
}

#pragma mark - 弹出此弹窗
- (void)show{
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    
    [self requestUrl];
    //    [UIView animateWithDuration:0.2 animations:^{
    //        self.alpha = 1;
    //    }];
    
}

-(UIView *)blackView{
    if (!_blackView) {
        //创建遮罩
        _blackView = [UIView new];
        _blackView.backgroundColor = UIColorFromRGBA(0x666666, 0.6);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(blackClick)];
        [_blackView addGestureRecognizer:tap];
        
        [self addSubview:_blackView];
        
    }
    return _blackView;
}

-(UIView *)alertview{
    if (!_alertview) {
        //创建alert
        _alertview = [UIView new];
        _alertview.layer.cornerRadius = 4;
        _alertview.clipsToBounds = YES;
        _alertview.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:_alertview];
    }
    return _alertview;
}

-(UIImageView *)qrCodeImageView{
    if (!_qrCodeImageView) {
        _qrCodeImageView = [[UIImageView alloc] init];
        //_qrCodeImageView.image = [UIImage imageNamed:@"二维码背景"];
        
        [self.alertview addSubview:_qrCodeImageView];
        
    }
    return _qrCodeImageView;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"请扫描二维码";
        _titleLabel.textColor = [UIColor darkGrayColor];
        [self.alertview addSubview:_titleLabel];
    }
    return _titleLabel;
}

@end
