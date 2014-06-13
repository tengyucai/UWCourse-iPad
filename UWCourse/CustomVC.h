//
//  CustomVC.h
//  UWCourse
//
//  Created by Tengyu Cai on 2014-06-07.
//  Copyright (c) 2014 Tengyu Cai. All rights reserved.
//

#import "CommonVC.h"

@interface CustomVC : CommonVC
{
    UITableView *tableView;
    NSMutableArray *lecArray;
    NSMutableArray *tutArray;
    NSMutableArray *tstArray;
}

@property (nonatomic, strong) UIPickerView *picker;
@property (nonatomic, strong) NSArray *lectureArray;
@property (nonatomic, strong) NSArray *tutorialArray;
@property (nonatomic, strong) NSArray *testArray;
@property (nonatomic, strong) NSString *courseName;
@property (nonatomic, strong) NSString *courseNum;

- (void)refresh;

@end
