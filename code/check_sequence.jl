using Kraft: check_sequence

project_dir = dirname(dirname(@__DIR__))

output_dir = joinpath(project_dir, "output")

using JSON: parse

project_json = parse(read(joinpath(project_dir, "project.json"), String))

check_sequence(
    Tuple(
        joinpath(project_dir, value)
        for (key, value) in project_json
        if endswith(key, ".fastq.gz")
    ),
    joinpath(output_dir, "check_sequence"),
    project_json["n_job"],
)
