//
//  UserEventTrackingInfoViewController.h
//  EventTracker
//
//  Created by Gopinath on 10/2/16.
//  Copyright © 2016 Gopinath. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserEventTrackingInfoViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>


@property (weak, nonatomic) IBOutlet UICollectionView *userTrackingCV;


@end
