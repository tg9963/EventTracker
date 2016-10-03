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

-(void)setUserName:(NSString *)userName{
    _userName = userName;
}

-(NSString*)getUserName{
    return _userName;
}

@end
