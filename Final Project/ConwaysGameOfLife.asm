; --------------------------------------------------------------------
; An implementation of Conway's Game of Life designed for the RAT MCU
; Utilizes VGA module written by Peter Heatwole, Aaron Barton
; as well as Keyboard module written by Paul Hummel 
; and the Pseudo Random module written by Jeffrey Gerfen
;
; Uses keys W, A, S, and D to move the cursor up, left, down, and right
; Use Q to bring a cell to life
; Use E to tick the clock
; Use R to start/stop the game running continuously
; Use P to populate the game board with random stripes of alive cells
; No reset currently implemented
;
; Author: Michael Hallock and William Rachuy, incorporating code
;  from "etch-a-sketch", written by Bridget Benson
; --------------------------------------------------------------------

.CSEG
.ORG 0x10

.EQU FB_HADD = 0x90
.EQU FB_LADD = 0x91
.EQU FB_COLOR = 0x92
.EQU FB_READ = 0x93

.EQU SSEG = 0x81
.EQU LEDS = 0x40
.EQU UP = 0x1D ; 'W'
.EQU LEFT = 0x1C; 'A'
.EQU RIGHT = 0x23; 'D'
.EQU DOWN =  0x1B; 'S'
.EQU MARK = 0x15; 'Q'
.EQU RUN = 0x24; 'E'
.EQU RUNLOOP = 0x2D; 'R'
.EQU POPULATE = 0x4D; 'P'

.EQU RNG = 0x94

.EQU ICOUNT = 0x03;

.EQU PS2_CONTROL = 0x46
.EQU PS2_KEY_CODE = 0x44
.EQU PS2_STATUS = 0x45
.EQU PS2_ERROR_MASK = 0x01
.EQU PS2_DATA_READY_MASK = 0x02

;CONSTANTS FOR PAUSE FUNCTION
.EQU time_INSIDE_FOR_COUNT    = 0x5E ;5E default
.EQU time_MIDDLE_FOR_COUNT    = 0xFF
.EQU time_OUTSIDE_FOR_COUNT   = 0x0F ;FF default

;R0 is for status
;R1 is for interrupt count
;r2 is keyboard input
;r4 is for y
;r5 is for x
;r6 is for color
;r7 temp y
;r8 temp x

;r9 newgen y
;r10 newgen x
;r11 newgen neighbors y
;r12 newgen neighbors x
;r13 count # of neighbors
;r14,r15,r16,r17 newgen variables
;r20 for process data return
;r21 for run flag
;r22 for playpause variable
;r23,24,25,26 for RNG functions

;r18 for led debug
;r19 for interrupt counting
;r27,r28,r29 for pause loops

init: ; initialize cursor at center of screen
   SEI
   MOV  R0, 0x00
   MOV  R1, 0x00
   MOV  R7, 0x0F  ;the origin
   MOV  R8, 0x14
   MOV  R4, R7   ;y coordin
   MOV  R5, R8   ;x coordin
   MOV  R6, 0xE0 ;red color
   MOV	R18, 0x00 ;For debug
   MOV  R19, 0x00
   CALL draw_dot   ;draw red square at origin

main: 
   CMP  R0, 0x00 ; do nothing
   CMP  R21, 0x01
   BREQ rungame ; run game if the "run register" is set
   BRN  main   ; continuous loop waiting for interrupts
rungame:
   CALL pause ; define a pause to determine speed of game
   CALL newgen ; create a new generation and tick the game clock
   BRN main

CheckKeyboard: ;loop to see which key was pressed and 
			   ;perform corresponding task
   OR R18, 0x01
   OUT R18, LEDS
   MOV R19, 0x00

   IN   R2, PS2_KEY_CODE
   OUT  R2, SSEG
   CMP  R2, UP
   BREQ cursor_up ; move cursor up
   CMP  R2, DOWN
   BREQ cursor_down ; move cursor down
   CMP  R2, RIGHT
   BREQ cursor_right ; move cursor right
   CMP  R2, LEFT
   BREQ cursor_left ; move cursor left
   CMP R2, MARK
   BREQ makealive ; make cell cursor is on alive
   CMP R2, RUN
   BREQ makenewgen ; run the game for a single tick
   CMP R2, POPULATE
   BREQ popboard ; populate the board with random cells
   CMP R2, RUNLOOP
   BREQ play ; start/stop the game running continuously
   CMP	R2, 0xF0
   BREQ no_move 
   BRN  PROCESS_DATA_RETURN

;------------------------------------------------------------------
;cursor operations
;------------------------------------------------------------------
cursor_up:
   MOV  R4, R7   ;y coordin 
   MOV  R5, R8   ;x coordin 
   ; current position must be moved into R4,R5 for all subroutines
   CALL erase_red
   SUB  R7, 0x01
   MOV  R4, R7   ;y coordin
   MOV  R5, R8   ;x coordin
   CALL add_red
   BRN  PROCESS_DATA_RETURN

cursor_down:
   MOV  R4, R7   ;y coordin
   MOV  R5, R8   ;x coordin
   CALL erase_red
   ADD  R7, 0x01
   MOV  R4, R7   ;y coordin
   MOV  R5, R8   ;x coordin
   CALL add_red
   BRN  PROCESS_DATA_RETURN

cursor_left:
   MOV  R4, R7   ;y coordin
   MOV  R5, R8   ;x coordin
   CALL erase_red
   SUB  R8, 0x01
   MOV  R4, R7   ;y coordin
   MOV  R5, R8   ;x coordin
   CALL add_red
   BRN  PROCESS_DATA_RETURN

cursor_right:
   MOV  R4, R7   ;y coordin
   MOV  R5, R8   ;x coordin
   CALL erase_red
   ADD  R8, 0x01
   MOV  R4, R7   ;y coordin
   MOV  R5, R8   ;x coordin
   CALL add_red
   BRN  PROCESS_DATA_RETURN

;---------------------------------------------------------------------
; cell/miscellaneous operations
;---------------------------------------------------------------------
makealive: ; make a single cell alive
   MOV  R4, R7   ;y coordin 
   MOV  R5, R8   ;x coordin
   CALL setalive
   BRN PROCESS_DATA_RETURN

makenewgen: ; tick the game of life clock
   CALL newgen
   BRN PROCESS_DATA_RETURN

play: ; start or stop the game running
   CALL playpause
   BRN PROCESS_DATA_RETURN

popboard: ; populate the board with random living cells
   CALL randboard
   BRN PROCESS_DATA_RETURN

no_move:
   BRN PROCESS_DATA_RETURN

; --------------------------------------------------------------------
; function draw_dot
; r5 is the x coordinate
; r4 is the y coordinate
; r6 is the color
; --------------------------------------------------------------------
draw_dot:
		MOV  R6, 0xE0 ;red color
        AND r5, 0x3F ; make sure top 2 bits cleared
        AND r4, 0x1F ; make sure top 3 bits cleared
        LSR r4 ;need to get the bot 2 bits of s4 into sA
        BRCS dd_add40
t1:     LSR r4
        BRCS dd_add80
dd_out: OUT r5, FB_LADD ; write bot 8 address bits to register
        OUT r4, FB_HADD ; write top 3 address bits to register
        OUT r6, FB_COLOR ; write data to frame buffer
        RET
dd_add40: OR r5, 0x40
        CLC
        BRN t1
dd_add80: OR r5, 0x80
        BRN dd_out

; --------------------------------------------------------------------
; function read_dot
; r5 is the x coordinate
; r4 is the y coordinate
; r6 is the color
; --------------------------------------------------------------------
read_dot:
        AND r5, 0x3F ; make sure top 2 bits cleared
        AND r4, 0x1F ; make sure top 3 bits cleared
        LSR r4 ;need to get the bot 2 bits of s4 into sA
        BRCS dd_add40r
t1r:     LSR r4
        BRCS dd_add80r
dd_outr: OUT r5, FB_LADD ; write bot 8 address bits to register
        OUT r4, FB_HADD ; write top 3 address bits to register
        IN r6, FB_READ ; read data from frame buffer
        RET
dd_add40r: OR r5, 0x40
        CLC
        BRN t1r
dd_add80r: OR r5, 0x80
        BRN dd_outr

; --------------------------------------------------------------------
; function add_red
; adds red, leaves others intact
; r5 is the x coordinate
; r4 is the y coordinate
; r6 is the color
; --------------------------------------------------------------------
add_red:
        AND r5, 0x3F ; make sure top 2 bits cleared
        AND r4, 0x1F ; make sure top 3 bits cleared
        LSR r4 ;need to get the bot 2 bits of s4 into sA
        BRCS dd_add40ar
t1ar:     LSR r4
        BRCS dd_add80ar
dd_outar: OUT r5, FB_LADD ; write bot 8 address bits to register
        OUT r4, FB_HADD ; write top 3 address bits to register
		IN r6, FB_READ ; read from frame buffer
 		OR R6, 0xE0 ; mask on red bits
        OUT r6, FB_COLOR ; write data to frame buffer
        RET
dd_add40ar: OR r5, 0x40
        CLC
        BRN t1ar
dd_add80ar: OR r5, 0x80
        BRN dd_outar

; --------------------------------------------------------------------
; function erase_red
; erases only red bits, leaves others intact
; r5 is the x coordinate
; r4 is the y coordinate
; --------------------------------------------------------------------
erase_red:
        AND r5, 0x3F ; make sure top 2 bits cleared
        AND r4, 0x1F ; make sure top 3 bits cleared
        LSR r4 ;need to get the bot 2 bits of s4 into sA
        BRCS dd_add40er
t1er:     LSR r4
        BRCS dd_add80er
dd_outer: OUT r5, FB_LADD ; write bot 8 address bits to register
        OUT r4, FB_HADD ; write top 3 address bits to register
		IN R6, FB_READ; read r6
		AND R6, 0x1F; clear top 3 bits
        OUT R6, FB_COLOR ; write to frame buffer
        RET
dd_add40er: OR r5, 0x40
        CLC
        BRN t1er
dd_add80er: OR r5, 0x80
        BRN dd_outer

;---------------------------------------------------------------------
; function birth
; marks cell to be born next turn (used by newgen)
;---------------------------------------------------------------------
birth:
        AND r5, 0x3F ; make sure top 2 bits cleared
        AND r4, 0x1F ; make sure top 3 bits cleared
        LSR r4 ;need to get the bot 2 bits of s4 into sA
        BRCS dd_add40b
t1b:     LSR r4
        BRCS dd_add80b
dd_outb: OUT r5, FB_LADD ; write bot 8 address bits to register
        OUT r4, FB_HADD ; write top 3 address bits to register
		IN R6, FB_READ; read r6
		OR R6, 0x0C; turn on bottom two blue bits
        OUT R6, FB_COLOR ; write to frame buffer
        RET
dd_add40b: OR r5, 0x40
        CLC
        BRN t1b
dd_add80b: OR r5, 0x80
        BRN dd_outb

;---------------------------------------------------------------------
; function death
; marks cell for death next turn (used by newgen)
;---------------------------------------------------------------------
death:
        AND r5, 0x3F ; make sure top 2 bits cleared
        AND r4, 0x1F ; make sure top 3 bits cleared
        LSR r4 ;need to get the bot 2 bits of s4 into sA
        BRCS dd_add40d
t1d:     LSR r4
        BRCS dd_add80d
dd_outd: OUT r5, FB_LADD ; write bot 8 address bits to register
        OUT r4, FB_HADD ; write top 3 address bits to register
		IN R6, FB_READ; read r6
		AND R6, 0xF3; turn off bottom two blue bits
        OUT R6, FB_COLOR ; write to frame buffer
        RET
dd_add40d: OR r5, 0x40
        CLC
        BRN t1d
dd_add80d: OR r5, 0x80
        BRN dd_outd

;---------------------------------------------------------------------
; function setalive
; sets cell alive (used by user and RNG functions)
;---------------------------------------------------------------------
setalive:
        AND r5, 0x3F ; make sure top 2 bits cleared
        AND r4, 0x1F ; make sure top 3 bits cleared
        LSR r4 ;need to get the bot 2 bits of s4 into sA
        BRCS dd_add40sa
t1sa:     LSR r4
        BRCS dd_add80sa
dd_outsa: OUT r5, FB_LADD ; write bot 8 address bits to register
        OUT r4, FB_HADD ; write top 3 address bits to register
		IN R6, FB_READ; read r6
		OR R6, 0x1C; turn on blue bits
        OUT R6, FB_COLOR ; write to frame buffer
        RET
dd_add40sa: OR r5, 0x40
        CLC
        BRN t1sa
dd_add80sa: OR r5, 0x80
        BRN dd_outsa

;---------------------------------------------------------------------
; function setdead
; sets cell dead (used by cleartrench)
;---------------------------------------------------------------------
setdead:
        AND r5, 0x3F ; make sure top 2 bits cleared
        AND r4, 0x1F ; make sure top 3 bits cleared
        LSR r4 ;need to get the bot 2 bits of s4 into sA
        BRCS dd_add40sd
t1sd:     LSR r4
        BRCS dd_add80sd
dd_outsd: OUT r5, FB_LADD ; write bot 8 address bits to register
        OUT r4, FB_HADD ; write top 3 address bits to register
		IN R6, FB_READ; read r6
		AND r6,0xE3; clear blue bits
		OUT r6, FB_COLOR; write to framebuffer
		RET
dd_add40sd: OR r5, 0x40
        CLC
        BRN t1sd
dd_add80sd: OR r5, 0x80
        BRN dd_outsd

;---------------------------------------------------------------------
; function andbits
; evalutes cell and sets it alive or dead based on 
; bottom two blue bits (used by second pass of newgen)
;---------------------------------------------------------------------
andbits:
        AND r5, 0x3F ; make sure top 2 bits cleared
        AND r4, 0x1F ; make sure top 3 bits cleared
        LSR r4 ;need to get the bot 2 bits of s4 into sA
        BRCS dd_add40ab
t1ab:     LSR r4
        BRCS dd_add80ab
dd_outab: OUT r5, FB_LADD ; write bot 8 address bits to register
        OUT r4, FB_HADD ; write top 3 address bits to register
		IN R6, FB_READ; read r6

		MOV r14,r6
		LSL r14
		LSL r14
		LSL r14
		LSL r14
		LSL r14

		BRCC gonnadie
		OR r6, 0x1C; turn on blue bits
        OUT r6, FB_COLOR ; write to frame buffer
		BRN abdone
gonnadie:
		AND r6,0xE3
		OUT r6, FB_COLOR
abdone:
        RET
dd_add40ab: OR r5, 0x40
        CLC
        BRN t1ab
dd_add80ab: OR r5, 0x80
        BRN dd_outab

;--------------------------------------------------------------------
; function new generation
; run the game for a single "tick" 
; according to game of life rules
; occurs in two passes: evaluating cells and marking for birth/death
; based on current state and then actually setting next cell state
; after all cells have been evaluated 
; top blue bit (bit 4 of 7) used to keep track of current cell state
; bottom two blue bits (2 and 3 of 7) used to keep track of 
; state next turn
;--------------------------------------------------------------------
newgen:
		CALL cleartrench ; first clear cells at border

		MOV r9, 0x01;for position
		MOV r10, 0x01;for position
		MOV r11, 0x01;for counting neighbors
		MOV r12, 0x01;for counting neighbors

evalcell:
		MOV r4,r9
		MOV r5,r10
		CALL read_dot
		MOV r14,r6

checkalive: ; check bit 4 of 7 to see if cell is currently alive
		LSL 	r14
		LSL 	r14
		LSL		r14
		LSL 	r14
		BRCC checkbirth ; if dead, see if it should be born
		BRN checkdeath ; if alive, see if it should die

checkbirth:
		CALL countn ; count number of living neighbors of current cell
		CMP r13,0x03 ; if exactly 3 neighbors, make cell alive next turn
		BREQ born
		BRN nextcell ; otherwise move on to next cell
born:
		MOV r4,r9
		MOV r5,r10
		CALL birth 
		BRN nextcell

checkdeath:
		CALL countn ; count living neighbors
		CMP r13,0x02 ; if two
		BREQ nextcell
		CMP r13,0x03 ; or three are alive
		BREQ nextcell ; leave the cell be

		MOV r4,r9
		MOV r5,r10
		CALL death ; otherwise mark cell for death next turn
		BRN nextcell

nextcell:
		ADD R10,0x01 ; progress to evaluate all cells 
		CMP R10,0x27 ; in rectangle spanning (1,1) to (38,28)
		BREQ newrow
		BRN evalcell
newrow:
		ADD r9,0x01
		CMP r9,0x1D
		BREQ secondpass ; when all cells have been evaluated move on
		MOV r10,0x01 ; to second pass
		BRN evalcell

secondpass: ; second pass sets cell alive or dead
		MOV r9,0x01 ; based on what its been marked on first pass
		MOV r10,0x01

finaleval:
		MOV r4,r9
		MOV r5,r10
		CALL andbits ; andbits function actually evalutes/sets current cell

nextcellf:
		ADD r10,0x01
		CMP r10,0x27
		BREQ newrowf
		BRN finaleval

newrowf:
		ADD r9,0x01
		CMP r9,0x1D
		BREQ finished
		MOV r10,0x01
		BRN finaleval

finished:
		BRN PROCESS_DATA_RETURN

; function countn
countn: ; count number of living neighbbors out of 8 surrounding
		MOV r11,r9
		MOV r12,r10
		MOV r13,0x00

		SUB r12, 0x01; step r11/r12 around the cell position at r9/r10
		CALL checkn; and add to tally in r13 if that neighbor is alive
		SUB r11,0x01
		CALL checkn
		ADD r12,0x01
		CALL checkn
		ADD r12,0x01
		CALL checkn
		ADD r11,0x01
		CALL checkn
		ADD r11,0x01
		CALL checkn
		SUB r12,0x01
		CALL checkn
		SUB r12,0x01
		CALL checkn
		RET

; function checkn
checkn: ; check current dot's status, if its alive add to tally in r13
		MOV r4,r11
		MOV r5,r12
		CALL read_dot
		MOV r15,r6
checkadd:
		LSL r15
		LSL r15
		LSL	r15
		LSL	r15
		BRCC noadd
		ADD r13,0x01
noadd:
		RET

;function cleartrench
;clear all spaces in outermost rectangle of pixels
cleartrench:
		MOV r9,0x00;
		MOV r10,0x00;
cleardot:
		MOV r4,r9
		MOV r5,r10
		CALL setdead
		ADD r9,0x01
		CMP r9,0x1D
		BREQ clearright
		BRN cleardot
clearright:
		ADD r10,0x01
		MOV r4,r9
		MOV r5,r10
		CALL setdead
		CMP r10,0x27
		BREQ clearup
		BRN clearright
clearup:
		SUB r9,0x01
		MOV r4,r9
		MOV r5,r10
		CALL setdead
		CMP r9,0x00
		BREQ clearleft
		BRN clearup
clearleft:
		SUB r10,0x01
		MOV r4,r9
		MOV r5,r10
		CALL setdead
		CMP r10,0x00
		BREQ trenchclear
		BRN clearleft
trenchclear:
		RET

;--------------------------------------------------------------------
; playpause function - set or clear the "run" register
;-------------------------------------------------------------------- 
playpause:
		LSR r21 ; game runs based on state of r21
		BRCC startplay ; if r21 is 0x00, set to 0x00
		RET ; if r21 is 0x01, set to 0x00
startplay: 
		MOV r21,0x01
		RET

;--------------------------------------------------------------------
; randboard function
; populate board with some random cells
;--------------------------------------------------------------------
randboard:
		MOV r24,0x0A ; create ten shapes - r24 loop variable
randboardloop:
		CALL randpop ; randpop below creates a shape in a random location
		SUB r24,0x01
		BRNE randboardloop
		RET

;--------------------------------------------------------------------
; randpop function - populate a random shape
; in this case a line but could be modified
;--------------------------------------------------------------------
randpop: 
		MOV r26,0x00 ; r26 loop variable
		IN r23, RNG ; r23,r25 keep track of position
		IN r25, RNG
makeline: ; this makes a stripe of alive pixels
		ADD R25,0x01
		MOV r5,r23
		MOV r4,r25
		CALL setalive
		ADD R26,0x01
		CMP R26,0x06
		BRNE makeline
		RET
		
;---------------------------------------------------------------------
; pause function - used to set speed game runs at
;---------------------------------------------------------------------
pause:	     MOV     R29, time_OUTSIDE_FOR_COUNT  ;set outside for loop count
outside_for: SUB     R29, 0x01

			 MOV     R28, time_MIDDLE_FOR_COUNT   ;set middle for loop count
middle_for: SUB     R28, 0x01

			 MOV     R27, time_INSIDE_FOR_COUNT   ;set inside for loop count
inside_for: SUB     R27, 0x01
			 BRNE    inside_for

			 OR      R28, 0x00               ;load flags for middle for counter
			 BRNE    middle_for

			 OR      R29, 0x00               ;load flags for outsde for counter value
			 BRNE    outside_for
			 RET

; --------------------------------------------------------------------
; Interrupts service routine
; --------------------------------------------------------------------
My_ISR:
	BRN CheckKeyboard


PROCESS_DATA_RETURN:

	MOV r20, 0x01           
	OUT r20, PS2_CONTROL    ;set the PS2_DATA_READY flag (this may not be necessary)
	MOV r20, 0x00
	OUT r20, PS2_CONTROL    ;clear the PS2_DATA_READY flag
	RETIE

; --------------------------------------------------------------------
; interrupt vector
; --------------------------------------------------------------------
.CSEG
.ORG 0x3FF
BRN My_ISR
