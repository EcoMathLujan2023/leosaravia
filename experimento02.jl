##
# Uso de bucles while para 
# intervalo de tiempo variable
#
t=0.0
h=0.1
tfinal=100
while t<=tfinal
    t = t + h 
    @info t
end

##
# 
#  Ejercicio Crecimiento exponencial deterministico discreto 
#  con intervalo de tiempo h variable
#  Subirlo a el repositorio de Github
#
#  λ = 1/año * h  
using Plots

function crec_exp(λ,N₀,tfinal,h=1.0)    # asume intervalo de tiempo = h
    pop = [N₀]
    ts  = [0.0]
    i = 1
    t = 0.0
    while t <= tfinal
        #@info "Tiempo $(t) indice $(i)"
        pop1 = pop[i] + h * λ * pop[i]
        t = ts[i] + h
        i += 1                   # equivale a i = i + 1 
        push!(pop, pop1)
        push!(ts,t)
    end
    return ts,pop
end

c1 = crec_exp(0.1,1.0,100,0.1)
c2 = crec_exp(0.1,1.0,100,0.5)
c3 = crec_exp(0.1,1.0,100,1.0)
c4 = crec_exp(0.1,1.0,100,0.01)
c5 = crec_exp(0.1,1.0,100,0.001)

plot(c1)
plot!(c2)
plot!(c3)
plot!(c4)
plot!(c5)

# Ejercicio asumiendo que son bacteria que crecen en un medio, hacer un repique 
# 
#
function crec_exp(λ,N₀,tfinal,h=1.0, trepique=0.0)    # asume intervalo de tiempo = h
    pop = [N₀]
    ts  = [0.0]
    i = 1
    t = 0.0
    while t <= tfinal
        #@info "Tiempo $(t) indice $(i)"
        pop1 = pop[i] + h * λ * pop[i]
        t = ts[i] + h
        i += 1                   # equivale a i = i + 1 
        if t % trepique <= 0.01
            #@info "repique!"
            pop1 = 0.1 * pop1
        end
        push!(pop, pop1)
        push!(ts,t)
    end
    return ts,pop
end

c4 = crec_exp(0.1,1.0,1000,0.01,50.0)
plot(c4)

##
# Crecimiento exponencial estocástico, se calcula tiempo que transcurre hasta un evento
# Suposiciones en un tiempo h sucede 1 solo evento
# Tomamos como evento a la reproduccion de un individuo 
#
# la tasa per capita es λ la tasa total es Numero de individuos * λ

# Crear una funcion para calcular la distribución exponencial con tasa λ

n = 10000
de = zeros(n)
λ = .1
for i in 1:n
    de[i] = - log(rand())/λ
end

## Para graficar la densidad de la distribucion 

using StatsPlots






## 
#  Crecimiento estocástico con repique cada 50
#
#  Usamos la misma funcion agregando otro parametro
#



## 
# Crecimiento y muerte
#



## 
# Crecimiento logistico 
#


## 
# Crecimiento logistico + cosecha
#
