# Program: find_palindrome.pl
# Developed by: Anoop Kumar
# Date: 07/15/2009
# Description: The program reads a sequence from file and finds the palindromes in the sequence


$seq_file = $ARGV[0];
$seq= "";
$MAX_GAP = 10;
$MIN_GAP = 0;
$MAX_LENGTH = 20;
$MIN_FRAG_LENGTH = 20;
$MAX_FRAG_LENGTH = 500;
open(SEQ,$seq_file)  or die("Can't open sequence file: $seq_file");
while($line = <SEQ>) {
 if(!($line =~ m/^\>/)){
  $seq .= $line;
 }
}
close(SEQ);
$seq =~ s/\W+//g;
#print $seq;
print "\n";

$seq_length = length($seq);

for($i=0;$i<$seq_length;$i++) {
  $frag_length = $i+$MAX_FRAG_LENGTH; 
  if($seq_length< $frag_length) { $frag_length= $seq_length ;}
  for($j=$i+$MIN_FRAG_LENGTH;$j<$frag_length;$j++) {
  $fragment = substr($seq,$i,$j-$i);
#  print $fragment."\n";
#10 percent of the sequence
  $gap_length = int(($j-$i)/10); 
  if($gap_length < $MIN_GAP) { $gap_length = $MIN_GAP;}
  if($gap_length > $MAX_GAP) { $gap_length = $MAX_GAP;}
    $score = 0;
#get the round value instead of floor
    $half = int(($j-$i)/2); 
#    print "$i,$j,$half\n";
# a flag that turns 0 if there is a mismatch
    $flag_match =1;
    for($k=$half;$k>0;$k--) {
      $char1 = substr($seq,$i+$k-1,1);
      $char2 = substr($seq,$j-$k,1);
      if(is_complement($char1,$char2)) {
	$score++;
      } else {
	$score--;
        $flag_match = 0;
      }
      if($score < 0 && ($half-$k)<= $gap_length) { $score =0;};
      
#      print "$k,$char1,$char2,$score\n";
    }
    if($score>=10 && $flag_match) {
      print "$i $j  $score  $fragment\n";
    }
  }
}

sub is_complement {

  my $char1= shift;
  my $char2= shift;
  if($char1 eq 'A' && $char2 eq 'T') { return 1;}
  if($char1 eq 'T' && $char2 eq 'A') { return 1;}
  if($char1 eq 'G' && $char2 eq 'C') { return 1;}
  if($char1 eq 'C' && $char2 eq 'G') { return 1;}
  return 0;

}


