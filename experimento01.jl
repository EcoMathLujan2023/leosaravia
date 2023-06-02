#
# 1) Entrar al administrador de paquetes con `]` y Activar el proyecto de la carpeta actual `activate .`
# 2) Que paquetes vamos a usar 
#    `add Plots`
#

# Variables 

x = 10
typeof(x)     # que tipo de variable es x

x = 10.0 
typeof(x)
#

y = 10

x + y

# vectores y matrices 

x = [10, 10, 10, 10, 11]

x = zeros(10)

x = zeros(3,4)

x = [Float64]

mat = [ 10 11; 12 13 ]

x = ones(10)

# Multiplicar escalares x vectores 

x = 5 * x

# operaciones no definidas para vector se realizan utilizando . 

log(x)  # errror

log.(x)

# Condicionales


if length(x) == 1
    @info "El vector es de largo 1"
else
    @info "El vector es mayor que 1"
end



if length(x) == 1
    @info "El vector es de largo 1"
elseif length(x)==2
    @info "El vector es de largo 2"
elseif length(x)==10
    @info "El vector es de largo 10"
else
    @info "El vector es mayor que 2"
end

if typeof(x) == "Vector"
    @info  "El tipo es vector"
else
    @info  "El tipo de x es $(typeof(x))"
end

# Bucles - loops

for i in 1:10
    @info "i = $(i)"
end

# combinar bucles y condicionales 

for i in 1:10
    if i == 5
        @info "OHHHH i es igual a 5"
    else
        @info "i es igual a $(i)"
    end
end

# 

x = rand(10)
for i in 1:10 
    if x[i]<0.2
        @info "Evaluamos la probabilidad de 0.2"
    end
end

p = 0.2
for i in 1:10 
    if( rand() < p)
        @info "Verdadero"
    else
        @info "Falso"
    end
end

#
# funciones
# 

function evento_aleatorio(p)
    if rand() < p
        return true
    else
        return false
    end
end

eventos = Bool[]
length(eventos)

push!(eventos, false)
length(eventos)


eventos = Bool[]

for i in 1:100
    push!(eventos,evento_aleatorio(0.1))
end

count(eventos)

#
# Hacer una funcion caminante aleatorio que nos diga la nueva posicion del caminante con parametro p
#
