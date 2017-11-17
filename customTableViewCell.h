//
//  customTableViewCell.h
//  Falco Flash BLE
//
//  Created by Falco eMotors Pvt. Ltd. on 25/01/2017.
//  Copyright © 2017 Falco eMotors Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
extern bool flagForMethod,flagForDisconnect,flagForOutlet;
@interface customTableViewCell : UITableViewCell
{
    
}

@property (strong, nonatomic) IBOutlet UIButton *btn_Connect;
@property (strong, nonatomic) IBOutlet UILabel *lbl_Identifier;
@property (strong, nonatomic) IBOutlet UILabel *lbl_Peripheral;
@property (strong, nonatomic) IBOutlet UIImageView *img_RSSIValue;


@end
