/*
 * SPIFunctions.c
 *
 *  Created on: Feb 19, 2020
 *      Author: HSB
 */

#include <stdio.h>
#include "xparameters.h"
#include "xil_io.h"
#include "xgpiops.h"
#include "SPIFunctions.h"


void
initGPIO(void){	//Clear all Output GPIO's and set input directions for all input GPIO's
	//Initialize all outputs to zero
		Xil_Out32(CZT_DATA_RW_DATAOUT_OUT,	0);	//Clearing the DataOut[31:0] GPIO
		Xil_Out32(CZT_WR_REQ_WRITEREQ_OUT,	0);	//Clearing the Write request GPIO
		Xil_Out32(CZT_WR_REQ_READREQ_OUT ,	0);	//Clearing the Read  request GPIO
		Xil_Out32(CMD_OUT_ADDR_OUT		 ,	0);	//Clearing the CmdOut[9:0]   GPIO
		Xil_Out32(FIFO_READ_DATA_RCLK_OUT,	0);	//Clearing the FIFO read clk GPIO

	//Set all directions of input regs as inputs
		Xil_Out32(FIFO_FULL_EMPTY_FULL_IN  +0x04,	0x1);		//Setting FIFO full flag GPIO as Input
		Xil_Out32(FIFO_FULL_EMPTY_EMPTY_IN +0x04,	0x1);		//Setting FIFO empty flag GPIO as Input
		Xil_Out32(CZT_DATA_RW_DATAIN_IN    +0x04,	0xFFFFFFFF);//Setting all CZT Data GPIO pins as Input
		Xil_Out32(FIFO_READ_DATA_DOUT_IN   +0x04,	0xFFFFFFFF);//Setting all FIFO Data GPIO pins as Input

	//Configure the PS GPIO
		Xil_Out32(XPAR_PS7_GPIO_0_BASEADDR + 0x00000284, 0x0); 		 //configuring ps7 gpio as input
		Xil_Out32(XPAR_PS7_GPIO_0_BASEADDR + 0x0000029C, 0x00000001);//configuring as rising edge   (typr)
		Xil_Out32(XPAR_PS7_GPIO_0_BASEADDR + 0x000002A0, 0x00000001);//configuring as irising edge (polarity)
		Xil_Out32(XPAR_PS7_GPIO_0_BASEADDR + 0x000002A4, 0x0);  	 //configuring as irising edge (any)
		Xil_Out32(XPAR_PS7_GPIO_0_BASEADDR + 0x00000294, 0x00000001);//interrupt enable mask
}

void
wipeGPIO(void){
	//Initialize all outputs to zero
		Xil_Out32(CZT_DATA_RW_DATAOUT_OUT	,	0);	//Clearing the DataOut[31:0] GPIO
		Xil_Out32(CZT_WR_REQ_WRITEREQ_OUT	,	0);	//Clearing the Write request GPIO
		Xil_Out32(CZT_WR_REQ_READREQ_OUT	,	0);	//Clearing the Read  request GPIO
		Xil_Out32(CMD_OUT_ADDR_OUT			,	0);	//Clearing the CmdOut[9:0]   GPIO
		Xil_Out32(FIFO_READ_DATA_RCLK_OUT	,	0);	//Clearing the FIFO read clk GPIO
}

void
writeConfigToCZT(u32 cmd, u32 data){
	//Send out the command
	Xil_Out32(CMD_OUT_ADDR_OUT		  , cmd);

	//Send out the data
	Xil_Out32(CZT_DATA_RW_DATAOUT_OUT , data);

	//Set write request and reset read request
	Xil_Out32(CZT_WR_REQ_WRITEREQ_OUT , 1);
	Xil_Out32(CZT_WR_REQ_READREQ_OUT  , 0);

	//Reset all the pins
	Xil_Out32(CZT_WR_REQ_WRITEREQ_OUT , 0);
	Xil_Out32(CZT_WR_REQ_READREQ_OUT  , 0);
	Xil_Out32(CZT_DATA_RW_DATAOUT_OUT , 0);
}

u32
readConfigFromCZT(u32 cmd){
	char dataRdyFlag = 0;
	u32 readData = 0;

	//Send out the command
	Xil_Out32(CMD_OUT_ADDR_OUT	, cmd);

	//Reset write request and Set read request
	Xil_Out32(CZT_WR_REQ_WRITEREQ_OUT , 0);
	Xil_Out32(CZT_WR_REQ_READREQ_OUT  , 1);

	//Wait till the data is ready at SPI controllers end
	do{

		dataRdyFlag = Xil_In32(PS_GPIO0_RDAVAIL_IN);

	}while ((dataRdyFlag & 0x1) == 1);

	//Reset write request and read request
	Xil_Out32(CZT_WR_REQ_WRITEREQ_OUT , 0);
	Xil_Out32(CZT_WR_REQ_READREQ_OUT  , 0);

	//Read the CZT data
	readData = Xil_In32(CZT_DATA_RW_DATAIN_IN);

	return readData;
}

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

