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
}
 - (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.videoCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionFront];

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
    
    [self.videoCamera stopCameraCapture];
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (IBAction)beautifyclicked:(id)sender {
    
    if( _beautifyEnable )
        [self disableBeautify];
    else
        [self enableBeautify];
    
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
        self.mitblock( img,nil);
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)capclciked:(id)sender {
    
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

    if( _beautifyFilter )
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
