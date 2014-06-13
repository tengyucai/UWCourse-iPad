//
//  SubjectCell.m
//  UWCourse
//
//  Created by Tengyu Cai on 2014-06-09.
//  Copyright (c) 2014 Tengyu Cai. All rights reserved.
//

#import "SubjectCell.h"

#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@implementation SubjectCell {
    UILabel *subjectLabel;
    UILabel *subjectDetailLabel;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [[self contentView] setBackgroundColor:[UIColor clearColor]];
        [[self backgroundView] setBackgroundColor:[UIColor clearColor]];
        [self setBackgroundColor:[UIColor clearColor]];
        
        
        
       // self.backgroundColor = [UIColor clearColor];  //RGBA(30, 130, 220, 0.8);
//        self.layer.cornerRadius = 4.0f;
//        [self clipsToBounds];
        float xMargin = 15;
        float yMargin = 15;
        
        subjectLabel = [[UILabel alloc] initWithFrame:(CGRect){xMargin,yMargin,200,20}];
        subjectLabel.backgroundColor = [UIColor clearColor];
        subjectLabel.textAlignment = NSTextAlignmentLeft;
        subjectLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:subjectLabel];
        
        float y = CGRectGetMaxY(subjectLabel.frame);
        
        subjectDetailLabel = [[UILabel alloc] initWithFrame:(CGRect){xMargin,y,200,20}];
        subjectDetailLabel.backgroundColor = [UIColor clearColor];
        subjectDetailLabel.textAlignment = NSTextAlignmentLeft;
        subjectDetailLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:subjectDetailLabel];
        
    }
    return self;
}

-(void)setItemDic:(NSDictionary *)itemDic
{
    subjectLabel.text = itemDic[@"subject"];
    subjectDetailLabel.text = itemDic[@"description"];
}

@end
