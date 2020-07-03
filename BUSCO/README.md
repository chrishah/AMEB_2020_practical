# Intro

The following assumes that you have run BUSCO on all the genomes you want to include in the analyses and that you have present in the current directory a directory each for the genomes which contain the BUSCO results.

You should have a file `ingroup.txt` that contains a list of the taxa you consider the ingroup. The names need to correspond to the names of the directories for each taxon. Simiarly, there should be a file `outgroup.txt`.

We will now bring together all BUSCO results and evaluate which of the BUSCO genes fullfill our criteria.

```bash
../scripts/evaluate.py \
-i ingroup.txt -o outgroup.txt \
--max_mis_in 3 --max_mis_out 1 --max_avg 2 --max_med 1 \
--outfile summary.tsv \
-f $(find ./ -name "full_table*" | grep -v "pyscaf")
```

For the course all BUSCO results are deposited in a directory that you should all have access to:
`/usr/people/EDVZ/hahnc/AMEB_2020_practical/BUSCO/`.

So the command should look like this:

```bash
../scripts/evaluate.py \
-i ingroup.txt -o outgroup.txt \
--max_mis_in 3 --max_mis_out 1 --max_avg 2 --max_med 1 \
--outfile summary.tsv \
-f $(find /usr/people/EDVZ/hahnc/AMEB_2020_practical/BUSCO/ -name "full_table*" | grep -v "pyscaf")
```

This will produce `summary.tsv` which contains the info you want. Have a look.

Now let's each extract 50 random BUSCOs which have passed our criteria.
```bash
(user@host)-$ cat summary.tsv | \
grep "pass$" | \
cut -f 1 | \
shuf | \
tail -n 50 > my_subset.txt
```

We can now run the pipeline that we've already demonstrated in a previous [session](https://github.com/chrishah/AMEB_HPC_Snakemake).

Prepare a submission script.


```bash
snakemake \
--use-singularity --singularity-args "-B $(pwd) -B /usr/people/EDVZ/hahnc/AMEB_2020_practical/BUSCO/" \
-j 6 -p \
--config \
dir=/usr/people/EDVZ/hahnc/AMEB_2020_practical/BUSCO/ \
ingroup="$(pwd)/ingroup.txt" outgroup="$(pwd)/outgroup.txt" \
files="$(cat my_subset.txt | tr '\n' ' ' | sed 's/ $//')"
```
