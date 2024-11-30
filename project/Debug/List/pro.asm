
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega32
;Program type           : Application
;Clock frequency        : 1.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
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

	#pragma AVRPART ADMIN PART_NAME ATmega32
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
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
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
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
	.DEF __lcd_x=R5
	.DEF __lcd_y=R4
	.DEF __lcd_maxx=R7

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
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
	JMP  0x00

_0x3:
	.DB  0xF,0xF,0xF,0xF
_0x0:
	.DB  0x43,0x68,0x6F,0x6F,0x73,0x65,0x20,0x46
	.DB  0x6F,0x6F,0x64,0x0,0x41,0x20,0x42,0x20
	.DB  0x43,0x20,0x44,0x0,0x46,0x6F,0x6F,0x64
	.DB  0x20,0x41,0x0,0x50,0x72,0x69,0x63,0x65
	.DB  0x3D,0x35,0x30,0x20,0x63,0x65,0x6E,0x74
	.DB  0x0,0x70,0x61,0x69,0x64,0x0,0x65,0x78
	.DB  0x74,0x72,0x61,0x20,0x70,0x61,0x69,0x64
	.DB  0x0,0x46,0x6F,0x6F,0x64,0x20,0x42,0x0
	.DB  0x50,0x72,0x69,0x63,0x65,0x3D,0x36,0x35
	.DB  0x20,0x63,0x65,0x6E,0x74,0x0,0x46,0x6F
	.DB  0x6F,0x64,0x20,0x43,0x0,0x50,0x72,0x69
	.DB  0x63,0x65,0x3D,0x37,0x37,0x20,0x63,0x65
	.DB  0x6E,0x74,0x0,0x46,0x6F,0x6F,0x64,0x20
	.DB  0x44,0x0,0x50,0x72,0x69,0x63,0x65,0x3D
	.DB  0x36,0x33,0x20,0x63,0x65,0x6E,0x74,0x0
_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x04
	.DW  _data
	.DW  _0x3*2

	.DW  0x0C
	.DW  _0xC
	.DW  _0x0*2

	.DW  0x08
	.DW  _0xC+12
	.DW  _0x0*2+12

	.DW  0x07
	.DW  _0xC+20
	.DW  _0x0*2+20

	.DW  0x0E
	.DW  _0xC+27
	.DW  _0x0*2+27

	.DW  0x05
	.DW  _0xC+41
	.DW  _0x0*2+41

	.DW  0x0B
	.DW  _0xC+46
	.DW  _0x0*2+46

	.DW  0x07
	.DW  _0xC+57
	.DW  _0x0*2+57

	.DW  0x0E
	.DW  _0xC+64
	.DW  _0x0*2+64

	.DW  0x05
	.DW  _0xC+78
	.DW  _0x0*2+41

	.DW  0x0B
	.DW  _0xC+83
	.DW  _0x0*2+46

	.DW  0x07
	.DW  _0xC+94
	.DW  _0x0*2+78

	.DW  0x0E
	.DW  _0xC+101
	.DW  _0x0*2+85

	.DW  0x05
	.DW  _0xC+115
	.DW  _0x0*2+41

	.DW  0x0B
	.DW  _0xC+120
	.DW  _0x0*2+46

	.DW  0x07
	.DW  _0xC+131
	.DW  _0x0*2+99

	.DW  0x0E
	.DW  _0xC+138
	.DW  _0x0*2+106

	.DW  0x05
	.DW  _0xC+152
	.DW  _0x0*2+41

	.DW  0x0B
	.DW  _0xC+157
	.DW  _0x0*2+46

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
	.ORG 0x260

	.CSEG
;#include <mega32.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <alcd.h>
;
;unsigned char data[4]={0x0f,0x0f,0x0f,0x0f};

	.DSEG
;
;void display(void)
; 0000 0008 {

	.CSEG
_display:
; .FSTART _display
; 0000 0009 register unsigned char i;
; 0000 000A unsigned char select[4]={0x80,0x40,0x20,0x10};
; 0000 000B for(i=0;i<4;i++){
	SBIW R28,4
	LDI  R30,LOW(128)
	ST   Y,R30
	LDI  R30,LOW(64)
	STD  Y+1,R30
	LDI  R30,LOW(32)
	STD  Y+2,R30
	LDI  R30,LOW(16)
	STD  Y+3,R30
	ST   -Y,R17
;	i -> R17
;	select -> Y+1
	LDI  R17,LOW(0)
_0x5:
	CPI  R17,4
	BRSH _0x6
; 0000 000C PORTD=data[i];
	CALL SUBOPT_0x0
	LD   R30,Z
	OUT  0x12,R30
; 0000 000D PORTD=PORTD | select[i];
	IN   R0,18
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,1
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	OR   R30,R0
	OUT  0x12,R30
; 0000 000E delay_ms(5);
	LDI  R26,LOW(5)
	LDI  R27,0
	CALL _delay_ms
; 0000 000F PORTD=0x0f;
	LDI  R30,LOW(15)
	OUT  0x12,R30
; 0000 0010 }
	SUBI R17,-1
	RJMP _0x5
_0x6:
; 0000 0011 }
	LDD  R17,Y+0
	ADIW R28,5
	RET
; .FEND
;
;void main(void)
; 0000 0014 {
_main:
; .FSTART _main
; 0000 0015 
; 0000 0016 // Declare your local variables here
; 0000 0017 unsigned char j;
; 0000 0018 unsigned int c,p1,q,i1,i2,i4,x=0;
; 0000 0019 int i3,a,a1=0;
; 0000 001A // Input/Output Ports initialization
; 0000 001B // Port A initialization
; 0000 001C // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 001D DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	SBIW R28,16
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	STD  Y+3,R30
	STD  Y+4,R30
	STD  Y+5,R30
	STD  Y+6,R30
	STD  Y+7,R30
;	j -> R17
;	c -> R18,R19
;	p1 -> R20,R21
;	q -> Y+14
;	i1 -> Y+12
;	i2 -> Y+10
;	i4 -> Y+8
;	x -> Y+6
;	i3 -> Y+4
;	a -> Y+2
;	a1 -> Y+0
	OUT  0x1A,R30
; 0000 001E // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 001F PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	OUT  0x1B,R30
; 0000 0020 
; 0000 0021 // Port B initialization
; 0000 0022 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0023 DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	OUT  0x17,R30
; 0000 0024 // State: Bit7=P Bit6=P Bit5=P Bit4=P Bit3=P Bit2=P Bit1=P Bit0=P
; 0000 0025 PORTB=(1<<PORTB7) | (1<<PORTB6) | (1<<PORTB5) | (1<<PORTB4) | (1<<PORTB3) | (1<<PORTB2) | (1<<PORTB1) | (1<<PORTB0);
	LDI  R30,LOW(255)
	OUT  0x18,R30
; 0000 0026 
; 0000 0027 // Port C initialization
; 0000 0028 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0029 DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
	LDI  R30,LOW(0)
	OUT  0x14,R30
; 0000 002A // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 002B PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	OUT  0x15,R30
; 0000 002C 
; 0000 002D // Port D initialization
; 0000 002E // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 002F 
; 0000 0030 DDRD=0xff;
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 0031 PORTD=0x0f;
	LDI  R30,LOW(15)
	OUT  0x12,R30
; 0000 0032 
; 0000 0033 TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 0034 TCNT0=0x00;
	OUT  0x32,R30
; 0000 0035 OCR0=0x00;
	OUT  0x3C,R30
; 0000 0036 TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 0037 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 0038 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 0039 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 003A ICR1H=0x00;
	OUT  0x27,R30
; 0000 003B ICR1L=0x00;
	OUT  0x26,R30
; 0000 003C OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 003D OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 003E OCR1BH=0x00;
	OUT  0x29,R30
; 0000 003F OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0040 
; 0000 0041 // Timer/Counter 2 initialization
; 0000 0042 // Clock source: System Clock
; 0000 0043 // Clock value: Timer2 Stopped
; 0000 0044 // Mode: Normal top=0xFF
; 0000 0045 // OC2 output: Disconnected
; 0000 0046 ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 0047 TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 0048 TCNT2=0x00;
	OUT  0x24,R30
; 0000 0049 OCR2=0x00;
	OUT  0x23,R30
; 0000 004A 
; 0000 004B // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 004C TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	OUT  0x39,R30
; 0000 004D 
; 0000 004E // External Interrupt(s) initialization
; 0000 004F // INT0: Off
; 0000 0050 // INT1: Off
; 0000 0051 // INT2: Off
; 0000 0052 MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	OUT  0x35,R30
; 0000 0053 MCUCSR=(0<<ISC2);
	OUT  0x34,R30
; 0000 0054 
; 0000 0055 // USART initialization
; 0000 0056 // USART disabled
; 0000 0057 UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	OUT  0xA,R30
; 0000 0058 
; 0000 0059 
; 0000 005A ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 005B SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 005C 
; 0000 005D // ADC initialization
; 0000 005E // ADC disabled
; 0000 005F ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	OUT  0x6,R30
; 0000 0060 
; 0000 0061 // SPI initialization
; 0000 0062 // SPI disabled
; 0000 0063 SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 0064 
; 0000 0065 // TWI initialization
; 0000 0066 // TWI disabled
; 0000 0067 TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 0068 
; 0000 0069 // Characters/line: 16
; 0000 006A lcd_init(16);
	LDI  R26,LOW(16)
	RCALL _lcd_init
; 0000 006B 
; 0000 006C while (1)
_0x7:
; 0000 006D       {
; 0000 006E 
; 0000 006F l1:
_0xA:
; 0000 0070 
; 0000 0071 
; 0000 0072 if(c==0)
	MOV  R0,R18
	OR   R0,R19
	BRNE _0xB
; 0000 0073      {
; 0000 0074      lcd_clear();
	RCALL _lcd_clear
; 0000 0075      lcd_puts("Choose Food");
	__POINTW2MN _0xC,0
	CALL SUBOPT_0x1
; 0000 0076      lcd_gotoxy(0,1);
; 0000 0077      lcd_puts("A B C D");
	__POINTW2MN _0xC,12
	RCALL _lcd_puts
; 0000 0078      c++;
	__ADDWRN 18,19,1
; 0000 0079      }
; 0000 007A 
; 0000 007B 
; 0000 007C 
; 0000 007D      if(PINB.0==0)
_0xB:
	SBIC 0x16,0
	RJMP _0xD
; 0000 007E       {
; 0000 007F       delay_ms(20);
	CALL SUBOPT_0x2
; 0000 0080       while(PINB.0==0);
_0xE:
	SBIS 0x16,0
	RJMP _0xE
; 0000 0081       if(p1>0)
	CLR  R0
	CP   R0,R20
	CPC  R0,R21
	BRSH _0x11
; 0000 0082       {i1=i1+10;}
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	ADIW R30,10
	STD  Y+12,R30
	STD  Y+12+1,R31
; 0000 0083       if(p1==0)
_0x11:
	MOV  R0,R20
	OR   R0,R21
	BRNE _0x12
; 0000 0084       {q=1;}
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STD  Y+14,R30
	STD  Y+14+1,R31
; 0000 0085       p1++;
_0x12:
	__ADDWRN 20,21,1
; 0000 0086       }
; 0000 0087 
; 0000 0088       if(PINB.1==0)
_0xD:
	SBIC 0x16,1
	RJMP _0x13
; 0000 0089       {
; 0000 008A       delay_ms(20);
	RCALL SUBOPT_0x2
; 0000 008B       while(PINB.1==0);
_0x14:
	SBIS 0x16,1
	RJMP _0x14
; 0000 008C       if(p1>0)
	CLR  R0
	CP   R0,R20
	CPC  R0,R21
	BRSH _0x17
; 0000 008D       {i1=i1+5;}
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	ADIW R30,5
	STD  Y+12,R30
	STD  Y+12+1,R31
; 0000 008E       if(p1==0)
_0x17:
	MOV  R0,R20
	OR   R0,R21
	BRNE _0x18
; 0000 008F       {q=2;}
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STD  Y+14,R30
	STD  Y+14+1,R31
; 0000 0090       p1++;
_0x18:
	__ADDWRN 20,21,1
; 0000 0091       }
; 0000 0092 
; 0000 0093       if(PINB.2==0)
_0x13:
	SBIC 0x16,2
	RJMP _0x19
; 0000 0094       {
; 0000 0095       delay_ms(20);
	RCALL SUBOPT_0x2
; 0000 0096       while(PINB.2==0);
_0x1A:
	SBIS 0x16,2
	RJMP _0x1A
; 0000 0097       if(p1>0)
	CLR  R0
	CP   R0,R20
	CPC  R0,R21
	BRSH _0x1D
; 0000 0098       {i1=i1+1;}
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	ADIW R30,1
	STD  Y+12,R30
	STD  Y+12+1,R31
; 0000 0099       if(p1==0)
_0x1D:
	MOV  R0,R20
	OR   R0,R21
	BRNE _0x1E
; 0000 009A       {q=3;}
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	STD  Y+14,R30
	STD  Y+14+1,R31
; 0000 009B       p1++;
_0x1E:
	__ADDWRN 20,21,1
; 0000 009C       }
; 0000 009D 
; 0000 009E       if(PINB.3==0)
_0x19:
	SBIC 0x16,3
	RJMP _0x1F
; 0000 009F       {
; 0000 00A0       delay_ms(20);
	RCALL SUBOPT_0x2
; 0000 00A1       while(PINB.3==0);
_0x20:
	SBIS 0x16,3
	RJMP _0x20
; 0000 00A2       a1++;
	LD   R30,Y
	LDD  R31,Y+1
	ADIW R30,1
	ST   Y,R30
	STD  Y+1,R31
; 0000 00A3       if(p1>0)
	CLR  R0
	CP   R0,R20
	CPC  R0,R21
	BRSH _0x23
; 0000 00A4       {a++;}
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	ADIW R30,1
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0000 00A5       if(p1==0)
_0x23:
	MOV  R0,R20
	OR   R0,R21
	BRNE _0x24
; 0000 00A6       {q=4;}
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	STD  Y+14,R30
	STD  Y+14+1,R31
; 0000 00A7       p1++;
_0x24:
	__ADDWRN 20,21,1
; 0000 00A8       }
; 0000 00A9 
; 0000 00AA 
; 0000 00AB       if(PINB.4==0)
_0x1F:
	SBIC 0x16,4
	RJMP _0x25
; 0000 00AC       {
; 0000 00AD       delay_ms(20);
	RCALL SUBOPT_0x2
; 0000 00AE       while(PINB.4==0);
_0x26:
	SBIS 0x16,4
	RJMP _0x26
; 0000 00AF       c=0;p1=0;q=0;i1=0;i2=0;i4=0;x=0;
	__GETWRN 18,19,0
	__GETWRN 20,21,0
	LDI  R30,LOW(0)
	STD  Y+14,R30
	STD  Y+14+1,R30
	STD  Y+12,R30
	STD  Y+12+1,R30
	STD  Y+10,R30
	STD  Y+10+1,R30
	STD  Y+8,R30
	STD  Y+8+1,R30
	STD  Y+6,R30
	STD  Y+6+1,R30
; 0000 00B0       i3=0;a=0;a1=0;
	STD  Y+4,R30
	STD  Y+4+1,R30
	STD  Y+2,R30
	STD  Y+2+1,R30
	STD  Y+0,R30
	STD  Y+0+1,R30
; 0000 00B1 
; 0000 00B2        for(j=0;j<4;j++)
	LDI  R17,LOW(0)
_0x2A:
	CPI  R17,4
	BRSH _0x2B
; 0000 00B3     {
; 0000 00B4     data[j]=0;
	RCALL SUBOPT_0x0
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 00B5     }
	SUBI R17,-1
	RJMP _0x2A
_0x2B:
; 0000 00B6 
; 0000 00B7      for(j=0;j<10;j++) display();
	LDI  R17,LOW(0)
_0x2D:
	CPI  R17,10
	BRSH _0x2E
	RCALL _display
	SUBI R17,-1
	RJMP _0x2D
_0x2E:
; 0000 00B9 goto l1;
	RJMP _0xA
; 0000 00BA       }
; 0000 00BB 
; 0000 00BC       if(q==1)
_0x25:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	SBIW R26,1
	BRNE _0x2F
; 0000 00BD       {
; 0000 00BE       lcd_clear();
	RCALL _lcd_clear
; 0000 00BF       lcd_puts("Food A");
	__POINTW2MN _0xC,20
	RCALL SUBOPT_0x1
; 0000 00C0       lcd_gotoxy(0,1);
; 0000 00C1       lcd_puts("Price=50 cent");
	__POINTW2MN _0xC,27
	RCALL _lcd_puts
; 0000 00C2       x=50;
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	RCALL SUBOPT_0x3
; 0000 00C3       if(i1==50)
	SBIW R26,50
	BRNE _0x30
; 0000 00C4       {
; 0000 00C5       lcd_clear();
	RCALL _lcd_clear
; 0000 00C6       lcd_puts("paid");delay_ms(1000);q=0;c=0;  goto l1;
	__POINTW2MN _0xC,41
	RCALL SUBOPT_0x4
	RJMP _0xA
; 0000 00C7       }
; 0000 00C8 
; 0000 00C9        if(i1>50)
_0x30:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	SBIW R26,51
	BRLO _0x31
; 0000 00CA       {
; 0000 00CB       lcd_clear();
	RCALL _lcd_clear
; 0000 00CC       lcd_puts("extra paid"); delay_ms(1000);q=0;c=0;  goto l1;
	__POINTW2MN _0xC,46
	RCALL SUBOPT_0x4
	RJMP _0xA
; 0000 00CD       }
; 0000 00CE 
; 0000 00CF       }
_0x31:
; 0000 00D0 
; 0000 00D1        if(q==2)
_0x2F:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	SBIW R26,2
	BRNE _0x32
; 0000 00D2       {
; 0000 00D3       lcd_clear();
	RCALL _lcd_clear
; 0000 00D4       lcd_puts("Food B");
	__POINTW2MN _0xC,57
	RCALL SUBOPT_0x1
; 0000 00D5       lcd_gotoxy(0,1);
; 0000 00D6       lcd_puts("Price=65 cent");
	__POINTW2MN _0xC,64
	RCALL _lcd_puts
; 0000 00D7       x=65;
	LDI  R30,LOW(65)
	LDI  R31,HIGH(65)
	RCALL SUBOPT_0x3
; 0000 00D8       if(i1==65)
	CPI  R26,LOW(0x41)
	LDI  R30,HIGH(0x41)
	CPC  R27,R30
	BRNE _0x33
; 0000 00D9       {
; 0000 00DA       lcd_clear();
	RCALL _lcd_clear
; 0000 00DB       lcd_puts("paid"); delay_ms(1000);q=0;c=0; goto l1;
	__POINTW2MN _0xC,78
	RCALL SUBOPT_0x4
	RJMP _0xA
; 0000 00DC       }
; 0000 00DD 
; 0000 00DE        if(i1>65)
_0x33:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CPI  R26,LOW(0x42)
	LDI  R30,HIGH(0x42)
	CPC  R27,R30
	BRLO _0x34
; 0000 00DF       {
; 0000 00E0       lcd_clear();
	RCALL _lcd_clear
; 0000 00E1       lcd_puts("extra paid");  delay_ms(1000);q=0;c=0;  goto l1;
	__POINTW2MN _0xC,83
	RCALL SUBOPT_0x4
	RJMP _0xA
; 0000 00E2       }
; 0000 00E3 
; 0000 00E4       }
_0x34:
; 0000 00E5 
; 0000 00E6        if(q==3)
_0x32:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	SBIW R26,3
	BRNE _0x35
; 0000 00E7       {
; 0000 00E8       lcd_clear();
	RCALL _lcd_clear
; 0000 00E9       lcd_puts("Food C");
	__POINTW2MN _0xC,94
	RCALL SUBOPT_0x1
; 0000 00EA       lcd_gotoxy(0,1);
; 0000 00EB       lcd_puts("Price=77 cent");
	__POINTW2MN _0xC,101
	RCALL _lcd_puts
; 0000 00EC       x=77;
	LDI  R30,LOW(77)
	LDI  R31,HIGH(77)
	RCALL SUBOPT_0x3
; 0000 00ED       if(i1==77)
	CPI  R26,LOW(0x4D)
	LDI  R30,HIGH(0x4D)
	CPC  R27,R30
	BRNE _0x36
; 0000 00EE       {
; 0000 00EF       lcd_clear();
	RCALL _lcd_clear
; 0000 00F0       lcd_puts("paid");   delay_ms(1000);q=0;c=0; goto l1;
	__POINTW2MN _0xC,115
	RCALL SUBOPT_0x4
	RJMP _0xA
; 0000 00F1       }
; 0000 00F2 
; 0000 00F3        if(i1>77)
_0x36:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CPI  R26,LOW(0x4E)
	LDI  R30,HIGH(0x4E)
	CPC  R27,R30
	BRLO _0x37
; 0000 00F4       {
; 0000 00F5       lcd_clear();
	RCALL _lcd_clear
; 0000 00F6       lcd_puts("extra paid");  delay_ms(1000);q=0;c=0;  goto l1;
	__POINTW2MN _0xC,120
	RCALL SUBOPT_0x4
	RJMP _0xA
; 0000 00F7       }
; 0000 00F8 
; 0000 00F9       }
_0x37:
; 0000 00FA 
; 0000 00FB        if(q==4)
_0x35:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	SBIW R26,4
	BRNE _0x38
; 0000 00FC       {
; 0000 00FD       lcd_clear();
	RCALL _lcd_clear
; 0000 00FE       lcd_puts("Food D");
	__POINTW2MN _0xC,131
	RCALL SUBOPT_0x1
; 0000 00FF       lcd_gotoxy(0,1);
; 0000 0100       lcd_puts("Price=63 cent");
	__POINTW2MN _0xC,138
	RCALL _lcd_puts
; 0000 0101       x=63;
	LDI  R30,LOW(63)
	LDI  R31,HIGH(63)
	RCALL SUBOPT_0x3
; 0000 0102       if(i1==63)
	SBIW R26,63
	BRNE _0x39
; 0000 0103       {
; 0000 0104       lcd_clear();
	RCALL _lcd_clear
; 0000 0105       lcd_puts("paid");  delay_ms(1000);q=0;c=0;     goto l1;
	__POINTW2MN _0xC,152
	RCALL SUBOPT_0x4
	RJMP _0xA
; 0000 0106       }
; 0000 0107 
; 0000 0108        if(i1>63)
_0x39:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CPI  R26,LOW(0x40)
	LDI  R30,HIGH(0x40)
	CPC  R27,R30
	BRLO _0x3A
; 0000 0109       {
; 0000 010A       lcd_clear();
	RCALL _lcd_clear
; 0000 010B       lcd_puts("extra paid");  delay_ms(1000);q=0;c=0;        goto l1;
	__POINTW2MN _0xC,157
	RCALL SUBOPT_0x4
	RJMP _0xA
; 0000 010C       }
; 0000 010D 
; 0000 010E       }
_0x3A:
; 0000 010F 
; 0000 0110       i2=i1;
_0x38:
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	STD  Y+10,R30
	STD  Y+10+1,R31
; 0000 0111       i3=i2-x;
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+4,R30
	STD  Y+4+1,R31
; 0000 0112       if(a==1)
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	SBIW R26,1
	BRNE _0x3B
; 0000 0113       {
; 0000 0114       i3=i2;
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	STD  Y+4,R30
	STD  Y+4+1,R31
; 0000 0115       }
; 0000 0116      for(j=0;j<4;j++)
_0x3B:
	LDI  R17,LOW(0)
_0x3D:
	CPI  R17,4
	BRSH _0x3E
; 0000 0117     {
; 0000 0118 
; 0000 0119     if(i3>0)
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL __CPW02
	BRGE _0x3F
; 0000 011A     {
; 0000 011B     data[j]=i3%10;
	RCALL SUBOPT_0x0
	MOVW R22,R30
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	MOVW R26,R22
	ST   X,R30
; 0000 011C     i3=i3/10;
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	STD  Y+4,R30
	STD  Y+4+1,R31
; 0000 011D     }
; 0000 011E     }
_0x3F:
	SUBI R17,-1
	RJMP _0x3D
_0x3E:
; 0000 011F 
; 0000 0120      for(j=0;j<10;j++) display();
	LDI  R17,LOW(0)
_0x41:
	CPI  R17,10
	BRSH _0x42
	RCALL _display
	SUBI R17,-1
	RJMP _0x41
_0x42:
; 0000 0122 }
	RJMP _0x7
; 0000 0123 
; 0000 0124 }
_0x43:
	RJMP _0x43
; .FEND

	.DSEG
_0xC:
	.BYTE 0xA8
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
; .FSTART __lcd_write_nibble_G100
	ST   -Y,R26
	IN   R30,0x1B
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x1B,R30
	__DELAY_USB 2
	SBI  0x1B,2
	__DELAY_USB 2
	CBI  0x1B,2
	__DELAY_USB 2
	RJMP _0x2020001
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
	RJMP _0x2020001
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
	LDD  R5,Y+1
	LDD  R4,Y+0
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	RCALL SUBOPT_0x5
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	RCALL SUBOPT_0x5
	LDI  R30,LOW(0)
	MOV  R4,R30
	MOV  R5,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2000005
	CP   R5,R7
	BRLO _0x2000004
_0x2000005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	INC  R4
	MOV  R26,R4
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2020001
_0x2000004:
	INC  R5
	SBI  0x1B,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x1B,0
	RJMP _0x2020001
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
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	IN   R30,0x1A
	ORI  R30,LOW(0xF0)
	OUT  0x1A,R30
	SBI  0x1A,2
	SBI  0x1A,0
	SBI  0x1A,1
	CBI  0x1B,2
	CBI  0x1B,0
	CBI  0x1B,1
	LDD  R7,Y+0
	LD   R30,Y
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x6
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
_0x2020001:
	ADIW R28,1
	RET
; .FEND

	.DSEG
_data:
	.BYTE 0x4
__base_y_G100:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_data)
	SBCI R31,HIGH(-_data)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x1:
	RCALL _lcd_puts
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x2:
	LDI  R26,LOW(20)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:60 WORDS
SUBOPT_0x4:
	RCALL _lcd_puts
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL _delay_ms
	LDI  R30,LOW(0)
	STD  Y+14,R30
	STD  Y+14+1,R30
	__GETWRN 18,19,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	RCALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x6:
	LDI  R26,LOW(48)
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 33
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
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

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	RET

;END OF CODE MARKER
__END_OF_CODE:
