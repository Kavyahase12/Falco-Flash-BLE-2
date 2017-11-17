//
//  TorqueMotorParameterViewController.h
//  Falco Flash BLE
//
//  Created by Falco eMotors Pvt. Ltd. on 15/10/2016.
//  Copyright © 2016 Falco eMotors Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UARTPeripheral.h"
#import "ViewController.h"

typedef enum
{
    IDLE = 0,
    SCANNING,
    CONNECTED,
} ConnectionState;


@interface TorqueMotorParameterViewController : UIViewController<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *wireless6image;

@property (strong, nonatomic) IBOutlet UIImageView *ts_image;


@property (strong, nonatomic) IBOutlet UITextField *TSRawText;
@property (strong, nonatomic) IBOutlet UITextField *TSPeakText;

@property (strong, nonatomic) IBOutlet UITextField *TSFinalText;


@property (strong, nonatomic) IBOutlet UITextField *TSRectiLable;


@property (weak, nonatomic) IBOutlet UIView *torqueView;
@property (strong, nonatomic) IBOutlet UILabel *lbl_MotorParameter;
@property (strong, nonatomic) IBOutlet UILabel *lbl_TSRectified;
@property (strong, nonatomic) IBOutlet UILabel *lbl_TSFinal;
@property (strong, nonatomic) IBOutlet UILabel *lbl_TSPeak;
@property (strong, nonatomic) IBOutlet UILabel *lbl_TSRaw;
@property ConnectionState state;



@end
