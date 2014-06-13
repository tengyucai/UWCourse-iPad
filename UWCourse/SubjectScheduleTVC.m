//
//  SubjectScheduleTVC.m
//  UWCourse
//
//  Created by Tengyu Cai on 2014-06-07.
//  Copyright (c) 2014 Tengyu Cai. All rights reserved.
//

#import "SubjectScheduleTVC.h"
#import "SubjectVC.h"
#import "CourseTVC.h"
#import "CustomVC.h"
#import "CourseFetcher.h"

@interface SubjectScheduleTVC () <SubjectDelegate, CourseDelegate>

@end

@implementation SubjectScheduleTVC {
    SubjectVC *subjectVC;
    CourseTVC *courseTVC;
    CustomVC *customVC;
}

- (id)init
{
    self = [super init];
    if (self) {
        UIImage *image = [UIImage imageNamed:@"course_list.png"];
        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:@"Course" image:image tag:0];//  initWithTitle:@"Courses" image:nil tag:0];
        [self setTabBarItem:item];
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
    //self.view.backgroundColor = RGBA(190, 190, 90, 0.5);
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background1"]];
    imageView.frame = (CGRect){0,0,1024,768};
    [self.view addSubview:imageView];
    
    UIImageView *logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UniversityOfWaterloo_logo_horiz_rgb"]];
    logoView.frame = (CGRect){1024/2-logoView.bounds.size.width/2,768/2-logoView.bounds.size.height/2,logoView.bounds.size};
    logoView.alpha = 0.1;
    [imageView addSubview:logoView];
    
//    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:(CGRect){0,0,self.view.bounds.size.width,64}];
//    navBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//    navBar.backgroundColor = [UIColor grayColor];
//    [self.view addSubview:navBar];
    
    float tableWidth = 220;
    float yMargin = 20;
    
    subjectVC = [SubjectVC new];
    subjectVC.view.frame = (CGRect){5,yMargin,tableWidth,self.view.bounds.size.height};
    //subjectVC.view.backgroundColor = [UIColor];
    subjectVC.delegate = self;
    [self addChildViewController:subjectVC];
    [self.view addSubview:subjectVC.view];
    [subjectVC didMoveToParentViewController:self];
    
    float x = CGRectGetMaxX(subjectVC.view.frame);
    
    courseTVC = [CourseTVC new];
    courseTVC.view.frame = (CGRect){x,yMargin,tableWidth,self.view.bounds.size.height};
    //courseTVC.view.backgroundColor = [UIColor brownColor];
    courseTVC.delegate = self;
    [self addChildViewController:courseTVC];
    [self.view addSubview:courseTVC.view];
    [courseTVC didMoveToParentViewController:self];
    
    x = CGRectGetMaxX(courseTVC.view.frame);
    
    customVC = [CustomVC new];
    customVC.view.frame = (CGRect){x+5,yMargin,1024-2*tableWidth,self.view.bounds.size.height};
    //customVC.view.backgroundColor = [UIColor yellowColor];
    [self addChildViewController:customVC];
    [self.view addSubview:customVC.view];
    [customVC didMoveToParentViewController:self];

}


#pragma mark - SubjectVC Delegate

- (void)SubjectVC:(SubjectVC *)subjectVC didSelectSubject:(NSString *)courseName
{
    courseTVC.coursename = courseName;
    [courseTVC refresh];
    
}


#pragma mark - CourseTVC Delegate

- (void)CourseVC:(CourseTVC *)courseVC didSelectCourse:(NSDictionary *)course
{
    NSMutableArray *lecArray = [[NSMutableArray alloc]initWithArray:@[]];
    NSMutableArray *tutArray = [[NSMutableArray alloc]initWithArray:@[]];
    NSMutableArray *tstArray = [[NSMutableArray alloc]initWithArray:@[]];
    
    NSUserDefaults *recents = [NSUserDefaults standardUserDefaults];
    
    if (![recents objectForKey:@"Course List"]){
        NSMutableArray *urlArray = [[NSMutableArray alloc] initWithObjects:course, nil];
        [recents setObject:urlArray forKey:@"Course List"];
    } else {
        NSMutableArray *urlArray = [[NSMutableArray alloc] initWithArray:[recents objectForKey:@"Course List"]];
        BOOL isExist = NO;
        for (NSDictionary *photo in urlArray){
            if ([photo isEqualToDictionary:course]){
                isExist = YES;
            }
        }
        if (!isExist){
            [urlArray addObject:course];
            [recents setObject:urlArray forKey:@"Course List"];
            [recents synchronize];
        }
    }
    [self fetchDetail:course[@"subject"] courseNum:course[@"catalog_number"] lecArray:lecArray tutArray:tutArray tstArray:tstArray];
    
    customVC.tutorialArray = tutArray;
    customVC.lectureArray = lecArray;
    customVC.testArray = tstArray;
    customVC.courseName = course[@"subject"];
    customVC.courseNum = course[@"catalog_number"];
    
    [customVC refresh];
}


-(void) fetchDetail:(NSString *)coursename
          courseNum:(NSString *)courseNum
           lecArray:(NSMutableArray *)lectureArray
           tutArray:(NSMutableArray *)tutArray
           tstArray:(NSMutableArray *)tstArray{
    NSURL *url = [CourseFetcher URLForDeatail:coursename courseNum:courseNum];
    NSData *json = [NSData dataWithContentsOfURL:url];
    NSDictionary *subDic = [NSJSONSerialization JSONObjectWithData:json options:0 error:NULL];
    
    NSArray *subArray = subDic[@"data"];
    
    for (NSDictionary *dic in subArray){
        NSString *section = dic[@"section"];
        if ([section hasPrefix:@"LEC"]){
            [lectureArray addObject:dic];
        } else if ([section hasPrefix:@"TUT"]){
            [tutArray addObject:dic];
        } else {
            [tstArray addObject:dic];
        }
    }
}


@end
