//
//  ChatCell.m
//  RealIM
//
//  Created by Rizwan Saleem on 03/10/2015.
//  Copyright © 2015 Rizwan Saleem. All rights reserved.
//

#import "ChatCell.h"

@implementation ChatCell
@synthesize name = _name;
@synthesize chat = _chat;
@synthesize image = _image;

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

- (void) setChatObject:(ChatObject*)chatObject {
//    [_image removeFromSuperview];
    [_name setText:chatObject.chatName];
    [_chat setText:chatObject.chatText];
    [_image setHidden:YES];
}

- (void) setChatObjectWithImage:(ChatObject*)chatObject {
    [_name setText:chatObject.chatName];
    [_chat setText:chatObject.chatText];
    [_image setHidden:NO];
    [_image setImage:nil];
    [chatObject.imageData getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if(!error) {
            UIImage* image = [UIImage imageWithData:data];
            [_image setImage:image];
        }
    }];
}

@end
