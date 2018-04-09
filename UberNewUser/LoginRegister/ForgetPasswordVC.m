//
//  ForgetPasswordVC.m
//  UberforXOwner
//
//  Created by Deep Gami on 14/11/14.
//  Copyright (c) 2014 Jigs. All rights reserved.
//

#import "ForgetPasswordVC.h"
#import "CancelSchedule_parsing.h"

@interface ForgetPasswordVC ()

@end

@implementation ForgetPasswordVC
{
    NSUserDefaults *pref,*prefl;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    pref = [[NSUserDefaults alloc]init];
    [super setBackBarItem];
    self.btnSend=[APPDELEGATE setBoldFontDiscriptor:self.btnSend];
    self.txtEmail.font=[UberStyleGuide fontRegularBold];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self customFont];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)signBtnPressed:(id)sender
{
    if(self.txtEmail.text.length==0)
    {

        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                       message:NSLocalizedStringFromTable(@"PLEASE_EMAIL",[prefl objectForKey:@"TranslationDocumentName"],nil)
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"OK", [prefl objectForKey:@"TranslationDocumentName"],nil) style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    if(![[UtilityClass sharedObject]isValidEmailAddress:self.txtEmail.text])
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                       message:NSLocalizedStringFromTable(@"PLEASE_EMAIL",[prefl objectForKey:@"TranslationDocumentName"],nil)
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"OK", [prefl objectForKey:@"TranslationDocumentName"],nil) style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;

    }
    if([[AppDelegate sharedAppDelegate]connected])
    {
        
         [[AppDelegate sharedAppDelegate]showLoadingWithTitle:NSLocalizedStringFromTable(@"SENDING MAIL",[pref objectForKey:@"TranslationDocumentName"],nil)];
        
        NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
        [dictParam setValue:self.txtEmail.text forKey:PARAM_EMAIL];
        [dictParam setValue:@"2" forKey:@"type"];
 
        
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
        [afn getDataFromPath:FILE_FORGET_PASSWORD withParamData:dictParam withBlock:^(id response, NSError *error)
         {
             [[AppDelegate sharedAppDelegate]hideLoadingView];
             if (response)
             {
                 if([[response valueForKey:@"success"] boolValue])
                 {
                     // changed by natarajan commented unused variable......
                      // NSDictionary *set = response;
                     //CancelSchedule_parsing* tester = [RMMapper objectWithClass:[CancelSchedule_parsing class] fromDictionary:set];
                   
                     [APPDELEGATE showToastMessage:NSLocalizedStringFromTable(@"PASSWORD_SENT",[pref objectForKey:@"TranslationDocumentName"],nil)];
                     [self.navigationController popViewControllerAnimated:YES];
                 }
                 else
                 {
                     [APPDELEGATE showToastMessage:[response valueForKey:@"error"]];
                     
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

- (IBAction)backBtnPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];

}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark -
#pragma mark - Font & Color
-(void)customFont
{
    self.BtnMenu.titleLabel.textColor = [UberStyleGuide colorDefault];
    [self.btnSend setBackgroundColor: [UberStyleGuide colorDefault]];
    [self.btnSend setTitle:NSLocalizedStringFromTable(@"SEND PASSWORD", [pref objectForKey:@"TranslationDocumentName"], nil)forState:UIControlStateNormal];
    [self.forgetpassword setTitle:NSLocalizedStringFromTable(@"TITLE_FORGET_PASSWORD",[pref objectForKey:@"TranslationDocumentName"],nil)];
    
    
}


@end
