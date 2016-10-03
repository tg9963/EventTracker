//
//  Events+CoreDataProperties.h
//  EventTracker
//
//  Created by Gopinath on 10/3/16.
//  Copyright © 2016 Gopinath. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Events.h"

NS_ASSUME_NONNULL_BEGIN

@interface Events (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *eventId;
@property (nullable, nonatomic, retain) NSString *eventLocation;
@property (nullable, nonatomic, retain) NSString *eventName;
@property (nullable, nonatomic, retain) NSString *eventPrice;
@property (nullable, nonatomic, retain) NSString *eventImage;

@end

NS_ASSUME_NONNULL_END
