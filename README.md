## About

A self-contained genome sequence analysis package.

`code/` contains sequence analysis notebooks which run in the environment below to read data in `input/` and produce data in `output/`.

This package uses Skewer to trim reads, minimap2 to align them to GRCH38, and strelka & manta to call variants.

## Setup Environment

### 1. [Install conda](https://github.com/KwatME/environment/blob/master/conda.md)

### 2. [Install SnpEff](https://pcingola.github.io/SnpEff/download.html#download) in `Downloads/` folder. In Terminal enter:

```sh
cd ~/Downlaods/SnpEff_CURRENT_VERSION

java -jar SnpEff.jar download GRCh38.76
```

### 3. [Install Julia](https://julialang.org/downloads/). Enter:

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

Add path to julia executable. On a mac add the following to ~/.bash_profile:

```sh
alias julia="/Applications/Julia_CURRENT_VERSION/Contents/Resources/julia/bin/julia
```

### 4. Download [Kraft.jl](https://github.com/KwatME/Kraft.jl/releases/tag/0.0.1) and unzip.


### 5. Install python 2.7 environment.

```sh
conda create --name py2 --yes python=2.7 &&

conda install --name py2 --channel bioconda --yes manta strelka
```

## Run

```sh
jupyter lab
```
