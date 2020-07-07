# Full analyis

## Intro

The below steps walk you through the full analyses. I have run it and have deposited the results on Sauron under `/usr/people/EDVZ/hahnc/temp/AMEB_2020_practical/BUSCO/full_analysis.tgz`. I don't want to put it on Github since some of these data are not yet published. If you want, you can of course run it also yourself, but the results should be exactly the same. With the configuration I chose the whole analysis took about 8 hours.

If you want to access the results, you can copy them to your Sauron user space like so:
```bash
(user@host)-$ cp /usr/people/EDVZ/hahnc/temp/AMEB_2020_practical/BUSCO/full_analysis.tgz .
``` 
Then decompress the directory:
```bash
(user@host) tar xvfz full_analysis.tgz
```


## Analyses walkthrough
The following assumes that you have run BUSCO on all the genomes you want to include in the analyses and that you have present in the current directory a directory each for the genomes which contain the BUSCO results.

If further assumes that you have cloned this repository and that the path to the `scripts` directory is: `~/AMEB_2020_practical/scripts/`. If this is not the case you need to change the path below.

You should have a file `ingroup.txt` that contains a list of the taxa you consider the ingroup. The names need to correspond to the names of the directories for each taxon. Similarly, there should be a file `outgroup.txt`.

We will now bring together all BUSCO results and evaluate which of the BUSCO genes fullfill our criteria.


```bash
(user@host)-$ ~/AMEB_2020_practical/scripts/evaluate.py \
-i ingroup.txt -o outgroup.txt \
--max_mis_in 4 --max_mis_out 0 --max_avg 2 --max_med 1 \
-f $(find ./ -name "full_table*") \
--outfile summary.tsv 
```

For the course all BUSCO results are gathered in a directory that you should all have access to:
`/usr/people/EDVZ/hahnc/AMEB_2020_practical/BUSCO/`.

So the command should look like this:

```bash
(user@host)-$ ~/AMEB_2020_practical/scripts/evaluate.py \
-i ingroup.txt -o outgroup.txt \
--max_mis_in 4 --max_mis_out 0 --max_avg 2 --max_med 1 \
-f $(find /usr/people/EDVZ/hahnc/AMEB_2020_practical/BUSCO/ -name "full_table*") \
--outfile summary.tsv 
```

This will produce `summary.tsv` which contains the info you want. Have a look.

Next we will extract the IDs of the BUSCOs that passed our criteria and write to a new file.
```bash
(user@host)-$ cat summary.tsv | \
grep "pass$" | \
cut -f 1 > pass.txt
```

Two BUSCO genes cause an error during Alignment trimming. I haven't yet solved the problem so the easiest is to just exclude them from any downstream analyses for now. The IDs of the problematic ones are in the file `problematic.txt`. I exclude them from the file we have created above and write the remainder to a file `ok.txt`.

```bash
(user@host)-$ grep -v -f problematic.txt pass.txt > ok.txt
```

The `Snakefile` I have deposited in this directory runs some of the rules with more threads than we previously did, to speed things up. You'll need a computer/node with at least 32 threads for it to run, so we need to also request more resources from Sauron - see the submission file [here](https://github.com/chrishah/AMEB_2020_practical/blob/master/BUSCO/full_analysis/submit_full_snakemake.sge.sh).

What's left is to enter you Snakemake conda environment.
```bash
(user@host)-$ conda activate snakemake
```

Then submit the job.
```bash
(snakemake) (user@host)-$ qsub submit_full_snakemake.sge.sh
```

