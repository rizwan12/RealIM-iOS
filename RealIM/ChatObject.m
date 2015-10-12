//
//  ChatObject.m
//  RealIM
//
//  Created by Rizwan Saleem on 03/10/2015.
//  Copyright © 2015 Rizwan Saleem. All rights reserved.
//

#import "ChatObject.h"

@implementation ChatObject

@synthesize chatName = _chatName;
@synthesize chatText = _chatText;
@synthesize imageUrl = _imageUrl;
@synthesize imageData = _imageData;
@synthesize isImage = _isImage;

/*
 * Constructor to initialize all properties with default values.
 */
- (id) init {
    self = [super init];
    if (self) {
        // Do all initialization here.
        _chatName = @"";
        _chatText = @"";
        _imageUrl = @"";
        _imageData = NULL;
        _isImage = NO;
    }
    return self;
}

/*
 * Overloaded Constructor to initialize all properties with given values.
 */

- (id) initWithName:(NSString*)chatName andText:(NSString*)chatText andImageData:(PFFile*)imageData andImageUrl:(NSString*)imageUrl andIsImage:(Boolean)isImage {
    self = [super init];
    if(self) {
        _chatName = chatName;
        _chatText = chatText;
        _imageUrl = imageUrl;
        _imageData = imageData;
        _isImage = isImage;
    }
    return self;
}


@end
