#include "mex.h"
#include "DasControl.h"


void mexFunction(
				 int nlhs, mxArray *plhs[],
				 int nrhs, const mxArray *prhs[])
{
    long *Pos;
    double *avg, *Out;
    
        plhs[0] = mxCreateDoubleMatrix(2, 1, mxREAL);
        Out = mxGetPr(plhs[0]);
        
    if( Usemouse){
       Pos = Get_Cursor_Pos();     
       Out[0] = (double)Pos[0];
       Out[1] = (double)Pos[1];
    }
    else  {
            avg = get_Eye( );
            Out[0] = avg[0];
            Out[1] = avg[1]; 
    }
           
}