//
//  ON_OFF_RoadScreenViewController.m
//  Falco Flash BLE
//
//  Created by Falco eMotors Pvt. Ltd. on 15/10/2016.
//  Copyright © 2016 Falco eMotors Pvt. Ltd. All rights reserved.
//

#import "ON_OFF_RoadScreenViewController.h"
#import "UARTPeripheral.h"

int offClickCount;
@interface ON_OFF_RoadScreenViewController ()

@end
BOOL lockStatus=true;

@implementation ON_OFF_RoadScreenViewController
//@synthesize backgroundTxt;




@synthesize   lockLabel,unLockLabel;
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self displayWingsMethod];
    allscreenload=true;

    if (offroadscreenStatus==false)
    {
        UIImage *btnImage = [UIImage imageNamed:@"Icon-53"];
        [_imgButton_Unlock setImage:btnImage forState:UIControlStateNormal];
        
        unLockLabel.text=@"Locked";
        
    }
    if (offroadscreenStatus==true)
    {
        UIImage *btnImage = [UIImage imageNamed:@"Icon-108"];
        [_imgButton_Unlock setImage:btnImage forState:UIControlStateNormal];
        unLockLabel.text=@"Unlocked";
        
    }
    
    [self selfCall];
    
    UISwipeGestureRecognizer *swipeRightOrange = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(slideToRightWithGestureRecognizer:)];
    
    swipeRightOrange.direction=UISwipeGestureRecognizerDirectionRight;
    [self.myView1 addGestureRecognizer:swipeRightOrange];
    
    [self adjustFontSizeOfLabel];
    
    
}

-(void)selfCall
{
    if (receptionStartFlag==true)
    {
        _wireless4image.hidden=false;
        countclose=0;
    }
    [self displayWingsMethod];
    
    if (receptionStartFlag==false)
    {
        _wireless4image.hidden=true;
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

-(void)slideToRightWithGestureRecognizer:(UISwipeGestureRecognizer *)gestureRecognizer{
    [UIView animateWithDuration:0.5 animations:^{
        
        [self dismissViewControllerAnimated:NO completion:Nil];
        
        NSLog(@"HIIIIIIIIIIIIIIII OFF ROAD");
        
      
        
    }];
}
-(void)slideToLeftWithGestureRecognizer:(UISwipeGestureRecognizer *)gestureRecognizer{
    [UIView animateWithDuration:0.5 animations:
     ^{
        
        NSLog(@"HIIIIIIIIIIIIIIII OFF ROAD LEFT");
        
    }];
}


- (IBAction)unLockedButton:(id)sender
{
    if (receptionStartFlag==true)
    {
        
        offClickCount++;
        if (offClickCount%2==0)
        {
            
            
            //  OffRoadStatus=true;
            
            UIImage *btnImage = [UIImage imageNamed:@"Icon-108"];
            [_imgButton_Unlock setImage:btnImage forState:UIControlStateNormal];
            unLockLabel.text=@"Unlocked";
            
            offroadscreenStatus=true;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1

            
            int8_t bytes2[] ={103,01,00,00,00,00,00,00,00,00,00,00,00};
            
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
            
            });
            
            
        }
        else
        {
            //   OnRoadStatus=true;
       
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1

            int8_t bytes2[] ={103,00,00,00,00,00,00,00,00,00,00,00,00};
            
            
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
            
            
            });
            UIImage *btnImage = [UIImage imageNamed:@"Icon-53"];
            [_imgButton_Unlock setImage:btnImage forState:UIControlStateNormal];
            
            unLockLabel.text=@"Locked";
            offroadscreenStatus=false;
            
            
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
            else if (voltageDec > 29 && voltageDec <=35) {
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
        {
                
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
-(void)adjustFontSizeOfLabel{
    
    CGRect screenSize = [[UIScreen mainScreen]bounds];
    
    if (screenSize.size.height <= 480) {
        // iPhone 4
        self.unLockLabel.font = [self.unLockLabel.font fontWithSize:25];
        
    } else if (screenSize.size.height <= 568) {
        // IPhone 5/5s/5c
        self.unLockLabel.font = [self.unLockLabel.font fontWithSize:27];
        
    } else if (screenSize.size.width <= 375) {
        // iPhone 6
        self.unLockLabel.font = [self.unLockLabel.font fontWithSize:32];
        
        
    } else if (screenSize.size.width <= 414) {
        // iPhone 6+
        self.unLockLabel.font = [self.unLockLabel.font fontWithSize:37];
        _imgButton_Unlock.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
        _imgButton_Unlock.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
        
    }
}

@end
