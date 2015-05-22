  PUBLIC RON       TABLE ON MOVES
  PUBLIC INSET     START OF INVID TABLE
  PUBLIC INVID
  PUBLIC MISCLR    CLR MISSILES
  PUBLIC RLOC      ENEMY INFO
  PUBLIC CRUNCH    EXPLOS ROUT

PACK   EXT
X1     EXT
TURN   EXT
DRANK  EXT     DRIVING RANK
KABOOM EXT
SCLOC  EXT     SCROLL LOCATION 1ST Y?
OFFSET EXT
X      EXT
Y      EXT
PRINT  EXT
DISP   EXT
EXPLOD EXT
HITANY EXT
SMDIR  EXT

ZZ     EQU     30720
PICST  EQU     48128
LOOKUP FDB     RRRR    #0
       FDB     RR0     #1
       FDB     RR1     #2
       FDB     RR2     #3
       FDB     RR3     #4
       FDB     RR4     #5-12
       FDB     RR4     #6
       FDB     RR4     #7
       FDB     RR4     #8
       FDB     RR4     #9
       FDB     RR4     #10
       FDB     RR4     #11
       FDB     RR4     #12
       FDB     RR52    #13
       FDB     RR53    #14
       FDB     RR50    #15BOGUS
       FDB     RR50    #16
       FDB     RR54    #17
       FDB     RR55    #18
       FDB     RR56    #19
       FDB     RR57    #20
       FDB     RR58    #21
       FDB     RR59    #22
       FDB     RR60    #23
       FDB     RR61    #24
       FDB     RR62    #25
       FDB     RR63    #26
       FDB     RR64    #27
       FDB     RR65    #28
       FDB     RR66    #29
       FDB     RR67    #30
***********************
* ROBO INVID ROUTINE
*--UPDATES ALL SHIPS AND
*--PRINTS THEM DOING ALL
*--ACTIONS HERE
***********************
INSET  PSHS    B,X     2 REGS USED
       LDX     #38376  POSIBLE START OF TABLE
       STX     RTABLE  SAVE IN IN POINTER
       LDB     #3      DO FOR 7 ROBOTS
       LDX     #RLOC   FIND ROBOT TABLE
RCLR   LDA     #190    OFF NUMBER
       STA     ,X      CLEAR X BYTE(INACTIVE)
       STA     4,X
       LEAX    5,X     5 BYTES PER BEAST
       DECB            DO ONE LESS
       BNE     RCLR    DO 7 TIMES
       LDB     #1      1=ON 0=OFF TABLE
       STB     RON     SAVE IN VAR
       PULS    X,B     GET BYTES
       RTS             RETURN DONE

*** VARS ***
* RX-1 RY-1 RDRAW-2 R POINTS-1=5
*********************************
RLOC   RMB     15      3SHIPS*5BYTES
RTABLE FDB     38376   START OF COMMANDS
RON    FCB     1       INSRTUCT 1=ON 0=OFF
ITER   FCB     1       # OF CMDS PER LOOP
ITCNT  FCB     0       TEMP STORAGE
PIC    FDB     11268+ZZ ROBOT LOOKUP TABLE
       FDB     11272+ZZ
       FDB     11276+ZZ
       FDB     11280+ZZ
       FDB     11284+ZZ
       FDB     11288+ZZ
       FDB     11292+ZZ
       FDB     11296+ZZ
FAKE   RMB     5
SDIRX  FCB     1
SDIRY  FCB     0
IMAGE  FDB     41992
***********************
* ROBO MODE ROUTINE
***********************
INVID  JSR     MVS     MOVE SHOTS
       JSR     CRUNCH  ANIMATE EXPLOSION
       LDA     ITER    GET ITERATION CNT
       STA     ITCNT   SAVE IT
       LDY     RTABLE  GET INSTRUCT POINTER
INOVER LDX     #RLOC   GET SHIP AREA
       LDB     ,Y+     GET FIRST COMMAND
       CMPB    #2      OUT OF RANGE?
       BHI     BOGIT   FAKE SHIP
       LDA     #5      *5 BYTES
       MUL
       ABX             B SIGNIF.+X FOR SHIP OFF
       LDB     ,Y
       CMPB    #15     IF INIT SKIP THIS JUNK
       BEQ     UNHUH
       LDU     2,X     GET PIC
       CMPU    #46592
       BLO     UNHUH   O.K.
       CMPU    #46592+32
       BHI     UNHUH   O.K.
BOGIT  LDX     #FAKE   SET UP FAKE SHIP

UNHUH  LDB     ,Y+     GET COMMAND


       CMPB    #15     ACTIVATE?
       BNE     RR99    NO
       LDD     ,Y++    GET X AND Y POS FROM COMM
       STD     ,X      SAVE IN TABLE
       LDD     ,Y++    GET PIC LOC
       STD     2,X     SAVE IN PIX AREA
       LDA     ,Y+     GET HIT POINTS
       STA     4,X     SAVE IN HP LOC
       JMP     RDONE   DONE
RR99   LDA     4,X     GET HP
       CMPA    #190    OFF?
       BNE     RR111   NO WAY GO
       LDX     #FAKE
RR111  LDU     #LOOKUP GET TABLE
       CMPB    #30
       BHI     RRRR
       LSLB            *2
       JMP     [B,U]   GO TO THAT ONE

RRRR   JMP     RDONE

RR0    DEC     1,X     SUBTRACT 2 FROM RY
       DEC     1,X
       JMP     RDONE   THIS COMMAND DONE
RR1    INC     1,X     MAKE RY +2
       INC     1,X
       INC     1,X
       JMP     RDONE   DONE
RR2    DEC     ,X      RX=RX-1
       JMP     RDONE
RR3    INC     ,X      RX=RX+1
       JMP     RDONE
RR4    LDU     ,Y++    GET THE PICTURE
       STU     2,X     SAVE THE PIX UPDATE
       JMP     RDONE   DONE
RR50   LDA     ,Y+     GET DIRECTION
       STA     SDIRX
       LDA     ,Y+     GET Y DIR
       STA     SDIRY
       JMP     RDONE
RR52   TFR     X,U     TRANSFER INFO
       JSR     FIRE    SHOOT GUN
       JMP     RDONE
RR53   LDA     ,Y+     FIRST PARAM USELESS
       STA     ITER    SAVE IT
       JMP     RDONE
RR54   LDA     ,X      GET ROBOTS X LOC
       CMPA    X       TOO FAR RT?
       BGE     RMLT    MOVE IT LEFT IF TRUE
       INC     ,X      ROBOT RIGHT
       JMP     RDONE   DONE
RMLT   DEC     ,X      X=X-1
RAM1   JMP     RDONE   DONE
RR55   LDA     1,X     GET Y
       CMPA    Y       TOO BIG?
       BGE     HMLT    MAKE GO UP
       INC     1,X     GO DOWN
       INC     1,X
       INC     1,X
       JMP     RDONE
HMLT   DEC     1,X     MAKE GO UP
       DEC     1,X
       JMP     RDONE
RR56   LDA     1,X     GET Y
       CMPA    Y       TOO BIG?
       BGE     HMLT2   MAKE GO UP
       INC     1,X     GO DOWN
       INC     1,X
       INC     1,X
       BRA     RR54
HMLT2  DEC     1,X     MAKE GO UP
       DEC     1,X
       BRA     RR54
RR57   DEC     ,X      LEFT
       DEC     1,X     UP LEFT
       DEC     1,X
       JMP     RDONE
RR58   INC     ,X      RIGHT
       DEC     1,X     UP
       DEC     1,X
       JMP     RDONE
RR59   INC     ,X      RIGHT
       INC     1,X     DN
       INC     1,X
       JMP     RDONE
RR60   DEC     ,X      LEFT
       INC     1,X     DN
       INC     1,X
       JMP     RDONE
RR61   LEAY    3,Y     UP COUNTER
       DEC     -3,Y    DEC CNT
       LBEQ    RDONE
       LDU     -2,Y    GET LOC
       TFR     U,Y
       JMP     RDONE
LOOKL  LDU     #11284+ZZ  GET LT
       STU     2,X     SAVE IT
       JMP     RDONE
RR62   LDU     #46592  SELF DEST
       STU     2,X     SAVE IN PIC
       JMP     RDONE
RR63   LDA     5,X     GET HP
       CMPA    #10     MIN PTS
       BHI     RDONE   NO PROB
       DEC     ,X      GO LEFT
       DEC     ,X
       JMP     RDONE   FIN
RR64   TST     PACK+1
       BEQ     LALA2   NO RADIO
       LDX     #PICST  SHO COMIX
       LDB     ,Y+     GET PIX NUM
       LDA     #8      *8
       MUL
       ABX             ADDIT
NOSFT  LDU     #57344  GET SCREEN ST
       LDA     #48     TIME
       STA     PIXCNT  SAVE
PICLP  LDD     ,X++
       STD     ,U++    MOVE IT
       LDD     ,X++
       STD     ,U++
       LDD     ,X++
       STD     ,U++
       LDD     ,X
       STD     ,U
       LEAX    26,X
       LEAU    26,U    NEXT LINE
       DEC     PIXCNT  1 LESS
       BNE     PICLP
       JMP     RDONE
PIXCNT RMB     1       GRAPH CNT

LALA2  LEAY    1,Y
       LBRA    RDONE

RR65   TST     PACK+1
       BEQ     LALA
       TFR     Y,U     GET PARAM
       JSR     DISP
LALA   LEAY    24,Y    UPDATE
       BRA     RDONE
RR66   TFR     X,U     PASS PARAM
       JSR     IMISS   FIRE MISSILE
       JMP     RDONE
RR67   LDU     ,Y++
       STU     SDIRX

RDONE  DEC     ITCNT   1 LESS TO DO
       LBEQ    INOVER  GO UNTIL 0!
       LBPL    INOVER  OR POSITIVE
       STY     RTABLE  SAVE MODIFIED COMMAND LOC
       CMPY    #40370  DONE WITH TABLE?
       BLO     RDLOC   NO CHECK LOCS OF SHIPS
       CLR     RON     TURN OFF TABLE
       JMP     RFIN    NO MORE CHEKS

RDLOC  LDB     #3      3 SHIPS
       LDX     #RLOC   START OF SHIPS
RDLP   LDA     ,X      GET X LOCATION
********CHECK BUMP SHIP********
       PSHS    A
       LDA     4,X
       CMPA    #190
       PULS    A       GET IT BACK?
       BEQ     NOTT
       ADDA    #2      INTERFIR?
       CMPA    X
       BLE     NOTT    NO IN X WAY
       LDA     X       GET OTHER
       ADDA    #2      OTHER SIDE
       CMPA    ,X      CPM TO SHIP X
       BLE     NOTT
       LDA     1,X     GET Y
       ADDA    #46     BOT OF INVID
       CMPA    Y
       BLE     NOTT
       LDA     Y
       ADDA    #22     FOR SHIP
       CMPA    1,X
       BLE     NOTT    IF.F.THEN HIT
* A BUMP

       INC     Y
       INC     Y
       TST     TURN
       BEQ     BLEFT   BOUNCE LEFT
       DEC     X
       LDA     #12     SET BIT
       STA     X1
       BRA     CONT5
BLEFT  INC     X
       CLR     X1      SET FOR MOVE
CONT5  LDA     X+3     GET HP
       SUBA    #1      -1 HP
       ADDA    DRANK   ADD IN DRIVING RANK
       STA     X+3     SAVE IT
       BPL     NOTT    NO DEAD
       JSR     DEAD    JUMP TO DEAD ROUTINE

NOTT   LDA     4,X     GET X LOC
       CMPA    #190    WHERE IT IS
       BEQ     SKIPIT  190? THEN SKIP THIS
CH2    LDA     1,X     GET Y POS
       CMPA    #4
       BHI     NOFIX
       LDA     #4
       STA     1,X
NOFIX  LDU     SCLOC   GET SCROLL POS
       LDA     ,X      GET X POS
       ASLA            SHIFT LEFT
       LDA     A,U     FIND LOC U+A
       SUBA    #45     + HEIGHT
       CMPA    1,X     COMPARE TO Y POS
       BHI     CH4     ITS OK LAND WISE
       STA     1,X     SAVE IN Y

CH4    TFR     X,U     INTO U FOR PRINT
       JSR     PUT32   PRINT THE CHAR
SKIPIT LEAX    5,X     DO NEXT ONE
       DECB            ONE LESS
       LBNE    RDLP    KEEP GOING TILL =0
RFIN   RTS             DONE???
*******************************
*   48*32 GRAPHIX PUT
*   X=1ST PARAM(1DRAW,1X1,1Y,1X)
*******************************
PUT32  PSHS    A,B,X,Y         PUSH REGS
       LDD     2,U             GET DRAW LOC
       PSHS    A,B             SAVE FOR (X)
       LDB     #32             FIND Y
       LDA     1,U             GET Y
       MUL                     COMPUTE Y POS
       STD     PMX             SAVE IT TEMP
       CLRA                    CLEAR HI
       LDB     ,U              GET X POS
       CMPB    #252            OFF SCREEN?
       BLO     NODIFF          NO
       SUBD    #256            -OFFSET
NODIFF ADDD    PMX             X+REST OF SCREEN
       ADDD    OFFSET          WHERE SCREEN IS
       STD     PMX             SAVE PUT LOC
       PULS    X               GET (X) PICTURE
       LDA     ,U              GET X FOR OVERLAP
       LDU     PMX             Y HAS (P)UT LOC

       LDB     #48             48TIMES (INVID)
       STB     COUNT           SAVE IT
PTLP   CMPA    #31             OFF RT SIDE?
       BHI     OVER1           YESS TOO BIG
       LDB     ,X             GET 1 BYTES
       ORB     ,U
       STB     ,U              PUT ON SCREEN
OVER1  LEAX    1,X             NEXT GRAPIX POINTER
       LEAU    1,U
       INCA                    DO NEXT X LOC.
       CMPA    #31             OFF RT SIDE?
       BHI     OVER2           YES DONT PRINT IT
       LDB     ,X              GET 1 MORE
       ORB     ,U
       STB     ,U
OVER2  LEAX    1,X
       LEAU    1,U
       INCA                    3RD X LOC
       CMPA    #31
       BHI     OVER3
       LDB     ,X
       ORB     ,U
       STB     ,U
OVER3  LEAX    1,X
       LEAU    1,U
       INCA
       CMPA    #31
       BHI     OVER4
       LDB     ,X
       ORB     ,U
       STB     ,U
OVER4  LEAX    29,X            NEXT LINE
       LEAU    29,U            OF STACKS
       SUBA    #3              ORIGINAL X POS
       DEC     COUNT           DECRT CNTR
       BNE     PTLP            KEEP GOING
*******************************DONE
       PULS    Y,X,B,A
       RTS
PMX    RMB     2               TEMP STORAGE
COUNT  RMB     1               COUNTER FOR GRAPIX

************************
* SHOT ROUTINE FOR ENEMY
* PASS PARAMS IN U!
************************
IMISS  PSHS    A,B,X,Y
       LDB     #99     SHOT PIX
       BRA     BOOG
FIRE   PSHS    A,B,X,Y PUSH REGS
       LDB     #100
BOOG   LDA     SHOTS   HOW MANY SHOTS?
       CMPA    #9      NINE IS ENOUGH
       LBEQ    RET     TOO MANY
       CMPU    #FAKE   FAKE SHIP?
       BEQ     RET
       INC     SHOTS   1 MORE SHOT
       LDX     #SLOC   FIND A SPACE
SFIND  LDA     ,X++    GET X POS & +2
       CMPA    #190
       BNE     SFIND   NO FIND IT
       STB     34,X    SAVE IN TABLE
       STB     35,X
       LDA     ,U      GET ROBOTS POS
       INCA            OVER 1
       STA     -2,X    SAVE IT IN SHOT
       LDA     1,U     GET Y POS
       ADDA    #4      CENTER THE SHOT
       STA     -1,X     SAVE IN X+1
       LDA     SDIRX   GET DIRECTION
       STA     16,X    SAVE IN TABLE
       LDA     SDIRY   MAKE SHOT GO DOWN
       STA     17,X    SET Y DIRECTION
RET    PULS    Y,X,B,A PULL THOSE REGS
       RTS             RETURN TO MAIN!
*
SHOTS  FCB     0       (10) SHOTS ON BOARD
SLOC   RMB     18      6*X/Y ALT
SSPD   RMB     18      6*X/Y ALT
STPC   RMB     18      TYPE
*********************
*MVS --MOVE SHOT..
*********************
MVS    LDX     #SLOC   GETTHE X LOCATION
MO1    CMPX    #SSPD    DONE WITH ALL SHOTS?
       LBEQ    MOX     YES, GET OUT!
       LDA     ,X++    GET X
       CMPA    #190
       BEQ     MO1     GET NEXT
       STA     SHX     SAV TO PRINT
       LDA     -1,X    GET OLD Y (++)
       STA     SHY     SAVE FOR Y PRINT
       LDU     #SHX     GET START OF PARAM
       JSR     PRINT   PRINT IT
*PAST LAND
       LDU     SCLOC   GET LAND
       LDA     SHX     GET X COORD IN A
       ASLA            *2 SHIFT
       LDB     A,U     GET Y OF LAND
       CMPB    SHY     IS IT GRATER
       BHI     GUI     YES GO ON
       LDA     #190
       STA     -2,X    CLEAR THAT ONE
       DEC     SHOTS   1 LESS
       BRA     MO1     TO START
GUI    LDA     34,X    GET SHOT PIC
       STA     SHX+2   SAVE IT
       CMPA    #99
       BNE     NODISP  NOT GUIDED
       LDA     -1,X    GET Y
       SUBA    #5      ADJUST FOR HIEGHT
       CMPA    Y       WHERE
       BLT     GODN
       DEC     17,X    ADJ VEL
       DEC     -1,X
       DEC     -1,X
       BRA     NODISP
GODN   INC     17,X
       INC     -1,X
       INC     -1,X

*A HIT?
NODISP LDA     X       GET SHIP LOC
       CMPA    SHX     IN RANGE?
       BHI     BAWAY   SHIP TOO GREAT
       ADDA    #4      OTHER SIDE
       CMPA    SHX     IN RANGE ON OTHER SIDE?
       BLO     BAWAY   NOPE
       LDA     SHY     GET Y OF SHOT
       ADDA    #2      +6 FOR CENTER
       STA     SHY     SAVE
       LDA     Y       GET SHIP Y
       CMPA    SHY     ST RANGE?
       BHI     BAWAY
       ADDA    #19
       CMPA    SHY
       BLO     BAWAY   IF NOT THEN A HIT
       LDA     16,X    GET DIRECTION
       INCA            SET FOR SMOKE
       STA     SMDIR   SET THE DIRECTION
       LDU     #SHX    GET SMOKE PARAMS
       JSR     EXPLOD  MAKE SMOKE
       LDA     #190
       STA     -2,X    CLEAR SHOT
       DEC     SHOTS
       DEC     X+3     GETTING WEAKER
       LDA     34,X    GET SHOT
       CMPA    #99     KIND?
       BEQ     BOREG
       LDA     X+3
       SUBA    #4
       STA     X+3
BOREG  TST     X+3
       LBPL    MO1     DEAD?
       JSR     DEAD
       JMP     MO1     BACK TO START

BAWAY  LDA     -2,X    GET OLD X
       ADDA    16,X    ADD IN VELOC
       STA     -2,X    SAVE IT AGAIN
       CMPA    #31     X BOUND
       BHI     ERASE2  = THE ERASE IT
YBND   LDA     -1,X    GET Y POS
       ADDA    17,X    ADD IN Y VEL
       STA     -1,X    SAVE Y AGAIN
       CMPA    #110    Y BOUND
       BHI     ERASE2  CLEAR IT
       JMP     MO1     BACK TO START
ERASE2 LDA     #190
       STA     -2,X    CLR X POS
       DEC     SHOTS   1 LESS SHOT
       JMP     MO1     BACK TO START
MOX    RTS             RETURN
*
SHX    RMB     1       X FOR PRINT
SHY    RMB     2       Y FOR PRINT
       FCB     0       DONE
DEAD1  FCB     3
       FCB     60
       FCC     /*-YOU HAVE BEEN DESTROYED-*/
       FCB     0

******************
* CLEAR ALL SHOTS
******************
MISCLR CLR     SHOTS   0 SHOTS
       LDX     #SLOC   GET X LOC
SHLP   CMPX    #SSPD   DONE?
       BEQ     SHOUT   DONE
CL1    LDA     #190
       STA     ,X++    CLEAR THIS
       BRA     SHLP    DO ALL SHOTS
SHOUT  RTS             DONE!

*******************
*DEAD
*******************
DEAD   PSHS    A
       LDU     #DEAD1  YES
       JSR     DISP
       JSR     HITANY
       JSR     HITANY
       LDA     #100
       STA     X+3
       PULS    A
       RTS
