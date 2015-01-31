//
//  BeaconViewController.h
//  Nimble
//
//  Created by Adam Gammell on 31/01/2015.
//  Copyright (c) 2015 HubSpot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EstimoteSDK/ESTBeaconManager.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <EstimoteSDK/ESTBeacon.h>

typedef enum : int
{
    ESTScanTypeBluetooth,
    ESTScanTypeBeacon
    
} ESTScanType;

@interface BeaconViewController : UIViewController <ESTBeaconManagerDelegate>


@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;
@property (strong, nonatomic) IBOutlet UILabel *beaconDetails;
@property (strong, nonatomic) IBOutlet UILabel *beaconName;
@property (strong, nonatomic) IBOutlet UIImageView *animationOne;
@property (strong, nonatomic) IBOutlet UIImageView *animationTwo;
@property (strong, nonatomic) IBOutlet UIImageView *animationThree;
@property (strong, nonatomic) IBOutlet UIImageView *animationFour;
@property (strong, nonatomic) IBOutlet UIImageView *animationFive;
@property (strong, nonatomic) IBOutlet UILabel *searchingLabel;

@end
