#!/bin/bash

# ==============================================================================
START=$(date +%s)

# ==============================================================================
. "$(dirname $0)/functions.sh"

# ==============================================================================
DATA_DIR=$1

N_JOB=$2

GB_MEMORY=$3

GERM_1_FQ_GZ=$4

check_path $GERM_1_FQ_GZ

GERM_2_FQ_GZ=$5

check_path $GERM_2_FQ_GZ

if [[ "$6" =~ ^(genome|exome)$ ]]; then

  SEQUENCING_SCOPE=$6

else

  echo "Sequencing scope is not either \"genome\" or \"exome\"." >&2

  exit 1

fi

OUTPUT_DIR=$7

# ==============================================================================
ready $DATA_DIR $N_JOB $GB_MEMORY

# ==============================================================================
mkdir $OUTPUT_DIR

SKEWER_DIR=$OUTPUT_DIR/skewer

mkdir $SKEWER_DIR

FASTQC_DIR=$OUTPUT_DIR/fastqc

mkdir $FASTQC_DIR

MINIMAP2_DIR=$OUTPUT_DIR/minimap2

mkdir $MINIMAP2_DIR

GERM_BAM=$MINIMAP2_DIR/germ.bam

MANTA_DIR=$OUTPUT_DIR/manta

STRELKA_DIR=$OUTPUT_DIR/strelka

SNPEFF_DIR=$OUTPUT_DIR/snpeff

mkdir $SNPEFF_DIR

# ==============================================================================
trim_sequence $GERM_1_FQ_GZ $GERM_2_FQ_GZ $SKEWER_DIR/germ

GERM_TRIM_1_FQ_GZ=$SKEWER_DIR/germ-trimmed-pair1.fastq.gz

GERM_TRIM_2_FQ_GZ=$SKEWER_DIR/germ-trimmed-pair2.fastq.gz

# ==============================================================================
check_sequence $FASTQC_DIR $GERM_TRIM_1_FQ_GZ $GERM_TRIM_2_FQ_GZ

# ==============================================================================
align_sequence $GERM_TRIM_1_FQ_GZ $GERM_TRIM_2_FQ_GZ Germ $GERM_BAM

# ==============================================================================
find_mutation $GERM_BAM " " $SEQUENCING_SCOPE $MANTA_DIR $STRELKA_DIR $SNPEFF_DIR

# ==============================================================================
END=$(date +%s)

print_header "Done in $((END-START)) second."
