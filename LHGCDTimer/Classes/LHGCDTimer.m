//
//  LHGCDTimer.m
//
//  Created by lihui on 2020/6/23.
//

#import "LHGCDTimer.h"
@interface LHGCDTimer ()

/// YES 表示正在活跃状态   加入这个属性防止崩溃
@property (nonatomic, assign) BOOL execute;

@property (nonatomic, strong , nonnull) dispatch_source_t executeSource;
@property (nonatomic, copy) dispatch_block_t block;
@property (nonatomic, assign) NSTimeInterval interval;
@property (nonatomic, strong) dispatch_queue_t executeQueue;

@end

@implementation LHGCDTimer

- (void)dealloc {
    [self destroy];
}

- (instancetype)init {
    if (self = [super init]) {
        dispatch_queue_t queue = dispatch_queue_create("com.lh.gcd.timer", DISPATCH_QUEUE_SERIAL);
        self.executeQueue = queue;
        self.executeSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, self.executeQueue);
        self.execute = NO;
    }
    return self;
}

- (instancetype)initWithExecuteQueue: (dispatch_queue_t )queue {
    if (self = [super init]) {
        self.executeQueue = queue;
        self.executeSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, self.executeQueue);
        self.execute = NO;
    }
    return self;
}

#pragma mark - 操作
- (void)execute: (dispatch_block_t)block interval: (NSTimeInterval)interval {
    [self execute: block interval: interval delay: 0];
}

- (void)execute: (dispatch_block_t)block interval: (NSTimeInterval)interval delay: (NSTimeInterval)delay {
    NSParameterAssert(block);
    self.block = block;
    self.interval = interval;
    dispatch_source_set_timer(self.executeSource, dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC), self.interval * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(self.executeSource, block);
}

- (void)resume {
    if (!_executeSource) {
        self.executeSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, _executeQueue);
        [self execute: _block interval: _interval];
    }
    if (!self.execute) {
        dispatch_resume(self.executeSource);
        self.execute = YES;
    }
}

- (void)pause {
    if (_executeSource && self.execute) {
        dispatch_suspend(self.executeSource);
        self.execute = NO;
    }
}

- (void)destroy {
    if (_executeSource && !self.execute) {
        [self resume];
    }
    if (_executeSource) {
        dispatch_source_cancel(self.executeSource);
    }
}

@end
