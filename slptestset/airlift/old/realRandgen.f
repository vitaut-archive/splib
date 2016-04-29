c     This one attempts to make block indep vars, similar, I believe
c     to those of Midler and Wollmer.


c     This file generates the stoch file of the airlift problem given
c     by Midler, J.L. and Wollmer, R.D., Stochastic programming models
c     for scheduling airlift operations, Naval Research Logistics Quarterly,
c     16 (1969), 315--330.
c
c     I had to guess what they meant by mu_1 = 1000, sigma_1 = 50,
c     mu_2 = 1500, sigma_2 = 300.  The usual interpretation is that
c     mu and sigma are properties of the normal distribution from which
c     the lognormal distribution is derived.  However, this gives 
c     unreasonably high values (~10^500).  So, I assumed they meant for
c     the expected value of the lognormal distribution to be mu and 
c     the std. dev. of the lognormal dist. to be sigma.
c
c     For a lognormal distribution derived from an N(mu_n, sigma_n) 
c     distribution, the mean is e^{mu_n + sigma_n^2/2}, and the variance
c     is e^{2 mu_n + sigma_n^2}(e^{sigma_n^2} - 1).  So, using mu_n = 0.0
c     and sigma_n = 1.0, to get a lognormal with mean mu_1 and std. dev. 
c     sigma_1, if X1 ~ N(0,1),
c
c     LX1 = (((exp(X1) - exp(1/2))/(e^2 - 1))* sigma_1) + mu_1.


      implicit none

      double precision uniran
C     uniran is a function which returns a U(0,1) random number
      double precision Xbar, SV, Sum1, Sum2, n
	    double precision V1,V2, U1, U2, W, X1, X2, LX1, LX2
	    double precision mu,sigma, Lmu1, Lsigma1, Cmu, Csigma, prob
      double precision Lmu2,Lsigma2
	    integer m, count
C     n is the length of the simulation

      n=25.0
      prob = 1.0/n
      mu=0.0
      sigma=1.0
	    Lmu1 = 1000.0
      Lsigma1 = 50.0
      Lmu2 = 1500.0
      Lsigma2 = 300.0
      Cmu = EXP( mu + (sigma**2)/2)
      Csigma = SQRT( EXP( 2*mu + (sigma**2) ) * (EXP( sigma**2 ) 
     *     - 1.0) )

      open( unit=3, file='airl.sto', status = 'unknown')
      write (3,1000) 'STOCH   ','AIRL    '
      write (3,1000) 'BLOCKS  ','DISCRETE'
 1000 format(a8,6x,a8)


      
C   The outer loop allows for doing more than one run with different seeds

      Do 10 m=1, 1

         Sum1=0.0
         Sum2=0.0
         count=0

      DO WHILE (count.lt.n) 

         U1=uniran()
         U2=uniran()
         V1=2*U1-1
         V2=2*U2-1
         W=V1**2+V2**2
 
         If(W.le.1) then
            X1=mu+V1*sigma*SQRT(-2*LOG(W)/W)
            X2=mu+V2*sigma*SQRT(-2*LOG(W)/W)   
	          LX1 = ((X1 - Cmu)/Csigma)* Lsigma1 + Lmu1
            LX2 = ((X2 - Cmu)/Csigma)* Lsigma2 + Lmu2
            write (3,3000) 'BL','BLOCK',(10),'PERIOD2 ',prob
 3000       format(1x,a2,1x,a5,i2.2,3x,a8,3x,f6.3)
            write (3,2000) 'RIGHT   ','DEMAND1',LX1,'DEMAND2',LX2
c            write (3,2000) 'RIGHT   ','DEMAND',m,LX2,'PERIOD2',prob
c 2000       format(4x,a8,2x,a6,i1.1,3x,f12.6,2x,a8,2x,f6.3)
 2000       format(4x,a8,2x,a7,3x,f12.6,3x,a7,2x,f12.6)
c	          print *, 'X[',count+1,'] = ',X1,'logN[x] = ',LX1
c	          print *, 'X[',count+2,'] = ',X2,'logN[x] = ',LX2


C     The sums are tallied, due to an algebraic simplification of the Sample
C     Variance, SV can be computed with Xbar and the Sum of Squares 
            count=count+1
            Sum1=Sum1+LX1+LX2
            Sum2=Sum2+(LX1 - 1003.017)**2 +(LX2 - 1003.017)**2
         endif
      End Do

C     Xbar and SV are computed and displayed.
   
         Xbar=Sum1/n
c         SV=Sum2/(n-1)-(Xbar**2)*n/(n-1)
         SV = Sum2/(n-1)
c         Print *, 'Sample mean for run', m, 'is', Xbar
c         Print *, 'Sample Variance for run', m, 'is', SV
c         Print *, 'Sample sigma for run', m, 'is', SQRT(SV)
   10 Continue

      write (3,1000)'ENDATA  '



         end

C     This function was given in class

      DOUBLE PRECISION FUNCTION uniran()
      DOUBLE PRECISION seeds(24), twom24, carry, one
      PARAMETER ( one=1, twom24=ONE/16777216)
      Integer i, j
      Save i, j, carry, seeds
      data i, j, carry/24, 10, 0.0 /
      data seeds /
     & 0.8804418, 0.2694365, 0.0367681, 0.4068699, 0.4554052, 0.2880635,
     & 0.1463408, 0.2390333, 0.6407298, 0.1755283, 0.7132940, 0.4913043,
     & 0.2979918, 0.1396858, 0.3589528, 0.5254809, 0.9857749, 0.4612127,
     & 0.2196441, 0.7848351, 0.4096100, 0.9807353, 0.2689915, 0.5140357/
      uniran=seeds(i)-seeds(j)-carry
      If (uniran .lt. 0) then 
         uniran=uniran+1
         carry=twom24
      else 
         carry=0
      endif

      seeds(i)=uniran
      i =24 - MOD(25-i,24)
      j=24 - MOD(25-j,24)
      end
