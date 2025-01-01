
#note this script shows analysing raw amplicon sequencing data: (output of this script generates otu table, taxonomy per otu and fasta sequence per otu)
#input files are: forwars.fastq(Undetermined_S0_L001_R1_001.fastq) , reverse.fastq(Undetermined_S0_L001_R2_001.fastq) and index.fastq(Undetermined_S0_L001_I1_001.fastq) and barcode file (barcodBacFunOtradPr.txt)
# note: As there were 11 sets of input files to process, step1 to step3 were done per file seperatly and results of all the sets were combined in step4
# basically in step 4 grep were done 11 times and combined all the files together.
# note: if you are downloading the dataset from NCBI () you would need to change first step according to name of demultiplex files

#step1
make.contigs(ffastq=Undetermined_S0_L001_R1_001.fastq, rfastq=Undetermined_S0_L001_R2_001.fastq, rindex=Undetermined_S0_L001_I1_001.fastq, oligos=barcodBacFunOtradPr.txt, bdiffs=2, processors=12)
#step2
screen.seqs(fasta=Undetermined_S0_L001_R1_001.trim.contigs.fasta, contigsreport=Undetermined_S0_L001_R1_001.contigs.report, group=Undetermined_S0_L001_R1_001.contigs.groups, minoverlap=5, maxambig=0, maxhomop=10, minlength=100, maxlength=600, processors=12)
#step3
rename.seqs(fasta=Undetermined_S0_L001_R1_001.trim.contigs.good.fasta, group=Undetermined_S0_L001_R1_001.contigs.good.groups)
#step4
system(grep -A 1 "PrV9." Undetermined_S0_L001_R1_001.trim.contigs.good.renamed.fasta>PrV9.trim.contigs.good.renamed.fasta)
system(grep "PrV9." Undetermined_S0_L001_R1_001.contigs.good.renamed.groups>PrV9.contigs.good.renamed.groups)
#step5
unique.seqs(fasta=PrV9.trim.contigs.good.renamed.fasta)
count.seqs(name=PrV9.trim.contigs.good.renamed.names, group=PrV9.contigs.good.renamed.groups)
chimera.vsearch(fasta=PrV9.trim.contigs.good.renamed.unique.fasta, count=PrV9.trim.contigs.good.renamed.count_table, processors=12)
remove.seqs(accnos=PrV9.trim.contigs.good.renamed.unique.denovo.vsearch.accnos, fasta=PrV9.trim.contigs.good.renamed.unique.fasta, count=PrV9.trim.contigs.good.renamed.count_table)
system(cutadapt -g "ATAACAGGTCTGTGATGCCC;max_error_rate=0.15;min_overlap=5" -o PrV9.trim.contigs.good.renamed.unique.pick.cutadapt1.fasta  PrV9.trim.contigs.good.renamed.unique.pick.fasta --cores=12)
system(cutadapt -a "GTAGGTGAACCTGCAGAAGGATCA;max_error_rate=0.15;min_overlap=5" -m 30 -o PrV9.trim.contigs.good.renamed.unique.pick.cutadapt2.fasta PrV9.trim.contigs.good.renamed.unique.pick.cutadapt1.fasta --cores=12)
list.seqs(fasta=PrV9.trim.contigs.good.renamed.unique.pick.cutadapt2.fasta)
get.seqs(accnos=PrV9.trim.contigs.good.renamed.unique.pick.cutadapt2.accnos, count=PrV9.trim.contigs.good.renamed.pick.count_table)
unique.seqs(fasta=PrV9.trim.contigs.good.renamed.unique.pick.cutadapt2.fasta, count=PrV9.trim.contigs.good.renamed.pick.pick.count_table)
screen.seqs(fasta=PrV9.trim.contigs.good.renamed.unique.pick.cutadapt2.unique.fasta, count=PrV9.trim.contigs.good.renamed.unique.pick.cutadapt2.count_table, minlength=30)
classify.seqs(fasta=PrV9.trim.contigs.good.renamed.unique.pick.cutadapt2.unique.good.fasta, template=Pr_PhiX.fasta, taxonomy=Pr_taxomomy_PhiX.tax, processors=12)

remove.groups(fasta=PrV9.trim.contigs.good.renamed.unique.pick.cutadapt2.unique.good.fasta, count=PrV9.trim.contigs.good.renamed.unique.pick.cutadapt2.count_table, groups=PrV9.A48-PrV9.B37-PrV9.C41-PrV9.D48-PrV9.E18-PrV9.F37-PrV9.G17-PrV9.H42-PrV9.I29-PrV9.J96-PrV9.K11-PrV9.L2-PrV9.M52, taxonomy=PrV9.trim.contigs.good.renamed.unique.pick.cutadapt2.unique.good.Pr_taxomomy_PhiX.wang.taxonomy)

cluster(fasta=PrV9.trim.contigs.good.renamed.unique.pick.cutadapt2.unique.good.pick.fasta, count=PrV9.trim.contigs.good.renamed.unique.pick.cutadapt2.pick.count_table, method=dgc, cutoff=0.03)

split.abund(fasta=PrV9.trim.contigs.good.renamed.unique.pick.cutadapt2.unique.good.pick.fasta, count=PrV9.trim.contigs.good.renamed.unique.pick.cutadapt2.pick.count_table, list=PrV9.trim.contigs.good.renamed.unique.pick.cutadapt2.unique.good.pick.dgc.list, cutoff=50)

classify.otu(taxonomy=PrV9.trim.contigs.good.renamed.unique.pick.cutadapt2.unique.good.Pr_taxomomy_PhiX.wang.pick.taxonomy, list=PrV9.trim.contigs.good.renamed.unique.pick.cutadapt2.unique.good.pick.dgc.0.03.abund.list, count=PrV9.trim.contigs.good.renamed.unique.pick.cutadapt2.pick.0.03.abund.count_table)

make.shared(list=PrV9.trim.contigs.good.renamed.unique.pick.cutadapt2.unique.good.pick.dgc.0.03.abund.list, count=PrV9.trim.contigs.good.renamed.unique.pick.cutadapt2.pick.0.03.abund.count_table)

remove.lineage(constaxonomy=PrV9.trim.contigs.good.renamed.unique.pick.cutadapt2.unique.good.pick.dgc.0.03.abund.0.03.cons.taxonomy, shared=PrV9.trim.contigs.good.renamed.unique.pick.cutadapt2.unique.good.pick.dgc.0.03.abund.shared, taxon=unknown-PhiX-Arabidopsis-mitochondria-Chloroplast-Embryophyceae)

get.oturep(fasta=PrV9.trim.contigs.good.renamed.unique.pick.cutadapt2.unique.good.pick.0.03.abund.fasta, list=PrV9.trim.contigs.good.renamed.unique.pick.cutadapt2.unique.good.pick.dgc.0.03.abund.list, count=PrV9.trim.contigs.good.renamed.unique.pick.cutadapt2.pick.0.03.abund.count_table, method=abundance)




