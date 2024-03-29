//
//  APIClient.h
//  Nimble
//
//  Created by Adam Gammell on 31/01/2015.
//  Copyright (c) 2015 HubSpot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Overcoat/Overcoat.h>
#import "Venue.h"
#import "Order.h"

@interface APIClient : OVCClient

+ (APIClient *)sharedInstance;

- (void)getVenueForBeaconMajorId:(NSNumber *)majorId completion:(void (^)(Venue *place, NSError *error))block;
- (void)getOrderDetailsForVenue:(int)venueId completion:(void (^)(Order *order, NSError *error))block;
- (void)pay:(int)ammount onOrder:(Order *)oldOrder completion:(void (^)(Order *order, NSError *error))block;

@end
