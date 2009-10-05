# Program: get_distribution.pl
# Seveloped by: Anoop Kumar
# Date: 10/05/09
# Description: The program prints the distribution of lengths of cruciform

$result_file = $ARGV[0];
open(DAT,$result_file);
@lines = <DAT>;
close DAT;

for($i=0;$i<=$#lines;$i++) {
   @words = split(/\W+/,$lines[$i]);
   $position = $words[1];
   $length  = length($words[2]);
   if($dist{$length}) {
	$dist{$length}++;
   } else {
	$dist{$length} =1;
   }
}

foreach $length (keys %dist) {
 print "$length ".$dist{$length}."\n";
}
