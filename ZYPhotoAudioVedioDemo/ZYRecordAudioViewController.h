//
//  ZYRecordAudioViewController.h
//  ZYPhotoAudioVedioDemo
//
//  Created by Char on 16/8/19.
//  Copyright © 2016年 Bogon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYRecordAudioViewController : UIViewController
typedef void (^RecordAudioSuccessBlock)(NSData *audioData);
/**
 *  视频录制时间  设置时间后就是需要录制的时长，如不设置默认时长：20S
 */
@property (nonatomic,assign) NSInteger recordTime;
@property (copy,nonatomic) RecordAudioSuccessBlock recordAudioSuccessBlock;
@end
