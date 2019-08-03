using JSON: parse
using Kraft: check_sequence

include("path.jl")


project_json = parse(read(
    project_json_file_path,
    String,
))

check_sequence(
    Tuple(joinpath(
        project_directory_path,
        value,
    ) for (
        key,
        value,
    ) in project_json if endswith(
        key,
        ".fastq.gz",
    )),
    joinpath(
        output_directory_path,
        "check_sequence",
    ),
    project_json["n_job"],
)
