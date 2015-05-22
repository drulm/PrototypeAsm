 PUBLIC FLIP
 PUBLIC X1
 PUBLIC TURN
 PUBLIC SCLOC
 PUBLIC DISP
 PUBLIC EXPLOD
 PUBLIC HITANY
 PUBLIC X
 PUBLIC Y
 PUBLIC PRINT  PRINT SUB
 PUBLIC DRANK
 PUBLIC OFFSET GRAPHICS OFF
 PUBLIC SMDIR
 PUBLIC SMDY
 PUBLIC KABOOM
 PUBLIC START
 PUBLIC SELWEP

PACK  EXT      MOUNTED DICT
LEVS  EXT      BACKGROUND 0-4
PROBJ EXT      SHOW OBJ
STNG2 EXT      STRENGHT?
COMP  EXT      COMPLETE WITH LEV
INSET EXT      SETUP INVID
MISCLR EXT     CLEAR ENEMY MISILES
INVID EXT      INVID CALL ROUTINE
RON   EXT      ROBOTS ON
RLOC  EXT      LOCATION OR ENEMY
PPP   EXT      2ND BODY OF PROG
BCDOP2 EXT     ADD OF BCD
AMMO   EXT
BCDADD EXT

*******************************
*   ROBOGAME MAIN
*******************************
*      STARTUP VALUES
ZZ     EQU     30720   HI SCREEN OFFSET
ON64K  EQU     $FFDF
OFF64K EQU     $FFDE
STACK  EQU     1400    STACK LOC
MWALK  EQU     9732+ZZ CYCLE PICTURES
MFLY   EQU     12804+ZZ
MBIKE  EQU     10500+ZZ
MUP    EQU     13572+ZZ   BIKE UP
MTRANS EQU     14340+ZZ
LOCH   EQU     36608   CHAR LOCATION
*
SNDST  FCB     1
       FCB     13
       FDB     1
       FDB     5000

SEXP   FCB     1
       FCB     5
       FDB     1000
       FDB     2000

START  JSR     SHCLR   CLEAR SHOTS
       JSR     MISCLR  CLEAR ENEMY SHOTS
       JSR     INSET   SET UP ENEMIES TABLE
       LDA     #15     START UP POS
       STA     X
       CLR     STNG2   SHOWN STRNG
       LDA     #1
       STA     TURN
       LDU     #SNDST
       JSR     SETUP   SET UP SOUND
       CLR     MODE
       LDU     #37386  START FOR SCROLL
       STU     SCLOC   SAVE IT
       JSR     HITANY
       LDU     #MES1
       JSR     DISP
       JSR     PROBJ
       JSR     EXPCLR  CLEAR SMOKE
       LDA     #0
       STA     AMMO-3  CLEAR STATUS
       JSR     SELWEP
*
TOP    JSR     PCLS    CLEAR THE SREEN
       LDX     #DRAW   START OF PARAMS
       JSR     PUT24   GOPUT IT
       JSR     SCROLL
       JSR     MOSH    MOVE THE SHOTS
       TST     RON     SEE IF TABLE IS ON
       BEQ     NFIGHT  NO ENEMIES
       JSR     INVID   MOVE ENIMIES
NFIGHT JSR     EXPMOV  PRINT EXPLOSIONS
       JSR     PPP     GO 2ND SUBROUT
       JSR     FLIP    DONE PRINTING
       JSR     CHGWEP  CHANGE WEAPON?
       JSR     SOUND
*MODE CHECK AND END OF LEV CHECK*
       LDU     SCLOC   GET S POS
       CMPU    #38303  RIGHT SIDE?
       BLT     GOOP    NO
       LDA     X       GET X POS
       CMPA    #20     RIGHT ENOUGH?
       BLO     GOOP
       RTS             BACK TO MAIN?!

GOOP   LDU     #Y      GET PARAM START
       JSR     CHEKY   CHECK Y POS
       TST     MODE    GET MODE TYPE
       BEQ     GOON    0=MAN MODE
       TST     UPDN    SLOPE?
       BNE     SLOPE
       LDD     #MBIKE  CYCLING MODE
       BRA     SLOPEN
SLOPE  LDD     #MUP    BIKE MODE
SLOPEN STD     DRAW    SAVE IN DRAW
********** TRANSFORM ROUTINE ********
GOON   CLR     OFF64K  NEED BASIC ROUT
       JSR     [$A00A] DO JOYSTICK
       JSR     [$A000] GET A KEY
       CLR     ON64K   NEED 64K
       TST     TRANS   FORMING?
       BEQ     FINDT   NO, GO GET KEYS
       CLRA            GET OFFSET
       LDB     DIREC
       ADDD    #MTRANS TRANS GRAFIX
       STD     DRAW    SAVE IT FOR GRAFIX

       TST     PACK+3  FAST UNIT?
       BNE     REFED
       DEC     TTIME2
       LBNE    NEXT1   OUT?
       LDA     #3      TIMED
       STA     TTIME2

REFED  TST     MODE
       BEQ     BRN1    YES ITS THE MAN
       DEC     DIREC   MAKE IT SMALLER
       DEC     DIREC
       DEC     DIREC
       DEC     DIREC
       BRA     BRN2    GO CHECK ROUTINE
BRN1   INC     DIREC   MAKE IT GREATER
       INC     DIREC
       INC     DIREC
       INC     DIREC
BRN2   DEC     COUNT   COUNT 4 TIMES
       LBNE    NEXT1   NO GO TO LOOP
       LDA     MODE    ELSE FLIP MAN/CYCLE
       EORA    #1      FLIP MODE
       STA     MODE
       CLR     TRANS
       JMP     GOOP    RETURN TO GET GOOD PIC
**** SEE IF HIT CLEAR (TRANSFORM) ****
FINDT  LDB     65280   RIGHT JOY BUTTON?
       CMPB    #125
       BNE     RJ2
       BRA     RJOK
RJ2    CMPB    #253
       BEQ     RJOK
       LDB     339     INKEY
       CMPB    #191    YAH?
       BNE     MOVE    GO TO MOVEMENT

RJOK   TST     PRTCNT
       BEQ     PRTSUB
       DEC     PRTCNT
       BRA     TROK
PRTSUB LDB     #4
       STB     PRTCNT
       LDU     #39321  "-1"
       STU     BCDOP2  SUB OFF PROTO
       LDU     #AMMO+9 PROTO LOC
       JSR     BCDADD
TROK   TST     PACK+3  TURBO UNIT?
       BNE     QWED
       DEC     TTIME   TIME TO TRANS
       BNE     MOVE
QWED   LDA     #8
       STA     TTIME
       DEC     Y       JUMP UP
       DEC     Y
       DEC     VY
       DEC     VY
       DEC     VY
       DEC     VY

       CLR     X1      CLEAR OUR OLD OFFSET
       LDA     #4      DO 4 TRANSFOMS
       STA     COUNT   SAVE IT
       LDA     #1      GET TRANS
       STA     TRANS   FLIP
       TST     TURN    GET DIRCETION
       BNE     RTRAN   RIGHT
       LDA     #16     LEFT
       STA     DIREC
       BRA     NEWT    GO MOVE
RTRAN  CLR     DIREC   FOR RIGHT
NEWT   TST     MODE
       LBEQ    GOON    NO CHANGE MAN TO CYCLE
       LDA     DIREC
       ADDA    #12     FOR LEFT
       STA     DIREC   SAVE IT
       JMP     GOON    SKIP STUFF NOW?
*****MOVEMENT UP*****
MOVE   TST     MODE    CYCLE MODE?
       BNE     NEXT1   YES, SO CANT FLY!
       LDB     $15B
       CMPB    #20
       BLO     MLCK
       LDB     341     UP
       CMPB    #247    YES IF SAME
       BNE     NEXT1
MLCK   TST     PRTCNT
       BEQ     DECF2
       DEC     PRTCNT
       BRA     DECFA
DECF2  LDB     #4
       STB     PRTCNT
       LDU     #39320  "-1"
       STU     BCDOP2
       LDU     #AMMO+9  PROTO
       JSR     BCDADD
DECFA  DEC     Y       BOOSTER UP
       CLR     VY      STOP ACC
       BRA     NOACC   DONT ACCELERATE
*****ACCELERATE DOWN****
NEXT1  INC     VY      FASTER VELOCITY
       LDB     Y
       ADDB    VY      MAKE ACCELERATE
       STB     Y       SAVE NEWW POS
       TST     TRANS   TRANSFORMING?
       LBNE    NEXT4*  YES SO SKIP THIS
*** JUMP JET UP ***
NOACC  TST     MODE    CYCLE MODE?
       BNE     NEXT2   NO JUMP JET IF CYC
       LDB     $15B
       CMPB    #10
       BLO     NLCK
       LDB     342     DOWN
       CMPB    #247    SAME?
       BNE     NEXT2
NLCK   TST     PRTCNT
       BEQ     DECF3
       DEC     PRTCNT
       BRA     DFA2
DECF3  LDB     #4
       STB     PRTCNT
       LDU     #39321  "-1"
       STU     BCDOP2
       LDU     #AMMO+9 PROTO
       JSR     BCDADD
DFA2   DEC     Y       MAKE HIM GO UP FAST
       DEC     Y
       DEC     VY
*** LEFT/RIGHT/SHOOT/TURBO***
NEXT2  TST     PACK+3
       BEQ     NEXTH
       LDA     $15A    JOY TURBO?
       CMPA    #4
       BLO     TOUCH
       CMPA    #60
       BHI     TOUCH

       LDA     340     TURBO?
       CMPA    #247    ?
       BNE     NEXTH
TOUCH  JSR     SCMOVE
NEXTH  TST     MODE    CYCLE OR MAN?
       BNE     NOSHT   BIKE CANT SHOOT
       JSR     SHOOT
       JSR     SIX
NOSHT  TST     TURN    WHICH WAY GOING
       BNE     TRNR    RIGHT TURN
       LDD     DRAW    GET PICTURE
       ADDD    #16     FOR LEFT
       STD     DRAW    SAVE IT
*TURN
TRNR   TST     REV     CAN
       BNE     TRGO    ITS OK
       TST     MODE
       BNE     NEXT4   CANT TURN HERE
TRGO   LDB     $15A
       CMPB    #15
       BLO     ZHUU
       LDB     343     LEFT
       CMPB    #247    SAME?
       BNE     NEXT3
ZHUU   CLR     TURN    LEFT!
       LDB     X1      GET X1
       SUBB    #4      ADD OFFSET FOR GRAFIX
       TSTB
       BGE     LSHIFT  NAH
       DEC     X       YAH,FIX X&X1
       LDB     #12
LSHIFT STB     X1
NEXT3  LDB     $15A
       CMPB    #45
       BHI     CACAS
       LDB     344     RIGHT
       CMPB    #247    SAME?
       BNE     NEXT4

CACAS  LDA     #1
       STA     TURN    RIGHT
       LDB     X1      GET X1
       ADDB    #4      SUBTRACT OFF
       CMPB    #16
       BNE     RSHIFT  NAH
       INC     X       NAKE BYTE GREATER
       CLR     X1      MAKE IT 12
       BRA     NEXT4   GT TO MAIN
RSHIFT STB     X1      SAVE NEW X1
NEXT4  JSR     BOUND   CHECK X&Y BOUNDS
       JMP     TOP     GO TO TOP

******* VARS *******

DRAW   FDB     9748    WHERE IN MEM PICTURE
X1     FCB     4       OFFSET OF PIC
Y      FCB     5       Y LOC FOR CYCLE
X      FCB     10      X LOC OF CYCLE
VY     FCB     1       VELOCITY
TRANS  FCB     0       0=NO 1=YES
STNG   FCB     30      30 HITS
MODE   FCB     0       0=GUY 1=CYCLE
DIREC  FCB     0       DIRECTION AND CYCLE OR MAN!
RANDOM FDB     34000   START OF ROM
TURN   FCB     0       0=LEFT 1=RIGHT
COUNT  FCB     5       DO 4 TIMES
OFFSET FDB     52736   SCREEN OFF
TTIME  FCB     5       TRANS TIME
TTIME2 FCB     3       FORM TIME
DRANK  FCB     0       RANK OF DRIVER
MES1   FCB     13
       FCB     159
       FCC     /AMMO MISS PAKS FUEL/
       FCB     0
UPDN   FCB     0
REV    FCB     0
SSHOT  FCB     1       TIMES
       FCB     8       DELAY
       FDB     $A85C   START
       FDB     $A95C   END
SEX    FCB     1
       FCB     16
       FDB     $6000
       FDB     $7000
CURWEP FCB     0
PRTCNT FCB     4
*******************************
*   CLEAR SCREEN ROUTINE   (I)
*******************************
PLAH   RMB     2

PCLS   LDU     OFFSET
       LEAU    1216,U
       STU     PLAH
       LDU     OFFSET  WHERE SCREEN IS
       LEAU    4128,U  GO TO END OF SCREEN
       LDX     #0      CLEAR SCREEN 0
       LDY     #0
       LDD     #0      WHAT TO PUT
DOIT   PSHU    A,B,X,Y ONTO SCREEN
       CMPU    PLAH    STRT SCREEN?
       BHS     DOIT

       LDD     OFFSET
       ADDD    #1248
       STD     PLAH    SAVE END LOC
       LDA     LEVS
       LDB     #38
       MUL             0 TO 4 * 38
       LDA     #32     *32
       MUL
       ADDD    #24320
       TFR     D,X     INTO X
       LDU     OFFSET  SCREEN LOC
DOIT2  LDD     ,X++
       STD     ,U++
       LDD     ,X++
       STD     ,U++
       LDD     ,X++
       STD     ,U++
       LDD     ,X++
       STD     ,U++
       LDD     ,X++
       STD     ,U++
       LDD     ,X++
       STD     ,U++
       LDD     ,X++
       STD     ,U++
       LDD     ,X++
       STD     ,U++
       LDD     ,X++
       STD     ,U++
       LDD     ,X++
       STD     ,U++
       LDD     ,X++
       STD     ,U++
       LDD     ,X++
       STD     ,U++
       LDD     ,X++
       STD     ,U++
       LDD     ,X++
       STD     ,U++
       LDD     ,X++
       STD     ,U++
       LDD     ,X++
       STD     ,U++
       CMPU    PLAH
       BLO     DOIT2
       RTS
*******************************
*   24*32 GRAPHIX PUT
*   X=1ST PARAM(1DRAW,1X1,1Y,1X)
*******************************
PUT24  LDD     ,X              GET  PARAMS
       ADDB    2,X             ADD B FOR START
       PSHS    A,B             SAVE FOR (X)
       LDB     #32             FIND Y
       LDA     3,X             GET Y
       MUL                     R(A)*32
       STD     PMX             SAVE IT
       CLRA                    CLEAR HI
       LDB     4,X             GET X POS
       ADDD    PMX             X+REST OF SCREEN
       ADDD    OFFSET          WHERE SCREEN IS
       ADDB    #4              +4 FOR METHOD!
       PULS    X               GET (X)
       TFR     D,Y             PUT LOC IN STACK
*
       LDA     #24             24TIMES
PTLP   LDB     ,-X            GET 1 BYTES
       ORB     ,-Y
       STB     ,Y             PUT ON SCREEN
       LDB     ,-X             GET 1 MORE
       ORB     ,-Y
       STB     ,Y
       LDB     ,-X
       ORB     ,-Y
       STB     ,Y
       LDB     ,-X
       ORB     ,-Y
       STB     ,Y
       LEAX    36,X            NEXT LINE
       LEAY    36,Y            OF STACKS
       DECA                    DECRT CNTR
       BNE     PTLP            KEEP GOING
*******************************DONE
       RTS
PMX    RMB     2               TEMP STORAGE
********************
* PAGE FLIP
********************
FLIP   LDA     #$34    SYNC W SCRN
       STA     $FF03
       LDA     $FF02
WT     LDA     $FF03
       BPL     WT
       LDA     BIT             GET PAGE SELECT
       EORA    #1              FLIPIT
       STA     BIT             SAVE IT
       TSTA                    0 OR 1?
       BNE     PAGE2           PAGE2
       CLR     65479          SET UP PAGE1
       CLR     65481
       CLR     65482
       CLR     65484
       CLR     65487
       CLR     65489
       CLR     65491
       LDD     #52736          GET OFFSET
       STD     OFFSET          SAVE IT
       BSR     PAGE            GET (SCREEN1,1)
       RTS                     OUT OF HERE
PAGE2  CLR     65479          SET UP PAGE2
       CLR     65481
       CLR     65483
       CLR     65484
       CLR     65486
       CLR     65489
       CLR     65491
       LDD     #58880          GET OFFSET
       STD     OFFSET          SAVE IT
       BSR     PAGE            PUT IN PAGE
       RTS
BIT    FCB     0               FILP FLOP
***************
* PAGE   (I)
***************
PAGE   LDA     #248    SCREEN AREA
       STA     65314   SAVE IT
       RTS             RETURN
**********************
* PRINT SUB--NEEDS X,Y,WORD,(0)--IN MEM
**********************
PRINT  PSHS    A,B,X,Y SAVE REGS
       LDA     ,U      GET X POS
       CMPA    #32     OUT OF RANGE?
       LBHS    DONE    YES DONT PRINT
       LDA     1,U     GET Y POS
       LDB     #32     A*32=D
       MUL             MAKE LOC
       ADDB    ,U++    ADD IN X AND +2 FOR CHARS
       ADDD    OFFSET  ADD FOR SCREEN
       TFR     D,Y     INTO INDEX
OUTER  LDA     ,U      GET CHAR
       LBEQ    DONE    0=DONE
       SUBA    #32     ADJUST
       LDB     #8      FIND CHAR
       MUL             A*8
       ADDD    #LOCH   ADD IN CHAR LOC
       TFR     D,X     INTO INDEX
       LDA     ,U+     GET CHAR IN RANGE +1>NEXT
       CMPA    #91     LAST CHAR!
       BGE     BLMV2   GO TO OR IT
       LDA     ,X+     GET BYTE +1 FOR NEXT
       STA     ,Y      SAV ON SCREEN
       LEAY    32,Y    FOR NEXT POS
       LDA     ,X+
       STA     ,Y
       LEAY    32,Y
       LDA     ,X+
       STA     ,Y
       LEAY    32,Y
       LDA     ,X+
       STA     ,Y
       LEAY    32,Y
       LDA     ,X+
       STA     ,Y
       LEAY    32,Y
       LDA     ,X+
       STA     ,Y
       LEAY    32,Y
       LDA     ,X+
       STA     ,Y
       LEAY    32,Y
       LDA     ,X
       STA     ,Y
       LEAY    -223,Y
       BRA     OUTER   DO IT AGAIN
** OR IT FOR GRAFIX **
BLMV2  LDA     ,X+     GET BYTE +1 FOR NEXT
       ORA     ,Y      BLEND IT IN
       STA     ,Y      SAV ON SCREEN
       LEAY    32,Y    FOR NEXT POS
       LDA     ,X+
       ORA     ,Y
       STA     ,Y
       LEAY    32,Y
       LDA     ,X+
       ORA     ,Y
       STA     ,Y
       LEAY    32,Y
       LDA     ,X+
       ORA     ,Y
       STA     ,Y
       LEAY    32,Y
       LDA     ,X+
       ORA     ,Y
       STA     ,Y
       LEAY    32,Y
       LDA     ,X+
       ORA     ,Y
       STA     ,Y
       LEAY    32,Y
       LDA     ,X+
       ORA     ,Y
       STA     ,Y
       LEAY    32,Y
       LDA     ,X
       ORA     ,Y
       STA     ,Y
       LEAY    -223,Y
       JMP     OUTER   BACK TO NEXT CHAR
DONE   PULS    Y,X,B,A GET REGS
       RTS             RETURN
************************
* SHOT ROUTINE! FIRES A SHOT
************************
SHOOT  LDA     SHOTS   6 TOO MANY
       CMPA    MAXSHT
       LBEQ    RET     YEAH TOO MANY
       LDA     345     " " LOC
       CMPA    #247    HIT IT?
       BEQ     HUHUT   NO SO RETURN
       LDA     65280   JOY BUTTON
       CMPA    #126
       BEQ     HUHUT
       CMPA    #254
       LBNE    RET
       LDA     CURWEP
       LBNE    BRK1    NOT THIS WEP

HUHUT  LDB     #97     CHAR OF SHOT
       TST     PACK+4  FAST GUN?
       BNE     FSTGUN  YES!!!
       DEC     STIME   TIME FOR ANOTHER
       LBNE    RET
FSTGUN LDA     #4
       STA     STIME
       TST     AMMO
       BNE     ENO1
       TST     AMMO+1
       BNE     ENO1
       JSR     SELWEP
       LBRA    RET

ENO1   LDA     #153    GET -1 BCD
       STA     BCDOP2
       STA     BCDOP2+1
       LDU     #AMMO   GET NUM LOC
       JSR     BCDADD  SUB 1
       BRA     HARHAR
BRK1   TST     PACK+2
       LBEQ    RET
       LDA     340     "BRK" KEY
       CMPA    #191    HIT?
       BEQ     SLWGO
       LDA     CURWEP  =1?
       CMPA    #1
       BNE     RET

SLWGO  LDB     #98
       TST     AMMO+18 TEST MISSILES
       BNE     CATS    O.K.
       TST     AMMO+19  =0?
       BNE     CATS    OUT OF MISS'
       JSR     SELWEP
       BRA     RET

CATS   LDA     #153    SUB 1
       STA     BCDOP2
       STA     BCDOP2+1
       LDU     #AMMO+18 GET MISSNUM
       JSR     BCDADD   SUB1
HARHAR LDU     #SSHOT   GET SOUND
       LDA     #15
       STA     SSHOT
       JSR     SETUP
       INC     SHOTS   1 MORE SHOT
       LDX     #SLOC   FIND A SPACE
SFIND  LDA     ,X++    GET X POS & +2
       CMPA    #190    IS IT A 0?
       BNE     SFIND   NO FIND IT
       LDA     X       GET MANS POS
       INCA            OVER 1
       STA     -2,X      SAVE IT IN SHOT
       LDA     Y       GET Y POS
       ADDA    #6      CENTER THE SHOT
       STA     -1,X     SAVE IN X+1
       STB     22,X    SAVE PICTURE

       TFR     X,U     PUT INTO PARAMS
       LEAU    -2,U    BACK 2
       LDA     TURN    FLIP IT
       EORA    #1

       TST     TURN    GOING LEFT?
       BNE     SH1     MUST BE GOING RT
       LDA     #255    GET -1
       STA     10,X      SAV IN TABLE
       BRA     SETY    SKIP RT
SH1    LDA     #1      GET FOWARD
       STA     10,X      INTO TABLE
SETY   CLR     11,X     CLEAR Y FOR NOW
RET    RTS             RETURN TO MAIN!
*
STIME  FCB     2       TIME TILL NEXT SHOT
SHOTS  FCB     0       SHOTS ON BOARD
SLOC   RMB     12      6*X/Y ALT
SSPD   RMB     12      6*X/Y ALT
SHCHR  RMB     12      WHAT THE SHOW IS
MAXSHT FCB     6       MAX NUMBER OF SHOTS
************************
* SIX-FIRES SIX MISSILES!
************************
SIXY   RMB     1       FIRST Y
SIXT   RMB     1       TURN

SIX    TST     PACK
       LBEQ    SIXR
       LDA     338     ENTER KEY?
       CMPA    #191    HIT IT?
       BEQ     SIXHU   NO RETURN

       LDA     65280
       CMPA    #126
       BEQ     GOIGGY
       CMPA    #254
       BEQ     GOIGGY
       LBRA    SIXR

GOIGGY LDA     CURWEP  =2?
       CMPA    #2
       LBNE    SIXR

SIXHU  LDA     SHOTS   MAX?
       LBNE    SIXR    MUST BE EMPTY
       TST     AMMO+36  ANY LEFT?
       BNE     FOOM    YES
       TST     AMMO+37
       BNE     FOOM    NONE LEFT
       JSR     SELWEP
       BRA     SIXR

FOOM   LDD     #39321  "-1"
       STD     BCDOP2  ONE LESS
       LDU     #AMMO+36  PAKS!
       JSR     BCDADD  ADD IT!
       LDA     Y
       STA     SIXY
       LDA     TURN
       STA     SIXT
       CLR     TURN    SHOOT IN ALL DIRECTIONS
       LDB     #98     MISSILE PIC
       JSR     HARHAR
       LDA     SIXY
       SUBA    #14
       STA     Y
       JSR     HARHAR
       LDA     SIXY
       ADDA    #14
       STA     Y
       JSR     HARHAR
       INC     TURN
       JSR     HARHAR
       LDA     SIXY    GET ORIGINAL Y
       SUBA    #14
       STA     Y
       JSR     HARHAR
       LDA     SIXY
       STA     Y
       JSR     HARHAR
       LDA     SIXT    RESTORE TURN
       STA     TURN
SIXR   RTS             RETURN?
****************
* CHANGE A WEAP
****************
CHGWEP LDB     $15C    GET JOY VAL
       CMPB    #40
       BLO     CHLW1
       TST     AMMO    CHECK AMMO FOR WEP1
       BNE     CHL1
       TST     AMMO+1
       BNE     CHL1
CHLW1  CMPB    #20
       BLO     CHLW2
       TST     PACK+2   EXISTS?
       BEQ     CHLW2
       TST     AMMO+18  CHK MISSILE AMMO
       BNE     CHL2
       TST     AMMO+19
       BNE     CHL2
CHLW2  TST     PACK
       BEQ     CHGR
       TST     AMMO+36  CHK PACK AMMO
       BNE     CHL3
       TST     AMMO+37
       BNE     CHL3
       RTS
CHL1   LDA     #0
       STA     CURWEP
       JSR     SHWEP
       RTS
CHL2   LDA     #1
       STA     CURWEP
       JSR     SHWEP
       RTS
CHL3   LDA     #2
       STA     CURWEP
       JSR     SHWEP
CHGR   RTS


*********************
* SELECT A WEAPON
*********************
SELWEP TST     AMMO    CHECK AMMO FOR WEP1
       BNE     SEL1
       TST     AMMO+1
       BNE     SEL1
       TST     PACK+2   EXISTS?
       BEQ     SELW2
       TST     AMMO+18  CHK MISSILE AMMO
       BNE     SEL2
       TST     AMMO+19
       BNE     SEL2
SELW2  TST     PACK
       BEQ     SELW3
       TST     AMMO+36  CHK PACK AMMO
       BNE     SEL3
       TST     AMMO+37
       BNE     SEL3
SELW3  LDA     #3
       STA     CURWEP    NO WEAPON
       JSR     SHWEP
       RTS
SEL1   LDA     #0
       STA     CURWEP
       JSR     SHWEP
       RTS
SEL2   LDA     #1
       STA     CURWEP
       JSR     SHWEP
       RTS
SEL3   LDA     #2
       STA     CURWEP
       JSR     SHWEP
       RTS

WEPLST FCB     13
       FCB     147
       FCC     /50MM RIFLE      /
       FCB     0
       FCB     13
       FCB     147
       FCC     /GUIDED MISSILE  /
       FCB     0
       FCB     13
       FCB     147
       FCC     /SIX PACK ROCKETS/
       FCB     0
       FCB     13
       FCB     147
       FCC     /NO WEAPON LOADED/
       FCB     0
********************
* SHOW WEAP
********************
SHWEP  LDB     #19
       MUL             A(1..3)*19
       ADDD    #WEPLST
       TFR     D,U
       JSR     DISP    SHOW WEAPON
       RTS

*********************
* MOSH -MOVE SHOT..
*********************
MOSH   LDX     #SLOC   GETTHE X LOCATION
MO1    CMPX    #SSPD    DONE WITH ALL SHOTS?
       LBEQ    MOX     YES, GET OUT!
       LDA     ,X++    GET X
       CMPA    #190    IS IT DEAD?
       BEQ     MO1     GET NEXT
       STA     SHX     SAV TO PRINT
       LDA     -1,X    GET OLD Y (++)
       STA     SHY     SAVE FOR Y PRINT
       LDA     22,X    GET PIC
       STA     SHX+2   SAVE IT
       LDU     #SHX     GET START OF PARAM
       JSR     PRINT   PRINT IT
*HIT GROUND?
       LDU     SCLOC   GET SCROLL0
       LDA     SHX     GET X POS
       ASLA            *2
       LDB     SHY     GET Y OF SHOT
       CMPB    A,U     ?
       BLO     NOBOOM  LOWER THAN LAND
       LDU     #SHX
       JSR     EXPLOD  BLAST GROUND
       LDA     #190    CLEAR SHOT
       STA     -2,X    CLEAR IT
       DEC     SHOTS
       JMP     MO1     TO START
*A HIT?
NOBOOM TST     RON     ARE THE THINGS ON
       LBEQ    BLOUT   NO GET OUT
       LDU     #RLOC-5 GET SHIP LOCATIONS
BLAST  LEAU    5,U     GET NEXT SHIP
       CMPU    #RLOC+15  DONE?
       LBHS    BLOUT   YES
       LDA     4,U     IS IT ON?
       CMPA    #190
       BEQ     BLAST
*   GUIDED?
       LDA     22,X    GET SHOT PIX
       CMPA    #98     GUIDED?
       BNE     SHREG   NO
       LDA     1,U     Y LOC
       ADDA    #10     CENTER
       CMPA    -1,X
       BHI     SHDN    GO DOWN
       DEC     11,X    MAKE IT GO UP
       DEC     -1,X
       BRA     SHREG   CHECK RT LEFT
SHDN   INC     11,X    INCRASE DN VEL
       INC     -1,X

SHREG  LDA     ,U      GET X OF SHIP
       CMPA    -2,X    COMPARE X OF SHOT
       BHI     BLAST   NOT IN RANGE
       ADDA    #4      ADD RANGE
       CMPA    -2,X    COMPARE TO X
       BLO     BLAST
       LDA     1,U     GET Y
       CMPA    -1,X    COMPARE TO SHOT Y
       BHI     BLAST
       ADDA    #42     RANGE
       CMPA    -1,X
       BLO     BLAST   AFTER THIS A HIT?
*
SHHIT  DEC     SHOTS   1 LESS SHOT
       LDA     10,X    GETX VELOC
       INCA            1 BIGGER FOR DIREC
       STA     SMDIR   MAKE IT THE SMOKE DIRECTION
       PSHS    U       SAVE MONSTER LOC
       TFR     X,U     TRANS
       LEAU    -2,U    BACK TO FIRST
       CLR     SMDY    STRAIGHT
       JSR     EXPLOD  DO THE SMOKE
       PULS    U       GET IT BACK
       LDA     #190    CLEAR CHAR
       STA     -2,X    CLEAR OUT SHOT
       LDA     22,X    WAS IT A STINGER?
       CMPA    #98     ?
       BEQ     BLAM    YUP
       DEC     4,U     LESS HIT POINTS
       TST     PACK+5  HEAV POWER?
       BEQ     SHDIE
       DEC     4,U     MEGA DAMAGE
       DEC     4,U
       DEC     4,U
       DEC     4,U
       BRA     SHDIE   IS IT DEAD?
BLAM   LDA     4,U     BOOM -10
       SUBA    #10
       STA     4,U
SHDIE  LBPL    MO1     IM NOT DEAD YET!

       LDA     #100    RESET HP
       STA     4,U
       LDD     #46592  START OF GRAPH
       STD     2,U     NO START DEATH
       LDD     #256    "100"
       ADDD    DRANK
       STD     BCDOP2
       LDU     #AMMO+27
       JSR     BCDADD  MORE MONEY!
       JMP     MO1     TO STRT/NULL SHOT

BLOUT  LDA     -2,X    GET OLD X
       ADDA    10,X    ADD IN VELOC
       STA     -2,X    SAVE IT AGAIN
       CMPA    #32     BOUND2
       BLO     YBND    NO CHECK Y BOUND
ERASE  LDA     #190    CLEAR CHAR
       STA     -2,X    CLR OUT X POS
       DEC     SHOTS   1 LESS SHOT
       JMP     MO1     BACK TO START
YBND   LDA     -1,X    GET Y POS
       ADDA    11,X    ADD IN Y VEL
       STA     -1,X    SAVE Y AGAIN
       TSTA            Y BOUND
       BMI     ERASE   CLEAR IT
       JMP     MO1     BACK TO START
MOX    RTS             RETURN
*
SHX    RMB     1       X FOR PRINT
SHY    RMB     1       Y FOR PRINT
       FCB     97      ENERGY BOLT >91?
       FCB     0       DONE
******************
* CLEAR ALL SHOTS
******************
SHCLR  CLR     SHOTS   0 SHOTS
       LDX     #SLOC   GET X LOC
SHLP   CMPX    #SSPD   DONE?
       BEQ     SHOUT   DONE
       LDA     #190    CLEAR CHAR
CL1    STA     ,X++    CLEAR THIS
       BRA     SHLP    DO ALL SHOTS
SHOUT  RTS             DONE!
************************
* SCROLL WHEN IN CYCLE MODE
************************
UK     RMB     2

SCROLL JSR     SCMOVE  MOVE TO SCROLL
       CLR     SCX     CLEAR THE LEFT SIDE
       LDX     SCLOC   GET START LOC
SCLP   LDA     ,X      GET Y LOC
       LDB     #32
       MUL             B*32
       STD     UK      SAVE B*32
       CLRA
       LDB     SCX     GET X LOC
       ADDD    UK      PLUS B*32
       ADDD    OFFSET
       ADDD    #224
       TFR     D,Y
       LDU     OFFSET  BOUND
       LEAU    3520,U
       STU     UK
       LDA     #2
PINHD  STA     ,Y      SAVE BACK
       LEAY    224,Y   ADD 192
       CMPY    UK      DONE?
       BLO     PINHD   NO

       LDA     ,X++    GET Y LOC
       STA     SCY     SAVE IN Y
       LDA     -1,X     GET LAND ++
       STA     LAND    SAVE IN LAND VAR
       LDU     #SCX    GET START OF PRINT!
       JSR     PRINT   PRINT LAND!
       LDA     SCX     GET X
       INCA            UP BY ONE
       STA     SCX     SAVE IT
       CMPA    #32     DONE?
       BNE     SCLP    BAC AGAIN
SDONE  RTS             TO MAIN!
*
SCX    FCB     0       X LOCATION
SCY    FCB     0       PUT Y LOCATION
LAND   FCC     /*/     WHAT THE LAND IS
       FCB     0       END OF PRINT
SCLOC  FDB     37376   SOMEWHERE IN HI-MEM
*************************
* SCMOVE-MOVES WHEN CYCLE!
*************************
SCMOVE TST     MODE    CYCLE?
       BEQ     SCLAST  = THEN MAN
       TST     TURN    LEFT OR RIGHT?
       BEQ     SCLFT   LEFT=
       LDX     SCLOC   TOO GREAT?
       CMPX    #38308  TOO BIG
       BGE     SCLAST  STOP SCROLL
       LEAX    2,X     MAKE BIGER
       STX     SCLOC

       LDX     #RLOC   GET ENEMY LOC
MVEN   LDA     4,X     GET X POS
       CMPA    #190    IS IT ON?
       BEQ     NSHVE   NO
       DEC     ,X      DEC X POS
NSHVE  LEAX    5,X     NEXT ONE
       CMPX    #RLOC+15 DONE?
       BNE     MVEN    NO    

       BRA     SCLAST  TO END
SCLFT  LDX     SCLOC   TOO SMALL
       CMPX    #37380  TOO SMALL?
       BLE     SCLAST  =YES
       LEAX    -2,X
       STX     SCLOC   SAVE IT

       LDX     #RLOC   GET ENEMY LOC
MVEN2  LDA     4,X     GET X POS
       CMPA    #190    IS IT ON?
       BEQ     NSHVE2  NO
       INC     ,X      INC X POS
NSHVE2 LEAX    5,X     NEXT ONE
       CMPX    #RLOC+15 DONE?
       BNE     MVEN2   NO

SCLAST RTS             TO MAIN!
*********************
* CHEKY- IS IT ON GROUND  Y-FIRST THEN X
* PARAM U CHANGED TO FIT GROUND
*********************
CHEKY  LDX     SCLOC   GET SCROLL POS.
       LDD     #MFLY   ASSUME FLYING
       STD     DRAW    SAVE IT
       LDB     1,U      GET X POS
       LSLB            X*2
       ABX             SCLOC+POS
       LEAX    2,X     PUT IT IN TH MIDDLE
       LDB     ,U      GET Y POS OF THING
       CLR     REV     YES CAN REVERSE
       ADDB    #24     DO THIS FOR HEIGHT
       CMPB    ,X      COMPARE TO LAND
       BLE     CHEND   ITS OK=
       LDB     ,X      FIX IT,GET LAND POS
       SUBB    #24     SET IT FOR HEIGHT
       STB     ,U      SAVE NEW Y POS!
       CLR     2,U     CLEAR OUT VELOCITY
       TST     MODE
       BEQ     SCNB    MAN CANT JUMP
       LDA     1,X     GET LND HES OVER
       CMPA    #59     BUMP?
       BNE     SCNB    NO
       LDA     #248    NEG16 ACC
       STA     VY      RAMP EFFECT
       DEC     Y
SCNB   CMPA    #111    MINES?
       BNE     NOMIN   LOAD POS
       LDA     X
       INCA
       STA     EXPPOS
       LDA     Y
       ADDA    #20
       STA     EXPPOS+1
       LDU     #EXPPOS
       JSR     EXPLOD
       LDA     STNG    GET HP
       SUBA    #8      OUCH!
       BPL     GUGU
       LDA     #100
GUGU   STA     STNG
NOMIN  LDD     #MWALK  NO, HES WALKING
       STD     DRAW    SAVE IT
       LDA     #1      CANT TURN MID AIR
       STA     REV
CHEND  CLR     UPDN    NO MOVEMENT
       LDA     2,X     GET LAND
       CMPA    4,X     HIGHER
       BGE     CHDONE  NO UP OR DOWN
       LDA     #1      GOING UP
       STA     UPDN    SAVE IT
CHDONE RTS

EXPPOS RMB     2
*****************************
* BOUND--TEST X AND Y BOUNDS FOR SHIP
*****************************
BOUND  LDA     X       GET X POS
       CMPA    #27     RT SIDE?
       BLO     LBOUND  NO CHECK LEFT
       CLR     X1      NO MODE BIT SCROLL
       LDA     #27     FIX X
       STA     X
LBOUND CMPA    #2      LEFT SIDE?
       BHI     YBOUND  CHECK Y PART
       CLR     X1      SAME POS
       LDA     #3      MAKE IT FOR LEFT?
       STA     X
YBOUND LDA     Y       CHECK THE Y
       CMPA    #220    OFF TOP?
       BLO     BNDEND  Y IS OK NO MOD
       CLR     Y       MAKE SHIP STAY AT TOP
BNDEND TST     AMMO+9  =0?
       BNE     BNDOK   NO
       LDA     #80     =50
       STA     AMMO+10
BNDOK  TST     MODE
       BNE     BNDFIN  NOT MAN MODE
       LDU     #39321  "-1"
       STU     BCDOP2
       LDU     #AMMO+9
       JSR     BCDADD
BNDFIN RTS             DONE
*************************
* HITANY-HIT A KEY TO CONTINUE
*************************
HITANY PSHS    A
HIT2   CLR     $FFDE   32K MODE
       JSR     [$A000] JUMP KEY ROUTINE
       CLR     $FFDF   64K MODE
       TSTA            A=0?
       BEQ     HIT2    AGAIN
       PULS    A
       RTS             RETURN

*************************
* EXPLOSION ROUT (30)
* 190 FOR X=EXPLOSION OFF
* X/Y/CYCLE/0/X DIRECTION
*************************
EXPNO  FCB     0       NUMBER OF EXPLOSIONS
SMOKE  RMB     300     300=50*6 X,Y,CYCLE
SMDIR  FCB     0       DIR OF SMOKE 0=LT 1=R
SMDY   FCB     0       SMOKE DIR: -10..+10

EXPCLR LDX     #SMOKE  GET START OF SMOKE
       CLR     EXPNO   CLEAR ALL SMOKE
       LDA     #190    GET CLEAR NO.
EXPLP1 STA     ,X      SAVE IT
       CLR     3,X     CLEAR LAST PRINT
       LEAX    6,X     UP BY 3
       CMPX    #SMDIR  END OF SMOKE
       BLO     EXPLP1  DO ALL CLOUDS
       RTS
************************
* EXPLOD-MAKES A NEW SMOKE
* PASS X,Y LOC IN U
************************
EXPLOD PSHS    A,B,X,Y SAVE REGS
       LDA     EXPNO   HOW MANY?
       CMPA    #45     ARE THERE 30 ALREADY?
       BHI     EXPEND  YES NO GO
       INC     EXPNO   1 MORE EXPLOSION!
       LDX     #SMOKE-6  ELSE GET TABLE
EXPLP2 LEAX    6,X     TABLE+5
       LDA     ,X      IS IT 190?
       CMPA    #190
       BNE     EXPLP2  NO
       LDD     ,U      GET X AND Y
       STD     ,X      SAVE IN SMOKE
       DECA            -1 SO NO WIERD
       LDA     #99     START OF SMOKE-1
       STA     2,X     SAVE IN 3RD LOC
       TST     SMDIR   0=LEFT
       BNE     SMRT    SMOKE RT
       LDA     #255    LEFT
       STA     4,X     SAVE IN DIRC
       LDA     SMDY    GET Y DIREC
       STA     5,X     SAVE IN Y DIR

       BRA     EXPEND  DONE
SMRT   LDA     #1      RIGHT
       STA     4,X     SAVE IN DIR

EXPEND PULS    Y,X,B,A GET REGS
       RTS             RETURN
************************
* EMPMOV:MOVES EXPLOSIONS
************************
EXPMOV LDX     #SMOKE-6  GET TABLE
EXPLP3 LEAX    6,X     GET TABLE+4
       LDA     ,X      GET X LOC
       CMPX    #SMDIR  END TABLE
       BHS     EXLST   END OF TABLE
       CMPA    #190    A BLANK?
       BEQ     EXPLP3  YES GET NEXT
       INC     2,X     GO TO NEXT ANIMATION
       LDA     2,X     WHAT IS IT?
       CMPA    #111    LAST ONE?
       BNE     EXPHED  NO
       LDA     #190    GET CLEAR NO
       STA     ,X      SAVE IT
       DEC     EXPNO   1 LESS EXPLOSION
       BRA     EXPLP3  NEXT EXPLOS
EXPHED TFR     X,U     PUT X INTO PARAM
       LDA     ,X      GET SMOKE X LOC
       ADDA    4,X     ADD SMOKE DIRECTION
       STA     ,X
       LDA     1,X     GET Y LOC
       ADDA    5,X     ADD IN SMOKE
       STA     1,X
       CMPA    #120    IN RANGE?
       BHI     EXPLP3  NO WAY

       JSR     PRINT   PRINT THE THING
       BRA     EXPLP3  BACK TO START
EXLST  RTS             BACK TO MAIN
********************
* KABOOM-BIG EXPLOSION AT X,Y IN U
********************
KATEMP FCB     0       COUNTS NO OF SMOKE

KABOOM PSHS    A,B,X,Y SAVE EM
       PSHS    U
       LDU     #SEX
       JSR     SETUP
       PULS    U
       LDA     EXPNO
       CMPA    #38
       BHI     KAEND
       LDA     #32     32 SMOKE
       STA     KATEMP
       LDX     #KADIR  GET EXP DIRECTIONS
KALP   DEC     KATEMP  1 LESS
       BEQ     KAEND   DONE
       LDA     ,X+     GET X DIREC
       STA     SMDIR   SAVE IN PARAM
       LDA     ,X+     GET Y
       STA     SMDY
       JSR     EXPLOD  HAVE Y SO BLOW IT
       BRA     KALP
KAEND  PULS    Y,X,B,A GET REGS
       RTS

KADIR  FDB     $00FF   EXPLOSION TABLE
       FDB     $01FE
       FDB     $00FD
       FDB     $01FC
       FDB     $00FB
       FDB     $01FA
       FDB     $00F9
       FDB     $01F8
       FDB     $00F7
       FDB     $01F6
       FDB     $00F5
       FDB     $01F4
       FDB     $00F3
       FDB     $01F2
       FDB     $00F1
       FDB     $0100
       FDB     $010F
       FDB     $000E
       FDB     $010D
       FDB     $000C
       FDB     $010B
       FDB     $000A
       FDB     $0109
       FDB     $0008
       FDB     $0107
       FDB     $0006
       FDB     $0105
       FDB     $0004
       FDB     $0103
       FDB     $0002
       FDB     $0101
       FDB     $0000
       FDB     $0100

***********************
* DISP   -SHOWS ON BOTH SCREENS
***********************
DISP   PSHS    A,B
       LDD     OFFSET
       PSHS    A,B
       LDD     #52736
       STD     OFFSET
       STU     USAVE
       JSR     PRINT
       LDU     USAVE
       LDD     #58880
       STD     OFFSET
       JSR     PRINT
       PULS    B,A
       STD     OFFSET
       LDU     USAVE
       PULS    B,A
       RTS
USAVE  RMB     2       SAVE U TEMP

*************
* SETUP
*************
SETUP  PSHS    A,B
       LDD     ,U
       STD     SBUFF
       LDD     2,U
       STD     SBUFF+2
       LDD     4,U
       STD     SBUFF+4
       PULS    B,A
       RTS

SBUFF  RMB     6       TEMP CONTENTS

