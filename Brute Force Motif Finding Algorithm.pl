use List::Util qw[max];
use List::MoreUtils qw(firstidx);
use Time::HiRes qw( time );
my $start = time();
my @sequences = (
	"GGGCTATCCAGCTGGGTCGTCACATTCCCCTTTCGA",
	"TGAGGGTGCCCAATAAGGGCAACTCCAAAGCGGACA",
	"ATGGATCTGATGCCGTTTGACGACCTAAATCAACGG",
	"GGAAGCAACCCCAGGAGCGCCTTTGCTGGTTCTACC",
	"TTTTCTAAAAAGATTATAATGTCGGTCCTTGGAACT",
	"GCTGTACACACTGGATCATGCTGCATGCCATTTTCA",
	"CATGATCTTTTGATGGCACTTGGATGAGGGAATGAT"
);

my $seqSubsetLength = 10;


my $maxInAllPosition=0;
my @maxInAllPositionIndex=();
my $maxInAllPositionMotif="";
foreach my $indexOne0 ( 0 .. ( length( $sequences[0] ) - $seqSubsetLength ) ) {
	print "$indexOne0\n";
	foreach
	  my $indexOne1 ( 0 .. ( length( $sequences[1] ) - $seqSubsetLength ) )
	{
		foreach
		  my $indexOne2 ( 0 .. ( length( $sequences[2] ) - $seqSubsetLength ) )
		{
			foreach my $indexOne3 (
				0 .. ( length( $sequences[3] ) - $seqSubsetLength ) )
			{
				foreach my $indexOne4 (
					0 .. ( length( $sequences[4] ) - $seqSubsetLength ) )
				{
					foreach my $indexOne5 (
						0 .. ( length( $sequences[5] ) - $seqSubsetLength ) )
					{
						foreach my $indexOne6 (
							0 .. ( length( $sequences[6] ) - $seqSubsetLength )
						  )
						{
							my @startPositions=($indexOne0,$indexOne1,$indexOne2,$indexOne3,$indexOne4,$indexOne5,$indexOne6);
							my ($sumValue,$maxMotif) = maxCount( \@startPositions, \@sequences, $seqSubsetLength );
							if ($maxInAllPosition<$sumValue) {
								$maxInAllPosition=$sumValue;
								@maxInAllPositionIndex=@startPositions;
								$maxInAllPositionMotif=$maxMotif;
							}
						}
					}
				}
			}
		}
	}
}

print "Max Count in all positions: ".$maxInAllPosition."\n";
my @extractedSequences=();
foreach my $i (0..(scalar(@maxInAllPositionIndex)-1)) {
	my $motif = substr $sequences[$i], $maxInAllPositionIndex[$i], $seqSubsetLength;
	print "Sequence ".$i."\t".$motif."\n";
}
print "Motif: ".$maxInAllPositionMotif."\n";
my $end = time();
printf("%.2f\n", $end - $start);


sub maxCount {
	my ( $startPositionRef, $sequencesRef, $seqSubsetLength,$returnMotif ) = @_;

	my @sequences      = @{$sequencesRef};
	my @startPositions = @{$startPositionRef};

	#Record nucidetide count in each postion
	my %seqPositionCount;
	foreach my $j ( 0 .. ( scalar(@startPositions) - 1 ) ) {
		my $startPosition = $startPositions[$j];
		my $sequence      = $sequences[$j];

		#		print $startPosition. "\n";
		my $subSequence = substr $sequence, $startPosition, $seqSubsetLength;

		#		print $subSequence. "\n";

	#split sequence into array, each element indicate nucidetide at one position
		my @subSequenceArray = split //, $subSequence;

#loop each position of sequence and count nucidetide into hash. $i means postion, $subSequenceArray[$i] means nucidetide (A, T, C, G)
		foreach my $i ( 0 .. ( $seqSubsetLength - 1 ) ) {
			if ( exists $seqPositionCount{$i}{ $subSequenceArray[$i] } ) {
				$seqPositionCount{$i}{ $subSequenceArray[$i] } =
				  $seqPositionCount{$i}{ $subSequenceArray[$i] } + 1;
			}
			else {
				$seqPositionCount{$i}{ $subSequenceArray[$i] } = 1;
			}
		}
	}

	#find max in each position
	my $sumValue = 0;
	my $maxMotif= "";
	
	foreach my $i ( 0 .. ( $seqSubsetLength - 1 ) ) {
		$countInPositionMax=0;
		$countInPositionMaxNuc="";
		while (my ($k, $v) = each %{$seqPositionCount{$i}}) {
			if ($v>$countInPositionMax) {
				$countInPositionMax=$v;
				$countInPositionMaxNuc=$k;
			}
		}
		$sumValue = $sumValue + $countInPositionMax;
		$maxMotif=$maxMotif.$countInPositionMaxNuc;
		
		#		print $countInPositionMax. "\n";
	}

#	print "Result:" . $sumValue . "\n";
	return ($sumValue,$maxMotif);

}
