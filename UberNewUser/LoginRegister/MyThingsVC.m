//
//  MyThingsVC.m
//  UberNew
//
//  Created by Elluminati - macbook on 26/09/14.
//  Copyright (c) 2014 Jigs. All rights reserved.
//

#import "MyThingsVC.h"
//#import "PaymentVC.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVBase.h>
#import <AVFoundation/AVFoundation.h>
#import "PaymentVC.h"
#import "Constants.h"
#import "AFNHelper.h"
#import "AppDelegate.h"

@interface MyThingsVC ()

@end

@implementation MyThingsVC
{
    NSUserDefaults *prefl;
}

@synthesize strForID,strForToken;

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
    [super setNavBarTitle:TITLE_MYTHINGS];
    [super setBackBarItem];
 //   [self performSegueWithIdentifier:SEGUE_ADD_PAYMENT sender:self];

}


#pragma mark -
#pragma mark - Memory Mgmt

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)nextBtnPressed:(id)sender
{
    if([[AppDelegate sharedAppDelegate]connected])
    {
    
    [[AppDelegate sharedAppDelegate]showLoadingWithTitle:NSLocalizedStringFromTable(@"LOADING",[prefl objectForKey:@"TranslationDocumentName"],nil)];
    NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
    [dictParam setValue:self.txtName.text forKey:PARAM_NAME];
    [dictParam setValue:self.txtAge.text forKey:PARAM_AGE];
    [dictParam setValue:self.txtComment.text forKey:PARAM_NOTES];
    [dictParam setValue:self.txtType.text forKey:PARAM_TYPE];
    [dictParam setValue:strForID forKey:PARAM_ID];
    [dictParam setValue:strForToken forKey:PARAM_TOKEN];
    
    AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
    [afn getDataFromPath:FILE_THING withParamDataImage:dictParam andImage:self.imgMyThing.image withBlock:^(id response, NSError *error)
     {
        
        [[AppDelegate sharedAppDelegate]hideLoadingView];
        
        if([[response valueForKey:@"success"]boolValue])
        {
            
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                           message:NSLocalizedStringFromTable(@"THING_SUCCESS",[prefl objectForKey:@"TranslationDocumentName"],nil)
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"OK", [prefl objectForKey:@"TranslationDocumentName"],nil) style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
            
            [self performSegueWithIdentifier:SEGUE_ADD_PAYMENT sender:self];
        }
        else
        {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@""
                                                                           message:NSLocalizedStringFromTable(@"THING_FAIL",[prefl objectForKey:@"TranslationDocumentName"],nil)
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"OK", [prefl objectForKey:@"TranslationDocumentName"],nil) style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        NSLog(@"MY THINGS RESPONSE --> %@",response);
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
     //[self performSegueWithIdentifier:SEGUE_ADD_PAYMENT sender:self];

}

- (IBAction)imageBtnPressed:(id)sender
{

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
//    UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
//    UIActionSheet *actionpass;
//    
//    actionpass = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"CANCEL",[prefl objectForKey:@"TranslationDocumentName"],nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedStringFromTable(@"SELECT_PHOTO",[prefl objectForKey:@"TranslationDocumentName"],nil),NSLocalizedStringFromTable(@"TAKE_PHOTO",[prefl objectForKey:@"TranslationDocumentName"],nil),nil];
//    [actionpass showInView:window];

}

#pragma mark
#pragma mark - Segue Methods

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:SEGUE_ADD_PAYMENT])
    {
        PaymentVC *obj=[segue destinationViewController];
        obj.strForID=strForID;
        obj.strForToken=strForToken;
        
    }
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
    
    [self presentViewController:imagePickerController animated:YES completion:^{
        
    }];
}

-(void)takePhoto
{
    // Set up the image picker controller and add it to the view
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType =UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:imagePickerController animated:YES completion:^{
        
    }];
}

#pragma mark
#pragma mark - ImagePickerDelegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if([info valueForKey:UIImagePickerControllerOriginalImage]==nil)
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
        [self setImage:[info valueForKey:UIImagePickerControllerOriginalImage]];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)setImage:(UIImage *)image
{
    self.imgMyThing.image=image;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


@end
