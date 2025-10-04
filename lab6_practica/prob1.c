
/*
“En C, las matrices son row-major; por eso, recorrer fila por fila aprovecha que varios elementos consecutivos llegan juntos
en una línea de caché. La localidad espacial hace que tras el primer acceso (posible miss), los siguientes de la misma fila
sean hits. En column-major, el stride grande rompe esa localidad y aumenta los fallos de caché. Por tanto, en C conviene programar 
los bucles con el índice de columna en el bucle interno.”
*/

#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main(int argc, char *argv[]) {
    if (argc < 2) {
        printf("Uso: %s N\n", argv[0]);
        return 1;
    }

    int N = atoi(argv[1]); // leer N desde la terminal
    int **A, **B, **C;
    
    // (1) Reservar memoria dinámica
    A = (int**) malloc(N * sizeof(int*));
    B = (int**) malloc(N * sizeof(int*));
    C = (int**) malloc(N * sizeof(int*));
    for (int i=0; i<N; i++) {
        A[i] = (int*) malloc(N * sizeof(int));
        B[i] = (int*) malloc(N * sizeof(int));
        C[i] = (int*) malloc(N * sizeof(int));
    }

    // (2) Llenar con números aleatorios
    srand(time(NULL));
    for (int i=0; i<N; i++) {
        for (int j=0; j<N; j++) {
            A[i][j] = rand() % 10;
            B[i][j] = rand() % 10;
        }
    }

    // (3a) Suma recorriendo en row-major (fila por fila)
    clock_t start = clock();
    for (int i=0; i<N; i++) {
        for (int j=0; j<N; j++) {
            C[i][j] = A[i][j] + B[i][j];
        }
    }
    clock_t end = clock();
    double t_row = (double)(end - start) / CLOCKS_PER_SEC;

    // (3b) Suma recorriendo en column-major (columna por columna)
    start = clock();
    for (int j=0; j<N; j++) {
        for (int i=0; i<N; i++) {
            C[i][j] = A[i][j] + B[i][j];
        }
    }
    end = clock();
    double t_col = (double)(end - start) / CLOCKS_PER_SEC;

    // (4) Imprimir tiempos
    printf("Tiempo row-major: %f s\n", t_row);
    printf("Tiempo column-major: %f s\n", t_col);

    return 0;
}
