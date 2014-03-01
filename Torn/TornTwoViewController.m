//
//  TornTwoViewController.m
//  Torn
//
//  Created by Devon Ryan on 2/27/14.
//  Copyright (c) 2014 Devon Ryan. All rights reserved.
//

#import <Parse/Parse.h>
#import "UIColor+FlatUI.h"
#import "TornTwoViewController.h"

@interface TornTwoViewController ()
@property (weak, nonatomic) IBOutlet PFImageView *imageViewOne;
@property (weak, nonatomic) IBOutlet PFImageView *imageViewTwo;
@property (weak, nonatomic) IBOutlet UITextField *tornNameTextField;

@end

@implementation TornTwoViewController

-(void)awakeFromNib
{
    [PFImageView class];
}

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
    self.imageViewOne.backgroundColor = [UIColor silverColor];
    self.imageViewTwo.backgroundColor = [UIColor silverColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
