 MAIN
**************************
* SUBROUTINE FILE
**************************
  PUBLIC JOYKEY
  PUBLIC PRNUM
  PUBLIC BCDADD
  PUBLIC BCDOP2
  PUBLIC COMP
  PUBLIC LEVS
  PUBLIC PACK

OFFSET EXT
FLIP   EXT
PRINT  EXT
AMMO     EXT   GET VALS
X        EXT   USE FOR MANY VARS
HITANY   EXT
DISP     EXT
START    EXT

STACK  EQU     1400

COLOR  NOP
       ORCC    #$50    MASK INTERUPTS
       LDA     #$34    OFF PIA
       STA     $FF03
       CLR     $FF40   OFF DISK
       LDS     #STACK
       LDU     #COLOR  GET RESET VERTOR
       STU     114     RESET VEC
       CLR     65472   PAGE IN
       CLR     65475
       CLR     65477
       CLR     $FFDF   64K ON
       JSR     FLIP
       JSR     SETCLR
       JSR     FLIP
       JSR     HITANY  WAIT
       LDU     OFFSET
       CMPU    #58880
       BNE     NOFLY
       JSR     FLIP
*SHOWS ONE PAGE OF TEXT
NOFLY  LDU     #CHR
       JSR     READ
       LDU     #PAGE2
       JSR     READ
       LDU     #PAGE1
       JSR     READ
       LDU     #PAGE3
       JSR     READ
       LDU     #TIT1
       JSR     READ
       LDU     #BACKK
       JSR     READ
       JSR     FLIP
       LDX     #0
TITLPS LEAX    1,X
       CLR     $FFDE
       JSR     [$A000]
       CLR     $FFDF
       TSTA
       BNE     TITOUT
       CMPX    #10000
       BNE     TITLPS
TITOUT LDU     #BEGSC
       JSR     SCREEN
       JSR     HITANY
       JSR     NEET
       LDU     #HEAD   THIS SCREEN
       JSR     SCREEN
NEW    TST     X+3     TEST HP
       LBMI    DOOM    TOTALLY DEAD
       LDU     #PICK   2ND SCREEN
       JSR     SCREEN
*NEW LEVEL?
       LDA     #112    YPOS FOR PRINT
       STA     NY
       LDA     LOC     GET CURRENT LOC
       STA     LAST    LAST POINTER
       JSR     AREA    PRINT IT
       LDA     #128    NEXT PRINT ZONE
       STA     NY
*SAVE POINTERS
       TFR     X,U     GET OBJLOC
       LEAU    28,U    ADD OFESET
       STU     LOCO    SAVE LOC OF OBJECT
       STX     XSAVE   SAVE INDEX!
       LDD     ,X      GET N/S
       STD     NSTEMP  SAVE THEM
       LDD     2,X     GET E/W
       STD     NSTEMP+2
       LDD     24,X    GET TRACK+SEC ST
       STD     DATA    SAVE IN DISK DATA
       LDD     26,X    GET TR/SEC END
       STD     DATA+2  SAVE
       LDU     #DATA   LAND/MOVES
       JSR     READ    READ THIS
NOBL   LDA     NSTEMP
       JSR     AREA    A HOLDS NORTH
       LDA     #136    NEXT P ZONE
       STA     NY
       LDA     NSTEMP+1 GET SOUTH
       JSR     AREA     DO IT
       LDA     #144
       STA     NY
       LDA     NSTEMP+2  EAST
       JSR     AREA
       LDA     #152
       STA     NY
       LDA     NSTEMP+3  WEST
       JSR     AREA
       LDA     #1      PRINT ALL FIRST TIME
       STA     KEYS
       JSR     CMD     PICK A COMMAND
       JSR     NEET
       LDU     #STSSS  SETUP GAME SCREEN
       JSR     SCREEN
       LDA     LOC     GET LOCATION
       ANDA    #7      SAVE LOW BITS
       CMPA    #4      >4?
       BLS     TOTOS   OK
       SUBA    #5
TOTOS  STA     LEVS    SAVE BACK LEVEL
       JSR     START   START OF GAME
       DEC     HUNG
       LBEQ    DOOM    OUT OF FOOD

       LDA     NEXT
       STA     LOC     SAVE THE NEW LOCATION
       CLR     TMOUNT
       CLR     MTRY
       CLR     STRY
       CLR     FTRY    CAN FIX AGAIN!
AGAIN  JMP     NEW

JOYKEY FCB     0       0=KEYS 1=JOY
DATA   RMB     4       TR/SC/TRE/SCE
       FDB     37376   START OF DATA
       FDB     40447   END

LEVS   RMB     1       BACGROUND LEVEL
LAST   RMB     1       LAST LOCATION
NEXT   RMB     1       NEXT LOC. IF DONE

NSTEMP RMB     4       SAVE DIRECTIONS
NX     FCB     10
NY     FCB     0
NAME   FCC     /                    /
       FCB     0
XSAVE  RMB     2       INDEX SAVE
COMP   FCB     0       =1 IF DONE W/LEV
LOCO   RMB     2
INVENT FDB     118     ITEMS HELD
       FDB     119
       FDB     114
       FDB     112
       FDB     117
LOC    FCB     1       POINTER OF GRID NUM
MECH   FCB     4       FIXING SKILL 1-8--SKILLS--
MEDIC  FCB     4       MEDIC SKILL 1-8
LUCK   FCB     4       1-8
HUNG   FCB     5       HUNGER FACTOR
PACK   FCB     0       --SPECIAL ITEMS--
RADIO  FCB     1
LAUN   FCB     0
TURB   FCB     0
HIGH   FCB     0
HEAVY  FCB     0

CHR    FCB     18
       FCB     1
       FCB     18
       FCB     3
       FDB     36608
       FDB     37375
TIT1   FCB     19
       FCB     1
       FCB     20
       FCB     6
       FDB     52736
       FDB     58879
PAGE3  FCB     21
       FCB     1
       FCB     22
       FCB     6
       FDB     30464
       FDB     36607
BACKK  FCB     27
       FCB     1
       FCB     28
       FCB     6
       FDB     24320
       FDB     30463
PAGE1  FCB     23      TR
       FCB     1       SEC 1
       FCB     24      TR END
       FCB     6       SEC 6 LAST
       FDB     40448+6144  START
       FDB     40448+12287 END
PAGE2  FCB     25
       FCB     1
       FCB     26
       FCB     6
       FDB     40448
       FDB     40448+6143
COUNT  RMB     1
COUNT2 RMB     1
TITLE  FCB     0
       FCB     0
       FCC     /                                /
       FCB     0
HEAD   FCC     /!!/
       FCC     /<==============================>/
       FCC     /.         PROTOTYPE            ./
       FCC     /.                              ./
       FCC     /.         DARRELL ULM          ./
       FCC     /.                              ./
       FCC     /.      K E Y S    U S E D      ./
       FCC     /&==============================%/
       FCC     /.   Z       -TURBO             ./
       FCC     /.   L       -LOAD AMMO         ./
       FCC     /.   ENTER   -MISSILE PACK      ./
       FCC     /.   BREAK   -SR MISSILES       ./
       FCC     /.   UP ARROW-THRUST UP         ./
       FCC     /.   DN ARROW-MAINTAIN THRUST   ./
       FCC     /.   LT ARROW-MOVE LEFT         ./
       FCC     /.   RT ARROW-MOVE RIGHT        ./
       FCC     /.   SPACEBAR-FIRE HAND WEAPON  ./
       FCC     /.   CLEAR   -TRANSFORM         ./
       FCC     /.     CYCLE MODE-MOVES QUICKLY ./
       FCC     /.     ARMOR MODE-FOR FIGHTING  ./
       FCC     /(==============================)/
       FCC     /!!/
PICK   FCC     /=========== OPTIONS ============/
       FCC     /                                /
       FCC     / T-TRAVEL       H-HEAL BODY     /
       FCC     / F-FIX CYCLE    D-DROP ITEM     /
       FCC     / B-BUY          S-SALVAGE MISC  /
       FCC     / M-MOUNT WEAP   I-INFO #STATS#  /
       FCC     / E-EAT FOOD     J-JOYSTICK      /
       FCC     /          K-KEYBOARD            /
       FCC     /                                /
       FCC     /                                /
       FCC     /=========== MESSAGE ============/
       FCC     /                                /
       FCC     /                                /
       FCC     /================================/
       FCC     /LOCATION-                       /
       FCC     /                                /
       FCC     /   NORTH-                       /
       FCC     /   SOUTH-                       /
       FCC     /    EAST-                       /
       FCC     /    WEST-                       /
       FCC     /================================/
       FCC     /    $                           /
       FCC     /CASH---------AMMO-MISS-PAKS-FUEL/
       FCC     /================================/
MARKET FCC     /<======= THE AMMO DUMP ========>/
       FCC     /.KEY      DESCRIPTION    PRICE ./
       FCC     /.***      ***********    ***** ./
       FCC     /. A    1000 UNITS OF FUEL 150  ./
       FCC     /. B    1 DAY OF FOOD       45  ./
       FCC     /. C    100 50MM AMMO      200  ./
       FCC     /.*D    10 STING MISS      400  ./
       FCC     /.*E    5 MISSILE PACKS   1200  ./
       FCC     /. F    FULL REPAIRS       500  ./
       FCC     /. M    ** MORE ITEMS **        ./
       FCC     /. X    EXIT THE AMMO DUMP      ./
       FCC     /(==============================)/
       FCC     /!/
MARK2  FCC     /""""/
       FCC     /<==============================>/
       FCC     /. G    TRAIN IN MECH     1000  ./
       FCC     /. H    TRAIN IN MEDIC     500  ./
       FCC     /. I    MISSILE LAUNCHER  2500  ./
       FCC     /(==============================)/
       FCC     /!/
STSSS  FCC     /""""""""""""""""/
       FCC     /       <========================/
       FCC     /=======)                        /
       FCC     /        <=>                     /
       FCC     /        . &=====================/
       FCC     /        . .                     /
       FCC     /        . .                     /
       FCC     /        . &=====================/
       FCC     /        . .                     /
       FCC     /!/

BEGSC  FCC     /"""""""/
       FCC     /<==============================>/
       FCC     /.         M I S S I O N        ./
       FCC     /.              # 1             ./
       FCC     /(==============================)/
       FCC     /!/
STSCR  FCC     /================================/
       FCC     /       INVENTORY    .  ARMR RANK/
       FCC     /================================/
       FCC     /                                /
       FCC     /                                /
       FCC     /                                /
       FCC     /                                /
       FCC     /                                /
       FCC     /                                /
       FCC     /                                /
       FCC     /                                /
       FCC     /                                /
       FCC     /                                /
       FCC     /== MOUNTED MECH ==>             /
       FCC     /                  .             /
       FCC     /                  .             /
       FCC     /                  .             /
       FCC     /                  .             /
       FCC     /                  .             /
       FCC     /                  .             /
       FCC     /                  .             /
       FCC     /                  .             /
       FCC     /                  .             /
       FCC     /==================)             /


********************
*BCDADD ADDS 2 NOS
*1ST NO IN U
*BCDOP2 HAS ADDED NO
********************
BCDADD PSHS    A,B,X,Y,U
       LDD     ,U         GET 1ST NO
       STD     BCDOP1     SAVE IT
       LEAU    2,U        FIX FOR PROG
       LDX     #BCDOP2
       LDY     #RESULT
       ANDCC   #$FE       RESET CARRY
       LDB     #2
BCD010 LDA     ,-X
       ADCA    ,-Y
       DAA
       STA     ,-U
       DECB
       BNE     BCD010    NOT DONE
       PULS    U,Y,X,B,A   GET PARAMS
       RTS

BCDOP1 RMB     2       ORIGINAL
BCDOP2 RMB     2       ADDED
RESULT RMB     0       POINTER

**********************
* NUMPR-PRINTS NUMBERS
* BYTE 0,1=NUM X,Y,FCC,0
**********************
PRNUM  PSHS    A,X,U   SAVE THESE
       LDA     ,U      GET 1ST BYTE
       LSRA            GET 1ST NO
       LSRA
       LSRA
       LSRA
       ADDA    #48     ADD NUM
       STA     4,U     SAVE IN FCC
       LDA     ,U
       ANDA    #15
       ADDA    #48
       STA     5,U
       LDA     1,U     3/4 NUM
       LSRA
       LSRA
       LSRA
       LSRA
       ADDA    #48
       STA     6,U
       LDA     1,U
       ANDA    #15
       ADDA    #48
       STA     7,U
       LEAU    2,U     UP POINTER
       JSR     PRINT
       PULS    U,X,A
       RTS

*************************
* GRID DATA
*************************
GRID   FCB     3       NORTH
       FCB     0       SOUTH
       FCB     0       EAST
       FCB     2       WEST
       FCC     /FRENCH GYUANA      /
       FCB     0
       FCB     2       TRACK
       FCB     13      SECTOR
       FCB     3       TR END
       FCB     6       SEC END
       FCB     115     OBJECTS
       FDB     100
       FCB     116
       FDB     200
       FCB     111
       FDB     300
       FCB     113
       FDB     400
       FCB     117
       FDB     150
       FCB     120
       FDB     250
       FCB     121
       FDB     251
       FCB     122
       FDB     252
       FCB     123
       FDB     253
       FCB     124
       FDB     254

       FCB     0
       FCB     0
       FCB     1
       FCB     0
       FCC     /BRAZIL             /
       FCB     0
       FCB     3
       FCB     7
       FCB     3
       FCB     18
       RMB     30

       FCB     5
       FCB     1
       FCB     0
       FCB     4
       FCC     /PANAMA             /
       FCB     0
       FCB     4
       FCB     1
       FCB     4
       FCB     12
       RMB     30

       FCB     6
       FCB     0
       FCB     3
       FCB     0
       FCC     /MEXICO              /
       FCB     4
       FCB     13
       FCB     5
       FCB     6
       RMB     30

       FCB     0
       FCB     3
       FCB     0
       FCB     0
       FCC     /TEXAS               /
       FCB     5
       FCB     7
       FCB     5
       FCB     18
       RMB     30

       FCB     0
       FCB     4
       FCB     0
       FCB     0
       FCC     /NEW MEXICO          /
       FCB     6
       FCB     1
       FCB     6
       FCB     12
       RMB     30

************************
* CLEARS BOTH SCREENS
************************
SETCLR LDX     #51726
       LDA     #85
SETLP  STA     ,X+
       CMPX    #65023
       BNE     SETLP
       RTS

*************************
* AREA-SETS UP AN AREA
* TO/ A-HOLDS LOCATION
* FROM/ X-RET THE INDEX FOR DISK AND OTHER DIRS
*************************
AREA   TSTA            DEAD END?
       BEQ     DEND    YES
       DECA            -1 FOR TABLE
       LDB     #58     *58 (LAST 30 FOR ITEM)
       MUL
       ADDD    #GRID   ADD GRID LOC
       TFR     D,X     INDEX IT
       BRA     ISOK    NO DEAD END
DEND   LDX     #DTEXT-4  GET THE TEXT
ISOK   LDB     #4      OFFSET OF TITLE
       LDU     #NAME-4   GET NAME OFF
WORD   LDA     B,X     GET IST LETTER
       STA     B,U     SAVE IT
       INCB            GO TO NEXT ONE
       CMPB    #23     DONE?
       BNE     WORD
       LDU     #NX     GET PRINT PARM
       JSR     DISP    SHOW IT
       RTS

DTEXT  FCC     /-                   /
***********************
* SCREEN0SHOWS WHOLE SCREEN IN U
************************
SCREEN PSHS    A,B,X,U
       CLR     TITLE   RESET IT
       CLR     TITLE+1
       TFR     U,X     INTO RIGHT PARAM
       LDA     #24     LINE
       STA     COUNT2  TEMP COUNT
       LDU     #TITLE  WHERE IT GOES
TITLP  LDA     #32     32 CHARS
       STA     COUNT   SAV IT
       LDB     #2
OHNO   LDA     ,X+
       CMPA    #33     !
       BEQ     SCRDD
       CMPA    #34     "
       BNE     CONT
       DEC     COUNT2  1 LESS LINE
       LDA     TITLE+1 GET Y POS
       ADDA    #8
       STA     TITLE+1
       BRA     TITLP
CONT   STA     B,U
       INCB
       DEC     COUNT
       BNE     OHNO
       JSR     DISP
       LDA     TITLE+1 GET Y
       ADDA    #8
       STA     TITLE+1
       DEC     COUNT2  ONE LESS LINE
       BNE     TITLP
SCRDD  PULS    U,X,B,A
       RTS

**********************
* CHOOSE A DIRECTION
**********************
CHOOSE CLR     $FFDE   32K
       JSR     [$A000] KEY ROUT
       CLR     $FFDF   64K
       LDB     #0      NO PRESSED OR DEAD END
       CMPA    #88     X
       LBEQ    CMD     RETURN
       CMPA    #78     NORTH?
       BNE     ND1     NO
       LDB     NSTEMP  GET POINTER
ND1    CMPA    #83     SOUTH
       BNE     ND2     NO
       LDB     NSTEMP+1 GET S POINT
ND2    CMPA    #69     EAST
       BNE     ND3     NO
       LDB     NSTEMP+2 GET EAST POINT
ND3    CMPA    #87     WEST
       BNE     ND4     NO
       LDB     NSTEMP+3 GET W
ND4    TSTB            NONE PRESSED?
       BEQ     CHOOSE  BACK TO START
       STB     NEXT    SAVE THIS
       RTS

**************************
* DISK ROUTINE (READ)
*   PARAMS IN U
*+0 TRACK START 1
* 1 SECTOR START 1
* 2 TRACK END 1
* 3 SECTOR END 1
* 4 MEM START 2
* 6 MEM END 2
**************************
TRACK  RMB     1       OFFSET
SECTOR RMB     1       OFFSET
DBUFF  RMB     256     DISK BUFFER
BEND   RMB     0       BUFFER END
**************************
READ   PSHS    A,B,X,Y SAVE REGS
       LDX     4,U     GET MEM START
       LDA     ,U      GET TRACK & SECTOR TO SAVE
       STA     TRACK
       LDA     1,U
       STA     SECTOR
DSKLP  CLR     $FFDE   BASIC
       LDY     $C006   GET DIS START
       CLR     $FFDF
       LDA     #2      READ DISK
       STA     ,Y      SET IT
       CLR     1,Y     DRIVE #0
       LDD     #DBUFF  GET BUFFER LOC
       STD     4,Y     SAVE IN BUFF
       LDA     TRACK   GET TRACK
       STA     2,Y     SAVE IT
       LDA     SECTOR  GET SECTOR
       STA     3,Y     SAVE SECTOR
       CLR     $FFDE   32K MODE
       JSR     [$C004] READ A SECTOR
       CLR     $FFDF   64K MODE
       TST     6,Y     CKECK ERRORS
       BNE     ERROR
       LDY     #DBUFF  GET SECTOR START

MEMLP  LDA     ,Y+     GET A BYTE
       STA     ,X+     MOVE IT TO NEW MEM
       CMPX    6,U     COMPARE WITH MEM END
       BHI     DDONE   BRANCH IF DONE
       CMPY    #BEND   END OF BUFFER?
       BLO     MEMLP   NO!
       INC     SECTOR  INCREASE SECTOR
       LDA     TRACK   GET TRACK
       CMPA    2,U     CHECK LAST TRACK
       BNE     SECDEF  LAST TK? NO-SECTOR CHECK
       LDA     SECTOR  GET SECTOR NO.
       CMPA    3,U     CHECK LAST SECTOR
       BLS     SECDEF  KEEP GOING
       BRA     DDONE   DONE WHITH MOVE

SECDEF LDA     SECTOR  GET SECTOR
       CMPA    #19     NEW TRACK TIME?
       BNE     DSKLP   NO DO AGAIN
       INC     TRACK   ELSE TRACK+1
       LDA     #1      GET SECTOR START
       STA     SECTOR  SAVE IT
       JMP     DSKLP   KEEP READING

ERROR  PSHS    U       SAVE PARAMS
       LDU     #ERR1   GET ERROR MESSAGE
       JSR     DISP    PRINT IT
       PSHS    A,B
       JSR     HITANY  WAIT FOR KEY
       PULS    B,A
       LDU     #CLRERR GET CLEAR STRING
       JSR     DISP
       PULS    U       GET PARAMS
       JMP     DSKLP
DDONE  PULS    Y,X,B,A
       CLR     $FF40
       RTS
ERR1   FCB     3
       FCB     184
       FCC     /:  D I S K    E R R O R  :/
       FCB     0
CLRERR FCB     3
       FCB     184
       FCC     /                          /
       FCB     0
**************************
* CMD-TO PICK A COMMAND-BUY FIX ETC
**************************
STRY   FCB     0
FTRY   FCB     0        0=NTRY 1=Y
MTRY   FCB     0
RND    RMB     1       NUM 1-8
RANDOM FDB     33000   RANDOM PTR
KEYS   RMB     1       SAVES A KEY
CCNT   FDB     0       CNT FOR MSG CLEAR
CCLR   FCB     0
       FCB     95
       FCC     /                                /
       FCB     0
PRNK   RMB     1       X POS
       FCB     167
       FCB     92      BAR
       FCB     0
RANK   RMB     1
       FCB     175
       FCB     96
       FCB     0
***************************
JJJOY  FCB     5
       FCB     70
       FCC     /- NOW USING JOYSTICK -/
       FCB     0
KKKEY  FCB     5
       FCB     70
       FCC     /- NOW USING KEYBOARD -/
       FCB     0

CMD    TST     JOYKEY
       BEQ     KEYSH
       LDU     #JJJOY
       JSR     DISP
       BRA     LOOME
KEYSH  LDU     #KKKEY
       JSR     DISP
LOOME  TST     KEYS    KEY LAST TIME?
       BEQ     SKIP
       LDU     #AMMO+27 PRINT MONEY
       JSR     PRNUM
       LDU     #AMMO    AMMO
       JSR     PRNUM
       LDU     #AMMO+18 MISSILES
       JSR     PRNUM
       LDU     #AMMO+36 PAKS
       JSR     PRNUM
       LDU     #AMMO+9 PROTO
       JSR     PRNUM

       JSR     FLIP

       LDX     #1      CLEAR THE COUNT
       STX     CCNT
SKIP   LDX     CCNT    CLEAR MSS WHENEVER
       CMPX    #500
       BNE     CKEEP   NOT TIME
       LDU     #CCLR   CLEAR IT
       JSR     DISP
CKEEP  LEAX    1,X     ADD 1
       STX     CCNT
       CLR     $FFDE   32K
       JSR     [$A000]  GET A KEY
       LDX     RANDOM   GET PTR
       CMPX    #48000  TOP BOUND?
       BLO     XOK     NO
       LDX     #33000  START OVER
XOK    LEAX    1,X     NEXT ONE
       STX     RANDOM
       LDB     ,X      GET A NUMBER FROM 1-8?
       CLR     $FFDF   64K
       LSRB            SHIFT THE NUM
       LSRB
       LSRB
       LSRB
       LSRB
       STB     RND     SAVE NUM

       STA     KEYS    SAVE THE KEY
       CMPA    #84     "T"?
       BNE     C0      CHOOSE A DIRECTION
       LDU     #PDIR   MSG
       JSR     DISP
       JMP     CHOOSE  PICK A DIRECTION

PDIR   FCB     0
       FCB     95
       FCC     /   NORTH-SOUTH-EAST-WEST-XIT    /
       FCB     0

C0     CMPA    #70     "F" FIX IT?
       LBNE    C1      NO NEXT CMD
       TST     FTRY    1=TRIED
       LBNE    CANT    CANT FIX IT
       LDX     #INVENT  GOT TOOLS?
FLP    LDA     ,X+
       CMPA    #115
       BEQ     FIXIT
       CMPX    #INVENT+10
       BNE     FLP
       LDU     #TOOLS
       JSR     DISP
       JMP     CMD

FIXIT  CMPB    MECH    LOWER THEN MECH SKILL?
       BHI     NOFIX   NO
       LDA     X+3     GET STRENTH
       CMPA    #90     TOO STRNG?
       BHI     NOFIX   YES
       ADDA    #10     +10 POINTS
       ADDA    MECH    ADD MECH SKILL
       STA     X+3     SAVE HP
       LDU     #FIXED  MSG
       JSR     DISP
       LDA     #1      NOT AGAIN
       STA     FTRY
       JMP     CMD     BACK TO START
NOFIX  LDU     #NFIX   NOT FIXED
       JSR     DISP
       LDA     #1
       STA     FTRY
       JMP     CMD     LOOP

FIXED  FCB     0
       FCB     95
       FCC     /  YOU HAVE COMPLETED A REPAIR! /
       FCB     0
NFIX   FCB     0
       FCB     95
       FCC     / AT THIS TIME THE REPAIR FAILED /
       FCB     0
TOOLS  FCB     0
       FCB     95
       FCC     /YOU DONT HAVE A TOOL KIT TO TRY /
       FCB     0

C1     CMPA    #83     "SALVAGE"
       LBNE    C2
       TST     STRY
       LBNE    CANT    CANT DO IT NOW
       INC     STRY    TRIED IT ONCE
       CMPB    MECH    CAN DO?
       BHI     NSAL    CANT DO IT
       LDX     #INVENT SCAN LIST FOR OBJ
SALLP  LDA     ,X      GET OBJ
       CMPA    #118    USABLE?
       BEQ     DOSAL   YES!
       CMPA    #119
       BEQ     DOSAL
       LEAX    1,X     NEXT ONE
       CMPX    #INVENT+10  DONE?
       BNE     SALLP   NO
       BRA     NSAL    CANT SALVAGE
DOSAL  CLR     ,X      CLEAR THE OBJ
       CMPA    #118    WHAT KIND?
       BEQ     TYPE2   WHAT TYPE?
       LDD     #200
       BRA     DOSAL2
TYPE2  LDD     #100
DOSAL2 STD     BCDOP2  READY TO ADD
       LDU     #AMMO+27 GET CASH
       JSR     BCDADD  ADD THEM
       LDA     #8      REST OF MONY
       LDB     MECH    EXTRA
       MUL
       STD     BCDOP2  ADDIT
       JSR     BCDADD
       LDU     #SALY   MSG
       JSR     DISP
       JMP     CMD
NSAL   LDU     #SALN
       JSR     DISP
       JMP     CMD
SALY   FCB     0
       FCB     95
       FCC     / YOU MADE MONEY ON THE SALVAGE! /
       FCB     0
SALN   FCB     0
       FCB     95
       FCC     / NO MONEY WAS MADE ON SALVAGING /
       FCB     0
NOCAN  FCB     0
       FCB     95
       FCC     /YOU CAN NOT TRY THIS COMMAND NOW/
       FCB     0

CANT   LDU     #NOCAN
       JSR     DISP
       JMP     CMD

C2     CMPA    #72     "H"EAL
       LBNE    C3
       TST     MTRY    HEALED YET?
       BNE     CANT    CANT DO IT
       LDX     #INVENT  GOT A KIT?
MLP    LDA     ,X+
       CMPA    #116    ?
       BEQ     DOCT    YES
       CMPX    #INVENT+10
       BNE     MLP
       LDU     #MKIT
       JSR     DISP
       JMP     CMD

DOCT   CMPB    MEDIC   CAN HE DO IT?
       BHI     MEDN    IT FAILED
       INC     MTRY
       LDA     X+3     GET HP
       CMPA    #20     IS HE HURT?
       BHS     MEDOK   YOU ARE OK

       LDA     #20
       STA     X+3     SET HP TO 20
       LDU     #MEDY   YES MSG
       JSR     DISP
       JMP     CMD
MEDN   LDU     #MEDNO
       JSR     DISP
       JMP     CMD
MEDOK  LDU     #MOK
       JSR     DISP
       JMP     CMD

MEDY   FCB     0
       FCB     95
       FCC     /    YOU PREFORMED FIRST AID !   /
       FCB     0
MEDNO  FCB     0
       FCB     95
       FCC     /  YOU COULD NOT HEAL YOURSELF   /
       FCB     0
MOK    FCB     0
       FCB     95
       FCC     /    YOU HAVE NO BODY DAMMAGE    /
       FCB     0
MKIT   FCB     0
       FCB     95
       FCC     /  YOU DONT OWN A FIRST AID KIT  /
       FCB     0

C3     CMPA    #73     INVENTORY
       LBNE    C4      PRINT OBJECTS FIX SCREEN
       LDU     #STSCR
       JSR     SCREEN
       LDA     #15     GET PRINT Y
       STA     SHOW+1  SAVE IT
       LDX     #INVENT  GET OBJ LIST
INVLP  LDA     ,X+     GET ITEM
       CMPX    #INVENT+11 DONE?
       BEQ     INVEND  YES
       TSTA
       LBEQ    SORE    A BLANK
       SUBA    #111    GET NUM
       LDB     #23     *23
       MUL             GET START
       LDY     #NAMES  CLEAR PLACE MARKER
       LEAY    D,Y     ADD IT
INVST  LDA     SHOW+1
       ADDA    #8
       STA     SHOW+1
       LDB     #23     GET 23 CHARS
       LDU     #SHOW+2  WHERE IT GOES
INVLP2 LDA     ,Y+     GET CHAR
       STA     ,U+     PUT IT
       DECB            ONE LESS
       BNE     INVLP2
       LDU     #SHOW   SHOW THE OBJECT
       JSR     DISP
SORE   JMP     INVLP   DOAGAIN
INVEND TST     HIGH
       BEQ     II2
       LDU     #PHIGH
       JSR     DISP
II2    TST     TURB
       BEQ     II3
       LDU     #PTURB
       JSR     DISP
II3    TST     HEAVY
       BEQ     II4
       LDU     #PHEAV
       JSR     DISP
II4    TST     RADIO
       BEQ     II5
       LDU     #PRADIO
       JSR     DISP
II5    TST     LAUN
       BEQ     II6
       LDU     #PLAUN
       JSR     DISP
II6    TST     PACK
       BEQ     II7
       LDU     #PPACK
       JSR     DISP

II7    LDA     #24
       STA     PRNK
       LDA     X+3     GET HP
       CMPA    #110
       BLS     FOGE
       LDA     #1
FOGE   LSRA
       TSTA
       BNE     FOGE2
       LDA     #1
FOGE2  LDB     #180    START AT 5
RLP    STB     PRNK+1  SAVE IN X
       LDU     #PRNK
       JSR     DISP
       SUBB    #3      NEXT ZONE
       DECA            COUNTER
       BNE     RLP

       LDA     #28
       STA     RANK
       LDB     #180    DO RANK NOW
       LDA     MEDIC   GET ALL SKILLS
       ADDA    MECH
RLP2   STB     RANK+1
       LDU     #RANK
       JSR     DISP
       SUBB    #6      NEXT ZONE
       DECA            CNT
       BNE     RLP2

       JSR     HITANY  HIT A KEY
       LDU     #PICK   OPTION SCREEN
       LEAS    2,S     POP RETURN
       JMP     NEW

SHOW   FCB     1
       RMB     24
       FCB     0


PHIGH  FCB     0
       FCB     148
       FCC     / FAST LAUNCHER /
       FCB     0
PTURB  FCB     0
       FCB     156
       FCC     / TURBO UNIT    /
       FCB     0
PHEAV  FCB     0
       FCB     116
       FCC     / HEAVY LAUNCHER/
       FCB     0
PLAUN  FCB     0
       FCB     124
       FCC     / MISSILE UNIT  /
       FCB     0
PRADIO FCB     0
       FCB     132
       FCC     / RADIO #RANGED#/
       FCB     0
PPACK  FCB     0
       FCB     140
       FCC     / MISSILE PACK  /
       FCB     0


NAMES  FCC     /MISSILE PACK MAGAZINE  /
       FCC     /LONG RANGE RADIO       /
       FCC     /50MM AMMO  *L* TO USE  /
       FCC     /1 DAYS WORTH OF FOOD   /
       FCC     /CYCLETECH REPAIR KIT   /
       FCC     /SELF MED KIT           /
       FCC     /PROTOFUEL  *F* TO USE  /
       FCC     /SPARE PARTS            /
       FCC     /SCRAP METAL            /
       FCC     /MISSILE LAUNCHER       /
       FCC     /HEAVY PROJECTOR UNIT   /
       FCC     /TURBOJET TRANSMISSION  /
       FCC     /HIGH SPEED LAUNCHER    /
       FCC     /UNUSABLE AMMO          /

C4     CMPA    #69     "E"
       LBNE    C5
       LDA     #114    FOOD
       JSR     SCAN    WHERE?
       TSTA
       BEQ     NOEAT
       LDA     HUNG
       CMPA    #10
       BHS     NTHUNG
       LDA     #10
       STA     HUNG
       CLR     ,X      ATE FOOD
       LDU     #ATE
       JSR     DISP
       JMP     CMD
NTHUNG LDU     #NOTH
       JSR     DISP
       JMP     CMD
NOEAT  LDU     #NOFOOD
       JSR     DISP
       JMP     CMD
ATE    FCB     0
       FCB     95
       FCC     /   YOU ATE SOME RATIONS,YUMMY?  /
       FCB     0
NOFOOD FCB     0
       FCB     95
       FCC     / YOU DONT HAVE ANY FOOD TO EAT  /
       FCB     0
NOTH   FCB     0
       FCB     95
       FCC     /    YOU DONT NEED TO EAT YET!   /
       FCB     0

C6     CMPA    #77     MOUNT
       LBNE    C7
       TST     TMOUNT  TRY IT
       BEQ     MNTGO   NO
       JMP     CANT
MNTGO  INC     TMOUNT  FLAG
       CMPB    MECH    ROLLED MECH SKILL?
       BHI     NOMNT   NO
       LDA     #112    RADIO
       JSR     SCAN    HAVE IT?
       TSTA            =0 IS NO
       BEQ     M2
       CLR     ,X      OFF OF TABLE
       INC     RADIO   SET FLAG
       JMP     MNT     SUCC.
M2     LDA     #111    MISS PAC?
       JSR     SCAN
       TSTA
       BEQ     M3
       CLR     ,X
       INC     PACK
       JMP     MNT
M3     LDA     #120    MISS LAUNCER
       JSR     SCAN
       TSTA
       BEQ     M4
       CLR     ,X
       INC     LAUN
       JMP     MNT
M4     LDA     #121    HEAVY DAMMAGE
       JSR     SCAN
       TSTA
       BEQ     M5
       CLR     ,X
       INC     HEAVY
       JMP     MNT
M5     LDA     #123    FAST MISSILES
       JSR     SCAN
       TSTA
       BEQ     M6
       CLR     ,X
       INC     HIGH
       JMP     MNT
M6     LDA     #122    TURBO
       JSR     SCAN
       TSTA
       BEQ     NILMT
       CLR     ,X
       INC     TURB
       JMP     MNT
NILMT  LDU     #ZIPMT
       JSR     DISP
       JMP     CMD
NOMNT  LDU     #NMOU
       JSR     DISP
       JMP     CMD
MNT    LDU     #MOU
       JSR     DISP
       JMP     CMD
ZIPMT  FCB     0
       FCB     95
       FCC     / THERE IS NOTHING TO MOUNT!!!   /
       FCB     0
TMOUNT FCB     0
NMOU   FCB     0
       FCB     95
       FCC     /  YOU COULD NOT MOUNT ANY ARMS  /
       FCB     0
MOU    FCB     0
       FCB     95
       FCC     /YOU CORRECTLY MOUNTED SOMETHING /
       FCB     0
QUE2   FCB     0
       FCB     95
       FCC     / DROP IT?  YES ,  NO  ,  QUIT   /
       FCB     0
QUE3   FCB     0
       FCB     95
       FCC     /  THE ITEM WAS DROPPED          /
       FCB     0
QUE4   FCB     0
       FCB     95
       FCC     / THERE ARE NO ITEMS TO DROP !   /
       FCB     0

C7     CMPA    #68     "D"
       LBNE    C8
       LDX     #INVENT
       CLRA
SCHZO  CMPX    #INVENT+10
       BEQ     NITEMS
       TST     ,X+
       BNE     C7LZ
       INCA
       BRA     SCHZO
NITEMS LDU     #QUE4
       JSR     DISP
       JMP     CMD

C7LZ   STA     DRNOW
C7LP   CLR     $FFDE   BASIC
       JSR     [$A00A]
       JSR     [$A000]
       CLR     $FFDF   FULL
       TST     JOYKEY
       BEQ     SK1
       LDA     $15A    GET JOY VALUE
       CMPA    #50
       BLO     CUCU1
       BRA     YUYU1
SK1    LDA     342
       CMPA    #247
       BNE     CUCU1
YUYU1  INC     DRNOW
CUCU1  TST     JOYKEY
       BEQ     SK2
       CMPA    #10
       BHI     CUCU2
       BRA     YUYU2
SK2    LDA     341
       CMPA    #247
       BNE     CUCU2
YUYU2  DEC     DRNOW
CUCU2  LDA     DRNOW
       CMPA    #255
       BNE     CUCU3
       LDA     #9
CUCU3  CMPA    #10
       BNE     CUCU4
       LDA     #0
CUCU4  STA     DRNOW   SAVE AGAIN
       LDX     #INVENT
       TST     A,X
       BEQ     C7LP    DO AGAIN IF EMPTY
       LDA     A,X
       SUBA    #111    ADJUST
       LDB     #23
       MUL             COMPUTE OFFSET
       LDX     #NAMES  GET TABLE LOC
       LEAX    D,X     X+D
       LDY     #DROPSH+7
       LDB     #23
MOVELP LDA     ,X+
       STA     ,Y+
       DECB
       BNE     MOVELP
       LDU     #DROPSH
       JSR     DISP
       JSR     TUTIME  TIMER
       TST     JOYKEY
       BNE     SK3
       LDA     345
       CMPA    #247
       BEQ     DROIT
       JMP     C7LP
SK3    LDA     65280   JOY BUTTON
       CMPA    #126
       BEQ     DROIT
       CMPA    #254
       BEQ     DROIT
       JMP     C7LP

DROIT  LDU     #QUE2
       JSR     DISP
OE1    CLR     $FFDE
       JSR     [$A000]
       CLR     $FFDF
       CMPA    #81
       LBEQ    CMD
       CMPA    #78
       LBEQ    C7LP
       CMPA    #89
       BNE     OE1
       LDA     DRNOW
       LDX     #INVENT
       CLR     A,X     CLEAR THE OBJECT!
       LDU     #QUE3
       JSR     DISP
       JMP     CMD

TUTIME LDX     #20000
DECSO  LEAX    -1,X
       BNE     DECSO
       RTS

C8     CMPA    #75     K
       BNE     JLOOK
       CLR     JOYKEY
       LDU     #KKKSH
       JSR     DISP
       JMP     CMD
JLOOK  CMPA    #74     J
       BNE     C9
       LDA     #1
       STA     JOYKEY
       LDU     #JJJSH
       JSR     DISP
       JMP     CMD

C9     JMP     CMD

KKKSH  FCB     1
       FCB     95
       FCC     /SWITCHING TO KEYBOARD CONTROL/
       FCB     0
JJJSH  FCB     1
       FCB     95
       FCC     /SWITCHING TO JOYSTICK CONTROL/
       FCB     0

DROPSH FCB     1
       FCB     95
       FCC     /DROP                         /
       FCB     0
DRNOW  RMB     1       WHICH TO DROP
FLBUY  FCB     0       WHICH MRK SCRN

C5     CMPA    #66     BUY
       LBNE    C6
       LDU     #MARKET
       JSR     SCREEN
       CLR     FLBUY
BUYLP  TST     KEYS    HIT A KEY?
       BEQ     BSKIP   NO
       LDX     #1      CLEAR COUNT
       STX     CCNT
BSKIP  LDX     CCNT
       CMPX    #100
       BLO     BKEEP   NOT TIME TO CLEAR
       LDU     #CCLR   CLEAR IT
       JSR     DISP
BKEEP  LEAX    1,X     ADD ONE
       STX     CCNT
       JSR     FLIP
       CLR     $FFDE
       JSR     [$A000]
       CLR     $FFDF
       STA     KEYS      SAVE KEY
       LDU     #AMMO+27  SHOW VALS
       JSR     PRNUM
       LDU     #AMMO
       JSR     PRNUM
       LDU     #AMMO+18
       JSR     PRNUM
       LDU     #AMMO+36
       JSR     PRNUM
       LDU     #AMMO+9
       JSR     PRNUM
       TSTA
       BEQ     BUYLP
       CMPA    #88     XIT
       BEQ     BUYEND
       CMPA    #65     1FEUL
       BNE     BY2
       LDY     #38992  $150-
       JSR     PUR     BUY IT
       LDU     #4096   FU=1000
       STU     BCDOP2
       LDU     #AMMO+9
       JSR     BCDADD
       JMP     BUYLP

BUYEND LDU     #PICK
       JSR     SCREEN
       LEAS    2,S
       JMP     NEW     TO START

*NEXT ITEM*
BY2    CMPA    #66     FOOD
       BNE     BY3
       LDA     #0
       JSR     SCAN    FIND PLACE
       TSTA            =0?
       BEQ     NBFOOD  TOO MANY ITEMS 
       LDY     #39253  $45
       JSR     PUR
       LDA     #114    FOOD#
       STA     ,X      INTO TABLE
       JMP     BUYLP

NBFOOD LDU     #CBFDN
       JSR     DISP
       JMP     BUYLP

CBFDN  FCB     0
       FCB     95
       FCC     / YOUR PACK IS TOO FULL ALREADY! /
       FCB     0

BY3    CMPA    #67     C-AMMO
       BNE     BY4
       LDY     #38912  $200
       JSR     PUR
       LDU     #256    AM=100
       STU     BCDOP2
       LDU     #AMMO
       JSR     BCDADD
       JMP     BUYLP

BY4    CMPA    #68
       BNE     BY5
       LDY     #38400  $400
       JSR     PUR
       LDU     #16     MS=10
       STU     BCDOP2
       LDU     #AMMO+18
       JSR     BCDADD
       JMP     BUYLP

BY5    CMPA    #69
       BNE     BY6
       LDY     #34816
       JSR     PUR
       LDU     #5      PAK=5
       STU     BCDOP2
       LDU     #AMMO+36
       JSR     BCDADD
       JMP     BUYLP

BY6    CMPA    #70
       BNE     BY7
       LDY     #38144  $500-REPAR
       JSR     PUR
       LDA     #100    FULL STRENTH!
       STA     X+3
       JMP     BUYLP

BY7    CMPA    #71
       BNE     BY8
       LDY     #36864  $1000-MECH
       JSR     PUR
       INC     MECH
       LDA     MECH
       CMPA    #8
       BLO     BYE7
       LDA     #8
       STA     MECH
BYE7   JMP     BUYLP

BY8    CMPA    #72
       BNE     BY9
       LDY     #38144  $500-MED
       JSR     PUR
       LDA     MEDIC
       CMPA    #8
       BEQ     BYE8
       INC     MEDIC
BYE8   JMP     BUYLP

BY9    CMPA    #77     M-ORE
       BNE     BY10
       TST     FLBUY
       BEQ     BSC2
       CLR     FLBUY
       LDU     #MARKET
       JSR     SCREEN
       JMP     BUYLP
BSC2   INC     FLBUY
       LDU     #MARK2
       JSR     SCREEN
       JMP     BUYLP

BY10   CMPA    #73
       BNE     BY11    MISSILE LAUNC
       LDY     #32768  $2000
       JSR     PUR
       INC     LAUN
       JMP     BUYLP

BY11   JMP     BUYLP

MONS   RMB     2       SAVE MONEY
PUR    LDU     AMMO+27
       STU     MONS
       STY     BCDOP2  SAVE MINUS
       LDU     #AMMO+27
       JSR     BCDADD
       TST     AMMO+27 NEG CASH?
       BMI     BROKE
       LDU     #BOUGHT
       JSR     DISP
       RTS
BROKE  LDU     MONS    GET OLD CASH
       STU     AMMO+27
       LDU     #MINCH
       JSR     DISP
       LEAS    2,S     POP RETURN
       JMP     BUYLP
MINCH  FCB     0
       FCB     95
       FCC     /?? YOU DONT HAVE ENOUGH MONEY ??/
       FCB     0
BOUGHT FCB     0
       FCB     95
       FCC     /  THE PURCHASE HAS BEEN MADE !  /
       FCB     0
**************************
* NEET- BLANKS SCREEN
***************************
NEETV  RMB     2
NCNT   RMB     1
NEET   PSHS    A,B,X,Y,U
       LDX     OFFSET  START OF SCREEN
       LEAX    6143,X  END OF SCREEN
       STX     NEETV   SAVE THIS
       LEAX    -6145,X
       JSR     FLIP
       LDB     #8
       STB     NCNT
NEETLP LEAX    2,X     GET 2 BYTES
       LSR     ,X    DO THINGS
       LSL     1,X
       CMPX    NEETV   END OF SCREEN
       BLO     NEETLP
       DEC     NCNT    8 TIMES
       BEQ     NNEND
       LDX     NEETV
       LEAX    -6145,X  RESTORE
       BRA     NEETLP
NNEND  PULS    U,Y,X,B,A
       RTS     DONE!

******************
* DOOM-VERY DEAD
******************
DOOM   RTS

*****************
* SCAN-LOOKS IN INVENTORY
* ITEM IN A FIND POS X/A=0 IF NOT FOUND
*****************
SCSAVE RMB     1
LDHUH  RMB     1

SCAN   STA     SCSAVE
       LDX     #INVENT
SCNLP  LDA     ,X
       CMPA    SCSAVE
       BEQ     SCFND
       LEAX    1,X
       CMPX    #INVENT+10
       BNE     SCNLP
       CLRA
       RTS
SCFND  LDA     #1
       RTS


