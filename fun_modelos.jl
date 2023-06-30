"""
    function nutri_phyto_det(par,ini,tfinal, h=1.0)

Dinamica de poblacion (fitoplankton) con nutrientes determinística

Las variables de estado son  
`N` = Nutrientes
`P` = Población (fitoplankton)

* dN = a - b N P - e N
* dP = c N P - d P 

## Argumentos

`a` = Tasa de ingreso de Nutrientes
`b` = Consumo de Nutrientes por la población P
`e` = Tasa de degradacion de Nutrientes
`c` = Tasa de asimilación c < b
`d` = Mortalidad de la poblacion

## Retorna

tupla = tiempo,N,P

"""
function nutri_phyto_det(par,ini,tfinal, h=1.0)  
    a , b , e, c, d  = par                       # desempaquetamos los parámetros
    N₀,P₀  = ini                                 # desempaquetamos los valores iniciales
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

"Equaciones del modelo Poblacion Nutrientes"
function np_ODE!(du,u,p,t)
    N, P = u
    a , b , e, c, d = p                       # desempaquetamos los parámetros

    du[1] = a - b*N*P - e*N
    du[2] = c*N*P - d*P
end

"Simulación de modelo Poblacion-Nutrientes determinístico"
function simulate_np(par,ini,tspan)
    prob = ODEProblem(np_ODE!,ini,tspan,par)
    sol = solve(prob)
    return sol
end

"""
    nutri_phyto_sto(par,ini,tfinal)

Simulacion estocastica de modelo Poblacion-Nutrientes

* dN = a - b N P - e N
* dP = c N P - d P 

"""
function nutri_phyto_sto(par,ini,tfinal)    
    a , b , e, c, d  = par                       # desempaquetamos los parámetros
    N1,P1  = ini                                 # desempaquetamos los valores iniciales
    N = Float64[N1]                              # Forzamos variable a Float64 (numero real)
    P = Float64[P1]
    ts  = [0.0]
    i = 1
    t = 0.0
    while t <= tfinal
        #@info "Tiempo $(t) indice $(i)"

        Bn = a
        Dn = b*N[i]*P[i] + e * N[i]
        Bp = c * N[i]*P[i]
        Dp = d* P[i]
        R = Bn + Dn + Bp + Dp 
        t = ts[i] - log(rand()) / R
        rnd = rand()
        if rnd < Bn/R                   # probabilidad de nacimiento 
            N1 = N[i] + 1
        elseif rnd < (Bn+Dn)/ R
            N1 = N[i] - 1
        elseif rnd <  (Bn+Dn+Bp)/ R
            P1 = P[i] + 1
        else
            P1 = P[i] - 1 
        end
        if P1<= 0.0
            P1 = 0.0 
        end
        if N1<= 0.0
            N1 = 0.0 
        end

        i += 1                  
        push!(N, N1)
        push!(P, P1)
        push!(ts,t)
    end
    return ts,N,P
end




"Distancia euclidiana entre datos y simulaciones"
function distance(data::Vector{Float64},simulation::Vector{Float64})
    return sqrt(sum((data.-simulation).^2.0))
end

"Computación Bayesiana Aproximada"
function ABC_nutri_phyto(data,deltaP,umbral)
    δa , δb , δe, δc, δd  = deltaP
    exitos = 0 
    intentos = 0
    params = zeros(Float64, 5, 100)

    while exitos < size(params, 2)
        intentos += 1

        t_a = rand(δa)
        t_b = rand(δb)
        t_e = rand(δe)
        t_c = rand(δc)
        t_d = rand(δd)
        if t_b > t_c
            
            Neq = t_d/t_c 
            Peq = t_a*t_c/(t_b*t_d) + t_e/t_b

            t, N, P = nutri_phyto_sto([t_a,t_b,t_e,t_c,t_d],[Neq,Peq],100)
            l_data = size(data,1)-1
            score = distance(data,P[end-l_data:end])
            if score < umbral
                exitos += 1
                params[:,exitos] .= [t_a,t_b,t_e,t_c,t_d ]
                @info "Tengo $(exitos) exitos, en $(intentos) intentos!!!!!"
            end
        end
    end
    return params
end
