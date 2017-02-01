//
//  FingerPrint.h
//  T21FingerPrint
//
//  Created by Edwin Peña on 26/1/17.
//  Copyright © 2017 Edwin Peña. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PinAppearance.h"
#import "PinProtocole.h"
#import "PinViewController.h"
#import "SettingController.h"
#import "SettingsAppearance.h"
#import "PinAppearance.h"

@interface FingerPrint : NSObject

/**
 set the appearance of the view
 */
@property (strong, nonatomic) PinAppearance *appearance;
/**
 set length For Pin code
 */
@property (nonatomic) NSInteger lengthForPin;

/**
 @return A singleton FingerPrint instance.
 */
+ (instancetype)sharedInstance;

/**
 createPinView. Return a viewcontroller(PinViewController).
 @param scope of the view , Default PinViewControllerScopeValidate
 @param validationDelegate Validate of pin
 */
- (UIViewController*)createPinViewWithScope:(PinViewControllerScope)scope
                  WithvalidationDelegate:(id<PinViewControllerValidateDelegate>)validationDelegate;

/**
 createSettingView. Return a viewcontroller(SettingController).
 @param appearance of the view
 */
- (UIViewController*)createSettingViewWithAppearance:(SettingsAppearance*)appearance
                withPinViewControllerAppearance:(PinAppearance*)pinAppearance;

@end
