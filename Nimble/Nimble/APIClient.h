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

@interface APIClient : OVCClient

+ (APIClient *)sharedInstance;

- (void)getVenueForBeaconMajorId:(NSNumber *)majorId completion:(void (^)(Venue *place, NSError *error))block;

@end
