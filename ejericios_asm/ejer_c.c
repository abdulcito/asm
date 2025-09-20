#include<stdio.h>
#include<math.h>
#include<time.h>

float leibniz( int n){
        
    float sum=1;

    for(int i=1;i<n+1;i++){

        float num=pow(-1,i);
        float deno=2*(i)+1;
        sum+=(num/deno);

    }

    float resultado=4*sum;

    return resultado;

}


int main(){

    int NUM_MUESTRAS=10;
    int n=100000;
    printf("Tiempos en segundos para n=%d: \n",n);
   
    for (int i=0;i<NUM_MUESTRAS;i++){

        clock_t inicio=clock();
        //printf("inicio: %ld\n",inicio);
        float resultado=leibniz(n);
        clock_t fin=clock();
        //printf("fin: %ld\n",fin);
        double tiempo=(double)(fin-inicio)/CLOCKS_PER_SEC;
        printf("%f\n",tiempo);
    }


    //float pi=M_PI;

    //printf("usando leibniz nos da: %f\n",resultado);
    //printf("El valor de pi es: %f\n",pi);

    return 0;
}
