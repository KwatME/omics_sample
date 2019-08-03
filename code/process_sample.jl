using JSON: parse
using Kraft: print_and_run_cmd, error_if_equal, process_germ_dna, process_soma_dna, process_soma_rna

include("path.jl")


data_for_processing_sequence_directory_path = joinpath(
    input_directory_path,
    "data_for_processing_sequence",
)

if !isdir(data_for_processing_sequence_directory_path)

    print_and_run_cmd(`unzip -o -d $input_directory_path $data_for_processing_sequence_directory_path.zip`)

end

project_json = parse(read(
    project_json_file_path,
    String,
))

process_dna_arguments = (
    joinpath(
        data_for_processing_sequence_directory_path,
        "GCA_000001405.15_GRCh38_no_alt_plus_hs38d1_analysis_set.fna.gz",
        # "hs37d5.fa.gz",
    ),
    joinpath(
        data_for_processing_sequence_directory_path,
        "chromosome.bed.gz",
    ),
    joinpath(
        data_for_processing_sequence_directory_path,
        "chrn_n.tsv",
    ),
    project_json["n_job"],
    project_json["gb_memory"],
    2,
)

if all(in(
    key,
    keys(project_json),
) for key in (
    "germ_dna.1.fastq.gz",
    "germ_dna.2.fastq.gz",
))

    error_if_equal(
        project_json["germ_dna.1.fastq.gz"],
        project_json["germ_dna.2.fastq.gz"],
    )

    process_germ_dna(
        joinpath(
            project_directory_path,
            project_json["germ_dna.1.fastq.gz"],
        ),
        joinpath(
            project_directory_path,
            project_json["germ_dna.2.fastq.gz"],
        ),
        project_json["dna_is_targeted"],
        joinpath(
            output_directory_path,
            "process_germ_dna",
        ),
        process_dna_arguments...,
    )
    
end

if all(in(
    key,
    keys(project_json),
) for key in (
    "germ_dna.1.fastq.gz",
    "germ_dna.2.fastq.gz",
    "soma_dna.1.fastq.gz",
    "soma_dna.2.fastq.gz",
))

    error_if_equal(
        project_json["germ_dna.1.fastq.gz"],
        project_json["germ_dna.2.fastq.gz"],
    )

    error_if_equal(
        project_json["soma_dna.1.fastq.gz"],
        project_json["soma_dna.2.fastq.gz"],
    )

    process_soma_dna(
        joinpath(
            project_directory_path,
            project_json["germ_dna.1.fastq.gz"],
        ),
        joinpath(
            project_directory_path,
            project_json["germ_dna.2.fastq.gz"],
        ),
        joinpath(
            project_directory_path,
            project_json["soma_dna.1.fastq.gz"],
        ),
        joinpath(
            project_directory_path,
            project_json["soma_dna.2.fastq.gz"],
        ),
        project_json["dna_is_targeted"],
        joinpath(
            output_directory_path,
            "process_soma_dna",
        ),
        process_dna_arguments...,
    )
    
end

if all(in(
    key,
    keys(project_json),
) for key in (
    "soma_rna.1.fastq.gz",
    "soma_rna.2.fastq.gz",
))

    error_if_equal(
        project_json["soma_rna.1.fastq.gz"],
        project_json["soma_rna.2.fastq.gz"],
    )
    
    process_soma_rna(
        joinpath(
            project_directory_path,
            project_json["soma_rna.1.fastq.gz"],
        ),
        joinpath(
            project_directory_path,
            project_json["soma_rna.2.fastq.gz"],
        ),
        joinpath(
            output_directory_path,
            "process_soma_rna",
        ),
        joinpath(
            data_for_processing_sequence_directory_path,
            "Homo_sapiens.GRCh38.cdna.all.fa.gz",
        ),
        project_json["n_job"],
    )
    
end
