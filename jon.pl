#spooky witchcraft
use strict;
use warnings;
use chatbotFunctions;
use Tie::File;
use Win32::OLE;
$Win32::OLE::Warn = 3;
my $speaker = Win32::OLE->new('SAPI.spvoice');

#variables
my $doChatLoop = 1; #loop variable
my $output;

#user input loop
while($doChatLoop == 1){

	#prompt
	print "\n?:";

#USER INPUT
	my $my_chat_words = <STDIN>;
	chomp $my_chat_words;
	#prevent entering blanks
	while($my_chat_words eq ""){
		$my_chat_words = <STDIN>;
		chomp $my_chat_words;
	}
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

	#vars
	my $interestWordPos;
	my @tempReturn;
	my @omrDB;
	our $db1Index;
	my $randChance = getRandom();

	#if I'm gonna use the one with the highest rating
	if($randChance > 0){
		@tempReturn = highestDB1Position($sentenceType);
		$interestWordPos = $tempReturn[0];
		$db1Index = $tempReturn[1];
	}
	else{
		$interestWordPos = int(rand(11)) / 10;
		$db1Index = getDB1Index($interestWordPos, $sentenceType);
	}

	#balance interesting word position off of user input size
	my $balancedPosition = $interestWordPos * @user_words;
	$balancedPosition = int($balancedPosition);
	my $interestWord = $user_words[$balancedPosition - 1];

#FIND WORD PART OF SPEECH IN DATABASE LEVEL 2
	my $dbWordFound = 0;
	my $wordInDB = 1;
	my $interestWordPartOfSpeech = "";
	my $hasResponseSaved = 0;
	my $interestWordIndex;
	my @currentDB;
	while($dbWordFound == 0){

		tie @currentDB, 'Tie::File', "conjunctions.txt" or die;
		for(my $i = 0; $i < @currentDB; $i ++){
			if(index($currentDB[$i], $interestWord) != -1){
				if(index($currentDB[$i], "1") != -1){
					$hasResponseSaved = 1;
				}
				$interestWordPartOfSpeech = "conjunction";
				$interestWordIndex = $i;
				$dbWordFound = 1;
			}
		}
		untie @currentDB;

		tie @currentDB, 'Tie::File', "articles.txt" or die;
		for(my $i = 0; $i < @currentDB; $i ++){
			if(index($currentDB[$i], $interestWord) != -1){
				my @temp = split "s", $currentDB[$i];
				if(index($temp[0], "1") != -1){
					$hasResponseSaved = 1;
				}	
				$interestWordPartOfSpeech = "article";
				$interestWordIndex = $i;
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
				$interestWordIndex = $i;
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
				$interestWordIndex = $i;
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
				$interestWordIndex = $i;
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
				$interestWordIndex = $i;
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
				$interestWordIndex = $i;
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
				$interestWordIndex = $i;
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

				my $responseSplitString = "r";

				#put the ratings on this structure into an array
				my @tempResponse = split / $responseSplitString /, $responses[$i];
				my $q = $tempResponse[1];

				#if it has a good rating, use it
				if($q >= 4){

					print $tempResponse[0] . "\n";
					$speaker->Speak( $tempResponse[0] );
					$responseRating = $q;
					last;

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
	$randChance = getRandom();
	my @sentences;
	my @sentencesPossible;
	my $sentenceStructure;
	my $responseKey = responseKeyType($sentenceType);

	tie @sentences, 'Tie::File', "structures.txt" or die;

	#if no sentence structures, I'm forced to make a new one
	if(@sentences == 0){
		$randChance = 0;
	}

	#loop through all possible structures
	for(my $i = 0; $i < @sentences; $i ++){

		my $splitString = "s";

		#put the ratings on this structure into an array
		my @structRatings = split / $splitString /, $sentences[$i];

		#if it is a coherent sentence structure
		if($structRatings[($sentenceType * 2) - 1] >= 3){

			#make it a possible response
			push @sentencesPossible, $structRatings[0];
			last;

		}

	}

	#if I found no suitable structures, make a new one
	if(@sentencesPossible == 0){
		$randChance = 0;
	}

	#if I'm not going to make a new one, choose one
	my @structure;

	if($randChance > 0){
		$sentenceStructure = $sentencesPossible[rand @sentencesPossible];
	}
	else{
		$sentenceStructure = makeSentenceStructure();
		#add to the structures file
		open(my $fhused, ">>", "structures.txt") or die "Can't open >> structures.txt: $!";
		print $fhused $sentenceStructure . " s 0 s 0 s 0 s 0 s 0 s 0 s 0 s 0\n";
		close $fhused;
	}
	#get word array from sentence structure
	@structure = arrayFromStructure($sentenceStructure);


	#array to track which articles were used as plurals
	my @plurals;


#GET RANDOM WORDS FROM DATABASE LEVEL 2
	if($hasResponseSaved == 0){

		$output = "";

		#have I already included the interest word?
		my $usedInterestWord = 0;

		my $plurality = 0;
		my $pluralWord;

		#for each word in the sentence structure
		for(my $i = 0; $i < @structure; $i ++){

			if($usedInterestWord == 0 && $interestWordPartOfSpeech."s" eq $structure[$i] && $wordInDB == 1){

				print $interestWord . " ";
				$output .= $interestWord . " ";
				$usedInterestWord = 1;

			}
			else{

				tie @currentDB, 'Tie::File', $structure[$i].".txt" or die;

				my $randIndex = int(rand(@currentDB));

				my $printword = $currentDB[$randIndex] . " ";

				untie @currentDB;

				#PLURALITY
				#if i am the article
				if($structure[$i] eq "articles"){

					#grab the plurality value
					my @tempPlurality = split /\s+/, $printword;
					$plurality = $tempPlurality[2];
					$pluralWord = $tempPlurality[0];
					$printword = $tempPlurality[0] . " ";

				}
				#if i am the noun
				if($i > 0 && $structure[$i] eq "nouns" && $structure[$i - 1] eq "articles"){

					#make sure there's some variance on plural picking
					my $randChance = getRandom();

					#on random chance or with high plurality
					if($randChance == 0 || $plurality >= 3){

						#make it plural
						push @plurals, $pluralWord;
						my @tempPrintword;
						@tempPrintword = split /\s+/, $printword;
						$printword = $tempPrintword[0] . "s ";

					}

				}else{
				if($structure[$i] eq "nouns"){

					#make sure there's some variance on plural picking
					my $randChance = getRandom();

					#on random chance
					if($randChance == 0){

						#make it plural
						my @tempPrintword;
						@tempPrintword = split /\s+/, $printword;
						$printword = $tempPrintword[0] . "s ";

					}

				}}

				$printword = join( "", split(" 0", $printword) );
				$printword = join( "", split(" 1", $printword) );

				print $printword;
				$output .= $printword;

			}

		}

		$speaker->Speak( $output );

	}

#USER RATING
if($doChatLoop == 1){

	my @openDB;

	#prompt
	print "\nHow Would You Rate My Response? (1-5)\n";

	my $rating = <STDIN>;
	chomp $rating;

	#ignore non-1thru5 ratings
	if ($rating =~ /^[1-5]$/) {

		#check for existing response
		my @temp = isDupeResponse($output);
		print "Dupe:".$hasResponseSaved."\n";
		print "Index:".$temp[1]."\n";
		# if it already exists, update its rating
		if($hasResponseSaved != 0){

			tie @openDB, 'Tie::File', "responses.txt" or die;

			my $splitString = " r ";

			#put the parts of this response into an array
			my @tempResponse = split / $splitString /, $openDB[$temp[1]];

			#update the amount of uses
			$tempResponse[2] += 1;

			#update the rating
			$tempResponse[1] = ((($tempResponse[2] - 1) * $tempResponse[1]) + $rating ) / $tempResponse[2];

			#add it to the database
			$openDB[$temp[1]] = join $splitString, @tempResponse;

			untie @openDB;

		}
		else{
			#add output to the responses file if it does not exist
			open(my $fhused, ">>", "responses.txt") or die "Can't open >> responses.txt: $!";
			print $fhused $output . " r " . $rating . " r 1\n";
			close $fhused;
		}

		#change word response value
		if($hasResponseSaved == 0 && $wordInDB == 1){
			tie @openDB, 'Tie::File', $interestWordPartOfSpeech."s.txt" or die;
			$openDB[$interestWordIndex] =~ s/ 0/ 1/i;
			untie @openDB;
		}

		#change sentence structure rating
		tie @openDB, 'Tie::File', "structures.txt" or die;

		#loop through all possible structures
		for(my $i = 0; $i < @openDB; $i ++){

			my $splitString = "s";

			#put the ratings on this structure into an array
			my @structRatings = split / $splitString /, $openDB[$i];

			#if this is the structure I used
			if($sentenceStructure eq $structRatings[0]){

				#update the amount of uses
				$structRatings[$sentenceType * 2] += 1;

				#update the rating
				$structRatings[($sentenceType * 2) - 1] = ((($structRatings[$sentenceType * 2] - 1) * $structRatings[($sentenceType * 2) - 1]) + $rating ) / $structRatings[$sentenceType * 2];

				#add it to the database
				$openDB[$i] = join " ".$splitString." ", @structRatings;
				$openDB[$i] .= "\n";

			}

		}

		untie @openDB;

		#change sentence interest word rating
		tie @openDB, 'Tie::File', "typeRatings.txt" or die;

			my $splitString = "spl";

			#put the ratings on this structure into an array
			my @structRatings = split / $splitString /, $openDB[$db1Index];

			#update the amount of uses
			$structRatings[2] += 1;

			#update the rating
			$structRatings[1] = ((($structRatings[2] - 1) * $structRatings[1]) + $rating ) / $structRatings[2];

			#add it to the database
			$openDB[$db1Index] = join " ".$splitString." ", @structRatings;
			$openDB[$db1Index] .= "\n";

		untie @openDB;

		#update progress report
		tie @openDB, 'Tie::File', "progress.txt" or die;

			#update the OOC
			$openDB[3] += 1;

			#update the OMR
			$openDB[1] = ((($openDB[3] - 1) * $openDB[1]) + $rating ) / $openDB[3];

			#check for progress milestone
			if($openDB[3] % 100 == 0 || $openDB[3] == 0){

				my $progressReport = "";

				$progressReport .= $openDB[3] . "\t" . $openDB[1];

				push @openDB, $progressReport;

			}

		untie @openDB;

		#update plurals
		if(@plurals > 0){

			tie @openDB, 'Tie::File', "articles.txt" or die;

			for(my $i = 0; $i < @openDB; $i ++){

				my $article = $openDB[$i];
				my @articleParts = split /\s+/, $article;

				for(my $q = 0; $q < @plurals; $q ++){

					#if it was used as a plural
					if($plurals[$q] eq $articleParts[0]){

						#update the counter
						$articleParts[3] += 1;

						#update the plurality
						$articleParts[2] = ((($articleParts[3] - 1) * $articleParts[2]) + $rating ) / $articleParts[3];

						#add it to the database
						$openDB[$i] = join " ", @articleParts;

						last;

					}

				}

			}

			untie @openDB;

		}

	}

}

}