//
//  TorqueMotorParameterViewController.m
//  Falco Flash BLE
//
//  Created by Falco eMotors Pvt. Ltd. on 15/10/2016.
//  Copyright © 2016 Falco eMotors Pvt. Ltd. All rights reserved.
//

#import "TorqueMotorParameterViewController.h"




NSString *TorqueRaw;
NSString *TorqueRectified;
NSString *TorquePeak;
NSString *TorqueFinal;
NSString *str3,*str2,*str1,*str4;

@interface TorqueMotorParameterViewController ()
@property UARTPeripheral *currentPeripheral;

@end

@implementation TorqueMotorParameterViewController
@synthesize currentPeripheral=_currentPeripheral;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (TSRaw<=590&&TSRaw>=350)
    {
        str4 = [[NSNumber numberWithInt:TSRawDecimal]stringValue];
        
        if (TSRectifiedDecimal<40)
        {
            str1 = [[NSNumber numberWithInt:TSRectifiedDecimal]stringValue];
        }
        
        if (TSPeakDecimal<40)
        {
            TSPeakDecimal=0;
            str2 = [[NSNumber numberWithInt:TSPeakDecimal]stringValue];
        }
        
        if (TSFinalDecimal<40)
        {
            str3 = [[NSNumber numberWithInt:TSFinalDecimal]stringValue];
            
        }
        
        _TSRawText.text = str4;
        _TSRectiLable.text = str1;
        _TSPeakText.text = str2;
        _TSFinalText.text = str3;
        
    }
    
    UISwipeGestureRecognizer *swipeRightOrange = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(slideToRightWithGestureRecognizer:)];
    swipeRightOrange.direction=UISwipeGestureRecognizerDirectionRight;
    [self.torqueView addGestureRecognizer:swipeRightOrange];
    
    [self adjustFontSizeOfLabel];
    // Do any additional setup after loading the view.
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    screen_load=true;
    
    [self selfCall];
    
    if (myperipheral)
    {
        //  [tscm connectPeripheral:myperipheral options:nil];
    }
    
}
- (void) centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSString *message = @"Communication started";
    
    UIAlertController *alert1 = [UIAlertController alertControllerWithTitle:nil
                                                                    message:message
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


-(void)viewWillDisappear:(BOOL)animated
{
    if (myperipheral)
    {
        
        screen_load=false;
        
    }
    
}
- (void)disconnect:(CBPeripheral *)device
{
    // Unsubscribes from all the characteristics in services
    for (CBService *service in device.services) {
        for (CBCharacteristic *characteristic in service.characteristics)
            [device setNotifyValue:NO forCharacteristic:characteristic];
    }
}

- (void) centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"Did disconnect peripheral %@", peripheral.name);
    
    NSString *message = @"Communication closed";
    receptionFlag=false;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    int duration = 2; // duration in seconds
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [alert dismissViewControllerAnimated:YES completion:nil];
    });
    
    
    self.state = IDLE;
    
    if ([self.currentPeripheral.peripheral isEqual:peripheral])
    {
        [self.currentPeripheral didDisconnect];
    }
}



-(void)slideToRightWithGestureRecognizer:(UISwipeGestureRecognizer *)gestureRecognizer{
    [UIView animateWithDuration:0.5 animations:^{
        
        //        [[self presentingViewController] dismissViewControllerAnimated:NO completion:nil];
        [self dismissViewControllerAnimated:NO completion:Nil];
        
        NSLog(@"My peripheral=%@",myperipheral.name);
        
        //        [self performSegueWithIdentifier:@"ShowVerify" sender:self];
        
    }];
}
-(void)selfCall
{
    if (receptionStartFlag==true)
    {
        _wireless6image.hidden=false;
        countclose=0;
    }
    if (tsreceptionflag==true)
    {
        _ts_image.hidden=false;
        tscountclose=0;
        if (tsDataFlag==true)
        {
            if (TSRaw<=590&&TSRaw>=350)
            {
                
                NSLog(@"IN TS State==%u",self.state);
                str4 = [[NSNumber numberWithInt:TSRawDecimal]stringValue];
                
                if (TSRectifiedDecimal<40)
                {
                    str1 = [[NSNumber numberWithInt:TSRectifiedDecimal]stringValue];
                }
                
                if (TSPeakDecimal<40)
                {
                    str2 = [[NSNumber numberWithInt:TSPeakDecimal]stringValue];
                    
                }
                
                if (TSFinalDecimal<40)
                {
                    str3 = [[NSNumber numberWithInt:TSFinalDecimal]stringValue];
                    
                }
                _TSRawText.text = str4;
                _TSRectiLable.text = str1;
                _TSPeakText.text = str2;
                _TSFinalText.text = str3;
                
            }
        }
    }
    
    if (receptionStartFlag==false)
    {
        _wireless6image.hidden=true;
        tscountclose++;
        _ts_image.hidden=true;
        if (tscountclose==1)
        {
            //            NSString *message = @"Communication closed";
            //
            //            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
            //                                                                           message:message
            //                                                                    preferredStyle:UIAlertControllerStyleActionSheet];
            //
            //            [self presentViewController:alert animated:YES completion:nil];
            //
            //            int duration = 1; // duration in seconds
            //
            //            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            //                [alert dismissViewControllerAnimated:YES completion:nil];
            //            });
            
        }
        
        
        
        
        countclose++;
        
    }
    //  screen_load=true;
    if (screen_load==true) {
        [self performSelector:@selector(selfCall) withObject:nil afterDelay:0.1];
        
    }
    
    //[self selfCall];
}




-(void)adjustFontSizeOfLabel{
    
    CGRect screenSize = [[UIScreen mainScreen]bounds];
    
    if (screenSize.size.height <= 480) {
        // iPhone 4
        
    } else if (screenSize.size.height <= 568) {
        // IPhone 5/5s/5c
        self.lbl_TSRaw.font = [self.lbl_TSRaw.font fontWithSize:20];
        self.lbl_TSPeak.font = [self.lbl_TSPeak.font fontWithSize:20];
        self.lbl_TSFinal.font = [self.lbl_TSFinal.font fontWithSize:20];
        self.lbl_TSRectified.font = [self.lbl_TSRectified.font fontWithSize:20];
        self.lbl_MotorParameter.font=[self.lbl_MotorParameter.font fontWithSize:28];
        
        self.TSRawText.font=[self.TSRawText.font fontWithSize:45];
        self.TSPeakText.font=[self.TSPeakText.font fontWithSize:45];
        self.TSFinalText.font=[self.TSFinalText.font fontWithSize:45];
        self.TSRectiLable.font=[self.TSRectiLable.font fontWithSize:45];
        
        
        
    } else if (screenSize.size.width <= 375) {
        // iPhone 6
        self.lbl_TSRaw.font = [self.lbl_TSRaw.font fontWithSize:23];
        self.lbl_TSPeak.font = [self.lbl_TSPeak.font fontWithSize:23];
        self.lbl_TSFinal.font = [self.lbl_TSFinal.font fontWithSize:23];
        self.lbl_TSRectified.font = [self.lbl_TSRectified.font fontWithSize:23];
        self.lbl_MotorParameter.font=[self.lbl_MotorParameter.font fontWithSize:32];
        
        self.TSRawText.font=[self.TSRawText.font fontWithSize:49];
        self.TSPeakText.font=[self.TSPeakText.font fontWithSize:49];
        self.TSFinalText.font=[self.TSFinalText.font fontWithSize:49];
        self.TSRectiLable.font=[self.TSRectiLable.font fontWithSize:49];
        
        
    } else if (screenSize.size.width <= 414) {
        // iPhone 6+
        self.lbl_TSRaw.font = [self.lbl_TSRaw.font fontWithSize:28];
        self.lbl_TSPeak.font = [self.lbl_TSPeak.font fontWithSize:28];
        self.lbl_TSFinal.font = [self.lbl_TSFinal.font fontWithSize:28];
        self.lbl_TSRectified.font = [self.lbl_TSRectified.font fontWithSize:28];
        self.lbl_MotorParameter.font=[self.lbl_MotorParameter.font fontWithSize:36];
        
        self.TSRawText.font=[self.TSRawText.font fontWithSize:52];
        self.TSPeakText.font=[self.TSPeakText.font fontWithSize:52];
        self.TSFinalText.font=[self.TSFinalText.font fontWithSize:52];
        self.TSRectiLable.font=[self.TSRectiLable.font fontWithSize:52];
        
    }}





@end
