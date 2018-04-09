//
//  WalletVC.h
//  Jayeentaxi
//
//  Created by Spextrum on 22/05/17.
//  Copyright © 2017 Jigs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Constants.h"
#import "AFNHelper.h"
#import "BaseVC.h"
#import "AFNetworking.h"
#import "KPDropMenu.h"
#import "KLCPopup.h"

@interface WalletVC : BaseVC<KPDropMenuDelegate>


@property (weak, nonatomic) IBOutlet UIImageView *ImageWallet;
@property (weak, nonatomic) IBOutlet UILabel *LblAvailableAmount;
@property (weak, nonatomic) IBOutlet UIButton *BtnAddingMoney;
- (IBAction)BtnAddMoney:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *BtnWalletNavigation;
@property (weak, nonatomic) IBOutlet UIView *BGView;
@property (weak, nonatomic) IBOutlet UIView *ViewforAddMoney;
@property (weak, nonatomic) IBOutlet UITextField *TxtFieldAmount;
@property (weak, nonatomic) IBOutlet UIButton *BtnAdd;
- (IBAction)BtnAddAmount:(id)sender;
- (IBAction)BtnCanel:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *CancelBtn;
@property (weak, nonatomic) IBOutlet KPDropMenu *ViewForCardsList;

@end
