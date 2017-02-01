//
//  Appearance.h
//  T21FingerPrint
//
//  Created by Edwin Peña on 19/1/17.
//  Copyright © 2017 Edwin Peña. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PinAppearance : NSObject

+ (instancetype)defaultAppearance;

/**
 Circle fil color of numeric buttons
 */
@property (nonatomic, strong) UIColor *numberButtonColor;
/**
 Numeric buttons text color
 */
@property (nonatomic, strong) UIColor *numberButtonTitleColor;
/**
 Circle color of numeric buttons
 */
@property (nonatomic, strong) UIColor *numberButtonStrokeColor;
/**
 Circle error color
 */
@property (nonatomic, strong) UIColor *strokeErrorColor;
/**
 Numeric buttons circle width
 */
@property (nonatomic, assign) CGFloat numberButtonStrokeWitdh;
/**
 Display Numeric buttons
 */
@property (nonatomic, assign) BOOL numberButtonstrokeEnabled;
/**
 Display Numeric buttons
 */
@property (nonatomic, strong) UIFont *numberButtonFont;
/**
 line color of delete Button
 */
@property (nonatomic, strong) UIColor *deleteButtonColor;
/**
 Circle fil color of pin code
 */
@property (nonatomic, strong) UIColor *pinFillColor;
/**
 Circle fil highlight color of pin code
 */
@property (nonatomic, strong) UIColor *pinHighlightedColor;
/**
 Circle color of pin code
 */
@property (nonatomic, strong) UIColor *pinStrokeColor;
/**
 Pin fil circle width
 */
@property (nonatomic, assign) CGFloat pinStrokeWidth;
/**
 Pin circle width
 */
@property (nonatomic, assign) CGSize pinSize;
/**
 title to display the first time to enter code
 default text "Enter code"
 */
@property (nonatomic, strong) NSString *titleText;
/**
 title to display the second time to enter code
 default text "Re-enter the code"
 */
@property (nonatomic, strong) NSString *reEnterPinTitleText;
/**
 title to display to create a new code
 default text "Create code"
 */
@property (nonatomic, strong) NSString *createNewPinTitleText;
/**
 title to display when it try to change of code
 default text "Enter the new code"
 */
@property (nonatomic, strong) NSString *changeTitleText;
/**
 title color
 */
@property (nonatomic, strong) UIColor *titleTextColor;
/**
 title font
 */
@property (nonatomic, strong) UIFont *titleTextFont;
/**
 sub-title to display
 default text "Passcodes did not match"
 */
@property (nonatomic, strong) NSString *supportText;
/**
 supportT title color
 */
@property (nonatomic, strong) UIColor *supportTextColor;
/**
 supportT title font
 */
@property (nonatomic, strong) UIFont *supportTextFont;
/**
 title to display in popup of touch id
 default text @"Put finger"
 */
@property (nonatomic, strong) NSString *touchIDText;
/**
 sub-title to display in popup of touch id
 default text @"Unlock App"
 */
@property (nonatomic, strong) NSString *touchIDVerification;
/**
 logo to display
 */
@property (nonatomic, strong) UIImage *logo;
/**
 backggroun color
 */
@property (nonatomic, strong) UIColor *backgroundColor;




@end
