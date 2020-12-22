using Gadfly
import Cairo

export saveplot

function saveplot(plot, filepath)
    path = joinpath("plots", filepath)
    draw(PNG(path, dpi = 300), plot)
end