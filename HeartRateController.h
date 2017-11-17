//
//  HeartRateController.h
//  Falco Flash BLE
//
//  Created by Falco eMotors Pvt. Ltd. on 04/01/2017.
//  Copyright © 2017 Falco eMotors Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "UARTPeripheral.h"

@interface HeartRateController : UIViewController
{
    
}
@property (strong, nonatomic) IBOutlet UIView *hrmView;
@property (strong, nonatomic) IBOutlet UIImageView *powerDisplayImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblAssisting;


@end
