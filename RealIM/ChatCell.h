//
//  ChatCell.h
//  RealIM
//
//  Created by Rizwan Saleem on 03/10/2015.
//  Copyright © 2015 Rizwan Saleem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatObject.h"

@interface ChatCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *chat;
@property (weak, nonatomic) IBOutlet UIImageView *image;

- (void) setChatObject:(ChatObject*)chatObject;
- (void) setChatObjectWithImage:(ChatObject*)chatObject;

@end
