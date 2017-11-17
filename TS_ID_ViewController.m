//
//  TS_ID_ViewController.m
//  Falco Flash BLE
//
//  Created by Falco eMotors Pvt. Ltd. on 15/03/2017.
//  Copyright © 2017 Falco eMotors Pvt. Ltd. All rights reserved.
//

#import "TS_ID_ViewController.h"
#import "UARTPeripheral.h"
#import "AppDelegate.h"
UIActivityIndicatorView *activityIndicator5;
AppDelegate *mainDelegate;
@interface TS_ID_ViewController ()

@end

@implementation TS_ID_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
  //  UARTPeripheral *uart=[[UARTPeripheral alloc]init];
  //  UARTPeripheral *uart = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    //uart.didTSConnect];

    
    activityIndicator5 = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator5.transform = CGAffineTransformMakeScale(2.5, 2.5);
    activityIndicator5.color=[UIColor blackColor];
    activityIndicator5.alpha = 1.0;
    [_ts_Id_View addSubview:activityIndicator5];
    activityIndicator5.center = CGPointMake([[UIScreen mainScreen]bounds].size.width/2, [[UIScreen mainScreen]bounds].size.height/2);
    

    
    
    _txt_TSIDSet.delegate=self;
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarButtonItemStylePlain;
    numberToolbar.items = @[[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelNumberPad)],
                            [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                            [[UIBarButtonItem alloc]initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)]];
    [numberToolbar sizeToFit];
_txt_TSIDSet.inputAccessoryView = numberToolbar;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onCloseView:(id)sender
{
     [self dismissViewControllerAnimated:YES completion:Nil];
}

- (IBAction)onSetID:(id)sender
{
    if (receptionStartFlag==true)
    {
       NSString *idOnMotor=_txt_TSIDSet.text;
        if (![idOnMotor isEqual:@""])
        {
            
        rxRecpPause=false;
        int setID=[idOnMotor intValue];
            for (int d=0;d<=3;d++)
            {
        int8_t bytes2[] ={83,02,setID,00,00,00,00,00,00,00,00,00,00};
        
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
        
            }
       
        
        rxRecpPause=true;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                       ^{
                           
                           for (NSInteger i = 1; i <= 30; i++)
                           {
                               [NSThread sleepForTimeInterval:0.250];
                               dispatch_async(dispatch_get_main_queue(),
                                              ^{
                                                  
                                                  
                                                  
                [activityIndicator5 startAnimating];//to start animating
                      _ts_Id_View.userInteractionEnabled = NO;
                                                  
                                                  
                                              });
                           }
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                                [activityIndicator5 stopAnimating];
                                                   _ts_Id_View.userInteractionEnabled = YES;
                                              
                                              
                                              
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

- (IBAction)onIDSearch:(id)sender
{
    if (receptionStartFlag==true) {
        
        rxRecpPause=false;
        //        tsTransmitFlag=true;
        int8_t bytes2[] ={153,02,00,00,00,00,00,00,00,00,00,00,00};
        
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
        
        tsReceiveFlag=true;
        
        manufacturingflag=true;
        rxRecpPause=true;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                       ^{
                           
                           for (NSInteger i = 1; i <=25; i++)
                           {
                               [NSThread sleepForTimeInterval:0.250];
                               dispatch_async(dispatch_get_main_queue(),
                                              ^{
                                                  
                                                  
                                                 NSString *m7 = [[NSNumber numberWithInt: deci_TS_ID]stringValue];
                                                  _txt_TSIDSearch.text=m7;
                                                  
                                                  [activityIndicator5 startAnimating];//to start animating
                                                  _ts_Id_View.userInteractionEnabled = NO;
                                                  
                                              });
                           }
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              if (manu_TSID==true)
                                              {
                                                  [activityIndicator5 stopAnimating];
                                                  
                                                  _ts_Id_View.userInteractionEnabled = YES;
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
                                                  [activityIndicator5 stopAnimating];
                                                  
                                                  _ts_Id_View.userInteractionEnabled = YES;
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
        
        
      
    }

}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(_txt_TSIDSet.resignFirstResponder==true)
    {
        
        NSString *text1 = _txt_TSIDSet.text;
        double value1 = [text1 doubleValue];
        voltageTarget= value1;
        
        NSString *myT = [[NSNumber numberWithDouble:value1] stringValue];
        _txt_TSIDSet.text=myT;
        
        if(voltageTarget>255)
        {
            voltageTarget = 255;
            NSString *myT12 = [[NSNumber numberWithDouble:voltageTarget] stringValue];
            _txt_TSIDSet.text=myT12;
        }
        if(voltageTarget<1)
        {
            voltageTarget = 1;
            NSString *myT12 = [[NSNumber numberWithDouble:voltageTarget] stringValue];
            _txt_TSIDSet.text=myT12;
        }
        
        NSString *myT1 = [[NSNumber numberWithDouble:voltageTarget] stringValue];
        
        _txt_TSIDSet.text=myT1;
        
        
        [self.txt_TSIDSet setNeedsDisplay];
    }
    
    
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGSize result = [[UIScreen mainScreen] bounds].size;
    if (result.height==480||result.height==568||result.height==375||result.height==414)
    {
        if (textField==_txt_TSIDSet)
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
    [_txt_TSIDSet resignFirstResponder];
    
    CGSize result = [[UIScreen mainScreen] bounds].size;
    if (result.height==480||result.height==568||result.height==375||result.height==414)
    {
        if (textField==_txt_TSIDSet)
        {
            CGRect moveViewUpside = self.ts_Id_View.frame;
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
    [_txt_TSIDSet resignFirstResponder];
    CGSize result = [[UIScreen mainScreen] bounds].size;
    if (result.height==480||result.height==568||result.height==375||result.height==414)
    {
        if (_txt_TSIDSet)
        {
            CGRect moveViewUpside = self.ts_Id_View.frame;
            moveViewUpside.origin.y=+0;
            [UIView animateWithDuration:0.3 animations:^{
                self.view.frame=moveViewUpside;
            }];
            
        }
    }
}

-(void)doneWithNumberPad
{
    [_txt_TSIDSet resignFirstResponder];
    
    CGSize result = [[UIScreen mainScreen] bounds].size;
    if (result.height==480||result.height==568||result.height==375||result.height==414)
    {
        if (_txt_TSIDSet)
        {
            CGRect moveViewUpside = self.ts_Id_View.frame;
            moveViewUpside.origin.y=+0;
            [UIView animateWithDuration:0.3 animations:^{
                self.view.frame=moveViewUpside;
            }];
            
        }
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *validation = [_txt_TSIDSet.text stringByReplacingCharactersInRange:range withString:string];
    
    //first, check if the new string is numeric only. If not, return NO;
    NSCharacterSet *characterSet1 = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    if ([validation rangeOfCharacterFromSet:characterSet1].location != NSNotFound)
    {
        return NO;
    }
    
    return [validation doubleValue] < 1000;
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
