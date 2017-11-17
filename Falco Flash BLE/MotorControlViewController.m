//
//  MotorControlViewController.m
//  Falco Flash BLE
//
//  Created by Falco eMotors Pvt. Ltd. on 15/10/2016.
//  Copyright © 2016 Falco eMotors Pvt. Ltd. All rights reserved.
//

#import "MotorControlViewController.h"
#import "UARTPeripheral.h"
#import "ViewController.h"
#import "sensorSelection.h"
NSString *text1,*text2,*text3,*text4,*text5,*text6,*text7,*text8;
NSString *myT1,*myT2,*myT3,*myT4,*myT5,*myT6,*myT7,*myT8,*myT15,*myT11,*myT18,*myT20,*myT21,*myT22,*myT23,*myT24;

NSString *myT45;
UIActivityIndicatorView *activityIndicator2;
NSString *selectedDropout;

BOOL turnOnSpeedBool=false;
BOOL turnOnDelayBool=false;
BOOL baseTorqueBool=false;
BOOL turnOffDelayBool=false;
BOOL flipAxelBool=false;
BOOL torqueMultiplierBool=false;
BOOL tsTurnOnBool=false;
BOOL dropoutOffsetBool=false;
static Byte randarray[]={0x90,0,0,0,0,0,0,0};
static Byte randarray1[]={0x91,0,0,0,0,0,0,0};
@interface MotorControlViewController ()
@property UARTPeripheral *currentPeripheral;
@end


@implementation MotorControlViewController
@synthesize currentPeripheral=_currentPeripheral;
@synthesize txtturnonspeed;
@synthesize txtturnondelay;
@synthesize txtturnoffdelay;
@synthesize txttorquemultiplier;
@synthesize txtdropoutoffset;
@synthesize txttsturnon;
@synthesize txtflipaxel;
@synthesize txtbasetorque;
@synthesize btnbroadcast;
@synthesize btnmemoryread;
@synthesize btnrestore;

- (void)viewDidLoad
{
    [super viewDidLoad];
    allscreenload=true;
    
    if (receptionStartFlag==true)
    {
        _dropout_Picker.userInteractionEnabled=true;
    }
    
    _lbl_DropoutSelect.lineBreakMode=NSLineBreakByClipping;
    _lbl_DropoutSelect.numberOfLines=0;
    
    if (dropoutFlag==true)
    {
        [_dropout_Picker reloadAllComponents];
        [_dropout_Picker selectRow:1 inComponent:0 animated:YES];
    }
    
    self.dropout_Picker.dataSource = self;
    self.dropout_Picker.delegate = self;
    dropoutData = @[@"Vertical",@"Horizontal"];
    
    [self.btn_Send.layer setBorderWidth:1.0];
    [self.btn_Send.layer setBorderColor:[[UIColor blackColor] CGColor]];
    
    btnrestore.layer.borderWidth=1.0;
    btnrestore.layer.borderColor=[UIColor blackColor].CGColor;
    btnmemoryread.layer.borderWidth=1.0;
    btnmemoryread.layer.borderColor=[UIColor blackColor].CGColor;
    btnbroadcast.layer.borderWidth=1.0;
    btnbroadcast.layer.borderColor=[UIColor blackColor].CGColor;
    
    
    turnONTorqueBool=true;
    
    
    activityIndicator2 = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator2.transform = CGAffineTransformMakeScale(2.5, 2.5);
    activityIndicator2.color=[UIColor blackColor];
    activityIndicator2.alpha = 1.0;
    [_motorView addSubview:activityIndicator2];
    activityIndicator2.center = CGPointMake([[UIScreen mainScreen]bounds].size.width/2, [[UIScreen mainScreen]bounds].size.height/2);
    
    [self adjustFontSizeOfLabel];
    
    txtturnonspeed.delegate=self;
    txtturnondelay.delegate=self;
    txtbasetorque.delegate=self;
    txtdropoutoffset.delegate=self;
    txttsturnon.delegate=self;
    txtturnoffdelay.delegate=self;
    txttorquemultiplier.delegate=self;
    txtflipaxel.delegate=self;
    
    [self selfCall];
    
    UISwipeGestureRecognizer *swipeRightOrange = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(slideToRightWithGestureRecognizer:)];
    
    swipeRightOrange.direction=UISwipeGestureRecognizerDirectionRight;
    [self.motorView addGestureRecognizer:swipeRightOrange];
    
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarButtonItemStylePlain;
    numberToolbar.items = @[[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelNumberPad)],
                            [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                            [[UIBarButtonItem alloc]initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)]];
    [numberToolbar sizeToFit];
    
    
    txtturnonspeed.inputAccessoryView = numberToolbar;
    txtturnondelay.inputAccessoryView = numberToolbar;
    txtbasetorque.inputAccessoryView = numberToolbar;
    txtdropoutoffset.inputAccessoryView = numberToolbar;
    txttsturnon.inputAccessoryView = numberToolbar;
    txtturnoffdelay.inputAccessoryView = numberToolbar;
    txttorquemultiplier.inputAccessoryView = numberToolbar;
    txtflipaxel.inputAccessoryView = numberToolbar;
    
    if (motorcontrolscreenstatus==true)
    {
        
        
        myT1 = [[NSNumber numberWithInt:dec_mem_Basetorque] stringValue];
        txtbasetorque.text=myT1;
        
        NSLog(@"it si dec_mem_Basetorque==%d",dec_mem_Basetorque);
        
        myT2 = [[NSNumber numberWithInt:dec_mem_Flipaxle] stringValue];
        
        txtflipaxel.text=myT2;
        NSLog(@"it si dec_mem_Flipaxle==%d",dec_mem_Flipaxle);
        
        myT3 = [[NSNumber numberWithInt:dec_mem_Turnonspeed] stringValue];
        
        txtturnonspeed.text=myT3;
        NSLog(@"it si dec_mem_Turnonspeed==%d",dec_mem_Turnonspeed);
        myT4 = [[NSNumber numberWithInt:dec_mem_tsturnon] stringValue];
        
        txttsturnon.text=myT4;
        NSLog(@"it si dec_mem_tsturnon==%d",dec_mem_tsturnon);
        
        myT5 = [[NSNumber numberWithInt:dec_mem_Dropoutdisp] stringValue];
        
        txtdropoutoffset.text=myT5;
        NSLog(@"dec_mem_Dropoutdispi==%d",dec_mem_Dropoutdisp);
        
        myT6 = [[NSNumber numberWithInt:dec_mem_Tmultiplier] stringValue];
        
        txttorquemultiplier.text=myT6;
        NSLog(@"dec_mem_Tmultiplier==%d",dec_mem_Tmultiplier);
        
        myT7 = [[NSNumber numberWithInt:dec_mem_Turnondelay] stringValue];
        
        txtturnondelay.text=myT7;
        NSLog(@"dec_mem_Turnondelay=%d",dec_mem_Turnondelay);
        
        myT8 = [[NSNumber numberWithInt:dec_mem_Turnoffdelay] stringValue];
        
        txtturnoffdelay.text=myT8;
        NSLog(@"dec_mem_Turnoffdelay=%d",dec_mem_Turnoffdelay);
    }
    
    // Do any additional setup after loading the view.
    
    
    if(turnOnSpeedBool==true)
    {
        
        txtturnonspeed.text=myT45;
       
    }
    
    if(baseTorqueBool==true)
        
    {
        
        txtbasetorque.text=myT18;
    }
    
    if(flipAxelBool==true)
    {
        txtflipaxel.text=myT21;
    }
    
    if(tsTurnOnBool==true)
    {
        txttsturnon.text=myT23;
     
    }
    
    if(dropoutOffsetBool==true)
    {
     txtdropoutoffset.text=myT24;
    }
    
    if(torqueMultiplierBool==true)
    {
        txttorquemultiplier.text=myT22;
    }
    
    if(turnOnDelayBool==true)
    {
    txtturnondelay.text=myT15;
    }
    
    if(turnOffDelayBool==true)
    {
    txtturnoffdelay.text=myT20;
    }
    
}


- (void) centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSString *message = @"Communication started";
    
    UIAlertController *alert1 = [UIAlertController alertControllerWithTitle:nil message:message
                                                             preferredStyle:UIAlertControllerStyleActionSheet];
    
    [self presentViewController:alert1 animated:YES completion:nil];
    
    int duration = 2 ; // duration in seconds
    
    NSLog(@"Did connect peripheral %@", peripheral.name);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(),
                   ^{
                       [alert1 dismissViewControllerAnimated:YES completion:nil];
                   });
    
    self.state = CONNECTED;
    
    if ([self.currentPeripheral.peripheral isEqual:peripheral])
    {
        [self.currentPeripheral didConnect];
    }
    
}


- (void)disconnect:(CBPeripheral *)device
{
    // Unsubscribes from all the characteristics in services
    for (CBService *service in device.services)
    {
        for (CBCharacteristic *characteristic in service.characteristics)
            [device setNotifyValue:NO forCharacteristic:characteristic];
    }
}


- (void) centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"Did disconnect peripheral %@", peripheral.name);
    
    NSString *message = @"Communication closed";
    receptionFlag=false;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleActionSheet];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    int duration = 3; // duration in seconds
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [alert dismissViewControllerAnimated:YES completion:nil];
    });
    
    self.state = IDLE;
    
    if ([self.currentPeripheral.peripheral isEqual:peripheral])
    {
        [self.currentPeripheral didDisconnect];
    }
    
}


-(void)viewDidAppear:(BOOL)animated
{
    
    NSLog(@"IN TS State==%u",self.state);
    
    if ([self isBeingPresented] || [self isMovingToParentViewController])
    {
        // Perform an action that will only be done once
    }
    else
    {
        if (myperipheral)
        {
            NSLog(@"My peripheral=%@",myperipheral.name);
            screen_load=false;
        }
    }
    
    if (motorcontrolscreenstatus==true)
    {
        txtbasetorque.text=myT1;
        txtflipaxel.text=myT2;
        txtturnonspeed.text=myT3;
        txttsturnon.text=myT4;
        txtdropoutoffset.text=myT5;
        txttorquemultiplier.text=myT6;
        txtturnondelay.text=myT7;
        txtturnoffdelay.text=myT8;
    }
    
}

-(void)selfCall
{
    if (receptionStartFlag==true)
    {
        _wireless5image.hidden=false;
        countclose=0;
    }
    
    if (receptionStartFlag==false)
    {
        _wireless5image.hidden=true;
        countclose++;
        if (countclose==1)
        {
            NSString *message = @"Communication closed";
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                           message:message
                                                                    preferredStyle:UIAlertControllerStyleActionSheet];
            
            [self presentViewController:alert animated:YES completion:nil];
            
            int duration = 3; // duration in seconds
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [alert dismissViewControllerAnimated:YES completion:nil];
            });
            
        }
        
    }
    
    [self performSelector:@selector(selfCall) withObject:nil afterDelay:0.1];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)btnbroadcast:(id)sender
{
//
    if (turnOFFSpeedBool==true)
    {
        turnONTorqueBool=false;
    }
       NSLog(@"Firmware string==%@",updateFirmware);
    
    if (receptionStartFlag==true)
    {
        rxRecpPause=false;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                       ^{
                           for (NSInteger i = 1; i <= 3; i++)
                           {
                               text1=txtturnonspeed.text;
                               turnonspeed=[text1 intValue];
                               
                               text3=txtflipaxel.text;
                               flipaxle=[text3 intValue];
                               
                               text4=txtbasetorque.text;
                               basetorque=[text4 intValue];
                               
                               text5=txttorquemultiplier.text;
                               tmultiplier=[text5 intValue];
                               
                               text6=txtdropoutoffset.text;
                               dropoutdisp=[text6 intValue];
                               
                               text7=txtturnondelay.text;
                               turnondelay=[text7 intValue];
                               
                               text8=txtturnoffdelay.text;
                               turnoffdelay=[text8 intValue];
                               
                               text2=txttsturnon.text;
                               tsTurnOn=[text2 intValue];
                               
                               randarray[2] = turnonspeed;
                               randarray[3] = basetorque;
                               randarray[6] = flipaxle;
                               randarray[1] = tsturnon;
                               randarray[4] = tmultiplier;
                               randarray[5] = dropoutdisp;
                               
                               randarray1[2]=turnondelay;
                               randarray1[4]=turnoffdelay;
                              
                               if ([updateFirmware isEqual:@"100872"] ||[updateFirmware isEqual:@"100863"]||[updateFirmware isEqual:@"100651"] ||[updateFirmware isEqual:@"100657"]||(turnOFFSpeedBool==true))
                               {
                                   randarray1[5]=0;
                               }
                               else if(turnONTorqueBool==true)
                               {
                                  randarray1[5]=2;
                                   
                               }
                               
                               NSData *data2 = [NSData dataWithBytes:randarray length:sizeof(randarray)];
                               NSData *data3 = [NSData dataWithBytes:randarray1 length:sizeof(randarray1)];
                               
                               if ((txChar.properties & CBCharacteristicPropertyWrite) != 0)
                               {
                                   [myperipheral writeValue:data2 forCharacteristic:txChar type:CBCharacteristicWriteWithResponse];
                                   
                                   [myperipheral writeValue:data3 forCharacteristic:txChar type:CBCharacteristicWriteWithResponse];
                               }
                               
                               else if ((txChar.properties & CBCharacteristicPropertyWrite) != 0)
                               {
                                   [myperipheral writeValue:data2 forCharacteristic:txChar type:CBCharacteristicWriteWithResponse];
                                   [myperipheral writeValue:data3 forCharacteristic:txChar type:CBCharacteristicWriteWithResponse];
                               }
                               else
                               {
                                   NSLog(@"No write property on TX characteristic, %lu.", (unsigned long)txChar.properties);
                               }
                               rxRecpPause=true;
                           }
                           
                           
                           for (NSInteger i = 1; i <= 30; i++)
                           {
                               
                               [NSThread sleepForTimeInterval:0.500];
                               dispatch_async(dispatch_get_main_queue(),
                                    ^{
                                        [activityIndicator2 startAnimating];
                                        _motorView.userInteractionEnabled = NO;
                                    });
                           }
                           
                           dispatch_async(dispatch_get_main_queue(),
                                ^{
                                    [activityIndicator2 stopAnimating];
                                    _motorView.userInteractionEnabled = YES;
                                              
                                    UIAlertController * alert = [UIAlertController
                                                                           alertControllerWithTitle:@""
                                                                           message:@"Broadcast Done"
                                                                           preferredStyle:UIAlertControllerStyleAlert];
                                              
                                    UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"                                   style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                        {
                                         //Handle your yes please button action here
                                        }];
                                              
                                           [alert addAction:yesButton];
                                           [self presentViewController:alert animated:YES completion:nil];
                                          });
                       });
        
       
        
        
        
    }
    else
    {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@""
                                     message:@"Please connect to motor"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"OK"   style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        //Handle your yes please button action here
                                    }];
        
        
        [alert addAction:yesButton];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        
    }
    
}

- (IBAction)btnmemoryread:(id)sender
{
    if (receptionStartFlag==true)
    {
        
        rxRecpPause=false;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                       ^{
                           for (NSInteger i = 1; i <=8; i++)
                           {
                               
                               int8_t bytes2[] ={149,01,00,00,00,00,00,00,00,00,00,00,00};
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
                               rxRecpPause=true;
                               
                               
                           }
                           for (NSInteger i = 1; i <=30.; i++)
                           {
                               
                               
                               [NSThread sleepForTimeInterval:0.500];
                               
                               dispatch_async(dispatch_get_main_queue(),
                                              ^{
                                                  motorcontrolscreenstatus=true;
                                                  
                                                  [activityIndicator2 startAnimating];
                                                  
                                                  _motorView.userInteractionEnabled = NO;
                                                  
                                                  myT1 = [[NSNumber numberWithInt:dec_mem_Basetorque] stringValue];
                                                  txtbasetorque.text=myT1;
                                                  
                                                  myT2 = [[NSNumber numberWithInt:dec_mem_Flipaxle] stringValue];
                                                  txtflipaxel.text=myT2;
                                                  
                                                  myT3 = [[NSNumber numberWithInt:dec_mem_Turnonspeed] stringValue];
                                                  txtturnonspeed.text=myT3;
                                                  
                                                  myT4 = [[NSNumber numberWithInt:dec_mem_tsturnon] stringValue];
                                                  txttsturnon.text=myT4;
                                                  
                                                  myT5 = [[NSNumber numberWithInt:dec_mem_Dropoutdisp] stringValue];
                                                  txtdropoutoffset.text=myT5;
                                                  
                                                  myT6 = [[NSNumber numberWithInt:dec_mem_Tmultiplier] stringValue];
                                                  txttorquemultiplier.text=myT6;
                                                  
                                                  myT7 = [[NSNumber numberWithInt:dec_mem_Turnondelay] stringValue];
                                                  txtturnondelay.text=myT7;
                                                  
                                                  myT8 = [[NSNumber numberWithInt:dec_mem_Turnoffdelay] stringValue];
                                                  txtturnoffdelay.text=myT8;
                                                  
                                              });
                           }
                           
                           
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              if (memoryReadDoneFlag==true && memoryReadDoneFlag1==true)
                                              {
                                                  [activityIndicator2 stopAnimating];
                                                  _motorView.userInteractionEnabled = YES;
                                                  
                                                  UIAlertController * alert = [UIAlertController
                                                                               alertControllerWithTitle:@""
                                                                               message:@"Memory Read Successfully"
                                                                               
                                                                               
                                                                               preferredStyle:UIAlertControllerStyleAlert];
                                                  
                                                  
                                                  
                                                  UIAlertAction* yesButton = [UIAlertAction
                                                                              actionWithTitle:@"OK"                                   style:UIAlertActionStyleDefault
                                                                              handler:^(UIAlertAction * action)
                                                                              {
                                                                                  //Handle your yes please button action here
                                                                              }];
                                                  
                                                  [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(ShowReadMessage) userInfo:nil repeats:NO]; //60 sec timer
                                                  
                                                  memoryReadDoneFlag=false;
                                                  
                                                  [alert addAction:yesButton];
                                                  
                                                  [self presentViewController:alert animated:YES completion:nil];
                                                  
                                                 
                                                  
                                              }
                                              else
                                              {
                                                  
                                                  [activityIndicator2 stopAnimating];
                                                  _motorView.userInteractionEnabled = YES;
                                                  
                                                  UIAlertController * alert = [UIAlertController
                                                                               alertControllerWithTitle:@""
                                                                               message:@"Memory Read Failed!"
                                                                               
                                                                               preferredStyle:UIAlertControllerStyleAlert];
                                                  
                                                  UIAlertAction* yesButton = [UIAlertAction
                                                                              actionWithTitle:@"OK"                                   style:UIAlertActionStyleDefault
                                                                              handler:^(UIAlertAction * action)
                                                                              {
                                                                                  //Handle your yes please button action here
                                                                              }];
                                                  memoryReadDoneFlag=false;
                                                  
                                                  [alert addAction:yesButton];
                                                  
                                                  [self presentViewController:alert animated:YES completion:nil];
                                              }
                                              
                                              memoryStatus=false;
                                              
                                          });
                       });
        
        
           }
    else
    {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@""
                                     message:@"Please connect to motor"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"OK"   style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        //Handle your yes please button action here
                                    }];
        
        
        [alert addAction:yesButton];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}
-(void)ShowReadMessage
{
    
    if (sensorValueCheckRead==0)
    {
        NSString *message = @"Read: Speed  Sensor";
        
        turnOFFSpeedBool=true;
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                       message:message
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        int duration = 5; // duration in seconds
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(),
                       ^{
                           [alert dismissViewControllerAnimated:YES completion:nil];
                       });
    }
    else
        if (sensorValueCheckRead==2)
        {
            turnONTorqueBool=true;
            NSString *message = @"Read: Torque and Speed  Sensor";
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                           message:message
                                                                    preferredStyle:UIAlertControllerStyleActionSheet];
            
            [self presentViewController:alert animated:YES completion:nil];
            
            int duration = 5; // duration in seconds
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(),
                           ^{
                               [alert dismissViewControllerAnimated:YES completion:nil];
                           });
        }
    
    
    
}


-(void)slideToRightWithGestureRecognizer:(UISwipeGestureRecognizer *)gestureRecognizer
{
    
    if (turnONTorqueBool==true)
    {
        NSLog(@"IN TURN ON TORQYUE");
        
        [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"switch"];
        turnONTorqueBool=false;
    }
    
    if(turnOFFSpeedBool==true)
    {
        NSLog(@"IN TURN OFF SPEED");
        
        [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"switchKeySpeed"];
    }

    [UIView animateWithDuration:0.5 animations:
     ^{
         [self dismissViewControllerAnimated:NO completion:Nil];
     }];
}




- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (receptionStartFlag==true)
    {
        //Code for Turn On Speed
        
        if(txtturnonspeed.resignFirstResponder==true)
        {
            
            turnOnSpeedBool=true;
            NSString *text11 = txtturnonspeed.text;
            double value11 = [text11 doubleValue];
            tspeed= value11;
            myT45 = [[NSNumber numberWithDouble:tspeed] stringValue];
            txtturnonspeed.text=myT45;
            
            if (tspeed>150)
            {
                tspeed=150;
                myT45 = [[NSNumber numberWithDouble:tspeed] stringValue];
                txtturnonspeed.text=myT45;
                UIAlertController * alert = [UIAlertController
                                             alertControllerWithTitle:@""
                                             message:@"Enter the value in range 10 to 150"
                                             preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* yesButton = [UIAlertAction
                                            actionWithTitle:@"OK"   style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * action)
                                            {
                                                //Handle your yes please button action here
                                            }];
                
                
                [alert addAction:yesButton];
                
                [self presentViewController:alert animated:YES completion:nil];
                
            }
            else if(tspeed<10)
            {
                tspeed=10;
                myT45 = [NSString stringWithFormat:@"%02d",tspeed];
                txtturnonspeed.text=myT45;
                [self.txtturnonspeed setNeedsDisplay];
                UIAlertController * alert = [UIAlertController
                                             alertControllerWithTitle:@""
                                             message:@"Enter the value in range 10 to 150"
                                             preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* yesButton = [UIAlertAction
                                            actionWithTitle:@"OK"   style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * action)
                                            {
                                                //Handle your yes please button action here
                                            }];
                
                
                [alert addAction:yesButton];
                
                [self presentViewController:alert animated:YES completion:nil];
            }
            
            
        }
        
        // Code for turn on delay
        
        if(txtturnondelay.resignFirstResponder==true)
        {
            turnOnDelayBool=true;
            NSString *text15 = txtturnondelay.text;
            double value15 = [text15 doubleValue];
            tdelay= value15;
            myT15 = [[NSNumber numberWithDouble:tdelay] stringValue];
            txtturnondelay.text=myT15;
            
            if (tdelay>40)
            {
                tdelay=40;
                myT15 = [[NSNumber numberWithDouble:tdelay] stringValue];
                txtturnondelay.text=myT15;
                UIAlertController * alert = [UIAlertController
                                             alertControllerWithTitle:@""
                                             message:@"Enter the value in range 1 to 40"
                                             preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* yesButton = [UIAlertAction
                                            actionWithTitle:@"OK"   style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * action)
                                            {
                                                //Handle your yes please button action here
                                            }];
                
                
                [alert addAction:yesButton];
                
                [self presentViewController:alert animated:YES completion:nil];
            }
            else if (tdelay<1)
            {
                tdelay=1;
                myT15 = [NSString stringWithFormat:@"%02d",tdelay];
                txtturnondelay.text=myT15;
                UIAlertController * alert = [UIAlertController
                                             alertControllerWithTitle:@""
                                             message:@"Enter the value in range 1 to 40"
                                             preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* yesButton = [UIAlertAction
                                            actionWithTitle:@"OK"  style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * action)
                                            {
                                                //Handle your yes please button action here
                                            }];
                
                
                [alert addAction:yesButton];
                
                [self presentViewController:alert animated:YES completion:nil];
                
            }
            else
            {
                if (tdelay>=1 && tdelay<=9)
                {
                    myT15= [NSString stringWithFormat:@"%02d",tdelay];
                    txtturnondelay.text=myT15;
                }
                else
                {
                    myT15 = txtturnondelay.text;
                    double value17 = [myT15 doubleValue];
                    tdelay= value17;
                }
                
            }
            
        }
        
        //Code for base Torque
        
        if(txtbasetorque.resignFirstResponder==true)
        {
            
            baseTorqueBool=true;
            NSString *text18 = txtbasetorque.text;
            double value18 = [text18 doubleValue];
            tbasetorque= value18;
            myT18 = [[NSNumber numberWithDouble:tbasetorque] stringValue];
            txtbasetorque.text=myT18;
            
            if (tbasetorque>13)
            {
                tbasetorque=13;
                myT18 = [[NSNumber numberWithDouble:tbasetorque] stringValue];
                txtbasetorque.text=myT18;
                UIAlertController * alert = [UIAlertController
                                             alertControllerWithTitle:@""
                                             message:@"Enter the value in range 0 to 13"
                                             preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* yesButton = [UIAlertAction
                                            actionWithTitle:@"OK"    style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * action)
                                            {
                                                //Handle your yes please button action here
                                            }];
                
                
                [alert addAction:yesButton];
                
                [self presentViewController:alert animated:YES completion:nil];
            }
            else if (tbasetorque<0)
            {
                tbasetorque=0;
                myT18= [NSString stringWithFormat:@"%02d",tbasetorque];
                txtbasetorque.text=myT18;
                
            }
            else
            {
                if (tbasetorque>=1 && tbasetorque<=9)
                {
                    myT18 = [NSString stringWithFormat:@"%02d",tbasetorque];
                    txtbasetorque.text=myT18;
                }
                else
                {
                    myT18 = txtbasetorque.text;
                    double value19 = [myT18 doubleValue];
                    tbasetorque= value19;
                }
            }
        }
        
        //Code for Turn Off Delay
        if(txtturnoffdelay.resignFirstResponder==true)
        {
            turnOffDelayBool=true;
            NSString *text19 = txtturnoffdelay.text;
            double value19 = [text19 doubleValue];
            tdelayoff= value19;
            myT20 = [[NSNumber numberWithDouble:tdelayoff] stringValue];
            txtturnoffdelay.text=myT20;
            
            if (tdelayoff>40)
            {
                tdelayoff=40;
                myT20 = [[NSNumber numberWithDouble:tdelayoff] stringValue];
                txtturnoffdelay.text=myT20;
                UIAlertController * alert = [UIAlertController
                                             alertControllerWithTitle:@""
                                             message:@"Enter the value in range 1 to 40"
                                             preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* yesButton = [UIAlertAction
                                            actionWithTitle:@"OK"  style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * action)
                                            {
                                                //Handle your yes please button action here
                                            }];
                
                
                [alert addAction:yesButton];
                [self presentViewController:alert animated:YES completion:nil];
                
            }
            else if (tdelayoff<1)
            {
                tdelayoff=1;
                myT20= [NSString stringWithFormat:@"%02d",tdelayoff];
                txtturnoffdelay.text=myT20;
                UIAlertController * alert = [UIAlertController
                                             alertControllerWithTitle:@""
                                             message:@"Enter the value in range 1 to 40"
                                             preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* yesButton = [UIAlertAction
                                            actionWithTitle:@"OK"   style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * action)
                                            {
                                                //Handle your yes please button action here
                                            }];
                
                
                [alert addAction:yesButton];
                [self presentViewController:alert animated:YES completion:nil];
                
            }
            else
            {
                if (tdelayoff>=1 && tdelayoff<=9)
                {
                    myT20 = [NSString stringWithFormat:@"%02d",tdelayoff];
                    txtturnoffdelay.text=myT20;
                }
                else
                {
                    myT20 = txtturnoffdelay.text;
                    double value19 = [myT20 doubleValue];
                    tdelayoff= value19;
                    
                }
            }
        }
        
        //Code for Flip Axel
        if(txtflipaxel.resignFirstResponder==true)
        {
            flipAxelBool=true;
            NSString *text19 = txtflipaxel.text;
            double value19 = [text19 doubleValue];
            tflipaxel= value19;
            
            myT21 = [[NSNumber numberWithDouble:tflipaxel] stringValue];
            txtflipaxel.text=myT21;
            
            if (tflipaxel>1)
            {
                tflipaxel=0;
                myT21 = [NSString stringWithFormat:@"%02d",tflipaxel];
                txtflipaxel.text=myT21;
                UIAlertController * alert = [UIAlertController
                                             alertControllerWithTitle:@""
                                             message:@"Enter the value in range 0 to 1"
                                             preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* yesButton = [UIAlertAction
                                            actionWithTitle:@"OK"   style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * action)
                                            {
                                                //Handle your yes please button action here
                                            }];
                
                
                [alert addAction:yesButton];
                
                [self presentViewController:alert animated:YES completion:nil];
            }
            else if (tflipaxel<0)
            {
                tflipaxel=0;
                myT21= [NSString stringWithFormat:@"%02d",tflipaxel];
                txtflipaxel.text=myT21;
                UIAlertController * alert = [UIAlertController
                                             alertControllerWithTitle:@""
                                             message:@"Enter the value in range 0 to 1"
                                             preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* yesButton = [UIAlertAction
                                            actionWithTitle:@"OK"  style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * action)
                                            {
                                                //Handle your yes please button action here
                                            }];
                
                
                [alert addAction:yesButton];
                
                [self presentViewController:alert animated:YES completion:nil];
            }
            else
            {
                if (tflipaxel>=0) {
                    myT21 = [NSString stringWithFormat:@"%02d",tflipaxel];
                    txtflipaxel.text=myT21;
                }
                else
                {
                    myT21= txtflipaxel.text;
                    double value19 = [myT21 doubleValue];
                    tflipaxel= value19;
                    
                }
                
            }
            
        }
        
        //Code For Torque Multiplier
        
        if(txttorquemultiplier.resignFirstResponder==true)
        {
            
            torqueMultiplierBool=true;
            NSString *text19 = txttorquemultiplier.text;
            double value19 = [text19 doubleValue];
            torquemultiply= value19;
            myT22 = [[NSNumber numberWithDouble:torquemultiply] stringValue];
            txttorquemultiplier.text=myT22;
            
            if (torquemultiply>50)
            {
                torquemultiply=50;
                myT22= [[NSNumber numberWithDouble:torquemultiply] stringValue];
                txttorquemultiplier.text=myT22;
                UIAlertController * alert = [UIAlertController
                                             alertControllerWithTitle:@""
                                             message:@"Enter the value in range 1 to 50"
                                             preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* yesButton = [UIAlertAction
                                            actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * action)
                                            {
                                                //Handle your yes please button action here
                                            }];
                
                
                [alert addAction:yesButton];
                
                [self presentViewController:alert animated:YES completion:nil];
            }
            else if (torquemultiply<1)
            {
                torquemultiply=1;
                myT22= [NSString stringWithFormat:@"%02d",torquemultiply];
                txttorquemultiplier.text=myT22;
                UIAlertController * alert = [UIAlertController
                                             alertControllerWithTitle:@""
                                             message:@"Enter the value in range 1 to 50"
                                             preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* yesButton = [UIAlertAction
                                            actionWithTitle:@"OK"  style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * action)
                                            {
                                                //Handle your yes please button action here
                                            }];
                
                
                [alert addAction:yesButton];
                
                [self presentViewController:alert animated:YES completion:nil];
            }
            else
            {
                if (torquemultiply>=1 && torquemultiply<=9)
                {
                    myT22 = [NSString stringWithFormat:@"%02d",torquemultiply];
                    txttorquemultiplier.text=myT22;
                }
                else
                {
                    myT22 = txttorquemultiplier.text;
                    double value19 = [myT22 doubleValue];
                    torquemultiply= value19;
                }
            }
        }
        
        //Code for TS Turn On
        
        if(txttsturnon.resignFirstResponder==true)
        {
            
            tsTurnOnBool=true;
            NSString *text19 = txttsturnon.text;
            int value19 = [text19 intValue];
            tsturnon= value19;
            myT23 = [[NSNumber numberWithDouble:tsturnon] stringValue];
            txttsturnon.text=myT23;
            
            if (tsturnon>50)
            {
                tsturnon=50;
                myT23 = [[NSNumber numberWithDouble:tsturnon] stringValue];
                txttsturnon.text=myT23;
                UIAlertController * alert = [UIAlertController
                                             alertControllerWithTitle:@""
                                             message:@"Enter the value in range 3 to 50"
                                             preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* yesButton = [UIAlertAction
                                            actionWithTitle:@"OK"  style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * action)
                                            {
                                                //Handle your yes please button action here
                                            }];
                
                
                [alert addAction:yesButton];
                
                [self presentViewController:alert animated:YES completion:nil];
            }
            else if (tsturnon<3)
            {
                tsturnon=3;
                myT23 = [NSString stringWithFormat:@"%02d",tsturnon];
                txttsturnon.text=myT23;
                UIAlertController * alert = [UIAlertController
                                             alertControllerWithTitle:@""
                                             message:@"Enter the value in range 3 to 50"
                                             preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* yesButton = [UIAlertAction
                                            actionWithTitle:@"OK"   style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * action)
                                            {
                                                //Handle your yes please button action here
                                            }];
                
                
                [alert addAction:yesButton];
                
                [self presentViewController:alert animated:YES completion:nil];
            }
            else
            {
                if (tsturnon>1 && tsturnon<=9)
                {
                    myT23 = [NSString stringWithFormat:@"%02d",tsturnon];
                    txttsturnon.text=myT23;
                }
                else
                {
                    myT23 = txttsturnon.text;
                    double value19 = [myT23 doubleValue];
                    tsturnon= value19;
                }
                
            }
            
        }
        
        // Code for Drop Out Offset
        
        if(txtdropoutoffset.resignFirstResponder==true)
        {
            dropoutOffsetBool=true;
            NSString *text19 = txtdropoutoffset.text;
            double value19 = [text19 doubleValue];
            tdropout= value19;
            myT24 = [[NSNumber numberWithDouble:tdropout] stringValue];
            txtdropoutoffset.text=myT24;
            
            if (tdropout>50)
            {
                tdropout=50;
                myT24 = [[NSNumber numberWithDouble:tdropout] stringValue];
                txtdropoutoffset.text=myT24;
                
                UIAlertController * alert = [UIAlertController
                                             alertControllerWithTitle:@""
                                             message:@"Enter the value in range 0 to 50"
                                             preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* yesButton = [UIAlertAction
                                            actionWithTitle:@"OK"  style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * action)
                                            {
                                                //Handle your yes please button action here
                                            }];
                
                
                [alert addAction:yesButton];
                
                [self presentViewController:alert animated:YES completion:nil];
                
            }
            else if (tdropout<=0)
            {
                tdropout=0;
                myT24= [NSString stringWithFormat:@"%02d",tdropout];
                txtdropoutoffset.text=myT24;
            }
            else
            {
                
                if (tdropout>0 && tdropout<=9) //for display two digit like 00,01....
                {
                    myT24= [NSString stringWithFormat:@"%02d",tdropout];
                    txtdropoutoffset.text=myT24;
                }
                else
                {
                    myT24 = txtdropoutoffset.text;
                    double value19 = [myT24 doubleValue];
                    tdropout= value19;
                }
                
            }
        }
    }
    else
    {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@""
                                     message:@"Please connect to motor"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"OK"  style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        //Handle your yes please button action here
                                    }];
        
        
        [alert addAction:yesButton];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    // Prevent crashing undo bug – see note below.
    if(textField==txtturnonspeed)
    {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return newLength <=3;
    }
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return newLength <=2;
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (receptionStartFlag==true)
    {
        
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if (result.height==480||result.height==568||result.height==375||result.height==414)
        {
            if (textField==txttsturnon)
            {
                CGRect moveViewUpside = self.view.frame;
                moveViewUpside.origin.y=-150;
                [UIView animateWithDuration:0.3 animations:^{
                    self.view.frame=moveViewUpside;
                }];
            }
            
            if (textField==txtdropoutoffset)
            {
                CGRect moveViewUp =self.view.frame;
                moveViewUp.origin.y=-150;
                [UIView animateWithDuration:0.3 animations:^{
                    self.view.frame=moveViewUp;
                }];
                
            }
            
            if (textField==txtflipaxel)
            {
                CGRect moveViewUpside = self.view.frame;
                moveViewUpside.origin.y=-80;
                [UIView animateWithDuration:0.3 animations:^{
                    self.view.frame=moveViewUpside;
                }];
            }
            
            if (textField==txttorquemultiplier)
            {
                CGRect moveViewUp =self.view.frame;
                moveViewUp.origin.y=-80;
                [UIView animateWithDuration:0.3 animations:^{
                    self.view.frame=moveViewUp;
                }];
                
            }
            
        }
    }
    else
    {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@""
                                     message:@"Please connect to motor"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"OK"    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        //Handle your yes please button action here
                                    }];
        
        
        [alert addAction:yesButton];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [txtturnonspeed resignFirstResponder];
    [txtturnondelay resignFirstResponder];
    [txtturnoffdelay resignFirstResponder];
    [txtbasetorque resignFirstResponder];
    [txtflipaxel resignFirstResponder];
    [txttorquemultiplier resignFirstResponder];
    [txttsturnon resignFirstResponder];
    [txtdropoutoffset resignFirstResponder];
    
    CGSize result = [[UIScreen mainScreen] bounds].size;
    
    if (result.height==480||result.height==568||result.height==375||result.height==414)
    {
        if (textField==txttsturnon)
        {
            CGRect moveViewUpside = self.view.frame;
            moveViewUpside.origin.y=+0;
            [UIView animateWithDuration:0.3 animations:^{
                self.view.frame=moveViewUpside;
            }];
            
        }
        if (textField==txtdropoutoffset)
        {
            CGRect moveViewUpside = self.view.frame;
            moveViewUpside.origin.y=+0;
            [UIView animateWithDuration:0.3 animations:^{
                self.view.frame=moveViewUpside;
            }];
            
        }
    }
    
    
    return YES;
}


- (IBAction)btnrestore:(id)sender
{
    if(receptionStartFlag==true)
    {
        //----------------- txttsturnon---------------------
        int a = 05;
        NSString *m = [NSString stringWithFormat:@"%d",a];
        txttsturnon.text=m;
        
        //-------------- txtturnonspeed -----------------
        int b = 10;
        NSString *m1 = [NSString stringWithFormat:@"%d",b];
        txtturnonspeed.text=m1;
        
        //-------- -----txtbasetorque------------
        int c = 03;
        NSString *m2 = [NSString stringWithFormat:@"%d",c];
        txtbasetorque.text=m2;
        
        // ---------------txttorquemultiplier-------------------------
        int d = 12;
        NSString *m3 = [NSString stringWithFormat:@"%d",d];
        txttorquemultiplier.text=m3;
        
        // ----------------txtdropoutoffset----------------------
        int e = 05;
        NSString *m4 = [NSString stringWithFormat:@"%d",e];
        txtdropoutoffset.text=m4;
        
        //------------------txtflipaxel----------------------------
        int f = 00;
        NSString *m5 = [NSString stringWithFormat:@"%d",f];
        txtflipaxel.text=m5;
        
        //-----------------txtturnondelay---------------------------
        int g = 30;
        NSString *m6 = [NSString stringWithFormat:@"%d",g];
        txtturnondelay.text=m6;
        
        //------------------txtturnoffdelay-----------------------
        int h = 05;
        NSString *m7 = [NSString stringWithFormat:@"%d",h];
        txtturnoffdelay.text=m7;
        
        int duration =0.2;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(),
                       ^{
                           
                           
                           
                           
                           UIAlertController * alert = [UIAlertController
                                                        alertControllerWithTitle:@""
                                                        message:@"You have restore default values.Please broadcast"
                                                        preferredStyle:UIAlertControllerStyleAlert];
                           
                           UIAlertAction* yesButton = [UIAlertAction
                                                       actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                       }];
                           
                           [alert addAction:yesButton];
                           
                           [self presentViewController:alert animated:YES completion:nil];
                           
                       });
    }
    else
    {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@""
                                     message:@"Please connect to motor"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"OK"    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        //Handle your yes please button action here
                                    }];
        
        
        [alert addAction:yesButton];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
}


-(void)cancelNumberPad
{
    [txtturnonspeed resignFirstResponder];
    [txtturnondelay resignFirstResponder];
    [txtturnoffdelay resignFirstResponder];
    [txtbasetorque resignFirstResponder];
    [txtflipaxel resignFirstResponder];
    [txttorquemultiplier resignFirstResponder];
    [txttsturnon resignFirstResponder];
    [txtdropoutoffset resignFirstResponder];
    CGSize result = [[UIScreen mainScreen] bounds].size;
    if (result.height==480||result.height==568||result.height==375||result.height==414)
    {
        if (txttsturnon)
        {
            CGRect moveViewUpside = self.motorView.frame;
            moveViewUpside.origin.y=+0;
            [UIView animateWithDuration:0.3 animations:^{
                self.view.frame=moveViewUpside;
            }];
            
        }
        if (txtdropoutoffset)
        {
            CGRect moveViewUpside = self.motorView.frame;
            moveViewUpside.origin.y=+0;
            [UIView animateWithDuration:0.3 animations:^{
                self.view.frame=moveViewUpside;
            }];
            
        }
        
    }
    
}

-(void)doneWithNumberPad
{
    [txtturnonspeed resignFirstResponder];
    [txtturnondelay resignFirstResponder];
    [txtturnoffdelay resignFirstResponder];
    [txtbasetorque resignFirstResponder];
    [txtflipaxel resignFirstResponder];
    [txttorquemultiplier resignFirstResponder];
    [txttsturnon resignFirstResponder];
    [txtdropoutoffset resignFirstResponder];
    
    if (txttsturnon)
    {
        CGRect moveViewUpside = self.motorView.frame;
        moveViewUpside.origin.y=+0;
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame=moveViewUpside;
        }];
        
    }
    
    if (txtdropoutoffset)
    {
        CGRect moveViewUpside = self.motorView.frame;
        moveViewUpside.origin.y=+0;
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame=moveViewUpside;
        }];
        
    }
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component............
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [dropoutData count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    selectedDropout = [dropoutData objectAtIndex:[self.dropout_Picker selectedRowInComponent:0]];
    return dropoutData[row];
}


- (IBAction)onSendDropout:(id)sender
{
    if(receptionStartFlag==true)
    {
        if ([selectedDropout isEqual:@"Vertical"])
        {
            
            int8_t bytes2[] ={117,01,00,00,00,00,00,00,00,00,00,00,00};
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
        
        if ([selectedDropout isEqual:@"Horizontal"])
        {
            dropoutFlag=true;
            
            int8_t bytes2[] ={117,02,00,00,00,00,00,00,00,00,00,00,00};
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
    }
    else
    {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@""
                                     message:@"Please connect to motor"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                    }];
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}


-(void)adjustFontSizeOfLabel
{
    
    CGRect screenSize = [[UIScreen mainScreen]bounds];
    
    if (screenSize.size.height <= 480)
    {
        // iPhone 4
        [btnbroadcast.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [btnmemoryread.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [btnrestore.titleLabel setFont:[UIFont systemFontOfSize:12]];
    }
    else if (screenSize.size.height <= 568)
    {
        // IPhone 5/5s/5c
        
        self.btnbroadcast.titleLabel.font=[self.btnbroadcast.font fontWithSize:18];
        self.btnmemoryread.titleLabel.font=[self.btnmemoryread.font fontWithSize:18];
        self.btnrestore.titleLabel.font=[self.btnrestore.font fontWithSize:18];
        
        //        [btnbroadcast.titleLabel setFont:[UIFont systemFontOfSize:15]];
        //        [btnmemoryread.titleLabel setFont:[UIFont systemFontOfSize:15]];
        //        [btnrestore.titleLabel setFont:[UIFont systemFontOfSize:15]];
        self.lbl_TurnOnSpeed.font = [self.lbl_TurnOnSpeed.font fontWithSize:19];
        self.lbl_FlipAxel.font = [self.lbl_FlipAxel.font fontWithSize:19];
        self.lbl_TsTurnOn.font = [self.lbl_TsTurnOn.font fontWithSize:19];
        self.lbl_BaseTorque.font = [self.lbl_BaseTorque.font fontWithSize:19];
        self.lbl_TurnOnDelay.font = [self.lbl_TurnOnDelay.font fontWithSize:19];
        self.lbl_TurnOffDelay.font = [self.lbl_TurnOffDelay.font fontWithSize:19];
        self.lbl_DropoutOffset.font = [self.lbl_DropoutOffset.font fontWithSize:19];
        self.lbl_TorqueMultiplier.font = [self.lbl_TorqueMultiplier.font fontWithSize:19];
        self.lbl_MotorControl.font = [self.lbl_MotorControl.font fontWithSize:28];
        self.txtturnonspeed.font = [self.txtturnonspeed.font fontWithSize:37];
        self.txtflipaxel.font = [self.txtflipaxel.font fontWithSize:37];
        self.txttsturnon.font = [self.txttsturnon.font fontWithSize:37];
        self.txtbasetorque.font = [self.txtbasetorque.font fontWithSize:37];
        self.txtturnondelay.font = [self.txtturnondelay.font fontWithSize:37];
        self.txtturnoffdelay.font = [self.txtturnoffdelay.font fontWithSize:37];
        self.txtdropoutoffset.font = [self.txtdropoutoffset.font fontWithSize:37];
        self.txttorquemultiplier.font = [self.txttorquemultiplier.font fontWithSize:37];
        self.lbl_DropoutSelect.font = [self.lbl_DropoutSelect.font fontWithSize:19];
        
        self.btn_Send.titleLabel.font=[self.btn_Send.font fontWithSize:16];
        //[_btn_Send.titleLabel setFont:[UIFont systemFontOfSize:13]];
        
    }
    else if (screenSize.size.width <= 375)
    {
        // iPhone 6
        
        self.btnbroadcast.titleLabel.font=[self.btnbroadcast.font fontWithSize:19];
        self.btnmemoryread.titleLabel.font=[self.btnmemoryread.font fontWithSize:19];
        self.btnrestore.titleLabel.font=[self.btnrestore.font fontWithSize:19];
        
        //        [btnbroadcast.titleLabel setFont:[UIFont systemFontOfSize:15]];
        //        [btnmemoryread.titleLabel setFont:[UIFont systemFontOfSize:15]];
        //        [btnrestore.titleLabel setFont:[UIFont systemFontOfSize:15]];
        
        self.lbl_TurnOnSpeed.font = [self.lbl_TurnOnSpeed.font fontWithSize:18];
        self.lbl_FlipAxel.font = [self.lbl_FlipAxel.font fontWithSize:18];
        self.lbl_TsTurnOn.font = [self.lbl_TsTurnOn.font fontWithSize:18];
        self.lbl_BaseTorque.font = [self.lbl_BaseTorque.font fontWithSize:18];
        self.lbl_TurnOnDelay.font = [self.lbl_TurnOnDelay.font fontWithSize:18];
        self.lbl_TurnOffDelay.font = [self.lbl_TurnOffDelay.font fontWithSize:18];
        self.lbl_DropoutOffset.font = [self.lbl_DropoutOffset.font fontWithSize:18];
        self.lbl_TorqueMultiplier.font = [self.lbl_TorqueMultiplier.font fontWithSize:18];
        self.lbl_DropoutSelect.font = [self.lbl_DropoutSelect.font fontWithSize:18];
        
        self.lbl_MotorControl.font = [self.lbl_MotorControl.font fontWithSize:32];
        
        self.txtturnonspeed.font = [self.txtturnonspeed.font fontWithSize:39];
        self.txtflipaxel.font = [self.txtflipaxel.font fontWithSize:39];
        self.txttsturnon.font = [self.txttsturnon.font fontWithSize:39];
        self.txtbasetorque.font = [self.txtbasetorque.font fontWithSize:39];
        self.txtturnondelay.font = [self.txtturnondelay.font fontWithSize:39];
        self.txtturnoffdelay.font = [self.txtturnoffdelay.font fontWithSize:39];
        self.txtdropoutoffset.font = [self.txtdropoutoffset.font fontWithSize:39];
        self.txttorquemultiplier.font = [self.txttorquemultiplier.font fontWithSize:39];
        self.btn_Send.titleLabel.font=[self.btn_Send.font fontWithSize:18];
        //        [_btn_Send.titleLabel setFont:[UIFont systemFontOfSize:15]];
    }
    else if (screenSize.size.width <= 414)
    {
        // iPhone 6+
        
        self.btnbroadcast.titleLabel.font=[self.btnbroadcast.font fontWithSize:20];
        self.btnmemoryread.titleLabel.font=[self.btnmemoryread.font fontWithSize:20];
        self.btnrestore.titleLabel.font=[self.btnrestore.font fontWithSize:20];
        
        //        [btnbroadcast.titleLabel setFont:[UIFont systemFontOfSize:16]];
        //        [btnmemoryread.titleLabel setFont:[UIFont systemFontOfSize:16]];
        //        [btnrestore.titleLabel setFont:[UIFont systemFontOfSize:16]];
        self.lbl_TurnOnSpeed.font = [self.lbl_TurnOnSpeed.font fontWithSize:19];
        self.lbl_FlipAxel.font = [self.lbl_FlipAxel.font fontWithSize:19];
        self.lbl_TsTurnOn.font = [self.lbl_TsTurnOn.font fontWithSize:19];
        self.lbl_BaseTorque.font = [self.lbl_BaseTorque.font fontWithSize:19];
        self.lbl_TurnOnDelay.font = [self.lbl_TurnOnDelay.font fontWithSize:19];
        self.lbl_TurnOffDelay.font = [self.lbl_TurnOffDelay.font fontWithSize:19];
        self.lbl_DropoutOffset.font = [self.lbl_DropoutOffset.font fontWithSize:19];
        self.lbl_TorqueMultiplier.font = [self.lbl_TorqueMultiplier.font fontWithSize:19];
        self.lbl_MotorControl.font = [self.lbl_MotorControl.font fontWithSize:35];
        
        self.txtturnonspeed.font = [self.txtturnonspeed.font fontWithSize:45];
        self.txtflipaxel.font = [self.txtflipaxel.font fontWithSize:45];
        self.txttsturnon.font = [self.txttsturnon.font fontWithSize:45];
        self.txtbasetorque.font = [self.txtbasetorque.font fontWithSize:45];
        self.txtturnondelay.font = [self.txtturnondelay.font fontWithSize:45];
        self.txtturnoffdelay.font = [self.txtturnoffdelay.font fontWithSize:45];
        self.txtdropoutoffset.font = [self.txtdropoutoffset.font fontWithSize:45];
        self.txttorquemultiplier.font = [self.txttorquemultiplier.font fontWithSize:45];
        self.lbl_DropoutSelect.font = [self.lbl_DropoutSelect.font fontWithSize:24];
        //[_btn_Send.titleLabel setFont:[UIFont systemFontOfSize:16]];
        
        self.btn_Send.titleLabel.font=[self.btn_Send.font fontWithSize:19];
    }
}


@end
