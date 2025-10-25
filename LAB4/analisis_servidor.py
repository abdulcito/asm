import socket

SOCK_BUFFER = 409600

def busca_fila(producto: str):

    try:
        with open("orders_data_large.csv", "r") as f:
            contenido = f.read()
    except FileNotFoundError:
        print("Archivo no existe")
        return ""
    tabla = contenido.split("\n")
    #########################

    lista= list()

    for idx in range(1, len(tabla)):
        fila = tabla[idx]
        if producto in fila:
            lista.append(fila)

    lista_str="\n".join(map(str, lista))
    
    return lista_str    



if __name__ == "__main__":
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server_address = ("0.0.0.0", 5400)

    print(f"Iniciando el servidor en {server_address[0]}:{server_address[1]}")

    sock.bind(server_address)

    sock.listen(1)

    while True:
        print("Esperando conexiones...")

        conn, addr = sock.accept()

        print(f"Conexión establecida desde {addr[0]}:{addr[1]}")

        try:
            while True:
                data = conn.recv(SOCK_BUFFER)
                if data:
                    print(f"Recibido: {data.decode('utf-8')}")
                    #_----------------------------
                    cod = data.decode("utf-8")
                    if cod=="salir":
                        conn.close()
                    fila_lista = busca_fila(cod)
                    conn.sendall(fila_lista.encode("utf-8"))
                else:
                    print("No hay mas datos.")
                    break
        except ConnectionResetError:
            print("El cliente cerró la conexión abruptamente.")
        finally:
            print("Cerrando la conexión.")
            conn.close()