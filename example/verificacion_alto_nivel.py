# Semilla con que comienza, no puede ser 0
semilla = "1000"

# Lee el archivo y su referencia
f       = open("./testbenches/output.txt",encoding = 'utf-8')

# Actualiza el valor
registro = semilla

for x in range(0,14):
    # Aplica el corrimiento y la operación de XOR con Strings
    if(registro[0] == registro[1]):
        registro = registro[1:4] + "0"
    else:
        registro = registro[1:4] + "1"

    # Lee 5 caracteres, incluyendo \n
    lectura = f.read(5)

    # Si algún valor es diferente se rompe el ciclo
    if(registro[0:4] != lectura[0:4]):
        break

if(x == 13):
    print("El componente cumple la especificación");
else:
    print("El componente no cumple la especificación");
