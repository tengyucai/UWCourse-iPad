//
//  CourseTableVC.m
//  UWCourse
//
//  Created by Tengyu Cai on 2014-06-07.
//  Copyright (c) 2014 Tengyu Cai. All rights reserved.
//

#import "CourseTableVC.h"
#import "CourseTableFrameVC.h"

@interface CourseTableVC ()

@end

@implementation CourseTableVC {
    
    NSTimer *timer;
    UIView *currentTimeLine;
    UILabel *currenttimelabel;
    
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
    self.view.backgroundColor = CCOLOR; //RGBA(242, 242, 242, 1);
    self.view.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
    xMargin = 70;
    yMargin = 50;
    numOfHour = 14;
    numOfDay = 5;
    hourHeight = 680/numOfHour;
    dayWidth = (1024-2*xMargin)/5.0;
    NSArray *dayArray = @[@"Mon", @"Tue", @"Wed", @"Thu", @"Fri"];
    
    // draw horizontal line
    for (int i = 0; i < numOfHour; ++i) {
        [self drawHorizontalLineAtHeight:i*hourHeight+yMargin];
        [self drawTimeLabelWithTime:8+i atHeight:i*hourHeight+yMargin];
    }
    
    // draw vertical line
    for (int i = 1; i < numOfDay; ++i) {
        [self drawVerticalLineAtWidth:xMargin+i*dayWidth];
    }
    
    // draw current day
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *weekdayComponents =[gregorian components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
    NSInteger weekday = [weekdayComponents weekday];
    UIView *currentDayView = [[UIView alloc] initWithFrame:(CGRect){70+(weekday-2)*dayWidth,50,dayWidth,self.view.bounds.size.height}];
    currentDayView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    currentDayView.backgroundColor = RGBA(200, 170, 200, 0.5);
    [self.view addSubview:currentDayView];
    
    // draw day label
    for (int i = 0; i < dayArray.count; ++i) {
        [self drawDayLabelWithDay:dayArray[i] atWidth:xMargin+i*dayWidth inDay:dayArray[weekday-2]];
    }

    // draw current time
    timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(minuteTick:) userInfo:nil repeats:YES];
    [timer fire];
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    for (UIViewController *vc in self.childViewControllers) {
        if ([vc isKindOfClass:[CourseTableFrameVC class]]) {
            [vc removeFromParentViewController];
            [vc.view removeFromSuperview];
        }
    }
    [self drawFrames];
    [self checkConflict];
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


#pragma mark - Draw table

-(void)minuteTick:(NSTimer*)timer
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDate *date = [NSDate date];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *currentTime = [dateFormatter stringFromDate:date];
    
    [self drawCurrentTimeLineWithTime:currentTime];
}


-(void)drawCurrentTimeLineWithTime:(NSString*)currentTime
{
    NSString *currentHour = [currentTime substringWithRange:(NSRange){0,2}];
    NSString *currentMinute = [currentTime substringWithRange:(NSRange){3,2}];
    float hour = currentHour.floatValue;
    float minute = currentMinute.floatValue;

    if (hour < 8 || hour > 22) {
        return;
    }
    float height;
    height = (hour+minute/60-8)*hourHeight + hourHeight;
    //NSLog(@"%f, %f, %f",hour,minute, height);
    
    if (!currentTimeLine) {
        currentTimeLine = [[UIView alloc] initWithFrame:(CGRect){xMargin,height,dayWidth*5,2}];
        currentTimeLine.backgroundColor = [UIColor redColor];
        [self.view addSubview:currentTimeLine];
    } else {
        currentTimeLine.frame = (CGRect){xMargin,height,dayWidth*5,2};
    }
    
    if (!currenttimelabel) {
        currenttimelabel = [[UILabel alloc] initWithFrame:(CGRect){xMargin+dayWidth*5,height-30/2,50,30}];
        currenttimelabel.textColor = [UIColor redColor];
        currenttimelabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:currenttimelabel];
    } else {
        currenttimelabel.frame = (CGRect){xMargin+dayWidth*5,height-30/2,50,30};
    }
    currenttimelabel.text = currentTime;
}


-(void)drawTimeLabelWithTime:(int)time atHeight:(float)height
{
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:(CGRect){20,height-30/2,50,30}];
    timeLabel.text = [NSString stringWithFormat:@"%d:00", time];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:timeLabel];
}


-(void)drawDayLabelWithDay:(NSString*)day atWidth:(float)width inDay:(NSString*)weekday
{
    UILabel *dayLabel = [[UILabel alloc] initWithFrame:(CGRect){width,10,dayWidth,40}];
    dayLabel.text = day;
    dayLabel.font = [UIFont systemFontOfSize:20];
    dayLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:dayLabel];
    
    if ([day isEqual:weekday]) {
        dayLabel.backgroundColor = RGBA(220, 50, 50, 0.7);
    }
}


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
    UIView *lineView = [[UIView alloc] initWithFrame:(CGRect){width, yMargin, 2, self.view.bounds.size.height}];
    lineView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    lineView.backgroundColor = RGBA(240, 240, 240, 0.7);
    [self.view addSubview:lineView];
}

#pragma mark - Draw frames

-(void)drawFrames
{
    NSUserDefaults *bookmark = [NSUserDefaults standardUserDefaults];
    NSArray *eventList = [bookmark valueForKey:@"Event List"];
    
    for (NSDictionary *course in eventList) {
        
        // Draw LEC
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
            
            // location
            NSString *location = lecture[@"location"];
            
            // otherInfo
            NSString *title = [NSString stringWithFormat:@"%@ %@ - %@", course[@"lecture"][0][@"coursename"], course[@"lecture"][0][@"coursenum"], lecture[@"section"]];
            NSString *instructor = lecture[@"instructor"];
            
            float originX, originY, height;
            for (int i = 0; i < daysArray.count; ++i) {
                originX = xMargin + ([(NSNumber *)[daysArray objectAtIndex:i] intValue]-1) * dayWidth;
                originY = hourHeight + (startHour+(float)startMinute/60-8)/14*680;
                height = (endHour+(float)endMinute/60 - startHour-(float)startMinute/60)/14.0 * 680;
//                UIView *lectureView = [[UIView alloc] initWithFrame:(CGRect){originX,originY,dayWidth,height}];
//                lectureView.backgroundColor = RGBA(65, 170, 60, 0.5);
//                lectureView.layer.cornerRadius = 8.0f;
//                [self.view addSubview:lectureView];
                CourseTableFrameVC *courseTableFrameVC = [CourseTableFrameVC new];
                courseTableFrameVC.view.frame = (CGRect){originX,originY,dayWidth,height};
                courseTableFrameVC.view.backgroundColor = RGBA(65, 170, 60, 0.4);
                courseTableFrameVC.view.layer.borderColor = RGBA(65, 170, 60, 1.0).CGColor;
                courseTableFrameVC.type = @[@"lecture"].mutableCopy;
                courseTableFrameVC.titles = @[title].mutableCopy;
                courseTableFrameVC.location = @[location].mutableCopy;
                courseTableFrameVC.instructor = nil;
                courseTableFrameVC.startTime = @[startTime].mutableCopy;
                courseTableFrameVC.endTime = @[endTime].mutableCopy;
                courseTableFrameVC.weekdays = @[weekdays].mutableCopy;
                [self addChildViewController:courseTableFrameVC];
                [self.view addSubview:courseTableFrameVC.view];
                [courseTableFrameVC didMoveToParentViewController:self];
            }
            
        }
        
        
        // Draw TUT
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
        
        // location
        NSString *location = tutorialDic[@"location"];
        
        // otherInfo
        NSString *title = [NSString stringWithFormat:@"%@ %@ - %@", lectureArray[0][@"coursename"], lectureArray[0][@"coursenum"], tutorialDic[@"section"]];
        
        float originX, originY, height;
        for (int i = 0; i < daysArray.count; ++i) {
            originX = xMargin + ([(NSNumber *)[daysArray objectAtIndex:i] intValue]-1) * dayWidth;
            originY = hourHeight + (startHour+(float)startMinute/60-8)/14*680;
            height = (endHour+(float)endMinute/60 - startHour-(float)startMinute/60)/14.0 * 680;
//            UIView *lectureView = [[UIView alloc] initWithFrame:(CGRect){originX,originY,dayWidth,height}];
//            lectureView.backgroundColor = RGBA(30, 130, 220, 0.5);
//            lectureView.layer.cornerRadius = 8.0f;
//            [self.view addSubview:lectureView];
            CourseTableFrameVC *courseTableFrameVC = [CourseTableFrameVC new];
            courseTableFrameVC.view.frame = (CGRect){originX,originY,dayWidth,height};
            courseTableFrameVC.view.backgroundColor = RGBA(30, 130, 220, 0.4);
            courseTableFrameVC.view.layer.borderColor = RGBA(30, 130, 220, 1.0).CGColor;
            courseTableFrameVC.type = @[@"lecture"].mutableCopy;
            courseTableFrameVC.titles = @[title].mutableCopy;
            courseTableFrameVC.location = @[location].mutableCopy;
            courseTableFrameVC.instructor = nil;
            courseTableFrameVC.startTime = @[startTime].mutableCopy;
            courseTableFrameVC.endTime = @[endTime].mutableCopy;
            courseTableFrameVC.weekdays = @[weekdays].mutableCopy;
            [self addChildViewController:courseTableFrameVC];
            [self.view addSubview:courseTableFrameVC.view];
            [courseTableFrameVC didMoveToParentViewController:self];
            
        }
    }
}

#pragma mark - Time conflict

// frame1 is on the top of frame2
-(BOOL)isFrame:(UIView*)frame1 andFrameConflict:(UIView*)frame2
{
    return frame1.frame.origin.y <= frame2.frame.origin.y &&
        frame1.frame.origin.y+frame1.frame.size.height >= frame2.frame.origin.y &&
        frame1.frame.origin.x == frame2.frame.origin.x;
}

-(void)checkConflict
{
    for (CourseTableFrameVC *vc1 in self.childViewControllers) {
        if (![vc1 isKindOfClass:[CourseTableFrameVC class]]) {
            continue;
        }
        for (CourseTableFrameVC *vc2 in self.childViewControllers) {
            if (![vc2 isKindOfClass:[CourseTableFrameVC class]]) {
                continue;
            }
            if (vc1 != vc2) {
                if ([self isFrame:vc1.view andFrameConflict:vc2.view]) {
                    
                    NSLog(@"%@",vc1.titles);
                    float originX = vc1.view.frame.origin.x;
                    float originY = vc1.view.frame.origin.y;
                    float height = vc2.view.frame.origin.y + vc2.view.frame.size.height - vc1.view.frame.origin.y;
                    CourseTableFrameVC *courseTableFrameVC = [CourseTableFrameVC new];
                    courseTableFrameVC.view.frame = (CGRect){originX,originY,dayWidth,height};
                    courseTableFrameVC.view.backgroundColor = RGBA(220, 50, 50, 0.4);
                    courseTableFrameVC.view.layer.borderColor = RGBA(220, 50, 50, 1).CGColor;
                    courseTableFrameVC.type = [NSMutableArray arrayWithArray:vc1.type];
                    [courseTableFrameVC.type addObjectsFromArray:vc2.type];
                    NSMutableArray *title = [NSMutableArray arrayWithArray:vc1.titles];
                    [title addObjectsFromArray:vc2.titles];
                    courseTableFrameVC.titles = title;
                    NSMutableArray *location = [NSMutableArray arrayWithArray:vc1.location];
                    [title addObjectsFromArray:vc2.location];
                    courseTableFrameVC.location = location;
                    courseTableFrameVC.instructor = nil;
                    courseTableFrameVC.startTime = [NSMutableArray arrayWithArray:vc1.startTime];
                    [courseTableFrameVC.startTime addObjectsFromArray:vc2.startTime];
                    courseTableFrameVC.endTime = [NSMutableArray arrayWithArray:vc1.endTime];
                    [courseTableFrameVC.endTime addObjectsFromArray:vc2.endTime];
                    courseTableFrameVC.weekdays = [NSMutableArray arrayWithArray:vc1.weekdays];
                    [courseTableFrameVC.weekdays addObjectsFromArray:vc2.weekdays];
                    [self addChildViewController:courseTableFrameVC];
                    [self.view addSubview:courseTableFrameVC.view];
                    [courseTableFrameVC didMoveToParentViewController:self];
                    
                    [vc1 removeFromParentViewController];
                    [vc1.view removeFromSuperview];
                    [vc2 removeFromParentViewController];
                    [vc2.view removeFromSuperview];
                    
                    
                    [self checkConflict];
                    return;
                   
                }
            }
        }
    }
}


@end
