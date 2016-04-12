//
//  WXSOperation.h
//  QuatrzDemo
//
//  Created by 王小树 on 16/4/12.
//  Copyright © 2016年 王小树. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^OperationBlock) ();

@interface WXSOperation : NSOperation

/**
 *  Operation code  block
 */
@property (nonatomic,copy) OperationBlock operationBlock;
/**
 *  if want asyn or syn to set YES or NO
 */
@property (nonatomic,assign) BOOL isAsyn;


-(instancetype)initWithOperationBlock:(OperationBlock)operationBlock;



/**
 *  异步任务
 *
 *  @param operationBlock opertion code
 */
+(void)asynOperationBlock:(OperationBlock )operationBlock;
/**
 *  同步任务
 *
 *  @param operationBlock opertion code
 */
+(void)synOperationBlock:(OperationBlock )operationBlock;

@end
