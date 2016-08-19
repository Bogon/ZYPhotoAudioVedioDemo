//
//  RootViewController.m
//  ZYPhotoAudioVedioDemo
//
//  Created by Char on 16/8/18.
//  Copyright © 2016年 Bogon. All rights reserved.
//

#import "RootViewController.h"
#import "ZYRecordVedioViewController.h"
#import "ZYRecordAudioViewController.h"
//屏幕高度
#define kScreenHeight CGRectGetHeight([UIScreen mainScreen].bounds)
//屏幕宽
#define kScreenWidth CGRectGetWidth([UIScreen mainScreen].bounds)

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIButton *recodeVedioBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 80, kScreenWidth-40, 50)];
    recodeVedioBtn.backgroundColor = [UIColor blueColor];
    [recodeVedioBtn setTitle:@"视频录制" forState:UIControlStateNormal];
    [recodeVedioBtn addTarget:self action:@selector(recordVedioAction:) forControlEvents:UIControlEventTouchUpInside];
    [recodeVedioBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:recodeVedioBtn];

    UIButton *recodeAudioBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 200, kScreenWidth-40, 50)];
    recodeAudioBtn.backgroundColor = [UIColor blueColor];
    [recodeAudioBtn setTitle:@"音频录制" forState:UIControlStateNormal];
    [recodeAudioBtn addTarget:self action:@selector(recordAudioAction:) forControlEvents:UIControlEventTouchUpInside];
    [recodeAudioBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:recodeAudioBtn];
}

-(void)recordAudioAction:(UIButton *)sender{

    ZYRecordAudioViewController *VC = [[ZYRecordAudioViewController alloc] init];
    /**
     *  录制完成后的回调，直接使用回调回来的数据即可，上传是直接使用vedioData，调用图片上传的方法
     *
     *  @param vedioData 返回录制的视频二进制数据
     *
     *  @return 录制的视频二进制数据
     */
    VC.recordAudioSuccessBlock = ^(NSData *vedioData){
        /**
         *  在这个位置做上传或者是其他操作
         */
        //TODO ...
        NSLog(@"get audioData success !");
    };
    VC.recordTime = 11;      //录制视频时长跟安卓保持一致均是7秒，若不设置默认不限制时长
    [self.navigationController pushViewController:VC animated:YES];

}

-(void)recordVedioAction:(UIButton *)sender{
    
    //    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //    ViewController *recodVedioVC = [storyBoard instantiateViewControllerWithIdentifier:@"ViewController"];
    ZYRecordVedioViewController *VC = [[ZYRecordVedioViewController alloc] init];
    /**
     *  录制完成后的回调，直接使用回调回来的数据即可，上传是直接使用vedioData，调用图片上传的方法
     *
     *  @param vedioData 返回录制的视频二进制数据
     *
     *  @return 录制的视频二进制数据
     */
    VC.recordVedioSuccessBlock = ^(NSData *vedioData){
        /**
         *  在这个位置做上传或者是其他操作
         */
        //TODO ...
        NSLog(@"get vedioData success !");
    };
    VC.recordTime = 7;      //录制视频时长跟安卓保持一致均是7秒，若不设置默认不限制时长
    [self.navigationController pushViewController:VC animated:YES];
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
