//
//  ChatObject.h
//  RealIM
//
//  Created by Rizwan Saleem on 03/10/2015.
//  Copyright © 2015 Rizwan Saleem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/PFFile.h>

@interface ChatObject : NSObject

@property NSString* chatName;
@property NSString* chatText;
@property PFFile* imageData;
@property NSString* imageUrl;
@property Boolean isImage;


- (id) init;
- (id) initWithName:(NSString*)chatName andText:(NSString*)chatText andImageData:(PFFile*)imageData andImageUrl:(NSString*)imageUrl andIsImage:(Boolean)isImage;

@end
