using Kraft: print_and_run_cmd


for program in (
    "skewer",
    "fastqc",
    "bgzip",
    "tabix",
    "minimap2",
    "samtools",
    "configManta.py",
    "configureStrelkaGermlineWorkflow.py",
    "configureStrelkaSomaticWorkflow.py",
    "bcftools",
    "snpEff",
    "kallisto",
)

    print_and_run_cmd(`which $program`)

end
