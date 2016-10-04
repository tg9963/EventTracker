//
//  EventsViewController.m
//  EventTracker
//
//  Created by Gopinath on 10/2/16.
//  Copyright © 2016 Gopinath. All rights reserved.
//

#import "EventsViewController.h"
#import "EventDetailViewController.h"

#define HGAP 20
#define VGAP 20

@interface EventsViewController(){
    BOOL isGrid;
}

@property(nonatomic, strong)NSMutableArray *eventData;

@end

@implementation EventsViewController

-(void)viewDidLoad{
    
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    [flow setMinimumInteritemSpacing:HGAP];
    [flow setMinimumLineSpacing:VGAP];
    [self.eventsCV setCollectionViewLayout:flow animated:YES];
    self.eventsCV.scrollsToTop = NO;
    self.eventsCV.delegate = self;
    self.eventsCV.dataSource = self;
    isGrid = false;
    [self.layoutChangeButton setImage:[UIImage imageNamed:@"grid-view"]];
    [self fetchData];
}

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

-(void)fetchData{
    NSManagedObjectContext *managedObjectContext = [EventHelper managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Events"];
    _eventData = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}

- (IBAction)changeLayout:(id)sender {
    if (isGrid==true) {
        isGrid = false;
        [self.layoutChangeButton setImage:[UIImage imageNamed:@"grid-view"]];
    }else{
        isGrid = true;
        [self.layoutChangeButton setImage:[UIImage imageNamed:@"list-view"]];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
         [self.eventsCV reloadData];
    });
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.eventsCV reloadData];
    });
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
    [vc setEventDict:_eventData[indexPath.row]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (isGrid) {
        return CGSizeMake(242-HGAP,350-VGAP);
    }else{
        return CGSizeMake(CGRectGetWidth(self.eventsCV.bounds),350-VGAP);
    }
}

@end

@implementation EventsCell
+(NSString*)cellIdentifier{
    return @"eventCell";
}
//- (IBAction)stopTrackingClicked:(id)sender {
//    
//}



@end