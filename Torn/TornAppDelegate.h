//
//  TornAppDelegate.h
//  Torn
//
//  Created by Devon Ryan on 2/27/14.
//  Copyright (c) 2014 Devon Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface TornAppDelegate : UIResponder <UIApplicationDelegate, PFLogInViewControllerDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
-(void)presentLoginView;
-(void)logOutUser;

@end
