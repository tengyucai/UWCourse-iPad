//
//  CourseTableContainerVC.m
//  UWCourse
//
//  Created by Tengyu Cai on 2014-06-12.
//  Copyright (c) 2014 Tengyu Cai. All rights reserved.
//

#import "CourseTableContainerVC.h"
#import "CourseTableVC.h"

@interface CourseTableContainerVC ()

@end

@implementation CourseTableContainerVC {
    CourseTableVC *courseTableVC;
}

- (id)init
{
    self = [super init];
    if (self) {
        
        UIImage *image = [UIImage imageNamed:@"time_table"];
        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:@"Course Table" image:image tag:1]; //initWithTitle:@"Course Table" image:nil tag:1];
        [self setTabBarItem:item];
    }
    
    return self;
}

-(void)loadView
{
    [super loadView];
    
    UIImageView *backgroundImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background1"]];
    backgroundImageView.frame = (CGRect){0,0,1024,768};
    [self.view addSubview:backgroundImageView];
    
    UIImageView *logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UniversityOfWaterloo_logo_horiz_bk"]];
    logoView.frame = (CGRect){1024/2-logoView.bounds.size.width/2,768/2-logoView.bounds.size.height/2,logoView.bounds.size};
    logoView.alpha = 0.05;
    [backgroundImageView addSubview:logoView];
    
    courseTableVC = [CourseTableVC new];
    courseTableVC.view.frame = (CGRect){0,0,1024,768};
    [self addChildViewController:courseTableVC];
    [self.view addSubview:courseTableVC.view];
    [courseTableVC didMoveToParentViewController:self];
    
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
