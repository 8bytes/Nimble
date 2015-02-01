//
//  HSToastView.h
//  HSDashboardApp
//
//  Created by Adam Gammell on 29/01/2014.
//  Copyright (c) 2014 HubSpot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JTTargetActionBlock/UIControl+JTTargetActionBlock.h>
#import <NSTimer-Blocks/NSTimer+Blocks.h>
#import "HSToastViewButton.h"


typedef NS_ENUM(NSUInteger, HSToastViewButtonLayout) {
    HSToastViewButtonLayoutDefault,
    HSToastViewButtonLayoutVertical,
    HSToastViewButtonLayoutHorizontal
};

@interface HSToastView : UIView

typedef void(^HSToastButtonBlock)(UIButton *button);

@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* message;
@property (nonatomic, strong) UIImage* image;
@property (nonatomic) BOOL darkenView, isWide, showShadow, showCloseButton, dismissOnBackgroundTap, inlineImage;
@property (nonatomic, assign) float paddingLeft;
@property (nonatomic, assign) float paddingRight;
@property (nonatomic, assign) float paddingTop;
@property (nonatomic, assign) float paddingBottom;
@property (nonatomic, assign) float cornerRadius;
@property (nonatomic, strong) UIColor* borderColor;
@property (nonatomic, assign) float borderSize;
@property (nonatomic, assign) float shadowRadius;
@property (nonatomic, assign) float shadowOpacity;
@property (nonatomic, strong) UIColor* shadowColor;
@property (nonatomic, assign) CGSize shadowOffset;
@property (nonatomic, strong) UIFont* titleFont;
@property (nonatomic, strong) UIColor* titleColor;
@property (nonatomic, strong) UIFont* messageFont;
@property (nonatomic, strong) UIColor* messageColor;
@property (nonatomic, assign) NSTimeInterval iconAnimationDelay;
@property (nonatomic, assign) float iconSpringSpeed;
@property (nonatomic, assign) float iconSpringBounciness;
@property (nonatomic, assign) float toastSpringSpeed;
@property (nonatomic, assign) float toastSpringBounciness;
@property (nonatomic, copy) HSToastButtonBlock completionBlock;
@property (nonatomic) HSToastViewButtonLayout buttonLayout;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, assign) float topOffset;


- (id)initWithTitle:(NSString *)title message:(NSString *)message andImage:(UIImage *)image;
- (void)setUpToast;
- (void)showOnView:(UIView*)view;
- (void)showOnView:(UIView*)view dismissAfter:(NSTimeInterval)duration;
- (void)hideToast;
- (void)addButtonWithText:(NSString *)buttonText andTitleColor:(UIColor *)tintColor andCompletion:(HSToastButtonBlock)completion DEPRECATED_MSG_ATTRIBUTE("Use addButtonWithText:titleColor:completion: for new block calback");
- (void)addButtonWithText:(NSString *)buttonText titleColor:(UIColor *)tintColor completion:(HSToastButtonBlockWithToast)completion;
- (void)addButtonWithText:(NSString *)buttonText backgroundColor:(UIColor *)backgroundColor titleColor:(UIColor *)tintColor completion:(HSToastButtonBlockWithToast)completion;
- (BOOL)isPresentOnView:(UIView *)view;
@end
