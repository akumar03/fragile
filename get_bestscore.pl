# Program: get_bestscore.pl
# Developed by: Anoop Kumar
# Date: 10/05/09
# Description: The program takes the output from find_cruciform and filters it with lines that have best score

$result_file = $ARGV[0];
open(DAT,$result_file);
@lines = <DAT>;
close DAT;

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
	  print $best_line;
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
