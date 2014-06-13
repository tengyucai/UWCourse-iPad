//
//  CourseTableFrameVC.h
//  UWCourse
//
//  Created by Tengyu Cai on 2014-06-09.
//  Copyright (c) 2014 Tengyu Cai. All rights reserved.
//

#import "CommonVC.h"

@interface CourseTableFrameVC : CommonVC

@property (strong, nonatomic) NSMutableArray *titles;
@property (strong, nonatomic) NSMutableArray *type;
@property (strong, nonatomic) NSMutableArray *location;
@property (strong, nonatomic) NSMutableArray *instructor;
@property (strong, nonatomic) NSMutableArray *startTime;
@property (strong, nonatomic) NSMutableArray *endTime;
@property (strong, nonatomic) NSMutableArray *weekdays;


-(void)setTitles:(NSMutableArray *)titles;
-(void)setLocation:(NSMutableArray *)location;

@end
