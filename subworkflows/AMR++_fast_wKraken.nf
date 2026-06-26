include { FASTQ_QC_WF } from "$baseDir/subworkflows/fastq_information.nf"
include { FASTQ_TRIM_WF } from "$baseDir/subworkflows/fastq_QC_trimming.nf"
include { FASTQ_RESISTOME_WF } from "$baseDir/subworkflows/fastq_resistome.nf"
include { FASTQ_KRAKEN_WF } from "$baseDir/subworkflows/fastq_microbiome.nf"

workflow FAST_AMRplusplus_wKraken {
    take: 
        read_pairs_ch
        amr
        annotation

    main:
        // fastqc
        FASTQ_QC_WF( read_pairs_ch )
        // runqc trimming
        FASTQ_TRIM_WF(read_pairs_ch)
        // AMR alignment (no host removal)
        FASTQ_RESISTOME_WF(FASTQ_TRIM_WF.out.trimmed_reads, amr, annotation)
        // Microbiome analysis on trimmed reads
        FASTQ_KRAKEN_WF(FASTQ_TRIM_WF.out.trimmed_reads)

}
