push!(LOAD_PATH, "src");

using WhatIf, Gadfly, Statistics, GLM, DataFrames

# Program 11.1 
A = [1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0]
Y = [200, 150, 220, 110, 50, 180, 90, 170, 170, 30, 70, 110, 80, 50, 10, 20]

saveplot(plot(x = A, y = Y), "figure-11-1.png")

describe(Y[A .== 0])
describe(Y[A .== 1])

A₂ = [1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4]
Y₂ = [110, 80, 50, 40, 170, 30, 70, 50, 110, 50, 180, 130, 200, 150, 220, 210]

saveplot(plot(x = A₂, y = Y₂), "figure-11-2.png")

describe(Y₂[A₂ .== 1])
describe(Y₂[A₂ .== 2])
describe(Y₂[A₂ .== 3])
describe(Y₂[A₂ .== 4])

A₃ = [3, 11, 17, 23, 29, 37, 41, 53, 67, 79, 83, 97, 60, 71, 15, 45]
Y₃ = [21, 54, 33, 101, 85, 65, 157, 120, 111, 200, 140, 220, 230, 217, 11, 190]

saveplot(plot(x = A₃, y = Y₃), "figure-11-3.png")

# Program 11.2
data = DataFrame(A₃ = A₃, Y₃ = Y₃);
fit = lm(@formula(Y₃ ~ A₃), data)
predict(fit, DataFrame(A₃ = 90))

plot(layer(x = A₃, y = Y₃, Geom.point),
     layer(x = A₃, y = predict(fit), Geom.line)) |> 
     x -> saveplot(x, "figure-11-4.png")

# Program 11.3
fit₃ = lm(@formula(Y₃ ~ A₃ + A₃^2), data)
predict(fit₃, DataFrame(A₃ = 90), interval = :confidence)

plot(layer(x = A₃, y = Y₃, Geom.point),
     layer(x = A₃, y = predict(fit₃), Geom.line)) |> 
     x -> saveplot(x, "figure-11-5.png")