using Beamformer
using Documenter

DocMeta.setdocmeta!(Beamformer, :DocTestSetup, :(using Beamformer); recursive=true)

makedocs(;
    modules=[Beamformer],
    authors="Morten F. Rasmussen <10264458+mofii@users.noreply.github.com> and contributors",
    repo="https://github.com/Orchard-Ultrasound-Innovation/Beamformer.jl/blob/{commit}{path}#{line}",
    sitename="Beamformer.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://Orchard-Ultrasound-Innovation.github.io/Beamformer.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/Orchard-Ultrasound-Innovation/Beamformer.jl",
    devbranch="main",
)
