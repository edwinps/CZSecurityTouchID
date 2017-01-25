//
//  SettingCell.h
//  T21FingerPrint
//
//  Created by Edwin Peña on 19/1/17.
//  Copyright © 2017 Edwin Peña. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SettingCell;
@class CellDTO;

@protocol CellDTODelegate

-(void)cellTouchId:(SettingCell*)cell didActive:(BOOL)actvie;

@end

@interface SettingCell : UITableViewCell

@property (weak,nonatomic) IBOutlet UILabel *titleText;
@property (weak,nonatomic) IBOutlet UISwitch *switchButton;
@property (nonatomic,strong) CellDTO *cellDTO;
@property (nonatomic,weak) id<CellDTODelegate> delegate;

@end
