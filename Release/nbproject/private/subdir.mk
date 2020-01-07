################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../nbproject/private/c_standard_headers_indexer.c 

OBJS += \
./nbproject/private/c_standard_headers_indexer.o 

C_DEPS += \
./nbproject/private/c_standard_headers_indexer.d 


# Each subdirectory must supply rules for building sources it contributes
nbproject/private/%.o: ../nbproject/private/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C Compiler'
	gcc -I/usr/local/include/igraph -O3 -Wall -c -fmessage-length=0 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


