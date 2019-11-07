using JuMP, GLPK, Test

function assignment2(;)

    # Constants
    A = [1 0 0 1 1; 1 0 0 0 1; 1 1 0 0 1; 1 1 1 0 0; 0 1 1 0 0; 0 1 1 0 0; 0 0 1 1 0; 0 0 0 1 1]
    w = [8, 15, 18, 10, 12, 16, 6, 4]

    # Initialize model
    model = Model(with_optimizer(GLPK.Optimizer))

    # Variables
    @variable(model, x[1:5] >= 0, Int)
    @variable(model, u[1:8] >= 0, Int)

    # Objective: maximize profit
    @objective(model, Min, sum(u))

    # Constraint: can carry all
    @constraint(model, A * x .== u + w)
    
    # Solve problem using MIP solver
    JuMP.optimize!(model)

    # Print solution
    println("Objective is: ", JuMP.objective_value(model))
    println("Solution is:")

    for i in 1:5
        println("x[$i] = ", JuMP.value(x[i]))
    end
end

assignment2()


function assignment7(;)

    # Constants
    A = [1 0 0 1 1; 1 0 0 0 1; 1 1 0 0 1; 1 1 1 0 0; 0 1 1 0 0; 0 1 1 0 0; 0 0 1 1 0; 0 0 0 1 1]
    w = [8, 15, 18, 10, 12, 16, 6, 4]
    tmp = [4, 4, 4, 3, 4]
    big_m = 18

    # Initialize model
    model = Model(with_optimizer(GLPK.Optimizer))

    # Variables
    @variable(model, x[1:5] >= 0, Int)
    @variable(model, y[1:8], Bin)
    @variable(model, u_plus[1:8] >= 0, Int)
    @variable(model, u_minus[1:8] >= 0, Int)

    # Objective function
    @objective(model, Min, sum(u_minus))

    # Constraints
    @constraint(model, x .<= (2 - A' * y) * big_m)
    @constraint(model, A * x + u_minus .== w + u_plus)
    @constraint(model, u_plus .<= y * big_m)

    # Solve
    JuMP.optimize!(model)

    # Print solution
    println("Objective is: ", JuMP.objective_value(model))
    println("Solution is:")

    for i in 1:5
        println("x[$i] = ", JuMP.value(x[i]))
    end
end

assignment7()

