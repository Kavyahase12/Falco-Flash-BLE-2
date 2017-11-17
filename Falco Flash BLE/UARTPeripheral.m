//
//  UARTPeripheral.m
//  nRF UART
//
//  Created by Ole Morten on 1/12/13.
//  Copyright (c) 2013 Nordic Semiconductor. All rights reserved.
//

#import "UARTPeripheral.h"
#import "ViewController.h"
//BLEMessage receivedData;
CBPeripheral *myperipheral;
CBCharacteristic *tsrxCharacteristic;
CBCharacteristic *c;
CBCentralManager *tscm;
CBCharacteristic *rxChar,*txChar;
int CRM=2075;
CBService *tsservice;
float avgspeed1S,avgspeed2S;
NSData *data;
double speedPast;
double whpkm=0,whpmile=0;
NSInteger crmvalue1;
int current,voltageDec;
int power,index_Byte;
int displayBarDec,regenFlag;
int temperature,hallcode;
BOOL iskphselected,positiveflagstatus,negativeflagstatus,manufacturingflag,receptionStartFlag,offroadscreenStatus=true,flagForMotorTypeStatus;
double targetpower=400,speed;
BOOL batteryStatusFlag,firmwareCheck;
double userEdit,whremain,whremainForMile;
BOOL batteryCapacityFlag=false;
int tspeed=0;
int tdelay;
int tdelayoff;
int tbasetorque;
int tdropout;
int tflipaxel;
int tsturnon;
int torquemultiply;
BOOL flagForConnectMsg=false;
int powerlevel=0;
float avgdstncinmph;
NSString *mytime;
int timerset;
BOOL kphStateFlag,mphStateFlag,dropoutFlag,screen_load,allscreenload;
int seconds,minutes,hours;
///////////////////////////Manufacturing///////////////////////////////
int MotorIDFrame,myMotorID,FirmwareNumber,Deci_FirmwareNumber,FirmwareFrame,deci_FirmwareFrame,Voltage,deci_Voltage,TS_ID,deci_TS_ID,deci_FirmwareFrame1,deci_FirmwareFrame2,deci_FirmwareFrame3,batteryvalue,dec_batteryvalue,motoriderr,iderr;
BOOL manu_Firmware,manu_MotorID,manu_TSID,manu_Voltage,receptionFlag;
NSString *myresult,*m6,*vtgBroadcastValue;
int dec_myChar,dec_revisionNo,myChar,revisionNo,voltageTarget,MotorTarget,TorqueTarget;
BOOL motorTransmitFlag=true,motorReceiveFlag,tsTransmitFlag,tsReceiveFlag,firmwareTransmitFlag,firmwareReceiveFlag,voltageTransmitFlag,voltageReceiveFlag,voltageBroadcast,OffRoadStatus,OnRoadStatus,batterySelect;
int DATAByte1,DATAByte2,DATAByte3,DATAByte4,DATAByte5,DATAByte6,DATAByte7,DATAByte8;
NSData *str;
//////////////////////////Motor Parameter///////////////////////////////
int TSRaw,TSRawDecimal,TSRectified, TSRectifiedDecimal,TSPeak,  TSPeakDecimal, TSFinal,  TSFinalDecimal ;
BOOL  tsreceptionflag,tsDataFlag;///////////////////////////Main SCREEN///////////////////////////
int valuePower,positive_power=0,negative_power=0;
////////////////////////////Motor Control////////////////////////
int motor_frame_id,motor_frame_dec,frame_Type,dec_frame_type,mem_Turnonspeed,dec_mem_Turnonspeed,mem_Basetorque,dec_mem_Basetorque,mem_Flipaxle,dec_mem_Flipaxle,mem_tsturnon,dec_mem_tsturnon,mem_Turnondelay,dec_mem_Turnondelay,mem_Turnoffdelay,dec_mem_Turnoffdelay,mem_Tmultiplier,dec_mem_Tmultiplier,mem_Dropoutdisp,dec_mem_Dropoutdisp,sensorValueCheck,sensorValueCheckRead;
BOOL broadcastStatus1,powerbroadcastStatus,memoryStatus,motorcontrolscreenstatus,memoryReadDoneFlag=false,memoryReadDoneFlag1=false;
int turnonspeed,turnondelay, basetorque, turnoffdelay, flipaxle, tmultiplier, dropoutdisp,tsTurnOn;


////////////////////////////Power control/////////////////////////
BOOL flag_Memoryread=false,flag_Broadcast=false,flagpwr;
BOOL motorTypeTransmitStatus,motorTypeReceiveStatus,batterySelectFlagD,motorTypeSelectFlagD,memoryReadFlagD;
int wattIndex,winding,armType,swipecount;
NSString *motorTypeString;
NSArray *arrwatt;
NSArray *arrmwinding;
NSArray *arrmtype;
NSString *stAssist1,*stAssist2,*stAssist3,*stAssist4,*stAssist5,*stAssist6,*stRegen1,*stRegen2,*stRegen3,*stRegen4,*stRegen5;
BOOL assistBroadcastStatus,regenBroadcastStatus,memoryStatusClampCurrent=false,powerScreenflag;
int8_t *clamplevel_Regen,*clamplevel_Assist;
NSString *assistBroadcastValue,*regenBroadcastValue;
id assist1,assist2,assist3,assist4,assist5,assistT;
id assist_value;
id wattString,windingString,typeString,updateFirmware;
int battery_36,battery_48;
NSInteger segmentValue;
//NSArray *clamp_level;
NSInteger index1,index2,index3,index4,index5,index6,rindex1,rindex2,rindex3,rindex4,rindex5;
int assist_l1,assist_l2,assist_l3,assist_l4,assist_l5,assist_t,regen_l1,regen_l2,regen_l3,regen_l4,regen_l5;
NSString *motorData,*tsData;
bool rxRecpPause;

NSString *batteryResult;
NSString *StoreBtryValue;


@interface UARTPeripheral ()
@property CBService *uartService;
@property CBCharacteristic *rxCharacteristic;
@property CBCharacteristic *txCharacteristic;
@property CBCharacteristic *tsrxCharacteristic;
@property CBCharacteristic *tstxCharacteristic;

@end

@implementation UARTPeripheral
@synthesize peripheral = _peripheral;
@synthesize delegate = _delegate;
@synthesize uartService = _uartService;
@synthesize rxCharacteristic = _rxCharacteristic;
@synthesize txCharacteristic = _txCharacteristic;
@synthesize tsrxCharacteristic;

+ (CBUUID *) uartServiceUUID
{
    return [CBUUID UUIDWithString:@"6e400001-b5a3-f393-e0a9-e50e24dcca9e"];
}

+ (CBUUID *) txCharacteristicUUID
{
    return [CBUUID UUIDWithString:@"6e400002-b5a3-f393-e0a9-e50e24dcca9e"];
}

+ (CBUUID *) rxCharacteristicUUID
{
    return [CBUUID UUIDWithString:@"6e400003-b5a3-f393-e0a9-e50e24dcca9e"];
}

+ (CBUUID *) torquerxCharacteristicUUID
{
    return [CBUUID UUIDWithString:@"00002A37-0000-1000-8000-00805f9b34fb"];
}

+ (CBUUID *) deviceInformationServiceUUID
{
    motorData=@"180A";
    return [CBUUID UUIDWithString:@"180A"];
}
+ (CBUUID *) torqueInformationServiceUUID
{
    tsData=@"180D";
    return [CBUUID UUIDWithString:@"180D"];
}

+ (CBUUID *) hardwareRevisionStringUUID
{
    return [CBUUID UUIDWithString:@"2A37"];
}

- (UARTPeripheral *) initWithPeripheral:(CBPeripheral*)peripheral delegate:(id<UARTPeripheralDelegate>) delegate
{
    if (self = [super init])
    {
        _peripheral = peripheral;
        _peripheral.delegate = self;
        _delegate = delegate;
        myperipheral=peripheral;
    }
    return self;
    
}

- (void) didConnect
{
    
    
    [_peripheral discoverServices:@[self.class.uartServiceUUID, self.class.deviceInformationServiceUUID]];
    
    [_peripheral discoverServices:@[self.class.uartServiceUUID, self.class.torqueInformationServiceUUID]];
    
    
    NSLog(@"Did start service discovery.");
    
}

- (void) didTSConnect
{
    NSLog(@" discovery start ,,,.........");
    
    
}



- (void) peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error)
    {
        NSLog(@"2");
        NSLog(@"Error discovering services: %@", error);
        return;
    }
    for (CBService *service in peripheral.services) {
        NSLog(@"Discovered service: %@", service.UUID);
        [peripheral discoverCharacteristics:nil forService:service];
    }
    
    
    
}


- (void) peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    tsservice=service;
    
    if (error)
    {
        NSLog(@"Error discovering characteristics: %@", error);
        receptionStartFlag=false;
        NSLog(@"3");
        return;
        
    }
    
    
    
    for (CBCharacteristic *d in [tsservice characteristics])
    {
        
        if ([d.UUID isEqual:self.class.torquerxCharacteristicUUID])
        {
            //  if ([c.UUID isEqual:[CBUUID UUIDWithString:@"2A27"]]) { // 2
            
            NSLog(@"Found ts RX characteristic");
            self.tsrxCharacteristic = d;
            receptionStartFlag=true;
            //
            rxRecpPause=true;
            rxChar=tsrxCharacteristic;
            [self.peripheral setNotifyValue:YES forCharacteristic:d];
            [self.peripheral readValueForCharacteristic:d];
            
        }
        
        
        
        if ([d.UUID isEqual:self.class.rxCharacteristicUUID])
        {
            //  if ([c.UUID isEqual:[CBUUID UUIDWithString:@"2A27"]]) { // 2
            
            NSLog(@"Found RX characteristic");
            self.rxCharacteristic = d;
            receptionStartFlag=true;
            //
            rxRecpPause=true;
            rxChar=_rxCharacteristic;
            [self.peripheral setNotifyValue:YES forCharacteristic:d];
            [self.peripheral readValueForCharacteristic:d];
            //}
            
            
            
            
        }
        
        
        
        if ([d.UUID isEqual:self.class.txCharacteristicUUID])
        {
            NSLog(@"Found TX characteristic");
            self.txCharacteristic = d;
            txChar=_txCharacteristic;
            
            [self.peripheral setNotifyValue:YES forCharacteristic:d];
            
            
        }
        
    }
    [self rxdatareception];
}




-(void)tsrxreception
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0), ^{ // 1
        if (screen_load==true) {
            
            
            NSData *dataRec1=tsrxCharacteristic.value;
            
            
            Byte byteData1[[dataRec1 length]];//(Byte*)malloc(len);
            
            [dataRec1 getBytes:&byteData1];
            
            NSLog(@"Torque Received data on a characteristic.%@",dataRec1);
            
            
            
            if (byteData1[0]==132)
            {
                if(!(byteData1[0]==01)&&!(byteData1[0]==02)&&!(byteData1[0]==00))
                {
                    tsDataFlag=true;
                    
                    tsreceptionflag=true;
                    
                    TSRaw = (byteData1[1]*0x0100)+(byteData1[2]);
                    
                    
                    TSRawDecimal = ((TSRaw/0x0A)*10)+(TSRaw % 0x0A);
                    
                    
                    TSRectified = (byteData1[3]*0x0100)+(byteData1[4]);
                    TSRectifiedDecimal = ((TSRectified/0x0A)*10)+(TSRectified % 0x0A);
                    
                    TSPeak = (byteData1[5]*0x0100)+(byteData1[6]);
                    TSPeakDecimal = ((TSPeak/0x0A)*10)+(TSPeak % 0x0A);
                    
                    TSFinal = (byteData1[7]);
                    TSFinalDecimal = ((TSFinal/0x0A)*10)+(TSFinal % 0x0A);
                    
                }
                
                
                
            }
            else
            {
                tsDataFlag=false;
            }
            
            
        }
        
    });
}
- (void) rxdatareception
{
    if (screen_load==true)
    {
        [self tsrxreception];
    }
    
    
    
    if (batteryStatusFlag==true)
    {
        int8_t bytes2[] ={121,00,00,00,00,00,00,00,00,00,00,00,00};
        
        NSData *data2 = [NSData dataWithBytes:bytes2 length:sizeof(bytes2)];
        // NSLog(@"MIDDLE %@", data2);
        if ((txChar.properties & CBCharacteristicPropertyWrite) != 0)
        {
            [myperipheral writeValue:data2 forCharacteristic:txChar
                                type:CBCharacteristicWriteWithResponse];
            
            
        }
        else if ((txChar.properties & CBCharacteristicPropertyWrite) != 0)
        {
            [myperipheral writeValue:data2 forCharacteristic:txChar type:CBCharacteristicWriteWithResponse];
        }
        else
        {
            NSLog(@"No write property on TX characteristic, %lu.", (unsigned long)txChar.properties);
        }
        
        batteryStatusFlag=false;
    }
    
    if (firmwareCheck==true)
    {
        
        int8_t bytes3[] ={133,02,00,00,00,00,00,00,00,00,00,00,00};
        NSData *data3 = [NSData dataWithBytes:bytes3 length:sizeof(bytes3)];
        
        if ((txChar.properties & CBCharacteristicPropertyWrite) != 0)
        {
            [myperipheral writeValue:data3 forCharacteristic:txChar
                                type:CBCharacteristicWriteWithResponse];
            
            
        }
        
        NSLog(@"Firmware string==%@",updateFirmware);
        
        firmwareCheck=false;
    }
    
    
    int RPMIn_Decimle;
    NSData *dataRec=_rxCharacteristic.value;
    
    
    Byte byteData[[dataRec length]];//(Byte*)malloc(len);
    
    [dataRec getBytes:&byteData];
    
    index_Byte=byteData[1];
    
    
    if(!((byteData[1] == 149 && byteData[2] == 0x1)
         || (byteData[1] == 149 && byteData[2] == 0x2 )
         || (byteData[1] == 149 && byteData[2] == 0x3 )
         || (byteData[1] == 153)
         || (byteData[1] == 149 && byteData[2] == 0x4 )
         || (byteData[1] == 149 && byteData[2] == 0x5 )
         || (byteData[1] == 151 && byteData[2] == 0x2 )
         || (byteData[1] == 151 && byteData[3] == 0x3 )
         || (byteData[1] == 151 && byteData[4] == 0x4 )
         || (byteData[1] == 133 && byteData[2] == 0x0a)
         || (byteData[1] == 134 && byteData[2] == 0x2)
         || (byteData[1] == 153 && byteData[2] == 0x2)
         || (byteData[1] == 121 )
         || (byteData[0] == 132)))
      {
        int recv_RPM=(byteData[0]*0x0100)+(byteData[1]);
        
        RPMIn_Decimle=((recv_RPM/0x0A)*10)+(recv_RPM % 0x0A);
        
        NSLog(@"CRM is %d",CRM);
        
     
        if (CRM==0)
        {
            CRM=2075;
        }
        speed= (double)(CRM * RPMIn_Decimle * 60)/1000000;
        
        NSLog(@"Speed is %f",speed);
        
        
        if((speed>300.0)||(speed<0))
        {
            speed=0.0;
            
        }
        
        if (speedmph<0)
        {
            speedmph=0.0;
        }
        speedPast=speed;
        
        
        
        voltageDec = ((byteData[2]/0x0A)*10)+(byteData[2]% 0x0A);
        
        if(voltageDec>55)
        {
            voltageDec=0;
            
        }
        
        temperature= ((byteData[6]/0x0A)*10)+(byteData[6] % 0x0A);
        
        
        switch (temperature)
        {
            case 255:
                temperature=-1;
                break;
            case 254:
                temperature=-2;
                break;
            case 253:
                temperature=-3;
                break;
            case 252:
                temperature=-4;
                break;
            case 251:
                temperature=-5;
                break;
                
        }
        
        hallcode = ((byteData[5]/0x0A)*10)+(byteData[5] % 0x0A);
      
          if(current>=40)
          {
              current=0;
              
          }
          
        current = ((byteData[7]/0x0A)*10)+(byteData[7] % 0x0A);
         
        displayBarDec = ((byteData[3]/0x0A)*10)+(byteData[3]% 0x0A);
        
        regenFlag = ((byteData[4]/0x0A)*10)+(byteData[4]% 0x0A);
        
    }
    else
    {
        speed=speedPast;
    }
    
    ///////////////////////////Motor Id///////////////////////////////
    
    if(byteData[1]==153 )
    {
        
        if(motorReceiveFlag==true)
        {
            MotorIDFrame = (byteData[2]);
            myMotorID = ((MotorIDFrame/0x0A)*10)+(MotorIDFrame % 0x0A);
            
            NSLog(@"Motorrrr id %d",MotorIDFrame);
            manu_MotorID=true;
            //  motorReceiveFlag=false;
        }
    }
    
    /////////////////////Manufacturing Screen/////////////////////
    
    
    arrwatt=[NSArray arrayWithObjects:@" ",@"250WATT",@"500WATT",@"750WATT",@"1000WATT",@"1500WATT",@"750WATTPLUS", nil];
    
    arrmwinding= [NSArray arrayWithObjects:@" ",@"14T",@"18T",@"27T",@"37T",@"57T", nil];
    arrmtype= [NSArray arrayWithObjects:@" ",@"ULTSW",@"ULTSW",@"HSW",@"SSW",@"USSW", nil];
    
    
    if(byteData[1]==133)
    {
        
        //FirmwareNumber = (byteData[2]);
        
        Deci_FirmwareNumber = ((byteData[2]/0x0A)*10)+(byteData[2]% 0x0A);
        NSString *stringWatt=[NSString stringWithFormat:@"%02d",Deci_FirmwareNumber];
        int FirmwareFrame2 =  (byteData[3]);
        
        deci_FirmwareFrame2=(( FirmwareFrame2/0x0A)*10)+( FirmwareFrame2% 0x0A);
        //   NSLog(@"DECIFIRMWARE2 %@",stringWatt);
        
        
        NSString *stringWinding=[NSString stringWithFormat:@"%02d",deci_FirmwareFrame2];
        
        int FirmwareFrame3 =  (byteData[4]);
        deci_FirmwareFrame3=(( FirmwareFrame3/0x0A)*10)+( FirmwareFrame3% 0x0A);
        
        NSString *stringType=[NSString stringWithFormat:@"%02d",deci_FirmwareFrame3];
        
        NSString  *myresult1=[stringWatt stringByAppendingString:[@"" stringByAppendingString:[stringWinding stringByAppendingString:[@"" stringByAppendingString:stringType]]]];
        
        
        updateFirmware=myresult1;
        
        revisionNo =  (byteData[5]);
        
        dec_revisionNo = (( revisionNo/0x0A)*10)+( revisionNo% 0x0A);
        
        myChar =  (byteData[6]);
        
        char rev;
        
        switch (revisionNo)
        {
            case 0:
                break;
                
            case 1:
                
                dec_myChar = (( myChar/0x0A)*10)+( myChar% 0x0A);
                
                rev = (char)dec_myChar;//Encoding.ASCII.GetBytes(temprev)
                
                NSString *strrev=[NSString stringWithFormat:@"%c",rev];
                
                myresult = [myresult1 stringByAppendingString:[@" REV." stringByAppendingString:strrev]];
                
                break;
                
        }
        manu_Firmware=true;
        firmwareReceiveFlag=false;
        
    }
    
    
    ///////////////////////////Voltage///////////////////////////////
    
    if(byteData[1]==134 && voltageReceiveFlag==true)
    {
        
        Voltage = (byteData[3]);
        deci_Voltage = ((Voltage/0x0A)*10)+(Voltage % 0x0A);
        //  NSLog(@"Voltage id %d",deci_Voltage);
        manu_Voltage=true;
        voltageReceiveFlag=false;
    }
    ///////////////////////////Battery///////////////////////////////
    
    if(byteData[1]==121)
    {
        
        batteryvalue = (byteData[2]);
        batterySelectFlagD=true;
        //            dec_batteryvalue = ((batteryvalue/0x0A)*10)+(batteryvalue % 0x0A);
        //            if (batteryvalue==1)
        //            {
        //                battery_36=1;
        //                NSLog(@"BAttery selection==%d",batteryvalue);
        //
        //            }
        //            if (batteryvalue==2)
        //            {
        //                battery_48=2;
        //                NSLog(@"BAttery selection==%d",batteryvalue);
        //            }
        //            batterySelect=false;
    }
    
    
    ///////////////////////////TS Id///////////////////////////////
    
    if(byteData[1]==153 )
    {
        if(tsReceiveFlag==true)
        {
            TS_ID = (byteData[2]);
            deci_TS_ID = ((TS_ID/0x0A)*10)+(TS_ID % 0x0A);
            NSLog(@"TS id %d",deci_TS_ID);
            manu_TSID=true;
            // tsReceiveFlag=false;
        }
        
    }
    /////////////////////////// Motor Control//////////////////////
    
    if (byteData[1]==149&&byteData[2]==1)
    {
        
        mem_Turnonspeed= byteData[3];
        dec_mem_Turnonspeed=((mem_Turnonspeed/0x0A)*10)+(mem_Turnonspeed % 0x0A);
        
        mem_Basetorque=byteData[4];
        dec_mem_Basetorque=((mem_Basetorque/0x0A)*10)+(mem_Basetorque % 0x0A);
        
        mem_Flipaxle=byteData[5];
        dec_mem_Flipaxle=((mem_Flipaxle/0x0A)*10)+(mem_Flipaxle % 0x0A);
        
        mem_tsturnon=byteData[6];
        dec_mem_tsturnon=((mem_tsturnon/0x0A)*10)+(mem_tsturnon % 0x0A);
        
        
        sensorValueCheck=byteData[7];
        sensorValueCheckRead = ((sensorValueCheck/0x0A)*10)+(sensorValueCheck % 0x0A);
        
        
        memoryReadDoneFlag=true;
        
    }
    if (byteData[1]==149&&byteData[2]==2)
    {
        
        mem_Turnondelay= byteData[3];
        dec_mem_Turnondelay=((mem_Turnondelay/0x0A)*10)+(mem_Turnondelay % 0x0A);
        
        mem_Turnoffdelay= byteData[4];
        dec_mem_Turnoffdelay=((mem_Turnoffdelay/0x0A)*10)+(mem_Turnoffdelay % 0x0A);
        
        mem_Tmultiplier= byteData[5];
        dec_mem_Tmultiplier=((mem_Tmultiplier/0x0A)*10)+(mem_Tmultiplier % 0x0A);
        
        mem_Dropoutdisp= byteData[6];
        dec_mem_Dropoutdisp=((mem_Dropoutdisp/0x0A)*10)+(mem_Dropoutdisp % 0x0A);
        
        
        memoryReadDoneFlag1=true;
    }
    
    ///////////Power Control//////////////////////////////////
    if (flagpwr==true)
    {
        
        
        if(byteData[1]==151 )
        {
            
            //  arrwatt=[NSArray arrayWithObjects:@"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0", @"0",nil];
            wattIndex=byteData[2];
            winding=byteData[3];
            armType=byteData[4];
            
            //  wattString=[arrwatt objectAtIndex:wattIndex];
            if([arrwatt count] > 0 && [arrwatt count] > wattIndex){
                
                wattString=[arrwatt objectAtIndex:wattIndex];
                
            }
            else{
                
                //Array is empty,handle as you needed
                
            }
            NSLog(@"Watt String=%@",wattString);
            
            windingString=[arrmwinding objectAtIndex:winding];
            NSLog(@"Winding String=%@",windingString);
            
            typeString=[arrmtype objectAtIndex:armType];
            NSLog(@"Type String=%@",typeString);
            
            
            
            NSString *stringWatt=[NSString stringWithFormat:@"%@",wattString];
            NSString *stringWinding=[NSString stringWithFormat:@"%@",windingString];
            NSString *stringType=[NSString stringWithFormat:@"%@",typeString];
            
            
            motorTypeSelectFlagD=true;
            motorTypeString=[stringWatt stringByAppendingString:[@"-" stringByAppendingString:[stringWinding stringByAppendingString:[@"-" stringByAppendingString:stringType]]]];
            
            NSLog(@"motor string issss %d",DATAByte1);
            
            
        }
    }
    if(byteData[1]==149 )
    {
        
        if(byteData[2]==3)
        {
            
            
            assist_l1=byteData[3];
            assist_l2=byteData[4];
            assist_l3=byteData[5];
            assist_l4=byteData[6];
            assist_l5=byteData[7];
            
            
        }
        if(byteData[2]==5)
        {
            regen_l5=byteData[3];
        }
        
        /////////////////////////Turbo & Regen Memory Read ////////////////////
        if (byteData[2]==4) {
            
            assist_t=byteData[3];
            regen_l1=byteData[4];
            regen_l2=byteData[5];
            regen_l3=byteData[6];
            regen_l4=byteData[7];
        }
        memoryReadFlagD=true;
    }
    
    
    
    NSLog(@"Received data on a characteristic.%@",dataRec);
    
    
    //  [self.delegate didReceiveData];
    
    //}
    
    if (receptionFlag==true)
    {
        
        if (rxRecpPause==true)
        {
            [self performSelector:@selector(rxdatareception) withObject:nil afterDelay:0.1];
            
            //
            //           //
        }
    }
    // }
}

@end

