# Julia code for *Causal Inference: What If*

### Downloading the data

Data can be downloaded with the repository. Alternatively, the following can be used:

```
using HTTP, CSV

data = HTTP.get("https://cdn1.sph.harvard.edu/wp-content/uploads/sites/1268/1268/20/nhefs.csv")
CSV.File(data.body) |> CSV.write("data/test.csv")
```