//
//  TornOneDetailViewController.m
//  Torn
//
//  Created by Devon Ryan on 2/27/14.
//  Copyright (c) 2014 Devon Ryan. All rights reserved.
//

#import <Parse/Parse.h>
#import "TornConstants.h"
#import "TornOneDetailViewController.h"
#import "TornLoginViewController.h"
#import "TornAppDelegate.h"

@interface TornOneDetailViewController ()

@property (weak, nonatomic) IBOutlet PFImageView *tornImageView;
@property (strong, nonatomic) PFQuery *query;
@property (strong, nonatomic) PFFile *imageFile;
@property (weak, nonatomic) IBOutlet UILabel *yesLabel;
@property (weak, nonatomic) IBOutlet UILabel *noLabel;
@end

@implementation TornOneDetailViewController

#define APPLICATION_DELEGATE (TornAppDelegate *)[[UIApplication sharedApplication] delegate]


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
    if ([PFUser currentUser]) {
 
        self.nameLabel.text = [self.torn objectForKey:TornName];
        self.imageFile = [self.torn objectForKey:TornPhotoOne];
        self.query = [PFQuery queryWithClassName:TornOneClass];
        self.query.cachePolicy = kPFCachePolicyCacheThenNetwork;
        [self.query  whereKey:TornOneTorn equalTo:self.torn];
        [self runQuery];
        
    }else{

        [self performSelector:@selector(showLogin) withObject:nil afterDelay:.5];
    }
    
 
    [self.tornImageView setFile:self.imageFile];
    [self.tornImageView loadInBackground];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark { }
-(void)runQuery
{
    
    [self.query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
        if (object) {
            
            NSLog(@"Object: %@",self.torn);
            NSNumber *yes = [object objectForKey:TornOneYes];
            NSNumber *no = [object objectForKey:TornOneNo];
            
            self.yesLabel.text = [yes stringValue];
            self.noLabel.text = [no stringValue];
            
        }
    
    }];

}

-(void)showLogin
{
    [APPLICATION_DELEGATE presentLoginView];
}
@end
