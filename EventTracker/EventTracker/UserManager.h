//
//  UserManager.h
//  EventTracker
//
//  Created by Gopinath on 10/3/16.
//  Copyright © 2016 Gopinath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventHelper.h"
#import "Users.h"

@interface UserManager : NSObject

@property (nonatomic,strong) Users *currentUser;

+(UserManager *)sharedManager;
-(Users*)getUserWithName:(NSString*)userName;
-(BOOL)isUserTrackingEvent:(NSString*)eventId;
-(void)startTrackingEvent:(NSString*)eventId;
-(Users*)getCurrentUser;
@end
