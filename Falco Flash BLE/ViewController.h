//power level transmission1 completed
//  ViewController.h
//  nRF UART
//
//  Created by Ole Morten on 1/11/13.
//  Copyright (c) 2013 Nordic Semiconductor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UARTPeripheral.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "MessageStructure.h"
#import "ScannerDelegate.h"
#import "ScannedPeripheral.h"
#import "ScannerViewController.h"


NS_ASSUME_NONNULL_BEGIN
extern int countclose,tscountclose;
extern BOOL startFlag,timerStopFlag,timerFlag,flagForConnectMsg;
extern double targetpower;
extern float avgdstncinmph;
extern double speedmph;
//For Speed
extern Byte power_level;
extern int flagforpower;
extern int mycount;
extern BOOL flagStatus;

//For Timer
extern int timerset;
extern int seconds,minutes,hours;
extern int totalTimeInSec;

//For Distance
extern float distance,distance1;


@interface ViewController :UIViewController< UITextViewDelegate, UITextFieldDelegate,UIScrollViewDelegate,CBCentralManagerDelegate, CBPeripheralDelegate,UIGestureRecognizerDelegate>

@property id<CBPeripheralDelegate> delegate;
@property (readwrite) NSUInteger length;
@property (readwrite) const void *bytes NS_RETURNS_INNER_POINTER;
@property (strong, nonatomic) IBOutlet UIView *view2;

@property (strong, nonatomic) IBOutlet UIView *view3;

//+ (CBUUID *) uartServiceUUID;




@property CBService *uartService;


//@property (retain, nonatomic) PowerScreenViewController *selfObj;
//@property UARTPeripheral *currentPeripheral;

//@property UARTPeripheral *uartPeripheral;

@property (strong, nonatomic) IBOutlet UIView *SwipeControl;
@property (strong, nonatomic) IBOutlet UIView *MainViewControl;

//@property CBPeripheral *peripheral2;
//@property CBPeripheral *cbperipheral;
@property (strong, nonatomic) CBCentralManager *bluetoothManager;
@property (strong, nonatomic) IBOutlet UILabel *lbl_Speed;

@property (strong, nonatomic) IBOutlet UIImageView *blankWings;

//@property(nonatomic,assign)id delegate;
@property (strong, nonatomic) IBOutlet UILabel *lbl_Timer;
@property (strong, nonatomic) IBOutlet UILabel *lbl_Distance;


@property (nonatomic, strong) CBCharacteristic *uartRXCharacteristic;

@property (strong, nonatomic) IBOutlet UILabel *txtSpeed;

@property(strong,nonatomic) NSTimer *secondsTimer;


@property (strong, nonatomic) IBOutlet UIButton *connectButton;
- (IBAction)connectButtonPressed:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *btn_KPH;

@property (strong, nonatomic) IBOutlet UIButton *btn_MPH;



@property (strong, nonatomic) IBOutlet UILabel *txttimer;


@property (strong, nonatomic) IBOutlet UILabel *distanceLable;
@property(assign,nonatomic)int count;

@property (strong, nonatomic) IBOutlet UIButton *startButton;
@property (strong, nonatomic) IBOutlet UIImageView *img_Wireless;

@property (weak, nonatomic) IBOutlet UIImageView *batteryImageView;

@property (weak, nonatomic) IBOutlet UIImageView *powerLavelImageView;
//------------------- Power Level ----------------------------
@property (strong, nonatomic) IBOutlet UIImageView *powerDisplayImageView;

@property (strong, nonatomic) IBOutlet UIButton *emergencyStop;
- (IBAction)emergencyStop:(id)sender;

NS_ASSUME_NONNULL_END
@end
