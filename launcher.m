//
//  launcher.m
//  Falco Flash BLE
//
//  Created by Falco eMotors Pvt. Ltd. on 05/01/2017.
//  Copyright © 2017 Falco eMotors Pvt. Ltd. All rights reserved.
//

#import "launcher.h"
#import "UARTPeripheral.h"
BOOL launchFlag=true;


@interface launcher ()

@end

@implementation launcher

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    if (launchFlag==true) {
        
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissAllViewControllers:) name:@"YourDismissAllViewControllersIdentifier" object:nil];
        
//        launchFlag=false;
    }
    
  //  [self.btn_Outdoor setImage:[UIImage imageNamed:stretchImage] forState:UIControlStateNormal];
    // Do any additional setup after loading the view.
}
//-(void)viewWillAppear:(BOOL)animated
//{
//    receptionStartFlag=false;
//    [[self.btn_Outdoor imageView] setContentMode: UIViewContentModeScaleAspectFit];
//    
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

    
    // listen to any requests to dismiss all stacked view controllers

    // the remainder of viewDidLoad ...

// this method gets called whenever a notification is posted to dismiss all view controllers
- (void)dismissAllViewControllers:(NSNotification *)notification {
    // dismiss all view controllers in the navigation stack
    [self dismissViewControllerAnimated:YES completion:^{}];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onOutdoorBtn:(id)sender {
   
//    launchFlag=true;
}

- (IBAction)onIndoorBtn:(id)sender
{
    
    
}
@end
