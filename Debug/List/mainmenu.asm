
;CodeVisionAVR C Compiler V3.14 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega16
;Program type           : Application
;Clock frequency        : 1.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _i=R4
	.DEF _i_msb=R5
	.DEF _j=R6
	.DEF _j_msb=R7
	.DEF _zone=R8
	.DEF _zone_msb=R9
	.DEF _mmz=R10
	.DEF _mmz_msb=R11
	.DEF _smz=R12
	.DEF _smz_msb=R13

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  _ext_int0_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0

_0x3:
	.DB  0x1
_0x4:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x4,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x5,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x7
_0x5:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x3,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x4,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x5,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x2,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x6,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x2,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x7,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x7
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x9
_0x0:
	.DB  0x25,0x30,0x32,0x75,0x2F,0x25,0x30,0x32
	.DB  0x75,0x2F,0x25,0x30,0x32,0x75,0x20,0x2D
	.DB  0x20,0x44,0x61,0x79,0x20,0x25,0x75,0x0
	.DB  0x25,0x30,0x32,0x75,0x3A,0x25,0x30,0x32
	.DB  0x75,0x3A,0x25,0x30,0x32,0x75,0x0,0x25
	.DB  0x73,0x0,0x45,0x6E,0x74,0x65,0x72,0x20
	.DB  0x4E,0x65,0x77,0x20,0x50,0x61,0x73,0x73
	.DB  0x3A,0x0,0x4E,0x65,0x77,0x20,0x50,0x61
	.DB  0x73,0x73,0x20,0x69,0x73,0x3A,0x0,0x70
	.DB  0x61,0x73,0x73,0x20,0x63,0x68,0x65,0x6E
	.DB  0x67,0x65,0x64,0x0,0x25,0x64,0x0,0x44
	.DB  0x50,0x53,0x79,0x73,0x2E,0x63,0x6F,0x0
	.DB  0x50,0x61,0x73,0x73,0x20,0x4B,0x65,0x79
	.DB  0x20,0x3A,0x0,0x4C,0x6F,0x63,0x6B,0x20
	.DB  0x3A,0x20,0x4F,0x4E,0x0,0x49,0x6E,0x76
	.DB  0x61,0x6C,0x69,0x64,0x20,0x50,0x61,0x73
	.DB  0x73,0x77,0x6F,0x72,0x64,0x0,0x48,0x41
	.DB  0x4C,0x4C,0x4F,0x0
_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x06
	.DW  0x08
	.DW  __REG_VARS*2

	.DW  0x01
	.DW  _MemAddress
	.DW  _0x3*2

	.DW  0x33
	.DW  _MM
	.DW  _0x4*2

	.DW  0x99
	.DW  _SM
	.DW  _0x5*2

	.DW  0x10
	.DW  _0x44
	.DW  _0x0*2+42

	.DW  0x0D
	.DW  _0x44+16
	.DW  _0x0*2+58

	.DW  0x0D
	.DW  _0x44+29
	.DW  _0x0*2+71

	.DW  0x09
	.DW  _0x68
	.DW  _0x0*2+87

	.DW  0x0B
	.DW  _0x68+9
	.DW  _0x0*2+96

	.DW  0x09
	.DW  _0x72
	.DW  _0x0*2+87

	.DW  0x0B
	.DW  _0x72+9
	.DW  _0x0*2+96

	.DW  0x06
	.DW  _0x72+20
	.DW  _0x0*2+134

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.14 Advanced
;Automatic Program Generator
;© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version : V0.2
;Date    : 05/07/2024
;Author  : SHAHROKH DELGOSHAD
;Company : DPSys.co
;Comments: Read menu items from EEPROM and copy to strauctur
;
;Chip type               : ATmega16
;Program type            : Application
;AVR Core Clock frequency: 1.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*******************************************************/
;#include <io.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <i2c.h>
;#include <alcd.h>
;#include <delay.h>
;#include <stdio.h>
;#include <stdint.h>
;#include <string.h>
;#include <ds1307.h>
;#include "config.h"

	.DSEG

	.CSEG
_micro_init:
; .FSTART _micro_init
	LDI  R30,LOW(240)
	OUT  0x1A,R30
	LDI  R30,LOW(15)
	OUT  0x1B,R30
	LDI  R30,LOW(0)
	OUT  0x17,R30
	OUT  0x18,R30
	LDI  R30,LOW(1)
	OUT  0x14,R30
	LDI  R30,LOW(0)
	OUT  0x15,R30
	OUT  0x11,R30
	OUT  0x12,R30
	OUT  0x33,R30
	OUT  0x32,R30
	OUT  0x3C,R30
	OUT  0x2F,R30
	OUT  0x2E,R30
	OUT  0x2D,R30
	OUT  0x2C,R30
	OUT  0x27,R30
	OUT  0x26,R30
	OUT  0x2B,R30
	OUT  0x2A,R30
	OUT  0x29,R30
	OUT  0x28,R30
	OUT  0x22,R30
	OUT  0x25,R30
	OUT  0x24,R30
	OUT  0x23,R30
	OUT  0x39,R30
	IN   R30,0x3B
	ORI  R30,0x40
	OUT  0x3B,R30
	LDI  R30,LOW(1)
	OUT  0x35,R30
	LDI  R30,LOW(0)
	OUT  0x34,R30
	LDI  R30,LOW(64)
	OUT  0x3A,R30
	LDI  R30,LOW(0)
	OUT  0xA,R30
	LDI  R30,LOW(128)
	OUT  0x8,R30
	LDI  R30,LOW(0)
	OUT  0x30,R30
	OUT  0x6,R30
	OUT  0xD,R30
	OUT  0x36,R30
	CALL _i2c_init
	LDI  R26,LOW(16)
	CALL _lcd_init
	sei
	RET
; .FEND
_EEPROM_WritePage:
; .FSTART _EEPROM_WritePage
	ST   -Y,R26
	ST   -Y,R17
;	deviceAddress -> Y+5
;	memAddress -> Y+4
;	*data -> Y+2
;	len -> Y+1
;	current_byte -> R17
	CALL _i2c_start
	LDD  R26,Y+5
	CALL _i2c_write
	LDD  R26,Y+4
	CALL _i2c_write
_0x6:
	LDD  R30,Y+1
	SUBI R30,LOW(1)
	STD  Y+1,R30
	SUBI R30,-LOW(1)
	BREQ _0x8
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LD   R17,X+
	STD  Y+2,R26
	STD  Y+2+1,R27
	MOV  R26,R17
	CALL _i2c_write
	RJMP _0x6
_0x8:
	LDI  R17,LOW(0)
	MOV  R26,R17
	CALL SUBOPT_0x0
	LDD  R17,Y+0
	ADIW R28,6
	RET
; .FEND
_EEPROM_ReadPage:
; .FSTART _EEPROM_ReadPage
	ST   -Y,R26
;	deviceAddress -> Y+4
;	memAddress -> Y+3
;	*data -> Y+1
;	len -> Y+0
	CALL _i2c_start
	LDD  R26,Y+4
	CALL _i2c_write
	LDD  R26,Y+3
	CALL _i2c_write
	CALL _i2c_start
	LDD  R30,Y+4
	ORI  R30,1
	MOV  R26,R30
	CALL _i2c_write
_0x9:
	LD   R30,Y
	SUBI R30,LOW(1)
	ST   Y,R30
	BREQ _0xB
	CALL SUBOPT_0x1
	PUSH R31
	PUSH R30
	LDI  R26,LOW(1)
	CALL _i2c_read
	POP  R26
	POP  R27
	ST   X,R30
	RJMP _0x9
_0xB:
	CALL SUBOPT_0x1
	PUSH R31
	PUSH R30
	LDI  R26,LOW(0)
	CALL _i2c_read
	POP  R26
	POP  R27
	ST   X,R30
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LDI  R30,LOW(0)
	ST   X,R30
	CALL _i2c_stop
	JMP  _0x20C0003
; .FEND
_GetKey:
; .FSTART _GetKey
	ST   -Y,R17
	ST   -Y,R16
;	key_code -> R17
;	columns -> R16
	LDI  R17,255
	LDI  R30,LOW(255)
	OUT  0x1B,R30
	CBI  0x1B,4
	CALL SUBOPT_0x2
	BREQ _0xE
	CALL SUBOPT_0x3
	BRNE _0x12
	LDI  R17,LOW(1)
	RJMP _0x11
_0x12:
	CPI  R30,LOW(0xD)
	LDI  R26,HIGH(0xD)
	CPC  R31,R26
	BRNE _0x13
	LDI  R17,LOW(2)
	RJMP _0x11
_0x13:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0x14
	LDI  R17,LOW(3)
	RJMP _0x11
_0x14:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x11
	LDI  R17,LOW(12)
_0x11:
_0xE:
	SBI  0x1B,4
	CBI  0x1B,5
	CALL SUBOPT_0x2
	BREQ _0x1A
	CALL SUBOPT_0x3
	BRNE _0x1E
	LDI  R17,LOW(4)
	RJMP _0x1D
_0x1E:
	CPI  R30,LOW(0xD)
	LDI  R26,HIGH(0xD)
	CPC  R31,R26
	BRNE _0x1F
	LDI  R17,LOW(5)
	RJMP _0x1D
_0x1F:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0x20
	LDI  R17,LOW(6)
	RJMP _0x1D
_0x20:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x1D
	LDI  R17,LOW(13)
_0x1D:
_0x1A:
	SBI  0x1B,5
	CBI  0x1B,6
	CALL SUBOPT_0x2
	BREQ _0x26
	CALL SUBOPT_0x3
	BRNE _0x2A
	LDI  R17,LOW(7)
	RJMP _0x29
_0x2A:
	CPI  R30,LOW(0xD)
	LDI  R26,HIGH(0xD)
	CPC  R31,R26
	BRNE _0x2B
	LDI  R17,LOW(8)
	RJMP _0x29
_0x2B:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0x2C
	LDI  R17,LOW(9)
	RJMP _0x29
_0x2C:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x29
	LDI  R17,LOW(14)
_0x29:
_0x26:
	SBI  0x1B,6
	CBI  0x1B,7
	CALL SUBOPT_0x2
	BREQ _0x32
	CALL SUBOPT_0x3
	BRNE _0x36
	LDI  R17,LOW(10)
	RJMP _0x35
_0x36:
	CPI  R30,LOW(0xD)
	LDI  R26,HIGH(0xD)
	CPC  R31,R26
	BRNE _0x37
	LDI  R17,LOW(0)
	RJMP _0x35
_0x37:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0x38
	LDI  R17,LOW(11)
	RJMP _0x35
_0x38:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x35
	LDI  R17,LOW(15)
_0x35:
_0x32:
	SBI  0x1B,7
	LDI  R30,LOW(15)
	OUT  0x1B,R30
	MOV  R30,R17
	RJMP _0x20C0006
; .FEND
_showDateTime:
; .FSTART _showDateTime
	ST   -Y,R17
	ST   -Y,R16
;	k -> R16,R17
	__GETWRN 16,17,0
	__GETWRN 16,17,0
_0x3D:
	__CPWRN 16,17,6
	BRLT PC+2
	RJMP _0x3E
	LDI  R30,LOW(_d)
	LDI  R31,HIGH(_d)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _d,3
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _d,2
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2MN _d,1
	CALL _rtc_get_date
	LDI  R30,LOW(_mStr)
	LDI  R31,HIGH(_mStr)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	__GETB1MN _d,2
	CALL SUBOPT_0x4
	__GETB1MN _d,3
	CALL SUBOPT_0x4
	__GETB1MN _d,1
	CALL SUBOPT_0x4
	LDS  R30,_d
	CALL SUBOPT_0x4
	LDI  R24,16
	CALL _sprintf
	ADIW R28,20
	CALL SUBOPT_0x5
	LDI  R26,LOW(1)
	CALL SUBOPT_0x6
	LDI  R30,LOW(_t)
	LDI  R31,HIGH(_t)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _t,1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2MN _t,2
	CALL _rtc_get_time
	LDI  R30,LOW(_mStr)
	LDI  R31,HIGH(_mStr)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,24
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_t
	CALL SUBOPT_0x4
	__GETB1MN _t,1
	CALL SUBOPT_0x4
	__GETB1MN _t,2
	CALL SUBOPT_0x4
	LDI  R24,12
	CALL _sprintf
	ADIW R28,16
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL SUBOPT_0x6
	CALL SUBOPT_0x7
	__ADDWRN 16,17,1
	RJMP _0x3D
_0x3E:
_0x20C0006:
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
_makeScreen:
; .FSTART _makeScreen
	ST   -Y,R27
	ST   -Y,R26
;	z -> Y+4
;	m -> Y+2
;	s -> Y+0
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	SBIW R30,0
	BRNE _0x42
	CALL SUBOPT_0x5
	CALL SUBOPT_0x8
	RJMP _0x9A
_0x42:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x41
	CALL SUBOPT_0x5
	CALL SUBOPT_0x8
	CALL SUBOPT_0x9
	LDI  R30,LOW(_temp)
	LDI  R31,HIGH(_temp)
	CALL SUBOPT_0xA
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(51)
	CALL __MULB1W2U
	SUBI R30,LOW(-_SM)
	SBCI R31,HIGH(-_SM)
	MOVW R26,R30
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	CALL SUBOPT_0xB
	ADD  R30,R22
	ADC  R31,R23
	CALL SUBOPT_0xC
	LDI  R26,LOW(_temp)
	LDI  R27,HIGH(_temp)
_0x9A:
	CALL _lcd_puts
_0x41:
	JMP  _0x20C0001
; .FEND
_menu1:
; .FSTART _menu1
	CALL __SAVELOCR6
;	i -> R16,R17
;	j -> R18,R19
;	kp -> R21
	__GETWRN 16,17,0
	__GETWRN 18,19,0
	IN   R30,0x3B
	OUT  0x3B,R30
	CALL SUBOPT_0x5
	LDI  R26,LOW(0)
	CALL _lcd_gotoxy
	__POINTW2MN _0x44,0
	CALL SUBOPT_0x9
_0x45:
	MOV  R0,R16
	OR   R0,R17
	BREQ PC+2
	RJMP _0x47
	RCALL _GetKey
	MOV  R21,R30
	LDI  R26,LOW(200)
	LDI  R27,0
	CALL _delay_ms
	CPI  R21,255
	BRNE PC+2
	RJMP _0x48
	MOV  R30,R21
	CALL SUBOPT_0xD
	BRNE _0x4C
	RJMP _0x4B
_0x4C:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0x4D
	CALL SUBOPT_0x5
	LDI  R26,LOW(0)
	CALL _lcd_gotoxy
	__POINTW2MN _0x44,16
	CALL SUBOPT_0x9
	LDI  R26,LOW(_setPass)
	LDI  R27,HIGH(_setPass)
	CALL _lcd_puts
	CALL SUBOPT_0x7
	CALL SUBOPT_0xE
	LDI  R30,LOW(_setPass)
	LDI  R31,HIGH(_setPass)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(5)
	RCALL _EEPROM_WritePage
	CALL SUBOPT_0xF
	CALL _lcd_clear
	__POINTW2MN _0x44,29
	CALL SUBOPT_0x10
	__GETWRN 16,17,1
	RJMP _0x4B
_0x4D:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BREQ _0x4B
	CPI  R30,LOW(0xD)
	LDI  R26,HIGH(0xD)
	CPC  R31,R26
	BREQ _0x4B
	CPI  R30,LOW(0xE)
	LDI  R26,HIGH(0xE)
	CPC  R31,R26
	BREQ _0x4B
	CPI  R30,LOW(0xF)
	LDI  R26,HIGH(0xF)
	CPC  R31,R26
	BREQ _0x4B
	__CPWRN 18,19,4
	BRGE _0x53
	CALL SUBOPT_0x11
	MOVW R26,R18
	SUBI R26,LOW(-_setPass)
	SBCI R27,HIGH(-_setPass)
	MOV  R30,R21
	SUBI R30,-LOW(48)
	ST   X,R30
	CALL SUBOPT_0x12
	__POINTW1FN _0x0,84
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R21
	CALL SUBOPT_0x4
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	LDI  R26,LOW(_tempStr)
	LDI  R27,HIGH(_tempStr)
	CALL _lcd_puts
	__ADDWRN 18,19,1
	RJMP _0x58
_0x53:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CP   R30,R18
	CPC  R31,R19
	BRNE _0x59
	MOVW R30,R18
	__ADDW1MN _setPass,1
	LDI  R26,LOW(0)
	STD  Z+0,R26
_0x59:
_0x58:
_0x4B:
_0x48:
	RJMP _0x45
_0x47:
	IN   R30,0x3B
	ORI  R30,0x40
	OUT  0x3B,R30
	CALL __LOADLOCR6
	JMP  _0x20C0001
; .FEND

	.DSEG
_0x44:
	.BYTE 0x2A
;
;// Declare your global Function here
;//void EEPROM_WritePage(uint8_t deviceAddress, uint8_t memAddress, uint8_t* data, uint8_t len);
;//void EEPROM_ReadPage(uint8_t deviceAddress, uint8_t memAddress, uint8_t* data, uint8_t len);
;//void makeScreen(int z,int m, int s);
;//void showDateTime();
;//char GetKey();
;//void menu1();
;void KeyAction(char KeyPress);
;
;// External Interrupt 0 service routine
;interrupt [EXT_INT0] void ext_int0_isr(void)
; 0000 002B {

	.CSEG
_ext_int0_isr:
; .FSTART _ext_int0_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 002C     char k;
; 0000 002D     delay_ms(200);
	ST   -Y,R17
;	k -> R17
	LDI  R26,LOW(200)
	LDI  R27,0
	CALL _delay_ms
; 0000 002E     k = GetKey();
	RCALL _GetKey
	MOV  R17,R30
; 0000 002F     if(k != 0xFF) {
	CPI  R17,255
	BREQ _0x5A
; 0000 0030         PORTC.0=1;
	CALL SUBOPT_0x11
; 0000 0031         delay_ms(50);
; 0000 0032         PORTC.0=0;
; 0000 0033         KeyAction(k);
	MOV  R26,R17
	RCALL _KeyAction
; 0000 0034         //newKeyAction(k,kpass,mmz,smz);
; 0000 0035     }
; 0000 0036     // clear INTF0
; 0000 0037     GICR |= (1 << INTF0);
_0x5A:
	IN   R30,0x3B
	ORI  R30,0x40
	OUT  0x3B,R30
; 0000 0038 }
	LD   R17,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;void main(void) {
; 0000 003A void main(void) {
_main:
; .FSTART _main
; 0000 003B     micro_init();
	RCALL _micro_init
; 0000 003C 
; 0000 003D     // Initialize Menu items reead from EEPROM
; 0000 003E     MemAddress = mainMenuAdd;
	CALL SUBOPT_0xE
; 0000 003F     // Reading Password from EEPROM
; 0000 0040     EEPROM_ReadPage(DeviceAddress, MemAddress , tempStr, passLen);
	CALL SUBOPT_0x12
	LDI  R26,LOW(4)
	CALL SUBOPT_0x13
; 0000 0041     delay_ms(10);
; 0000 0042     MemAddress += buffSize ;
	CALL SUBOPT_0x14
; 0000 0043     strcpy(sys_code,tempStr);
	LDI  R30,LOW(_sys_code)
	LDI  R31,HIGH(_sys_code)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_tempStr)
	LDI  R27,HIGH(_tempStr)
	CALL _strcpy
; 0000 0044 
; 0000 0045     for(i=0; i<maxMenuitemsX ; i++){
	CLR  R4
	CLR  R5
_0x60:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CP   R4,R30
	CPC  R5,R31
	BRSH _0x61
; 0000 0046         EEPROM_ReadPage(DeviceAddress, MemAddress , tempStr, MM[i].len);
	CALL SUBOPT_0x15
	MOVW R30,R4
	LDI  R26,LOW(17)
	LDI  R27,HIGH(17)
	CALL __MULW12U
	__ADDW1MN _MM,16
	LD   R26,Z
	CALL SUBOPT_0x13
; 0000 0047         delay_ms(10);
; 0000 0048         MemAddress += buffSize ;
	CALL SUBOPT_0x14
; 0000 0049         sprintf(MM[i].Name,"%s",tempStr);
	MOVW R30,R4
	LDI  R26,LOW(17)
	LDI  R27,HIGH(17)
	CALL __MULW12U
	SUBI R30,LOW(-_MM)
	SBCI R31,HIGH(-_MM)
	CALL SUBOPT_0xA
	LDI  R30,LOW(_tempStr)
	LDI  R31,HIGH(_tempStr)
	CALL SUBOPT_0xC
; 0000 004A     }
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
	RJMP _0x60
_0x61:
; 0000 004B 
; 0000 004C     for(i=0; i<maxMenuitemsX ; i++){
	CLR  R4
	CLR  R5
_0x63:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CP   R4,R30
	CPC  R5,R31
	BRSH _0x64
; 0000 004D         for(j=0; j<maxMenuitemsY ; j++){
	CLR  R6
	CLR  R7
_0x66:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CP   R6,R30
	CPC  R7,R31
	BRSH _0x67
; 0000 004E             EEPROM_ReadPage(DeviceAddress, MemAddress, tempStr, SM[i][j].len);
	CALL SUBOPT_0x15
	CALL SUBOPT_0x16
	MOVW R26,R22
	ADD  R26,R30
	ADC  R27,R31
	ADIW R26,16
	LD   R26,X
	CALL SUBOPT_0x13
; 0000 004F             delay_ms(10);
; 0000 0050             MemAddress += buffSize ;
	CALL SUBOPT_0x14
; 0000 0051             sprintf(SM[i][j].Name,"%s",tempStr);
	CALL SUBOPT_0x16
	ADD  R30,R22
	ADC  R31,R23
	CALL SUBOPT_0xA
	LDI  R30,LOW(_tempStr)
	LDI  R31,HIGH(_tempStr)
	CALL SUBOPT_0xC
; 0000 0052         }
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
	RJMP _0x66
_0x67:
; 0000 0053     }
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
	RJMP _0x63
_0x64:
; 0000 0054     lcd_clear();
	CALL SUBOPT_0x17
; 0000 0055     lcd_gotoxy(4, 0);
; 0000 0056     lcd_puts("DPSys.co");
	__POINTW2MN _0x68,0
	CALL SUBOPT_0x9
; 0000 0057     lcd_gotoxy(0, 1);
; 0000 0058     lcd_puts("Pass Key :");
	__POINTW2MN _0x68,9
	RCALL _lcd_puts
; 0000 0059 
; 0000 005A     while (1)
_0x69:
; 0000 005B     {
; 0000 005C         // Place progrram
; 0000 005D     }
	RJMP _0x69
; 0000 005E }
_0x6C:
	RJMP _0x6C
; .FEND

	.DSEG
_0x68:
	.BYTE 0x14
;
;void KeyAction(char KeyPress)
; 0000 0061 {

	.CSEG
_KeyAction:
; .FSTART _KeyAction
; 0000 0062     if(kpass == 0)
	ST   -Y,R26
;	KeyPress -> Y+0
	LDS  R30,_kpass
	LDS  R31,_kpass+1
	SBIW R30,0
	BREQ PC+2
	RJMP _0x6D
; 0000 0063     {
; 0000 0064         switch(KeyPress)
	LD   R30,Y
	CALL SUBOPT_0xD
; 0000 0065         {
; 0000 0066             case 10 : {
	BRNE _0x71
; 0000 0067                 strcpyf(usr_code, "");
	CALL SUBOPT_0x18
	CALL SUBOPT_0x19
; 0000 0068                 usr_code_idx = 0;
; 0000 0069                 lcd_clear();
	CALL SUBOPT_0x17
; 0000 006A                 lcd_gotoxy(4, 0);
; 0000 006B                 lcd_puts("DPSys.co");
	__POINTW2MN _0x72,0
	CALL SUBOPT_0x9
; 0000 006C                 lcd_gotoxy(0, 1);
; 0000 006D                 lcd_puts("Pass Key :");
	__POINTW2MN _0x72,9
	RCALL _lcd_puts
; 0000 006E             }; break;
	RJMP _0x70
; 0000 006F             case 11 : {
_0x71:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0x76
; 0000 0070                 usr_code[usr_code_idx] = '\0';
	LDS  R30,_usr_code_idx
	LDI  R31,0
	SUBI R30,LOW(-_usr_code)
	SBCI R31,HIGH(-_usr_code)
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 0071                 // user code equals to system code
; 0000 0072                 if(strcmp(usr_code, sys_code) == 0)
	CALL SUBOPT_0x18
	LDI  R26,LOW(_sys_code)
	LDI  R27,HIGH(_sys_code)
	CALL _strcmp
	CPI  R30,0
	BRNE _0x74
; 0000 0073                 {
; 0000 0074                   lcd_clear();
	RCALL _lcd_clear
; 0000 0075                   lcd_gotoxy(3, 0);
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _lcd_gotoxy
; 0000 0076                   lcd_putsf("Lock : ON");
	__POINTW2FN _0x0,107
	RCALL _lcd_putsf
; 0000 0077                   delay_ms(1000);
	CALL SUBOPT_0x7
; 0000 0078                   lcd_clear();
	CALL SUBOPT_0x5
; 0000 0079                   lcd_gotoxy(0, 0);
	LDI  R26,LOW(0)
	RCALL _lcd_gotoxy
; 0000 007A                   sprintf(tempStr,"%s",MM[0].Name);
	LDI  R30,LOW(_tempStr)
	LDI  R31,HIGH(_tempStr)
	CALL SUBOPT_0xA
	LDI  R30,LOW(_MM)
	LDI  R31,HIGH(_MM)
	CALL SUBOPT_0xC
; 0000 007B                   lcd_puts(tempStr);
	LDI  R26,LOW(_tempStr)
	LDI  R27,HIGH(_tempStr)
	RCALL _lcd_puts
; 0000 007C                   kpass = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _kpass,R30
	STS  _kpass+1,R31
; 0000 007D                   //while(GetKey() != DELETE);
; 0000 007E                   }
; 0000 007F                 // user code is invalid
; 0000 0080                 else
	RJMP _0x75
_0x74:
; 0000 0081                 {
; 0000 0082                   lcd_clear();
	RCALL _lcd_clear
; 0000 0083                   lcd_putsf("Invalid Password");
	__POINTW2FN _0x0,117
	RCALL _lcd_putsf
; 0000 0084                   delay_ms(2000);
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	CALL _delay_ms
; 0000 0085                 }
_0x75:
; 0000 0086                 // clear the user code buffer
; 0000 0087                 strcpyf(usr_code, "");
	CALL SUBOPT_0x18
	CALL SUBOPT_0x19
; 0000 0088                 usr_code_idx = 0;
; 0000 0089             }; break;
	RJMP _0x70
; 0000 008A 
; 0000 008B             default : {
_0x76:
; 0000 008C                 if(usr_code_idx < sizeof(usr_code) - 1)
	LDS  R26,_usr_code_idx
	CPI  R26,LOW(0x4)
	BRSH _0x77
; 0000 008D                 {
; 0000 008E                     usr_code[usr_code_idx] = KeyPress + 0x30; // save the ascii code of digit
	LDI  R27,0
	SUBI R26,LOW(-_usr_code)
	SBCI R27,HIGH(-_usr_code)
	LD   R30,Y
	SUBI R30,-LOW(48)
	ST   X,R30
; 0000 008F                     usr_code_idx++;
	LDS  R30,_usr_code_idx
	SUBI R30,-LOW(1)
	STS  _usr_code_idx,R30
; 0000 0090                     lcd_putchar('*');
	LDI  R26,LOW(42)
	RCALL _lcd_putchar
; 0000 0091                     //lcd_puts(usr_code);
; 0000 0092                 }
; 0000 0093             }
_0x77:
; 0000 0094         }
_0x70:
; 0000 0095     }else {
	RJMP _0x78
_0x6D:
; 0000 0096         if(zone == 0) {
	MOV  R0,R8
	OR   R0,R9
	BREQ PC+2
	RJMP _0x79
; 0000 0097             switch(KeyPress)
	LD   R30,Y
	CALL SUBOPT_0xD
; 0000 0098             {
; 0000 0099                case 10 : ; break;       // DELETE *
	BRNE _0x7D
	RJMP _0x7C
; 0000 009A                case 11 : zone++; break; // ENTER  #
_0x7D:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0x7E
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
	RJMP _0x7C
; 0000 009B                case 12 : showDateTime(); break;
_0x7E:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0x7F
	RCALL _showDateTime
	RJMP _0x7C
; 0000 009C                case 13 : ; break;
_0x7F:
	CPI  R30,LOW(0xD)
	LDI  R26,HIGH(0xD)
	CPC  R31,R26
	BREQ _0x7C
; 0000 009D                case 14 :                // UP F14
	CPI  R30,LOW(0xE)
	LDI  R26,HIGH(0xE)
	CPC  R31,R26
	BRNE _0x81
; 0000 009E                {
; 0000 009F                     if(mmz ==  maxMenuitemsX-1 | mmz != 0 ) mmz--;
	MOVW R26,R10
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __EQW12
	MOV  R0,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __NEW12
	OR   R30,R0
	BREQ _0x82
	MOVW R30,R10
	SBIW R30,1
	RJMP _0x9B
; 0000 00A0                     else mmz=maxMenuitemsX-1;
_0x82:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
_0x9B:
	MOVW R10,R30
; 0000 00A1                }
; 0000 00A2                ;break;
	RJMP _0x7C
; 0000 00A3                case 15 :                // DOWN F15
_0x81:
	CPI  R30,LOW(0xF)
	LDI  R26,HIGH(0xF)
	CPC  R31,R26
	BRNE _0x7C
; 0000 00A4                {
; 0000 00A5                     if(mmz == 0 | mmz != maxMenuitemsX-1) mmz++;
	MOVW R26,R10
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EQW12
	MOV  R0,R30
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __NEW12
	OR   R30,R0
	BREQ _0x85
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
; 0000 00A6                     else mmz=0;
	RJMP _0x86
_0x85:
	CLR  R10
	CLR  R11
; 0000 00A7                }
_0x86:
; 0000 00A8                ; break;
; 0000 00A9             }
_0x7C:
; 0000 00AA             makeScreen(zone, mmz, smz);
	RJMP _0x9C
; 0000 00AB         }else {
_0x79:
; 0000 00AC             switch(KeyPress)
	LD   R30,Y
	CALL SUBOPT_0xD
; 0000 00AD             {
; 0000 00AE                 case 10 : {zone--; smz=0;}; break;
	BRNE _0x8B
	MOVW R30,R8
	SBIW R30,1
	MOVW R8,R30
	RJMP _0x9D
; 0000 00AF                 case 11 : {
_0x8B:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0x8C
; 0000 00B0                         switch(mmz*10 + smz)
	MOVW R30,R10
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12
	ADD  R30,R12
	ADC  R31,R13
; 0000 00B1                         {
; 0000 00B2                             case 0 : {lcd_puts("HALLO"); delay_ms(500);}; break;
	SBIW R30,0
	BRNE _0x90
	__POINTW2MN _0x72,20
	CALL SUBOPT_0x10
	RJMP _0x8F
; 0000 00B3                             case 1 : ; break;
_0x90:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ _0x8F
; 0000 00B4                             case 20 : menu1(); break;
	CPI  R30,LOW(0x14)
	LDI  R26,HIGH(0x14)
	CPC  R31,R26
	BRNE _0x92
	RCALL _menu1
	RJMP _0x8F
; 0000 00B5                             case 22 : showDateTime();break;
_0x92:
	CPI  R30,LOW(0x16)
	LDI  R26,HIGH(0x16)
	CPC  R31,R26
	BRNE _0x8F
	RCALL _showDateTime
; 0000 00B6                         }
_0x8F:
; 0000 00B7 
; 0000 00B8                 }; break;
	RJMP _0x8A
; 0000 00B9                 case 14 :              // UP F14
_0x8C:
	CPI  R30,LOW(0xE)
	LDI  R26,HIGH(0xE)
	CPC  R31,R26
	BRNE _0x94
; 0000 00BA                 {
; 0000 00BB                     if(smz ==  maxMenuitemsY-1 | smz != 0 ) smz--;
	MOVW R26,R12
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __EQW12
	MOV  R0,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __NEW12
	OR   R30,R0
	BREQ _0x95
	MOVW R30,R12
	SBIW R30,1
	RJMP _0x9E
; 0000 00BC                     else smz=maxMenuitemsY-1;
_0x95:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
_0x9E:
	MOVW R12,R30
; 0000 00BD                 };break;
	RJMP _0x8A
; 0000 00BE                 case 15 :             // DOWN F15
_0x94:
	CPI  R30,LOW(0xF)
	LDI  R26,HIGH(0xF)
	CPC  R31,R26
	BRNE _0x8A
; 0000 00BF                 {
; 0000 00C0                     if(smz == 0 | smz != maxMenuitemsY-1) smz++;
	MOVW R26,R12
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EQW12
	MOV  R0,R30
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __NEW12
	OR   R30,R0
	BREQ _0x98
	MOVW R30,R12
	ADIW R30,1
	MOVW R12,R30
; 0000 00C1                     else smz=0;
	RJMP _0x99
_0x98:
_0x9D:
	CLR  R12
	CLR  R13
; 0000 00C2                 }; break;
_0x99:
; 0000 00C3             }
_0x8A:
; 0000 00C4             makeScreen(zone, mmz, smz);
_0x9C:
	ST   -Y,R9
	ST   -Y,R8
	ST   -Y,R11
	ST   -Y,R10
	MOVW R26,R12
	RCALL _makeScreen
; 0000 00C5         }
; 0000 00C6     }
_0x78:
; 0000 00C7 }
	RJMP _0x20C0004
; .FEND

	.DSEG
_0x72:
	.BYTE 0x1A
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
; .FSTART __lcd_write_nibble_G100
	ST   -Y,R26
	IN   R30,0x18
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x18,R30
	__DELAY_USB 2
	SBI  0x18,2
	__DELAY_USB 2
	CBI  0x18,2
	__DELAY_USB 2
	RJMP _0x20C0004
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 17
	RJMP _0x20C0004
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	CALL SUBOPT_0x1A
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0x1A
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2000005
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2000004
_0x2000005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R26,__lcd_y
	SUBI R26,-LOW(1)
	STS  __lcd_y,R26
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2000007
	RJMP _0x20C0004
_0x2000007:
_0x2000004:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	SBI  0x18,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x18,0
	RJMP _0x20C0004
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2000008:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x200000A
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2000008
_0x200000A:
	RJMP _0x20C0005
; .FEND
_lcd_putsf:
; .FSTART _lcd_putsf
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x200000B:
	CALL SUBOPT_0x1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x200000D
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x200000B
_0x200000D:
_0x20C0005:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	IN   R30,0x17
	ORI  R30,LOW(0xF0)
	OUT  0x17,R30
	SBI  0x17,2
	SBI  0x17,0
	SBI  0x17,1
	CBI  0x18,2
	CBI  0x18,0
	CBI  0x18,1
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1B
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 33
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x20C0004:
	ADIW R28,1
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_buff_G101:
; .FSTART _put_buff_G101
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2020010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2020012
	__CPWRN 16,17,2
	BRLO _0x2020013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2020012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2020013:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2020014
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
_0x2020014:
	RJMP _0x2020015
_0x2020010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2020015:
	LDD  R17,Y+1
	LDD  R16,Y+0
_0x20C0003:
	ADIW R28,5
	RET
; .FEND
__print_G101:
; .FSTART __print_G101
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2020016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2020018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x202001C
	CPI  R18,37
	BRNE _0x202001D
	LDI  R17,LOW(1)
	RJMP _0x202001E
_0x202001D:
	CALL SUBOPT_0x1C
_0x202001E:
	RJMP _0x202001B
_0x202001C:
	CPI  R30,LOW(0x1)
	BRNE _0x202001F
	CPI  R18,37
	BRNE _0x2020020
	CALL SUBOPT_0x1C
	RJMP _0x20200CC
_0x2020020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2020021
	LDI  R16,LOW(1)
	RJMP _0x202001B
_0x2020021:
	CPI  R18,43
	BRNE _0x2020022
	LDI  R20,LOW(43)
	RJMP _0x202001B
_0x2020022:
	CPI  R18,32
	BRNE _0x2020023
	LDI  R20,LOW(32)
	RJMP _0x202001B
_0x2020023:
	RJMP _0x2020024
_0x202001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2020025
_0x2020024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2020026
	ORI  R16,LOW(128)
	RJMP _0x202001B
_0x2020026:
	RJMP _0x2020027
_0x2020025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x202001B
_0x2020027:
	CPI  R18,48
	BRLO _0x202002A
	CPI  R18,58
	BRLO _0x202002B
_0x202002A:
	RJMP _0x2020029
_0x202002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x202001B
_0x2020029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x202002F
	CALL SUBOPT_0x1D
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x1E
	RJMP _0x2020030
_0x202002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2020032
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x1F
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2020033
_0x2020032:
	CPI  R30,LOW(0x70)
	BRNE _0x2020035
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x1F
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2020033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2020036
_0x2020035:
	CPI  R30,LOW(0x64)
	BREQ _0x2020039
	CPI  R30,LOW(0x69)
	BRNE _0x202003A
_0x2020039:
	ORI  R16,LOW(4)
	RJMP _0x202003B
_0x202003A:
	CPI  R30,LOW(0x75)
	BRNE _0x202003C
_0x202003B:
	LDI  R30,LOW(_tbl10_G101*2)
	LDI  R31,HIGH(_tbl10_G101*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x202003D
_0x202003C:
	CPI  R30,LOW(0x58)
	BRNE _0x202003F
	ORI  R16,LOW(8)
	RJMP _0x2020040
_0x202003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2020071
_0x2020040:
	LDI  R30,LOW(_tbl16_G101*2)
	LDI  R31,HIGH(_tbl16_G101*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x202003D:
	SBRS R16,2
	RJMP _0x2020042
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x20
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2020043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2020043:
	CPI  R20,0
	BREQ _0x2020044
	SUBI R17,-LOW(1)
	RJMP _0x2020045
_0x2020044:
	ANDI R16,LOW(251)
_0x2020045:
	RJMP _0x2020046
_0x2020042:
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x20
_0x2020046:
_0x2020036:
	SBRC R16,0
	RJMP _0x2020047
_0x2020048:
	CP   R17,R21
	BRSH _0x202004A
	SBRS R16,7
	RJMP _0x202004B
	SBRS R16,2
	RJMP _0x202004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x202004D
_0x202004C:
	LDI  R18,LOW(48)
_0x202004D:
	RJMP _0x202004E
_0x202004B:
	LDI  R18,LOW(32)
_0x202004E:
	CALL SUBOPT_0x1C
	SUBI R21,LOW(1)
	RJMP _0x2020048
_0x202004A:
_0x2020047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x202004F
_0x2020050:
	CPI  R19,0
	BREQ _0x2020052
	SBRS R16,3
	RJMP _0x2020053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2020054
_0x2020053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2020054:
	CALL SUBOPT_0x1C
	CPI  R21,0
	BREQ _0x2020055
	SUBI R21,LOW(1)
_0x2020055:
	SUBI R19,LOW(1)
	RJMP _0x2020050
_0x2020052:
	RJMP _0x2020056
_0x202004F:
_0x2020058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x202005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x202005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x202005A
_0x202005C:
	CPI  R18,58
	BRLO _0x202005D
	SBRS R16,3
	RJMP _0x202005E
	SUBI R18,-LOW(7)
	RJMP _0x202005F
_0x202005E:
	SUBI R18,-LOW(39)
_0x202005F:
_0x202005D:
	SBRC R16,4
	RJMP _0x2020061
	CPI  R18,49
	BRSH _0x2020063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2020062
_0x2020063:
	RJMP _0x20200CD
_0x2020062:
	CP   R21,R19
	BRLO _0x2020067
	SBRS R16,0
	RJMP _0x2020068
_0x2020067:
	RJMP _0x2020066
_0x2020068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2020069
	LDI  R18,LOW(48)
_0x20200CD:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x202006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0x1E
	CPI  R21,0
	BREQ _0x202006B
	SUBI R21,LOW(1)
_0x202006B:
_0x202006A:
_0x2020069:
_0x2020061:
	CALL SUBOPT_0x1C
	CPI  R21,0
	BREQ _0x202006C
	SUBI R21,LOW(1)
_0x202006C:
_0x2020066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2020059
	RJMP _0x2020058
_0x2020059:
_0x2020056:
	SBRS R16,0
	RJMP _0x202006D
_0x202006E:
	CPI  R21,0
	BREQ _0x2020070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x1E
	RJMP _0x202006E
_0x2020070:
_0x202006D:
_0x2020071:
_0x2020030:
_0x20200CC:
	LDI  R17,LOW(0)
_0x202001B:
	RJMP _0x2020016
_0x2020018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x21
	SBIW R30,0
	BRNE _0x2020072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20C0002
_0x2020072:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x21
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G101)
	LDI  R31,HIGH(_put_buff_G101)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G101
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x20C0002:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
; .FEND

	.CSEG
_strcmp:
; .FSTART _strcmp
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
strcmp0:
    ld   r22,x+
    ld   r23,z+
    cp   r22,r23
    brne strcmp1
    tst  r22
    brne strcmp0
strcmp3:
    clr  r30
    ret
strcmp1:
    sub  r22,r23
    breq strcmp3
    ldi  r30,1
    brcc strcmp2
    subi r30,2
strcmp2:
    ret
; .FEND
_strcpy:
; .FSTART _strcpy
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcpy0:
    ld   r22,z+
    st   x+,r22
    tst  r22
    brne strcpy0
    movw r30,r24
    ret
; .FEND
_strcpyf:
; .FSTART _strcpyf
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcpyf0:
	lpm  r0,z+
    st   x+,r0
    tst  r0
    brne strcpyf0
    movw r30,r24
    ret
; .FEND
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND

	.CSEG
_rtc_get_time:
; .FSTART _rtc_get_time
	CALL SUBOPT_0x22
	LDI  R26,LOW(0)
	CALL SUBOPT_0x0
	CALL SUBOPT_0x23
	CALL SUBOPT_0x24
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
	MOV  R26,R30
	CALL _bcd2bin
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ST   X,R30
	CALL _i2c_stop
_0x20C0001:
	ADIW R28,6
	RET
; .FEND
_rtc_get_date:
; .FSTART _rtc_get_date
	CALL SUBOPT_0x22
	LDI  R26,LOW(3)
	CALL SUBOPT_0x0
	CALL SUBOPT_0x23
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ST   X,R30
	CALL SUBOPT_0x25
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ST   X,R30
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
	CALL SUBOPT_0x24
	CALL _i2c_stop
	ADIW R28,8
	RET
; .FEND

	.CSEG

	.CSEG
_bcd2bin:
; .FSTART _bcd2bin
	ST   -Y,R26
    ld   r30,y
    swap r30
    andi r30,0xf
    mov  r26,r30
    lsl  r26
    lsl  r26
    add  r30,r26
    lsl  r30
    ld   r26,y+
    andi r26,0xf
    add  r30,r26
    ret
; .FEND

	.DSEG
_kpass:
	.BYTE 0x2
_MemAddress:
	.BYTE 0x2
_temp:
	.BYTE 0x10
_tempStr:
	.BYTE 0x10
_mStr:
	.BYTE 0x10
_sys_code:
	.BYTE 0x5
_usr_code:
	.BYTE 0x5
_usr_code_idx:
	.BYTE 0x1
_setPass:
	.BYTE 0x5
_MM:
	.BYTE 0x33
_SM:
	.BYTE 0x99
_d:
	.BYTE 0x4
_t:
	.BYTE 0x3
__base_y_G100:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	CALL _i2c_write
	JMP  _i2c_stop

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2:
	IN   R30,0x19
	ANDI R30,LOW(0xF)
	MOV  R16,R30
	CPI  R16,15
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3:
	MOV  R30,R16
	LDI  R31,0
	CPI  R30,LOW(0xE)
	LDI  R26,HIGH(0xE)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x4:
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x5:
	CALL _lcd_clear
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	CALL _lcd_gotoxy
	LDI  R26,LOW(_mStr)
	LDI  R27,HIGH(_mStr)
	JMP  _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x8:
	LDI  R26,LOW(0)
	CALL _lcd_gotoxy
	LDI  R30,LOW(_tempStr)
	LDI  R31,HIGH(_tempStr)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,39
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(17)
	CALL __MULB1W2U
	SUBI R30,LOW(-_MM)
	SBCI R31,HIGH(-_MM)
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	LDI  R26,LOW(_tempStr)
	LDI  R27,HIGH(_tempStr)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x9:
	CALL _lcd_puts
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xA:
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,39
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB:
	MOVW R22,R26
	LDI  R26,LOW(17)
	LDI  R27,HIGH(17)
	CALL __MULW12U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0xC:
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xD:
	LDI  R31,0
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xE:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _MemAddress,R30
	STS  _MemAddress+1,R31
	LDI  R30,LOW(160)
	ST   -Y,R30
	LDS  R30,_MemAddress
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xF:
	LDI  R26,LOW(10)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	CALL _lcd_puts
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	SBI  0x15,0
	LDI  R26,LOW(50)
	LDI  R27,0
	CALL _delay_ms
	CBI  0x15,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x12:
	LDI  R30,LOW(_tempStr)
	LDI  R31,HIGH(_tempStr)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13:
	CALL _EEPROM_ReadPage
	RJMP SUBOPT_0xF

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x14:
	LDS  R30,_MemAddress
	LDS  R31,_MemAddress+1
	ADIW R30,16
	STS  _MemAddress,R30
	STS  _MemAddress+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x15:
	LDI  R30,LOW(160)
	ST   -Y,R30
	LDS  R30,_MemAddress
	ST   -Y,R30
	RJMP SUBOPT_0x12

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x16:
	MOVW R30,R4
	LDI  R26,LOW(51)
	LDI  R27,HIGH(51)
	CALL __MULW12U
	SUBI R30,LOW(-_SM)
	SBCI R31,HIGH(-_SM)
	MOVW R26,R30
	MOVW R30,R6
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x17:
	CALL _lcd_clear
	LDI  R30,LOW(4)
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x18:
	LDI  R30,LOW(_usr_code)
	LDI  R31,HIGH(_usr_code)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x19:
	__POINTW2FN _0x0,23
	CALL _strcpyf
	LDI  R30,LOW(0)
	STS  _usr_code_idx,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1A:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1B:
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G100
	__DELAY_USB 33
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x1C:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1D:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1E:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1F:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x20:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x21:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x22:
	ST   -Y,R27
	ST   -Y,R26
	CALL _i2c_start
	LDI  R26,LOW(208)
	JMP  _i2c_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x23:
	CALL _i2c_start
	LDI  R26,LOW(209)
	CALL _i2c_write
	LDI  R26,LOW(1)
	JMP  _i2c_read

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x24:
	MOV  R26,R30
	CALL _bcd2bin
	LD   R26,Y
	LDD  R27,Y+1
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x25:
	LDI  R26,LOW(1)
	CALL _i2c_read
	MOV  R26,R30
	JMP  _bcd2bin

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x26:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ST   X,R30
	LDI  R26,LOW(0)
	JMP  _i2c_read


	.CSEG
	.equ __sda_bit=1
	.equ __scl_bit=0
	.equ __i2c_port=0x12 ;PORTD
	.equ __i2c_dir=__i2c_port-1
	.equ __i2c_pin=__i2c_port-2

_i2c_init:
	cbi  __i2c_port,__scl_bit
	cbi  __i2c_port,__sda_bit
	sbi  __i2c_dir,__scl_bit
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay2
_i2c_start:
	cbi  __i2c_dir,__sda_bit
	cbi  __i2c_dir,__scl_bit
	clr  r30
	nop
	sbis __i2c_pin,__sda_bit
	ret
	sbis __i2c_pin,__scl_bit
	ret
	rcall __i2c_delay1
	sbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	ldi  r30,1
__i2c_delay1:
	ldi  r22,2
	rjmp __i2c_delay2l
_i2c_stop:
	sbi  __i2c_dir,__sda_bit
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
__i2c_delay2:
	ldi  r22,3
__i2c_delay2l:
	dec  r22
	brne __i2c_delay2l
	ret
_i2c_read:
	ldi  r23,8
__i2c_read0:
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_read3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_read3
	rcall __i2c_delay1
	clc
	sbic __i2c_pin,__sda_bit
	sec
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	rol  r30
	dec  r23
	brne __i2c_read0
	mov  r23,r26
	tst  r23
	brne __i2c_read1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_read2
__i2c_read1:
	sbi  __i2c_dir,__sda_bit
__i2c_read2:
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay1

_i2c_write:
	ldi  r23,8
__i2c_write0:
	lsl  r26
	brcc __i2c_write1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_write2
__i2c_write1:
	sbi  __i2c_dir,__sda_bit
__i2c_write2:
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_write3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_write3
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	dec  r23
	brne __i2c_write0
	cbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	ldi  r30,1
	sbic __i2c_pin,__sda_bit
	clr  r30
	sbi  __i2c_dir,__scl_bit
	rjmp __i2c_delay1

_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	wdr
	__DELAY_USW 0xFA
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__EQW12:
	CP   R30,R26
	CPC  R31,R27
	LDI  R30,1
	BREQ __EQW12T
	CLR  R30
__EQW12T:
	RET

__NEW12:
	CP   R30,R26
	CPC  R31,R27
	LDI  R30,1
	BRNE __NEW12T
	CLR  R30
__NEW12T:
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULB1W2U:
	MOV  R22,R30
	MUL  R22,R26
	MOVW R30,R0
	MUL  R22,R27
	ADD  R31,R0
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
