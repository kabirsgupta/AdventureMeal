//
//  ADMFoodChoicesViewController.m
//  AdventureMeal
//
//  Created by Kabir Gupta on 9/25/14.
//  Copyright (c) 2014 AdventureMeal. All rights reserved.
//

#import "ADMFoodChoicesViewController.h"

#pragma mark - Class Extension
@interface ADMFoodChoicesViewController ()

@property (nonatomic, strong) NSArray *foodCategories;
@property (nonatomic, strong) NSIndexPath *lastIndexPath;
@property (nonatomic) NSInteger selectedRow;

@end


#pragma mark - Class Implementation
@implementation ADMFoodChoicesViewController

#pragma mark - Controller life cycle
// Regular init
- (instancetype)init {
    self = [super init];
    if(self) {
        self.foodCategories = @[@"", @"American", @"Italian", @"Mexican", @"Chinese", @"Indian", @"Mediterranean", @"Korean", @"Pizza", @"Seafood", @"Sushi", @"Vegan", @"Vegetarian", @"Thai"];
        self.selectedRow = 0;
    } //end if self
    
    return self;
}

// Init with style
- (instancetype)initWithStyle:(UITableViewStyle)style {
    return [super initWithStyle:style];
}

#pragma mark - View life cycle
// View did load
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Table view attributes
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    self.tableView.separatorColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor colorWithRed:0.0705 green:0.8 blue:1.0 alpha:1.0];
    
    // Get previously selected choice if applicable
    if(self.foodChoice) {
        self.selectedRow = [self.foodCategories indexOfObjectIdenticalTo:self.foodChoice];
    } // end if self.foodChoice was passed from ADMInitialViewController
}

#pragma mark - Table view data source
// Cell for row at index path
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Get a new or recycled cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    // Configure cell background and colors
    cell.backgroundColor = [UIColor colorWithRed:0.0705 green:0.8 blue:1.0 alpha:1.0];
    cell.tintColor = [UIColor whiteColor]; //Checkmark color
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Set text of cell
    cell.textLabel.text = self.foodCategories[indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    // Give checkmark to previously selected choice if it exists
    if(self.selectedRow != 0 && indexPath.row == self.selectedRow) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    return cell;
}

// Number of sections in table view
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Number of rows in section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.foodCategories count];
}

#pragma mark - Table view delegate
// Did select row at index path
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Don't let them select empty one at top
    if(indexPath.row == 0) {
        return;
    }
    
    // Take checkmark off old choice
    if(self.lastIndexPath) {
        [tableView cellForRowAtIndexPath:self.lastIndexPath].accessoryType = UITableViewCellAccessoryNone;
    }
    
    // Pass back chosen food category
    NSString *itemToPassBack = self.foodCategories[indexPath.row];
    [self.delegate selectChoiceViewController:self didFinishChoosingFood:itemToPassBack];
    
    // Give selected row a checkmark
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    
    // Update index path to new row
    self.lastIndexPath = indexPath;
    
    // Dismiss view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end