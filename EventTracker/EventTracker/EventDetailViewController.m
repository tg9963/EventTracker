//
//  EventDetailViewController.m
//  EventTracker
//
//  Created by Gopinath on 10/2/16.
//  Copyright © 2016 Gopinath. All rights reserved.
//

#import "EventDetailViewController.h"

@implementation EventDetailViewController

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    
    [self updateViews];
}

-(void)viewDidDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}

-(void)updateViews{
    self.eventImageView.image = [UIImage imageNamed:@"Event-9"];
}

-(void)setEventDict:(NSMutableDictionary*)dict{
    self.eventImageView.image = [UIImage imageNamed:dict[@"imageName"]];
    self.eventName.text = dict[@"eventName"];
    self.eventLocation.text = dict[@"eventLocation"];
    self.priceInfo.text = dict[@"eventPrice"];
    
}

@end
