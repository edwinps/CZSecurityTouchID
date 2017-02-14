//
//  CellDTO.m
//  T21FingerPrint
//
//  Created by Edwin Peña on 19/1/17.
//  Copyright © 2017 Edwin Peña. All rights reserved.
//

#import "CellDTO.h"
#import "SettingsAppearance.h"

@implementation CellDTO

- (instancetype)init {
    self = [super init];
    if (self) {
        _appearance = nil;
        _switchHidden = YES;
        _enableCell = YES;
    }
    return self;
}

- (instancetype)initWithId:(pinViewAction)identifier wihtAppearance:(SettingsAppearance*)appearance withDelegate:(id<CellDTODelegate>)delegate {
    self = [super init];
    if (self) {
        _cellDTOIdentifier = identifier;
        _appearance = appearance;
        _delegate = delegate;
        _enableCell = YES;
        if(delegate){
            _switchHidden = NO;
        }else{
           _switchHidden = YES; 
        }
    }
    return self;
}


@end
