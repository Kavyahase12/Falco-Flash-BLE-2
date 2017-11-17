//
//  ManufacturingScreenViewController.m
//  Falco Flash BLE
//
//  Created by Falco eMotors Pvt. Ltd. on 15/10/2016.
//  Copyright © 2016 Falco eMotors Pvt. Ltd. All rights reserved.
//

#import "ManufacturingScreenViewController.h"
#import "ViewController.h"
#import "UARTPeripheral.h"
NSString *voltread;
NSString *m8,*m7;
UIActivityIndicatorView *activityIndicator1;
@interface ManufacturingScreenViewController ()
@property UARTPeripheral *currentPeripheral;
@end

@implementation ManufacturingScreenViewController
@synthesize currentPeripheral = _currentPeripheral;
- (void)viewDidLoad {
    [super viewDidLoad];
    activityIndicator1 = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator1.transform = CGAffineTransformMakeScale(2.5, 2.5);
    activityIndicator1.color=[UIColor blackColor];
    activityIndicator1.alpha = 1.0;
    [_ManuScreenView addSubview:activityIndicator1];
    activityIndicator1.center = CGPointMake([[UIScreen mainScreen]bounds].size.width/2, [[UIScreen mainScreen]bounds].size.height/2);
    

    
    UISwipeGestureRecognizer *swipeRightOrange = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(slideToRightWithGestureRecognizer:)];
    
    swipeRightOrange.direction=UISwipeGestureRecognizerDirectionRight;
    [self.ManuScreenView addGestureRecognizer:swipeRightOrange];
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarButtonItemStylePlain;
    numberToolbar.items = @[[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelNumberPad)],
                            [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                            [[UIBarButtonItem alloc]initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)]];
    [numberToolbar sizeToFit];
    _VoltageLable.inputAccessoryView = numberToolbar;
    if (receptionStartFlag==true)
    {
        _wireless8image.hidden=false;
        [self selfCall];
        
    }
    if (manufacturingflag==true)
    {
        _Firmware_Lable.text = myresult;
        _MotorIDLable.text=m8;
        _VoltageLable.text=voltread;
        _TS_ID_Lable.text=m7;
    }
    _VoltageLable.delegate=self;
    _Firmware_Lable.delegate=self;
    _MotorIDLable.delegate=self;
    _TS_ID_Lable.delegate=self;
    
    tsTransmitFlag=false;
    firmwareTransmitFlag=false;
    motorTransmitFlag=false;
    voltageTransmitFlag=false;
    [self adjustFontSizeOfLabel];
    [self viewWillAppear:YES];
    // Do any additional setup after loading the view.
}

-(void)slideToRightWithGestureRecognizer:(UISwipeGestureRecognizer *)gestureRecognizer{
    [UIView animateWithDuration:0.5 animations:^{
        
        //        [[self presentingViewController] dismissViewControllerAnimated:NO completion:nil];
        [self dismissViewControllerAnimated:NO completion:Nil];
        
        //  NSLog(@"HIIIIIIIIIIIIIIII Manu");
        
        //        [self performSegueWithIdentifier:@"ShowVerify" sender:self];
        
    }];
}

-(void)selfCall
{
    if (receptionStartFlag==true)
    {
        _wireless8image.hidden=false;
        countclose=0;
    }
    
    if (receptionStartFlag==false)
    {
        
        
        _wireless8image.hidden=true;
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
    //[self selfCall];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)checked_1:(id)sender
{
    
    _checked_1.hidden=true;
    _checked_2.hidden=true;
    _checked_3.hidden=true;
    _checked_4.hidden=true;
    _VoltageLable.userInteractionEnabled=false;
    _unchecked_1.hidden=false;
    _unchecked_2.hidden=false;
    _unchecked_3.hidden=false;
    _unchecked_4.hidden=false;
    
    
}

- (IBAction)unchecked_1:(id)sender
{
    _unchecked_1.hidden=true;
    _checked_1.hidden=false;
    if (receptionStartFlag==true)
    {
        firmwareTransmitFlag=true;
        manufacturingflag=true;
        _VoltageLable.userInteractionEnabled=false;
        
      
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                       ^{
                           
                           for (NSInteger i = 1; i <= 15; i++)
                           {
                               [NSThread sleepForTimeInterval:0.250];
                               dispatch_async(dispatch_get_main_queue(),
                                              ^{
                                                  _Firmware_Lable.text = myresult;
                                                  
                                                  [activityIndicator1 startAnimating];//to start animating
                                                  _ManuScreenView.userInteractionEnabled = NO;
                                                  
                                                  
                                              });
                           }
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              if (manu_Firmware==true)
                                              {
                                                  [activityIndicator1 stopAnimating];
                                                 
                                                  _ManuScreenView.userInteractionEnabled = YES;
                                                  UIAlertController * alert = [UIAlertController
                                                                               alertControllerWithTitle:@""
                                                                               message:@"Memory Read Successfully"
                                                                               
                                                                               preferredStyle:UIAlertControllerStyleAlert];
                                                  
                                                  UIAlertAction* yesButton = [UIAlertAction
                                                                              actionWithTitle:@"OK"                                   style:UIAlertActionStyleDefault
                                                                              handler:^(UIAlertAction * action) {
                                                                                  //Handle your yes please button action here
                                                                              }];
                                                  manu_Firmware=false;
                                                  
                                                  [alert addAction:yesButton];
                                                  
                                                  [self presentViewController:alert animated:YES completion:nil];
                                              }else
                                              {
                                                  [activityIndicator1 stopAnimating];
                                                
                                                  _ManuScreenView.userInteractionEnabled = YES;
                                                  UIAlertController * alert = [UIAlertController
                                                                               alertControllerWithTitle:@""
                                                                               message:@"Memory Read Failed!"
                                                                               
                                                                               preferredStyle:UIAlertControllerStyleAlert];
                                                  
                                                  UIAlertAction* yesButton = [UIAlertAction
                                                                              actionWithTitle:@"OK"                                   style:UIAlertActionStyleDefault
                                                                              handler:^(UIAlertAction * action) {
                                                                                  //Handle your yes please button action here
                                                                              }];
                                                  
                                                  manu_Firmware=false;

                                                  [alert addAction:yesButton];
                                                  
                                                  [self presentViewController:alert animated:YES completion:nil];
                                              }
                                             
                                          });
                           
                       });
        
    }else
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
        
        _unchecked_1.hidden=false;
        _checked_1.hidden=true;
    }
    
}

- (IBAction)checked_2:(id)sender
{
    _VoltageLable.userInteractionEnabled=false;
    _checked_2.hidden=true;
    _checked_1.hidden=true;
    _checked_3.hidden=true;
    _checked_4.hidden=true;
    
    _unchecked_1.hidden=false;
    _unchecked_2.hidden=false;
    _unchecked_3.hidden=false;
    _unchecked_4.hidden=false;
    
}

- (IBAction)unchecked_2:(id)sender
{
    _unchecked_2.hidden=true;
    _checked_2.hidden=false;
    if (receptionStartFlag==true) {
        
        
        motorTransmitFlag=true;
        manufacturingflag=true;
        _VoltageLable.userInteractionEnabled=false;
        
        
         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                       ^{
                           
                           for (NSInteger i = 1; i <=20; i++)
                           {
                               [NSThread sleepForTimeInterval:0.250];
                               dispatch_async(dispatch_get_main_queue(),
                                              ^{
                                                  m8 = [[NSNumber numberWithInt: myMotorID]stringValue];
                                                  
                                                  _MotorIDLable.text=m8;
                                              
                                                  
                                                  [activityIndicator1 startAnimating];//to start animating
                                                  _ManuScreenView.userInteractionEnabled = NO;
                                                  
                                                  
                                              });
                           }
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              if (manu_MotorID==true)
                                              {
                                                  [activityIndicator1 stopAnimating];
                                          
                                                  _ManuScreenView.userInteractionEnabled = YES;
                                                  UIAlertController * alert = [UIAlertController
                                                                               alertControllerWithTitle:@""
                                                                               message:@"Memory Read Successfully"
                                                                               
                                                                               preferredStyle:UIAlertControllerStyleAlert];
                                                  
                                                  UIAlertAction* yesButton = [UIAlertAction
                                                                              actionWithTitle:@"OK"                                   style:UIAlertActionStyleDefault
                                                                              handler:^(UIAlertAction * action) {
                                                                                  //Handle your yes please button action here
                                                                              }];
                                                  manu_MotorID=false;
                                                  
                                                  [alert addAction:yesButton];
                                                  
                                                  [self presentViewController:alert animated:YES completion:nil];
                                              }else
                                              {
                                                  [activityIndicator1 stopAnimating];
                                               
                                                  _ManuScreenView.userInteractionEnabled = YES;
                                                  UIAlertController * alert = [UIAlertController
                                                                               alertControllerWithTitle:@""
                                                                               message:@"Memory Read Failed!"
                                                                               
                                                                               preferredStyle:UIAlertControllerStyleAlert];
                                                  
                                                  UIAlertAction* yesButton = [UIAlertAction
                                                                              actionWithTitle:@"OK"                                   style:UIAlertActionStyleDefault
                                                                              handler:^(UIAlertAction * action) {
                                                                                  //Handle your yes please button action here
                                                                              }];
                                                  
                                                  manu_MotorID=false;
                                                  
                                                  [alert addAction:yesButton];
                                                  
                                                  [self presentViewController:alert animated:YES completion:nil];
                                              }
                                          });
                           
                       });
        
    }else
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
        
        _unchecked_2.hidden=false;
        _checked_2.hidden=true;
    }
}

- (IBAction)checked_3:(id)sender
{
    _VoltageLable.userInteractionEnabled=false;
    
    
    _checked_3.hidden=true;
    _checked_1.hidden=true;
    _checked_2.hidden=true;
    _checked_4.hidden=true;
    
    _unchecked_1.hidden=false;
    _unchecked_2.hidden=false;
    _unchecked_3.hidden=false;
    _unchecked_4.hidden=false;
    
}
- (IBAction)unchecked_3:(id)sender
{
    _unchecked_3.hidden=true;
    _checked_3.hidden=false;
    if (receptionStartFlag==true) {
        
        
        tsTransmitFlag=true;
        manufacturingflag=true;
        
        _VoltageLable.userInteractionEnabled=false;
        
               dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                       ^{
                           
                           for (NSInteger i = 1; i <=25; i++)
                           {
                               [NSThread sleepForTimeInterval:0.250];
                               dispatch_async(dispatch_get_main_queue(),
                                              ^{
                                                  
                                                  m7 = [[NSNumber numberWithInt: deci_TS_ID]stringValue];
                                                  _TS_ID_Lable.text=m7;
                                                  
                                                  [activityIndicator1 startAnimating];//to start animating
                                                  _ManuScreenView.userInteractionEnabled = NO;
                                                  
                                              });
                           }
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              if (manu_TSID==true)
                                              {
                                                  [activityIndicator1 stopAnimating];
                                               
                                                  _ManuScreenView.userInteractionEnabled = YES;
                                                  UIAlertController * alert = [UIAlertController
                                                                               alertControllerWithTitle:@""
                                                                               message:@"Memory Read Successfully"
                                                                               
                                                                               preferredStyle:UIAlertControllerStyleAlert];
                                                  
                                                  UIAlertAction* yesButton = [UIAlertAction
                                                                              actionWithTitle:@"OK"                                   style:UIAlertActionStyleDefault
                                                                              handler:^(UIAlertAction * action) {
                                                                                  //Handle your yes please button action here
                                                                              }];
                                                  manu_TSID=false;
                                                  
                                                  [alert addAction:yesButton];
                                                  
                                                  [self presentViewController:alert animated:YES completion:nil];
                                              }else
                                              {
                                                  [activityIndicator1 stopAnimating];
                                            
                                                  _ManuScreenView.userInteractionEnabled = YES;
                                                  UIAlertController * alert = [UIAlertController
                                                                               alertControllerWithTitle:@""
                                                                               message:@"Memory Read Failed!"
                                                                               
                                                                               preferredStyle:UIAlertControllerStyleAlert];
                                                  
                                                  UIAlertAction* yesButton = [UIAlertAction
                                                                              actionWithTitle:@"OK"                                   style:UIAlertActionStyleDefault
                                                                              handler:^(UIAlertAction * action) {
                                                                                  //Handle your yes please button action here
                                                                              }];
                                                  
                                                  manu_TSID=false;
                                                  
                                                  [alert addAction:yesButton];
                                                  
                                                  [self presentViewController:alert animated:YES completion:nil];
                                              }
                                          });
                           
                       });
    }else
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
        
        
        _unchecked_3.hidden=false;
        _checked_3.hidden=true;
    }
}

- (IBAction)checked_4:(id)sender
{
    
    _Broadcast.hidden=true;
    _checked_4.hidden=true;
    
    _checked_1.hidden=true;
    _checked_2.hidden=true;
    _checked_3.hidden=true;
    
    _unchecked_1.hidden=false;
    _unchecked_2.hidden=false;
    _unchecked_3.hidden=false;
    _unchecked_4.hidden=false;
    _VoltageLable.userInteractionEnabled=false;
    
    
}

- (IBAction)unchecked_4:(id)sender
{
    _unchecked_4.hidden=true;
    _checked_4.hidden=false;
    if (receptionStartFlag==true)
    {
        
        
        _VoltageLable.userInteractionEnabled=true;
        voltageTransmitFlag=true;
        _Broadcast.hidden=false;
        _Broadcast.enabled=true;
        manufacturingflag=true;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                       ^{
                           
                           for (NSInteger i = 1; i <=25; i++)
                           {
                               [NSThread sleepForTimeInterval:0.250];
                               dispatch_async(dispatch_get_main_queue(),
                                              ^{
                                                  voltread = [[NSNumber numberWithInt:deci_Voltage]stringValue];
                                                  _VoltageLable.text=voltread;
                                              
                                                  
                                                  
                                                  [activityIndicator1 startAnimating];//to start animating
                                                  _ManuScreenView.userInteractionEnabled = NO;
                                                  
                                                  
                                              });
                           }
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              if (manu_Voltage==true)
                                              {
                                                  [activityIndicator1 stopAnimating];
                                              
                                                  _ManuScreenView.userInteractionEnabled = YES;
                                                  UIAlertController * alert = [UIAlertController
                                                                               alertControllerWithTitle:@""
                                                                               message:@"Memory Read Successfully"
                                                                               
                                                                               preferredStyle:UIAlertControllerStyleAlert];
                                                  
                                                  UIAlertAction* yesButton = [UIAlertAction
                                                                              actionWithTitle:@"OK"                                   style:UIAlertActionStyleDefault
                                                                              handler:^(UIAlertAction * action) {
                                                                                  //Handle your yes please button action here
                                                                              }];
                                                  manu_Voltage=false;
                                                  
                                                  [alert addAction:yesButton];
                                                  
                                                  [self presentViewController:alert animated:YES completion:nil];
                                              }else
                                              {
                                                  [activityIndicator1 stopAnimating];
                                               
                                                  _ManuScreenView.userInteractionEnabled = YES;
                                                  UIAlertController * alert = [UIAlertController
                                                                               alertControllerWithTitle:@""
                                                                               message:@"Memory Read Failed!"
                                                                               
                                                                               preferredStyle:UIAlertControllerStyleAlert];
                                                  
                                                  UIAlertAction* yesButton = [UIAlertAction
                                                                              actionWithTitle:@"OK"                                   style:UIAlertActionStyleDefault
                                                                              handler:^(UIAlertAction * action) {
                                                                                  //Handle your yes please button action here
                                                                              }];
                                                  
                                                  manu_Voltage=false;
                                                  
                                                  [alert addAction:yesButton];
                                                  
                                                  [self presentViewController:alert animated:YES completion:nil];
                                              }
                                          });
                           
                       });
        
    }else
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
        
        
        _unchecked_4.hidden=false;
        _checked_4.hidden=true;
        
    }
    
}
- (IBAction)onVoltageBroadcast:(id)sender
{
    if (receptionStartFlag==true)
    {
        
        voltageBroadcast=true;
        vtgBroadcastValue=_VoltageLable.text;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                       ^{
                           
                           for (NSInteger i = 1; i <= 30; i++)
                           {
                               [NSThread sleepForTimeInterval:0.250];
                               dispatch_async(dispatch_get_main_queue(),
                                              ^{
                                                  
                                                  
                                                  
                                                  [activityIndicator1 startAnimating];//to start animating
                                                  _ManuScreenView.userInteractionEnabled = NO;
                                                  
                                                  
                                              });
                           }
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              [activityIndicator1 stopAnimating];
                                              _ManuScreenView.userInteractionEnabled = YES;
                                           
                                              
                                              
                                              UIAlertController * alert = [UIAlertController
                                                                           alertControllerWithTitle:@""
                                                                           message:@"Broadcast Done"
                                                                           preferredStyle:UIAlertControllerStyleAlert];
                                              
                                              UIAlertAction* yesButton = [UIAlertAction
                                                                          actionWithTitle:@"OK"                                   style:UIAlertActionStyleDefault
                                                                          handler:^(UIAlertAction * action) {
                                                                              //Handle your yes please button action here
                                                                          }];
                                              
                                              
                                              [alert addAction:yesButton];
                                              
                                              [self presentViewController:alert animated:YES completion:nil];
                                              
                                              
                                          });
                           
                       });
        
        //_VoltageLable.text=@"0";
        _unchecked_4.hidden=false;
        _checked_4.hidden=true;
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

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(_VoltageLable.resignFirstResponder==true)
    {
        
        NSString *text1 = _VoltageLable.text;
        double value1 = [text1 doubleValue];
        voltageTarget= value1;
        
        NSString *myT = [[NSNumber numberWithDouble:value1] stringValue];
        _VoltageLable.text=myT;
        
        if(voltageTarget>55)
        {
            voltageTarget = 55;
            NSString *myT12 = [[NSNumber numberWithDouble:voltageTarget] stringValue];
            _VoltageLable.text=myT12;
        }
        if(voltageTarget<20)
        {
            voltageTarget = 20;
            NSString *myT12 = [[NSNumber numberWithDouble:voltageTarget] stringValue];
            _VoltageLable.text=myT12;
        }
        
        NSString *myT1 = [[NSNumber numberWithDouble:voltageTarget] stringValue];
        
        _VoltageLable.text=myT1;
        
        
        [self.VoltageLable setNeedsDisplay];
    }
    
    
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGSize result = [[UIScreen mainScreen] bounds].size;
    if (result.height==480||result.height==568||result.height==375||result.height==414)
    {
        if (textField==_VoltageLable)
        {
            CGRect moveViewUpside = self.view.frame;
            moveViewUpside.origin.y=-150;
            [UIView animateWithDuration:0.3 animations:^{
                self.view.frame=moveViewUpside;
            }];
        }
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_VoltageLable resignFirstResponder];
    
    CGSize result = [[UIScreen mainScreen] bounds].size;
    if (result.height==480||result.height==568||result.height==375||result.height==414)
    {
        if (textField==_VoltageLable)
        {
            CGRect moveViewUpside = self.ManuScreenView.frame;
            moveViewUpside.origin.y=+0;
            [UIView animateWithDuration:0.3 animations:^{
                self.view.frame=moveViewUpside;
            }];
            
        }
        
        
    }
    
    return YES;
}
-(void)cancelNumberPad
{
    [_VoltageLable resignFirstResponder];
    CGSize result = [[UIScreen mainScreen] bounds].size;
    if (result.height==480||result.height==568||result.height==375||result.height==414)
    {
        if (_VoltageLable)
        {
            CGRect moveViewUpside = self.ManuScreenView.frame;
            moveViewUpside.origin.y=+0;
            [UIView animateWithDuration:0.3 animations:^{
                self.view.frame=moveViewUpside;
            }];
            
        }
    }
}

-(void)doneWithNumberPad
{
    [_VoltageLable resignFirstResponder];
    
    CGSize result = [[UIScreen mainScreen] bounds].size;
    if (result.height==480||result.height==568||result.height==375||result.height==414)
    {
        if (_VoltageLable)
        {
            CGRect moveViewUpside = self.ManuScreenView.frame;
            moveViewUpside.origin.y=+0;
            [UIView animateWithDuration:0.3 animations:^{
                self.view.frame=moveViewUpside;
            }];
            
        }
    }
    
}
-(void)adjustFontSizeOfLabel{
    
    CGRect screenSize = [[UIScreen mainScreen]bounds];
    
    if (screenSize.size.height <= 480) {
        // iPhone 4
        self.lbl_firmware.font = [self.lbl_firmware.font fontWithSize:12];
    } else if (screenSize.size.height <= 568) {
        // IPhone 5/5s/5c
       self.lbl_firmware.font = [self.lbl_firmware.font fontWithSize:20];
        self.lbl_TurnONVoltage.font = [self.lbl_TurnONVoltage.font fontWithSize:20];
        self.lbl_TSID.font = [self.lbl_TSID.font fontWithSize:20];
        self.lbl_MotorID.font = [self.lbl_MotorID.font fontWithSize:20];
        self.lbl_ErrorMsg.font = [self.lbl_ErrorMsg.font fontWithSize:20];

        self.lbl_Manufacturingparameter.font=[self.lbl_Manufacturingparameter.font fontWithSize:28];
        
        self.Firmware_Lable.font=[self.Firmware_Lable.font fontWithSize:17];
        self.TS_ID_Lable.font=[self.TS_ID_Lable.font fontWithSize:17];
        self.MotorIDLable.font=[self.MotorIDLable.font fontWithSize:17];
        self.VoltageLable.font=[self.VoltageLable.font fontWithSize:17];
        
    } else if (screenSize.size.width <= 375) {
        // iPhone 6
        self.lbl_firmware.font = [self.lbl_firmware.font fontWithSize:20];
        self.lbl_TurnONVoltage.font = [self.lbl_TurnONVoltage.font fontWithSize:20];
        self.lbl_TSID.font = [self.lbl_TSID.font fontWithSize:20];
        self.lbl_MotorID.font = [self.lbl_MotorID.font fontWithSize:20];
        self.lbl_ErrorMsg.font = [self.lbl_ErrorMsg.font fontWithSize:20];
        
        self.lbl_Manufacturingparameter.font=[self.lbl_Manufacturingparameter.font fontWithSize:31];
        
        self.Firmware_Lable.font=[self.Firmware_Lable.font fontWithSize:20];
        self.TS_ID_Lable.font=[self.TS_ID_Lable.font fontWithSize:20];
        self.MotorIDLable.font=[self.MotorIDLable.font fontWithSize:20];
        self.VoltageLable.font=[self.VoltageLable.font fontWithSize:20];

        
        
        
        
    } else if (screenSize.size.width <= 414) {
        // iPhone 6+
        self.lbl_firmware.font = [self.lbl_firmware.font fontWithSize:20];
        self.lbl_TurnONVoltage.font = [self.lbl_TurnONVoltage.font fontWithSize:20];
        self.lbl_TSID.font = [self.lbl_TSID.font fontWithSize:20];
        self.lbl_MotorID.font = [self.lbl_MotorID.font fontWithSize:20];
        self.lbl_ErrorMsg.font = [self.lbl_ErrorMsg.font fontWithSize:20];
        
        self.lbl_Manufacturingparameter.font=[self.lbl_Manufacturingparameter.font fontWithSize:34];
        
        self.Firmware_Lable.font=[self.Firmware_Lable.font fontWithSize:23];
        self.TS_ID_Lable.font=[self.TS_ID_Lable.font fontWithSize:23];
        self.MotorIDLable.font=[self.MotorIDLable.font fontWithSize:23];
        self.VoltageLable.font=[self.VoltageLable.font fontWithSize:23];
   
    }
}


@end
