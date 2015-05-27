//
//  DownLoadImageTask.m
//  Download
//
//  Created by justinjing on 15/5/27.
//  Copyright (c) 2015年 justinjing. All rights reserved.
//

#import "DownLoadImageTask.h"

@implementation DownLoadImageTask
@synthesize operationId;
@synthesize downloadImageDelegate;
@synthesize buffer;
@synthesize request;
@synthesize connection;


- (id)initWithURLString:(NSString *)url{
    self = [super init];
    if(self){
        request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        buffer = [NSMutableData data];
    }
    return self;
}

//主要处理方法
-(void)start{ //或者main
    NSLog(@"DownLoadImageTask-start");
    
    if(![self isCancelled]){
        //暂停一下
        [NSThread sleepForTimeInterval:1];
        //设置connection及其代理
        connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
        if(connection!=nil){
            while(!done){
                [[NSRunLoop currentRunLoop]runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            }
        }
    }
}

-(void)httpConnectEndWithError{
    //[self hiddenWaiting];
    NSLog(@"httpConnectEndWithError");
}

-(void)dealloc{
    buffer = nil;
    connection = nil;
    request = nil;
    downloadImageDelegate = nil;
}

#pragma NSURLConnection delegate methods
//不执行缓存
-(NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse{
    return nil;
}

//连接发生错误
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [self performSelectorOnMainThread:@selector(httpConnectEndWithError) withObject:self waitUntilDone:NO];
    [buffer setLength:0];
}

//收到响应
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if(httpResponse && [httpResponse respondsToSelector:@selector(allHeaderFields)]){
        NSDictionary *httpResponseHeaderFields = [httpResponse allHeaderFields];
        totalLength = [[httpResponseHeaderFields objectForKey:@"Content-Length"] longLongValue];
        NSLog(@"totalLength is %lld",totalLength);
    }
}

//接收数据
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    //NSLog(@"didReceiveData...");
    [buffer appendData:data];
    
    double progressValue = totalLength==0?0:((double)([buffer length])/(double)totalLength);
    //更新进度条值
    [downloadImageDelegate updateDownProgress:progressValue];
}

//下载完毕
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    done = YES;
    UIImage *img = [[UIImage alloc] initWithData:buffer];
    [downloadImageDelegate imageDownLoadFinished:img];
}

-(BOOL)isConcurrent {
    //返回yes表示支持异步调用，否则为支持同步调用
    return YES;
    
}

- (BOOL)isExecuting{
    return connection == nil; 
}

- (BOOL)isFinished{
    return connection == nil; 
}
@end
