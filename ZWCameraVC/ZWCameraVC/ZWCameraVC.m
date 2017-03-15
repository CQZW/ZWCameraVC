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
@interface ZWCameraVC ()

@property (nonatomic, strong) GPUImageStillCamera *videoCamera;
@property (nonatomic, strong) GPUImageView *filterView;

@end

@implementation ZWCameraVC
{
    BOOL    _bdoing;
    
    BOOL    _beautifyEnable;
    
    GPUImageBeautifyFilter  *   _beautifyFilter;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.videoCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionFront];
    self.videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    self.videoCamera.horizontallyMirrorFrontFacingCamera = YES;
    self.filterView = [[GPUImageView alloc] initWithFrame:self.centerwaper.bounds];
    
    [self.centerwaper addSubview:self.filterView];
    
    
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
    
}


-(void)enableBeautify
{
    _beautifyFilter = [[GPUImageBeautifyFilter alloc] init];
    //[beautifyFilter setBrightness:1.8 saturation:1.2];
    [self.videoCamera addTarget:_beautifyFilter];
    [_beautifyFilter addTarget:self.filterView];
    _beautifyEnable = YES;
    self.msliderconst.constant = 30;
}
-(void)disableBeautify
{
    [self.videoCamera removeAllTargets];
    [self.videoCamera addTarget:self.filterView];
    _beautifyEnable = NO;
    self.msliderconst.constant = 0;
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
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (IBAction)beautifyclicked:(id)sender {
    
    if( _beautifyEnable )
        [self disableBeautify];
    else
        [self enableBeautify];
    
}

- (IBAction)capclciked:(id)sender {
    
    [self.videoCamera capturePhotoAsImageProcessedUpToFilter:_beautifyFilter withCompletionHandler:^(UIImage *processedImage, NSError *error) {
        
        if( error == nil )
        {
            UIImage* img = [processedImage copy];
            [self.videoCamera stopCameraCapture];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"拍照失败:%@",error.description]];
        }
        
    }];
}

-(void)dealloc
{
    _beautifyFilter = nil;
}

- (IBAction)sliderchang:(id)sender {
    
    if( !_beautifyEnable ) return;
    [_beautifyFilter setBrightness:self.mslider.value*2.0f saturation:1.05f];
    
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
