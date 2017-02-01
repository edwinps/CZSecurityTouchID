//
//  SettingsAppearance.h
//  T21FingerPrint
//
//  Created by Edwin Peña on 23/1/17.
//  Copyright © 2017 Edwin Peña. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsAppearance : NSObject

+ (instancetype)defaultAppearance;
/**
 footer to display at below of table group
 default text @"Allows the touch unlocking of the application"
 */
@property (strong,nonatomic) NSString *footerGroupText;
/**
 title to display at above of table group
 default text @""
 */
@property (strong,nonatomic) NSString *titleGroupText;
/**
 active button text
 default text @"Activate Code"
 */
@property (strong,nonatomic) NSString *activateButtonText;
/**
 active button color
 */
@property (nonatomic, strong) UIColor *activateButtonColor;
/**
 active button font
 */
@property (nonatomic, strong) UIFont *activateButtonFont;
/**
 Deactivate button text
 default text @"Deactivate Code"
 */
@property (strong,nonatomic) NSString *deactivateButtonText;
/**
 Deactivate button color
 */
@property (nonatomic, strong) UIColor *deactivateButtonColor;
/**
 Deactivate button font
 */
@property (nonatomic, strong) UIFont *deactivateButtonFont;
/**
 change button text
 default text @"Change Code"
 */
@property (strong,nonatomic) NSString *changeButtonText;
/**
 change button color
 */
@property (nonatomic, strong) UIColor *changeButtonColor;
/**
 change button font
 */
@property (nonatomic, strong) UIFont *changeButtonFont;
/**
 touch id button text
 default text @"Touch ID"
 */
@property (strong,nonatomic) NSString *touchIDButtonText;
/**
 touch id button color
 */
@property (nonatomic, strong) UIColor *touchIDButtonColor;
/**
 touch id button font
 */
@property (nonatomic, strong) UIFont *touchIDButtonFont;

@end
