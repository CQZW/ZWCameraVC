//
//  ViewController.m
//  ZWCameraVC
//
//  Created by zzl on 2017/3/15.
//  Copyright © 2017年 zzl. All rights reserved.
//

#import "ViewController.h"
#import "ZWCameraVC.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (IBAction)ccc:(id)sender {
    
    ZWCameraVC* vc = [[ZWCameraVC alloc]initWithNibName:@"ZWCameraVC" bundle:nil];
    vc.mbBackCamera = YES;
    vc.mitblock = ^(UIImage* takedImage,NSURL* moveurl,int moveleng, NSString* err)
    {
        self.mmm.image = takedImage;
    };
    vc.mResType = 0;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
