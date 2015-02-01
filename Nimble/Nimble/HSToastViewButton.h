//
//  HSToastViewButton.h
//  Pods
//
//  Created by Eoin O'Connell on 02/09/2014.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class HSToastView;

typedef void(^HSToastButtonBlockWithToast)(UIButton *button, HSToastView *toastView);


@interface HSToastViewButton : NSObject

@property (nonatomic, copy) HSToastButtonBlockWithToast completionBlockWithButton;
@property (strong, nonatomic) UIButton *button;


@end
