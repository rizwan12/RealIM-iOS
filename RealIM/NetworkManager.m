//
//  NetworkManager.m
//  RealIM
//
//  Created by Rizwan Saleem on 03/10/2015.
//  Copyright © 2015 Rizwan Saleem. All rights reserved.
//

#import "NetworkManager.h"
#import "Constants.h"

@implementation NetworkManager

static NetworkManager* _sharedMySingleton = NULL;

#pragma mark Singleton Methods
+ (NetworkManager*)sharedManager {
    
    @synchronized([NetworkManager class])
    {
        if (_sharedMySingleton == nil) {
            _sharedMySingleton = [[self alloc] init];
        }
        
        return _sharedMySingleton;
    }
    
    return nil;
}

+(id)alloc
{
    @synchronized([NetworkManager class])
    {
        NSAssert(_sharedMySingleton == nil,
                 @"Attempted to allocate a second instance of a singleton.");
        _sharedMySingleton = [super alloc];
        return _sharedMySingleton;
    }
    
    return nil;
}

- (id)init {
    if (self = [super init]) {
        // Do initialization here.
    }
    return self;
}

- (void) saveChatObject:(ChatObject*) object {
    PFObject *chat = [PFObject objectWithClassName:@"ChatObject"];
    chat[@"chat_name"] = object.chatName;
    chat[@"chat_text"] = object.chatText;
    Boolean isImage = object.isImage;
    if(isImage) {
        chat[@"chat_is_image"] = @YES;
    } else {
        chat[@"chat_is_image"] = @NO;
    }
    chat[@"chat_URL"] = object.imageUrl;
    [chat saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            // Do nothing for now.
        } else {
            // TODO - Display Error Message
        }
    }];
}

- (void) saveChatObjectWithFile:(ChatObject*) object {
    PFObject *chat = [PFObject objectWithClassName:@"ChatObject"];
    chat[@"chat_name"] = object.chatName;
    chat[@"chat_text"] = object.chatText;
    Boolean isImage = object.isImage;
    if(isImage) {
        chat[@"chat_is_image"] = @YES;
        chat[@"chat_image"] = object.imageData;
    } else {
        chat[@"chat_is_image"] = @NO;
    }
    chat[@"chat_URL"] = object.imageUrl;
    [chat saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            // Do nothing for now.
        } else {
            // TODO - Display Error Message
        }
    }];
}


@end
