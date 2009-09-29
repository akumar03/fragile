# Program: find_cruciform.pl
# Developed by: Anoop Kumar
# Date: 09/27/2009
# Description: The program reads a sequence from file and finds cruciforms
# * Loop of 0-12 in general case
# * Loop pf 0-30 in AT rich if >=ATP (Default 80%)
# * Mismatch <= MISMATCH (Default 3)
# * Insertions <=INSERT (Default 2)
# * stem >= STEM (Default 20)
# * opveralap <=OVERLAP (Default 75%)



$seq_file = $ARGV[0];
$seq= "";
$MAX_GAP = 10;
$MIN_GAP = 0;
$MAX_LENGTH = 20;
$MIN_FRAG_LENGTH = 20;
$MAX_FRAG_LENGTH = 500;
$ATP = 0.80;
$MISMATCH = 3;
$INSERT = 2;
$LOOP = 12;
$LOOP_AT = 30;
$STEM = 20;
$OVERLAP = 0.75;

 
open(SEQ,$seq_file)  or die("Can't open sequence file: $seq_file");
while($line = <SEQ>) {
 if(!($line =~ m/^\>/)){
  $seq .= $line;
 }
}
close(SEQ);

$seq =~ s/\W+//g;
#print $seq;

$seq_length = length($seq);

for(my $i=0;$i<$seq_length;$i++) {
  $frag_end = $i+$MAX_FRAG_LENGTH; 
  if($seq_length< $frag_end) { $frag_end= $seq_length ;}
 
  for(my $j=$i+$MIN_FRAG_LENGTH;$j<$frag_end;$j++) {
    $orig_fragment = substr($seq,$i,$j-$i);
    $insert_count = 0;
    $mismatch_count =0;
    $start = $i;
    if(is_AT_rich($orig_fragment)) {
     $loop_threshold = (length($orig_fragment) -$LOOP_AT)/2;
    } else {
     $loop_threshold = (length($orig_fragment) -$LOOP)/2;
    }
    if($loop_threshold <$STEM ) {
      $loop_threshold = $STEM;
    }
    
    get_cruciform_nd($orig_fragment,'','',0);
  }
}

# This method is not based on dynamic programming
sub  get_cruciform_nd {
  my $fragment = shift;
  my $alignment_left = shift;
  my $alignment_right = shift;
  my $score = shift;
  my $frag_length = length($fragment);
  if($score > 20) {
    print "$start $orig_fragment $fragment $alignment_left $alignment_right $score\n";
  }
  if($frag_length == 0) {
    if($score > 15) {
     print "F $start $orig_fragment $fragment $alignment_left $alignment_right $score\n";
    }
#   print "$alignment_left $alignment_right $score\n";
   return 0;
  } 
  my $char1 = substr($fragment,0,1);
  my $char2 = substr($fragment,$frag_length-1,1);

  if(is_complement($char1,$char2)) {
    return get_cruciform_nd(substr($fragment,1,$frag_length-2),$alignment_left.'M',$alignment_right.'M',$score+1);
  } else {
    
    if(length($alignment_left) >$loop_threshold && length(alignment_right) >=$loop_threshold) {
          get_cruciform_nd(substr($fragment,1,$frag_length-2),$alignment_left.'L',$alignment_right.'L',$score);
    }
    if($mismatch_count <=2) {
      $mismatch_count++;
      get_cruciform_nd(substr($fragment,1,$frag_length-2),$alignment_left.'W',$alignment_right.'W',$score-1);
    }
    if($insert_count <=1) {
      $insert_count++; 
      get_cruciform_nd(substr($fragment,0,$frag_length-2),$alignment_left,$alignment_right.'G',$score-1);
      get_cruciform_nd(substr($fragment,1,$frag_length-1),$alignment_left.'G',$alignment_left,$score-1);
    }

  }
  
}

sub get_best_cruciform {
  my $fragment = shift;
  my $frag_length = length($fragment);
  my $half = int($frag_length/2);
  my $insert_count = 0;
  my $mismatch_count =0;
  my @score;
# arrow  is T (top), C (cross), L(left);
  my @arrow;
 
  for(my $i = 0;$i<$half;$i++) {
   for(my $j =0;$j<$half-1;$j++) {
     my $char1 = substr($fragment,$i,1);
     my $char2 = substr($fragment,$frag_length-$j-1,1);
     
     
     
   }

  } 
  print "$fragment $frag_length $half\n";
  

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

sub is_AT_rich {
  my $fragment = shift;
  $frag_length = length($fragment);
  $at_count =0;
  for(my $i =0;$i< $frag_length;$i++) {
   my $char = substr($fragment,$i,1);
   if( uc($char) eq 'A' || uc($char) eq 'T') {
      $at_count++;
   }
  }
  if($at_count > $ATP*$frag_length) {
   return 1;
  } else {
    return 0;
  }

}

