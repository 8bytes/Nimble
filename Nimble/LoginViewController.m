//
//  ViewController.m
//  Nimble
//
//  Created by Adam Gammell on 31/01/2015.
//  Copyright (c) 2015 HubSpot. All rights reserved.
//

#import "LoginViewController.h"
#import "BeaconViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.signUpButton.layer.cornerRadius = 4.0f;
    self.signUpButton.layer.masksToBounds = YES;
    self.signUpButton.backgroundColor = kGreenTintColor;
    self.signUpButton.titleLabel.shadowColor = [UIColor colorWithWhite:0 alpha:0.1];
    self.signUpButton.titleLabel.shadowOffset = CGSizeMake(0, 1);
    
    self.loginButton.layer.borderWidth = 1.0f;
    self.loginButton.layer.cornerRadius = 4.0f;
    self.loginButton.layer.masksToBounds = YES;
    self.loginButton.layer.borderColor = kGreenTintColor.CGColor;
    [self.loginButton setTitleColor:kGreenTintColor forState:UIControlStateNormal];
    self.loginButton.backgroundColor = [UIColor clearColor];
    
    self.view.backgroundColor = kViewBackgroundColor;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signUpButtonPressed:(id)sender{
    

    
    
}
- (IBAction)loginButtonPressed:(id)sender{
    
}

@end
