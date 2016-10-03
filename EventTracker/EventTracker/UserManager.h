//
//  UserManager.h
//  EventTracker
//
//  Created by Gopinath on 10/3/16.
//  Copyright © 2016 Gopinath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserManager : NSObject

+(UserManager *)sharedManager;
@property(nonatomic, strong) NSString *userName;

@end
