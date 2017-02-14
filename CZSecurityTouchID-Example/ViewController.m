//
//  ViewController.m
//  T21FingerPrint
//
//  Created by Edwin Peña on 19/1/17.
//  Copyright © 2017 Edwin Peña. All rights reserved.
//

#import "ViewController.h"
#import "FingerPrint.h"


@interface ViewController () <PinViewControllerValidateDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



-(void)pinViewControllerDidSetWrongPin:(pinViewAction)action{
    
}

-(void)pinViewControllerDidSetСorrectPin:(pinViewAction)action{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)showPinAction:(UIButton *)sender {
    //Config de Appearance
    PinAppearance * appearance = [[PinAppearance alloc] init];
    appearance.logo = [UIImage imageNamed:@"sc_logo"];
    [FingerPrint sharedInstance].appearance = appearance;
//    [[FingerPrint sharedInstance] setLengthForPin:8];
    UIViewController *vc = [[FingerPrint sharedInstance] createPinViewWithScope:PinViewControllerScopeValidate WithvalidationDelegate:self];
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)SettingPinAction:(UIButton *)sender {
    //Config de Appearance
//    SettingsAppearance *appearance = [[SettingsAppearance alloc] init];
//    appearance.titleGroupText = @"Group title";
    PinAppearance * appearance = [[PinAppearance alloc] init];
    appearance.logo = [UIImage imageNamed:@"sc_logo"];
    UIViewController *vc = [[FingerPrint sharedInstance] createSettingViewWithAppearance:nil withPinViewControllerAppearance:appearance];
    [self.navigationController pushViewController:vc animated:YES];
}



@end
