# Program: get_aligned_cruciform.pl
# Developed by: Anoop Kumar
# Date: 10/26/09
# Description: The program takes the output from find_cruciform,compares them to mouse and rat genomes and reports conserved cruciforms

$query_file = "1_YAC801B6_min40_max200_best.txt";
@genomes = ("mouse","rat");


open(QUERY,$query_file);
@qlines = <QUERY>;
close QUERY;

#load all genomes.  Will work for small datasets;
for($i=0;$i<=$#genomes;$i++) {
 open(GENOME,$genomes[$i]."_min40max200_best.txt");
 my @genome_lines = <GENOME>;
 close GENOME;
 my $ref =  \@genome_lines;
 $all_genomes[$i] = \@genome_lines;
}

for(my $i=0;$i<=$#qlines;$i++) {
  my @words = split(/\W+/,$qlines[$i]);
  my $position = $words[1];
  $score = $words[5];
  $align = $words[3];
  $align_length = length($align);
  print "H: P:$position S $score A:$align\n";
  for($j=0;$j<=$#genomes;$j++) {
   $aligned_line =   get_aligned_line($position-10000,$position+10000,$j);
   if($aligned_line) {
   @aligned_words = split(/\W+/,$aligned_line);
   $a_position = $aligned_words[1];
   $a_score = $aligned_words[5];
   $a_align = $aligned_words[3];
   $a_align_length = length($a_align);
   print "$j: P:$a_position S $a_score A:$a_align\n";
   }
  }
  
} 

sub get_aligned_line {
  my $start = shift;
  my $stop = shift;
  my $genome_id = shift;
  my $ref = $all_genomes[$genome_id];
  @lines =  @$ref;
  for(my $i=0;$i<=$#lines;$i++) {
    my @words = split(/\W+/,$lines[$i]);
    my $position = $words[1];
#    print "Working on $genome_id $i $position $start $stop \n";
    if( ($position >= $start) && ($position <= $stop)) {
 	return $lines[$i];
    } elsif($position > $stop) {
	return 0;
    } 

  }  
  return 0;


}
