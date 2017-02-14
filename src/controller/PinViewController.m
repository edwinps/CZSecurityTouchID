//
//  PinViewController.m
//  T21FingerPrint
//
//  Created by Edwin Peña on 19/1/17.
//  Copyright © 2017 Edwin Peña. All rights reserved.
//

#import "PinViewController.h"

#import "PinButton.h"
#import "PinView.h"
#import "PinAppearance.h"
#import <AudioToolbox/AudioToolbox.h>
#import <LocalAuthentication/LocalAuthentication.h>

static PinAppearance *appearance;

@interface PinViewController ()<CAAnimationDelegate>

@property (nonatomic, strong) PinAppearance *appearance;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *supportLabel;
@property (strong, nonatomic) IBOutletCollection(PinButton) NSArray *numberButtons;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIView *viewForPins;
@property (weak, nonatomic) IBOutlet UIImageView *imageLogo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewForPinsLayoutConstraint;

@property (nonatomic, strong) NSString *currentPin;
@property (nonatomic, strong) NSString *comfirmationPin;
@property (nonatomic, assign) BOOL enable;
@property (nonatomic, assign) BOOL touchIDPassedValidation;
@property (nonatomic) BOOL errorPin;
@end

@implementation PinViewController

#pragma mark - Public

+ (PinAppearance *)appearance {
    return appearance;
}

+ (void)setNewAppearance:(PinAppearance *)newAppearance {
    appearance = newAppearance;
}

#pragma mark - initialization

- (instancetype)initWithScope:(PinViewControllerScope)scope {
    NSBundle *budle = [NSBundle bundleForClass:[PinViewController class]];
    NSLog(@"%@", budle);
    self = [super initWithNibName:NSStringFromClass([PinViewController class]) bundle:budle];
    if (self) {
        _scope = scope;
        if (!appearance) {
            appearance = [PinAppearance defaultAppearance];
        }
        _appearance = appearance;
    }
    return self;
}

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureView];
    self.navigationController.navigationBar.topItem.title = @"";
    [self setupInitialState];
    [self clearCurrentPin];
    [self createPinView];
    
}

-(void)setupInitialState {
    self.enable = YES;
    self.touchIDPassedValidation = NO;

    
    if ([self.dataSourceDelegate respondsToSelector:@selector(showTouchIDVerificationImmediately)]) {
        BOOL immediately = [self.dataSourceDelegate showTouchIDVerificationImmediately];
        if (immediately) {
            [self touchIDVerification];
        }
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)setScope:(PinViewControllerScope)scope{
    _scope = scope;
    [self viewDidLoad];
    if(scope == PinViewControllerScopeCreate){
        self.titleLabel.text = _appearance.createNewPinTitleText;
    }else{
        self.titleLabel.text = _appearance.titleText;
    }
}

-(void)configureView {
    for (PinButton *button in self.numberButtons) {
        [button setTintColor:_appearance.numberButtonColor];
        [button setTitleColor:_appearance.numberButtonTitleColor forState:UIControlStateNormal];
        [button setTitleColor:_appearance.numberButtonTitleColor forState:UIControlStateSelected];
        [button setTitleColor:_appearance.numberButtonTitleColor forState:UIControlStateHighlighted];
        button.strokeColor = _appearance.numberButtonStrokeColor;
        button.strokeWidth = _appearance.numberButtonStrokeWitdh;
        button.strokeColor = _appearance.numberButtonstrokeEnabled ? [_appearance numberButtonStrokeColor] : [UIColor clearColor];
        [button.titleLabel setFont:_appearance.numberButtonFont];
        [button setNeedsDisplay];
    }
    
    NSBundle *bundle = [NSBundle bundleForClass:[PinViewController class]];
    UIImage *deleteButtonImage = [UIImage imageNamed:@"sc_img_delete" inBundle:bundle compatibleWithTraitCollection:nil];
    [self.deleteButton setImage:deleteButtonImage forState:UIControlStateNormal];
    [self.deleteButton setTintColor:_appearance.deleteButtonColor];
    self.titleLabel.text = _appearance.titleText;
    self.titleLabel.font = _appearance.titleTextFont;
    self.titleLabel.textColor = _appearance.titleTextColor;
    self.supportLabel.text = _appearance.supportText;
    self.supportLabel.font = _appearance.supportTextFont;
    self.supportLabel.textColor = _appearance.supportTextColor;
    [self.supportLabel setHidden:YES];
    [self.imageLogo setImage:_appearance.logo];
    self.view.backgroundColor = _appearance.backgroundColor;
}

-(void)changeColorView {
 
    for (PinButton *button in self.numberButtons) {
        button.strokeColor = _errorPin ? _appearance.strokeErrorColor :_appearance.numberButtonStrokeColor;
        [button setNeedsDisplay];
    }
    for(PinView *view in self.viewForPins.subviews){
        view.strokeColor = _errorPin ?_appearance.strokeErrorColor : _appearance.pinStrokeColor;
        view.fillColor = _errorPin ?_appearance.strokeErrorColor : _appearance.pinStrokeColor;
        view.highlightedColor = _errorPin ?_appearance.strokeErrorColor : _appearance.pinHighlightedColor;
        [view setNeedsDisplay];
    }
    [self createPinView2];
    [self.deleteButton setTintColor: _errorPin ?_appearance.strokeErrorColor : _appearance.deleteButtonColor];
    self.titleLabel.textColor = _errorPin ? _appearance.strokeErrorColor : _appearance.titleTextColor;
    self.supportLabel.textColor = _errorPin ? _appearance.strokeErrorColor : _appearance.supportTextColor;
}

-(void)createPinView2 {
    NSInteger length;
    NSInteger currentPinLength = [self.currentPin length];
    switch (self.scope) {
        case PinViewControllerScopeCreate: {
            length = [self.createDelegate lengthForPin];
            break;
        }
        case PinViewControllerScopeValidate: {
            NSString *pin = [self.dataSourceDelegate codeForPinViewController];
            length = [pin length];
            break;
        }
        case PinViewControllerScopeChange: {
            NSString *pin = [self.dataSourceDelegate codeForPinViewController];
            length = [pin length];
            break;
        }
        case PinViewControllerScopeDesactive: {
            NSString *pin = [self.dataSourceDelegate codeForPinViewController];
            length = [pin length];
            break;
        }
        default:
            break;
    }
    
    CGFloat width = _appearance.pinSize.width;
    CGFloat distance = 15.0f;
    
    CGFloat pinWidth = (length * width) + ((length - 1) * distance);
    CGFloat center = CGRectGetWidth(self.viewForPins.frame) / 2;
    CGFloat x = center - (pinWidth / 2);
    
    for (UIView *view in self.viewForPins.subviews) {
        [view removeFromSuperview];
    }
    
    for (NSInteger index = 0; index<length; index++) {
        PinView *view = [[PinView alloc]initWithFrame:CGRectMake(x, 0, _appearance.pinSize.width, _appearance.pinSize.height)];
        
        view.fillColor = _appearance.pinFillColor;
        view.highlightedColor = _appearance.strokeErrorColor;
        view.strokeColor = _appearance.strokeErrorColor;
        view.strokeWidth = _appearance.pinStrokeWidth;
        
        if (self.touchIDPassedValidation) {
            view.highlighted = YES;
        } else if (currentPinLength <= index) {
            view.highlighted = NO;
        } else {
            view.highlighted = YES;
        }
        
        [self.viewForPins addSubview:view];
        x+= (distance + width);
    }
}

-(void)clearCurrentPin {
    self.currentPin = @"";
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self rotateTransform];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self rotateTransform];
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self createPinView];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    CGAffineTransform t = self.view.transform;
    if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation) && t.b && t.c) {
        [self.view setTransform:CGAffineTransformMakeRotation(0)];
    }
}

#pragma mark - Controller logic

-(void)rotateTransform{
    CGAffineTransform rotateTransform;
    switch ([UIApplication sharedApplication].statusBarOrientation) {
        case UIDeviceOrientationLandscapeLeft:
            rotateTransform = CGAffineTransformMakeRotation(-90*M_PI/180.0);
            rotateTransform = CGAffineTransformTranslate(rotateTransform, +90.0, +90.0);
            [self.view setTransform:rotateTransform];
            break;
        case UIDeviceOrientationLandscapeRight:
            rotateTransform = CGAffineTransformMakeRotation(90*M_PI/180.0);
            rotateTransform = CGAffineTransformTranslate(rotateTransform, +90.0, +90.0);
            [self.view setTransform:rotateTransform];
            break;
            
        default:
            rotateTransform = CGAffineTransformMakeRotation(0);
            break;
    }
}

-(void)reEnterPin{
    [self viewDidLoad];
    self.titleLabel.text = _appearance.reEnterPinTitleText;
}

-(void)noMathPin{
    [self wrongPin];
    [self.supportLabel setHidden:NO];
}

-(void)createNewPin{
    _scope = PinViewControllerScopeCreate;
    _comfirmationPin = nil;
    [self viewDidLoad];
    self.titleLabel.text = _appearance.changeTitleText;
}

-(void)createPinView {
    NSInteger length;
    NSInteger currentPinLength = [self.currentPin length];
    switch (self.scope) {
        case PinViewControllerScopeCreate: {
            length = [self.createDelegate lengthForPin];
            break;
        }
        case PinViewControllerScopeValidate: {
            NSString *pin = [self.dataSourceDelegate codeForPinViewController];
            length = [pin length];
            break;
        }
        case PinViewControllerScopeChange: {
            NSString *pin = [self.dataSourceDelegate codeForPinViewController];
            length = [pin length];
            break;
        }
        case PinViewControllerScopeDesactive: {
            NSString *pin = [self.dataSourceDelegate codeForPinViewController];
            length = [pin length];
            break;
        }
        default:
            break;
    }
    
    CGFloat width = _appearance.pinSize.width;
    CGFloat distance = 15.0f;
    
    CGFloat pinWidth = (length * width) + ((length - 1) * distance);
    CGFloat center = CGRectGetWidth(self.viewForPins.frame) / 2;
    CGFloat x = center - (pinWidth / 2);
    
    for (UIView *view in self.viewForPins.subviews) {
        [view removeFromSuperview];
    }
    
    for (NSInteger index = 0; index<length; index++) {
        PinView *view = [[PinView alloc]initWithFrame:CGRectMake(x, 0, _appearance.pinSize.width, _appearance.pinSize.height)];
        
        view.fillColor = _errorPin ?_appearance.strokeErrorColor : _appearance.pinFillColor;
        view.highlightedColor = _appearance.pinHighlightedColor;
        view.strokeColor = _errorPin ?_appearance.strokeErrorColor : _appearance.pinStrokeColor;
        view.strokeWidth = _appearance.pinStrokeWidth;
        
        if (self.touchIDPassedValidation) {
            view.highlighted = YES;
        } else if (currentPinLength <= index) {
            view.highlighted = NO;
        } else {
            view.highlighted = YES;
        }
        
        [self.viewForPins addSubview:view];
        x+= (distance + width);
    }
}

- (void)appendingPincode:(NSString *)pincode {
    NSString * appended = [self.currentPin stringByAppendingString:pincode];
    NSUInteger length;
    switch (self.scope) {
        case PinViewControllerScopeCreate: {
            length = MIN([appended length], [self.createDelegate lengthForPin]);
            break;
        }
        case PinViewControllerScopeValidate: {
            length = MIN([appended length], [[self.dataSourceDelegate codeForPinViewController] length]);
            break;
        }
        case PinViewControllerScopeChange: {
            length = MIN([appended length], [[self.dataSourceDelegate codeForPinViewController] length]);
            break;
        }
        case PinViewControllerScopeDesactive: {
            length = MIN([appended length], [[self.dataSourceDelegate codeForPinViewController] length]);
            break;
        }
        default:
            break;
    }
    
    self.currentPin = [appended substringToIndex:length];
    [self createPinView];
}

- (void)removeLastPincode {
    NSUInteger index = ([self.currentPin length] - 1);
    if ([self.currentPin length] > index) {
        self.currentPin = [self.currentPin substringToIndex:index];
    }
    [self createPinView];
}

-(void)setCurrentPin:(NSString *)currentPin {
    _currentPin = currentPin;
    
    switch (self.scope) {
        case PinViewControllerScopeValidate:{
            BOOL equalLength = ([currentPin length] == [[self.dataSourceDelegate codeForPinViewController] length] && [currentPin length] > 0 );
            if (equalLength) {
                [self validatePin:currentPin];
            }
            break;
        }
        case PinViewControllerScopeChange:{
            BOOL equalLength = ([currentPin length] == [[self.dataSourceDelegate codeForPinViewController] length]);
            if (equalLength) {
                [self validatePin:currentPin];
            }
            break;
        }
        case PinViewControllerScopeCreate: {
            if ([currentPin length] == [self.createDelegate lengthForPin]) {
                if(_comfirmationPin.length > 0){
                    if([_comfirmationPin isEqualToString:currentPin]){
                        [self.createDelegate pinViewController:self didSetNewPin:_comfirmationPin];
                        _comfirmationPin = nil;
                    }else{
                        [self noMathPin];
                    }
                }else {
                    _comfirmationPin = currentPin;
                    [self reEnterPin];
                }
                
            }
            break;
        }
        case PinViewControllerScopeDesactive:{
            BOOL equalLength = ([currentPin length] == [[self.dataSourceDelegate codeForPinViewController] length] && [currentPin length] > 0 );
            if (equalLength) {
                [self validatePin:currentPin];
            }
            break;
        }
        default:
            break;
    }
}

-(void)validatePin:(NSString *)pin {
    if ([[self.dataSourceDelegate codeForPinViewController] isEqualToString:pin]) {
        [self correctPin];
        
    } else {
        [self wrongPin];
    }
}

-(void)correctPin {
    if(_scope == PinViewControllerScopeChange){
        [self createNewPin];
    }else{
        if ([self.validateDelegate respondsToSelector:@selector(pinViewControllerDidSetСorrectPin:)]) {
            if(_scope == PinViewControllerScopeDesactive){
                [self.validateDelegate pinViewControllerDidSetСorrectPin:deactivatePin];
            }else{
                [self.validateDelegate pinViewControllerDidSetСorrectPin:showPin];
            }
        }
    }
}

- (void)wrongPin {
    __weak PinViewController *weakSelf = self;
    _errorPin = YES;
    [self changeColorView];
    self.enable = NO;
    NSTimeInterval delay = 0.25f;
    dispatch_time_t delayInSeconds = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(delayInSeconds, dispatch_get_main_queue(), ^(void){
        __strong PinViewController *strongSelf = weakSelf;
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        CAAnimation * shake = [self makeShakeAnimation];
        [strongSelf.viewForPins.layer addAnimation:shake forKey:@"shake"];
        if ([strongSelf.validateDelegate respondsToSelector:@selector(pinViewControllerDidSetWrongPin:)]) {
            [strongSelf.validateDelegate pinViewControllerDidSetWrongPin:showPin];
        }
        [strongSelf clearCurrentPin];
        [strongSelf createPinView];
        strongSelf.enable = YES;
    });
    
}

- (CAAnimation *)makeShakeAnimation {
    CAKeyframeAnimation * shake = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    [shake setValue:@"shake" forKey:@"makeShakeAnimation"];
    [shake setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [shake setDuration:0.5f];
    [shake setDelegate:self];
    [shake setValues:@[ @(-20), @(20), @(-15), @(15), @(-10), @(10), @(-5), @(5), @(0) ]];
    return shake;
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag{
    
    NSString* value = [theAnimation valueForKey:@"makeShakeAnimation"];
    if ([value isEqualToString:@"shake"])
    {
        _errorPin = NO;
        [self changeColorView];
        [self createPinView];
        return;
    }
}


-(BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (UIInterfaceOrientationMask) supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(toInterfaceOrientation);
}

- (void)touchIDVerification {
    
    NSError   * error   = nil;
    LAContext * context = [[LAContext alloc] init];
    context.localizedFallbackTitle = @"";
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        __weak PinViewController *weakSelf = self;
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                localizedReason:_appearance.touchIDVerification
                          reply:^(BOOL success, NSError * authenticationError) {
                              if (success) {
                                  __strong PinViewController *strongSelf = weakSelf;
                                  
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      strongSelf.touchIDPassedValidation = YES;
                                      [strongSelf createPinView];
                                      if ([strongSelf.validateDelegate respondsToSelector:@selector(pinViewControllerDidSetСorrectPin:)]) {
                                          [strongSelf.validateDelegate pinViewControllerDidSetСorrectPin:showPin];
                                      }
                                  });
                              } else {
                                  NSLog(@"Authentication Error: %@", authenticationError);
                              }
                          }];
    } else {
        NSLog(@"Policy Error: %@", [error localizedDescription]);
    }
    
}

#pragma mark - Actions

- (IBAction)tapPinButtonAction:(PinButton *)sender {
    if (!self.enable) {
        return;
    }
    NSInteger number = [sender tag];
    [self appendingPincode:[@(number) description]];
    AudioServicesPlaySystemSound(0x450);
    
}


- (IBAction)deleteButtonAction:(UIButton *)sender {
    [self removeLastPincode];
    AudioServicesPlaySystemSound(0x450);
    
}

@end

