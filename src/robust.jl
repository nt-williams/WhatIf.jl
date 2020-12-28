using DataFrames, GLM, CovarianceMatrices, Distributions

export robustci

function robustci(m)
    cf = coef(m)
    se = stderror(m, HC3())
    cv = quantile(Normal(), 0.975)
    DataFrame(coef = cf, se = se, lower = cf .- (cv*se), upper = cf .+ (cv*se))
end