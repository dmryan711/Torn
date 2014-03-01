//
//  TornAppDelegate.m
//  Torn
//
//  Created by Devon Ryan on 2/27/14.
//  Copyright (c) 2014 Devon Ryan. All rights reserved.
//


#import "TornAppDelegate.h"
#import "TornMainTableViewController.h"
#import "TornLoginViewController.h"
#import "TornViewController.h"
#import "TornConstants.h"
#import "TornUtility.h"
#import "UINavigationBar+FlatUI.h"
#import "UIColor+FlatUI.h"
#import "UITabBar+FlatUI.h"

@interface TornAppDelegate ()

@property  (strong, nonatomic)  UITabBarController *startingViewController;

@end

@implementation TornAppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [Parse setApplicationId:@"8291A2TP49UYYZC0D22fG4ZIEzNGZTuZvz1ISMTV"
                  clientKey:@"WRU2FuJvlczkrDqXlqaeDz6O6CTBo1Bvyjh94j1w"];
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    [PFFacebookUtils initializeFacebook];
    
    NSLog(@"Bundle ID: %@",[[NSBundle mainBundle] bundleIdentifier]);
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    
    self.startingViewController = [mainStoryboard instantiateInitialViewController];
    
    [self.startingViewController.tabBar configureFlatTabBarWithColor:[UIColor blackColor]];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setRootViewController:self.startingViewController];
    [self.window makeKeyAndVisible];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    
    
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark Facebook Session Setup

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[PFFacebookUtils session]];
}

#pragma mark Login Delegate

/*!
 Sent to the delegate to determine whether the log in request should be submitted to the server.
 @param username the username the user tries to log in with.
 @param password the password the user tries to log in with.
 @result a boolean indicating whether the log in should proceed.
 */
/*- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password
{}*/

/*! @name Responding to Actions */
/// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user
{
    //Remove Login View
    [self.startingViewController dismissViewControllerAnimated:YES completion:nil];
    
    //[self.startingViewController presentViewController:[[self.startingViewController viewControllers]objectAtIndex:0] animated:YES completion:nil];
    
    //Set Requests
    FBRequest *requestForFriends = [FBRequest requestForMyFriends];
    FBRequest *request = [FBRequest requestForMe];
    
    //Request Friends
    [requestForFriends startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error){
        if (!error) {
            
            NSArray *data = [result objectForKey:@"data"];
            
            //Create List of Friend Ids
            if (data) {
                NSMutableArray *friendIdList = [[NSMutableArray alloc]initWithCapacity:[data count]];
                for (NSDictionary *friend in data){
                    [friendIdList addObject:friend[@"id"]];
                }
                
                [user setObject:friendIdList forKey:UserFriends];
                
                [user saveEventually];
                
                
            }
            
        } else if ([error.userInfo[FBErrorParsedJSONResponseKey][@"body"][@"error"][@"type"] isEqualToString:@"OAuthException"]) {//Request Failed , Checking Why
            NSLog(@"The facebook session was invalidated");
            [self logOutUser];
            
        } else {
            NSLog(@"Some other error: %@", error);
            [self logOutUser];
        }
        
        
    }];
    
    //Request User Information
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error){
        if (!error) {
            
            //Store Facebook Results to local objects
            NSDictionary *userData = (NSDictionary *)result;
            
            NSString *email = [userData objectForKey:@"email"];
            NSString *gender = [userData objectForKey:@"gender"];
            NSString  *locale = [userData objectForKey:@"locale"];
            NSString *birthday = [userData objectForKey:@"birthday"];
            NSString *fullName = [userData objectForKey:@"name"];
            NSString *faceBookID = [userData objectForKey:@"id"];
            
            //Derive Age from Birthday
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
            [dateFormat setDateFormat:@"MM/dd/yyyy"];
            [dateFormat dateFromString:birthday];
            NSNumber *age = [NSNumber numberWithInteger:[TornUtility age:[dateFormat dateFromString:birthday]]];
            
            //Save local facebook result to Parse
            [user setObject:email forKey:UserEmail];
            [user setObject:gender forKey:UserGender];
            [user setObject:locale forKey:UserLocale];
            [user setObject:birthday forKey:UserBirthday];
            [user setObject:age forKey:UserAge];
            [user setObject:fullName forKey:UserDisplayName];
            [user setObject:faceBookID forKey:UserFacebookId];
        }
    }];
            
            
    
    
}

/// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error
{}

/// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController
{}

#pragma mark { }
-(void)presentLoginView
{
    TornLoginViewController    *logInViewController = [[TornLoginViewController alloc] init];
    [logInViewController setDelegate:self]; // Set ourselves as the delegate
    [logInViewController setFacebookPermissions:[NSArray arrayWithObjects:@"email",@"user_location",@"user_birthday", nil]];
    [logInViewController setFields:PFLogInFieldsFacebook];
    
    [self.startingViewController presentViewController:logInViewController animated:YES completion:NULL];

 
}

-(void)logOutUser{
            
    [PFUser logOut];
    [self presentLoginView];
}

@end
