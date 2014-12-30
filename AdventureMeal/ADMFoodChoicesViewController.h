//
//  ADMFoodChoicesViewController.h
//  AdventureMeal
//
//  Created by Kabir Gupta on 9/25/14.
//  Copyright (c) 2014 AdventureMeal. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ADMFoodChoicesViewController;

#pragma mark - Delegate protocol
@protocol ADMFoodChoicesViewControllerDelegate <NSObject>
- (void)selectChoiceViewController:(ADMFoodChoicesViewController *)controller didFinishChoosingFood:(NSString *)foodChoice;
@end


#pragma mark - Class interface
@interface ADMFoodChoicesViewController : UITableViewController

@property (nonatomic, weak) id <ADMFoodChoicesViewControllerDelegate> delegate;
@property (nonatomic, copy) NSString *foodChoice;

@end