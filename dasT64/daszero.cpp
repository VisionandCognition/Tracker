#include "mex.h"
#include "DasControl.h"


void mexFunction(
				 int nlhs, mxArray *plhs[],
				 int nrhs, const mxArray *prhs[])
{
       double *raw, *Out;
       Transform TF;
       
       //Output 
       plhs[0] = mxCreateDoubleMatrix(2, 1, mxREAL);
       raw = mxGetPr(plhs[0]);  
       
       plhs[1] = mxCreateDoubleMatrix(3, 3, mxREAL);       
        Out = mxGetPr(plhs[1]); 
       
       TF = SetZero( raw );
       
       for( unsigned short i=0; i < 3; i++)
           for( unsigned short j=0; j < 3; j++){
               Out[i*3 +j] = TF.Mtrans[i][j];
           }
       
}
    

