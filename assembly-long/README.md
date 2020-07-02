# Assembler

## Canu

### Installation
```bash
cd ~
cd src
mkdir CANU
cd CANU
wget https://github.com/marbl/canu/archive/end-of-big-meryl.tar.gz
tar xfvz end-of-big-meryl.tar.gz
cd canu-end-of-big-meryl/
cd src/
make -j 8
cd ../Linux-amd64/bin/
#add directory to PATH
echo -e "\nexport PATH=\$PATH:$(pwd)" >> ~/.bash_profile

```

### Example
```bash
canu -d Dcoe -p Dcoe \
useGrid=0 -genomeSize=100M \
-nanopore ./MinION-data/*.fastq.gz
```

## pyScaf

# Example
```bash
singularity run -B $(pwd) docker://chrishah/pyscaf-docker \
pyScaf.py \
-t 6 -f genome.illumina.fasta -n reads.fastq.gz -o Illumina.MinION.pyscaf.fasta
```
