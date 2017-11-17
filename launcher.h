//
//  launcher.h
//  Falco Flash BLE
//
//  Created by Falco eMotors Pvt. Ltd. on 05/01/2017.
//  Copyright © 2017 Falco eMotors Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
extern BOOL launchFlag;
@interface launcher : UIViewController
{
    
}
@property (strong, nonatomic) IBOutlet UIButton *btn_Outdoor;
@property (strong, nonatomic) IBOutlet UIButton *btn_Indoor;
- (IBAction)onOutdoorBtn:(id)sender;
- (IBAction)onIndoorBtn:(id)sender;

@end
