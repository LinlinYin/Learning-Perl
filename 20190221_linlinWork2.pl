use List::Util qw[max];

my @sequences=("ACTTCGACCCCCGACTCCCAGCAGCACGATCAGCACTAT","ACTTCGACCTGCACGACAGCAGCACGATCAGCACTAT","CACGATCAGCACTATCACGATC","CACGATCAGCACTAGATCAGCACT","AGCACGATCAGCACTTCGACCTGCACGA");
my $searchPattern="ACTTCGAC";

my $searchPatternLength=length($searchPattern);
my @searchPattern=split //, $searchPattern;

#Record nucidetide count in each postion
my $totalMin=0;
foreach my $j (0..(scalar(@sequences)-1)) {
	my $sequence=$sequences[$j];
	my $sequenceMin=$searchPatternLength;
	
	foreach my $position (0..(length($sequence)-$searchPatternLength)) {
		my $subSequence  = substr $sequence, $position,$searchPatternLength;
#		print($subSequence."\n");
		my @subSequence=split //, $subSequence;
		
		my $arrayDistance=array_distance(\@subSequence,\@searchPattern);
		if ($arrayDistance<$sequenceMin) {
			$sequenceMin=$arrayDistance;
		}
	}
	print $sequenceMin."\t".$sequence."\n";
	$totalMin=$totalMin+$sequenceMin;
}


print "Result:".$totalMin."\n";


sub array_distance {
    my ($xref, $yref) = @_;
    my $arraySize=scalar @{$xref};
    
    my $arrayDistance=0;
    foreach my $i (0..($arraySize-1)) {
    	if (${$xref}[$i] ne ${$yref}[$i]) {
    		$arrayDistance=$arrayDistance+1;
    	}
    }
    return($arrayDistance);
}


#my @x = (1,3,3);
#my @y = (1,2,4);
#
#my $arrayDistance=array_distance(\@x,\@y);
#print($arrayDistance)

