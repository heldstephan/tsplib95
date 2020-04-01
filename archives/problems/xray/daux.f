  
C     A COLLECTION OF COMMON ROUTINES, MOSTLY FOR SETUP OF THE          DAU00010
C     TRAVELLING SALESMAN PROBLEM.                                      DAU00020
C     DOUBLE PRECISION VERSION                                          DAU00030
C                                                                       DAU00040
C  SETPTS:  COMPUTE COORDINATES OF VERTICES                             DAU00050
C                                                                       DAU00060
C  THIS ROUTINE TAKES AS ARGUMENTS THE PARAMETERS OF THE CRYSTAL        DAU00070
C  AND THE DESIRED RANGES OF MILLER INDICES AND COMPUTES THE COORDINATESDAU00080
C  OF THE DETECTOR CORRESPONDING TO THE DESIRED REFLECTIONS.            DAU00090
C                                                                       DAU00100
C  INPUT PARAMETERS:                                                    DAU00110
C     ORIENT  MATRIX OF VECTORS DEFINING RECIPROCAL LATTICE             DAU00120
C     LAMBDA  WAVELENGTH OF X-RAY BEAM IN INVERSE ANGSTROMS             DAU00130
C     HLO, HHI, KLO, KHI, LLO, LHI  RANGES OF MILLER INDICES H, K, L    DAU00140
C                                                                       DAU00150
C  OUTPUT:                                                              DAU00160
C     NO PARAMETERS ARE CHANGED.  IN COMMON /POINTS/, N IS SET TO THE   DAU00170
C     NUMBER OF POINTS TO WHICH IT IS POSSIBLE TO MOVE THE DETECTOR,    DAU00180
C     AND THE COORDINATES OF THOSE POINTS ARE PLACED IN PHI, CHI,       DAU00190
C     AND TWOTH.                                                        DAU00200
C                                                                       DAU00210
      SUBROUTINE SETPTS (ORIENT, LAMBDA, HLO, HHI, KLO, KHI, LLO, LHI)  DAU00220
C                                                                       DAU00230
      COMMON /MSTPRM/ MSGLVL                                            DAU00240
      COMMON /POINTS/ PHI, CHI, TWOTH, N                                DAU00250
      INTEGER N, MSGLVL                                                 DAU00260
      INTEGER INC ,INC2, KSTART,LSTART,KEND,LEND,MOD                    DAU00270
      DOUBLE PRECISION    PHI(20000), CHI(20000), TWOTH(20000)          DAU00280
C                                                                       DAU00290
      DOUBLE PRECISION ORIENT(3,3), LAMBDA                              DAU00300
      INTEGER HLO, HHI, KLO, KHI, LLO, LHI                              DAU00310
      INTEGER H, K, L, IMPOSS                                           DAU00320
      DOUBLE PRECISION P, C, T                                          DAU00330
      LOGICAL POSIBL                                                    DAU00340
      DOUBLE PRECISION DMIN1,DMAX1                                      DAU00350
      DOUBLE PRECISION MINP,MINC,MINT,MAXP,MAXC,MAXT                    DAU00360
      MINP =  360.0D+0                                                  DAU00370
      MINC =  180.0D+0                                                  DAU00380
      MINT =  155.0D+0                                                  DAU00390
      MAXP =    0.0D+0                                                  DAU00400
      MAXC = -180.0D+0                                                  DAU00410
      MAXT =  -55.0D+0                                                  DAU00420
C                                                                       DAU00430
      IF (MSGLVL .GE. 2) WRITE (*,*) 'ENTERING SETPTS'                  DAU00440
      N=0                                                               DAU00450
      IMPOSS = 0                                                        DAU00460
      DO 100 H = HLO, HHI                                               DAU00470
        IF (MOD(H-HLO,2).EQ.0) THEN                                     DAU00480
          INC = 1                                                       DAU00490
          KSTART = KLO                                                  DAU00500
          KEND = KHI                                                    DAU00510
          ELSE                                                          DAU00520
            INC = -1                                                    DAU00530
            KSTART = KHI                                                DAU00540
            KEND = KLO                                                  DAU00550
          ENDIF                                                         DAU00560
      DO 100 K = KSTART, KEND, INC                                      DAU00570
        IF (MOD((H + K - HLO -KLO),2).EQ.0) THEN                        DAU00580
          INC2 = 1                                                      DAU00590
          LSTART = LLO                                                  DAU00600
          LEND = LHI                                                    DAU00610
          ELSE                                                          DAU00620
            INC2 = -1                                                   DAU00630
            LSTART = LHI                                                DAU00640
            LEND =LLO                                                   DAU00650
          ENDIF                                                         DAU00660
      DO 100 L = LSTART, LEND, INC2                                     DAU00670
          CALL ANGLES (H, K, L, ORIENT, LAMBDA, 0.0D0, P, C, T, POSIBL) DAU00680
          IF (POSIBL) GOTO 90                                           DAU00690
              IMPOSS = IMPOSS + 1                                       DAU00700
              IF (MSGLVL .GE. 2) WRITE (*,*) 'POINT H, K, L =',         DAU00710
     $            H, K, L, ' IS NOT POSSIBLE'                           DAU00720
              GOTO 100                                                  DAU00730
90        CONTINUE                                                      DAU00740
              N = N+1                                                   DAU00750
              PHI(N) = P                                                DAU00760
              CHI(N) = C                                                DAU00770
              TWOTH(N) = T                                              DAU00780
              MINP = DMIN1(MINP,P)                                      DAU00790
              MINC = DMIN1(MINC,C)                                      DAU00800
              MINT = DMIN1(MINT,T)                                      DAU00810
              MAXP = DMAX1(MAXP,P)                                      DAU00820
              MAXC = DMAX1(MAXC,C)                                      DAU00830
              MAXT = DMAX1(MAXT,T)                                      DAU00840
c             IF (MSGLVL .GE. 3) WRITE (*,*) N, 'H,K,L=',               DAU00850
c    $            H, K, L, 'PHI,CHI,TWOTH=', P, C, T                    DAU00860
c********
	      WRITE (*,*) n, p, c, t
c********
100       CONTINUE                                                      DAU00870
      IF (MSGLVL .GE. 1)                                                DAU00880
     $    WRITE(*,*) IMPOSS, ' POINTS WERE NOT POSSIBLE.'               DAU00890
      IF (MSGLVL .GE. 1) WRITE (*,*) N, 'POINTS TO VISIT.'              DAU00900
      WRITE(*,*) 'PHI RANGE:   ',MINP,MAXP                              DAU00910
      WRITE(*,*) 'CHI RANGE:   ',MINC,MAXC                              DAU00920
      WRITE(*,*) 'TWOTH RANGE: ',MINT,MAXT                              DAU00930
      IF (MSGLVL .GE. 2) WRITE (*,*) 'LEAVING SETPTS'                   DAU00940
      RETURN                                                            DAU00950
      END                                                               DAU00960
C  TCOST:  RETURN THE TOTAL COST OF A TOUR                              DAU00970
C                                                                       DAU00980
C  INPUT:                                                               DAU00990
C      TOUR    TOUR(V) IS THE VERTEX FOLLOWING V IN THE TOUR.           DAU01000
C              THE POINTS ARE IN COMMON /POINTS/ AS DESCRIBED IN SETPTS.DAU01010
C                                                                       DAU01020
      DOUBLE PRECISION FUNCTION TCOST (TOUR)                            DAU01030
C                                                                       DAU01040
      COMMON /MSTPRM/ MSGLVL                                            DAU01050
      COMMON /POINTS/ PHI, CHI, TWOTH, N                                DAU01060
      INTEGER N, MSGLVL                                                 DAU01070
      DOUBLE PRECISION    PHI(20000), CHI(20000), TWOTH(20000)          DAU01080
C                                                                       DAU01090
      EXTERNAL COST                                                     DAU01100
      DOUBLE PRECISION COST                                             DAU01110
      INTEGER TOUR(N)                                                   DAU01120
      INTEGER V, W, I, HOURS, MINITS, SECNDS                            DAU01130
      DOUBLE PRECISION C                                                DAU01140
C                                                                       DAU01150
      IF (MSGLVL .GE. 2) WRITE (*,*) 'ENTERING TCOST'                   DAU01160
      V = 1                                                             DAU01170
      TCOST = 0.0D0                                                     DAU01180
      DO 100 I = 1, N                                                   DAU01190
          W = TOUR(V)                                                   DAU01200
          C = COST(V,W)                                                 DAU01210
          IF (MSGLVL .GE. 3)                                            DAU01220
     $        WRITE (*,*) 'EDGE:', V, W, 'COST:', C                     DAU01230
          TCOST = TCOST + C                                             DAU01240
          V = W                                                         DAU01250
          IF (V .EQ. 1  .AND.  I .NE. N) GOTO 800                       DAU01260
100       CONTINUE                                                      DAU01270
      IF (V .NE. 1) GOTO 800                                            DAU01280
      HOURS = TCOST / 3600                                              DAU01290
      MINITS = (TCOST-3600*HOURS) / 60                                  DAU01300
      SECNDS = TCOST - 3600*HOURS - 60*MINITS                           DAU01310
      IF (MSGLVL .GE. 1)                                                DAU01320
     $    WRITE (*,*) 'COST OF TOUR IS', TCOST, ' SEC.'                 DAU01330
      IF (MSGLVL .GE. 1)                                                DAU01340
     $    WRITE (*,*) HOURS, 'HR.', MINITS, 'MIN.', SECNDS, 'SEC.'      DAU01350
      IF (MSGLVL .GE. 2) WRITE (*,*) 'LEAVING TCOST'                    DAU01360
      RETURN                                                            DAU01370
C                                                                       DAU01380
800   IF (MSGLVL .GE. 1)                                                DAU01390
     $    WRITE (*,*) 'TCOST DETECTS ILLEGAL TOUR'                      DAU01400
      STOP                                                              DAU01410
      END                                                               DAU01420
C  ANGLES:  GIVEN MILLER INDICES OF A REFLECTION,                       DAU01430
C           COMPUTE POSITIONING INFORMATION FOR                         DAU01440
C           THE DETECTOR.                                               DAU01450
C                                                                       DAU01460
C  FROM MATT SMALL, APRIL 5, 1984.                                      DAU01470
C                                                                       DAU01480
C  INPUT PARAMETERS:                                                    DAU01490
C      IH, K, L    MILLER INDICES                                       DAU01500
C      ORIENT      3 BY 3 MATRIX OF VECTORS DEFINING THE RECIPROCAL     DAU01510
C                  LATTICE                                              DAU01520
C      LAMBDA      WAVELENGTH OF X-RAY BEAM (IN INVERSE ANGSTROMS)      DAU01530
C      OMEGA       'MUST BE KEPT AT 0.0' - FINN NIELSEN                 DAU01540
C                                                                       DAU01550
C  OUTPUT PARAMETERS:                                                   DAU01560
C      FI, KHI, TWOT  CALCULATED ANGLES PHI, CHI, AND TWO*THETA         DAU01570
C      POSIBL         FALSE IF IT IS IMPOSSIBLE TO MOVE                 DAU01580
C                     TO THE REFLECTION.                                DAU01590
C                                                                       DAU01600
C                                                                       DAU01610
      SUBROUTINE ANGLES (IH, K, L, ORIENT, LAMBDA, OMEGA,               DAU01620
     $                   FI, KHI, TWOT, POSIBL)                         DAU01630
      INTEGER IH, K, L                                                  DAU01640
      DOUBLE PRECISION    FI, KHI, TWOT, LAMBDA, OMEGA, ORIENT(3,3)     DAU01650
      LOGICAL POSIBL                                                    DAU01660
C                                                                       DAU01670
      DOUBLE PRECISION PI, RH, RK, RL, COSOMG, X, Y, Z, D, DUM          DAU01680
      DOUBLE PRECISION T1, T2, T3, SINKHI, Q, R, COSFI, SINFI           DAU01690
      DATA PI /3.14159265368979/                                        DAU01700
C                                                                       DAU01710
      POSIBL = .TRUE.                                                   DAU01720
      OMEGA = OMEGA/180.*PI                                             DAU01730
      RH = IH                                                           DAU01740
      RK = K                                                            DAU01750
      RL = L                                                            DAU01760
      COSOMG = DCOS (OMEGA)                                             DAU01770
      X = ORIENT(1,1)*RH + ORIENT(1,2)*RK + ORIENT(1,3)*RL              DAU01780
      Y = ORIENT(2,1)*RH + ORIENT(2,2)*RK + ORIENT(2,3)*RL              DAU01790
      Z = ORIENT(3,1)*RH + ORIENT(3,2)*RK + ORIENT(3,3)*RL              DAU01800
      D = DSQRT (X*X + Y*Y + Z*Z)                                       DAU01810
      DUM = LAMBDA*D/2.                                                 DAU01820
      IF (DUM .LT. .000001 .OR. DUM .GE. 1.0) GOTO 7                    DAU01830
      TWOT = DASIN(DUM)*2.                                              DAU01840
      T1 = X/D                                                          DAU01850
      T2 = Y/D                                                          DAU01860
      T3 = Z/D                                                          DAU01870
      IF (DABS(T3) .LT. DABS(COSOMG)) GOTO 2                            DAU01880
7         POSIBL = .FALSE.                                              DAU01890
          GOTO 998                                                      DAU01900
2     SINKHI = 0.0 - T3/COSOMG                                          DAU01910
      KHI = DASIN(SINKHI)                                               DAU01920
      Q = DSIN(OMEGA)                                                   DAU01930
      R = COSOMG * DCOS(KHI)                                            DAU01940
      COSFI = (Q*T1+R*T2)/(T1*T1+T2*T2)                                 DAU01950
      SINFI = (R*T1-Q*T2)/(T1*T1+T2*T2)                                 DAU01960
      IF (SINFI .GT. -.7) GOTO 4                                        DAU01970
          FI = 0.0 - DACOS (COSFI)                                      DAU01980
          GOTO 999                                                      DAU01990
4     IF (SINFI .LT. .7) GOTO 5                                         DAU02000
          FI = DACOS (COSFI)                                            DAU02010
          GOTO 999                                                      DAU02020
5     IF (COSFI .GT. 0) GOTO 6                                          DAU02030
          FI = PI - DASIN (SINFI)                                       DAU02040
          GOTO 999                                                      DAU02050
6     FI = DASIN(SINFI)                                                 DAU02060
C                                                                       DAU02070
999   FI = FI*180./PI                                                   DAU02080
      KHI = KHI*180./PI                                                 DAU02090
      TWOT = TWOT*180./PI                                               DAU02100
C                                                                       DAU02110
998   OMEGA = OMEGA*180./PI                                             DAU02120
      RETURN                                                            DAU02130
      END                                                               DAU02140
