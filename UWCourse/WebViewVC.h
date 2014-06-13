//
//  WebViewVC.h
//  UWCourse
//
//  Created by Tengyu Cai on 2014-06-08.
//  Copyright (c) 2014 Tengyu Cai. All rights reserved.
//

#import "CommonVC.h"

@interface WebViewVC : CommonVC

@property (nonatomic, strong) NSURL *initialUrl;
@property (strong,nonatomic) NSString *instructorString;

@end
