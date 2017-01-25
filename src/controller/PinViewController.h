//
//  PinViewController.h
//  T21FingerPrint
//
//  Created by Edwin Peña on 19/1/17.
//  Copyright © 2017 Edwin Peña. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PinProtocole.h"
@class PinViewController;
@class PinStyle;

typedef NS_ENUM(NSInteger, PinViewControllerScope) {
    PinViewControllerScopeValidate,
    PinViewControllerScopeCreate,
    PinViewControllerScopeChange,
    PinViewControllerScopeDesactive,
};

@interface PinViewController : UIViewController
- (instancetype)initWithScope:(PinViewControllerScope)scope;

+ (PinStyle *)stlye;
+ (void)setNewStyle:(PinStyle *)newStlye;

@property (nonatomic, assign) PinViewControllerScope scope;
@property (nonatomic, weak) id<PinViewControllerCreateDelegate> createDelegate;
@property (nonatomic, weak) id<PinViewControllerValidateDelegate> validateDelegate;
@property (nonatomic, weak) id<PinViewControllerDataSource> dataSourceDelegate;

@end


