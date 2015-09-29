//
//  WizardController.m
//  Prey
//
//  Created by Javier Cala Uribe on 8/07/13.
//  Copyright (c) 2013 Fork Ltd. All rights reserved.
//

#import "OnboardingWebView.h"

#import "PreyAppDelegate.h"
#import "User.h"
#import "Device.h"
#import "PreyConfig.h"
#import "Constants.h"
#import "Location.h"

#import "CongratulationsController.h"

@interface OnboardingWebView ()

@end

@implementation OnboardingWebView

@synthesize wizardWebView;

#pragma mark Init

- (void)callStartMethod:(NSURL *)userInfo
{
    NSInteger currentPage = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentViewWizard"];
    if (currentPage == 0)
        currentPage = 1;
    
    NSString *loadString = [NSString stringWithFormat:@"Wizard.load('%ld')",(long)currentPage];
    
    [wizardWebView stringByEvaluatingJavaScriptFromString:@"Wizard.start(4)"];
    [wizardWebView stringByEvaluatingJavaScriptFromString:loadString];

/*
    PreyConfig *config = [PreyConfig instance];
    
    if (config.alreadyRegistered)
    {
        if (config.askForPassword)
        {
            [wizardWebView stringByEvaluatingJavaScriptFromString:@"Wizard.load('ok')"];
            [self enablePrey];
        }
    }
    else
    {
        NSInteger currentPage = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentViewWizard"];
        if (currentPage == 0)
            currentPage = 1;
        
        NSString *loadString = [NSString stringWithFormat:@"Wizard.load('%d')",currentPage];
        
        [wizardWebView stringByEvaluatingJavaScriptFromString:@"Wizard.start(4)"];
        [wizardWebView stringByEvaluatingJavaScriptFromString:loadString];
    }
*/
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"index" ofType:@"html" inDirectory:@"OnboardingWebView"]];
    
    PreyAppDelegate *appDelegate = (PreyAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    wizardWebView = [[UIWebView alloc] initWithFrame:appDelegate.window.frame];
    [wizardWebView loadRequest:[NSURLRequest requestWithURL:url]];
    [wizardWebView setDelegate:self];
    wizardWebView.scrollView.alwaysBounceVertical = NO;

    [self.view addSubview:wizardWebView];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark New User

- (void)callNewUserMethod:(NSURL *)userInfo
{
    NSArray     *userData = [userInfo pathComponents];
    NSString    *strEmailMatchstring =   @"\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b";
    
    if ([userData count] == 4)
    {
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.delegate = self;
        HUD.labelText = NSLocalizedString(@"Attaching device...",nil);
        
        [self addNewUser:userData];
    }
    else
        [self showWarningInfoUser];
}

- (void) addNewUser:(NSArray*)userData
{
    // UserDATA = nombre, email, password
    if ([userData[3] length] <6)
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"We have a situation!",nil)
                                                            message:NSLocalizedString(@"Password must be at least 6 characters",nil)
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    [User createNew:userData[1] email:userData[2] password:userData[3] repassword:userData[3]
          withBlock:^(User *user, NSError *error)
     {
         if (!error) // User Login
         {
             [Device newDeviceForApiKey:user
                              withBlock:^(User *user, Device *dev, NSError *error)
              {
                  [MBProgressHUD hideHUDForView:self.view animated:NO];
                  
                  if (!error) // Device created
                  {
                      PreyConfig *config = [PreyConfig initWithUser:user andDevice:dev];
                      if (config != nil)
                      {
                          NSString *txtCongrats = NSLocalizedString(@"Account created! Remember to verify your account by opening your inbox and clicking on the link we sent to your email address.",nil);
                          [(PreyAppDelegate*)[UIApplication sharedApplication].delegate registerForRemoteNotifications];
                          [self performSelectorOnMainThread:@selector(showCongratsView:) withObject:txtCongrats waitUntilDone:NO];
                      }
                  }
              }]; // End Block Device
         }
         else
             [MBProgressHUD hideHUDForView:self.view animated:NO];
     }]; // End Block User
}


#pragma mark Old User

- (void)callOldUserMethod:(NSURL *)userInfo
{
    NSArray     *userData = [userInfo pathComponents];
    NSString    *strEmailMatchstring =   @"\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b";
    
    if ([userData count] == 3)
    {
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.labelText = NSLocalizedString(@"Attaching device...",nil);
        
        [self addDeviceForCurrentUser:userData];
    }
    else
        [self showWarningInfoUser];
}

- (void) addDeviceForCurrentUser:(NSArray*)userData
{
    [User allocWithEmail:userData[1] password:userData[2]
               withBlock:^(User *user, NSError *error)
     {
         if (!error) // User Login
         {
             [Device newDeviceForApiKey:user
                              withBlock:^(User *user, Device *dev, NSError *error)
              {
                  [MBProgressHUD hideHUDForView:self.view animated:NO];
                  
                  if (!error) // Device created
                  {
                      PreyConfig *config = [PreyConfig initWithUser:user andDevice:dev];
                      if (config != nil)
                      {
                          NSString *txtCongrats = NSLocalizedString(@"Congratulations! You have successfully associated this iOS device with your Prey account.",nil);
                          [(PreyAppDelegate*)[UIApplication sharedApplication].delegate registerForRemoteNotifications];
                          [self performSelectorOnMainThread:@selector(showCongratsView:) withObject:txtCongrats waitUntilDone:NO];
                      }
                  }
              }]; // End Block Device
         }
         else
             [MBProgressHUD hideHUDForView:self.view animated:NO];
     }]; // End Block User
}

- (void)deviceAddedSuccessfully
{
    [wizardWebView stringByEvaluatingJavaScriptFromString:@"Wizard.load('ok')"];
    
    [self enableLocationManager];
    [self enablePrey];
}

- (void)enableLocationManager
{
    location = [[Location alloc] init];
    //[location testLocation];
}

- (void)enablePrey
{
    UIRemoteNotificationType notificationTypes = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    
    if (notificationTypes & UIRemoteNotificationTypeAlert)
        PreyLogMessage(@"App Delegate", 10, @"Alert notification set. Good!");
    else
    {
        PreyLogMessage(@"App Delegate", 10, @"User has disabled alert notifications");
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Alert notification disabled",nil)
                                                            message:NSLocalizedString(@"You need to grant Prey access to show alert notifications in order to remotely mark it as missing.",nil)
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK",nil)
                                                  otherButtonTitles:nil];
		[alertView show];
    }

}


#pragma mark Methods

- (void)showWebView:(NSString *)url
{
    /*
    UIViewController *controller = [UIWebViewController controllerToEnterdelegate:self
                                                                   forOrientation:UIInterfaceOrientationPortrait setURL:url];
    
    if (controller)
    {
        if ([self.navigationController respondsToSelector:@selector(presentViewController:animated:completion:)]) // Check iOS 5.0 or later
            [self.navigationController presentViewController:controller animated:YES completion:NULL];
        else
            [self.navigationController presentModalViewController:controller animated:YES];
    }
    */
}

- (void)showWarningInfoUser
{
    UIAlertView *objAlert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Enter a valid e-mail/password" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Try Again",nil];
    [objAlert show];
}

- (void) showCongratsView:(id) congratsText
{
    CongratulationsController *congratsController;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        if (IS_IPHONE5)
            congratsController = [[CongratulationsController alloc] initWithNibName:@"CongratulationsController-iPhone-568h" bundle:nil];
        else
            congratsController = [[CongratulationsController alloc] initWithNibName:@"CongratulationsController-iPhone" bundle:nil];
    }
    else
        congratsController = [[CongratulationsController alloc] initWithNibName:@"CongratulationsController-iPad" bundle:nil];
    
    congratsController.txtToShow = (NSString*) congratsText;
    
    PreyAppDelegate *appDelegate = (PreyAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.viewController setNavigationBarHidden:YES animated:YES];
    [appDelegate.viewController pushViewController:congratsController animated:YES];
}

#pragma mark UIWebViewDelegate

- (void)callJavaScriptMethod:(NSURL *)userInfo
{    
    if ([[userInfo host] isEqualToString:@"index"])
    {
        [self callStartMethod:userInfo];
    }
    
    else if ([[userInfo host] isEqualToString:@"signin"])
    {
        [self callOldUserMethod:userInfo];
    }

    else if ([[userInfo host] isEqualToString:@"signup"])
    {
        [self callNewUserMethod:userInfo];
    }
    
    else if ([[userInfo host] isEqualToString:@"activeView"])
    {
        NSArray     *userData = [userInfo pathComponents];
        [[NSUserDefaults standardUserDefaults] setInteger:[userData[1] intValue] forKey:@"currentViewWizard"];
    }
    else if ([[userInfo host] isEqualToString:@"tos"])
    {
        [self showWebView:@"https://preyproject.com/terms"];
    }
    else if ([[userInfo host] isEqualToString:@"privacy"])
    {
        [self showWebView:@"https://preyproject.com/privacy"];
    }
    else if ([[userInfo host] isEqualToString:@"forgot"])
    {
        [self showWebView:@"https://beta.preyproject.com/forgot"];
    }
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
    /*
    NSString *url_ = @"foo://name.com:8080/12345;param?foo=1&baa=2#fragment";
    NSURL *url = [NSURL URLWithString:url_];
    
    NSLog(@"scheme: %@", [url scheme]);
    NSLog(@"host: %@", [url host]);
    NSLog(@"port: %@", [url port]);
    NSLog(@"path: %@", [url path]);
    NSLog(@"path components: %@", [url pathComponents]);
    NSLog(@"parameterString: %@", [url parameterString]);
    NSLog(@"query: %@", [url query]);
    NSLog(@"fragment: %@", [url fragment]);
     
     TEST
     command://callfunction/parameter1/parameter2?parameter3=value
    */
    
    NSURL *URL = [request URL];
    if ([[URL scheme] isEqualToString:@"command"])
    {
        [self callJavaScriptMethod:URL];
        return NO;
    }
    else
        return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    PreyLogMessage(@"Wizard Controller", 10, @"Did StartLoadUIWebview");
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    PreyLogMessage(@"Wizard Controller", 10, @"Did FinishLoadUIWebView");
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    PreyLogMessage(@"Wizard Controller", 10, @"Did FailLoadUIWebView = %@", error);
}

@end
