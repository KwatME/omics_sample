A self-contained genome sequence analysis package.

`code/` contains sequence analysis notebooks which run in the environment below to read data (fastq, fasta) in `input/` and produce data (trimmed fastq, bam, vcf, etc.) in `output/`.

This package uses Skewer to trim reads, minimap2 to align them to GRCH38, and strelka & manta to find variants.

## Setup Environment

1. [Install conda](https://github.com/KwatME/environment/blob/master/conda.md)

2. [Install SnpEff](https://pcingola.github.io/SnpEff/download.html#download) in `Downloads/` folder

```sh
cd ~/Downlaods/SnpEff_CURRENT_VERSION

java -jar SnpEff.jar download GRCh38.76
```

3. [Install Julia](https://julialang.org/downloads/)

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

4. Download [Kraft.jl](https://github.com/KwatME/Kraft.jl/releases/tag/0.0.1) and unzip


## Run

```sh
jupyter lab
```
