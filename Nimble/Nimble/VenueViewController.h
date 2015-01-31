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

@end
