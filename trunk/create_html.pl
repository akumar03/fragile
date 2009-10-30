# Program: create_html.pl
# Developed by: Anoop Kumar
# Date: 10/02/09
# Description: The program takes the output from find_cruciform and generates an html file

$result_file = $ARGV[0];
open(DAT,$result_file);
@lines = <DAT>;
close DAT;

@genomes = ("mouse","rat");
for($i=0;$i<=$#genomes;$i++) {
 open(GENOME,$genomes[$i]."_min40max200_best.txt");
 my @genome_lines = <GENOME>;
 close GENOME;
 my $ref =  \@genome_lines;
 $all_genomes[$i] = \@genome_lines;
}


print "<html><head><title>List of Cruciforms</title></head><body><b>Cruciforms for ".$result_file."<br />";
print "<table border=1><th><tr><td>Position</td><td>Sequence</td><td>Size</td><td>Cruciform</td><td>Score</td></tr></th>";
$best_line ="";
$best_score = 0;
$current_position = 130771;
for(my $i=0;$i<=$#lines;$i++) {
   my @words = split(/\W+/,$lines[$i]);
   my $position = $words[1];
   my $score = $words[5];
#   print "$i S$score $best_score P:$position CP:$current_position\n";
   print format_line($lines[$i]);
}
print "</table></body></html>";

sub format_line {
  my $line = shift;
  my @words = split(/\W+/,$line);
  my $r = "<tr><td>".$words[1]."</td><td>".$words[2]."</td><td>".length($words[2])."</td><td>";
  $r .= "<a href=\"http://bcb.cs.tufts.edu/fragile/display_cruciform.php?fragment=".$words[2];
  $r .= "&alignment_left=".$words[3];
  $r .= "&alignment_right=".$words[4];
  $r .= "\">View</a></td>";
  my @alines;
  my $cscore = 0;
  push(my @alines,$line);
  for(my $j=0;$j<=$#genomes;$j++) {
   my $aligned_line =   get_aligned_line($words[1]-10000,$words[1]+10000,$j);
   if($aligned_line) {
     push(@alines,$aligned_line);
   }
  }
  if($#alines>1) {
    $cscore =get_cruciform_score(\@alines);
  }
  $r .= "<td>".sprintf("%.3f",$cscore)."</td></tr>\n";
  return $r;
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
#        print substr($clabels[$i],$j,1)." ";
    }
#    print " $score\n";
   }
   $score = $score/($#clabels+1);
#   print "Score :$score\n";
   return $score;

}
