//
//  ADMInitialViewController.m
//  AdventureMeal
//
//  Created by Kabir Gupta on 9/25/14.
//  Copyright (c) 2014 AdventureMeal. All rights reserved.
//

#import "ADMInitialViewController.h"

#pragma mark - Class Extension
@interface ADMInitialViewController ()

@property (nonatomic, weak) IBOutlet UILabel *distanceLabel;
@property (nonatomic, weak) IBOutlet UISlider *distanceSlider;
@property (nonatomic, weak) IBOutlet UIButton *foodButton;
@property (nonatomic, weak) IBOutlet UIButton *restaurantButton;

@property (nonatomic, copy) NSString *foodChoice;
@property (nonatomic, strong) NSDictionary *chosenRestaurant;

@end


#pragma mark - Class Implementation
@implementation ADMInitialViewController

#pragma mark - View life cycle
// View did load
- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - Buttons
// Food button pressed
- (IBAction)foodButtonPressed:(id)sender {
    ADMFoodChoicesViewController *fvc = [[ADMFoodChoicesViewController alloc] init];
    fvc.delegate = self;
    if(self.foodChoice) {
        fvc.foodChoice = self.foodChoice;
    }
    [self presentViewController:fvc animated:YES completion:nil];
}

// Start Adventure button pressed
- (IBAction)startButtonPressed:(id)sender {
    if(self.foodChoice) {
        YelpRequest *request = [[YelpRequest alloc] init];
        request.delegate = self;
        [request queryForTerm:@"restaurants"
                 location:@"Los+Angeles"
                 foodCategory:self.foodChoice
                 radius:(int)self.distanceSlider.value];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Please choose a restaurant category!"
                              message:nil
                              delegate:nil
                              cancelButtonTitle:@"Okay"
                              otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - Other actions
// Distance slider changed
- (IBAction)distanceSliderChanged:(id)sender {
    self.distanceLabel.text = [[NSString alloc] initWithFormat:@"Distance: %dmi", (int)self.distanceSlider.value];
}

#pragma mark - FoodChoicesViewControllerDelegate
// Pass back food category choice from ADMFoodChoicesViewController
- (void)selectChoiceViewController:(ADMFoodChoicesViewController *)controller didFinishChoosingFood:(NSString *)foodChoice {
    self.foodChoice = foodChoice;
    [self.foodButton setTitle:self.foodChoice forState:UIControlStateNormal];
    [self.foodButton sizeToFit];
    
    [self.restaurantButton setHidden:NO];
}

#pragma mark - YelpRequestDelegate
- (void)getYelpRequest:(YelpRequest *)yelpRequest didChooseRestaurant:(NSDictionary *)restaurant {
    self.chosenRestaurant = restaurant;
    NSLog(@"Got restaurant: %@", [self.chosenRestaurant valueForKey:@"name"]);
    
    ADMLocationViewController *lvc = [[ADMLocationViewController alloc] init];
    [lvc setDictionaryForRestaurant:self.chosenRestaurant];
    
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:lvc];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:nvc animated:YES completion:nil];
    });
}

@end