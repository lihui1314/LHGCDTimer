//
//  LHGCDTimer.h
//
//  Created by lihui on 2020/6/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LHGCDTimer : NSObject
#pragma mark - 构造器
- (instancetype)initWithExecuteQueue: (dispatch_queue_t)queue;
#pragma mark - 操作
- (void)execute: (dispatch_block_t)block interval: (NSTimeInterval)interval;
- (void)execute: (dispatch_block_t)block interval: (NSTimeInterval)interval delay: (NSTimeInterval)delay;
- (void)resume;
- (void)pause;
- (void)destroy;

@end

NS_ASSUME_NONNULL_END
