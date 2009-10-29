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
  my @aligned_cruciforms;
  $score = $words[5];
  $align = $words[3];
  $align_length = length($align);
#  print "H: P:$position S $score A:$align\n";
  push(@aligned_cruciforms,$qlines[$i]);
  for($j=0;$j<=$#genomes;$j++) {
   
   $aligned_line =   get_aligned_line($position-10000,$position+10000,$j);
   if($aligned_line) {
     push(@aligned_cruciforms,$aligned_line);
   @aligned_words = split(/\W+/,$aligned_line);
   $a_position = $aligned_words[1];
   $a_score = $aligned_words[5];
   $a_align = $aligned_words[3];
   $a_align_length = length($a_align);
#   print "$j: P:$a_position S $a_score A:$a_align\n";
   }

  }
  if($#aligned_cruciforms >1) {
    for(my $k=0;$k<=$#aligned_cruciforms;$k++) {
	print_cruciform($k,$aligned_cruciforms[$k]);
    }
    get_cruciform_score(\@aligned_cruciforms);
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

sub print_cruciform {
  my $id = shift;
  my $line = shift;
  my @words = split(/\W+/,$line);
  my $position = $words[1];
  my $align = $words[3];
  my $score = length($align);
  print "$id: $position $score $align \n";

}

sub get_cruciform_score {
   my $ref = shift;
  my $score = 0;
   my @cruciforms = @$ref;
   my @clabels;
   for(my $i = 0; $i<=$#cruciforms;$i++) {
     my @words = split(/\W+/,$cruciforms[$i]);
     $clabels[$i] =  $words[3];
     $clabels[$i] =~ s/L//g;
     $clabels[$i] =~ s/G//g;
     $clabels[$i] = reverse($clabels[$i]);
   }
   for(my $j =0;$j < length($clabels[0]);$j++) {
    for(my $i = 0; $i<=$#clabels;$i++) {
        if(substr($clabels[$i],$j,1) eq "M") { $score++;} 
	print substr($clabels[$i],$j,1)." "; 
    }
    print " $score\n";
   }
   $score = $score/($#clabels+1);
   print "Score :$score\n";

}
