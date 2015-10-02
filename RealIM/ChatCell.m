//
//  ChatCell.m
//  RealIM
//
//  Created by Rizwan Saleem on 03/10/2015.
//  Copyright © 2015 Rizwan Saleem. All rights reserved.
//

#import "ChatCell.h"

@implementation ChatCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    
    if(self) {
        // Do additional settings in cell
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
