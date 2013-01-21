A (PO)rtable (S)tochastic programming (T)est (S)et (POSTS)
              compiled by Derek F. Holmes, 3/12/95
                  dholmes@engin.umich.edu
-------------------------------------------------------------------------

The following is a small test set of stochastic programming recourse
problems designed to highlight different qualities of general linear
recourse problems.  The problems are generally extendable to an arbitrary
number of periods and scenarios.

The problems are given in standard SMPS format (Birge, at. al.).
(If deterministic equivalent MPS files are needed, please contact
the test set librarian at the address above.)

Solutions and problem sizes are given in the accompanying file Post_Results.
Suggested rules for solving the problems are in the file Post_Suggrules.

1. Costs and RHS stochastic, time dependent scenarios.

   The only problems not arbitrarily created from those with only RHS
   stochasticity are the sgpf problems submitted courtesy of Prof. Karl
   Frauendorfer.  The sgpf problems arise from a portfolio management
   application approximated with his discrete barycentric approximation
   system. (Frauendorfer, 1992).

   There is a set of small size problems and a set of large size problems
   publicly available.  Due to their excessive size, only the smaller set
   will be used.  The problems in the set and their filenames are given
   in the table below.

        Stages   Scenarios     Cor            Time        STOCH
      ---------------------------------------------------------------

          3          25      sgpf3y3.cor  sgpf3y3.tim  sgpf3y3.sce
          4         125      sgpf3y4.cor  sgpf3y4.tim  sgpf3y4.sce
          5         625      sgpf3y5.cor  sgpf3y5.tim  sgpf3y5.sce
          6        3125      sgpf3y6.cor  sgpf3y6.tim  sgpf3y6.sce


2. RHS random: Finding feasibility

   The most tightly constrained problem in the test set is SCFXM1, which
   is tightly coupled in at least the first few stages. (See note below)
   The problem first appeared in Ho and Loute.

   There are 2,3, and 4 stage versions of this problem, and 2 and 16 scenarios
   per stage STOCH versions.  The problems and their descriptions are given
   below

        Stages  Scens/stage    Cor      Time      STOCH
      ----------------------------------------------------

          2          6       fxm.cor  fxm2.tim  fxm2_6.sto
                    16                          fxm2_16.sto

          3          6       fxm.cor  fxm3.tim  fxm3_6.sto
                    16                          fxm3_16.sto

          4          6       fxm.cor  fxm4.tim  fxm4_6.sto
                    16                          fxm4_16.sto

    Note: The period partitions in the core file are different from those
          originally used in Gassman 1988.  The original fxm file from the
          netlib test set was partitioned so as to have roughly equal size
          blocks.

4. RHS random: A moderate number of optimal bases.

   A problem with a relatively few number of optimal second stage bases
   is the PLTEXP problem (Sims), which is the linear relaxation of a stochastic
   capacity expansion problem.  The problem is extendable to an arbitrary
   number of stages and an arbitrary number of scenarios.

   4.1 Thick tree version.

   This test set has either 6 or 16 scenarios per stage.  The associated
   file names are shown below

     Stages  Scens/stage    Cor             Time       STOCH
    ---------------------------------------------------------------

       2          6       pltexpA2.cor  pltexpA2.tim  pltexpA2_6.sto
                 16                                 pltexpA2_16.sto

       3          6       pltexpA3.cor  pltexpA3.tim  pltexpA3_6.sto
                 16                                 pltexpA3_16.sto

       4          6       pltexpA4.cor  pltexpA4.tim  pltexpA4_6.sto
                 16                                 pltexpA4_16.sto

       5          6       pltexpA5.cor  pltexpA5.tim  pltexpA5_6.sto
                 16                                 pltexpA5_16.sto

       6          6       pltexpA6.cor  pltexpA6.tim  pltexpA6_6.sto

   4.2 Thin tree version.

   This test set has 6 scenarios in the first stage, and
   two scenarios per stage thereafter.  These problems are provided
   as a contrast with those in (4.1), and may show results less
   dependent on subproblem solution.


     Stages  Scens in Stg 2   Cor             Time       STOCH
    ---------------------------------------------------------------

       3          6       pltexpA3.cor  pltexpA3.tim  pltexpB3_6.sto

       4          6       pltexpA4.cor  pltexpA4.tim  pltexpB4_6.sto

       5          6       pltexpA5.cor  pltexpA5.tim  pltexpB5_6.sto


5. RHS random: Huge number of optimal bases.

   Due to its size and the high dimension of its support, STORM (Mulvey and
   Ruszczy/'{n}ski, 1992) is a problem well known for its difficulty.  The
   problem as originally received was a very large two-stage only problem,
   with dim (Supp) = 118.  Prof.  H.I.  Gassmann modified the model
   by enforcing some dependence among the RHSs.    These instantiations
   form the basis of  this test set.  However, in the spirit of the
   original model, the smaller two-stage model has extended to include
   up to 1000 scenarios.

        Stages   Scenarios    Cor         Time           STOCH
      -------------------------------------------------------------

          2          8    stormG2.cor  stormG2.tim   stormG2_8.sto
                    27                               stormG2_27.sto
                   125                               stormG2_125.sto
                  1000                               stormG2_1000.sto

References (please excuse the varied styles)
-------------------------------------------------------------------------

J. R. Birge, M.A.H. Dempster, H. I. Gassman, E. A. Gunn, A. J. King,
   and S. W. Wallace, 1987. ``A Standard forinput format for
   multiperiod stochastic linear programs,'' {\it COAL newsletter},
   17, pp. 1-20.

K. Frauendorfer,
   Lecture Notes in Economics and Mathematical Systems No 392,
   {\it Stochastic Two-Stage Programming} (Springer-Verlag, Berlin, 1993).

H. I. Gassman, 1990. ``MSLiP: A computer code for the
   multistage stochastic linear programming problem.''
   {\it Mathematical Programming}, 47, pp. 407-423.

J.K. Ho and E. Loute, 1981.
   ``A Set of Linear Programming Test Problems,'' {\it Mathematical
   Programming 20} 245-250.

M. J. Sims, 1992.  ``Use of a stochastic capacity planning
   model to find the optimal level of flexibility for a manufacturing system,''
   Senior Design Project, Department of Industrial and Operations Engineering,
   University of Michigan, Ann Arbor, MI 48109.

J. M. Mulvey, and A. Ruszczy/'{n}ski, 1992.  ``A New Scenario Decomposition
   Method for Large Scale Stochastic Optimization,''
   Technical Report SOR-91-19, Dept. of Civil Engineering and Operations
   Research, Princeton Univ. Princeton, N.J. 08544                
