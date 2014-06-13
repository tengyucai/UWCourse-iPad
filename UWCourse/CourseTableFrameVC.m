//
//  CourseTableFrameVC.m
//  UWCourse
//
//  Created by Tengyu Cai on 2014-06-09.
//  Copyright (c) 2014 Tengyu Cai. All rights reserved.
//

#import "CourseTableFrameVC.h"
#import "CourseFrameDetailVC.h"

@interface CourseTableFrameVC ()

@end

@implementation CourseTableFrameVC {
    UILabel *titleLabel;
    UILabel *locationLabel;
    
    UIPopoverController *popoverController;
}

-(void)loadView
{
    [super loadView];
    
    self.view.layer.cornerRadius = 8.0f;
    self.view.layer.borderWidth = 1.0f;
    self.view.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *gr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(detailAction:)];
    [self.view addGestureRecognizer:gr];
    
    float height = 13;
    NSLog(@"%f", self.view.frame.size.height);
    
    titleLabel = [UILabel new];
    titleLabel.frame = (CGRect){0,self.view.bounds.size.height/4-height/2,self.view.bounds.size.width,height};
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = RGB(100, 50, 150);
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    titleLabel.backgroundColor = CCOLOR;
    [self.view addSubview:titleLabel];
    
    int y = CGRectGetMaxY(titleLabel.frame);
    
    locationLabel = [UILabel new];
    locationLabel.frame = (CGRect){0,self.view.bounds.size.height*3/4-height/2,self.view.frame.size.width,height};
    locationLabel.textAlignment = NSTextAlignmentCenter;
    locationLabel.textColor = RGB(100, 50, 150);
    locationLabel.font = [UIFont systemFontOfSize:13];
    locationLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    locationLabel.backgroundColor = CCOLOR;
    [self.view addSubview:locationLabel];

    
    CourseFrameDetailVC *courseFrameDetailVC = [CourseFrameDetailVC new];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:courseFrameDetailVC];
    popoverController = [[UIPopoverController alloc] initWithContentViewController:nc];
}

-(void)setTitles:(NSMutableArray *)titles
{
    _titles = titles;
    if (titles.count == 1) {
        titleLabel.text = [titles objectAtIndex:0];
    } else {
        for (NSString *text in titles) {
            UILabel *label = [UILabel new];
            label.frame = (CGRect){0,self.view.bounds.size.height/4-13/2,self.view.bounds.size.width,13};
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = RGB(100, 50, 150);
            label.font = [UIFont systemFontOfSize:15];
            label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
            label.backgroundColor = CCOLOR;
            [self.view addSubview:label];
            label.text = [label.text stringByAppendingString:text];
        }
    }
    
}

-(void)setLocation:(NSMutableArray *)location
{
    _location = location;
    if (location.count == 1) {
        locationLabel.text = [[location objectAtIndex:0] mutableCopy];
    }
}

#pragma mark - Action

-(void)detailAction:(UILongPressGestureRecognizer*)gr
{
    if (UIGestureRecognizerStateBegan) {
        
        [popoverController presentPopoverFromRect:[self.view convertRect:self.view.frame fromView:self.view.superview] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    
    
}


@end
