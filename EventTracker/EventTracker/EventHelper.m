//
//  EventHelper.m
//  EventTracker
//
//  Created by Gopinath on 10/3/16.
//  Copyright © 2016 Gopinath. All rights reserved.
//

#import "EventHelper.h"

@implementation EventHelper

+(NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

@end
