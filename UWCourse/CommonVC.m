//
//  CommonVC.m
//  UWCourse
//
//  Created by Tengyu Cai on 2014-06-07.
//  Copyright (c) 2014 Tengyu Cai. All rights reserved.
//

#import "CommonVC.h"

@interface CommonVC ()

@end

@implementation CommonVC {
    UIActivityIndicatorView *activityIndicator;
}

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(void)loadView{
    
    self.view = [[UIView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    //self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
}


-(void)activityIndicator:(BOOL)show{
    
    if (show) {
        if (!activityIndicator) {
            activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            activityIndicator.bounds = (CGRect){0,0,50,50};
            activityIndicator.center = self.view.center;
            activityIndicator.backgroundColor = RGBA(0, 0, 0, 0.8);
            activityIndicator.layer.cornerRadius = 10;
            [self.view addSubview:activityIndicator];
        }
        activityIndicator.hidden = NO;
        [activityIndicator startAnimating];
        self.view.userInteractionEnabled = NO;
    }else{
        if (activityIndicator) {
            [activityIndicator removeFromSuperview];
        }
        
        self.view.userInteractionEnabled = YES;
    }
}



- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


@end
