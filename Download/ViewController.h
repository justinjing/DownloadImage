//
//  ViewController.h
//  Download
//
//  Created by justinjing on 15/5/27.
//  Copyright (c) 2015年 justinjing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property(nonatomic,strong)NSMutableData *fileData;
@property(nonatomic,strong)NSFileHandle *writeHandle;
@property(nonatomic,assign)long long currentLength;
@property(nonatomic,assign)long long sumLength;
@property(weak, nonatomic)IBOutlet UIProgressView *progressView;
@property(weak, nonatomic)IBOutlet UIButton *startButton;
@property(weak, nonatomic)IBOutlet UIButton *nextButton;
@property(weak, nonatomic)IBOutlet UILabel *precentLabel;


- (IBAction)star;
- (IBAction)next;

@end

