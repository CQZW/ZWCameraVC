//
//  ZWCameraVC.m
//  ZWCameraVC
//
//  Created by zzl on 2017/3/15.
//  Copyright © 2017年 zzl. All rights reserved.
//

#import "ZWCameraVC.h"
#import "GPUImageBeautifyFilter.h"
#import "SVProgressHUD.h"
#import "ZWPreViewVC.h"

#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
@interface ZWCameraVC ()

@property (nonatomic, strong) GPUImageStillCamera *videoCamera;
@property (nonatomic, strong) GPUImageView *filterView;

@end

@implementation ZWCameraVC
{
    BOOL    _bdoing;
    
    BOOL    _beautifyEnable;
    
    GPUImageBeautifyFilter  *   _beautifyFilter;
    
    float   _defaulta;
    float   _defaultb;
    BOOL    _caping;
    
    GPUImageMovieWriter*    _movieweiter;
    NSURL*      _ressaveurl;
    
    int     _funcindex;
    
    BOOL    _recoding;
    NSTimer* _timer;
    int      _counttimer;
}
 - (void)viewDidLoad {
     [super viewDidLoad];
     // Do any additional setup after loading the view.
     
     _funcindex = 0;
     
     self.videoCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:self.mbBackCamera?AVCaptureDevicePositionBack: AVCaptureDevicePositionFront];
     
     self.videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
     self.videoCamera.horizontallyMirrorFrontFacingCamera = YES;
     
     self.filterView = [[GPUImageView alloc] initWithFrame:self.centerwaper.bounds];
     
     [self.centerwaper addSubview:self.filterView];
     [self.centerwaper bringSubviewToFront:self.mctrwaper];
     
     [self loadcfg];
     [self.mslider setValue:_defaulta animated:YES];
     [self.msliderb setValue:_defaultb animated:YES];
     
     NSLayoutConstraint* w = [NSLayoutConstraint constraintWithItem:self.filterView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.centerwaper attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
     w.priority = 999;
     
     NSLayoutConstraint* h = [NSLayoutConstraint constraintWithItem:self.filterView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.centerwaper attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
     h.priority = 999;
     
     NSLayoutConstraint* cx = [NSLayoutConstraint constraintWithItem:self.filterView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.centerwaper attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
     cx.priority = 999;
     
     NSLayoutConstraint* cy = [NSLayoutConstraint constraintWithItem:self.filterView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.centerwaper attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
     cy.priority = 999;
     
     [self.centerwaper addConstraint:w];
     [self.centerwaper addConstraint:h];
     [self.centerwaper addConstraint:cx];
     [self.centerwaper addConstraint:cy];
     
     [self.view layoutIfNeeded];
     
     [self.videoCamera addTarget:self.filterView];
     [self.videoCamera startCameraCapture];
     
     [self enableBeautify];
     [self sliderchang:nil];
     
     if( self.mResType == 1 )
     {//只能有图片
         self.mvmmm.textColor = [UIColor blackColor];
     }
     else if( self.mResType == 2 )
     {//只能有视频
         [self chagneFunc:NO];
         self.mmmm.textColor = [UIColor blackColor];
     }
     
}
-(void)loadcfg
{
    NSUserDefaults * def = [NSUserDefaults standardUserDefaults];
    float fa = [[def objectForKey:@"zwcamera_seta"] floatValue];
    float fb = [[def objectForKey:@"zwcamera_setb"] floatValue];
    _defaulta = fa == 0.0f ? 0.525 : fa;
    _defaultb = fb == 0.0f ? 0.525 : fb;
}
-(void)savecfg
{
    NSUserDefaults * def = [NSUserDefaults standardUserDefaults];
    [def setObject:@(self.mslider.value) forKey:@"zwcamera_seta"];
    [def setObject:@(self.msliderb.value) forKey:@"zwcamera_setb"];
    [def synchronize];
}


-(void)enableBeautify
{
    if( _beautifyEnable ) return;
    [self.videoCamera removeAllTargets];
    _beautifyFilter = [[GPUImageBeautifyFilter alloc] init];
    //[beautifyFilter setBrightness:1.8 saturation:1.2];
    [self.videoCamera addTarget:_beautifyFilter];
    [_beautifyFilter addTarget:self.filterView];
    _beautifyEnable = YES;
}
-(void)disableBeautify
{
    if( !_beautifyEnable ) return;
    [self.videoCamera removeAllTargets];
    [self.videoCamera addTarget:self.filterView];
    _beautifyEnable = NO;
    self.mctrwaper.hidden = YES;

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (IBAction)lightclicked:(id)sender {
    
    if( _bdoing ) return;
    _bdoing = YES;
    [self updateLightStatus];
    
    [UIView animateWithDuration:0.3f animations:^{
        self.lightwaperconst.constant = self.lightwaperconst.constant == 0 ? 200:0;
        [self.view layoutIfNeeded];
    }completion:^(BOOL finished) {
        _bdoing = NO;
    }];
    
}

- (IBAction)sublightclicked:(UIButton*)sender {
    
    NSError* xx = nil;
    
    [self.videoCamera.inputCamera lockForConfiguration:&xx];
    if( [self.videoCamera.inputCamera isFlashModeSupported:sender.tag] )
        [self.videoCamera.inputCamera setFlashMode:sender.tag];
    [self.videoCamera.inputCamera unlockForConfiguration];
    
    [self updateLightStatus];
}

-(void)updateLightStatus
{
    AVCaptureFlashMode v = self.videoCamera.inputCamera.flashMode;
    for( UIButton* bt in self.mlightwaper.subviews )
    {
        if( bt.tag == v )
            [bt setTitleColor:self.mmmm.textColor forState:UIControlStateNormal];
        else
            [bt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

- (IBAction)frontbackclicked:(id)sender {
    
    [self.videoCamera rotateCamera];
    
}
- (IBAction)cacleclicked:(id)sender {
    
    [_movieweiter finishRecording];
    [self.videoCamera stopCameraCapture];
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (IBAction)beautifyclicked:(id)sender {
    
    if( _recoding ) return;
    
    if( _beautifyEnable )
    {
        [self disableBeautify];
        [self.mbeautifybt setTitle:@"开启美颜" forState:UIControlStateNormal];
    }
    else
    {
        [self enableBeautify];
        [self.mbeautifybt setTitle:@"关闭美颜" forState:UIControlStateNormal];
    }
    
}

-(void)haveTakedMove
{
    ZWPreViewVC* vc = [[ZWPreViewVC alloc]initWithNibName:@"ZWPreViewVC" bundle:nil];
    vc.mItBlock = ^(BOOL b){
        if( b )
        {
            [self.videoCamera stopCameraCapture];
        }
        else
        {
            [self.videoCamera resumeCameraCapture];
        }
    };
    vc.mmoveurl = _ressaveurl;
    vc.mmoveleng = _counttimer;
    vc.mfinllock = self.mitblock;
    [self.navigationController pushViewController:vc animated:NO];
    
    self.mtoptime.text = @"00:00";
    [self.mrecodingprocess setProgress:1.0f];
    
}

-(void)haveTakedPic:(UIImage*)img
{
    ZWPreViewVC* vc = [[ZWPreViewVC alloc]initWithNibName:@"ZWPreViewVC" bundle:nil];
    vc.mimg = img;
    vc.mItBlock = ^(BOOL b){
        if( b )
        {
            [self.videoCamera stopCameraCapture];
        }
        else
        {
            [self.videoCamera resumeCameraCapture];
        }
    };
    vc.mfinllock = self.mitblock;
    [self.navigationController pushViewController:vc animated:NO];
}

-(void)gobackWithImg:(UIImage*)img
{
    if( self.mitblock )
        self.mitblock( img,nil,0,nil);
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)recoddeal
{
    if( _recoding )
    {
        
        [self.videoCamera pauseCameraCapture];
        [_movieweiter finishRecording];
        
        self.videoCamera.audioEncodingTarget = nil;
        
        if( _beautifyEnable )
            [_beautifyFilter removeTarget:_movieweiter];
        else
        {
            [self.videoCamera removeTarget:_movieweiter];
        }
        
        [_timer invalidate];
        
        [self haveTakedMove];
        
        _recoding = NO;
    }
    else
    {
        self.mtoptime.text = @"00:00";
        [self.mrecodingprocess setProgress:1.0f animated:YES];
        
        NSString* ss = [NSTemporaryDirectory() stringByAppendingPathComponent:@"zwcarmera.mp4"];
        unlink( [ss UTF8String] );
        _ressaveurl = [NSURL fileURLWithPath:ss];
        
        _movieweiter = [[GPUImageMovieWriter alloc]initWithMovieURL:_ressaveurl size:CGSizeMake(480, 640)];
        _movieweiter.encodingLiveVideo = YES;
        _movieweiter.shouldPassthroughAudio = YES;
        _movieweiter.hasAudioTrack = YES;
        if( _beautifyEnable )
            [_beautifyFilter addTarget:_movieweiter];
        else
        {
            [self.videoCamera addTarget:_movieweiter];
            [self.videoCamera addTarget:self.filterView];
        }
        
        self.videoCamera.audioEncodingTarget = _movieweiter;
        
        [_movieweiter startRecording];
        
        _counttimer = 0;
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeron:) userInfo:nil repeats:YES];
        _recoding = YES;
        
    }
}
#define MAX_RECODE 120
-(void)timeron:(id)sender
{
    if( _counttimer > MAX_RECODE )
    {
        return;
    }
    
    _counttimer++;
    int m = _counttimer/60;
    self.mtoptime.text = [NSString stringWithFormat:@"%02d:%02d",m,_counttimer - m*60];
    [self.mrecodingprocess setProgress:1-(float)_counttimer/MAX_RECODE animated:YES];
    if( _counttimer == MAX_RECODE ) [self recoddeal];
    
}

- (IBAction)capclciked:(id)sender {
    
    if( _funcindex == 1 )
    {//录像
        [self recoddeal];
        return;
    }
    if( _caping ) return;
    _caping = YES;
    
    if( !_beautifyEnable )
    {
        GPUImageCropFilter* filter = [[GPUImageCropFilter alloc]initWithCropRegion:CGRectMake(0, 0, 1.0f, 1.0f)];
        [self.videoCamera addTarget:filter];
        [filter addTarget:self.filterView];
        
        [self.videoCamera capturePhotoAsImageProcessedUpToFilter:filter withCompletionHandler:^(UIImage *processedImage, NSError *error) {
            
            [self.videoCamera removeAllTargets];
            [self.videoCamera addTarget:self.filterView];
            
            if( error == nil && processedImage != nil )
            {
                UIImage* img = [processedImage copy];
                [self.videoCamera pauseCameraCapture];
                [self haveTakedPic:img];
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"拍照失败:%@",error.description]];
            }
            _caping = NO;
        }];
        return;
    }
    
    [self savecfg];
    [self.videoCamera capturePhotoAsImageProcessedUpToFilter:_beautifyFilter withCompletionHandler:^(UIImage *processedImage, NSError *error) {
        
        if( error == nil && processedImage != nil )
        {
            UIImage* img = [processedImage copy];
            [self.videoCamera pauseCameraCapture];
            [self haveTakedPic:img];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"拍照失败:%@",error.description]];
        }
        _caping = NO;
    }];
}

-(void)dealloc
{
    _beautifyFilter = nil;
}

- (IBAction)sliderchang:(id)sender {
    
    if( !_beautifyEnable ) return;
    [_beautifyFilter setBrightness:self.mslider.value*2.0f saturation:self.msliderb.value*2.0f];
    
}

- (IBAction)slikderbclciked:(id)sender {
    
    if( !_beautifyEnable ) return;
    [_beautifyFilter setBrightness:self.mslider.value*2.0f saturation:self.msliderb.value*2.0f];
    
}

- (IBAction)centertaped:(id)sender {

    if( _recoding ) return;//录制过程不能调整了
    
    if( _beautifyEnable )
    {
        self.mctrwaper.hidden = !self.mctrwaper.hidden;
    }
    else
    {
        self.mctrwaper.hidden = YES;
    }
}
- (IBAction)defaultclciked:(id)sender {
    
    [self.mslider setValue:0.525f animated:YES];
    [self.msliderb setValue:0.525f animated:YES];
    [self sliderchang:nil];
    [self slikderbclciked:nil];
    [self savecfg];
    
}
- (IBAction)swiperight:(id)sender {
    
    if( self.mResType != 0 ) return;
    if( _recoding ) return;//录制过程不能切换
    
    [self chagneFunc:YES];
}
- (IBAction)swipeleft:(id)sender {
    
    if( self.mResType != 0 ) return;
    if( _recoding ) return;//录制过程不能切换
    
    [self chagneFunc:NO];
}
-(void)chagneFunc:(BOOL)bright
{
    if( _funcindex == 0 && bright ) return;
    if( _funcindex == 1 && !bright ) return;
    _funcindex += bright?(-1):1;
    if( _funcindex == 0 )
    {
        self.mtoptime.hidden = YES;
        self.mrecodingprocess.hidden = YES;
        self.mmmm.textColor = [UIColor colorWithRed:234/255.0f green:187/255.0f blue:0/255.0f alpha:1];
        self.mvmmm.textColor = [UIColor whiteColor];
        
        [UIView animateWithDuration:0.2 animations:^{
            self.mcenterconst.constant = 0;
            [self.view layoutIfNeeded];
        }];
    }
    else
    {
        self.mtoptime.hidden = NO;
        self.mrecodingprocess.hidden = NO;
        self.mmmm.textColor = [UIColor whiteColor];
        self.mvmmm.textColor = [UIColor colorWithRed:234/255.0f green:187/255.0f blue:0/255.0f alpha:1];
        
        [UIView animateWithDuration:0.2 animations:^{
            self.mcenterconst.constant = -34.0f;
            [self.view layoutIfNeeded];
        }];
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
