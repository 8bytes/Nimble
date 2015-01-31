//
//  Venue.h
//  Nimble
//
//  Created by Adam Gammell on 31/01/2015.
//  Copyright (c) 2015 HubSpot. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface Venue : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly) int venueId;
@property (nonatomic, copy, readonly) NSString *name;

+ (id)venueFromJSON:(NSDictionary *)JSON;

@end
