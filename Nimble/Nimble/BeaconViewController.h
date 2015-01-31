//
//  BeaconViewController.h
//  Nimble
//
//  Created by Adam Gammell on 31/01/2015.
//  Copyright (c) 2015 HubSpot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EstimoteSDK/ESTBeaconManager.h>

@interface BeaconViewController : UIViewController <ESTBeaconManagerDelegate>

@property (strong, nonatomic) ESTBeaconManager *beaconManager;
@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;

@end
