################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../louvain-semantic/main.c 

OBJS += \
./louvain-semantic/main.o 

C_DEPS += \
./louvain-semantic/main.d 


# Each subdirectory must supply rules for building sources it contributes
louvain-semantic/%.o: ../louvain-semantic/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C Compiler'
	gcc -I/usr/local/include/igraph -O3 -Wall -c -fmessage-length=0 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


