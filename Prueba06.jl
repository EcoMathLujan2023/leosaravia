using Plots
using DifferentialEquations
using Distributions
include( "fun_modelos.jl")

tsamp = tspan[1]:0.1:tspan[2]
reduce(hcat,sol.(tsamp))

a = 100000     # g/m3/dia
b = 1
e = 0.01    # 1/m3/dia
c = .2      # mg/m3/dia 
d = 5
tfinal = 50

Neq = d/c 
Peq = a*c/(b*d) + e/b

sol = simulate_np([a,b,e,c,d],[5,50],(0,tfinal))
plot(sol)

@info sol.t
tsamp = 71:1:100
reduce(hcat,sol.(tsamp))

sol[1:end,:]
