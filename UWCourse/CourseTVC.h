//
//  CourseTVC.h
//  UWCourse
//
//  Created by Tengyu Cai on 2014-06-07.
//  Copyright (c) 2014 Tengyu Cai. All rights reserved.
//

#import "CommonVC.h"

@protocol CourseDelegate;

@interface CourseTVC : CommonVC

@property (nonatomic,strong) NSString *coursename;
@property (nonatomic,strong) NSArray *courseArray;
@property (nonatomic,weak) id <CourseDelegate> delegate;

-(void)refresh;

@end

@protocol CourseDelegate <NSObject>

-(void)CourseVC:(CourseTVC*)courseVC didSelectCourse:(NSDictionary*)course;

@end
