//
//  ProfileVC.h
//  UberNew
//
//  Created by Elluminati - macbook on 26/09/14.
//  Copyright (c) 2014 Jigs. All rights reserved.
//

#import "BaseVC.h"


@interface ProfileVC : BaseVC <UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

- (IBAction)selectPhotoBtnPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *proPicImgv;
@property (weak, nonatomic) IBOutlet UIButton *btnEdit;
@property (weak, nonatomic) IBOutlet UIButton *btnProPic;

@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;
@property (weak, nonatomic) IBOutlet UITextField *txtLastName;

@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPhone;
@property (weak, nonatomic) IBOutlet UITextField *txtAddress;
@property (weak, nonatomic) IBOutlet UITextField *txtBio;
@property (weak, nonatomic) IBOutlet UITextField *txtZipCode;
@property (weak, nonatomic) IBOutlet UITextField *txtCurrentPWD;
@property (weak, nonatomic) IBOutlet UITextField *txtNewPWD;
@property (weak, nonatomic) IBOutlet UITextField *txtConformPWD;
@property (weak, nonatomic) IBOutlet UIButton *btnemailinfo;

- (IBAction)updateBtnPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnUpdate;

- (IBAction)editBtnPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnNavigation;

- (IBAction)btnEmailInfoClick:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblEmailInfo;
@property (weak, nonatomic) IBOutlet UIView *viewForEmailInfo;
@end
