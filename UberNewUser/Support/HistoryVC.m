//
//  SupportVC.m
//  UberNew
//
//  Created by Elluminati - macbook on 26/09/14.
//  Copyright (c) 2014 Jigs. All rights reserved.
//

#import "HistoryVC.h"
#import "HistoryCell.h"
#import "Constants.h"
#import "UIImageView+Download.h"
#import "AppDelegate.h"
#import "AFNHelper.h"
#import "UtilityClass.h"
#import "UberStyleGuide.h"

@interface HistoryVC ()
{
    NSMutableArray *arrHistory;
    NSMutableArray *arrForDate;
    NSMutableArray *arrForSection;
    NSUserDefaults *prefl;
    CGFloat screenWidth,screenHeight;CGRect screenRect;
}

@end

@implementation HistoryVC

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
    screenRect = [[UIScreen mainScreen] bounds];
    screenWidth = screenRect.size.width;
    screenHeight = screenRect.size.height;
    NSLog(@"Screen Width %f",screenWidth);
    NSLog(@"Screen Height %f",screenHeight);
    self.viewForBill.hidden=YES;
    arrHistory=[[NSMutableArray alloc]init];
    //[super setNavBarTitle:TITLE_SUPPORT];
    [super setBackBarItem];
    [[AppDelegate sharedAppDelegate]showLoadingWithTitle:NSLocalizedStringFromTable(@"GETTING HISTORY", [prefl objectForKey:@"TranslationDocumentName"], nil)];
    [self getHistory];
    
    self.btnMenu.titleLabel.font=[UberStyleGuide fontRegular];
    
    self.lblDistCost.font=[UberStyleGuide fontRegular];
    self.lblBasePrice.font=[UberStyleGuide fontRegular];
    
    self.lblPerDist.font=[UberStyleGuide fontRegular:12.0];
    self.lblPerTime.font=[UberStyleGuide fontRegular:12.0];
    self.lblTimeCost.font=[UberStyleGuide fontRegular];
    self.lblPomoBouns.font=[UberStyleGuide fontRegular];
    self.lblReferralBouns.font=[UberStyleGuide fontRegular];
    //self.lblTotal.font=[UberStyleGuide fontRegular:25.0f];
  
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self SetLocalization];
    self.tableView.hidden=NO;
    self.viewForBill.hidden=YES;
    self.lblnoHistory.hidden=YES;
    self.imgNoDisplay.hidden=YES;
    self.navigationController.navigationBarHidden=NO;
}
- (void)viewDidAppear:(BOOL)animated
{
    [self.btnMenu setTitle:NSLocalizedStringFromTable(@"History", [prefl objectForKey:@"TranslationDocumentName"], nil) forState:UIControlStateNormal];
}

-(void)SetLocalization
{
    self.btnMenu.titleLabel.textColor = [UberStyleGuide colorDefault];
    
    self.lBasePrice.textColor=[UberStyleGuide colorDefault];
    self.lblBasePrice.textColor=[UberStyleGuide colorDefault];
    self.lDistanceCost.textColor=[UberStyleGuide colorDefault];
    self.lblDistCost.textColor=[UberStyleGuide colorDefault];
    self.lblPerDist.textColor=[UberStyleGuide colorDefault];
    self.lTimeCost.textColor=[UberStyleGuide colorDefault];
    self.lblTimeCost.textColor=[UberStyleGuide colorDefault];
    self.lblPerTime.textColor=[UberStyleGuide colorDefault];
    self.lreferalBonus.textColor=[UberStyleGuide colorDefault];
    self.lblReferralBouns.textColor=[UberStyleGuide colorDefault];
    self.lPromoBonus.textColor=[UberStyleGuide colorDefault];
    self.lblPomoBouns.textColor=[UberStyleGuide colorDefault];
    self.LblWaitingcost.textColor=[UberStyleGuide colorDefault];
    self.LblWaitingcostValue.textColor=[UberStyleGuide colorDefault];
    
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    if ([[pref objectForKey:@"ArabicLanguage"] isEqualToString:@"YesArabic"])
    {
        if (screenHeight == 568.000000)
        {
            NSLog(@"Standard Resolution Device");
            [_lBasePrice setFrame:CGRectMake(220, 125, 175, 35)];
            [_lblBasePrice setFrame:CGRectMake(0, 125, 96, 35)];
            [_lDistanceCost setFrame:CGRectMake(220, 158, 175, 35)];
            [_lblDistCost setFrame:CGRectMake(0, 168, 96, 35)];
            [_lblPerDist setFrame:CGRectMake(220, 175, 175, 35)];
            [_lTimeCost setFrame:CGRectMake(220, 210, 175, 35)];
            [_lblTimeCost setFrame:CGRectMake(0, 215, 96, 35)];
            [_lblPerTime setFrame:CGRectMake(220, 225, 175, 35)];
            [_lreferalBonus setFrame:CGRectMake(220, 258, 175, 35)];
            [_lblReferralBouns setFrame:CGRectMake(0, 258, 96, 35)];
            [_lPromoBonus setFrame:CGRectMake(220, 294, 175, 35)];
            [_lblPomoBouns setFrame:CGRectMake(0, 294, 96, 35)];
            [_LblWaitingcost setFrame:CGRectMake(220, 332, 175, 35)];
            [_LblWaitingcostValue setFrame:CGRectMake(0, 332, 96, 35)];
        }
        if (screenHeight == 667.000000)
        {
            NSLog(@"High Resolution Device");
            [_lBasePrice setFrame:CGRectMake(280, 125, 175, 35)];
            [_lblBasePrice setFrame:CGRectMake(-10, 125, 96, 35)];
            [_lDistanceCost setFrame:CGRectMake(280, 158, 175, 35)];
            [_lblDistCost setFrame:CGRectMake(-10, 168, 96, 35)];
            [_lblPerDist setFrame:CGRectMake(280, 175, 175, 35)];
            [_lTimeCost setFrame:CGRectMake(280, 210, 175, 35)];
            [_lblTimeCost setFrame:CGRectMake(-10, 215, 96, 35)];
            [_lblPerTime setFrame:CGRectMake(280, 225, 175, 35)];
            [_lreferalBonus setFrame:CGRectMake(280, 258, 175, 35)];
            [_lblReferralBouns setFrame:CGRectMake(-10, 258, 96, 35)];
            [_lPromoBonus setFrame:CGRectMake(280, 294, 175, 35)];
            [_lblPomoBouns setFrame:CGRectMake(-10, 294, 96, 35)];
            [_LblWaitingcost setFrame:CGRectMake(280, 332, 175, 35)];
            [_LblWaitingcostValue setFrame:CGRectMake(-10, 332, 96, 35)];
        }
        if (screenHeight == 736.000000)
        {
            NSLog(@"iPhone 7 & 7plus");
            [_lBasePrice setFrame:CGRectMake(300, 125, 175, 35)];
            [_lblBasePrice setFrame:CGRectMake(0, 125, 96, 35)];
            [_lDistanceCost setFrame:CGRectMake(300, 158, 175, 35)];
            [_lblDistCost setFrame:CGRectMake(0, 168, 96, 35)];
            [_lblPerDist setFrame:CGRectMake(300, 175, 175, 35)];
            [_lTimeCost setFrame:CGRectMake(300, 210, 175, 35)];
            [_lblTimeCost setFrame:CGRectMake(0, 215, 96, 35)];
            [_lblPerTime setFrame:CGRectMake(300, 225, 175, 35)];
            [_lreferalBonus setFrame:CGRectMake(300, 258, 175, 35)];
            [_lblReferralBouns setFrame:CGRectMake(0, 258, 96, 35)];
            [_lPromoBonus setFrame:CGRectMake(300, 294, 175, 35)];
            [_lblPomoBouns setFrame:CGRectMake(0, 294, 96, 35)];
            [_LblWaitingcost setFrame:CGRectMake(300, 332, 175, 35)];
            [_LblWaitingcostValue setFrame:CGRectMake(0, 332, 96, 35)];
            
        }

        
        
    }

    self.LblWaitingcost.text=NSLocalizedStringFromTable(@"Waiting_Cost",[prefl objectForKey:@"TranslationDocumentName"],nil);
    self.lblInvoice.text=NSLocalizedStringFromTable(@"Invoice",[prefl objectForKey:@"TranslationDocumentName"],nil);
    self.lBasePrice.text=NSLocalizedStringFromTable(@"BASE PRICE",[prefl objectForKey:@"TranslationDocumentName"], nil);
    self.lDistanceCost.text=NSLocalizedStringFromTable(@"DISTANCE COST",[prefl objectForKey:@"TranslationDocumentName"], nil);
    self.lTimeCost.text=NSLocalizedStringFromTable(@"TIME COST",[prefl objectForKey:@"TranslationDocumentName"], nil);
    self.lPromoBonus.text=NSLocalizedStringFromTable(@"PROMO BONUS",[prefl objectForKey:@"TranslationDocumentName"], nil);
    self.lreferalBonus.text=NSLocalizedStringFromTable(@"REFERRAL BONUS",[prefl objectForKey:@"TranslationDocumentName"], nil);
    self.lTotalCost.text=NSLocalizedStringFromTable(@"Total Due",[prefl objectForKey:@"TranslationDocumentName"], nil);
    [self.btnClose setTitle:NSLocalizedStringFromTable(@"Close",[prefl objectForKey:@"TranslationDocumentName"],nil) forState:UIControlStateNormal];
}
#pragma mark -
#pragma mark - Memory Mgmt

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark-
#pragma mark - Table view data source

-(void)makeSection
{
    arrForDate=[[NSMutableArray alloc]init];
    arrForSection=[[NSMutableArray alloc]init];
    NSMutableArray *arrtemp=[[NSMutableArray alloc]init];
    [arrtemp addObjectsFromArray:arrHistory];
    NSSortDescriptor *distanceSortDiscriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO
                                                                            selector:@selector(localizedStandardCompare:)];
    
    [arrtemp sortUsingDescriptors:@[distanceSortDiscriptor]];
    
    for (int i=0; i<arrtemp.count; i++)
    {
        NSMutableDictionary *dictDate=[[NSMutableDictionary alloc]init];
        dictDate=[arrtemp objectAtIndex:i];
        
        NSString *temp=[dictDate valueForKey:@"date"];
        NSArray *arrDate=[temp componentsSeparatedByString:@" "];
        NSString *strdate=[arrDate objectAtIndex:0];
        if(![arrForDate containsObject:strdate])
        {
            [arrForDate addObject:strdate];
        }
        
    }
    
    for (int j=0; j<arrForDate.count; j++)
    {
        NSMutableArray *a=[[NSMutableArray alloc]init];
        [arrForSection addObject:a];
    }
    for (int j=0; j<arrForDate.count; j++)
    {
        NSString *strTempDate=[arrForDate objectAtIndex:j];
        
        for (int i=0; i<arrtemp.count; i++)
        {
            NSMutableDictionary *dictSection=[[NSMutableDictionary alloc]init];
            dictSection=[arrtemp objectAtIndex:i];
            NSArray *arrDate=[[dictSection valueForKey:@"date"] componentsSeparatedByString:@" "];
            NSString *strdate=[arrDate objectAtIndex:0];
            if ([strdate isEqualToString:strTempDate])
            {
                [[arrForSection objectAtIndex:j] addObject:dictSection];
                
            }
        }
        
    }
    
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return arrForSection.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [[arrForSection objectAtIndex:section] count];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 15)];
    UILabel *lblDate=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 300, 15)];
    lblDate.font=[UberStyleGuide fontRegular:13.0f];
    lblDate.textColor=[UberStyleGuide colorDefault];
    NSString *strDate=[arrForDate objectAtIndex:section];
    NSString *current=[[UtilityClass sharedObject] DateToString:[NSDate date] withFormate:@"yyyy-MM-dd"];
    
   
    ///   YesterDay Date Calulation
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = -1;
    NSDate *yesterday = [gregorian dateByAddingComponents:dayComponent
                                                   toDate:[NSDate date]
                                                  options:0];
    NSString *strYesterday=[[UtilityClass sharedObject] DateToString:yesterday withFormate:@"yyyy-MM-dd"];
    
    
    if([strDate isEqualToString:current])
    {
        lblDate.text=@"Today";
        headerView.backgroundColor=[UberStyleGuide colorDefault];
        lblDate.textColor=[UIColor whiteColor];
    }
    else if ([strDate isEqualToString:strYesterday])
    {
        lblDate.text=@"Yesterday";
    }
    else
    {
        NSDate *date=[[UtilityClass sharedObject]stringToDate:strDate withFormate:@"yyyy-MM-dd"];
        NSString *text=[[UtilityClass sharedObject]DateToString:date withFormate:@"dd MMMM yyyy"];//2nd Jan 2015
        lblDate.text=text;
    }
    
    [headerView addSubview:lblDate];
    return headerView;
}

/*- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [arrForDate objectAtIndex:section];
}*/

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIImageView *imgFooter=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rectangle2"]];
    return imgFooter;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"historycell";
    

    
    HistoryCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (cell==nil)
    {
        cell=[[HistoryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    NSMutableDictionary *pastDict=[[arrForSection objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    NSMutableDictionary *dictOwner=[pastDict valueForKey:@"walker"];

    cell.lblName.font=[UberStyleGuide fontRegularBold:12.0f];
    cell.lblPrice.font=[UberStyleGuide fontRegular:20.0f];
    cell.lblType.font=[UberStyleGuide fontRegular];
    //cell.lblTime.font=[UberStyleGuide fontRegular];
    
    cell.lblName.text=[NSString stringWithFormat:@"%@ %@",[dictOwner valueForKey:@"first_name"],[dictOwner valueForKey:@"last_name"]];
    cell.lblType.text=[NSString stringWithFormat:@"%@",[dictOwner valueForKey:@"phone"]];
    cell.lblPrice.text=[NSString stringWithFormat:@"%@%.2f",NSLocalizedStringFromTable(@"Currency", [prefl objectForKey:@"TranslationDocumentName"], nil),[[pastDict valueForKey:@"total"] floatValue]];
    
    NSDate *dateTemp=[[UtilityClass sharedObject]stringToDate:[pastDict valueForKey:@"date"]];
    NSString *strDate=[[UtilityClass sharedObject]DateToString:dateTemp withFormate:@"hh:mm a"];
    

  
    
    cell.lblTime.text=[NSString stringWithFormat:@"%@",strDate];
    [cell.imageView downloadFromURL:[dictOwner valueForKey:@"picture"] withPlaceholder:nil];
        return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.navigationController.navigationBarHidden=YES;
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSMutableDictionary *pastDict=[[arrForSection objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
   
    NSLog(@"Payment Detail:- %@",pastDict);
    
    self.LblWaitingcostValue.text=[NSString stringWithFormat:@"%@ %.2f",NSLocalizedStringFromTable(@"Currency", [prefl objectForKey:@"TranslationDocumentName"], nil),[[pastDict valueForKey:@"waiting_price"]floatValue]];
    
    self.lblBasePrice.text=[NSString stringWithFormat:@"%@%.2f",NSLocalizedStringFromTable(@"Currency", [prefl objectForKey:@"TranslationDocumentName"], nil),[[pastDict valueForKey:@"base_price"]floatValue]];
    self.lblDistCost.text=[NSString stringWithFormat:@"%@%.2f",NSLocalizedStringFromTable(@"Currency", [prefl objectForKey:@"TranslationDocumentName"], nil),[[pastDict valueForKey:@"distance_cost"] floatValue]];
    self.lblTimeCost.text=[NSString stringWithFormat:@"%@%.2f",NSLocalizedStringFromTable(@"Currency", [prefl objectForKey:@"TranslationDocumentName"], nil),[[pastDict valueForKey:@"time_cost"] floatValue]];
    self.lblTotal.text=[NSString stringWithFormat:@"%@%.2f",NSLocalizedStringFromTable(@"Currency", [prefl objectForKey:@"TranslationDocumentName"], nil),[[pastDict valueForKey:@"total"] floatValue]];
    self.lblPomoBouns.text=[NSString stringWithFormat:@"%@%.2f",NSLocalizedStringFromTable(@"Currency", [prefl objectForKey:@"TranslationDocumentName"], nil),[[pastDict valueForKey:@"promo_bonus"] floatValue]];
    self.lblReferralBouns.text=[NSString stringWithFormat:@"%@%.2f",NSLocalizedStringFromTable(@"Currency", [prefl objectForKey:@"TranslationDocumentName"], nil),[[pastDict valueForKey:@"referral_bonus"] floatValue]];
    float totalDist=[[pastDict valueForKey:@"distance_cost"] floatValue];
    float Dist=[[pastDict valueForKey:@"distance"]floatValue];
    float NetDistance = Dist - 1.0;
    NSLog(@"Net Distance=%f",NetDistance);
    NSLog(@"Distance Price=%f",[[pastDict valueForKey:@"distance_price"] floatValue]);
    NSLog(@"Set Base Distance=%f",[[pastDict valueForKey:@"setbase_distance"] floatValue]);
    NSLog(@"Price Per Unit Time=%f",[[pastDict valueForKey:@"price_per_unit_time"] floatValue]);
    NSString *Distance_Price = [pastDict valueForKey:@"distance_price"];
    NSString *SetBaseDistance = [pastDict valueForKey:@"setbase_distance"];
    NSString *PricePerUnitTime = [pastDict valueForKey:@"price_per_unit_time"];
    
    
    if ([[pastDict valueForKey:@"unit"]isEqualToString:@"kms"])
    {
        totalDist=totalDist*0.621317;
        Dist=Dist*0.621371;
    }
    
    if(Dist!=0)
    {
         //        self.lblPerDist.text=[NSString stringWithFormat:@"%.2f%@ %@",(totalDist/Dist),NSLocalizedStringFromTable(@"Currency", [prefl objectForKey:@"TranslationDocumentName"], nil),NSLocalizedStringFromTable(@"per mile", [prefl objectForKey:@"TranslationDocumentName"], nil)];
        
        if (Dist<[SetBaseDistance doubleValue])
        {
            self.lBasePrice.text=[NSString stringWithFormat:@"%@",NSLocalizedStringFromTable(@"BASE PRICE",[prefl objectForKey:@"TranslationDocumentName"], nil)];
            
            self.lDistanceCost.text = [NSString stringWithFormat:@"%@",NSLocalizedString(@"DISTANCE COST", nil)];
            
            self.lblPerDist.text=[NSString stringWithFormat:@"%.2f$ %@",[Distance_Price floatValue],NSLocalizedStringFromTable(@"per mile",[prefl objectForKey:@"TranslationDocumentName"],nil)];
            NSLog(@" IF Calling Label Value1 =%@",self.lblPerDist.text);
        }
        else
        {
            self.lBasePrice.text=[NSString stringWithFormat:@"%@ (%.2f KM)",NSLocalizedStringFromTable(@"BASE PRICE",[prefl objectForKey:@"TranslationDocumentName"], nil),[SetBaseDistance floatValue]];
            
            self.lDistanceCost.text = [NSString stringWithFormat:@"%@ (%.2f KM)",NSLocalizedString(@"DISTANCE COST", nil),NetDistance];
            
            self.lblPerDist.text=[NSString stringWithFormat:@"%@ %.2f %@",NSLocalizedStringFromTable(@"Currency", [prefl objectForKey:@"TranslationDocumentName"], nil),[Distance_Price floatValue],NSLocalizedStringFromTable(@"per mile",[prefl objectForKey:@"TranslationDocumentName"],nil)];
            NSLog(@"Else Calling Label Value2 =%@",self.lblPerDist.text);
        }
     
    }
    else
    {
         self.lBasePrice.text=NSLocalizedStringFromTable(@"BASE PRICE",[prefl objectForKey:@"TranslationDocumentName"], nil);
        self.lblPerDist.text=[NSString stringWithFormat:@"0 %@ %@",NSLocalizedStringFromTable(@"Currency", [prefl objectForKey:@"TranslationDocumentName"], nil),NSLocalizedStringFromTable(@"per mile",  [prefl objectForKey:@"TranslationDocumentName"], nil)];
    }
    
    //float totalTime=[[pastDict valueForKey:@"time_cost"] floatValue];
    float Time=[[pastDict valueForKey:@"time"]floatValue];
    if(Time!=0)
    {
         //        self.lblPerTime.text=[NSString stringWithFormat:@"%.2f%@ %@",(totalTime/Time),NSLocalizedStringFromTable(@"Currency", [prefl objectForKey:@"TranslationDocumentName"], nil),NSLocalizedStringFromTable(@"per mins", [prefl objectForKey:@"TranslationDocumentName"], nil)];
         self.lblPerTime.text=[NSString stringWithFormat:@"%@ %.2f %@",NSLocalizedStringFromTable(@"Currency", [prefl objectForKey:@"TranslationDocumentName"], nil),[PricePerUnitTime floatValue],NSLocalizedStringFromTable(@"per mins",[prefl objectForKey:@"TranslationDocumentName"],nil)];
    }
    else
    {
        self.lblPerTime.text=[NSString stringWithFormat:@"0%@ %@",NSLocalizedStringFromTable(@"Currency", [prefl objectForKey:@"TranslationDocumentName"], nil),NSLocalizedStringFromTable(@"per mins",  [prefl objectForKey:@"TranslationDocumentName"], nil)];
    }

    
    
    
    [UIView animateWithDuration:0.5 animations:^{
        self.viewForBill.hidden=NO;
    } completion:^(BOOL finished)
     {
     }];
}
#pragma mark -
#pragma mark - Custom Methods

-(void)getHistory
{
    if([[AppDelegate sharedAppDelegate]connected])
    {
        
        NSUserDefaults *pref=[NSUserDefaults standardUserDefaults];
       NSString * strForUserId=[pref objectForKey:PREF_USER_ID];
       NSString * strForUserToken=[pref objectForKey:PREF_USER_TOKEN];
        
        
        NSMutableString *pageUrl=[NSMutableString stringWithFormat:@"%@?%@=%@&%@=%@",FILE_HISTORY,PARAM_ID,strForUserId,PARAM_TOKEN,strForUserToken];
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:GET_METHOD];
        [afn getDataFromPath:pageUrl withParamData:nil withBlock:^(id response, NSError *error)
         {
             
             NSLog(@"History Data= %@",response);
             [APPDELEGATE hideLoadingView];
             if (response)
             {
                 if([[response valueForKey:@"success"] intValue]==1)
                 {
                     [APPDELEGATE hideLoadingView];
                     
                     arrHistory=[response valueForKey:@"requests"];
                     NSLog(@"History count = %lu",(unsigned long)arrHistory.count);
                     if (arrHistory.count==0 || arrHistory==nil)
                     {
                         self.tableView.hidden=YES;
                         self.lblnoHistory.hidden=NO;
                         self.imgNoDisplay.hidden=NO;
                     }
                     else
                     {
                         self.tableView.hidden=NO;
                         self.lblnoHistory.hidden=YES;
                         self.imgNoDisplay.hidden=YES;
                         [self makeSection];
                         [self.tableView reloadData];
                         
                     }
                     
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
        
- (IBAction)closeBtnPressed:(id)sender
{
    self.navigationController.navigationBarHidden=NO;
    [UIView animateWithDuration:0.5 animations:^{
        self.viewForBill.hidden=YES;
    } completion:^(BOOL finished)
     {
     }];
}

@end
