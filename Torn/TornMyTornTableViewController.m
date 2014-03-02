//
//  TornMyTornTableViewController.m
//  Torn
//
//  Created by Devon Ryan on 2/27/14.
//  Copyright (c) 2014 Devon Ryan. All rights reserved.
//

#import "TornMyTornTableViewController.h"
#import "TornConstants.h"
#import "TornAppDelegate.h"
#import "UITableViewCell+FlatUI.h"
#import "UIColor+FlatUI.h"
#import "MyTornCell.h"
#import "TornUtility.h"
#import "UINavigationBar+FlatUI.h"
#import "TornOneDetailViewController.h"
#import "AMBlurView.h"
#import "FUIButton.h"
#import "UIFont+FlatUI.h"

@interface TornMyTornTableViewController ()

@end

@implementation TornMyTornTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.tableView.backgroundColor = [UIColor cloudsColor];
    
    [self.navigationController.navigationBar configureFlatNavigationBarWithColor:[UIColor pomegranateColor]];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Create" style:UIBarButtonItemStyleBordered target:self action:@selector(displayMenuAlert)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Log Out" style:UIBarButtonItemStyleBordered target:self action:@selector(logOutPressed)];
    
    
    for (NSString* family in [UIFont familyNames])
    {
        NSLog(@"%@", family);
        
        for (NSString* name in [UIFont fontNamesForFamilyName: family])
        {
            NSLog(@"  %@", name);
        }
    }
}

-(void)awakeFromNib
{
    
    self.parseClassName = TornClass;
    self.textKey = @"objectId";
    self.pullToRefreshEnabled = YES;
    self.paginationEnabled = NO;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(PFQuery *)queryForTable
{
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [query whereKey:TornUser equalTo:[PFUser currentUser]];
    
    return query;
    
}

- (MyTornCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    
    static NSString *TornCellIdentifier = @"MyTornCell";
    
    MyTornCell *cell = [tableView dequeueReusableCellWithIdentifier:TornCellIdentifier ];
    if (cell == nil) {
        cell = [[MyTornCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TornCellIdentifier];
    }
    
    // Configure the cell
    cell.nameLabel.text = [object objectForKey:TornName];
    cell.nameLabel.font = [UIFont fontWithName:@"Lato-Black" size:15];
    cell.timeStampLabel.font = [UIFont fontWithName:@"Lato-Bold" size:10];
    cell.votesLabel.font = [UIFont fontWithName:@"Lato-Regular" size:10];
    cell.timeStampLabel.text = [self changeDateToString:[object objectForKey:TornTimeStamp]];
    if ([object objectForKey:TornTotalVotes]) {
        cell.votesLabel.text = [NSString stringWithFormat:@"Votes: %@",[object objectForKey:TornTotalVotes]];
    }else{
        cell.votesLabel.text = @"No Votes";
    
    }
    

    
    return cell;


}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    PFObject *torn = [self objectAtIndexPath:indexPath];
    if ([[torn objectForKey:TornType] isEqualToString:TornTypeSingle]) {
        //Present Single
    
        TornOneDetailViewController *singleTornViewController = [mainStoryboard   instantiateViewControllerWithIdentifier:@"singleTornViewController"];
        singleTornViewController.torn = torn;
        
        [self.navigationController pushViewController:singleTornViewController animated:YES];
        
    }
}

#pragma mark { }

-(NSString *)changeDateToString:(NSDate *)date
{
    
    //NSLog(@"Date In:\n%@",date);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    formatter.timeZone = [NSTimeZone systemTimeZone];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    NSString *stringFromDate = [formatter stringFromDate:date];
   // NSLog(@"Date Out:\n%@",stringFromDate);
    return stringFromDate;
}


-(void)displayMenuAlert
{
    FUIAlertView *menu = [[FUIAlertView alloc]initWithTitle:@"Torn" message:@"How Many Ways Are You Torn?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"1",@"2",@"3",@"4", nil];
    
    menu.defaultButtonColor = [UIColor alizarinColor];
    menu.defaultButtonShadowColor = [UIColor pomegranateColor];
    menu.defaultButtonShadowHeight = 6.0f;
    menu.defaultButtonCornerRadius = 6.0f;
    menu.defaultButtonTitleColor = [UIColor cloudsColor];
    menu.alertContainer.backgroundColor = [UIColor clearColor];
    menu.backgroundOverlay.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    menu.defaultButtonFont = [UIFont fontWithName:@"Lato-Regular" size:20];
    menu.messageLabel.font = [UIFont fontWithName:@"Lato-Bold" size:15];
    menu.titleLabel.font = [UIFont fontWithName:@"Lato-Black" size:20];
    menu.messageLabel.textColor = [UIColor cloudsColor];
    menu.titleLabel.textColor = [UIColor cloudsColor];
    UIButton *cancelButton =  [menu.buttons objectAtIndex:[menu cancelButtonIndex]];
    cancelButton.titleLabel.font = [UIFont fontWithName:@"Lato-Black" size:20];
    
    
    [menu show];

}




@end
