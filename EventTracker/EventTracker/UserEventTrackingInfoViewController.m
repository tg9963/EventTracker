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
    return 50;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    EventsCell  *cell = [cv dequeueReusableCellWithReuseIdentifier:[EventsCell cellIdentifier] forIndexPath:indexPath];
    cell.eventImage.image = [UIImage imageNamed:@"Event-6.png"];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    EventDetailViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"EventDetailViewController"];
    
    if ([vc respondsToSelector:@selector(setEventDict:)]) {
        [vc setEventDict:[NSMutableDictionary new]];
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(CGRectGetWidth(self.userTrackingCV.bounds),350-VGAP);
}





@end
