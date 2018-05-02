//
//  PaymentVC.m
//  UberNew
//
//  Created by Elluminati - macbook on 26/09/14.
//  Copyright (c) 2014 Jigs. All rights reserved.
//

#import "PaymentVC.h"
#import "CardIO.h"
#import "PTKView.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "AFNHelper.h"
#import "PTKTextField.h"
#import "UberStyleGuide.h"
#import "UserAddCardToken.h"
#import "AFNetworking.h"

@interface PaymentVC ()<CardIOPaymentViewControllerDelegate,PTKViewDelegate,BTDropInViewControllerDelegate>
{
    NSString *strForStripeToken,*strForLastFour;
     NSUserDefaults *prefl;
    NSDictionary *jsonObject;
    NSString *nonceStr;
   
     NSString *endingStr,*IsCardAdded;
}
@property (nonatomic, strong) BTAPIClient *braintreeClient;
@property (nonatomic, strong) NSString *clientToken;


@end

@implementation PaymentVC

#pragma mark -
#pragma mark - Init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark -
#pragma mark - ViewLife Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    prefl = [[NSUserDefaults alloc]init];
    NSLog(@"NavigationList= %@",self.navigationController.viewControllers);
    
    [super setNavBarTitle:TITLE_PAYMENT];
    //[super setBackBarItem];
    
    if ([IsCardAdded isEqualToString:@"YESADDED"])
    {
        self.btnAddPayment.enabled=YES;
    }
    else
    {
        self.btnAddPayment.enabled=NO;
    }

    /*PTKView *paymentView = [[PTKView alloc] initWithFrame:CGRectMake(15, 250, 9, 5)];
    paymentView.delegate = self;
    self.paymentView = paymentView;
    [self.view addSubview:paymentView];
    self.btnAddPayment.enabled=NO;*/
    
    self.btnMenu.titleLabel.font=[UberStyleGuide fontRegular];
   self.btnAddPayment.titleLabel.font=[UberStyleGuide fontRegularBold];
    
    [self getToken];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.btnMenu setTitle:NSLocalizedStringFromTable(@"ADD PAYMENT",[prefl objectForKey:@"TranslationDocumentName"], nil) forState:UIControlStateNormal];
    [self setLocalization];
}
-(void)setLocalization
{
    [self.btnAddPayment setTitle:NSLocalizedStringFromTable(@"ADD PAYMENT",[prefl objectForKey:@"TranslationDocumentName"],nil)forState:UIControlStateNormal];
    self.btnMenu.titleLabel.textColor =[UberStyleGuide colorDefault];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.paymentView resignFirstResponder];
}
#pragma mark - Braintree Actions
//Code for Braintree Payment
-(void)getToken
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:@"http://notanotherfruit.com/jayeentaxi/public/token_braintree" parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary *responseDict = responseObject;
        NSLog(@"responseDict: %@", responseDict);
        _clientToken = [responseObject valueForKey:@"clientToken"];
        [self Show_payment];
    }failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        NSLog(@"Product GetImage Error2: %@", error);
    }];
}
-(void)Show_payment
{
    self.braintreeClient = [[BTAPIClient alloc] initWithAuthorization:_clientToken];
    BTDropInViewController *dropInViewController = [[BTDropInViewController alloc]
                                                    initWithAPIClient:self.braintreeClient];
    dropInViewController.delegate = self;
    // Or, upon initialization
    dropInViewController.view.tintColor = [UIColor blueColor];
    BTPaymentRequest *paymentRequest = [[BTPaymentRequest alloc] init];
    paymentRequest.callToActionText = @"Add Card";
    dropInViewController.paymentRequest = paymentRequest;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]
                             initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                             target:self
                             action:@selector(userDidCancelPayment)];
    
    dropInViewController.navigationItem.leftBarButtonItem = item;
    UINavigationController *navigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:dropInViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}
//Code for Braintree Payment
#pragma Braintree Delegate
- (void)userDidCancelPayment {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)dropInViewController:(BTDropInViewController *)viewController
  didSucceedWithTokenization:(BTPaymentMethodNonce *)paymentMethodNonce {
    // Send payment method nonce to your server for processing
    NSLog(@"nonceValue is: %@", paymentMethodNonce.nonce);
    NSLog(@"type is: %@", paymentMethodNonce.type);
    NSLog(@"type is: %@", paymentMethodNonce.type.description);
    NSLog(@"type is: %@", paymentMethodNonce.localizedDescription);
    [[NSUserDefaults standardUserDefaults]setObject:paymentMethodNonce.localizedDescription forKey:@"ENDING"];
    [[NSUserDefaults standardUserDefaults]setObject:paymentMethodNonce.nonce forKey:@"NONCEVALUE"];
    //[self postNonceToServer:paymentMethodNonce.nonce];
    [self dismissViewControllerAnimated:YES completion:^{
        //self.navigationController.navigationBarHidden = YES;
        nonceStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"NONCEVALUE"];
        if(nonceStr != nil)
        {
            NSLog(@"nonceStr is:%@",nonceStr);
        }
        endingStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"ENDING"];
        if(endingStr != nil)
        {
            NSLog(@"endingStr is:%@",endingStr);
            self.btnAddPayment.enabled=YES;
            IsCardAdded = @"YESADDED";
            NSLog(@"endingStr is:%@",endingStr);
            NSLog(@"Add Card Tapped");
            
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Alert"
                                                                           message:NSLocalizedStringFromTable(@"Please Click the Add Payment Button at the Bottom in order to add the card to Server.",[prefl objectForKey:@"TranslationDocumentName"],nil)
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"OK", [prefl objectForKey:@"TranslationDocumentName"],nil) style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}
- (void)dropInViewControllerDidCancel:(__unused BTDropInViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)tappedMyPayButton {
    BTDropInViewController *dropInViewController = [[BTDropInViewController alloc]
                                                    initWithAPIClient:self.braintreeClient];
    dropInViewController.delegate = self;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]
                             initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                             target:self
                             action:@selector(userDidCancelPayment)];
    dropInViewController.navigationItem.leftBarButtonItem = item;
    UINavigationController *navigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:dropInViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

-(void)addCardOnServerNew
{
    NSUserDefaults *pref=[NSUserDefaults standardUserDefaults];
    NSString * strForUserId=[pref objectForKey:PREF_USER_ID];
    NSString * strForUserToken=[pref objectForKey:PREF_USER_TOKEN];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parameters = @{@"payment_token":nonceStr,@"last_four":endingStr,@"token":strForUserToken,@"id":strForUserId,@"card_type":@""};
    NSString *fullUrl = [NSString stringWithFormat:@"http://notanotherfruit.com/jayeentaxi/public/user/addcardtoken"];
    [manager POST:fullUrl parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        [[AppDelegate sharedAppDelegate]hideLoadingView];
        NSLog(@"responseObject is %@",responseObject);
        
        jsonObject=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"jsonObject is %@",jsonObject);
        if([[jsonObject valueForKey:@"success"] boolValue])
        {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                           message:@"Successfully Added your card."
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"OK", [prefl objectForKey:@"TranslationDocumentName"],nil) style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action)
            {
                [self.navigationController popToRootViewControllerAnimated:YES];
                                                                  }];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else
        {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Alert"
                                                                           message:NSLocalizedStringFromTable(@"Fail to add your card.",[prefl objectForKey:@"TranslationDocumentName"],nil)
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"OK", [prefl objectForKey:@"TranslationDocumentName"],nil) style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
            
        }

    }
          failure:^(NSURLSessionTask *operation, NSError *error)
    {
              NSLog(@"Error: %@", error);
          }];
}


//

- (void)postNonceToServer:(NSString *)paymentMethodNonce
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    NSDictionary *parameters = @{@"payment_method_nonce":paymentMethodNonce,@"amount":@"100",@"tripid":@"53"};
    NSString *fullUrl = [NSString stringWithFormat:@"http://notanotherfruit.com/jayeentaxi/public/user/addcardtoken"];
    [manager POST:fullUrl parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        [[AppDelegate sharedAppDelegate]hideLoadingView];
        NSLog(@"responseObject is %@",responseObject);
        
        //jsonObject=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        //NSLog(@"jsonObject is %@",jsonObject);
    }
          failure:^(NSURLSessionTask *operation, NSError *error)
    {
              NSLog(@"Error: %@", error);
          }];
    
}



#pragma mark -
#pragma mark - Actions


- (void)paymentView:(PTKView *)paymentView
           withCard:(PTKCard *)card
            isValid:(BOOL)valid
{
    // Enable save button if the Checkout is valid
    self.btnAddPayment.enabled=YES;
}
- (IBAction)scanBtnPressed:(id)sender
{
    [self scanCardClicked:self];
   /* CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
    scanViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    //scanViewController.appToken = @""; // see Constants.h
    [self presentViewController:scanViewController animated:YES completion:nil];*/
}

- (IBAction)addPaymentBtnPressed:(id)sender
{
    [[AppDelegate sharedAppDelegate]showLoadingWithTitle:NSLocalizedStringFromTable(@"Adding cards",[prefl objectForKey:@"TranslationDocumentName"], nil)];
    [self addCardOnServerNew];
    
   /* if (![self.paymentView isValid]) {
        return;
    }
    if (![Stripe defaultPublishableKey]) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"No Publishable Key"
                                                          message:@"Please specify a Stripe Publishable Key in Constants"
                                                         delegate:nil
                                                cancelButtonTitle:NSLocalizedStringFromTable(@"OK",[prefl objectForKey:@"TranslationDocumentName"], nil)
                                                otherButtonTitles:nil];
        [message show];
        return;
    }
    STPCard *card = [[STPCard alloc] init];
    card.number = self.paymentView.card.number;
    card.expMonth = self.paymentView.card.expMonth;
    card.expYear = self.paymentView.card.expYear;
    card.cvc = self.paymentView.card.cvc;
    [Stripe createTokenWithCard:card completion:^(STPToken *token, NSError *error) {
        if (error) {
            [self hasError:error];
        } else {
            [self hasToken:token];
            [self addCardOnServer];
        }
    }];*/
}

- (IBAction)backBtnPressed:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
   
}

- (void)hasError:(NSError *)error
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Alert"
                                                                   message:NSLocalizedStringFromTable(@"Error",[prefl objectForKey:@"TranslationDocumentName"],nil)
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"OK", [prefl objectForKey:@"TranslationDocumentName"],nil) style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}
/*
- (void)hasToken:(STPToken *)token
{
 
    NSLog(@"%@",token.tokenId);
    NSLog(@"%@",token.card.last4);
    
    strForLastFour=token.card.last4;
    strForStripeToken=token.tokenId;
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    return;
    
}*/

#pragma mark -
#pragma mark - CardIOPaymentViewControllerDelegate

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [CardIOUtilities preload];
}


#pragma mark - User Actions

- (void)scanCardClicked:(id)sender
{
    CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
    scanViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:scanViewController animated:YES completion:nil];
}

#pragma mark - CardIOPaymentViewControllerDelegate

- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)info inPaymentViewController:(CardIOPaymentViewController *)paymentViewController
{
    NSLog(@"Scan succeeded with info: %@", info);
    // Do whatever needs to be done to deliver the purchased items.
    [self dismissViewControllerAnimated:YES completion:nil];
    self.paymentView.cardNumberField.text =[NSString stringWithFormat:@"%@",info.cardNumber];
    self.paymentView.cardExpiryField.text=[NSString stringWithFormat:@"%02lu/%lu",(unsigned long)info.expiryMonth, (unsigned long)info.expiryYear];
    self.paymentView.cardCVCField.text=[NSString stringWithFormat:@"%@",info.cvv];
    
    NSLog(@"%@", [NSString stringWithFormat:@"Received card info. Number: %@, expiry: %02lu/%lu, cvv: %@.", info.cardNumber, (unsigned long)info.expiryMonth, (unsigned long)info.expiryYear, info.cvv]);
    //self.infoLabel.text = [NSString stringWithFormat:@"Received card info. Number: %@, expiry: %02lu/%lu, cvv: %@.", info.redactedCardNumber, (unsigned long)info.expiryMonth, (unsigned long)info.expiryYear, info.cvv];
}

- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)paymentViewController
{
    NSLog(@"User cancelled scan");
    [self dismissViewControllerAnimated:YES completion:nil];
}


/*- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)info inPaymentViewController:(CardIOPaymentViewController *)paymentViewController
{
    NSLog(@"Scan succeeded with info: %@", info);
    // Do whatever needs to be done to deliver the purchased items.
    [self dismissViewControllerAnimated:YES completion:nil];
    
    self.paymentView.cardNumberField.text =[NSString stringWithFormat:@"%@",info.redactedCardNumber];
    self.paymentView.cardExpiryField.text=[NSString stringWithFormat:@"%02lu/%lu",(unsigned long)info.expiryMonth, (unsigned long)info.expiryYear];
    self.paymentView.cardCVCField.text=[NSString stringWithFormat:@"%@",info.cvv];
    
    NSLog(@"%@", [NSString stringWithFormat:@"Received card info. Number: %@, expiry: %02lu/%lu, cvv: %@.", info.redactedCardNumber, (unsigned long)info.expiryMonth, (unsigned long)info.expiryYear, info.cvv]);
}

- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
    NSLog(@"User cancelled scan");
   [self dismissViewControllerAnimated:YES completion:nil];
}*/

#pragma mark -
#pragma mark - Memory Mgmt

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark - WS Methods

-(void)addCardOnServer
{
    
    if([[AppDelegate sharedAppDelegate]connected])
    {
        NSUserDefaults *pref=[NSUserDefaults standardUserDefaults];
        NSString * strForUserId=[pref objectForKey:PREF_USER_ID];
        NSString * strForUserToken=[pref objectForKey:PREF_USER_TOKEN];
        

        
    NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
    [dictParam setValue:strForUserToken forKey:PARAM_TOKEN];
    [dictParam setValue:strForUserId forKey:PARAM_ID];
    [dictParam setValue:strForStripeToken forKey:PARAM_STRIPE_TOKEN];
    [dictParam setValue:strForLastFour forKey:PARAM_LAST_FOUR];


    
    AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
    [afn getDataFromPath:FILE_ADD_CARD withParamData:dictParam withBlock:^(id response, NSError *error)
     {
        
         [[AppDelegate sharedAppDelegate]hideLoadingView];
         NSLog(@"Addcard Response %@",response);
        if(response)
        {
            if([[response valueForKey:@"success"] boolValue])
            {
                NSDictionary *set = response;
                UserAddCardToken *tester = [RMMapper objectWithClass:[UserAddCardToken class] fromDictionary:set];
                NSLog(@"Tdata: %@",tester.success);
                
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                               message:@"Successfully Added your card."
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"OK", [prefl objectForKey:@"TranslationDocumentName"],nil) style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * action)
                                                {
                                                    [self.navigationController popToRootViewControllerAnimated:YES];
                                                }];
                
                [alert addAction:defaultAction];
                
            }
            else
            {
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Alert"
                                                                               message:NSLocalizedStringFromTable(@"Fail to add your card.",[prefl objectForKey:@"TranslationDocumentName"],nil)
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"OK", [prefl objectForKey:@"TranslationDocumentName"],nil) style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * action) {}];
                
                [alert addAction:defaultAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
        
    }];
    }
    else
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:NSLocalizedStringFromTable(@"Network Status",[prefl objectForKey:@"TranslationDocumentName"],nil)
                                                                       message:NSLocalizedStringFromTable(@"NO_INTERNET",[prefl objectForKey:@"TranslationDocumentName"],nil)
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"OK", [prefl objectForKey:@"TranslationDocumentName"],nil) style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}


#pragma mark-
#pragma mark- Custom Font & Localization

-(void) customfont
{
    
    
}


@end
