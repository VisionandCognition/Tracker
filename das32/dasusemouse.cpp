#include "mex.h"
#include "DasControl.h"


void mexFunction(
				 int nlhs, mxArray *plhs[],
				 int nrhs, const mxArray *prhs[])
{
      double On;
      long *Pos;
      double * Out;
      
          /* Check for proper number of arguments */
    if (nrhs != 1) {
        mexErrMsgTxt("One input argument required.");
        return;
    }
        On = mxGetScalar(prhs[0]); 
              
       plhs[0] = mxCreateDoubleMatrix(2, 1, mxREAL);
       Out = mxGetPr(plhs[0]);
    
       Pos = Use_Mouse( (unsigned short)On);
       Out[0] = (double)Pos[0];
       Out[1] = (double)Pos[1];
}
    

