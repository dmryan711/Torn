//
//  TornUtility.h
//  Torn
//
//  Created by Devon Ryan on 2/27/14.
//  Copyright (c) 2014 Devon Ryan. All rights reserved.
//

#import <Parse/Parse.h>

#import <Foundation/Foundation.h>

@interface TornUtility : NSObject

+(NSInteger)age:(NSDate *)dateOfBirth;
+(void)saveTornWithType:(NSString *)tornType withName:(NSString *)name  atTimeStamp:(NSDate *) timeStamp withPhotoOneFile:(PFFile *)fileOne withPhotoTwoFile:(PFFile *)fileTwo withPhotoThreeFile:(PFFile *)fileThree withPhotoFourFile:(PFFile *)fileFour;
+(NSDate *)getLocalTime:(NSDate *)date;

@end
