## 
# 
# 1) Crecimiento logístico deterministica
#
# 2) Crecimiento logistico estocástico + cosecha
# 3) Crecimiento logistico deterministico + cosecha
#
# Grafico de bifurcaciones
# Grafico de varianza antes de punto critico
#

using Plots
using Statistics


function logistico_det(par,N₀,tfinal, h=1.0)    # asume intervalo de tiempo = h
    λ , K = par                       # desempaquetamos los parámetros
    
    pop = Float64[N₀]                        # Forzamos variable a Float64 (numero real)
    ts  = [0.0]
    i = 1
    t = 0.0
    #@info "Pop[1] $(pop[i]) indice $(i)"

    while t <= tfinal
        pop1 = pop[i] + h * ( λ * pop[i] * (1 - pop[i]/K)) 
        #@info "Pop1 $(pop1) indice $(i)"
        t = ts[i] + h
        i += 1                   # equivale a i = i + 1 
        push!(pop, pop1)
        push!(ts,t)
    end
    return ts,pop
end

p2 = logistico_sto( [0.2, 100], 10, 1000 )
plot(p2)
p3 = logistico_det( [0.2, 100], 10, 1000, 0.01 )
plot!(p3)



# Crecimiento logistico con cosecha 
#
function logistico_cos_det(par,N₀,tfinal, h=1.0)    # asume intervalo de tiempo = h
    λ , K , μ  = par                       # desempaquetamos los parámetros
    
    pop = Float64[N₀]                        # Forzamos variable a Float64 (numero real)
    ts  = [0.0]
    i = 1
    t = 0.0
    #@info "Pop[1] $(pop[i]) indice $(i)"

    while t <= tfinal
        pop1 = pop[i] + h * ( λ * pop[i] * (1 - pop[i]/K) - μ) 
        #@info "Pop1 $(pop1) indice $(i)"
        t = ts[i] + h
        i += 1                   # equivale a i = i + 1 
        if pop1 < 0.0
            pop1 = 0.0
        end

        push!(pop, pop1)
        push!(ts,t)
    end
    return ts,pop
end


p2 = logistico_cos_det( [0.2, 100, 1.5], 10, 1000 )
plot(p2)

# Diagrama de bifurcación de logistico determinista
#
valor_eq = Float64[]
for μ in 0:0.1:10
    #@info μ
    p2 = logistico_cos_det( [0.2, 100, μ], 100, 1000, 0.01 )
    t,p = p2
    push!( valor_eq,p[end])
end

plot(0:0.1:10,valor_eq)


## 
# Crecimiento logistico estocástico con cosecha
#
#  dpop = λ pop (1 - pop / K  ) - μ = λ pop - ( pop * pop * λ / K  + μ) 
#
function logistico_cos_sto(par,N₀,tfinal)    
    λ , K , μ = par                       # desempaquetamos los parámetros
    
    pop = Float64[N₀]                 # Forzamos variable a Float64 (numero real)
 
    ts  = [0.0]                       # Vector de valores de tiempo
    i = 1                             # variable indice
    t = 0.0                           # variable auxiliar de tiempo
    while t <= tfinal
        #@info "Tiempo $(t) indice $(i)"

        B = pop[i]*λ
        M = pop[i]*pop[i]*λ/K + μ
        R = B + M 
        t = ts[i] - log(rand()) / R
        if rand() < B/R                   # probabilidad de nacimiento 
            pop1 = pop[i] + 1
        else
            pop1 = pop[i] - 1
        end
        if pop1<= 0.0
            pop1 = 0.0 
        end
        i += 1                  
        push!(pop, pop1)
        push!(ts,t)
    end
    return ts,pop
end

p2 = logistico_cos_sto( [0.2, 100, 5], 100, 1000 )
p3 = logistico_cos_det( [0.2, 100, 5], 100, 1000, 0.01 )
plot(p2)
plot!(p3)
t , p = p2

i
# Grafico de bifurcación estocástico
#
valor_eq = Float64[]
for μ in 0:0.1:10
    #@info μ
    p2 = logistico_cos_sto( [0.2, 100, μ], 100, 1000 )
    t,p = p2
    @info "Tamaño de p $(size(p) )"
    push!( valor_eq,mean(p[(end -100):end])
    )
end
plot(0:0.1:10,valor_eq)

# 
#
function donde_es_cero(p)
    for i in 1:length(p)
        if p[i] == 0
            #@info "Es igual a cero en $(i)"
            return i
        end
    end
    return length(p)
end

# Varianzas antes de punto critico
#
valor_eq = Float64[]
for μ in 0:0.1:10
    #@info μ
    p2 = logistico_cos_sto( [0.2, 100, μ], 100, 1000 )
    t,p = p2
    fin = donde_es_cero(p)
    @info "Tamaño de fin $(fin )"
    push!( valor_eq,var(p[(fin -100):fin]))
end
plot(0:0.1:10,valor_eq)


# N = Nutrientes
# P = Población (fitoplankton)
#
# dN = a - b N P - e N
# dP = c N P - d P 
#
# a = Tasa de ingreso de Nutrientes
# b = Consuma de Nutrientes por la poblacion P
# e = Tasa de degradacion de Nutrientes
#
# c = Tasa de asimilación c < b
# d = Mortalidad de la poblacion



