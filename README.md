# Julia code for *Causal Inference: What If*

**This repository is a work-in-progress!**

Julia code for Part II of [*Causal Inference: What If*](https://www.hsph.harvard.edu/miguel-hernan/causal-inference-book/)

> Hernán MA, Robins JM (2020). Causal Inference: What If. Boca Raton: Chapman & Hall/CRC.
___

### Downloading the data

Data can be downloaded with the repository. Alternatively, the following can be used:

```
using HTTP, CSV

data = HTTP.get("https://cdn1.sph.harvard.edu/wp-content/uploads/sites/1268/1268/20/nhefs.csv")
CSV.File(data.body) |> CSV.write("data/nhefs.csv")
```