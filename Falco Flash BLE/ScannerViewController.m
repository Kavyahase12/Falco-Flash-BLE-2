
//Completed  identifier.




/*
 * Copyright (c) 2015, Nordic Semiconductor
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the
 * documentation and/or other materials provided with the distribution.
 *
 * 3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this
 * software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 * ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
 * USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "ScannerViewController.h"
#import "ScannedPeripheral.h"
#import "UARTPeripheral.h"
#import "ViewController.h"
#import "customTableViewCell.h"
//#import "BluetoothManager.h"
#import "launcher.h"
#import "Utility.h"

BOOL connectionFlag,stateConnection;
BOOL timeStatusShowFlag,viewStopFlag;
CBPeripheral *connectPeripheral;
NSString *number,*iden1;
id identifier;
NSString * const dfuServiceUUIDString;
NSString * const ANCSServiceUUIDString;
NSMutableArray *array2;
NSMutableArray *identifierArray;

NSString * const dfuServiceUUIDString;
NSString * const ANCSServiceUUIDString;
NSTimer *timer;
typedef enum
{
    IDLE = 0,
    SCANNING,
    CONNECTED,
} ConnectionState;


@interface ScannerViewController ()

/*!
 * List of the peripherals shown on the table view. Peripheral are added to this list when it's discovered.
 * Only peripherals with bridgeServiceUUID in the advertisement packets are being displayed.
 */
@property ViewController *viewcontrol;
@property (retain,nonatomic) NSMutableArray *peripherals1,*rssiArray;
/*!
 * The timer is used to periodically reload table
 */
@property (strong, nonatomic) NSTimer *timer;

@property UARTPeripheral *currentPeripheral;

@property ConnectionState state;

@property (weak, nonatomic) IBOutlet UIView *emptyView;

- (void)timerFireMethod:(NSTimer *)timer;


@end

@implementation ScannerViewController
@synthesize viewcontrol;
@synthesize txCharacteristic,rxCharacteristic,peripheral;
@synthesize bluetoothManager;
@synthesize devicesTable;
@synthesize emptyView;
@synthesize filterUUID;
@synthesize peripherals1,rssiArray;
@synthesize timer;
@synthesize rssilabel;
@synthesize currentPeripheral;

- (void)viewDidLoad
{
    [super viewDidLoad];
  //  customTableViewCell  *cell = (customTableViewCell *)[devicesTable dequeueReusableCellWithIdentifier:@"customCell"];
    flagForOutlet=true;
   
    [self.devicesTable registerNib:[UINib nibWithNibName:@"customTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"customCell"];

    // Do any additional setup after loading the view.
    peripherals1 = [NSMutableArray arrayWithCapacity:8];
    array2 = [NSMutableArray arrayWithCapacity:8];
    identifierArray=[NSMutableArray arrayWithCapacity:8];
    devicesTable.delegate = self;
    devicesTable.dataSource = self;
    
    UIActivityIndicatorView* uiBusy = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    uiBusy.hidesWhenStopped = YES;
    [uiBusy startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:uiBusy];
    
    // We want the scanner to scan with dupliate keys (to refresh RRSI every second) so it has to be done using non-main queue
    
    dispatch_queue_t centralQueue = dispatch_queue_create("no.nordicsemi.ios.nrftoolbox", DISPATCH_QUEUE_SERIAL);
    
    bluetoothManager = [[CBCentralManager alloc] initWithDelegate:self queue:centralQueue];
    [self scanForPeripherals:YES];
    
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self scanForPeripherals:NO];
    @autoreleasepool
    {
        peripherals1 = [NSMutableArray arrayWithCapacity:8];
        array2 = [NSMutableArray arrayWithCapacity:8];
        identifierArray=[NSMutableArray arrayWithCapacity:8];
    }
}
-(void)viewDidAppear:(BOOL)animated
{
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [super viewWillDisappear:animated];
    [self scanForPeripherals:NO];
}

-(void)dataReceived
{
    NSLog(@"Received data");
    
    //  [[[UIApplication sharedApplication] delegate] performSelector:@selector(didReceiveData)];
    
    //    [self performSelector:@selector(didReceiveData) withObject:nil afterDelay:1.0];
    //    str11=[NSString stringWithFormat:@"%.2f",distance];
    //    str12 = [NSString stringWithFormat:@"%.1f",speed];
    receptionStartFlag=TRUE;
    startFlag=TRUE;
    timeStatusShowFlag=TRUE;
    
}

- (void) addConnectedPeripheral:(CBPeripheral *)peripheral
{
    ScannedPeripheral* sensor = [ScannedPeripheral initWithPeripheral:peripheral rssi:0 isPeripheralConnected:YES];
    [peripherals1 addObject:sensor];
}

#pragma mark Central Manager delegate methods

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    NSLog(@"Central Manager did update state");
    switch (self.state)
    {
        case IDLE:
            self.state = SCANNING;
            
            NSLog(@"Started scan ...");
            
            //            [self.cm scanForPeripheralsWithServices:nil options:nil];
            [self scanForPeripherals:YES];
            //            viewstatusController=true;
            
            
            break;
            
        case SCANNING:
            self.state = IDLE;
            
            NSLog(@"Stopped scan");
            
            [self.bluetoothManager stopScan];
            break;
            
        case CONNECTED:
            NSLog(@"Disconnect peripheral %@", self.currentPeripheral.peripheral.name);
            [self.bluetoothManager cancelPeripheralConnection:self.currentPeripheral.peripheral];
            break;
            
    }
    
}


/*!
 * @brief Starts scanning for peripherals with rscServiceUUID
 * @param enable If YES, this method will enable scanning for bridge devices, if NO it will stop scanning
 * @return 0 if success, -1 if Bluetooth Manager is not in CBCentralManagerStatePoweredOn state.
 */

- (int) scanForPeripherals:(BOOL)enable
{
    
    if (bluetoothManager.state != CBCentralManagerStatePoweredOn)
    {
        return YES;
    }
    
    // Scanner uses other queue to send events. We must edit UI in the main queue
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (enable)
        {
            
            NSDictionary  *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], CBCentralManagerScanOptionAllowDuplicatesKey, nil];
            
            if (filterUUID != nil)
            {
                [bluetoothManager scanForPeripheralsWithServices:@[ filterUUID ] options:options];
                
            }
            else
            {
                [bluetoothManager scanForPeripheralsWithServices:nil options:options];
                
            }
        }
        else
        {
            [timer invalidate];
            timer=nil;
            
            [bluetoothManager stopScan];
        }
    });
    
    return 0;
}

/*!
 * @brief This method is called periodically by the timer. It refreshes the devices list. Updates from Central Manager comes to fast and it's hard to select a device if refreshed from there.
 * @param timer the timer that has called the method
 */

- (id)init
{
    self = [super init];
    if (self) {
        array2 = [NSMutableArray new];
    }
    return self;
}

- (void)timerFireMethod:(NSTimer *)timer
{
    if ([peripherals1 count] > 0)
    {
        
        [devicesTable reloadData];
    }
    
}
-(void)onCallConnect
{
    if(flagForMethod==true)
    {
       
        
     //   [self centralManager:bluetoothManager didConnectPeripheral:connectPeripheral];
        
        
        // [self.delegate centralManager:bluetoothManager didPeripheralSelected:[[peripherals objectAtIndex:indexPath.row] peripheral]];
        //
    //    customTableViewCell  *cell = (customTableViewCell *)[devicesTable dequeueReusableCellWithIdentifier:@"customCell"];
      
        
        
        [bluetoothManager stopScan];
     
        
        NSString  *Motorid = [[NSNumber numberWithInt: myMotorID]stringValue];
        NSString *msg=@"You are connected to  ";
        
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@""
                                     message:[msg stringByAppendingString:Motorid]
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"OK"                                   style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        flagForMethod=false;

                                        UIViewController *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
                                        [self presentViewController:newView animated:YES completion:nil];

                                        //Handle your yes please button action here
                                    }];
        
        
        [alert addAction:yesButton];
               [self presentViewController:alert animated:YES completion:nil];
      
    }
    
    if(flagForDisconnect==true)
    {
        [self.bluetoothManager cancelPeripheralConnection:connectPeripheral];
//        UIViewController *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"tableview"];
//        [self presentViewController:newView animated:YES completion:nil];
        
        
//        [self dismissViewControllerAnimated:YES completion:nil];
       
//        launchFlag=true;
//        UIViewController *newView1 = [self.storyboard instantiateViewControllerWithIdentifier:@"launcherscreen"];
//        [self presentViewController:newView1 animated:YES completion:nil];
        
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.alpha = 1.0;
        [_scannerview addSubview:activityIndicator];
        activityIndicator.center = CGPointMake([[UIScreen mainScreen]bounds].size.width/2, [[UIScreen mainScreen]bounds].size.height/2);
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
//                       ^{
        
//                           for (NSInteger i = 1; i <= 3; i++)
//                           {
//                               [NSThread sleepForTimeInterval:0.2];
//                               dispatch_async(dispatch_get_main_queue(),
//                                              ^{
//                                                [activityIndicator startAnimating];//to start animating
//                                                  _scannerview.userInteractionEnabled = NO;
//                                                  
//                                                  
//                                              });
                           //}
//                           dispatch_async(dispatch_get_main_queue(),
//                                          ^{
//                                              [activityIndicator stopAnimating];
//                                                        _scannerview.userInteractionEnabled = YES;
                                              UIAlertController * alert = [UIAlertController
                                                                           alertControllerWithTitle:@"Disconnected"
                                                                           message:@"Thank you for using app"
                                                                           
                                                                           preferredStyle:UIAlertControllerStyleAlert];
                                              
                                              UIAlertAction* yesButton = [UIAlertAction
                                                                          actionWithTitle:@"OK"                                   style:UIAlertActionStyleDefault
                                                                          handler:^(UIAlertAction * action)
                                                                          {
                                                                              exit(-1);

                                                                            
                                                                              //Handle your yes please button action here
                                                                          }];
                                              
                                              
                                              [alert addAction:yesButton];
                                        [self presentViewController:alert animated:YES completion:nil];
//                                          });
//                           
//                       });
 
        // exit(0);
    }
    [self performSelector:@selector(onCallConnect) withObject:nil afterDelay:1];
    
    
    
}


- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    
    
    NSLog(@"Did discover peripheral %@", peripheral.name);
    
    NSArray *array1=[identifier   componentsSeparatedByString:@"<__NSConcreteUUID"];
    //
    iden1=[[array1  valueForKey:@"description"] componentsJoinedByString:@""];
    //
    
    NSRange range=[identifier rangeOfString:@">"];
    
    if (range.location != NSNotFound)
        
    {
        NSString *newString = [identifier substringWithRange:NSMakeRange(0, range.location+1)];
        
        iden1= [identifier stringByReplacingOccurrencesOfString:newString withString:@""];
    }
    else
    {
        NSLog(@"= is not found");
    }
    
    NSString *iden2=[[array1  valueForKey:@"description"] componentsJoinedByString:@""];
    //
    //    array2=[iden1   componentsSeparatedByString:@"0x"];
    //
    iden2=[[array2  valueForKey:@"description"] componentsJoinedByString:@""];
    
    NSLog(@"identi %@",peripheral.identifier);
    
    
    
    // Scanner uses other queue to send events. We must edit UI in the main queue
    
    if ([[advertisementData objectForKey:CBAdvertisementDataIsConnectable] boolValue])
    {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // Add the sensor to the list and reload deta set
            
            ScannedPeripheral* sensor = [ScannedPeripheral initWithPeripheral:peripheral rssi:RSSI.intValue isPeripheralConnected:NO];
            
            if (![peripherals1 containsObject:sensor])
            {
                [peripherals1 addObject:sensor];
                //  NSLog(@"4");
                
                
                identifier=[[NSString alloc] initWithFormat:@"%@",peripheral.identifier];
                [array2 addObject:identifier];
                
                timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
                
            }
            
            else
            {
                sensor = [peripherals1 objectAtIndex:[peripherals1 indexOfObject:sensor]];
                sensor.RSSI = RSSI.intValue;
                
                timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
                
            }
        });
    }
    
    
    
    if (connectionFlag==true)
    {
       
     //   self.currentPeripheral = [[UARTPeripheral alloc] initWithPeripheral:peripheral delegate:self];

        self.currentPeripheral = [[UARTPeripheral alloc] initWithPeripheral:peripheral delegate:self];

        if([self.currentPeripheral.peripheral isEqual:peripheral])
        {
            [self.bluetoothManager connectPeripheral:peripheral options:nil];
            
        }
        //   [self.bluetoothManager connectPeripheral:peripheral options:nil];
      //  [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    //    if ([self.currentPeripheral.peripheral isEqual:peripheral])
    //    {
    //         [self.currentPeripheral didConnect];
    //}
    
    
    
    
}



- (void) centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"Did connect peripheral %@", peripheral);
    

    //tsreceptionflag=true;
    
    NSString *message = @"Communication started";
    
    
    //sleep(10);
    
    receptionStartFlag=true;
    
    stateConnection=true;
    timerset=0;
    timerStopFlag=false;
    timerFlag=true;
  

    
    //   timeStatusShowFlag=TRUE;
    
    //    receptionStartFlag=true;
    //    timeStatusShowFlag=true;
   
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
//                                                                   message:message
//                                                            preferredStyle:UIAlertControllerStyleActionSheet];
//    
//    [self presentViewController:alert animated:YES completion:nil];
//    mytime=[[NSString alloc]init];
//    
//    int duration = 2 ; // duration in seconds
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//        [alert dismissViewControllerAnimated:YES completion:nil];
//    });
    self.currentPeripheral = [[UARTPeripheral alloc] initWithPeripheral:peripheral delegate:self];

    
    self.state = CONNECTED;
    
    if ([self.currentPeripheral.peripheral isEqual:peripheral])
    {
        [self.currentPeripheral didConnect];
        _wirelessImage.hidden=false;
        [bluetoothManager stopScan];
        // [self dismissViewControllerAnimated:YES completion:nil];
    }
   
    
}

-(void)dismissMyView
{
   // [self dismissViewControllerAnimated:YES completion:nil];

}
- (void) centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"Did disconnect peripheral %@", peripheral);
    
    receptionStartFlag=false;
    timeStatusShowFlag=false;
    tsreceptionflag=false;
    timerset=1;
    timerStopFlag=true;
    self.currentPeripheral = [[UARTPeripheral alloc] initWithPeripheral:peripheral delegate:self];
    

//    NSString *message = @"Communication closed";
//    
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
//                                                                   message:message
//                                                            preferredStyle:UIAlertControllerStyleActionSheet];
//    
//    [self presentViewController:alert animated:YES completion:nil];
//    
//    int duration = 3; // duration in seconds
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//        [alert dismissViewControllerAnimated:YES completion:nil];
//    });
//    
    
    self.state = IDLE;
    
    if ([self.currentPeripheral.peripheral isEqual:peripheral])
    {
        [self.currentPeripheral didDisconnect];
    }
}

#pragma mark Table View delegate methods

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //
    NSLog(@"TOUCH EVETNT");
     flagForOutlet=false;
    connectionFlag=true;
    connectPeripheral=[[peripherals1 objectAtIndex:indexPath.row] peripheral];
 //   [self centralManager:bluetoothManager didConnectPeripheral:connectPeripheral];
    NSLog(@"Tapped peripheral====%@",connectPeripheral);
    customTableViewCell  *cell = (customTableViewCell *)[devicesTable dequeueReusableCellWithIdentifier:@"customCell"];
    cell.btn_Connect.hidden=false;
    //    CBPeripheral* currentPer = [peripherals objectAtIndex:indexPath.row];
    //    [self.bluetoothManager connectPeripheral:currentPer options:nil];
    // Call delegate method
    
    
    
    
    // [self.delegate centralManager:bluetoothManager didPeripheralSelected:[[peripherals objectAtIndex:indexPath.row] peripheral]];
    //
   // [bluetoothManager stopScan];
   // [self dismissViewControllerAnimated:YES completion:nil];

    }

#pragma mark Table View Data Source delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return peripherals1.count;
    //  NSLog(@"7");
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    customTableViewCell  *cell = (customTableViewCell *)[devicesTable dequeueReusableCellWithIdentifier:@"customCell"];

    // Update sensor name
    
    if(cell==nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cell];
    }
    
    cell.selectionStyle = UITableViewCellStyleSubtitle;
    
    ScannedPeripheral *peripheral = [peripherals1 objectAtIndex:indexPath.row];
   // connectPeripheral=peripheral;
    //  ScannedPeripheral *peripheral1 = [rssiArray objectAtIndex:indexPath.row];
    //cell.textLabel.text = (peripheral.name ? peripheral.name : @"not available");
     cell.lbl_Peripheral.text = (peripheral.name ? peripheral.name : @"not available");
    
    
//    cell.detailTextLabel.text=[array2 objectAtIndex:indexPath.row];
    cell.lbl_Identifier.text=[array2 objectAtIndex:indexPath.row];

    //       cell.detailTextLabel.text=iden1;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
    
    
   // cell.imageView.image = [self getRSSIImage:peripheral.RSSI];
    
    cell.img_RSSIValue.image=[self getRSSIImage:peripheral.RSSI];
    [self onCallConnect];
    
    return cell;
}




//- (void) centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
//{
//    NSLog(@"Did disconnect peripheral %@", peripheral.name);
//
//       if ([self.currentPeripheral.peripheral isEqual:peripheral])
//    {
//        [self.currentPeripheral didDisconnect];
//    }
//}


-(UIImage *) getRSSIImage:(int)rssi
{
    // Update RSSI indicator
    UIImage* image;
    if (rssi < -90)
    {
        image = [UIImage imageNamed: @"Icon-84"];
    }
    else if (rssi < -70)
    {
        image = [UIImage imageNamed: @"Icon-87"];
    }
    else if (rssi < -50)
    {
        image = [UIImage imageNamed: @"Icon-85"];
    }
    else
    {
        image = [UIImage imageNamed: @"Icon-86"];
    }
    return image;
}

@end
