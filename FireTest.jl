using Random
using Plots
using Distributions

function initialize_forest(N::Int)
    forest = fill('B', (N, N))
    return forest
end

function initialize_fire(forest, p::Float64)
    N = size(forest, 1)
    for i in 1:N, j in 1:N
        if rand() < p
            forest[i, j] = 'F'
        end
    end
end

function power_law(alpha::Float64)
    r = rand()
    return ceil(Int, 1 / (1 - r^(1 / alpha)))
end

function gillespie(forest, lambdaB::Float64, lambdaF::Float64, muF::Float64, bF::Float64)
    N = size(forest, 1)
    M = size(forest, 2)
    rates = zeros(Float64, 4)
    while true
        # Calculate rates for each reaction
        for i in 1:N, j in 1:M
            if forest[i, j] == 'B'
                rates[1] = lambdaB * power_law(2.0)
                rates[2] = lambdaF * count_neighbors_on_fire(forest, i, j)
                rates[4] = bF
            elseif forest[i, j] == 'F'
                rates[3] = muF
            end
        end
        
        # Calculate total rate
        total_rate = sum(rates)
        
        # Calculate time for next event
        tau = -log(rand()) / total_rate
        
        # Determine which event occurs
        distribution = Categorical(rates / total_rate)
        event = rand(distribution)
        
        # Choose a random site
        site_i, site_j = rand(1:N), rand(1:M)
        
        # Update the forest based on the chosen event
        if event == 1
            forest[site_i, site_j] = 'B'
        elseif event == 2
            forest[site_i, site_j] = 'F'
        elseif event == 3
            forest[site_i, site_j] = 'V'
        elseif event == 4
            forest[site_i, site_j] = 'F'
        end
        
        return tau
    end
end

function count_neighbors_on_fire(forest, i, j)
    N = size(forest, 1)
    M = size(forest, 2)
    count = 0
    if i > 1 && forest[i - 1, j] == 'F'
        count += 1
    end
    if i < N && forest[i + 1, j] == 'F'
        count += 1
    end
    if j > 1 && forest[i, j - 1] == 'F'
        count += 1
    end
    if j < M && forest[i, j + 1] == 'F'
        count += 1
    end
    return count
end

function simulate_forest(lambdaB::Float64, lambdaF::Float64, muF::Float64, bF::Float64, N::Int, T::Float64)
    forest = initialize_forest(N)
    initialize_fire(forest, 0.5)
    
    times = [0.0]
    counts = Dict('B' => [count_B(forest)], 'F' => [count_F(forest)], 'V' => [count_V(forest)])
    
    for (tau) in gillespie(forest, lambdaB, lambdaF, muF, bF)
        t = times[end] + tau
        if t > T
            break
        end
        push!(times, t)
        push!(counts['B'], count_B(forest))
        push!(counts['F'], count_F(forest))
        push!(counts['V'], count_V(forest))
    end
    
    return times, counts
end

function count_B(forest)
    return count(x -> x == 'B', forest)
end

function count_F(forest)
    return count(x -> x == 'F', forest)
end

function count_V(forest)
    return count(x -> x == 'V', forest)
end

function plot_temporal_dynamics(times, counts)
    plot(times, counts['B'], label = "B", xlabel = "Time", ylabel = "Count", title = "Temporal Dynamics")
    plot!(times, counts['F'], label = "F")
    plot!(times, counts['V'], label = "V")
    display(plot!)
end

function plot_spatial_distribution(forest)
    N = size(forest, 1)
    M = size(forest, 2)
    heatmap(forest, aspect_ratio = :equal, color = [:green, :red, :white], legend = false, 
            xlims = (1, M), ylims = (1, N), xlabel = "Column", ylabel = "Row", title = "Spatial Distribution")
    display(plot!)
end

# Set the parameters
lambdaB = 0.2
lambdaF = 0.1
muF = 0.05
bF = 0.01
N = 100
T = 100.0

forest = initialize_forest(100)
gillespie(forest, lambdaB, lambdaF, muF, bF)
# Simulate the forest dynamics
times, counts = simulate_forest(lambdaB, lambdaF, muF, bF, N, T)

# Plot the temporal dynamics
plot_temporal_dynamics(times, counts)

# Plot the spatial distribution at the end of simulation
plot_spatial_distribution(counts['F'][end])

