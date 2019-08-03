using Pkg: add, PackageSpec


add([
    PackageSpec("CSV"),
    PackageSpec("DataFrames"),
    PackageSpec("JSON"),
    PackageSpec(url="https://github.com/KwatME/Kraft.jl"),
])
