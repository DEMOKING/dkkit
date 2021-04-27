//
//  DKTimer.h
//  DEMOKING
//
//  Created by 王亚振 on 2021/4/26.
//

#import <Foundation/Foundation.h>
/*
 每秒频单频计时器回调
 current 每秒回调一次 回调当前的时间
 end 当为TRUE时 定时器结束
 */
typedef void (^DKTimerSingleTimerBlock)(NSInteger current, BOOL end);

@interface DKTimer : NSObject
/*
 倒计时
 time：从xx秒开始倒计时
 block: 回调
 */
+ (void)countdown:(NSInteger)time block:(DKTimerSingleTimerBlock)block;
/*
 计时
 max：计时xx时间
 block: 回调
 */
+ (void)singleTimer:(NSInteger)max block:(DKTimerSingleTimerBlock)block;
/*
 取消计时
 */
+ (void)cancelSingleTimer;
@end
