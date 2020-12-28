using Statistics, GLM

export rmse

function rmse(fit)
    truth = response(fit.mf)
    n, p = size(fit.mm)
    df = n - p
    sqrt(sum((predict(fit) - truth) .^ 2) / df)
end