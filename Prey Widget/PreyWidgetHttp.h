//
//  PreyWidgetHttp.h
//  Prey
//
//  Created by Javier Cala Uribe on 5/2/15.
//  Copyright (c) 2015 Fork Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface PreyWidgetHttp : NSObject


+ (void)checkStatusForDevice:(NSInteger)reload withBlock:(void (^)(NSHTTPURLResponse *response, NSError *error))block;

@end
