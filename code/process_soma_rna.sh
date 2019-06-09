#!/bin/bash

# ==============================================================================
START=$(date +%s)

# ==============================================================================
. "$(dirname $0)/functions.sh"

# ==============================================================================
DATA_DIR=$1

N_JOB=$2

GB_MEMORY=$3

_1_FQ_GZ=$4

check_path $_1_FQ_GZ

_2_FQ_GZ=$5

check_path $_2_FQ_GZ

OUTPUT_DIR=$6

# ==============================================================================
ready $DATA_DIR $N_JOB $GB_MEMORY

mkdir $OUTPUT_DIR

SKEWER_DIR=$OUTPUT_DIR/skewer

mkdir $SKEWER_DIR

FASTQC_DIR=$OUTPUT_DIR/fastqc

mkdir $FASTQC_DIR

KALLISTO_DIR=$OUTPUT_DIR/kallisto

mkdir $KALLISTO_DIR

# ==============================================================================
trim_sequence $_1_FQ_GZ $_2_FQ_GZ $SKEWER_DIR/

TRIM_1_FQ_GZ=$SKEWER_DIR/trimmed-pair1.fastq.gz

TRIM_2_FQ_GZ=$SKEWER_DIR/trimmed-pair2.fastq.gz

# ==============================================================================
check_sequence $FASTQC_DIR $TRIM_1_FQ_GZ $TRIM_2_FQ_GZ

# ==============================================================================
REFERENCE=transcriptome

count_transcript $REFERENCE $TRIM_1_FQ_GZ $TRIM_2_FQ_GZ $KALLISTO_DIR/$REFERENCE

REFERENCE=virus

count_transcript $REFERENCE $TRIM_1_FQ_GZ $TRIM_2_FQ_GZ $KALLISTO_DIR/$REFERENCE

# ==============================================================================
END=$(date +%s)

print_header "Done in $((END-START)) second."
