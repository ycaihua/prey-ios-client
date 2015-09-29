//
//  WizardController.h
//  Prey
//
//  Created by Javier Cala Uribe on 8/07/13.
//  Copyright (c) 2013 Fork Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "Location.h"
#import "UIWebViewController.h"

@interface OnboardingWebView : UIViewController <UIWebViewControllerDelegate, UIWebViewDelegate, MBProgressHUDDelegate>
{
    UIWebView *wizardWebView;
    Location *location;
    MBProgressHUD *HUD;
}

@property (nonatomic)  UIWebView *wizardWebView;

@end
