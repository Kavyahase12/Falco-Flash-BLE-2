//
//  ManufacturingScreenViewController.h
//  Falco Flash BLE
//
//  Created by Falco eMotors Pvt. Ltd. on 15/10/2016.
//  Copyright © 2016 Falco eMotors Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UARTPeripheral.h"
#import "ViewController.h"
@interface ManufacturingScreenViewController : UIViewController<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIView *ManuScreenView;



@property (strong, nonatomic) IBOutlet UITextField *MotorIDLable;


@property (strong, nonatomic) IBOutlet UITextField *Firmware_Lable;


@property (strong, nonatomic) IBOutlet UITextField *TS_ID_Lable;



@property (strong, nonatomic) IBOutlet UITextField *VoltageLable;





@property (strong, nonatomic) IBOutlet UIButton *Broadcast;

- (IBAction)onVoltageBroadcast:(id)sender;


@property (strong, nonatomic) IBOutlet UIButton *checked_1;
- (IBAction)checked_1:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *unchecked_1;
- (IBAction)unchecked_1:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *checked_2;
- (IBAction)checked_2:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *unchecked_2;
- (IBAction)unchecked_2:(id)sender;


@property (strong, nonatomic) IBOutlet UIButton *checked_3;
- (IBAction)checked_3:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *unchecked_3;
- (IBAction)unchecked_3:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *lbl_firmware;

@property (strong, nonatomic) IBOutlet UIButton *checked_4;
- (IBAction)checked_4:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *unchecked_4;
- (IBAction)unchecked_4:(id)sender;


@property(strong,nonatomic)NSMutableArray *broadcastArray;
@property(strong,nonatomic)NSMutableArray *motorIDArray;
@property(strong,nonatomic)NSMutableArray *TSIDArray;
@property (strong, nonatomic) IBOutlet UIImageView *img_disp;

@property (strong, nonatomic) IBOutlet UILabel *lbl_Manufacturingparameter;


@property (strong, nonatomic) IBOutlet UIImageView *wireless8image;
@property (strong, nonatomic) IBOutlet UILabel *lbl_MotorID;
@property (strong, nonatomic) IBOutlet UILabel *lbl_TSID;
@property (strong, nonatomic) IBOutlet UILabel *lbl_TurnONVoltage;
@property (strong, nonatomic) IBOutlet UILabel *lbl_ErrorMsg;

@end

