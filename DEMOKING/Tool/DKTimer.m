//
//  DKTimer.m
//  DEMOKING
//
//  Created by 王亚振 on 2021/4/26.
//

#import "DKTimer.h"

@interface DKTimer ()
/*
 每秒频单频计时器；
 每次调用前，会销毁之前的定时器；
 支持计时和倒计时。倒计时到0时，停止计时；
 回调的block均为主线程；
 */
@property (strong, nonatomic) dispatch_source_t singleTimer;
@property (assign, nonatomic) NSInteger current;
@property (assign, nonatomic) NSInteger max;
@property (assign, nonatomic) BOOL sequence;
@property (copy, nonatomic) DKTimerSingleTimerBlock singleTimerBlock;
@end

@implementation DKTimer

/*
 单例类的创建
 使用单例类创建定时器，在一定的环境下，可以高效的控制定时器。
 */
+ (DKTimer *)timer {
    static dispatch_once_t onceToken;
    static DKTimer *timer = nil;
    dispatch_once(&onceToken, ^{
        timer = [[DKTimer alloc] init];
    });
    return timer;
}

#pragma mark --
#pragma mark -- public singleTimer

/*
 倒计时 最小从1开始倒计时
 time：从xx秒开始倒计时
 block: 回调
 */
+ (void)countdown:(NSInteger)time block:(DKTimerSingleTimerBlock)block {
    if (time <= 0) {
        return;
    }
    [DKTimer timer].singleTimerBlock = block;
    [DKTimer timer].sequence = NO;
    [DKTimer timer].current = time;
    [[DKTimer timer] startSingleTime];
}
/*
 计时
 max：计时xx时间
 block: 回调
 */
+ (void)singleTimer:(NSInteger)max block:(DKTimerSingleTimerBlock)block {
    [DKTimer timer].singleTimerBlock = block;
    [DKTimer timer].sequence = YES;
    [DKTimer timer].max = max;
    [DKTimer timer].current = 0;
    [[DKTimer timer] startSingleTime];
}
/*
 取消计时
 */
+ (void)cancelSingleTimer {
    [[DKTimer timer] stopSingleTimer];
}

#pragma mark --
#pragma mark -- private singleTimer

/*
 计时器的回调方法 主线程
 */
- (void)singleTimerMethod {
    if ([DKTimer timer].sequence) {
        // 计时
        [DKTimer timer].current = [DKTimer timer].current + 1;
        BOOL end;
        if ([DKTimer timer].current > [DKTimer timer].max) {
            // 结束
            end = YES;
            [self stopSingleTimer];
        }else {
            // 继续
            end = NO;
        }
        if ([DKTimer timer].singleTimerBlock) {
            [DKTimer timer].singleTimerBlock([DKTimer timer].current, end);
        }
    }else {
        // 倒计时
        [DKTimer timer].current = [DKTimer timer].current - 1;
        BOOL end;
        if ([DKTimer timer].current < 0) {
            // 结束
            end = YES;
            [self stopSingleTimer];
        }else {
            // 继续
            end = NO;
        }
        if ([DKTimer timer].singleTimerBlock) {
            [DKTimer timer].singleTimerBlock([DKTimer timer].current, end);
        }
    }
}

#pragma mark --
#pragma mark -- 计时器创建 开始 销毁

- (void)stopSingleTimer {
    if (_singleTimer) {
        dispatch_cancel(_singleTimer);
        _singleTimer = nil;
    }
}
- (void)startSingleTime {
    [self stopSingleTimer];
    __weak DKTimer *weakself = self;
    NSInteger timeSpace = 1;
    dispatch_queue_t queue = dispatch_get_main_queue();
    self.singleTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    uint64_t interval = (uint64_t)(timeSpace * NSEC_PER_SEC);
    dispatch_source_set_timer(self.singleTimer, start, interval, 0);
    dispatch_source_set_event_handler(self.singleTimer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself singleTimerMethod];
        });
    });
    dispatch_resume(self.singleTimer);
}
@end
