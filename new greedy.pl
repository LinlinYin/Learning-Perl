use List::Util qw[max];
use List::MoreUtils qw(firstidx);
use Time::HiRes qw( time );
use Data::Dumper;
my $start     = time();
my @sequences = (
	"CCTGATAGACGCTATCTGGCTATCCAGGTACTTAGGTCCTCTGTGCGAATCTATGCGTTTCCAACCAT",
	"AGTACTGGTGTACATTTGATCCATACGTACACCGGCAACCTGAAACAAACGCTCAGAACCAGAAGTGC",
	"AAACGTTAGTGCACCCTCTTTCTTCGTGGCTCTGGCCAACGAGGGCTGATGTATAAGACGAAAATTTT",
	"AGCCTCCGATGTAAGTCATAGCTGTAACTATTACCTGCCACCCCTATTACATCTTACGTCCATATACA",
	"CTGTTATACAACGCGTCATGGCGGGGTATGCGTTTTGGTCGTCGTACGCTCGATCGTTACCGTACGGC"
);

my $seqSubsetLength = 8;
my @startPositions = (0, 0, 0, 0, 0);
my $maxInAllPosition      = 0;
my @maxInAllPositionIndex = ();
my $maxInAllPositionMotif = "";
foreach my $i ( 0 .. ( length( $sequences[0] ) - $seqSubsetLength ) ) {
	my @motifs = substr $sequences[0], $i , $seqSubsetLength;	
	$startPositions[0] = $i;
	foreach my $j ( 1 .. 4 ){
		my $profile = profile( \@motifs, $seqSubsetLength, $j );
		my ($kmer, $most_in) = profile_most ($sequences[$j],$seqSubsetLength,$profile);
		$startPositions[$j] = $most_in;
		push @motifs,$kmer;
		#print $j."index". $most_in. "\n";
	}
	  
	my ( $sumValue, $maxMotif ) = maxCount( \@startPositions, \@sequences, $seqSubsetLength );
	if ( $maxInAllPosition < $sumValue ) {
			$maxInAllPosition      = $sumValue;
			@maxInAllPositionIndex = @startPositions;
			$maxInAllPositionMotif = $maxMotif;
		}
	
	}


print "Max Count in all positions: " . $maxInAllPosition . "\n";



my @extractedSequences = ();
foreach my $i ( 0 .. ( scalar(@maxInAllPositionIndex) - 1 ) ) {
  my $motif = substr $sequences[$i], $maxInAllPositionIndex[$i],
	$seqSubsetLength;
  print "Sequence " . $i . "\t" . $motif . "\n";
}
print "Motif: " . $maxInAllPositionMotif . "\n";
my $end = time();
printf( "%.2f\n", $end - $start );


sub profile {
    my ( $motifs, $k, $t ) = @_;    

    my %profile;
    foreach my $i ( 0 .. $k - 1 ) {
        my %count = map { $_ => 0 } qw(A C G T);
        foreach my $motif ( @{$motifs} ) {
            $count{ substr $motif, $i, 1 }++;
        }
        foreach my $nucleotide (qw(A C G T)) {
            push @{ $profile{$nucleotide} }, $count{$nucleotide} / $t;
        }
    }

    return \%profile;
}

sub profile_most {
    my ( $text, $k, $profile ) = @_;    

    my $kmer;
	my $most_in;
    my $max_prob = -1;                  
    foreach my $i ( 0 .. ( ( length $text ) - $k ) ) {
        my $prob = profile_prob( ( substr $text, $i, $k ), $profile );
        if ( $prob > $max_prob ) {
            $max_prob = $prob;
			$most_in = $i;
            $kmer = substr $text, $i, $k;
        }
    }

    return ($kmer, $most_in);
}

sub profile_prob {
	
    my ($kmer, $profile) = @_;
    my $prob = 1;
	my $dnabp;
    foreach my $i ( 0 .. ( length $kmer ) - 1 ) {
		$dnabp = substr $kmer, $i, 1;
        $prob = $prob*${$profile}{$dnabp}[$i];		
    }

    return $prob;
}

sub maxCount {
	my ( $startPositionRef, $sequencesRef, $seqSubsetLength, $returnMotif ) =
	  @_;

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
	my $maxMotif = "";

	foreach my $i ( 0 .. ( $seqSubsetLength - 1 ) ) {
		$countInPositionMax    = 0;
		$countInPositionMaxNuc = "";
		while ( my ( $k, $v ) = each %{ $seqPositionCount{$i} } ) {
			if ( $v > $countInPositionMax ) {
				$countInPositionMax    = $v;
				$countInPositionMaxNuc = $k;
			}
		}
		$sumValue = $sumValue + $countInPositionMax;
		$maxMotif = $maxMotif . $countInPositionMaxNuc;

		#		print $countInPositionMax. "\n";
	}

	#	print "Result:" . $sumValue . "\n";
	return ( $sumValue, $maxMotif );

}
