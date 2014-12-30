//
//  ADMLocationViewController.h
//  AdventureMeal
//
//  Created by Kabir Gupta on 12/11/14.
//  Copyright (c) 2014 AdventureMeal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <AddressBook/AddressBook.h>

@interface ADMLocationViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>

- (void)setDictionaryForRestaurant:(NSDictionary *)restaurant;

@end