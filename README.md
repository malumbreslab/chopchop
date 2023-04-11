# chopchop

## Description

Pipeline to use chopchop API using command shell.

## Table of contents

- [Workflow](#workflow)
- [Contents of the repository](#contents-of-the-repository)
- [Pipeline](#pipeline)
- [Recomendations](#recomendations)

## Workflow

![This is an image](/images/workflow.png)

## Contents of the repository

- The bash script `chop_pipeline.sh` that can be used for obtaining target sites for CRISPR.
- `config_env.yml` which is a file for create the working enviroment.

The output of this bash script includes:

- `<gen>.txt` which are target sites for CRISPR.

There are other outputs less important such as off-targets sequences.

## Pipeline
  
### Step 1: Clone the repo in your home

If you have not git package installed
  
```
conda install -c anaconda git
```
  
Then clone the entire repository in your local space

```
git clone https://bitbucket.org/valenlab/chopchop.git
cd chopchop
```
  
### Step 2a: Update conda and create the environment

```
conda update --all
conda env create -f config_env.yml
conda activate chopchop
```
If this step doesn´t work, doing step 2b.

### Step 2b: Create new enviroment

```
conda update --all
conda env create -n chopchop
conda activate chopchop
conda install -c anaconda biopython pandas numpy scipy argparse mysql-python scikit-learn=0.18.1
```

### Step 3: Create table

`chopchop.py` will need a [table](http://genome.ucsc.edu/cgi-bin/hgTables?command=start) to look up genomic coordinates if you want to supply names of the genes rather than coordinates. To get example genePred table:

- Select organism and assembly
- Select group: Genes and Gene Predictions
- Select track: RefSeq Genes or Ensemble Genes
- Select table: refGene or ensGene
- Select region: genome
- Select output format: all fields from selected table
- Fill name with extension ".gene_table' e.g. danRer10.gene_table
- Get output

```
mkdir genePred_folder
```
Save `file.gene_table` inside of `genePred_folder`.

### Step 4: Download genome

Download *.2bit compressed [genome](http://hgdownload.soe.ucsc.edu/downloads.html):

- Select organism in complete annotation sets section
- Select Full data set
- download *.2bit file

```
mkdir 2bit_folder
wget -P 2bit_folder http://hgdownload.soe.ucsc.edu/goldenPath/hg38/bigZips/latest/hg38.2bit
```

### Step 5: Download genome

Create fasta version of genome by running twoBitToFa on *.2bit file

``` 
./twoBitToFa 2bit_folder/hg38.2bit hg38.fasta
```

### Step 6: Create bowtie version

Make [bowtie](http://bowtie-bio.sourceforge.net/manual.shtml#the-bowtie-build-indexer) compressed version of genome using your new *.fasta file

```
mkdir ebwt_folder
./bowtie/bowtie-build hg38.fasta ebwt_folder/hg38
```

### Step 6: Create bowtie version

Change `config.json` file, replace paths with your own for .2bit genome files, bowtie (.ewbt) genome files and *.gene_table files

Observe `config.json` in order to see an example.

### Step 7: Permissions

Make sure all these files and programs have proper access rights. You can use the `chmod` command in order to change permissions. Maybe some packages may require compilation for your operating system.

### Step 8: Run pipeline (single gen)

You must run this in your terminal shell and in gen must type the name of the interest gen (be carefull, you must write gene name correctly, some genes have several names, but it is only in one way).

```
./chopchop.py -G hg38 -o results -Target <gen> --scoringMethod DOENCH_2016 -consensusUnion -t CODING > results/<gen>.txt
```
- -G is the genome to search
- -o output folder
- -Target Target genes or regions
- -t Target the whole gene CODING/WHOLE/UTR5/UTR3/SPLICE
- -consensusUnion this option specifies union of isoforms

### Step 9: Run pipeline (several genes)

You must run this in your terminal shell and type interest genes separated by spaces.

```
bash chop_pipeline.sh <gen1> <gen2> <gen3> <gen4>
```
## Recomendations

`chopchop.py` has a lot of funtionalities and arguments that you can change, it would be well for you observe this in the chochop [link](https://bitbucket.org/valenlab/chopchop/src/master/) or doing this:

```
./chopchop.py --help
```
