//
//  PinAppearance.m
//  T21FingerPrint
//
//  Created by Edwin Peña on 19/1/17.
//  Copyright © 2017 Edwin Peña. All rights reserved.
//

#import "PinAppearance.h"
#import "PinButton.h"

@implementation PinAppearance


+ (instancetype)defaultAppearance {
    PinAppearance *defaultAppearance = [[PinAppearance alloc]init];
    return defaultAppearance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupDefaultAppearance];
    }
    return self;
}

-(void)setupDefaultAppearance {
    UIColor *defaultTextColor = [UIColor darkGrayColor];
    UIColor *defaultColor = [UIColor colorWithRed:46.0f / 255.0f green:192.0f / 255.0f blue:197.0f / 255.0f alpha:1]; //blue color
    UIColor *errorColor = [UIColor redColor];
    
    UIFont *defaultTitleFont = [UIFont fontWithName:@"HelveticaNeue" size:22.0f];
    UIFont *defaultSupportFont = [UIFont fontWithName:@"HelveticaNeue" size:12.0f];
    UIFont *defaultFont = [UIFont fontWithName:@"HelveticaNeue" size:27.0f];
    
    self.numberButtonColor = defaultColor;
    self.numberButtonTitleColor = [UIColor blackColor];
    self.numberButtonStrokeColor = defaultColor;
    self.numberButtonStrokeWitdh = 0.8f;
    self.numberButtonstrokeEnabled = YES;
    self.numberButtonFont = defaultFont;
    
    self.strokeErrorColor = errorColor;
    self.deleteButtonColor = defaultColor;
    
    self.pinFillColor = [UIColor clearColor];
    self.pinHighlightedColor = defaultColor;
    self.pinStrokeColor = defaultColor;
    self.pinStrokeWidth = 0.8f;
    self.pinSize = CGSizeMake(14.0f, 14.0f);
    
    self.titleText = @"Enter code";
    self.createNewPinTitleText = @"Create code";
    self.reEnterPinTitleText = @"Re-enter the code";
    self.changeTitleText = @"Enter the new code";
    self.titleTextFont = defaultTitleFont;
    self.titleTextColor = defaultTextColor;
    
    self.supportText = @"Passcode did not match, try again";
    self.supportTextFont = defaultSupportFont;
    self.supportTextColor = defaultTextColor;
    
    self.touchIDText = @"Put finger";
    self.touchIDVerification = @"Unlock App";
    self.logo = nil;
    self.backgroundColor = [UIColor whiteColor];
}

@end
