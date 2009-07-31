
$out_file = $ARGV[0];
$id = int($ARGV[1]);

$MAX_GAP = 30;
$MIN_GAP = 3;

open(OUT,$out_file);
$line_id = 1;

while($line = <OUT> ) {
if($line_id ==$id) {
  @words = split(" ",$line);
#  print $words[3]."\n";
  $palin = $words[3];
  $len = length($palin);
  $score = 0;
  $half = int($len/2+0.5)-1;
  $gap_length = int($len/10);
  if($gap_length < $MIN_GAP) { $gap_length = $MIN_GAP;}
  if($gap_length > $MAX_GAP) { $gap_length = $MAX_GAP;}
  $count = 0;
  for($k=0;$k<$half;$k++) {
    $char1 = substr($palin,$k,1);
    $char2 = substr($palin,$len-$k-1,1);
    if(is_complement($char1,$char2)) {
   	$pt = "+1";
   	$score++;
    } else {
   	$pt = "-1";
	$score--;
    } 
#      if($score < 0 && ($half-$k)<= $gap_length) { $score =0;};
    print "$char1 $char2 $count $pt $score \n";
    $count++;
  }
}
  $line_id++;
}
close OUT;

sub is_complement {

  my $char1= shift;
  my $char2= shift;
  if($char1 eq 'A' && $char2 eq 'T') { return 1;}
  if($char1 eq 'T' && $char2 eq 'A') { return 1;}
  if($char1 eq 'G' && $char2 eq 'C') { return 1;}
  if($char1 eq 'C' && $char2 eq 'G') { return 1;}
  return 0;

}
