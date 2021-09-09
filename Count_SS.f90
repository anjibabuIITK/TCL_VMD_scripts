! Fortran program to count % of secondary structure from VMD timeline data
!
PROGRAM count
IMPLICIT NONE
!REAL*8::
INTEGER::j,k,steps,dummy
INTEGER::T,E,B,H,G,I,C
CHARACTER(len=1)::ss,X
CHARACTER(len=10)::dum
!
T=0;E=0;B=0;H=0;G=0;I=0;C=0
!
open(10,file='ss.dat',status='old')

CALL step_count(10,steps)
print*,"STEPS = ",steps

 DO j=1,steps
    read(10,*)dummy,X,dum,dummy,ss
   if(ss .eq. 'T')then
     T=T+1  
   elseif(ss .eq. 'E')then
     E=E+1  
   elseif(ss .eq. 'B')then
     B=B+1  
   elseif(ss .eq. 'H')then
     H=H+1  
   elseif(ss .eq. 'G')then
     G=G+1  
   elseif(ss .eq. 'I')then
     I=I+1  
   elseif(ss .eq. 'C')then
     C=C+1  
   endif  
 ENDDO
 
 write(*,*) "Secondary Structure Analysis"
 write(*,*) "----------------------------"
 write(*,*)
 write(*,100)(FLOAT(T)/FLOAT(steps))*100
 write(*,200)(FLOAT(E)/FLOAT(steps))*100
 write(*,300)(FLOAT(B)/FLOAT(steps))*100
 write(*,400)(FLOAT(H)/FLOAT(steps))*100
 write(*,500)(FLOAT(G)/FLOAT(steps))*100
 write(*,600)(FLOAT(I)/FLOAT(steps))*100
 write(*,700)(FLOAT(C)/FLOAT(steps))*100
 write(*,*)
 write(*,*) "----------------------------"

 100 FORMAT (1X,"Turn           ( T ) : ",1X,F10.2)
 200 FORMAT (1X,"Extended Sheet ( E ) : ",1X,F10.2)
 300 FORMAT (1X,"Isolated Bridge( B ) : ",1X,F10.2)
 400 FORMAT (1X,"Alpha Helix    ( H ) : ",1X,F10.2)
 500 FORMAT (1X,"3-10 Helix     ( G ) : ",1X,F10.2)
 600 FORMAT (1X,"Pi Helix       ( I ) : ",1X,F10.2)
 700 FORMAT (1X,"Coil           ( C ) : ",1X,F10.2)

! write(*,*)"Total STEPS:",T+E+B+H+G+I+C

close(10)
END PROGRAM count
!---------------------!
subroutine step_count(file_number,steps)
integer :: file_number, steps, ios,i
steps=0
do
 read(file_number,*,iostat=ios)
 if(ios.ne.0) exit
  steps=steps+1
end do
rewind(file_number)
end subroutine
!---------------------------------!
! Written By Anji Babu Kapakayala
!---------------------------------!
