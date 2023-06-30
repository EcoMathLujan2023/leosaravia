#
# Equilibrio
#
# N = Nutrientes
# P = Población (fitoplankton)
#
# dN = a - b N P - e N
# dP = c N P - d P     (monod : N P / (k + N))
#
#  0 = a - b N P - e N   ==> a - N (b P - e )=0 ==>    d/c ( b P - e ) = a 
#  ==> b P - e = a c/d   ==>  P = (a c/ d + e  ) / b = a c / ( d b ) + e / b
#
#  0 = c N P - d P ==>  P ( c N - d) = 0  ==>    Neq = d/c
#
using Plots
include( "fun_modelos.jl")

a = 100     # g/m3/dia
b = 1
e = 0.01    # 1/m3/dia
c = .2      # mg/m3/dia 
d = 1
tfinal = 100

Neq = d/c 
Peq = a*c/(b*d) + e/b
t, N, P = nutri_phyto_det([a,b,e,c,d],[1,500],tfinal, 0.01)

plot(t,N, label="N")
plot!(t,P, label="P")

using DifferentialEquations

sol = simulate_np([a,b,e,c,d],[5,50],(0,tfinal))
plot(sol)

# Organizar archivos + docstrings
#
# Simulación estocástica
a = 100000     # g/m3/dia
b = 1
e = 0.01    # 1/m3/dia
c = .2      # mg/m3/dia 
d = 5
tfinal = 50

Neq = d/c 
Peq = a*c/(b*d) + e/b

t,N,P = nutri_phyto_sto([a,b,e,c,d],[1,50],tfinal)
plot(t,N, label="N")
plot!(t,P, label="P")



#
#
# Datos 
# 
dat = Float64[1097950, 1163450, 378200, 346800, 26800, 15150,
                0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ,
                4426250, 33050, 188500, 23200, 16900, 6550, 51050] 

dat= dat ./ 100                
using Plots, Distributions
scatter(dat)

d_a = Truncated(Normal(100000,50000),100,200000)
d_b = Truncated(Normal(2,1),.01,5)
d_e = Truncated(Normal(0.01,0.01),0.001, 0.1)
d_c = Truncated(Normal(.2,.1),.001,.5)
d_d = Truncated(Normal(5,2),0.1,10)

t,N,P = nutri_phyto_sto([a,b,e,c,d],[1,50],tfinal)
t,N1,P1 = nutri_phyto_sto([a,b,e,c,d],[1,50],tfinal)

distance(P1[end-29: end], P[end-29:end])

exito_par = ABC_nutri_phyto(dat,[d_a,d_b,d_e,d_c,d_d], 1000)

#
# Ejercicio
# 
# 1) Usar funcion deterministica para hacer el ajuste ABC
#
# 2) Agregar funcion de monod para saturación de nutrientes
#
