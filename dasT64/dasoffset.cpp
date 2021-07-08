#include "mex.h"
#include "DasControl.h"


void mexFunction(
				 int nlhs, mxArray *plhs[],
				 int nrhs, const mxArray *prhs[])
{
   float X,  Y;
   Transform TF;

   plhs[0] = mxCreateDoubleMatrix(3, 3, mxREAL);
   double *Out = mxGetPr(plhs[0]);
   
    /* Check for proper number of arguments */
    if (nrhs != 2) {
        mexErrMsgTxt("Two input arguments required.");
        return;
    }
    
        X = (float)mxGetScalar(prhs[0]);
        Y = (float)mxGetScalar(prhs[1]);
    
       TF = ShiftOffset( X, Y);
       for(int i=0; i<3; i++)
           for(int j=0; j<3; j++){
                Out[i*3 +j]=TF.Mtrans[i][j];
           }
       
}
    

