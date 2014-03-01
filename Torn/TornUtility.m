//
//  TornUtility.m
//  Torn
//
//  Created by Devon Ryan on 2/27/14.
//  Copyright (c) 2014 Devon Ryan. All rights reserved.
//

#import "TornUtility.h"
#import "TornConstants.h"
#import "UIImage+ResizeAdditions.h"

@implementation TornUtility

+(NSInteger)age:(NSDate *)dateOfBirth {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    
    NSDateComponents *dateComponentsNow = [calendar components:unitFlags fromDate:[NSDate date]];
    
    NSDateComponents *dateComponentsBirth = [calendar components:unitFlags fromDate:dateOfBirth];
    
    if (([dateComponentsNow month] < [dateComponentsBirth month]) ||
        (([dateComponentsNow month] == [dateComponentsBirth month]) && ([dateComponentsNow day] < [dateComponentsBirth day])))
    {
        return [dateComponentsNow year] - [dateComponentsBirth year] - 1;
        
    } else {
        
        return [dateComponentsNow year] - [dateComponentsBirth year];
    }
}

+(void)saveTornWithType:(NSString *)tornType withName:(NSString *)name  atTimeStamp:(NSDate *) timeStamp withPhotoOneFile:(PFFile *)fileOne withPhotoTwoFile:(PFFile *)fileTwo withPhotoThreeFile:(PFFile *)fileThree withPhotoFourFile:(PFFile *)fileFour
{
    PFObject *torn = [PFObject objectWithClassName:TornClass];
    
    if ([tornType isEqualToString:TornTypeSingle]) {
        //[torn setObject:[TornUtility processedImageWithData:dataOne] forKey:TornPhotoOneProcessed];
        //[torn setObject:[TornUtility thumbNailImageWithData:dataOne] forKey:TornPhotoOneThumbNail];
        [torn setObject:fileOne forKey:TornPhotoOne];
        
    }else if ([tornType isEqualToString:TornTypeDouble]){
        [torn setObject:fileOne forKey:TornPhotoOne];
        [torn setObject:fileTwo forKey:TornPhotoTwo];
        
    }else if ([tornType isEqualToString:TornTypeTriple]){
        [torn setObject:fileOne forKey:TornPhotoOne];
        [torn setObject:fileTwo forKey:TornPhotoTwo];
        [torn setObject:fileThree forKey:TornPhotoThree];
        
    }else if ([tornType isEqualToString:TornTypeQuadrupal]){
        [torn setObject:fileOne forKey:TornPhotoOne];
        [torn setObject:fileTwo forKey:TornPhotoTwo];
        [torn setObject:fileThree forKey:TornPhotoThree];
        [torn setObject:fileFour forKey:TornPhotoFour];
    }
    
    [torn setObject:[TornUtility getLocalTime:timeStamp] forKey:TornTimeStamp];
    [torn setObject:name forKey:TornName];
    [torn setObject:tornType forKey:TornType];
    [torn setObject:[PFUser currentUser] forKey:TornUser];
    
    [torn saveEventually];

}

+(NSDate *)getLocalTime:(NSDate *)date
{

    NSDate* sourceDate = date;
    
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    
    NSDate* destinationDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate];
    
    return destinationDate;
    
}


+(PFFile *)processedImageWithData:(NSData *)data
{
 
    UIImage *image = [UIImage imageWithData:data];

    UIImage *mediumImage = [image thumbnailImage:280 transparentBorder:0 cornerRadius:.3 interpolationQuality:kCGInterpolationHigh];

    NSData *mediumImageData = UIImageJPEGRepresentation(mediumImage, 0.5); // using JPEG for larger pictures

    if (mediumImageData.length > 0) {
        return [PFFile fileWithData:mediumImageData];
    }else{
        return nil;
    }
}

+(PFFile *)thumbNailImageWithData:(NSData *)data
{
    
    UIImage *image = [UIImage imageWithData:data];
    
    UIImage *smallRoundedImage = [image thumbnailImage:64 transparentBorder:0 cornerRadius:9 interpolationQuality:kCGInterpolationLow];
    NSData *smallRoundedImageData = UIImagePNGRepresentation(smallRoundedImage);
    
    if (smallRoundedImageData.length > 0) {
        
        return [PFFile fileWithData:smallRoundedImageData];
    }else{
        return nil;
    }
    
}




@end
