# sum_pow_lab.py
from time import perf_counter

# ---------- 1) función base: S(N) = 1^1 + 2^2 + ... + N^N ----------
def sum_pow(N: int) -> int:
    s = 0
    # Row-major mentalidad: acceso secuencial 1..N favorece reutilización en caché virtual
    for i in range(1, N + 1):
        s += i ** i
    return s

# ---------- 2) caché virtual para potencias i^i ----------
class PowerCache:
    def __init__(self):
        self.store = {}   # i -> i**i
        self.hits = 0
        self.misses = 0

    def get_pow(self, i: int) -> int:
        if i in self.store:
            self.hits += 1
            return self.store[i]
        self.misses += 1
        val = i ** i
        self.store[i] = val
        return val

def sum_pow_cached(N: int, cache: PowerCache) -> int:
    s = 0
    for i in range(1, N + 1):
        s += cache.get_pow(i)   # reutiliza i^i si ya fue calculado antes
    return s

# ---------- 3) utilidades de medición ----------
def time_call(fn, *args, repeats=1):
    best = float("inf")
    last_res = None
    for _ in range(repeats):
        t0 = perf_counter()
        last_res = fn(*args)
        t1 = perf_counter()
        best = min(best, t1 - t0)
    return best, last_res

def print_table(header, rows):
    widths = [max(len(str(x)) for x in col) for col in zip(header, *rows)]
    fmt = "  ".join("{:<" + str(w) + "}" for w in widths)
    print(fmt.format(*header))
    for r in rows:
        print(fmt.format(*r))
    print()

# ---------- 4) experimentos ----------
if __name__ == "__main__":
    # (a) correr para N = 5, 10, 100, 500, 1000 (sin caché) y ver tendencia del tiempo
    Ns_a = [5, 10, 100, 500, 1000]
    rows_a = []
    for N in Ns_a:
        t, val = time_call(sum_pow, N, repeats=1)  # 1 corrida basta
        rows_a.append([N, f"{t*1000:.3f} ms", val])
    print("A) Tiempo sin caché (sum_pow):")
    print_table(["N", "tiempo", "resultado"], rows_a)
    # Observa: el tiempo crece con N (explica por qué en el informe)

    # (b) caché virtual y secuencia con repetidos:
    Ns_b = [5, 10, 100, 500, 1000, 5, 10, 100, 500, 1000]
    cache = PowerCache()
    rows_b = []
    for N in Ns_b:
        t, val = time_call(sum_pow_cached, N, cache, repeats=1)
        rows_b.append([N, f"{t*1000:.3f} ms", val, cache.hits, cache.misses])
    print("B) Tiempo CON caché virtual (sum_pow_cached) y contadores:")
    print_table(["N", "tiempo", "resultado", "hits", "misses"], rows_b)

    # (c) Hit Ratio y Miss Ratio finales
    total_accesses = cache.hits + cache.misses
    hit_ratio  = cache.hits / total_accesses if total_accesses else 0.0
    miss_ratio = cache.misses / total_accesses if total_accesses else 0.0
    print(f"C) Hit Ratio = {hit_ratio:.3f}, Miss Ratio = {miss_ratio:.3f}  (accesos={total_accesses})\n")

    # (d) Relación con localidad temporal y espacial:
    # - Localidad temporal: en Ns_b hay valores repetidos -> se reutilizan potencias i^i ya calculadas (más hits).
    # - Localidad espacial (aquí de forma lógica): al calcular 1..N en orden, se “recorre” secuencialmente el dominio,
    #   lo que incrementa la probabilidad de que datos recién calculados se vuelvan a usar en N crecientes.
    # Para el informe: relaciona cómo cambian los tiempos con y sin caché y cómo sube el Hit Ratio cuando hay repetición.

    # BONUS (opcional): si quieres comparar explícitamente sin caché vs con caché en la MISMA secuencia Ns_b:
    rows_cmp = []
    cache2 = PowerCache()
    for N in Ns_b:
        t_no, _ = time_call(sum_pow, N, repeats=1)
        t_ca, _ = time_call(sum_pow_cached, N, cache2, repeats=1)
        rows_cmp.append([N, f"{t_no*1000:.3f} ms", f"{t_ca*1000:.3f} ms"])
    print("Comparación directa en la misma secuencia (opcional):")
    print_table(["N", "sin caché", "con caché"], rows_cmp)
