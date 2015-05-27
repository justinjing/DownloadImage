//
//  ASyncDownLoadViewController.m
//  Download
//
//  Created by justinjing on 15/5/27.
//  Copyright (c) 2015年 justinjing. All rights reserved.
//

#import "ASyncDownLoadViewController.h"

@interface ASyncDownLoadViewController ()

@end

@implementation ASyncDownLoadViewController

@synthesize queue;
@synthesize appImgView;

-(void)backClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    //初始化视图组件
    CGRect frame = [UIScreen mainScreen].bounds;
    frame = CGRectMake(0, 20, frame.size.width, frame.size.height);
    appImgView = [[UIImageView alloc]initWithFrame:frame];
    [self.view addSubview:appImgView];
    
    
    UIButton *backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(20, 40, 40, 50);
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton setTitle:@"返回" forState:UIControlStateHighlighted];
    [self.view addSubview:backButton];
    [backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    
    //显示等待框
    [self showWaiting];
    NSString *url = @"http://hiphotos.baidu.com/newwen666666/pic/item/01ec7750863e49600cf3e3cc.jpg";
    //int index = 1;
    
    DownLoadImageTask *task = [[DownLoadImageTask alloc]initWithURLString:url];
    task.downloadImageDelegate = self;
    //  task.operationId = index++;
    
    queue = [[NSOperationQueue alloc]init];
    [queue addOperation:task];  //将Task加入NSOperationQueue开始执行

}


//展示等待框
-(void)showWaiting{
    CGRect frame = [UIScreen mainScreen].bounds;
    int x = frame.size.width;
    
    UIProgressView *progress = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleBar];
    progress.frame = CGRectMake((x-150)/2, 100, 150, 32);
    progress.progress = 0.0;
    progress.backgroundColor = [UIColor whiteColor];
    
    UILabel *showValue = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(progress.frame)+10,90, 65, 25)];
    showValue.textAlignment=NSTextAlignmentCenter;
    showValue.backgroundColor = [UIColor redColor];
    showValue.text = @"0.0";
    
    
    int progressIndWidth = 32;
    
    UIActivityIndicatorView *progressInd = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake((x-progressIndWidth)/2, 100+32, progressIndWidth, progressIndWidth)];
    [progressInd startAnimating];
    progressInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    
    
    UILabel *waitinglabel = [[UILabel alloc]initWithFrame: CGRectMake(0,100+32+32,[UIScreen mainScreen].bounds.size.width,30)];
    waitinglabel.text = @"正在下载应用程序图片...";
    waitinglabel.textColor = [UIColor redColor];
    waitinglabel.textAlignment= NSTextAlignmentCenter;
    waitinglabel.font = [UIFont systemFontOfSize:15];
    waitinglabel.backgroundColor = [UIColor clearColor];
    
    UIView *theView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    theView.backgroundColor = [UIColor blackColor];
    theView.alpha = 0.7;
    
    [progress setTag:100];
    [theView addSubview:progress];
    [showValue setTag:101];
    [theView addSubview:showValue];
    
    [theView addSubview:progressInd];
    [theView addSubview:waitinglabel];
    
    [theView setTag:110];
    [self.view addSubview:theView];
}

//隐藏等待框
-(void)hiddenWaiting{
    [[self.view viewWithTag:110]removeFromSuperview];
}


#pragma mark DownLoadImageDelegate methods
//展示下载完毕的图片
-(void)imageDownLoadFinished:(UIImage *)img{
    //退出等待框
    [self hiddenWaiting];
    [appImgView setImage:img];
}

//更新进度条的值
-(void)updateDownProgress:(double) value{
    UIProgressView *progresss = (UIProgressView *)[self.view viewWithTag:100];
    UILabel *showValue = (UILabel*)[self.view viewWithTag:101];
    progresss.progress = value;
    showValue.text = [NSString stringWithFormat:@"%.1f%%",(double)(value*100)];
}
@end
