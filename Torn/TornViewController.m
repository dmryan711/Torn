//
//  TornViewController.m
//  Torn
//
//  Created by Devon Ryan on 2/27/14.
//  Copyright (c) 2014 Devon Ryan. All rights reserved.
//

#import <Parse/Parse.h>
#import "TornViewController.h"
#import "UIFont+FlatUI.h"
#import "FUIButton.h"
#import "UIColor+FlatUI.h"
#import "UINavigationBar+FlatUI.h"
#import "TornAppDelegate.h"

#define APPLICATION_DELEGATE (TornAppDelegate *)[[UIApplication sharedApplication] delegate]


@interface TornViewController ()
@property (weak, nonatomic) IBOutlet FUIButton *buttonOne;
@property (weak, nonatomic) IBOutlet FUIButton *buttonTwo;
@property (weak, nonatomic) IBOutlet FUIButton *buttonThree;
@property (weak, nonatomic) IBOutlet FUIButton *buttonFour;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) UITapGestureRecognizer *tapGesture;

@end

@implementation TornViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar configureFlatNavigationBarWithColor:[UIColor pomegranateColor]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(logOut)];
    
    self.view.userInteractionEnabled = YES;
    
    
    self.navigationController.navigationBar.tintColor = [UIColor cloudsColor];
    
    self.buttonOne.buttonColor = [UIColor alizarinColor];
    self.buttonTwo.buttonColor = [UIColor alizarinColor];
    self.buttonThree.buttonColor = [UIColor alizarinColor];
    self.buttonFour.buttonColor = [UIColor alizarinColor];
    
    self.buttonOne.shadowColor = [UIColor pomegranateColor];
    self.buttonTwo.shadowColor = [UIColor pomegranateColor];
    self.buttonThree.shadowColor = [UIColor pomegranateColor];
    self.buttonFour.shadowColor = [UIColor pomegranateColor];
    
    self.buttonOne.highlightedColor = [UIColor alizarinColor];
    self.buttonTwo.highlightedColor = [UIColor alizarinColor];
    self.buttonThree.highlightedColor = [UIColor alizarinColor];
    self.buttonFour.highlightedColor = [UIColor alizarinColor];
    
    //self.buttonOne.titleLabel.font = [UIFont fontWithName:@"Lato-Black" size:20];
    self.buttonTwo.titleLabel.font = [UIFont fontWithName:@"Lato-Bla" size:20];
    self.buttonThree.titleLabel.font = [UIFont fontWithName:@"Lato-Bol" size:20];
    self.buttonFour.titleLabel.font = [UIFont fontWithName:@"Lato-Blalta" size:20];
    
    self.titleLabel.font = [UIFont fontWithName:@"Lato-Black" size:24];
    self.titleLabel.textColor = [UIColor blackColor];
    
   
    
    /*self.buttonOne.titleLabel.tintColor = [UIColor cloudsColor];
    self.buttonTwo.titleLabel.textColor = [UIColor cloudsColor];
    self.buttonThree.titleLabel.textColor = [UIColor cloudsColor];
    self.buttonFour.titleLabel.textColor = [UIColor cloudsColor];*/

    
    self.buttonOne.shadowHeight = 6.0f;
    self.buttonTwo.shadowHeight = 6.0f;
    self.buttonThree.shadowHeight = 6.0f;
    self.buttonFour.shadowHeight = 6.0f;
    
    self.buttonOne.cornerRadius = 3.0f;
    self.buttonTwo.cornerRadius = 3.0f;
    self.buttonThree.cornerRadius = 3.0f;
    self.buttonFour.cornerRadius = 3.0f;
    
    
    
    self.view.backgroundColor  =[UIColor cloudsColor];
    

    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark {  }
-(void)logOut
{
    [APPLICATION_DELEGATE logOutUser];

}


@end
