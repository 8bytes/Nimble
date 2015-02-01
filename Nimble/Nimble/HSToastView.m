//
//  HSToastView.m
//  HSDashboardApp
//
//  Created by Adam Gammell on 29/01/2014.
//  Copyright (c) 2014 HubSpot. All rights reserved.
//

#import "HSToastView.h"
#import <pop/POP.h>

#define kButtonHeight 36

@interface HSToastView()

@property (strong, nonatomic) NSMutableArray *buttons;
@property (strong, nonatomic) UIColor *backColour;

@property (weak, nonatomic) IBOutlet UIView *toastContainer;
@property (weak, nonatomic) IBOutlet UIView *toastView;
@property (weak, nonatomic) IBOutlet UIView *parentView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toastYConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toastWidthConstraint;
@property (weak, nonatomic) IBOutlet UIView *buttonContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonContainerHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonContainerBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonContainerTopConstraint;



@property (strong, nonatomic) NSTimer *hideTimer;
@property (nonatomic) BOOL toastShown;

@end

@implementation HSToastView

- (id)initWithTitle:(NSString *)title message:(NSString *)message andImage:(UIImage *)image{
    
    self = [self init];
    _title = title;
    _message = message;
    _image = image;
    
    return self;
}

- (id)init{
    
    self = [[[NSBundle mainBundle] loadNibNamed:@"HSToastView" owner:self options:nil] objectAtIndex:0];
    if (self){
        self.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1];
        _backColour = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1];
        _darkenView = YES;
        _paddingLeft = 15.0f;
        _paddingRight = 15.0f;
        _paddingTop = 15.0f;
        _paddingBottom = 15.0f;
        _cornerRadius = 5.0f;
        _isWide = NO;
        _borderColor = [UIColor clearColor];
        _borderSize = 1.0f;
        
        _shadowColor = [UIColor blackColor];
        _shadowOpacity = 0.2;
        _shadowRadius = 10;
        _shadowOffset = CGSizeMake(0, 0);
        _showShadow = YES;
        
        _titleFont = [UIFont fontWithName:@"Avenir-Medium" size:16];
        _titleColor = [UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:1];
        _messageFont = [UIFont fontWithName:@"Avenir-Light" size:12];
        _messageColor = [UIColor colorWithRed:0.69 green:0.69 blue:0.68 alpha:1];
        
        _showCloseButton = NO;
        _dismissOnBackgroundTap = NO;
        _inlineImage = YES;
        
        _iconAnimationDelay = 0.5;
        _iconSpringSpeed = 10.0;
        _iconSpringBounciness = 12.0;
        _toastSpringSpeed = 10.0;
        _toastSpringBounciness = 12.0;
        self.buttons = [NSMutableArray new];
        _buttonLayout = HSToastViewButtonLayoutDefault;
        _topOffset = 0;
    }
    
    return self;
    
}

- (void)setUpToast{
    self.toastView.backgroundColor = [UIColor clearColor];
    self.toastView.layer.cornerRadius = _cornerRadius;
    
    // Toast Set Up
    self.toastContainer.backgroundColor = self.backColour;
    self.toastContainer.layer.cornerRadius = _cornerRadius;
    self.toastContainer.layer.borderColor = _borderColor.CGColor;
    self.toastContainer.layer.borderWidth = _borderSize;
    
    if(_showShadow){
        self.toastContainer.layer.shadowColor = _shadowColor.CGColor;
        self.toastContainer.layer.shadowOpacity = _shadowOpacity;
        self.toastContainer.layer.shadowRadius = _shadowRadius;
        self.toastContainer.layer.shadowOffset = _shadowOffset;
    }
    
    if (self.inlineImage || !self.image) {
        self.imageTopConstraint.constant = 8;
    }else{
        self.imageTopConstraint.constant = - (self.image.size.height/2);
    }
    
    
    if (self.topOffset > 0) {
        self.toastYConstraint.constant = self.topOffset;
    }
    
    self.iconImage.image = self.image;
    self.imageHeightConstraint.constant = self.image.size.height;
    self.imageWidthConstraint.constant = self.image.size.width;
    if (!self.image.size.height) {
        self.imageBottomConstraint.constant = 0;
    }
    
    //Title
    self.titleLabel.text = _title;
    self.titleLabel.textColor = _titleColor;
    self.titleLabel.font = _titleFont;
    
    //Message
    self.messageLabel.text = _message;
    self.messageLabel.font = _messageFont;
    self.messageLabel.textColor = _messageColor;
    
    //    float toastHeight = messageLabel.frame.origin.y + messageLabel.frame.size.height;
    
    //TODO topoffset
    [self.parentView addSubview:self];
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [self.parentView addConstraints:@[[NSLayoutConstraint constraintWithItem:self
                                                                   attribute:NSLayoutAttributeTop
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.parentView
                                                                   attribute:NSLayoutAttributeTop
                                                                  multiplier:1.0
                                                                    constant:0],
                                      [NSLayoutConstraint constraintWithItem:self
                                                                   attribute:NSLayoutAttributeLeft
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.parentView
                                                                   attribute:NSLayoutAttributeLeft
                                                                  multiplier:1.0
                                                                    constant:0],
                                      [NSLayoutConstraint constraintWithItem:self
                                                                   attribute:NSLayoutAttributeRight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.parentView
                                                                   attribute:NSLayoutAttributeRight
                                                                  multiplier:1.0
                                                                    constant:0],
                                      [NSLayoutConstraint constraintWithItem:self
                                                                   attribute:NSLayoutAttributeBottom
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.parentView
                                                                   attribute:NSLayoutAttributeBottom
                                                                  multiplier:1.0
                                                                    constant:0]
                                      ]];
    
    
    self.alpha = 0;
    self.tag = 70857;
    
    if(_darkenView){
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    }else{
        self.backgroundColor = [UIColor clearColor];
    }
    if(_dismissOnBackgroundTap){
        UITapGestureRecognizer *tapToClose = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideToast)];
        [self addGestureRecognizer:tapToClose];
    }
    
    //Close Button
    UIButton *closeButton = [[UIButton alloc] init];
    UIButton *closeView = [[UIButton alloc] init];
    if(_showCloseButton){
        closeButton.frame = CGRectMake(-10, -10, 20, 20);
        [closeButton setImage:[UIImage imageNamed:@"HSToastIconClose"] forState:UIControlStateNormal];
        [closeButton setBackgroundColor:[UIColor clearColor]];
        [closeButton addEventHandler:^(id sender, UIEvent *event) {
            [self hideToast];
        } forControlEvent:UIControlEventTouchUpInside];
        closeButton.alpha = 1;
        [self.toastContainer addSubview:closeButton];
        
        closeView.frame = self.frame;
        closeView.backgroundColor = [UIColor clearColor];
        [closeView addEventHandler:^(id sender, UIEvent *event) {
            [self hideToast];
        } forControlEvent:UIControlEventTouchUpInside];
        [self insertSubview:closeView belowSubview:self.toastContainer];
    }
    
    [self addButtons];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 1;
    }];
}

- (void)showOnView:(UIView*)view{
    
    [self presentOnView:view];
    self.hideTimer = [NSTimer scheduledTimerWithTimeInterval:MAXFLOAT block:^{
        [self hideToast];
    } repeats:NO];
    
}

- (void)presentOnView:(UIView*)view{
    
    if(!self.toastShown && ![self isPresentOnView:view]){
        
        self.parentView = view;
        [self setUpToast];
        [self showToastWithDelay:1.0];
        self.toastShown = YES;
        
    }
    
}

- (void)showOnView:(UIView*)view dismissAfter:(NSTimeInterval)duration{
    
    [self presentOnView:view];
    self.hideTimer = [NSTimer scheduledTimerWithTimeInterval:duration block:^{
        [self hideToast];
    } repeats:NO];
    
}

- (void)hideToast{
    
    if(self.toastShown){
        
        self.tag = 90;
        
        [UIView animateWithDuration:0.4 animations:^{
            self.alpha = 0;
            self.toastContainer.transform = CGAffineTransformMakeScale(0, 0);
        } completion:^(BOOL finished) {
            
            [self.hideTimer invalidate];
            [self removeFromSuperview];
            self.toastShown = NO;
            
        }];
        
    }
    
}

- (void)showToastWithDelay:(NSTimeInterval)delay{
    
    POPSpringAnimation *showToastAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    showToastAnimation.fromValue  = [NSValue valueWithCGSize:CGSizeMake(0, 0)];
    showToastAnimation.toValue  = [NSValue valueWithCGSize:CGSizeMake(1.0f, 1.0f)];
    showToastAnimation.springBounciness = _toastSpringBounciness;
    showToastAnimation.springSpeed = _toastSpringSpeed;
    showToastAnimation.beginTime = CACurrentMediaTime() + delay;
    [self.toastContainer pop_addAnimation:showToastAnimation forKey:@"showToastAnimation"];
    
    if(_image != nil){
        POPSpringAnimation *showImageAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
        showImageAnimation.fromValue  = [NSValue valueWithCGSize:CGSizeMake(0, 0)];
        showImageAnimation.toValue  = [NSValue valueWithCGSize:CGSizeMake(1.0f, 1.0f)];
        showImageAnimation.springBounciness = _iconSpringBounciness;
        showImageAnimation.springSpeed = _iconSpringSpeed;
        showImageAnimation.beginTime = CACurrentMediaTime() + _iconAnimationDelay + delay;
        [self.iconImage pop_addAnimation:showImageAnimation forKey:@"showImageAnimation"];
    }
    
    
}

- (void)addButtonWithText:(NSString *)buttonText backgroundColor:(UIColor *)backgroundColor titleColor:(UIColor *)tintColor completion:(HSToastButtonBlockWithToast)completion{
    
    HSToastViewButton *button = [[HSToastViewButton alloc] init];
    button.completionBlockWithButton = completion;
    button.button = [self createButtonWithText:buttonText backgroundColor:backgroundColor andTitleColor:tintColor];
    [self.buttons addObject:button];
    
}

- (void)addButtonWithText:(NSString *)buttonText andTitleColor:(UIColor *)tintColor andCompletion:(HSToastButtonBlock)completion {
    
    _completionBlock = completion;
    [self createButtonWithText:buttonText backgroundColor:[UIColor clearColor] andTitleColor:tintColor];
}

- (void)addButtonWithText:(NSString *)buttonText titleColor:(UIColor *)tintColor completion:(HSToastButtonBlockWithToast)completion{
    
    HSToastViewButton *button = [[HSToastViewButton alloc] init];
    button.completionBlockWithButton = completion;
    button.button = [self createButtonWithText:buttonText backgroundColor:[UIColor clearColor] andTitleColor:tintColor];
    [self.buttons addObject:button];
}


- (UIButton *)createButtonWithText:(NSString *)buttonText backgroundColor:(UIColor *)backgroundColor andTitleColor:(UIColor *)tintColor{
    _button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, kButtonHeight)];
    [_button setTitle:buttonText forState:UIControlStateNormal];
    [_button setTintColor:tintColor];
    [_button.titleLabel setTextColor:tintColor];
    [_button setBackgroundColor:backgroundColor];
    if(backgroundColor == [UIColor clearColor]){
        _button.layer.borderColor = tintColor.CGColor;
    }else{
        _button.layer.borderColor = [UIColor clearColor].CGColor;
    }
    _button.layer.borderWidth = 0.5f;
    _button.layer.cornerRadius = 5.0f;
    [_button setTitleColor:tintColor forState:UIControlStateNormal];
    [_button.titleLabel setFont:[UIFont fontWithName:@"Avenir-Light" size:14]];
    [_button addTarget:self action:@selector(buttonpressed:) forControlEvents:UIControlEventTouchDown];
    return _button;
}

- (void)buttonpressed:(id)sender{
    if (_completionBlock) {
        _completionBlock(_button);
    }else{
        
        if ([sender isKindOfClass:[UIButton class]]) {
            UIButton *pressedButton = (UIButton *)sender;
            
            [self.buttons enumerateObjectsUsingBlock:^(HSToastViewButton *toastButton, NSUInteger idx, BOOL *stop) {
                
                if([pressedButton isEqual:toastButton.button]){
                    if (toastButton.completionBlockWithButton) {
                        toastButton.completionBlockWithButton(toastButton.button, self);
                    }
                    *stop = YES;
                }
            }];
        }
    }
}

- (void)addButtons{
    
    if(_button && (!self.buttons || [self.buttons count] == 0)){
        [self addButton:_button atIndex:0];
    }else{
        [self.buttons enumerateObjectsUsingBlock:^(HSToastViewButton *button, NSUInteger idx, BOOL *stop) {
            [self addButton:button.button atIndex:idx];
        }];
    }
    
    NSUInteger buttonCount = 0;
    if (self.buttons.count) {
        buttonCount = self.buttons.count;
    }else if (_button){
        buttonCount = 1;
    }
    
    if (buttonCount) {
        if (self.buttonLayout == HSToastViewButtonLayoutHorizontal) {
            self.buttonContainerHeightConstraint.constant = (kButtonHeight+10);
        }else{
            self.buttonContainerHeightConstraint.constant = (kButtonHeight+10)*buttonCount;
        }
    }else{
        self.buttonContainerHeightConstraint.constant = 0;
        self.buttonContainerBottomConstraint.constant = 0;
        self.buttonContainerTopConstraint.constant = 0;
    }
    
    
    // If you set 0, pop cannot invert a 0 matrix and freaks out
    self.toastContainer.transform = CGAffineTransformMakeScale(0.001, 0.001);
    self.iconImage.transform = CGAffineTransformMakeScale(0.001, 0.001);
}

- (CGFloat)buttonWidth{
    return (self.toastWidthConstraint.constant / [self.buttons count] - (10 * [self.buttons count]));
}

- (void)addButton:(UIButton *)button atIndex:(NSUInteger)index{
    switch (self.buttonLayout) {
        case HSToastViewButtonLayoutHorizontal:
            button.frame = CGRectMake((([self buttonWidth] + 8) * index) ,  8, [self buttonWidth], kButtonHeight);
            
            break;
        case HSToastViewButtonLayoutDefault:
        case HSToastViewButtonLayoutVertical:
        default:
            button.frame = CGRectMake(0, ((8 * (index + 1))) + ((index * kButtonHeight)), self.toastWidthConstraint.constant - _paddingRight - _paddingLeft, kButtonHeight);
            
            break;
    }
    [self.buttonContainer addSubview:button];
}

- (BOOL)isPresentOnView:(UIView *)view{
    BOOL isOnView = [view.subviews containsObject:self];
    
    for (UIView *currentView in view.subviews) {
        
        if(currentView.tag == 70857){
            isOnView = YES;
        }
    }
    
    return isOnView;
}


@end
