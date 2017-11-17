//
//  customTableViewCell.m
//  Falco Flash BLE
//
//  Created by Falco eMotors Pvt. Ltd. on 25/01/2017.
//  Copyright © 2017 Falco eMotors Pvt. Ltd. All rights reserved.
//

#import "customTableViewCell.h"
bool flagForMethod,flagForDisconnect,flagForOutlet;
int tapCount=0;
@implementation customTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self actionOnOutlet];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)actionOnOutlet
{
    if (flagForOutlet==true)
    {
        _btn_Connect.hidden=true;
    }else
    {
        _btn_Connect.hidden=false;
    }
    
    
    [self performSelector:@selector(actionOnOutlet) withObject:nil afterDelay:1.0];

}

- (IBAction)onConnect:(id)sender
{
    tapCount++;
    if (tapCount%2==0)
    {
        flagForDisconnect=true;

        
    }else
    {
        flagForMethod=true;
        [_btn_Connect setTitle:@"Disconnect" forState:UIControlStateNormal];

    }
   
}



//-(id)initWithDelegate:(id)parent reuseIdentifier:(NSString *)reuseIdentifier
//{
    
 //   if (self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier])
 //   {
  //      self=(CustomCell*)[[[[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:nil options:nil] lastObject];
 //   }
    
  //  self.backgroundColor = [UIColor clearColor];
   // self.backgroundView = NULL;
   // self.selectedBackgroundView =NULL;
    
    //If you want any delegate methods and if cell have delegate protocol defined
   // self.delegate=parent;
    
    //return cell
   // return self;
//}

@end
