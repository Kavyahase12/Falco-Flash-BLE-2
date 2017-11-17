//
//  PowerControlViewController.m
//  Falco Flash BLE
//
//  Created by Falco eMotors Pvt. Ltd. on 15/10/2016.
//  Copyright © 2016 Falco eMotors Pvt. Ltd. All rights reserved.
//

#import "PowerControlViewController.h"
#import "UARTPeripheral.h"

NSInteger clampCurrentValues []= {1, 3, 4, 5, 6, 8, 10, 12, 14, 16, 18, 20, 23, 23}; // default current clamp values & also used to add current clamps of 250,500,750,1000w

NSInteger sliderValue1,sliderValue2,sliderValue3,sliderValue4,sliderValue5,sliderValue6;
NSInteger slidevalue=0,slidevalue1=0,slidevalue2=0,slidevalue3=0,slidevalue4=0;
NSInteger assist_Amount,assist_Amount1,assist_Amount2,assist_Amount3,assist_Amount4,assist_Amount5;
NSInteger assist_value1,assist_value2,assist_value3,assist_value4,assist_value5;
NSInteger indexInteger,assistIndexInteger;
NSInteger level,level1;

NSString *num1,*num2,*num3,*num4,*num5,*num6,*num7,*num8,*num9,*num10,*num11;
NSString *number1,*number2,*number3,*number4,*number5,*number6;
NSString *numberReg1,*numberReg2,*numberReg3,*numberReg4,*numberReg5;
NSString *strVal1,*strVal2,*strVal3,*strVal4,*strVal5,*strVal6;
NSString *YourselectedTitle;
BOOL motorSelectFlag;
NSArray *clamp500WATTHSW,*texts,*clamp250WATTHSW,*clamp750WATTHSW,*clamp750WATTSSW,*clamp1000WATTHSW,*clamp1000WATTSSW,*clamp750WATTPLUS;
CGFloat    sliderValue21,  sliderValue22;
bool firmstate1,firmstate2,firmstate3,firmstate4,btrySelectFlag;


UISlider *sldier1;
int slide1,slide2,slide3,slide4,slide5,slide6;

Byte  assist_txt_val1,assist_txt_val2,assist_txt_val3,assist_txt_val4,assist_txt_val5,assist_txt_val6;
Byte txt_val1,txt_val2,txt_val3,txt_val4,txt_val5;


int i=0;
int ind1=0,ind2=0,ind3=0,ind4=0,ind5=0,ind6=0;
int indre1=0,indre2=0,indre3=0,indre4=0,indre5=0,indre6=0;
int indOne1,indTwo2,indThree3,indFour4,indFive5,indSix6;
int choice,assist_Choice;
int L1=0,L2=0,L3=0,L4=0,L5=0,T=0;
int R1=0,R2=0,R3=0,R4=0,R5=0;


UIActivityIndicatorView *activityIndicator;

BOOL sliderOneBool,sliderTwoBool,skiderThreeBool,sliderFourBool,sliderFiveBool,sliderSixBool=false;


int assistString1,assistString2,assistString3,assistString4,assistString5,assistStringT,regenString1,regenString2,regenString3,regenString4,regenString5;




@interface PowerControlViewController ()

@property UARTPeripheral *currentPeripheral;

@end

@implementation PowerControlViewController

@synthesize  val1,val2,val3,val4,val5,val6;
@synthesize txt_1,txt_2,txt_3,txt_4,txt_5,txt_6;
@synthesize currentPeripheral=_currentPeripheral;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _btn_Restorecurrentclamp.layer.borderWidth=1.0;
    _btn_Restorecurrentclamp.layer.borderColor=[UIColor blackColor].CGColor;
    allscreenload=true;
    
    _btn_MemoryRead.layer.borderWidth=1.0;
    _btn_MemoryRead.layer.borderColor=[UIColor blackColor].CGColor;
    
    _btn_Broadcast.layer.borderWidth=1.0;
    _btn_Broadcast.layer.borderColor=[UIColor blackColor].CGColor;
    
    _motorTypeTextfield.lineBreakMode=NSLineBreakByClipping;
    _motorTypeTextfield.numberOfLines=0;
    
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.transform = CGAffineTransformMakeScale(2.5, 2.5);
    activityIndicator.color=[UIColor blackColor];
    activityIndicator.alpha = 1.0;
    [_powerView addSubview:activityIndicator];
    activityIndicator.center = CGPointMake([[UIScreen mainScreen]bounds].size.width/2, [[UIScreen mainScreen]bounds].size.height/2);
    
    UISwipeGestureRecognizer *swipeRightOrange = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(slideToRightWithGestureRecognizer:)];
    swipeRightOrange.direction=UISwipeGestureRecognizerDirectionRight;
    [self.powerView addGestureRecognizer:swipeRightOrange];
    
    
    UISwipeGestureRecognizer *swipeLeftOrange = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(slideToLeftWithGestureRecognizer:)];
    swipeLeftOrange.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.powerView addGestureRecognizer:swipeLeftOrange];
    
    
    [self adjustFontSizeOfLabel];
    
    
    
    [_segmentCurrentClamp setSelectedSegmentIndex:swipecount];
    
    if (receptionStartFlag==true)//
    {
        _wireless8image.hidden=false;
        [self selfCall];
        firmwareTransmitFlag=true;
        if (batteryvalue==1)
        {
            _txt_BatterySelect.text=@"36";
            self.txt_BatterySelect.backgroundColor = [UIColor lightGrayColor];
            // NSLog(@"Battery Values==%d",batteryvalue);
        }
        if (batteryvalue==2)
        {
            _txt_BatterySelect.text=@"48";
            self.txt_BatterySelect.backgroundColor = [UIColor lightGrayColor];
        }
        
    }
    if (motorTypeSelectFlagD==true)
    {
        _motorTypeTextfield.text=motorTypeString;
        _slider1.enabled=true;
        _slider2.enabled=true;
        _slider3.enabled=true;
        _slider4.enabled=true;
        _slider5.enabled=true;
        _slider6.enabled=true;
        
    }
    
    
    
    
    clamp500WATTHSW=[NSArray arrayWithObjects:@"0.5", @"4", @"6", @"8", @"10", @"12", @"14", @"16", @"18", @"20", @"22", @"24", @"26", @"28",nil];
    
    clamp250WATTHSW=[NSArray arrayWithObjects:@"1", @"3", @"4", @"5", @"6", @"8", @"10", @"12", @"14", @"16", @"18", @"20", @"22", @"23",nil];
    
    clamp750WATTHSW=[NSArray arrayWithObjects:@"2", @"3", @"5", @"7", @"8", @"11", @"14", @"17", @"21", @"25", @"28", @"31", @"35", @"40",nil];
    
    clamp750WATTSSW=[NSArray arrayWithObjects:@"3", @"4", @"6", @"8", @"9", @"12", @"15", @"18", @"21", @"25", @"28", @"31", @"35", @"40",nil];
    
    clamp1000WATTHSW=[NSArray arrayWithObjects:@"1", @"2", @"4", @"5", @"6", @"7", @"8", @"10", @"12", @"14", @"17", @"19", @"25", @"28",nil];
    
    clamp1000WATTSSW=[NSArray arrayWithObjects:@"1", @"2", @"4", @"5", @"6", @"7", @"8", @"10", @"12", @"14", @"17", @"19", @"25", @"28",nil];
    
    clamp750WATTPLUS=[NSArray arrayWithObjects:@"2", @"3", @"4", @"7", @"8", @"12", @"14", @"16", @"20", @"24", @"26", @"31", @"35", @"40",nil];
    
    
}

-(void)viewWillAppear:(BOOL)animated

{
    
    switch (segmentValue)
    {
        case 0:
            
            
            swipecount=0;
            
            _lbl_6.hidden=false;
            
            _lbl_1.text=@"Assist Level 1";
            _lbl_2.text=@"Assist Level 2";
            _lbl_3.text=@"Assist Level 3";
            _lbl_4.text=@"Assist Level 4";
            _lbl_5.text=@"Assist Level 5";
            _lbl_6.text=@"Turbo Level";
            
            txt_6.hidden=false;
            _slider6.hidden=false;
            
            self.AssistView.hidden=false;
            self.regenView.hidden=true;
            
            
            txt_1.text=[texts objectAtIndex:ind1];
            txt_2.text=[texts objectAtIndex:ind2];
            txt_3.text=[texts objectAtIndex:ind3];
            txt_4.text=[texts objectAtIndex:ind4];
            txt_5.text=[texts objectAtIndex:ind5];
            txt_6.text=[texts objectAtIndex:ind6];
            
            
            self.slider1.value=(float)ind1;
            self.slider2.value=(float)ind2;
            self.slider3.value=(float)ind3;
            self.slider4.value=(float)ind4;
            self.slider5.value=(float)ind5;
            self.slider6.value=(float)ind6;
            
            
            break;
            
        case 1:
            
            swipecount=1;
            
            _lbl_1.text=@"Regen Level 1";
            _lbl_2.text=@"Regen Level 2";
            _lbl_3.text=@"Regen Level 3";
            _lbl_4.text=@"Regen Level 4";
            _lbl_5.text=@"Regen Level 5";
            
            _lbl_6.hidden=true;
            txt_6.hidden=TRUE;
            _slider6.hidden=true;
            
            self.AssistView.hidden=true;
            self.regenView.hidden=false;
            
            
            
            txt_1.text=[texts objectAtIndex:indre1];
            
            txt_2.text=[texts objectAtIndex:indre2];
            
            txt_3.text=[texts objectAtIndex:indre3];
            
            txt_4.text=[texts objectAtIndex:indre4];
            txt_5.text=[texts objectAtIndex:indre5];
            
            self.slider1.value=(float)indre1;
            self.slider2.value=(float) indre2;
            self.slider3.value=(float)indre3;
            self.slider4.value=(float)indre4;
            self.slider5.value=(float)indre5;
            
            
            break;
            
        default:
            break;
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
        //  [tscm connectPeripheral:myperipheral options:nil];
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



-(void)slideToRightWithGestureRecognizer:(UISwipeGestureRecognizer *)gestureRecognizer{
    [UIView animateWithDuration:0.5 animations:^{
        
        //        [[self presentingViewController] dismissViewControllerAnimated:NO completion:nil];
        [self dismissViewControllerAnimated:NO completion:Nil];
        
        NSLog(@"HIIIIIIIIIIIIIIII pwr");
        
    }];
}

-(void)slideToLeftWithGestureRecognizer:(UISwipeGestureRecognizer *)gestureRecognizer{
    [UIView animateWithDuration:0.5 animations:^{
        
        NSString *message = @"This is last screen";
        
        
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


#pragma slider delegate method

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
    
}

// returns the # of rows in each component............
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    return [pickerData count];
    
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    YourselectedTitle = [ pickerData objectAtIndex:[self.pickerView selectedRowInComponent:0]];
    NSLog(@"%@", YourselectedTitle);
    
    return pickerData[row];
    
    
}

#pragma slider
- (IBAction)onSlider1:(id)sender
{
    
    
    
    sldier1 = (UISlider *)sender;
    sliderValue1=[sldier1 value];
    
    txt_1.text=[texts objectAtIndex:sliderValue1];
    
    
    sliderValue2=[_slider2 value];
    sliderValue3=[_slider3 value];
    sliderValue4=[_slider4 value];
    sliderValue5=[_slider5 value];
    sliderValue6=[_slider6 value];
    
    if(segmentValue==0)
    {
        
        ind1=sliderValue1;
        txt_1.text=[texts objectAtIndex:ind1];
    }
    else
    {
        indre1=sliderValue1;
        txt_1.text=[texts objectAtIndex:indre1];
    }
    
    
    
    if(sliderValue2<sliderValue1)
    {
        [_slider2 setValue:sliderValue1 animated:YES];
        txt_2.text=[texts objectAtIndex:sliderValue1];
        
        if(segmentValue==0)
        {
            ind2=sliderValue1;
            
            txt_2.text=[texts objectAtIndex:ind2];
        }
        else
        {
            indre2=sliderValue1;
            txt_2.text=[texts objectAtIndex:indre2];
            
        }
    }
    
    if(sliderValue3<sliderValue1)
    {
        [_slider3 setValue:sliderValue1 animated:YES];
        txt_3.text=[texts objectAtIndex:sliderValue1];
        
        if(segmentValue==0)
        {
            ind3=sliderValue1;
            txt_3.text=[texts objectAtIndex:ind3];
        }
        else
        {
            indre3=sliderValue1;
            txt_3.text=[texts objectAtIndex:indre3];
            
        }
        
    }
    
    if(sliderValue4<sliderValue1)
    {
        [_slider4 setValue:sliderValue1 animated:YES];
        txt_4.text=[texts objectAtIndex:sliderValue1];
        
        if(segmentValue==0)
        {
            ind4=sliderValue1;
            txt_4.text=[texts objectAtIndex:ind4];
        }
        else
        {
            indre4=sliderValue1;
            txt_4.text=[texts objectAtIndex:indre4];
            
        }
    }
    
    if(sliderValue5<sliderValue1)
    {
        [_slider5 setValue:sliderValue1 animated:YES];
        txt_5.text=[texts objectAtIndex:sliderValue1];
        
        if(segmentValue==0)
        {
            ind5=sliderValue1;
            txt_5.text=[texts objectAtIndex:ind5];
        }
        else
        {
            indre5=sliderValue1;
            txt_5.text=[texts objectAtIndex:indre5];
            
        }
    }
    
    if(sliderValue6<sliderValue1)
    {
        [_slider6 setValue:sliderValue1 animated:YES];
        txt_6.text=[texts objectAtIndex:sliderValue1];
        
        if(segmentValue==0)
        {
            ind6=sliderValue1;
            txt_6.text=[texts objectAtIndex:ind6];
        }
        //        else
        //        {
        //            indre6=sliderValue1;
        //            txt_6.text=[texts objectAtIndex:indre6];
        //
        //        }
    }
    
    
}

- (IBAction)onSlider2:(id)sender
{
    
    UISlider *sldier2 = (UISlider *)sender;
    
    sliderValue2=[sldier2 value];
    
    txt_2.text=[texts objectAtIndex:sliderValue2];
    
    sliderValue1=[_slider1 value];
    sliderValue3=[_slider3 value];
    sliderValue4=[_slider4 value];
    sliderValue5=[_slider5 value];
    sliderValue6=[_slider6 value];
    
    if(segmentValue==0)
    {
        ind2=sliderValue2;
        txt_2.text=[texts objectAtIndex:ind2];
    }
    else
    {
        indre2=sliderValue2;
        txt_2.text=[texts objectAtIndex:indre2];
        
    }
    
    
    if(sliderValue2<sliderValue1)
    {
        [_slider2 setValue:sliderValue1 animated:YES];
        txt_2.text=[texts objectAtIndex:sliderValue1];
        if(segmentValue==0)
        {
            ind2=sliderValue1;
            txt_2.text=[texts objectAtIndex:ind2];
        }
        else
        {
            indre2=sliderValue1;
            txt_2.text=[texts objectAtIndex:indre2];
            
        }
    }
    if(sliderValue3<sliderValue2)
    {
        [_slider3 setValue:sliderValue2 animated:YES];
        txt_3.text=[texts objectAtIndex:sliderValue2];
        if(segmentValue==0)
            
        {
            ind3=sliderValue2;
            txt_3.text=[texts objectAtIndex:ind3];
        }
        else
        {
            indre3=sliderValue2;
            txt_3.text=[texts objectAtIndex:indre3];
            
        }
    }
    
    if(sliderValue4<sliderValue2)
    {
        [_slider4 setValue:sliderValue2 animated:YES];
        txt_4.text=[texts objectAtIndex:sliderValue2];
        
        
        if(segmentValue==0)
        {
            ind4=sliderValue2;
            txt_4.text=[texts objectAtIndex:ind4];
        }
        else
        {
            indre4=sliderValue2;
            txt_4.text=[texts objectAtIndex:indre4];
            
        }
    }
    
    if(sliderValue5<sliderValue2)
    {
        [_slider5 setValue:sliderValue2 animated:YES];
        txt_5.text=[texts objectAtIndex:sliderValue2];
        
        if(segmentValue==0)
        {
            ind5=sliderValue2;
            txt_5.text=[texts objectAtIndex:ind5];
        }
        else
        {
            indre5=sliderValue2;
            txt_5.text=[texts objectAtIndex:indre5];
            
        }
    }
    
    if(sliderValue6<sliderValue2)
    {
        [_slider6 setValue:sliderValue2 animated:YES];
        txt_6.text=[texts objectAtIndex:sliderValue2];
        
        if(segmentValue==0)
        {
            ind6=sliderValue2;
            txt_6.text=[texts objectAtIndex:ind6];
        }
        //        else
        //        {
        //            indre2=sliderValue2;
        //            txt_2.text=[texts objectAtIndex:indre2];
        //
        //        }
    }
    
}

- (IBAction)onSlider3:(id)sender
{
    
    UISlider *sldier3 = (UISlider *)sender;
    
    sliderValue3=[sldier3 value];
    
    txt_3.text=[texts objectAtIndex:sliderValue3];
    
    sliderValue1=[_slider1 value];
    sliderValue2=[_slider2 value];
    sliderValue4=[_slider4 value];
    sliderValue5=[_slider5 value];
    sliderValue6=[_slider6 value];
    
    if(segmentValue==0)
    {
        ind3=sliderValue3;
        txt_3.text=[texts objectAtIndex:ind3];
    }
    else
    {
        indre3=sliderValue3;
        txt_3.text=[texts objectAtIndex:indre3];
        
    }
    
    
    if(sliderValue3<sliderValue2)
    {
        [_slider3 setValue:sliderValue2 animated:YES];
        txt_3.text=[texts objectAtIndex:sliderValue2];
        if(segmentValue==0)
        {
            ind3=sliderValue2;
            txt_3.text=[texts objectAtIndex:ind3];
        }
        else
        {
            indre3=sliderValue2;
            txt_3.text=[texts objectAtIndex:indre3];
            
        }
    }
    if(sliderValue4<sliderValue3)
    {
        [_slider4 setValue:sliderValue3 animated:YES];
        txt_4.text=[texts objectAtIndex:sliderValue3];
        if(segmentValue==0)
        {
            ind4=sliderValue3;
            txt_4.text=[texts objectAtIndex:ind4];
        }
        else
        {
            indre4=sliderValue3;
            txt_4.text=[texts objectAtIndex:indre4];
            
        }
    }
    
    if(sliderValue5<sliderValue3)
    {
        [_slider5 setValue:sliderValue3 animated:YES];
        txt_5.text=[texts objectAtIndex:sliderValue3];
        if(segmentValue==0)
        {
            ind5=sliderValue3;
            txt_5.text=[texts objectAtIndex:ind5];
        }
        else
        {
            indre5=sliderValue3;
            txt_5.text=[texts objectAtIndex:indre5];
            
        }
    }
    
    if(sliderValue6<sliderValue3)
    {
        [_slider6 setValue:sliderValue3 animated:YES];
        txt_6.text=[texts objectAtIndex:sliderValue3];
        if(segmentValue==0)
        {
            ind6=sliderValue3;
            txt_6.text=[texts objectAtIndex:ind6];
        }
        //        else
        //        {
        //            indre3=sliderValue3;
        //            txt_3.text=[texts objectAtIndex:indre3];
        //
        //        }
    }
    
    
}

- (IBAction)onSlider4:(id)sender
{
    UISlider *sldier4 = (UISlider *)sender;
    
    sliderValue4=[sldier4 value];
    
    txt_4.text=[texts objectAtIndex:sliderValue4];
    
    sliderValue1=[_slider1 value];
    sliderValue2=[_slider2 value];
    sliderValue3=[_slider3 value];
    sliderValue5=[_slider5 value];
    sliderValue6=[_slider6 value];
    
    if(segmentValue==0)
    {
        ind4=sliderValue4;
        txt_4.text=[texts objectAtIndex:ind4];
    }
    else
    {
        indre4=sliderValue4;
        txt_4.text=[texts objectAtIndex:indre4];
        
    }
    
    if(sliderValue4<sliderValue3)
    {
        [_slider4 setValue:sliderValue3 animated:YES];
        txt_4.text=[texts objectAtIndex:sliderValue3];
        if(segmentValue==0)
        {
            ind4=sliderValue3;
            txt_4.text=[texts objectAtIndex:ind4];
        }
        else
        {
            indre4=sliderValue3;
            txt_4.text=[texts objectAtIndex:indre4];
            
        }
        
    }
    if(sliderValue5<sliderValue4)
    {
        [_slider5 setValue:sliderValue4 animated:YES];
        txt_5.text=[texts objectAtIndex:sliderValue4];
        if(segmentValue==0)
        {
            ind5=sliderValue4;
            txt_5.text=[texts objectAtIndex:ind5];
        }
        else
        {
            indre5=sliderValue4;
            txt_5.text=[texts objectAtIndex:indre5];
            
        }
    }
    
    if(sliderValue6<sliderValue4)
    {
        [_slider6 setValue:sliderValue4 animated:YES];
        txt_6.text=[texts objectAtIndex:sliderValue4];
        if(segmentValue==0)
        {
            ind6=sliderValue4;
            txt_6.text=[texts objectAtIndex:ind6];
        }
        //        else
        //        {
        //            indre4=sliderValue4;
        //            txt_4.text=[texts objectAtIndex:ind4];
        //
        //        }
    }
    
    
    
}

- (IBAction)onSlider5:(id)sender
{
    
    
    UISlider *sldier5 = (UISlider *)sender;
    
    sliderValue5=[sldier5 value];
    
    txt_5.text=[texts objectAtIndex:sliderValue5];
    
    sliderValue1=[_slider1 value];
    sliderValue2=[_slider2 value];
    sliderValue3=[_slider3 value];
    sliderValue4=[_slider4 value];
    sliderValue6=[_slider6 value];
    
    if(segmentValue==0)
    {
        ind5=sliderValue5;
        txt_5.text=[texts objectAtIndex:ind5];
    }
    else
    {
        indre5=sliderValue5;
        txt_5.text=[texts objectAtIndex:indre5];
        
    }
    
    if(sliderValue5<sliderValue4)
    {
        [_slider5 setValue:sliderValue4 animated:YES];
        txt_5.text=[texts objectAtIndex:sliderValue4];
        
        if(segmentValue==0)
        {
            ind5=sliderValue4;
            txt_5.text=[texts objectAtIndex:ind5];
        }
        else
        {
            indre5=sliderValue4;
            txt_5.text=[texts objectAtIndex:indre5];
            
        }
    }
    if(sliderValue6<sliderValue5)
    {
        [_slider6 setValue:sliderValue5 animated:YES];
        txt_6.text=[texts objectAtIndex:sliderValue5];
        
        if(segmentValue==0)
        {
            ind6=sliderValue5;
            txt_6.text=[texts objectAtIndex:ind6];
        }
        //        else
        //        {
        //            indre5=sliderValue5;
        //            txt_5.text=[texts objectAtIndex:indre5];
        //
        //        }
    }
    
    
}
- (IBAction)onSlider6:(id)sender
{
    
    UISlider *sldier6 = (UISlider *)sender;
    
    sliderValue6=[sldier6 value];
    
    txt_6.text=[texts objectAtIndex:sliderValue6];
    
    sliderValue1=[_slider1 value];
    sliderValue2=[_slider2 value];
    sliderValue3=[_slider3 value];
    sliderValue4=[_slider4 value];
    sliderValue5=[_slider5 value];
    
    if(segmentValue==0)
    {
        ind6=sliderValue6;
        txt_6.text=[texts objectAtIndex:ind6];
    }
    //    else
    //    {
    //        indre5=sliderValue5;
    //        txt_5.text=[texts objectAtIndex:sliderValue5];
    //
    //    }
    
    if(sliderValue6<sliderValue5)
    {
        [_slider6 setValue:sliderValue5 animated:YES];
        txt_6.text=[texts objectAtIndex:sliderValue5];
        
        if(segmentValue==0)
        {
            ind6=sliderValue5;
            txt_6.text=[texts objectAtIndex:ind6];
        }
    }
    
    
}



#pragma motor type selection

- (IBAction)onMotorType:(id)sender
{
    flagpwr=true;
    
    if (receptionStartFlag==true)
    {
        
        rxRecpPause=false;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                       ^{
                           for (NSInteger k = 1; k <= 3; k++)
                           {
                               int8_t bytes2[] ={151,00,00,00,00,00,00,00,00,00,00,00,00};
                               int8_t bytes3[] ={121,00,00,00,00,00,00,00,00,00,00,00,00};
                               int8_t bytes4[] ={133,02,00,00,00,00,00,00,00,00,00,00,00};
                               
                               NSData *data2 = [NSData dataWithBytes:bytes2 length:sizeof(bytes2)];
                               NSData *data3 = [NSData dataWithBytes:bytes3 length:sizeof(bytes3)];
                               NSData *data4 = [NSData dataWithBytes:bytes4 length:sizeof(bytes4)];
                               
                               if ((txChar.properties & CBCharacteristicPropertyWrite) != 0)
                               {
                                   [myperipheral writeValue:data4 forCharacteristic:txChar                                                                              type:CBCharacteristicWriteWithResponse];
                                   [myperipheral writeValue:data3 forCharacteristic:txChar                                                                              type:CBCharacteristicWriteWithResponse];
                                   [myperipheral writeValue:data2 forCharacteristic:txChar                                                                              type:CBCharacteristicWriteWithResponse];
                               }
                               else
                               {
                                   NSLog(@"No write property on TX characteristic, %lu.", (unsigned long)txChar.properties);
                               }
                               rxRecpPause=true;
                           }
                           for (NSInteger i = 1; i <= 50; i++)
                           {
                               
                               [NSThread sleepForTimeInterval:0.250];
                               dispatch_async(dispatch_get_main_queue(),
                                              ^{
                                                  
                                                  NSLog(@"Battery Values==%d",batteryvalue);
                                                  if (batteryvalue==1)
                                                  {
                                                      _txt_BatterySelect.text=@"36";
                                                      self.txt_BatterySelect.backgroundColor = [UIColor lightGrayColor];
                                                     
                                                  }
                                                  if (batteryvalue==2)
                                                  {
                                                      _txt_BatterySelect.text=@"48";
                                                      self.txt_BatterySelect.backgroundColor = [UIColor lightGrayColor];
                                                  }
                                                  
                                                  NSString *validate=@" ";
                                                  if(wattString!=validate)
                                                  {
                                                      _motorTypeTextfield.text=motorTypeString;
                                                      [self restoreRegenClamp];
                                                      
                                                      [self restoreAssistingclamp];
                                                      
                                                      
                                                  }
                                                  NSLog(@"Firmware string==%@",updateFirmware);
                                                  if ([updateFirmware isEqual:@"100486"])
                                                  {
                                                      firmstate3=true;
                                                      switch (segmentValue) {
                                                          case 0:
                                                              [self restoreAssistingclamp];
                                                              
                                                              break;
                                                          case 1:
                                                              [self restoreRegenClamp];
                                                              break;
                                                          default:
                                                              break;
                                                      }
                                                      
                                                      
                                                      
                                                  }
                                                  if ([updateFirmware isEqual:@""])
                                                      
                                                  {
                                                      firmstate3=false;
                                                  }
                                                  if ([updateFirmware isEqual:@"100872"])
                                                  {
                                                      firmstate1=true;
                                                      firmstate2=false;
                                                      
                                                      switch (segmentValue) {
                                                          case 0:
                                                              [self restoreAssistingclamp];
                                                              
                                                              break;
                                                          case 1:
                                                              [self restoreRegenClamp];
                                                              break;
                                                          default:
                                                              
                                                              break;
                                                      }
                                                      
                                                  }
                                                  if ([updateFirmware isEqual:@"100863"])
                                                  {
                                                      firmstate1=false;
                                                      firmstate2=true;
                                                      
                                                      
                                                      switch (segmentValue) {
                                                          case 0:
                                                              [self restoreAssistingclamp];
                                                              
                                                              break;
                                                          case 1:
                                                              [self restoreRegenClamp];
                                                              break;
                                                          default:
                                                              break;
                                                      }
                                                      
                                                      
                                                  }
                                                  
                                                  if ([updateFirmware isEqual:@"101124"])
                                                  {
                                                      firmstate1=false;
                                                      
                                                      firmstate4=true;
                                                      
                                                      switch (segmentValue) {
                                                          case 0:
                                                              [self restoreAssistingclamp];
                                                              
                                                              break;
                                                          case 1:
                                                              [self restoreRegenClamp];
                                                              break;
                                                          default:
                                                              break;
                                                      }
                                                      
                                                      
                                                  }
                                                  
                                                  
                                                  
                                                  
                                              });
                           }
                       });
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                       ^{
                           for (NSInteger i = 1; i <=45; i++)
                           {
                               
                               [NSThread sleepForTimeInterval:0.250];
                               dispatch_async(dispatch_get_main_queue(),
                                              ^{
                                                  //
                                                  
                                                  
                                                  
                                                  [activityIndicator startAnimating];//to start animating
                                                  _powerView.userInteractionEnabled = NO;
                                                  
                                                  
                                              });
                               
                               
                           }
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              
                                              if (motorTypeSelectFlagD==true) {
                                                  
                                                  
                                                  motorSelectFlag=true;
                                                  _slider1.enabled=true;
                                                  _slider2.enabled=true;
                                                  _slider3.enabled=true;
                                                  _slider4.enabled=true;
                                                  _slider5.enabled=true;
                                                  _slider6.enabled=true;
                                                  
                                                  [activityIndicator stopAnimating];
                                                  _powerView.userInteractionEnabled = YES;
                                                  UIAlertController * alert = [UIAlertController
                                                                               alertControllerWithTitle:@""
                                                                               message:@"Motor Type Selection Done"
                                                                               
                                                                               
                                                                               preferredStyle:UIAlertControllerStyleAlert];
                                                  
                                                  UIAlertAction* yesButton = [UIAlertAction
                                                                              actionWithTitle:@"OK"                                   style:UIAlertActionStyleDefault
                                                                              handler:^(UIAlertAction * action) {
                                                                                  //Handle your yes please button action here
                                                                              }];
                                                  
                                                  [alert addAction:yesButton];
                                                  
                                                  [self presentViewController:alert animated:YES completion:nil];
                                                  
                                              }else
                                              {
                                                  [activityIndicator stopAnimating];
                                                  _powerView.userInteractionEnabled = YES;
                                                  UIAlertController * alert = [UIAlertController
                                                                               alertControllerWithTitle:@""
                                                                               message:@"Motor Type Selection Failed!"
                                                                               
                                                                               preferredStyle:UIAlertControllerStyleAlert];
                                                  
                                                  UIAlertAction* yesButton = [UIAlertAction
                                                                              actionWithTitle:@"OK"                                   style:UIAlertActionStyleDefault
                                                                              handler:^(UIAlertAction * action) {
                                                                                  //Handle your yes please button action here
                                                                              }];
                                                  
                                                  
                                                  [alert addAction:yesButton];
                                                  
                                                  [self presentViewController:alert animated:YES completion:nil];
                                              }
                                              
                                              
                                              
                                          });
                       });
        motorTypeTransmitStatus=false;
        firmwareTransmitFlag=false;
        batterySelect=false;
        motorTypeSelectFlagD=false;
        
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



-(void)restoreAssistingclamp//Code for restoring assisting current clamp
{
    _btn_Restorecurrentclamp.enabled=true;
    _btn_Broadcast.enabled=true;
    _btn_MemoryRead.enabled=true;
    _pickerView.userInteractionEnabled=true;
    switch (wattIndex)
    {
        case 1://"250-HSW":
            
            texts= [[NSArray alloc] initWithArray:clamp250WATTHSW];
            txt_1.text =@"4";
            txt_2.text = @"6";
            txt_3.text = @"10";
            txt_4.text = @"18";
            txt_5.text = @"23";
            txt_6.text = @"23";
            break;
            
        case 2://"500-HSW":
            //check for no of turns based on it set restore values.
            switch (winding)
        {
            case 3://500-"27T"
                
                texts= [[NSArray alloc] initWithArray:clamp500WATTHSW];
                txt_1.text =@"8";
                txt_2.text = @"12";
                txt_3.text = @"16";
                txt_4.text = @"20";
                txt_5.text = @"24";
                txt_6.text = @"26";
                
                index1=3;
                index2=5;
                index3=7;
                index4=9;
                index5=11;
                index6=12;
                break;
                
            case 4://500-"37T"
                
                texts= [[NSArray alloc] initWithArray:clamp500WATTHSW];
                txt_1.text =@"6";
                txt_2.text = @"8";
                txt_3.text = @"12";
                txt_4.text = @"16";
                txt_5.text = @"18";
                txt_6.text = @"20";
                break;
        }
            
            break;
            
        case 3://750-HSW":
            //check for no of turns based on it set restore values.
            
            switch (winding)
        {
            case 3://750-"27T"
                
                texts= [[NSArray alloc] initWithArray:clamp750WATTHSW];
                
                if (![myresult isEqual:@""])
                    
                {
                    if (firmstate3==true)
                    {
                        
                        if (batteryvalue==1)
                        {
                            
                            txt_1.text =@"3";
                            txt_2.text = @"8";
                            txt_3.text = @"11";
                            txt_4.text = @"14";
                            txt_5.text = @"17";
                            txt_6.text = @"21";
                        }
                        if (batteryvalue==2)
                        {
                            
                            txt_1.text =@"5";
                            txt_2.text = @"11";
                            txt_3.text = @"14";
                            txt_4.text = @"17";
                            txt_5.text = @"25";
                            txt_6.text = @"28";
                            
                        }
                    }
                    
                }
                if (firmstate3==false)
                {
                    txt_1.text =@"5";
                    txt_2.text = @"11";
                    txt_3.text = @"14";
                    txt_4.text = @"17";
                    txt_5.text = @"25";
                    txt_6.text = @"28";
                }
                
                break;
                
            case 4://750-"37T"
                
                texts= [[NSArray alloc] initWithArray:clamp750WATTSSW];
                txt_1.text =@"9";
                txt_2.text = @"15";
                txt_3.text = @"21";
                txt_4.text = @"28";
                txt_5.text = @"35";
                txt_6.text = @"40";
                break;
        }
            
            break;
            
        case 4:
            //case "1000WATT"://HSW":
            switch (winding)
        {
            case 3://1000-"27T"
                texts= [[NSArray alloc] initWithArray:clamp1000WATTHSW];
                txt_1.text =@"8";
                txt_2.text = @"12";
                txt_3.text = @"17";
                txt_4.text = @"21";
                txt_5.text = @"25";
                txt_6.text = @"28";
                break;
                
            case 4://1000-"37T"
                texts= [[NSArray alloc] initWithArray:clamp1000WATTSSW];
                
                txt_1.text =@"4";
                txt_2.text = @"7";
                txt_3.text = @"10";
                txt_4.text = @"14";
                txt_5.text = @"25";
                txt_6.text = @"28";
                
                break;
        }
            
            break;
            
            
        case 6:
            texts= [[NSArray alloc] initWithArray:clamp750WATTPLUS];
            
            if (![myresult isEqual:@""])
                
            {
                if (firmstate1==true)
                {
                    
                    if (batteryvalue==1)
                    {
                        ind1=[texts indexOfObject:@"4"];
                        ind2=[texts indexOfObject:@"8"];
                        ind3=[texts indexOfObject:@"12"];
                        ind4=[texts indexOfObject:@"14"];
                        ind5=[texts indexOfObject:@"16"];
                        ind6=[texts indexOfObject:@"20"];
                        
                        txt_1.text =@"4";
                        txt_2.text = @"8";
                        txt_3.text = @"12";
                        txt_4.text = @"14";
                        txt_5.text = @"16";
                        txt_6.text = @"20";
                        
                        self.slider1.value=(float)ind1;
                        self.slider2.value=(float)ind2;
                        self.slider3.value=(float)ind3;
                        self.slider4.value=(float)ind4;
                        self.slider5.value=(float)ind5;
                        self.slider6.value=(float)ind6;
                        
                    }
                    
                    
                    if (batteryvalue==2)
                    {
                        ind1=[texts indexOfObject:@"4"];
                        ind2=[texts indexOfObject:@"8"];
                        ind3=[texts indexOfObject:@"12"];
                        ind4=[texts indexOfObject:@"14"];
                        ind5=[texts indexOfObject:@"16"];
                        ind6=[texts indexOfObject:@"20"];
                        
                        
                        txt_1.text =@"12";
                        txt_2.text = @"14";
                        txt_3.text = @"16";
                        txt_4.text = @"20";
                        txt_5.text = @"24";
                        txt_6.text = @"26";
                        self.slider1.value=(float)ind1;
                        self.slider2.value=(float)ind2;
                        self.slider3.value=(float)ind3;
                        self.slider4.value=(float)ind4;
                        self.slider5.value=(float)ind5;
                        self.slider6.value=(float)ind6;
                        
                        
                    }
                    
                }
                else if (firmstate2==true)
                    
                {
                    
                    if(batteryvalue==1 )
                    {
                        ind1=[texts indexOfObject:@"4"];
                        ind2=[texts indexOfObject:@"8"];
                        ind3=[texts indexOfObject:@"12"];
                        ind4=[texts indexOfObject:@"14"];
                        ind5=[texts indexOfObject:@"16"];
                        ind6=[texts indexOfObject:@"20"];
                        
                        
                        txt_1.text =@"4";
                        txt_2.text = @"8";
                        txt_3.text = @"12";
                        txt_4.text = @"14";
                        txt_5.text = @"16";
                        txt_6.text = @"20";
                        self.slider1.value=(float)ind1;
                        self.slider2.value=(float)ind2;
                        self.slider3.value=(float)ind3;
                        self.slider4.value=(float)ind4;
                        self.slider5.value=(float)ind5;
                        self.slider6.value=(float)ind6;
                        
                    }
                    
                    if(batteryvalue==2)
                    {
                        ind1=[texts indexOfObject:@"8"];
                        ind2=[texts indexOfObject:@"14"];
                        ind3=[texts indexOfObject:@"16"];
                        ind4=[texts indexOfObject:@"20"];
                        ind5=[texts indexOfObject:@"24"];
                        ind6=[texts indexOfObject:@"26"];
                        
                        
                        txt_1.text =@"8";
                        txt_2.text = @"14";
                        txt_3.text = @"16";
                        txt_4.text = @"20";
                        txt_5.text = @"24";
                        txt_6.text = @"26";
                        self.slider1.value=(float)ind1;
                        self.slider2.value=(float)ind2;
                        self.slider3.value=(float)ind3;
                        self.slider4.value=(float)ind4;
                        self.slider5.value=(float)ind5;
                        self.slider6.value=(float)ind6;
                        
                        
                    }
                    
                    
                }
                
                
                
                //101124
                
                else  if (firmstate4==true)
                    
                {
                    //NSLog(@"IN 101124 %d",batteryvalue);
                    if(batteryvalue==1 )
                    {
                        ind1=[texts indexOfObject:@"4"];
                        ind2=[texts indexOfObject:@"8"];
                        ind3=[texts indexOfObject:@"12"];
                        ind4=[texts indexOfObject:@"14"];
                        ind5=[texts indexOfObject:@"16"];
                        ind6=[texts indexOfObject:@"20"];
                        
                        
                        txt_1.text =@"4";
                        txt_2.text = @"8";
                        txt_3.text = @"12";
                        txt_4.text = @"14";
                        txt_5.text = @"16";
                        txt_6.text = @"20";
                        self.slider1.value=(float)ind1;
                        self.slider2.value=(float)ind2;
                        self.slider3.value=(float)ind3;
                        self.slider4.value=(float)ind4;
                        self.slider5.value=(float)ind5;
                        self.slider6.value=(float)ind6;
                        
                    }
                    
                    
                    if(batteryvalue==2)
                    {
                        ind1=[texts indexOfObject:@"12"];
                        ind2=[texts indexOfObject:@"14"];
                        ind3=[texts indexOfObject:@"16"];
                        ind4=[texts indexOfObject:@"20"];
                        ind5=[texts indexOfObject:@"24"];
                        ind6=[texts indexOfObject:@"26"];
                        
                        
                        txt_1.text =@"12";
                        txt_2.text = @"14";
                        txt_3.text = @"16";
                        txt_4.text = @"20";
                        txt_5.text = @"24";
                        txt_6.text = @"26";
                        
                        self.slider1.value=(float)ind1;
                        self.slider2.value=(float)ind2;
                        self.slider3.value=(float)ind3;
                        self.slider4.value=(float)ind4;
                        self.slider5.value=(float)ind5;
                        self.slider6.value=(float)ind6;
                        
                        
                    }
                    
                }
                
                else
                {
                    
                    
                    
                    ind1=[texts indexOfObject:@"4"];
                    ind2=[texts indexOfObject:@"8"];
                    ind3=[texts indexOfObject:@"12"];
                    ind4=[texts indexOfObject:@"14"];
                    ind5=[texts indexOfObject:@"16"];
                    ind6=[texts indexOfObject:@"20"];
                    
                    txt_1.text =@"4";
                    txt_2.text = @"8";
                    txt_3.text = @"12";
                    txt_4.text = @"14";
                    txt_5.text = @"16";
                    txt_6.text = @"20";
                    
                    self.slider1.value=(float)ind1;
                    self.slider2.value=(float)ind2;
                    self.slider3.value=(float)ind3;
                    self.slider4.value=(float)ind4;
                    self.slider5.value=(float)ind5;
                    self.slider6.value=(float)ind6;
                    
                    
                }
                
            }
            
            break;
    }
    
    
    
}

-(void)restoreRegenClamp//Code For Restore Assist Current Clamp value
{
    _btn_Restorecurrentclamp.enabled=true;
    _btn_Broadcast.enabled=true;
    _btn_MemoryRead.enabled=true;
    _pickerView.userInteractionEnabled=true;
    switch (wattIndex)
    {
            
        case 1:// "250" "HSW":
            
            texts= [[NSArray alloc] initWithArray:clamp250WATTHSW];
            txt_1.text= @"4";
            txt_2.text = @"6";
            txt_3.text= @"10";
            txt_4.text= @"18";
            txt_5.text= @"23";
            break;
            
        case 2://"500 Watt"
            switch (winding)
        {
            case 3://500-"27T"
                texts= [[NSArray alloc] initWithArray:clamp500WATTHSW];
                txt_1.text= @"8";
                txt_2.text= @"12";
                txt_3.text= @"16";
                txt_4.text= @"20";
                txt_5.text= @"24";
                
                rindex1=3;
                rindex2=5;
                rindex3=7;
                rindex4=9;
                rindex5=11;
                
                break;
                
            case 4://500-"37T"
                texts= [[NSArray alloc] initWithArray:clamp500WATTHSW];
                txt_1.text= @"6";
                txt_2.text = @"8";
                txt_3.text= @"12";
                txt_4.text= @"16";
                txt_5.text= @"18";
                break;
        }
            break;
            
        case 3://"750 Watt"
            
            //check for no of turns based on it set restore values.
            
            switch (winding)
        {
            case 3://750-"27 T"
                texts= [[NSArray alloc] initWithArray:clamp750WATTHSW];
                
                if (![myresult isEqual:@""])
                    
                {
                    if (firmstate3==true)
                    {
                        
                        if (batteryvalue==1)
                        {
                            txt_1.text= @"2";
                            txt_2.text = @"3";
                            txt_3.text = @"5";
                            txt_4.text = @"7";
                            txt_5.text = @"8";
                            
                            
                        }
                        if(batteryvalue==2)
                        {
                            txt_1.text= @"2";
                            txt_2.text = @"3";
                            txt_3.text = @"5";
                            txt_4.text = @"7";
                            txt_5.text = @"8";
                        }
                        
                        
                    }
                }
                if (firmstate3==false) {
                    
                    
                    txt_1.text = @"5";
                    txt_2.text= @"11";
                    txt_3.text = @"14";
                    txt_4.text= @"17";
                    txt_5.text= @"25";
                }
                
                break;
                
            case 4://750-"37T"
                
                texts= [[NSArray alloc] initWithArray:clamp750WATTSSW];
                txt_1.text = @"9";
                txt_2.text= @"15";
                txt_3.text = @"21";
                txt_4.text= @"28";
                txt_5.text= @"35";
                break;
        }
            break;
            
        case 4:
            //            case "1000WATT"://HSW":
            switch (winding)
        {
            case 3://1000-"27T"
                
                texts= [[NSArray alloc] initWithArray:clamp1000WATTHSW];
                txt_1.text= @"8";
                txt_2.text= @"12";
                txt_3.text = @"17";
                txt_4.text = @"21";
                txt_5.text = @"25";
                break;
                
            case 4://1000-"37T"
                texts= [[NSArray alloc] initWithArray:clamp1000WATTSSW];
                txt_1.text = @"4";
                txt_2.text = @"7";
                txt_3.text = @"10";
                txt_4.text = @"14";
                txt_5.text = @"25";
                break;
        }
            break;
            
        case 6://750 Watt Plus
            
            texts= [[NSArray alloc] initWithArray:clamp750WATTPLUS];
            
            if (![myresult isEqual:@""])
                
            {
                if (firmstate1==true)
                {
                    if (batteryvalue==1)
                    {
                        indre1=[texts indexOfObject:@"2"];
                        indre2=[texts indexOfObject:@"3"];
                        indre3=[texts indexOfObject:@"4"];
                        indre4=[texts indexOfObject:@"7"];
                        indre5=[texts indexOfObject:@"8"];
                        
                        txt_1.text = @"2";
                        txt_2.text = @"3";
                        txt_3.text = @"4";
                        txt_4.text = @"7";
                        txt_5.text = @"8";
                        
                        self.slider1.value=(float)indre1;
                        self.slider2.value=(float) indre2;
                        self.slider3.value=(float)indre3;
                        self.slider4.value=(float)indre4;
                        self.slider5.value=(float)indre5;
                    }
                    
                    if(batteryvalue==2)
                    {
                        indre1=[texts indexOfObject:@"2"];
                        indre2=[texts indexOfObject:@"3"];
                        indre3=[texts indexOfObject:@"4"];
                        indre4=[texts indexOfObject:@"7"];
                        indre5=[texts indexOfObject:@"8"];
                        
                        
                        txt_1.text= @"2";
                        txt_2.text = @"3";
                        txt_3.text = @"4";
                        txt_4.text = @"7";
                        txt_5.text = @"8";
                        
                        self.slider1.value=(float)indre1;
                        self.slider2.value=(float) indre2;
                        self.slider3.value=(float)indre3;
                        self.slider4.value=(float)indre4;
                        self.slider5.value=(float)indre5;
                        
                    }
                    
                }
                
                else if (firmstate2==true)
                    
                {
                    if (batteryvalue==1)
                    {
                        indre1=[texts indexOfObject:@"2"];
                        indre2=[texts indexOfObject:@"3"];
                        indre3=[texts indexOfObject:@"4"];
                        indre4=[texts indexOfObject:@"7"];
                        indre5=[texts indexOfObject:@"8"];
                        
                        txt_1.text= @"2";
                        txt_2.text = @"3";
                        txt_3.text = @"4";
                        txt_4.text = @"7";
                        txt_5.text = @"8";
                        
                        self.slider1.value=(float)indre1;
                        self.slider2.value=(float) indre2;
                        self.slider3.value=(float)indre3;
                        self.slider4.value=(float)indre4;
                        self.slider5.value=(float)indre5;
                    }
                    //
                    if(batteryvalue==2)
                    {
                        indre1=[texts indexOfObject:@"2"];
                        indre2=[texts indexOfObject:@"3"];
                        indre3=[texts indexOfObject:@"4"];
                        indre4=[texts indexOfObject:@"7"];
                        indre5=[texts indexOfObject:@"8"];
                        
                        txt_1.text= @"2";
                        txt_2.text = @"3";
                        txt_3.text = @"4";
                        txt_4.text = @"7";
                        txt_5.text = @"8";
                        
                        self.slider1.value=(float)indre1;
                        self.slider2.value=(float) indre2;
                        self.slider3.value=(float)indre3;
                        self.slider4.value=(float)indre4;
                        self.slider5.value=(float)indre5;
                        
                    }
                    
                }
                
                else  if (firmstate4==true)
                    
                {
                    if (batteryvalue==1)
                    {
                        indre1=[texts indexOfObject:@"4"];
                        indre2=[texts indexOfObject:@"8"];
                        indre3=[texts indexOfObject:@"12"];
                        indre4=[texts indexOfObject:@"14"];
                        indre5=[texts indexOfObject:@"16"];
                        txt_1.text= @"4";
                        txt_2.text = @"8";
                        txt_3.text = @"12";
                        txt_4.text = @"14";
                        txt_5.text = @"16";
                        
                        self.slider1.value=(float)indre1;
                        self.slider2.value=(float) indre2;
                        self.slider3.value=(float)indre3;
                        self.slider4.value=(float)indre4;
                        self.slider5.value=(float)indre5;
                    }
                    
                    if(batteryvalue==2)
                    {
                        indre1=[texts indexOfObject:@"4"];
                        indre2=[texts indexOfObject:@"8"];
                        indre3=[texts indexOfObject:@"12"];
                        indre4=[texts indexOfObject:@"14"];
                        indre5=[texts indexOfObject:@"16"];
                        
                        txt_1.text= @"4";
                        txt_2.text = @"8";
                        txt_3.text = @"12";
                        txt_4.text = @"14";
                        txt_5.text = @"16";
                        
                        self.slider1.value=(float)indre1;
                        self.slider2.value=(float) indre2;
                        self.slider3.value=(float)indre3;
                        self.slider4.value=(float)indre4;
                        self.slider5.value=(float)indre5;
                        
                    }
                    
                }
                //
                
                else
                    
                {
                    indre1=[texts indexOfObject:@"4"];
                    indre2=[texts indexOfObject:@"8"];
                    indre3=[texts indexOfObject:@"12"];
                    indre4=[texts indexOfObject:@"14"];
                    indre5=[texts indexOfObject:@"16"];
                    
                    txt_1.text= @"4";
                    txt_2.text = @"8";
                    txt_3.text = @"12";
                    txt_4.text = @"14";
                    txt_5.text = @"16";
                    
                    self.slider1.value=(float)indre1;
                    self.slider2.value=(float) indre2;
                    self.slider3.value=(float)indre3;
                    self.slider4.value=(float)indre4;
                    self.slider5.value=(float)indre5;
                    
                    
                }
                
            }
            
            
            break;
    }
    
    
}


- (IBAction)onSelectSwitch:(id)sender
{
    
    
    UISegmentedControl *segment=sender;
    segmentValue=segment.selectedSegmentIndex;
    
    
    switch (segmentValue)
    {
        case 0:
            
            swipecount=0;
            
            _lbl_6.hidden=false;
            
            _lbl_1.text=@"Assist Level 1";
            _lbl_2.text=@"Assist Level 2";
            _lbl_3.text=@"Assist Level 3";
            _lbl_4.text=@"Assist Level 4";
            _lbl_5.text=@"Assist Level 5";
            _lbl_6.text=@"Turbo Level";
            
            txt_6.hidden=false;
            
            _slider6.hidden=false;
            
            
            
            
            self.AssistView.hidden=false;
            self.regenView.hidden=true;
            
            
            
            txt_1.text=[texts objectAtIndex:ind1];
            
            txt_2.text=[texts objectAtIndex:ind2];
            
            txt_3.text=[texts objectAtIndex:ind3];
            
            txt_4.text=[texts objectAtIndex:ind4];
            txt_5.text=[texts objectAtIndex:ind5];
            txt_6.text=[texts objectAtIndex:ind6];
            
            
            self.slider1.value=(float)ind1;
            self.slider2.value=(float)ind2;
            self.slider3.value=(float)ind3;
            self.slider4.value=(float)ind4;
            self.slider5.value=(float)ind5;
            self.slider6.value=(float)ind6;
            
            
            break;
            
        case 1:
            swipecount=1;
            
            _lbl_1.text=@"Regen Level 1";
            _lbl_2.text=@"Regen Level 2";
            _lbl_3.text=@"Regen Level 3";
            _lbl_4.text=@"Regen Level 4";
            _lbl_5.text=@"Regen Level 5";
            
            _lbl_6.hidden=true;
            txt_6.hidden=TRUE;
            _slider6.hidden=true;
            
            self.AssistView.hidden=true;
            self.regenView.hidden=false;
            
            
            
            txt_1.text=[texts objectAtIndex:indre1];
            
            txt_2.text=[texts objectAtIndex:indre2];
            
            txt_3.text=[texts objectAtIndex:indre3];
            
            txt_4.text=[texts objectAtIndex:indre4];
            
            txt_5.text=[texts objectAtIndex:indre5];
            
            self.slider1.value=(float)indre1;
            self.slider2.value=(float) indre2;
            self.slider3.value=(float)indre3;
            self.slider4.value=(float)indre4;
            self.slider5.value=(float)indre5;
            
            
            break;
            
        default:
            break;
    }
    
    
}
- (IBAction)onRestore:(id)sender
{
   if (receptionStartFlag==true)
    {
        switch (segmentValue)
        {
            case 0:
                [self restoreAssistingclamp];
                
                
                break;
            case 1:
                
                [self restoreRegenClamp];
                break;
                
            default:
                break;
        }
        int duration =0.5;
        
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
                                    actionWithTitle:@"OK"                                   style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        //Handle your yes please button action here
                                    }];
        [alert addAction:yesButton];
        
        [activityIndicator stopAnimating];
        [self presentViewController:alert animated:YES completion:nil];
        
        
    }
        
        
        
        
    }

- (IBAction)onBroadcastingCurrentClamp:(id)sender
{
    if (receptionStartFlag==true) {
        
        
        switch (segmentValue) {
            case 0:
                for (int n=0; n<4;n++)
                {
                    [self assistBroadcastMethod];
                    int8_t bytes2[] ={147,index1,index2,index3,index4,index5,index6,00,00,00,00,00,00};
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
                
                break;
                
            case 1:
                for (int n=0; n<2;n++)
                {
                    [self regenBroadcastMethod];
                    [self assistBroadcastMethod];
                    //  int8_t bytes2[] ={147,index1,index2,index3,index4,index5,index6,00,00,00,00,00,00};
                    int8_t bytes3[] ={152,rindex1,rindex2,rindex3,rindex4,rindex5,00,00,00,00,00,00,00};
                    //  NSData *data2 = [NSData dataWithBytes:bytes2 length:sizeof(bytes2)];
                    NSData *data3 = [NSData dataWithBytes:bytes3 length:sizeof(bytes3)];
                    
                    if ((txChar.properties & CBCharacteristicPropertyWrite) != 0)
                    {
                        //    [myperipheral writeValue:data2 forCharacteristic:txChar                                                                              type:CBCharacteristicWriteWithResponse];
                        [myperipheral writeValue:data3 forCharacteristic:txChar                                                                              type:CBCharacteristicWriteWithResponse];
                    }
                    else if ((txChar.properties & CBCharacteristicPropertyWrite) != 0)
                    {
                        //    [myperipheral writeValue:data2 forCharacteristic:txChar type:CBCharacteristicWriteWithResponse];
                        [myperipheral writeValue:data3 forCharacteristic:txChar type:CBCharacteristicWriteWithResponse];
                    }
                    else
                    {
                        NSLog(@"No write property on TX characteristic, %lu.", (unsigned long)txChar.properties);
                    }
                    rxRecpPause=true;
                }
                
                break;
            default:
                break;
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                       ^{
                           for (NSInteger i = 1; i <= 40; i++)
                           {
                               
                               [NSThread sleepForTimeInterval:0.300];
                               dispatch_async(dispatch_get_main_queue(),
                                              ^{
                                                  
                                                  [activityIndicator startAnimating];//to start animating
                                                  _powerView.userInteractionEnabled = NO;
                                                  
                                                  
                                              });
                               
                               
                           }
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              
                                              [activityIndicator stopAnimating];
                                              _powerView.userInteractionEnabled = YES;
                                              
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
                                              assistBroadcastStatus=false;
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
-(void)assistBroadcastMethod
{
    
    NSString *str1=[txt_1 text];
    num1=[NSString stringWithString:str1];
    stAssist1=[NSString stringWithString:str1];
    
    index1=[texts indexOfObject:num1];
    
    NSString *str2=[txt_2 text];
    num2=[NSString stringWithString:str2];
    index2=[texts indexOfObject:num2];
    stAssist2=[NSString stringWithString:str2];
    
    NSString *str3=[txt_3 text];
    num3=[NSString stringWithString:str3];
    index3=[texts indexOfObject:num3];
    stAssist3=[NSString stringWithString:str3];
    NSString *str4=[txt_4 text];
    num4=[NSString stringWithString:str4];
    index4=[texts indexOfObject:num4];
    stAssist4=[NSString stringWithString:str4];
    
    NSString *str5=[txt_5 text];
    num5=[NSString stringWithString:str5];
    index5=[texts indexOfObject:num5];
    stAssist5=[NSString stringWithString:str5];
    
    NSString *str6=[txt_6 text];
    num6=[NSString stringWithString:str6];
    index6=[texts indexOfObject:num6];
    
    stAssist6=[NSString stringWithString:str6];
    
    flag_Broadcast=true;
}


-(void)regenBroadcastMethod
{
    
    NSString *str1=[txt_1 text];
    num7=[NSString stringWithString:str1];
    
    NSLog(@"NUM 7 %@",num7);
    rindex1=[texts indexOfObject:num7];
    stRegen1=str1;
    NSString *str2=[txt_2 text];
    num8=[NSString stringWithString:str2];
    NSLog(@"NUM 7 %@",num7);
    rindex2=[texts indexOfObject:num8];
    stRegen2=str2;
    
    NSString *str3=[txt_3 text];
    num9=[NSString stringWithString:str3];
    rindex3=[texts indexOfObject:num9];
    NSLog(@"NUM 7 %@",num7);
    stRegen3=str3;
    NSString *str4=[txt_4 text];
    num10=[NSString stringWithString:str4];
    rindex4=[texts indexOfObject:num10];
    NSLog(@"NUM 7 %@",num7);
    stRegen4=str4;
    
    NSString *str5=[txt_5 text];
    num11=[NSString stringWithString:str5];
    rindex5=[texts indexOfObject:num11];
    NSLog(@"NUM 7 %@",num11);
    stRegen5=str5;
    flag_Broadcast=true;
    
    
}


- (IBAction)onMemoryReadCurrentClamp:(id)sender
{
    if (receptionStartFlag==true)
    {
        flag_Memoryread=true;
        
        if (motorSelectFlag==true)
        {
            
            
            rxRecpPause=false;
            
            for (int j=0; j<=9;j++)
            {
                int8_t bytes2[] ={149,02,00,00,00,00,00,00,00,00,00,00,00};
                
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
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                           ^{
                               for (NSInteger i = 1; i <=80; i++)
                               {
                                   
                                   [NSThread sleepForTimeInterval:0.300];
                                   
                                   dispatch_async(dispatch_get_main_queue(),
                                                  ^{
                                                      
                                                      int i;
                                                      
                                                      //       if (segmentValue==0)
                                                      //      {
                                                      for (i = 0; i < [texts count]; i++)
                                                      {
                                                          ind1=assist_l1;
                                                          
                                                      }
                                                      for (i = 0; i < [texts count]; i++)
                                                      {
                                                          ind2=assist_l2;
                                                      }
                                                      for (i = 0; i < [texts count]; i++)
                                                      {
                                                          
                                                          ind3=assist_l3;
                                                      }
                                                      for (i = 0; i < [texts count]; i++)
                                                      {
                                                          ind4=assist_l4;
                                                          
                                                      }
                                                      
                                                      for (i = 0; i < [texts count]; i++)
                                                      {
                                                          ind5=assist_l5;
                                                          
                                                      }
                                                      for (i = 0; i < [texts count]; i++)
                                                      {
                                                          ind6=assist_t;
                                                      }
                                                      
                                                      
                                                      for (i = 0; i < [texts count]; i++)
                                                      {
                                                          indre1=regen_l1;
                                                          
                                                      }
                                                      for (i = 0; i < [texts count]; i++)
                                                      {
                                                          indre2=regen_l2;
                                                          
                                                      }
                                                      
                                                      for (i = 0; i < [texts count]; i++)
                                                      {
                                                          indre3=regen_l3;
                                                          
                                                      }
                                                      for (i = 0; i < [texts count]; i++)
                                                      {
                                                          indre4=regen_l4;
                                                      }
                                                      for (i = 0; i < [texts count]; i++)
                                                      {
                                                          indre5=regen_l5;
                                                      }
                                                      
                                                      
                                                      switch (segmentValue)
                                                      {
                                                          case 0:
                                                              
                                                              txt_1.text=[texts objectAtIndex:ind1];
                                                              
                                                              txt_2.text=[texts objectAtIndex:ind2];
                                                              
                                                              txt_3.text=[texts objectAtIndex:ind3];
                                                              
                                                              txt_4.text=[texts objectAtIndex:ind4];
                                                              txt_5.text=[texts objectAtIndex:ind5];
                                                              txt_6.text=[texts objectAtIndex:ind6];
                                                              
                                                              
                                                              self.slider1.value=(float)ind1;
                                                              self.slider2.value=(float)ind2;
                                                              self.slider3.value=(float)ind3;
                                                              self.slider4.value=(float)ind4;
                                                              self.slider5.value=(float)ind5;
                                                              self.slider6.value=(float)ind6;
                                                              
                                                              
                                                              break;
                                                              
                                                              
                                                          case 1:
                                                              
                                                              txt_1.text=[texts objectAtIndex:indre1];
                                                              
                                                              txt_2.text=[texts objectAtIndex:indre2];
                                                              
                                                              txt_3.text=[texts objectAtIndex:indre3];
                                                              
                                                              txt_4.text=[texts objectAtIndex:indre4];
                                                              txt_5.text=[texts objectAtIndex:indre5];
                                                              
                                                              self.slider1.value=(float)indre1;
                                                              self.slider2.value=(float) indre2;
                                                              self.slider3.value=(float)indre3;
                                                              self.slider4.value=(float)indre4;
                                                              self.slider5.value=(float)indre5;
                                                              
                                                              break;
                                                              
                                                              
                                                          default:
                                                              break;
                                                      }
                                                      
                                                      
                                                      [activityIndicator startAnimating];//to start animating
                                                      _powerView.userInteractionEnabled = NO;
                                                      
                                                      
                                                  });
                                   
                                   
                               }
                               
                               
                               dispatch_async(dispatch_get_main_queue(),
                                              ^{
                                                  
                                                  NSLog(@"Memory read status %d",memoryReadFlagD);
                                                  
                                                  if (memoryReadFlagD==true)
                                                  {
                                                      
                                                      
                                                      [activityIndicator stopAnimating];
                                                      _powerView.userInteractionEnabled = YES;
                                                      UIAlertController * alert = [UIAlertController
                                                                                   alertControllerWithTitle:@""
                                                                                   message:@"Memory Read Successfully! "
                                                                                   
                                                                                   
                                                                                   preferredStyle:UIAlertControllerStyleAlert];
                                                      
                                                      UIAlertAction* yesButton = [UIAlertAction
                                                                                  actionWithTitle:@"OK"   style:UIAlertActionStyleDefault
                                                                                  handler:^(UIAlertAction * action)
                                                                                  {
                                                                                      //Handle your yes please button action here
                                                                                  }];
                                                      
                                                      memoryReadFlagD=false;
                                                      
                                                      NSLog(@"Memory read status %d",memoryReadFlagD);
                                                      
                                                      [alert addAction:yesButton];
                                                      
                                                      [self presentViewController:alert animated:YES completion:nil];
                                                      
                                                  }
                                                  else
                                                  {
                                                      //                                                  memoryReadFlagD=false;
                                                      NSLog(@"Memory read status %d",memoryReadFlagD);
                                                      
                                                      
                                                      [activityIndicator stopAnimating];
                                                      _powerView.userInteractionEnabled = YES;
                                                      
                                                      UIAlertController * alert = [UIAlertController
                                                                                   alertControllerWithTitle:@""
                                                                                   message:@"Memory Read Failed "
                                                                                   
                                                                                   preferredStyle:UIAlertControllerStyleAlert];
                                                      
                                                      UIAlertAction* yesButton = [UIAlertAction
                                                                                  actionWithTitle:@"OK"                                   style:UIAlertActionStyleDefault
                                                                                  handler:^(UIAlertAction * action)
                                                                                  {
                                                                                      //Handle your yes please button action here
                                                                                  }];
                                                      
                                                      memoryReadFlagD=false;
                                                      
                                                      
                                                      [alert addAction:yesButton];
                                                      
                                                      [self presentViewController:alert animated:YES completion:nil];
                                                  }
                                                  
                                                  
                                                  NSLog(@"Memory read status %d",memoryReadFlagD);
                                                  memoryStatusClampCurrent=false;
                                                  
                                                  
                                              });
                           });
            
            
        }
        else
            
        {
            UIAlertController * alert = [UIAlertController
                                         alertControllerWithTitle:@""
                                         message:@"Please select Motor Type First"
                                         preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:@"OK"                                   style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action) {
                                            //Handle your yes please button action here
                                        }];
            [alert addAction:yesButton];
            
            [activityIndicator stopAnimating];
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
                                    actionWithTitle:@"OK"     style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        //Handle your yes please button action here
                                    }];
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
        
        
        
    }
}

-(void)adjustFontSizeOfLabel{
    
    CGRect screenSize = [[UIScreen mainScreen]bounds];
    
    
    
    if (screenSize.size.height <= 480)
    {
        // iPhone 4
        [_btn_Broadcast.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_btn_Restorecurrentclamp.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_btn_MemoryRead.titleLabel setFont:[UIFont systemFontOfSize:12]];
    }
    else if (screenSize.size.height <= 568)
    {
        // IPhone 5/5s/5c
        
        self.btn_Broadcast.titleLabel.font=[self.btn_Broadcast.font fontWithSize:18];
        self.btn_Restorecurrentclamp.titleLabel.font=[self.btn_Restorecurrentclamp.font fontWithSize:18];
        self.btn_MemoryRead.titleLabel.font=[self.btn_MemoryRead.font fontWithSize:18];
        
        [_btn_Battery.titleLabel setFont:[UIFont systemFontOfSize:15]];
        
        //        [_btn_Broadcast.titleLabel setFont:[UIFont systemFontOfSize:15]];
        //        [_btn_Restorecurrentclamp.titleLabel setFont:[UIFont systemFontOfSize:15]];
        //        [_btn_MemoryRead.titleLabel setFont:[UIFont systemFontOfSize:15]];
        
        self.motorTypeTextfield.font = [self.motorTypeTextfield.font fontWithSize:17];
        self.lbl_1.font = [self.lbl_1.font fontWithSize:18];
        self.lbl_2.font = [self.lbl_2.font fontWithSize:18];
        self.lbl_3.font = [self.lbl_3.font fontWithSize:18];
        self.lbl_4.font = [self.lbl_4.font fontWithSize:18];
        self.lbl_5.font = [self.lbl_5.font fontWithSize:18];
        self.lbl_6.font = [self.lbl_6.font fontWithSize:18];
        
        self.txt_1.font = [self.txt_1.font fontWithSize:18];
        self.txt_2.font = [self.txt_2.font fontWithSize:18];
        self.txt_3.font = [self.txt_3.font fontWithSize:18];
        self.txt_4.font = [self.txt_4.font fontWithSize:18];
        self.txt_5.font = [self.txt_5.font fontWithSize:18];
        self.txt_6.font = [self.txt_6.font fontWithSize:18];
        
        self.lbl_PowerLevel.font = [self.lbl_PowerLevel.font fontWithSize:15];
        self.lbl_CurrentClamp.font = [self.lbl_CurrentClamp.font fontWithSize:15];
        self.txt_BatterySelect.font = [self.txt_BatterySelect.font fontWithSize:18];
        self.lbl_PowerConfigurator.font=[self.lbl_PowerConfigurator.font fontWithSize:28];
        
        
        
    }
    else if (screenSize.size.width <= 375)
    {
        // iPhone 6
        
        _slider1.frame=CGRectMake(81, 230, 211, 31);
        txt_1.frame=CGRectMake(6, 232, 52, 28);
        _lbl_1.frame=CGRectMake(121, 250, 140, 50);
        
        _slider2.frame=CGRectMake(81, 290, 211, 31);
        txt_2.frame=CGRectMake(6, 292, 52, 28);
        _lbl_2.frame=CGRectMake(121, 310, 140, 50);
        
        _slider3.frame=CGRectMake(81, 350, 211, 31);
        txt_3.frame=CGRectMake(6, 352, 52, 28);
        _lbl_3.frame=CGRectMake(121, 370, 140, 50);
        
        _slider4.frame=CGRectMake(81, 410, 211, 31);
        txt_4.frame=CGRectMake(6, 412, 52, 28);
        _lbl_4.frame=CGRectMake(121, 430, 140, 50);
        
        _slider5.frame=CGRectMake(81, 470, 211, 31);
        txt_5.frame=CGRectMake(6, 472, 52, 28);
        _lbl_5.frame=CGRectMake(121, 490, 140, 50);
        
        _slider6.frame=CGRectMake(81, 530, 211, 31);
        txt_6.frame=CGRectMake(6, 532, 52, 28);
        _lbl_6.frame=CGRectMake(121, 550, 140, 50);
        
        
        [self.view addSubview:_slider1];
        [self.view addSubview:txt_1];
        [self.view addSubview:_lbl_1];
        
        [self.view addSubview:_slider2];
        [self.view addSubview:txt_2];
        [self.view addSubview:_lbl_2];
        
        [self.view addSubview:_slider3];
        [self.view addSubview:txt_3];
        [self.view addSubview:_lbl_3];
        
        [self.view addSubview:_slider4];
        [self.view addSubview:txt_4];
        [self.view addSubview:_lbl_4];
        
        [self.view addSubview:_slider5];
        [self.view addSubview:txt_5];
        [self.view addSubview:_lbl_5];
        
        
        [self.view addSubview:_slider6];
        [self.view addSubview:txt_6];
        [self.view addSubview:_lbl_6];
        
        
        //   self.motortype.font = [self.motortype.font fontWithSize:20];
        [_btn_Battery.titleLabel setFont:[UIFont systemFontOfSize:17]];
        
        self.btn_Broadcast.titleLabel.font=[self.btn_Broadcast.font fontWithSize:19];
        self.btn_Restorecurrentclamp.titleLabel.font=[self.btn_Restorecurrentclamp.font fontWithSize:19];
        self.btn_MemoryRead.titleLabel.font=[self.btn_MemoryRead.font fontWithSize:19];
        
        //        [_btn_Broadcast.titleLabel setFont:[UIFont systemFontOfSize:15]];
        //        [_btn_Restorecurrentclamp.titleLabel setFont:[UIFont systemFontOfSize:15]];
        //        [_btn_MemoryRead.titleLabel setFont:[UIFont systemFontOfSize:15]];
        
        self.motorTypeTextfield.font = [self.motorTypeTextfield.font fontWithSize:16];
        self.lbl_1.font = [self.lbl_1.font fontWithSize:21];
        self.lbl_2.font = [self.lbl_2.font fontWithSize:21];
        self.lbl_3.font = [self.lbl_3.font fontWithSize:21];
        self.lbl_4.font = [self.lbl_4.font fontWithSize:21];
        self.lbl_5.font = [self.lbl_5.font fontWithSize:21];
        self.lbl_6.font = [self.lbl_6.font fontWithSize:21];
        
        self.txt_1.font = [self.txt_1.font fontWithSize:21];
        self.txt_2.font = [self.txt_2.font fontWithSize:21];
        self.txt_3.font = [self.txt_3.font fontWithSize:21];
        self.txt_4.font = [self.txt_4.font fontWithSize:21];
        self.txt_5.font = [self.txt_5.font fontWithSize:21];
        self.txt_6.font = [self.txt_6.font fontWithSize:21];
        
        self.lbl_PowerLevel.font = [self.lbl_PowerLevel.font fontWithSize:18];
        self.lbl_CurrentClamp.font = [self.lbl_CurrentClamp.font fontWithSize:18];
        self.lbl_PowerConfigurator.font=[self.lbl_PowerConfigurator.font fontWithSize:32];
        
        self.txt_BatterySelect.font = [self.txt_BatterySelect.font fontWithSize:21];
        
        
    }
    else if (screenSize.size.width <= 414)
    {
        // iPhone 6+
        
        _slider1.frame=CGRectMake(100, 250, 211, 31);
        txt_1.frame=CGRectMake(17, 252, 52, 28);
        _lbl_1.frame=CGRectMake(135, 270, 140, 50);
        
        _slider2.frame=CGRectMake(100, 310, 211, 31);
        txt_2.frame=CGRectMake(17, 312, 52, 28);
        _lbl_2.frame=CGRectMake(135, 330, 140, 50);
        
        _slider3.frame=CGRectMake(100, 370, 211, 31);
        txt_3.frame=CGRectMake(17, 372, 52, 28);
        _lbl_3.frame=CGRectMake(135, 390, 140, 50);
        
        _slider4.frame=CGRectMake(100, 430, 211, 31);
        txt_4.frame=CGRectMake(17, 432, 52, 28);
        _lbl_4.frame=CGRectMake(135, 450, 140, 50);
        
        _slider5.frame=CGRectMake(100, 490, 211, 31);
        txt_5.frame=CGRectMake(17, 492, 52, 28);
        _lbl_5.frame=CGRectMake(135, 510, 140, 50);
        
        _slider6.frame=CGRectMake(100, 550, 211, 31);
        txt_6.frame=CGRectMake(17, 552, 52, 28);
        _lbl_6.frame=CGRectMake(135, 570, 140, 50);
        
        
        [self.view addSubview:_slider1];
        [self.view addSubview:txt_1];
        [self.view addSubview:_lbl_1];
        
        [self.view addSubview:_slider2];
        [self.view addSubview:txt_2];
        [self.view addSubview:_lbl_2];
        
        [self.view addSubview:_slider3];
        [self.view addSubview:txt_3];
        [self.view addSubview:_lbl_3];
        
        [self.view addSubview:_slider4];
        [self.view addSubview:txt_4];
        [self.view addSubview:_lbl_4];
        
        [self.view addSubview:_slider5];
        [self.view addSubview:txt_5];
        [self.view addSubview:_lbl_5];
        
        
        [self.view addSubview:_slider6];
        [self.view addSubview:txt_6];
        [self.view addSubview:_lbl_6];
        
        [_btn_Battery.titleLabel setFont:[UIFont systemFontOfSize:19]];
        
        self.btn_Broadcast.titleLabel.font=[self.btn_Broadcast.font fontWithSize:20];
        self.btn_Restorecurrentclamp.titleLabel.font=[self.btn_Restorecurrentclamp.font fontWithSize:20];
        self.btn_MemoryRead.titleLabel.font=[self.btn_MemoryRead.font fontWithSize:20];
        
        //        [_btn_Broadcast.titleLabel setFont:[UIFont systemFontOfSize:16]];
        //        [_btn_Restorecurrentclamp.titleLabel setFont:[UIFont systemFontOfSize:16]];
        //        [_btn_MemoryRead.titleLabel setFont:[UIFont systemFontOfSize:16]];
        
        
        self.motorTypeTextfield.font = [self.motorTypeTextfield.font fontWithSize:18];
        
        self.lbl_1.font = [self.lbl_1.font fontWithSize:24];
        self.lbl_2.font = [self.lbl_2.font fontWithSize:24];
        self.lbl_3.font = [self.lbl_3.font fontWithSize:24];
        self.lbl_4.font = [self.lbl_4.font fontWithSize:24];
        self.lbl_5.font = [self.lbl_5.font fontWithSize:24];
        self.lbl_6.font = [self.lbl_6.font fontWithSize:24];
        
        self.txt_1.font = [self.txt_1.font fontWithSize:24];
        self.txt_2.font = [self.txt_2.font fontWithSize:24];
        self.txt_3.font = [self.txt_3.font fontWithSize:24];
        self.txt_4.font = [self.txt_4.font fontWithSize:24];
        self.txt_5.font = [self.txt_5.font fontWithSize:24];
        self.txt_6.font = [self.txt_6.font fontWithSize:24];
        
        self.lbl_PowerLevel.font = [self.lbl_PowerLevel.font fontWithSize:18];
        self.lbl_CurrentClamp.font = [self.lbl_CurrentClamp.font fontWithSize:19];
        self.lbl_PowerConfigurator.font=[self.lbl_PowerConfigurator.font fontWithSize:38];
        self.txt_BatterySelect.font = [self.txt_BatterySelect.font fontWithSize:24];
    }
}


@end
