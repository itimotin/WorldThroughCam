//
//  CameraCell.m
//  ThroughtCam
//
//  Created by iVanea! on 5/16/13.
//  Copyright (c) 2013 iVanea!. All rights reserved.
//

#import "CameraCell.h"

@implementation CameraCell
@synthesize labelName;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
