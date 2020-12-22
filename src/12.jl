module twelve

using GLM
using CSV
using DataFrames
using Statistics

# 12.1
nhefs = CSV.File("nhefs.csv") |> DataFrame;
nhefs.cens = ismissing.(nhefs.wt82); 
nhefs_nmv = filter(row -> !ismissing(row.wt82), nhefs);

fit = lm(@formula(wt82_71 ~ qsmk), nhefs_nmv)
predict(fit, DataFrame(qsmk = [0, 1]))
coeftable(fit)

combine(groupby(nhefs_nmv, :qsmk), [:age, :sex, :race, :education, :wt71, :smokeintensity, :smokeyrs] .=> mean) |>
    x -> stack(x, 2:8) |>
    x -> unstack(x, :qsmk, :value)
