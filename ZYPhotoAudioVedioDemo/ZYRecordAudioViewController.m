//
//  ZYRecordAudioViewController.m
//  ZYPhotoAudioVedioDemo
//
//  Created by Char on 16/8/19.
//  Copyright © 2016年 Bogon. All rights reserved.
//

#import "ZYRecordAudioViewController.h"
#import <AVFoundation/AVFoundation.h>
#define kRecordAudioFile @"myRecord.aac"
@interface ZYRecordAudioViewController ()<AVAudioRecorderDelegate>{
    NSTimer *timer;
    NSInteger timeCount;
    NSURL *vedioSavePath;
}

@property (nonatomic, weak) IBOutlet UILabel *recordTimeLabel;
//@property (nonatomic, weak) IBOutlet UIProgressView *recordProgress;



@property (nonatomic,strong) AVAudioRecorder *audioRecorder;//音频录音机
@property (nonatomic,strong) AVAudioPlayer *audioPlayer;//音频播放器，用于播放录音文件


@end

@implementation ZYRecordAudioViewController

#pragma mark - 控制器视图方法
- (void)viewDidLoad {
    [super viewDidLoad];
    timeCount = 0;
    _recordTimeLabel.alpha = 0.0;
    _recordTimeLabel.text = @"00:00";
    self.title = @"录制音频";
    [self setAudioSession];
}

#pragma mark - 私有方法
/**
 *  设置音频会话
 */
-(void)setAudioSession{
    AVAudioSession *audioSession=[AVAudioSession sharedInstance];
    //设置为播放和录音状态，以便可以在录制完之后播放录音
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];
}

/**
 *  取得录音文件保存路径
 *
 *  @return 录音文件路径
 */
-(NSURL *)getSavePath{
    NSString *urlStr=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    urlStr=[urlStr stringByAppendingPathComponent:kRecordAudioFile];
    NSLog(@"file path:%@",urlStr);
    NSURL *url=[NSURL fileURLWithPath:urlStr];
    return url;
}

/**
 *  取得录音文件保存路径
 *
 *  @return 录音文件路径
 */
-(NSString *)getSavedPath{
    NSString *urlStr=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    urlStr=[urlStr stringByAppendingPathComponent:kRecordAudioFile];
    NSLog(@"file path:%@",urlStr);
    return urlStr;
}

/**
 *  取得录音文件设置
 *
 *  @return 录音设置
 */
-(NSDictionary *)getAudioSetting{
    NSMutableDictionary *dicM=[NSMutableDictionary dictionary];
    //设置录音格式
    [dicM setObject:@(kAudioFormatMPEG4AAC) forKey:AVFormatIDKey];
    //设置录音采样率，8000是电话采样率，对于一般录音已经够了
    [dicM setObject:@(8000) forKey:AVSampleRateKey];
    //设置通道,这里采用单声道
    [dicM setObject:@(1) forKey:AVNumberOfChannelsKey];
    //每个采样点位数,分为8、16、24、32
    [dicM setObject:@(8) forKey:AVLinearPCMBitDepthKey];
    //是否使用浮点数采样
    [dicM setObject:@(YES) forKey:AVLinearPCMIsFloatKey];
    //....其他设置等
    return dicM;
}

/**
 *  获得录音机对象
 *
 *  @return 录音机对象
 */
-(AVAudioRecorder *)audioRecorder{
    if (!_audioRecorder) {
        //创建录音文件保存路径
        NSURL *url=[self getSavePath];
        //创建录音格式设置
        NSDictionary *setting=[self getAudioSetting];
        //创建录音机
        NSError *error=nil;
        _audioRecorder=[[AVAudioRecorder alloc]initWithURL:url settings:setting error:&error];
        _audioRecorder.delegate=self;
        _audioRecorder.meteringEnabled=YES;//如果要监控声波则必须设置为YES
        if (error) {
            NSLog(@"创建录音机对象时发生错误，错误信息：%@",error.localizedDescription);
            return nil;
        }
    }
    return _audioRecorder;
}

/**
 *  创建播放器
 *
 *  @return 播放器
 */
-(AVAudioPlayer *)audioPlayer{
    if (!_audioPlayer) {
        NSURL *url=[self getSavePath];
        NSError *error=nil;
        _audioPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
        _audioPlayer.numberOfLoops=0;
        [_audioPlayer prepareToPlay];
        if (error) {
            NSLog(@"创建播放器过程中发生错误，错误信息：%@",error.localizedDescription);
            return nil;
        }
    }
    return _audioPlayer;
}

#pragma mark - UI事件
/**
 *  点击录音按钮
 *
 *  @param sender 录音按钮
 */
- (IBAction)recordClick:(UIButton *)sender {
    if (![self.audioRecorder isRecording]) {
        _recordTimeLabel.text = @"00:00";
        [UIView animateWithDuration:.5f animations:^{
            _recordTimeLabel.alpha = 1.0f;
        }];
        timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(recordTimeChange:) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        [self.audioRecorder record];//首次使用应用时如果调用record方法会询问用户是否允许使用麦克风
        sender.selected = YES;
    }else{
        sender.enabled = NO;
        sender.selected = YES;
        [self.audioRecorder stop];//停止录制
    }

}

-(void)recordTimeChange:(NSTimer *)sender{
    timeCount ++;

//    [self.recordProgress setProgress:timeCount/7.0];

    NSInteger minutes = timeCount/60;
    NSInteger minuteTenUint = minutes/10;
    NSInteger nminuteBit = minutes%10;
    NSInteger second = timeCount%60;
    NSInteger secondTenUint = second/10;
    NSInteger secondBit = second%10;
    _recordTimeLabel.text = [NSString stringWithFormat:@"%ld%ld:%ld%ld",(long)minuteTenUint,(long)nminuteBit,(long)secondTenUint,(long)secondBit];
    NSLog(@"timeInterval = %ld",(long)sender.tolerance);
    if (_recordTime !=0 ) {
        if (timeCount == _recordTime) {
            [self.audioRecorder stop];//停止录制
        }
    }
    
}

/**
 *  点击暂定按钮
 *
 *  @param sender 暂停按钮
 */
- (IBAction)pauseClick:(UIButton *)sender {
    if ([self.audioRecorder isRecording]) {
        [self.audioRecorder pause];

    }
}

/**
 *  点击恢复按钮
 *  恢复录音只需要再次调用record，AVAudioSession会帮助你记录上次录音位置并追加录音
 *
 *  @param sender 恢复按钮
 */
- (IBAction)resumeClick:(UIButton *)sender {
    [self recordClick:sender];
}

/**
 *  点击停止按钮
 *
 *  @param sender 停止按钮
 */
- (IBAction)stopClick:(UIButton *)sender {
    [self.audioRecorder stop];

//    self.audioPower.progress=0.0;
}

#pragma mark - 录音机代理方法
/**
 *  录音完成，录音完成后播放录音
 *
 *  @param recorder 录音机对象
 *  @param flag     是否成功
 */
-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    if (![self.audioPlayer isPlaying]) {
        [self.audioPlayer play];
    }
     NSLog(@"录音完成!");
    //视频录入完成之后在后台将视频存储到相簿
    [timer invalidate];
    timer = nil;
    timeCount = 0;

    //输出本地视频
    NSData *fileData = [NSData dataWithContentsOfFile:[self getSavedPath]];
    _recordAudioSuccessBlock(fileData);
    [[NSFileManager defaultManager] removeItemAtURL:vedioSavePath error:nil];
    [self.navigationController popViewControllerAnimated:YES];

}

@end
