//
//  ProfileVC.m
//  UberNew
//
//  Created by Elluminati - macbook on 26/09/14.
//  Copyright (c) 2014 Jigs. All rights reserved.
//

#import "ProfileVC.h"
#import "UIImageView+Download.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVBase.h>
#import <AVFoundation/AVFoundation.h>
#import "Constants.h"
#import "AppDelegate.h"
#import "AFNHelper.h"
#import "UtilityClass.h"
#import "UIView+Utils.h"
#import "UberStyleGuide.h"
#import "RMUserDetails.h"
#import "RMMapper.h"
#import "RMUser.h"

@interface ProfileVC ()
{
    NSString *strForUserId,*strForUserToken;
}

@end

@implementation ProfileVC
{
     NSUserDefaults *prefl ;
}

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
    
    //[super setNavBarTitle:TITLE_PROFILE];
    self.viewForEmailInfo.hidden=YES;
    [super setBackBarItem];
    [self setDataForUserInfo];
    [self.proPicImgv applyRoundedCornersFullWithColor:[UIColor whiteColor]];
    
    self.btnEdit.hidden=NO;
    self.btnUpdate.hidden=YES;
    [self textDisable];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.txtFirstName setTintColor:[UIColor whiteColor]];
    [self.txtLastName setTintColor:[UIColor whiteColor]];
    [self SetLocalization];
    [self customFont];
    

}
- (void)viewDidAppear:(BOOL)animated
{
    [self.btnNavigation setTitle:NSLocalizedStringFromTable(@"Profile",[prefl objectForKey:@"TranslationDocumentName"], nil) forState:UIControlStateNormal];
}
-(void)SetLocalization
{
   
    self.txtFirstName.placeholder=NSLocalizedStringFromTable(@"FIRST NAME",[prefl objectForKey:@"TranslationDocumentName"],nil);
    self.txtLastName.placeholder=NSLocalizedStringFromTable(@"LAST NAME",[prefl objectForKey:@"TranslationDocumentName"], nil);
    self.txtEmail.placeholder=NSLocalizedStringFromTable(@"EMAIL",[prefl objectForKey:@"TranslationDocumentName"], nil);
    self.txtPhone.placeholder=NSLocalizedStringFromTable(@"PHONE",[prefl objectForKey:@"TranslationDocumentName"], nil);
    self.txtCurrentPWD.placeholder=NSLocalizedStringFromTable(@"CURRENT PASSWORD",[prefl objectForKey:@"TranslationDocumentName"], nil);
    self.txtNewPWD.placeholder=NSLocalizedStringFromTable(@"NEW PASSWORD",[prefl objectForKey:@"TranslationDocumentName"], nil);
    self.txtConformPWD.placeholder=NSLocalizedStringFromTable(@"CONFORM PASSWORD",[prefl objectForKey:@"TranslationDocumentName"], nil);
    [self.btnEdit setTitle:NSLocalizedStringFromTable(@"EDIT PROFILE",[prefl objectForKey:@"TranslationDocumentName"], nil) forState:UIControlStateNormal];
    [self.btnUpdate setTitle:NSLocalizedStringFromTable(@"UPDATE PROFILE",[prefl objectForKey:@"TranslationDocumentName"], nil) forState:UIControlStateNormal];
    self.lblEmailInfo.text =NSLocalizedStringFromTable(@"INFO_EMAIL",[prefl objectForKey:@"TranslationDocumentName"], nil);
}
-(void)setDataForUserInfo
{
    NSUserDefaults *pref=[NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dictInfo=[pref objectForKey:PREF_LOGIN_OBJECT];
    
    [self.proPicImgv downloadFromURL:[dictInfo valueForKey:@"picture"] withPlaceholder:nil];
    self.txtFirstName.text=[dictInfo valueForKey:@"first_name"];
    self.txtLastName.text=[dictInfo valueForKey:@"last_name"];
    self.txtEmail.text=[dictInfo valueForKey:@"email"];
    self.txtPhone.text=[dictInfo valueForKey:@"phone"];
    self.lblEmailInfo.text=NSLocalizedStringFromTable(@"This field is not editable.", [prefl objectForKey:@"TranslationDocumentName"], nil);
    //self.txtAddress.text=[dictInfo valueForKey:@"address"];
    ///self.txtZipCode.text=[dictInfo valueForKey:@"zipcode"];
    //self.txtBio.text=[dictInfo valueForKey:@"bio"];

}
#pragma mark -
#pragma mark - Memory Mgmt

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark-
#pragma mark - UIButton Action

- (IBAction)btnEmailInfoClick:(id)sender {
    
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

- (IBAction)selectPhotoBtnPressed:(id)sender
{
    //UIWindow* window = [[[UIApplication sharedApplication] delegate] window];

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

//    UIActionSheet *actionpass;
//    
//    actionpass = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"CANCEL",[prefl objectForKey:@"TranslationDocumentName"], nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedStringFromTable(@"SELECT_PHOTO", [prefl objectForKey:@"TranslationDocumentName"], nil),NSLocalizedStringFromTable(@"TAKE_PHOTO", [prefl objectForKey:@"TranslationDocumentName"], nil),nil];
//    actionpass.delegate=self;
//    [actionpass showInView:window];
}

- (IBAction)updateBtnPressed:(id)sender
{
    if (self.txtNewPWD.text.length > 0 || self.txtConformPWD.text.length > 0)
    {
        if ([self.txtNewPWD.text isEqualToString:self.txtConformPWD.text])
        {
            [self updateProfile];
        }
        else
        {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Profile Update Fail"
                                                                           message:NSLocalizedStringFromTable(@"NOT_MATCH_RETYPE",[prefl objectForKey:@"TranslationDocumentName"], nil)
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"OK", [prefl objectForKey:@"TranslationDocumentName"],nil) style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action)
                                            {
                                                
                                            }];
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    else
    {
        [self updateProfile];
    }
    
}
-(void)updateProfile
{
    if([[AppDelegate sharedAppDelegate]connected])
    {
        if([[UtilityClass sharedObject]isValidEmailAddress:self.txtEmail.text])
        {
            [[AppDelegate sharedAppDelegate]showLoadingWithTitle:NSLocalizedStringFromTable(@"EDITING",[prefl objectForKey:@"TranslationDocumentName"], nil)];
            NSUserDefaults *pref=[NSUserDefaults standardUserDefaults];
            strForUserId=[pref objectForKey:PREF_USER_ID];
            strForUserToken=[pref objectForKey:PREF_USER_TOKEN];
            NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
            [dictParam setValue:self.txtEmail.text forKey:PARAM_EMAIL];
            [dictParam setValue:self.txtFirstName.text forKey:PARAM_FIRST_NAME];
            [dictParam setValue:self.txtLastName.text forKey:PARAM_LAST_NAME];
            [dictParam setValue:self.txtPhone.text forKey:PARAM_PHONE];
            [dictParam setValue:@"" forKey:PARAM_BIO];
            [dictParam setValue:self.txtCurrentPWD.text forKey:PARAM_OLD_PASSWORD];
            [dictParam setValue:self.txtNewPWD.text forKey:PARAM_NEW_PASSWORD];
            [dictParam setValue:strForUserId forKey:PARAM_ID];
            [dictParam setValue:strForUserToken forKey:PARAM_TOKEN];
            
            [dictParam setValue:@"" forKey:PARAM_ADDRESS];
            [dictParam setValue:@"" forKey:PARAM_STATE];
            [dictParam setValue:@"" forKey:PARAM_COUNTRY];
            [dictParam setValue:@"" forKey:PARAM_ZIPCODE];
            UIImage *imgUpload = [[UtilityClass sharedObject]scaleAndRotateImage:self.proPicImgv.image];
            
            AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
            [afn getDataFromPath:FILE_UPADTE withParamDataImage:dictParam andImage:imgUpload withBlock:^(id response, NSError *error) {
                
                [[AppDelegate sharedAppDelegate]hideLoadingView];
                NSLog(@"Profile-Update%@",response);
                if (response)
                {
                    if([[response valueForKey:@"success"] boolValue])
                    {
                        RMUserDetails *getrooms = [RMMapper objectWithClass:[RMUserDetails class] fromDictionary:response];
                        NSDictionary *getDict = (NSDictionary *) getrooms.user;
                        RMUser *getUser = [RMMapper objectWithClass:[RMUser class] fromDictionary:getDict];
                        NSLog(@"%@", getUser);
                        NSUserDefaults *pref=[NSUserDefaults standardUserDefaults];
                        [pref setObject:[response valueForKey:@"user"] forKey:PREF_LOGIN_OBJECT];
                        [pref synchronize];
                        [self setDataForUserInfo];
                        [APPDELEGATE showToastMessage:NSLocalizedStringFromTable(@"PROFILE_EDIT_SUCESS",[prefl objectForKey:@"TranslationDocumentName"], nil)];
                        [self textDisable];
                        self.btnUpdate.hidden=YES;
                        self.btnEdit.hidden=NO;
                        self.txtConformPWD.text=@"";
                        self.txtCurrentPWD.text=@"";
                        self.txtNewPWD.text=@"";
                        // [self.navigationController popViewControllerAnimated:YES];
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

- (IBAction)editBtnPressed:(id)sender
{
    [self textEnable];
    [self.btnEdit setHidden:YES];
    [self.btnUpdate setHidden:NO];
    [self.txtFirstName becomeFirstResponder];
    [APPDELEGATE showToastMessage:@"You Can Edit Your Profile"];

}

#pragma mark-
#pragma mark- Custom Font

-(void)customFont
{
    self.btnNavigation.titleLabel.textColor = [UberStyleGuide colorDefault];
    self.lblEmailInfo.textColor = [UberStyleGuide colorDefault];
    
    self.txtFirstName.font=[UberStyleGuide fontRegularBold:18.0f];
    self.txtLastName.font=[UberStyleGuide fontRegularBold:18.0f];
    self.txtPhone.font=[UberStyleGuide fontRegular];
    self.txtEmail.font=[UberStyleGuide fontRegular];
   // self.txtAddress.font=[UberStyleGuide fontRegular];
   // self.txtBio.font=[UberStyleGuide fontRegular];
   // self.txtZipCode.font=[UberStyleGuide fontRegular];
    
    self.btnNavigation.titleLabel.font=[UberStyleGuide fontRegular];
   self.btnEdit.titleLabel.font=[UberStyleGuide fontRegularBold];
    self.btnUpdate.titleLabel.font=[UberStyleGuide fontRegularBold];
}


-(void)textDisable
{
    self.txtFirstName.enabled = NO;
    self.txtLastName.enabled = NO;
    self.txtEmail.enabled = NO;
    self.txtPhone.enabled = NO;
    self.txtConformPWD.enabled=NO;
    self.txtCurrentPWD.enabled=NO;
    self.txtNewPWD.enabled=NO;
   // self.txtAddress.enabled = NO;
   // self.txtZipCode.enabled = NO;
   // self.txtBio.enabled = NO;
    self.btnProPic.enabled=NO;
}

-(void)textEnable
{
    self.txtFirstName.enabled = YES;
    self.txtLastName.enabled = YES;
    self.txtEmail.enabled = NO;
    self.txtPhone.enabled = YES;
    self.txtConformPWD.enabled=YES;
    self.txtCurrentPWD.enabled=YES;
    self.txtNewPWD.enabled=YES;
   // self.txtAddress.enabled = YES;
   // self.txtZipCode.enabled = YES;
   // self.txtBio.enabled = YES;
    self.btnProPic.enabled=YES;
}
#pragma mark
#pragma mark - ActionSheet Delegate

//- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
//{
//    switch (buttonIndex)
//    {
//        case 1:
//        {
//            [self takePhoto];
//        }
//            break;
//        case 0:
//        {
//            [self selectPhotos];
//        }
//            break;
//            
//        default:
//            break;
//    }
//}

#pragma mark
#pragma mark - Action to Share


- (void)selectPhotos
{
    // Set up the image picker controller and add it to the view
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType =UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.allowsEditing=YES;
    [self presentViewController:imagePickerController animated:YES completion:^{
    }];
}

-(void)takePhoto
{
    // Set up the image picker controller and add it to the view
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType =UIImagePickerControllerSourceTypeCamera;
    imagePickerController.allowsEditing=YES;
    [self presentViewController:imagePickerController animated:YES completion:^{
    }];
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
    self.proPicImgv.image=image;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark
#pragma mark - UItextField Delegate

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    int y=0;
    if(textField==self.txtPhone)
        y=-100;
    else if(textField==self.txtCurrentPWD)
        y=-136;
    else if(textField==self.txtNewPWD)
        y=-150;
    else if(textField==self.txtConformPWD)
        y=-170;
    
    [UIView animateWithDuration:0.5 animations:^{
        
            self.view.frame=CGRectMake(0, y, self.view.frame.size.width, self.view.frame.size.height);
        
    } completion:^(BOOL finished)
     {
     }];
    
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField==self.txtLastName)
    {
       
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    /*if (textField==self.txtFirstName)
    {
        [self.txtLastName becomeFirstResponder];
    }
    if (textField==self.txtLastName)
    {
         //[[UITextField appearance] setTintColor:[UIColor blackColor]];
        [self.txtEmail becomeFirstResponder];
    }
    if (textField==self.txtEmail)
    {
        [self.txtPhone becomeFirstResponder];
    }
    if (textField==self.txtPhone)
    {
     
        [self.txtAddress becomeFirstResponder];
    }
    if (textField==self.txtAddress)
    {
        [self.txtBio  becomeFirstResponder];
    }
    if (textField==self.txtBio)
    {
        [self.txtZipCode becomeFirstResponder];
    }*/

    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.view.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
    } completion:^(BOOL finished)
     {
     }];
    
    [textField resignFirstResponder];
    return YES;
}

@end
