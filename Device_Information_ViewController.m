//
//  Device_Information_ViewController.m
//  Falco Flash BLE
//
//  Created by Falco eMotors Pvt. Ltd. on 15/03/2017.
//  Copyright © 2017 Falco eMotors Pvt. Ltd. All rights reserved.
//

#import "Device_Information_ViewController.h"
UIActivityIndicatorView *activityIndicator4;

@interface Device_Information_ViewController ()

@end

@implementation Device_Information_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _txt_Voltage.delegate=self;
    
    activityIndicator4 = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator4.transform = CGAffineTransformMakeScale(2.5, 2.5);
    activityIndicator4.color=[UIColor blackColor];
    activityIndicator4.alpha = 1.0;
    [_device_Info_View addSubview:activityIndicator4];
    activityIndicator4.center = CGPointMake([[UIScreen mainScreen]bounds].size.width/2, [[UIScreen mainScreen]bounds].size.height/2);
    
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarButtonItemStylePlain;
    numberToolbar.items = @[[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelNumberPad)],
                            [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                            [[UIBarButtonItem alloc]initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)]];
    [numberToolbar sizeToFit];
_txt_Voltage.inputAccessoryView = numberToolbar;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onFirmwareRead:(id)sender
{
    if (receptionStartFlag==true)
    {
        // firmwareTransmitFlag=true;
        rxRecpPause=false;
        manufacturingflag=true;
        int8_t bytes2[] ={133,02,00,00,00,00,00,00,00,00,00,00,00};
        
        NSData *data2 = [NSData dataWithBytes:bytes2 length:sizeof(bytes2)];
        // NSLog(@"MIDDLE %@", data2);
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
        
        firmwareReceiveFlag=true;
        rxRecpPause=true;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                       ^{
                           
                           for (NSInteger i = 1; i <= 15; i++)
                           {
                               [NSThread sleepForTimeInterval:0.250];
                               dispatch_async(dispatch_get_main_queue(),
                                              ^{
                                                  _txt_FirmwareNo.text = myresult;
                                                  
                                                  [activityIndicator4 startAnimating];//to start animating
                                                  _device_Info_View.userInteractionEnabled = NO;
                                                  
                                                  
                                              });
                           }
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              if (manu_Firmware==true)
                                              {
                                                  [activityIndicator4 stopAnimating];
                                                  
                                                  _device_Info_View.userInteractionEnabled = YES;
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
                                                  [activityIndicator4 stopAnimating];
                                                  
                                                  _device_Info_View.userInteractionEnabled = YES;
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
        
    }

}

- (IBAction)onVoltageBroadcast:(id)sender
{
    if (receptionStartFlag==true)
    {
         vtgBroadcastValue=_txt_Voltage.text;
        if (![vtgBroadcastValue isEqual:@""])
        {
            
        rxRecpPause=false;
        int vtgIntValue=[vtgBroadcastValue intValue];
        
        int8_t bytes2[] ={134,01,vtgIntValue,00,00,00,00,00,00,00,00,00,00};
        
        NSData *data2 = [NSData dataWithBytes:bytes2 length:sizeof(bytes2)];
        // NSLog(@"MIDDLE %@", data2);
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
        
        
        voltageBroadcast=true;
       
        rxRecpPause=true;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                       ^{
                           
                           for (NSInteger i = 1; i <= 30; i++)
                           {
                               [NSThread sleepForTimeInterval:0.250];
                               dispatch_async(dispatch_get_main_queue(),
                                              ^{
                                                  
                                                  
                                                  
                                                  [activityIndicator4 startAnimating];//to start animating
                                                  _device_Info_View.userInteractionEnabled = NO;
                                                  
                                                  
                                              });
                           }
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              [activityIndicator4 stopAnimating];
                                              _device_Info_View.userInteractionEnabled = YES;
                                              
                                              
                                              
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
        }else
        {
            UIAlertController * alert = [UIAlertController
                                         alertControllerWithTitle:@""
                                         message:@"!Text can not left blank"
                                         preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:@"OK"                                   style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action) {
                                            //Handle your yes please button action here
                                        }];
            
            
            [alert addAction:yesButton];
            
            [self presentViewController:alert animated:YES completion:nil];

            
        }
        //_VoltageLable.text=@"0";
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

- (IBAction)onVoltageRead:(id)sender
{
    if (receptionStartFlag==true)
    {
        rxRecpPause=false;
        voltageReceiveFlag=true;
        int8_t bytes2[] ={134,02,00,00,00,00,00,00,00,00,00,00,00};
        
        NSData *data2 = [NSData dataWithBytes:bytes2 length:sizeof(bytes2)];
        // NSLog(@"MIDDLE %@", data2);
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
        
        
        // voltageTransmitFlag=true;
        manufacturingflag=true;
        rxRecpPause=true;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                       ^{
                           
                           for (NSInteger i = 1; i <=25; i++)
                           {
                               [NSThread sleepForTimeInterval:0.250];
                               dispatch_async(dispatch_get_main_queue(),
                                              ^{
                                                 NSString *voltread = [[NSNumber numberWithInt:deci_Voltage]stringValue];
                                                  _txt_Voltage.text=voltread;
                                                  
                                                  
                                                  
                                                  [activityIndicator4 startAnimating];//to start animating
                                                  _device_Info_View.userInteractionEnabled = NO;
                                                  
                                                  
                                              });
                           }
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              if (manu_Voltage==true)
                                              {
                                                  [activityIndicator4 stopAnimating];
                                                  
                                                  _device_Info_View.userInteractionEnabled = YES;
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
                                                  [activityIndicator4 stopAnimating];
                                                  
                                                  _device_Info_View.userInteractionEnabled = YES;
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
        
        
    }

}
- (IBAction)onCloseView:(id)sender
{
     [self dismissViewControllerAnimated:YES completion:Nil];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(_txt_Voltage.resignFirstResponder==true)
    {
        
        NSString *text1 = _txt_Voltage.text;
        double value1 = [text1 doubleValue];
        voltageTarget= value1;
        
        NSString *myT = [[NSNumber numberWithDouble:value1] stringValue];
        _txt_Voltage.text=myT;
        
        if(voltageTarget>55)
        {
            voltageTarget = 55;
            NSString *myT12 = [[NSNumber numberWithDouble:voltageTarget] stringValue];
            _txt_Voltage.text=myT12;
        }
        if(voltageTarget<20)
        {
            voltageTarget = 20;
            NSString *myT12 = [[NSNumber numberWithDouble:voltageTarget] stringValue];
            _txt_Voltage.text=myT12;
        }
        
        NSString *myT1 = [[NSNumber numberWithDouble:voltageTarget] stringValue];
        
        _txt_Voltage.text=myT1;
        
        
        [self.txt_Voltage setNeedsDisplay];
    }
    
    
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGSize result = [[UIScreen mainScreen] bounds].size;
    if (result.height==480||result.height==568||result.height==375||result.height==414)
    {
        if (textField==_txt_Voltage)
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
    [_txt_Voltage resignFirstResponder];
    
    CGSize result = [[UIScreen mainScreen] bounds].size;
    if (result.height==480||result.height==568||result.height==375||result.height==414)
    {
        if (textField==_txt_Voltage)
        {
            CGRect moveViewUpside = self.device_Info_View.frame;
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
    [_txt_Voltage resignFirstResponder];
    CGSize result = [[UIScreen mainScreen] bounds].size;
    if (result.height==480||result.height==568||result.height==375||result.height==414)
    {
        if (_txt_Voltage)
        {
            CGRect moveViewUpside = self.device_Info_View.frame;
            moveViewUpside.origin.y=+0;
            [UIView animateWithDuration:0.3 animations:^{
                self.view.frame=moveViewUpside;
            }];
            
        }
    }
}

-(void)doneWithNumberPad
{
    [_txt_Voltage resignFirstResponder];
    
    CGSize result = [[UIScreen mainScreen] bounds].size;
    if (result.height==480||result.height==568||result.height==375||result.height==414)
    {
        if (_txt_Voltage)
        {
            CGRect moveViewUpside = self.device_Info_View.frame;
            moveViewUpside.origin.y=+0;
            [UIView animateWithDuration:0.3 animations:^{
                self.view.frame=moveViewUpside;
            }];
            
        }
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *validation = [_txt_Voltage.text stringByReplacingCharactersInRange:range withString:string];
    
    //first, check if the new string is numeric only. If not, return NO;
    NSCharacterSet *characterSet1 = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789,."] invertedSet];
    if ([validation rangeOfCharacterFromSet:characterSet1].location != NSNotFound)
    {
        return NO;
    }
    
    return [validation doubleValue] < 99;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
