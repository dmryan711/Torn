//
//  TornOneViewController.m
//  Torn
//
//  Created by Devon Ryan on 2/27/14.
//  Copyright (c) 2014 Devon Ryan. All rights reserved.
//

#import <Parse/Parse.h>
#import "TornOneViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "UIProgressView+FlatUI.h"
#import "UIColor+FlatUI.h"
#import "TornConstants.h"
#import "TornUtility.h"
#import "FUIAlertView.h"

@interface TornOneViewController ()

@property  (strong, nonatomic) UIImagePickerController *imagePicker;
@property (strong, nonatomic) PFFile *imageFile;
@property (strong, nonatomic) NSString *tornName;
@property (strong, nonatomic) NSData *dataOfImage;
@property (strong, nonatomic) IBOutlet UIProgressView *imageLoad;
@property (weak, nonatomic) IBOutlet UITextField *tornNameTextField;
@end

@implementation TornOneViewController

-(void)awakeFromNib
{
    [PFImageView class];
    NSLog(@"View One");


    
    NSLog(@"Wakey Load");

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
    NSLog(@"View Did Load");
    
    self.tornNameTextField.delegate = self;
    
    [self.photoChoice setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tappedImage)];
    [self.photoChoice addGestureRecognizer:tap];
    
    
    UITapGestureRecognizer *viewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTapped)];
    [self.view addGestureRecognizer:viewTap];

    
    [viewTap setNumberOfTouchesRequired:1];
    [tap setNumberOfTouchesRequired:1];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Submit" style:UIBarButtonItemStyleBordered target:self action:@selector(submitTorn)];
    
    self.imageLoad.hidden = YES;
    [self.imageLoad configureFlatProgressViewWithTrackColor:[UIColor silverColor] progressColor:[UIColor greenSeaColor]];
    self.photoChoice.backgroundColor = [UIColor silverColor];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tap
-(void)tappedImage
{
    
    NSLog(@"Tap");
    UIActionSheet *imageLoadSheet = [[UIActionSheet alloc]initWithTitle:@"Uploade Image" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Choose From Library",@"Take a Photo", nil];
    [self dropKeyboardAndSetName];
    
    imageLoadSheet.delegate =self;
    
    [imageLoadSheet showFromTabBar:self.tabBarController.tabBar];

}

- (void)viewTapped {
    
    [self dropKeyboardAndSetName];
}


#pragma mark Action Sheet Delegate Methods
#define CAMERA_ROLL 0
#define TAKE_PHOTO 1
// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{}

// Called when we cancel a view (eg. the user clicks the Home button). This is not called when the user clicks the cancel button.
// If not defined in the delegate, we simulate a click in the cancel button
- (void)actionSheetCancel:(UIActionSheet *)actionSheet{}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet  // before animation and showing view
{}
- (void)didPresentActionSheet:(UIActionSheet *)actionSheet  // after animation
{}

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex // before animation and hiding view
{
    if (buttonIndex == CAMERA_ROLL) { //Camera Roll Was Selected
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){ // Selected Media Type is Available
            
            self.imagePicker = [[UIImagePickerController alloc]init];
            self.imagePicker.delegate = self;
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            self.imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:self.imagePicker.sourceType];
            [self presentViewController:self.imagePicker animated:YES completion:nil];
            
        }else{//Selected Media Type is not Available
            [self createAndDisplayMediaSourceAlert];
        }
    }else if (buttonIndex == TAKE_PHOTO){
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            self.imagePicker = [[UIImagePickerController alloc]init];
            self.imagePicker.delegate = self;
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            self.imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            self.imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:self.imagePicker.sourceType];
            [self presentViewController:self.imagePicker animated:YES completion:nil];
            
        }else{//No Camera is available
            [self createAndDisplayMediaSourceAlert];
        }
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex  // after animation
{}


#pragma mark UIImagePicker Controller Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
   
    //UnHide the Image Load Process Bar
    self.imageLoad.hidden = NO;
    
    NSString *imageType = (NSString *)kUTTypeImage;
    if (![[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:imageType]) { // User did not select an Image, throw an alert
        
        //Dismiss Image Picker & Show ALert
        [self dismissViewControllerAnimated:YES completion:^(void) {
            UIAlertView *didNotSelectImage = [[UIAlertView alloc]initWithTitle:@"Pictures Only!" message:@"The image you have selected is not a picture" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [didNotSelectImage show];
            
        }];
    }else{
        
        if (!_dataOfImage) {
            _dataOfImage = [[NSData alloc]init];
        }
        self.dataOfImage  = UIImageJPEGRepresentation([info objectForKey:UIImagePickerControllerOriginalImage], 0.5);
        
        //Set Image Locally & Animate Progress Bar
        self.imageFile = [PFFile fileWithData:self.dataOfImage];
        [self.imageFile saveInBackgroundWithBlock:^(BOOL succeeded , NSError *error){
            if (!error) {
                [self.photoChoice setFile:self.imageFile];
                [self.photoChoice  loadInBackground];
            }
            if (succeeded) {
                self.imageLoad.hidden = YES;
                self.imageLoad.progress = 0.0;
            }
            
        }
                                             progressBlock:^(int percentDone){
                                                 [self.imageLoad setProgress:(float)percentDone];
                                             }];
        
        //Upload Photo To Parse
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark TextField Delegate Method
- (BOOL)textFieldShouldReturn:(UITextField *)textField{ // called when 'return' key pressed. return NO to ignore.
    
    self.tornName = textField.text;
    [textField resignFirstResponder];
    
    
    return YES;
}

#pragma mark { }
-(void)createAndDisplayMediaSourceAlert
{
    UIAlertView *mediaTypeNotAvailable = [[UIAlertView alloc]initWithTitle:@"Sorry" message:@"The Media Type you have selected is not available!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [mediaTypeNotAvailable show];
    
}

-(void)dropKeyboardAndSetName
{
    
    if ([self.tornNameTextField isFirstResponder]) {
        self.tornName = self.tornNameTextField.text;
        
        [self.view endEditing:YES];
    }
}

-(void)submitTorn{
    
    [self dropKeyboardAndSetName];
    
    if (![self.tornName isEqualToString:@""] && self.imageFile) {
        NSLog(@"Upload Fired");
        
        
        //Process & Upload to Parse
        [TornUtility saveTornWithType:TornTypeSingle withName:self.tornName atTimeStamp:[NSDate date]  withPhotoOneFile:self.imageFile withPhotoTwoFile:nil withPhotoThreeFile:nil withPhotoFourFile:nil];
        
        [self createSubmissionSuccess];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }else{// Create Alert
        [self createSubmissionAlert];
    }

}


-(void)createSubmissionAlert{
    UIAlertView *submissionAlert = [[UIAlertView alloc]initWithTitle:@"Not Finished!" message:@"Sorry you either didn't upload all images or you forgot to name what your Torn over!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    
    [submissionAlert show];

}

-(void)createSubmissionSuccess{
    UIAlertView *submissionSuccess = [[UIAlertView alloc]initWithTitle:@"All Set!" message:@"Your Torn has been submitted!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    
    [submissionSuccess show];
    
}


@end
