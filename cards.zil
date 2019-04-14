"CARDS for
		             BALLYHOO
	(c) Copyright 1986 Infocom, Inc.  All Rights Reserved.
"

<GLOBAL CARD-TABLE <TABLE 4 4 4 4 4 4 4 4 4 4 4 4 4
			  4 4 4 4 4 4 4 4 4 4 4 4 4
			  4 4 4 4 4 4 4 4 4 4 4 4 4
			  4 4 4 4 4 4 4 4 4 4 4 4 4>>

;"12th value handles ace schizophrenia"
<GLOBAL CARD-VALUES <TABLE 11 2 3 4 5 6 7 8 9 10 10 10 10 1>>

<GLOBAL CARD-COUNT 0>

;"Returns 0 to 51 inclusive"

<ROUTINE PICK-CARD ("AUX" NUM TMP)
	 <COND (<G? <SETG CARD-COUNT <+ ,CARD-COUNT 1>> 52>
		<TELL
"\"I'm shuffling the decks now.\"" CR>
		<SHUFFLE-DECK>)>
	 <REPEAT ()
		 <SET NUM <- <RANDOM 52> 1>>
		 <COND (,FORCED-BET
			<SET NUM <+ 3 <RANDOM 47>>>)>
		 <COND (<0? <SET TMP <GET ,CARD-TABLE .NUM>>>
			<AGAIN>)
		       (T
			<PUT ,CARD-TABLE .NUM <- .TMP 1>>
			<RETURN .NUM>)>>>

<ROUTINE CARD-VALUE (NUM)
	 ;<COND (,FORCED-BET ;"set to false below"
		<GET ,CARD-VALUES <+ 2 <RANDOM 8>>>)>
	 <GET ,CARD-VALUES </ .NUM 4>>>

<GLOBAL DEALER-HAND <LTABLE 0 0 0 0 0 0 0 0 0 0 0 0>>
<GLOBAL YOUR-HAND  <LTABLE 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0>>
<GLOBAL DEALER-COUNT 0>
<GLOBAL YOUR-COUNT 0>

<ROUTINE DEAL-HAND (TBL)
	 <PUT .TBL 1 <PICK-CARD>>
	 <PUT .TBL 0 1>
	 <PUT .TBL 2 <PICK-CARD>>
	 <PUT .TBL 0 2>>

;"can probably be macro"
<ROUTINE TELL-HAND (TBL "AUX" (CNT <GET .TBL 0>) (1ST T))
	 <REPEAT ()
		 <COND (<0? .CNT> <RETURN>)
		       (T
			<COND (.1ST
			       <SET 1ST <>>)
			      (T <TELL " and the ">)>
			<TELL-CARD <GET .TBL .CNT>>
			<SET CNT <- .CNT 1>>)>>>

<ROUTINE TELL-CARD (NUM)
	 <TELL <GET ,CARD-SPOT </ .NUM 4>>>
	 <TELL " of ">
	 <TELL <GET ,CARD-SUIT <MOD .NUM 4>>>>

<GLOBAL CARD-SPOT <TABLE "ace" "two" "three" "four" "five" "six" "seven"
			  "eight" "nine" "ten" "jack" "queen" "king">>

<GLOBAL CARD-SUIT <TABLE "clubs" "diamonds" "hearts" "spades">>

<ROUTINE PLAY-HAND (BET "AUX" TMP CNT DEALER-HOLE (VAL <>) (DD <>))
	 ;"Reset hands"
	 <PUT ,DEALER-HAND 0 0>
	 <PUT ,YOUR-HAND 0 0>
	 <DEAL-HAND ,DEALER-HAND>
	 <DEAL-HAND ,YOUR-HAND>
	 <TELL "The dealer gives you the ">
	 <TELL-HAND ,YOUR-HAND>
	 <TELL ,PERIOD>
	 <TELL "He deals himself the ">
	 <TELL-CARD <GET ,DEALER-HAND 1>>
	 <TELL " and one card down">
	 <COND (<IN? ,THUMB ,HERE>
		<TELL ", which he peeks at">)>
	 <TELL "." CR CR>
	 <SETG YOUR-COUNT <+ <CARD-VALUE <GET ,YOUR-HAND 1>>
			     <CARD-VALUE <GET ,YOUR-HAND 2>>>>
	 <SETG DEALER-COUNT <+ <CARD-VALUE <GET ,DEALER-HAND 1>>
			       <CARD-VALUE <GET ,DEALER-HAND 2>>>>
	 <COND (<==? ,DEALER-COUNT 21>
		<TELL "The dealer turns over his hole card, which is the ">
		<TELL-CARD <GET ,DEALER-HAND 2>>
		<TELL ". \"Blackjack!\" he announces">
		<COND (<==? ,YOUR-COUNT 21>
		       <TELL ". You tie him for a push." CR>
		       <RETURN 0>)
		      (T
		       <TELL ", as he collects your bet." CR>
		       <RETURN <* .BET -1>>)>)
	       (<==? ,YOUR-COUNT 21>
		<TELL "You show the dealer your blackjack, and he pays you ">
		<SET BET </ <* .BET 3> 2>>
	        <PRINT-AMOUNT .BET>
		<TELL ,PERIOD>
		<RETURN .BET>)
	       (T
		<SETG FORCED-BET <>> 
		<SET DEALER-HOLE <CARD-VALUE <GET ,DEALER-HAND 2>>>
		<COND (<IN? ,THUMB ,HERE>
		       <SETG THUMB-TAPPED T>
		       <TELL "Inexplicably, you feel ">
		       <COND (<EQUAL? .DEALER-HOLE 1 11>
		              <TELL "one tap">)
		             (T
		       	      <TELL N .DEALER-HOLE " taps">)>
		       <TELL " on your foot." CR CR>)>)> 
      	 <REPEAT ()
		 <TELL "Do you want another card? (Y is affirmative): ">
		 <COND (<YES?>
			<SET CNT <+ <GET ,YOUR-HAND 0> 1>>
			<PUT ,YOUR-HAND 0 .CNT>
			<PUT ,YOUR-HAND .CNT <SET TMP <PICK-CARD>>>
			<TELL CR "You're dealt the ">
			<TELL-CARD .TMP>
			<SETG YOUR-COUNT <+ ,YOUR-COUNT <CARD-VALUE .TMP>>>
			<COND (<AND <G? ,YOUR-COUNT 21>
			       	    <NOT <ACE-CHECK>>>
			       <TELL 
" which puts you over 21, and the " D ,DEALER " rakes in your bet." CR>
			       <SET VAL <- 0 .BET>>
			       <RETURN>)
			      (T
			       <TELL ,PERIOD>
			       <AGAIN>)>)
		       (T
			<COND (<G? ,YOUR-COUNT 21>
			       <ACE-CHECK>)>
			<RETURN>)>>
	 <TELL CR "The dealer turns up his hole card, the ">
	 <TELL-CARD <GET ,DEALER-HAND 2>>
	 <COND (.VAL
		<TELL ", and smiles." CR>
		<RETURN .VAL>)
	       (T <TELL "." CR>)>
	 <REPEAT ()
		 <COND (<AND <G? ,DEALER-COUNT 21>
			     <NOT <ACE-CHECK <>>>>
			<TELL "This gives him " N ,DEALER-COUNT
			      ", putting him over. He pays you ">
			<PRINT-AMOUNT .BET>
			<TELL ,PERIOD>
			<RETURN .BET>)
		       (<G? ,DEALER-COUNT 16>
			<TELL "He stops here, with " N ,DEALER-COUNT ".">
			<COND (<G? ,YOUR-COUNT ,DEALER-COUNT>
			       <TELL " You beat him and reap the payoff, ">
			       <PRINT-AMOUNT .BET>
			       <TELL ,PERIOD>
			       <RETURN .BET>)
			      (<==? ,YOUR-COUNT ,DEALER-COUNT>
			       <TELL " Your hand ties his for a push." CR>
			       <RETURN 0>)
			      (T
			       <TELL 
" He beats you and rakes in your money." CR>
			       <RETURN <- 0 .BET>>)>)
		       (T
			<SET CNT <+ <GET ,DEALER-HAND 0> 1>>
			<PUT ,DEALER-HAND 0 .CNT>
			<PUT ,DEALER-HAND .CNT <SET TMP <PICK-CARD>>>
			<SETG DEALER-COUNT <+ ,DEALER-COUNT <CARD-VALUE .TMP>>>
			<COND (.DD
			       <TELL "He draws again">)
			      (T
			       <TELL "The dealer draws">)>
			<TELL " and picks up the ">
			<TELL-CARD .TMP>
			<TELL ,PERIOD>
			<SET DD T>)>>>

<ROUTINE ACE-CHECK ("OPTIONAL" (PLAYER? T) "AUX" CNT TMP HND)
	 <COND (.PLAYER? <SET HND ,YOUR-HAND>)
	       (T <SET HND ,DEALER-HAND>)>
	 <SET CNT <GET .HND 0>>
	 <REPEAT ()
		 <COND (<0? .CNT> <RFALSE>)
		       (<==? <CARD-VALUE <SET TMP <GET .HND .CNT>>> 11>
			<PUT .HND .CNT <+ .TMP 52>>
			<COND (.PLAYER?
			        <SETG YOUR-COUNT <- ,YOUR-COUNT 10>>
				<SET TMP ,YOUR-COUNT>)
			      (T
			        <SETG DEALER-COUNT <- ,DEALER-COUNT 10>>
				<SET TMP ,DEALER-COUNT>)>
			<COND (<L? .TMP 22>
			       <RTRUE>)>)>
		 <SET CNT <- .CNT 1>>>>

<ROUTINE SHUFFLE-DECK ("AUX" (CNT 52))
	 <REPEAT ()
		 <COND (<0? .CNT> <RETURN>)
		       (T
			<SET CNT <- .CNT 1>>
			<PUT ,CARD-TABLE .CNT 4>)>>
	 <SETG CARD-COUNT 0>
	 <ALREADY-GONE ,DEALER-HAND>
	 <ALREADY-GONE ,YOUR-HAND>>

<ROUTINE ALREADY-GONE (HND "AUX" CNT TMP)
	 <SET CNT <GET .HND 0>>
	 <REPEAT ()
		 <COND (<0? .CNT> <RETURN>)
		       (T
			<SET TMP <GET .HND .CNT>>
			<COND (<OR <G? .TMP 52>  ;"changed by JO" 
				   <EQUAL? .TMP 52>>
			       <SET TMP <- .TMP 52>>)>
			<PUT ,CARD-TABLE .TMP <- <GET ,CARD-TABLE .TMP> 1>>)>
		 <SETG CARD-COUNT <+ ,CARD-COUNT 1>>
		 <SET CNT <- .CNT 1>>>>