//
//  ASyncDownLoadViewController.h
//  Download
//
//  Created by justinjing on 15/5/27.
//  Copyright (c) 2015年 justinjing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownLoadImageTask.h"

@interface ASyncDownLoadViewController : UIViewController<DownLoadImageDelegate>
 
@property(strong,nonatomic)NSOperationQueue *queue;
@property(strong,nonatomic)UIImageView *appImgView;

@end
