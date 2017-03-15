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

@property (weak, nonatomic) IBOutlet UILabel *mmmm;


@property (nonatomic,strong)    void(^mitblock)(UIImage* takedImage,NSString* err);
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *msliderconst;

@property (weak, nonatomic) IBOutlet UISlider *mslider;
@end
