//
//  CustomCell.m
//  UWCourse
//
//  Created by Tengyu Cai on 2014-06-08.
//  Copyright (c) 2014 Tengyu Cai. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor grayColor];
        
        float xMargin = 15;
        float y = 15;
        float lableWidth = self.frame.size.width-50;
        
        self.label1 = [UILabel new];
        self.label1.frame = (CGRect){xMargin,y,lableWidth,15};
        self.label1.font = [UIFont systemFontOfSize:18];
        [self.contentView addSubview:self.label1];
        
        y = CGRectGetMaxY(self.label1.frame);
        
        self.timeLabel = [UILabel new];
        self.timeLabel.frame = (CGRect){xMargin,y+8,lableWidth,15};
        self.timeLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.timeLabel];
        
        y = CGRectGetMaxY(self.timeLabel.frame);
        
        self.placeLabel = [UILabel new];
        self.placeLabel.frame = (CGRect){xMargin,y+5,lableWidth,15};
        self.placeLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.placeLabel];
        
        y = CGRectGetMaxY(self.placeLabel.frame);
        
        self.instructorLabel = [UILabel new];
        self.instructorLabel.frame = (CGRect){xMargin,y+5,lableWidth,15};
        self.instructorLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.instructorLabel];
        
    }
    return self;
}



@end
