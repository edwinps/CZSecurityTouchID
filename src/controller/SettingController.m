//
//  SettingController.m
//  T21FingerPrint
//
//  Created by Edwin Peña on 19/1/17.
//  Copyright © 2017 Edwin Peña. All rights reserved.
//

#import "SettingController.h"
#import "SettingCell.h"
#import "CellDTO.h"
#import "PinViewController.h"
#import "PinAppearance.h"
#import "SettingsAppearance.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface SettingController ()<CellDTODelegate,PinViewControllerValidateDelegate,PinViewControllerCreateDelegate>
@property (strong,nonatomic) NSString *footerGroupText;
@property (strong,nonatomic) NSString *titleGroupText;
@property (strong,nonatomic) NSString *activatePinText;
@property (strong,nonatomic) NSString *deactivatePinText;
@property (strong,nonatomic) NSString *changePinText;
@property (strong,nonatomic) NSString *touchIDPinText;
@property (strong,nonatomic) NSArray *dataSource;
@property (nonatomic,strong,readonly) PinViewController * vcPinView;
@end

NSString * const kCellIdentifier = @"SettingCell";

@implementation SettingController
@synthesize vcPinView;

#pragma mark - initialization

- (instancetype)initWithSettingsAppearance:(SettingsAppearance*)appearance{
    NSBundle *budle = [NSBundle bundleForClass:[SettingController class]];
    NSLog(@"%@", budle);
    self = [super initWithNibName:NSStringFromClass([SettingController class]) bundle:budle];
    if (self) {
        if (!appearance) {
            appearance = [SettingsAppearance defaultAppearance];
            self.pinViewAppearance = [PinAppearance defaultAppearance];
        }
        self.appearance = appearance;
    }
    return self;
}

-(PinViewController *)vcPinView
{
    if (!vcPinView) {
        vcPinView = [[PinViewController alloc] initWithScope:PinViewControllerScopeCreate];
    }
    
    vcPinView.dataSourceDelegate = _delegate;
    vcPinView.validateDelegate = self;
    vcPinView.createDelegate = self;
    return vcPinView;
}

-(void)setPinViewAppearance:(PinAppearance *)pinViewAppearance{
    _pinViewAppearance = pinViewAppearance;
    if(!pinViewAppearance){
      _pinViewAppearance = [PinAppearance defaultAppearance];
    }
    [PinViewController setNewAppearance:_pinViewAppearance];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:kCellIdentifier bundle:nil] forCellReuseIdentifier:kCellIdentifier];
    [self configureView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configureView{
    _footerGroupText = @"";
    _titleGroupText = _appearance.titleGroupText;
    
    NSError   * error   = nil;
    LAContext * context = [[LAContext alloc] init];
    NSMutableArray *arrayButtons = [[NSMutableArray alloc] init];
    
    CellDTO * changeCodeButton = [[CellDTO alloc] initWithId:changePin wihtStyle:_appearance withDelegate:nil];
    CellDTO * tocheIDButton = [[CellDTO alloc] initWithId:touchIdPin wihtStyle:_appearance withDelegate:self];
    if ([self.delegate codeForPinViewController].length > 0){
        CellDTO *deactiveButton = [[CellDTO alloc] initWithId:deactivatePin wihtStyle:_appearance withDelegate:nil];
        [arrayButtons addObject:deactiveButton];
    }else{
        CellDTO * activeButton = [[CellDTO alloc] initWithId:activatePin wihtStyle:_appearance withDelegate:nil];
        [arrayButtons addObject:activeButton];
        changeCodeButton.enableCell = NO;
        tocheIDButton.enableCell = NO;
    }
    [arrayButtons addObject:changeCodeButton];
    
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        [arrayButtons addObject:tocheIDButton];
        tocheIDButton.switchOn = [_delegate touchIDActiveViewController];
        _footerGroupText = _appearance.footerGroupText;

    }
    self.dataSource = [[NSArray alloc] initWithArray:arrayButtons];
}

#pragma mark - Setter

-(void)setFooterText:(NSString *)footerText{
    _footerGroupText = footerText;
}

-(void)setTitleGroupText:(NSString *)titleGroupText{
    _titleGroupText = titleGroupText;
}

-(void)setDataSource:(NSArray *)dataSource{
    _dataSource = dataSource;
    [self.tableView reloadData];
}

-(void)setActivatePinText:(NSString *)activatePinText{
    _activatePinText = activatePin;
}

-(void)setDeactivatePinText:(NSString *)deactivatePinText{
    _deactivatePinText = deactivatePinText;
}

-(void)setChangePinText:(NSString *)changePinText{
    _changePinText = changePinText;
}

-(void)setTouchIDPinText:(NSString *)touchIDPinText{
    _touchIDPinText = touchIDPinText;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SettingCell * cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (!cell) {
        cell = [[SettingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
    }
    [cell setCellDTO:[_dataSource objectAtIndex:indexPath.row]];
    cell.delegate = self;
    return cell;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return _titleGroupText;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    return _footerGroupText;
}


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //Change the selected background view of the cell.
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CellDTO *cellDTO = [_dataSource objectAtIndex:indexPath.row];
    
    if(cellDTO.cellDTOIdentifier == activatePin){
        [self createPinAction];
    }else if (cellDTO.cellDTOIdentifier == deactivatePin){
        [self desactivePinAction];
    }else if (cellDTO.cellDTOIdentifier == changePin){
        [self changePinAction];
    }
}

#pragma mark - CellDTODelegate delegate
-(void)cellTouchId:(SettingCell*)cell didActive:(BOOL)actvie{
    [_delegate touchIDActive:self didActiveTouchID:actvie];
}

- (void)showPinAction {
    [self.vcPinView setScope:PinViewControllerScopeValidate];
    [self.navigationController pushViewController:vcPinView animated:YES];
}

- (void)changePinAction {
    [self.vcPinView setScope:PinViewControllerScopeChange];
    [self.navigationController pushViewController:vcPinView animated:YES];
}


- (void)createPinAction {
    [self.vcPinView setScope:PinViewControllerScopeCreate];
    [self.navigationController pushViewController:vcPinView animated:YES];
}

- (void)desactivePinAction {
    [self.vcPinView setScope:PinViewControllerScopeDesactive];
    [self.navigationController pushViewController:vcPinView animated:YES];

}

#pragma mark - PinViewControllerValidateDelegate

-(void)pinViewControllerDidSetWrongPin:(pinViewAction)action{
    
}

-(void)pinViewControllerDidSetСorrectPin:(pinViewAction)action{
    if(action == deactivatePin){
        [_delegate touchIDActive:self didActiveTouchID:NO];
        [_delegate pinViewController:self didSetNewPin:nil];
        [self configureView];
    }
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - PinViewControllerCreateDelegate
-(void)pinViewController:(UIViewController *)viewController didSetNewPin:(NSString *)pin{
    
    [self.navigationController popViewControllerAnimated:YES];
    [_delegate pinViewController:viewController didSetNewPin:pin];
    [self configureView];
}

-(void)touchIDActive:(UIViewController *)viewController didActiveTouchID:(BOOL)active{
    [_delegate touchIDActive:viewController didActiveTouchID:activatePin];
}

-(NSInteger)lengthForPin{
    return [_delegate lengthForPin];
}

@end
