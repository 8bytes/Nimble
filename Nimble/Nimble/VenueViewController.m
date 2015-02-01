//
//  VenueViewController.m
//  Nimble
//
//  Created by Adam Gammell on 31/01/2015.
//  Copyright (c) 2015 HubSpot. All rights reserved.
//

#import "VenueViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <NSTimer-Blocks/NSTimer+Blocks.h>

@interface VenueViewController ()

@property (nonatomic, strong) Order *currentOrder;

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
    
    self.splitBillButton.layer.borderWidth = 1.0f;
    self.splitBillButton.layer.cornerRadius = 4.0f;
    self.splitBillButton.layer.masksToBounds = YES;
    self.splitBillButton.layer.borderColor = kGreenTintColor.CGColor;
    [self.splitBillButton setTitleColor:kGreenTintColor forState:UIControlStateNormal];
    self.splitBillButton.backgroundColor = [UIColor clearColor];
    
    self.orderDetails.font = [UIFont fontWithName:@"Avenir-Light" size:22];
    self.orderDetails.textColor = [UIColor whiteColor];
    
    self.priceLabel.font = [UIFont fontWithName:@"Avenir-Light" size:80];
    self.priceLabel.textColor = [UIColor whiteColor];
    
    
    
    [SVProgressHUD setForegroundColor:kGreenTintColor];
    [SVProgressHUD setRingThickness:2.0];
    [self getOrderDetails];
    [SVProgressHUD show];
    
}

- (void)getOrderDetails{
    
    [NSTimer scheduledTimerWithTimeInterval:2.0 block:^{
        
        [[APIClient sharedInstance]getOrderDetailsForVenue:_venue.venueId completion:^(Order *order, NSError *error) {
 
            
         
//            if([orders count]>0){
            
//                Order *theOrder = [orders objectAtIndex:0];
                NSLog(@"Order Total: %d", order.price);
            self.orderDetails.text = @"Due on your order";
            self.priceLabel.text = [NSString stringWithFormat:@"€%d", order.price];
            [UIView animateWithDuration:0.8 animations:^{
                self.payNowButton.alpha = 1;
                self.splitBillButton.alpha = 1;
            }];
            
            if(order.price <= 0){
                self.orderDetails.text = @"Thank You";
                self.priceLabel.text = @"Paid";
                [UIView animateWithDuration:0.8 animations:^{
                    self.payNowButton.alpha = 0;
                    self.splitBillButton.alpha = 0;
                }];
            }
            
            self.currentOrder = order;
            [SVProgressHUD dismiss];
        }];
        
    } repeats:YES];
    
}

- (void)close{
    [self.navigationController popViewControllerAnimated:YES];
    
//    [self dismissViewControllerAnimated:YES completion:nil];
    
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
    
    [[APIClient sharedInstance]pay:self.currentOrder.price onOrder:self.currentOrder completion:^(Order *order, NSError *error) {
        
        NSLog(@"New price: %d", order.price);
        if(order.price <= 0){
            self.orderDetails.text = @"Thank You";
            self.priceLabel.text = @"Paid";
            [UIView animateWithDuration:0.8 animations:^{
                self.payNowButton.alpha = 0;
                self.splitBillButton.alpha = 0;
            }];
        }
        
    }];
    
}

- (IBAction)splitBillPressed:(id)sender {
    
    HSToastView *splitToast = [[HSToastView alloc]initWithTitle:@"Split the bill" message:@"How much do you wish to pay?" andImage:[UIImage imageNamed:@"toastIcon"]];
    splitToast.inlineImage = NO;
    
    [splitToast addButtonWithText:@"25%" backgroundColor:kGreenTintColor titleColor:kViewBackgroundColor completion:^(UIButton *button, HSToastView *toastView){
        
        [[APIClient sharedInstance]pay:(self.currentOrder.price/4) onOrder:self.currentOrder completion:^(Order *order, NSError *error) {
            
            NSLog(@"New price: %d", order.price);
            self.priceLabel.text = [NSString stringWithFormat:@"€%d", order.price];
            [toastView hideToast];
            
        }];
        
    }];
    
    [splitToast addButtonWithText:@"50%" backgroundColor:kGreenTintColor titleColor:kViewBackgroundColor completion:^(UIButton *button, HSToastView *toastView){
    
        [[APIClient sharedInstance]pay:(self.currentOrder.price/2) onOrder:self.currentOrder completion:^(Order *order, NSError *error) {
            
            NSLog(@"New price: %d", order.price);
            self.priceLabel.text = [NSString stringWithFormat:@"€%d", order.price];
            [toastView hideToast];
            
        }];
        
    }];
    
    [splitToast addButtonWithText:@"75%" backgroundColor:kGreenTintColor titleColor:kViewBackgroundColor completion:^(UIButton *button, HSToastView *toastView){
        
        [[APIClient sharedInstance]pay:((self.currentOrder.price/4)*3) onOrder:self.currentOrder completion:^(Order *order, NSError *error) {
            
            NSLog(@"New price: %d", order.price);
            self.priceLabel.text = [NSString stringWithFormat:@"€%d", order.price];
            [toastView hideToast];
            
        }];
        
    }];
    
    [splitToast showOnView:self.view];
    
}
@end
