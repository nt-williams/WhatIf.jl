push!(LOAD_PATH, "src");

using WhatIf, GLM, CSV, DataFrames, Statistics, Distributions

# Program 12.1
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

# Program 12.2
fitᵩ = glm(@formula(qsmk ~ sex + race + age + age^2 + education + 
                   smokeintensity + smokeintensity^2 + smokeyrs + smokeyrs^2 + 
                   exercise + active + wt71 + wt71^2), 
    nhefs, Binomial(), LogitLink(), 
    contrasts = Dict(:education => DummyCoding(), 
                     :exercise => DummyCoding(), 
                     :active => DummyCoding()))

ϕ = 1 ./ [s == 1 ? p : 1 - p for (s, p) in zip(nhefs.qsmk, predict(fitᵩ))]
describe(ϕ)

fitᵨ = glm(@formula(wt82_71 ~ qsmk), nhefs, Normal(), IdentityLink(), wts = ϕ)
robustci(fitᵨ)

# Program 12.3
num = mean(nhefs.qsmk)
ϕsw = [s == 1 ? num / p : (1 - num) / (1 - p) for (s, p) in zip(nhefs.qsmk, predict(fitᵩ))]
describe(ϕsw)

fitₛ = glm(@formula(wt82_71 ~ qsmk), nhefs, Normal(), IdentityLink(), wts = ϕsw)
robustci(fitₛ)

# Program 12.4
nhefs₂ = filter(row -> row.smokeintensity <= 25, nhefs);

fit_num = glm(@formula(smkintensity82_71 ~ 1), 
              nhefs₂, Normal(), IdentityLink())

fit_denom = glm(@formula(smkintensity82_71 ~ sex + race + age + age^2 + education + 
                    smokeintensity + smokeintensity^2 + smokeyrs + smokeyrs^2 + 
                    exercise + active + wt71 + wt71^2), 
           nhefs₂, Normal(), IdentityLink(), 
           contrasts = Dict(:education => DummyCoding(), 
                            :exercise => DummyCoding(), 
                            :active => DummyCoding()))

σ̂num, σ̂denom = rmse(fit_num), rmse(fit_denom)
ϕdens = [pdf(Normal(ŷnum, σ̂num), x) / pdf(Normal(ŷdenom, σ̂denom), x) for (x, ŷnum, ŷdenom) in zip(nhefs₂.smkintensity82_71, predict(fit_num), predict(fit_denom))]
describe(ϕdens)

fit_msm = glm(@formula(wt82_71 ~ smkintensity82_71 + smkintensity82_71^2), nhefs₂, Normal(), IdentityLink(), wts = ϕdens)
robustci(fit_msm)