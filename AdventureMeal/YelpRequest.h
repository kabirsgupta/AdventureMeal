//
//  YelpRequest.h
//  AdventureMeal
//
//  Created by Kabir Gupta on 12/11/14.
//  Copyright (c) 2014 AdventureMeal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDOAuth.h"

@class YelpRequest;

@protocol YelpRequestDelegate <NSObject>
- (void)getYelpRequest:(YelpRequest *)yelpRequest didChooseRestaurant:(NSDictionary *)restaurant;
@end

@interface YelpRequest : NSObject

@property (nonatomic, strong) NSDictionary *chosenRestaurant;
@property (nonatomic, weak) id <YelpRequestDelegate> delegate;

- (void)queryForTerm:(NSString *)term location:(NSString *)location foodCategory:(NSString *)category radius:(int)radius;

@end