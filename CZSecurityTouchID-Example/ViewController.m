//
//  ViewController.m
//  CZSecurityTouchID
//
//  Created by Edwin Peña on 25/1/17.
//  Copyright © 2017 Edwin Peña. All rights reserved.
//

#import "ViewController.h"
#import "PinViewController.h"
#import "PinStyle.h"
#import "SettingController.h"

NSString * const kViewControllerPin = @"kViewControllerPin";
NSString * const kTouchIDActive = @"kTouchIDActive";

@interface ViewController () <PinViewControllerCreateDelegate, PinViewControllerDataSource, PinViewControllerValidateDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)pinViewController:(UIViewController *)viewController didSetNewPin:(NSString *)pin {
    NSLog(@"viewController: %@",viewController);
    [[NSUserDefaults standardUserDefaults] setObject:pin forKey:kViewControllerPin];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)touchIDActive:(UIViewController *)viewController didActiveTouchID:(BOOL)active{
    NSLog(@"viewController: %@",viewController);
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:active] forKey:kTouchIDActive];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSInteger)lengthForPin {
    return 4;
}

-(NSString *)codeForPinViewController {
    NSString *pin = [[NSUserDefaults standardUserDefaults] objectForKey:kViewControllerPin];
    return pin;
}

-(BOOL )touchIDActiveViewController{
    NSNumber *active = [[NSUserDefaults standardUserDefaults] objectForKey:kTouchIDActive];
    if(active){
        return active.boolValue;
    }
    
    return NO;
}

-(BOOL)hideTouchIDButtonIfFingersAreNotEnrolled {
    return YES;
}

-(BOOL)showTouchIDVerificationImmediately {
    return NO;
}

-(void)pinViewControllerDidSetWrongPin:(pinViewAction)action{
    
}

-(void)pinViewControllerDidSetСorrectPin:(pinViewAction)action{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)showPinAction:(UIButton *)sender {
    if([self codeForPinViewController].length > 0){
        PinViewController *vc;
        PinStyle *style = [PinStyle defaultStyle];
        style.titleText = @"Enter PIN";
        [PinViewController setNewStyle:style];
        vc = [[PinViewController alloc] initWithScope:PinViewControllerScopeValidate];
        vc.dataSourceDelegate = self;
        vc.validateDelegate = self;
        [self presentViewController:vc animated:YES completion:nil];
    }
}

- (IBAction)SettingPinAction:(UIButton *)sender {
    SettingController *vc;
    vc = [[SettingController alloc] initWithSettingsStyle:nil];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
