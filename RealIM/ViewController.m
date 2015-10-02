//
//  ViewController.m
//  RealIM
//
//  Created by Rizwan Saleem on 02/10/2015.
//  Copyright © 2015 Rizwan Saleem. All rights reserved.
//

#import "ViewController.h"
#import "ChatViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 * Join Button callback
 */
- (IBAction)joinButtonPressed:(id)sender {
    /*
     * Creating AlertView Controller to get user display name
     * Alert Viewcontroller is present in iOS 8 only.
     */
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"Alert" message:@"Please Enter Nick"
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
    
    UIAlertAction* okayAction = [UIAlertAction
                                 actionWithTitle:NSLocalizedString(@"Confirm", @"OK action")
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction *action)
                                 {
                                     NSLog(@"OK action");
                                     UITextField* nameField = alert.textFields.firstObject;
                                     NSLog(@"Name is: %@", nameField.text);
                                     NSString * storyboardName = @"Main";
                                     UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
                                     UIViewController * viewController = [storyboard instantiateViewControllerWithIdentifier:@"ChatViewController"];
                                     [self.navigationController pushViewController:viewController animated:YES];
                                     
                                 }];
    
    /*
     *Adding actions to the alertController
     */
    [alert addAction:cancelAction];
    [alert addAction:okayAction];
    
    /*
     * Adding textfield to get User name
     */
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Enter name:";
    }];
    /*
     * Display Alert View Controller
     */
    [self presentViewController:alert animated:YES completion:nil];
}


@end
