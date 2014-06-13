//
//  CustomVC.m
//  UWCourse
//
//  Created by Tengyu Cai on 2014-06-07.
//  Copyright (c) 2014 Tengyu Cai. All rights reserved.
//

#import "CustomVC.h"
#import "CWStatusBarNotification.h"
#import "CustomCell.h"
#import "CourseDetailVC.h"
#import "MiniCourseTableVC.h"

@interface CustomVC () <UIPickerViewDataSource,UIPickerViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic) BOOL isLEC;
@property (nonatomic) BOOL isTUT;
@property (nonatomic) BOOL isTST;
@property (nonatomic,strong) CWStatusBarNotification *notification;
@end


@implementation CustomVC {
    UISegmentedControl *segControl;
    UIButton *addButton;
    
    MiniCourseTableVC *courseTableVC;
}

- (void)loadView
{
    [super loadView];
    
    float xMargin = 5;
    float y;
    float x;
    float leftWidth = 230;
    float rightWidth = 250;
    
    tableView = [[UITableView alloc] initWithFrame:(CGRect){xMargin, 10, leftWidth, 300} style:UITableViewStyleGrouped];
//    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[CustomCell class] forCellReuseIdentifier:@"Custom"];
    tableView.backgroundColor = RGBA(200, 200, 200, 0.5);
    [self.view addSubview:tableView];
    
    x = CGRectGetMaxX(tableView.frame);
    
    segControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"LEC", @"TUT", @"TST", nil]];
    segControl.frame = (CGRect){x+xMargin,20,rightWidth,30};
    //    segControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    segControl.selectedSegmentIndex = 0;
    [segControl addTarget:self action:@selector(changeTable:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segControl];
    
    y = CGRectGetMaxY(segControl.frame);
    
    self.picker = [[UIPickerView alloc] initWithFrame:(CGRect){x+xMargin, y+20, rightWidth, 150}];
//    self.picker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.picker.dataSource = self;
    self.picker.delegate = self;
    [self.view addSubview:self.picker];
    
    y = CGRectGetMaxY(self.picker.frame);
    
    addButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    NSString *buttonTitle = @"Add course";
    [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addButton setTitle:buttonTitle forState:UIControlStateNormal];
    addButton.frame = (CGRect){x+xMargin, y+20, rightWidth, 40};
    addButton.backgroundColor = self.view.tintColor;
    [addButton addTarget:self action:@selector(addCourse) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addButton];
    
    y = CGRectGetMaxY(tableView.frame);
    
    courseTableVC = [[MiniCourseTableVC alloc] init];
    courseTableVC.view.frame = (CGRect){xMargin,y+5,560,330};
    courseTableVC.view.layer.cornerRadius = 8.0f;
    courseTableVC.view.backgroundColor = CCOLOR;
    [self addChildViewController:courseTableVC];
    [self.view addSubview:courseTableVC.view];
    [courseTableVC didMoveToParentViewController:self];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    lecArray = [[NSMutableArray alloc]initWithArray:self.lectureArray];
    NSMutableArray *fakeLecArray = [lecArray mutableCopy];
    for (NSDictionary *dic in fakeLecArray){
        NSMutableString *string = [[NSMutableString alloc]init];
        NSDictionary *date = dic[@"classes"][0][@"date"];
        if (![date[@"start_time"] isKindOfClass:[NSString class]] ){
            [lecArray removeObject:dic];
            continue;
        }
        NSMutableArray *classArray = [[NSMutableArray alloc]initWithArray:dic[@"classes"]];
        NSMutableArray *array = [[NSMutableArray alloc]init];
        for (NSDictionary *class in classArray){
            NSMutableString *timestring = [[NSMutableString alloc]init];
            NSDictionary *time = class[@"date"];
            if (time[@"start_time"] && time[@"end_time"] && time[@"weekdays"]){
                [timestring appendString:[NSString stringWithFormat:@"%@ %@-%@ ",time[@"weekdays"],time[@"start_time"],time[@"end_time"]]];
            }
            if ([string rangeOfString:timestring].location == NSNotFound){
                [string appendString:timestring];
                [array addObject:class];
            }
        }
        NSMutableDictionary *newdic = [[NSMutableDictionary alloc]initWithDictionary:dic];
        [newdic setObject:string forKey:@"timeLabel"];
        [newdic setObject:array forKey:@"classes"];
        [lecArray replaceObjectAtIndex:[fakeLecArray indexOfObject:dic] withObject:newdic];
    }
    tstArray = [[NSMutableArray alloc]initWithArray:self.testArray];
    tutArray = [[NSMutableArray alloc] initWithArray:self.tutorialArray];
    self.title = [NSString stringWithFormat:@"%@ %@",self.courseName,self.courseNum];
    self.isLEC = YES;
    self.isTST = NO;
    self.isTUT = NO;
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addStuff)];
    self.navigationItem.rightBarButtonItem = button;
}


-(NSInteger) getMinute:(NSString *)time{
    NSInteger result = 0;
    NSInteger breakpoint = 0;
    for (NSInteger i = 0; i<[time length]; i++){
        char c = [time characterAtIndex:i];
        if (c == ':'){
            breakpoint = i;
        }
    }
    NSString *hour = [time substringToIndex:breakpoint];
    NSString *minute = [time substringFromIndex:breakpoint+1];
    result = [hour intValue] * 60 + [minute intValue];
    return result;
}


- (void)addCourse
{
    int lecIndex = [self.picker selectedRowInComponent:0];
    int tutIndex = [self.picker selectedRowInComponent:1];
    int tstIndex = [self.picker selectedRowInComponent:2];
    
    NSDictionary *lecture;
    NSDictionary *tutorial;
    NSDictionary *test;
    
    if (lecArray.count > 0) {
        lecture = lecArray[lecIndex];
    } else {
        return;  // Potential bug: assume must have at least one lecture
    }
    if (tutArray.count > 0) {
        tutorial = tutArray[tutIndex];
    }
    if (tstArray.count > 0) {
        test = tstArray[tstIndex];
    }
    
    // a newCourse to be added to database
    NSMutableDictionary *newCourseDic = [[NSMutableDictionary alloc] init];
    
    // *** LEC ***
    NSMutableArray *lecArray = [[NSMutableArray alloc] init];
    NSArray *classArray = lecture[@"classes"];
    for (int i = 0; i < classArray.count; ++i) {
        NSMutableDictionary *lecDic = [[NSMutableDictionary alloc] init];
        
        // section, course name & location
        [lecDic setValue:lecture[@"section"] forKey:@"section"];
        [lecDic setValue:self.courseName forKey:@"coursename"];
        [lecDic setValue:self.courseNum forKey:@"coursenum"];
        NSDictionary *locationDic = lecture[@"classes"][i][@"location"];
        NSString *location = [NSString stringWithFormat:@"%@ %@", locationDic[@"building"], locationDic[@"room"]];
        [lecDic setValue:location forKey:@"location"];
        
        // instructor
        NSArray *instructorArray = lecture[@"classes"][0][@"instructors"];
        if ([instructorArray isEqualToArray:@[]]){
            [lecDic setValue:@"No Instructors Found" forKey:@"instructor"];
        } else {
            [lecDic setValue:instructorArray[0] forKey:@"instructor"];
        }
        
        // date & time
        NSDictionary *date = lecture[@"classes"][i][@"date"];
        [lecDic setValue:date[@"weekdays"] forKey:@"weekdays"];
        [lecDic setValue:date[@"start_time"] forKey:@"start_time"];
        [lecDic setValue:date[@"end_time"] forKey:@"end_time"];
        
        [lecArray addObject:lecDic];
    }
    [newCourseDic setValue:lecArray forKey:@"lecture"];
    
    // *** TUT ***
    if (tutorial) {
        NSMutableDictionary *tutDic = [[NSMutableDictionary alloc] init];
        NSDictionary *date = tutorial[@"classes"][0][@"date"];
        [tutDic setValue:date[@"weekdays"] forKey:@"weekdays"];
        [tutDic setValue:date[@"start_time"] forKey:@"start_time"];
        [tutDic setValue:date[@"end_time"] forKey:@"end_time"];
        [tutDic setValue:tutorial[@"section"] forKey:@"section"];
        NSDictionary *locationDic = tutorial[@"classes"][0][@"location"];
        NSString *location = [NSString stringWithFormat:@"%@ %@", locationDic[@"building"], locationDic[@"room"]];
        [tutDic setValue:location forKey:@"location"];
        [newCourseDic setValue:tutDic forKey:@"tutorial"];
    }
    
    // *** TST ***
    if (test) {
        NSMutableDictionary *tstDic = [[NSMutableDictionary alloc] init];
        NSDictionary *date = test[@"classes"][0][@"date"];
        [tstDic setValue:date[@"weekdays"] forKey:@"weekdays"];
        [tstDic setValue:date[@"start_time"] forKey:@"start_time"];
        [tstDic setValue:date[@"end_time"] forKey:@"end_time"];
        [newCourseDic setValue:tstDic forKey:@"test"];
    }
    
    // add newCourse to bookmark(database)
    NSUserDefaults *bookmark = [NSUserDefaults standardUserDefaults];
    if (![bookmark objectForKey:@"Event List"]){
        NSMutableArray *markArray = [[NSMutableArray alloc] initWithObjects:newCourseDic, nil];
        [bookmark setObject:markArray forKey:@"Event List"];
        [bookmark synchronize];
    } else {
        NSMutableArray *markArray = [[NSMutableArray alloc] initWithArray:[bookmark objectForKey:@"Event List"]];
        [markArray addObject:newCourseDic];
        [bookmark setObject:markArray forKey:@"Event List"];
        [bookmark synchronize];
    }
    
    // status bar notification
    self.notification = [CWStatusBarNotification new];
    self.notification.notificationLabelBackgroundColor  = self.view.tintColor;
    self.notification.notificationLabelTextColor = [UIColor whiteColor];
    [self.notification displayNotificationWithMessage:[NSString stringWithFormat:@"%@%@ has been added",self.courseName,self.courseNum] forDuration:1.0];
    
    [courseTableVC update];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (buttonIndex == 1)
    {
        self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:1];
        
    }
}


- (void)refresh
{
    lecArray = _lectureArray;
    tutArray = _tutorialArray;
    tstArray = _testArray;
    [tableView reloadData];
    [self.picker reloadAllComponents];
}

#pragma mark - Segmented Control


- (IBAction)hitLEC:(id)sender {
    self.isLEC = YES;
    self.isTUT = NO;
    self.isTST = NO;
    [tableView reloadData];
}

- (IBAction)hitTUT:(id)sender {
    self.isLEC = NO;
    self.isTUT = YES;
    self.isTST = NO;
    [tableView reloadData];
}


- (IBAction)hitTST:(id)sender {
    self.isLEC = NO;
    self.isTUT = NO;
    self.isTST = YES;
    [tableView reloadData];
}

- (void)changeTable:(id)sender
{
    if (segControl.selectedSegmentIndex == 0) {
        [self hitLEC:sender];
    } else if (segControl.selectedSegmentIndex == 1) {
        [self hitTUT:sender];
    } else if (segControl.selectedSegmentIndex == 2) {
        [self hitTST:sender];
    }
    
}



#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (self.isLEC){
        return [lecArray count];
    } else if (self.isTUT){
        return [tutArray count];
    } else {
        return [tstArray count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CourseDetailVC *courseDetailVC = [CourseDetailVC new];

    if (self.isLEC){
        courseDetailVC.section = lecArray[indexPath.row];
    } else if (self.isTUT){
        courseDetailVC.section = tutArray[indexPath.row];
    } else{
        courseDetailVC.section = tstArray[indexPath.row];
    }
    courseDetailVC.courseName = [NSString stringWithFormat:@"%@ - %@", self.courseName, courseDetailVC.section[@"section"]];
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:courseDetailVC];
    nc.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:nc animated:YES completion:nil];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Custom";
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (self.isTUT){
        cell.instructorLabel.text = @"";
    }
    
    if (self.isTST){
        cell.instructorLabel.text = @"";
        cell.placeLabel.text = @"";
    }
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    if (self.isLEC){
        
        NSDictionary *lecture = lecArray[indexPath.row];
        
        cell.label1.text = lecture[@"section"];
        NSArray *instructorArray = lecture[@"classes"][0][@"instructors"];
        if ([instructorArray isEqualToArray:@[]]){
            cell.instructorLabel.text = @"No Instructors Found";
        } else {
            cell.instructorLabel.text = instructorArray[0];
        }
        
        NSDictionary *location = lecture[@"classes"][0][@"location"];
        if (!location[@"building"] || !location[@"room"]){
            cell.placeLabel.text = @"No Place Found";
        } else {
            cell.placeLabel.text = [NSString stringWithFormat:@"%@ %@",location[@"building"],location[@"room"]];
        }
        
        NSDictionary *date = lecture[@"classes"][0][@"date"];
        cell.timeLabel.text = [NSString stringWithFormat:@"%@ - %@", date[@"start_time"], date[@"end_time"]];  //lecture[@"timeLabel"];
    } else if (self.isTUT){
        if ([tutArray count] > 0){
            
            NSDictionary *tutorial = tutArray[indexPath.row];
            cell.label1.text = tutorial[@"section"];
            
            NSDictionary *date = tutorial[@"classes"][0][@"date"];
            cell.timeLabel.text = [NSString stringWithFormat:@"%@ %@-%@",
                                   date[@"weekdays"],date[@"start_time"],
                                   date[@"end_time"]];
            
            NSDictionary *location = tutorial[@"classes"][0][@"location"];
            if (!location[@"building"] || !location[@"room"]){
                cell.placeLabel.text = @"No Place Found";
            } else {
                cell.placeLabel.text = [NSString stringWithFormat:@"%@ %@",location[@"building"],location[@"room"]];
            }
            
        }
        
    } else {
        if ([tstArray count] > 0){
            NSDictionary *test = tstArray[indexPath.row];
            cell.label1.text = test[@"section"];
            
            NSDictionary *date = test[@"classes"][0][@"date"];
            cell.timeLabel.text = [NSString stringWithFormat:@"%@ %@-%@",
                                   date[@"weekdays"],date[@"start_time"],
                                   date[@"end_time"]];
            
        }
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

#pragma mark - Picker View

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    return 3;
}


- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0)
        return [lecArray count];
    if (component == 1)
        return  [tutArray count];
    if (component == 2)
        return [tstArray count];
    
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0){
        NSString *section = [lecArray objectAtIndex:row][@"section"];
        return section;
    }
    if (component == 1){
        NSString *tutorial = [tutArray objectAtIndex: row][@"section"];
        return tutorial;
    }
    if (component == 2){
        NSString *test = [tstArray objectAtIndex:row][@"section"];
        return test;
    }
    return 0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* tView = (UILabel*)view;
    if (!tView){
        tView = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        tView.font = [UIFont systemFontOfSize:19];
        if (component == 0) {
            tView.text = [lecArray objectAtIndex:row][@"section"];
        } else if (component == 1) {
            tView.text = [tutArray objectAtIndex: row][@"section"];
        } else if (component == 2) {
            tView.text = [tstArray objectAtIndex:row][@"section"];
        }
    }
    
    return tView;
}

@end
