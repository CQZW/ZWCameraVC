//
//  ZWPreViewVC.h
//  ZWCameraVC
//
//  Created by zzl on 2017/3/16.
//  Copyright © 2017年 zzl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZWPreViewVC : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *mtagimg;

@property (nonatomic,strong)    UIImage*    mimg;
@property (nonatomic,strong)    NSURL*      mmoveurl;

@property (nonatomic,strong)    void(^mItBlock)(BOOL bok);

@property (nonatomic,strong)    void(^mfinllock)(UIImage* takedImage,NSURL* moveurl,NSString* err);
@property (weak, nonatomic) IBOutlet UIButton *mokbt;
@property (weak, nonatomic) IBOutlet UILabel *mmoveinfo;

@end
