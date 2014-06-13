//
//  CourseDetailCell.m
//  UWCourse
//
//  Created by Tengyu Cai on 2014-06-08.
//  Copyright (c) 2014 Tengyu Cai. All rights reserved.
//

#import "CourseDetailCell.h"

@implementation CourseDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        float xMargin = 15;
        float y = 15;
        float lableWidth = self.frame.size.width-50;
        
        self.catagoryLabel = [UILabel new];
        self.catagoryLabel.frame = (CGRect){xMargin,y,lableWidth,15};
        self.catagoryLabel.font = [UIFont systemFontOfSize:18];
        [self.contentView addSubview:self.catagoryLabel];
        
        y = CGRectGetMaxY(self.catagoryLabel.frame);
        
        self.infoLabel = [UILabel new];
        self.infoLabel.frame = (CGRect){xMargin,y+8,lableWidth,15};
        self.infoLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.infoLabel];
        
        y = CGRectGetMaxY(self.infoLabel.frame);
        
        
    }
    return self;
}


@end
