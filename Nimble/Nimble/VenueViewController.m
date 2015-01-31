//
//  VenueViewController.m
//  Nimble
//
//  Created by Adam Gammell on 31/01/2015.
//  Copyright (c) 2015 HubSpot. All rights reserved.
//

#import "VenueViewController.h"

@interface VenueViewController ()

@end

@implementation VenueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = kViewBackgroundColor;
    
    self.welcomeLabel.textColor = kGreenTintColor;
    self.welcomeLabel.font = [UIFont fontWithName:@"Avenir-Light" size:30];
    
    self.venueNameLabel.text = [NSString stringWithFormat:@"the %@", self.venue.name];
    self.venueNameLabel.textColor = kGreenTintColor;
    self.venueNameLabel.font = [UIFont fontWithName:@"Avenir-Light" size:24];
    
    
    UITapGestureRecognizer *resetTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
    [resetTap setNumberOfTapsRequired:3];
    [self.view addGestureRecognizer:resetTap];
    
    self.payNowButton.layer.borderWidth = 1.0f;
    self.payNowButton.layer.cornerRadius = 4.0f;
    self.payNowButton.layer.masksToBounds = YES;
    self.payNowButton.layer.borderColor = kGreenTintColor.CGColor;
    [self.payNowButton setTitleColor:kGreenTintColor forState:UIControlStateNormal];
    self.payNowButton.backgroundColor = [UIColor clearColor];
    
    self.orderDetails = [UIFont fontWithName:@"Avenir-Light" size:30];
    
}

- (void)close{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)payNowPressed:(id)sender {
}
@end
