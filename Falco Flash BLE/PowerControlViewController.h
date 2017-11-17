//
//  PowerControlViewController.h
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


@interface PowerControlViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate>
{
    
    NSArray *pickerData,*currentPickerData,*datacount;
    
}


@property ConnectionState state;

@property (strong, nonatomic) IBOutlet UIView *powerView;
@property (strong, nonatomic) IBOutlet UIView *AssistView;
@property (strong, nonatomic) IBOutlet UIView *regenView;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;
@property (strong, nonatomic) IBOutlet UIImageView *img_disp;
@property (strong, nonatomic) IBOutlet UIPickerView *currentpickerview;
@property (strong, nonatomic) IBOutlet UILabel *lbl_PowerConfigurator;

@property (strong, nonatomic) IBOutlet UIButton *btn_Restorecurrentclamp;

@property (strong, nonatomic) IBOutlet UISegmentedControl *assistContainerView;

@property (strong, nonatomic) IBOutlet UISegmentedControl *RegenContainerView;

@property (strong, nonatomic) IBOutlet UIImageView *wireless8image;

///////////////////For Motor Type/////////////////////////
@property (strong, nonatomic) IBOutlet UIButton *motortype;
- (IBAction)onMotorType:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *motorTypeTextfield;

-(void)restoreRegenClamp;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentCurrentClamp;

@property (strong, nonatomic) IBOutlet UISlider *slider1;
@property (strong, nonatomic) IBOutlet UISlider *slider2;
@property (strong, nonatomic) IBOutlet UISlider *slider3;
@property (strong, nonatomic) IBOutlet UISlider *slider4;
@property (strong, nonatomic) IBOutlet UISlider *slider5;
@property (strong, nonatomic) IBOutlet UISlider *slider6;

@property (strong, nonatomic) IBOutlet UIButton *btn_MemoryRead;
@property (strong, nonatomic) IBOutlet UIButton *btn_Broadcast;

//- (IBAction)AssistBroadcastData:(id)sender;
@property(strong,nonatomic)NSMutableArray *clamp_level;
@property(assign)long val1,val2,val3,val4,val5,val6;


@property (strong, nonatomic) IBOutlet UILabel *lbl_1;
@property (strong, nonatomic) IBOutlet UILabel *lbl_2;
@property (strong, nonatomic) IBOutlet UILabel *lbl_3;
@property (strong, nonatomic) IBOutlet UILabel *lbl_4;
@property (strong, nonatomic) IBOutlet UILabel *lbl_5;
@property (strong, nonatomic) IBOutlet UILabel *lbl_6;
@property (strong, nonatomic) IBOutlet UITextField *txt_1;
@property (strong, nonatomic) IBOutlet UITextField *txt_2;
@property (strong, nonatomic) IBOutlet UITextField *txt_3;
@property (strong, nonatomic) IBOutlet UITextField *txt_4;
@property (strong, nonatomic) IBOutlet UITextField *txt_5;
@property (strong, nonatomic) IBOutlet UITextField *txt_6;

@property (strong, nonatomic) IBOutlet UITextField *txt_BatterySelect;
@property (strong, nonatomic) IBOutlet UIButton *btn_Battery;
@property (strong, nonatomic) IBOutlet UILabel *lbl_PowerLevel;
@property (strong, nonatomic) IBOutlet UILabel *lbl_CurrentClamp;

//- (IBAction)selectPickerAssist:(id)sender;
//@property (strong, nonatomic) IBOutlet UIButton *selectPickerAssist;
@end
