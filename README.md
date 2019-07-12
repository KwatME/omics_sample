# Sample Template

Sample :bust_in_silhouette: template :kimono:

```sh
PATH="`pwd`/environment/manta-1.5.0.centos6_x86_64/bin:`pwd`/environment/strelka-2.9.10.centos6_x86_64/bin:$PATH"
```

## Reference

-   <https://www.nature.com/articles/s41587-019-0054-x>
-   <http://lh3.github.io/2017/11/13/which-human-reference-genome-to-use>
-   ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/001/405/GCA_000001405.15_GRCh38/seqs_for_alignment_pipelines.ucsc_ids
-   ftp://ftp.ensembl.org/pub/release-95/fasta/homo_sapiens/cdna/Homo_sapiens.GRCh38.cdna.all.fa.gz
-   ftp://ftp.ncbi.nlm.nih.gov/refseq/release/viral/
-   <https://github.com/Illumina/manta>
-   <https://academic.oup.com/bioinformatics/article/32/8/1220/1743909>
-   <https://github.com/Illumina/strelka>
-   <https://www.nature.com/articles/s41592-018-0051-x>
-   ftp://ftp.ncbi.nih.gov/gene/
-   <https://www.ncbi.nlm.nih.gov/books/NBK21091/table/ch18.T.refseq_accession_numbers_and_mole/?report=objectonly>
-   ftp://ftp.ncbi.nlm.nih.gov/genomes/GENOME_REPORTS/
-   <https://www.nature.com/articles/nbt.3519>
-   <https://www.sevenbridges.com/centrifuge/>
-   <https://www.frontiersin.org/articles/10.3389/fmicb.2018.01172/full>
-   <https://github.com/ICBI/viGEN/>
-   <https://www.ncbi.nlm.nih.gov/genome/viruses/>
-   <https://support.illumina.com/downloads/illumina-adapter-sequences-document-1000000002694.html>
-   <https://github.com/genome-in-a-bottle/giab_latest_release>
-   ftp://ftp-trace.ncbi.nlm.nih.gov/giab/ftp/release

<br>

Shareable Project powered by [Guardiome](https://guardiome.com)

<img src="stuff/guardiome_logo.png" width="150" height="150">

  "environment": [
    "conda install --prefix PROJECT_ENVIRONMENT_DIRECTORY_PATH --channel conda-forge --yes jupyterlab julia",
    "conda install --prefix PROJECT_ENVIRONMENT_DIRECTORY_PATH --channel bioconda --yes skewer fastqc minimap2 htslib samtools bcftools snpeff kallisto"
  ],