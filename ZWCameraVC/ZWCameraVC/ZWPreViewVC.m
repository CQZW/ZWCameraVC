//
//  ZWPreViewVC.m
//  ZWCameraVC
//
//  Created by zzl on 2017/3/16.
//  Copyright © 2017年 zzl. All rights reserved.
//

#import "ZWPreViewVC.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
@interface ZWPreViewVC ()

@end

@implementation ZWPreViewVC
{
    AVPlayer*   _player;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if( self.mimg != nil )
        self.mtagimg.image = self.mimg;
    else if( self.mmoveurl != nil )
    {
        //2、创建播放器
        _player = [AVPlayer playerWithURL:self.mmoveurl];
        //3、创建视频显示的图层
        AVPlayerLayer *showVodioLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
        showVodioLayer.frame = self.view.frame;
        [self.mtagimg.layer addSublayer:showVodioLayer];
        //4、播放视频
        [_player play];

    }
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
        
        NSArray* ss = self.navigationController.viewControllers;
        NSMutableArray*xx = NSMutableArray.new;
        [xx addObjectsFromArray:ss];
        [xx removeLastObject];
        [xx removeLastObject];
        [self.navigationController setViewControllers:xx animated:YES];
        [self performSelector:@selector(gotoback) withObject:nil afterDelay:0.5f];

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
-(void)gotoback
{
    self.mfinllock(self.mimg,nil,nil);
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
