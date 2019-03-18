use List::Util qw[max];
use Data::Dump qw(dump);
use Time::HiRes qw( time );
my $start = time();
my @in = qw(A T C G);
my @allSearchPatterns;
foreach my $element1 (@in) {
	foreach my $element2 (@in) {
		foreach my $element3 (@in) {
			foreach my $element4 (@in) {
				foreach my $element5 (@in) {
					foreach my $element6 (@in) {
						foreach my $element7 (@in) {
							foreach my $element8 (@in) {
								push @allSearchPatterns,$element1.$element2.$element3.$element4.$element5.$element6.$element7.$element8;
							}
						}
					}
				}
			}
		}
	}
}
#print $allSearchPatterns[2]."\n";


my @sequences = (
	"CCTGATAGACGCTATCTGGCTATCCAGGTACTTAGGTCCTCTGTGCGAATCTATGCGTTTCCAACCAT",
	"AGTACTGGTGTACATTTGATCCATACGTACACCGGCAACCTGAAACAAACGCTCAGAACCAGAAGTGC",
	"AAACGTTAGTGCACCCTCTTTCTTCGTGGCTCTGGCCAACGAGGGCTGATGTATAAGACGAAAATTTT",
	"AGCCTCCGATGTAAGTCATAGCTGTAACTATTACCTGCCACCCCTATTACATCTTACGTCCATATACA",
	"CTGTTATACAACGCGTCATGGCGGGGTATGCGTTTTGGTCGTCGTACGCTCGATCGTTACCGTACGGC"
);


my $allPatternMin=99999;
my $minPattern="";
foreach my $searchPattern (@allSearchPatterns) {
	my $patternMin = sequences_distance( $searchPattern, \@sequences );
	if ($patternMin<$allPatternMin) {
		$allPatternMin=$patternMin;
		$minPattern=$searchPattern;
		if ($allPatternMin==0) {
			last;
		}
	}
}
print $minPattern."\t".$allPatternMin. "\n";
my $end = time();
printf("%.2f\n", $end - $start);



sub sequences_distance {
	my ( $searchPattern, $sequencesRef ) = @_;

	#	my $searchPattern = "ACTTCGAC";
	my @sequences = @{$sequencesRef};

	my $searchPatternLength = length($searchPattern);
	my @searchPattern = split //, $searchPattern;

	#Record nucidetide count in each postion
	my $totalMin = 0;
	foreach my $j ( 0 .. ( scalar(@sequences) - 1 ) ) {
		my $sequence    = $sequences[$j];
		my $sequenceMin = $searchPatternLength;

		foreach
		  my $position ( 0 .. ( length($sequence) - $searchPatternLength ) )
		{
			my $subSequence = substr $sequence, $position, $searchPatternLength;

			#		print($subSequence."\n");
			my @subSequence = split //, $subSequence;

			my $arrayDistance =
			  array_distance( \@subSequence, \@searchPattern );
			if ( $arrayDistance < $sequenceMin ) {
				$sequenceMin = $arrayDistance;
			}
		}
#		print $sequenceMin. "\t" . $sequence . "\n";
		$totalMin = $totalMin + $sequenceMin;
	}
	return ($totalMin);
}

sub array_distance {
	my ( $xref, $yref ) = @_;
	my $arraySize = scalar @{$xref};

	my $arrayDistance = 0;
	foreach my $i ( 0 .. ( $arraySize - 1 ) ) {
		if ( ${$xref}[$i] ne ${$yref}[$i] ) {
			$arrayDistance = $arrayDistance + 1;
		}
	}
	return ($arrayDistance);
}



