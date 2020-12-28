using DataFrames, GLM, CovarianceMatrices, Distributions
using StatsBase: CoefTable

function coeftable(mm::StatsModels.TableRegressionModel; robust::Bool=true)
    cc = coef(mm)
    se = robust ? stderror(mm, HC3()) : stderror(mm)
    tt = cc ./ se
    p = ccdf.(Ref(FDist(1, dof_residual(mm))), abs2.(tt))
    ci = se*quantile(TDist(dof_residual(mm)), (1-0.95)/2)
    levstr = isinteger(0.95*100) ? string(Integer(0.95*100)) : string(0.95*100)
    CoefTable(hcat(cc,se,tt,p,cc+ci,cc-ci),
              ["Coef.","Std. Error","t","Pr(>|t|)","Lower $levstr%","Upper $levstr%"],
              coefnames(mm), 4, 3)
end