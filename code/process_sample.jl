using Kraft: print_and_run_cmd, process_germ_dna, process_soma_dna, process_soma_rna

project_dir = dirname(dirname(@__DIR__))

input_dir = joinpath(project_dir, "input")

output_dir = joinpath(project_dir, "output")

data_for_processing_sequence_dir = joinpath(input_dir, "data_for_processing_sequence")

if !isdir(data_for_processing_sequence_dir)

    print_and_run_cmd(`unzip -o -d $input_dir $data_for_processing_sequence_dir.zip`)

end

using JSON: parse

project_json = parse(read(joinpath(project_dir, "project.json"), String))

process_dna_arguments = (
    joinpath(
        data_for_processing_sequence_dir,
        "GCA_000001405.15_GRCh38_no_alt_plus_hs38d1_analysis_set.fna.gz",
    ),
    joinpath(data_for_processing_sequence_dir, "chromosome.bed.gz"),
    joinpath(data_for_processing_sequence_dir, "chrn_n.tsv"),
    project_json["n_job"],
    project_json["gb_memory"],
    2,
)

if all(in(key, keys(project_json)) for key in (
    "germ_dna.1.fastq.gz",
    "germ_dna.2.fastq.gz",
))
    
    process_germ_dna(
        joinpath(project_dir, project_json["germ_dna.1.fastq.gz"]),
        joinpath(project_dir, project_json["germ_dna.2.fastq.gz"]),
        project_json["dna_is_targeted"],
        joinpath(output_dir, "process_germ_dna"),
        process_dna_arguments...,
    )
    
end

if all(in(key, keys(project_json)) for key in (
    "germ_dna.1.fastq.gz",
    "germ_dna.2.fastq.gz",
    "soma_dna.1.fastq.gz",
    "soma_dna.2.fastq.gz",
))
    
    process_soma_dna(
        joinpath(project_dir, project_json["germ_dna.1.fastq.gz"]),
        joinpath(project_dir, project_json["germ_dna.2.fastq.gz"]),
        joinpath(project_dir, project_json["soma_dna.1.fastq.gz"]),
        joinpath(project_dir, project_json["soma_dna.2.fastq.gz"]),
        project_json["dna_is_targeted"],
        joinpath(output_dir, "process_soma_dna"),
        process_dna_arguments...,
    )
    
end

if all(in(key, keys(project_json)) for key in (
    "soma_rna.1.fastq.gz",
    "soma_rna.2.fastq.gz",
))
    
    process_soma_rna(
        joinpath(project_dir, project_json["soma_rna.1.fastq.gz"]),
        joinpath(project_dir, project_json["soma_rna.2.fastq.gz"]),
        joinpath(output_dir, "process_soma_rna"),
        joinpath(data_for_processing_sequence_dir, "Homo_sapiens.GRCh38.cdna.all.fa.gz"),
        project_json["n_job"],
    )
    
end
