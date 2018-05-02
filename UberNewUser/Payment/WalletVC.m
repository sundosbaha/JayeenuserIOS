//
//  WalletVC.m
//  Jayeentaxi
//
//  Created by Spextrum on 22/05/17.
//  Copyright © 2017 Jigs. All rights reserved.
//

#import "WalletVC.h"

@interface WalletVC ()

@end

@implementation WalletVC
{
    NSMutableArray *arrForCards;
    NSString *card_id;
    NSUserDefaults *prefl,*pref;
    NSArray *LastFour,*CardID;
    NSDictionary *CardDict;
    NSMutableArray *stringArray;
    NSString *SelectedCardID;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self CustomSetup];
    [APPDELEGATE showLoadingWithTitle:@"Getting the Available Amount in Your Wallet please Wait"];
    [self GetAvailableAmountinWallet];
        // Do any additional setup after loading the view.
}


-(void)CustomSetup
{
    [self.ViewforAddMoney.layer setCornerRadius:5.0];
    [self.BtnAdd.layer setCornerRadius:5.0];
    [self.CancelBtn.layer setCornerRadius:5.0];
    [super setBackBarItem];
    [self.BGView setHidden:YES];
    [self.ViewforAddMoney setHidden:YES];
    prefl = [NSUserDefaults standardUserDefaults];
    pref = [NSUserDefaults standardUserDefaults];
    [self.BtnAddingMoney setTitle:NSLocalizedStringFromTable(@"Add_Money",[prefl objectForKey:@"TranslationDocumentName"], nil) forState:UIControlStateNormal];
}

#pragma mark - KPDropMenu Delegate Methods

-(void)didSelectItem : (KPDropMenu *) dropMenu atIndex : (int) atIntedex
{
    NSLog(@"Hi Selected iTem %@", dropMenu.items[atIntedex]);
    SelectedCardID = [dropMenu.items[atIntedex] substringFromIndex:45];
     NSLog(@"Hi Selected Card ID %@", SelectedCardID);
  //    if(dropMenu == _ViewForCardsList)
//        NSLog(@"%@ with TAG : %ld", dropMenu.items[atIntedex], (long)dropMenu.tag);
//    else
//        NSLog(@"%@", dropMenu.items[atIntedex]);
}

-(void)didShow:(KPDropMenu *)dropMenu
{
    NSLog(@"didShow");
}

-(void)didHide:(KPDropMenu *)dropMenu
{
    NSLog(@"didHide");
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)GetAvailableAmountinWallet
{
    
    NSString * strForUserId=[pref objectForKey:PREF_USER_ID];
    NSString * strForUserToken=[pref objectForKey:PREF_USER_TOKEN];
    NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
    
    [dictParam setObject:strForUserId forKey:@"id"];
    [dictParam setObject:strForUserToken forKey:@"token"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:@"http://notanotherfruit.com/jayeentaxi/public/user/get_amt" parameters:dictParam progress:nil success:^(NSURLSessionTask *task, id responseObject)
    {
        [APPDELEGATE showLoadingWithTitle:@""];
        NSLog(@"Available Amount in Wallet: %@", responseObject);
        NSString *NetAmountAvailable = [NSString stringWithFormat:@"$ %.2f",[[responseObject valueForKey:@"balance_amt" ]floatValue]];
        [self.LblAvailableAmount setText:NetAmountAvailable];
        [APPDELEGATE hideLoadingView];
        
    }
    failure:^(NSURLSessionTask *operation, NSError *error)
    {
        NSLog(@"Error: %@", error);
        [[AppDelegate sharedAppDelegate]hideLoadingView];
        
    }];

}


-(void)getAllMyCards
{
    if([[AppDelegate sharedAppDelegate]connected])
    {
        NSString * strForUserId=[pref objectForKey:PREF_USER_ID];
        NSString * strForUserToken=[pref objectForKey:PREF_USER_TOKEN];
        
        
        NSMutableString *pageUrl=[NSMutableString stringWithFormat:@"%@?%@=%@&%@=%@",FILE_GET_CARDS,PARAM_ID,strForUserId,PARAM_TOKEN,strForUserToken];
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:GET_METHOD];
        [afn getDataFromPath:pageUrl withParamData:nil withBlock:^(id response, NSError *error)
         {
             if (response)
             {
                 if([[response valueForKey:@"success"] intValue]==1)
                 {
                   NSLog(@"Card Details Data= %@",response);
                   NSLog(@"Detail 1 = %@",[response valueForKey:@"payments"]);
             
                     [APPDELEGATE hideLoadingView];
                     arrForCards = [response valueForKey:@"payments"];
                     stringArray = [[NSMutableArray alloc] init];
                     for (CardDict in arrForCards)
                     {
                         [stringArray addObject:[NSString stringWithFormat:@"  %@                                 %d",[CardDict valueForKey:@"last_four"],[[CardDict valueForKey:@"id"] integerValue]]];
                         
                         //LastFour = [CardDict valueForKey:@"last_four"];
                        // CardID = [CardDict valueForKey:@"card_id"];
                         NSLog(@"Card Digits= %@",stringArray);
                        //
                     }
                     _ViewForCardsList.items = [[NSMutableArray alloc]initWithArray:stringArray copyItems:YES];
                     _ViewForCardsList.itemsFont = [UIFont fontWithName:@"Helvetica-Regular" size:12.0];
                     _ViewForCardsList.titleTextAlignment = NSTextAlignmentCenter;
                     _ViewForCardsList.delegate = self;

                    
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
    [APPDELEGATE hideLoadingView];
}

-(void)AddMoneyToWAllet
{
    NSString * strForUserId=[pref objectForKey:PREF_USER_ID];
    NSString * strForUserToken=[pref objectForKey:PREF_USER_TOKEN];
    NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
    
    [dictParam setObject:strForUserId forKey:@"id"];
    [dictParam setObject:strForUserToken forKey:@"token"];
    [dictParam setObject:self.TxtFieldAmount.text forKey:@"amount"];
    [dictParam setObject:[NSNumber numberWithInt:[SelectedCardID integerValue]] forKey:@"card_id"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:@"http://notanotherfruit.com/jayeentaxi/public/user/add_wallet" parameters:dictParam progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         
         [APPDELEGATE showLoadingWithTitle:@""];
         NSLog(@"Adding Amount in Wallet: %@", responseObject);
         [APPDELEGATE hideLoadingView];
         [self GetAvailableAmountinWallet];
         UIAlertController * alert=[UIAlertController
                                    
                                    alertControllerWithTitle:NSLocalizedStringFromTable(@"Success", [prefl objectForKey:@"TranslationDocumentName"], nil) message:NSLocalizedStringFromTable(@"Amount_Added", [prefl objectForKey:@"TranslationDocumentName"], nil)preferredStyle:UIAlertControllerStyleAlert];
         
         UIAlertAction* yesButton = [UIAlertAction
                                     actionWithTitle:NSLocalizedStringFromTable(@"OK", [prefl objectForKey:@"TranslationDocumentName"], nil)
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                                     {
                                         
                                     }];
         [alert addAction:yesButton];
         [self presentViewController:alert animated:YES completion:nil];
         return;

         
     }
          failure:^(NSURLSessionTask *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
         [[AppDelegate sharedAppDelegate]hideLoadingView];
         
     }];

}

- (IBAction)BtnAddMoney:(id)sender
{
    [self.BGView setHidden:NO];
    [self.ViewforAddMoney setHidden:NO];
    [self getAllMyCards];
}

- (IBAction)BtnAddAmount:(id)sender
{
    if (self.TxtFieldAmount.text.length == 0)
    {
        UIAlertController * alert=[UIAlertController
                                   
                                   alertControllerWithTitle:NSLocalizedStringFromTable(@"Alert", [prefl objectForKey:@"TranslationDocumentName"], nil) message:NSLocalizedStringFromTable(@"Please_Amount", [prefl objectForKey:@"TranslationDocumentName"], nil)preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        
                                    }];
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    else
    {
        [self AddMoneyToWAllet];
        [self.BGView setHidden:YES];
        [self.ViewforAddMoney setHidden:YES];
    }
}

- (IBAction)BtnCanel:(id)sender
{
    [self.BGView setHidden:YES];
    [self.ViewforAddMoney setHidden:YES];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.TxtFieldAmount resignFirstResponder];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/




@end
