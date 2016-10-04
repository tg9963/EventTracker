//
//  EventDetailViewController.m
//  EventTracker
//
//  Created by Gopinath on 10/2/16.
//  Copyright © 2016 Gopinath. All rights reserved.
//

#import "EventDetailViewController.h"
#import "UserManager.h"

@implementation EventDetailViewController

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    [self updateUI];
    [self checkIfuserIsTracking];
}

-(void)checkIfuserIsTracking{
    if ([[UserManager sharedManager] isUserTrackingEvent:[_eventDict valueForKey:@"eventId"]]) {
        [self.trackButton setBackgroundColor:[UIColor blackColor]];
        [self.trackButton setTitle:@"You are tracking this event" forState:UIControlStateNormal |UIControlStateHighlighted];
        [self.trackButton setImage:[UIImage imageNamed:@"track-tick"] forState:UIControlStateNormal];
        [self.trackButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
        [self.trackButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        self.trackButton.userInteractionEnabled = NO;
    }else{
        [self.trackButton setBackgroundColor:[UIColor redColor]];
        [self.trackButton setImage:[UIImage new] forState:UIControlStateNormal];
        [self.trackButton setTitle:@"Start Tracking" forState:UIControlStateNormal];
        self.trackButton.userInteractionEnabled = YES;
    }
}

- (IBAction)trackingButtonClicked:(id)sender {
    [[UserManager sharedManager] startTrackingEvent:[_eventDict valueForKey:@"eventId"]];
    [self checkIfuserIsTracking];
}

-(void)viewDidDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}

-(void)updateUI{
    self.eventImageView.image = [UIImage imageNamed:[_eventDict valueForKey:@"eventImage"]];
    self.eventName.text = [_eventDict valueForKey:@"eventName"];
    self.eventLocation.text = [_eventDict valueForKey:@"eventLocation"];
    self.priceInfo.text = [_eventDict valueForKey:@"eventPrice"];
}

-(void)setEventDict:(NSMutableDictionary*)dict{
    _eventDict = dict;
}

@end
