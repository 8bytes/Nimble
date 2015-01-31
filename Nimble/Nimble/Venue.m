//
//  Venue.m
//  Nimble
//
//  Created by Adam Gammell on 31/01/2015.
//  Copyright (c) 2015 HubSpot. All rights reserved.
//

#import "Venue.h"

@implementation Venue

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"name": @"name",
             @"venueId": @"id"
             };
}

+ (id)venueFromJSON:(NSDictionary *)JSON{
    
    NSError *error;
    Venue *venue = [MTLJSONAdapter modelOfClass:[self class] fromJSONDictionary:JSON error:&error];
    if(error != nil){
        NSLog(@"Error parsing JSON : %@", error);
        return nil;
    }
    
    NSLog(@"JSON: %@", JSON);
    return venue;
    
}

+ (NSValueTransformer *)stationJSONTransformer{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[Venue class]];
}

@end
