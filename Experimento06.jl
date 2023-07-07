#
# Ejercicio
# 
# 1) Usar funcion deterministica para hacer el ajuste ABC
#
# 2) Agregar funcion de monod para saturación de nutrientes
#
# 3) Ver debugging/depuracion

#
# Probar si la metodología de ajuste funciona
# Usar una simulación con parametros conocidos como dato 
# Ajustar y si se recuperan los parametros verficamos la metodologia 
#

#
# Extraer valores a intervalos de tiempo constante de la solucion por el paquete DifferentialEquations
#
#
sol = simulate_np([a,b,e,c,d],[5,50],(0,tfinal))
sol.t ## devuelve el tiempo 
sol.u # devuelve el vector de 

tsamp = tfinal-l_data:1:tfinal   # Definir los intervalos de tiempo para que devuelva los valores
@info sol.(tsamp)
out = reduce(hcat,sol.(tsamp))  
P = out[2,:]

# Simulación estocástica
a = 100     # g/m3/dia
b = 1
e = 0.01    # 1/m3/dia
c = .2      # mg/m3/dia 
d = 2
tfinal = 50
Neq = d/c 
Peq = a*c/(b*d) + e/b
t,N,P = nutri_phyto_sto([a,b,e,c,d],[1,50],tfinal)

j=1
dat = zeros(50) 
for i in 1:length(t) 
    if t[i]>=j 
        dat[j] = P[i]
        j += 1
        if j > 50.0
            break
        end
    end
end
plot(dat)

dat = dat[ end - 29:end]
#
using Distributions

d_a = Uniform(1,500)
d_b = Uniform(01,5)
d_e = Uniform(0.001, 0.1)
d_c = Uniform(.001,.5)
d_d = Uniform(0.1,10)
exito_par = ABC_nutri_phyto(dat,[d_a,d_b,d_e,d_c,d_d], 30)

using StatsPlots
density(exito_par[1,:])
density(exito_par[2,:])
density(exito_par[3,:])
density(exito_par[4,:])
density(exito_par[5,:])

#
# Conclusion con 30 puntos no podemos recuperar los parametros 
#
# Ejercicio: Ver cuantos datos son necesarios para recuperar los parámetros
#

# Holling Type II = Monod
#
# dN = a - b N P / (k + P ) - e N
# dP = c N P / (k + P) - d P 
#
# Huppert, A., Blasius, B., Olinky, R., & Stone, L. (2005). A model for seasonal phytoplankton blooms. 
# Journal of Theoretical Biology, 236(3), 276–290. http://dx.doi.org/10.1016/j.jtbi.2005.03.012

# Transformación adimensional/no dimensional = Transformación proporcional
#
# dN = I - N P - q N
# dP = N P - P
#
# N'= N / c_N 
#
# N'= c/d N
# P'= b/d p
# t'= d t
# I = a c / d²
# q = e / d
#  

# Modelo paso 1 = Pensar en la simplicación del sistema de estudio
#
# dMo/dt = H  ( d_h + h_f Mf ) - a Ma Mo - e Me Mo - i Mi Mo - f Mf Mo
# dH/dt = q_h - d_h H - h_f Mf H = q_h - H ( d_h + h_f Mf )
# dMa/dt = a e_a Ma Mo - d_a Ma 
# dMe/dt = e e_e Me Mo - d_e Me 
# dMi/dt = i e_i Mi Mo - d_i Mi 
# dMf/dt = f e_f Mf Mo - d_f Mf 
# 
# Paso 2 - transformacion proporcional ( o no)
# Paso 3 - sacar equilibrios
# Paso 4 - Resolver de forma numérica
#

using DifferentialEquations
"Equaciones del modelo del suelo"
function suelo_ODE!(du,u,p,t)
    Mo, H, Ma, Me, Mi, Mf = u
    d_h, a , e, i , f, q_h, h_f, e_a, d_a, e_e, d_e, e_i, d_i, e_f, d_f = p                       # desempaquetamos los parámetros

    du[1] = H * ( d_h + h_f * Mf ) - a * Ma * Mo - e * Me * Mo - i * Mi * Mo - f * Mf * Mo
    du[2] = q_h - d_h * H - h_f * Mf * H 
    du[3] = a * e_a * Ma * Mo - d_a * Ma
    du[4] = e * e_e * Me * Mo - d_e * Me 
    du[5] = i * e_i * Mi * Mo - d_i * Mi 
    du[6] = f * e_f * Mf * Mo - d_f * Mf

end

"Simulación de modelo suelo"
function simulate_suelo(par,ini,tspan)
    prob = ODEProblem(suelo_ODE!,ini,tspan,par)
    sol = solve(prob)
    return sol
end

# d_h = 0.1 200 = 20
# q_h = 200 g/m²/año
# h_f = 6 20 = 120
p = [20, 20 , 10, 10 , 100, 200, 120, 0.3, 1/2, 0.3, 1/3, 0.3, 1/4, 0.3, 1/12 ]
#    d_h, a ,  e,  i ,   f, q_h, h_f, e_a, d_a, e_e, d_e, e_i, d_i, e_f, d_f
@info p
ini = [200,100, 100, 50, 10, 40]

sol = simulate_suelo(p, ini, (1,100) )

