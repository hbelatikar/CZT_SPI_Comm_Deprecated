################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
LD_SRCS += \
../src/lscript.ld 

C_SRCS += \
../src/SPIFunctions.c \
../src/helloworld.c \
../src/main.c \
../src/platform.c 

OBJS += \
./src/SPIFunctions.o \
./src/helloworld.o \
./src/main.o \
./src/platform.o 

C_DEPS += \
./src/SPIFunctions.d \
./src/helloworld.d \
./src/main.d \
./src/platform.d 


# Each subdirectory must supply rules for building sources it contributes
src/%.o: ../src/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM v7 gcc compiler'
	arm-none-eabi-gcc -Wall -O0 -g3 -I../../CZT_bsp/ps7_cortexa9_0/include -I"F:\DAKSHA\CommSrcs\FPGA\CZT\CZT.sdk\BD_wo_axi_wrapper_hw_platform_0" -c -fmessage-length=0 -MT"$@" -mcpu=cortex-a9 -mfpu=vfpv3 -mfloat-abi=hard -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


