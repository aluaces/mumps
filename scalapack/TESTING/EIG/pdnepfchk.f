      SUBROUTINE PDNEPFCHK( N, A, IA, JA, DESCA, IASEED, Z, IZ, JZ,
     $                      DESCZ, ANORM, FRESID, WORK )
*
*  -- ScaLAPACK routine (version 1.7) --
*     University of Tennessee, Knoxville, Oak Ridge National Laboratory,
*     and University of California, Berkeley.
*     May 1, 1997
*
*     .. Scalar Arguments ..
      INTEGER            IA, IASEED, IZ, JA, JZ, N
      DOUBLE PRECISION   ANORM, FRESID
*     ..
*     .. Array Arguments ..
      INTEGER            DESCA( * ), DESCZ( * )
      DOUBLE PRECISION   A( * ), WORK( * ), Z( * )
*     ..
*
*  Purpose
*  =======
*
*  PDNEPFCHK computes the residual
*  || sub(Z)*sub( A )*sub(Z)**T - sub( Ao ) || / (||sub( Ao )||*eps*N),
*  where Ao will be regenerated by the parallel random matrix generator,
*  sub( A ) = A(IA:IA+M-1,JA:JA+N-1), sub( Z ) = Z(IZ:IZ+N-1,JZ:JZ+N-1)
*  and ||.|| stands for the infinity norm.
*
*  Notes
*  =====
*
*  Each global data object is described by an associated description
*  vector.  This vector stores the information required to establish
*  the mapping between an object element and its corresponding process
*  and memory location.
*
*  Let A be a generic term for any 2D block cyclicly distributed array.
*  Such a global array has an associated description vector DESCA.
*  In the following comments, the character _ should be read as
*  "of the global array".
*
*  NOTATION        STORED IN      EXPLANATION
*  --------------- -------------- --------------------------------------
*  DTYPE_A(global) DESCA( DTYPE_ )The descriptor type.  In this case,
*                                 DTYPE_A = 1.
*  CTXT_A (global) DESCA( CTXT_ ) The BLACS context handle, indicating
*                                 the BLACS process grid A is distribu-
*                                 ted over. The context itself is glo-
*                                 bal, but the handle (the integer
*                                 value) may vary.
*  M_A    (global) DESCA( M_ )    The number of rows in the global
*                                 array A.
*  N_A    (global) DESCA( N_ )    The number of columns in the global
*                                 array A.
*  MB_A   (global) DESCA( MB_ )   The blocking factor used to distribute
*                                 the rows of the array.
*  NB_A   (global) DESCA( NB_ )   The blocking factor used to distribute
*                                 the columns of the array.
*  RSRC_A (global) DESCA( RSRC_ ) The process row over which the first
*                                 row of the array A is distributed.
*  CSRC_A (global) DESCA( CSRC_ ) The process column over which the
*                                 first column of the array A is
*                                 distributed.
*  LLD_A  (local)  DESCA( LLD_ )  The leading dimension of the local
*                                 array.  LLD_A >= MAX(1,LOCr(M_A)).
*
*  Let K be the number of rows or columns of a distributed matrix,
*  and assume that its process grid has dimension p x q.
*  LOCr( K ) denotes the number of elements of K that a process
*  would receive if K were distributed over the p processes of its
*  process column.
*  Similarly, LOCc( K ) denotes the number of elements of K that a
*  process would receive if K were distributed over the q processes of
*  its process row.
*  The values of LOCr() and LOCc() may be determined via a call to the
*  ScaLAPACK tool function, NUMROC:
*          LOCr( M ) = NUMROC( M, MB_A, MYROW, RSRC_A, NPROW ),
*          LOCc( N ) = NUMROC( N, NB_A, MYCOL, CSRC_A, NPCOL ).
*  An upper bound for these quantities may be computed by:
*          LOCr( M ) <= ceil( ceil(M/MB_A)/NPROW )*MB_A
*          LOCc( N ) <= ceil( ceil(N/NB_A)/NPCOL )*NB_A
*
*  Arguments
*  =========
*
*  N       (global input) INTEGER
*          The order of sub( A ) and sub( Z ). N >= 0.
*
*  A       (local input/local output) DOUBLE PRECISION pointer into the
*          local memory to an array of dimension (LLD_A,LOCc(JA+N-1)).
*          On entry, this array contains the local pieces of the N-by-N
*          distributed matrix sub( A ) to be checked. On exit, this
*          array contains the local pieces of the difference
*          sub(Z)*sub( A )*sub(Z)**T - sub( Ao ).
*
*  IA      (global input) INTEGER
*          A's global row index, which points to the beginning of the
*          submatrix which is to be operated on.
*
*  JA      (global input) INTEGER
*          A's global column index, which points to the beginning of
*          the submatrix which is to be operated on.
*
*  DESCA   (global and local input) INTEGER array of dimension DLEN_.
*          The array descriptor for the distributed matrix A.
*
*  IASEED  (global input) INTEGER
*          The seed number to generate the original matrix Ao.
*
*  Z       (local input) DOUBLE PRECISION pointer into the local memory
*          to an array of dimension (LLD_Z,LOCc(JZ+N-1)). On entry, this
*          array contains the local pieces of the N-by-N distributed
*          matrix sub( Z ).
*
*  IZ      (global input) INTEGER
*          Z's global row index, which points to the beginning of the
*          submatrix which is to be operated on.
*
*  JZ      (global input) INTEGER
*          Z's global column index, which points to the beginning of
*          the submatrix which is to be operated on.
*
*  DESCZ   (global and local input) INTEGER array of dimension DLEN_.
*          The array descriptor for the distributed matrix Z.
*
*  ANORM   (global input) DOUBLE PRECISION
*          The Infinity norm of sub( A ).
*
*  FRESID  (global output) DOUBLE PRECISION
*          The maximum (worst) factorizational error.
*
*  WORK    (local workspace) DOUBLE PRECISION array, dimension (LWORK).
*          LWORK >= MAX( NpA0 * NB_A, MB_A * NqA0 ) where
*
*          IROFFA = MOD( IA-1, MB_A ),
*          ICOFFA = MOD( JA-1, NB_A ),
*          IAROW = INDXG2P( IA, MB_A, MYROW, RSRC_A, NPROW ),
*          IACOL = INDXG2P( JA, NB_A, MYCOL, CSRC_A, NPCOL ),
*          NpA0 = NUMROC( N+IROFFA, MB_A, MYROW, IAROW, NPROW ),
*          NqA0 = NUMROC( N+ICOFFA, NB_A, MYCOL, IACOL, NPCOL ),
*
*          WORK is used to store a block of rows and a block of columns
*          of sub( A ).
*          INDXG2P and NUMROC are ScaLAPACK tool functions; MYROW,
*          MYCOL, NPROW and NPCOL can be determined by calling the
*          subroutine BLACS_GRIDINFO.
*
*  =====================================================================
*
*     .. Parameters ..
      INTEGER            BLOCK_CYCLIC_2D, CSRC_, CTXT_, DLEN_, DTYPE_,
     $                   LLD_, MB_, M_, NB_, N_, RSRC_
      PARAMETER          ( BLOCK_CYCLIC_2D = 1, DLEN_ = 9, DTYPE_ = 1,
     $                     CTXT_ = 2, M_ = 3, N_ = 4, MB_ = 5, NB_ = 6,
     $                     RSRC_ = 7, CSRC_ = 8, LLD_ = 9 )
      DOUBLE PRECISION   ONE, ZERO
      PARAMETER          ( ONE = 1.0D+0, ZERO = 0.0D+0 )
*     ..
*     .. Local Scalars ..
      INTEGER            I, IACOL, IAROW, IB, ICTXT, IIA, IOFFA, IROFF,
     $                   IW, J, JB, JJA, JN, LDA, LDW, MYCOL, MYROW, NP,
     $                   NPCOL, NPROW
      DOUBLE PRECISION   EPS
*     ..
*     .. Local Arrays ..
      INTEGER            DESCW( DLEN_ )
*     ..
*     .. External Subroutines ..
      EXTERNAL           BLACS_GRIDINFO, DESCSET, DMATADD, INFOG2L,
     $                   PDGEMM, PDLACPY, PDLASET, PDMATGEN
*     ..
*     .. External Functions ..
      INTEGER            ICEIL, NUMROC
      DOUBLE PRECISION   PDLAMCH, PDLANGE
      EXTERNAL           ICEIL, NUMROC, PDLAMCH, PDLANGE
*     ..
*     .. Intrinsic Functions ..
      INTRINSIC          MAX, MIN, MOD
*     ..
*     .. Executable Statements ..
*
      ICTXT = DESCA( CTXT_ )
      CALL BLACS_GRIDINFO( ICTXT, NPROW, NPCOL, MYROW, MYCOL )
      EPS = PDLAMCH( ICTXT, 'eps' )
*
      CALL INFOG2L( IA, JA, DESCA, NPROW, NPCOL, MYROW, MYCOL, IIA, JJA,
     $              IAROW, IACOL )
      IROFF = MOD( IA-1, DESCA( MB_ ) )
      NP = NUMROC( N+IROFF, DESCA( MB_ ), MYROW, IAROW, NPROW )
      IF( MYROW.EQ.IAROW )
     $   NP = NP - IROFF
      LDW = MAX( 1, NP )
*
*     First compute H <- H * Z**T
*
      CALL DESCSET( DESCW, DESCA( MB_ ), N, DESCA( MB_ ), DESCA( NB_ ),
     $              IAROW, IACOL, ICTXT, DESCA( MB_ ) )
*
      DO 10 I = IA, IA + N - 1, DESCA( MB_ )
         IB = MIN( IA+N-I, DESCA( MB_ ) )
*
         CALL PDLACPY( 'All', IB, N, A, I, JA, DESCA, WORK, 1, 1,
     $                 DESCW )
         CALL PDGEMM( 'No transpose', 'Transpose', IB, N, N, ONE, WORK,
     $                1, 1, DESCW, Z, IZ, JZ, DESCZ, ZERO, A, I, JA,
     $                DESCA )
*
         DESCW( RSRC_ ) = MOD( DESCW( RSRC_ )+1, NPROW )
*
   10 CONTINUE
*
*     Then compute H <- Z * H = Z * H0 * Z**T
*
      CALL DESCSET( DESCW, N, DESCA( NB_ ), DESCA( MB_ ), DESCA( NB_ ),
     $              IAROW, IACOL, ICTXT, LDW )
*
      DO 20 J = JA, JA + N - 1, DESCA( NB_ )
         JB = MIN( JA+N-J, DESCA( NB_ ) )
*
         CALL PDLACPY( 'All', N, JB, A, IA, J, DESCA, WORK, 1, 1,
     $                 DESCW )
         CALL PDGEMM( 'No transpose', 'No transpose', N, JB, N, ONE, Z,
     $                IZ, JZ, DESCZ, WORK, 1, 1, DESCW, ZERO, A, IA, J,
     $                DESCA )
*
         DESCW( CSRC_ ) = MOD( DESCW( CSRC_ )+1, NPCOL )
*
   20 CONTINUE
*
*     Compute H - H0
*
      JN = MIN( ICEIL( JA, DESCA( NB_ ) )*DESCA( NB_ ), JA+N-1 )
      LDA = DESCA( LLD_ )
      IOFFA = IIA + ( JJA-1 )*LDA
      IW = 1
      JB = JN - JA + 1
      DESCW( CSRC_ ) = IACOL
*
*     Handle first block of columns separately
*
      IF( MYCOL.EQ.DESCW( CSRC_ ) ) THEN
         CALL PDMATGEN( ICTXT, 'N', 'N', DESCA( M_ ), DESCA( N_ ),
     $                  DESCA( MB_ ), DESCA( NB_ ), WORK, LDW,
     $                  DESCA( RSRC_ ), DESCA( CSRC_ ), IASEED, IIA-1,
     $                  NP, JJA-1, JB, MYROW, MYCOL, NPROW, NPCOL )
         CALL PDLASET( 'Lower', MAX( 0, N-2 ), JB, ZERO, ZERO, WORK,
     $                 MIN( IW+2, N ), 1, DESCW )
         CALL DMATADD( NP, JB, -ONE, WORK, LDW, ONE, A( IOFFA ), LDA )
         JJA = JJA + JB
         IOFFA = IOFFA + JB*LDA
      END IF
*
      IW = IW + DESCA( MB_ )
      DESCW( CSRC_ ) = MOD( DESCW( CSRC_ )+1, NPCOL )
*
      DO 30 J = JN + 1, JA + N - 1, DESCA( NB_ )
         JB = MIN( JA+N-J, DESCA( NB_ ) )
*
         IF( MYCOL.EQ.DESCW( CSRC_ ) ) THEN
            CALL PDMATGEN( ICTXT, 'N', 'N', DESCA( M_ ), DESCA( N_ ),
     $                     DESCA( MB_ ), DESCA( NB_ ), WORK, LDW,
     $                     DESCA( RSRC_ ), DESCA( CSRC_ ), IASEED,
     $                     IIA-1, NP, JJA-1, JB, MYROW, MYCOL, NPROW,
     $                     NPCOL )
            CALL PDLASET( 'Lower', MAX( 0, N-IW-1 ), JB, ZERO, ZERO,
     $                    WORK, MIN( N, IW+2 ), 1, DESCW )
            CALL DMATADD( NP, JB, -ONE, WORK, LDW, ONE, A( IOFFA ),
     $                    LDA )
            JJA = JJA + JB
            IOFFA = IOFFA + JB*LDA
         END IF
         IW = IW + DESCA( MB_ )
         DESCW( CSRC_ ) = MOD( DESCW( CSRC_ )+1, NPCOL )
   30 CONTINUE
*
*     Calculate factor residual
*
      FRESID = PDLANGE( 'I', N, N, A, IA, JA, DESCA, WORK ) /
     $         ( N*EPS*ANORM )
*
      RETURN
*
*     End PDNEPFCHK
*
      END