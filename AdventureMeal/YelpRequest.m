//
//  YelpRequest.m
//  AdventureMeal
//
//  Created by Kabir Gupta on 12/11/14.
//  Copyright (c) 2014 AdventureMeal. All rights reserved.
//

#import "YelpRequest.h"

#pragma mark - Constants
static int const METERS_IN_MILE            = 1610;
static NSString * const kAPIHost           = @"api.yelp.com";
static NSString * const kSearchPath        = @"/v2/search/";
static NSString * const kConsumerKey       = @"USShhRxL35aoinnZMfCQwg";
static NSString * const kConsumerSecret    = @"8wo1F96AHilU5CBy1Tf7l8tWwpk";
static NSString * const kToken             = @"nvuFacag1VV6B9HNs-p2Y1EaoU_yRYBA";
static NSString * const kTokenSecret       = @"CSeY30pmfUN2-pQYlp62czAhCu0";

#pragma mark - Class Extension
@interface YelpRequest ()

@property (nonatomic, strong) NSDictionary *yelpChoices;

@end

#pragma mark - Class Implementation
@implementation YelpRequest

#pragma mark - Life Cycle
-(id)init {
    self = [super init];
    
    if(self) {
        self.yelpChoices = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"newamerican", @"American",
                            @"italian", @"Italian",
                            @"mexican", @"Mexican",
                            @"chinese", @"Chinese",
                            @"indpak", @"Indian",
                            @"mediterranean", @"Mediterranean",
                            @"korean", @"Korean",
                            @"pizza", @"Pizza",
                            @"seafood", @"Seafood",
                            @"sushi", @"Sushi",
                            @"vegan", @"Vegan",
                            @"vegetarian", @"Vegetarian",
                            @"thai", @"Thai"
                            ,nil];
    }
    
    return self;
}

#pragma mark - Yelp method
- (void)queryForTerm:(NSString *)term location:(NSString *)location foodCategory:(NSString *)category radius:(int)radius {
    NSLog(@"Starting query");
    // Create request from given parameters
    NSDictionary *getParams = [NSDictionary dictionaryWithObjectsAndKeys:
                               term, @"term",
                               location, @"location",
                               self.yelpChoices[category], @"category_filter",
                               [NSString stringWithFormat:@"%d",(radius * METERS_IN_MILE)], @"radius_filter",
                               @"2", @"sort",
                               nil];
    NSURLRequest *request = [TDOAuth URLRequestForPath:kSearchPath
                                        GETParameters:getParams
                                        host:kAPIHost
                                        consumerKey:kConsumerKey
                                        consumerSecret:kConsumerSecret
                                        accessToken:kToken
                                        tokenSecret:kTokenSecret];
    
    // Consume request
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
              completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                  NSLog(@"Sent query");
                  
                  // Parse data into JSON
                  NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                  
                  // Get businesses and choose a random one
                  NSArray *businesses = [json valueForKey:@"businesses"];
                  int numBusinesses = (int)businesses.count;
                  NSDictionary *randomBusiness = businesses[(arc4random() % numBusinesses)];
                  
                  // Pass back to InitialViewController
                  [self.delegate getYelpRequest:self didChooseRestaurant:randomBusiness];
    }];
    [dataTask resume];
}

@end