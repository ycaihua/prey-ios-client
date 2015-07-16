//
//  Config.h
//  Prey-iOS
//
//  Created by Carlos Yaconi on 25-03-10.
//  Copyright 2010 Fork Ltd.. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject {
    
	
}

// Onboarding View
#define subTextColor [UIColor colorWithWhite:0.79 alpha:1.000]



#define kTagNameNewUser 28
#define kTagNameOldUser 29

#define kTagSegmentedControl 2010

#define kTagLogoType       1000
#define kTagFlashView      1100
#define kTagPhotoImage     1101
#define kTagOldUser        1201 
#define kTagNewUser        1202

#define kTagButtonStart     200
#define kTagButtonBack      201
#define kTagButtonNext      202

#define kTagViewScroll      101
#define kTagViewPage        102
#define kPageWidth          100
#define kPageHeight          20

#define kNumberPages          4

#define kTagCameraSwitch   3301
#define kTagLocationSwitch 3302
#define kTagNotifySwitch   3303

#define kTagImageBg0       6100
#define kTagImageBg1       6101
#define kTagImageBg2       6102

#define kGAIcode @"UA-8743344-7"

#define kLabelTag	4096

#define IS_IPAD ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPhone)
#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)
#define IS_OS_5_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
#define IS_OS_6_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define IS_OS_8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

extern NSString * const DEFAULT_CONTROL_PANEL_HOST;
extern NSString * const DEFAULT_CHECK_PATH;
extern BOOL const DEFAULT_SEND_CRASH_REPORTS;
extern NSString * const DEFAULT_EXCEPTIONS_ENDPOINT;
extern NSString * const DEFAULT_DATA_ENDPOINT_LOCATION;
extern BOOL  const ASK_FOR_LOGIN;
extern BOOL const USE_CONTROL_PANEL_DELAY;
extern BOOL const SHOULD_LOG;

extern NSString * const URL_LOGIN_PANEL;
extern NSString * const URL_FORGOT_PANEL;

extern NSString * const URL_TERMS_PREY;
extern NSString * const URL_PRIVACY_PREY;
extern NSString * const URL_HELP_PREY;

+(NSString *) appName;
+(NSString *) appVersion;
+(NSString *) appBuildVersion;
+(NSString *) appLabel;

@end
