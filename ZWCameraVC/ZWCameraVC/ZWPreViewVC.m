//
//  ZWPreViewVC.m
//  ZWCameraVC
//
//  Created by zzl on 2017/3/16.
//  Copyright © 2017年 zzl. All rights reserved.
//

#import "ZWPreViewVC.h"

@interface ZWPreViewVC ()

@end

@implementation ZWPreViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.mtagimg.image = self.mimg;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (IBAction)redo:(id)sender {
    
    if( self.mItBlock )
        self.mItBlock(NO);
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)okdo:(id)sender {

    if( self.mfinllock )
    {
        if( self.mItBlock )
            self.mItBlock(YES);
        
        self.mfinllock(self.mimg,nil);
        
        NSArray* ss = self.navigationController.viewControllers;
        NSMutableArray*xx = NSMutableArray.new;
        [xx addObjectsFromArray:ss];
        [xx removeLastObject];
        [xx removeLastObject];
        [self.navigationController setViewControllers:xx animated:YES];
    }
    else
    {
        if( self.mItBlock )
            self.mItBlock(YES);
        [self.navigationController popViewControllerAnimated:YES];
    }
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
