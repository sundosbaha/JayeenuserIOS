//
//  RightSideSlider.m
//  Jayeentaxi
//
//  Created by Spextrum on 22/05/17.
//  Copyright © 2017 Jigs. All rights reserved.
//

#import "RightSideSlider.h"
#import "Constants.h"
#import "SWRevealViewController.h"
#import "PickUpVC.h"
#import "CellSlider.h"
#import "HistoryVC.h"
#import "AboutVC.h"
#import "PaymentVC.h"
#import "ProfileVC.h"
#import "PromotionsVC.h"
#import "ContactUsVC.h"
#import "UIView+Utils.h"
#import "UIImageView+Download.h"
#import "UberStyleGuide.h"
#import "AppDelegate.h"
#import "AFNHelper.h"
#import "Provider_Logout.h"




@interface RightSideSlider ()
{
    NSMutableArray *arrListName,*arrIdentifire, *arrSlider,*arrImages;
    NSMutableString *strUserId;
    NSMutableString *strUserToken;
    NSString *strContent;
    NSUserDefaults *prefl;
}

@end

@implementation RightSideSlider

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleUpdatedData:)
                                                 name:@"DataUpdated"
                                               object:nil];
    
    arrSlider=[[NSMutableArray alloc]initWithObjects:NSLocalizedStringFromTable(@"Profile", [prefl objectForKey:@"TranslationDocumentName"], nil),NSLocalizedStringFromTable(@"History",[prefl objectForKey:@"TranslationDocumentName"],nil),NSLocalizedStringFromTable(@"Payment", [prefl objectForKey:@"TranslationDocumentName"], nil),NSLocalizedStringFromTable(@"Schedule", [prefl objectForKey:@"TranslationDocumentName"], nil),nil ];//@"Promotions",@"Logout", nil];
    arrImages=[[NSMutableArray alloc]initWithObjects:@"nav_profile",@"ub__nav_history",@"nav_payment",@"ub__nav_history",nil];
    
    self.tblMenu.backgroundView=nil;
    self.tblMenu.backgroundColor=[UIColor clearColor];
    [self.imgProfilePic applyRoundedCornersFullWithColor:[UIColor whiteColor]];
    NSUserDefaults *pref=[NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dictInfo=[pref objectForKey:PREF_LOGIN_OBJECT];
    
    [self.imgProfilePic downloadFromURL:[dictInfo valueForKey:@"picture"] withPlaceholder:nil];
    self.lblName.font=[UberStyleGuide fontRegular:18.0f];
    self.lblName.text=[NSString stringWithFormat:@"%@ %@",[dictInfo valueForKey:@"first_name"],[dictInfo valueForKey:@"last_name"]];
    arrIdentifire=[[NSMutableArray alloc]initWithObjects:SEGUE_PROFILE,SEGUE_TO_HISTORY,SEGUE_PAYMENT,SEGUE_TO_SCHEDULE, nil];
    
    NSMutableArray *arrTemp=[[NSMutableArray alloc]init];
    NSMutableArray *arrImg=[[NSMutableArray alloc]init];

    // changed by natarajan commented the loop

//    for (int i=0; i<arrPage.count; i++)
//    {
//        NSMutableDictionary *temp1=[arrPage objectAtIndex:i];
////        [arrTemp addObject:[NSString stringWithFormat:@"  %@",[temp1 valueForKey:@"title"]]];
////        [arrImg addObject:@"nav_about"];
//    }
    
    [arrSlider addObjectsFromArray:arrTemp];
    [arrIdentifire addObjectsFromArray:arrTemp];
    [arrIdentifire addObject:SEGUE_TO_REFERRAL_CODE];
    
    [arrImages addObjectsFromArray:arrImg];
    
    [arrSlider addObject:NSLocalizedStringFromTable(@"Referral",[prefl objectForKey:@"TranslationDocumentName"], nil)];
    [arrImages addObject:@"nav_referral"];
    
//    [arrSlider addObject:NSLocalizedStringFromTable(@"Wallet",[prefl objectForKey:@"TranslationDocumentName"],nil)];
//    [arrImages addObject:@"nav_payment"];
//    [arrIdentifire addObject:@"SegueToWalletVC"];
    
    [arrSlider addObject:NSLocalizedStringFromTable(@"Settings",[prefl objectForKey:@"TranslationDocumentName"],nil)];
    [arrImages addObject:@"nav_settings"];
    [arrIdentifire addObject:SEGUE_TO_SETTINGS];
    
    [arrSlider addObject:NSLocalizedStringFromTable(@"Logout", [prefl objectForKey:@"TranslationDocumentName"], nil)];
    [arrImages addObject:@"ub__nav_logout"];
    
}

-(void)handleUpdatedData:(NSNotification *)notification
{
    NSLog(@"recieved");
    [self.tblMenu reloadData];
    [self viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //    UINavigationController *nav=(UINavigationController *)self.revealViewController.frontViewController;
    //    frontVC=[nav.childViewControllers objectAtIndex:0];
}

#pragma mark -
#pragma mark - UITableView Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrSlider count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellSlider *cell=(CellSlider *)[tableView dequeueReusableCellWithIdentifier:@"CellSlider"];
    if (cell==nil) {
        cell=[[CellSlider alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellSlider"];
    }
    cell.lblName.text=[arrSlider objectAtIndex:indexPath.row];
    cell.imgIcon.image=[UIImage imageNamed:[arrImages objectAtIndex:indexPath.row]];
    
    
    //[cell setCellData:[arrSlider objectAtIndex:indexPath.row] withParent:self];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([[arrSlider objectAtIndex:indexPath.row]isEqualToString:NSLocalizedStringFromTable(@"Logout",[prefl objectForKey:@"TranslationDocumentName"], nil)])
    {
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:NSLocalizedStringFromTable(@"Logout",[prefl objectForKey:@"TranslationDocumentName"], nil)
                                                                       message:NSLocalizedStringFromTable(@"Logout Msg",[prefl objectForKey:@"TranslationDocumentName"], nil)
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"Yes", [prefl objectForKey:@"TranslationDocumentName"],nil) style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action)
        {
            NSUserDefaults *pref=[NSUserDefaults standardUserDefaults];
            
            NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
            [dictParam setObject:[pref objectForKey:PREF_USER_ID] forKey:PARAM_ID];
            [dictParam setObject:[pref objectForKey:PREF_USER_TOKEN] forKey:PARAM_TOKEN];
            
            if([[AppDelegate sharedAppDelegate]connected])
            {
                AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
                [afn getDataFromPath:FILE_LOGOUT withParamData:dictParam withBlock:^(id response, NSError *error)
                 {
                     [[AppDelegate sharedAppDelegate]hideLoadingView];
                     if (response)
                     {
                         
                         NSDictionary *set = response;
                         Provider_Logout *tester = [RMMapper objectWithClass:[Provider_Logout class] fromDictionary:set];
                         NSLog(@"Test data: %@",tester.success);
                         
                         [pref removeObjectForKey:PREF_USER_TOKEN];
                         [pref removeObjectForKey:PREF_REQ_ID];
                         [pref removeObjectForKey:PREF_IS_LOGOUT];
                         [pref removeObjectForKey:PREF_USER_ID];
                         [pref removeObjectForKey:PREF_MOBILE_NO];
                         [pref removeObjectForKey:PREF_IS_LOGIN];
                         [pref synchronize];
                         [self.navigationController popToRootViewControllerAnimated:YES];
                     }
                     
                     
                 }];
                
            }

                                                              }];
        
        UIAlertAction* CancelAction = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"No", [prefl objectForKey:@"TranslationDocumentName"],nil) style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:CancelAction];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    
    if ((indexPath.row >3)&&(indexPath.row<(arrSlider.count-3)))
    {
        [self.revealViewController rightRevealToggle:self];
        UINavigationController *nav=(UINavigationController *)self.revealViewController.frontViewController;
        self.ViewObj=(PickUpVC *)[nav.childViewControllers objectAtIndex:0];
        //        NSDictionary *dictTemp=[arrPage objectAtIndex:indexPath.row-3];
        //        strContent=[dictTemp valueForKey:@"content"];
        [self.ViewObj performSegueWithIdentifier:SEGUE_TO_REFERRAL_CODE sender:self];
        return;
    }
    [self.revealViewController rightRevealToggle:self];
    UINavigationController *nav=(UINavigationController *)self.revealViewController.frontViewController;
    self.ViewObj=(PickUpVC *)[nav.childViewControllers objectAtIndex:0];
    if(self.ViewObj!=nil)
        [self.ViewObj goToSetting:[arrIdentifire objectAtIndex:indexPath.row]];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *v=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 1)];
    v.backgroundColor=[UIColor clearColor];
    return nil;
}
/*
 - (void)onClickProfile:(id)sender
 {
 if (frontVC) {
 [self.revealViewController rightRevealToggle:nil];
 [frontVC performSegueWithIdentifier:SEGUE_PROFILE sender:frontVC];
 }
 }
 
 - (void)onClickPayment:(id)sender
 {
 if (frontVC) {
 [self.revealViewController rightRevealToggle:nil];
 [frontVC performSegueWithIdentifier:SEGUE_PAYMENT sender:frontVC];
 }
 }
 
 - (void)onClickPromotions:(id)sender
 {
 if (frontVC) {
 [self.revealViewController rightRevealToggle:nil];
 [frontVC performSegueWithIdentifier:SEGUE_PROMOTIONS sender:frontVC];
 }
 }
 
 - (void)onClickShare:(id)sender
 {
 if (frontVC) {
 [self.revealViewController rightRevealToggle:nil];
 [frontVC performSegueWithIdentifier:SEGUE_SHARE sender:frontVC];
 }
 }
 
 - (void)onClickSupport:(id)sender
 {
 if (frontVC) {
 [self.revealViewController rightRevealToggle:nil];
 [frontVC performSegueWithIdentifier:SEGUE_SUPPORT sender:frontVC];
 }
 }
 
 - (void)onClickAbout:(id)sender
 {
 if (frontVC) {
 [self.revealViewController rightRevealToggle:nil];
 [frontVC performSegueWithIdentifier:SEGUE_ABOUT sender:frontVC];
 }
 }
 */


#pragma mark -
#pragma mark - Custom Font & Color

-(void) customfont
{
    //[self.lblName setText:NSLocalizedString(@"", nil)];
}




#pragma mark -
#pragma mark - Memory Mgmt

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
