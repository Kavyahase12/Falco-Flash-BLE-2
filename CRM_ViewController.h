//
//  CRM_ViewController.h
//  Falco Flash BLE
//
//  Created by Falco eMotors Pvt. Ltd. on 15/03/2017.
//  Copyright © 2017 Falco eMotors Pvt. Ltd. All rights reserved.
//

#import "ViewController.h"

@interface CRM_ViewController : ViewController<UIPickerViewDataSource,UIPickerViewDelegate>

{
    NSArray *pickerData;

}
@property (strong, nonatomic) IBOutlet UILabel *lbl_CRMSettings;
@property (strong, nonatomic) IBOutlet UIButton *btn_Close;
@property (strong, nonatomic) IBOutlet UILabel *lbl_Circumference;

@property (strong, nonatomic) IBOutlet UIButton *btn_Set;
@property (strong, nonatomic) IBOutlet UIPickerView *crmPickerView;

@end
