//
//  BeaconViewController.m
//  Nimble
//
//  Created by Adam Gammell on 31/01/2015.
//  Copyright (c) 2015 HubSpot. All rights reserved.
//

#import "BeaconViewController.h"
#import <POP/POP.h>
#import <NSTimer-Blocks/NSTimer+Blocks.h>
#import "Venue.h"
#import "VenueViewController.h"


#define ESTIMOTE_PROXIMITY_UUID             [[NSUUID alloc] initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"]


@interface BeaconViewController ()

@property (nonatomic, copy)     void (^completion)(ESTBeacon *);
@property (nonatomic, assign)   ESTScanType scanType;

@property (nonatomic, strong) ESTBeaconManager *beaconManager;
@property (nonatomic, strong) ESTBeaconRegion *region;
@property (nonatomic, strong) NSArray *beaconsArray;
@property (nonatomic, strong) ESTBeacon *currentBeacon;

@property BOOL beaconFound;

@end

@implementation BeaconViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.beaconManager = [[ESTBeaconManager alloc] init];
    self.beaconManager.delegate = self;
    self.beaconManager.returnAllRangedBeaconsAtOnce = YES;
    
    /*
     * Creates sample region object (you can additionaly pass major / minor values).
     *
     * We specify it using only the ESTIMOTE_PROXIMITY_UUID because we want to discover all
     * hardware beacons with Estimote's proximty UUID.
     */
    self.region = [[ESTBeaconRegion alloc] initWithProximityUUID:ESTIMOTE_PROXIMITY_UUID
                                                      identifier:@"EstimoteSampleRegion"];
    
    /*
     * Starts looking for Estimote beacons.
     * All callbacks will be delivered to beaconManager delegate.
     */
    if (self.scanType == ESTScanTypeBeacon)
    {
        [self startRangingBeacons];
    }
    else
    {
        [self.beaconManager startEstimoteBeaconsDiscoveryForRegion:self.region];
    }
    
    
    self.view.backgroundColor = kViewBackgroundColor;
    
    self.animationOne.transform = CGAffineTransformMakeScale(0.001, 0.001);
    self.animationTwo.transform = CGAffineTransformMakeScale(0.001, 0.001);
    self.animationThree.transform = CGAffineTransformMakeScale(0.001, 0.001);
    self.animationFour.transform = CGAffineTransformMakeScale(0.001, 0.001);
    self.animationFive.transform = CGAffineTransformMakeScale(0.001, 0.001);
    
    UITapGestureRecognizer *resetTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reset)];
    [resetTap setNumberOfTapsRequired:3];
    [self.view addGestureRecognizer:resetTap];
    
    self.searchingLabel.textColor = kGreenTintColor;
    
}

- (void)beaconManager:(ESTBeaconManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (self.scanType == ESTScanTypeBeacon)
    {
        [self startRangingBeacons];
    }
}

-(void)startRangingBeacons
{
    if ([ESTBeaconManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)
    {
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
            /*
             * No need to explicitly request permission in iOS < 8, will happen automatically when starting ranging.
             */
            [self.beaconManager startRangingBeaconsInRegion:self.region];
        } else {
            /*
             * Request permission to use Location Services. (new in iOS 8)
             * We ask for "always" authorization so that the Notification Demo can benefit as well.
             * Also requires NSLocationAlwaysUsageDescription in Info.plist file.
             *
             * For more details about the new Location Services authorization model refer to:
             * https://community.estimote.com/hc/en-us/articles/203393036-Estimote-SDK-and-iOS-8-Location-Services
             */
            [self.beaconManager requestAlwaysAuthorization];
        }
    }
    else if([ESTBeaconManager authorizationStatus] == kCLAuthorizationStatusAuthorized)
    {
        [self.beaconManager startRangingBeaconsInRegion:self.region];
    }
    else if([ESTBeaconManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Access Denied"
                                                        message:@"You have denied access to location services. Change this in app settings."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        
        [alert show];
    }
    else if([ESTBeaconManager authorizationStatus] == kCLAuthorizationStatusRestricted)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Not Available"
                                                        message:@"You have no access to location services."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        
        [alert show];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    /*
     *Stops ranging after exiting the view.
     */
    [self.beaconManager stopRangingBeaconsInRegion:self.region];
    [self.beaconManager stopEstimoteBeaconDiscovery];
}

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ESTBeaconManager delegate

- (void)beaconManager:(ESTBeaconManager *)manager rangingBeaconsDidFailForRegion:(ESTBeaconRegion *)region withError:(NSError *)error
{
    UIAlertView* errorView = [[UIAlertView alloc] initWithTitle:@"Ranging error"
                                                        message:error.localizedDescription
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    
    [errorView show];
}

- (void)beaconManager:(ESTBeaconManager *)manager monitoringDidFailForRegion:(ESTBeaconRegion *)region withError:(NSError *)error
{
    UIAlertView* errorView = [[UIAlertView alloc] initWithTitle:@"Monitoring error"
                                                        message:error.localizedDescription
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    
    [errorView show];
}

- (void)beaconManager:(ESTBeaconManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(ESTBeaconRegion *)region
{
    self.beaconsArray = beacons;
    
    NSLog(@"Ranged beacons");

}

- (void)beaconManager:(ESTBeaconManager *)manager didDiscoverBeacons:(NSArray *)beacons inRegion:(ESTBeaconRegion *)region
{
    self.beaconsArray = beacons;
    
    
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
        
        
        self.beaconDetails.text = [NSString stringWithFormat:@"MAJOR: %@, MINOR: %@", closestBeacon.major, closestBeacon.minor];
        
        
        switch (closestBeacon.color) {
            case ESTBeaconColorUnknown:
                self.beaconName.text = @"Unknown";
                break;
            case ESTBeaconColorMint:
                self.beaconName.text = @"Green";
                break;
            case ESTBeaconColorIce:
                self.beaconName.text = @"Blue";
                break;
            case ESTBeaconColorBlueberry:
                self.beaconName.text = @"Purple";
                break;
            case ESTBeaconColorWhite:
                self.beaconName.text = @"White";
                break;
            case ESTBeaconColorTransparent:
                self.beaconName.text = @"Transparent";
                break;
                
            default:
                self.beaconName.text = @"Unknown";
                break;
        }
        
        if(!_beaconFound){
            
            [NSTimer scheduledTimerWithTimeInterval:2.0 block:^{
                
                [self preformAnimation];
                
            } repeats:NO];
            _currentBeacon = closestBeacon;
            _beaconFound = YES;
            
        }
        
    }
    
}


- (void)preformAnimation{
    
    POPSpringAnimation *hideLabel = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    hideLabel.fromValue  = [NSValue valueWithCGSize:CGSizeMake(1.0f, 1.0f)];
    hideLabel.toValue  = [NSValue valueWithCGSize:CGSizeMake(0.001f, 0.001f)];
    hideLabel.springBounciness = 0;
    hideLabel.springSpeed = 10;
    hideLabel.beginTime = CACurrentMediaTime() + .5;
    [self.searchingLabel pop_addAnimation:hideLabel forKey:@"showToastAnimation"];
    
    POPSpringAnimation *animationOne = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    animationOne.fromValue  = [NSValue valueWithCGSize:CGSizeMake(0, 0)];
    animationOne.toValue  = [NSValue valueWithCGSize:CGSizeMake(1.0f, 1.0f)];
    animationOne.springBounciness = 12;
    animationOne.springSpeed = 10;
    animationOne.beginTime = CACurrentMediaTime() + 1.0;
    [self.animationOne pop_addAnimation:animationOne forKey:@"showToastAnimation"];
    
    
    POPSpringAnimation *showAnimationTwo = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    showAnimationTwo.fromValue  = [NSValue valueWithCGSize:CGSizeMake(0, 0)];
    showAnimationTwo.toValue  = [NSValue valueWithCGSize:CGSizeMake(1.0f, 1.0f)];
    showAnimationTwo.springBounciness = 12;
    showAnimationTwo.springSpeed = 10;
    showAnimationTwo.beginTime = CACurrentMediaTime() + 1.3;
    [self.animationTwo pop_addAnimation:showAnimationTwo forKey:@"showToastAnimation"];
    
    POPSpringAnimation *showAnimationThree = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    showAnimationThree.fromValue  = [NSValue valueWithCGSize:CGSizeMake(0, 0)];
    showAnimationThree.toValue  = [NSValue valueWithCGSize:CGSizeMake(1.0f, 1.0f)];
    showAnimationThree.springBounciness = 12;
    showAnimationThree.springSpeed = 10;
    showAnimationThree.beginTime = CACurrentMediaTime() + 1.6;
    [self.animationThree pop_addAnimation:showAnimationThree forKey:@"showToastAnimation"];
    
    POPSpringAnimation *showAnimationFour = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    showAnimationFour.fromValue  = [NSValue valueWithCGSize:CGSizeMake(0, 0)];
    showAnimationFour.toValue  = [NSValue valueWithCGSize:CGSizeMake(1.0f, 1.0f)];
    showAnimationFour.springBounciness = 12;
    showAnimationFour.springSpeed = 10;
    showAnimationFour.beginTime = CACurrentMediaTime() + 1.9;
    [self.animationFour pop_addAnimation:showAnimationFour forKey:@"showToastAnimation"];
    
    POPSpringAnimation *showAnimationFive = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    showAnimationFive.fromValue  = [NSValue valueWithCGSize:CGSizeMake(0, 0)];
    showAnimationFive.toValue  = [NSValue valueWithCGSize:CGSizeMake(1.0f, 1.0f)];
    showAnimationFive.springBounciness = 12;
    showAnimationFive.springSpeed = 10;
    showAnimationFive.beginTime = CACurrentMediaTime() + 2.2;
    [self.animationFive pop_addAnimation:showAnimationFive forKey:@"showToastAnimation"];
    
    showAnimationFive.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        [self getVenueData];
    };

}


- (void)reset{
    
    self.searchingLabel.transform = CGAffineTransformMakeScale(1.0, 1.0);
    self.animationOne.transform = CGAffineTransformMakeScale(0.001, 0.001);
    self.animationTwo.transform = CGAffineTransformMakeScale(0.001, 0.001);
    self.animationThree.transform = CGAffineTransformMakeScale(0.001, 0.001);
    self.animationFour.transform = CGAffineTransformMakeScale(0.001, 0.001);
    self.animationFive.transform = CGAffineTransformMakeScale(0.001, 0.001);
    
    _beaconFound = NO;
  
}

//-(void)viewDidAppear:(BOOL)animated{
//    if(_beaconFound == YES){
//        [self reset];
//    }
//}

-(void)getVenueData{
     
    [[APIClient sharedInstance] getVenueForBeaconMajorId:_currentBeacon.major completion:^(Venue *venue, NSError *error) {
      
//        Venue *returnedVenue = (Venue *)[results objectAtIndex:0];
        NSLog(@"venue name: %@, and id: %d", venue.name, venue.venueId);
        
        UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        VenueViewController *venueVC = [sb instantiateViewControllerWithIdentifier:@"venueVC"];
//        VenueViewController *venueVC = [[VenueViewController alloc] init];
        
//        VenueViewController *venueVC = [[VenueViewController alloc]init];
        venueVC.venue = venue;
        
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:venueVC];
        nav.navigationBar.hidden = YES;
        
//        [self presentViewController:nav animated:YES completion:nil];
        [self.navigationController pushViewController:venueVC animated:YES];

        
    }];
    
    
}




@end
