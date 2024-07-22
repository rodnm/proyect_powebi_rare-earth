# Diccionario de variables utilizadas

1. country : nombre del país. Contiene valores de cadena.
2. year : año. Contiene valores de fecha en años.
3. trade value export : valor comercial de las exportaciones en dólares. Contiene valores enteros positivos.
4. trade value import : valor comercial de las importaciones en dólares. Contiene valores enteros positivos.
5. trade value delta : diferencia entre el valor de exportaciones menos importaciones. Contiene valores dobles.
6. delta_log : logaritmo de `trade value delta`. Se emplea condición lógica donde si el valor de `trade value delta` es negativo, se calcula su valor absoluto y al resultado se calcula el logaritmo con asignación de signo negativo. Si el valor es mayor a cero, se calcula el logaritmo. Caso contrario, si el valor es cero, se suma 1 y se calcula el logaritmo.

