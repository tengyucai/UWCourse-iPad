//
//  CourseDetailVC.h
//  UWCourse
//
//  Created by Tengyu Cai on 2014-06-08.
//  Copyright (c) 2014 Tengyu Cai. All rights reserved.
//

#import "CommonVC.h"

@interface CourseDetailVC : CommonVC

@property (strong, nonatomic) NSDictionary *section;
@property (strong, nonatomic) NSMutableArray *infoArray;
@property (strong, nonatomic) NSString *courseName;

@end
