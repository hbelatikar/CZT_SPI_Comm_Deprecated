/*
 * main.c
 *
 *  Created on: Feb 20, 2020
 *      Author: HSB
 */

#include <stdio.h>
#include "platform.h"
#include "xparameters.h"
#include "xil_printf.h"
#include "SPIFunctions.h"
#include "ps7_init.c"
#include "xuartps.h"

//#define variables go here
#define COMMAND 0
#define DATA 1

XUartPs Uart_Ps;		/* The instance of the UART Driver */

//Global Variable Declaration here

//Local Functions go here
u32
parityCalc(u32 val){
	val ^= (val >> 16);
	val ^= (val >> 8);
	val ^= (val >> 4);
	val ^= (val >> 2);
	val ^= (val >> 1);

	return (u32) (val & 0x1);
}

u32
joinDataBitPar(u32 data, char CWFlag){
	u32 parity;
	//Note:- Since we are going to shift the data by one bit we will set the 17th bit high and not the 18th
	data = (CWFlag)? (data | 0x10000): (data);	//Set the bit high according to CZT data sheet
	parity = parityCalc(data);	//Calculate the parity of the 32 bit data
	data = (data <<1)|parity;	//Left shift and append parity to the data
	return data;
}

//int UartPsHelloWorldExample(u16 DeviceId)
//{
//	u8 HelloWorld[] = "Hello World";
//	int SentCount = 0;
//	int Status;
//	XUartPs_Config *Config;
//
//	/*
//	 * Initialize the UART driver so that it's ready to use
//	 * Look up the configuration in the config table and then initialize it.
//	 */
//	Config = XUartPs_LookupConfig(DeviceId);
//	if (NULL == Config) {
//		return XST_FAILURE;
//	}
//
//	Status = XUartPs_CfgInitialize(&Uart_Ps, Config, Config->BaseAddress);
//	if (Status != XST_SUCCESS) {
//		return XST_FAILURE;
//	}
//
//	XUartPs_SetBaudRate(&Uart_Ps, 115200);
//
//	while (SentCount < (sizeof(HelloWorld) - 1)) {
//		/* Transmit the data */
//		SentCount += XUartPs_Send(&Uart_Ps,
//					   &HelloWorld[SentCount], 1);
//	}
//
//	return SentCount;
//}


//Main function
//int main()
//{
//	//Initialize variables here
//	unsigned int frame,dictID,threshVal,cmd,readData,writeData;
//	unsigned int eventFlag,pixVal,pixLoc;
//
//	init_platform();	//uncomment in declaration to run code outside SDK
//    //ps7_post_config();
//
//    //Initialize the hardware here
//    initGPIO();
//
//    xil_printf("CZT Communicator Intialized! Enter a command\n");
//
//    //Forever loop
//    while(1){
//
//    	//Wait for input here
//    	scanf("%d",&frame);
//    	//Extracting dict id
//    	dictID = frame & 0xF000;
//
//    	switch(dictID){
//
//			case(ENRGTHRESH): //Energy set code goes here
//				threshVal = frame & 0x0FFF;
//
//				//Converts the threshold data to CZT seq format
//				writeData = joinDataBitPar(threshVal,DATA);
//
//				//Set the thresh value
//				cmd = 66;	//Set the threshold value command
//				writeConfigToCZT(cmd,writeData);
//
//    			//get the thresh value
//				cmd = 323;	//Read threshold value command
//    			readData = readConfigFromCZT(cmd);
//    			readData = readData >> 1;
//    			//reply back the thresh value
//				xil_printf("%x\n",readData);
//				break;
//
//    		case(PIXENADIS): //Pixel status code goes here
//
//				//Set the pixel location
//				pixLoc = frame & 0xFF;		//Pixel location in Array
//    			//Append parity and data bit
//    			writeData = joinDataBitPar(pixLoc,DATA);
//    			cmd = 15;	//Select channel command
//				writeConfigToCZT(cmd,writeData);
//
//				//Turn the pixel On/off
//				cmd = 23;	//Enable disable command
//				pixVal = (frame>>8) & 0xF;	//Pixel to be turned off or on
//    			if((pixVal == 0x1)||(pixVal == 0x0)){	//All pixel status case not handled yet
//    				writeData = joinDataBitPar(pixVal,DATA);
//    				writeConfigToCZT(cmd,writeData);
//    			}
//
//    			//Get the pixel status
//    			cmd = 278;	//Read enable disable status command
//    			readData = readConfigFromCZT (cmd);
//    			readData = readData >> 1;
//    			//reply back the pixel status in frame format
//    			xil_printf("%x\n",readData);
//				break;
//
//    		case(EVENTMODE): //Event mode code goes here
//				eventFlag = frame & 0x00FF;
//				if(eventFlag){
//					//Turn the event mode on here and capture data;
//				}
//				else{
//					//Turn the event mode Off if its On else do nothing;
//				}
//				break;
//    		default: xil_printf("%d\n",0xFFFFFFFF);
//				break;
//    	}
//    }
//
//    cleanup_platform();
//    return 0;
//}

//Main function used for testing
//int main()
//{
//	//Initialize variables here
//	unsigned int frame,dictID;//,threshVal,cmd,readData,writeData;
//	//unsigned int eventFlag,pixVal,pixLoc;
//
//	init_platform();	//uncomment in declaration to run code outside SDK
//	//ps7_post_config();
//
//    //Initialize the hardware here
//    //initGPIO();
//
//    xil_printf("CZT Communicator Intialized! Enter a command\n");
//
//    //Forever loop
//    while(1){
//
//    	//Wait for input here
//    	scanf("%d",&frame);
//    	//Extracting dict id
//    	dictID = frame & 0xF000;
//
//    	switch(dictID){
//
//			case(ENRGTHRESH): //Energy set code goes here
////				threshVal = frame & 0x0FFF;
////
////				//Converts the threshold data to CZT seq format
////				writeData = joinDataBitPar(threshVal,DATA);
////
////				//Set the thresh value
////				cmd = 66;	//Set the threshold value command
////				writeConfigToCZT(cmd,writeData);
////
////    			//get the thresh value
////				cmd = 323;	//Read threshold value command
////    			readData = readConfigFromCZT(cmd);
////    			readData = readData >> 1;
////    			//reply back the thresh value
//				xil_printf("%x\n",dictID);
//				break;
//
//    		case(PIXENADIS): //Pixel status code goes here
////				//Set the pixel location
////				pixLoc = frame & 0xFF;		//Pixel location in Array
////    			//Append parity and data bit
////    			writeData = joinDataBitPar(pixLoc,DATA);
////    			cmd = 15;	//Select channel command
////				writeConfigToCZT(cmd,writeData);
////
////				//Turn the pixel On/off
////				cmd = 23;	//Enable disable command
////				pixVal = (frame>>8) & 0xF;	//Pixel to be turned off or on
////    			if((pixVal == 0x1)||(pixVal == 0x0)){	//All pixel status case not handled yet
////    				writeData = joinDataBitPar(pixVal,DATA);
////    				writeConfigToCZT(cmd,writeData);
////    			}
////
////    			//Get the pixel status
////    			cmd = 278;	//Read enable disable status command
////    			readData = readConfigFromCZT (cmd);
////    			readData = readData >> 1;
////    			//reply back the pixel status in frame format
//    			xil_printf("%x\n",dictID);
//				break;
//
//    		case(EVENTMODE): //Event mode code goes here
////				eventFlag = frame & 0x00FF;
////				if(eventFlag){
////					//Turn the event mode on here and capture data;
////				}
////				else{
////					//Turn the event mode Off if its On else do nothing;
////				}
//				xil_printf("%x\n",dictID);
//				break;
//    		default: xil_printf("%d\n",0xFFFFFFFF);
//				break;
//    	}
//    }
//
//    cleanup_platform();
//    return 0;
//}
//



//int main(void)
//{
//	int Status;
//
//
//	Status = UartPsHelloWorldExample(UART_DEVICE_ID);
//
//	if (Status == XST_FAILURE) {
//		xil_printf("Uartps hello world Example Failed\r\n");
//		return XST_FAILURE;
//	}
//
//	xil_printf("Successfully ran Uartps hello world Example\r\n");
//
//	return Status;
//}

/****************************************************************************/
/**
*
* This function sends 'Hello World' to an external terminal in polled mode.
* The purpose of this function is to illustrate how to use the XUartPs driver.
*
*
* @param	DeviceId is the unique ID for the device from hardware build.
*
* @return
*		- XST_FAILURE if the UART driver could not be initialized
*		  successfully.
*		- A non-negative number indicating the number of characters
*		  sent.
*
* @note		None.
*
****************************************************************************/
