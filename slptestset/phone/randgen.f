

      program randgen

      implicit none

c     mxsize is maximum size of the vector
      integer mxsize
      parameter (mxsize=15)

c     mxreal is maximum number of realizations PER dimension
      integer mxreal(mxsize)


c     Ryan, look here:
c     the following line made each of the 15 random variables have
c     two realizations each
c      data mxreal /2,14*2/
c     This caused the joint distribution to have 2^15 = 32,768
c     realizations.  The following line will cause the joint
c     distribution to have 65536 realizations:
      data mxreal /4,14*2/
c     You can keep going, e.g.:
c      data mxreal /4,4,13*2/

c     there will be \Pi_i mxreal(i)  discrete elements in the distribution

      character*8 colnames(mxsize),rownames(mxsize)
      data colnames /mxsize*'RIGHT'/
      data rownames /'DEM12','DEM13','DEM14','DEM15','DEM16',
     *   'DEM23','DEM24','DEM25','DEM26','DEM34','DEM35','DEM36',
     *   'DEM45','DEM46','DEM56'/
    
      double precision mean(mxsize) 
      data mean /3.0,4.4,5.0,5.2,2.1,4.6,5.0,5.3,1.1,6.2,6.3,3.1,7.1,1.4
     *   ,2.1/ 
      double precision unirange(mxsize) 
c     range of the uniform distribution as a percentage of the mean 
      data unirange /mxsize*0.20/ 
      double precision currval
      double precision addtoval
      double precision prob,sumprob
      integer iterate,mxit
      integer i

c     Ryan, look here:
c     The file name should be changed each time:
      open( unit=3, file='phone.sto.65536', status = 'unknown')
      write (3,1000) 'STOCH   ','PHONE   '
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
     *           'PERIOD2 ',prob
            currval = currval + addtoval

         enddo
 2000    format(4x,a8,2x,a8,2x,g12.6,3x,a8,2x,g12.6)
         
      enddo
      
      write (3,1000)'ENDATA  '

      close(3)
      


      end

