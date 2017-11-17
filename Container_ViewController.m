//
//  Container_ViewController.m
//  Falco Flash BLE
//
//  Created by Falco eMotors Pvt. Ltd. on 14/03/2017.
//  Copyright © 2017 Falco eMotors Pvt. Ltd. All rights reserved.
//

#import "Container_ViewController.h"
#include "ViewController.h"
ViewController *viewObj;

@interface Container_ViewController ()
@property (weak, nonatomic) IBOutlet UIView *popUpView;
@end

@implementation Container_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)onMotorID:(id)sender
{
   // NSLog(@"HIIIIII");
   }

- (IBAction)onTSID:(id)sender
{
  //  [self dismissViewControllerAnimated:YES completion:Nil];

}

- (IBAction)onCRMID:(id)sender
{
   // [self dismissViewControllerAnimated:YES completion:Nil];

}

- (IBAction)onDeviceInfo:(id)sender
{
  //  [self dismissViewControllerAnimated:YES completion:Nil];

}

- (IBAction)onCloseView:(id)sender
{
 [self dismissViewControllerAnimated:YES completion:Nil];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *newVC = segue.destinationViewController;
    
    [Container_ViewController setPresentationStyleForSelfController:self presentingController:newVC];
}
//-(void)viewWillDisappear:(BOOL)animated
//{
//    [self dismissViewControllerAnimated:YES completion:Nil];
//
//}
+ (void)setPresentationStyleForSelfController:(UIViewController *)selfController presentingController:(UIViewController *)presentingController
{
    if ([NSProcessInfo instancesRespondToSelector:@selector(isOperatingSystemAtLeastVersion:)])
    {
        //iOS 8.0 and above
        presentingController.providesPresentationContextTransitionStyle = YES;
        presentingController.definesPresentationContext = YES;
        
        [presentingController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    }
    else
    {
        [selfController setModalPresentationStyle:UIModalPresentationCurrentContext];
        [selfController.navigationController setModalPresentationStyle:UIModalPresentationCurrentContext];
    }
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
