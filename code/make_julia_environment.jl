include("path.jl")

using Pkg: activate

activate(environment_directory_path)

using Pkg: add, PackageSpec

add([
    PackageSpec("JSON"),
    PackageSpec(url="https://github.com/KwatME/Kraft.jl"),
])
