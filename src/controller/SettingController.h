//
//  SettingController.h
//  T21FingerPrint
//
//  Created by Edwin Peña on 19/1/17.
//  Copyright © 2017 Edwin Peña. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PinProtocole.h"
@class SettingsStyle;

@interface SettingController : UITableViewController

@property (nonatomic,strong) SettingsStyle *style;

- (instancetype)initWithSettingsStyle:(SettingsStyle*)style;

@property (nonatomic, weak) id<PinViewControllerDataSource,PinViewControllerCreateDelegate> delegate;

@end
