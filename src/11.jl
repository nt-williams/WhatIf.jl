module eleven

using Plots
using StatsBase
using GLM
using DataFrames

# 11.1 
A = [1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0]
Y = [200, 150, 220, 110, 50, 180, 90, 170, 170, 30, 70, 110, 80, 50, 10, 20]

plot(A, Y, seriestype = :scatter, legend = false)

describe(Y[A .== 0])
describe(Y[A .== 1])

A₂ = [1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4]
Y₂ = [110, 80, 50, 40, 170, 30, 70, 50, 110, 50, 180, 130, 200, 150, 220, 210]

plot(A₂, Y₂, seriestype = :scatter, legend = false)

describe(Y₂[A₂ .== 1])
describe(Y₂[A₂ .== 2])
describe(Y₂[A₂ .== 3])
describe(Y₂[A₂ .== 4])

# 11.2
A₃ = [3, 11, 17, 23, 29, 37, 41, 53, 67, 79, 83, 97, 60, 71, 15, 45]
Y₃ = [21, 54, 33, 101, 85, 65, 157, 120, 111, 200, 140, 220, 230, 217, 11, 190]

plot(A₃, Y₃, seriestype = :scatter, legend = false)

data = DataFrame(A₃ = A₃, Y₃ = Y₃);
fit = lm(@formula(Y₃ ~ A₃), data)
predict(fit, DataFrame(A₃ = 90))

# 11.3
fit₃ = lm(@formula(Y₃ ~ A₃ + A₃^2), data)
predict(fit₃, DataFrame(A₃ = 90), interval = :confidence)