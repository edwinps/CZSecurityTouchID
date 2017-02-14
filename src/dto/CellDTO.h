//
//  cellDTO.h
//  T21FingerPrint
//
//  Created by Edwin Peña on 19/1/17.
//  Copyright © 2017 Edwin Peña. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SettingCell.h"
#import "PinProtocole.h"
@class SettingsAppearance;

@interface CellDTO : NSObject
@property (strong,nonatomic) SettingsAppearance* appearance;
@property (nonatomic) BOOL enableCell;
@property (nonatomic) BOOL switchHidden;
@property (nonatomic) pinViewAction cellDTOIdentifier;
@property (nonatomic,weak) id<CellDTODelegate> delegate;
@property (nonatomic) BOOL switchOn;

- (instancetype)initWithId:(pinViewAction)identifier wihtAppearance:(SettingsAppearance*)appearance withDelegate:(id<CellDTODelegate>)delegate;

@end
