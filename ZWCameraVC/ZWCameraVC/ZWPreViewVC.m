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
    BOOL        _stoped;
    AVPlayerItem* _playitem;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if( self.mimg != nil )
        self.mtagimg.image = self.mimg;
    else if( self.mmoveurl != nil )
    {
        [self.view layoutIfNeeded];
        
        _playitem = [AVPlayerItem playerItemWithURL:self.mmoveurl];
        
        //2、创建播放器
        _player = [AVPlayer playerWithPlayerItem:_playitem];
        //3、创建视频显示的图层
        AVPlayerLayer *showVodioLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
        showVodioLayer.frame = CGRectMake(0, 0, ([UIScreen mainScreen].bounds.size.width), ([UIScreen mainScreen].bounds.size.height)-55);
        [self.mtagimg.layer addSublayer:showVodioLayer];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playend:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        //4、播放视频
        [_player play];
        
        [self.mokbt setTitle:@"使用视频" forState:UIControlStateNormal];
    /*
        self.mmoveinfo.hidden = NO;
        double sec = CMTimeGetSeconds(playitem.asset.duration);
        int m = sec/60;
        self.mmoveinfo.text = [NSString stringWithFormat:@"视频时长:%02d:%02d",m,(int)sec-m*60];
     */
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
-(void)playend:(id)sender
{
    if( _stoped ) return;
    
    [_playitem seekToTime:kCMTimeZero];
    [_player play];
}

- (IBAction)redo:(id)sender {
    
    _stoped = YES;
    [_player pause];
    if( self.mItBlock )
        self.mItBlock(NO);
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)okdo:(id)sender {

    _stoped = YES;
    [_player pause];
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
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
