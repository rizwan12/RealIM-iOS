//
//  NetworkManager.h
//  RealIM
//
//  Created by Rizwan Saleem on 03/10/2015.
//  Copyright © 2015 Rizwan Saleem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/PFQuery.h>
#import "ChatObject.h"

@interface NetworkManager : NSObject

// Singleton manager
+ (id) sharedManager;

/*
 * Save chat Object to server
 */
- (void) saveChatObject:(ChatObject*) object;
- (void) saveChatObjectWithFile:(ChatObject*) object;

@end
