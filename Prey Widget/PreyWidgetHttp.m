//
//  PreyWidgetHttp.m
//  Prey
//
//  Created by Javier Cala Uribe on 5/2/15.
//  Copyright (c) 2015 Fork Ltd. All rights reserved.
//


#import "PreyWidgetHttp.h"
#import "AFNetworking.h"
#import "AFPreyStatusClient.h"
#import "PreyLogger.h"
#import "JsonConfigParser.h"
#import "PreyConfig.h"

@implementation PreyWidgetHttp


+ (void)checkStatusForDevice:(NSInteger)reload withBlock:(void (^)(NSHTTPURLResponse *response, NSError *error))block
{
    PreyLogMessage(@"PreyWidgetHttp", 21, @"WidgetHttp checkStatus");
    if (reload <= 0)
    {
        if (block)
        {
            NSError *error = [NSError errorWithDomain:@"StatusCode503Reload" code:700 userInfo:nil];
            block(nil, error);
        }
    }
    else
    {
        NSString *deviceKey = [[PreyConfig instance] deviceKey];
        
        [[AFPreyStatusClient sharedClient] getPath:[NSString stringWithFormat:@"/api/v2/devices/%@.json", deviceKey]
                                        parameters:nil
                                           success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             PreyLogMessage(@"PreyWidgetHttp", 21, @"GET devices/%@.json: %@",deviceKey,[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
             
             
             NSString *respString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
             JsonConfigParser *configParser = [[JsonConfigParser alloc] init];
             
             NSError *error2;
             NewModulesConfig *modulesConfig = [configParser parseModulesConfig:respString parseError:&error2];
             
             if ([modulesConfig checkAllModulesEmpty])
             {
                 NSLog(@"Tests");
                 //PreyAppDelegate *appDelegate = (PreyAppDelegate*)[[UIApplication sharedApplication] delegate];
                 //[appDelegate checkedCompletionHandler];
             }
             else
                 [modulesConfig runAllModules];
             
             
             
             if (block)
                 block(operation.response,nil);
            
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             if (block)
             {
                 if ([operation.response statusCode] == 503)
                 {
                     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                         [self checkStatusForDevice:reload - 1 withBlock:block];
                     });
                 }
                 else
                     block(operation.response,error);
             }
             PreyLogMessage(@"PreyWidgetHttp", 10,@"Error: %@",error);
         }];
    }
}


@end
