using DifferentialEquations, Plots

function lotka_volterra!(du,u,p,t)
    a, b, c, e, d = p
    N, P = u
    du[1] = a*N - b*N*P - e*N
    du[2] = c*N*P - d*P
end

a = 0.00075
b = 1.0
c = 1.0
e = 0
d = 0.1

p = [a,b,c,e,d]


u0 = [0.05,0.0005]
tspan = (0.0,350.0)
p = [a,b,c,e,d]

prob = ODEProblem(lotka_volterra!,u0,tspan,p)
sol = solve(prob)
plot(sol)

Nmax = 1
Pmax = 1

Nrange = range(0,Nmax,length=20)
Prange = range(0,Pmax,length=20)

x = Vector{Float64}()
y = Vector{Float64}()
u = Vector{Float64}()
v = Vector{Float64}()

for N in Nrange
    for P in Prange
        dNdt,dPdt = lotka_volterra!([0,0],[N,P],p,0)
        push!(x,N)
        push!(y,P)
        push!(u,dNdt)
        push!(v,dPdt)
    end
end

quiver(x,y,quiver=(u,v))

using Plots

a = 0.00075
b = 1.0
c = 1.0
e = 0.0
d = 0.1

Nmax = 0.0015
Pmax = 0.15

Nrange = range(0,Nmax,length=100)
Prange = range(0,Pmax,length=100)

N_nullcline = (a-e)/b .+ zeros(length(Nrange))
P_nullcline = (d/c) ./ Nrange

plot(Nrange,N_nullcline,label="dP/dt=0")
plot!(P_nullcline,Prange,label="dN/dt=0")
xlabel!("N")
ylabel!("P")