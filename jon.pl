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

#USER INPUT
	my $my_chat_words = <STDIN>;
	chomp $my_chat_words;
	$my_chat_words = fixString($my_chat_words);

	if($my_chat_words eq "quit"){

		$doChatLoop = 0;

	}

	#get my words
	my @user_words = split /[:,\s?!.]+/, $my_chat_words;

#PREDICT SENTENCE TYPE
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

#GET INTERESTING WORD POSITION
	my @interestWordsArray;
	my $interestWordPos;
	tie @interestWordsArray, 'Tie::File', "db1.txt" or die;
	$interestWordPos = $interestWordsArray[$sentenceType - 1];
	untie @interestWordsArray;

	#balance interesting word position off of user input size
	my $balancedPosition = $interestWordPos * @user_words;
	$balancedPosition = int($balancedPosition);
	my $interestWord = $user_words[$balancedPosition - 1];

#FIND WORD PART OF SPEECH IN DATABASE LEVEL 2
	my $dbWordFound = 0;
	my $wordInDB = 1;
	my $interestWordPartOfSpeech = "";
	my $hasResponseSaved = 0;
	my @currentDB;
	while($dbWordFound == 0){

		tie @currentDB, 'Tie::File', "conjunctions.txt" or die;
		for(my $i = 0; $i < @currentDB; $i ++){
			if(index($currentDB[$i], $interestWord) != -1){
				if(index($currentDB[$i], "1") != -1){
					$hasResponseSaved = 1;
				}
				$interestWordPartOfSpeech = "conjunction";
				$dbWordFound = 1;
			}
		}
		untie @currentDB;

		tie @currentDB, 'Tie::File', "articles.txt" or die;
		for(my $i = 0; $i < @currentDB; $i ++){
			if(index($currentDB[$i], $interestWord) != -1){
				if(index($currentDB[$i], "1") != -1){
					$hasResponseSaved = 1;
				}	
				$interestWordPartOfSpeech = "article";
				$dbWordFound = 1;
			}
		}
		untie @currentDB;

		tie @currentDB, 'Tie::File', "prepositions.txt" or die;
		for(my $i = 0; $i < @currentDB; $i ++){
			if(index($currentDB[$i], $interestWord) != -1){
				if(index($currentDB[$i], "1") != -1){
					$hasResponseSaved = 1;
				}	
				$interestWordPartOfSpeech = "preposition";
				$dbWordFound = 1;
			}
		}
		untie @currentDB;

		tie @currentDB, 'Tie::File', "interjections.txt" or die;
		for(my $i = 0; $i < @currentDB; $i ++){
			if(index($currentDB[$i], $interestWord) != -1){
				if(index($currentDB[$i], "1") != -1){
					$hasResponseSaved = 1;
				}	
				$interestWordPartOfSpeech = "interjection";
				$dbWordFound = 1;
			}
		}
		untie @currentDB;

		tie @currentDB, 'Tie::File', "adverbs.txt" or die;
		for(my $i = 0; $i < @currentDB; $i ++){
			if(index($currentDB[$i], $interestWord) != -1){
				if(index($currentDB[$i], "1") != -1){
					$hasResponseSaved = 1;
				}	
				$interestWordPartOfSpeech = "adverb";
				$dbWordFound = 1;
			}
		}
		untie @currentDB;

		tie @currentDB, 'Tie::File', "verbs.txt" or die;
		for(my $i = 0; $i < @currentDB; $i ++){
			if(index($currentDB[$i], $interestWord) != -1){
				if(index($currentDB[$i], "1") != -1){
					$hasResponseSaved = 1;
				}	
				$interestWordPartOfSpeech = "verb";
				$dbWordFound = 1;
			}
		}
		untie @currentDB;

		tie @currentDB, 'Tie::File', "adjectives.txt" or die;
		for(my $i = 0; $i < @currentDB; $i ++){
			if(index($currentDB[$i], $interestWord) != -1){
				if(index($currentDB[$i], "1") != -1){
					$hasResponseSaved = 1;
				}	
				$interestWordPartOfSpeech = "adjective";
				$dbWordFound = 1;
			}
		}
		untie @currentDB;

		tie @currentDB, 'Tie::File', "nouns.txt" or die;
		for(my $i = 0; $i < @currentDB; $i ++){
			if(index($currentDB[$i], $interestWord) != -1){
				if(index($currentDB[$i], "1") != -1){
					$hasResponseSaved = 1;
				}	
				$interestWordPartOfSpeech = "noun";
				$dbWordFound = 1;
			}
		}
		untie @currentDB;

		if($dbWordFound == 0){

			$wordInDB = 0;
			$dbWordFound = 1;

		}

	}

#GET BEST MATCH FROM RESPONSE DATABASE
	if($hasResponseSaved == 1){

		my $responseRating = 0;
		my @responses;

		tie @responses, 'Tie::File', "responses.txt" or die;

		#loop through all recorded responses
		for(my $i = 0; $i < @responses; $i ++){

			#if this is the right one
			if(index($responses[$i], $interestWord) != -1){

				#loop through all possible ratings to see which it has
				for(my $q = 1; $q <= 5; $q ++){

					if(index($responses[$i], $q) != -1 && index($responses[$i], $q) > index($responses[$i], "ResponseRating")){

						if($q >= 4){

							my $outStr;
							$outStr = substr $responses[$i], 0, index($responses[$i], "ResponseRating") - 1;
							print $outStr . "\n";
							$responseRating = $q;
							last;

						}

					}

				}

				if($responseRating != 0){

					last;

				}

			}

		}
		if($responseRating == 0){

			$hasResponseSaved = 0;

		}

		untie @responses;

	}

#CHOOSE A SENTENCE STRUCTURE

	#vars
	my $randChance = int(rand(10));
	my @sentences;
	my @sentencesPossible;
	my $sentenceStructure;
	my $responseKey = responseKeyType($sentenceType);

	tie @sentences, 'Tie::File', "structures.txt" or die;

	#if no sentence structures, I'm forced to make a new one
	if(@sentences == 0){
		$randChance = 9;
	}

	#loop through all recorded responses
	for(my $i = 0; $i < @sentences; $i ++){

		#loop through all possible ratings to see which it has
		for(my $q = 1; $q <= 5; $q ++){

			#if it has that rating for the current sentence structure
			if(index($sentences[$i], $q) != -1 && index($sentences[$i], $q) == index($sentences[$i], $responseKey) + 16){

				#if it is a coherent sentence structure
				if($q >= 3){

					#make it a possible response
					push @sentencesPossible, $sentences[$i];
					last;

				}

			}

		}

	}

	#if I'm not going to make a new one, choose one
	my @structure;

	if($randChance <= 7){
		$sentenceStructure = $sentencesPossible[rand @sentencesPossible];
		#get word array from sentence structure
		@structure = arrayFromStructure($sentenceStructure, 0);
	}
	else{
		$sentenceStructure = makeSentenceStructure();
		#get word array from sentence structure
		@structure = arrayFromStructure($sentenceStructure, 1);
	}

	


#GET RANDOM WORDS FROM DATABASE LEVEL 2
	if($hasResponseSaved == 0){

		#have I already included the interest word?
		my $usedInterestWord = 0;

		#for each word in the sentence structure
		for(my $i = 0; $i < @structure; $i ++){

			if($usedInterestWord == 0 && $interestWordPartOfSpeech."s" eq $structure[$i] && $wordInDB == 1){

				print $interestWord . " ";
				$usedInterestWord = 1;

			}
			else{

				tie @currentDB, 'Tie::File', $structure[$i].".txt" or die;

				my $randIndex = int(rand(@currentDB));

				my $printword = $currentDB[$randIndex] . " ";
				$printword = join( "", split(" 0", $printword) );
				$printword = join( "", split(" 1", $printword) );

				print $printword;

				untie @currentDB;

			}

		}

	}

}