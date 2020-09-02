#include <stdio.h>
#include<stdlib.h>
#include<time.h>
void main()
{
    int i,j,max_num=0;
    double *ptr;
    int n=2162688;
    srand (time(NULL));
    ptr = (double*) malloc(n * sizeof(double));
          for( i = 0; i<n; i++)
            {
                ptr[i]=rand();
                    if(max_num<ptr[i])
                        max_num=ptr[i];

            }


                   printf("The largest number is  %d \n", max_num) ;





}

