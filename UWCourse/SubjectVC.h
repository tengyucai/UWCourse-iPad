//
//  SubjectVC.h
//  UWCourse
//
//  Created by Tengyu Cai on 2014-06-07.
//  Copyright (c) 2014 Tengyu Cai. All rights reserved.
//

#import "CommonVC.h"

@protocol SubjectDelegate;

@interface SubjectVC : CommonVC

@property (nonatomic,strong) NSArray *subjectArray;
@property (nonatomic,strong) NSMutableArray *resultArray;

@property (nonatomic,weak) id <SubjectDelegate> delegate;

@end

@protocol SubjectDelegate <NSObject>

-(void)SubjectVC:(SubjectVC*)subjectVC didSelectSubject:(NSString*)courseName;

@end
