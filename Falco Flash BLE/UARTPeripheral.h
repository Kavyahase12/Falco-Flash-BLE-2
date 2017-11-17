//
//  UARTPeripheral.h
//  nRF UART
//
//  Created by Ole Morten on 1/12/13.
//  Copyright (c) 2013 Nordic Semiconductor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "MessageStructure.h"
#import "ViewController.h"
#import "PowerScreenViewController.h"
#import "Cycle_AnalysisViewController.h"
extern int CRM;
extern CBCentralManager *tscm;
extern CBCharacteristic *c;
extern CBCharacteristic *tsrxCharacteristic;
extern CBPeripheral *myperipheral;
extern CBService *tsservice;
extern NSData *data;
extern NSData *str;
extern CBCharacteristic *rxChar,*txChar;
extern float avgspeed1S,avgspeed2S;
extern double whpkm,whpmile;
extern double speedPast;
extern int current,voltageDec;
extern int power,index_Byte;
extern int temperature,hallcode;
extern double avg_power_display,avgpower,powerRemain,consumed,speed;
extern int displayBarDec,regenFlag;
extern BOOL iskphselected,OffRoadStatus,OnRoadStatus,positiveflagstatus,negativeflagstatus,receptionStartFlag,offroadscreenStatus,flagForMotorTypeStatus,dropoutFlag;
extern int powerlevel;
extern double userEdit, whremain,whremainForMile;
;
extern BOOL batteryStatusFlag;
extern NSString *mytime;
/////////////////////////////////////////////Main Screen///////////////////////////////////
extern int valuePower,positive_power,negative_power,motoriderr,iderr;
extern  NSInteger crmvalue1;
extern BOOL kphStateFlag,mphStateFlag,screen_load,allscreenload;
///////////TS//////////////////////////////////////////////////////////////////////////////////////////////

extern  int TSRaw,TSRawDecimal,TSRectified, TSRectifiedDecimal,TSPeak,  TSPeakDecimal, TSFinal,  TSFinalDecimal ;
extern BOOL tsreceptionflag,tsDataFlag,receptionFlag;
/////////////////////////Manufacturing parameter////////////
extern BOOL manu_Firmware,manu_MotorID,manu_TSID,manu_Voltage;
extern int MotorIDFrame,myMotorID,FirmwareNumber,Deci_FirmwareNumber,FirmwareFrame,deci_FirmwareFrame,Voltage,deci_Voltage,TS_ID,deci_TS_ID,deci_FirmwareFrame1,deci_FirmwareFrame2,deci_FirmwareFrame3,sensorValueCheck,sensorValueCheckRead;
extern NSString *myresult, *m6,*vtgBroadcastValue;
extern int dec_myChar,dec_revisionNo,myChar,revisionNo,voltageTarget,MotorTarget,TorqueTarget;
extern BOOL motorTransmitFlag,motorReceiveFlag,tsTransmitFlag,tsReceiveFlag,firmwareTransmitFlag,firmwareReceiveFlag,voltageTransmitFlag,voltageReceiveFlag,voltageBroadcast,batterySelect,manufacturingflag;
extern int DATAByte1,DATAByte2,DATAByte3,DATAByte4,DATAByte5,DATAByte6,DATAByte7,DATAByte8;
////////////////////////////// Motor Control//////////////////////////

extern int motor_frame_id,motor_frame_dec,frame_Type,dec_frame_type,mem_Turnonspeed,dec_mem_Turnonspeed,mem_Basetorque,dec_mem_Basetorque,mem_Flipaxle,dec_mem_Flipaxle,mem_tsturnon,dec_mem_tsturnon,mem_Turnondelay,dec_mem_Turnondelay,mem_Turnoffdelay,dec_mem_Turnoffdelay,mem_Tmultiplier,dec_mem_Tmultiplier,mem_Dropoutdisp,dec_mem_Dropoutdisp;
extern int turnonspeed,turnondelay, basetorque, turnoffdelay, flipaxle, tmultiplier, dropoutdisp,tsTurnOn;
extern BOOL broadcastStatus1,powerbroadcastStatus,memoryStatus,motorcontrolscreenstatus,memoryReadDoneFlag,memoryReadDoneFlag1;

//////////////////////////Power control Screen////////////////////////////////////
extern BOOL flag_Memoryread,flag_Broadcast,flagpwr;
extern BOOL motorTypeTransmitStatus,motorTypeReceiveStatus,powerScreenflag,batterySelectFlagD,motorTypeSelectFlagD,memoryReadFlagD;
extern int wattIndex,winding,armType,batteryvalue,dec_batteryvalue,swipecount;
extern NSString *motorTypeString;
extern int8_t *clamplevel_Regen,*clamplevel_Assist;
extern BOOL assistBroadcastStatus,regenBroadcastStatus,memoryStatusClampCurrent;
extern NSString *assistBroadcastValue,*regenBroadcastValue;
extern NSString *stAssist1,*stAssist2,*stAssist3,*stAssist4,*stAssist5,*stAssist6,*stRegen1,*stRegen2,*stRegen3,*stRegen4,*stRegen5;
//extern NSString  (*arrwatt)={@" ",@"250WATT",@"500WATT",@"750WATT",@"1000WATT",@"1500WATT",@"750WATTPLUS"};

//extern NSString (*arrmwinding)={@" ",@"14T",@"18T",@"27T",@"37T",@"57T"};
//extern NSString (*arrmtype)={@" ",@"ULTSW",@"ULTSW",@"HSW",@"SSW",@"USSW"};
extern  NSInteger index1,index2,index3,index4,index5,index6,rindex1,rindex2,rindex3,rindex4,rindex5;
extern NSInteger segmentValue;
extern int assist_l1,assist_l2,assist_l3,assist_l4,assist_l5,assist_t,regen_l1,regen_l2,regen_l3,regen_l4,regen_l5;
extern NSArray *arrwatt ;
extern  NSArray *arrmwinding;
extern  NSArray *arrmtype ;
extern id assist1,assist2,assist3,assist4,assist5,assistT;
extern BOOL firmwareCheck;
extern   id wattString,windingString,typeString,updateFirmware;
//extern NSArray *clamp_level;

//For battery Capacity

extern NSString *batteryResult;
extern NSString *StoreBtryValue;

extern BOOL batteryCapacityFlag;
 extern int tspeed;
 extern int tdelay;
extern int tdelayoff;
extern int tbasetorque;
extern int tdropout;
extern int tflipaxel;
extern int tsturnon;
extern int torquemultiply;


static Byte power_memred_reg[]={0x95,0x2,0,0,0,0,0,0};//Memory Read Frame
static Byte clamp_level[]= { 0X93,2,4,6,10,12,13,0};//1000 27T watt current clamp
static Byte regen_clamp_level []= {0X98,2,4,6,10,12,0,0 };//1000 37T watt current clamp

extern bool rxRecpPause;


extern id assist_value;
@protocol UARTPeripheralDelegate
- (void) didReceiveData;
-(void)didTransmitData:(NSData*)data;
@optional
- (void) didReadHardwareRevisionString:(NSString *) string;

@end


@interface UARTPeripheral : NSObject <CBPeripheralDelegate>
@property CBPeripheral *peripheral;
@property id<UARTPeripheralDelegate> delegate;
@property (readwrite) NSUInteger length;
@property (readwrite) const void *bytes NS_RETURNS_INNER_POINTER;


+ (CBUUID *) uartServiceUUID;

- (UARTPeripheral *) initWithPeripheral:(CBPeripheral*)peripheral delegate:(id<UARTPeripheralDelegate>) delegate;

//- (void) writeString:(NSString *) string;
//- (void) increaseLevel1:(NSString *) string;
//- (void) increaseLevel2:(NSString *) string;
//- (void) increaseLevel3:(NSString *)string;
//- (void) increaseLevel4:(NSString *) string;
//- (void) increaseLevel5:(NSString *) string;
//- (void) decreaseLevel1:(NSString *) string;
//- (void) decreaseLevel2:(NSString *) string;
//- (void) decreaseLevel3:(NSString *) string;
//- (void) decreaseLevel4:(NSString *)string;
//- (void) decreaseLevel5:(NSString *) string;
//- (void) midleLevel:(NSString *)string;
- (void) didConnect;
-(void)didTSConnect;
- (void) didDisconnect;


/////////////////////MANUFACTURING SCREEN//////////////////////////////////
//- (void) firmMethod:(NSString *)string;
//- (void) VoltageMethod:(NSString *)string;
//- (void) writeString:(NSString *)string;
//- (void) motorIdMethod:(NSString *)string;
//- (void) tsIdMethod:(NSString *)string;
//- (void) turnOnVtgMethod:(NSString *)string;
@end




