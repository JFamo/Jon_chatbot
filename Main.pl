#spooky witchcraft
use strict;
use warnings;
use JoshFirstFunctions;

#poorly written loop
my $doLoop = 1;

while($doLoop == 1){

	#menu
	print "\n\t\tMy First Perl\n";
	print "\t[1]Fibonacci Numbers\n";
	print "\t[2]Quadratic Formula\n";
	print "\t[3]String Reversal\n";
	print "\t[4]Get Words\n";
	print "\t[5]Chatbot\n";
	print "\t[6]Quit\n\n";

	#prompt
	print "?:";

	#input
	my $input = <STDIN>;
	chomp $input;

	#program 1
	if($input == 1){

		#prompt
		print "\nPrint How Many Numbers? : ";

		#input
		my $fib_input = <STDIN>;
		chomp $fib_input;

		#call subroutine for output
		GetFibonacci($fib_input);

	}

	#program 2
	if($input == 2){

		#prompt
		print "\nA : ";
		#input
		my $a = <STDIN>;
		chomp $a;
		#prompt
		print "\nB : ";
		#input
		my $b = <STDIN>;
		chomp $b;
		#prompt
		print "\nC : ";
		#input
		my $c = <STDIN>;
		chomp $c;

		#call subroutine for output
		Quadratic($a,$b,$c);

	}

	#program 3
	if($input == 3){

		#prompt
		print "\nEnter a String : ";

		#input
		my $rev_input = <STDIN>;
		chomp $rev_input;

		ReverseString($rev_input);

	}

	#program 4
	if($input == 4){

		#prompt
		print "\nEnter a String : ";

		#input
		my $words_input = <STDIN>;
		chomp $words_input;

		#split the input
		my @words_array = split / /, $words_input;

		#output
		foreach my $word (@words_array){
			print "\n" . $word;
		}

	}

	#program 5
	if($input == 5){

		#variables
		my $doChatLoop = 1; #loop variable
		my @usedlines; #array to hold already used text lines
		my @responses_possible; #array of possible responses

		my @chatlines = textFileToArray("convo");

		#clear used.txt, prep it to write
		open(my $fhused, ">", "used.txt") or die "Can't open > used.txt: $!";
		close $fhused;

		#user input loop
		while($doChatLoop == 1){

			splice @responses_possible;

			#prompt
			print "\n?:";

			#input
			my $my_chat_words = <STDIN>;
			chomp $my_chat_words;
			$my_chat_words = fixString($my_chat_words);

			#check if the user's already said that
			#make sure to do this before adding their words to used.txt
			splice @usedlines;
			@usedlines = textFileToArray("used");
			foreach my $usedline (@usedlines){
				if(lc($my_chat_words) eq lc($usedline)){
					if(isProbableQuestion($my_chat_words) == 1){
						my @dupelines = textFileToArray("duplicateResponsesQuestions");
						push @responses_possible, @dupelines;
					}
					else{
						my @dupelines = textFileToArray("duplicateResponses");
						push @responses_possible, @dupelines;
					}
				}
			}

			#add input to the used.txt file
			open(my $fhused, ">>", "used.txt") or die "Can't open >> used.txt: $!";
			print $fhused $my_chat_words . "\n";
			close $fhused;

			#get my words
			my @user_words = split /[:,\s?!.]+/, $my_chat_words;

			#IS QUESTION
			if(isProbableQuestion($my_chat_words) == 1){

				my $foundCase = 0;

				#SPECIAL CASES
				if(lc($my_chat_words) eq "what is your name?"){

					push @responses_possible, "My name is Jon!";
					push @responses_possible, "I'm Jon!";
					push @responses_possible, "My name is not important...";
					$foundCase = 1;

				}
				if(lc($my_chat_words) eq "what is your name?"){

					push @responses_possible, "My name is Ron!";
					$foundCase = 1;

				}
				

				if($foundCase == 0){
					
					#randomize response type
					if(int(rand(11)) < 1){

						#REPHRASE
						my $rephrased;
						if(scalar(@user_words) >= 2){
							$rephrased = $user_words[0] . " " . $user_words[1] . "?";
						}
						else{
							$rephrased = $user_words[0] . "?";
						}
						push @responses_possible, $rephrased;

					}
					else{
						
						#KEYWORD
						#for each line
						foreach my $chatline (@chatlines){

							#get words from that line
							my @line_words = split /[:,\s?!.]+/, $chatline;

							#for each user input word
							foreach my $userword (@user_words){

								#for each word in the line
								foreach my $chatword (@line_words){

									my $word = lc $userword;
									
									if( isValidWord($word) == 1 ){

										#check if a word matches
										if($word eq lc $chatword){

											#make that line a possible response
											push @responses_possible, $chatline;

										}
									}
								}
							}
						}

					}

				}

			}
			else{

				#SPECIAL CASES
				if(lc($my_chat_words) eq "quit"){

					$doChatLoop = 0;

				}


				#KEYWORD
				#for each line
				foreach my $chatline (@chatlines){

					#get words from that line
					my @line_words = split /[:,\s?!.]+/, $chatline;

					#for each user input word
					foreach my $userword (@user_words){

						#for each word in the line
						foreach my $chatword (@line_words){

							my $word = lc $userword;
							
							if( isValidWord($word) == 1 ){

								#check if a word matches
								if($word eq lc $chatword){

									#make that line a possible response
									push @responses_possible, $chatline;

								}
							}
						}
					}
				}
				
			}

			#checking for blank output
			if(!@responses_possible){

				#access all lines
				push @responses_possible, @chatlines;

			}

			#output
			my $chosen_output = $responses_possible[rand @responses_possible];
			print $chosen_output . "\n";

		}

	}

	#quit option
	if($input == 6){

		#output
		print "\nQuitting...\n";

		#stop loop
		$doLoop = 0;
		
	}

}