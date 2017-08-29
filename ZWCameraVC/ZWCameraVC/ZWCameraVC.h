//
//  ZWCameraVC.h
//  ZWCameraVC
//
//  Created by zzl on 2017/3/15.
//  Copyright © 2017年 zzl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZWCameraVC : UIViewController

@property (weak, nonatomic) IBOutlet UIView *centerwaper;

@property (weak, nonatomic) IBOutlet UIButton *mbeautifybt;
@property (weak, nonatomic) IBOutlet UIButton *mlightbt;

@property (weak, nonatomic) IBOutlet UIView *mlightwaper;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lightwaperconst;
@property (weak, nonatomic) IBOutlet UILabel *mvmmm;

@property (weak, nonatomic) IBOutlet UILabel *mmmm;
@property (weak, nonatomic) IBOutlet UIProgressView *mrecodingprocess;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mcenterconst;
@property (weak, nonatomic) IBOutlet UILabel *mtoptime;


@property (nonatomic,strong)    void(^mitblock)(UIImage* takedImage,NSURL* moveurl,int moveleng,NSString* err);
@property (weak, nonatomic) IBOutlet UIView *mctrwaper;

@property (weak, nonatomic) IBOutlet UISlider *mslider;
@property (weak, nonatomic) IBOutlet UISlider *msliderb;

@property (nonatomic,assign)    BOOL    mbBackCamera;//默认打开后置摄像头
@property (nonatomic,assign)    int     mResType;//0 随便,1只能拍照,2只能视频

@property (weak, nonatomic) IBOutlet UIButton *mcatpbt;

@end
