//
//  UserEventTrackingInfoViewController.m
//  EventTracker
//
//  Created by Gopinath on 10/2/16.
//  Copyright © 2016 Gopinath. All rights reserved.
//

#import "UserEventTrackingInfoViewController.h"
#import "EventsViewController.h"
#import "EventDetailViewController.h"
#import "AppDelegate.h"
#import "UserManager.h"

#define HGAP 20
#define VGAP 20

@interface UserEventTrackingInfoViewController()

@property(nonatomic,strong) NSMutableDictionary *userTrackingData;

@end


@implementation UserEventTrackingInfoViewController

-(void)viewDidLoad{
    UISwipeGestureRecognizer * swipeGesture =[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeHandler:)];
    swipeGesture.direction=  UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeGesture];
    _userTrackingData = [[NSMutableDictionary alloc] init];
    self.userTrackingCV.delegate = self;
    self.userTrackingCV.dataSource = self;
    [self fetchData];
}

-(void)fetchData{
    // update _userTrackingData
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"UserEventTracker" inManagedObjectContext:[EventHelper managedObjectContext]]];
    NSString *userId = [NSString stringWithFormat:@"%@",[[[UserManager sharedManager] getCurrentUser] userId]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId == %@",userId];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *userTrackingobjects = [[EventHelper managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    if (userTrackingobjects.count > 0) {
        NSArray *eventIds = [userTrackingobjects valueForKey:@"eventId"];
        fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:[NSEntityDescription entityForName:@"Events" inManagedObjectContext:[EventHelper managedObjectContext]]];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"eventId IN %@",eventIds];
        [fetchRequest setPredicate:predicate];
        NSArray *eventobjects = [[EventHelper managedObjectContext] executeFetchRequest:fetchRequest error:&error];
        
        if (eventobjects.count >0) {
            _eventData = [[NSMutableArray alloc] initWithArray:eventobjects];
        }else{
            _eventData = [[NSMutableArray alloc] init];
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}

-(void)swipeHandler:(UISwipeGestureRecognizer *)recognizer {
    if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        AppDelegate *appdelegateObj = [[UIApplication sharedApplication] delegate];
        if ([appdelegateObj respondsToSelector:@selector(resetUserTrackingView)]) {
            [appdelegateObj performSelector:@selector(resetUserTrackingView) withObject:nil];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [_eventData count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    EventsCell  *cell = [cv dequeueReusableCellWithReuseIdentifier:[EventsCell cellIdentifier] forIndexPath:indexPath];
    NSDictionary *currEventDict = _eventData[indexPath.row];
    cell.eventImage.image = [UIImage imageNamed:[currEventDict valueForKey:@"eventImage"]];
    cell.eventName.text = [currEventDict valueForKey:@"eventName"];
    cell.eventLocation.text =  [currEventDict valueForKey:@"eventLocation"];
    cell.eventPrice.text =  [currEventDict valueForKey:@"eventPrice"];
    cell.eventId =  [currEventDict valueForKey:@"eventId"];
    return cell;

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    EventDetailViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"EventDetailViewController"];
    NSMutableDictionary *currEventDict = _eventData[indexPath.row];
    if ([vc respondsToSelector:@selector(setEventDict:)]) {
        [vc setEventDict:currEventDict];
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(CGRectGetWidth(self.userTrackingCV.bounds),350-VGAP);
}

@end
