# Program: create_html.pl
# Developed by: Anoop Kumar
# Date: 10/02/09
# Description: The program takes the output from find_cruciform and generates an html file

$result_file = $ARGV[0];
open(DAT,$result_file);
@lines = <DAT>;
close DAT;

print "<html><head><title>List of Cruciforms</title></head><body><b>Cruciforms for ".$result_file."<br />";
print "<table border=1><th><tr><td>Position</td><td>Sequence</td><td>Size</td><td>Cruciform</td></tr></th>";
$best_line ="";
$best_score = 0;
$current_position = 130771;
for($i=0;$i<=$#lines;$i++) {
   @words = split(/\W+/,$lines[$i]);
   $position = $words[1];
   $score = $words[5];
#   print "S$score $best_score P:$position CP:$current_position\n";
   if($position > $current_position) {
	if($best_line) {
	  print format_line($best_line);
	  $best_score = 0;
	  $best_line ="";
	}
  	$current_position = $position;
   } else {
	if($score > $best_score) {
	  $best_line = $lines[$i];
	  $best_score = $score;
	}
    }

 
}
print "</table></body></html>";

sub format_line {
  my $line = shift;
  my @words = split(/\W+/,$line);
  my $r = "<tr><td>".$words[1]."</td><td>".$words[2]."</td><td>".length($words[2])."</td><td>";
  $r .= "<a href=\"http://bcb.cs.tufts.edu/fragile/display_cruciform.php?fragment=".$words[2];
  $r .= "&alignment_left=".$words[3];
  $r .= "&alignment_right=".$words[4];
  $r .= "\">View</a></td></tr>\n";
  return $r;
}
  
