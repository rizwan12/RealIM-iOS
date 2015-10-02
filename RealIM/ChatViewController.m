//
//  ChatViewController.m
//  RealIM
//
//  Created by Rizwan Saleem on 03/10/2015.
//  Copyright © 2015 Rizwan Saleem. All rights reserved.
//

#import "ChatViewController.h"

#define CELL_HEIGHT 50;

@interface ChatViewController ()

@end

@implementation ChatViewController
@synthesize chatArray = _chatArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return CELL_HEIGHT;
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
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
