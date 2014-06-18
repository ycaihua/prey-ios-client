//
//  PhotoLibraryModule.h
//  Prey
//
//  Created by Javier Cala Uribe on 18/6/14.
//  Copyright (c) 2014 Fork Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataModule.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface PhotoLibraryModule : DataModule
{
    ALAssetsLibrary     *library;
    NSArray             *imageArray;
    NSMutableArray      *mutableArray;
}

- (void)allPhotosCollected:(NSArray*)imgArray;

@end