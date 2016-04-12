//
//  ViewController.m
//  WXSOperation
//
//  Created by 王小树 on 16/4/12.
//  Copyright © 2016年 王小树. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic,strong) UIImageView *imgView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//================== NSInvocationOperation NSBlockOperation 操作 ==============
    UILabel *label  = [[UILabel alloc] init];
    label.frame = CGRectMake(40, 40, 100, 20);
    label.text = @"页面已经显示";
    [self.view addSubview:label];
    
    self.imgView = [[UIImageView alloc] init];
    self.imgView.frame = CGRectMake(30, 30, 50, 50);
    self.imgView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.imgView];
    
    
    NSInvocationOperation *invocationOperation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(invocationOperationAction) object:nil];
    
    
    
    __weak ViewController *weakSelf = self;
    NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
        
        for (int i = 0; i < 3 ; i++) {
            [NSThread sleepForTimeInterval:0.5];
            NSLog(@"线程block--%d",i);
        }
        
        //异步加载图片时要到主线程显示
        NSURL *url = [NSURL URLWithString:@"https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1459910345&di=297c58ac877a35d5cd21f1b12e25ddf0&src=http://a.hiphotos.baidu.com/lvpics/w=1000/sign=c9a07988672762d0803ea0bf90dc09fa/359b033b5bb5c9ea7582c548d139b6003af3b32c.jpg"];
        NSData *data = [[NSData alloc] initWithContentsOfURL:url];
        UIImage *img = [[UIImage alloc] initWithData:data];
        if (img) {
            [weakSelf performSelectorOnMainThread:@selector(updateImgView:) withObject:img waitUntilDone:YES];
        }
        
        
    }];
    
    //---------------- 执行任务方式一：用start方法 ------------------
    /**用start执行线程任务时为同步效果，blockOperation、invocationOperation阻塞主线程
     *要等到blockOperation、invocationOperation两个线程任务执行完毕之后self.view的背景色才会变为黄色
     //     */
    //    NSLog(@"没有变色"); //这句话一开始就会打印出来，而label 和imgView 要等两个operation后才显示出来。因为UI要在主线程上渲染后显示，start阻塞了主线程。
    //    [blockOperation start];
    //    [invocationOperation start];
    //    NSLog(@"变色");
    //    self.view.backgroundColor = [UIColor yellowColor];
    
    
    //---------------  执行任务方式二：加入NSOperationQueue (两种方式运行的时候要注释掉其中一种) -----------
    //线程任务与主线程异步，不会阻塞主线程，self.view 的颜色一开始就变为黄色
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    //设置最大的线程并行数量 如果为1的话就相当于串行，大于1时为并行
    queue.maxConcurrentOperationCount = 2;
    [queue addOperation:blockOperation];
    [queue addOperation:invocationOperation];
    self.view.backgroundColor = [UIColor yellowColor];
    
    
    //取消所有operation
    [queue cancelAllOperations];
    
    [blockOperation setQueuePriority:NSOperationQueuePriorityNormal];
    
    
    [blockOperation addDependency:invocationOperation];
    
    //取消任务
    [blockOperation cancel];
    [blockOperation start];
    [queue setSuspended:YES]; //YES 暂停 NO 恢复
    
    
//======================== 自定义子类化 ==============================
    
    [WXSOperation synOperationBlock:^{
        NSLog(@"同步");
        [NSThread sleepForTimeInterval:3];
        NSLog(@"同步");
        
    }];
    
    [WXSOperation asynOperationBlock:^{
        for (int i = 0; i < 10; i++) {
            NSLog(@"异步线程1-------");
            [NSThread sleepForTimeInterval:0.5];
        }
        
    }];
    
    
    [WXSOperation asynOperationBlock:^{
        for (int i = 0; i < 10; i++) {
            NSLog(@"异步线程2-------");
            [NSThread sleepForTimeInterval:0.5];
        }
    }];
    

    
}

-(void)invocationOperationAction {
    for (int i = 0; i < 5 ; i++) {
        [NSThread sleepForTimeInterval:0.5];
        NSLog(@"线程invocation--%d",i);
    }
}

- (void)updateImgView:(UIImage *)image {
    self.imgView.image = image;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
