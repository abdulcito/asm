import socket
import time
import sys
import math

SOCK_BUFFER = 409600


def promedio_ventas(lista: str):

    suma=0
    lista_new=lista.split("\n")
    for i in range(len(lista_new)):
        fila=lista_new[i].split(",")
        suma+=float(fila[9])
    return suma/len(lista_new) 

def mejor_canal(lista : str):
    suma=0
    lista_new=lista.split("\n")
    mejor=0
    for i in range(len(lista_new)):
        fila=lista_new[i].split(",")
        prueba=float(fila[9])
        if prueba>mejor:
            mejor=prueba
            canal=fila[2]
            total=fila[8]

    return mejor, canal, total

def desviacion(lista : str):

    lista_new=lista.split("\n")
    media=promedio_ventas(lista)
    n=len(lista_new)
    suma=0
    for i in range(n):
        fila=lista_new[i].split(",")
        resta=float(fila[9])-media
        r=resta*resta
        suma+= r
    desviacion= math.sqrt(suma/n)

    return desviacion 
def vent_superior(lista : str):

    promedio= promedio_ventas(lista)
    lista_new=lista.split("\n")
    clientes=list()
    
    for i in range(len(lista_new)):
        fila=lista_new[i].split(",")
        prueba=float(fila[9])
        if prueba>promedio:
            client=fila[1]
            clientes.append(client)

    return clientes

def distribucion(lista : str):

    media= promedio_ventas(lista)
    lista_new=lista.split("\n")
    ventas=list()
    n=len(lista_new)
    
    for i in range(n):
        fila=lista_new[i].split(",")
        venta=float(fila[9])
        ventas.append(venta)
    ventas.sort()
    min=ventas[0]
    max=ventas[n-1]
    n_med=int((n-1)/2)
    mediana=ventas[n_med]

    return media,min,max,mediana


if __name__ == "__main__":

    if len(sys.argv)<2 :
        print("Se necesita un argumento\n")
        exit(1)

    #------------------------------------------.
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server_address = ("10.101.53.100", 5400)

    print(f"Conectando al servidor en {server_address[0]}:{server_address[1]}")
#_----------------------------------------------------------
    inicio_io = time.perf_counter()
    sock.connect(server_address) ##

    producto = sys.argv[1]
    sock.sendall(producto.encode("utf-8"))
    data = sock.recv(SOCK_BUFFER)

    data_str = data.decode("utf-8")

    print(f"Recibido: {data_str}")

    sock.close() ##
    fin_io = time.perf_counter()

    inicio_proceso = time.perf_counter()
    ###########################

    ##########################

    promedio_vent = promedio_ventas(data_str)
    numero_ventas,canal_venta,total_ventas=mejor_canal(data_str)
    desv=desviacion(data_str)
    clientes=vent_superior(data_str)
    num_cl=len(clientes)
    media,min,max,mediana=distribucion(data_str)

    fin_proceso = time.perf_counter()
    print(f"El promedio final de las ventas del producto {producto}, es {promedio_vent:.2f}")
    print(f"El mejor canal de venta fue {canal_venta} con {numero_ventas} ventas y con un total de {total_ventas} soles.")
    print(f"La desviación estandar es {desv}")
    print(f"Los clientes con ventas superiores al promedio son: {num_cl} y son: {clientes}.")
    print(f"Distribución de ventas: media {media:.2f}, mediana {mediana:.2f}, mínimo {min:.2f}, máximo {max:.2f}.")
    #print(f"{data_str}")
    print(f"El tiempo de I/O: {(fin_io - inicio_io):.6f} segundos")
    print(f"El tiempo de procesamiento: {(fin_proceso - inicio_proceso):.6f} segundos")