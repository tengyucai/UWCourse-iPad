//
//  MiniCourseTableVC.m
//  UWCourse
//
//  Created by Tengyu Cai on 2014-06-10.
//  Copyright (c) 2014 Tengyu Cai. All rights reserved.
//

#import "MiniCourseTableVC.h"

@interface MiniCourseTableVC ()

@end

@implementation MiniCourseTableVC {
    
    float xMargin;
    float yMargin;
    int numOfDay;
    int numOfHour;
    float hourHeight;
    float dayWidth;
}

-(void)loadView
{
    [super loadView];
    self.view.backgroundColor = RGBA(242, 242, 242, 1);
    self.view.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
    xMargin = 0;
    yMargin = 0;
    numOfHour = 14;
    numOfDay = 5;
    hourHeight = 330/numOfHour;
    dayWidth = 560/5.0;
    NSArray *dayArray = @[@"Mon", @"Tue", @"Wed", @"Thu", @"Fri"];
    
    // draw horizontal line
    for (int i = 1; i <= numOfHour; ++i) {
        [self drawHorizontalLineAtHeight:i*hourHeight+yMargin];
    }

    // draw vertical line
    for (int i = 1; i < numOfDay; ++i) {
        [self drawVerticalLineAtWidth:xMargin+i*dayWidth];
    }
    
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self update];
}

-(void)update
{
    for (UIView *view in self.view.subviews) {
        if (view.tag == 1) {
            [view removeFromSuperview];
        }
    }
    [self drawFrames];
}


#pragma mark - Draw table

- (void)drawHorizontalLineAtHeight:(float)height
{
    UIView *lineView = [[UIView alloc] initWithFrame:(CGRect){xMargin, height, dayWidth*5, 1}];
    //lineView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    lineView.backgroundColor = RGBA(240, 240, 240, 0.7);
    [self.view addSubview:lineView];
    
    UIView *halfHourView = [[UIView alloc] initWithFrame:(CGRect){xMargin, height, dayWidth*5, hourHeight/2}];
    halfHourView.backgroundColor = RGBA(200, 190, 160, 0.2);
    [self.view addSubview:halfHourView];
}


- (void)drawVerticalLineAtWidth:(float)width
{
    UIView *lineView = [[UIView alloc] initWithFrame:(CGRect){width, yMargin, 1, self.view.bounds.size.height}];
    lineView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    lineView.backgroundColor = RGBA(210, 210, 210, 1.0);
    [self.view addSubview:lineView];
}


#pragma mark - Draw frames

-(void)drawFrames
{
    NSUserDefaults *bookmark = [NSUserDefaults standardUserDefaults];
    NSArray *eventList = [bookmark valueForKey:@"Event List"];
    
    for (NSDictionary *course in eventList) {
        
        NSArray *lectureArray = course[@"lecture"];
        for (NSDictionary *lecture in lectureArray) {
            
            // weekdays
            NSString *weekdays = lecture[@"weekdays"];
            NSMutableArray *daysArray = [self parseWeekdays:weekdays];
            
            // time
            NSString *startTime = lecture[@"start_time"];
            NSString *endTime = lecture[@"end_time"];
            int startHour = [startTime substringWithRange:(NSRange){0,2}].intValue;
            int startMinute = [startTime substringWithRange:(NSRange){3,2}].intValue;
            int endHour = [endTime substringWithRange:(NSRange){0,2}].intValue;
            int endMinute = [endTime substringWithRange:(NSRange){3,2}].intValue;
            
            // otherInfo
            NSString *title = [NSString stringWithFormat:@"%@ %@  %@", course[@"lecture"][0][@"coursename"], course[@"lecture"][0][@"coursenum"], lecture[@"section"]];
            
            float originX, originY, height;
            for (int i = 0; i < daysArray.count; ++i) {
                originX = xMargin + ([(NSNumber *)[daysArray objectAtIndex:i] intValue]-1) * dayWidth;
                originY = hourHeight + (startHour+(float)startMinute/60-8)/14*330;
                height = (endHour+(float)endMinute/60 - startHour-(float)startMinute/60)/14.0 * 330;
                
                UILabel *lectureView = [[UILabel alloc] initWithFrame:(CGRect){originX,originY,dayWidth,height}];
                lectureView.tag = 1;
                lectureView.text = title;
                lectureView.textAlignment = NSTextAlignmentCenter;
                lectureView.font = [UIFont systemFontOfSize:9];
                lectureView.backgroundColor = RGBA(65, 170, 60, 0.5);
                lectureView.layer.cornerRadius = 4.0f;
                lectureView.clipsToBounds = YES;
                [self.view addSubview:lectureView];
            }
            
        }
        
        
        NSDictionary *tutorialDic = course[@"tutorial"];
        
        // time
        NSString *startTime = tutorialDic[@"start_time"];
        NSString *endTime = tutorialDic[@"end_time"];
        int startHour = [startTime substringWithRange:(NSRange){0,2}].intValue;
        int startMinute = [startTime substringWithRange:(NSRange){3,2}].intValue;
        int endHour = [endTime substringWithRange:(NSRange){0,2}].intValue;
        int endMinute = [endTime substringWithRange:(NSRange){3,2}].intValue;
        
        // weekdays
        NSString *weekdays = tutorialDic[@"weekdays"];
        NSMutableArray *daysArray = [self parseWeekdays:weekdays];
        
        // otherInfo
        NSString *title = [NSString stringWithFormat:@"%@ %@  %@", lectureArray[0][@"coursename"], lectureArray[0][@"coursenum"], tutorialDic[@"section"]];
        
        float originX, originY, height;
        for (int i = 0; i < daysArray.count; ++i) {
            originX = xMargin + ([(NSNumber *)[daysArray objectAtIndex:i] intValue]-1) * dayWidth;
            originY = hourHeight + (startHour+(float)startMinute/60-8)/14*330;
            height = (endHour+(float)endMinute/60 - startHour-(float)startMinute/60)/14.0 * 330;
            
            UILabel *lectureView = [[UILabel alloc] initWithFrame:(CGRect){originX,originY,dayWidth,height}];
            lectureView.tag = 1;
            lectureView.text = title;
            lectureView.textAlignment = NSTextAlignmentCenter;
            lectureView.font = [UIFont systemFontOfSize:9];
            lectureView.backgroundColor = RGBA(30, 130, 220, 0.5);
            lectureView.layer.cornerRadius = 4.0f;
            lectureView.clipsToBounds = YES;
            [self.view addSubview:lectureView];
            
        }
    }
}

-(NSArray*)parseWeekdays:(NSString*)weekdays
{
    NSMutableArray *daysArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < weekdays.length; ++i) {
        char day = [weekdays characterAtIndex:i];
        switch (day) {
            case 'M':
                [daysArray addObject:@(1)];
                break;
            case 'W':
                [daysArray addObject:@(3)];
                break;
            case 'F':
                [daysArray addObject:@(5)];
                break;
            case 'T':
                if (i+1 < weekdays.length && [weekdays characterAtIndex:i+1] == 'h') {
                    [daysArray addObject:@(4)];
                    ++i;
                } else {
                    [daysArray addObject:@(2)];
                }
                break;
            default:
                break;
        }
    }
    return daysArray;
}

@end
