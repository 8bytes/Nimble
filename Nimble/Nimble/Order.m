//
//  Order.m
//  Nimble
//
//  Created by Adam Gammell on 31/01/2015.
//  Copyright (c) 2015 HubSpot. All rights reserved.
//

#import "Order.h"

@implementation Order

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"price": @"price",
              @"orderId": @"id"
             };
}

+ (id)orderFromJSON:(NSDictionary *)JSON{
    
    NSError *error;
    Order *order = [MTLJSONAdapter modelOfClass:[self class] fromJSONDictionary:JSON error:&error];
    if(error != nil){
        NSLog(@"Error parsing JSON : %@", error);
        return nil;
    }
    
    
//    int priceYA = [[JSON objectForKey:@"price"] intValue];
//    
//    Order *other = [Order orderFromJSON:[JSON objectForKey:@"order"]];
    
    
//    order.price = [[JSON objectForKey:@"order"] intValue];
    
    
    NSArray *orderDict = [JSON objectForKey:@"order"];
    NSDictionary *finalDict = [orderDict objectAtIndex:0];
    int finalPrice = [[finalDict objectForKey:@"price"] intValue];
    order.price = finalPrice;
    
    int orderId = [[finalDict objectForKey:@"id"] intValue];
    order.orderId = orderId;
    
    
//    NSLog(@"JSON: %d", [[finalDict objectForKey:@"order"] intValue]);
    NSLog(@"Price: %d", order.price);
    
    return order;
    
}

+ (NSValueTransformer *)stationJSONTransformer{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[Venue class]];
}


@end
