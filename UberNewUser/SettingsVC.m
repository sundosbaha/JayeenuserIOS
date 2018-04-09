//
//  SettingsVC.m
//  Jayeentaxi
//
//  Created by Spextrum on 09/12/16.
//  Copyright © 2016 Jigs. All rights reserved.
//

#import "SettingsVC.h"

@interface SettingsVC ()
{
    NSArray *languagearray;
    NSUserDefaults *pref;
    
}
@end

@implementation SettingsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    pref = [[NSUserDefaults alloc]init];
    [super setBackBarItem];
    [self.tblLanguageList setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    languagearray = [NSArray arrayWithObjects:@"English",@"Arabic", nil]; //
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self CustomFormat];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





-(void)CustomFormat
{
    self.btnMenu.titleLabel.textColor = [UberStyleGuide colorDefault];
    
    [self.viewSelection setBackgroundColor:[UberStyleGuide colorSecondary]];
    [self.imgLine1 setBackgroundColor:[UberStyleGuide colorDefault]];
    [self.imgLine2 setBackgroundColor:[UberStyleGuide colorDefault]];
    [self.viewSelection.layer setCornerRadius:5.0];
    [self.BgviewForTblview.layer setCornerRadius:5.0];
    if ([[pref objectForKey:@"TranslationDocumentName"] isEqualToString:@"LocalizableSpanish"])
    {
        [self.lbl_languagetitle setText:@"Idioma"];
        [self.lb_language setText:@"Spanish"];
        [self.lbl_languageabbrv setText:@"SP"];
    }
    else if ([[pref objectForKey:@"TranslationDocumentName"] isEqualToString:@"LocalizablePortuguese" ])
    {
        [self.lbl_languagetitle setText:@"Língua"];
        [self.lb_language setText:@"Portuguese"];
        [self.lbl_languageabbrv setText:@"PT"];
    }
    else if ([[pref objectForKey:@"TranslationDocumentName"] isEqualToString:@"Localizable" ])
    {
        [self.lbl_languagetitle setText:@"Language"];
        [self.lb_language setText:@"English"];
        [self.lbl_languageabbrv setText:@"EN"];
    }
    else if ([[pref objectForKey:@"TranslationDocumentName"] isEqualToString:@"LocalizablePersian" ])
    {
        [self.lbl_languagetitle setText:@"Language"];
        [self.lb_language setText:@"Persian"];
        [self.lbl_languageabbrv setText:@"PR"];
    }
    else
    {
        [self.lbl_languagetitle setText:@"Language"];
        [self.lb_language setText:@"Arabic"];
        [self.lbl_languageabbrv setText:@"AR"];
    }
    
}
- (IBAction)btnlanguageselection:(id)sender
{
//    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:NSLocalizedStringFromTable(@"Alert",[pref objectForKey:@"TranslationDocumentName"],nil) message:NSLocalizedStringFromTable(@"Select_language",[pref objectForKey:@"TranslationDocumentName"],nil) delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"OK",[pref objectForKey:@"TranslationDocumentName"],nil) otherButtonTitles:nil, nil];
//    [alert show];
    [self.viewBackground setHidden:NO];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [languagearray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.textLabel.text = [languagearray objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self.viewBackground setHidden:YES];
    if ([cell.textLabel.text isEqualToString:@"English"])
    {
        [pref setObject:@"Localizable" forKey:@"TranslationDocumentName"];
        [pref setObject:@"NotArabic" forKey:@"ArabicLanguage"];
    }
    else if ([cell.textLabel.text isEqualToString:@"Spanish"])
    {
        [pref setObject:@"LocalizableSpanish" forKey:@"TranslationDocumentName"];
        [pref setObject:@"NotArabic" forKey:@"ArabicLanguage"];
    }
    else if ([cell.textLabel.text isEqualToString:@"Portuguese"])
    {
        [pref setObject:@"LocalizablePortuguese" forKey:@"TranslationDocumentName"];
        [pref setObject:@"NotArabic" forKey:@"ArabicLanguage"];
    }
    else if ([cell.textLabel.text isEqualToString:@"Arabic"])
    {
        [pref setObject:@"LocalizableArabic" forKey:@"TranslationDocumentName"];
        [pref setObject:@"YesArabic" forKey:@"ArabicLanguage"];
    }
    else if ([cell.textLabel.text isEqualToString:@"Persian"])
    {
        [pref setObject:@"LocalizablePersian" forKey:@"TranslationDocumentName"];
        [pref setObject:@"YesArabic" forKey:@"ArabicLanguage"];
    }
    
    [pref synchronize];
    [self CustomFormat];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DataUpdated"
                                                        object:self];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
