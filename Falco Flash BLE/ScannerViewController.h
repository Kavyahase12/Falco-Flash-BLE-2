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

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#include "ScannerDelegate.h"
#import "Utility.h"
#import <Foundation/Foundation.h>
#import "UARTPeripheral.h"
#import "ViewController.h"

extern BOOL connectionFlag,stateConnection;
extern BOOL timeStatusShowFlag,viewStopFlag;

//#import "BluetoothManager.h"
@interface ScannerViewController : UIViewController <CBCentralManagerDelegate, UITableViewDelegate, UITableViewDataSource,CBPeripheralDelegate>
{
    UIViewController *viewControl;
}
@property CBService *uartService;
@property CBCharacteristic *rxCharacteristic;
@property CBCharacteristic *txCharacteristic;

@property CBPeripheral *peripheral;
@property (nonatomic, strong) CBCharacteristic *uartRXCharacteristic;

@property id<CBPeripheralDelegate> delegate;
@property (readwrite) NSUInteger length;
@property (weak, nonatomic) IBOutlet UILabel *rssilabel;
@property (strong, nonatomic) IBOutlet UIView *scannerview;

@property (strong, nonatomic) CBCentralManager *bluetoothManager;
@property (weak, nonatomic) IBOutlet UITableView *devicesTable;
//@property (strong, nonatomic) id <ScannerDelegate> delegate;


@property (weak, nonatomic) IBOutlet UIImageView *wirelessImage;

@property (strong, nonatomic) CBUUID *filterUUID;
- (void)updateText:(NSString *)string;

/*!
 * Cancel button has been clicked
 */

- (IBAction)didCancelClicked:(id)sender;


@end
