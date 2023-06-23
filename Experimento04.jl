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
# b = Consumo de Nutrientes por la población P
# e = Tasa de degradacion de Nutrientes
#
# c = Tasa de asimilación c < b
# d = Mortalidad de la poblacion


# Crecimiento Nutrientes-Poblacion con cosecha 
#
function nutri_phyto_det(par,ini,tfinal, h=1.0)  
    a , b , e, c, d  = par                       # desempaquetamos los parámetros
    P₀, N₀ = ini                                 # desempaquetamos los valores iniciales
    N = Float64[N₀]                              # Forzamos variable a Float64 (numero real)
    P = Float64[P₀]
    ts  = [0.0]
    i = 1
    t = 0.0
    #@info "N[1] $(N[i]) indice $(i)"

    while t <= tfinal
        N1 = N[i] + h * ( a - b * P[i] * N[i] - e *N[i] )
        P1 = P[i] + h * ( c * N[i] * P[i] - d * P[i]) 
        #@info "N1 $(N1) indice $(i)"
        t = ts[i] + h
        i += 1                   # equivale a i = i + 1 
        if N1 < 0.0
            N1 = 0.0
        end

        push!(N, N1)
        push!(P, P1)
        push!(ts,t)
    end
    return ts,N,P
end

a = 0.01     # g/m3/dia
b = 2
e = 0.001    # 1/m3/dia
c = 0.8      # mg/m3/dia 
d = 0.1 
tfinal = 1000

t, N, P = nutri_phyto_det([a,b,e,c,d],[1,1],tfinal, 0.01)  

plot(t,N, label="N")
plot!(t,P, label="P")


#
# Ejercicio
#
# 1) Igualar a cero las ecuaciones para sacar de 
# forma analitica los puntos de equilibrio
#
# 2) Hacer un grafico de bifurcaciones
#
# 3) Hacer la versión estocástica
#
