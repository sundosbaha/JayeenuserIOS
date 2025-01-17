//
//  PaymentVC.h
//  UberNew
//
//  Created by Elluminati - macbook on 26/09/14.
//  Copyright (c) 2014 Jigs. All rights reserved.
//

#import "BaseVC.h"
#import "CardIOPaymentViewControllerDelegate.h"
#import "PTKView.h"
#import "BraintreeUI.h"
#import "BraintreeCore.h"
#import "BraintreeDropIn.h"
#import "BraintreeUIKit.h"
#import "BraintreeCard.h"


@interface PaymentVC : BaseVC<UITextFieldDelegate,UIAlertViewDelegate,BTDropInViewControllerDelegate>
{
    
}

///////// Actions


- (IBAction)scanBtnPressed:(id)sender;
- (IBAction)addPaymentBtnPressed:(id)sender;
- (IBAction)backBtnPressed:(id)sender;


///////// Property

@property (nonatomic,strong) NSString *strForID;
@property (nonatomic,strong) NSString *strForToken;

///// Outlets

@property (weak, nonatomic) IBOutlet UIButton *btnAddPayment;
@property(weak, nonatomic) PTKView *paymentView;
@property (weak, nonatomic) IBOutlet UIButton *btnMenu;
@property (weak, nonatomic) IBOutlet UIButton *btnscancard;

@end
