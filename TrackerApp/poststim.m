%poststim

global Par

if isfield(Par,'DasOn') && Par.DasOn == 1
 dasclose();
% cgshut
Screen('Closeall')
 
end

 Par.DasOn = 0;
 clear all
 close all
