#!/bin/bash

set -e


function check_n_argument {

  local N_ARGUMENT=$1

  local N_REQUIRED_ARGUMENT=$2

  if [[ $N_ARGUMENT != "$N_REQUIRED_ARGUMENT" ]]; then

    echo "The number of argument ($N_ARGUMENT) is not $N_REQUIRED_ARGUMENT." >&2

    exit 1

  fi

}


function print_header {

  local TEXT=$1

  printf "\n==============================================================================\n"

  printf "$TEXT\n"

  printf "==============================================================================\n"

}


function check_path {

  local PATH=$1

  if [[ ! -e $PATH ]]; then

    echo "$PATH does not exist." >&2

    exit 1

  fi

}


function ready {

  print_header "Getting ready ..."

  local DATA_DIR=$1

  local N_JOB=$2

  local GB_MEMORY=$3

  check_path $DATA_DIR

  type skewer

  type fastqc

  DNA_FA_GZ=$DATA_DIR/grch/GCA_000001405.15_GRCh38_no_alt_analysis_set.fna.gz

  check_path $DNA_FA_GZ

  type minimap2

  DNA_FA_GZ_MMI=$DNA_FA_GZ.mmi

  if [[ ! -e $DNA_FA_GZ_MMI ]]; then

    minimap2 -d $DNA_FA_GZ_MMI -t $N_JOB $DNA_FA_GZ

  fi

  type bgzip

  type samtools

  DNA_FA_BGZ=${DNA_FA_GZ::-3}.bgz

  if [[ ! -e $DNA_FA_BGZ ]]; then

    gzip --decompress --stdout $DNA_FA_GZ | bgzip --stdout --threads $N_JOB > $DNA_FA_BGZ

  fi

  if [[ ! -e $DNA_FA_BGZ.fai ]] || [[ ! -e $DNA_FA_BGZ.gzi ]]; then

    samtools faidx $DNA_FA_BGZ

  fi

  source activate py2.7

  type configManta.py

  type configureStrelkaGermlineWorkflow.py

  type configureStrelkaSomaticWorkflow.py

  conda deactivate

  CHROMOSOME_BED_GZ=$DATA_DIR/grch/chromosome.bed.gz

  check_path $CHROMOSOME_BED_GZ

  type tabix

  if [[ ! -e $CHROMOSOME_BED_GZ.tbi ]]; then

    tabix $CHROMOSOME_BED_GZ

  fi

  type bcftools

  CHRN_N_TSV=$DATA_DIR/grch/chrn_n.tsv

  check_path $CHRN_N_TSV

  type snpEff

  type kallisto

  CDNA_FA_GZ=$DATA_DIR/grch/Homo_sapiens.GRCh38.cdna.all.fa.gz

  check_path $CDNA_FA_GZ

  CDNA_FA_GZ_KI=$CDNA_FA_GZ.ki

  if [[ ! -e $CDNA_FA_GZ_KI ]]; then

    kallisto index --index $CDNA_FA_GZ_KI $CDNA_FA_GZ

  fi

  check_path $DATA_DIR/grch/enst_gene_name.tsv

  VIRUS_CDNA_FA_GZ=$DATA_DIR/virus/sequences.fasta

  check_path $VIRUS_CDNA_FA_GZ

  VIRUS_CDNA_FA_GZ_KI=$VIRUS_CDNA_FA_GZ.ki

  if [[ ! -e $VIRUS_CDNA_FA_GZ_KI ]]; then

    kallisto index --index $VIRUS_CDNA_FA_GZ_KI $VIRUS_CDNA_FA_GZ

  fi

  check_path $DATA_DIR/virus/sequences.csv

}


function trim_sequence {

  print_header "Trimming sequence ..."

  local _1_FQ_GZ=$1

  local _2_FQ_GZ=$2

  local OUTPUT_DIR=$3

  skewer --threads $N_JOB -x AGATCGGAAGAGC --compress --output $OUTPUT_DIR $_1_FQ_GZ $_2_FQ_GZ

}


function check_sequence {

  print_header "Checking sequence ..."

  local OUTPUT_DIR=$1

  local FQ_GZS=${*:2}

  fastqc --threads $N_JOB --outDir $OUTPUT_DIR $FQ_GZS

}


function align_sequence {

  print_header "Aligning sequence ..."

  local _1_FQ_GZ=$1

  local _2_FQ_GZ=$2

  local SAMPLE_NAME=$3

  local BAM=$4

  minimap2 -x sr -t $N_JOB -R "@RG\tID:$SAMPLE_NAME\tSM:$SAMPLE_NAME" -a $DNA_FA_GZ_MMI $_1_FQ_GZ $_2_FQ_GZ | samtools sort -n --threads $N_JOB -m 512M | samtools fixmate -m --threads $N_JOB - - | samtools sort --threads $N_JOB -m 512M > /tmp/no_markdup.bam

  samtools markdup -s --threads $N_JOB /tmp/no_markdup.bam $BAM

  rm --force /tmp/no_markdup.bam

  samtools index -@ $N_JOB $BAM

  samtools flagstat --threads $N_JOB $BAM > $BAM.flagstat

}


function find_mutation {

  print_header "Finding mutation ..."

  local GERM_BAM=$1

  local SOMA_BAM=$2

  local SEQUENCING_SCOPE=$3

  local MANTA_DIR=$4

  local STRELKA_DIR=$5

  local SNPEFF_DIR=$6

  local CONFIG_PARAMETERS="--referenceFasta $DNA_FA_BGZ --callRegions $CHROMOSOME_BED_GZ --$SEQUENCING_SCOPE"

  if [[ -e $GERM_BAM && -e $SOMA_BAM ]]; then

    CONFIG_PARAMETERS="$CONFIG_PARAMETERS --normalBam $GERM_BAM --tumorBam $SOMA_BAM"

  elif [[ -e $GERM_BAM ]]; then

    CONFIG_PARAMETERS="$CONFIG_PARAMETERS --bam $GERM_BAM"

  else

    echo "Arguments do not contain either germ and soma .bams or germ .bam." >&2

    exit 1

  fi

  local RUN_PARAMETERS="--mode local --jobs $N_JOB --memGb $GB_MEMORY --quiet"

  source activate py2.7

  configManta.py $CONFIG_PARAMETERS --outputContig --runDir $MANTA_DIR

  $MANTA_DIR/runWorkflow.py $RUN_PARAMETERS

  if [[ -e $GERM_BAM && -e $SOMA_BAM ]]; then

    configureStrelkaSomaticWorkflow.py $CONFIG_PARAMETERS --runDir $STRELKA_DIR --indelCandidates $MANTA_DIR/results/variants/candidateSmallIndels.vcf.gz

  else

    configureStrelkaGermlineWorkflow.py $CONFIG_PARAMETERS --runDir $STRELKA_DIR

  fi

  $STRELKA_DIR/runWorkflow.py $RUN_PARAMETERS

  conda deactivate

  if [[ -e $GERM_BAM && -e $SOMA_BAM ]]; then

    local INDEL_VCF_GZ=$STRELKA_DIR/results/variants/somatic.indels.vcf.gz

    local SNV_VCF_GZ=$STRELKA_DIR/results/variants/somatic.snvs.vcf.gz

    local STRELKA_SOMA_SAMPLE_NAME_TXT=/tmp/strelka_soma_sample_name.txt

    touch $STRELKA_SOMA_SAMPLE_NAME_TXT

    echo "Germ" >> $STRELKA_SOMA_SAMPLE_NAME_TXT

    echo "Soma" >> $STRELKA_SOMA_SAMPLE_NAME_TXT

    bcftools reheader --threads $N_JOB --samples $STRELKA_SOMA_SAMPLE_NAME_TXT $INDEL_VCF_GZ > /tmp/indel.vcf.gz

    mv --force /tmp/indel.vcf.gz $INDEL_VCF_GZ

    tabix --force $INDEL_VCF_GZ

    bcftools reheader --threads $N_JOB --samples $STRELKA_SOMA_SAMPLE_NAME_TXT $SNV_VCF_GZ > /tmp/snv.vcf.gz

    mv --force /tmp/snv.vcf.gz $SNV_VCF_GZ

    tabix --force $SNV_VCF_GZ

    rm --force $STRELKA_SOMA_SAMPLE_NAME_TXT

    local CONCAT_VCFS="$MANTA_DIR/results/variants/somaticSV.vcf.gz $INDEL_VCF_GZ $SNV_VCF_GZ"

  else

    local CONCAT_VCFS="$MANTA_DIR/results/variants/diploidSV.vcf.gz $STRELKA_DIR/results/variants/variants.vcf.gz"

  fi

  bcftools concat --allow-overlaps --threads $N_JOB $CONCAT_VCFS | bcftools annotate --rename-chrs $CHRN_N_TSV --threads $N_JOB | bgzip --stdout --threads $N_JOB > /tmp/concat.vcf.gz

  tabix /tmp/concat.vcf.gz

  snpEff -Xms${GB_MEMORY}g -Xmx${GB_MEMORY}g GRCh38.86 -verbose -noLog -csvStats $SNPEFF_DIR/stats.csv -htmlStats $SNPEFF_DIR/stats.html /tmp/concat.vcf.gz | bgzip --stdout --threads $N_JOB > $SNPEFF_DIR/variant.vcf.gz

  tabix $SNPEFF_DIR/variant.vcf.gz

  rm --force /tmp/concat.vcf.gz /tmp/concat.vcf.gz.tbi

}


function count_transcript {

  print_header "Counting transcript ..."

  local REFERENCE=$1

  local _1_FQ_GZ=$2

  local _2_FQ_GZ=$3

  local OUTPUT_DIR=$4

  if [[ $REFERENCE = "transcriptome" ]]; then

    local KI=$CDNA_FA_GZ_KI

  elif [[ $REFERENCE = "virus" ]]; then

    local KI=$VIRUS_CDNA_FA_GZ_KI

  else

    echo "Reference is not either 'transcriptome' or 'virus'." >&2

    exit 1

  fi

  kallisto quant --index $KI --output-dir $OUTPUT_DIR --threads $N_JOB $_1_FQ_GZ $_2_FQ_GZ

}
