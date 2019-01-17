//
//  QRcodeView.h
//  QfMeetingManager
//
//  Created by Mac on 2018/10/24.
//  Copyright © 2018年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QRcodeView : UIView

@property (nonatomic, copy)     NSString *title;
//@property (nonatomic, strong)   UIImage *qrCodeImage;

+(instancetype)qrcodeView:(CGRect)frame;
- (void)show;

@end
