//
//  TodayViewController.m
//  Prey Widget
//
//  Created by Javier Cala Uribe on 5/2/15.
//  Copyright (c) 2015 Fork Ltd. All rights reserved.
//

#import "PreyWidgetController.h"
#import "PreyWidgetHttp.h"

@interface PreyWidgetController () <NCWidgetProviding>

@end

@implementation PreyWidgetController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler
{
    self.onPreyWidgetVerificationSucceeded = completionHandler;
    
    [PreyWidgetHttp checkStatusForDevice:5 withBlock:^(NSHTTPURLResponse *response, NSError *error) {
        if (error)
        {
            [self checkedCompletionHandlerError];
        }
    }];
}

- (void)checkedCompletionHandler
{
    if (self.onPreyWidgetVerificationSucceeded)
    {
        self.onPreyWidgetVerificationSucceeded(NCUpdateResultNewData);
        self.onPreyWidgetVerificationSucceeded = nil;
    }
}

- (void)checkedCompletionHandlerError
{
    if (self.onPreyWidgetVerificationSucceeded)
    {
        self.onPreyWidgetVerificationSucceeded(NCUpdateResultFailed);
        self.onPreyWidgetVerificationSucceeded = nil;
    }
}


@end
