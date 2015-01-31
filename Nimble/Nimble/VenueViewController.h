//
//  VenueViewController.h
//  Nimble
//
//  Created by Adam Gammell on 31/01/2015.
//  Copyright (c) 2015 HubSpot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Venue.h"

@interface VenueViewController : UIViewController

@property (nonatomic, strong) Venue *venue;
@property (strong, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (strong, nonatomic) IBOutlet UILabel *venueNameLabel;
@property (strong, nonatomic) IBOutlet UIButton *payNowButton;
@property (strong, nonatomic) IBOutlet UILabel *orderDetails;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
- (IBAction)payNowPressed:(id)sender;

@end
