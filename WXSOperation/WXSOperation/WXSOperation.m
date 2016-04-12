//
//  WXSOperation.m
//  QuatrzDemo
//
//  Created by 王小树 on 16/4/12.
//  Copyright © 2016年 王小树. All rights reserved.
//

#import "WXSOperation.h"
@interface WXSOperation ()
{
    BOOL _isFinished;
    BOOL _isExecuting;
    
}
@end
@implementation WXSOperation

-(instancetype)initWithOperationBlock:(OperationBlock)operationBlock {
    self = [super init];
    if (self) {
        _isAsyn = YES;
        _operationBlock = operationBlock;
    }
    return self;
}

//NSOperation 的子类化一般都是采取重写start main方法，但是也可以自己实现其他方法,可以参考一下AFNetWorking
-(void)start {
    
    //同步情况是才会调用start
    _isAsyn = NO;
    
    if (self.cancelled) { //被取消
        _isFinished = YES;
    }else { //未被取消
        _isExecuting = YES;
        [self main];
    }
}
-(void)main {
    @autoreleasepool {
        
        void (^cancelBlock)() = ^() {
            _isExecuting = NO;
            _isFinished = YES;
        };
        if (!self.isCancelled) {
            _operationBlock();
            cancelBlock();
        }
    }
}

//重写getter 方法是为了在外部能完整获取相关信息
#pragma mark 重写getter方法
-(BOOL)isFinished {
    return _isFinished;
}

-(BOOL)isConcurrent{
    return !_isAsyn;
}
-(BOOL)isExecuting {
    return _isExecuting;
}

#pragma mark Class Method

//异步
+(void)asynOperationBlock:(OperationBlock)operationBlock {
    WXSOperation *operation = [[WXSOperation alloc] init];
    operation.operationBlock = [operationBlock copy];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
    
}

//同步
+(void)synOperationBlock:(OperationBlock)operationBlock {
    WXSOperation *operation = [[WXSOperation alloc] initWithOperationBlock:operationBlock];
    
    //如果添加到queue里，依然是异步
    [operation start];
}
@end
