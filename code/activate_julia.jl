using Pkg: activate, PackageSpec, add, status

include("initialize_path.jl")

activate(environment_directory_path)

add([
    PackageSpec(name="IJulia"),
    PackageSpec(name="JSON"),
    PackageSpec(url="https://github.com/KwatME/Kraft.jl"),
])

status()