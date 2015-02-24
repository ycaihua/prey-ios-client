//
//  TodayViewController.h
//  Prey Widget
//
//  Created by Javier Cala Uribe on 5/2/15.
//  Copyright (c) 2015 Fork Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NotificationCenter/NotificationCenter.h>


@interface PreyWidgetController : UIViewController


@property (nonatomic, copy) void (^onPreyWidgetVerificationSucceeded)(NCUpdateResult);

@end
