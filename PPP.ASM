******************
* PPP-EXT FILE
******************
  PUBLIC   PPP
  PUBLIC   AMMO
  PUBLIC   PROBJ   SHOW OBJECTS
  PUBLIC   STNG2

SELWEP EXT     SELECT WEAPON
DISP   EXT
X      EXT
COMP   EXT     COMPLETE/+1 LOCO/+3INVENTORY
PRINT  EXT
PRNUM  EXT     SCORING VARS
BCDADD EXT
BCDOP2 EXT
SCLOC  EXT     SCROLL LOCAT

PPP    LDU     #AMMO   SHOT NUM
       JSR     PRNUM   PRINT IT
       JSR     OBJSH
       LDU     #STING  MISSILES?
       JSR     PRNUM
       LDU     #PAK    MISS PAKS>
       JSR     PRNUM
       LDU     #PROTO
       JSR     PRNUM
       JSR     GET     GET OBJECTS?
       JSR     LOAD    LOAD AMMO
       JSR     LOAD2   LOAD FUEL
LP9    LDA     STNG2
       LSRA
       LSRA
       LDB     #32
       MUL
       STD     TSTS
       LDD     #65033  GET LOC SCREEN
       SUBD    TSTS
       TFR     D,X
       LDA     #170
       STA     ,X
       STA     -6144,X
       LDA     STNG2
       LSRA
       LSRA
       LDB     #32
       MUL
       STD     TSTS
       LDD     #65033  GET LOC SCREEN
       SUBD    TSTS
       TFR     D,X
       LEAX    -32,X
       CLR     ,X 
       CLR     -6144,X

       LDA     X+3     GET STNG
       CMPA    STNG2
       BLO     DECIT
       BHI     INCIT
       BRA     STOPIT
DECIT  DEC     STNG2
       BRA     STOPIT
INCIT  INC     STNG2
STOPIT RTS

STNG2  RMB     1
TSTS   RMB     2

AMMO   FDB     257     "500"
       FCB     13
       FCB     167
       FCC     /    /
       FCB     0
PROTO  FDB     8192    "2000"
       FCB     28
       FCB     167
       FCC     /    /
       FCB     0
STING  FDB     153     "99"
       FCB     18
       FCB     167
       FCC     /    /
       FCB     0
CASH   FDB     256     "100"
       FCB     0
       FCB     167
       FCC     /    /
       FCB     0
PAK    FDB     4       "8"
       FCB     23
       FCB     167
       FCC     /    /
       FCB     0
**************************
* OBJSH-SHOWS OBJECTS
**************************
OBJTEM RMB     2       TEMP OBJ VAR
OBJFIN RMB     2       SAVES DONE LOCAT
OBJPRT RMB     3       PRINT LOC
       FCB     0

OBJSH  LDX     COMP+1      GET OBJECT TABLE
       TFR     X,U         +30 FOR DONE
       LEAU    30,U
       STU     OBJFIN
       LDD     SCLOC       GET SCROLL LOC
       SUBD    #37376  =1-1000
       LSRA            DIVIDE BY 2
       RORB
       STD     OBJTEM
OBJLP  LDA     ,X      GET OBJ
       BEQ     OBJNXT  NOT LIGIT
       STA     OBJPRT+2  FOR PRINTING CHAR
       LDD     1,X     GET OBJ LOC 1-500
       SUBD    OBJTEM  SUBTRACT THE NUM
       CMPD    #31     IS IT IN RANGE
       BHI     OBJNXT  NO
       STB     OBJPRT  SAVE X LOC
       LSLB            B=B*2+1
       LDU     SCLOC   FIND Y FOR YHING
       LDA     B,U
       SUBA    #7      UP 8
       STA     OBJPRT+1
       LDU     #OBJPRT  PRINT IT
       JSR     PRINT
OBJNXT LEAX    3,X     NEXT OBJECT
       CMPX    OBJFIN  END OF OBJ
       BLO     OBJLP
       RTS
*********************:
* GET-GETS OBJECT
*********************:
GET    LDA     345     CHECK FOR G
       CMPA    #254    A "G"
       BNE     GETEND  NO GET OUT
       TST     X+4     MODE(MAN ONLY)
       BNE     GETEND  NOT CYCLE
       LDX     #COMP+3 SEE IF INV FULL
GETLP1 TST     ,X+     FIND A BLANK
       BEQ     GETOUT  YES!
       CMPX    #COMP+13   END?
       BEQ     GETEND  YES NOT FOUND
       BRA     GETLP1  LOOP IT!
GETOUT LEAX    -1,X    FIX FOR AUTO INC
       LDU     COMP+1  GET OBJ TAB LOC
       LEAU    30,U    +30 FOR END
       STU     OBJFIN  SAVE IT
       LEAU    -30,U   TO ORIGINAL
       LDD     SCLOC   GET SCROLL LOCATION
       SUBD    #37376  MAKE 1-1000
       LSRA            DIVIDE BY 2
       RORB            FOR 1-500
       STD     OBJTEM
GETLP  LDA     ,U      GET THE OBJECT
       BEQ     GETNXT  =0 THEN NO OBJECT
       LDD     1,U     GET LOCATION 1-500 OBJ
       SUBD    OBJTEM  TAKE OFF SCROLL LOC
       CMPD    #40     IN RANGE?
       BHI     GETNXT  NO
       CMPB    X       IS IT UNDER FOOT?
       BEQ     GOTIT   YES
       DECB            RIGHT SIDE
       CMPB    X
       BEQ     GOTIT   FOUND IT
       BRA     GETNXT
GOTIT  LDY     SCLOC   GET SCROLL LOCATION
       LSLB            B*2 FOR Y LOC
       LDA     B,Y     GET Y POS
       SUBA    #30     SET FOR CLOSE TO GROUND
       CMPA    X-1     COMPARE TO Y
       BHI     GETNXT  NOT CLOSE ENOUGH
       LDA     ,U      GET OBJ
       STA     ,X      SAVE OBJ IN TABLE
       CLR     ,U      CLEAR OUT OBJECT ON MAP
       JSR     PROBJ   PRINT OBJECTS
       BRA     GETEND  DONE!
GETNXT LEAU    3,U     +3 FOR NEXT
       CMPU    OBJFIN  DONE?
       BNE     GETLP   NO
GETEND RTS             DONE!?

******************************
* PROBJ-SHOWS OBJS
******************************
PCLR   FCB     11
       FCB     183
       FCC     /                    /
       FCB     0
PROBX  FCB     11      X AND Y LOC OF OBJECT
PROBY  FCB     183
PDATA  RMB     20
       FCB     0

PROBJ  LDU     #PCLR   PRINT BLANKS
       JSR     DISP
       LDX     #COMP+3  GET TABLE
       LDU     #PDATA  DATA START
POKEME LDA     ,X+     GET OBJECT
       TSTA
       BNE     PREG    OBJECT PRESENT
       LDA     #32     BLANK?
PREG   STA     ,U+
       LDA     #32
       STA     ,U+
       CMPU    #PDATA+20  DONE?
       BNE     POKEME     NO
       LDU     #PROBX  PRITN IT
POKEND JSR     DISP    WORK?
       RTS
**********************
* LOAD-LOADS AMMO
**********************
LTIME  FCB     20      TIME TO LOAD
PLOAD  FCB     13      LOADING MSG
       FCB     42
       FCC     /LOADING/
       FCB     0

LOAD   LDA     342     GET A "L"
       CMPA    #253    ?
       BNE     LEND    NO
       TST     X+4     TEST MODE
       BNE     LEND    NO LOAD CYC MODE

       LDX     #COMP+3  GET TABLE START
IUDR   LDA     ,X+     GET AN OBJECT
       CMPX    #COMP+14 DONE?
       BEQ     LEND
       CMPA    #113    AND AMMO?
       BNE     IUDR

       LDU     #PLOAD  SHOW YOUARE LOADING
       JSR     PRINT
       DEC     LTIME
       BNE     LEND    LOAD ONLY SO OFTEN
       LDA     #20
       STA     LTIME
       LDX     #COMP+3  GET TABLE START
LOADLP LDA     ,X+     GET AN OBJECT
       CMPX    #COMP+14 DONE?
       BEQ     LEND
       CMPA    #113    AND AMMO?
       BNE     LOADLP
       CLR     -1,X    VACATE AMMO
       LDD     #80     ADD 50 TO SHOTS
       STD     BCDOP2
       LDU     #AMMO
       JSR     BCDADD
       JSR     PROBJ
       JSR     SELWEP
LEND   RTS

**********************
* FUEL-UP
**********************
LTIME2 FCB     10      TIME TO LOAD
PLOAD2 FCB     13      LOADING MSG
       FCB     42
       FCC     /FUELING/
       FCB     0

LOAD2  LDA     344     GET A "F"
       CMPA    #254    ?
       BNE     LEND2   NO
       TST     X+4     TEST MODE
       BNE     LEND2   NO LOAD CYC MODE

       LDX     #COMP+3  GET TABLE START
ZUTI   LDA     ,X+     GET AN OBJECT
       CMPX    #COMP+14 DONE?
       BEQ     LEND2
       CMPA    #117    AND FUEL?
       BNE     ZUTI

       LDU     #PLOAD2 SHOW YOUARE LOADING
       JSR     PRINT

       LDD     #80     ADD 50 TO FUEL
       STD     BCDOP2
       LDU     #PROTO
       JSR     BCDADD

       DEC     LTIME2
       BNE     LEND2   LOAD ONLY SO OFTEN
       LDA     #10
       STA     LTIME2

       LDX     #COMP+3  GET TABLE START
LOADL2 LDA     ,X+     GET AN OBJECT
       CMPX    #COMP+14 DONE?
       BEQ     LEND2
       CMPA    #117    AND FUEL?
       BNE     LOADL2
       CLR     -1,X    CLEAR FUEL
       JSR 
