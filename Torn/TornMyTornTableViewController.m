//
//  TornMyTornTableViewController.m
//  Torn
//
//  Created by Devon Ryan on 2/27/14.
//  Copyright (c) 2014 Devon Ryan. All rights reserved.
//

#import "TornMyTornTableViewController.h"
#import "TornMainTableViewController.h"
#import "TornConstants.h"
#import "TornAppDelegate.h"
#import "UITableViewCell+FlatUI.h"
#import "UIColor+FlatUI.h"
#import "MyTornCell.h"
#import "TornUtility.h"
#import "UINavigationBar+FlatUI.h"
#import "TornOneDetailViewController.h"

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
    
    NSLog(@"Date In:\n%@",date);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    formatter.timeZone = [NSTimeZone systemTimeZone];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    NSString *stringFromDate = [formatter stringFromDate:date];
    NSLog(@"Date Out:\n%@",stringFromDate);
    return stringFromDate;
}


@end
