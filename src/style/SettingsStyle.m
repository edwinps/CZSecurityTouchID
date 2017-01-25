//
//  SettingsStyle.m
//  T21FingerPrint
//
//  Created by Edwin Peña on 23/1/17.
//  Copyright © 2017 Edwin Peña. All rights reserved.
//

#import "SettingsStyle.h"

@implementation SettingsStyle

+ (instancetype)defaultStyle {
    SettingsStyle *defaultStyle = [[SettingsStyle alloc]init];
    return defaultStyle;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupDefaultStyle];
    }
    return self;
}

-(void)setupDefaultStyle{
    UIColor *defaultColor = [UIColor colorWithRed:0.0f / 255.0f green:0.0f / 255.0f blue:0.0f / 255.0f alpha:1];
    UIFont *defaultFont = [UIFont fontWithName:@"HelveticaNeue" size:17.0f];
    
    self.footerGroupText = @"Allows the touch unlocking of the application";
    self.titleGroupText = @"";
    
    self.activateButtonText = @"Activate Code";
    self.activateButtonFont = defaultFont;
    self.activateButtonColor = defaultColor;
    
    self.changeButtonText = @"Change Code";
    self.changeButtonFont = defaultFont;
    self.changeButtonColor = defaultColor;
    
    self.deactivateButtonText = @"Deactivate Code";
    self.deactivateButtonFont = defaultFont;
    self.deactivateButtonColor = defaultColor;
    
    self.touchIDButtonText = @"Touch ID";
    self.touchIDButtonFont = defaultFont;
    self.touchIDButtonColor = defaultColor;
    
}

@end
