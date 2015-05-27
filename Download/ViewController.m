//
//  ViewController.m
//  Download
//
//  Created by justinjing on 15/5/27.
//  Copyright (c) 2015年 justinjing. All rights reserved.
//

#import "ViewController.h"
#import "ASyncDownLoadViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (IBAction)star {
        //创建下载路径
        NSURL *url=[NSURL URLWithString:@"https://github.com/vivalalova/SideBar/archive/master.zip"];
        //创建一个请求
        NSURLRequest *request=[NSURLRequest requestWithURL:url];
        //发送请求（使用代理的方式）
        [NSURLConnection connectionWithRequest:request delegate:self];
        [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
}

- (IBAction)next{
    ASyncDownLoadViewController* asynViewController=[[ASyncDownLoadViewController alloc]init];
    [self presentViewController:asynViewController animated:YES completion:nil];
    
}

#pragma mark- NSURLConnectionDataDelegate代理方法
/**当接收到服务器的响应（连通了服务器）时会调用*/
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //1.创建文件存储路径
    NSString *caches=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath=[caches stringByAppendingPathComponent:@"video.zip"];
    
    //2.创建一个空的文件,到沙盒中
    NSFileManager *mgr=[NSFileManager defaultManager];
    //刚创建完毕的大小是o字节
    [mgr createFileAtPath:filePath contents:nil attributes:nil];
    
    //3.创建写数据的文件句柄
    self.writeHandle=[NSFileHandle fileHandleForWritingAtPath:filePath];
    
    //4.获取完整的文件的长度
    self.sumLength=response.expectedContentLength;
    NSLog(@"获取完整的文件的长度---%lu",(unsigned long)self.sumLength);
}

/**当接收到服务器的数据时会调用（可能会被调用多次，每次只传递部分数据）*/
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //累加接收到的数据
    self.currentLength+=data.length;
    
    //计算当前进度(转换为double型的)
    double progress=(double)self.currentLength/self.sumLength;
     NSLog(@"！---%f",progress);
    self.progressView.progress=progress;
    
    //一点一点接收数据。
    NSLog(@"接收到服务器的数据！---%lu",(unsigned long)data.length);
    self.precentLabel.text= [NSString stringWithFormat:@"%.0f%%", progress*100];
    //把data写入到创建的空文件中，但是不能使用writeTofile(会覆盖)
    //移动到文件的尾部
    [self.writeHandle seekToEndOfFile];
    //从当前移动的位置，写入数据
    [self.writeHandle writeData:data];
}

/**当服务器的数据加载完毕时就会调用*/

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"下载完毕");
    //关闭连接，不再输入数据在文件中
    [self.writeHandle closeFile];
    //销毁
    self.writeHandle=nil;
    //在下载完毕后，对进度进行清空
    self.currentLength=0;
    self.sumLength=0;
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
}

/**请求错误（失败）的时候调用（请求超时\断网\没有网\，一般指客户端错误）*/
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
