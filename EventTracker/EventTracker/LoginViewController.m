//
//  LoginViewController.m
//  EventTracker
//
//  Created by Gopinath on 10/2/16.
//  Copyright © 2016 Gopinath. All rights reserved.
//

#import "LoginViewController.h"
#import "EventsViewController.h"
#import "UserManager.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    
    NSUserDefaults *stdUserDefaults = [NSUserDefaults standardUserDefaults];
    if ([stdUserDefaults objectForKey:@"events_added"] == nil) {
        NSDictionary *events = [self addEvents];
        NSArray *eventsArray = events[@"Events"];
        for(NSDictionary *eventDict in eventsArray){
            [self addToDB:eventDict];
        }
        [stdUserDefaults setObject:@"1" forKey:@"events_added"];
        [stdUserDefaults synchronize];
    }
    self.userName.delegate = self;
}

-(void)addToDB:(NSDictionary*)eventDict{
    NSManagedObjectContext *context = [EventHelper managedObjectContext];
    NSManagedObject *newEvent = [NSEntityDescription insertNewObjectForEntityForName:@"Events" inManagedObjectContext:context];
    [newEvent setValue:eventDict[@"eventImage"] forKey:@"eventImage"];
    [newEvent setValue:eventDict[@"eventName"] forKey:@"eventName"];
    [newEvent setValue:eventDict[@"eventLocation"] forKey:@"eventLocation"];
    [newEvent setValue:eventDict[@"eventPrice"] forKey:@"eventPrice"];
    [newEvent setValue:[NSString stringWithFormat:@"%@",[newEvent objectID]] forKey:@"eventId"];
    
    NSError *error = nil;
    if (![context save:&error]) {
//        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }else{
//        NSLog(@"Data saved for event id: %@",eventDict[@"eventId"]);
    }
    
}

-(NSDictionary*)addEvents{
    NSDictionary *sampleData = @{
                                        @"Events": @[
                                                @{
                                                    @"eventImage": @"Event-1",
                                                    @"eventName": @"Metallica Concert",
                                                    @"eventLocation": @"Palace Grounds",
                                                    @"eventPrice": @"Paid Entry",
                                                    @"eventId": @"1",
                                                    },
                                                @{
                                                    @"eventImage": @"Event-2",
                                                    @"eventName": @"Saree Exhibition",
                                                    @"eventLocation": @"Malleswaram Grounds",
                                                    @"eventPrice": @"Free Entry",
                                                    @"eventId": @"2",
                                                    },
                                                @{
                                                    @"eventImage": @"Event-3",
                                                    @"eventName": @"Wine tasting",
                                                    @"eventLocation": @"Links Brewery",
                                                    @"eventPrice": @"Paid Entry",
                                                    @"eventId": @"3",
                                                    },
                                                @{
                                                    @"eventImage": @"Event-4",
                                                    @"eventName": @"Startups Meet",
                                                    @"eventLocation": @"Kanteerava Indoor Stadium",
                                                    @"eventPrice": @"Paid Entry",
                                                    @"eventId": @"4",
                                                    },
                                                @{
                                                    @"eventImage": @"Event-5",
                                                    @"eventName": @"Summer Noon Party",
                                                    @"eventLocation": @"Kumara Park",
                                                    @"eventPrice": @"Paid Entry",
                                                    @"eventId": @"5",
                                                    },
                                                @{
                                                    @"eventImage": @"Event-6",
                                                    @"eventName": @"Rock and Roll nights",
                                                    @"eventLocation": @"Sarjapur Road",
                                                    @"eventPrice": @"Paid Entry",
                                                    @"eventId": @"6",
                                                    },
                                                @{
                                                    @"eventImage": @"Event-7",
                                                    @"eventName": @"Barbecue Fridays",
                                                    @"eventLocation": @"Whitefield",
                                                    @"eventPrice": @"Paid Entry",
                                                    @"eventId": @"7",
                                                    },
                                                @{
                                                    @"eventImage": @"Event-8",
                                                    @"eventName": @"Summer workshop",
                                                    @"eventLocation": @"Indiranagar",
                                                    @"eventPrice": @"Free Entry",
                                                    @"eventId": @"8",
                                                    },
                                                @{
                                                    @"eventImage": @"Event-9",
                                                    @"eventName": @"Impressions & Expressions",
                                                    @"eventLocation": @"MG Road",
                                                    @"eventPrice": @"Free Entry",
                                                    @"eventId": @"9",
                                                    },
                                                @{
                                                    @"eventImage": @"Event-10",
                                                    @"eventName": @"Italian carnival",
                                                    @"eventLocation": @"Electronic City",
                                                    @"eventPrice": @"Free Entry",
                                                    @"eventId": @"10",
                                                    },
                                                
                                                ]
                                        };
    return sampleData;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(void)addNewUser:(NSString*)userName{
    Users *activeUser = [[UserManager sharedManager] getUserWithName:userName];
    [[UserManager sharedManager] setCurrentUser:activeUser];
}


- (IBAction)submitClicked:(id)sender {
    if([self.userName.text isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                        message:@"Please enter your name."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }else{
        [self addNewUser:self.userName.text];
        NSString * storyboardName = @"Main";
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
        EventsViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"EventsViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self.view endEditing:YES];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}



@end
