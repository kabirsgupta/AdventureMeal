//
//  ADMInitialViewController.h
//  AdventureMeal
//
//  Created by Kabir Gupta on 9/25/14.
//  Copyright (c) 2014 AdventureMeal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADMFoodChoicesViewController.h"
#import "YelpRequest.h"
#import "ADMLocationViewController.h"

@interface ADMInitialViewController : UIViewController <ADMFoodChoicesViewControllerDelegate, YelpRequestDelegate>

@end