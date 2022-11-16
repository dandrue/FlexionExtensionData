function [a,b]=RotMatCardanAng(R,DecompositionFormat)
% RotationMatrixToCardanicAngles : Decomposes a Rotation  matrix into Cardan or Eulerian angles.

% INPUT: R                     : the 3x3 rotation matrix
%        DecompositionFormat   : [ r(1) r(2) r(3) ] with r(x) =1,2,3 
%                                use: X=1 ; Y=2; Z=3
% PROCESS:                              
% ORIGINAL FUNCTION: RTOCARDA (Spacelib)
% Extracts the Cardan (or Euler) angles from a rotation matrix.
% The  parameters  i, j, k  specify   the   sequence   of  the rotation axes 
% (their value must be the constant (X,Y or Z). 
% j must be different from i and k, k could be equal to i.
% (c) G.Legnani, C. Moiola 1998; adapted from: G.Legnani and R.Adamini 1993
%
%
% OUTPUT:            The two solutions are stored in the  three-element vectors a and b.
% 		 

% AUTHOR(S) AND VERSION-HISTORY
% Ver 0.1 Creation (Legnani 1998)
% Ver 1.0 Adaptation for BodyMech (Jaap Harlaar, VUmc, april 2001)



X=1;Y=2;Z=3; 

i=DecompositionFormat(1);
j=DecompositionFormat(2);
k=DecompositionFormat(3);


if ( i<X | i>Z | j<X | j>Z | k<X | k>Z | i==j | j==k )
	error('Error in RTOCARDA: Illegal rotation axis ')
end

if (rem(j-i+3,3)==1)	sig=1;   % ciclic 
	else            sig=-1;  % anti ciclic
end

if (i~=k)  % Cardanic Convention
	
	a(1)= atan2(-sig*R(j,k),R(k,k));
	a(2)= asin(sig*R(i,k));
	a(3)= atan2(-sig*R(i,j),R(i,i));
	
	b(1)= atan2(sig*R(j,k),-R(k,k));
	b(2)= rem( pi-asin(sig*R(i,k)) + pi , 2*pi )-pi; 
	b(3)= atan2(sig*R(i,j),-R(i,i));


else % Euleriana Convention

	l=6-i-j;
	
	a(1)= atan2(R(j,i),-sig*R(l,i));
	a(2)= acos(R(i,i));
	a(3)= atan2(R(i,j),sig*R(i,l));

	b(1)= atan2(-R(j,i),sig*R(l,i));
	b(2)= -acos(R(i,i));
	b(3)= atan2(-R(i,j),-sig*R(i,l));

end

return
% === END ==================================
% ======= RotationMatrixToCardanicAngles ===