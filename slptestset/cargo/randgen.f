c     This generates the file 4node.sto, the stochastic file for the 
c     cargo problem in John M. Mulvey and Andrez Ruszczynski, A new
c     scenario decomposition method for large-scale stochastic optimization,
c     Operations Research, 43(3):477--490, May-June 1995.  This problem
c     is Example 2 on pp. 486--487.  
c
c     Currently, 32,768 discrete realizations of a 12 dimensional random
c     vector are written to file by this program.  To change the number
c     of realizations, change the vector mxreal.  Each dimension is 
c     assumed to follow an independent uniform distribution, discretized
c     to mxreal(i) realizations.  You can also play with the mean, 
c     the spread of the uniform distribution (unirange, currently set at 
c     mean +/- 0.20*mean).
c
c     
c
c     Andy Felt, 12/30/99


      program randgen

      implicit none

c     mxsize is maximum size of the vector
      integer mxsize
      parameter (mxsize=12)

c     mxreal is maximum number of realizations PER dimension
      integer mxreal(mxsize)
c     AJF: used too much memory.  Changed first 4 to a 2.
c      data mxreal /2,4,2,2,4,2,2,2,2,2,2,4/
      data mxreal /2,2,2,2,2,2,2,2,2,2,2,2/

c     there will be \Pi_i mxreal(i)  discrete elements in the distribution

      character*8 colnames(mxsize),rownames(mxsize)
      data colnames /mxsize*'RIGHT'/
      data rownames /'CBAB','CBAC','CBAE','CBBA','CBBC',
     *   'CBBE','CBCA','CBCB','CBCE','CBEA','CBEB','CBEC'/


      double precision mean(mxsize)
      data mean /5.0, 8.0, 4.0, 4.5, 6.7, 4.2, 10.1, 
     *   8.3, 12.2, 3.2, 5.3, 7.2/


      double precision unirange(mxsize)
c     range of the uniform distribution as a percentage of the mean
      data unirange /mxsize*0.20/

      double precision currval
      double precision addtoval
      double precision prob,sumprob
      integer iterate,mxit
      integer i

      open( unit=3, file='4node_2_12.sto', status = 'unknown')
      write (3,1000) 'STOCH   ','4NODECAR'
      write (3,1000) 'INDEP   ','DISCRETE'
 1000 format(a8,6x,a8)

      mxit = 1
      do i=1,mxsize
c        this puts currval at the left endpoint of the first interval
         currval = mean(i)*(1.0 - unirange(i) )
         addtoval = (unirange(i) * 2.0) * mean(i) / mxreal(i)
c        this puts currval at the midpoint of the first interval
         currval = currval + 0.5 * addtoval
         mxit = mxit * mxreal(i)

         prob = 1.0/mxreal(i)
         sumprob = 0.0

         do iterate=1,mxreal(i)

            if( iterate .lt. mxreal(i) )then
               sumprob = sumprob + prob
            else
               prob = 1.0 - sumprob
            endif

c           print the line
               write(3,2000) colnames(i),rownames(i),currval,
     *              'PERIOD2 ',prob
               currval = currval + addtoval

         enddo
 2000    format(4x,a8,2x,a8,2x,g12.6,3x,a8,2x,g12.6)
         
      enddo
      
      write (3,1000)'ENDATA  '

      close(3)
      


      end

