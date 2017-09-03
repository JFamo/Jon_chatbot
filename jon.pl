#spooky witchcraft
use strict;
use warnings;
use chatbotFunctions;
use Tie::File;

#variables
my $doChatLoop = 1; #loop variable

#user input loop
while($doChatLoop == 1){

	#prompt
	print "\n?:";

	#input
	my $my_chat_words = <STDIN>;
	chomp $my_chat_words;
	$my_chat_words = fixString($my_chat_words);

	#add input to the used.txt file
	open(my $fhused, ">>", "used.txt") or die "Can't open >> used.txt: $!";
	print $fhused $my_chat_words . "\n";
	close $fhused;

	if($my_chat_words eq "quit"){

		$doChatLoop = 0;

	}

	#get my words
	my @user_words = split /[:,\s?!.]+/, $my_chat_words;

	#Predict the sentence type
	#1 - Declarative
	#2 - Interrogatory
	#3 - Imperative
	#4 - Exclamatory
	my $sentenceType = 1;

	#IS INTERROGATORY
	if(isProbableQuestion($my_chat_words) == 1){
		$sentenceType = 2;
	}
	else{
		#IS IMPERATIVE
		if(isProbableImperative($my_chat_words) == 1){
			$sentenceType = 3;
		}
		else{
			#IS EXCLAMATORY
			if(isProbableExclamatory($my_chat_words) == 1){
				$sentenceType = 4;
			}
		}
	}

	print $sentenceType . "\n";

	#read database 1, get interesting word position
	my @interestWordsArray;
	my $interestWordPos;
	tie @interestWordsArray, 'Tie::File', "db1.txt" or die;
	$interestWordPos = $interestWordsArray[$sentenceType - 1];
	untie @interestWordsArray;

	#balance interesting word position off of user input size
	my $balancedPosition = $interestWordPos * @user_words;
	$balancedPosition = int($balancedPosition);

	my $interestWord = $user_words[$balancedPosition - 1];

	print $interestWord;


}