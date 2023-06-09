using Plots
using Distributions

function migr_muerte_sto(μ, δ, n0, tmax)
    t = 0.0
    n = n0

    ts = [t]
    ns = [n]

    while t < tmax
        # Calcular las tasas de reacción
        rates = [μ, δ * n]

        # Calcular la tasa total
        total_rate = sum(rates)

        # Generar dos números aleatorios independientes
        r1 = rand()

        # Calcular el tiempo hasta el próximo evento
        dt = -log(r1) / total_rate

        # Determinar cuál reacción ocurre
        
        reaction = rand(Categorical(rates/total_rate))

        if reaction == 1
            # Se produce un incremento en n
            n += 1
        else
            # Se produce una disminución en n
            n -= 1
        end

        # Actualizar el tiempo
        t += dt

        # Agregar los resultados a las listas
        push!(ts, t)
        push!(ns, n)
    end

    return ts, ns
end

# Parámetros de la simulación
μ = 0.5
δ = 0.1
n0 = 100
tmax = 100.0

# Simular el proceso estocástico
ts, ns = migr_muerte_sto(μ, δ, n0, tmax)

# Graficar los resultados
plot(ts, ns, xlabel="Tiempo", ylabel="n", title="Simulación de Migr. Muerte", legend=false)