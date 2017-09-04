package chatbotFunctions;
use strict;
use warnings;
use Exporter;

our @ISA= qw( Exporter );

# these CAN be exported.
our @EXPORT_OK = qw( isValidWord textFileToArray isProbableQuestion fixString isProbableImperative isProbableExclamatory makeSentenceStructure responseKeyType arrayFromStructure highestDB1Position getDB1Index getRandom isDupeResponse );

# these are exported by default.
our @EXPORT = qw( isValidWord textFileToArray isProbableQuestion fixString isProbableImperative isProbableExclamatory makeSentenceStructure responseKeyType arrayFromStructure highestDB1Position getDB1Index getRandom isDupeResponse );

sub isValidWord{

	my $word = $_[0];

	if($word eq "not" || $word eq "or" || $word eq "that" || $word eq "and" || $word eq "you" || $word eq "i" || $word eq "the" || $word eq "then" || $word eq "as" || $word eq "am" || $word eq "no"){
		return 0;
	}
	else{
		return 1;
	}

}

sub textFileToArray{

	my $filename = $_[0];
	my @outputarray;

	#open and read from used.txt
	open(my $fh, "<", $filename.".txt") or die "Can't open < ".$filename.".txt: $!";

	#for each line in the file
	while(my $line = <$fh>){

		chomp $line;
		
		#add this line to the array
		push @outputarray, $line;

	}

	close $fh;

	return @outputarray;
}

sub isProbableQuestion{

	my $str = $_[0];
	my $out = 0;

	#check for question marks
	if (index($str, "?") != -1) {
		$out = 1;
	}
	#check for question words at the beginning of the sentence
	if (index(lc($str), lc("What")) == 0 || index(lc($str), lc("Who")) == 0 || index(lc($str), lc("Whom")) == 0 || index(lc($str), lc("When")) == 0 || index(lc($str), lc("Where")) == 0 || index(lc($str), lc("Why")) == 0) {
		$out = 1;
	}
	#check for other indicators
	if (index(lc($str), lc("Is")) == 0 || index(lc($str), lc("Are")) == 0 || index(lc($str), lc("Aren't")) == 0 || index(lc($str), lc("Do")) == 0 || index(lc($str), lc("Will")) == 0 || index(lc($str), lc("Won't")) == 0 || index(lc($str), lc("Shall")) == 0 || index(lc($str), lc("Can")) == 0 || index(lc($str), lc("Must")) == 0) {
		$out = 1;
	}

	return $out;

}

sub isProbableImperative{

	my $str = $_[0];
	my $out = 0;

	#check for imperative words
	if (index(lc($str), lc("Must")) != -1 || index(lc($str), lc("Do")) == 0 || index(lc($str), lc("Go")) == 0 || index(lc($str), lc("Help")) == 0 || index(lc($str), lc("Learn")) == 0 || index(lc($str), lc("Listen")) == 0) {
		$out = 1;
	}
	#check for other indicators
	if (index(lc($str), lc("Obey")) == 0 || index(lc($str), lc("Pay Attention")) == 0 || index(lc($str), lc("have to")) != -1 || index(lc($str), lc("need to")) != -1 || index(lc($str), lc("shall")) != -1 || index(lc($str), lc("do not")) != -1) {
		$out = 1;
	}

	return $out;

}

sub isProbableExclamatory{

	my $str = $_[0];
	my $out = 0;

	#check for exclamation points
	if (index($str, "!") != -1) {
		$out = 1;
	}
	#check for one-word inputs
	if (index($str, " ") == -1) {
		$out = 1;
	}
	#check for imperative words
	if (index(lc($str), lc("Wow")) != -1 || index(lc($str), lc("Hello")) != -1 || index(lc($str), lc("Goodbye")) != -1 || index(lc($str), lc("Hi")) != -1 || index(lc($str), lc("Bye")) != -1 || index(lc($str), lc("ok")) != -1 || index(lc($str), lc("okay")) != -1 || index(lc($str), lc("k")) != -1 || index(lc($str), lc("yes")) != -1 || index(lc($str), lc("no")) != -1 || index(lc($str), lc("cool")) != -1) {
		$out = 1;
	}

	return $out;

}

sub fixString{

	my $str = $_[0];

	#all lowercase
	$str = lc($str);

	#add question mark to probable questions
	if(isProbableQuestion($str) == 1 && index($str, "?") == -1){
		$str .= "?";
	}

	#check for missing apostraphies
	$str = join( "what's", split("whats", $str) );
	$str = join( "how's", split("hows", $str) );
	$str = join( "where's", split("wheres", $str) );
	$str = join( "when's", split("whens", $str) );
	$str = join( "who's", split("whos", $str) );
	$str = join( "weren't", split("werent", $str) );
	$str = join( "wasn't", split("wasnt", $str) );
	$str = join( "would've", split("wouldve", $str) );
	$str = join( "should've", split("shouldve", $str) );
	$str = join( "could've", split("couldve", $str) );
	$str = join( "hadn't", split("hadnt", $str) );
	$str = join( "can't", split("cant", $str) );
	$str = join( "wouldn't", split("wouldnt", $str) );
	$str = join( "couldn't", split("couldnt", $str) );
	$str = join( "shouldn't", split("shouldnt", $str) );
	$str = join( "won't", split("wont", $str) );

	#remove apostraphies
	if(index($str, "n't") != -1){
		$str = join( " not", split("n't", $str) );
	}
	if(index($str, "'ve") != -1){
		$str = join( " have", split("'ve", $str) );
	}
	if(index($str, "'s") != -1){
		$str = join( " is", split("'s", $str) );
	}

	return $str;

}

sub makeSentenceStructure {

	my $outStr = "";

	#give a random length from 1-12
	my $length = int(rand(6)) + 1;

	#add parts of speech
	for(my $i = 0; $i <= $length; $i ++){

		my $part;
		my $rand = int(rand(8));
		if($rand == 0){
			$part = "noun";
		}
		if($rand == 1){
			$part = "adjective";
		}
		if($rand == 2){
			$part = "verb";
		}
		if($rand == 3){
			$part = "adverb";
		}
		if($rand == 4){
			$part = "interjection";
		}
		if($rand == 5){
			$part = "preposition";
		}
		if($rand == 6){
			$part = "article";
		}
		if($rand == 7){
			$part = "conjunction";
		}
		$outStr .= $part . " ";

	}

	return $outStr;

}

#this function gets the response rating keyword to look for in the Structures DB based on sentence type
sub responseKeyType {

	my $sentenceType = $_[0];
	my $outStr;

	if($sentenceType == 1){
		$outStr = "ResponseRatingD";
	}
	if($sentenceType == 2){
		$outStr = "ResponseRatingN";
	}
	if($sentenceType == 3){
		$outStr = "ResponseRatingM";
	}
	if($sentenceType == 4){
		$outStr = "ResponseRatingE";
	}

	return $outStr;

}

sub arrayFromStructure {

	#vars
	my $str = $_[0];
	my $splitString = " ";
	my @out;

	#put in array
	@out = split / /, $str;

	#make parts plural
	for(my $i = 0; $i < @out; $i ++){

		$out[$i] .= "s";

	}

	return @out;

}

sub highestDB1Position {

	#vars
	my $sentenceType = $_[0];
	my $mindex = 0;
	my $highValue = 0;
	our $highIndex = $mindex;
	my @interestWordsArray;
	my $splitString = "spl";
	my $outPos = 0;
	my @out;

	#where in the database should I start?
	if($sentenceType == 1){
		$mindex = 0;
	}
	if($sentenceType == 2){
		$mindex = 11;
	}
	if($sentenceType == 3){
		$mindex = 22;
	}
	if($sentenceType == 4){
		$mindex = 33;
	}

	#read the db
	tie @interestWordsArray, 'Tie::File', "typeRatings.txt" or die;

	#for each position of my sentence type
	for(my $i = $mindex; $i < ($mindex + 11); $i++){

		#get the values at this row
		my @ratings = split / $splitString /, $interestWordsArray[$i];

		#if it has the highest rating so far, save it
		if($ratings[1] > $highValue){

			$highValue = $ratings[1];
			$highIndex = $i;
			$outPos = $ratings[0];

		}

	}

	push @out, $outPos;
	push @out, $highIndex;

	untie @interestWordsArray;

	return @out;

}

sub getDB1Index{

	my $val = $_[0];
	my $sentenceType = $_[1];

	return (10 * $val) + (11 * ($sentenceType - 1));

}

sub getRandom{

	my @omrDB;
	my $omr;
	my $rand;

	#check OMR
	tie @omrDB, 'Tie::File', "progress.txt" or die;

	$omr = $omrDB[1];

	untie @omrDB;

	$rand = 2 ** $omr;

	$rand = int(rand($rand));

	return $rand;

}

sub isDupeResponse {

	my $str = $_[0];
	my @responses;
	my @out;
	$out[0] = 0;
	$out[1] = 0;

	tie @responses, 'Tie::File', "responses.txt" or die;

	#for each saved response
	for(my $i = 0; $i < @responses; $i++){

		#predict if it is correct
		if(index($responses[$i], $str) != 0){

			my $splitString = " r ";

			#put the ratings on this structure into an array
			my @tempResponse = split / $splitString /, $responses[$i];

			if($tempResponse[0] eq $str){

				$out[0] = 1;
				$out[1] = $i;
				last;

			}

		}

	}

	untie @responses;

	return $out;

}

1;