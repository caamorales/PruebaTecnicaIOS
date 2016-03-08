//
//  Model.h
//  PruebaTecnicaIOS
//
//  Created by Camilo Morales on 8/3/16.
//  Copyright © 2016 SlashMobility. All rights reserved.
//

#import "Song.h"
#import <Foundation/Foundation.h>
#import "Constants.h"

@interface Model : NSObject

+ (Model *) sharedModel;

@property (nonatomic, strong, readonly) NSArray<Song *> *songs;

@end
