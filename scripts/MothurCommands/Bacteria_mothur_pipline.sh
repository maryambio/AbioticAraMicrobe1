#note this script shows analysing raw amplicon sequencing data:(output of this script generates otu table, taxonomy per otu and fasta sequence per otu)
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
system(grep -A 1 "BacV5." Undetermined_S0_L001_R1_001.trim.contigs.good.renamed.fasta > BacV5.trim.contigs.good.renamed.fasta)
system(grep "BacV5." Undetermined_S0_L001_R1_001.contigs.good.renamed.groups > BacV5.contigs.good.renamed.groups)

#next steps

unique.seqs(fasta=BacV5.trim.contigs.good.renamed.fasta)
count.seqs(name=BacV5.trim.contigs.good.renamed.names, group=BacV5.contigs.good.renamed.groups)
chimera.vsearch(fasta=BacV5.trim.contigs.good.renamed.unique.fasta, count=BacV5.trim.contigs.good.renamed.count_table, processors=12)
remove.seqs(accnos=BacV5.trim.contigs.good.renamed.unique.denovo.vsearch.accnos, fasta=BacV5.trim.contigs.good.renamed.unique.fasta, count=BacV5.trim.contigs.good.renamed.count_table)
system(cutadapt -g "AACMGGATTAGATACCCKG;max_error_rate=0.15;min_overlap=5" -o BacV5.trim.contigs.good.renamed.unique.pick.cutadapt1.fasta  BacV5.trim.contigs.good.renamed.unique.pick.fasta --cores=12)
system(cutadapt -a "GGAAGGTGGGGATGACGT;max_error_rate=0.15;min_overlap=5" -m 30 -o BacV5.trim.contigs.good.renamed.unique.pick.cutadapt2.fasta BacV5.trim.contigs.good.renamed.unique.pick.cutadapt1.fasta --cores=12)
list.seqs(fasta=BacV5.trim.contigs.good.renamed.unique.pick.cutadapt2.fasta)
get.seqs(accnos=BacV5.trim.contigs.good.renamed.unique.pick.cutadapt2.accnos, count=BacV5.trim.contigs.good.renamed.pick.count_table)
unique.seqs(fasta=BacV5.trim.contigs.good.renamed.unique.pick.cutadapt2.fasta, count=BacV5.trim.contigs.good.renamed.pick.pick.count_table)
screen.seqs(fasta=BacV5.trim.contigs.good.renamed.unique.pick.cutadapt2.unique.fasta, count=BacV5.trim.contigs.good.renamed.unique.pick.cutadapt2.count_table, minlength=30)
classify.seqs(fasta=BacV5.trim.contigs.good.renamed.unique.pick.cutadapt2.unique.good.fasta, template=silva_138_1_phiX.fasta, taxonomy=silva_138_1_phiX.tax, processors=12) # Silva databace were used 

remove.groups(fasta=BacV5.trim.contigs.good.renamed.unique.pick.cutadapt2.unique.good.fasta, count=BacV5.trim.contigs.good.renamed.unique.pick.cutadapt2.count_table, groups=BacV5.A48-BacV5.B37-BacV5.C41-BacV5.D48-BacV5.E18-BacV5.F37-BacV5.G17-BacV5.H42-BacV5.I29-BacV5.J96-BacV5.K11-BacV5.L2-BacV5.M52, taxonomy=BacV5.trim.contigs.good.renamed.unique.pick.cutadapt2.unique.good.gg_13_8_99_phiX.wang.taxonomy)

cluster(fasta=BacV5.trim.contigs.good.renamed.unique.pick.cutadapt2.unique.good.pick.fasta, count=BacV5.trim.contigs.good.renamed.unique.pick.cutadapt2.pick.count_table, method=dgc, cutoff=0.03)

split.abund(fasta=BacV5.trim.contigs.good.renamed.unique.pick.cutadapt2.unique.good.pick.fasta, count=BacV5.trim.contigs.good.renamed.unique.pick.cutadapt2.pick.count_table, list=BacV5.trim.contigs.good.renamed.unique.pick.cutadapt2.unique.good.pick.dgc.list, cutoff=50)

classify.otu(taxonomy=BacV5.trim.contigs.good.renamed.unique.pick.cutadapt2.unique.good.silva_138_1_phiX.wang.pick.taxonomy, list=BacV5.trim.contigs.good.renamed.unique.pick.cutadapt2.unique.good.pick.dgc.0.03.abund.list, count=BacV5.trim.contigs.good.renamed.unique.pick.cutadapt2.pick.0.03.abund.count_table)
make.shared(list=BacV5.trim.contigs.good.renamed.unique.pick.cutadapt2.unique.good.pick.dgc.0.03.abund.list, count=BacV5.trim.contigs.good.renamed.unique.pick.cutadapt2.pick.0.03.abund.count_table)

remove.lineage(constaxonomy=BacV5.trim.contigs.good.renamed.unique.pick.cutadapt2.unique.good.pick.dgc.0.03.abund.0.03.cons.taxonomy, shared=BacV5.trim.contigs.good.renamed.unique.pick.cutadapt2.unique.good.pick.dgc.0.03.abund.shared, taxon=unknown-mitochondria-Chloroplast-PhiX)

get.oturep(fasta=BacV5.trim.contigs.good.renamed.unique.pick.cutadapt2.unique.good.pick.0.03.abund.fasta, list=BacV5.trim.contigs.good.renamed.unique.pick.cutadapt2.unique.good.pick.dgc.0.03.abund.list, count=BacV5.trim.contigs.good.renamed.unique.pick.cutadapt2.pick.0.03.abund.count_table, method=abundance)
