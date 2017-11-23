//
//  Cycle_AnalysisViewController.m
//  Falco Flash BLE
//
//  Created by Falco eMotors Pvt. Ltd. on 15/10/2016.
//  Copyright © 2016 Falco eMotors Pvt. Ltd. All rights reserved.
//

#import "Cycle_AnalysisViewController.h"
#import "PowerScreenViewController.h"
#import "UARTPeripheral.h"

double avg_power_display,avgpower,powerRemain,consumed;
NSString *myT;
double value1,btryCty;

bool txtEditFlag=false;

BOOL updateBatteryValueBool=false;

@implementation Cycle_AnalysisViewController


@synthesize txt_voltage;
@synthesize txt_current;
@synthesize txt_whconsuming;
@synthesize txt_whremaining;
@synthesize txt_whmile;
@synthesize txt_temperature;
@synthesize txt_iWatts,lbl_Temp,lbl_WhKm,lbl_iWatts,lbl_Current,lbl_Voltage,lbl_Hallcode,lbl_eDrivedata,lbl_WHConsumed,lbl_WHRemaining,lbl_BatteryCapacity,lbl_Kmrangeremaining;
@synthesize txt_HSensorErr,txt_BatteryCapacity,txt_kmRangeRemaining;
@synthesize swipCycle;

- (void)viewDidLoad
{
    [super viewDidLoad];
    //   [self viewWillAppear:YES];
    // Do any additional setup after loading the view.
    [self showparameter];
    allscreenload=true;
    txt_BatteryCapacity.delegate=self;
    UISwipeGestureRecognizer *swipeRightOrange = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(slideToRightWithGestureRecognizer:)];
    
    swipeRightOrange.direction=UISwipeGestureRecognizerDirectionRight;
    [self.swipCycle addGestureRecognizer:swipeRightOrange];
    batteryStatusFlag=true;
    [self selfCall];
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarButtonItemStylePlain;
    numberToolbar.items = @[[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelNumberPadCycle)],
                            [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                            [[UIBarButtonItem alloc]initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPadCycle)]];
    [numberToolbar sizeToFit];
    
    txt_BatteryCapacity.inputAccessoryView = numberToolbar;
    
 
    
    UITextField *textfield;
    [textfield addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    // 
    
    txt_voltage.delegate=self;
    
    
    [self showBatteryCapacity];
    [self adjustFontSizeOfLabel];
    [self SetupUI];
    
    
    
}


- (void)textFieldDidChange:(UITextField *)textField
{
    
    NSLog( @"text changed: %@", myT);
    txt_BatteryCapacity.text=myT;
    
}



-(void)SetupUI
{
    _view1.layer.borderWidth = 1;
    _view1.layer.borderColor = [[UIColor blackColor] CGColor];
    
    _view2.layer.borderWidth = 1;
    _view2.layer.borderColor = [[UIColor blackColor] CGColor];
    
    _view3.layer.borderWidth = 1;
    _view3.layer.borderColor = [[UIColor blackColor] CGColor];
    
    _view4.layer.borderWidth = 1;
    _view4.layer.borderColor = [[UIColor blackColor] CGColor];
    
    _view5.layer.borderWidth = 1;
    _view5.layer.borderColor = [[UIColor blackColor] CGColor];
    
    _view6.layer.borderWidth = 1;
    _view6.layer.borderColor = [[UIColor blackColor] CGColor];
    
    _view7.layer.borderWidth = 1;
    _view7.layer.borderColor = [[UIColor blackColor] CGColor];
    
    _view8.layer.borderWidth = 1;
    _view8.layer.borderColor = [[UIColor blackColor] CGColor];
    
    _view9.layer.borderWidth = 1;
    _view9.layer.borderColor = [[UIColor blackColor] CGColor];
    
    _view10.layer.borderWidth = 1;
    _view10.layer.borderColor = [[UIColor blackColor] CGColor];
}

-(void)selfCall
{
    if (receptionStartFlag==true)
    {
        _wirelessImg.hidden=false;
        countclose=0;
    }
    
    if (receptionStartFlag==false)
    {
        _wirelessImg.hidden=true;
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
-(void)slideToRightWithGestureRecognizer:(UISwipeGestureRecognizer *)gestureRecognizer{
    [UIView animateWithDuration:0.5 animations:^{
        
        [self dismissViewControllerAnimated:NO completion:Nil];
     
        
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
 
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    txtEditFlag=true;
    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [txt_BatteryCapacity resignFirstResponder];
    txt_BatteryCapacity.text=myT;
    [self.txt_BatteryCapacity setNeedsDisplay];
    return YES;
}

-(void)cancelNumberPadCycle
{
    [txt_BatteryCapacity resignFirstResponder];
}

-(void)doneWithNumberPadCycle
{
    [txt_BatteryCapacity resignFirstResponder];
    
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    
    NSString *validation = [txt_BatteryCapacity.text stringByReplacingCharactersInRange:range withString:string];
    
    //first, check if the new string is numeric only. If not, return NO;
    NSCharacterSet *characterSet1 = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    if ([validation rangeOfCharacterFromSet:characterSet1].location != NSNotFound)
    {
        return NO;
    }
    
    return [validation doubleValue] < 10000;
}

-(void)showBatteryCapacity //user enterred value
{
    if(batteryvalue==1)
    {
        value1=400;
    }
    
    else if (batteryvalue==2)
    {
        if (batteryCapacityFlag ==true)
        {
            value1=500;
        }
        else
        {
            value1=670;
        }
    }
    
    
    if (batteryvalue==1)
    {
        if (voltageDec <= 29)
        {
            targetpower = 0;
        }
        else if (voltageDec > 29 && voltageDec <= 35)
        {
            targetpower = value1*(float)0.2;
        }
        else  if (voltageDec == 36)
        {
            targetpower = value1*(float)0.4;
        }
        else if (voltageDec == 37 || voltageDec == 38 )
        {
            targetpower = value1*(float)0.6;
        }
        else if (voltageDec == 39)
        {
            targetpower = value1*(float)0.8;
        }
        else if (voltageDec > 39 )
        {
            targetpower = value1;
        }
        
        
    }
    else if (batteryvalue==2)
    {
        if (voltageDec <= 38)
        {
            targetpower = 0;
        }
        else if (voltageDec <= 46)
        {
            targetpower = (float)value1*(float)0.2;
        }
        else if (voltageDec == 47)
        {
            targetpower = value1*(float)0.4;
        }
        else if (voltageDec == 48)
        {
            targetpower = value1*(float)0.6;
        }
        else if (voltageDec <= 51)
        {
            targetpower = value1 *(float)0.8;
        }
        else if (voltageDec > 51 && voltageDec <= 55)
        {
            targetpower = value1;
        }
    }
    
    myT = [NSString stringWithFormat:@"%.f",targetpower];
    txt_BatteryCapacity.text=myT;
    
    
    if (value1==0)
    {
        txt_whremaining.text=@"0";
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          updateBatteryValueBool=true;
                                          
                                          myT = [NSString stringWithFormat:@"%.f",targetpower];
                                          
                                          
                                          txt_BatteryCapacity.text=myT;
                                          
                                      });
                   });
    
    txt_whremaining.text=[NSString stringWithFormat:@"%.1f",powerRemain];
    
    
    txt_whconsuming.text=[NSString stringWithFormat:@"%.1f", avg_power_display];
    
    if(mphStateFlag==true)
    {
        txt_whmile.text=[NSString stringWithFormat:@"%.1f",whpkm];
        
        txt_kmRangeRemaining.text=[NSString stringWithFormat:@"%.1f",whremain];
        
    }
    if (kphStateFlag==true)
    {
        txt_whmile.text=[NSString stringWithFormat:@"%.1f",whpmile];
        txt_kmRangeRemaining.text=[NSString stringWithFormat:@"%.1f",whremainForMile];
    }
    
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(showBatteryCapacity) userInfo:nil repeats:NO];
}



-(void)showparameter
{
    
    if (current>=50)
    {
        current=50;
    }
    
    if (current<=50)
    {
        txt_current.text= [NSString stringWithFormat:@"%d",current];
    }
    txt_iWatts.text = [NSString stringWithFormat:@"%d",power];
    
    if( mphStateFlag==true)
    {
        
        lbl_WhKm.text=@"Wh/Km";
        lbl_Kmrangeremaining.text=@"KM Range Remaining";
    }
    if (kphStateFlag==true)
    {
        lbl_WhKm.text=@"Wh/Mile";
        lbl_Kmrangeremaining.text=@"Miles Range Remaining";
    }
    
    if (current>=50)
    {
        current=50;
    }
    
    //appending voltage
    
    NSMutableString  *selectVoltage=[NSString stringWithFormat:@"%d",voltageDec];
    NSString *untVolt=@"V";
    NSString *newStringVolt = [NSString stringWithFormat:@"%@%@", selectVoltage,untVolt];
    
    txt_voltage.text = newStringVolt;
    
    //end
    
    if (current<=50)
    {
        //appending current
        NSMutableString  *selectCurrent=[NSString stringWithFormat:@"%d",current];
        NSString *untCur=@"A";
        NSString *newStringCur = [NSString stringWithFormat:@"%@%@", selectCurrent,untCur];
        txt_current.text = newStringCur;
    }
    txt_temperature.text = [NSString stringWithFormat:@"%d",temperature];
    txt_HSensorErr.text = [NSString stringWithFormat:@"%d",hallcode];
    [NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(repetMethod) userInfo:nil repeats:NO];
}


-(void)repetMethod
{
    [self showparameter];
}


-(void)adjustFontSizeOfLabel
{
    
    CGRect screenSize = [[UIScreen mainScreen]bounds];
    
    if (screenSize.size.height <= 480)
    {
        
        // iPhone 4
        
    }
    else if (screenSize.size.height <= 568)
    {
        // IPhone 5/5s/5c
        
        self.lbl_Voltage.font=[self.lbl_Voltage.font fontWithSize:16];
        self.lbl_Current.font=[self.lbl_Current.font fontWithSize:16];
        self.lbl_WHConsumed.font=[self.lbl_WHConsumed.font fontWithSize:16];
        self.lbl_WHRemaining.font=[self.lbl_WHRemaining.font fontWithSize:16];
        self.lbl_WhKm.font=[self.lbl_WhKm.font fontWithSize:16];
        self.lbl_Temp.font=[self.lbl_Temp.font fontWithSize:16];
        self.lbl_Hallcode.font=[self.lbl_Hallcode.font fontWithSize:16];
        self.lbl_iWatts.font=[self.lbl_iWatts.font fontWithSize:16];
        self.lbl_BatteryCapacity.font=[self.lbl_BatteryCapacity.font fontWithSize:16];
        self.lbl_Kmrangeremaining.font=[self.lbl_Kmrangeremaining.font fontWithSize:16];
        self.lbl_eDrivedata.font=[self.lbl_eDrivedata.font fontWithSize:28];
        
        //Textfields
        self.txt_voltage.font=[self.txt_voltage.font fontWithSize:40];
        self.txt_current.font=[self.txt_current.font fontWithSize:40];
        self.txt_whconsuming.font=[self.txt_whconsuming.font fontWithSize:40];
        self.txt_whremaining.font=[self.txt_whremaining.font fontWithSize:40];
        self.txt_whmile.font=[self.txt_whmile.font fontWithSize:40];
        self.txt_temperature.font=[self.txt_temperature.font fontWithSize:40];
        self.txt_HSensorErr.font=[self.txt_HSensorErr.font fontWithSize:40];
        self.txt_kmRangeRemaining.font=[self.txt_kmRangeRemaining.font fontWithSize:40];
        self.txt_BatteryCapacity.font=[self.txt_BatteryCapacity.font fontWithSize:40];
        self.txt_iWatts.font=[self.txt_iWatts.font fontWithSize:40];
        
        
        
    }
    else if (screenSize.size.width <= 375)
    {
        // iPhone 6
        
        _view1.frame=CGRectMake(0, 108, 188, 100);
        self.txt_voltage.frame=CGRectMake(0, 10, 188, 58);
        self.lbl_Voltage.frame=CGRectMake(0, 60, 188, 26);
        _view2.frame=CGRectMake(188, 108, 187, 100);
        self.txt_current.frame=CGRectMake(0, 10, 187, 58);
        self.lbl_Current.frame=CGRectMake(0, 60, 187, 26);
        _view3.frame=CGRectMake(0, 208, 188, 100);
        self.txt_BatteryCapacity.frame=CGRectMake(0, 10, 188, 58);
        self.lbl_BatteryCapacity.frame=CGRectMake(0, 60, 188, 26);
        _view4.frame=CGRectMake(188, 208, 187, 100);
        self.txt_iWatts.frame=CGRectMake(0, 10, 187, 58);
        self.lbl_iWatts.frame=CGRectMake(0, 60, 187, 26);
        _view5.frame=CGRectMake(0, 308, 188, 100);
        self.txt_whconsuming.frame=CGRectMake(0, 10, 188, 58);
        self.lbl_WHConsumed.frame=CGRectMake(0, 60, 188, 26);
        _view6.frame=CGRectMake(188, 308, 187, 100);
        self.txt_whremaining.frame=CGRectMake(0, 10, 187, 58);
        self.lbl_WHRemaining.frame=CGRectMake(0, 60, 187, 26);
        _view7.frame=CGRectMake(0, 408, 188, 100);
        self.txt_whmile.frame=CGRectMake(0, 10, 188, 58);
        self.lbl_WhKm.frame=CGRectMake(0, 60, 188, 26);
        _view8.frame=CGRectMake(188, 408, 187, 100);
        self.txt_kmRangeRemaining.frame=CGRectMake(0, 10, 187, 58);
        self.lbl_Kmrangeremaining.frame=CGRectMake(0, 60, 187, 26);
        _view9.frame=CGRectMake(0, 508, 188, 100);
        self.txt_temperature.frame=CGRectMake(0, 10, 188, 58);
        self.lbl_Temp.frame=CGRectMake(0, 60, 188, 26);
        _view10.frame=CGRectMake(188, 508, 187, 100);
        self.txt_HSensorErr.frame=CGRectMake(0, 10, 187, 58);
        self.lbl_Hallcode.frame=CGRectMake(0, 60, 187, 26);
        
        
        self.lbl_Voltage.font=[self.lbl_Voltage.font fontWithSize:17];
        self.lbl_Current.font=[self.lbl_Current.font fontWithSize:17];
        self.lbl_WHConsumed.font=[self.lbl_WHConsumed.font fontWithSize:17];
        self.lbl_WHRemaining.font=[self.lbl_WHRemaining.font fontWithSize:17];
        self.lbl_WhKm.font=[self.lbl_WhKm.font fontWithSize:17];
        self.lbl_Temp.font=[self.lbl_Temp.font fontWithSize:17];
        self.lbl_Hallcode.font=[self.lbl_Hallcode.font fontWithSize:17];
        self.lbl_Kmrangeremaining.font=[self.lbl_Kmrangeremaining.font fontWithSize:17];
        self.lbl_eDrivedata.font=[self.lbl_eDrivedata.font fontWithSize:34];
        self.lbl_iWatts.font=[self.lbl_iWatts.font fontWithSize:17];
        self.lbl_BatteryCapacity.font=[self.lbl_BatteryCapacity.font fontWithSize:17];
        
        //Textfields
        self.txt_voltage.font=[self.txt_voltage.font fontWithSize:42];
        self.txt_current.font=[self.txt_current.font fontWithSize:42];
        self.txt_whconsuming.font=[self.txt_whconsuming.font fontWithSize:42];
        self.txt_whremaining.font=[self.txt_whremaining.font fontWithSize:42];
        self.txt_whmile.font=[self.txt_whmile.font fontWithSize:42];
        self.txt_temperature.font=[self.txt_temperature.font fontWithSize:42];
        self.txt_HSensorErr.font=[self.txt_HSensorErr.font fontWithSize:42];
        self.txt_kmRangeRemaining.font=[self.txt_kmRangeRemaining.font fontWithSize:42];
        self.txt_BatteryCapacity.font=[self.txt_BatteryCapacity.font fontWithSize:42];
        self.txt_iWatts.font=[self.txt_iWatts.font fontWithSize:42];
        
        
        
    }
    else if (screenSize.size.width <= 414)
    {
        // iPhone 6+
        
        _view1.frame=CGRectMake(0, 108, 210, 100);
        self.txt_voltage.frame=CGRectMake(0, 10, 210, 58);
        self.lbl_Voltage.frame=CGRectMake(0, 60, 210, 26);
        _view2.frame=CGRectMake(210, 108, 204, 100);
        self.txt_current.frame=CGRectMake(0, 10, 204, 58);
        self.lbl_Current.frame=CGRectMake(0, 60, 210, 26);
        _view3.frame=CGRectMake(0, 208, 210, 100);
        self.txt_BatteryCapacity.frame=CGRectMake(0, 10, 210, 58);
        self.lbl_BatteryCapacity.frame=CGRectMake(0, 60, 210, 26);
        _view4.frame=CGRectMake(210, 208, 210, 100);
        self.txt_iWatts.frame=CGRectMake(0, 10, 204, 58);
        self.lbl_iWatts.frame=CGRectMake(0, 60, 210, 26);
        _view5.frame=CGRectMake(0, 308, 210, 100);
        self.txt_whconsuming.frame=CGRectMake(0, 10, 210, 58);
        self.lbl_WHConsumed.frame=CGRectMake(0, 60, 210, 26);
        _view6.frame=CGRectMake(210, 308, 210, 100);
        self.txt_whremaining.frame=CGRectMake(0, 10, 204, 58);
        self.lbl_WHRemaining.frame=CGRectMake(0, 60, 210, 26);
        _view7.frame=CGRectMake(0, 408, 210, 100);
        self.txt_whmile.frame=CGRectMake(0, 10, 210, 58);
        self.lbl_WhKm.frame=CGRectMake(0, 60, 210, 26);
        _view8.frame=CGRectMake(210, 408, 210, 100);
        self.txt_kmRangeRemaining.frame=CGRectMake(0, 10, 204, 58);
        self.lbl_Kmrangeremaining.frame=CGRectMake(0, 60, 210, 26);
        _view9.frame=CGRectMake(0, 508, 210, 100);
        self.txt_temperature.frame=CGRectMake(0, 10, 210, 58);
        self.lbl_Temp.frame=CGRectMake(0, 60, 210, 26);
        _view10.frame=CGRectMake(210, 508, 210, 100);
        self.txt_HSensorErr.frame=CGRectMake(0, 10, 204, 58);
        self.lbl_Hallcode.frame=CGRectMake(0, 60, 210, 26);
        
        self.lbl_Voltage.font=[self.lbl_Voltage.font fontWithSize:17];
        self.lbl_Current.font=[self.lbl_Current.font fontWithSize:17];
        self.lbl_WHConsumed.font=[self.lbl_WHConsumed.font fontWithSize:17];
        self.lbl_WHRemaining.font=[self.lbl_WHRemaining.font fontWithSize:17];
        self.lbl_WhKm.font=[self.lbl_WhKm.font fontWithSize:17];
        self.lbl_Temp.font=[self.lbl_Temp.font fontWithSize:17];
        self.lbl_Hallcode.font=[self.lbl_Hallcode.font fontWithSize:17];
        self.lbl_Kmrangeremaining.font=[self.lbl_Kmrangeremaining.font fontWithSize:17];
        self.lbl_iWatts.font=[self.lbl_iWatts.font fontWithSize:17];
        self.lbl_BatteryCapacity.font=[self.lbl_BatteryCapacity.font fontWithSize:17];
        
        //Textfields
        self.txt_voltage.font=[self.txt_voltage.font fontWithSize:50];
        self.txt_current.font=[self.txt_current.font fontWithSize:50];
        self.txt_whconsuming.font=[self.txt_whconsuming.font fontWithSize:50];
        self.txt_whremaining.font=[self.txt_whremaining.font fontWithSize:50];
        self.txt_whmile.font=[self.txt_whmile.font fontWithSize:50];
        self.txt_temperature.font=[self.txt_temperature.font fontWithSize:50];
        self.txt_HSensorErr.font=[self.txt_HSensorErr.font fontWithSize:55];
        self.txt_kmRangeRemaining.font=[self.txt_kmRangeRemaining.font fontWithSize:50];
        self.txt_BatteryCapacity.font=[self.txt_BatteryCapacity.font fontWithSize:50];
        self.txt_iWatts.font=[self.txt_iWatts.font fontWithSize:50];
        
    }
    
}


@end
