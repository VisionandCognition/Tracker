function updateTransform()
global Par
% 

T = Par.T;
T(1,1) = Par.SCx * Par.xdir;
T(2,2) = Par.SCy * Par.ydir;

Par.T = T;
dassettransform(Par.T)
