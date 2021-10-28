function updateTransform()
global Par
% 
% Par.ROTx = sqrt(2)/30*Par.SCx;
% Par.ROTy = -sqrt(2)/60*Par.SCy;

T = Par.T;
T(1,1) = Par.SCx * Par.xdir;
T(2,2) = Par.SCy * Par.ydir;
% T(3,1) = Par.OFFx;
% T(3,2) = Par.OFFy;
% T(1,2) = Par.ROTx;
% T(2,1) = Par.ROTy;
Par.T = T;
dassettransform(Par.T)
