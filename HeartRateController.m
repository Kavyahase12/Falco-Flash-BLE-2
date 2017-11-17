//
//  HeartRateController.m
//  Falco Flash BLE
//
//  Created by Falco eMotors Pvt. Ltd. on 04/01/2017.
//  Copyright © 2017 Falco eMotors Pvt. Ltd. All rights reserved.
//

#import "HeartRateController.h"
#import "UARTPeripheral.h"

@interface HeartRateController ()

@end

@implementation HeartRateController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UISwipeGestureRecognizer *swipeUpOrange = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(slideToUpWithGestureRecognizer:)];
    swipeUpOrange.direction = UISwipeGestureRecognizerDirectionUp;
    
    
    UISwipeGestureRecognizer *swipeDownOrange = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(slideToDownWithGestureRecognizer:)];
    swipeDownOrange.direction = UISwipeGestureRecognizerDirectionDown;
    
    [self.hrmView addGestureRecognizer:swipeUpOrange];
    [self.hrmView addGestureRecognizer:swipeDownOrange];
    UISwipeGestureRecognizer *swipeRightOrange = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(slideToRightWithGestureRecognizer:)];
    
    swipeRightOrange.direction=UISwipeGestureRecognizerDirectionRight;
    [self.hrmView addGestureRecognizer:swipeRightOrange];
    
    [self viewWillAppear:YES];

}
-(void)slideToRightWithGestureRecognizer:(UISwipeGestureRecognizer *)gestureRecognizer{
    [UIView animateWithDuration:0.5 animations:^{
        
        
        [self dismissViewControllerAnimated:NO completion:Nil];
    }];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
