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


@property(nonatomic, strong) UIImageView *movingCell;
@property(nonatomic,strong) NSMutableDictionary *userTrackingData;
@property(nonatomic,strong) NSIndexPath *startCellIndex;
@property(nonatomic,strong) NSIndexPath *endCellIndex;
@end


@implementation UserEventTrackingInfoViewController

-(void)viewDidLoad{
    UISwipeGestureRecognizer * swipeGesture =[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeHandler:)];
    swipeGesture.direction=  UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeGesture];
    _userTrackingData = [[NSMutableDictionary alloc] init];
    self.userTrackingCV.delegate = self;
    self.userTrackingCV.dataSource = self;
    [self updateData];
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.delegate = self;
    lpgr.delaysTouchesBegan = YES;
    [self.userTrackingCV addGestureRecognizer:lpgr];
}

-(NSArray*)fetchData{
    // update _userTrackingData
    NSError *error = nil;
    NSArray *userTrackingobjects = [self fetchUserEvents];
    
    if (userTrackingobjects.count > 0) {
        NSArray *eventIds = [userTrackingobjects valueForKey:@"eventId"];
         NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:[NSEntityDescription entityForName:@"Events" inManagedObjectContext:[EventHelper managedObjectContext]]];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"eventId IN %@",eventIds];
        [fetchRequest setPredicate:predicate];
        NSArray *eventobjects = [[EventHelper managedObjectContext] executeFetchRequest:fetchRequest error:&error];
        
        return eventobjects;
    }
    return nil;
}

-(NSArray*)fetchUserEvents{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"UserEventTracker" inManagedObjectContext:[EventHelper managedObjectContext]]];
    NSString *userId = [NSString stringWithFormat:@"%@",[[[UserManager sharedManager] getCurrentUser] userId]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId == %@",userId];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *userTrackingobjects = [[EventHelper managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    return userTrackingobjects;
}

-(void)updateData{
    NSArray *eventObjects = [self fetchData];
    
    if (eventObjects.count >0) {
        _eventData = [[NSMutableArray alloc] initWithArray:eventObjects];
    }else{
        _eventData = [[NSMutableArray alloc] init];
    }
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)longRecognizer {
    
    CGPoint locationPoint = [longRecognizer locationInView:self.userTrackingCV];
    
    if (longRecognizer.state == UIGestureRecognizerStateBegan) {
        
        _startCellIndex = [self.userTrackingCV indexPathForItemAtPoint:locationPoint];
        UICollectionViewCell *cell = [self.userTrackingCV cellForItemAtIndexPath:_startCellIndex];
        
        UIGraphicsBeginImageContext(cell.bounds.size);
        [cell.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *cellImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.movingCell = [[UIImageView alloc] initWithImage:cellImage];
        [self.movingCell setCenter:locationPoint];
        [self.movingCell setAlpha:1];
        [self.userTrackingCV addSubview:self.movingCell];
    }else if (longRecognizer.state == UIGestureRecognizerStateChanged) {
        [self.movingCell setCenter:locationPoint];
    }else if (longRecognizer.state == UIGestureRecognizerStateEnded) {
        [self.movingCell removeFromSuperview];
        
        _endCellIndex = [self.userTrackingCV indexPathForItemAtPoint:locationPoint];
        
        if (_endCellIndex.row != _startCellIndex.row) {
            NSDictionary *currDict = [_eventData objectAtIndex:_startCellIndex.row];
            [_eventData removeObjectAtIndex:_startCellIndex.row];
            [_eventData insertObject:currDict atIndex:_endCellIndex.row];
            [self.userTrackingCV reloadData];
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

-(void)removeEntryFromUserTrackingEntity:(NSDictionary*)currEventDict{
    
    NSArray *eventobjects = [self fetchUserEvents];
    
    if (eventobjects.count >0) {
        for (NSManagedObject *currObj in eventobjects) {
            if ([[currObj valueForKey:@"eventId"] isEqualToString:[currEventDict valueForKey:@"eventId"]]) {
                [[EventHelper managedObjectContext] deleteObject:currObj];
                NSError *error = nil;
                if (![[EventHelper managedObjectContext] save:&error]) {
//                    NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
                }else{
//                    NSLog(@"Event removed: %@",currObj);
                }
            }
        }
    }
}

- (IBAction)stopTrackingClicked:(UIButton*)sender {
    NSIndexPath *currIndexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    [self.userTrackingCV performBatchUpdates:^{
        [self removeEntryFromUserTrackingEntity:_eventData[currIndexPath.row]];
        [_eventData removeObjectAtIndex:currIndexPath.row];
        [self.userTrackingCV deleteItemsAtIndexPaths:@[currIndexPath]];
    } completion:^(BOOL finished){
        [self.userTrackingCV reloadData];
    }];
    
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
    cell.stopTrackingButton.tag = indexPath.row;
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
    return CGSizeMake(CGRectGetWidth(self.userTrackingCV.bounds),400-VGAP);
}

@end
