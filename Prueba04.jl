"""

    nutri_phyto_sto(par,ini,tfinal)

Simulación del modelo de fitoplancton y nutrientes de forma estocastica por el método de Gillespie 
equivalente al modelo de ecuaciones diferenciales:

```math
dN/dt = a - b N P - e N
dP/dt = c N P - d P
```

 ## Argumentos
- `par`: (a,b,c,d,e) 
- `ini`: (N₀, P₀ )
- `tfinal`: tiempo final de la simulación

## Retorna

- `ts,P,N`: tupla con el tiempo, P, y N 


"""
function nutri_phyto_sto(par,ini,tfinal)    
    a , b , e, c, d = par                       # desempaquetamos los parámetros
    N₀ , P₀ = ini                         # desempaquetamos condiciones iniciales

    P = Float64[P₀]                 # Forzamos variable a Float64 (numero real)
    N = Float64[N₀]
    ts  = [0.0]                       # Vector de valores de tiempo
    i = 1                             # variable indice
    t = 0.0                           # variable auxiliar de tiempo
    N1 = 0.0
    P1 = 0.0
    while t <= tfinal
        #@info "Tiempo $(t) indice $(i)"

        Bn = a
        Dn = b * N[i] * P[i] + e * N[i]
        Bp = c * N[i] * P[i]
        Dp = d * P[i]
        R = Bp + Dp + Bn + Dn 
        t = ts[i] - log(rand()) / R
        rnd = rand() * R
        if rnd < Bn                   # probabilidad de nacimiento 
            P1 = P[i] + 1
        elseif rnd < Bn+Dn 
            P1 = P[i] - 1
        elseif rnd < Bn+Dn+Bp
            N1 = N[i] + 1
        else
            N1 = N[i] - 1
        end
        if P1<= 0.0
            P1 = 0.0 
        end
        if N1<=0.0
            N1=0.0
        end
        i += 1                  
        push!(P, P1)
        push!(N, N1)
        push!(ts,t)
    end
    return ts,N,P
end


function nutri_phyto_sto(par,ini,tfinal)    
    a , b , e, c, d = par                       # desempaquetamos los parámetros
    N , P = ini                         # desempaquetamos condiciones iniciales
    Pn = Nn = 0.0                       # Proximo valor
 
    Ps = Float64[P]                 # Serie temporal Forzada a Float64 (numero real)
    Ns = Float64[N]
    ts  = [0.0]                       # Vector de valores de tiempo
    i = 1                             # variable indice
    t = time = 0.0                           # variable auxiliar de tiempo
    while t <= tfinal
        #@info "Tiempo $(t) indice $(i)"

        Bn = a
        Dn = b * N[i] * P[i] + e * N[i]
        Bp = c * N[i] * P[i]
        Dp = d * P[i]
        R = Bp + Dp + Bn + Dn 
        time = time - log(rand()) / R
        rnd = rand() * R
        if rnd < Bn                   # probabilidad de nacimiento 
            Nn = N + 1
        elseif rnd < Bn+Dn 
            Nn = N - 1
        elseif rnd < Bn+Dn+Bp
            Pn = P + 1
        else
            Pn = P - 1
        end
        if Pn<= 0.0
            Pn = 0.0 
        end
        if Nn<=0.0
            Nn=0.0
        end

        if time > t
            push!(Ps, P)
            push!(Ns, N)
            push!(ts,time)
            t += .1
        end
        P = Pn
        N = Nn 
    end
    return ts,Ns,Ps
end




using Plots
a = 10000     # g/m3/dia
b = 2
e = 0.01    # 1/m3/dia
c = .4      # mg/m3/dia 
d = 1000
tfinal = 100

Neq = d/c
Peq = 1/b * (a*c/d - e)

t, N, P = nutri_phyto_det([a,b,e,c,d],[1,1],tfinal, 0.01)  


plot(t,N, label="N")
plot!(t,P, label="P")


function np_ODE!(du,u,p,t)
    N, P = u
    a , b , e, c, d = p                       # desempaquetamos los parámetros

    du[1] = a - b*N*P - e*N
    du[2] = c*N*P - d*P
end

function simulate_np(par,ini,tspan)
    prob = ODEProblem(np_ODE!,ini,tspan,par)
    sol = solve(prob)
    return sol
end

sol = simulate_np([a,b,e,c,d],[1,1],(0.0,tfinal))
plot(sol)
t, N, P = nutri_phyto_sto([a,b,e,c,d],[100,100],tfinal)  

plot(t,N, label="N")
plot!(t,P, label="P")

# Estamos en problemas


using(Distributions)
ats =  [ 500 + rand(Normal(200,50))*(1+cos( 1/10*x* pi)) for x in 1:101]
plot(ats)  

function nutri_phyto_sto(av,par,ini,tfinal)    
    b , e, c, d = par                       # desempaquetamos los parámetros
    N , P = ini                         # desempaquetamos condiciones iniciales
    Pn = Nn = 0.0                       # Proximo valor
 
    Ps = Float64[P]                 # Serie temporal Forzada a Float64 (numero real)
    Ns = Float64[N]
    ts  = [0.0]                       # Vector de valores de tiempo
    i = 1                             # variable indice
    t = time = 0.0                           # variable auxiliar de tiempo
    while t <= tfinal
        #@info "Tiempo $(t) indice $(i)"

        Bn = av[Int(trunc(t+1))]
        Dn = b * N[i] * P[i] + e * N[i]
        Bp = c * N[i] * P[i]
        Dp = d * P[i]
        R = Bp + Dp + Bn + Dn 
        time = time - log(rand()) / R
        rnd = rand() * R
        if rnd < Bn                   # probabilidad de nacimiento 
            Nn = N + 1
        elseif rnd < Bn+Dn 
            Nn = N - 1
        elseif rnd < Bn+Dn+Bp
            Pn = P + 1
        else
            Pn = P - 1
        end
        if Pn<= 0.0
            Pn = 0.0 
        end
        if Nn<=0.0
            Nn=0.0
        end

        if time > t
            push!(Ps, P)
            push!(Ns, N)
            push!(ts,time)
            t += .1
        end
        P = Pn
        N = Nn 
    end
    return ts,Ns,Ps
end

t, N, P = nutri_phyto_sto([a,b,e,c,d],[100,100],tfinal)  

plot(t,N, label="N")
plot!(t,P, label="P")

t, N, P = nutri_phyto_sto(ats,[b,e,c,d],[10,100],tfinal)  

plot(t,N, label="N")
plot!(t,P, label="P")

ats = [rand(Normal(500+x*100,30)) for x in 1:101]
plot(ats)

