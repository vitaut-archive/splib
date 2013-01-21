

      program randgen

      implicit none

c     mxsize is the number of independently random variables
      integer mxsize
      parameter (mxsize=3)

c     mxreal is maximum number of realizations PER variable
      integer mxreal(mxsize)
      data mxreal /60,25,25/

c     rsize is the size of each random variable
      integer rsize(mxsize)
      data rsize /13,5,4/

c     largest value of rsize
      integer mxrsize
      parameter (mxrsize=13)

c     there will be \Pi_i mxreal(i)  discrete elements in the distribution

      character*8 colnames(mxrsize,mxsize),rownames(mxrsize,mxsize)
      data colnames /'CH1CH2','SV1SV2','CD1CD2','CSH1CSH2','LN1LN2',
     *  'CH2CASH',
     *  'CASHCH2','SV2CASH','CASHSV2','CD2CASH','CASHCD2','LN2CASH',
     *  'CASHLN2',
     *  'CH2FWD','SA2FWD','CD2FWD','CA2FWD','LN2FWD',8*' ',4*'RIGHT',
     *  9*' '/

      data rownames /'CHECK2','SAV2','CD2',
     *  'CASH2','LOANS2','CASH2','CHECK2','CASH2','SAV2',
     *  'CASH2','CD2','CASH2','LOANS2',
     *  5*'OBJ',8*' ',
     *  'CHECK2','SAV2','CD2','LOANS2',9*' '/
    
c      double precision mean(mxrsize,mxsize) 
c      data mean /-1.04,-1.09,-1.12,-1.01,-1.08,-0.78,-0.93,
c     *  -0.95,-0.97,-0.60,-0.96,-0.82,-0.85,
c     *  -1.03, -1.06, -1.08, -1.00, -1.06, 8*99.9,
c     *  4*0.0,9*9.9/
c      double precision unirange(mxrsize,mxsize) 
c     range of the uniform distribution as a percentage of the mean 
c      data unirange /mxrsize*0.20,mxrsize*0.20,mxrsize*0.20/ 

      double precision low(mxrsize,mxsize),high(mxrsize,mxsize)
      data low /-1.08, -1.14, -1.10, -1.04, -1.11, -0.80, -0.95,
     *   -0.97, -0.99, -0.70, -0.98, -0.86, -0.90,
     *   -1.07, -1.11, -1.12, -1.03, -1.09, 8*99.9,
     *   -20.0, -40.0, -30.0, -16.0, 9*99.9/

      data high /-1.03, -1.05, -1.02, -0.98, -1.05, -0.70, -0.88,
     *    -0.90, -0.92, -0.60, -0.92, -0.77, -0.83,
     *    -1.02, -1.04, -1.05, -0.98, -1.02, 8*99.9,
     *    20.0, 40.0, 15.0, 16.0, 9*99.9/

      character*8 blocknms(mxsize)
      data blocknms /'BLOCK1  ','BLOCK2  ','BLOCK3  '/
      

      double precision currval(mxrsize)
      double precision addtoval(mxrsize)
      double precision prob,sumprob
      integer iterate
      integer i,j

      open( unit=3, file='ass2by5.sto', status = 'unknown')
      write (3,1000) 'STOCH   ','ASS2BY5 '
      write (3,1000) 'BLOCKS  ','DISCRETE'
 1000 format(a8,6x,a8)

      do i=1,mxsize
         do j=1,rsize(i)
c           this puts currval at the left endpoint of the first interval
            currval(j) = low(j,i)
            addtoval(j) = (high(j,i) - low(j,i)) / mxreal(i)
c           this puts currval at the midpoint of the first interval
            currval(j) = currval(j) + 0.5 * addtoval(j)
         enddo

         prob = 1.0/mxreal(i)
         sumprob = 0.0

         do iterate=1,mxreal(i)
           
            if( iterate .lt. mxreal(i) )then
               sumprob = sumprob + prob
            else
               prob = 1.0 - sumprob
            endif

c           print the block header line
            write(3,3000) 'BL',blocknms(i),'PERIOD2 ',prob
 3000       format(1x,a2,1x,a8,2x,a8,2x,g12.6,3x,a8,2x,g12.6)

            do j=1,rsize(i)

c              print the line
               write(3,2000) colnames(j,i),rownames(j,i),currval(j)
               currval(j) = currval(j) + addtoval(j)
            enddo

         enddo
 2000    format(4x,a8,2x,a8,2x,g12.6,3x,a8,2x,g12.6)
         
      enddo
      
      write (3,1000)'ENDATA  '

      close(3)
      


      end

