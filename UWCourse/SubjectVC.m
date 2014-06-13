//
//  SubjectVC.m
//  UWCourse
//
//  Created by Tengyu Cai on 2014-06-07.
//  Copyright (c) 2014 Tengyu Cai. All rights reserved.
//

#import "SubjectVC.h"
#import "CourseFetcher.h"
#import "SubjectCell.h"

@interface SubjectVC () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (nonatomic,strong) NSMutableArray *indexSubject;
@property (nonatomic,strong) NSMutableArray *indices;
@property (nonatomic) BOOL isFiltered;

@end

@implementation SubjectVC {
    UITableView *subjectTableView;
    UISearchBar *searchBar;
}

- (void)loadView
{
    [super loadView];
    
    subjectTableView = [[UITableView alloc] initWithFrame:(CGRect){0,0,self.view.bounds.size.width, 690} style:UITableViewStylePlain];
    subjectTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//    UIView *view = [[UIView alloc] initWithFrame:self.view.frame];
//    view.backgroundColor = RGBA(100, 220, 250, 0.5);
//    subjectTableView.backgroundView = view;
    subjectTableView.backgroundColor = CCOLOR;
    subjectTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    subjectTableView.delegate = self;
    subjectTableView.dataSource = self;
    [subjectTableView registerClass:[SubjectCell class] forCellReuseIdentifier:@"xxx"];
    [self.view addSubview:subjectTableView];
    //subjectTableView.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchSubject];
    
    if ([subjectTableView respondsToSelector:@selector(setSectionIndexColor:)]) {
        subjectTableView.sectionIndexBackgroundColor = [UIColor clearColor];
        subjectTableView.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
        subjectTableView.sectionIndexColor = RGBA(84, 48, 13, 1);
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self fetchSubject];
}

//-(void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [subjectTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
//}


-(void) fetchSubject{

    dispatch_queue_t subQueue = dispatch_queue_create("subect", NULL);
    dispatch_async(subQueue, ^{
        NSURL *url = [CourseFetcher URLForSubject];
        NSData *json = [NSData dataWithContentsOfURL:url];
        NSDictionary *subDic = [NSJSONSerialization JSONObjectWithData:json options:0 error:NULL];
        NSArray *subArray = subDic[@"data"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self activityIndicator:NO];
            self.subjectArray = subArray;
        });});
    
}


-(void)setSubjectArray:(NSArray *)subjectArray{
    
    _subjectArray = subjectArray;
    self.indexSubject = [self transform:subjectArray];
    self.indices = [self.indexSubject valueForKey:@"headerTitle"];
    [subjectTableView reloadData];
    
}


-(NSMutableArray *)transform:(NSArray *) subArray{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    NSArray *alphabet = [[NSArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",
                         @"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"Z",nil];
    for (int i = 0; i < [alphabet count] ; i++){
        NSString *key = alphabet[i];
        NSMutableDictionary *row = [[NSMutableDictionary alloc] init];
        [row setValue:@[] forKey:@"rowValues"];
        [row setValue:key forKey:@"headerTitle"];
        [result addObject:row];
    }
    
    for (NSDictionary *subject in subArray){
        NSString *name = subject[@"subject"];
        NSString *firstChar = [name substringToIndex:1];
        
        for (NSDictionary *row in result){
            if ([firstChar isEqualToString:row[@"headerTitle"]]){
                NSArray *value = [row valueForKey:@"rowValues"];
                NSMutableArray *newValue = [[NSMutableArray alloc] initWithArray:value];
                [newValue addObject:subject];
                [row setValue:newValue forKey:@"rowValues"];
            }
        }
    }
    return result;
}


#pragma mark - Table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == subjectTableView){
        // Return the number of sections.
        return [self.indices count];
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == subjectTableView){
        // Return the number of rows in the section.
        return [[[self.indexSubject objectAtIndex:section] objectForKey:@"rowValues"] count];
    } else {
        return [self.resultArray count];
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"xxx";
    SubjectCell *cell = [subjectTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[SubjectCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (tableView == subjectTableView){
        // Configure the cell...
        NSDictionary *subject = [[[self.indexSubject objectAtIndex:indexPath.section] objectForKey:@"rowValues"] objectAtIndex: indexPath.row];
        NSDictionary *itemDic = @{@"subject": subject[@"subject"],
                                  @"description": subject[@"description"]};
        cell.itemDic = itemDic;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{

    UIImageView *av = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 20, 20)];
    av.backgroundColor = [UIColor clearColor];
    av.opaque = NO;
    av.image = nil;
    cell.backgroundView = av;
    
    if (cell.contentView.subviews) {
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
    }
    
    cell.contentView.backgroundColor = [UIColor clearColor];
    UIView *whiteRoundedCornerView = [[UIView alloc] initWithFrame:CGRectMake(5,10,210,50)];
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

//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    if (tableView == subjectTableView){
//        
//        NSString *headerTitle = [[self.indexSubject objectAtIndex:section] objectForKey:@"headerTitle"];
//        return headerTitle;
//    } else {
//        return nil;
//    }
//}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if (tableView == subjectTableView){
        return self.indices;
    } else {
        return nil;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_delegate) {
        NSDictionary *subject = [[[self.indexSubject objectAtIndex:indexPath.section] objectForKey:@"rowValues"] objectAtIndex: indexPath.row];
        NSString *courseName = subject[@"subject"];
        [_delegate SubjectVC:self didSelectSubject:courseName];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma mark - Search Bar

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length == 0){
        self.isFiltered = NO;
    } else {
        self.isFiltered = YES;
        self.resultArray = [[NSMutableArray alloc] init];
        
        for (NSDictionary *dic in self.subjectArray){
            NSString *name = dic[@"subject"];
            NSRange range =  [name rangeOfString:searchText options:NSCaseInsensitiveSearch];
            
            if (range.location != NSNotFound){
                [self.resultArray addObject:dic];
            }
        }
    }
}


@end
