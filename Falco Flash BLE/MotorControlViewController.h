//
//  MotorControlViewController.h
//  Falco Flash BLE
//
//  Created by Falco eMotors Pvt. Ltd. on 15/10/2016.
//  Copyright © 2016 Falco eMotors Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UARTPeripheral.h"
typedef enum
{
    IDLE = 0,
    SCANNING,
    CONNECTED,
} ConnectionState;



@interface MotorControlViewController : UIViewController<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSArray *dropoutData;
}
@property ConnectionState state;
@property (strong, nonatomic) IBOutlet UIView *motorView;
@property (strong, nonatomic) IBOutlet UIImageView *img_disp;
@property (strong, nonatomic) IBOutlet UITextField *txtturnonspeed;
@property(nonatomic, assign) NSNumber* maxLength;
@property (strong, nonatomic) IBOutlet UITextField *txtturnondelay;

@property (strong, nonatomic) IBOutlet UITextField *txtturnoffdelay;

@property (strong, nonatomic) IBOutlet UITextField *txtbasetorque;

@property (strong, nonatomic) IBOutlet UITextField *txtflipaxel;

@property (strong, nonatomic) IBOutlet UITextField *txttorquemultiplier;

@property (strong, nonatomic) IBOutlet UITextField *txttsturnon;

@property (strong, nonatomic) IBOutlet UITextField *txtdropoutoffset;

- (IBAction)btnbroadcast:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnbroadcast;

- (IBAction)btnmemoryread:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnmemoryread;

- (IBAction)btnrestore:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnrestore;
@property(strong,nonatomic)NSMutableArray *randarray,*randarray1;


@property (strong, nonatomic) IBOutlet UIProgressView *memoryReadProgressBar;

@property (strong, nonatomic) IBOutlet UIImageView *wireless5image;
@property (strong, nonatomic) IBOutlet UILabel *lbl_MotorControl;
@property (strong, nonatomic) IBOutlet UILabel *lbl_TurnOnSpeed;
@property (strong, nonatomic) IBOutlet UILabel *lbl_TurnOnDelay;
@property (strong, nonatomic) IBOutlet UILabel *lbl_BaseTorque;
@property (strong, nonatomic) IBOutlet UILabel *lbl_TurnOffDelay;
@property (strong, nonatomic) IBOutlet UILabel *lbl_FlipAxel;
@property (strong, nonatomic) IBOutlet UILabel *lbl_TorqueMultiplier;
@property (strong, nonatomic) IBOutlet UILabel *lbl_TsTurnOn;
@property (strong, nonatomic) IBOutlet UILabel *lbl_DropoutOffset;
@property (strong, nonatomic) IBOutlet UILabel *lbl_DropoutSelect;
@property (strong, nonatomic) IBOutlet UIPickerView *dropout_Picker;
@property (strong, nonatomic) IBOutlet UIButton *btn_Send;



@end
