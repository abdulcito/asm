#include <stdio.h>
#include <stdlib.h>
#include <time.h>

// ---------- utilidades ----------
static inline double now_s(void){
    return (double)clock() / CLOCKS_PER_SEC;
}
int cmp_dbl(const void *a,const void *b){
    double x=*(const double*)a,y=*(const double*)b;
    return (x>y)-(x<y);
}
double median(double *v,int n){
    qsort(v,n,sizeof(double),cmp_dbl);
    return (n%2)? v[n/2] : 0.5*(v[n/2-1]+v[n/2]);
}
void fill_random(double *a,int N){
    for(int i=0;i<N*N;++i) a[i]=(double)rand()/RAND_MAX;
}

// ---------- transpuesta row-major ----------
void transpose_row(double *a, int N) {
    for (int i = 0; i < N; ++i) {
        for (int j = i+1; j < N; ++j) {
            size_t p = (size_t)i*N + j; // índice row-major
            size_t q = (size_t)j*N + i;
            double tmp = a[p];
            a[p] = a[q];
            a[q] = tmp;
        }
    }
}

// ---------- transpuesta column-major (simulada) ----------
void transpose_col(double *a, int N) {
    for (int i = 0; i < N; ++i) {
        for (int j = i+1; j < N; ++j) {
            size_t p = (size_t)j*N + i; // índice como si fuera column-major
            size_t q = (size_t)i*N + j;
            double tmp = a[p];
            a[p] = a[q];
            a[q] = tmp;
        }
    }
}

// ---------- main ----------
int main(void){
    const int N=500, REPS=10;
    double *A = (double*)malloc((size_t)N*N*sizeof(double));
    if(!A){perror("malloc"); return 1;}
    srand(12345);

    double t_row[REPS], t_col[REPS];

    // row-major
    for(int r=0;r<REPS;++r){
        fill_random(A,N);
        double t0=now_s(); 
        transpose_row(A,N); 
        double t1=now_s();
        t_row[r]=t1-t0;
    }

    // column-major
    for(int r=0;r<REPS;++r){
        fill_random(A,N);
        double t0=now_s(); 
        transpose_col(A,N); 
        double t1=now_s();
        t_col[r]=t1-t0;
    }

    double med_row=median(t_row,REPS);
    double med_col=median(t_col,REPS);

    printf("N=%d, reps=%d\n",N,REPS);
    printf("Mediana row-major   : %.6f s\n",med_row);
    printf("Mediana column-major: %.6f s\n",med_col);
    printf("Speedup (row/col)   : %.2fx\n", med_col/med_row);

    free(A);
    return 0;
}
