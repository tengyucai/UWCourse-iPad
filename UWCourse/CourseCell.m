//
//  CourseCell.m
//  UWCourse
//
//  Created by Tengyu Cai on 2014-06-10.
//  Copyright (c) 2014 Tengyu Cai. All rights reserved.
//

#import "CourseCell.h"

#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@implementation CourseCell 

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [[self contentView] setBackgroundColor:[UIColor clearColor]];
        [[self backgroundView] setBackgroundColor:[UIColor clearColor]];
        [self setBackgroundColor:[UIColor clearColor]];
        
        float xMargin = 15;
        float yMargin = 15;
        
        _courseLabel = [[UILabel alloc] initWithFrame:(CGRect){xMargin,yMargin,200,20}];
        _courseLabel.backgroundColor = [UIColor clearColor];
        _courseLabel.textAlignment = NSTextAlignmentLeft;
        _courseLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:_courseLabel];
        
        float y = CGRectGetMaxY(_courseLabel.frame);
        
        _courseDetailLabel = [[UILabel alloc] initWithFrame:(CGRect){xMargin,y,200,20}];
        _courseDetailLabel.backgroundColor = [UIColor clearColor];
        _courseDetailLabel.textAlignment = NSTextAlignmentLeft;
        _courseDetailLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_courseDetailLabel];
        
    }
    return self;
}



@end
