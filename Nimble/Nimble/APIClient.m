//
//  APIClient.m
//  Nimble
//
//  Created by Adam Gammell on 31/01/2015.
//  Copyright (c) 2015 HubSpot. All rights reserved.
//

#import "APIClient.h"

#import "Venue.h"

#define BYBaseURL @"http://getnimbleapp.com/"
//#define BYBaseURL @"http://172.16.24.153:3000/"
static APIClient *sharedInstance;

@implementation APIClient

+ (APIClient *)sharedInstance{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[[self class] alloc] init];
    });

    sharedInstance.requestSerializer = [AFJSONRequestSerializer serializer];
    sharedInstance.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    return sharedInstance;
}

- (id)init{
    
    return [super initWithBaseURL:[NSURL URLWithString:BYBaseURL]];
}


- (void)getVenueForBeaconMajorId:(NSNumber *)majorId completion:(void (^)(Venue *place, NSError *error))block{
    
    NSDictionary *params = @{
        @"beacon_id": @"B9407F30-F5F8-466E-AFF9-25556B57FE6D",
        @"beacon_major": [majorId stringValue]
    };
    
    
    
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    
//    [manager PUT:[NSString stringWithFormat:@"%@user/2", BYBaseURL] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//       
//        NSLog(@"Success: %@", responseObject);
//        NSError *error = nil;
//        
//        
//        
//        block(responseObject, error);
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//       
//        NSLog(@"Error occurred creating reminder: %@", error);
//        block(nil, error);
//        
//    }];

    
    
    [self PUT:@"user/2" parameters:params resultClass:Venue.class resultKeyPath:@"restaurant" completion:^(AFHTTPRequestOperation *operation, id responseObject, NSError *error) {
       
        NSLog(@"connected: %@", responseObject);
        
        Venue *current = (Venue *)responseObject;
        
        block(current, error);
        
        
//        block(responseObject, error);
    }];

}

@end
