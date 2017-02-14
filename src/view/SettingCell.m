//
//  SettingCell.m
//  T21FingerPrint
//
//  Created by Edwin Peña on 19/1/17.
//  Copyright © 2017 Edwin Peña. All rights reserved.
//

#import "SettingCell.h"
#import "CellDTO.h"
#import "SettingsAppearance.h"

@implementation SettingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [_switchButton setHidden:YES];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(IBAction)switchPressed:(id)sender{
    [_delegate cellTouchId:self didActive:_switchButton.on];
}


-(void)setCellDTO:(CellDTO *)cellDTO{
    _cellDTO = cellDTO;
    _switchButton.hidden = cellDTO.switchHidden;
    [_switchButton setOn:cellDTO.switchOn];
    
    if(!cellDTO.enableCell){
        self.userInteractionEnabled = NO;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.alpha = 0.5;
    }else{
        self.userInteractionEnabled = YES;
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        self.contentView.alpha = 1;
    }
    if(cellDTO.cellDTOIdentifier == activatePin){
        _titleText.text = cellDTO.appearance.activateButtonText;
        _titleText.font = cellDTO.appearance.activateButtonFont;
        _titleText.textColor = cellDTO.appearance.activateButtonColor;
    }else if(cellDTO.cellDTOIdentifier == deactivatePin){
        _titleText.text = cellDTO.appearance.deactivateButtonText;
        _titleText.font = cellDTO.appearance.deactivateButtonFont;
        _titleText.textColor = cellDTO.appearance.deactivateButtonColor;
    }else  if(cellDTO.cellDTOIdentifier == changePin){
        _titleText.text = cellDTO.appearance.changeButtonText;
        _titleText.font = cellDTO.appearance.changeButtonFont;
        _titleText.textColor = cellDTO.appearance.changeButtonColor;
    }else  if(cellDTO.cellDTOIdentifier == touchIdPin){
        _titleText.text = cellDTO.appearance.touchIDButtonText;
        _titleText.font = cellDTO.appearance.touchIDButtonFont;
        _titleText.textColor = cellDTO.appearance.touchIDButtonColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
}

@end
