//
//  CourseTVC.m
//  UWCourse
//
//  Created by Tengyu Cai on 2014-06-07.
//  Copyright (c) 2014 Tengyu Cai. All rights reserved.
//

#import "CourseTVC.h"
#import "CourseFetcher.h"
#import "SubjectVC.h"
#import "Reachability.h"
#import "CourseCell.h"

@interface CourseTVC () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation CourseTVC {
    UITableView *courseTableView;
}


- (void)loadView
{
    [super loadView];
    
    courseTableView = [[UITableView alloc] initWithFrame:(CGRect){0,0,self.view.bounds.size.width, 690} style:UITableViewStylePlain];
    courseTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    courseTableView.backgroundColor = CCOLOR;
    courseTableView.delegate = self;
    courseTableView.dataSource = self;
    courseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [courseTableView registerClass:[CourseCell class] forCellReuseIdentifier:@"course"];
    [self.view addSubview:courseTableView];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    if (self.coursename) {
        [self refresh];
    }
}

-(void)refresh
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:)name:kReachabilityChangedNotification object:nil];
    Reachability *reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    [reach startNotifier];
}

-(void)setCourseArray:(NSArray *)courseArray{
    _courseArray = courseArray;
    
    [courseTableView reloadData];
}


-(void)reachabilityChanged:(NSNotification*)note
{
    Reachability * reach = [note object];
    
    if([reach isReachable])
    {
        [self fetchCourse];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"NO INTERNET" message:@"Please connect your device to internet" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        [alert show];
    }
}


-(void) fetchCourse{
    dispatch_queue_t subQueue = dispatch_queue_create("subect", NULL);
    dispatch_async(subQueue, ^{
        NSURL *url = [CourseFetcher URLForCourse:self.coursename];
        NSData *json = [NSData dataWithContentsOfURL:url];
        NSDictionary *subDic = [NSJSONSerialization JSONObjectWithData:json options:0 error:NULL];
        NSArray *courseArray = subDic[@"data"];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.courseArray = courseArray;
        });
    });
}


#pragma mark - Table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.courseArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString *CellIdentifier = @"Cell";
    CourseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"course" forIndexPath:indexPath];
    
    // Configure the cell...
    if (!cell) {
        cell = [[CourseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"course"];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    if (tableView == courseTableView) {
        NSDictionary *courseDic = self.courseArray[indexPath.row];
        NSString *course = [NSString stringWithFormat:@"%@ %@",courseDic[@"subject"],courseDic[@"catalog_number"]];
        cell.courseLabel.text = course;
        cell.courseDetailLabel.text = courseDic[@"title"];
    }
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIImageView *av = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 20, 20)];
    av.backgroundColor = [UIColor clearColor];
    av.opaque = NO;
    av.image = nil;[UIImage imageNamed:@"background1"];
    //    UIView *av = [[UIView alloc]initWithFrame:self.view.frame];
    //    av.backgroundColor = CCOLOR;
    //    av.opaque = NO;
    cell.backgroundView = av;
    
    if (cell.contentView.subviews) {
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
    }
    
    cell.contentView.backgroundColor = [UIColor clearColor];
    UIView *whiteRoundedCornerView = [[UIView alloc] initWithFrame:CGRectMake(5,10,self.view.bounds.size.width,50)];
    whiteRoundedCornerView.backgroundColor = RGBA(155, 115, 50, 0.1);
    whiteRoundedCornerView.layer.masksToBounds = NO;
    whiteRoundedCornerView.layer.cornerRadius = 3.0;
    whiteRoundedCornerView.layer.shadowOffset = CGSizeMake(-1, 1);
    whiteRoundedCornerView.layer.shadowOpacity = 0.4;
    [cell.contentView addSubview:whiteRoundedCornerView];
    [cell.contentView sendSubviewToBack:whiteRoundedCornerView];
    
    UIView *selectedView = [[UIView alloc] initWithFrame:whiteRoundedCornerView.frame];
    selectedView.backgroundColor = RGBA(155, 115, 50, 0.2);
    selectedView.layer.masksToBounds = NO;
    selectedView.layer.cornerRadius = 3.0;
    selectedView.layer.shadowOffset = CGSizeMake(-1, 1);
    selectedView.layer.shadowOpacity = 0.4;
    cell.selectedBackgroundView = selectedView;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_delegate) {
        NSDictionary *course = self.courseArray[indexPath.row];
        [_delegate CourseVC:self didSelectCourse:course];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


#pragma mark - Navigation

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
