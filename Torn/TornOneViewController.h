//
//  TornOneViewController.h
//  Torn
//
//  Created by Devon Ryan on 2/27/14.
//  Copyright (c) 2014 Devon Ryan. All rights reserved.
//

#import "FUIAlertView.h"
#import <UIKit/UIKit.h>

@interface TornOneViewController : UIViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIActionSheetDelegate,UITextFieldDelegate,FUIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet PFImageView *photoChoice;

@end
