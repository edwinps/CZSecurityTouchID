//
//  SettingController.h
//  T21FingerPrint
//
//  Created by Edwin Peña on 19/1/17.
//  Copyright © 2017 Edwin Peña. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PinProtocole.h"
@class SettingsAppearance;
@class PinAppearance;

@interface SettingController : UITableViewController

@property (nonatomic,strong) SettingsAppearance *appearance;
@property (strong,nonatomic) PinAppearance *pinViewAppearance;

- (instancetype)initWithSettingsAppearance:(SettingsAppearance*)appearance;

@property (nonatomic, weak) id<PinViewControllerDataSource,PinViewControllerCreateDelegate> delegate;

@end
