//
//  MessageStructure.h
//  Falco Flash BLE
//
//  Created by Falco eMotors Pvt. Ltd. on 07/10/2016.
//  Copyright © 2016 Falco eMotors Pvt. Ltd. All rights reserved.
//

#ifndef MessageStructure_h
#define MessageStructure_h


typedef unsigned char   UCHAR;               // Unsigned 1-byte int.


typedef struct
{
    /**
     * The size of the message, not including the size byte or the messageId
     * byte.
     */
    
    UCHAR data1;
    /** Message data byte 2. */
    UCHAR data2;
    /** Message data byte 3. */
    UCHAR data3;
    /** Message data byte 4. */
    UCHAR data4;
    /** Message data byte 5. */
    UCHAR data5;
    /** Message data byte 6. */
    UCHAR data6;
    /** Message data byte 7. */
    UCHAR data7;
    /** Message data byte 8. */
    UCHAR data8;
    /** Message data byte 8. */
    UCHAR data9;
    /** Message data byte 10 (extended data - FLAGz byte). */
    UCHAR data10;
    /** Message data byte 11 (extended data). */
    UCHAR data11;
    /** Message data byte 12 (extended data). */
    UCHAR data12;
    /** Message data byte 13 (extended data). */
    UCHAR data13;
    /** Message data byte 14 (extended data). */
    UCHAR data14;
    
    UCHAR data15;
    /** Message data byte 2. */
    UCHAR data16;
    /** Message data byte 3. */
    UCHAR data17;
    /** Message data byte 4. */
    UCHAR data18;
    /** Message data byte 5. */
    UCHAR data19;
    /** Message data byte 6. */
    UCHAR data20;
    /** Message data byte 7. */
    UCHAR data21;
    /** Message data byte 8. */
    UCHAR data22;
    /** Message data byte 8. */
    UCHAR data23;
    /** Message data byte 10 (extended data - FLAGz byte). */
    UCHAR data24;
    /** Message data byte 11 (extended data). */
    UCHAR data25;
    /** Message data byte 12 (extended data). */
    UCHAR data26;
    /** Message data byte 13 (extended data). */
    UCHAR data27;
    /** Message data byte 14 (extended data). */
    UCHAR data28;
    
    UCHAR data29;
    /** Message data byte 14 (extended data). */
    UCHAR data30;

} BLEMessage;



#endif /* MessageStructure_h */
