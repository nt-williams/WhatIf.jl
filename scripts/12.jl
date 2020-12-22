push!(LOAD_PATH, "src")

using WhatIf, GLM, CSV, DataFrames, Statistics

# 12.1
nhefs = CSV.File("data/nhefs.csv") |> DataFrame;
nhefs.cens = ismissing.(nhefs.wt82); 
nhefs_nmv = filter(row -> !ismissing(row.wt82), nhefs);

combine(groupby(nhefs_nmv, :qsmk), [:age, :sex, :race, :education, :wt71, :smokeintensity, :smokeyrs] .=> mean) |>
    x -> stack(x, 2:8) |>
    x -> unstack(x, :qsmk, :value)

fit = lm(@formula(wt82_71 ~ qsmk), nhefs_nmv)
predict(fit, DataFrame(qsmk = [0, 1]))
coeftable(fit)

# 12.2
