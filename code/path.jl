project_directory_path = dirname(@__DIR__)

project_json_file_path = joinpath(
    project_directory_path,
    "project.json",
)

environment_directory_path = joinpath(
    project_directory_path,
    "environment",
)

input_directory_path = joinpath(
    project_directory_path,
    "input",
)

output_directory_path = joinpath(
    project_directory_path,
    "output",
)
