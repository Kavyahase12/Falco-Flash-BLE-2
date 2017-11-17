//
//  PowerScreenViewController.m
//  Falco Flash BLE
//
//  Created by Falco eMotors Pvt. Ltd. on 14/10/2016.
//  Copyright © 2016 Falco eMotors Pvt. Ltd. All rights reserved.
//

#import "PowerScreenViewController.h"
#import "UARTPeripheral.h"

int flag;
BOOL dataFlag;
@interface PowerScreenViewController ()
@property UARTPeripheral *currentPeripheral;
@end

@implementation PowerScreenViewController
@synthesize viewObject;
@synthesize txtpwrtraining,TargetLable;

@synthesize currentPeripheral = _currentPeripheral;
@synthesize delegate;

-(void)viewWillAppear:(BOOL)animated
{
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showpower];
    viewObject=[[ViewController alloc]init];
    txtpwrtraining.delegate=self;
    [self selfrecall];
    UISwipeGestureRecognizer *swipeUpOrange = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(slideToUpWithGestureRecognizer:)];
    swipeUpOrange.direction = UISwipeGestureRecognizerDirectionUp;
    
    
    UISwipeGestureRecognizer *swipeDownOrange = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(slideToDownWithGestureRecognizer:)];
    swipeDownOrange.direction = UISwipeGestureRecognizerDirectionDown;
    
    [self.SwipeView addGestureRecognizer:swipeUpOrange];
    [self.SwipeView addGestureRecognizer:swipeDownOrange];
    UISwipeGestureRecognizer *swipeRightOrange = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(slideToRightWithGestureRecognizer:)];
    
    swipeRightOrange.direction=UISwipeGestureRecognizerDirectionRight;
    [self.SwipeView addGestureRecognizer:swipeRightOrange];
    
    [self viewWillAppear:YES];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarButtonItemStylePlain;
    numberToolbar.items = @[[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelNumberPad)],
                            [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                            [[UIBarButtonItem alloc]initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)]];
    [numberToolbar sizeToFit];
    txtpwrtraining.inputAccessoryView = numberToolbar;
    
    
    
    NSString *myT1 = [[NSNumber numberWithDouble:targetpower] stringValue];
    txtpwrtraining.text=myT1;
    
    if (receptionStartFlag==true)
    {
        _wirelessFlag.hidden=false;
        [self selfCall];
        
    }
    [self adjustFontSizeOfLabel];
    
}

-(void)selfCall
{
    if (receptionStartFlag==true)
    {
        _wirelessFlag.hidden=false;
        countclose=0;
    }
    
    if (receptionStartFlag==false)
    {
        _wirelessFlag.hidden=true;
        
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

-(void)selfrecall
{
    
    switch (powerlevel)
    {
            
        case 0:
            self.powerDisplayImageView.image = [UIImage imageNamed:@"Icon-50"];
            _lblAssisting.text=@"";
            
            
            break;
            
            /***********case 1 to case 5 are used for positive powerlevel*************/
            
        case 1:
            self.powerDisplayImageView.image = [UIImage imageNamed:@"Icon-79"];
            _lblAssisting.text=@"Assisting";
            
            break;
        case 2:
            self.powerDisplayImageView.image = [UIImage imageNamed:@"Icon-80"];
            _lblAssisting.text=@"Assisting";
            
            break;
            
        case 3:
            self.powerDisplayImageView.image = [UIImage imageNamed:@"Icon-81"];
            _lblAssisting.text=@"Assisting";
            
            break;
            
        case 4:
            self.powerDisplayImageView.image = [UIImage imageNamed:@"Icon-82"];
            _lblAssisting.text=@"Assisting";
            
            break;
            
        case 5:
            self.powerDisplayImageView.image = [UIImage imageNamed:@"Icon-83"];
            _lblAssisting.text=@"Assisting";
            
            break;
            
            /************case -1 to case -4 are used for negative powerlevel***********/
            
        case -5:
            self.powerDisplayImageView.image = [UIImage imageNamed:@"Icon-58"];
            
            _lblAssisting.text=@"Regen";
            
            break;
            
        case -4:
            self.powerDisplayImageView.image = [UIImage imageNamed:@"Icon-57"];
            
            _lblAssisting.text=@"Regen";
            
            break;
            
        case -3:
            self.powerDisplayImageView.image = [UIImage imageNamed:@"Icon-56"];
            _lblAssisting.text=@"Regen";
            
            break;
            
        case -2:
            self.powerDisplayImageView.image = [UIImage imageNamed:@"Icon-55"];
            _lblAssisting.text=@"Regen";
            
            break;
            
        case -1:
            self.powerDisplayImageView.image = [UIImage imageNamed:@"Icon-54"];
            
            _lblAssisting.text=@"Regen";
            
            break;
            
            /** case 0 is used for set to 0 powerlevel ****/
            
        default:
            break;
            
    }
    
    [self performSelector:@selector(selfrecall) withObject:self afterDelay:0.250 ];
}


-(void)slideToUpWithGestureRecognizer:(UISwipeGestureRecognizer *)gestureRecognizer
{
    if (receptionStartFlag==true)
    {
        if(powerlevel<5)
        {
            powerlevel++;
        }
        
        [self selfrecall];
        
        //code for power level increment
        
        if( powerlevel>5 || powerlevel<=-5 ) //condition for checking power level in between +5 to -5 set power level max to 5
            powerlevel=5;
        
        if (powerlevel<=5)//if powerlevel value is less than 5 then increase power level
        {
            positive_power=powerlevel;
            positiveflagstatus=true;
            //         [_currentPeripheral positiveIncrement:@"544"];
        }
        
        if(powerlevel<=-1&&powerlevel>=-5) //if powerlevel value is negative then converted powerlevel in to positive and increased negative powerlevel
        {
            positive_power=(powerlevel);
            negative_power=true;
            
        }
        //        [_currentPeripheral positiveIncrement:@"544"];
        positiveflagstatus=true;
        //        [self positiveIncrement:@"867"];
        
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
-(void)slideToDownWithGestureRecognizer:(UISwipeGestureRecognizer *)gestureRecognizer
{
    if (receptionStartFlag==true)
    {
        // flagStatus=true;
        
        if(powerlevel>-5)
        {
            powerlevel--;
        }
        
        [self selfrecall];
        
        //code for power level decrement
        //        if(flagStatus==true)
        //        {
        
        if(powerlevel<=-5||powerlevel>5)//condition for checking power level in between +5 to -5 set power level max to -5
        {
            powerlevel=-5;
        }
        if(powerlevel>=0&&powerlevel<=5)//if powerlevel value is positive then increase power level and send power increase broadcast data
        {
            positive_power=powerlevel;
            positiveflagstatus=true;
            //            [_currentPeripheral positiveIncrement:@"544"];
            
            
            
            
            
        }
        
        if (powerlevel<=-1 &&powerlevel>= -5)   //if powerlevel value is negative  then decrease power level and send power decrease broadcast data
        {
            negative_power=(powerlevel);
            negativeflagstatus=true;
            //            [_currentPeripheral negativeDecrement:@"656"];
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




-(void)slideToRightWithGestureRecognizer:(UISwipeGestureRecognizer *)gestureRecognizer{
    [UIView animateWithDuration:0.5 animations:^{
        
        
        [self dismissViewControllerAnimated:NO completion:Nil];
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (receptionStartFlag==true)
    {
        
        
        NSString *text1 = txtpwrtraining.text;
        double value1 = [text1 doubleValue];
        targetpower= value1;
        NSString *myT = [[NSNumber numberWithDouble:value1] stringValue];
        txtpwrtraining.text=myT;
        if ((targetpower<5) ||(targetpower>3000))
        {
            if (targetpower<5)
            {
                targetpower=5;
                NSString *myT12 = [[NSNumber numberWithDouble:targetpower] stringValue];
                txtpwrtraining.text=myT12;
            }
            if (targetpower>3000)
            {
                targetpower=3000;
                NSString *myT12 = [[NSNumber numberWithDouble:targetpower] stringValue];
                txtpwrtraining.text=myT12;
            }
            UIAlertController * alert = [UIAlertController
                                         alertControllerWithTitle:@""
                                         message:@"Enter the value in range 5 to 3000"
                                         preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:@"OK"                                   style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action) {
                                            //Handle your yes please button action here
                                        }];
            
            
            [alert addAction:yesButton];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        }
        else
        {
            NSString *text2 = txtpwrtraining.text;
            double value2 = [text2 doubleValue];
            targetpower= value2;
        }
        
        NSString *myT1 = [[NSNumber numberWithDouble:targetpower] stringValue];
        txtpwrtraining.text=myT1;
        [self.txtpwrtraining setNeedsDisplay];
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

-(void)showpower
{
       
    
    TargetLable.text = [[NSNumber numberWithDouble:power] stringValue];
    
    if(current<=50.0)
    {
        TargetLable.text = [NSString stringWithFormat:@"%d",power];
    }
    
        [NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(repetMethod1) userInfo:nil repeats:NO];
    
    
}

-(void)repetMethod1
{
    [self showpower];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [txtpwrtraining resignFirstResponder];
    
    return YES;
}

-(void)cancelNumberPad
{
    [txtpwrtraining resignFirstResponder];
}

-(void)doneWithNumberPad
{
    [txtpwrtraining resignFirstResponder];
    
    
}
-(void)adjustFontSizeOfLabel{
    
    CGRect screenSize = [[UIScreen mainScreen]bounds];
    
    if (screenSize.size.height <= 480) {
        // iPhone 4
        self.TargetLable.font = [self.TargetLable.font fontWithSize:81];
        self.txtpwrtraining.font = [self.txtpwrtraining.font fontWithSize:81];
        self.lblAssisting.font = [self.txtpwrtraining.font fontWithSize:22];
        self.lbl_Target.font=[self.lbl_Target.font fontWithSize:20];
        self.lbl_PowerTraining.font=[self.lbl_PowerTraining.font fontWithSize:20];
        self.lbl_Achieved.font=[self.lbl_Achieved.font fontWithSize:20];
        
    } else if (screenSize.size.height <= 568) {
        // IPhone 5/5s/5c
        self.TargetLable.font = [self.TargetLable.font fontWithSize:101];
        self.txtpwrtraining.font = [self.txtpwrtraining.font fontWithSize:101];
        self.lblAssisting.font = [self.txtpwrtraining.font fontWithSize:25];
        
        self.lbl_Target.font=[self.lbl_Target.font fontWithSize:29];
        self.lbl_PowerTraining.font=[self.lbl_PowerTraining.font fontWithSize:31];
        self.lbl_Achieved.font=[self.lbl_Achieved.font fontWithSize:29];
        
        
    } else if (screenSize.size.width <= 375) {
        // iPhone 6
        self.TargetLable.font = [self.TargetLable.font fontWithSize:101];
        self.txtpwrtraining.font = [self.txtpwrtraining.font fontWithSize:101];
        self.lblAssisting.font = [self.txtpwrtraining.font fontWithSize:30];
        
        self.lbl_Target.font=[self.lbl_Target.font fontWithSize:34];
        self.lbl_PowerTraining.font=[self.lbl_PowerTraining.font fontWithSize:40];
        self.lbl_Achieved.font=[self.lbl_Achieved.font fontWithSize:34];
        
        
    } else if (screenSize.size.width <= 414) {
        // iPhone 6+
        self.TargetLable.font = [self.TargetLable.font fontWithSize:121];
        self.txtpwrtraining.font = [self.txtpwrtraining.font fontWithSize:121];
        self.lblAssisting.font = [self.txtpwrtraining.font fontWithSize:34];
        
        self.lbl_Target.font=[self.lbl_Target.font fontWithSize:38];
        self.lbl_PowerTraining.font=[self.lbl_PowerTraining.font fontWithSize:46];
        self.lbl_Achieved.font=[self.lbl_Achieved.font fontWithSize:38];
    }
    
}


@end
