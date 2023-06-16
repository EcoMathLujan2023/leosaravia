

## 
# Crecimiento y muerte
#
#
# ahora tenemos dos eventos: Nacimiento y muerte  
#
# Podemos simularla de forma deterministica
#
# Introducimos el empaquetamiento de parametros 



##
#
#   par = tupla, tuplas son vectores invariantes
#
function nac_mue_det(par,N₀,tfinal,h=1.0)    # asume intervalo de tiempo = h
    
    λ , μ = par
    
    pop = Float64[N₀]                        # Forzamos variable a Float64 (numero real)
    ts  = [0.0]
    i = 1
    t = 0.0
    #@info "Pop[1] $(pop[i]) indice $(i)"

    while t <= tfinal
        pop1 = pop[i] + h * ( λ - μ) * pop[i] 
        #@info "Pop1 $(pop1) indice $(i)"
        t = ts[i] + h
        i += 1                   # equivale a i = i + 1 
        push!(pop, pop1)
        push!(ts,t)
    end
    return ts,pop
end


p1 = nac_mue_det( [0.3, 0.3], 100, 100 )
using Plots
plot(p1, legend=false)

# Simulación crecimiento muerte estocástica
#
"""
    nac_mue_det(par, fin_t, N₀,h)

Simula el proceso de nacimiento muerte 

## Argumentos
- `par::Tuple{Float64, Float64}`: Tupla de parámetros de crecimiento, tasa de crecimiento, tasa de mortalidad
- `fin_t::Float64`: tiempo de simulación
- `N₀::Float64`: población inicial.

## Retorno
- `tiempo::Vector{Float64}`: Vector de tiempo simulado.
- `poblacion::Vector{Float64}`: Vector de la población simulada en función del tiempo.
"""
function nac_mue_sto(par,N₀,tfinal)    
    λ , μ = par                       # desempaquetamos los parámetros
    
    pop = Float64[N₀]                 # Forzamos variable a Float64 (numero real)
 
    ts  = [0.0]                       # Vector de valores de tiempo
    i = 1                             # variable indice
    t = 0.0                           # variable auxiliar de tiempo
    while t <= tfinal
        #@info "Tiempo $(t) indice $(i)"

        B = pop[i]*λ
        M = pop[i]*μ
        R = B + M 
        t = ts[i] - log(rand()) / R
        if rand() < B/R                   # probabilidad de nacimiento 
            pop1 = pop[i] + 1
        else
            pop1 = pop[i] - 1
        end

        i += 1                  
        push!(pop, pop1)
        push!(ts,t)
    end
    return ts,pop
end


p1 = nac_mue_det( [0.2, 0.3], 100, 100, 0.01 )
plot(p1, legend=false)

p2 = nac_mue_sto( [0.2, 0.3], 100, 100 )
plot!(p2)


p1 = nac_mue_det( [0.2, 0.2], 100, 100, 0.01 )
plot(p1, legend=false)
p2 = nac_mue_sto( [0.2, 0.2], 100, 100 )
plot!(p2)


## 
# Crecimiento logistico 
#
#  dpop = λ pop (1 - pop / K  )  = λ pop -  pop * pop * λ / K 
#
function logistico_sto(par,N₀,tfinal)    
    λ , K = par                       # desempaquetamos los parámetros
    
    pop = Float64[N₀]                 # Forzamos variable a Float64 (numero real)
 
    ts  = [0.0]                       # Vector de valores de tiempo
    i = 1                             # variable indice
    t = 0.0                           # variable auxiliar de tiempo
    while t <= tfinal
        #@info "Tiempo $(t) indice $(i)"

        B = pop[i]*λ
        M = pop[i]*pop[i]*λ/K 
        R = B + M 
        t = ts[i] - log(rand()) / R
        if rand() < B/R                   # probabilidad de nacimiento 
            pop1 = pop[i] + 1
        else
            pop1 = pop[i] - 1
        end

        i += 1                  
        push!(pop, pop1)
        push!(ts,t)
    end
    return ts,pop
end

p2 = logistico_sto( [0.2, 100], 10, 1000 )
plot(p2)
p3 = logistico_sto( [0.4, 200], 10, 1000 )
plot!(p3)
p4 = logistico_sto( [1, 200], 10, 1000 )
plot!(p4)


## 
# Ejercicio
#
# 1) Crecimiento logístico deterministica
#
# 2) Crecimiento logistico estocástico + cosecha
#
