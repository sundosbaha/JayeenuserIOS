//
//  RegisterVC.m
//  Uber
//
//  Created by Elluminati - macbook on 23/06/14.
//  Copyright (c) 2014 Elluminati MacBook Pro 1. All rights reserved.
//

#import "RegisterVC.h"
#import "MyThingsVC.h"
#import "FacebookUtility.h"
#import <GooglePlus/GooglePlus.h>
#import "AppDelegate.h"
#import "GooglePlusUtility.h"
#import "UIImageView+Download.h"
#import "AFNHelper.h"
#import "Base64.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVBase.h>
#import <AVFoundation/AVFoundation.h>
#import "UtilityClass.h"
#import "MyThingsVC.h"
#import "Constants.h"
#import "UIView+Utils.h"
#import "UberStyleGuide.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "RMUser.h"
#import "RMUserDetails.h"
#import "CancelSchedule_parsing.h"

@interface RegisterVC ()
{
    AppDelegate *appDelegate;
    NSMutableArray *arrForCountry;
    NSString *strImageData,*strForRegistrationType,*strForSocialId,*strForToken,*strForID;
    BOOL isPicAdded;
    NSMutableArray *arrOriginalData, *arrTableData, *arrTempdata;
    UITapGestureRecognizer *singleTapGestureRecognizer;
    NSUserDefaults *prefl;
}

@end

@implementation RegisterVC

#pragma mark -
#pragma mark - Init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

#pragma mark -
#pragma mark - ViewLife Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    prefl = [[NSUserDefaults alloc]init];
    [super setBackBarItem];
    [super setNavBarTitle:TITLE_REGISTER];
    
    arrForCountry=[[NSMutableArray alloc]init];
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, 500)];
    strForRegistrationType=@"manual";
    appDelegate=[AppDelegate sharedAppDelegate];
    self.viewForEmailInfo.hidden=YES;
    
    
    [self.txtSearchText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"countrycodes" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    arrOriginalData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    arrTableData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    [self.tblCountry reloadData];
    
    
    NSLocale *currentLocale = [NSLocale currentLocale];  // get the current locale.
    NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
    for (int i =0; i< [arrOriginalData count]; i++) {
        if([[[arrOriginalData objectAtIndex:i] valueForKey:@"alpha-2"] isEqualToString:countryCode]) {
            [self.btnSelectCountry setTitle:[[arrOriginalData objectAtIndex:i] valueForKey:@"phone-code"] forState:UIControlStateNormal];
            [self.btnSocialSelectCountry setTitle:[[arrOriginalData objectAtIndex:i] valueForKey:@"phone-code"] forState:UIControlStateNormal];
        }
    }
    [self.btnCheckBox setBackgroundImage:[UIImage imageNamed:@"cb_glossy_off.png"] forState:UIControlStateNormal];
    [self.btnRegister setBackgroundColor:[UIColor darkGrayColor]];
    [self.imgProPic applyRoundedCornersFullWithColor:[UIColor whiteColor]];
    
    self.btnRegister.enabled=TRUE;
    isPicAdded=NO;
    singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:singleTapGestureRecognizer];
    [self.btnSelectCountry setTitle:@"+962" forState:UIControlStateNormal];
}

-(void)viewWillAppear:(BOOL)animated
{
    [[FacebookUtility sharedObject] logOutFromFacebook];
    [self SetLocalization];
    [self customFont];
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"otp_status_key"]);
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"otp_status_key"] isEqualToString:@"otp_true_not_verified"])
    {
        [self.viewForOTP setHidden:NO];
        [self.navigationController setNavigationBarHidden:YES];
    }
}

-(void)SetLocalization
{
    [self.btnNav_Register setTitle:NSLocalizedStringFromTable(@"REGISTER", [prefl objectForKey:@"TranslationDocumentName"],nil)forState:UIControlStateNormal];
    self.lblEmailInfo.text=NSLocalizedStringFromTable(@"INFO_EMAIL", [prefl objectForKey:@"TranslationDocumentName"],nil);
    self.txtFirstName.placeholder=NSLocalizedStringFromTable(@"FIRST NAME*",[prefl objectForKey:@"TranslationDocumentName"], nil);
    self.txtLastName.placeholder=NSLocalizedStringFromTable(@"LAST NAME*",[prefl objectForKey:@"TranslationDocumentName"], nil);
    self.txtEmail.placeholder=NSLocalizedStringFromTable(@"EMAIL*", [prefl objectForKey:@"TranslationDocumentName"],nil);
    self.txtPassword.placeholder=NSLocalizedStringFromTable(@"PASSWORD*",[prefl objectForKey:@"TranslationDocumentName"], nil);
    self.txtConfirmPassword.placeholder=NSLocalizedStringFromTable(@"CONFIRM PASSWORD*",[prefl objectForKey:@"TranslationDocumentName"], nil);
    self.txtNumber.placeholder=NSLocalizedStringFromTable(@"NUMBER*",[prefl objectForKey:@"TranslationDocumentName"], nil);
    [self.btnTerm setTitle:NSLocalizedStringFromTable(@"I agree to the terms and conditions",[prefl objectForKey:@"TranslationDocumentName"], nil) forState:UIControlStateNormal];
    [self.btnRegister setTitle:NSLocalizedStringFromTable(@"Register",[prefl objectForKey:@"TranslationDocumentName"], nil) forState:UIControlStateNormal];
    [self.btnCancel setTitle:NSLocalizedStringFromTable(@"CANCEL",[prefl objectForKey:@"TranslationDocumentName"], nil) forState:UIControlStateNormal];
    [self.btnDone setTitle:NSLocalizedStringFromTable(@"Done",[prefl objectForKey:@"TranslationDocumentName"], nil) forState:UIControlStateNormal];
    self.lblSelectCountry.text=NSLocalizedStringFromTable(@"Select Country",[prefl objectForKey:@"TranslationDocumentName"], nil);
    self.txtOTP.placeholder=NSLocalizedStringFromTable(@"Enter OTP",[prefl objectForKey:@"TranslationDocumentName"], nil);
}

#pragma mark-
#pragma mark- Custom Font & Localization

-(void)viewDidLayoutSubviews
{
    [self.viewForOTP setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
}

-(void)customFont
{
    self.btnNav_Register.titleLabel.textColor = [UberStyleGuide colorDefault];
    self.btn_otpsubmit.titleLabel.textColor = [UIColor whiteColor];
    [self.btn_otpsubmit setBackgroundColor:[UberStyleGuide colorDefault]];
    [self.lblTaxiappz setBackgroundColor:[UberStyleGuide colorDefault]];
    self.lblEmailInfo.textColor = [UberStyleGuide colorDefault];
    self.txtFirstName.font=[UberStyleGuide fontRegular];
    self.txtLastName.font=[UberStyleGuide fontRegular];
    self.txtEmail.font=[UberStyleGuide fontRegular];
    self.txtPassword.font=[UberStyleGuide fontRegular];
    self.txtConfirmPassword.font=[UberStyleGuide fontRegular];
    [self.btnRegister setTitle:NSLocalizedStringFromTable(@"REGISTER",[prefl objectForKey:@"TranslationDocumentName"], nil) forState:UIControlStateNormal];
    [self.btnresendotp setTitle:NSLocalizedStringFromTable(@"Resend OTP",[prefl objectForKey:@"TranslationDocumentName"], nil) forState:UIControlStateNormal];
    [self.btnDone setTitle:NSLocalizedStringFromTable(@"Done",[prefl objectForKey:@"TranslationDocumentName"], nil) forState:UIControlStateNormal];
    [self.btnCancel setTitle:NSLocalizedStringFromTable(@"CANCEL",[prefl objectForKey:@"TranslationDocumentName"], nil) forState:UIControlStateNormal];
    [self.btn_otpsubmit setTitle:NSLocalizedStringFromTable(@"SUBMIT",[prefl objectForKey:@"TranslationDocumentName"], nil) forState:UIControlStateNormal];
    [self.btnNav_Register setTitle:NSLocalizedStringFromTable(@"REGISTER",[prefl objectForKey:@"TranslationDocumentName"], nil) forState:UIControlStateNormal];
    [self.lblsitback setText:NSLocalizedStringFromTable(@"Sitbacklrelax_text",[prefl objectForKey:@"TranslationDocumentName"], nil)];
    [self.lblTaxiappz setText:NSLocalizedStringFromTable(@"TITLE_APP_NAME",[prefl objectForKey:@"TranslationDocumentName"], nil)];
    [self.lblplsenterotp setText:NSLocalizedStringFromTable(@"Please enter the OTP below",[prefl objectForKey:@"TranslationDocumentName"], nil)];
    [self.lblenteryourphonenumber setText:NSLocalizedStringFromTable(@"PH_PHONE_NUMBER",[prefl objectForKey:@"TranslationDocumentName"], nil)];
    [self.lblEmailInfo setText:NSLocalizedStringFromTable(@"INFO_EMAIL",[prefl objectForKey:@"TranslationDocumentName"], nil)];
    [self.lblSelectCountry setText:NSLocalizedStringFromTable(@"Select Country",[prefl objectForKey:@"TranslationDocumentName"], nil)];
    self.btnNav_Register=[APPDELEGATE setBoldFontDiscriptor:self.btnNav_Register];
    self.btnRegister=[APPDELEGATE setBoldFontDiscriptor:self.btnRegister];
}

#pragma mark -
#pragma mark - UIPickerView Delegate and Datasource

- (void)pickerView:(UIPickerView *)pV didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if([pV tag] == 0)
    {
        [self.btnSelectCountry setTitle:[[arrForCountry objectAtIndex:row] valueForKey:@"phone-code"] forState:UIControlStateNormal];
    }
    else
    {
        [self.btnSocialSelectCountry setTitle:[[arrForCountry objectAtIndex:row] valueForKey:@"phone-code"] forState:UIControlStateNormal];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return arrForCountry.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *strForTitle=[NSString stringWithFormat:@"%@  %@",[[arrForCountry objectAtIndex:row] valueForKey:@"phone-code"],[[arrForCountry objectAtIndex:row] valueForKey:@"name"]];
    return strForTitle;
}
#pragma mark -
#pragma mark - Memory Mgmt

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark - UITextField Delegate
-(void)handleSingleTapGesture:(UITapGestureRecognizer *)tapGestureRecognizer;
{
    [self.txtFirstName resignFirstResponder];
    [self.txtLastName resignFirstResponder];
    [self.txtEmail resignFirstResponder];
    [self.txtPassword resignFirstResponder];
    [self.txtConfirmPassword resignFirstResponder];
    [self.txtNumber resignFirstResponder];
    [self.txtAddress resignFirstResponder];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.txtFirstName resignFirstResponder];
    [self.txtLastName resignFirstResponder];
    [self.txtEmail resignFirstResponder];
    [self.txtPassword resignFirstResponder];
    [self.txtConfirmPassword resignFirstResponder];
    [self.txtNumber resignFirstResponder];
    [self.txtAddress resignFirstResponder];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField==self.txtNumber || textField==self.txtZipCode)
    {
        NSCharacterSet *nonNumberSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
        return ([string stringByTrimmingCharactersInSet:nonNumberSet].length > 0) || [string isEqualToString:@""];
    }
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGPoint offset;
    if(textField==self.txtFirstName)
    {
        offset=CGPointMake(0, 50);
        [self.scrollView setContentOffset:offset animated:YES];
    }
    if(textField==self.txtLastName)
    {
        offset=CGPointMake(0, 80);
        [self.scrollView setContentOffset:offset animated:YES];
    }
    if(textField==self.txtEmail)
    {
        offset=CGPointMake(0, 110);
        [self.scrollView setContentOffset:offset animated:YES];
    }
    if(textField==self.txtPassword)
    {
        offset=CGPointMake(0, 170);
        [self.scrollView setContentOffset:offset animated:YES];
    }
    if(textField==self.txtConfirmPassword)
    {
        offset=CGPointMake(0, 210);
        [self.scrollView setContentOffset:offset animated:YES];
    }
    else if(textField==self.txtNumber)
    {
        offset=CGPointMake(0, 240);
        [self.scrollView setContentOffset:offset animated:YES];
    }
    else if(textField==self.txtAddress)
    {
        offset=CGPointMake(0, 350);
        [self.scrollView setContentOffset:offset animated:YES];
    }
    else if(textField==self.txtBio)
    {
        offset=CGPointMake(0, 390);
        [self.scrollView setContentOffset:offset animated:YES];
    }
    else if(textField==self.txtZipCode)
    {
        offset=CGPointMake(0, 430);
        [self.scrollView setContentOffset:offset animated:YES];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    CGPoint offset;
    offset=CGPointMake(0, 0);
    [self.scrollView setContentOffset:offset animated:YES];
    
    if(textField==self.txtFirstName)
        [self.txtLastName becomeFirstResponder];
    else if(textField==self.txtLastName)
        [self.txtEmail becomeFirstResponder];
    else if(textField==self.txtEmail)
        [self.txtPassword becomeFirstResponder];
    else if(textField==self.txtPassword)
        [self.txtConfirmPassword becomeFirstResponder];
    else if(textField==self.txtConfirmPassword)
        [self.txtNumber becomeFirstResponder];
    else if(textField == self.txtSearchText)
        if (textField.text.length == 0) {
            arrTableData = [NSMutableArray arrayWithArray:arrOriginalData];
            [self.tblCountry reloadData];
            [textField resignFirstResponder];

    }
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -
#pragma mark - UIButton Action

-(IBAction)EdiTProfile:(id)sender
{
    if([APPDELEGATE connected])
    {
        NSUserDefaults *pref=[NSUserDefaults standardUserDefaults];
        NSMutableDictionary *dictparam=[[NSMutableDictionary alloc]init];
        [dictparam setValue:[pref objectForKey:PREF_USER_ID] forKey:@"ownerid"];
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
        [afn getDataFromPath:@"temp_user" withParamData:dictparam withBlock:^(id response, NSError *error)
         {
             NSLog(@"Request= %@",response);
             if (response) {
                 if([[response valueForKey:@"success"] intValue]==1)
                 {
                     
                     
                     [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"otp_status_key"];
                     [self.viewForOTP setHidden:YES];
                     [self.navigationController setNavigationBarHidden:NO];
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

- (IBAction)pickerCancelBtnPressed:(id)sender
{
    self.viewForPicker.hidden=YES;
}
- (IBAction)pickerDoneBtnPressed:(id)sender
{
    self.viewForPicker.hidden=YES;
}
-(void)getFacebookProfileInfos {
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me"
                                       parameters:@{@"fields": @"picture, email, first_name, last_name"}]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
    {
         if (!error)
         {
             self.txtEmail.text = [result objectForKey:@"email"];
             self.txtFirstName.text = [result objectForKey:@"first_name"];
             self.txtLastName.text = [result objectForKey:@"last_name"];
             strForSocialId=[result valueForKey:@"id"];
             NSData  *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[result objectForKey:@"data"] valueForKey:@"url"]]];
             self.imgProPic.image = [UIImage imageWithData:data];
             [self.viewforPhone setHidden:NO];
         }
         else
         {
             NSLog(@"%@", [error localizedDescription]);
         }
     }];
}

-(IBAction)FinishFBRegistration:(id)sender
{
    [self resignFirstResponder];
    if ([self.txtSocialPhone.text length]==0)
    {
        [APPDELEGATE showToastMessage:@"Phone Number is mandatory"];
        return;
    }
    [self resignFirstResponder];
    [[AppDelegate sharedAppDelegate]showLoadingWithTitle:NSLocalizedStringFromTable(@"Registering",[prefl objectForKey:@"TranslationDocumentName"], nil)];
    NSString *strnumber=[NSString stringWithFormat:@"%@%@",self.btnSocialSelectCountry.titleLabel.text,self.txtSocialPhone.text];
    NSUserDefaults *pref=[NSUserDefaults standardUserDefaults];
    NSString *strDeviceId=[pref objectForKey:PREF_DEVICE_TOKEN];
    NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
    [dictParam setValue:self.txtEmail.text forKey:PARAM_EMAIL];
    [dictParam setValue:self.txtFirstName.text forKey:PARAM_FIRST_NAME];
    [dictParam setValue:self.txtLastName.text forKey:PARAM_LAST_NAME];
    [dictParam setValue:strnumber forKey:PARAM_PHONE];
    [dictParam setValue:strDeviceId forKey:PARAM_DEVICE_TOKEN];
    [dictParam setValue:@"ios" forKey:PARAM_DEVICE_TYPE];
    [dictParam setValue:@"" forKey:PARAM_BIO];
    [dictParam setValue:@"" forKey:PARAM_ADDRESS];
    [dictParam setValue:@"" forKey:PARAM_STATE];
    [dictParam setValue:@"" forKey:PARAM_COUNTRY];
    [dictParam setValue:@"" forKey:PARAM_ZIPCODE];
    [dictParam setValue:strForRegistrationType forKey:PARAM_LOGIN_BY];
    
    if([strForRegistrationType isEqualToString:@"facebook"])
        [dictParam setValue:strForSocialId forKey:PARAM_SOCIAL_UNIQUE_ID];
    else if ([strForRegistrationType isEqualToString:@"google"])
        [dictParam setValue:strForSocialId forKey:PARAM_SOCIAL_UNIQUE_ID];
    else
        [dictParam setValue:self.txtPassword.text forKey:PARAM_PASSWORD];
    
    if(isPicAdded==YES)
    {
        UIImage *imgUpload = [[UtilityClass sharedObject]scaleAndRotateImage:self.imgProPic.image];
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
        [afn getDataFromPath:FILE_REGISTER withParamDataImage:dictParam andImage:imgUpload withBlock:^(id response, NSError *error) {
            [[AppDelegate sharedAppDelegate]hideLoadingView];
            if (response)
            {
                if([[response valueForKey:@"success"] boolValue])
                {
                    [APPDELEGATE showToastMessage:NSLocalizedStringFromTable(@"REGISTER_SUCCESS",[prefl objectForKey:@"TranslationDocumentName"], nil)];
                    strForID=[response valueForKey:@"id"];
                    strForToken=[response valueForKey:@"token"];
                    [pref setObject:response forKey:PREF_LOGIN_OBJECT];
                    [pref setObject:[response valueForKey:@"token"] forKey:PREF_USER_TOKEN];
                    [pref setObject:[response valueForKey:@"phone"] forKey:PREF_MOBILE_NO];
                    [pref setObject:[response valueForKey:@"id"] forKey:PREF_USER_ID];
                    [pref setObject:[response valueForKey:@"is_referee"] forKey:PREF_IS_REFEREE];
                    [pref setBool:YES forKey:PREF_IS_LOGIN];
                    if([[response valueForKey:@"otp_status"] boolValue])
                    {
                        [self.viewForOTP setHidden:NO];//OTP
                        [self.navigationController setNavigationBarHidden:YES];
                        [[NSUserDefaults standardUserDefaults] setObject:@"otp_true_not_verified" forKey:@"otp_status_key"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                    else
                    {
                        [self performSegueWithIdentifier:SEGUE_TO_APPLY_REFERRAL_CODE sender:self];
                        [[NSUserDefaults standardUserDefaults] setObject:@"otp_false_verified" forKey:@"otp_status_key"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                    [pref synchronize];
                    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"otp_status_key"]);
                }
                else
                {
                    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                                   message:[response valueForKey:@"error"]
                                                                            preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"OK", [prefl objectForKey:@"TranslationDocumentName"],nil) style:UIAlertActionStyleDefault
                                                                          handler:^(UIAlertAction * action)
                                                    {
                                                        
                                                    }];
                    [alert addAction:defaultAction];
                    [self presentViewController:alert animated:YES completion:nil];
                }
            }
            NSLog(@"REGISTER RESPONSE --> %@",response);
        }];
    }
    else
    {
        NSLog(@"not profile");
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
        NSLog(@"Parameter Check ---> %@",dictParam);
        [afn getDataFromPath:FILE_REGISTER withParamData:dictParam withBlock:^(id response, NSError *error)
        {
            [[AppDelegate sharedAppDelegate]hideLoadingView];
            if (response)
            {
                if([[response valueForKey:@"success"] boolValue])
                {
                    [APPDELEGATE showToastMessage:NSLocalizedStringFromTable(@"REGISTER_SUCCESS",[prefl objectForKey:@"TranslationDocumentName"], nil)];
                    strForID=[response valueForKey:@"id"];
                    strForToken=[response valueForKey:@"token"];
                    [pref setObject:response forKey:PREF_LOGIN_OBJECT];
                    
                    [pref setObject:[response valueForKey:@"token"] forKey:PREF_USER_TOKEN];
                    [pref setObject:[response valueForKey:@"id"] forKey:PREF_USER_ID];
                    [pref setObject:[response valueForKey:@"phone"] forKey:PREF_MOBILE_NO];
                    [pref setObject:[response valueForKey:@"is_referee"] forKey:PREF_IS_REFEREE];
                    [pref setBool:YES forKey:PREF_IS_LOGIN];
                    if([[response valueForKey:@"otp_status"] boolValue])
                    {
                        [self.viewForOTP setHidden:NO];//OTP
                        [self.navigationController setNavigationBarHidden:YES];
                        [[NSUserDefaults standardUserDefaults] setObject:@"otp_true_not_verified" forKey:@"otp_status_key"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                    else
                    {
                        [self performSegueWithIdentifier:SEGUE_TO_APPLY_REFERRAL_CODE sender:self];
                        [[NSUserDefaults standardUserDefaults] setObject:@"otp_false_verified" forKey:@"otp_status_key"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        
                    }
                    [pref synchronize];
                    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"otp_status_key"]);
                }
                else
                {
                    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                                   message:[NSString stringWithFormat:@"%@",[[response objectForKey:@"error_messages"] objectAtIndex:0]]
                                                                            preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"OK", [prefl objectForKey:@"TranslationDocumentName"],nil) style:UIAlertActionStyleDefault
                                                                          handler:^(UIAlertAction * action)
                                                    {
                                                        
                                                    }];
                    [alert addAction:defaultAction];
                    [self presentViewController:alert animated:YES completion:nil];
                }
            }
            NSLog(@"REGISTER RESPONSE --> %@",response);
        }];
    }
}


- (IBAction)fbbtnPressed:(id)sender
{
    strForRegistrationType=@"facebook";
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    //    NSArray *arraPermissions = [NSArray arrayWithObjects:@"public_profile",@"email",@"user_friends",@"user_location", nil];
    [login logInWithReadPermissions: @[@"public_profile"] fromViewController:self
                            handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                if (error) {
                                    NSLog(@"Process error");
                                } else if (result.isCancelled) {
                                    NSLog(@"Cancelled");
                                } else {
                                    NSLog(@"Logged in");
                                    [self getFacebookProfileInfos];
                                }
                            }];
    
    /*
     if (![[FacebookUtility sharedObject]isLogin])
     {
     [[FacebookUtility sharedObject]loginInFacebook:^(BOOL success, NSError *error)
     {
     [APPDELEGATE hideLoadingView];
     if (success)
     {
     self.txtPassword.userInteractionEnabled=NO;
     self.txtConfirmPassword.userInteractionEnabled=NO;
     NSLog(@"Success");
     appDelegate = [UIApplication sharedApplication].delegate;
     [appDelegate userLoggedIn];
     [[FacebookUtility sharedObject]fetchMeWithFBCompletionBlock:^(id response, NSError *error) {
     if (response) {
     NSLog(@"FB Response ->%@",response);
     strForSocialId=[response valueForKey:@"id"];
     self.txtEmail.text=[response valueForKey:@"email"];
     NSArray *arr=[[response valueForKey:@"name"] componentsSeparatedByString:@" "];
     self.txtFirstName.text=[arr objectAtIndex:0];
     self.txtLastName.text=[arr objectAtIndex:1];
     
     [self.imgProPic downloadFromURL:[response valueForKey:@"link"] withPlaceholder:nil];
     NSString *userImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [response objectForKey:@"id"]];
     [self.imgProPic downloadFromURL:userImageURL withPlaceholder:nil];
     isPicAdded=YES;
     }
     }];
     }
     }];
     }
     else{
     NSLog(@"User Login Click");
     appDelegate = [UIApplication sharedApplication].delegate;
     [[FacebookUtility sharedObject]fetchMeWithFBCompletionBlock:^(id response, NSError *error) {
     [APPDELEGATE hideLoadingView];
     if (response) {
     NSLog(@"FB Response ->%@ ",response);
     strForSocialId=[response valueForKey:@"id"];
     
     self.txtEmail.text=[response valueForKey:@"email"];
     NSArray *arr=[[response valueForKey:@"name"] componentsSeparatedByString:@" "];
     self.txtFirstName.text=[arr objectAtIndex:0];
     self.txtLastName.text=[arr objectAtIndex:1];
     
     [self.imgProPic downloadFromURL:[response valueForKey:@"link"] withPlaceholder:nil];
     NSString *userImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [response objectForKey:@"id"]];
     [self.imgProPic downloadFromURL:userImageURL withPlaceholder:nil];
     isPicAdded=YES;
     }
     }];
     [appDelegate userLoggedIn];
     }
     */
}

- (IBAction)proPicBtnPressed:(id)sender
{
//    UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
//    UIActionSheet *actionpass;
//    
//    actionpass = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"CANCEL",[prefl objectForKey:@"TranslationDocumentName"], nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedStringFromTable(@"SELECT_PHOTO",[prefl objectForKey:@"TranslationDocumentName"], nil),NSLocalizedStringFromTable(@"TAKE_PHOTO", [prefl objectForKey:@"TranslationDocumentName"], nil),nil];
//    [actionpass showInView:window];

    UIAlertController * alert=[UIAlertController alertControllerWithTitle:nil
                                                                  message:nil
                                                           preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* cancelButton = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"CANCEL",[prefl objectForKey:@"TranslationDocumentName"], nil)
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * action)
                                   {
                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                   }];
    UIAlertAction* selectPhotoButton = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"SELECT_PHOTO", [prefl objectForKey:@"TranslationDocumentName"], nil)
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action)
                                        {
                                            [self selectPhotos];
                                        }];
    UIAlertAction* takePhotoButton = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"TAKE_PHOTO", [prefl objectForKey:@"TranslationDocumentName"], nil)
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * action)
                                      {
                                          [self takePhoto];
                                      }];

    [alert addAction:selectPhotoButton];
    [alert addAction:takePhotoButton];
    [alert addAction:cancelButton];
    [self presentViewController:alert animated:YES completion:nil];

}

- (IBAction)selectCountryBtnPressed:(id)sender
{
//    CGPoint offset;
//    offset=CGPointMake(0, 0);
//    [self.scrollView setContentOffset:offset animated:YES];
//    [self.txtAddress resignFirstResponder];
//    [self.txtFirstName resignFirstResponder];
//    [self.txtLastName resignFirstResponder];
//    [self.txtEmail resignFirstResponder];
//    [self.txtPassword resignFirstResponder];
//    [self.txtConfirmPassword resignFirstResponder];
//    [self.txtZipCode resignFirstResponder];
//    [self.txtBio resignFirstResponder];
//    [self.txtSocialPhone resignFirstResponder];
//    
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"countrycodes" ofType:@"json"];
//    NSData *data = [NSData dataWithContentsOfFile:filePath];
//    arrForCountry = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
//    [self.pickerView reloadAllComponents];
//    self.viewForPicker.hidden=NO;
//    [self.pickerView setTag:0];
    [self resignFirstResponder];
    
     [self.view removeGestureRecognizer:singleTapGestureRecognizer];
     [self.viewforCountrySearch setHidden:NO];
}

-(IBAction)selectCountryforSocialbtnPressed:(id)sender
{
    [self.txtSocialPhone resignFirstResponder];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"countrycodes" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    arrForCountry = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    [self.pickerView reloadAllComponents];
    self.viewForPicker.hidden=NO;
    [self.pickerView setTag:1];
}

- (IBAction)googleBtnPressed:(id)sender
{
    strForRegistrationType=@"google";
    if ([[GooglePlusUtility sharedObject]isLogin])
    {
    }
    else
    {
        [[GooglePlusUtility sharedObject]loginWithBlock:^(id response, NSError *error)
         {
             [APPDELEGATE hideLoadingView];
             if (response)
             {
                 self.txtPassword.userInteractionEnabled=NO;
                 self.txtConfirmPassword.userInteractionEnabled=NO;
                 NSLog(@"Gmail Response ->%@ ",response);
                 strForSocialId=[response valueForKey:@"userid"];
                 self.txtEmail.text=[response valueForKey:@"email"];
                 NSArray *arr=[[response valueForKey:@"name"] componentsSeparatedByString:@" "];
                 self.txtFirstName.text=[arr objectAtIndex:0];
                 self.txtLastName.text=[arr objectAtIndex:1];
                 [self.imgProPic downloadFromURL:[response valueForKey:@"profile_image"] withPlaceholder:nil];
                 isPicAdded=YES;
             }
         }];
    }
}

- (IBAction)nextBtnPressed:(id)sender
{
    if([[AppDelegate sharedAppDelegate]connected])
    {
        if(self.txtFirstName.text.length<1 || self.txtLastName.text.length<1 || self.txtEmail.text.length<1 || self.txtNumber.text.length<1 ||self.txtPassword.text.length<6 ||self.txtConfirmPassword.text.length<6)
        {
            if(self.txtFirstName.text.length<1)
            {
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                               message:NSLocalizedStringFromTable(@"PLEASE_FIRST_NAME",[prefl objectForKey:@"TranslationDocumentName"], nil)
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"OK", [prefl objectForKey:@"TranslationDocumentName"],nil) style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * action)
                                                {
                                                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                                }];
                [alert addAction:defaultAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
            else if(self.txtLastName.text.length<1)
            {
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                               message:NSLocalizedStringFromTable(@"PLEASE_LAST_NAME",[prefl objectForKey:@"TranslationDocumentName"], nil)
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"OK", [prefl objectForKey:@"TranslationDocumentName"],nil) style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * action)
                                                {
                                                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                                }];
                [alert addAction:defaultAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
            else if(self.txtEmail.text.length<1)
            {
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                               message:NSLocalizedStringFromTable(@"PLEASE_EMAIL",[prefl objectForKey:@"TranslationDocumentName"], nil)
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"OK", [prefl objectForKey:@"TranslationDocumentName"],nil) style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * action)
                                                {
                                                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                                }];
                [alert addAction:defaultAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
            else if(self.txtNumber.text.length<1)
            {
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                               message:NSLocalizedStringFromTable(@"PLEASE_NUMBER",[prefl objectForKey:@"TranslationDocumentName"], nil)
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"OK", [prefl objectForKey:@"TranslationDocumentName"],nil) style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * action)
                                                {
                                                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                                }];
                [alert addAction:defaultAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
            else if (self.txtPassword.text.length<6)
            {
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                               message:NSLocalizedStringFromTable(@"PLEASE_PASSWORD_LENGTH",[prefl objectForKey:@"TranslationDocumentName"], nil)
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"OK", [prefl objectForKey:@"TranslationDocumentName"],nil) style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * action)
                                                {
                                                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                                }];
                [alert addAction:defaultAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
            else if (self.txtConfirmPassword.text.length==0)
            {
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                               message:NSLocalizedStringFromTable(@"PLEASE_TYPE_CONFIRM_PASSWORD_LENGTH",[prefl objectForKey:@"TranslationDocumentName"], nil)
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"OK", [prefl objectForKey:@"TranslationDocumentName"],nil) style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * action)
                                                {
                                                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                                }];
                [alert addAction:defaultAction];
                [self presentViewController:alert animated:YES completion:nil];

            }
            else if (![self.txtPassword.text isEqualToString:self.txtConfirmPassword.text])
            {
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                               message:NSLocalizedStringFromTable(@"PASSWORD_MISMATCH",[prefl objectForKey:@"TranslationDocumentName"], nil)
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"OK", [prefl objectForKey:@"TranslationDocumentName"],nil) style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * action)
                                                {
                                                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                                }];
                [alert addAction:defaultAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
        else
        {
            if([[UtilityClass sharedObject]isValidEmailAddress:self.txtEmail.text])
            {
                [[AppDelegate sharedAppDelegate]showLoadingWithTitle:NSLocalizedStringFromTable(@"Registering", [prefl objectForKey:@"TranslationDocumentName"], nil)];
                NSString *strnumber=[NSString stringWithFormat:@"%@%@",self.btnSelectCountry.titleLabel.text,self.txtNumber.text];
                NSUserDefaults *pref=[NSUserDefaults standardUserDefaults];
                NSString *strDeviceId=[pref objectForKey:PREF_DEVICE_TOKEN];
                NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
                [dictParam setValue:self.txtEmail.text forKey:PARAM_EMAIL];
                [dictParam setValue:self.txtFirstName.text forKey:PARAM_FIRST_NAME];
                [dictParam setValue:self.txtLastName.text forKey:PARAM_LAST_NAME];
                [dictParam setValue:strnumber forKey:PARAM_PHONE];
                [dictParam setValue:strDeviceId forKey:PARAM_DEVICE_TOKEN];
                [dictParam setValue:@"ios" forKey:PARAM_DEVICE_TYPE];
                [dictParam setValue:@"" forKey:PARAM_BIO];
                [dictParam setValue:@"" forKey:PARAM_ADDRESS];
                [dictParam setValue:@"" forKey:PARAM_STATE];
                [dictParam setValue:@"" forKey:PARAM_COUNTRY];
                [dictParam setValue:@"" forKey:PARAM_ZIPCODE];
                [dictParam setValue:strForRegistrationType forKey:PARAM_LOGIN_BY];
                
                if([strForRegistrationType isEqualToString:@"facebook"])
                    [dictParam setValue:strForSocialId forKey:PARAM_SOCIAL_UNIQUE_ID];
                else if ([strForRegistrationType isEqualToString:@"google"])
                    [dictParam setValue:strForSocialId forKey:PARAM_SOCIAL_UNIQUE_ID];
                else
                    [dictParam setValue:self.txtPassword.text forKey:PARAM_PASSWORD];
                
                if(isPicAdded==YES)
                {
                    UIImage *imgUpload = [[UtilityClass sharedObject]scaleAndRotateImage:self.imgProPic.image];
                    AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
                    [afn getDataFromPath:FILE_REGISTER withParamDataImage:dictParam andImage:imgUpload withBlock:^(id response, NSError *error) {
                        NSLog(@"Response%@",response);
                        RMUserDetails *getrooms = [RMMapper objectWithClass:[RMUserDetails class] fromDictionary:response];
                        NSDictionary *getDict = (NSDictionary *) getrooms.user;
                        RMUser *getUser = [RMMapper objectWithClass:[RMUser class] fromDictionary:getDict];
                        NSLog(@"test%@",getUser.phone);
                        [[AppDelegate sharedAppDelegate]hideLoadingView];
                        if (response)
                        {
                            if([[response valueForKey:@"success"] boolValue])
                            {
                                [APPDELEGATE showToastMessage:NSLocalizedStringFromTable(@"REGISTER_SUCCESS",[prefl objectForKey:@"TranslationDocumentName"], nil)];
                                strForID=getUser.id;
                                strForToken=getUser.token;
                                [pref setObject:[response valueForKey:@"user"] forKey:PREF_LOGIN_OBJECT];
                                [pref setObject:getUser.token forKey:PREF_USER_TOKEN];
                                [pref setObject:getUser.phone forKey:PREF_MOBILE_NO];
                                [pref setObject:getUser.id forKey:PREF_USER_ID];
                                [pref setObject:getUser.is_referee forKey:PREF_IS_REFEREE];
                                [pref setBool:YES forKey:PREF_IS_LOGIN];
                                if([getUser.otp_status boolValue])
                                {
                                    [self.viewForOTP setHidden:NO];//OTP
                                    [self.navigationController setNavigationBarHidden:YES];
                                    [[NSUserDefaults standardUserDefaults] setObject:@"otp_true_not_verified" forKey:@"otp_status_key"];
                                    [[NSUserDefaults standardUserDefaults] synchronize];
                                }
                                else
                                {
                                    [self performSegueWithIdentifier:SEGUE_TO_APPLY_REFERRAL_CODE sender:self];
                                    [[NSUserDefaults standardUserDefaults] setObject:@"otp_false_verified" forKey:@"otp_status_key"];
                                    [[NSUserDefaults standardUserDefaults] synchronize];
                                }
                                [pref synchronize];
                                NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"otp_status_key"]);
                            }
                            else
                            {
                                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                                               message:[response valueForKey:@"error"]
                                                                                        preferredStyle:UIAlertControllerStyleAlert];
                                
                                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"OK", [prefl objectForKey:@"TranslationDocumentName"],nil) style:UIAlertActionStyleDefault
                                                                                      handler:^(UIAlertAction * action) {}];
                                
                                [alert addAction:defaultAction];
                                [self presentViewController:alert animated:YES completion:nil];
                            }
                        }
                        NSLog(@"REGISTER RESPONSE --> %@",response);
                    }];
                }
                else
                {
                    NSLog(@"not profile");
                    AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
                    NSLog(@"Parameter Check ---> %@",dictParam);
                    [afn getDataFromPath:FILE_REGISTER withParamData:dictParam withBlock:^(id response, NSError *error) {
                        [[AppDelegate sharedAppDelegate]hideLoadingView];
                        if (response)
                        {
                            NSLog(@"Response%@",response);
                            RMUserDetails *getrooms = [RMMapper objectWithClass:[RMUserDetails class] fromDictionary:response];
                            NSDictionary *getDict = (NSDictionary *) getrooms.user;
                            RMUser *getUser = [RMMapper objectWithClass:[RMUser class] fromDictionary:getDict];
                            NSLog(@"test%@",getUser.phone);
                            if([[response valueForKey:@"success"] boolValue])
                            {
                                [APPDELEGATE showToastMessage:NSLocalizedStringFromTable(@"REGISTER_SUCCESS", [prefl objectForKey:@"TranslationDocumentName"], nil)];
                                strForID=[response valueForKey:@"id"];
                                strForToken=[response valueForKey:@"token"];
                                [pref setObject:[response valueForKey:@"user"] forKey:PREF_LOGIN_OBJECT];
                                [pref setObject:getUser.token forKey:PREF_USER_TOKEN];
                                [pref setObject:getUser.id forKey:PREF_USER_ID];
                                [pref setObject:getUser.phone forKey:PREF_MOBILE_NO];
                                [pref setObject:getUser.is_referee forKey:PREF_IS_REFEREE];
                                [pref setBool:YES forKey:PREF_IS_LOGIN];
                                if([getUser.otp_status boolValue])
                                {
                                    [self.viewForOTP setHidden:NO];//OTP
                                    [self.navigationController setNavigationBarHidden:YES];
                                    [[NSUserDefaults standardUserDefaults] setObject:@"otp_true_not_verified" forKey:@"otp_status_key"];
                                    [[NSUserDefaults standardUserDefaults] synchronize];
                                }
                                else
                                {
                                    [self performSegueWithIdentifier:SEGUE_TO_APPLY_REFERRAL_CODE sender:self];
                                    [[NSUserDefaults standardUserDefaults] setObject:@"otp_false_verified" forKey:@"otp_status_key"];
                                    [[NSUserDefaults standardUserDefaults] synchronize];
                                }
                                [pref synchronize];
                                NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"otp_status_key"]);
                            }
                            else
                            {
                                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                                               message:[response valueForKey:@"error"]
                                                                                        preferredStyle:UIAlertControllerStyleAlert];
                                
                                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"OK", [prefl objectForKey:@"TranslationDocumentName"],nil) style:UIAlertActionStyleDefault
                                                                                      handler:^(UIAlertAction * action) {}];
                                [alert addAction:defaultAction];
                                [self presentViewController:alert animated:YES completion:nil];
                            }
                        }
                        NSLog(@"REGISTER RESPONSE --> %@",response);
                    }];
                }
            }
            else
            {
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                               message:NSLocalizedStringFromTable(@"PLEASE_VALID_EMAIL",[prefl objectForKey:@"TranslationDocumentName"], nil)
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"OK", [prefl objectForKey:@"TranslationDocumentName"],nil) style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * action) {}];
                [alert addAction:defaultAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
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

-(IBAction)OTPSubmit:(id)sender
{
    if(self.txtOTP.text.length >0)
    {
        [[AppDelegate sharedAppDelegate]showLoadingWithTitle:NSLocalizedStringFromTable(@"Verifying OTP",[prefl objectForKey:@"TranslationDocumentName"], nil)];
        NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
        NSUserDefaults *pref=[NSUserDefaults standardUserDefaults];
        [dictParam setValue:[pref objectForKey:PREF_USER_ID] forKey:@"ownerid"];
        [dictParam setValue:self.txtOTP.text forKey:@"otpkey"];
        
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
        [afn getDataFromPath:FILE_OTP withParamData:dictParam withBlock:^(id response, NSError *error) {
            [[AppDelegate sharedAppDelegate]hideLoadingView];
            if (response)
            {
                if([[response valueForKey:@"success"] boolValue])
                {
                    [[NSUserDefaults standardUserDefaults] setObject:@"otp_true_verified" forKey:@"otp_status_key"];
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:PREF_IS_LOGIN];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [self.navigationController setNavigationBarHidden:NO];
                    [self performSegueWithIdentifier:SEGUE_TO_APPLY_REFERRAL_CODE sender:self];
                }
                else
                {
                    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                                   message:[response valueForKey:@"error"]
                                                                            preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"OK", [prefl objectForKey:@"TranslationDocumentName"],nil) style:UIAlertActionStyleDefault
                                                                          handler:^(UIAlertAction * action) {}];
                    [alert addAction:defaultAction];
                    [self presentViewController:alert animated:YES completion:nil];
                }
                NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"otp_status_key"]);
            }
        }];
    }
    else
        [[AppDelegate sharedAppDelegate] showToastMessage:@"Must enter OTP"];
}

-(IBAction)ResendOTPAction:(id)sender
{
    [[AppDelegate sharedAppDelegate]showLoadingWithTitle:NSLocalizedStringFromTable(@"Resending OTP",[prefl objectForKey:@"TranslationDocumentName"], nil)];
    NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
    NSUserDefaults *pref=[NSUserDefaults standardUserDefaults];
    [dictParam setValue:[pref objectForKey:PREF_USER_ID] forKey:@"ownerid"];
    AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
    [afn getDataFromPath:FILE_RESEND_OTP withParamData:dictParam withBlock:^(id response, NSError *error)
    {
        [[AppDelegate sharedAppDelegate]hideLoadingView];
        if (response)
        {
            if([[response valueForKey:@"success"] boolValue])
            {
                [[AppDelegate sharedAppDelegate]showToastMessage:@"OTP sent"];
            }
            else
            {
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                               message:[response valueForKey:@"error"]
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"OK", [prefl objectForKey:@"TranslationDocumentName"],nil) style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * action) {}];
                [alert addAction:defaultAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
    }];
}

- (IBAction)btnEmailInfoClick:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    if(btn.tag==0)
    {
        btn.tag=1;
        self.viewForEmailInfo.hidden=NO;
    }
    else
    {
        btn.tag=0;
        self.viewForEmailInfo.hidden=YES;
    }
}

- (IBAction)checkBoxBtnPressed:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    if(btn.tag == 0)
    {
        btn.tag=1;
        [btn setBackgroundImage:[UIImage imageNamed:@"cb_glossy_on.png"] forState:UIControlStateNormal];
        [self.btnRegister setBackgroundColor:[UIColor blackColor]];
        self.btnRegister.enabled=TRUE;
    }
    else
    {
        btn.tag=0;
        [btn setBackgroundImage:[UIImage imageNamed:@"cb_glossy_off.png"] forState:UIControlStateNormal];
        [self.btnRegister setBackgroundColor:[UIColor darkGrayColor]];
        self.btnRegister.enabled=TRUE;
    }
}

- (IBAction)termsBtnPressed:(id)sender
{
    [self performSegueWithIdentifier:@"pushToTerms" sender:self];
}

#pragma mark
#pragma mark - Action to Share

- (void)selectPhotos
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType =UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.allowsEditing=YES;
    [self presentViewController:imagePickerController animated:YES completion:^{
    }];
}

-(void)takePhoto
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.sourceType =UIImagePickerControllerSourceTypeCamera;
        imagePickerController.allowsEditing=YES;
        [self presentViewController:imagePickerController animated:YES completion:^{
            
        }];
    }
    else
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                       message:NSLocalizedStringFromTable(@"CAM_NOT_AVAILABLE",[prefl objectForKey:@"TranslationDocumentName"], nil)
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"OK", [prefl objectForKey:@"TranslationDocumentName"],nil) style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark
#pragma mark - ImagePickerDelegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if([info valueForKey:UIImagePickerControllerEditedImage]==nil)
    {
        ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
        [assetLibrary assetForURL:[info valueForKey:UIImagePickerControllerReferenceURL] resultBlock:^(ALAsset *asset) {
            ALAssetRepresentation *rep = [asset defaultRepresentation];
            Byte *buffer = (Byte*)malloc(rep.size);
            NSUInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:rep.size error:nil];
            NSData *data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];//
            UIImage *img=[UIImage imageWithData:data];
            [self setImage:img];
        } failureBlock:^(NSError *err) {
            NSLog(@"Error: %@",[err localizedDescription]);
        }];
    }
    else
    {
        [self setImage:[info valueForKey:UIImagePickerControllerEditedImage]];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)setImage:(UIImage *)image
{
    self.imgProPic.image=image;
    isPicAdded=YES;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrTableData count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@  %@",[[arrTableData objectAtIndex:indexPath.row] valueForKey:@"phone-code"],[[arrTableData objectAtIndex:indexPath.row] valueForKey:@"name"]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.btnSelectCountry setTitle:[[arrTableData objectAtIndex:indexPath.row] valueForKey:@"phone-code"] forState:UIControlStateNormal];
    [self.btnSocialSelectCountry setTitle:[[arrTableData objectAtIndex:indexPath.row] valueForKey:@"phone-code"] forState:UIControlStateNormal];
    [self.viewforCountrySearch setHidden:YES];
    [self.view addGestureRecognizer:singleTapGestureRecognizer];
    [self.txtSearchText resignFirstResponder];
    self.txtSearchText.text = @"";
}

-(void)textFieldDidChange :(UITextField *) textField{
    if (textField.text.length>0)
    {
        NSPredicate *bPredicate = [NSPredicate predicateWithFormat:@"SELF.name CONTAINS[cd] %@",textField.text];
        arrTableData = [[NSMutableArray alloc] init];
        arrTableData = [(NSArray*)[arrOriginalData filteredArrayUsingPredicate:bPredicate] mutableCopy];
    }
    else
    {
        arrTableData = [NSMutableArray arrayWithArray:arrOriginalData];
    }
    [self.tblCountry reloadData];
}

-(IBAction)cancelsearBtnaction:(id)sender
{
    [self.txtSearchText resignFirstResponder];
    self.txtSearchText.text = @"";
    [self.viewforCountrySearch setHidden:YES];
}

@end
