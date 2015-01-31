//
//  BeaconViewController.m
//  Nimble
//
//  Created by Adam Gammell on 31/01/2015.
//  Copyright (c) 2015 HubSpot. All rights reserved.
//

#import "BeaconViewController.h"


@interface BeaconViewController ()

@end

@implementation BeaconViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    // create manager instance
    self.beaconManager = [[ESTBeaconManager alloc] init];
    self.beaconManager.delegate = self;
    
    // create sample region object (you can additionally pass major / minor values)
    NSUUID *beaconUUID = [[NSUUID alloc]initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"];
    ESTBeaconRegion* region = [[ESTBeaconRegion alloc] initWithProximityUUID:beaconUUID identifier:@"coffeeShop"];
    
    // start looking for Estimote beacons in region
    // when beacon ranged beaconManager:didRangeBeacons:inRegion: invoked
    [self.beaconManager startRangingBeaconsInRegion:region];
    
    
}

-(void)beaconManager:(ESTBeaconManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(ESTBeaconRegion *)region
{
    if([beacons count] > 0)
    {
        // beacon array is sorted based on distance
        // closest beacon is the first one
        ESTBeacon* closestBeacon = [beacons objectAtIndex:0];
        
        // calculate and set new y position
        switch (closestBeacon.proximity)
        {
            case CLProximityUnknown:
                self.distanceLabel.text = @"Unknown region";
                break;
            case CLProximityImmediate:
                self.distanceLabel.text = @"Immediate region";
                break;
            case CLProximityNear:
                self.distanceLabel.text = @"Near region";
                break;
            case CLProximityFar:
                self.distanceLabel.text = @"Far region";
                break;
                
            default:
                break;
        }
    }
}



@end
