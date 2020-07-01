
# Merge paired end reads

## FLASh

### Installation
```bash
cd src/
mkdir FLASh
cd FLASh/
wget http://ccb.jhu.edu/software/FLASH/FLASH-1.2.11-Linux-x86_64.tar.gz
tar xvfz FLASH-1.2.11-Linux-x86_64.tar.gz 
cd FLASH-1.2.11-Linux-x86_64/
#add directory to PATH
echo -e "\nexport PATH=\$PATH:$(pwd)" >> ~/.bash_profile
cd ~/
```

### Example
```bash
flash -z -o your_sample \
~/AMEB_2020_practical/NGS-data/Illumina/Gyrodactylus.1.fastq.gz \
~/AMEB_2020_practical/NGS-data/Illumina/Gyrodactylus.2.fastq.gz 
```

# Genome assembly

## Minia

### Installation
```bash
mkdir minia
cd minia/
wget https://github.com/GATB/minia/releases/download/v3.2.4/minia-v3.2.4-bin-Linux.tar.gz
tar xvfz minia-v3.2.4-bin-Linux.tar.gz
cd minia-v3.2.4-bin-Linux/
cd bin/
#add directory to PATH
echo -e "\nexport PATH=\$PATH:$(pwd)" >> ~/.bash_profile 
cd ~/
```
### Example
```
minia \
-in ~/AMEB_2020_practical/NGS-data/Illumina/Gyrodactylus.1.fastq.gz \
-in ~/AMEB_2020_practical/NGS-data/Illumina/Gyrodactylus.2.fastq.gz \
-kmer-size 31 -out minia_mysample_k31 -nb-cores 5
```

## platanus

### Example
```bash
prefix=Gyroplat

singularity run -B $(pwd) docker://chrishah/platanus:v1.2.4 \
platanus assemble \
-o $prefix \
-f <(zcat ~/AMEB_2020_practical/NGS-data/Illumina/Gyrodactylus.1.fastq.gz) <(zcat ~/AMEB_2020_practical/NGS-data/Illumina/Gyrodactylus.2.fastq.gz) \
-t 8 \
-m 20

singularity run -B $(pwd) docker://chrishah/platanus:v1.2.4 \
platanus scaffold \
-o $prefix \
-c $prefix\_contig.fa \
-b $prefix\_contigBubble.fa \
-IP1 <(zcat ~/AMEB_2020_practical/NGS-data/Illumina/Gyrodactylus.1.fastq.gz) <(zcat ~/AMEB_2020_practical/NGS-data/Illumina/Gyrodactylus.2.fastq.gz) \
-t 8

singularity run -B $(pwd) docker://chrishah/platanus:v1.2.4 \
platanus gap_close \
-o $prefix \
-c $prefix\_scaffold.fa \
-IP1 <(zcat ~/AMEB_2020_practical/NGS-data/Illumina/Gyrodactylus.1.fastq.gz) <(zcat ~/AMEB_2020_practical/NGS-data/Illumina/Gyrodactylus.2.fastq.gz) \
-t 8
```

## Spades

### Example
```bash
prefix=GyroSpades
mkdir $prefix

singularity run docker://chrishah/spades:v3.14.0 \
spades.py \
-o ./$prefix \
-1 ~/AMEB_2020_practical/NGS-data/Illumina/Gyrodactylus.1.fastq.gz \
-2 ~/AMEB_2020_practical/NGS-data/Illumina/Gyrodactylus.2.fastq.gz \
--only-assembler \
--checkpoints last \
-t 8 \
-m 20

```


# Assess assemblies

## quast

### Example
```bash
singularity run docker://reslp/quast:5.0.2 quast.py minia_assembly_k31.contigs.fa
```
