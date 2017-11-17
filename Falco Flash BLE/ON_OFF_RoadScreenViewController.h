//
//  ON_OFF_RoadScreenViewController.h
//  Falco Flash BLE
//
//  Created by Falco eMotors Pvt. Ltd. on 15/10/2016.
//  Copyright © 2016 Falco eMotors Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UARTPeripheral.h"

@interface ON_OFF_RoadScreenViewController : UIViewController<UITextViewDelegate, CBPeripheralDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *powelevel0;

@property (strong, nonatomic) IBOutlet UIImageView *powelevel1;
@property (strong, nonatomic) IBOutlet UIImageView *powelevel2;
@property (strong, nonatomic) IBOutlet UIImageView *powelevel3;
@property (strong, nonatomic) IBOutlet UIImageView *powelevel4;
@property (strong, nonatomic) IBOutlet UIImageView *powelevel5;
@property (strong, nonatomic) IBOutlet UIImageView *powelevel6;
@property (strong, nonatomic) IBOutlet UIImageView *powelevel7;
@property (strong, nonatomic) IBOutlet UIImageView *powelevel8;

//-------------- Power Level -ve -------------------



@property (weak, nonatomic) IBOutlet UIImageView *batteryImageView;
@property (weak, nonatomic) IBOutlet UIImageView *powerLavelImageView;


@property (strong, nonatomic) IBOutlet UILabel *unLockLabel;

@property (strong, nonatomic) IBOutlet UILabel *lockLabel;


- (IBAction)unLockedButton:(id)sender;


-(void)displayWingsMethod;


@property (strong, nonatomic) IBOutlet UIView *myView1;



@property (strong, nonatomic) IBOutlet UIImageView *img_Battery;
@property (strong, nonatomic) IBOutlet UIImageView *lockImage;
@property (strong, nonatomic) IBOutlet UIButton *imgButton_Unlock;



@property (strong, nonatomic) IBOutlet UIImageView *imgWing;

@property (strong, nonatomic) IBOutlet UIImageView *wireless4image;
@end

