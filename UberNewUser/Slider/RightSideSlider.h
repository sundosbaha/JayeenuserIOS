//
//  RightSideSlider.h
//  Jayeentaxi
//
//  Created by Spextrum on 22/05/17.
//  Copyright © 2017 Jigs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"
#import "PickUpVC.h"

@interface RightSideSlider : BaseVC <UITableViewDataSource,UITableViewDelegate>
{
    //  UIViewController *frontVC;
}

@property(weak,nonatomic)IBOutlet UITableView *tblMenu;
@property (nonatomic,strong) PickUpVC *ViewObj;
@property (nonatomic, weak) IBOutlet UIImageView *imgProfilePic;
@property (weak, nonatomic) IBOutlet UILabel *lblName;

@end
