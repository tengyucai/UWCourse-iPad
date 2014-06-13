//
//  CourseDetailVC.m
//  UWCourse
//
//  Created by Tengyu Cai on 2014-06-08.
//  Copyright (c) 2014 Tengyu Cai. All rights reserved.
//

#import "CourseDetailVC.h"
#import "CourseDetailCell.h"
#import "WebViewVC.h"

@interface CourseDetailVC () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation CourseDetailVC {
    UITableView *detailTableView;
}

- (void)loadView
{
    [super loadView];
    
    self.title = self.courseName;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneAction)];
    
    float x = 0;
    float y = 0;
    
    detailTableView = [[UITableView alloc] initWithFrame:(CGRect){x, y, self.view.frame.size.width-2*x,self.view.frame.size.height} style:UITableViewStyleGrouped];
    detailTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    detailTableView.delegate = self;
    detailTableView.dataSource = self;
    [detailTableView registerClass:[CourseDetailCell class] forCellReuseIdentifier:@"Detail Cell"];
    detailTableView.backgroundColor = CCOLOR;
    [self.view addSubview:detailTableView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self changeForm];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.navigationController.view.superview.bounds = CGRectMake(0, 0, 400, 460);
    
    CGRect rect = self.navigationController.view.superview.frame;
    rect.origin.y = 768/2-self.view.bounds.size.height/2;
    rect.origin.x = 1024/2-self.view.bounds.size.width/2;
    self.navigationController.view.superview.frame = rect;
}

-(void) changeForm{
    NSMutableArray *infoArray = [[NSMutableArray alloc]init];
    [infoArray addObject:@{@"head":@"Class Number",
                           @"content":[NSString stringWithFormat:@"%@",self.section[@"class_number"]]}];
    [infoArray addObject:@{@"head":@"Campus",
                           @"content":self.section[@"campus"]}];
    [infoArray addObject:@{@"head":@"Entollment Capacity",
                           @"content":[NSString stringWithFormat:@"%@",self.section[@"enrollment_capacity"]]}];
    [infoArray addObject:@{@"head":@"Entollment Total",
                           @"content":[NSString stringWithFormat:@"%@",self.section[@"enrollment_total"]]}];
    
    NSArray *instructorArray = self.section[@"classes"][0][@"instructors"];
    if ([instructorArray isEqualToArray:@[]]){
        [infoArray addObject:@{@"head":@"Instructor",
                               @"content":@"No Instructor Found"}];
        
    } else {
        [infoArray addObject:@{@"head":@"Instructor",
                               @"rateMyProf":@(YES),
                               @"content":instructorArray[0]}];
    }
    [infoArray addObject:@{@"head":@"Term",
                           @"content":[NSString stringWithFormat:@"%@",self.section[@"term"]]}];
    [infoArray addObject:@{@"head":@"Last Updated",
                           @"content":self.section[@"last_updated"]}];
    self.infoArray = infoArray;
}

#pragma mark - Action

- (void)doneAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
    return [self.infoArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CourseDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Detail Cell" forIndexPath:indexPath];
    NSDictionary *box = self.infoArray[indexPath.row];
    if ([box[@"head"] isEqualToString:@"Instructor"] && box[@"rateMyProf"]) {
        cell.backgroundColor = [UIColor greenColor];
        cell.catagoryLabel.text = [NSString stringWithFormat:@"%@ (Rate My Prof)", box[@"head"]];
    } else {
        cell.catagoryLabel.text = box[@"head"];
    }
    cell.infoLabel.text = box[@"content"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //CourseDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Detail Cell" forIndexPath:indexPath];
    NSDictionary *box = self.infoArray[indexPath.row];
//    cell.catagoryLabel.text = box[@"head"];
//    cell.infoLabel.text = box[@"content"];
    
    if ([box[@"head"] isEqualToString:@"Instructor"] && ![box[@"content"] isEqualToString:@"No Instructor Found"]){

        WebViewVC *webViewVC = [WebViewVC new];
        NSDictionary *info  = nil;
        for (NSDictionary *dic in self.infoArray){
            if ([dic[@"head"] isEqualToString:@"Instructor"]){
                info = dic;
            }
        }
        webViewVC.instructorString = info[@"content"];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:webViewVC];
        nc.modalPresentationStyle = UIModalPresentationFullScreen;
        //[self activityIndicator:YES];
        [self presentViewController:nc animated:YES completion:nil];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}




@end
