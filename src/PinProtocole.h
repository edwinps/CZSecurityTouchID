//
//  PinProtocole.h
//  T21FingerPrint
//
//  Created by Edwin Peña on 19/1/17.
//  Copyright © 2017 Edwin Peña. All rights reserved.
//
typedef enum pinViewAction
{
    activatePin = 0,
    deactivatePin = 1,
    changePin = 2,
    touchIdPin = 3,
    showPin = 4,
    otherPin = 5,
}pinViewAction;

//All steps of checkout

@protocol PinViewControllerDataSource <NSObject>
@required
/**
 *  Pin code for controller. Supports from 2 to 8 characters
 */
-(NSString *)codeForPinViewController;

/**
 *  touch id Active
 */
-(BOOL)touchIDActiveViewController;

@optional
-(BOOL)hideTouchIDButtonIfFingersAreNotEnrolled;
-(BOOL)showTouchIDVerificationImmediately;
@end

@protocol PinViewControllerValidateDelegate <NSObject>
@required
/**
 *  when user set wrong pin code calling this delegate method
 */
-(void)pinViewControllerDidSetWrongPin:(pinViewAction)action;
/**
 *  when user set correct pin code calling this delegate method
 */
-(void)pinViewControllerDidSetСorrectPin:(pinViewAction)action;;
@end

@protocol PinViewControllerCreateDelegate <NSObject>
@required
/**
 *  when user set new pin code calling this delegate method
 */
-(void)pinViewController:(UIViewController *)viewController didSetNewPin:(NSString *)pin;

/**
 *  when user active touchID calling this delegate method
 */
-(void)touchIDActive:(UIViewController *)viewController didActiveTouchID:(BOOL)active;

-(NSInteger)lengthForPin;
@end


