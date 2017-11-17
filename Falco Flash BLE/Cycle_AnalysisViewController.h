//
//  Cycle_AnalysisViewController.h
//  Falco Flash BLE
//
//  Created by Falco eMotors Pvt. Ltd. on 15/10/2016.
//  Copyright © 2016 Falco eMotors Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UARTPeripheral.h"
#import "ViewController.h"
#import "PowerScreenViewController.h"
#import "BatteryTypeSelection.h"


@interface Cycle_AnalysisViewController : UIViewController<UITextFieldDelegate,UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *lbl_iWatts;

@property (strong, nonatomic) IBOutlet UILabel *lbl_eDrivedata;

@property (strong, nonatomic) IBOutlet UIView *swipCycle;

@property (weak, nonatomic) IBOutlet UITextField *txt_voltage;

@property (strong, nonatomic) IBOutlet UITextField *txt_HSensorErr;

@property (strong, nonatomic) IBOutlet UILabel *lbl_BatteryCapacity;

@property (strong, nonatomic) IBOutlet UILabel *lbl_Kmrangeremaining;

@property (strong, nonatomic) IBOutlet UITextField *txt_kmRangeRemaining;

@property (strong, nonatomic) IBOutlet UITextField *txt_current;

@property (strong, nonatomic) IBOutlet UITextField *txt_whconsuming;

@property (strong, nonatomic) IBOutlet UITextField *txt_whremaining;

@property (strong, nonatomic) IBOutlet UITextField *txt_whmile;
@property (strong, nonatomic) IBOutlet UITextField *txt_temperature;


@property (strong, nonatomic) IBOutlet UILabel *lbl_Voltage;
@property (strong, nonatomic) IBOutlet UILabel *lbl_Current;

@property (strong, nonatomic) IBOutlet UILabel *lbl_Hallcode;

@property (strong, nonatomic) IBOutlet UILabel *lbl_Temp;
@property (strong, nonatomic) IBOutlet UILabel *lbl_WHRemaining;
@property (strong, nonatomic) IBOutlet UILabel *lbl_WHConsumed;

@property (strong, nonatomic) IBOutlet UITextField *txt_BatteryCapacity;
@property (strong, nonatomic) IBOutlet UITextField *txt_iWatts;

@property (strong, nonatomic) IBOutlet UILabel *lbl_WhKm;

-(void)showparameter;


@property (strong, nonatomic) IBOutlet UIImageView *wirelessImg;

@property (strong, nonatomic) IBOutlet UIView *view1;
@property (strong, nonatomic) IBOutlet UIView *view2;
@property (strong, nonatomic) IBOutlet UIView *view3;
@property (strong, nonatomic) IBOutlet UIView *view4;
@property (strong, nonatomic) IBOutlet UIView *view5;
@property (strong, nonatomic) IBOutlet UIView *view6;
@property (strong, nonatomic) IBOutlet UIView *view7;
@property (strong, nonatomic) IBOutlet UIView *view8;
@property (strong, nonatomic) IBOutlet UIView *view9;
@property (strong, nonatomic) IBOutlet UIView *view10;




@end
