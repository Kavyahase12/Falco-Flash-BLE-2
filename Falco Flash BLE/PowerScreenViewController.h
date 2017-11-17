//
//  PowerScreenViewController.h
//  Falco Flash BLE
//
//  Created by Falco eMotors Pvt. Ltd. on 14/10/2016.
//  Copyright © 2016 Falco eMotors Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "UARTPeripheral.h"
#import <MessageUI/MFMailComposeViewController.h>

extern BOOL dataFlag;
@protocol senddataProtocol <NSObject>

-(void)sendDataToA:(NSArray *)array; //I am thinking my data is NSArray, you can use another object for store your information.

@end

@interface PowerScreenViewController : UIViewController<UITextViewDelegate,UITextFieldDelegate,MFMailComposeViewControllerDelegate>
{
    
    UIViewController *viewObject;
    
    UITextField *txt_voltage;
    UITextField *txt_current;
    
    
}
@property(nonatomic,assign)id delegate;

@property (strong, nonatomic) IBOutlet UILabel *TargetLable;

@property (strong, nonatomic) IBOutlet UITextField *txtpwrtraining;
@property (strong, nonatomic) IBOutlet UILabel *lbl_PowerTraining;

@property(strong,nonatomic) UIViewController *viewObject;
@property (weak, nonatomic) IBOutlet UIImageView *wirelessFlag;
@property (weak, nonatomic) IBOutlet UILabel *lblRegen;
@property (weak, nonatomic) IBOutlet UILabel *lblAssisting;
@property (strong, nonatomic) IBOutlet UILabel *lbl_Target;
@property (strong, nonatomic) IBOutlet UILabel *lbl_Achieved;

-(void)showpower;

@property (strong, nonatomic) IBOutlet UIView *SwipeView;

@property (strong, nonatomic) IBOutlet UIImageView *powerDisplayImageView;


@end
