//
//  ZYRecordVedioViewController.h
//  AVFoundationCamera
//
//  Created by Char on 16/8/18.
//  Copyright © 2016年 Bogon. All rights reserved.
//
/**
 *  隐藏了2个功能块，一个是时间显示，一个是切换前后摄像头
 *  在完成七秒钟的录制之后，直接返回，执行回调函数；如在七秒之前完成视频的录制，则直接执行回调函数
 *  返回的数据说明：在录制完成之后，以10s为例，原始视频大小是10M左右，压缩之后的视频大小是：1M
                  由于现在设定的是7秒，视频大小是在400-500K左右
 */
#import <UIKit/UIKit.h>

@interface ZYRecordVedioViewController : UIViewController
typedef void (^RecordVedioSuccessBlock)(NSData *vedioData);
/**
 *  视频录制时间  设置时间后就是需要录制的时长，如不设置默认时长：20S
 */
@property (nonatomic,assign) NSInteger recordTime;
@property (copy,nonatomic) RecordVedioSuccessBlock recordVedioSuccessBlock;

@end
