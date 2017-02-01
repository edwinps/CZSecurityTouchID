//
//  FingerPrint.m
//  T21FingerPrint
//
//  Created by Edwin Peña on 26/1/17.
//  Copyright © 2017 Edwin Peña. All rights reserved.
//

#import "FingerPrint.h"
#import "NSString+AESCrypt.h"

NSString * const kViewControllerPin = @"kViewControllerPin";
NSString * const kTouchIDActive = @"kTouchIDActive";
NSString * const keyCrypted = @"603deb1015ca7f352c073b6108d0a30914dff4";

@interface FingerPrint () <PinViewControllerCreateDelegate,PinViewControllerDataSource>
@property (nonatomic) BOOL showTouchID;
@end

@implementation FingerPrint

+ (instancetype)sharedInstance
{
    static FingerPrint *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[[self class] alloc] init];
        sharedInstance.appearance = [PinAppearance defaultAppearance];
        sharedInstance.lengthForPin = 4;
    });
    return sharedInstance;
}


- (UIViewController*)createPinViewWithScope:(PinViewControllerScope)scope
                     WithvalidationDelegate:(id<PinViewControllerValidateDelegate>)validationDelegate
{
    if(!scope){
        scope = PinViewControllerScopeValidate;
    }
    
    if(scope == PinViewControllerScopeValidate && [self touchIDActiveViewController]){
        _showTouchID = YES;
    }else{
        _showTouchID = NO;
    }
    
    PinViewController *vc;
    [PinViewController setNewAppearance:self.appearance];
    vc = [[PinViewController alloc] initWithScope:scope];
    vc.dataSourceDelegate = self;
    vc.createDelegate = self;
    vc.validateDelegate = validationDelegate;
    
    return vc;
}

- (UIViewController*)createSettingViewWithAppearance:(SettingsAppearance*)appearance withPinViewControllerAppearance:(PinAppearance*)pinAppearance{
    _showTouchID = NO;
    SettingController *vc = [[SettingController alloc] initWithSettingsAppearance:appearance];
    vc.pinViewAppearance = pinAppearance;
    vc.delegate = self;
    return vc;
}

#pragma mark - PinViewControllerScope


-(void)pinViewController:(UIViewController *)viewController didSetNewPin:(NSString *)pin {
    // Encrypted the pin code
    NSString *encryptedString = [pin AES256EncryptWithKey:keyCrypted];
    //NSLog(@"Encrypted ID : %@", encryptedString);
    [[NSUserDefaults standardUserDefaults] setObject:encryptedString forKey:kViewControllerPin];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)touchIDActive:(UIViewController *)viewController didActiveTouchID:(BOOL)active{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:active] forKey:kTouchIDActive];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSInteger)lengthForPin {
    return _lengthForPin;
}

#pragma mark - PinViewControllerDataSource

-(NSString *)codeForPinViewController {
    NSString *pin = [[NSUserDefaults standardUserDefaults] objectForKey:kViewControllerPin];
    // Decrypted the pin code
    NSString *decryptedString = [pin AES256DecryptWithKey:keyCrypted];
    //NSLog(@"Decrypted ID : %@", decryptedString);
    return decryptedString;
}

-(BOOL )touchIDActiveViewController{
    NSNumber *active = [[NSUserDefaults standardUserDefaults] objectForKey:kTouchIDActive];
    if(active){
        return active.boolValue;
    }
    
    return NO;
}

-(BOOL)showTouchIDVerificationImmediately {
    return _showTouchID;
}
@end
