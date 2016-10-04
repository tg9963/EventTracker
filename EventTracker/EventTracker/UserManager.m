//
//  UserManager.m
//  EventTracker
//
//  Created by Gopinath on 10/3/16.
//  Copyright © 2016 Gopinath. All rights reserved.
//

#import "UserManager.h"

@implementation UserManager

+(UserManager *)sharedManager {
    static UserManager *_sharedManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

-(void)setCurrentUser:(Users*)currentUser{
    _currentUser = currentUser;
}

-(Users*)getCurrentUser{
    return _currentUser;
}

-(Users*)getUserWithName:(NSString*)userName{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Users" inManagedObjectContext:[EventHelper managedObjectContext]]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userName == %@",userName];
    
    [fetchRequest setPredicate:predicate];
    [fetchRequest setFetchLimit:1];
    
    NSError *error = nil;
    NSArray *objects = [[EventHelper managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    Users *activeUser = nil;
    if (objects.count > 0) {
        activeUser = objects[0];
    } else {
        
        activeUser = [NSEntityDescription insertNewObjectForEntityForName:@"Users" inManagedObjectContext:[EventHelper managedObjectContext]];
        [activeUser setUserId:[NSString stringWithFormat:@"%@",[activeUser objectID]]];
        [activeUser setUserName:userName];
    }
    return activeUser;
}

-(BOOL)isUserTrackingEvent:(NSString*)eventId{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"UserEventTracker" inManagedObjectContext:[EventHelper managedObjectContext]]];
    NSString *userId = [NSString stringWithFormat:@"%@",[[self getCurrentUser] userId]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId == %@ AND eventId == %@",userId,eventId];
    
    [fetchRequest setPredicate:predicate];
    [fetchRequest setFetchLimit:1];
    
    NSError *error = nil;
    NSArray *objects = [[EventHelper managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    if (objects.count > 0) {
        return true;
    }
    return false;
}

-(void)startTrackingEvent:(NSString*)eventId{
    NSManagedObjectContext *context = [EventHelper managedObjectContext];
    NSManagedObject *newEvent = [NSEntityDescription insertNewObjectForEntityForName:@"UserEventTracker" inManagedObjectContext:context];
    NSString *userId = [NSString stringWithFormat: @"%@",[[self getCurrentUser] userId]];
    [newEvent setValue:userId forKey:@"userId"];
    [newEvent setValue:eventId forKey:@"eventId"];
//    NSManagedObjectID *moID = [[self getCurrentUser] objectID];
    
    NSError *error = nil;
    if (![context save:&error]) {
//        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }else{
//        NSLog(@"User %@ started tracking event %@",moID,eventId);
    }
}

@end
