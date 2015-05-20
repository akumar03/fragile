# Program: submit_job.pl
# Developed by: Anoop Kumar
# Date: 05/04/2015
# Description: The program runs fragile sequence computation on Slurm Cluster
#
#!/bin/bash

$| = 1;

$seq_folder =  "/cluster/home/akumar03/fragile/data/hg18_chr16_78008602_79008602/";
$seq_file = "hg38_chr16_78008602_79008602.fasta";
$out_folder = "/cluster/home/akumar03/fragile/data/hg18_chr16_78008602_79008602/";
$START = 0;
$STOP = 1000000;
$STEP = 100000;

for($i = $START;$i<$STOP;$i += $STEP) {
	$status_file = $out_folder.$seq_file."status_$i.st";
	$out_file = $out_folder.$seq_file."_$i.txt";
	$end = $i+$STEP;
	my $s="#!/bin/bash\n";
	$s.="#SBATCH --partition=batch\n";
	$s.="#SBATCH --nodes=1\n";
	$s.="#SBATCH --ntasks-per-node=1\n";
	$s.="#SBATCH --mem=4000\n";
	$s.="perl /cluster/home/akumar03/fragile/code/fragile/find_cruciform.pl  $seq_folder$seq_file $status_file $i $end > $out_file\n";
	$batch_file  = $out_folder.$seq_file."_$i.sh";	
	open(BATCH, '>'.$batch_file);
	print BATCH $s;
	close BATCH;
	$cmd = "sbatch $batch_file";	
	print "Running $cmd\n";
	`$cmd`;
}

