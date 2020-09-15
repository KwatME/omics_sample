A self-contained genome sequencing analysis package.

This package uses Skewer to trim reads, minimap2 to align them to GRCH38, and strelka & manta to find variants. It runs best on Linux.

`code/` contains sequence analysis notebooks which run in the environment below to read data (fastq, fasta) in `input/` and produce data (trimmed fastq, bam, vcf, etc.) in `output/`.

## Setup Environment

1. [Install conda](https://github.com/KwatME/environment/blob/master/conda.md)

2. [Install Julia](https://julialang.org/downloads/)

```sh
julia

for package in (
    "IJulia",
    "JuliaFormatter",
    "JSON",
)

    add(package)

end

```

3.Download [Kraft.jl](https://github.com/KwatME/Kraft.jl/releases/tag/0.0.1) and unzip

4.[Install SnpEff](https://pcingola.github.io/SnpEff/download.html#download) in `Downloads/` folder

```sh
cd ~/Downlaods/SnpEff_CURRENT_VERSION

java -jar SnpEff.jar download GRCh38.76
```

## Run

```sh
jupyter lab
```
