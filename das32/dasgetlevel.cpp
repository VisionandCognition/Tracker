#include "mex.h"
#include "DasControl.h"


void mexFunction(
				 int nlhs, mxArray *plhs[],
				 int nrhs, const mxArray *prhs[])
{
    double *level, *Out;
    int i;
    
        plhs[0] = mxCreateDoubleMatrix(nChans-2, 1, mxREAL);
        Out = mxGetPr(plhs[0]);
        
       level = get_Level( );
       for(i = 0; i < nChans-2; i++){
            Out[i] = level[i];
       }
}
    

