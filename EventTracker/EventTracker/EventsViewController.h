//
//  EventsViewController.h
//  EventTracker
//
//  Created by Gopinath on 10/2/16.
//  Copyright © 2016 Gopinath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventHelper.h"

@interface EventsCell : UICollectionViewCell
+(NSString*)cellIdentifier;
@property (weak, nonatomic) IBOutlet UIImageView *eventImage;
@property (weak, nonatomic) IBOutlet UILabel *eventName;
@property (weak, nonatomic) IBOutlet UILabel *eventLocation;
@property (weak, nonatomic) IBOutlet UILabel *eventPrice;
@property (weak, nonatomic) NSString *eventId;

@end

@interface EventsViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *layoutChangeButton;
@property (weak, nonatomic) IBOutlet UICollectionView *eventsCV;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@end


