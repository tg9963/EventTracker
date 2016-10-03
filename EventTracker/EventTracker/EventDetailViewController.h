//
//  EventDetailViewController.h
//  EventTracker
//
//  Created by Gopinath on 10/2/16.
//  Copyright © 2016 Gopinath. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventDetailViewController : UIViewController


@property (weak, nonatomic) IBOutlet UIImageView *eventImageView;

@property (weak, nonatomic) IBOutlet UILabel *eventName;
@property (weak, nonatomic) IBOutlet UILabel *eventLocation;
@property (weak, nonatomic) IBOutlet UILabel *priceInfo;
@property (weak, nonatomic) IBOutlet UIButton *trackButton;



-(void)setEventDict:(NSMutableDictionary*)dict;

@end
