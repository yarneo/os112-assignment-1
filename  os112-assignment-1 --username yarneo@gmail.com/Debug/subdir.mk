################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../bio.c \
../bootmain.c \
../cat.c \
../console.c \
../echo.c \
../exec.c \
../file.c \
../forktest.c \
../fs.c \
../grep.c \
../ide.c \
../init.c \
../ioapic.c \
../kalloc.c \
../kbd.c \
../kill.c \
../lapic.c \
../ln.c \
../ls.c \
../main.c \
../mkdir.c \
../mkfs.c \
../mp.c \
../picirq.c \
../pipe.c \
../printf.c \
../proc.c \
../rm.c \
../sh.c \
../spinlock.c \
../stressfs.c \
../string.c \
../syscall.c \
../sysfile.c \
../sysproc.c \
../timer.c \
../trap.c \
../uart.c \
../ulib.c \
../umalloc.c \
../usertests.c \
../vm.c \
../wc.c \
../zombie.c 

S_UPPER_SRCS += \
../bootasm.S \
../bootother.S \
../initcode.S \
../swtch.S \
../trapasm.S \
../usys.S 

OBJS += \
./bio.o \
./bootasm.o \
./bootmain.o \
./bootother.o \
./cat.o \
./console.o \
./echo.o \
./exec.o \
./file.o \
./forktest.o \
./fs.o \
./grep.o \
./ide.o \
./init.o \
./initcode.o \
./ioapic.o \
./kalloc.o \
./kbd.o \
./kill.o \
./lapic.o \
./ln.o \
./ls.o \
./main.o \
./mkdir.o \
./mkfs.o \
./mp.o \
./picirq.o \
./pipe.o \
./printf.o \
./proc.o \
./rm.o \
./sh.o \
./spinlock.o \
./stressfs.o \
./string.o \
./swtch.o \
./syscall.o \
./sysfile.o \
./sysproc.o \
./timer.o \
./trap.o \
./trapasm.o \
./uart.o \
./ulib.o \
./umalloc.o \
./usertests.o \
./usys.o \
./vm.o \
./wc.o \
./zombie.o 

C_DEPS += \
./bio.d \
./bootmain.d \
./cat.d \
./console.d \
./echo.d \
./exec.d \
./file.d \
./forktest.d \
./fs.d \
./grep.d \
./ide.d \
./init.d \
./ioapic.d \
./kalloc.d \
./kbd.d \
./kill.d \
./lapic.d \
./ln.d \
./ls.d \
./main.d \
./mkdir.d \
./mkfs.d \
./mp.d \
./picirq.d \
./pipe.d \
./printf.d \
./proc.d \
./rm.d \
./sh.d \
./spinlock.d \
./stressfs.d \
./string.d \
./syscall.d \
./sysfile.d \
./sysproc.d \
./timer.d \
./trap.d \
./uart.d \
./ulib.d \
./umalloc.d \
./usertests.d \
./vm.d \
./wc.d \
./zombie.d 


# Each subdirectory must supply rules for building sources it contributes
%.o: ../%.c
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C Compiler'
	gcc -O0 -g3 -Wall -c -fmessage-length=0 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o"$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

%.o: ../%.S
	@echo 'Building file: $<'
	@echo 'Invoking: GCC Assembler'
	as  -o"$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


