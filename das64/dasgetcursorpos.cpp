#include "mex.h"
#include "DasControl.h"


void mexFunction(
				 int nlhs, mxArray *plhs[],
				 int nrhs, const mxArray *prhs[])
{
    
      long *Pos;
      double * Out;
      
       plhs[0] = mxCreateDoubleMatrix(2, 1, mxREAL);
       Out = mxGetPr(plhs[0]);
    
       Pos = Get_Cursor_Pos();
       Out[0] = (double)Pos[0];
       Out[1] = (double)Pos[1];
}
    

