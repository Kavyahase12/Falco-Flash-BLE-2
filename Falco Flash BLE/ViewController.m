//
//  ViewController.m
//  nRF UART
//
//  Created by Ole Morten on 1/11/13.
//  Copyright (c) 2013 Nordic Semiconductor. All rights reserved.
//

#import "ViewController.h"
#import "UARTPeripheral.h"
#import "Cycle_AnalysisViewController.h"

//#import  "MessageStructure.h"
bool kphflag,mphflag;
double speedmph,avg_speed=0;
int initialcounter;
int flagforpower;
int mycount,oneSecondCounter,onKphcount=2;
int countclose=0,tscountclose=0,clickCounter;
float mphDistance;
BOOL flagStatus,timerStopFlag;
NSString *myTime;
int counterTime=0,minuteCounter=0,secondCounter=0,hourCounter=0;
NSString *timeDisplay;

BOOL countflagBool=false,checkConnectionFlagBool=false;
int vtgCount=0,noCount=0;

BOOL emergencyFlag=false;
UIActivityIndicatorView *activityConnecting;
UIView *loadingView;
UILabel *loadingLabel;
NSTimer *timerForConnection;


BOOL conectionflagtodisable=false;
//power level ince decr

Byte power_level_increment[] = {0x80 , 0,0,0,0,0,0,0,0,0,0,0,0,0,0}; // used to send increment command & relative power level
Byte power_level_decrement[] = {0x82 , 0,0,0,0,0,0,0,0,0,0,0,0,0,0};
Byte power_level =0;

Byte positive_power_level = 0;
Byte negative_power_level = 0;

NSData *datapowerlevel=0;

//

//For display safety message

int valueforStore=0,swapCount;
typedef enum
{
    IDLE = 0,
    SCANNING,
    CONNECTED,
} ConnectionState;

typedef enum
{
    LOGGING,
    RX,
    TX,
}ConsoleDataType;

@interface ViewController ()

@property CBCentralManager *cm;
@property ConnectionState state;
@property UARTPeripheral *currentPeripheral;
@property (nonatomic, retain) UIView *loadingView;
@property (nonatomic, retain) UILabel *loadingLabel;

@end

UARTPeripheral *uartobj;

int totalTimeInSec;

BOOL viewstatusController;

//for Distance
float distance=0.0,distance1=0.0,mphDistance=0.0;


@implementation ViewController

@synthesize txtSpeed,connectButton;
@synthesize cm = _cm;
@synthesize currentPeripheral = _currentPeripheral;
@synthesize btn_KPH,btn_MPH;
@synthesize distanceLable,startButton;

@synthesize MainViewControl;





- (void)viewDidLoad
{
    [super viewDidLoad];
    
    activityConnecting = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityConnecting.transform = CGAffineTransformMakeScale(2.5, 2.5);
    
    activityConnecting.color=[UIColor blackColor];
    activityConnecting.alpha = 1.0;
    
    
    [_SwipeControl addSubview:activityConnecting];
    activityConnecting.center = CGPointMake([[UIScreen mainScreen]bounds].size.width/2, [[UIScreen mainScreen]bounds].size.height/2);
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    valueforStore=0;
    
    if (voltageDec == 36)
    {
        self.batteryImageView.image = [UIImage imageNamed:@"Icon-70"];
        
    }
    
    
    txtSpeed.hidden=false;

    [self adjustFontSizeOfLabel];
    _blankWings.hidden=false;
    
    motorReceiveFlag=true;
    initialcounter=0;
    flagforpower=0;
    mphStateFlag=true;
    
    if (viewstatusController==true)
    {
        if ([updateFirmware isEqual:@"101026"]||[updateFirmware isEqual:@"101082"])
        {
            timerStopFlag=true;
            UIAlertController * alert = [UIAlertController
                                         alertControllerWithTitle: @""
                                         message:@"We can't connect to Terra Trike Motor using General eBike Lab Application.Please use Falco Flash BLE x.xx TT App."
                                         
                                         preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:@"OK"                                   style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action)
                                        {
                                            timerStopFlag=true;
                                            [self.cm cancelPeripheralConnection:self.currentPeripheral.peripheral];// FOR STOP CONNECTION
                                            [self dismissViewControllerAnimated:YES completion:nil];
                                            //Handle your yes please button action here
                                        }];
            
            
            
            [alert addAction:yesButton];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
        else
        {
        [self didReceiveData];
        }
        if (kphStateFlag==true)
        {
            mphStateFlag=false;
        }
        if (mphStateFlag==true)
        {
            
            kphStateFlag=false;
        }
    }
    
    
    
    self.cm = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    tscm=self.cm;
    [self addTextToConsole:@"Did start application" dataType:LOGGING];
    mytime=[[NSString alloc]init];
    
    UISwipeGestureRecognizer *swipeUpOrange = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(slideToUpWithGestureRecognizer:)];
    swipeUpOrange.direction = UISwipeGestureRecognizerDirectionUp;
    
    
    UISwipeGestureRecognizer *swipeDownOrange = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(slideToDownWithGestureRecognizer:)];
    swipeDownOrange.direction = UISwipeGestureRecognizerDirectionDown;
    
    UISwipeGestureRecognizer *swipeRightOrange = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(slideToRight:)];
    swipeRightOrange.direction=UISwipeGestureRecognizerDirectionRight;
    
    [self.SwipeControl addGestureRecognizer:swipeRightOrange];
    [self.SwipeControl addGestureRecognizer:swipeUpOrange];
    [self.SwipeControl addGestureRecognizer:swipeDownOrange];
    
    
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    firmwareCheck=true;
    
    
    NSUserDefaults *standardUserDefault = [NSUserDefaults standardUserDefaults];
    NSNumber *age = nil;
    
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSNumber *num = nil;
    
    if (standardUserDefault)
        num = [prefs objectForKey:@"MessageValue"];
    valueforStore = [num intValue];
    
    
    
    if (standardUserDefault)
        age = [standardUserDefault objectForKey:@"CRMValue"];
    
    CRM = [age intValue];
    
    
    NSUserDefaults *standardUserDefaults1 = [NSUserDefaults standardUserDefaults];
    NSNumber *battryValue = nil;
    
    [self selfCall];
    [self UIDesign];
    
}


-(void)viewWillAppear:(BOOL)animated

{
    dispatch_async(dispatch_get_main_queue(),
                   ^{
                       
                       
                       if (valueforStore==0&&swapCount==0)
                       {
                           UIAlertController * alert = [UIAlertController
                                                        alertControllerWithTitle:@""
                                                        message:@"."
                                                        
                                                        preferredStyle:UIAlertActionStyleCancel];
                           
                           
                           NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:@"Always use your best judgment about the safety of road condition.Follow traffic laws and do not be distracted by this device while in motion or in any potentially unsafe area"];
                           [hogan addAttribute:NSFontAttributeName
                                         value:[UIFont systemFontOfSize:20.0]
                                         range:NSMakeRange(1, 1)];
                           [alert setValue:hogan forKey:@"attributedMessage"];
                           
                           
                           
                           UIAlertAction* yesButton = [UIAlertAction
                                                       actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action)
                                                       {
                                                           
                                                       }];
                           UIAlertAction* message = [UIAlertAction
                                                     actionWithTitle:@"Do not show this message again." style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         //Handle your yes please button action here
                                                         valueforStore=1;
                                                         [[NSUserDefaults standardUserDefaults] setInteger:valueforStore forKey:@"MessageValue"];
                                                     }];
                           
                           
                           [alert addAction:yesButton];
                           [alert addAction:message];
                           
                           
                           [self presentViewController:alert animated:YES completion:nil];
                           
                       }
                   });
}


-(void)selfCall
{
    if (receptionStartFlag==true)
    {
        _img_Wireless.hidden=false;
        _txttimer.text=timeDisplay;
        
        if ([updateFirmware isEqual:@"101026"]||[updateFirmware isEqual:@"101082"])
        {
            timerStopFlag=true;
            UIAlertController * alert = [UIAlertController
                                         alertControllerWithTitle: @""
                                         message:@"We can't connect to Terra Trike Motor using General eBike Lab Application.Please use Falco Flash BLE x.xx TT App."

                                         preferredStyle:UIAlertControllerStyleAlert];

            UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:@"OK"                                   style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action)
                                        {
                                            timerStopFlag=true;
                                            [self.cm cancelPeripheralConnection:self.currentPeripheral.peripheral];// FOR STOP CONNECTION
                                            [self dismissViewControllerAnimated:YES completion:nil];
                                            //Handle your yes please button action here
                                        }];



            [alert addAction:yesButton];

            [self presentViewController:alert animated:YES completion:nil];
        }
        else
        {
            [self didReceiveData];
        }
    }
    
    if (receptionStartFlag==false)
    {
        _img_Wireless.hidden=true;
    }
    
    [self performSelector:@selector(selfCall) withObject:nil afterDelay:1];
    
    
    
}

-(void)slideToRight:(UISwipeGestureRecognizer *)gestureRecognizer{
    [UIView animateWithDuration:0.5 animations:^{
        
        NSString *message = @"This is first screen";
        
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                       message:message
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        int duration = 1; // duration in seconds
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [alert dismissViewControllerAnimated:YES completion:nil];
        });
        
    }];
}

-(void)sendDataToA:(NSArray *)array
{
    [self didReceiveData];
    
}


-(void)selfrecall
{
    
    switch (power_level)
    {
            
        case 0:
            self.powerDisplayImageView.image = [UIImage imageNamed:@"Icon-50"];
            
            
            
            break;
            
            /***********case 1 to case 5 are used for positive powerlevel*************/
            
        case 1:
            self.powerDisplayImageView.image = [UIImage imageNamed:@"Icon-79"];
            break;
        case 2:
            self.powerDisplayImageView.image = [UIImage imageNamed:@"Icon-80"];
            break;
            
        case 3:
            self.powerDisplayImageView.image = [UIImage imageNamed:@"Icon-81"];
            break;
            
        case 4:
            self.powerDisplayImageView.image = [UIImage imageNamed:@"Icon-82"];
            break;
            
        case 5:
            self.powerDisplayImageView.image = [UIImage imageNamed:@"Icon-83"];
            break;
            
            /************case -1 to case -4 are used for negative powerlevel***********/
            
        case 251:
            self.powerDisplayImageView.image = [UIImage imageNamed:@"Icon-58"];
            
            break;
            
        case 252:
            self.powerDisplayImageView.image = [UIImage imageNamed:@"Icon-57"];
            
            break;
            
        case 253:
            self.powerDisplayImageView.image = [UIImage imageNamed:@"Icon-56"];
            
            break;
            
        case 254:
            self.powerDisplayImageView.image = [UIImage imageNamed:@"Icon-55"];
            
            break;
            
        case 255:
            self.powerDisplayImageView.image = [UIImage imageNamed:@"Icon-54"];
            
            break;
            
            /** case 0 is used for set to 0 powerlevel ****/
            
        default:
            break;
            
    }
    
}

-(void)slideToUpWithGestureRecognizer:(UISwipeGestureRecognizer *)gestureRecognizer
{
    if(receptionStartFlag==true)
    {
        power_level++;// increament the power level.
        if (power_level > 5 && power_level <= 251)
        {
            power_level = 5;//it will check the current status of the power level. if power level is more than 5 it stay in 5 level
        }
        if (power_level <= 5)// it checks if the power level is less than 5 // this condition is always true
        {
            positive_power_level = power_level;
            
            power_level_increment[1] = power_level;
            
            
            datapowerlevel = [NSData dataWithBytes:power_level_increment length:sizeof(power_level_increment)];
            
            if ((txChar.properties & CBCharacteristicPropertyWrite) != 0)
            {
                [myperipheral writeValue:datapowerlevel forCharacteristic:txChar
                                    type:CBCharacteristicWriteWithoutResponse];
                
                
            }
            else if ((txChar.properties & CBCharacteristicPropertyWrite) != 0)
            {
                [myperipheral writeValue:datapowerlevel forCharacteristic:txChar type:CBCharacteristicWriteWithResponse];
            }
            else
            {
                NSLog(@"No write property on TX characteristic, %lu.", (unsigned long)txChar.properties);
            }
            
        }
        if (power_level <= 255 && power_level >= 251)//this condition is set when the power level is minus
        {
            
            positive_power_level = (power_level * -1);//it store the negative power level into the variable
            
            power_level_decrement[1] = (power_level);//store the power level value into buffer of the power level increment, which we transomitt to paired motor
            
            datapowerlevel = [NSData dataWithBytes:power_level_decrement length:sizeof(power_level_decrement)];
            
            if ((txChar.properties & CBCharacteristicPropertyWrite) != 0)
            {
                [myperipheral writeValue:datapowerlevel forCharacteristic:txChar
                                    type:CBCharacteristicWriteWithoutResponse];
                
                
            }
            else if ((txChar.properties & CBCharacteristicPropertyWrite) != 0)
            {
                [myperipheral writeValue:datapowerlevel forCharacteristic:txChar type:CBCharacteristicWriteWithResponse];
            }
            else
            {
                NSLog(@"No write property on TX characteristic, %lu.", (unsigned long)txChar.properties);
            }
            
        }
        [self selfrecall];
    }
    else{
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@""
                                     message:@"Please reconnect to motor"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"OK"    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        
                                        //Handle your yes please button action here
                                        
                                        
                                        timerStopFlag=true;
                                      
                                        [self.cm stopScan];
                                        [self dismissViewControllerAnimated:YES completion:nil];
                                    }];
        
        
        
        
        [alert addAction:yesButton];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}

-(void)slideToDownWithGestureRecognizer:(UISwipeGestureRecognizer *)gestureRecognizer
{
    if(receptionStartFlag==true)
    {
        power_level--;// decrement the power level.
        
        if (power_level <251 && power_level > 5)
            power_level = 251;
        
        else if (power_level >= 0 && power_level <= 5)
        {
            negative_power_level = power_level;
            power_level_increment[1] = power_level;//store the power level value into buffer of the power level increment, which we transomitt to paired motor
            
            datapowerlevel = [NSData dataWithBytes:power_level_increment length:sizeof(power_level_increment)];
            
            if ((txChar.properties & CBCharacteristicPropertyWrite) != 0)
            {
                [myperipheral writeValue:datapowerlevel forCharacteristic:txChar
                                    type:CBCharacteristicWriteWithoutResponse];
                
                
            }
            else if ((txChar.properties & CBCharacteristicPropertyWrite) != 0)
            {
                [myperipheral writeValue:datapowerlevel forCharacteristic:txChar type:CBCharacteristicWriteWithResponse];
            }
            else
            {
                NSLog(@"No write property on TX characteristic, %lu.", (unsigned long)txChar.properties);
            }
            
        }
        
        else if (power_level <= 255 && power_level >= 251)//this condition is set when the power level is minus
        {
            negative_power_level = (power_level * -1);//it store the negative power level into the variable positive_power_level
            
            
            power_level_decrement[1] = (power_level);
            
            datapowerlevel = [NSData dataWithBytes:power_level_decrement length:sizeof(power_level_decrement)];
            
            if ((txChar.properties & CBCharacteristicPropertyWrite) != 0)
            {
                [myperipheral writeValue:datapowerlevel forCharacteristic:txChar
                                    type:CBCharacteristicWriteWithoutResponse];
                
                
            }
            else if ((txChar.properties & CBCharacteristicPropertyWrite) != 0)
            {
                [myperipheral writeValue:datapowerlevel forCharacteristic:txChar type:CBCharacteristicWriteWithResponse];
            }
            else
            {
                NSLog(@"No write property on TX characteristic, %lu.", (unsigned long)txChar.properties);
            }
            
            
        }
        
        
        [self selfrecall];
    }
    
    else{
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@""
                                     message:@"Please reconnect to motor"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"OK"    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        
                                        //Handle your yes please button action here
                                        
                                        
                                        timerStopFlag=true;
                                        //                                        [self.cm cancelPeripheralConnection:self.currentPeripheral.peripheral];// FOR STOP CONNECTION
                                        [self dismissViewControllerAnimated:YES completion:nil];
                                    }];
        
        
        
        
        [alert addAction:yesButton];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}


- (IBAction)connectButtonPressed:(id)sender
{
    int8_t bytes2[] ={121,00,00,00,00,00,00,00,00,00,00,00,00};
    NSData *data2 = [NSData dataWithBytes:bytes2 length:sizeof(bytes2)];
    
    if ((txChar.properties & CBCharacteristicPropertyWrite) != 0)
    {
        [myperipheral writeValue:data2 forCharacteristic:txChar
                            type:CBCharacteristicWriteWithResponse];
        NSLog(@"Battery value is %d",batteryvalue);
        
    }
    
    clickCounter++;
    
    
    
    [self connectionHandle];
    
}




-(void)connectionHandle
{
    conectionflagtodisable=true;
    CGRect screenSize = [[UIScreen mainScreen]bounds];
    if (screenSize.size.height <= 568)
    {
        // IPhone 5/5s/5c
        
        loadingView = [[UIView alloc] initWithFrame:CGRectMake(75, 175, 170, 140)];
        
    }
    
    
    else if (screenSize.size.width <= 375)
    {
        // iPhone 6
        loadingView = [[UIView alloc] initWithFrame:CGRectMake(100, 202, 170, 140)];
        
    }
    else if (screenSize.size.width <= 414)
    {
        // iPhone 6+/7
        loadingView = [[UIView alloc] initWithFrame:CGRectMake(117, 227, 170, 140)];
        
    }
    
    
    loadingView.backgroundColor = [UIColor blackColor];
    
    loadingView.alpha=1.0;
    loadingView.clipsToBounds = YES;
    loadingView.layer.cornerRadius = 10.0;
    txtSpeed.hidden=true;
    
    activityConnecting = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    activityConnecting.frame = CGRectMake(75, 40, activityConnecting.bounds.size.width/2, activityConnecting.bounds.size.height/2);
    
    [loadingView addSubview:activityConnecting];
    
    loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 85, 130, 22)];
    loadingLabel.backgroundColor = [UIColor clearColor];
    loadingLabel.textColor = [UIColor whiteColor];
    loadingLabel.adjustsFontSizeToFitWidth = YES;
    loadingLabel.textAlignment = NSTextAlignmentCenter;
    loadingLabel.text = @"Connecting...";
    
    [loadingView addSubview:loadingLabel];
    
    [_SwipeControl addSubview:loadingView];
    
    
    
    
    if (clickCounter%2==0)
    {
        
        UIImage *btnImage = [UIImage imageNamed:@"Icon-44"];
        [connectButton setImage:btnImage forState:UIControlStateNormal];
        loadingView.hidden=true;
        txtSpeed.hidden=false;
        txtSpeed.text=@"00";
        viewstatusController=false;
        
        //  timerset=1;
        if (receptionStartFlag==true)
        {
            
            timerStopFlag=true;
            [self.cm cancelPeripheralConnection:self.currentPeripheral.peripheral];// FOR STOP CONNECTION
            
            
            
        }
        
    }else
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                       ^{
                           for (NSInteger i = 1; i <= 30; i++)
                           {
                               
                               [NSThread sleepForTimeInterval:0.150];
                               dispatch_async(dispatch_get_main_queue(),
                                              ^{
                                                  
                                                 MainViewControl.userInteractionEnabled = NO;
                                                  [activityConnecting startAnimating];
                                                  
                                              });
                           }//
                           
                       });
        
        
        UIImage *btnImage = [UIImage imageNamed:@"Icon-60"];
        [connectButton setImage:btnImage forState:UIControlStateNormal];
        double delayInSeconds = 15.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                       {
                           switch (self.state)
                           {
                               case IDLE:
                                   self.state = SCANNING;
                                   
                                   NSLog(@"Started scan ...");
                                   [self.connectButton setTitle:@"Scanning ..." forState:UIControlStateNormal];
                                   
                                   [self.cm scanForPeripheralsWithServices:nil options:nil];
                                   
                                   viewstatusController=true;
                                   
                                   
                                   break;
                                   
                               case SCANNING:
                                   self.state = IDLE;
                                   
                                   NSLog(@"Stopped scan");
                                   [self.connectButton setTitle:@"Connect" forState:UIControlStateNormal];
                                   
                                   [self.cm stopScan];
                                   break;
                                   
                               case CONNECTED:
                                   NSLog(@"Disconnect peripheral %@", self.currentPeripheral.peripheral.name);
                                   [self.cm cancelPeripheralConnection:self.currentPeripheral.peripheral];
                                   break;
                           }
                       }
                       );
        
        
    }
    
    [NSTimer scheduledTimerWithTimeInterval:25.0
                                     target:self
                                   selector:@selector(update)
                                   userInfo:nil
                                    repeats:NO];
}

-(void)update
{
    if (receptionStartFlag==true)
    {
        //        UIAlertController * alert = [UIAlertController
        //                                     alertControllerWithTitle:@""
        //                                     message:@"Successfully Connected"
        //                                     preferredStyle:UIAlertControllerStyleAlert];
        //
        //        UIAlertAction* yesButton = [UIAlertAction
        //                                    actionWithTitle:@"OK"   style:UIAlertActionStyleDefault
        //                                    handler:^(UIAlertAction * action) {
        //                                        //Handle your yes please button action here
        //                                    }];
        //
        //
        //        [alert addAction:yesButton];
        //
        //        [self presentViewController:alert animated:YES completion:nil];
        
        
    }
    else
    {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@""
                                     message:@"Please reconnect to motor"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"OK"    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        
                                        //Handle your yes please button action here
                                        
                                        
                                        timerStopFlag=true;
                                        //                                        [self.cm cancelPeripheralConnection:self.currentPeripheral.peripheral];// FOR STOP CONNECTION
                                        [self dismissViewControllerAnimated:YES completion:nil];
                                    }];
        
        txtSpeed.hidden=false;
        [activityConnecting stopAnimating];
        [loadingView removeFromSuperview];
        _SwipeControl.userInteractionEnabled = YES;
        
        
        [alert addAction:yesButton];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        
        
    }
    MainViewControl.userInteractionEnabled = YES;
}

- (void) didReadHardwareRevisionString:(NSString *)string
{
    [self addTextToConsole:[NSString stringWithFormat:@"Hardware revision: %@", string] dataType:LOGGING];
}

-(void)updateSpeedTimer
{
    oneSecondCounter++;
    if (oneSecondCounter==4) {
        
        
        distance+=(avgspeed1S/4)/3600;
        distance1+=(avgspeed2S/4)/3600;
        avgspeed1S = 0;//resset the value of 1s to capture next 4 event of 250 ms
        avgspeed2S = 0;
        oneSecondCounter=0;
        
    }
    avg_power_display +=(power *0.0000694);//(power*0.0000694);//new equation for watt-hour
    
    //    avg_power_display +=(power *(1/(2.65*36000)));
    
    avgspeed1S = avgspeed1S + (double) speed;//take avg of speed for 1sec(by adding speed at every 250 ms)
    avgspeed2S = avgspeed2S + (double) speedmph;//take avg of speed for 1sec(by adding speed at every 250 ms)
    
    NSLog(@"avg_power_display==%.1f",avg_power_display);
    
    
    if(timerStopFlag==false)
    {
        [self performSelector:@selector(updateSpeedTimer) withObject:nil afterDelay:0.250];
    }
}


-(void)UpdateTimer
{
    counterTime++;
    secondCounter=counterTime;
    if (counterTime>59)
    {
        minuteCounter++;
        //            oneSecondCounter++;
        counterTime=0;
    }
    //secondCounter=0;
    if (minuteCounter>59)
    {
        hourCounter++;
        minuteCounter=0;
        
    }
    
    NSString *hourtime=[NSString stringWithFormat:@"%.2d:",hourCounter];
    NSString *minutetime=[NSString stringWithFormat:@"%.2d:",minuteCounter];
    NSString *secondtime=[NSString stringWithFormat:@"%.2d",counterTime];
    
    timeDisplay=[hourtime stringByAppendingString:[minutetime stringByAppendingString:secondtime]];
    
    _txttimer.text=timeDisplay;
    NSLog(@"/n /n Timer===%@ /n /n",timeDisplay);
    
    if (timerStopFlag==false)
        
    {
        [self performSelector:@selector(UpdateTimer) withObject:nil afterDelay:1];
    }
    
    
}
- (void) didReceiveData
{
    MainViewControl.userInteractionEnabled = YES;
    conectionflagtodisable=false;
    txtSpeed.hidden=false;
    [activityConnecting stopAnimating];
    [loadingView removeFromSuperview];
    _SwipeControl.userInteractionEnabled = YES;
    
    if(++vtgCount <=10)
    {
        
        if(voltageDec!=0)
        {
            if (++noCount==15)
            {
                
                countflagBool=false;
                vtgCount=0;
                noCount=0;
                
            }
        }
        else
        {
            if (vtgCount==10)
            {
                UIAlertController * alert = [UIAlertController
                                             alertControllerWithTitle:@" Data not received"
                                             message:@"Please reconnect or change the eDrive Mode."
                                             
                                             preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* yesButton = [UIAlertAction
                                            actionWithTitle:@"OK"  style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * action)
                                            {
                                                //Handle your yes please button action here
                                                [self.cm cancelPeripheralConnection:self.currentPeripheral.peripheral];
                                                
                                                [self dismissViewControllerAnimated:YES completion:nil];
                                            }];
                
                
                [alert addAction:yesButton];
                
                [self presentViewController:alert animated:YES completion:nil];
                
                countflagBool=false;
                vtgCount=0;
                
            }
            
        }
    }
    
    NSString *str = [NSString stringWithFormat:@"%.1f",speed];
    txtSpeed.text = str;
    if (speed>300)
    {
        speed=0.0;
        
    }
    speedmph=speed/1.609344;
    NSString *strMph = [NSString stringWithFormat:@"%.1f",speedmph];
    
    NSString *str11=[NSString stringWithFormat:@"%.2f",distance];
    distanceLable.text=str11;
    mphDistance=distance/1.609344;
    NSString *str1=[NSString stringWithFormat:@"%.2f",mphDistance];
    
    if (kphflag==true)
    {
        
        
        NSString *str = [NSString stringWithFormat:@"%.1f",speed];
        txtSpeed.text = str;
        distanceLable.text=str11;
        
    }
    if (mphflag==true)
    {
        txtSpeed.text = strMph;
        distanceLable.text=str1;
    }
    if(current>=50.0)
    {
        current=50;
    }
    else
    {
        
        power=voltageDec*current;
        
        //    avg_power_display +=(power *(1/(2.65*36000)));
        
        powerRemain = targetpower - avg_power_display;
        //
        consumed=targetpower-powerRemain;
        //    whpkm=(avg_power_display/distance);
        //    whpmile=(avg_power_display/(distance1));
        
        if(distance>0)
        {
            whpkm=avg_power_display/distance;
            
            if (whpkm!=0)
            {
                whremain=(powerRemain/whpkm);
            }
        }
        
        if(distance1>0)
        {
            whpmile=avg_power_display/distance1;
            
            if (whpmile!=0)
            {
                whremainForMile=(powerRemain/whpmile);
                
            }
            
            
        }
        
    }
    
    
    
    
    /////////////////////////DISTANCE/////////////////////////////////////
    
    [self displayWingsMethod];
    
}




-(void)displayWingsMethod
{
    if (receptionStartFlag==true)
    {
        if(batteryvalue==1)
        {
            
            if(voltageDec<=29)
            {
                
                self.batteryImageView.image = [UIImage imageNamed:@"Icon-78"];
            }
            
            else if (voltageDec>=42)
            {
                
                self.batteryImageView.image = [UIImage imageNamed:@"Icon-47"];
                
            }
            else if (voltageDec > 29 && voltageDec <=35)
            {
                self.batteryImageView.image = [UIImage imageNamed:@"Icon-73"];
            }
            else if (voltageDec == 36)
            {
                self.batteryImageView.image = [UIImage imageNamed:@"Icon-70"];
                
            }
            else if (voltageDec == 37)
            {
                self.batteryImageView.image = [UIImage imageNamed:@"Icon-68"];
            }
            else if (voltageDec > 37 && voltageDec <=39)
            {
                self.batteryImageView.image = [UIImage imageNamed:@"Icon-64"];
                
            }
            else if (voltageDec > 39 && voltageDec <= 42)
            {
                self.batteryImageView.image = [UIImage imageNamed:@"Icon-47"];
            }
            
        }
        else if(batteryvalue==2)
        {
            
            if (voltageDec >= 55)
            {
                self.batteryImageView.image = [UIImage imageNamed:@"Icon-47"];
                
            } else if (voltageDec <= 38)
            {
                self.batteryImageView.image = [UIImage imageNamed:@"Icon-46"];
            }
            else if (voltageDec > 38 && voltageDec <=46)
            {
                self.batteryImageView.image = [UIImage imageNamed:@"Icon-73"];
            }
            else if (voltageDec == 47)
            {
                self.batteryImageView.image = [UIImage imageNamed:@"Icon-70"];
            }
            else if (voltageDec == 48)
            {
                self.batteryImageView.image = [UIImage imageNamed:@"Icon-68"];
            }
            else if (voltageDec > 48 && voltageDec <=51)
            {
                self.batteryImageView.image = [UIImage imageNamed:@"Icon-64"];
            }
            else if (voltageDec > 51 && voltageDec <=55)
            {
                self.batteryImageView.image = [UIImage imageNamed:@"Icon-47"];
            }
        }
        
        
        
        switch (regenFlag)
        {//switch the bars reg/consume bars(0- consume & 1 - reg)
                
            case 0:
                
                switch (displayBarDec)
            {
                case 0:
                    self.powerLavelImageView.image = [UIImage imageNamed:@"Icon-48"];
                    
                    
                    break;
                    
                case 1:
                    self.powerLavelImageView.image = [UIImage imageNamed:@"Icon-48"];
                    
                    break;
                    
                case 2:
                    self.powerLavelImageView.image = [UIImage imageNamed:@"Icon-99"];
                    
                    break;
                    
                case 3:
                    self.powerLavelImageView.image = [UIImage imageNamed:@"Icon-100"];
                    
                    break;
                    
                case 4:
                    self.powerLavelImageView.image = [UIImage imageNamed:@"Icon-101"];
                    
                    break;
                    
                case 5:
                    self.powerLavelImageView.image = [UIImage imageNamed:@"Icon-102"];
                    
                    break;
                    
                case 6:
                    self.powerLavelImageView.image = [UIImage imageNamed:@"Icon-103"];
                    
                    
                    break;
                    
                case 7:
                    self.powerLavelImageView.image = [UIImage imageNamed:@"Icon-104"];
                    break;
                    
                case 8:
                    self.powerLavelImageView.image = [UIImage imageNamed:@"Icon-105"];
                    
                    
                    break;
                    
                case 9:
                    self.powerLavelImageView.image = [UIImage imageNamed:@"Icon-106"];
                    
                    
                    break;
            }
                break;
            case 1:
                
                switch (displayBarDec)
            {   //display the no of bars
                    
                case 0:
                    self.powerLavelImageView.image = [UIImage imageNamed:@"Icon-48"];
                    
                    break;
                    
                case 1:
                    self.powerLavelImageView.image = [UIImage imageNamed:@"Icon-48"];
                    
                    break;
                    
                case 2:
                    self.powerLavelImageView.image = [UIImage imageNamed:@"Icon-91"];
                    
                    break;
                    
                case 3:
                    self.powerLavelImageView.image = [UIImage imageNamed:@"Icon-92"];
                    
                    break;
                    
                case 4:
                    self.powerLavelImageView.image = [UIImage imageNamed:@"Icon-93"];
                    
                    break;
                    
                case 5:
                    self.powerLavelImageView.image = [UIImage imageNamed:@"Icon-94"];
                    
                    break;
                    
                case 6:
                    self.powerLavelImageView.image = [UIImage imageNamed:@"Icon-95"];
                    
                    break;
                    
                case 7:
                    self.powerLavelImageView.image = [UIImage imageNamed:@"Icon-96"];
                    
                    break;
                    
                case 8:
                    self.powerLavelImageView.image = [UIImage imageNamed:@"Icon-97"];
                    
                    
                    break;
                    
                case 9:
                    self.powerLavelImageView.image = [UIImage imageNamed:@"Icon-98"];
                    
                    
                    break;
            }
                break;
        }
        
    }
}
- (void) didTransmitData:(NSString *)string
{
    
    [self addTextToConsole:string dataType:TX];
}

- (void) addTextToConsole:(NSString *) string dataType:(ConsoleDataType) dataType
{
    
}
- (void) centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (central.state == CBCentralManagerStatePoweredOn)
    {
        [self.connectButton setEnabled:YES];
    }
    
}- (void) centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"Did discover peripheral %@", peripheral.name);
    
    //  self.currentPeripheral = peripheral;
    
    
    self.currentPeripheral = [[UARTPeripheral alloc] initWithPeripheral:peripheral delegate:self];
    
    [self.cm connectPeripheral:peripheral options:nil];
    
    [self.cm stopScan];
}

- (void) centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    
    
    [self battryCall];
    
    //tsreceptionflag=true;
    [self addTextToConsole:[NSString stringWithFormat:@"Did connect to %@", peripheral.name] dataType:LOGGING];
    NSString *message = @"Communication started";
    //    [self selfmsg];
    //sleep(10);
    timerset=0;
    timerStopFlag=false;
    motorTransmitFlag=true;
    
    batteryStatusFlag=true;
    
    receptionStartFlag=true;
    [self UpdateTimer];
    
    UIAlertController *alert1 = [UIAlertController alertControllerWithTitle:nil
                                                                    message:message
                                                             preferredStyle:UIAlertControllerStyleActionSheet];
    
    [self presentViewController:alert1 animated:YES completion:nil];
    // mytime=[[NSString alloc]init];
    
    int duration = 2 ; // duration in seconds
    NSLog(@"Did connect peripheral %@", peripheral.name);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(),
                   ^{
                       [alert1 dismissViewControllerAnimated:YES completion:nil];
                   });
    [self updateSpeedTimer];
    
    receptionFlag=true;
    
    self.state = CONNECTED;
    
    [self.connectButton setTitle:@"Disconnect" forState:UIControlStateNormal];
    
    
    
    if ([self.currentPeripheral.peripheral isEqual:peripheral])
    {
        [self.currentPeripheral didConnect];
    }
    
    
}

-(void)battryCall
{
    
    
    int8_t bytes2[] ={121,00,00,00,00,00,00,00,00,00,00,00,00};
    NSData *data2 = [NSData dataWithBytes:bytes2 length:sizeof(bytes2)];
    
    
    if ((txChar.properties & CBCharacteristicPropertyWrite) != 0)
    {
        [myperipheral writeValue:data2 forCharacteristic:txChar
                            type:CBCharacteristicWriteWithResponse];
    }
    else if ((txChar.properties & CBCharacteristicPropertyWrite) != 0)
    {
        [myperipheral writeValue:data2 forCharacteristic:txChar type:CBCharacteristicWriteWithResponse];
    }
    else
    {
        NSLog(@"No write property on TX characteristic, %lu.", (unsigned long)txChar.properties);
    }
}

- (void) centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"Did disconnect peripheral %@", peripheral.name);
    receptionStartFlag=false;
    tsreceptionflag=false;
    timerset=1;
    timerStopFlag=true;
    
    
    loadingView.hidden=true;
    
    NSString *message = @"Communication closed";
    receptionFlag=false;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    int duration = 3; // duration in seconds
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [alert dismissViewControllerAnimated:YES completion:nil];
    });
    
    
    self.state = IDLE;
    
    if ([self.currentPeripheral.peripheral isEqual:peripheral])
    {
        // [self.currentPeripheral didDisconnect];
    }
}

- (IBAction)onKPH:(id)sender
{
    
    if (receptionStartFlag==true)
    {
        onKphcount++;
        
        if (onKphcount%2==0)
        {
            [btn_KPH setTitle:@"KPH" forState:UIControlStateNormal];
            mphflag=FALSE;
            kphflag=true;
            mphStateFlag=true;
            kphStateFlag=false;
            
        }
        else
        {
            [btn_KPH setTitle:@"MPH" forState:UIControlStateNormal];
            kphflag=false;
            mphflag=true;
            
            kphStateFlag=true;
            mphStateFlag=false;
            
        }
        
    }
    
    else
        
    {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@""
                                     message:@"Please connect to motor"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"OK"                                   style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        //Handle your yes please button action here
                                    }];
        
        
        [alert addAction:yesButton];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
    
}


- (IBAction)emergencyStop:(id)sender
{
    
    if(receptionStartFlag==true)
    {
        power_level = -3;// decrement the power level.
        
        negative_power_level = (power_level * -1);//it store the negative power level into the variable positive_power_level
        
        
        power_level_decrement[1] = (power_level);//store the power level value into buffer of the power
        
        datapowerlevel = [NSData dataWithBytes:power_level_decrement length:sizeof(power_level_decrement)];
        
        if ((txChar.properties & CBCharacteristicPropertyWrite) != 0)
        {
            [myperipheral writeValue:datapowerlevel forCharacteristic:txChar
                                type:CBCharacteristicWriteWithoutResponse];
            
            
        }
        else if ((txChar.properties & CBCharacteristicPropertyWrite) != 0)
        {
            [myperipheral writeValue:datapowerlevel forCharacteristic:txChar type:CBCharacteristicWriteWithResponse];
        }
        else
        {
            NSLog(@"No write property on TX characteristic, %lu.", (unsigned long)txChar.properties);
        }
        
        [self selfrecall];
    }
    
    else{
        
        if(conectionflagtodisable==false)
        {
            UIAlertController * alert = [UIAlertController
                                         alertControllerWithTitle:@""
                                         message:@"Please reconnect to motor"
                                         preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:@"OK"    style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action) {
                                            
                                            //Handle your yes please button action here
                                            
                                            
                                            timerStopFlag=true;
                                            //                                        [self.cm cancelPeripheralConnection:self.currentPeripheral.peripheral];// FOR STOP CONNECTION
                                            [self dismissViewControllerAnimated:YES completion:nil];
                                        }];
            
            
            
            
            [alert addAction:yesButton];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}


- (IBAction)onSettingClicked:(id)sender
{
    //    _settingsView.hidden=false;
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *newVC = segue.destinationViewController;
    
    [ViewController setPresentationStyleForSelfController:self presentingController:newVC];
}

+ (void)setPresentationStyleForSelfController:(UIViewController *)selfController presentingController:(UIViewController *)presentingController
{
    if ([NSProcessInfo instancesRespondToSelector:@selector(isOperatingSystemAtLeastVersion:)])
    {
        //iOS 8.0 and above
        presentingController.providesPresentationContextTransitionStyle = YES;
        presentingController.definesPresentationContext = YES;
        
        [presentingController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    }
    else
    {
        [selfController setModalPresentationStyle:UIModalPresentationCurrentContext];
        [selfController.navigationController setModalPresentationStyle:UIModalPresentationCurrentContext];
    }
}


-(void)UIDesign
{
    
    CGRect screenSize = [[UIScreen mainScreen]bounds];
    if (screenSize.size.height <= 568)
    {
        // IPhone 5/5s/5c
        
        connectButton.frame=CGRectMake(50,self.view.frame.size.height-100, 80, 60);
        _emergencyStop.frame=CGRectMake(200,self.view.frame.size.height-100, 60, 60);
        _powerDisplayImageView.frame=CGRectMake(6,self.view.frame.size.height-180, self.view.frame.size.width-15, 63);
        _powerLavelImageView.frame=CGRectMake(13,self.view.frame.size.height-235, self.view.frame.size.width-25, 64);
        _batteryImageView.frame=CGRectMake(self.view.frame.size.width/2-8,self.view.frame.size.height-234, 17, 63);
        _view3.frame=CGRectMake(0,self.view.frame.size.height-240,  self.view.frame.size.width, 1);
        btn_KPH.frame=CGRectMake(self.view.frame.size.width/2-50,self.view.frame.size.height-280,  100, 24);
        txtSpeed.frame=CGRectMake(0,self.view.frame.size.height-380,  self.view.frame.size.width, 90);
        _lbl_Speed.frame=CGRectMake(0,self.view.frame.size.height-415,  self.view.frame.size.width, 26);
        _view2.frame=CGRectMake(0,self.view.frame.size.height-425,  self.view.frame.size.width, 1);
        
        [self.view addSubview:connectButton];
        [self.view addSubview:_emergencyStop];
        [self.view addSubview:_powerDisplayImageView];
        [self.view addSubview:_powerLavelImageView];
        [self.view addSubview:_batteryImageView];
        [self.view addSubview:btn_KPH];
        [self.view addSubview:txtSpeed];
        [self.view addSubview:_lbl_Speed];
        [self.view addSubview:_view3];
        [self.view addSubview:_view2];
        
        
    }
    
    
    else if (screenSize.size.width <= 375)
    {
        // iPhone 6
        
        connectButton.frame=CGRectMake(70,self.view.frame.size.height-110, 80, 60);
        _emergencyStop.frame=CGRectMake(240,self.view.frame.size.height-110, 60, 60);
        _powerDisplayImageView.frame=CGRectMake(8,self.view.frame.size.height-200, self.view.frame.size.width-16, 63);
        _powerLavelImageView.frame=CGRectMake(15,self.view.frame.size.height-270, self.view.frame.size.width-25, 72);
        _batteryImageView.frame=CGRectMake(self.view.frame.size.width/2-6,self.view.frame.size.height-268, 18, 70);
        _view3.frame=CGRectMake(0,self.view.frame.size.height-280,  self.view.frame.size.width, 1);
        btn_KPH.frame=CGRectMake(self.view.frame.size.width/2-50,self.view.frame.size.height-320,  100, 24);
        txtSpeed.frame=CGRectMake(0,self.view.frame.size.height-440,  self.view.frame.size.width, 90);
        _lbl_Speed.frame=CGRectMake(0,self.view.frame.size.height-490,  self.view.frame.size.width, 26);
        _view2.frame=CGRectMake(0,self.view.frame.size.height-510,  self.view.frame.size.width, 1);
        
        [self.view addSubview:connectButton];
        [self.view addSubview:_emergencyStop];
        [self.view addSubview:_powerDisplayImageView];
        [self.view addSubview:_powerLavelImageView];
        [self.view addSubview:_batteryImageView];
        [self.view addSubview:btn_KPH];
        [self.view addSubview:txtSpeed];
        [self.view addSubview:_lbl_Speed];
        [self.view addSubview:_view3];
        [self.view addSubview:_view2];
        
        
        
    }
    else if (screenSize.size.width <= 414)
    {
        // iPhone 6+/7
        
        connectButton.frame=CGRectMake(70,self.view.frame.size.height-105, 95, 76);
        _emergencyStop.frame=CGRectMake(260,self.view.frame.size.height-105, 70, 73);
        _powerDisplayImageView.frame=CGRectMake(8,self.view.frame.size.height-200, self.view.frame.size.width-17, 65);
        _powerLavelImageView.frame=CGRectMake(15,self.view.frame.size.height-280, self.view.frame.size.width-25, 80);
        _batteryImageView.frame=CGRectMake(self.view.frame.size.width/2-6,self.view.frame.size.height-280, 19, 80);
        _view3.frame=CGRectMake(0,self.view.frame.size.height-290,  self.view.frame.size.width, 1);
        btn_KPH.frame=CGRectMake(self.view.frame.size.width/2-50,self.view.frame.size.height-340,  100, 24);
        txtSpeed.frame=CGRectMake(0,self.view.frame.size.height-480,  self.view.frame.size.width, 90);
        _lbl_Speed.frame=CGRectMake(0,self.view.frame.size.height-550,  self.view.frame.size.width, 26);
        _view2.frame=CGRectMake(0,self.view.frame.size.height-580,  self.view.frame.size.width, 1);
        
        [self.view addSubview:connectButton];
        [self.view addSubview:_emergencyStop];
        [self.view addSubview:_powerDisplayImageView];
        [self.view addSubview:_powerLavelImageView];
        [self.view addSubview:_batteryImageView];
        [self.view addSubview:btn_KPH];
        [self.view addSubview:txtSpeed];
        [self.view addSubview:_lbl_Speed];
        [self.view addSubview:_view3];
        [self.view addSubview:_view2];
        
    }
    
    
}



-(void)adjustFontSizeOfLabel{
    
    CGRect screenSize = [[UIScreen mainScreen]bounds];
    
    if (screenSize.size.height <= 480) {
        // iPhone 4
        self.txtSpeed.font = [self.txtSpeed.font fontWithSize:60];
        self.lbl_Speed.font=[self.lbl_Speed.font fontWithSize:22];
        
    }
    else if (screenSize.size.height <= 568) {
        // IPhone 5/5s/5c
        self.txttimer.font=[self.txttimer.font fontWithSize:37];
        self.distanceLable.font=[self.distanceLable.font fontWithSize:37];
        self.txtSpeed.font = [self.txtSpeed.font fontWithSize:73];
        self.lbl_Speed.font=[self.lbl_Speed.font fontWithSize:25];
        self.btn_KPH.titleLabel.font=[self.btn_KPH.font fontWithSize:25];
        self.btn_MPH.titleLabel.font=[self.btn_KPH.font fontWithSize:25];
        
        //[btn_KPH.titleLabel setFont:[UIFont systemFontOfSize:25]];
        //[btn_MPH.titleLabel setFont:[UIFont systemFontOfSize:25]];
        self.lbl_Timer.font=[self.lbl_Timer.font fontWithSize:23];
        self.lbl_Distance.font=[self.lbl_Distance.font fontWithSize:23];
    }
    else if (screenSize.size.width <= 375) {
        // iPhone 6,iphone 7
        self.txttimer.font=[self.txttimer.font fontWithSize:40];
        self.distanceLable.font=[self.distanceLable.font fontWithSize:40];
        //[btn_KPH.titleLabel setFont:[UIFont fontWithName:@"californian-fb.ttf" size:28.0]];
        
        self.btn_KPH.titleLabel.font=[self.btn_KPH.font fontWithSize:28];
        self.btn_MPH.titleLabel.font=[self.btn_KPH.font fontWithSize:28];
        
        //        [btn_KPH.titleLabel setFont:[UIFont systemFontOfSize:28]];
        //[btn_MPH.titleLabel setFont:[UIFont systemFontOfSize:28]];
        self.lbl_Timer.font=[self.lbl_Timer.font fontWithSize:25];
        self.lbl_Distance.font=[self.lbl_Distance.font fontWithSize:25];
        
        self.lbl_Speed.font=[self.lbl_Speed.font fontWithSize:28];
        self.txtSpeed.font = [self.txtSpeed.font fontWithSize:90];
        
        
    }
    else if (screenSize.size.width <= 414) {
        // iPhone 6+,7+
        self.txttimer.font=[self.txttimer.font fontWithSize:45];
        self.distanceLable.font=[self.distanceLable.font fontWithSize:45];
        
        self.lbl_Speed.font=[self.lbl_Speed.font fontWithSize:30];
        
        self.btn_KPH.titleLabel.font=[self.btn_KPH.font fontWithSize:30];
        self.btn_MPH.titleLabel.font=[self.btn_KPH.font fontWithSize:30];
        //        [btn_KPH.titleLabel setFont:[UIFont systemFontOfSize:30]];
        //        [btn_MPH.titleLabel setFont:[UIFont systemFontOfSize:30]];
        self.lbl_Timer.font=[self.lbl_Timer.font fontWithSize:27];
        self.lbl_Distance.font=[self.lbl_Distance.font fontWithSize:27];
        
        self.txtSpeed.font = [self.txtSpeed.font fontWithSize:100];
        
    }
}




@end
