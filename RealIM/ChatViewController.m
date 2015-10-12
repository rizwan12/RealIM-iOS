//
//  ChatViewController.m
//  RealIM
//
//  Created by Rizwan Saleem on 03/10/2015.
//  Copyright © 2015 Rizwan Saleem. All rights reserved.
//

#import "ChatViewController.h"
#import "Constants.h"

#define CELL_HEIGHT 35;
#define kOFFSET_FOR_KEYBOARD -216
#define IMAGEVIEW_HEIGHT 195

@interface ChatViewController ()

@end

@implementation ChatViewController
@synthesize chatArray = _chatArray;
@synthesize chatField = _chatField;
@synthesize name = _name;
@synthesize objectId = _objectId;
@synthesize activityIndicator = _activityIndicator;

/*
 * using this delegate function to register a notification.
 */
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(chatReceived:) name:PUSH_NOTIFICATION
                                               object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _chatArray = [[NSMutableArray alloc] init];
    _chatField.autocorrectionType = UITextAutocorrectionTypeNo;
    [_chatField setDelegate:self];
    
    UIBarButtonItem *openCameraButton = [[UIBarButtonItem alloc]
                                    initWithTitle:@"Attach"
                                    style:UIBarButtonItemStylePlain
                                    target:self action:@selector(openCamera:)];
    
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc]
                                         initWithTitle:@"Refresh"
                                         style:UIBarButtonItemStylePlain
                                         target:self action:@selector(getChat:)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:openCameraButton, refreshButton, nil];
    [_activityIndicator setHidden:YES];
    // For emulator check only
    [self checkForCamera];
    /*
     * Get Chat from server
     */
    [self getChatFromServer];
}

#pragma mark - TextField Delegates
/*
 * Animate text Field so that it become visible
 */
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField:textField up:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:textField up:NO];
}

// It is important for you to hide the keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)animateTextField:(UITextField*)textField up:(BOOL)up
{
    const int movementDistance = kOFFSET_FOR_KEYBOARD; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? movementDistance : -movementDistance);
    
    [UIView beginAnimations: @"animateTextField" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ChatObject* object = [_chatArray objectAtIndex:indexPath.row];
    if(object.isImage) {
        return IMAGEVIEW_HEIGHT;
    }
    int height = [self findHeightForText:object.chatText havingWidth:320 andFont:[UIFont systemFontOfSize:15.0f]];
    return height + CELL_HEIGHT;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_chatArray count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"ChatCell";
    ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell) {
        NSArray *topLevelObjects = [[NSBundle mainBundle]
                                    loadNibNamed:CellIdentifier owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
        
        [cell setUserInteractionEnabled:YES];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    ChatObject* object = [_chatArray objectAtIndex:indexPath.row];
    if(object.isImage) {
        [cell setChatObjectWithImage:object];

    } else {
        [cell setChatObject:object];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

/*
 * Move table to the bottom of Table View for Chat View
 */
- (void) moveTableViewToBottom {
    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:([_chatArray count] - 1) inSection:0];
    [_chatTableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

/*
 *  Open camera to take image.
 */
- (IBAction)openCamera:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

#pragma mark - Camera Cllback
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    NSData *imageData = UIImagePNGRepresentation(chosenImage);
    PFFile *imageFile = [PFFile fileWithName:@"image.png" data:imageData];
    [_activityIndicator setHidden:NO];
    [_activityIndicator startAnimating];
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded) {
            ChatObject* object = [[ChatObject alloc] initWithName:_name andText:@"" andImageData:imageFile andImageUrl:imageFile.url andIsImage:YES];
            [[NetworkManager sharedManager] saveChatObjectWithFile:object];
            [_activityIndicator stopAnimating];
            [_activityIndicator setHidden:YES];
            [_chatArray addObject:object];
            [self sendPushMessageForObject:object];
            [_chatTableView reloadData];
            [self moveTableViewToBottom];
        }
    }];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

/*
 * IBAction when send button is pressed
 * It will add the chat object to array and send push notifiaction to all other devices
 */
- (IBAction)sendTextPressed:(id)sender {
    [self.view endEditing:YES];
    NSString* text = [_chatField text];
    [_chatField setText:@""];
    if([text length] > 0) {
        ChatObject* object = [[ChatObject alloc] initWithName:_name andText:text andImageData:nil andImageUrl:@"" andIsImage:NO];
        [[NetworkManager sharedManager] saveChatObject:object];
        [self sendPushMessageForObject:object];
        [_chatArray addObject:object];
        
        NSInteger lastSectionIndex = MAX(0, [_chatTableView numberOfSections] - 1);
        NSInteger lastRowIndex = [_chatTableView numberOfRowsInSection:lastSectionIndex];
        NSIndexPath *pathToLastRow = [NSIndexPath indexPathForRow:lastRowIndex inSection:lastSectionIndex];
        
        [_chatTableView beginUpdates];
        [_chatTableView insertRowsAtIndexPaths:@[pathToLastRow] withRowAnimation:UITableViewRowAnimationBottom];
        [_chatTableView reloadData];
        [_chatTableView endUpdates];

        [self moveTableViewToBottom];
    }
    
}

/*
 * Callback for Refresh Button
 */
- (IBAction)getChat:(id)sender {
    [self getChatFromServer];
}

/*
 * Get Chat from Parse function
 */
- (void) getChatFromServer {
    PFQuery *query = [PFQuery queryWithClassName:@"ChatObject"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            for (PFObject *object in objects) {
                NSString* name = [object objectForKey:@"chat_name"];
                if(name == nil || [name length] <= 0 || [name isEqualToString:@"\n"]) {
                    name = @"[No Name]";
                }
                NSString* text = [object objectForKey:@"chat_text"];
                Boolean isImage = [[object objectForKey:@"chat_is_image"] boolValue];
                NSString* url = @"";
                PFFile* imageFile = nil;
                if(isImage) {
                    url = [object objectForKey:@"chat_URL"];
                    imageFile = [object objectForKey:@"chat_image"];
                }
                ChatObject* object = [[ChatObject alloc] initWithName:name andText:text andImageData:imageFile andImageUrl:url andIsImage:isImage];
                [_chatArray addObject:object];
            }
            [_chatTableView reloadData];
            [self moveTableViewToBottom];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

/*
 *  Send Push Message to all devices except itself
 */
- (void) sendPushMessageForObject:(ChatObject*) object {
    // Create Push Dictionary
    NSDictionary* pushDictionary = nil;
    if(object.isImage) {
        pushDictionary = [[NSDictionary alloc ] initWithObjectsAndKeys:
                                    object.chatName, @"name",
                                    object.imageUrl, @"imageUrl",
                                    object.chatText, @"message",
                                    [NSNumber numberWithBool:YES], @"isImage",
                                    nil];
    } else {
        pushDictionary = [[NSDictionary alloc ] initWithObjectsAndKeys:
                                        object.chatName, @"name",
                                        object.chatText, @"message",
                                        [NSNumber numberWithBool:NO], @"isImage",
                                        nil];
    }
    NSDictionary* data = [NSDictionary dictionaryWithObjectsAndKeys:pushDictionary, @"message", nil];
    // Send a notification to all devices subscribed to the "Message" channel.
    NSLog(@"ID: %@", [[PFInstallation currentInstallation] installationId]);
    PFQuery *query = [PFQuery queryWithClassName:@"Installation"];
    [query whereKey:@"installationId" notEqualTo:[[PFInstallation currentInstallation] installationId]];
    PFPush *push = [[PFPush alloc] init];
    [push setQuery:query];
    [push setData:data];
    [push sendPushInBackground];
}

/*
 * Chat received from App Delegate Method via Notifiactions
 */
- (void)chatReceived:(NSNotification *)notification
{
    NSLog(@"Notification: %@", notification.userInfo);
    NSDictionary* messageDictionary = [notification.userInfo objectForKey:@"message"];
    NSString* name = [messageDictionary objectForKey:@"name"];
    NSString* message = [messageDictionary objectForKey:@"message"];
    Boolean isImage = [[messageDictionary objectForKey:@"isImage"] boolValue];
    NSString* imageUrl = @"";
    PFFile* imageData = nil;
    if(isImage) {
        imageUrl = [messageDictionary objectForKey:@"imageUrl"];
        [self getImageData:imageUrl andName:name andText:message];
        return;
    }
    ChatObject* object = [[ChatObject alloc] initWithName:name andText:message andImageData:imageData andImageUrl:imageUrl andIsImage:isImage];
    [_chatArray addObject:object];
    
    NSInteger lastSectionIndex = MAX(0, [_chatTableView numberOfSections] - 1);
    NSInteger lastRowIndex = [_chatTableView numberOfRowsInSection:lastSectionIndex];
    NSIndexPath *pathToLastRow = [NSIndexPath indexPathForRow:lastRowIndex inSection:lastSectionIndex];
    
    
    [_chatTableView beginUpdates];
    [_chatTableView insertRowsAtIndexPaths:@[pathToLastRow] withRowAnimation:UITableViewRowAnimationBottom];
    [_chatTableView reloadData];
    [_chatTableView endUpdates];
    [self moveTableViewToBottom];
}

/*
 *  Get Image Data of the chat received form Push Message
 */
- (void) getImageData:(NSString*) imageUrl andName:(NSString*)name andText:(NSString*) text {
    PFQuery *query = [PFQuery queryWithClassName:@"ChatObject"];
    [query whereKey:@"chat_URL" equalTo:imageUrl];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // Do something with the found objects
            for (PFObject *object in objects) {
                PFFile* file = [object objectForKey:@"chat_image"];
                ChatObject* object = [[ChatObject alloc] initWithName:name andText:text andImageData:file andImageUrl:imageUrl andIsImage:YES];
                [_chatArray addObject:object];
                
                NSInteger lastSectionIndex = MAX(0, [_chatTableView numberOfSections] - 1);
                NSInteger lastRowIndex = [_chatTableView numberOfRowsInSection:lastSectionIndex];
                NSIndexPath *pathToLastRow = [NSIndexPath indexPathForRow:lastRowIndex inSection:lastSectionIndex];
                
                
                [_chatTableView beginUpdates];
                [_chatTableView insertRowsAtIndexPaths:@[pathToLastRow] withRowAnimation:UITableViewRowAnimationBottom];
                [_chatTableView reloadData];
                [_chatTableView endUpdates];
                [self moveTableViewToBottom];
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

#pragma mark - Utility Methods

/*
 * Check if camera is available on the device
 */
- (void) checkForCamera {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertController *alert = [UIAlertController
                                    alertControllerWithTitle:@"Alert" message:@"No camera found."
                                    preferredStyle:UIAlertControllerStyleAlert];
        
        /*
         * Creating actions to cater Alert Controller Actions
         */
        UIAlertAction* cancelAction = [UIAlertAction
                                       actionWithTitle:NSLocalizedString(@"Dismiss", @"Cancel action")
                                       style:UIAlertActionStyleCancel
                                       handler:^(UIAlertAction *action)
                                       {
                                           NSLog(@"Cancel action");
                                       }];
        [alert addAction:cancelAction];
        
        /*
         * Display Alert View Controller
         */
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
}

/*
 * Height of Table View - Used to find height of Table View Cell
 */
- (CGFloat)findHeightForText:(NSString *)text havingWidth:(CGFloat)widthValue andFont:(UIFont *)font
{
    CGFloat result = font.pointSize+4;
    if (text) {
        CGSize size;
        //iOS 7
        CGRect frame = [text boundingRectWithSize:CGSizeMake(widthValue, CGFLOAT_MAX)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:@{NSFontAttributeName:font}
                                          context:nil];
        size = CGSizeMake(frame.size.width, frame.size.height+1);
        
        result = MAX(size.height, result); //At least one row
    }
    return result;
}


@end
