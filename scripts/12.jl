push!(LOAD_PATH, "src");

using WhatIf, GLM, CSV, DataFrames, Statistics, CovarianceMatrices, Distributions

# 12.1
nhefs = CSV.File("data/nhefs.csv") |> DataFrame;
filter!(row -> !ismissing(row.wt82), nhefs);

combine(groupby(nhefs, :qsmk), 
        [:age, :sex, :race, :education, :wt71, 
         :smokeintensity, :smokeyrs] .=> mean) |>
    x -> stack(x, 2:8) |>
    x -> unstack(x, :qsmk, :value)

fit = glm(@formula(wt82_71 ~ qsmk), nhefs, Normal(), IdentityLink())
predict(fit, DataFrame(qsmk = [0, 1]))
coeftable(fit)

# 12.2
fitᵩ = glm(@formula(qsmk ~ sex + race + age + age^2 + education + 
                   smokeintensity + smokeintensity^2 + smokeyrs + smokeyrs^2 + 
                   exercise + active + wt71 + wt71^2), 
    nhefs, Binomial(), LogitLink(), 
    contrasts = Dict(:education => DummyCoding(), 
                     :exercise => DummyCoding(), 
                     :active => DummyCoding()))

ϕ = 1 ./ [s == 1 ? p : 1 - p for (s, p) in zip(qsmk, predict(fitᵩ))]
describe(ϕ)

fitᵨ = glm(@formula(wt82_71 ~ qsmk), nhefs, Normal(), IdentityLink(), wts = ϕ)

function robustci(m)
    se = stderror(fitᵨ, HC3())
    cv = quantile(Normal(), 0.975)
    hcat(coef(m) .- (cv*se), coef(m) .+ (cv*se))
end

robustci(fitᵨ)