//
//  ADMLocationViewController.m
//  AdventureMeal
//
//  Created by Kabir Gupta on 12/11/14.
//  Copyright (c) 2014 AdventureMeal. All rights reserved.
//

#import "ADMLocationViewController.h"

#pragma mark - Class Extension
@interface ADMLocationViewController ()

@property (nonatomic, strong) NSDictionary *chosenRestaurant;
@property (nonatomic, assign) float restaurantLatitude;
@property (nonatomic, assign) float restaurantLongitude;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign) CLLocationCoordinate2D currentLocation;
@property (nonatomic, assign) CLLocationDistance distance;

@property (nonatomic, weak) IBOutlet MKMapView *mapKitView;
@property (nonatomic, strong) MKMapItem *userMapItem;
@property (nonatomic, strong) NSArray *mapItems;

@end


#pragma mark - Class Implementation
@implementation ADMLocationViewController

#pragma mark - View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Restaurant Found";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelRestaurantChoice:)];
    
    // User's location
    self.currentLocation = CLLocationCoordinate2DMake(34.0268187, -118.2810496);
    NSDictionary *userDictionary = @{
                                     (NSString *)kABPersonAddressCityKey: @"Los Angeles",
                                     (NSString *)kABPersonAddressStateKey: @"CA",
                                     (NSString *)kABPersonAddressZIPKey: @"90007",
                                     (NSString *)kABPersonAddressCountryKey: @"USA"
                                     };
    MKPlacemark *userPlacemark = [[MKPlacemark alloc] initWithCoordinate:self.currentLocation addressDictionary:userDictionary];
    self.userMapItem = [[MKMapItem alloc] initWithPlacemark:userPlacemark];
    
    
    // Get location of restaurant
    NSDictionary *restaurantLocation = [self.chosenRestaurant objectForKey:@"location"];
    NSDictionary *restaurantCoordinate = [restaurantLocation objectForKey:@"coordinate"];
    NSString *restaurantLatitude = [restaurantCoordinate valueForKey:@"latitude"];
    NSString *restaurantLongitude = [restaurantCoordinate valueForKey:@"longitude"];
    self.restaurantLatitude = [restaurantLatitude floatValue];
    self.restaurantLongitude = [restaurantLongitude floatValue];
    CLLocationCoordinate2D restaurantLocationCoordinate = CLLocationCoordinate2DMake(self.restaurantLatitude, self.restaurantLongitude);
    NSDictionary *restaurantAddress = @{
                                        (NSString *)kABPersonAddressCityKey: [restaurantLocation valueForKey:@"city"],
                                        (NSString *)kABPersonAddressCountryCodeKey: [restaurantLocation valueForKey:@"country_code"],
                                        (NSString *)kABPersonAddressZIPKey: [restaurantLocation valueForKey:@"postal_code"],
                                        (NSString *)kABPersonAddressStateKey: [restaurantLocation valueForKey:@"state_code"]
                                        };
    MKPlacemark *restaurantPlacemark = [[MKPlacemark alloc] initWithCoordinate:restaurantLocationCoordinate addressDictionary:restaurantAddress];
    MKMapItem *restaurantMapItem = [[MKMapItem alloc] initWithPlacemark:restaurantPlacemark];
    
    // Get distance
    CLLocation *userLocation = [[CLLocation alloc] initWithLatitude:34.0268187 longitude:-118.2810496];
    CLLocation *endLocation = [[CLLocation alloc] initWithLatitude:self.restaurantLatitude longitude:self.restaurantLongitude];
    self.distance = [endLocation distanceFromLocation:userLocation];
    
    // Initialize MapKit View
    self.mapKitView.showsUserLocation = YES;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.currentLocation, self.distance * 2, self.distance * 2);
    [self.mapKitView setRegion:region animated:YES];
    [self.mapKitView setDelegate:self];
    
    // Show marker at destination
    MKPointAnnotation *endPoint = [[MKPointAnnotation alloc] init];
    endPoint.coordinate = restaurantLocationCoordinate;
    endPoint.title = @"Destination: ???";
    [self.mapKitView addAnnotation:endPoint];
    
    self.mapItems = @[self.userMapItem, restaurantMapItem];
    
    // Get Directions
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    [request setSource:self.userMapItem];
    [request setDestination:restaurantMapItem];
    request.requestsAlternateRoutes = NO;
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    [directions
     calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
         if(error) {
             NSLog(@"Error: %@", [error localizedDescription]);
         } else {
             [self showRoute:response];
         }
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    self.locationManager = [[CLLocationManager alloc] init];
//    self.locationManager.delegate = self;
//    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    
//    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
//        [self.locationManager requestAlwaysAuthorization];
//        [self.locationManager requestWhenInUseAuthorization];
//    }
    
    [self.locationManager startUpdatingLocation];
    NSLog(@"Starting location manager");
}

#pragma mark - Instance methods
- (void)setDictionaryForRestaurant:(NSDictionary *)restaurant {
    self.chosenRestaurant = restaurant;
}

- (void)cancelRestaurantChoice:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Button pressed events
- (IBAction)startButtonPressed:(id)sender {
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.currentLocation, self.distance * 2, self.distance * 2);
    NSDictionary *options = @{
                              MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
                              MKLaunchOptionsShowsTrafficKey: @YES,
                              MKLaunchOptionsMapCenterKey: [NSValue valueWithMKCoordinate:self.currentLocation],
                              MKLaunchOptionsMapSpanKey: [NSValue valueWithMKCoordinateSpan:region.span]
                              };
    [MKMapItem openMapsWithItems:self.mapItems launchOptions:options];
}

#pragma mark - Map Kit methods
-(void)showRoute:(MKDirectionsResponse *)response {
    for(MKRoute *route in response.routes) {
        [self.mapKitView addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
        
        for(MKRouteStep *step in route.steps) {
            NSLog(@"%@", step.instructions);
        }
    }
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay {
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.strokeColor = [UIColor blueColor];
    renderer.lineWidth = 5.0;
    return renderer;
}

#pragma mark - Location Manager Delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    NSLog(@"Updated location");
//    self.currentLocation = [locations lastObject];
    [self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSString *errorType = (error.code == kCLErrorDenied) ? @"Access Denied" : @"Unknown Error";
    NSLog(@"Error: %@", [error localizedDescription]);
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Error getting Location"
                          message:errorType
                          delegate:nil
                          cancelButtonTitle:@"Okay"
                          otherButtonTitles:nil];
    [alert show];
}

@end