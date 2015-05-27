//
//  DownLoadImageTask.h
//  Download
//
//  Created by justinjing on 15/5/27.
//  Copyright (c) 2015年 justinjing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol DownLoadImageDelegate;

@interface DownLoadImageTask : NSOperation{
    int operationId;
    long long totalLength;
    BOOL done;
}

@property int operationId;
@property(nonatomic,assign) id <DownLoadImageDelegate> downloadImageDelegate;
@property(nonatomic,retain) NSMutableData *buffer;
@property(nonatomic,retain) NSURLRequest *request;
@property(nonatomic,retain) NSURLConnection *connection;

- (id)initWithURLString:(NSString *)url;
@end


@protocol DownLoadImageDelegate
//图片下载完成的委托
-(void)imageDownLoadFinished:(UIImage *)img;
//更新图片下载进度条的值
-(void)updateDownProgress:(double) value;

@end
