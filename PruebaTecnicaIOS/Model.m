//
//  Model.m
//  PruebaTecnicaIOS
//
//  Created by Camilo Morales on 8/3/16.
//  Copyright © 2016 SlashMobility. All rights reserved.
//

#import "Model.h"
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface Model ()
@property (nonatomic, strong, readwrite) NSArray<Song *> *songs;
@end

static Model *shared = NULL;

typedef void(^requestCompletion)(NSDictionary *data, NSError *error);

@implementation Model

+ (Model *)sharedModel {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (id)init{
    self = [super init];
    if (self) {
        [self downloadData];
    }
    return self;
}

- (void)performRequestWithMethod:(NSString *)method url:(NSString *) url data:(NSDictionary *)requestData completion:(requestCompletion) completion
{
    NSMutableDictionary *payload = [[NSMutableDictionary alloc] init];
    [payload addEntriesFromDictionary:requestData];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:method];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    if (requestData) {
        NSError *dataEncodingError;
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:payload options:kNilOptions error:&dataEncodingError];
        if (!dataEncodingError) [request setHTTPBody:jsonData];
    }
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (!connectionError) {
            NSError *decodingError;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&decodingError];
            completion(json, decodingError);
        }else{
            completion(nil, connectionError);
        }
    }];
}

- (void)downloadData{
    
    [self performRequestWithMethod:@"GET" url:TARGET_URL data:nil completion:^(NSDictionary *data, NSError *error) {

        if (!error && data) {
            self.songs = [self parseData:data[SONGS_RESULT_KEY]];

            [[NSNotificationCenter defaultCenter] postNotificationName:DATA_READY_NOTIFICATION object:nil];
            [self saveSongsToCoreData:self.songs];
        }else{
            
            NSArray<NSManagedObject *> *savedSongs;
            AppDelegate* appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
            NSManagedObjectContext *managedContext = appDelegate.managedObjectContext;
            NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Song"];
            NSError *error;
            savedSongs = [managedContext executeFetchRequest:request error:&error];
            self.songs = [self parseManageObjectToSong:savedSongs];
            
            if (!error) {
                [[NSNotificationCenter defaultCenter] postNotificationName:DATA_READY_NOTIFICATION object:nil];
            }else{
                self.songs = nil;
                [[NSNotificationCenter defaultCenter] postNotificationName:DATA_READY_NOTIFICATION object:nil userInfo:error ? @{@"error": error.localizedDescription} : nil];
            }
            
        }
        
    }];
}

- (NSMutableArray <Song *> *)parseData:(NSMutableArray *) data{
    
    NSMutableArray<Song *> *parsedData = [[NSMutableArray alloc] initWithCapacity:data.count];

    for (NSDictionary *anEntry in data) {
        Song *aSong = [[Song alloc] init];
        aSong.trackName = anEntry[SONG_TRACK_NAME_KEY];
        aSong.collectionCensoredName = anEntry[SONG_COLLECTION_SENSORED_NAME_KEY];
        aSong.country = anEntry[SONG_COUNTRY_KEY];
        [parsedData addObject:aSong];
    }
    
    return parsedData;
}

- (NSMutableArray <Song *> *)parseManageObjectToSong:(NSArray <NSManagedObject *> *) savedSongs{
   
    NSMutableArray<Song *> *parsedData = [[NSMutableArray alloc] initWithCapacity:savedSongs.count];
    
    for (NSManagedObject *anEntry in savedSongs) {
        Song *aSong = [[Song alloc] init];
        aSong.trackName = [anEntry valueForKey:SONG_TRACK_NAME_KEY];
        aSong.collectionCensoredName = [anEntry valueForKey:SONG_COLLECTION_SENSORED_NAME_KEY];
        aSong.country = [anEntry valueForKey:SONG_COUNTRY_KEY];
        [parsedData addObject:aSong];
    }
    
    return parsedData;
}

- (void)saveSongsToCoreData:(NSArray<Song *> *) songs{
    AppDelegate* appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managedContext = appDelegate.managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Song" inManagedObjectContext:managedContext];
    
    for (Song *aSong in songs) {
        NSManagedObject *aManagedSong = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:managedContext];
        [aManagedSong setValue:aSong.trackName forKey:@"trackName"];
        [aManagedSong setValue:aSong.collectionCensoredName forKey:@"collectionCensoredName"];
        [aManagedSong setValue:aSong.country forKey:@"country"];
        NSError *error;
        [managedContext save:&error];
        if (error) {
            NSLog(@"%@",error.localizedDescription);
        }
    }


}

@end
