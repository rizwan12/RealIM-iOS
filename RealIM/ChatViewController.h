//
//  ChatViewController.h
//  RealIM
//
//  Created by Rizwan Saleem on 03/10/2015.
//  Copyright © 2015 Rizwan Saleem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <Parse/PFQuery.h>
#import "ChatCell.h"
#import "ChatObject.h"
#import "NetworkManager.h"

@interface ChatViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray* chatArray;
@property (weak, nonatomic) IBOutlet UITableView *chatTableView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UITextField *chatField;
@property (weak, nonatomic) IBOutlet UIButton *chatSend;
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* objectId;
@property (strong, nonatomic) NSTimer* timer;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
- (IBAction)sendTextPressed:(id)sender;

- (void) getChatFromServer;

@end
