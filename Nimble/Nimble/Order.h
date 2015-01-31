//
//  Order.h
//  Nimble
//
//  Created by Adam Gammell on 31/01/2015.
//  Copyright (c) 2015 HubSpot. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface Order : MTLModel <MTLJSONSerializing>

@property (nonatomic) int price;

+ (id)orderFromJSON:(NSDictionary *)JSON;

@end
