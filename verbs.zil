"VERBS for
		              BALLYHOO
	(c) Copyright 1986 Infocom, Inc.  All Rights Reserved."

;"subtitle game commands"

<GLOBAL VERBOSITY 1> ;"0 = superbrief, 1 = brief, 2 = verbose"

<ROUTINE V-VERBOSE ()
	 <SETG VERBOSITY 2>
	 <TELL "Maximum verbosity." CR CR>
	 <V-LOOK>>

<ROUTINE V-SAVE ()
	 <COND (<SAVE>
	        <TELL "Ok." CR>)
	       (T
		<TELL "Failed." CR>)>>

<ROUTINE V-RESTORE ()
	 <COND (<RESTORE>
	        <TELL "Ok." CR CR>
		<V-LOOK>)
	       (T
		<TELL "Failed." CR>)>>

<ROUTINE V-SCORE ("OPTIONAL" (ASK? T))
         ;<COND (<L? ,GSCORE 400>
		<TELL
"We are about to give you your score. 
(Hit RETURN or ENTER when ready.) ">
		<PRINTI ">">
		<READ ,P-INBUF ,P-LEXV>
		<SETG P-CONT <>>
		<CRLF>)>
	 <TELL "Your score is " N ,SCORE " of a possible 200, in "
	        N ,MOVES " turn">
	 <COND (<NOT <EQUAL? ,MOVES 1>>
		<TELL "s">)>
	 <TELL ,PERIOD>
	 <RFATAL>>

<ROUTINE V-SCRIPT ()
	<PUT 0 8 <BOR <GET 0 8> 1>>
	<CORP-NOTICE "begins">
	<V-VERSION>>

<ROUTINE V-UNSCRIPT ()
	<CORP-NOTICE "ends">
	<V-VERSION>
	<PUT 0 8 <BAND <GET 0 8> -2>>
	<RTRUE>>

<ROUTINE CORP-NOTICE (STRING)
	 <TELL "Here " .STRING " a transcript with Ballyhoo." CR>>
					  
<ROUTINE V-BRIEF ()
	 <SETG VERBOSITY 1>
	 <TELL "Brief descriptions." CR>>

<ROUTINE V-SUPER-BRIEF ()
	 <SETG VERBOSITY 0>
	 <TELL "Super-brief descriptions." CR>>

<GLOBAL DIED <>>

<ROUTINE V-DIAGNOSE ()
         <COND (<AND <NOT ,DREAMING>
		     <G? ,MEET-COUNTER 7>>
	 	<SETG AWAITING-REPLY 9>
		<ENABLE <QUEUE I-REPLY 2>>
		<TELL 
"Are you really so heartless as to think of your own well-being at a time
like this?" CR>)
	       (T
		<TELL "You're ">
		<COND (<FSET? ,BANANA ,RMUNGBIT>
		       <TELL "still ">)>
		<TELL "famished." CR>)>>
		      
<ROUTINE V-INVENTORY ()  
	 <TELL "You have">
	 <COND (<NOT <FIRST? ,PROTAGONIST>>
		<TELL " ">
		<COND (<ZERO? ,POCKET-CHANGE>
		       <TELL "naught">)
		      (T
		       <PRINT-AMOUNT ,POCKET-CHANGE>
		       <TELL " to your name">)>
		<TELL ,PERIOD>
		<RTRUE>)
	       (T
	        <DESCRIBE-OBJECTS ,PROTAGONIST>
	      ; <COND (<G? ,POCKET-CHANGE 0>
		       <TELL " and">)
		      (T
		       <TELL ,PERIOD>
		       <RTRUE>)>)>
       ; <TELL " ">
       ; <PRINT-AMOUNT ,POCKET-CHANGE>        
       ; <TELL " to your name." CR>
	 <RTRUE>>

; <ROUTINE V-INVENTORY ()  
	 <TELL "You have">
	 <COND (<AND <NOT <FIRST? ,PROTAGONIST>>
	             <ZERO? ,POCKET-CHANGE>>
		<TELL " naught." CR>
		<RTRUE>)>
	 <COND (<FIRST? ,PROTAGONIST>
	        <PRINT-CONTENTS ,PROTAGONIST>
	        <COND (<G? ,POCKET-CHANGE 0>
		       <TELL " and">)
		      (T
		       <TELL ,PERIOD>
		       <RTRUE>)>)>
	 <TELL " ">
	 <PRINT-AMOUNT ,POCKET-CHANGE>        
	 <TELL " to your name." CR>
	 <RTRUE>>
		
<ROUTINE PRINT-AMOUNT (AMT)
	 <TELL "$" N </ .AMT 100> ".">
	 <SET AMT <MOD .AMT 100>>
	 <COND (<0? .AMT>
		<TELL "00">)
	       (<L? .AMT 10>
		<TELL "0" N .AMT>)
	       (T
		<TELL N .AMT>)>>

<ROUTINE V-QUIT ()
	 <V-SCORE>
	 <TELL
"Do you wish to leave the game? (Y is affirmative): ">
	 <COND (<YES?>
		<QUIT>)
	       (T
		<TELL "Ok." CR>)>>

<ROUTINE V-RESTART ()
	 <V-SCORE T>
	 <TELL "Do you wish to restart? (Y is affirmative): ">
	 <COND (<YES?>
		<TELL "Restarting." CR>
		<RESTART>
		<TELL "Failed." CR>)>>

<ROUTINE YES? ()
	 <PRINTI ">">
	 <READ ,P-INBUF ,P-LEXV>
	 <COND (<EQUAL? <GET ,P-LEXV 1> ,W?YES ,W?Y>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE FINISH ("OPTIONAL" (REPEATING <>))
	 <COND (<L? ,EGRESS-C 3>
		<CRLF>)>
	 <COND (<NOT .REPEATING>
		<V-SCORE>
		<CRLF>)>
	 <TELL-FINISH>
	 <READ ,P-INBUF ,P-LEXV>
	 <COND (<EQUAL? <GET ,P-LEXV 1> ,W?RESTAR>
	        <RESTART>
		<TELL "Failed." CR>
		<FINISH T>)
	       (<EQUAL? <GET ,P-LEXV 1> ,W?RESTOR>
		<COND (<RESTORE>
		       <TELL "Ok." CR>)
		      (T
		       <TELL "Failed." CR>
		       <FINISH T>)>)
	       (<EQUAL? <GET ,P-LEXV 1> ,W?QUIT ,W?Q>
		<QUIT>)
	       (T
		<FINISH T>)>>

<ROUTINE TELL-FINISH ()
	 <TELL
"Would you like to start over, restore a saved position, or end this session
of the game? (Type RESTART, RESTORE, or QUIT):|
|
>">>

<ROUTINE V-VERSION ("AUX" (CNT 17) V)
	 <SET V <BAND <GET 0 1> *3777*>>
	 <TELL
"BALLYHOO|
Infocom interactive fiction|
Copyright (c) 1986 by Infocom, Inc. All rights reserved.|
Release " N .V " / Serial number ">
	 <REPEAT ()
		 <COND (<G? <SET CNT <+ .CNT 1>> 23>
			<RETURN>)
		       (T
			<PRINTC <GETB 0 .CNT>>)>>
	 <CRLF>>

<ROUTINE V-$VERIFY ()
	 <COND (<AND <PRSO? ,INTNUM>
		     <EQUAL? ,P-NUMBER 963>>
		<TELL N ,SERIAL CR>)
	       (T
		<TELL "Verifying..." CR>
	 	<COND (<VERIFY>
		       <TELL "Good." CR>)
	       	      (T
		       <TELL CR "** Bad **" CR>)>)>>

<CONSTANT SERIAL 0>

;<GLOBAL DEBUG <>>

;<ROUTINE V-$DEBUG ()
	 <COND (,DEBUG
		<SETG DEBUG <>>
		<TELL "Debugging off." CR>)
	       (T
		<SETG DEBUG T>
		<TELL "Debugging on." CR>)>>

;<ROUTINE V-$CHEAT ()
	 <COND (<NOT <PRSO? INTNUM>>
		<GOTO ,WINGS>)
	       (<EQUAL? ,P-NUMBER 1>
		<MOVE ,NET ,GLOBAL-OBJECTS>
		<MOVE-LIONS ,CHUTE>
		<MOVE ,MUNRAB ,OFFICE>
		<MOVE ,BULL ,LOCAL-GLOBALS>
		<FSET ,OFFICE ,TOUCHBIT>
		<FSET ,LADDER ,RMUNGBIT>
		<FCLEAR ,LION-DOOR ,LOCKEDBIT>
		<FCLEAR ,LION-DOOR ,OPENBIT>
		<FCLEAR ,GRATE ,OPENBIT>
		<FCLEAR ,VEIL ,NDESCBIT>
		<FCLEAR ,DRESS ,NDESCBIT>
		<FCLEAR ,SHAWL ,NDESCBIT>
		<MOVE ,VEIL ,PROTAGONIST>
		<MOVE ,SHAWL ,PROTAGONIST>
		<MOVE ,DRESS ,PROTAGONIST>
		<FSET ,VEIL ,WORNBIT>
		<FSET ,DRESS ,WORNBIT>
		<FSET ,SHAWL ,WORNBIT>
		<MOVE ,TRADE-CARD ,PROTAGONIST>
		<MOVE ,RIBBON ,PROTAGONIST>
		<MOVE ,SHEET ,PROTAGONIST>
		<MOVE ,SCRAP ,PROTAGONIST>
		<MOVE ,NOTE ,PROTAGONIST>
		<MOVE ,RADIO ,PROTAGONIST>
		<FCLEAR ,RIBBON ,INVISIBLE>
		<FCLEAR ,RIBBON ,NDESCBIT>
		<FCLEAR ,RADIO ,NDESCBIT>
		<FSET ,RIBBON ,TOUCHBIT>
		<FSET ,SHEET ,TOUCHBIT>
		<FSET ,NOTE ,TOUCHBIT>
		<FSET ,SCRAP ,TOUCHBIT>
		<FSET ,CASE ,TOUCHBIT>
		<SETG CLOWN-ALLEY-SCENE T>
		<SETG WON-ON-TENT T>
		;<SETG JOEY-NAME-KNOWN T>
		<SETG SEEN-SHEET T>
		<MOVE ,THUMB ,CLOWN-ALLEY>
		<FCLEAR ,THUMB ,NDESCBIT>
		<FSET ,BACK-YARD ,TOUCHBIT>
		<FSET ,CLOWN-ALLEY ,TOUCHBIT>
		<FSET ,CON-AREA ,TOUCHBIT>
		<FSET ,THUMB ,RMUNGBIT>
		<GOTO ,WEST-CAMP>)
	       (<EQUAL? ,P-NUMBER 2>
		<DREAM>
		<SETG SIT-IN-STANDS <>>
		<DISABLE <INT I-STANDS>>
		<MOVE ,PROTAGONIST ,WINGS>
		<MOVE ,MONKEY ,PROTAGONIST>)
	       (T
		<GOTO ,WINGS>)>>

;"subtitle real verbs"

;<ROUTINE V-AGAIN ("AUX" OBJ (N <>))
	 <COND (<NOT ,L-PRSA>
		<TELL "Not until you do something." CR>)
	       (<OR <EQUAL? ,L-PRSA ,V?FIND ,V?FOLLOW ,V?CALL>
		    <EQUAL? ,L-PRSA ,V?WHAT ,V?WHERE ,V?WHO>
		    <EQUAL? ,L-PRSA ,V?WAIT-FOR ,V?WALK-TO ,V?TELL-ABOUT>
		    <EQUAL? ,L-PRSA ,V?ASK-ABOUT ,V?ASK-FOR>>
		<TELL
"Sorry, the Galactic Compendium on Interactive Fiction prohibits the use of
AGAIN after your previous action." CR>
		<SETG PRSA ,V?VERBOSE>) ;"so this won't run the clock"
	       (<EQUAL? ,NOT-HERE-OBJECT ,L-PRSO ,L-PRSI>
		<TELL "You can't see that here." CR>)
	       (<EQUAL? ,L-PRSA ,V?WALK>
		<DO-WALK ,L-PRSO>)
	       (T
		<SET OBJ
		     <COND (<AND ,L-PRSO <NOT <VISIBLE? ,L-PRSO>>>
			    ,L-PRSO)
			   (<AND ,L-PRSI <NOT <VISIBLE? ,L-PRSI>>>
			    ,L-PRSI)>>
		<COND (<AND .OBJ 
			    <NOT <EQUAL? .OBJ ,ROOMS>>>
		       <TELL "You can't see">
		       <COND (.N
			      <TELL " any " D .OBJ " here." CR>)
			     (T
		       	      <ARTICLE .OBJ T>
		       	      <TELL " anymore." CR>)>
		       <RFATAL>)
		      (T
		       ;<COND (,L-FRONT-FLAG
			      <SETG IN-FRONT-FLAG T>)>
	 	       <PERFORM ,L-PRSA ,L-PRSO ,L-PRSI>)>)>>

<ROUTINE V-ADVANCE ()
	 <V-DIG>>

<ROUTINE V-ALARM ()
	 <COND (<PRSO? ,ROOMS>
		<PERFORM ,V?ALARM ,ME>
		<RTRUE>)
	       (T
		<TELL "But">
	        <ARTICLE ,PRSO T>
	        <TELL " isn't asleep." CR>)>>

<ROUTINE V-ANSWER ()
	 <COND (<AND ,AWAITING-REPLY
		<EQUAL? <GET ,P-LEXV ,P-CONT> ,W?YES>>
	        <V-YES>
		<STOP>)
	       (<AND ,AWAITING-REPLY
		     <EQUAL? <GET ,P-LEXV ,P-CONT> ,W?NO>>
		<V-NO>
		<STOP>)
	       (T
		<TELL "Nobody is awaiting your answer." CR>
	        <STOP>)>>

<ROUTINE V-APPLAUD ()
	 <COND (<AND <FSET? ,PRSO ,PERSON>
		     <NOT <EQUAL? ,PRSO ,JERRY ,TEAM ,FAT>>
		     <NOT <EQUAL? ,PRSO ,DICK ,TAFT ,CROWD>>
		     <NOT <EQUAL? ,PRSO ,HAWKER>>>
		<TELL "Gracefully,">
	 	<ARTICLE ,PRSO T>
	 	<TELL " takes a bow." CR>)
	       (<AND <EQUAL? ,PRSO ,CIRCUS>
		     <EQUAL? ,HERE ,STANDS-ROOM>>
		<TELL "You're drowned out." CR>)
	       (T
		<TELL "Not surprisingly,">
		<ARTICLE ,PRSO T>
		<TELL " doesn't react." CR>)>>
	 
<ROUTINE V-ARREST ()
	 <TELL 
"Fine. Since you wield zero police power, the only thing that's getting
arrested around here is your logical faculty." CR>>

;"Having zero police power, you are merely further arresting your 
  logical faculties ... [ , all that you're arresting is your ...]
  Since you wield zero ..." 

<ROUTINE V-ASK-ABOUT ()
	 <COND (<PRSO? ,ME>
		<PERFORM ,V?TELL ,ME>
		<RTRUE>)
	       ;(<FSET? ,PRSO ,ACTORBIT>
		<SETG WINNER ,PRSO>
		<PERFORM ,V?TELL-ABOUT ,ME ,PRSI>
		<RTRUE>)
	       (<FSET? ,PRSO ,ACTORBIT>
		<TELL "A long silence tells you that">
		<ARTICLE ,PRSO T>
		<TELL " isn't interested in talking about">
		<COND (<IN? ,PRSI ,ROOMS>
		       <TELL " that">)
		      (T
		       <ARTICLE ,PRSI T>)>
		<TELL ,PERIOD>)
	       (T
		<PERFORM ,V?TELL ,PRSO>
		<RTRUE>)>>

<ROUTINE V-ASK-FOR ()
	 <TELL "Unsurprisingly,">
	 <ARTICLE ,PRSO T>
	 <TELL " doesn't oblige." CR>>

<ROUTINE V-BALANCE ()
	 <TELL "Your knees wobble a bit." CR>>
	       		
<ROUTINE V-BET ()
	 ;<COND (<NOT <EQUAL? ,HERE ,BLUE-ROOM>>)>
		<TELL "You can't bet here." CR>>    

<ROUTINE V-BITE ()
	 <HACK-HACK "Biting">>

<ROUTINE PRE-BOARD ()
	 <COND (<AND <PRSO? <LOC ,PROTAGONIST>>
		     <NOT ,IN-FRONT-FLAG>>
		<TELL ,LOOK-AROUND CR>)
	       (<EQUAL? ,P-PRSA-WORD ,W?CUT>
		<SETG IN-FRONT-FLAG T>
		<RFALSE>)
	       (<AND <EQUAL? ,POCKET-CHANGE 1281>
		     <EQUAL? ,PRSO ,LONG ,SHORT>>
		<TELL 
"You've lost all patience for waiting in line." CR>)
	       (<AND <HELD? ,PRSO>
		     <NOT <PRSO? ,SUIT>>>
		<TELL "You're holding it!" CR>)>>

<ROUTINE V-BOARD ("AUX" AV)
	 <SET AV <LOC ,PROTAGONIST>>
	 <COND (<AND <EQUAL? ,PRSO ,LONG ,SHORT>
		     <EQUAL? <LOC ,PROTAGONIST> ,SHORT ,LONG>>
		<OUT-OF-FIRST .AV> 
		<RTRUE>)>  
         <COND (<AND <EQUAL? ,PRSO ,SHORT>		
		     <NOT <EQUAL? ,LINE-COUNTER 1>>
		     <NOT <FSET? ,LONG ,RMUNGBIT>>>		
		<MOVE ,PROTAGONIST ,LONG>
		<ENTER-LINE>
		<RTRUE>)>
	 <COND (<FSET? ,PRSO ,VEHBIT>                                  
		<TELL "You are now ">
		<COND (<EQUAL? ,PRSO ,LONG ,SHORT>
		       <TELL ,TAIL-END>)
		      (T
		       <TELL "on">)>     
		<ARTICLE ,PRSO T>
		<TELL ,PERIOD>		
		<MOVE ,WINNER ,PRSO>
		<APPLY <GETP ,PRSO ,P?ACTION> ,M-ENTER>
		<RTRUE>)
	       (,IN-FRONT-FLAG
		<V-DIG>)
	       (T
	        <TELL "You can't get onto">
		<ARTICLE ,PRSO T>
		<TELL "!" CR>)>>

<ROUTINE V-BRIBE ()
	 <COND (<NOT ,PRSI>
		<PERFORM ,V?GIVE ,GLOBAL-MONEY ,PRSO>
		<RTRUE>)
	       (T
		<PERFORM ,V?GIVE ,PRSI ,PRSO>
		<RTRUE>)>>

<ROUTINE PRE-BUY ()
	 <COND (<AND ,PRSI
		     <NOT <EQUAL? ,PRSI ,HAWKER ,CON ,CONCESSIONAIRE>>>
		<TELL "But">
		<ARTICLE ,PRSI T>
		<TELL " isn't selling." CR>)>>

<ROUTINE V-BUY ()
	 <TELL "Sorry,">
	 <COND (<EQUAL? ,PRSO ,TICKET>
		<TELL " a ticket">)
	       ;(<IS-NOUN? ,W?TOFU>
		<TELL " tofu">)
	       (T
		<ARTICLE ,PRSO T>)>
	 <TELL " isn't for sale." CR>>

<ROUTINE V-CALL () ;"prso need not be in room"
	 <COND (<EQUAL? ,HERE ,OFFICE>
		<PERFORM ,V?PHONE ,PRSO>
		<RTRUE>)
	       (<AND <NOT <EQUAL? <META-LOC ,PRSO> ,HERE>>
	             <NOT <EQUAL? ,PRSO ,ME>>
		     <NOT <GLOBAL-IN? ,PRSO ,HERE>>>
		<CANT-SEE ,PRSO>)
	       (T
		<PERFORM ,V?TELL ,PRSO>
		<RTRUE>)>>

<ROUTINE V-CATCH-WITH ()
	 <PERFORM ,V?TAKE-WITH ,PRSO ,PRSI>
	 <RTRUE>>

<ROUTINE V-CHASTISE ()
	 <COND (<EQUAL? ,PRSO ,INTDIR>
		<PERFORM ,V?LOOK>
		<RTRUE>)
	       (T
		<TELL
"Use prepositions to indicate precisely what you want to do: LOOK AT the
object, LOOK INSIDE it, LOOK UNDER it, etc." CR>)>>

<ROUTINE V-CHEAT ()
	 <COND (<AND <EQUAL? ,HERE ,BLUE-ROOM>
		     <OR <NOT ,PRSO>
			 <EQUAL? ,PRSO ,BLACKJACK ,TABLE ,DEALER>>>
		<COND (<IN? ,HERE ,THUMB>
		       <PERFORM ,V?BET ,GLOBAL-MONEY>
		       <RTRUE>)
		      (T
		       <TELL "You'll need help." CR>
	       	       <RTRUE>)>)>
	 <TELL <PICK-ONE ,YUKS> CR>
	 <RTRUE>>

<ROUTINE V-CLAP ("AUX" ACTOR)
	 <COND (,PRSO
		<PERFORM ,V?RUB ,PRSO>
		<RTRUE>)
	       (<AND ,END-GAME
		     <IN? ,JIM ,HERE>>
		<TELL "The " D ,JIM>
	        <COND (<FSET? ,JIM ,RMUNGBIT>
		       <FCLEAR ,JIM ,RMUNGBIT>
		       <TELL 
" snaps out of his trance with a shake of his head.">)
		      (T
		       <FSET ,JIM ,RMUNGBIT>
		       <TELL		        
"'s eyes widen and become vacant as some invisible force comes over him.
He straightens up out of his usual slouch and appears perfectly rigid.">)>
	        <CRLF>)
	       (<AND <EQUAL? ,HERE ,BACK-YARD>
		     <IN? ,THUMB ,HERE>>
		<SETG PRSO ,THUMB>
		<PERFORM ,V?APPLAUD ,PRSO>
		<RTRUE>)	       
	       (<EQUAL? ,HERE ,STANDS-ROOM>
		<PERFORM ,V?APPLAUD ,CIRCUS>
		<RTRUE>)
	       (<SETG PRSO <FIND-IN ,HERE ,ACTORBIT>>		    
		<PERFORM ,V?APPLAUD ,PRSO>
		<RTRUE>)
	       (<PRSO? ,FAT>
		<PERFORM ,V?TELL ,FAT>
		<RTRUE>)
	       (T
		<TELL "Clap!" CR>)>>

<ROUTINE V-CLEAN ()
         <TELL "But">
	 <ARTICLE ,PRSO T>
	 <TELL " isn't all that dirty." CR>>

<ROUTINE V-CLIMB-DOWN ()
	 <COND (<PRSO? ,ROOMS>
		<DO-WALK ,P?DOWN>)
	       (T
		<V-COUNT>)>>

<ROUTINE V-CLIMB-FOO ()
	 <COND (<EQUAL? ,PRSO ,INTDIR>
		<CRAWL-DIR>
		<RTRUE>)
	       (<PRSO? ,ROOMS>
		<COND ;(<EQUAL? ,HERE ,CLOWN-ALLEY>
		       <PERFORM ,V?BOARD ,LADDER>)
		      (<EQUAL? ,HERE ,ON-WAGON ,PLATFORM-1>
		       <DOWN-LADDER>)
		      (T
		       <DO-WALK ,P?UP>)>)
	       (<EQUAL? ,PRSO ,TAMER-TRAILER ,WAGON ,CLOWN-TRAILER>
		<PERFORM ,V?CLIMB-ON ,PRSO>
		<RTRUE>)
	       (T
		<V-COUNT>)>>

<ROUTINE V-CLIMB-ON ()
	 <COND (<OR <FSET? ,PRSO ,VEHBIT>	
		    <AND <EQUAL? ,PRSO ,LONG ,SHORT>
			 <EQUAL? ,P-PRSA-WORD ,W?GET>>>
		 <PERFORM ,V?BOARD ,PRSO>
		 <RTRUE>)
	       (<PRSO? ,GRANDSTAND>
		<PERFORM ,V?SIT>
		<RTRUE>)
	       (<PRSO? ,STAIRCASE>
		<V-DIG>)
	       (T
		<TELL "You can't climb onto">
		<ARTICLE ,PRSO T>
		<TELL ,PERIOD>)>>

<ROUTINE V-CLIMB-OVER ()
	 <V-COUNT>>

<ROUTINE V-CLIMB-UP ()
	 <COND (<PRSO? ,ROOMS>
		<DO-WALK ,P?UP>)
	       (T
		<V-INHALE>)>>

<ROUTINE V-CLOSE ()
	 <COND (<FSET? ,PRSO ,SURFACEBIT>
		<V-COUNT>)
	       (<FSET? ,PRSO ,ACTORBIT>
	        <V-COUNT>)
	       (<OR <FSET? ,PRSO ,DOORBIT>
		    <FSET? ,PRSO ,CONTBIT>>
		<COND (<FSET? ,PRSO ,OPENBIT>
		       <TELL "Okay,">
		       <ARTICLE ,PRSO T>
		       <TELL " is now closed." CR>
		       <FCLEAR ,PRSO ,OPENBIT>)
		      (T
		       <TELL ,ALREADY-CLOSED CR>)>)
	       (T
		<CANT-OPEN>)>>

<ROUTINE PRE-COMPARE ()
 	 <COND (<OR <AND <NOT ,PRSI>
		     	 <EQUAL? 1 <GET ,P-PRSO 0>>>
		    <EQUAL? 2 <GET ,P-PRSO 0>>>	     	
		<TELL "Try typing \"COMPARE IT TO (something).\"" CR>
		<RFATAL>)>>

<ROUTINE V-COMPARE ()
        <COND (<EQUAL? ,PRSO ,PRSI> 
	       <TELL "The self-same thing." CR>)
       	      (T 
	       <TELL "Like Rimshaw,">
	       <ARTICLE ,PRSO T>
	       <TELL " is incomparable." CR>
	       <RTRUE>)>>

<ROUTINE V-COUNT ()
	 <TELL <PICK-ONE ,IMPOSSIBLES> CR>>

;<ROUTINE V-COUNT-BACK ()
	 <COND (<AND <EQUAL? ,P-DIRECTION ,P?SOUTH>
		     <PRSI? ,INTNUM>>
		<COND (,DREAMING
		       <TELL 
"You are presently unconscious of such recourse." CR>)>
		<COUNT-PRINT>
		<COND (<AND ,MEMORY-JOGGED
		            <FSET? ,RIBBON ,RMUNGBIT>
			    <NOT <FSET? ,TRADE-CARD ,RMUNGBIT>>>
		       <FCLEAR ,RIBBON ,RMUNGBIT>
		       <TELL CR
"You travel back to the nether regions of your unconscious mind ..." CR>)>)
	       (T
		<V-DIG>)>>

;<ROUTINE COUNT-PRINT ("AUX" CNT (TIMES 0))
	 <COND (<NOT <PRSI? ,INTNUM>> ;"I.E., FROM HYP-F"
		<SET CNT 100>)
	       (T
		<SET CNT ,P-NUMBER>)> ;"I.E., FROM VERB COUNT-BACK"
	 <TELL 
"With transcendental calm you begin mouthing the words, \"">
	 <REPEAT ()		 
	       	 <SET CNT <- .CNT 1>>
		 <SET TIMES <+ .TIMES 1>>
		 <TELL N .CNT " ... " >		 
		 <COND (<G? .TIMES <+ 3 <RANDOM 4>>>
			    ;<L? .CNT 1> ;"I CAN GET NEGATIVE NUM.S AS OUTPUT"
		       	<TELL "\"" CR>
			<RETURN>)>>>

<ROUTINE V-CRAWL-UNDER ()
	 <COND (<EQUAL? ,PRSO ,INTDIR>
		<CRAWL-DIR>
		<RTRUE>)
	       (<NOT <FSET? ,PRSO ,TAKEBIT>>
	        <TELL-HIT-HEAD>)
	       (<PRSO? ,STAND>
		<V-DIG>)
	       (T
		<V-COUNT>)>>

<ROUTINE V-CUT ()
	 <COND (<NOT ,PRSI>
		<V-INHALE>)
	       (T
		<TELL "It's doubtful the \"cutting edge\" of">
		<ARTICLE ,PRSI>
		<TELL " is adequate." CR>)>>

<ROUTINE V-DIG ()
	 <TELL <PICK-ONE ,WASTES> CR>>

<ROUTINE V-DISEMBARK ()
	 <COND (<AND <FSET? ,PRSO ,TAKEBIT> ;"since GET OUT is also TAKE OUT"
		     <EQUAL? <META-LOC ,PRSO> ,HERE>
		     <NOT <IN? ,PRSO ,HERE>>
		     <NOT <IN? ,PRSO ,PROTAGONIST>>>
		<PERFORM ,V?TAKE ,PRSO>
		<RTRUE>)
	       (<NOT <EQUAL? <LOC ,WINNER> ,PRSO>>
		<TELL ,LOOK-AROUND CR>
		<RFATAL>)
	       (T
		<COND (<AND <EQUAL? ,PRSO ,LONG ,SHORT>
		            <NOT <EQUAL? ,LINE-COUNTER 0 1>>
			    <OR <EQUAL? ,LINE-COUNTER 4 5>
				<EQUAL? ,LINE-COUNTER 2 3>>>
		       <COND (<EQUAL? ,LINE-COUNTER 2 3>
			      <TELL 
"You hesitate momentarily, as your line has appears to be about to move." CR>
			      <RTRUE>)>
		       <SETG P-CONT <>>
		       <SETG CLOCK-WAIT T>
		       <SETG AWAITING-REPLY 1>
		       <ENABLE <QUEUE I-REPLY 2>>
		       <TELL
"You hear an inner voice whisper, \"Do I really want to forfeit my position in
the " D ,PRSO "?\" To which you answer:" CR>)  
		      (T		       
	               <TELL "You get ">
		       <COND (<PRSO? ,SOFA ,STAND>
			      <TELL "off">)
			     (T
			      <TELL "out">)>
		       <TELL " of the " D ,PRSO "." CR>
	               <MOVE ,WINNER ,HERE>)>)>>

<ROUTINE V-DRINK ()
	 <TELL "You can't drink that!" CR>>

<ROUTINE V-DRINK-FROM ()
	 <V-COUNT>>

<ROUTINE V-DRIVE ()	
	 <V-COUNT>>

<ROUTINE PRE-DROP ()
	 <COND (<IDROP>
		<RTRUE>)>>

<ROUTINE V-DROP ()
	 <MOVE ,PRSO ,HERE>
	 <COND (<PRSO? ,FAT-HAND>
		<FSET ,FAT-HAND ,NDESCBIT>)>
	<TELL "Dropped." CR>>

<ROUTINE V-EAT ()
	 <TELL "Stuffing your face with">
	 <ARTICLE ,PRSO T>
	 <TELL " would do little to help at this point." CR>>

<ROUTINE V-EJECT ()
	 <V-COUNT>>

<ROUTINE V-EMPTY ("AUX" OBJ NXT)
	 <COND (<FSET? ,PRSO ,CONTBIT>
		<COND (<FSET? ,PRSO ,OPENBIT>
		       <SET OBJ <FIRST? ,PRSO>>
		       <COND (.OBJ
			      <REPEAT ()
				      <COND (.OBJ
					     <SET NXT <NEXT? .OBJ>>
					     <COND (<NOT <FSET? .OBJ
							  ,NARTICLEBIT>>
						    <TELL "The ">)>
					     <TELL D .OBJ ": ">
					     <PERFORM ,V?TAKE .OBJ ,PRSO>
					     <SET OBJ .NXT>)
					    (T
					     <RETURN>)>>)
			     (T
			      <TELL "It's already empty!" CR>)>)
		      (T
		       <TELL "It's closed." CR>)>)
	       (T
		<V-COUNT>)>
	 <RTRUE>>

<ROUTINE V-ENTER ("AUX" VEHICLE)
	 <COND (<AND <SET VEHICLE <FIND-IN ,HERE ,VEHBIT>>
		     <NOT <EQUAL? .VEHICLE ,STOOL>>>
		<PERFORM ,V?BOARD .VEHICLE>
		<RTRUE>)
	       (T
	        <DO-WALK ,P?IN>)>>
	
<ROUTINE V-EXAMINE ()
	 <COND (<AND <OR <FSET? ,PRSO ,DOORBIT>
		         <FSET? ,PRSO ,SURFACEBIT>>
		     <NOT <PRSO? ,SOFA ,TRAP>>>
		<V-LOOK-INSIDE>)
	       (<AND <FSET? ,PRSO ,CONTBIT>
		     <NOT <FSET? ,PRSO ,ACTORBIT>>
		     <AND <NOT <EQUAL? ,PRSO ,COAT ,COMPARTMENT ,TRAP>>
			  <NOT <EQUAL? ,PRSO ,SOFA ,RADIO>>>>
		<COND (<FSET? ,PRSO ,OPENBIT>
		       <V-LOOK-INSIDE>)
		      (T
		       <TELL "It's closed." CR>)>)
	       (<FSET? ,PRSO ,CLEARBIT>
		<TELL "It's invisible, naturally." CR>)
	       (<PRSO? ,HEAD ,BACK>
		<TELL "That would involve quite a contortion." CR>)
	       (T
	        <TELL "You see">
		<COND (<AND <PRSO? ,SOFA ,CHANDELIER>
			    <FSET? ,PRSO ,RMUNGBIT>>
		       <TELL ", indeed,">)>
		<TELL " nothing " <PICK-ONE ,YAWNS> " about">
		<COND (<OR <IS-NOUN? ,W?TABLECLOTH>
		           <IS-NOUN? ,W?CLOTH>>
		       <TELL " the tablecloth">)
		      (T
		       <ARTICLE ,PRSO T>)>
		<COND (<EQUAL? ,PRSO ,HYP>
		       <TELL " (contrary to his billing)">)
		      (<EQUAL? ,PRSO ,THUMB>
		       <TELL " (except that he's about two feet high)">)>
		<TELL ".">
		<CRLF>)>>

<ROUTINE V-EXAMINE-THROUGH ()
	 <TELL "This reveals nothing new." CR>>

<ROUTINE V-EXIT ()
	 <COND (<AND ,PRSO
		     <FSET? ,PRSO ,VEHBIT>>
		<PERFORM ,V?DISEMBARK ,PRSO>
		<RTRUE>)
	       (T
		<DO-WALK ,P?OUT>)>>

<ROUTINE V-FEED ("AUX" (FOOD <>))
	 <COND (<AND <PRSO? ,MOUSE>
		     <HELD? ,CHEESE>>
		<SET FOOD ,CHEESE>)
	       (<HELD? ,MEAT>
		<SET FOOD ,MEAT>)
	       (<HELD? ,GRANOLA>
		<SET FOOD ,GRANOLA>)
	       (<HELD? ,BANANA>
		<SET FOOD ,BANANA>)
	       (<HELD? ,CHEESE>
		<SET FOOD ,CHEESE>)>
	 <COND (.FOOD		    
		<TELL "(the " D .FOOD ")" CR>
		<PERFORM ,V?GIVE .FOOD ,PRSO>
		<RTRUE>)
	       (T
		<TELL "You have nothing to feed">
		<ARTICLE ,PRSO T>
		<TELL " with." CR>)>>

<ROUTINE V-FILL ()
	 <COND (<NOT ,PRSI>
		<COND (<EQUAL? ,HERE ,CON-AREA>
		       <PERFORM ,V?FILL ,PRSO ,GLOBAL-WATER>
		       <RTRUE>)
		      (<AND <FSET? ,PRSO ,CONTBIT>
			    <NOT <ZERO? <GETP ,PRSO ,P?CAPACITY>>>>
		       <TELL "There's nothing to fill it with." CR>)
		      (T
		       <V-COUNT>)>)
	       (<EQUAL? ,PRSI ,GLOBAL-WATER ,WATER>
		<COND (<IN? ,WATER ,PRSO>
		       <TELL "It's already full." CR>)
		      (<NOT <EQUAL? ,HERE ,CON-AREA>>
		       <CANT-SEE ,WATER>)
		      (<NOT <EQUAL? ,PRSO ,BUCKET>>
		       <V-COUNT>)
		      (<FIRST? ,BUCKET>
		       <TELL "That would get">
		       <PRINT-CONTENTS ,BUCKET T> ;"def. article"
		       <TELL " all wet." CR>)
		      (T
		       <MOVE ,WATER ,BUCKET>
		       <TELL 
"A good measure of " D ,WATER " gurgles into the " D ,BUCKET "." CR>)>)
	       (<EQUAL? ,PRSI ,WATER>
		<PERFORM ,V?POUR ,WATER ,PRSO>
		<SETG P-IT-OBJECT ,PRSO>
		<RTRUE>)
	       (T 
		<V-COUNT>)>>

<ROUTINE V-FIND ("OPTIONAL" (WHERE <>) "AUX" (L <LOC ,PRSO>))
	 <COND ;(<PRSO? ,HANDS ,HEAD ,EARS ,TEETH ,EYES>
		<TELL "Are you sure">
		<ARTICLE ,PRSO T>
		<TELL " is lost?" CR>)
	       (<PRSO? ,ME>
		<TELL "You're in">
		<ARTICLE ,HERE T>
		<TELL ,PERIOD>)
	       (<IN? ,PRSO ,PROTAGONIST>
		<TELL "You have it!" CR>)
	       (<AND <PRSO? KEY>
		     <FSET? ,KEY ,TRYTAKEBIT>>
		<WHERE-FIND .WHERE>)
	       (<IN? ,PRSO ,HERE>		     
		<TELL "Right in front of you." CR>)
	       (<OR <IN? ,PRSO ,GLOBAL-OBJECTS>
		    <GLOBAL-IN? ,PRSO ,HERE>>
		<TELL "You figure it out!" CR>)
	       (<AND <FSET? .L ,ACTORBIT>
		     <VISIBLE? .L>>
		<TELL "As far as you can tell,">
		<ARTICLE .L T>
		<TELL " has it." CR>)
	       (<AND <FSET? .L ,CONTBIT>
		     <VISIBLE? ,PRSO>
		     <NOT <IN? .L ,GLOBAL-OBJECTS>>>
		<TELL "It's in">
		<ARTICLE .L T>
		<TELL ,PERIOD>)
	       (T
		<WHERE-FIND .WHERE>)>>

<ROUTINE WHERE-FIND ("OPTIONAL" (WHERE <>))
	 <COND (.WHERE
		<TELL "Beats me." CR>)
	       (T
		<TELL "You'll have to do that yourself." CR>)>>

<ROUTINE V-FIRST-LOOK ()
	 <COND (<DESCRIBE-ROOM>
		<COND (<EQUAL? ,VERBOSITY 1 2>
		       <DESCRIBE-OBJECTS>)>)>>

<ROUTINE V-FOLLOW ()
	 <COND (<OR <IN? ,PRSO ,HERE>
		    <AND <EQUAL? ,PRSO ,CROWD>
			 <EQUAL? ,HERE ,STANDS-ROOM>>>
		<TELL "But">
		<ARTICLE ,PRSO T>
		<TELL " is right here!" CR>)
	       (<NOT <FSET? ,PRSO ,ACTORBIT>>
		<V-COUNT>)
	       (<AND <EQUAL? ,PRSO ,JIM>
		     <NOT ,END-GAME>
		     <EQUAL? ,HERE ,WINGS>>
		<DO-WALK ,P?SOUTH>)
	       (T
		<WHICH-WAY>
		<WHICH-WAY>
		<CRLF>)>>

<ROUTINE WHICH-WAY ()
	 <TELL "Which way did ">
	 <COND (<FSET? ,PRSO ,FEMALE>
	 	<TELL "s">)>
	 <TELL "he go? ">>

<GLOBAL FOLLOW-FLAG <>>

<ROUTINE I-FOLLOW ()
	 <COND (<AND <EQUAL? ,FOLLOW-FLAG 4>
		     <EQUAL? ,HERE ,EAST-CAMP>>
		<TELL 
"The " D ,CURTAINS "s part slightly and are quickly drawn back." CR>)>
	 <SETG FOLLOW-FLAG <>>
	 <RFALSE>>

<ROUTINE PRE-GIVE ()
	 <COND (<AND <VERB? GIVE>
		     <PRSO? ,HANDS>>
		<COND (<PRSI? ,HYP>
		       <SETG WINNER ,HYP>
		       <PERFORM ,V?READ ,HANDS>
		       <SETG WINNER ,PROTAGONIST>
		       <RTRUE>)>
		<PERFORM ,V?SHAKE-WITH ,PRSI>
		<RTRUE>)
	       (<IDROP>
		<RTRUE>)>>

<ROUTINE V-GET-DOWN ()
	 <COND (<PRSO? ,ROOMS>
		<DO-WALK ,P?DOWN>)
	       (T
		<PERFORM ,V?TAKE-OFF ,PRSO>
		<RTRUE>)>>

<ROUTINE V-GIVE ()
	 <COND (<AND <FSET? ,PRSI ,ACTORBIT>
		     <NOT <EQUAL? ,PRSI ,TAFT>>>
		<COND (<AND <PRSI? ,DICK>
			    ,DICK-DRUNK>
		       <TELL "Haplessly,">)
		      (T
		       <TELL "Briskly,">)>
		<ARTICLE ,PRSI T>
		<TELL " refuses your offer." CR>)
	       (T
		<TELL "You can't give">
		<ARTICLE ,PRSO>
		<TELL " to">
		<ARTICLE ,PRSI>
		<TELL "!" CR>)>>

;<ROUTINE V-GIVE-UP ()
	 <COND (<PRSO? ,ROOMS>
		<V-QUIT>)
	       (T
		<V-TELL-TIME>)>>

<ROUTINE V-HANG-UP ()
	<V-DIG>>

<ROUTINE V-HELLO ()
       ;<COND (<NOT ,PRSO>
	      <SET ACTOR <FIND-IN ,HERE ,ACTORBIT>>)>
       <COND (<AND ,PRSO
	           <FSET? ,PRSO ,ACTORBIT>>
	      <TELL "\"Hello.\"" CR>
	      <STOP>)
	     (,PRSO
	      <PERFORM ,V?TELL ,PRSO>
	      <RTRUE>)
	     (T
	      <PERFORM ,V?TELL ,ME>
	      <RTRUE>)>>

<ROUTINE V-HELP ()
	 <TELL
"If you're really stuck, maps and hint booklets are available from your
dealer, or via mail order with the form that came in your package." CR>>

<ROUTINE V-HIDE ()
	 <COND (<AND <NOT ,PRSO>
		     <IN? ,TAFT ,HERE>
		     <RUNNING? ,I-MEET>>
		<PERFORM ,V?HIDE-BEHIND ,TAFT>
		<RTRUE>)
	       (T
		<COND (<AND <EQUAL? ,HERE ,PROP-ROOM>
			    <PRSO? ,TAFT>>
		       <TELL "There's no need to">)
		      (T
		       <TELL "You can't">)>
		<TELL " hide ">
		<COND (,PRSO
		       <TELL "t">)>
		<TELL "here." CR>)>>

<ROUTINE V-HIDE-BEHIND ()
	 <COND (,HIDING
		<TELL ,YOU-ARE CR>
		<RTRUE>)		
	       (T
		<V-DIG>)>>

<ROUTINE V-HYPNOTISE ()
	 <COND (<ENABLED? ,I-HYP> ;"ie, rimshaw asked me what i want"
	        <COND (<FSET? ,MASK ,WORNBIT>
		       <PERFORM ,V?TELL ,HYP>
		       <RTRUE>)>
		<SETG WINNER ,HYP>
		<PERFORM ,V?HYPNOTISE ,PRSO>
		<SETG WINNER ,PROTAGONIST>
		<RTRUE>)
	       (<PRSO? ,ME>
		<TELL ,HOW CR>)
	       (<FSET? ,PRSO ,ACTORBIT>
		<TELL ,IT-LOOKS-LIKE>
		<ARTICLE ,PRSO T>
		<COND (<NOT <FSET? ,PRSO ,PERSON>>
		       <TELL ", though not lacking in animal magnetism,">)>
		<TELL " is not hypnotizable." CR>)
	       (T
		<V-COUNT>)>>

;<ROUTINE V-I-AM ()
	 <TELL "Pleased to meet you. I'm your computer." CR>>

;<ROUTINE V-IDIOT ()
	 <PERFORM ,V?TELL ,ME>
	 <RTRUE>>

<ROUTINE V-INHALE ()
	 <COND (<PRSO? ,AIR>
		<TELL "Deep-breathing -- good for the health." CR>)
	       (T
	        <V-COUNT>)>>

<ROUTINE V-KICK ()
	 <HACK-HACK "Flailing your leg at">>

<ROUTINE V-KILL ()
	 <COND (<AND <EQUAL? ,PRSO ,TRAP>
		     <NOT <FSET? ,TRAP ,RMUNGBIT>>>
		<COND (,PRSI       		    
		       <PERFORM ,V?TAKE ,TRAP>
		       <RTRUE>)
		      (T
		       <TELL 
"\"SNAP!\" The " D ,TRAP " does a back flip." CR>)>)
	       (<AND <FSET? ,PRSO ,ACTORBIT>
		     <NOT <EQUAL? ,PRSO ,FAT ,TAFT ,THUMB>>>
		<TELL "Thinking of your own safety, you refrain." CR>)
	       (T
		<TELL <PICK-ONE ,YUKS> CR>)>>

;<ROUTINE V-KNEEL ()
	 <V-TASTE>>

<ROUTINE V-KNOCK ()
	 <COND (<FSET? ,PRSO ,DOORBIT>
		<COND (<FSET? ,PRSO ,OPENBIT>
		       <PERFORM ,V?OPEN ,PRSO>
		       <RTRUE>)
		      (T
		       <TELL "Silence answers back." CR>)>)
	       (T
		<HACK-HACK "Knocking on">)>>

<ROUTINE V-KISS ()
	<COND (<AND <FSET? ,PRSO ,PERSON>
		    <NOT <EQUAL? ,PRSO ,TAFT>>>
	       <TELL "It would be totally out of character for">
	       <ARTICLE ,PRSO T>
	       <TELL " to be smooching with you right now." CR>
	       <RTRUE>)
	      (<AND <FSET? ,PRSO ,ACTORBIT>
		    <NOT <FSET? ,PRSO ,PERSON>>>
	       <TELL
"The ASPCA has taken people to court for lesser offences!" CR>)
	      (T
	       <TELL "Kissed." CR>)>>

<ROUTINE V-LAMP-OFF ()
	 <TELL "You can't turn that off." CR>>

<ROUTINE V-LAMP-ON ()
	 <TELL "You can't turn that on." CR>>

<ROUTINE V-LEAP ()
	 <COND (<AND ,PRSO
		     <NOT <IN? ,PRSO ,HERE>>>
		<V-COUNT>)
	       (<AND ,PRSO
		     <FSET? ,PRSO ,PERSON>>
		<PERFORM ,V?KILL ,PRSO>
		<RTRUE>)
	       (<IN? ,PROTAGONIST ,SOFA>
		<V-COUNT>) 
	       (T
		<TELL "Your feet barely leave the ground." CR>)>>

<ROUTINE V-LEAP-OFF ()
	 <COND (<FSET? ,PRSO ,VEHBIT>
		<PERFORM ,V?DISEMBARK ,PRSO>
		<RTRUE>)
	       (T
		<PERFORM ,V?LEAP ,PRSO>
		<RTRUE>)>>

<ROUTINE V-LEAN ()
	 <COND (<EQUAL? ,HERE ,TIGHTROPE-ROOM>
		<COND (<AND <RUNNING? ,I-TREMBLE>
			    <EQUAL? ,P-DIRECTION ,P?SOUTH ,P?NORTH>>
		       <COND (<OR <AND <EQUAL? ,P-DIRECTION ,P?SOUTH>
			               <NOT ,LEAN-NORTH?>>
				  <AND <EQUAL? ,P-DIRECTION ,P?NORTH>
				       ,LEAN-NORTH?>>
			      <TELL ,UNBALANCED>
		      	      <FLYING>		      
		      	      <TELL "And you fall ...">
		      	      <FALL-DOWN>
			      <RTRUE>)
			     (<PROB 40>
			      <TELL 
"Overly cautious, you don't put enough of " D ,ME " in that " D ,INTDIR "."
CR>)
			     (T
			      <TELL "You overcompensate, and are now">
			      <LEANING>
			      <COND (,LEAN-NORTH?
				     <LEAN>)
				    (T
				     <LEAN T>)>)>)
		     (T
		      <FLYING>
		      <TELL "You drop like a quail ...">
		      <FALL-DOWN>
		      <RTRUE>)>)
	       (T
		<V-DIG>)>>
			      		
<ROUTINE V-LEAVE ()
	 <COND (<NOT ,PRSO>
		<SETG PRSO ,ROOMS>)>
	 <COND (<PRSO? ,ROOMS>
		<DO-WALK ,P?OUT>)
	       (<OR <FSET? ,PRSO ,VEHBIT>
		    <EQUAL? ,PRSO ,LONG ,SHORT>>
		<PERFORM ,V?DISEMBARK ,PRSO>
		<RTRUE>)
	       (T
		<PERFORM ,V?DROP ,PRSO>
		<RTRUE>)>>

<ROUTINE V-LIE-DOWN ()
	 <TELL "There's no time for that." CR>>

<ROUTINE V-LISTEN ()
	 <TELL "At the moment,">
	 <ARTICLE ,PRSO T>
	 <TELL " makes no sound." CR>>

<ROUTINE PRE-LOCK ()
	 <COND (<EQUAL? ,PRSO ,CHAIN ,BULL>
		<RFALSE>)
	       (<OR <EQUAL? ,PRSO ,CURTAINS>
		    <AND <NOT <FSET? ,PRSO ,DOORBIT>>
		         <NOT <EQUAL? ,PRSO ,KIESTER ,BAGGAGE-COMPARTMENT
				      ,CAGE>>
			 <NOT <EQUAL? ,PRSO ,LION-CAGE ,DESK>>>>
		<V-COUNT>
		<RTRUE>)	       
	       (<AND <EQUAL? ,HERE ,OFFICE>
		     <EQUAL? ,PRSO ,OFFICE-DOOR>
		     <NOT ,PRSI>>
		<RFALSE>)
	       (<AND <EQUAL? ,HERE ,OFFICE>
		     <EQUAL? ,PRSO ,OFFICE-DOOR>
		     ,PRSI
		     <PRSI? ,KEY>>
	        <TELL 
"(You don't need the key, which doesn't fit anyway.) " CR CR>
		<RFALSE>)>
	 <COND (<AND <NOT ,PRSI>
		     <HELD? ,KEY>
		     <NOT <AND <EQUAL? ,HERE ,OFFICE>
			       <EQUAL? ,PRSO ,OFFICE-DOOR>>>>
	        <SETG PRSI ,KEY>
		<TELL "(with the key)" CR>
		<RFALSE>)>
	 <COND (<PRSI? ,KEY>
		<RFALSE>)
	       (T
		<TELL "The " D ,PRSO " cannot be ">
		<COND (<VERB? UNLOCK>
		       <TELL "un">)>
		<TELL "locked with">
		<COND (,PRSI
		       <ARTICLE ,PRSI T>)
		      (T
		       <TELL " " D ,HANDS>)>
		<TELL ,PERIOD>)>
	 <RTRUE>>

<ROUTINE V-LOCK ()
	 <COND (<OR <FSET? ,PRSO ,DOORBIT>
		    <PRSO? ,KIESTER ,BAGGAGE-COMPARTMENT ,DESK>>
		<COND (<FSET? ,PRSO ,OPENBIT>
		       <TELL "But the " D ,PRSO " is open." CR>
		       <RTRUE>)
		      (<FSET? ,PRSO ,LOCKEDBIT>
		       <TELL "It already is." CR>)
		      (<AND <NOT <FSET? ,PRSO ,CAGEBIT>>
			    <NOT <EQUAL? ,HERE ,OFFICE>>>
		       <CANT-LOCK> ;"ie, this doesn't work"
		       <RTRUE>)
		      (T
	               <FSET ,PRSO ,LOCKEDBIT>
		       <TELL
"Okay, the " D ,PRSO " is now locked." CR>)>)
	       (T
		<TELL <PICK-ONE ,YUKS> CR>)>>

;<ROUTINE V-LOCK ()
	 <COND (<FSET? ,PRSO ,DOORBIT>
	        <COND (<OR <AND <EQUAL? ,PRSI ,KEY>
				<NOT <EQUAL? ,PRSO ,OFFICE-DOOR>>>
			   <AND <EQUAL? ,HERE ,OFFICE>
				<EQUAL? ,PRSO ,OFFICE-DOOR>
			        <NOT <EQUAL? ,PRSO ,KEY>>>>
		      		)
		       (T
			<TELL "This doesn't work." CR>)>)
	          (T
		   <V-COUNT>)>>

<ROUTINE V-LOOK ()
	 <DESCRIBE-ROOM T>
	 <DESCRIBE-OBJECTS>>

<ROUTINE V-LOOK-BEHIND ()
	 <COND (<FSET? ,PRSO ,DOORBIT>
		<PERFORM ,V?LOOK-INSIDE ,PRSO>
		<RTRUE>)>
	 <TELL "There is nothing ">
	 <COND (<PRSO? ,CHUTE>
		<TELL "on the other side of">)
	       (T
		<TELL "behind">)>
	 <ARTICLE ,PRSO T>
	 <TELL ,PERIOD>>

<ROUTINE V-LOOK-DOWN ()
	 <COND (<NOT ,LIT>
		<TELL ,TOO-DARK CR>)
	       (<EQUAL? ,HERE ,TIGHTROPE-ROOM ,PLATFORM-1 ,PLATFORM-2>
		<COND (<EQUAL? ,APE-LOC 2 3>
		       <TELL 
"Without looking down, you're confident the net is properly positioned under
the girl and not " D ,ME ". It's the kind of confidence that makes your
knees buckle.">)
		      ;(<EQUAL? ,APE-LOC 4>
		       <TELL 
"Your neck won't stretch down that far, but you sense a very genuine new
spirit of harmony among these circus people as they all attend to the safety
of the girl.">)
		      (T
		       <TELL 
"First lesson of a wire walker: NEVER look down. ">
		       <COND (<IN? ,NET ,RING>
			      <TELL 
"However, you trust the net is in place.">)>)>
		<CRLF>)
	       (<PRSO? ,ROOMS>
		<PERFORM ,V?EXAMINE ,GROUND>
		<RTRUE>)
	       (T
		<PERFORM ,V?LOOK-INSIDE ,PRSO>
		<RTRUE>)>>

<ROUTINE V-LOOK-INSIDE ()
	 <COND (<PRSO? ,LIGHT ,DARKNESS>
		<PERFORM ,V?EXAMINE ,PRSO>
		<RTRUE>)
	       (<FSET? ,PRSO ,ACTORBIT>
		<TELL "There is nothing special to be seen." CR>)
	       (<FSET? ,PRSO ,SURFACEBIT>
		<COND (<PRSO? <LOC ,WINNER>>
		       <DESCRIBE-VEHICLE>
		       <RTRUE>)
		      (T
	               <TELL ,YOU-SEE>
		       <PRINT-CONTENTS ,PRSO>
		       <TELL " on">
		       <ARTICLE ,PRSO T>
		       <TELL ,PERIOD>)>)
	       (<FSET? ,PRSO ,DOORBIT>
		<TELL "All you can tell is that">
		<COND (<FSET? ,PRSO ,OPENBIT>
		       <ARTICLE ,PRSO T>
		       <TELL " is open.">)
		      (T
		       <ARTICLE ,PRSO T>
		       <TELL " is closed.">)>
		<CRLF>)
	       (<AND <FSET? ,PRSO ,CONTBIT>
		     <NOT <PRSO? ,BALLOON>>>
		<COND (<PRSO? <LOC ,WINNER>>
		       <DESCRIBE-VEHICLE>
		       <RTRUE>)
		      (<SEE-INSIDE? ,PRSO>
		       <COND (<FIRST? ,PRSO>
			      <TELL ,YOU-SEE>
			      <PRINT-CONTENTS ,PRSO>
			      <COND (<EQUAL? ,PRSO ,RING>
				     <TELL " on">)
				    (T
				     <TELL " in">)>
			      <ARTICLE ,PRSO T>)
			     (T
			      <TELL ,EMPTY>)>
		       <TELL ,PERIOD>)
		      (<AND <NOT <FSET? ,PRSO ,OPENBIT>>
			    <FIRST? ,PRSO>>
		       <PERFORM ,V?OPEN ,PRSO>
		       <RTRUE>)
		      (T
		       <TELL "It seems that">
		       <ARTICLE ,PRSO T>
		       <TELL " is closed." CR>)>)
	       (T
		<TELL "You can't do that." CR>)>>

<ROUTINE V-LOOK-ON ()
	 <COND (<FSET? ,PRSO ,SURFACEBIT>
		<PERFORM ,V?LOOK-INSIDE ,PRSO>)
	       (T
		<PERFORM ,V?EXAMINE ,PRSO>
	 	<RTRUE>)>> 

<ROUTINE V-LOOK-OUTSIDE ()
	 <COND (<OR <FSET? ,PRSO ,DOORBIT>
		    <FSET? ,PRSO ,TRANSBIT>
		    <PRSO? ,VEIL>>
		<PERFORM ,V?LOOK-INSIDE ,PRSO>
		<RTRUE>)
	       (T
		<V-LOOK>
		<RTRUE>)>>

<ROUTINE V-LOOK-UNDER ()
	 <COND (<HELD? ,PRSO>
		<COND (<FSET? ,PRSO ,WORNBIT>
		       <TELL "You're wearing it!" CR>)
		      (T
		       <TELL "You're holding it!" CR>)>)
	       (<AND <PRSO? ,STRAW>
		     <EQUAL? ,HERE ,APE-ROOM>
		     <NOT <FSET? ,TRAP-DOOR ,OPENBIT>>>
		<FCLEAR ,TRAP-DOOR ,INVISIBLE>
	        <TELL 
"Under the coarse layer of " D ,STRAW " the outline of a " D ,TRAP-DOOR "
is visible." CR>)
	       (T
		<TELL "There's nothing eye-catching under">
		<ARTICLE ,PRSO T>
		<COND (<AND <EQUAL? ,HERE ,MEN ,NOOK>
			    <PRSO? ,STRAW>>
		       <TELL " that's within reach">)
		      (<AND <EQUAL? ,HERE ,APE-ROOM>
			    <PRSO? ,STRAW>>
		       <TELL " except the ">
		       <OPEN-CLOSED ,TRAP-DOOR>
		       <TELL " " D ,TRAP-DOOR>)>
		<TELL ,PERIOD>)>>

<ROUTINE V-LOOK-UP ()
	 <COND (<NOT ,LIT>
		<TELL ,TOO-DARK CR>)
	       (<PRSO? ,ROOMS>
		<COND (<NOT <FSET? ,HERE ,INDOORSBIT>>
		       <TELL "The sky is ">
		       <COND (,DREAMING
			      <TELL "deep blue.">)
			     (T
			      <TELL "an inky black.">)>
		       <CRLF>)
		      (<AND <EQUAL? ,HERE ,RING>
			    <NOT ,END-GAME>>
		       <TELL 
,YOU-SEE " the supporting apparatus for the " D ,TIGHTROPE-OBJECT "." CR>)
		      (<EQUAL? ,HERE ,UNDER-STANDS>
		       <TELL 
"From here the " D ,GRANDSTAND " resembles a huge venetian blind, letting in
broad panels of hazy light." CR>)
		      (<AND <EQUAL? ,HERE ,RING ,PLATFORM-1 ,TIGHTROPE-ROOM>
			    ,APE-LOC>
		       <TELL-APE>
		       <CRLF>)
		      (<AND <EQUAL? ,HERE ,PLATFORM-2>
			    <NOT <FSET? ,BALLOON ,TOUCHBIT>>>
		       <TELL <GETP ,BALLOON ,P?FDESC> CR>)
		      (<AND <EQUAL? ,HERE ,BULL-ROOM>
			    <NOT <FSET? ,BURN-HOLE ,INVISIBLE>>>
		       <TELL ,YOU-SEE " " D ,BURN-HOLE "s." CR>)
		      (T
		       <PERFORM ,V?EXAMINE ,CEILING>
		       <RTRUE>)>)
	       (T
		<PERFORM ,V?LOOK-INSIDE ,PRSO>
		<RTRUE>)>>

<ROUTINE V-LOWER ()
	 <V-RAISE>>

<ROUTINE V-MAKE ()
	 <TELL "You can't make">
	 <ARTICLE ,PRSO>
	 <TELL "!" CR>>

<ROUTINE V-MOVE ()
	 <COND (<HELD? ,PRSO>
		<TELL "Why juggle objects?" CR>)
	       (<LOC-CLOSED>
		<RTRUE>)
	       (<OR <FSET? ,PRSO ,TAKEBIT>
		    <FSET? ,PRSO ,TRYTAKEBIT>>
		<TELL "Moving">
		<ARTICLE ,PRSO T>
		<TELL " reveals nothing." CR>)
	       (T
		<TELL "You can't move">
		<ARTICLE ,PRSO T>
		<TELL ,PERIOD>)>>

<ROUTINE V-MUNG ()
	 <HACK-HACK "Trying to break">>

;<ROUTINE V-MY-NAME ()
	 <COND (<PRSO? ,NAME>
		<V-I-AM>)
	       (T
		<V-TELL-TIME>)>>

<ROUTINE V-NO ()
	 <COND (<EQUAL? ,AWAITING-REPLY 1>
		;<APPLY <GETP <LOC ,PROTAGONIST> ,P?ACTION> ,M-BEG>
		<PERFORM ,V?WAIT>
		<RTRUE>)
	       (<EQUAL? ,AWAITING-REPLY 2>
		<TELL "Contain " D ,ME "." CR>)
	       (<EQUAL? ,AWAITING-REPLY 3>
		<TELL "You should start." CR>)
	       (<EQUAL? ,AWAITING-REPLY 4>
		<TELL "Right. ">
	        <V-YES>)
	       (<EQUAL? ,AWAITING-REPLY 5>
		<TELL "Then you don't need it." CR>)
	       (<EQUAL? ,AWAITING-REPLY 6>
		<COND (<EQUAL? ,DID-C 0>		       
		       <TELL "\"Of course you did now, didn't you?\"">)
		      (T		       
		       <TELL "\"Did so.\"">)>
		<FCLEAR ,PROTAGONIST ,RMUNGBIT> ;"Can't win Did puzzle"
		<CRLF>)
	       (<EQUAL? ,AWAITING-REPLY 7>
		<TELL "Quit your " D ,GRANDSTAND "ing." CR>)
	       (<AND <EQUAL? ,AWAITING-REPLY 8>
		     <IN? ,CON ,HERE>>
		<PERFORM ,V?ASK-ABOUT ,CON ,FLASK>
		<RTRUE>)
	       (<EQUAL? ,AWAITING-REPLY 9>
		<TELL "We didn't think so." CR>)
	       (<EQUAL? ,AWAITING-REPLY 10>
		<SETG AWAITING-REPLY 11>
		<V-YES>)
	       (<EQUAL? ,AWAITING-REPLY 11>
		<DO-WALK ,P?SOUTH>)
	       (<EQUAL? ,AWAITING-REPLY 12>
		<SETG EGRESS-C 0>
		<TELL "That's the spirit." CR>)
	       (<EQUAL? ,AWAITING-REPLY 13>
		<TELL "Then think of one." CR>)
	       (T
		<TELL "You sound rather negative." CR>)>>
	                    
<ROUTINE V-OPEN ("AUX" F STR)
	 <COND (<FSET? ,PRSO ,SURFACEBIT>
		<V-COUNT>)
	       (<FSET? ,PRSO ,ACTORBIT>
		<V-COUNT>)
	       (<OR <AND <PRSO? ,BAGGAGE-COMPARTMENT>
			 <NOT <FSET? ,BAGGAGE-COMPARTMENT ,LOCKEDBIT>>>
		    <AND <FSET? ,PRSO ,CONTBIT>
		         <NOT 
			  <EQUAL? ,PRSO ,KIESTER ,BAGGAGE-COMPARTMENT ,DESK>>>>
		<COND (<FSET? ,PRSO ,OPENBIT>
		       <TELL ,ALREADY-OPEN CR>)
		      (T
		       <FSET ,PRSO ,OPENBIT>
		       <FSET ,PRSO ,TOUCHBIT>
		       <COND (<OR <NOT <FIRST? ,PRSO>>
				  <FSET? ,PRSO ,TRANSBIT>>
			      <TELL "Opened." CR>)
			     (T
			      <TELL "Opening">
			      <ARTICLE ,PRSO T>
			      <TELL " reveals">
			      <PRINT-CONTENTS ,PRSO>
			      <TELL ,PERIOD>)>)>)
	       (<OR <FSET? ,PRSO ,DOORBIT>             ;"see above clause"
		    <PRSO? ,KIESTER ,BAGGAGE-COMPARTMENT ,DESK>>
		<COND (<AND <VERB? OPEN>
		            <EQUAL? ,PRSI ,KEY>>
	               <PERFORM ,V?UNLOCK ,PRSO ,KEY>
		       <RTRUE>)
	       	      (<NOT <FSET? ,PRSO ,LOCKEDBIT>>
		       <COND (<NOT <FSET? ,PRSO ,OPENBIT>>
			      <FSET ,PRSO ,OPENBIT>
			      <TELL "The " D ,PRSO " ">
			      <COND (<PRSO? ,BLUE-DOOR ,CURTAINS>
				     <TELL "slides">)
				    (<PRSO? ,LION-DOOR ,ROUST-DOOR ,APE-DOOR>
				     <TELL "creaks slowly">)
				    (T
				     <TELL "swings">)>
			      <TELL " open." CR>)
			     (T
			      <TELL "It's already open." CR>)>)
		      (T
		       <TELL "The " D ,PRSO " is locked." CR>)>)
	       (T
		<CANT-OPEN>)>>

<ROUTINE V-PASS ("AUX" ACTOR)
	 <COND (<AND <EQUAL? ,P-PRSA-WORD ,W?PAY>
		     <NOT <EQUAL? ,PRSO ,INTNUM>>
		     <NOT ,PRSI>>
		<SPECIFY-MONEY>
		<RFATAL>)
		(<OR <FSET? ,PRSO ,TAKEBIT>
		    <EQUAL? ,PRSO ,INTNUM ,GLOBAL-MONEY ,DOLLAR>>
		<COND (<OR <SET ACTOR <FIND-IN ,HERE ,ACTORBIT>>
			   <SET ACTOR <FIND-IN ,PROTAGONIST ,ACTORBIT>>>
		       <TELL "(to">
		       <ARTICLE .ACTOR T>
		       <TELL ")" CR>
		       <PERFORM ,V?GIVE ,PRSO .ACTOR>
		       <RTRUE>)
		      (T
		       <V-COUNT>)>)
	       (T
		<SETG IN-FRONT-FLAG T>
		<PERFORM ,V?BOARD ,PRSO>
		<RTRUE>)>>

<ROUTINE V-PHONE ()
	 <COND (<NOT <EQUAL? ,HERE ,OFFICE>>
		;<SETG PRSO ,PHONE>
		<CANT-SEE <> "the phone">)	       
	       (<OR <PRSO? ,RADIO ,DIAL ,WPDL>
		    <AND <PRSO? ,INTNUM>
			 <EQUAL? ,P-NUMBER 1170>>>
		<COND (<AND ,END-GAME
			    <FSET? ,DIAL ,RMUNGBIT>>
		       <SETG CALLED-STATION T>
		       <TELL 
"After verifying, via computer, your credit card number, home address,
social security number, and credit rating, the cheerful voice on the
other end of the line takes your pledge and hangs up." CR>)
		      (T
         	       <TELL "The line is busy." CR>)>)
	       (<EQUAL? ,PRSO ,HOME>
		<TELL "E.T. quit this " D ,CIRCUS " long ago." CR>)
	       (<EQUAL? ,PRSO ,INTNUM>
		<COND (<AND <EQUAL? ,P-EXCHANGE 0>
			    <EQUAL? ,P-NUMBER 0>>
		       <TELL
"The operator suggests you dial 411 for information." CR>)
		      (<AND <EQUAL? ,P-EXCHANGE 0>
			    <EQUAL? ,P-NUMBER 411>>
		       <TELL 
"A recording informs you to consult your directory." CR>)
		      (<AND <EQUAL? ,P-EXCHANGE 0>
			    <EQUAL? ,P-NUMBER 911>>
		       <PERFORM ,V?PHONE ,POLICE>
		       <RTRUE>)
		      ;(<AND <EQUAL? ,P-EXCHANGE 555>
			    <EQUAL? ,P-NUMBER 9009>>
		       <PERFORM ,V?PHONE ,COSTUME-SHOP>)
		      (T
		       <TELL ,BUSY>)>)
	       	 (T
		  <TELL ,BUSY>)>>

<ROUTINE V-PHONE-WITH ()
	 <COND (<NOT <PRSI? ,PHONE>>
		<TELL "You can't use">
		<ARTICLE ,PRSI>
		<TELL " as a " D ,PHONE "." CR>)
	       (T
		<PERFORM ,V?PHONE ,PRSO>
		<RTRUE>)>>

<ROUTINE V-PICK ()
	 <COND (<FSET? ,PRSO ,DOORBIT>
		<TELL "You're no locksmith." CR>)
	       (T
		<V-COUNT>)>>

<ROUTINE V-PICK-UP ()
	 <PERFORM ,V?TAKE ,PRSO ,PRSI>
	 <RTRUE>>

<ROUTINE V-PLAY ()
	 <V-COUNT>>

;<ROUTINE V-PLANT ()
	 <COND (<PRSI? ,FLOWERPOT>
		<PERFORM ,V?PUT ,PRSO ,PRSI>
		<RTRUE>)
	       (T
		<TELL "You can't plant something in">
		<ARTICLE ,PRSI>
		<TELL ,PERIOD>)>>

;<ROUTINE V-PLUG ()
	 <TELL "You can't seem to plug">
	 <ARTICLE ,PRSO T>
	 <TELL " into">
	 <ARTICLE ,PRSI T>
	 <TELL ,PERIOD>>

;<ROUTINE V-POINT ()
	 <COND (<EQUAL? ,HERE ,SPEEDBOAT>
		<PERFORM ,V?STEER ,BOAT-OBJECT ,PRSO>
		<RTRUE>)
	       (T
		<V-STEER>)>>

<ROUTINE V-POUR ()
	 <V-INHALE>>

;<ROUTINE V-PROTEST ()
	 <COND (<AND <EQUAL? ,HERE ,FRONT-OF-HOUSE>
		     <RUNNING? ,I-BULLDOZER>>
		<TELL
"Prosser says \"I wouldn't stop the " D ,BULLDOZER " even if you were lying in
front of it!\"" CR>)
	       (T
		<TELL "To whom? About what? Why?" CR>)>>

;<ROUTINE V-PULL-TOGETHER ()
	 <V-TELL-TIME>>

<ROUTINE V-PUNCH ()
	 <PERFORM ,V?KILL ,PRSO>
	 <RTRUE>>

<ROUTINE V-PUSH ()
	 <COND (<AND <PRSO? ,POLE>
		     <NOT <FSET? ,POLE ,TOUCHBIT>>>
		<PERFORM ,V?TAKE ,POLE>
		<RTRUE>)
	       (<EQUAL? ,P-PRSA-WORD ,W?PULL>
		<HACK-HACK "Pulling">)	       
	       (T
		<HACK-HACK "Pushing">)>>

<ROUTINE PRE-PUT ()
	 <COND (<OR <PRSI? ,GROUND ,SAWDUST ,STRAW>
		    <AND <PRSI? ,CENTER-POLE>
			 <IS-NOUN? ,W?SAWDUST>>>
		<COND (<GETP ,HERE ,P?GROUND-LOC>
		       <PERFORM ,V?THROW-OFF ,PRSO ,CAGE>)
		      (T
		       <PERFORM ,V?DROP ,PRSO>
		       <RTRUE>)>
		<RTRUE>)
	       (<AND <PRSO? ,KEY>
		     <FSET? ,KEY ,TRYTAKEBIT>>
		<PERFORM ,V?TAKE-WITH ,KEY ,PRSI>
		<RTRUE>)
	       (<AND <VERB? PUT>
		     <EQUAL? ,HERE ,CON-AREA>
		     <PRSO? ,GLOBAL-WATER>
		     ,PRSI>
		<PERFORM ,V?FILL ,PRSI ,GLOBAL-WATER>
		<RTRUE>)
	       (<PRSO? ,HANDS>
		<COND (<VERB? PUT>
		       <PERFORM ,V?REACH-IN ,PRSI>
		       <RTRUE>)
		      (T
		       <V-COUNT>)>)
	       (<HELD? ,PRSI ,PRSO>
;"formerly <PRSO? <LOC ,PRSI>> but that only checked down one level"
		<TELL "You can't put">
		<ARTICLE ,PRSO T>
		<TELL " in">
		<ARTICLE ,PRSI T>
		<TELL " when">
		<ARTICLE ,PRSI T>
		<TELL " is already in">
		<ARTICLE ,PRSO T>
		<TELL "!" CR>)
	       (,IN-FRONT-FLAG
		<V-DIG>)
	       (<IDROP>
		<RTRUE>)>>

<ROUTINE V-PUT ()
	 <COND (<AND <NOT <FSET? ,PRSI ,OPENBIT>>
		     <NOT <FSET? ,PRSI ,DOORBIT>>
		     <NOT <FSET? ,PRSI ,CONTBIT>>
		     <NOT <FSET? ,PRSI ,SURFACEBIT>>
		     <NOT <FSET? ,PRSI ,VEHBIT>>>
		<TELL "You can't put">
		<ARTICLE ,PRSO T>
		<TELL " in">
		<ARTICLE ,PRSI>
		<TELL "!" CR>
		<RTRUE>)
	       (<FSET? ,PRSI ,ACTORBIT>
		<V-COUNT>)
	       (<OR <PRSI? ,PRSO>
		    <AND <HELD? ,PRSO>
			 <NOT <FSET? ,PRSO ,TAKEBIT>>>>
		<TELL "How can you do that?" CR>)
	       (<AND <NOT <FSET? ,PRSI ,OPENBIT>>
		     <NOT <FSET? ,PRSI ,SURFACEBIT>>>
		<TELL "Inspection reveals that">
		<ARTICLE ,PRSI T>
		<TELL " isn't open." CR>
		<SETG P-IT-OBJECT ,PRSI>)
	       (<IN? ,PRSO ,PRSI>
		<TELL "But">
		<ARTICLE ,PRSO T>
		<TELL " is already in">
		<ARTICLE ,PRSI T>
		<TELL ,PERIOD>)
	       (<G? <- <+ <WEIGHT ,PRSI> <GETP ,PRSO ,P?SIZE>>
		       <GETP ,PRSI ,P?SIZE>>
		    <GETP ,PRSI ,P?CAPACITY>>
		<COND (<AND <FSET? ,PRSI ,VEHBIT>
			    <NOT <EQUAL? ,PRSI ,STAND>>>
		       <V-DIG>)
		      (T
		       <TELL "There's no room ">
		       <COND (<FSET? ,PRSO ,SURFACEBIT>
			      <TELL "on">)
			     (T
			      <TELL "in">)>
		       <TELL " the " D ,PRSI " for">
		       <ARTICLE ,PRSO T>
		       <TELL ,PERIOD>)>)
	       (<AND <NOT <HELD? ,PRSO>>
		     <EQUAL? <ITAKE> ,M-FATAL <>>>
		<RTRUE>)
	       (T
		<MOVE ,PRSO ,PRSI>
		<FSET ,PRSO ,TOUCHBIT>
		<TELL "Done." CR>)>>

<ROUTINE V-PUT-BEHIND ()
	 <V-DIG>>

;<ROUTINE V-PUT-IN-FRONT ()
	 <V-DIG>>

<ROUTINE V-PUT-ON ()
	 <COND (<OR <PRSI? ,ME>
		    <AND <PRSI? ,HEAD>
		         <PRSO? ,MASK>>>
		<PERFORM ,V?WEAR ,PRSO>
		<RTRUE>)
	       (<FSET? ,PRSI ,SURFACEBIT>
		<V-PUT>)
	       (<AND <FSET? ,PRSI ,PERSON>
		     <NOT <EQUAL? ,PRSI ,TAFT ,DICK ,FAT>>>
		<TELL "Perturbed,">
		<ARTICLE ,PRSI T>
		<TELL " stays your mischievous hand." CR>)
	       (<AND <FSET? ,PRSO ,WEARBIT>
		     <FSET? ,PRSI ,ACTORBIT>>
		<TELL "The " D ,PRSO " isn't">
		<ARTICLE ,PRSI T>
	        <TELL "'s style." CR>)
	       (T
		<TELL "There's no good surface on">
		<ARTICLE ,PRSI T>
		<TELL ,PERIOD>)>>

<ROUTINE V-PUT-OUTSIDE ()
	 <COND (<AND <EQUAL? ,HERE ,DEN>
		     <PRSI? ,LION-CAGE>>
		<PERFORM ,V?THROW ,PRSO ,LION-CAGE>
		<RTRUE>)
	       (T
		<V-DIG>)>>

<ROUTINE V-PUT-UNDER ()
         <V-DIG>>

<ROUTINE V-RAISE ()
	 <HACK-HACK "Playing in this way with">>

<ROUTINE V-REACH-IN ("AUX" OBJ)
	 <SET OBJ <FIRST? ,PRSO>>
	 <COND (<OR <FSET? ,PRSO ,ACTORBIT>
		    <FSET? ,PRSO ,SURFACEBIT>
		    <NOT <FSET? ,PRSO ,CONTBIT>>>
		<TELL <PICK-ONE ,YUKS> CR>)
	       (<NOT <FSET? ,PRSO ,OPENBIT>>
		<TELL "It's not open." CR>)
	       (<OR <NOT .OBJ>
		    <FSET? .OBJ ,INVISIBLE>
		    <NOT <FSET? .OBJ ,TAKEBIT>>>
		<TELL "There's nothing in">
		<ARTICLE ,PRSO T>
		<TELL ,PERIOD>)
	       (<AND <PRSO? ,BUCKET>
		     <IN? ,WATER ,BUCKET>>
	        <TELL ,ALL-WET>)
	       (T
		<TELL "You reach into">
		<ARTICLE ,PRSO T>
		<TELL " and feel something." CR>
		<SETG P-IT-OBJECT <FIRST? ,PRSO>>
		<RTRUE>)>>

<ROUTINE PRE-READ ()
	 <COND (<NOT ,LIT>
		<TELL ,TOO-DARK CR>)
	       (<PRSO? HEAD>
		<PERFORM ,V?RUB ,HEAD>
		<RTRUE>)
	       (<AND ,PRSI
		     <NOT <FSET? ,PRSI ,TRANSBIT>>>
		<TELL "How does one look through">
		<ARTICLE ,PRSI>
		<TELL "?" CR>)>>

<ROUTINE V-READ ()
	      ;(<FSET? ,PRSO ,READBIT>
		<TELL <GETP ,PRSO ,P?TEXT> CR>)
         <TELL "How can you read">
	 <ARTICLE ,PRSO>
	 <TELL "?" CR>>

<ROUTINE V-RECORD ()
	 <COND (<VISIBLE? ,HEADPHONES>
		<PERFORM ,V?RECORD ,HEADPHONES>
		<RTRUE>)
	       (T
	        <V-DIG>)>>

<ROUTINE V-RELEASE ()
	 <COND (<AND <PRSO? ,ROOMS>
		     <IN? ,PROD ,PROTAGONIST>>
		<PERFORM ,V?DROP ,PROD>
		<RTRUE>)
	       (<PRSO? ,ROOMS>
		<V-COUNT>)
	       (T
		<PERFORM ,V?DROP ,PRSO>
		<RTRUE>)>>

<ROUTINE V-REWIND ()
	 <V-DIG>>

;<ROUTINE V-REFUSE ()
	 <SETG PRSA ,V?TAKE>
	 <DONT-F>>

;<ROUTINE V-RELAX ()
	 <TELL ,ZEN CR>>

<ROUTINE V-REMOVE ()
	 <COND (<FSET? ,PRSO ,WEARBIT>
		<PERFORM ,V?TAKE-OFF ,PRSO>
		<RTRUE>)
	       (T
		<PERFORM ,V?TAKE ,PRSO>
		<RTRUE>)>>

;<ROUTINE V-REPLACE ()
	 <TELL "It's not in need of replacement." CR>>

;<ROUTINE V-REPAIR ()
	 <COND (<OR <AND <PRSO? ,THUMB>
		         <FSET? ,THUMB ,MUNGEDBIT>>
		    <AND <PRSO? ,HATCH>
			 ,LANDED>>
		<TELL "You have neither the tools nor the expertise." CR>)
	       (T
		<TELL "I'm not sure it's broken." CR>)>>

<ROUTINE V-REPLY ()
	 <TELL "It is hardly likely that">
	 <ARTICLE ,PRSO T>
	 <TELL " is interested." CR>
	 <STOP>>

<ROUTINE V-RUB ()
	 <COND (<LOC-CLOSED>
		<RTRUE>)
	       (<PRSO? ,HEAD>
		<TELL 
"You feel the bumps but lack the interpretive skills of the phrenologist." CR>)
	       (T
		<HACK-HACK "Fiddling with">)>>

<ROUTINE V-SAVE-SOMETHING ()
	 <COND (<AND <RUNNING? ,I-BOOST>
		     <IN? ,THUMB ,HERE>>
		<PERFORM ,V?RAISE ,THUMB>
		<RTRUE>)
	       (T
		<TELL "Sorry, but">
	 	<ARTICLE ,PRSO T>
	 	<TELL " is beyond help." CR>)>>

;<ROUTINE V-SAY ("AUX" V)
	 <COND (<AND ,AWAITING-REPLY
		     <EQUAL? <GET ,P-LEXV ,P-CONT> ,W?YES>>
		<V-YES>
		<STOP>)
	       (<AND ,AWAITING-REPLY
		     <EQUAL? <GET ,P-LEXV ,P-CONT> ,W?NO>>
		<V-NO>
		<STOP>)
	       ;(<AND <IN? ,GUARD ,HERE>
		     <OR <AND <PRSO? ,HELLO-OBJECT>
			      <NOT ,PRSI>>
			 <AND <PRSO? ,HELLO-OBJECT>
			      <PRSI? ,GUARD>>>>
		<PERFORM ,V?HELLO ,GUARD>
		<RTRUE>)
	       (<SET V <FIND-IN ,HERE ,ACTORBIT>>
		<TELL "You must address">
		<ARTICLE .V T>
		<TELL " directly." CR>
		<STOP>)
	       (T
		<PERFORM ,V?TELL ,ME>
		<STOP>)>>

<ROUTINE V-SEARCH ()
	 <COND (<AND <FSET? ,PRSO ,PERSON>
		     <NOT <EQUAL? ,PRSO ,TAFT ,CROWD>>>
		<TELL "It seems">
		<ARTICLE ,PRSO T>
		<TELL 
" isn't the sort of person who'd allow such a frisking without a search
warrant." CR>
		<RTRUE>)
	       (<FSET? ,PRSO ,CONTBIT>
		<COND (<PRSO? <LOC ,WINNER>>
		       <DESCRIBE-VEHICLE>
		       <RTRUE>)
		      (<NOT <FSET? ,PRSO ,OPENBIT>>
		       <TELL-OPEN-FIRST>
		       <RTRUE>)
		      (<AND <FIRST? ,PRSO>
			    <NOT <FSET? <FIRST? ,PRSO> ,NDESCBIT>>>
		       <TELL ,YOU-SEE>
		       <PRINT-CONTENTS ,PRSO>
		       <TELL ,PERIOD>
		       <RTRUE>)>)>
	 <TELL "You find nothing unusual." CR>>

<ROUTINE V-SEARCH-OBJECT-FOR ()
	 <COND (<FSET? ,PRSO ,PERSON>
		<PERFORM ,V?SEARCH ,PRSO>)
	       (<AND <FSET? ,PRSO ,CONTBIT>
		     <NOT <FSET? ,PRSO ,OPENBIT>>>
		<TELL-OPEN-FIRST>)
	       (<OR <IN? ,PRSI ,PRSO>
		    <IN? ,PRSI ,HERE>>
		<TELL "Very observant. There "
			<COND (<FSET? ,PRSI ,FEMALE> "she")
			      (<FSET? ,PRSI ,PERSON> "he")
			      (T "it")>
			" is." CR>)
	       (T 
		<TELL "You don't find">
		<ARTICLE ,PRSI T>
		<TELL " there." CR>)>>

<ROUTINE TELL-OPEN-FIRST ()
	 <TELL "You'll have to open">
	 <ARTICLE ,PRSO T>
	 <TELL " first." CR>>

<ROUTINE V-SET ()
	 <COND (<PRSO? ,ROOMS>
		<COND (<EQUAL? ,HERE ,TIGHTROPE-ROOM>	
		       <COND (,HEADING-EAST?
			      <DO-WALK ,P?WEST>)
			     (T
			      <DO-WALK ,P?EAST>)>)
		      (T
		       <TELL <PICK-ONE ,WASTES> CR>)>)
	       (<NOT ,PRSI>
	        <COND (<AND <EQUAL? ,PRSO ,RADIO ,DIAL>
			    <FSET? ,RADIO ,ONBIT>>
		       <TELL 
"Without setting the dial to a specific number, you pick up mostly static,
interspersed with even more irritating snippets of talk and music." CR>)
		      (T
		       <COND (<FSET? ,PRSO ,TAKEBIT>
		              <HACK-HACK "Turning">)
			     (T
			      <TELL ,NOT-HOLDING>
			      <ARTICLE ,PRSO T>
			      <TELL ,PERIOD>)>)>)
	       (T
		<V-COUNT>)>>

<ROUTINE V-SGIVE ()
	 <PERFORM ,V?GIVE ,PRSI ,PRSO>
	 <RTRUE>>

<ROUTINE V-SHAKE ("AUX" X)
	 <COND (<FSET? ,PRSO ,ACTORBIT>
		<TELL "Be real." CR>)
	       (T
		<HACK-HACK "Shaking">)>>

<ROUTINE V-SHAKE-WITH ()
	 <COND (<NOT <PRSO? ,HANDS>>
		<V-TELL-TIME>)
	       (<NOT <FSET? ,PRSI ,ACTORBIT>>
		<TELL "But">
		<ARTICLE ,PRSI T>
		<TELL " doesn't even have hands." CR>)
	       (T
		<PERFORM ,V?THANK ,PRSI>
		<RTRUE>)>>
	       
<ROUTINE V-SHOW ()
	 <TELL "It's doubtful">
	 <ARTICLE ,PRSI T>
	 <TELL " is interested." CR>>

<ROUTINE V-SIT ("AUX" VEHICLE)
	 <COND (<SET VEHICLE <FIND-IN ,HERE ,VEHBIT>>
		<COND (<EQUAL? .VEHICLE ,LONG ,SHORT>
		       <V-COUNT>)
		      (T
		       <PERFORM ,V?BOARD .VEHICLE>
		       <RTRUE>)>)
               (T
		<V-DIG>)>>

<ROUTINE V-SKIP ()
	 ;<SETG AWAITING-REPLY 15>
	 ;<ENABLE <QUEUE I-REPLY 2>>
	 <TELL "Wasn't that fun?" CR>>

<ROUTINE V-SLEEP ()
	 <TELL "Temporary insomnia prevents this." CR>>

<ROUTINE V-SMELL ()
	 <COND (<NOT ,PRSO>
		<COND (<EQUAL? ,HERE ,CLOWN-ALLEY>
		       <TELL "It's quite bad." CR>)
		      (<EQUAL? ,HERE ,ROUST-ROOM>
		       <PERFORM ,V?SMELL ,CAGE>
		       <RTRUE>)
		      (T
		       <TELL "You smell nothing " <PICK-ONE ,YAWNS> "." CR>)>)
	       (T
		<TELL "It smells just like">
	 	<ARTICLE ,PRSO>
	 	<TELL ,PERIOD>)>>

<ROUTINE V-SMILE ()
         <TELL "How nice." CR>>

<ROUTINE V-SPIN ()
	 <TELL "You can't spin that!" CR>>     

<ROUTINE V-SPUT-ON ()
         <PERFORM ,V?PUT-ON ,PRSI ,PRSO>
	 <RTRUE>>

<ROUTINE V-SWHIP ()
	 <PERFORM ,V?WHIP ,PRSI ,PRSO>
	 <RTRUE>>

<ROUTINE V-SSHOW ()
	 <PERFORM ,V?SHOW ,PRSI ,PRSO>
	 <RTRUE>>

<ROUTINE V-STAND ()
	 <COND (<AND ,PRSO
		     <NOT <EQUAL? ,PRSO ,ROOMS>>>
		<V-DIG>)
	       (<AND <NOT <EQUAL? <LOC ,WINNER> ,LONG ,SHORT>>
		     <FSET? <LOC ,WINNER> ,VEHBIT>>
		<PERFORM ,V?DISEMBARK <LOC ,WINNER>>
		<RTRUE>)
	      (<AND ,SIT-IN-STANDS
		     <EQUAL? ,HERE ,STANDS-ROOM>>
	       <SETG SIT-IN-STANDS <>>
	       <TELL 
"As you rise, your row scrunches into the empty space." CR>)
	       (T
		<TELL "You are already standing." CR>)>>

<ROUTINE V-STAND-ON ()
	 <COND (<EQUAL? ,PRSO ,SHORT ,LONG ,STAND>	
		<PERFORM ,V?BOARD ,PRSO>
	        <RTRUE>)
	       (T
		<V-DIG>)>>

<ROUTINE V-STELL ()
	 <PERFORM ,V?TELL ,PRSI>
	 <RTRUE>>

<ROUTINE V-STOP ()
	 <COND (<PRSO? ,HEADPHONES ,RADIO>
		<PERFORM ,V?LAMP-OFF ,PRSO>
		<RTRUE>)
	       (T
		<TELL <PICK-ONE ,YUKS> CR>)>>

<ROUTINE PRE-TAKE ()
	 <COND (<EQUAL? ,PRSO ,PSEUDO-OBJECT>
		<RFALSE>)
	       (<LOC-CLOSED>
		<RTRUE>)
	       (<OR <AND <EQUAL? ,PRSI <LOC ,PRSO>>
			 <NOT <VERB? TAKE-WITH>>>
		    <EQUAL? ,PRSO ,MONKEY ,FLOWER>>
		<RFALSE>)
	       (<AND <EQUAL? ,PRSO ,KEY>
		     <EQUAL? ,PRSI ,KEY>>
		<RFALSE>)
	       (<AND <EQUAL? ,PRSO ,BANANA>
		     <EQUAL? ,PRSI ,BANANA>>
	       <RFALSE>)
	       (<AND ,PRSI
		     <VERB? TAKE>
		     <PRSI? POLE>>
		<PERFORM ,V?TAKE-WITH ,PRSO ,POLE>
		<RTRUE>)
	       (<OR <IN? ,PRSO ,PROTAGONIST>
		    <AND <HELD? ,PRSO>
			 <NOT <FSET? ,PRSO ,TAKEBIT>>>>
		<COND (<FSET? ,PRSO ,WORNBIT>
		       <TELL "You are already wearing it." CR>)
		      (T
		       <HAVE-IT>)>)
	       (,PRSI
		<COND (<VERB? TAKE-WITH>
		       <COND (<PRSI? ,HANDS>
			      <PERFORM ,V?TAKE ,PRSO>
			      <RTRUE>)
		       	     (<AND <NOT <HELD? ,PRSI>>
				   <NOT <EQUAL? ,PRSI ,GLOBAL-MONEY ,DOLLAR>>>
			      <TELL ,NOT-HOLDING>
			      <ARTICLE ,PRSI T>
			      <TELL ,PERIOD>
			      <RTRUE>)			     
			     (<HELD? ,PRSO>
			      <HAVE-IT>)
			     (T
			      <RFALSE>)>)
		      (<PRSO? ,ME>
		       <PERFORM ,V?DROP ,PRSI>
		       <RTRUE>)
		      (<AND <EQUAL? ,HERE ,CON-AREA>
			    <PRSO? ,WATER ,GLOBAL-WATER>>
		       <RFALSE>)		      
		      (<AND <IN? ,PRSO ,JOEY>
			    <EQUAL? ,PRSI ,EDDIE>>
		       <RFALSE>)
		      (<NOT <PRSI? <LOC ,PRSO>>>			    
		       <TELL "But">
		       <ARTICLE ,PRSO T>
		       <TELL " isn't ">
		       <COND (<FSET? ,PRSI ,ACTORBIT>
			       <TELL "being held by">)
			     (<FSET? ,PRSI ,SURFACEBIT>
			      <TELL "on">)
			     (T
			      <TELL "in">)>
		       <ARTICLE ,PRSI T>
		       <TELL ,PERIOD>)
		      (T
		       <SETG PRSI <>>
		       <RFALSE>)>)
	       (<PRSO? <LOC ,WINNER>>
		<TELL "You are on it!" CR>)>>

<ROUTINE HAVE-IT ()
	 <TELL "You already have ">
	 <COND (<PRSO? ,THUMB>
		<TELL "him">)
	       (<PRSO? ,GIRL>
		<TELL "her">)	
	       (T
	        <TELL "it">)>
         <TELL ,PERIOD>>

<ROUTINE V-TAKE ()
	 <COND (<EQUAL? <ITAKE> T>
		<TELL "Taken." CR>
		<COND (<AND <PRSO? ,RADIO>
		            <NOT ,RADIO-POINTS>>
		       <SETG RADIO-POINTS T>
		       <SETG SCORE <+ ,SCORE 10>>)>)>
	 <RTRUE>>

<GLOBAL RADIO-POINTS <>>

<ROUTINE V-TAKE-OFF ()
	 <COND (<FSET? ,PRSO ,WORNBIT>
		<FCLEAR ,PRSO ,WORNBIT>
		<TELL "Okay, you're no longer wearing">
		<ARTICLE ,PRSO T>
		<TELL ,PERIOD>
		<COND (<PRSO? ,MASK>
		       <PUTP ,PROTAGONIST ,P?ACTION ,PROTAGONIST-F>)>
		<RTRUE>)
	       (<FSET? ,PRSO ,VEHBIT>
		<PERFORM ,V?DISEMBARK ,PRSO>
		<RTRUE>)
	       (<PRSO? ,TENT ,WAGON ,CAGE ,PLATFORM>
		<COND (<EQUAL? ,HERE ,ON-CAGE ,ON-TENT ,PLATFORM>
		       <DO-WALK ,P?DOWN>)
		      (<EQUAL? ,HERE ,ON-WAGON>
		       <PERFORM ,V?CLIMB-DOWN ,LADDER>)
		      (T
		       <TELL ,LOOK-AROUND CR>)>
		<RTRUE>)
	       (<FSET? ,PRSO ,WEARBIT>
		<TELL "You aren't wearing that!" CR>)
	       (T
		<V-DIG>)>>

<ROUTINE V-TAKE-WITH ()
	 <TELL "Well,">
	 <ARTICLE ,PRSI T>
	 <TELL " is of little use in obtaining">
	 <ARTICLE ,PRSO T>
	 <TELL ,PERIOD>>

<ROUTINE V-TALK-INTO ()
	 <V-COUNT>>

<ROUTINE V-TAME ()
	 <COND (<PRSO? ,ELSIE ,NIMROD ,LION-NAME>
		<TELL ,HOW CR>)
	       (T
		<TELL "But">
		<ARTICLE ,PRSO T>
		<TELL " isn't so wild." CR>)>> 

<ROUTINE V-TASTE ()
	 <COND (<FSET? ,PRSO ,EATBIT>
		<TELL "The taste is quite strong." CR>)
	       (T
		<TELL "Yuck!" CR>)>>

<ROUTINE V-TELL ()
	 <COND (<FSET? ,PRSO ,ACTORBIT>
		<COND (,P-CONT
		       <SETG WINNER ,PRSO>
		       <SETG HERE <LOC ,WINNER>>
		       <RTRUE>)
		      (T
		       <TELL "Hmmm ...">
		       <ARTICLE ,PRSO T>
		       <COND (<EQUAL? ,PRSO ,GUARD>
			      <TELL " appears willing to listen to you">)
			     (T
			      <TELL
" looks at you expectantly, as if you seemed to be about to talk">)>
		       <TELL ,PERIOD>)>)
	       (T
		<TELL "You can't talk to">
		<ARTICLE ,PRSO>
		<TELL "!" CR>
		<STOP>)>>

<ROUTINE V-TELL-ABOUT ()
	 <COND (<PRSO? ,ME>
		<PERFORM ,V?WHAT ,PRSI>
		<RTRUE>)
	       (T
		<TELL "It doesn't look like">
		<ARTICLE ,PRSO T>
		<TELL " is interested." CR>)>>

<ROUTINE V-TELL-TIME ()
	 <TELL ,BAD-SENTENCE CR>>

<ROUTINE V-TELL-NAME ()
	 <V-TELL-TIME>>

<ROUTINE V-THANK ()
	 <COND (<AND ,PRSO
		     <FSET? ,PRSO ,PERSON>>		     
		<TELL "You're more than welcome." CR>)
	       (T
		<TELL <PICK-ONE ,YUKS> CR>)>>

<ROUTINE V-THROUGH ("AUX" M)
	<COND (<FSET? ,PRSO ,DOORBIT>
	       <DO-WALK <OTHER-SIDE ,PRSO>>
	       <RTRUE>)
	      (<OR <FSET? ,PRSO ,VEHBIT>
		   <EQUAL? ,PRSO ,LONG ,SHORT>>
	       <PERFORM ,V?BOARD ,PRSO>
	       <RTRUE>)
	      (<PRSO? ,INTDIR>
	       <PERFORM ,V?WALK ,PRSO>
	       <RTRUE>)
	      (<NOT <FSET? ,PRSO ,TAKEBIT>>
	       <TELL-HIT-HEAD>)
	      (<IN? ,PRSO ,WINNER>
	       <PERFORM ,V?EXAMINE ,BACK>
	       <RTRUE>)
	      (T
	       <V-INHALE>)>>

;<ROUTINE V-TIME ("AUX" H M)
	 <TELL "It's ">
	 <TELL-TIME>	 
	 <TELL ,PERIOD>>

;<ROUTINE TELL-TIME ("AUX" H (PM? <>))
	 <COND (<G? ,SCORE 11>
		<SET PM? T>)>
	 <COND (<G? ,SCORE 12>
		<SET H <- ,SCORE 12>>)
	       (<ZERO? ,SCORE>
		<SET H 12>)
	       (T
		<SET H ,SCORE>)>
	 <TELL N .H ":">
	 <COND (<L? ,MOVES 10>
		<TELL "0">)>
	 <TELL N ,MOVES>
	 <COND (.PM?
		<TELL " pm">)
	       (T
		<TELL " am">)>>

<ROUTINE PRE-THROW ()
	 <COND (<IDROP>
		<RTRUE>)>>

<ROUTINE V-THROW ()
	 <COND (<AND ,PRSI
		     <FSET? ,LION-DOOR ,OPENBIT>
		     <EQUAL? ,PRSI ,LION-DOOR>>
	        <TELL "That wouldn't do any good." CR>) 
	       (<AND ,PRSI
		     <NOT <EQUAL? ,PRSI ,GROUND>>>
		<MOVE ,PRSO ,HERE>
		<TELL ,BAD-AIM ";">
		<ARTICLE ,PRSO T>
		<TELL " goes sailing by." CR>)
	       (<GETP ,HERE ,P?GROUND-LOC>
		<PERFORM ,V?THROW-OFF ,PRSO ,CAGE>
		<RTRUE>)
	       (T
		<MOVE ,PRSO ,HERE>
		<TELL "Thrown." CR>)>>

<ROUTINE V-THROW-OFF ()
	 <COND (<AND <GETP ,HERE ,P?GROUND-LOC>
		     <EQUAL? ,PRSI ,CAGE ,TENT ,PLATFORM>>
		<MOVE ,PRSO <GETP ,HERE ,P?GROUND-LOC>>
	        <TELL "It falls to the ground below." CR>)
	       (T
		<V-COUNT>)>>

<ROUTINE V-TIE ()
	 <COND (<PRSO? ,RIBBON>
		<V-DIG>)
	       (T
		<TELL "You can't tie">
	 	<ARTICLE ,PRSO>
		<COND (,PRSI
		       <TELL " to">
		       <ARTICLE ,PRSI>)>
	 	<TELL ,PERIOD>)>>

;<ROUTINE V-TIE-TOGETHER ()
	 <COND (<PRSO? ,SLEEVES>
		<PERFORM ,V?TIE ,SLEEVES>
		<RTRUE>)
	       (T
		<V-TELL-TIME>)>>

;<ROUTINE V-TURN ()
	      ;(<PRSO? ,BOAT-OBJECT>
		<TELL "Try: STEER BOAT TOWARD (something)." CR>)
	       ;(<PRSO? ,ME ,ROOMS>
		<V-SKIP>)
	       ;(<AND <PRSO? ,INTNUM>
		     <L? ,P-NUMBER 9>
		     <ACCESSIBLE? ,BOARD>>
		<PERFORM ,V?TURN ,DIPSWITCH>
		<RTRUE>)
	       	<TELL "This has no effect." CR>>

<ROUTINE V-TUNE ()
	 <COND (<NOT ,PRSI>
		<TELL "Unfortunately, ">
		<HACK-HACK "adjusting">)
	       (T
		<PERFORM ,V?SET ,PRSO ,PRSI>
		<RTRUE>)>>

<ROUTINE V-UNLOCK ()
	 <COND (<OR <FSET? ,PRSO ,DOORBIT>
		    <EQUAL? ,PRSO ,KIESTER ,BAGGAGE-COMPARTMENT ,DESK>>
		<COND (<AND <FSET? ,PRSO ,OPENBIT>
			    <NOT <EQUAL? ,PRSO ,DESK>>>
		       <PERFORM ,V?LOCK ,PRSO ,PRSI>
		       <RTRUE>)
		      (<OR <AND <NOT <FSET? ,PRSO ,CAGEBIT>>
		                <NOT <EQUAL? ,HERE ,OFFICE>>>
			   <EQUAL? ,PRSO ,DESK>>
		       <CANT-LOCK>)
		      (<FSET? ,PRSO ,LOCKEDBIT>
		       <FCLEAR ,PRSO ,LOCKEDBIT>
		       <TELL 
"The " D ,PRSO " is now unlocked." CR>)
		      (T
	               <TELL
"But the " D ,PRSO " isn't locked." CR>)>)
		 (T
		  <TELL <PICK-ONE ,YUKS> CR>)>>

<ROUTINE CANT-LOCK ()
	 <TELL 
"However many times you flip over the key, jiggle the lock, and cajole the "
D ,PRSO ", you can't make the key fit the lock." CR>>

;<ROUTINE V-UNLOCK ()
	 <COND (<FSET? ,PRSO ,DOORBIT>
		<COND (<OR <AND <EQUAL? ,PRSI ,KEY>
			        <NOT <EQUAL? ,PRSO ,OFFICE-DOOR>>>
		           <AND <EQUAL? ,HERE ,OFFICE>
			        <EQUAL? ,PRSO ,OFFICE-DOOR>>>
		       <COND (<NOT <FSET? ,PRSO ,LOCKEDBIT>>
			      <TELL "It's not locked." CR>)
		             (T
		              <COND (<OR <FSET? ,PRSO ,CAGEBIT>
  				         <EQUAL? ,PRSO ,OFFICE-DOOR>>
			             <FCLEAR ,PRSO ,LOCKEDBIT>
			             <TELL 
"Okay, the " D ,PRSO " is now unlocked." CR>)
			            (T
 			             <TELL
 "The " D ,PRSI " doesn't seem to work." CR>)>)>)
			  (T
			   <TELL "This doesn't work." CR>)>)
	        (T
		 <V-COUNT>)>>

;<ROUTINE V-UNPLUG ()
	 <COND (<PRSO? ,SPARE-DRIVE ,LARGE-PLUG ,SMALL-PLUG ,PLOTTER>
		<TELL ,NOT-PLUGGED CR>)
	       (T
		<V-COUNT>)>>

<ROUTINE V-UNTIE ()
	 <COND (<AND <EQUAL? ,PRSO ,LADDER>
		     <EQUAL? ,HERE ,RING ,PLATFORM-1>
		     ,END-GAME>
		<TELL "It's hopelessly balled up." CR>)
	       (T
		<V-INHALE>)>>

<ROUTINE V-VAULT ()
	 <COND (<AND <NOT ,PRSI>
		     <NOT <HELD? ,POLE>>>
		<TELL "You have no pole." CR>)
	       (<OR <EQUAL? ,PRSI ,POLE>
		    <AND <NOT ,PRSI>
			 <HELD? ,POLE>
			 <NOT <HELD? ,PRSO>>
			 <NOT <FSET? ,PRSO ,TAKEBIT>>>>
		<TELL 
"You carefully mark off the steps leading up to">
		<ARTICLE ,PRSO T>
	        <TELL 
" but, right before the approach, you're psyched out by the image of " D ,ME
" in a full body-cast." CR>)
	      (T
	       <V-COUNT>)>> 
		
<ROUTINE V-WALK ("AUX" PT PTS STR OBJ RM)
	 <COND ;(<AND <IN? ,FLEET ,HERE>
		     <NOT <PRSO? ,P?UP ,P?DOWN>>>
		<TELL "You would be no safer there." CR>)
	       ;(,LYING-DOWN
		<TELL ,WHILE-LYING CR>)
	       ;(<FSET? ,TOWEL ,WORNBIT>
		<SETG BEARINGS-LOST T>
		<TELL
"You stumble in that direction, but as you can't see where you're going you
wander around in circles.">
		<COND (<NOT <FSET? ,BEAST ,MUNGEDBIT>>
		       <TELL
" The Beast is getting puzzled that something it can't see is stumbling around
its lair." ,SLOWLY-DAWNS>)>
		<CRLF>)
	       ;(<AND <NOT <EQUAL? ,HERE ,MAZE>>
		     <EQUAL? ,IDENTITY-FLAG ,ARTHUR>
		     ,BRAIN-DAMAGED
		     <PROB 30>>
		<TELL
"You notice that you can't remember how to walk. Oddly, as you think about
walking, all that comes to mind is an image of">
		<ARTICLE ,BRAIN-DAMAGED>
		<TELL ,PERIOD>)
	       (<NOT ,P-WALK-DIR>
		<PERFORM ,V?WALK-TO ,PRSO>
		<RTRUE>)
	       (<SET PT <GETPT ,HERE ,PRSO>>
		<COND (<EQUAL? <SET PTS <PTSIZE .PT>> ,UEXIT>
		       <GOTO <GETB .PT ,REXIT>>)
		      (<EQUAL? .PTS ,NEXIT>
		       <TELL <GET .PT ,NEXITSTR> CR>
		       <RFATAL>)
		      (<EQUAL? .PTS ,FEXIT>
		       <COND (<SET RM <APPLY <GET .PT ,FEXITFCN>>>
			      <GOTO .RM>)
			     ;(<AND <EQUAL? ,HERE ,BRIDGE>
				   <EQUAL? ,P-WALK-DIR ,P?WEST>>
			      <RTRUE>)
			     (T
			      <RFATAL>)>)
		      (<EQUAL? .PTS ,CEXIT>
		       <COND (<VALUE <GETB .PT ,CEXITFLAG>>
			      <GOTO <GETB .PT ,REXIT>>)
			     (<SET STR <GET .PT ,CEXITSTR>>
			      <TELL .STR CR>
			      <RFATAL>)
			     (T
			      <TELL ,CANT-GO CR>
			      <RFATAL>)>)
		      (<EQUAL? .PTS ,DEXIT>
		       <COND (<FSET? <SET OBJ <GETB .PT ,DEXITOBJ>> ,OPENBIT>
			      <GOTO <GETB .PT ,REXIT>>)
			     (<SET STR <GET .PT ,DEXITSTR>>
			      <TELL .STR CR>
			      <SETG P-IT-OBJECT .OBJ>
			      <RFATAL>)
			     (T
			      <TELL "The " D .OBJ " is closed." CR>
			      <SETG P-IT-OBJECT .OBJ>
			      <RFATAL>)>)>)
	       (T
		<COND (<PRSO? ,P?OUT ,P?IN>
		       <V-WALK-AROUND>)
		      (T
		       <TELL ,CANT-GO CR>)>
		<RFATAL>)>>

<ROUTINE V-WALK-AROUND ()
	 <SETG AWAITING-REPLY 13>
	 <ENABLE <QUEUE I-REPLY 2>>
	 <TELL "Did you have any particular direction in mind?" CR>>

<ROUTINE V-WALK-OVER ()
	 <COND (<PRSO? ,CHUTE>
		<PERFORM ,V?LOOK-BEHIND ,CHUTE>
		<RTRUE>)
	       (T
		<PERFORM ,V?THROUGH ,PRSO>
		<RTRUE>)>>

<ROUTINE V-WALK-TO ()
	 <COND (,PRSO
		<COND (<EQUAL? ,PRSO ,INTDIR>
		       <DO-WALK ,P-DIRECTION>
		       <RTRUE>)
		      (T
		       <V-FOLLOW>)>)
	       (T
		<V-WALK-AROUND>)>>

;<ROUTINE V-WALK-TO ()
	 <COND (<OR <IN? ,PRSO ,HERE>
		    <GLOBAL-IN? ,PRSO ,HERE>>
	        <COND (<FSET? ,PRSO ,ACTORBIT>
		       <TELL "He's">)
		      (T
		       <TELL "It's">)>
		<TELL " here!" CR>)
	       (T
		<V-WALK-AROUND>)>>

<ROUTINE V-WAIT ("OPTIONAL" (NUM 3))
	 <TELL "Time passes..." CR>
	 <REPEAT ()
		 <COND (<L? <SET NUM <- .NUM 1>> 0>
			<RETURN>)
		       (<CLOCKER>
			<RETURN>)>>
	 <SETG CLOCK-WAIT T>>

<ROUTINE V-WAIT-FOR ()
	 <TELL "You may be waiting quite a while." CR>>

<ROUTINE V-WAIT-IN ()
	 <COND (<EQUAL? <LOC ,PROTAGONIST> ,PRSO>
		<V-WAIT>)
	       (<FSET? ,PRSO ,VEHBIT>
		<PERFORM ,V?BOARD ,PRSO>
		<RTRUE>)
	       (T
		<V-COUNT>)>>
	        

;<ROUTINE V-WATER ()
	 <TELL "It doesn't need watering." CR>>

<ROUTINE V-WAVE ()
	 <V-INHALE>>

<ROUTINE V-WAVE-AT ()
	 <COND (<NOT ,PRSO>
		<V-SMILE>)
	       (T
		<TELL "Despite your friendly nature,">
		<ARTICLE ,PRSO T>
		<TELL " isn't likely to respond." CR>)>>

<ROUTINE PRE-WEAR ()
	 <COND (<NOT <FSET? ,PRSO ,WEARBIT>>
		<TELL "You can't wear">
		<ARTICLE ,PRSO T>
		<TELL ,PERIOD>
		<RTRUE>)
	       (<FSET? ,PRSO ,WORNBIT>
		<TELL "You're already wearing">
		<ARTICLE ,PRSO T>
		<TELL "!" CR>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE V-WEAR ()
         <MOVE ,PRSO ,PROTAGONIST>
         <FSET ,PRSO ,WORNBIT>
	 <TELL "You are now wearing">
	 <ARTICLE ,PRSO T>
	 <TELL ,PERIOD>>

<ROUTINE V-WHAT ()
	 <COND (<NOT ,PRSO>
		<TELL "That's what." CR>)
	       (<AND <PRSO? ,HYP>
		     <IS-NOUN? ,W?PHRENO>>
		<TELL "Look it up." CR>)
	       (T
		<TELL "Good question." CR>)>
	 <STOP>>

;<ROUTINE V-WHAT-ABOUT ()
	 <TELL "Well, what about it?" CR>>

;<ROUTINE V-WHAT-TIME ()
	 <V-TELL-TIME>>

<ROUTINE V-WHERE ()
	 <COND (,PRSO
		<V-FIND T>)
	       (T
		<TELL "Right here." CR>)>>

<ROUTINE V-WHIP ()
	 <COND (<NOT ,PRSI>
		<COND (<WHIP-HOLD>
		       <RTRUE>)
		      (<PRSO? ,WHIP>
		       <TELL 
"The quietude is shattered by an earsplitting \"crack!\" The musty scent
of rawhide drifts into your nostrils." CR>)
	              (<IN? ,WHIP ,PROTAGONIST>
		       <PERFORM ,V?WHIP ,PRSO ,WHIP>
		       <RTRUE>)
		      (T
		       <WHIP-HOLD>
		       <RTRUE>
		       ;<TELL
"Whipping whimsically without wherefore, while what we're wielding won't
whip what we want whipped, won't wash, whipper-snapper!" CR>)>)
	       (<PRSI? ,WHIP>
		<COND (<WHIP-HOLD>
		       <RTRUE>)
		      (<HELD? ,PRSO>
		       <TELL <PICK-ONE ,YUKS> CR>)
		      (<AND <FSET? ,PRSO ,PERSON>
			    <NOT <EQUAL? ,PRSO ,TAFT>>>
		       <TELL "As">
		       <ARTICLE ,PRSO T>
		       <TELL 
" sidesteps your attack, the bullwhip shatters the air right next to ">
		       <COND (<FSET? ,PRSO ,FEMALE>
			      <TELL "her">)
			     (T
			      <TELL "him">)>
		       <TELL ,PERIOD>)
		      (<FSET? ,PRSO ,WORNBIT>
		       <PERFORM ,V?WHIP ,ME ,WHIP>
		       <RTRUE>)
		      (T
		       <TELL "The whip strikes">
		       <ARTICLE ,PRSO T>
		       <TELL ", but nothing else happens." CR>)>)
	       (T
		<TELL
"Don't ever bother applying for a job as a cowboy." CR>)>>

<ROUTINE V-WHO ()
	 <COND (<NOT ,PRSO>
		<TELL "You." CR>)
	       (<FSET? ,PRSO ,ACTORBIT>
		<PERFORM ,V?WHAT ,PRSO>
		<RTRUE>)
	       (T
		<TELL "That's not a person!" CR>)>>

<ROUTINE V-WHY ()
	 <TELL "Why not?" CR>>

<ROUTINE V-YELL ()
	 <TELL "You begin to get a sore throat." CR>
	 <STOP>>

<ROUTINE V-YOU-ARE-OBJECT ()
	 <COND (<AND <NOT ,PRSO>>
		<ENABLED? ,I-TURNSTILE>
		<PERFORM ,V?TELL ,ANDREW>
		<RTRUE>)
	       (T
		<PERFORM ,V?TELL ,ME>
	 	<RTRUE>)>>

<ROUTINE I-REPLY ()
	 <SETG AWAITING-REPLY <>>
	 <RFALSE>>

<GLOBAL AWAITING-REPLY <>>

<ROUTINE V-YES ("AUX" VEH)
	 <SET VEH <LOC ,PROTAGONIST>>
	 ;<SETG CLOCK-WAIT T>
	 <COND (<EQUAL? ,AWAITING-REPLY 1>
		<TELL "You nonchalantly walk away from the " D .VEH "." CR>
		<MOVE ,PROTAGONIST ,HERE>)
	       (<EQUAL? ,AWAITING-REPLY 2>
		<TELL "A most wholesome decision." CR>)
	       (<EQUAL? ,AWAITING-REPLY 3>
		<TELL "Not surprisingly." CR>)
	       (<EQUAL? ,AWAITING-REPLY 4>
		<TELL "That's really beneath you." CR>)
	       (<EQUAL? ,AWAITING-REPLY 5>
		<TELL "Alright, that's the last " D ,STRAW "." CR>
		<TELL-FINISH>
		<READ ,P-INBUF ,P-LEXV>
		<TELL 
"Well, not quite the LAST straw. Please resume play." CR>)
	       (<EQUAL? ,AWAITING-REPLY 6>
		<COND (<NOT <EQUAL? ,DID-C 0>>
		       <FSET ,PROTAGONIST ,RMUNGBIT>
		       <TELL 
"\"Did not ... Er, um ... Well, I guess I didn't answer that question
before. All I can say is that I haven't seen the kid all evening.\"" CR>)
		      (T
		       <TELL "\"Thought you'd see it my way.\"" CR>
		       <SETG DID-C 0>
		       <DISABLE <INT I-DID>>)>)
	       (<EQUAL? ,AWAITING-REPLY 7>
		<TELL "Real brainy of you." CR>)
	       (<AND <EQUAL? ,AWAITING-REPLY 8>
		     <IN? ,CON ,HERE>>
		<TELL "\"Well then scram.\"" CR>)
	       (<EQUAL? ,AWAITING-REPLY 9>
		<TELL "For shame." CR>)
	       (<EQUAL? ,AWAITING-REPLY 10 12>
	        <DO-WALK ,P?SOUTH>)
	       (<EQUAL? ,AWAITING-REPLY 11>
	        <SETG EGRESS-C 0>
		<TELL 
"Then you'd be helpless against this dangerous beast." CR>)
	       (<EQUAL? ,AWAITING-REPLY 13>
		<TELL "Then supply it." CR>)
	       (T
	        <TELL "Yes?" CR>)>>
         
;"subtitle object manipulation"

<ROUTINE ITAKE ("OPTIONAL" (VB T) "AUX" ;CNT OBJ)
	 <COND (<NOT <FSET? ,PRSO ,TAKEBIT>>
		<COND (.VB
		       <V-INHALE>)>
		<RFATAL>)	       
	       (<NOT <IN? <LOC ,PRSO> ,WINNER>>
		<COND (<G? <+ <WEIGHT ,PRSO> <WEIGHT ,WINNER>> 100>
		       <COND (.VB
			      <TELL "Your load would be too heavy." CR>)>
		       <RFATAL>)
		      (<G? <CCOUNT ,WINNER> 9>
			      ;<PROB <* .CNT 8>>
		       <COND (.VB
				 ;<NOT ,STOP-HACK>
			      ;<SETG STOP-HACK T>
			      <TELL "You're holding too much already." CR>)>
		       <RFATAL>)>)>
	 <MOVE ,PRSO ,PROTAGONIST>
	 <FSET ,PRSO ,TOUCHBIT>
	 <FCLEAR ,PRSO ,NDESCBIT>
	 <RTRUE>>

;<GLOBAL STOP-HACK <>>

;"IDROP is called by these routines: PRE-DROP, PRE-GIVE, PRE-PUT, PRE-THROW"

<ROUTINE IDROP ()                     ;"revised 7/19/84 by SEM"
	 <COND (<AND <EQUAL? ,PRSO ,TIGHTROPE-OBJECT>
		     <EQUAL? ,HERE ,LEFT-HANGING>>
		<RFALSE>)
	       (<AND <VERB? DROP>
		     <PRSO? ,ME>
		     <EQUAL? ,HERE ,LEFT-HANGING>>
		<PERFORM ,V?LEAP>
		<RTRUE>)
	       (<PRSO? ,DIAL>
		<V-COUNT>)
	       (<AND <VERB? DROP>
		     <PRSO? ,PHONE>>
		<RFALSE>)
	       (<PRSO? ,HANDS ,BACK ,HELIUM ,HEAD>
		<COND (<OR <VERB? DROP THROW GIVE>
			   <AND <PRSO? ,BACK ,HELIUM ,HEAD>
			        <VERB? PUT PUT-ON>>>
		       <V-COUNT>)		      
		      (T
		       <RFALSE>)>)
	       (<AND <VERB? GIVE DROP THROW PUT PUT-ON>
		     <PRSO? ,INTNUM>
		     <NOT ,P-DOLLAR-FLAG>>
		<SPECIFY-MONEY>
		<SETG CLOCK-WAIT T>
		<RFATAL>)
	       (<OR <PRSO? ,GLOBAL-MONEY ,DOLLAR>
		    <AND <PRSO? ,INTNUM>
			 ,P-DOLLAR-FLAG>>
		    <COND (<AND <VERB? GIVE>
				<EQUAL? ,POCKET-CHANGE 1841>
				<EQUAL? ,HERE ,STANDS-ROOM>>	
			   <RFALSE>)
			  (<AND <VERB? GIVE>
				<PRSI? ,HAWKER ,CROWD>>
			   <COND (<EQUAL? ,HERE ,STANDS-ROOM>
				  <TELL 
"The hawker doesn't notice your desire to buy." CR>)>)
		          (<AND <VERB? GIVE>
			        <PRSI? ,GUARD>>
			   <TELL
"\"Hey, you'd better take better care of your money, especially around
here.\"" CR>)
			  (<AND <VERB? GIVE>
			        <FSET? ,PRSI ,PERSON>
				<NOT <EQUAL? ,PRSI ,TAFT>>>
			   <TELL "Disdainfully,">
			   <ARTICLE ,PRSI T>
			   <TELL " rejects your cash payment." CR>)
			  (<OR <AND <EQUAL? ,PRSI ,SLOT>
				    <VERB? PUT>>
			       <AND <EQUAL? ,PRSI ,TABLE>
			            <VERB? PUT-ON>>>
			   <RFALSE>)
		          (<AND <VERB? PUT>
			        <PRSI? ,DRESS>>
			   <V-DIG>)
			  (T
			   <TELL "You can't afford to." CR>)>)	       	       
	       (<PRSO? ,INTNUM>
		<COND (,PRSI
		       <PERFORM ,PRSA ,PRSO ,GLOBAL-MONEY>)
		      (T
		       <PERFORM ,PRSA ,GLOBAL-MONEY>)>
		<RTRUE>)
	       (<NOT <HELD? ,PRSO>>
		<TELL "That's easy for you to say since you don't even have">
		<ARTICLE ,PRSO T>
		<TELL ,PERIOD>)
	       (<AND <EQUAL? ,HERE ,ON-TENT>		     
		     <NOT <FSET? ,PRSO ,WORNBIT>>
		     <NOT <EQUAL? ,PRSO ,PROD>>
		     <OR <VERB? DROP>
			 <AND <VERB? PUT-ON>
			      <PRSI? ,TENT>>>>
		<COND (<PROB 50>
		       <MOVE ,PRSO ,ON-CAGE>)
		      (T
		       <MOVE ,PRSO ,NOOK>)>
		<TELL "It slides off the tent." CR>)
	       (<AND <EQUAL? ,HERE ,TIGHTROPE-ROOM>
	             <NOT <PRSO? ,BALLOON ,WATER>>
		     <NOT <EQUAL? ,PRSI ,PLATFORM ,BUCKET ,DRESS>>
		     <NOT <VERB? GIVE>>
		     <NOT <FSET? ,PRSO ,WORNBIT>>>
		<MOVE ,PRSO ,RING>
		<COND (<AND <PRSO? BUCKET>
			    <IN? ,WATER ,BUCKET>>
		       <MOVE ,WATER ,LOCAL-GLOBALS>)>
		<TELL "It falls">
		<COND (<OR <IN? ,NET ,RING>
			   <IN? ,NET ,MUNRAB>>
		       <TELL 
", luckily for the sake of whoever may later dive into the net,">)>
	        <TELL " to the " D ,GROUND " below." CR>)
	       (<AND <NOT <IN? ,PRSO ,WINNER>>
		     <FSET? <LOC ,PRSO> ,CONTBIT>
		     <NOT <FSET? <LOC ,PRSO> ,OPENBIT>>>
		<TELL "Impossible because">
		<ARTICLE <LOC ,PRSO> T>
		<TELL " is closed." CR>)
	       (<AND <VERB? PUT-ON>
		     <PRSI? ,ME>>
		<PERFORM ,V?WEAR ,PRSO>
		<RTRUE>)
	       (<FSET? ,PRSO ,WORNBIT>
		<REMOVE-FIRST>)
	       (<AND <PRSO? ,MONKEY>
		     <NOT <VERB? SHOW>>>
		<TELL ,NOT-HOLDING " the " D ,MONKEY "." CR>)
	       (T
		<RFALSE>)>>

<ROUTINE REMOVE-FIRST ("OPTIONAL" (OBJ <>))
	 <TELL "You'll have to remove ">
	 <COND (.OBJ
		<TELL "the " D .OBJ>)
	       (T
		<TELL "it">)>
	 <TELL " first." CR>>

<ROUTINE CCOUNT	(OBJ "AUX" (CNT 0) X)
	 <COND (<SET X <FIRST? .OBJ>>
		<REPEAT ()
			<COND (<NOT <FSET? .X ,WORNBIT>>
				  ;<NOT <EQUAL? .X ,BABEL-FISH>>
			       <SET CNT <+ .CNT 1>>)>
			<COND (<NOT <SET X <NEXT? .X>>>
			       <RETURN>)>>)>
	 .CNT>

;"Gets SIZE of supplied object, recursing to nth level."

<ROUTINE WEIGHT (OBJ "AUX" CONT (WT 0))
	 <COND (<SET CONT <FIRST? .OBJ>>
		<REPEAT ()
			<COND (<AND <EQUAL? .OBJ ,PLAYER>
				    <FSET? .CONT ,WORNBIT>>
			       <SET WT <+ .WT 1>>)
			              ;"worn things shouldn't count"
			      (<AND <EQUAL? .OBJ ,PLAYER>
				    <FSET? <LOC .CONT> ,WORNBIT>>
			       <SET WT <+ .WT 1>>)
			              ;"things in worn things shouldn't count"
			      (<EQUAL? .OBJ ,PLAYER>
				  ;<EQUAL? .CONT ,BABEL-FISH>
			       <SET WT <+ .WT 1>>)
			              ;"the babel fish shouldn't count"
			      (T
			       <SET WT <+ .WT <WEIGHT .CONT>>>)>
			<COND (<NOT <SET CONT <NEXT? .CONT>>> <RETURN>)>>)>
	 <+ .WT <GETP .OBJ ,P?SIZE>>>

;"subtitle describers"

<ROUTINE DESCRIBE-ROOM ("OPTIONAL" (LOOK? <>) "AUX" V? STR AV)
	 <SET V? <OR .LOOK? <EQUAL? ,VERBOSITY 2>>>
	 <COND (<NOT ,LIT>
		<TELL "It is pitch black.">
		<CRLF>
		<RETURN <>>)>
	 <COND (<NOT <FSET? ,HERE ,TOUCHBIT>>
		<FSET ,HERE ,TOUCHBIT>
		<SET V? T>)>
	 <COND (<IN? ,HERE ,ROOMS>
		<COND (<AND <NOT <EQUAL? ,HERE ,TIGHTROPE-ROOM>>
			    <NOT <ZERO? ,VERBOSITY>>>
		       <TELL D ,HERE>)>
	        <SET AV <LOC ,WINNER>>
		<COND (<AND <NOT <FSET? .AV ,VEHBIT>>
		            <NOT ,HIDING>
			    <NOT <EQUAL? ,HERE ,TIGHTROPE-ROOM>>>
		       <CRLF>)>)>
	 <COND (<OR .LOOK?
		    <EQUAL? ,VERBOSITY 1 2>>
		<COND (,HIDING
		       <TELL ", hiding behind the " D ,TAFT CR>)
		      (<FSET? .AV ,VEHBIT>
		       <COND (<EQUAL? .AV ,LONG ,SHORT>
			      <TELL ", " ,TAIL-END " a ">)
			     (<EQUAL? .AV ,NET>
			      <TELL ", in the ">)
			     (T
			      <TELL ", on the ">)>
		       <TELL D .AV>
		       <CRLF>)>
		<COND (<AND .V? <APPLY <GETP ,HERE ,P?ACTION> ,M-LOOK>>
		       <RTRUE>)
		      (<AND .V? <SET STR <GETP ,HERE ,P?LDESC>>>
		       <TELL .STR CR>)
		      (T
		       <APPLY <GETP ,HERE ,P?ACTION> ,M-FLASH>)>
		<COND (<AND <NOT <EQUAL? ,HERE .AV>>
			    <FSET? .AV ,VEHBIT>>
		       <APPLY <GETP .AV ,P?ACTION> ,M-LOOK>)>)>
	 T>

<OBJECT C-OBJECT>

<ROUTINE PRINT-CONTENTS (THING "OPTIONAL" (ARTICLE-T? <>) 
			       "AUX" OBJ NXT (1ST? T) (IT? <>) (TWO? <>))
	 <SET OBJ <FIRST? .THING>>
	 <REPEAT ()
		<COND (.OBJ
		       <SET NXT <NEXT? .OBJ>>
		       <COND (<OR <FSET? .OBJ ,INVISIBLE>
				  <AND <FSET? .OBJ ,NDESCBIT> ;"was semied"
				       <NOT <EQUAL? .OBJ ,RIBBON>>>
				  <EQUAL? .OBJ ,WINNER>>
			      <MOVE .OBJ ,C-OBJECT>)>
		       <SET OBJ .NXT>)
		      (T
		       <RETURN>)>>
	 <SET OBJ <FIRST? .THING>>
	 <COND (<NOT .OBJ>
		<TELL " nothing " <PICK-ONE ,YAWNS>>)
	       (T
		<REPEAT ()
		        <COND (.OBJ
		               <SET NXT <NEXT? .OBJ>>
		               <COND (.1ST?
			              <SET 1ST? <>>)
			             (T
			              <COND (.NXT
				             <TELL ",">)
				            (T
				             <TELL " and">)>)>
		               <ARTICLE .OBJ .ARTICLE-T?>
		             ; <COND (<FSET? .OBJ ,WORNBIT>
			              <TELL " (being worn)">)>
			     ; <COND (<FSET? .OBJ ,ONBIT>
				      <TELL " (providing light)">)>
			     ; <COND (<AND <HELD? ,MONKEY>	
				           <EQUAL? .OBJ ,MONKEY>>
				      <TELL " on " D ,BACK>)>	
			     ; <COND (<AND <EQUAL? .OBJ ,BUCKET>
				           <IN? ,WATER ,BUCKET>>
				      <TELL " (filled with " D ,WATER ")">)>
			       <COND (<AND <NOT .IT?>
				           <NOT .TWO?>>
			              <SET IT? .OBJ>)
			             (T
			              <SET TWO? T>
			              <SET IT? <>>)>
		               <SET OBJ .NXT>)
			      (T
		               <COND (<AND .IT?
				           <NOT .TWO?>>
			              <SETG P-IT-OBJECT .IT?>)>
		               <RETURN>)>>)>
	 <ROB ,C-OBJECT .THING>>

<OBJECT X-OBJECT>

<ROUTINE DESCRIBE-OBJECTS ("OPTIONAL" (THING <>)
			   "AUX" OBJ NXT STR (1ST? T) (TWO? <>) (IT? <>)
			         (ANY? <>))
	 <COND (<ZERO? .THING>
		<SET THING ,HERE>)>
	 <COND (<NOT ,LIT>
	        <TELL ,TOO-DARK CR>
	        <RTRUE>)>
       
      ; "Hide invisible objects"

	<SET OBJ <FIRST? .THING>>
	<COND (<ZERO? .OBJ>
	       <RTRUE>)>
	
	<REPEAT ()
		<COND (.OBJ
		       <SET NXT <NEXT? .OBJ>>
		       <COND (<OR <FSET? .OBJ ,INVISIBLE>
				  <FSET? .OBJ ,NDESCBIT>
				  <EQUAL? .OBJ ,WINNER>
				  <EQUAL? .OBJ <LOC ,PROTAGONIST>>> ;"added JO"
			      <MOVE .OBJ ,DUMMY-OBJECT>)>
		       <SET OBJ .NXT>)
		      (T
		       <RETURN>)>>
	
      ; "Apply all FDESCs and eliminate those objects"
	
	<SET OBJ <FIRST? .THING>>
	<REPEAT ()
		<COND (<AND .OBJ
			    <EQUAL? .THING ,HERE>>
		       <SET NXT <NEXT? .OBJ>>
		       <SET STR <GETP .OBJ ,P?FDESC>>
		       <COND (<AND .STR
				   <NOT <FSET? .OBJ ,TOUCHBIT>>>
			      <TELL CR .STR CR>
			      <MOVE .OBJ ,DUMMY-OBJECT>)>
		       <SET OBJ .NXT>)
		      (T
		       <RETURN>)>>

       ;"Apply all LDESC's and eliminate those objects"

       <SET OBJ <FIRST? .THING>>
       <REPEAT ()
		<COND (<AND .OBJ
			    <EQUAL? .THING ,HERE>>
		       <SET NXT <NEXT? .OBJ>>
		       <SET STR <GETP .OBJ ,P?LDESC>>
		       <COND (.STR
		              <TELL CR .STR CR>
			      <MOVE .OBJ ,DUMMY-OBJECT>)>
		       <SET OBJ .NXT>)
		      (T
		       <RETURN>)>>

	; "Apply all DESCFCNs and hide those objects"
	
       <SET OBJ <FIRST? .THING>>
       <REPEAT ()
		<COND (<AND .OBJ
			    <EQUAL? .THING ,HERE>>
		       <SET NXT <NEXT? .OBJ>>
		       ;<SET STR <GETP .OBJ ,P?DESCFCN>>
		       <COND (<GETP .OBJ ,P?DESCFCN>
		              <CRLF>
			      <APPLY <GETP .OBJ ,P?DESCFCN> ,M-OBJDESC>
			      <CRLF>
			      <MOVE .OBJ ,DUMMY-OBJECT>)>
		       <SET OBJ .NXT>)
		      (T
		       <RETURN>)>>
     
       ; "Print whatever's left in a nice sentence"
	
	<SET OBJ <FIRST? .THING>>
	<COND (.OBJ
	       <REPEAT ()
		       <COND (.OBJ
		              <SET NXT <NEXT? .OBJ>>
		              <COND (.1ST?
			             <SET 1ST? <>>
			           ; <CRLF>
			             <COND (<EQUAL? .THING ,HERE>
					    <CRLF>
					    <COND (.NXT
				                   <TELL ,YOU-SEE>)
				                   (T
				                    <TELL "There's">)>)>)
			            (T
			             <COND (<OR .NXT
						<AND <EQUAL? .THING
							     ,PROTAGONIST>
						     <G? ,POCKET-CHANGE 0>>>
					    <TELL ",">)
				           (T
				            <TELL " and">)>)>
			      <ARTICLE .OBJ>
			    ; <COND (<FSET? .OBJ ,ONBIT>
				     <TELL " (providing light)">)>
			      <COND (<FSET? .OBJ ,WORNBIT>
			             <TELL " (being worn)">)>
			      <COND (<AND <EQUAL? .OBJ ,MONKEY>
					  <HELD? ,MONKEY>>
				      <TELL " on " D ,BACK>)>	
			      <COND (<AND <EQUAL? .OBJ ,BUCKET>
				          <IN? ,WATER ,BUCKET>>
				     <TELL " (filled with " D ,WATER ")">)
			            (<AND <SEE-INSIDE? .OBJ>
				          <SEE-ANYTHING-IN? .OBJ>>
			             <MOVE .OBJ ,X-OBJECT>
				   ; <TELL " with">
			           ; <PRINT-CONTENTS .OBJ>
			           ; <COND (<FSET? .OBJ ,CONTBIT>
				            <TELL " in">)
				           (T
				            <TELL " on">)>
			           ; <TELL " it">)>
		              <COND (<AND <NOT .IT?>
				          <NOT .TWO?>>
			             <SET IT? .OBJ>)
			            (T
			             <SET TWO? T>
			             <SET IT? <>>)>
		              <SET OBJ .NXT>)
		             (T
		              <COND (<AND .IT?
				          <NOT .TWO?>>
			             <SETG P-IT-OBJECT .IT?>)>
		              <COND (<AND <EQUAL? .THING ,PROTAGONIST>
					  <G? ,POCKET-CHANGE 0>>
				     <TELL " and ">
				     <PRINT-AMOUNT ,POCKET-CHANGE>
				     <TELL " to your name">)>
			      <COND (<EQUAL? .THING ,HERE>
				     <TELL " here">)>
			      <TELL ".">
			      <SET ANY? T>
		              <RETURN>)>>)>
	<SET OBJ <FIRST? ,X-OBJECT>>
	<REPEAT ()
		<COND (<ZERO? .OBJ>
		       <RETURN>)>
		<COND (<FSET? .OBJ ,SURFACEBIT>
		       <TELL CR CR "On">)
		      (T
		       <TELL CR CR "Inside">)>
		<ARTICLE .OBJ T>
		<TELL " you see">
		<PRINT-CONTENTS .OBJ>
		<TELL ".">
		<SET OBJ <NEXT? .OBJ>>>
	<COND (.ANY?
	       <CRLF>)>
	<ROB ,X-OBJECT .THING>
	<ROB ,DUMMY-OBJECT .THING>>

<ROUTINE SEE-ANYTHING-IN? (THING "AUX" OBJ NXT (ANY? <>))
	 <SET OBJ <FIRST? .THING>>
	 <REPEAT ()
		 <COND (.OBJ
			<COND (<AND <NOT <FSET? .OBJ ,INVISIBLE>>
				    <NOT <FSET? .OBJ ,NDESCBIT>>
				    <NOT <EQUAL? .OBJ ,WINNER>>>
			       <SET ANY? T>
			       <RETURN>)>
			<SET OBJ <NEXT? .OBJ>>)
		       (T
			<RETURN>)>>
	 <RETURN .ANY?>>

;"My old ..."
;<ROUTINE DESCRIBE-OBJECTS ("OPTIONAL" (V? <>))
   <COND (,LIT
	  <COND (<FIRST? ,HERE>
		 <PRINT-CONT ,HERE <SET V? <OR .V? <==? ,VERBOSITY 2>>> -1>)>)
	 (T
	  <TELL ,TOO-DARK CR>)>>

"DESCRIBE-OBJECT -- takes object and flag.  if flag is true will print a
long description (fdesc or ldesc), otherwise will print short."
;<ROUTINE DESCRIBE-OBJECT (OBJ V? LEVEL "AUX" (STR <>) AV)
	 <COND (<AND <0? .LEVEL>
		     <APPLY <GETP .OBJ ,P?DESCFCN> ,M-OBJDESC>>
		<RTRUE>)
	       (<AND <0? .LEVEL>
		     <OR <AND <NOT <FSET? .OBJ ,TOUCHBIT>>
			      <SET STR <GETP .OBJ ,P?FDESC>>>
			 <SET STR <GETP .OBJ ,P?LDESC>>>>
		<TELL .STR>)
	       (<0? .LEVEL>
		<TELL "There is">
		<ARTICLE .OBJ>
		<TELL " here.">)
	       (T
		<TELL <GET ,INDENTS .LEVEL>>
		<COND (<FSET? .OBJ ,NARTICLEBIT>
		       T)
		      (<FSET? .OBJ ,VOWELBIT>
		       <TELL "an ">)
		      (T
		       <TELL "a ">)>
		<TELL D .OBJ>
		<COND (<FSET? .OBJ ,WORNBIT>
		       <TELL " (being worn)">)
		      (<EQUAL? .OBJ ,FAT-HAND>
		       <TELL " (being held like a sandbag)">)
		      ;(<AND <EQUAL? .OBJ ,PLOTTER>
			    ,BROWNIAN-SOURCE>
		       <TELL " (suspended in">
		       <ARTICLE ,BROWNIAN-SOURCE>
		       <TELL ")">)
		      ;(<AND <EQUAL? .OBJ ,SPARE-DRIVE>
			    <OR ,DRIVE-TO-PLOTTER ,DRIVE-TO-CONTROLS>>
		       <TELL " (connected to">
		       <COND (,DRIVE-TO-PLOTTER
			      <TELL " the plotter">
			      <COND (,DRIVE-TO-CONTROLS
				     <TELL " and">)>)>
		       <COND (,DRIVE-TO-CONTROLS
			      <TELL " the control console">)>
		       <TELL ")">)>)>
	 <COND (<AND <0? .LEVEL>
		     <NOT <FSET? .OBJ ,ACTORBIT>>
		     <SET AV <LOC ,WINNER>>
		     <FSET? .AV ,VEHBIT>
		     <NOT <EQUAL? .OBJ ,LONG ,SHORT>>>
		<TELL " (outside the " D .AV ")">)>
	 <CRLF>
	 <COND (<AND <SEE-INSIDE? .OBJ>
		     <FIRST? .OBJ>
		     <NOT <EQUAL? .OBJ ,LOWER ,UPPER>>>
		<PRINT-CONT .OBJ .V? .LEVEL>)>>

;"My old PRINT-CONT"
;<ROUTINE PRINT-CONT (OBJ
		     "OPTIONAL" (V? <>) (LEVEL 0)
		     "AUX" Y (1ST? T) (AV <>) STR (PV? <>) (INV? <>) (SC <>))
	 <COND (<NOT <SET Y <FIRST? .OBJ>>>
		<RTRUE>)>
	 <COND (<FSET? <LOC ,WINNER> ,VEHBIT>
		<SET AV <LOC ,WINNER>>)>
	 <COND (<EQUAL? ,PROTAGONIST .OBJ <LOC .OBJ>>
		<SET INV? T>)
	       (T
		<REPEAT ()
			<COND (<NOT .Y>
			       <RETURN <NOT .1ST?>>)
			      (<EQUAL? .Y .AV>
			       <SET PV? T>)
			      (<EQUAL? .Y ,WINNER>)
			      (<AND <NOT <FSET? .Y ,INVISIBLE>>
				    <NOT <FSET? .Y ,TOUCHBIT>>
				    <SET STR <GETP .Y ,P?FDESC>>>
			       <COND (<NOT <FSET? .Y ,NDESCBIT>>
				      <TELL .STR CR>)>
			       <COND (<AND <SEE-INSIDE? .Y>
					   <NOT <GETP <LOC .Y> ,P?DESCFCN>>
					   <FIRST? .Y>>
				      <PRINT-CONT .Y .V? 0>)>)>
			<SET Y <NEXT? .Y>>>)>
	 <SET Y <FIRST? .OBJ>>
	 ;<COND (<AND <EQUAL? .OBJ ,HERE>
		     <IN? ,SATCHEL ,HERE>>
		<DESCRIBE-OBJECT ,SATCHEL .V? .LEVEL>
		<SET SC T>)>
	 <REPEAT ()
		 <COND (<NOT .Y>
			<COND (<AND .PV? .AV <FIRST? .AV>>
			       <PRINT-CONT .AV .V? .LEVEL>)>
			<RETURN <NOT .1ST?>>)
		       (<EQUAL? .Y .AV ,PROTAGONIST> T)
		       ;(<AND .SC <EQUAL? .Y ,SATCHEL>> T)
		       (<AND <NOT <FSET? .Y ,INVISIBLE>>
			     <OR .INV?
				 <FSET? .Y ,TOUCHBIT>
				 <NOT <GETP .Y ,P?FDESC>>>>
			<COND ;(<AND <EQUAL? .Y ,STONE>
				    <EQUAL? ,HERE ,OUTER-LAIR>
				    <IN? .Y ,HERE>>
			       <FSET .Y ,NDESCBIT>)
			      (<NOT <FSET? .Y ,NDESCBIT>>
			       <COND (.1ST?
				      <COND (<FIRSTER .OBJ .LEVEL>
					     <COND (<L? .LEVEL 0>
						    <SET LEVEL 0>)>)>
				      <SET LEVEL <+ 1 .LEVEL>>
				      <SET 1ST? <>>)>
			       <DESCRIBE-OBJECT .Y .V? .LEVEL>)
			      (<AND <FIRST? .Y>
				    <SEE-INSIDE? .Y>>
			       <PRINT-CONT .Y .V? .LEVEL>)>)>
		 <SET Y <NEXT? .Y>>>>

<ROUTINE DESCRIBE-VEHICLE () ;"for LOOK AT vehicle when you're in it"
	 <MOVE ,PROTAGONIST ,ROOMS>
	 <COND (<FIRST? ,PRSO>
		<PRINT-CONTENTS ,PRSO>
		<TELL ,PERIOD>)
	       (T
		<TELL ,EMPTY " (not counting you)." CR>)>
	 <MOVE ,PROTAGONIST ,PRSO>>


;"subtitle movement and death"

<CONSTANT REXIT 0>
<CONSTANT UEXIT 1>
<CONSTANT NEXIT 2>
<CONSTANT FEXIT 3>
<CONSTANT CEXIT 4>
<CONSTANT DEXIT 5>

<CONSTANT NEXITSTR 0>
<CONSTANT FEXITFCN 0>
<CONSTANT CEXITFLAG 1>
<CONSTANT CEXITSTR 1>
<CONSTANT DEXITOBJ 1>
<CONSTANT DEXITSTR 1>

<ROUTINE GOTO (RM "OPTIONAL" (V? T))
	 <MOVE ,PROTAGONIST .RM>
	 <SETG HERE .RM>
	 ;<COND (<NOT <EQUAL? ,HERE ,DARK>>
		<MOVE ,NAME ,HERE>)>
	 <SETG LIT <LIT? ,HERE>>
	 ;<UNPLUG-HELD-STUFF>
	 <APPLY <GETP ,HERE ,P?ACTION> ,M-ENTER>
	 <COND (<AND .V?
		     <EQUAL? ,HERE .RM>>
		<V-FIRST-LOOK>)>
	 <RTRUE>>

;<ROUTINE UNPLUG-HELD-STUFF ()
	 <COND (<AND ,DRIVE-TO-CONTROLS
		     <HELD? ,SPARE-DRIVE>>
		<SETG DRIVE-TO-CONTROLS <>>
		<FCLEAR ,SPARE-DRIVE ,NDESCBIT>
		<TELL "(unplugging the spare drive first)" CR>)>
	 <COND (<AND <HOLDING-ONE-BUT-NOT-BOTH? ,SPARE-DRIVE ,PLOTTER>
		     ,DRIVE-TO-PLOTTER>
		<SETG DRIVE-TO-PLOTTER <>>
		<TELL "(disconnecting the short cord first)" CR>)>
	 <COND (<AND <HOLDING-ONE-BUT-NOT-BOTH? ,BROWNIAN-SOURCE ,PLOTTER>
		     ,BROWNIAN-SOURCE>
		<SETG BROWNIAN-SOURCE <>>
		<REMOVING-BIT>)>>

<ROUTINE JIGS-UP (NUM DESC)
	 <TELL .DESC>	       
	 <TELL-DIED>
	 <TELL 
"Well not quite died. The doctors do what they can, but as the debts rise
and the prognosis dips you take the only avenue left -- and sell " D ,ME 
" to the circus.|
|
As \"The Human " <GET ,FREAKS .NUM> ",\" you enjoy top billing as a popular
midway attraction, garnering fame to rival that of nineteenth century oddity
John Merrick.|
|
Still, as the fingers of the Great Unwashed poke at your benumbed hide,
you contemplate how this fate might have been thwarted.">
	 <CRLF>
	 <FINISH>>

;"The TCTTF is relieved of major financial burden, and all sides in the
kidknapping controversy are reconciled..."
	
<GLOBAL FREAKS
     	<PLTABLE
	"Platypus"
	"Eelworm"
	"Croissant"
	"Corkscrew"
	"Armadillo">>
	
<ROUTINE TELL-DIED ()
	 <TELL CR CR
"    ****  You have died  ****" CR CR>>

<ROUTINE I-DEMISE ()
	 <DISABLE <INT I-DEMISE>>
	 <TELL CR 
"(The reports of your demise have been grossly exaggerated. You suffer
little more than injured pride.)" CR>>

;"subtitle useful utility routines"

<ROUTINE ACCESSIBLE? (OBJ "AUX" (L <LOC .OBJ>)) ;"can player TOUCH object?"
	 ;"revised 5/2/84 by SEM and SWG"
	 <COND (<FSET? .OBJ ,INVISIBLE>
		<RFALSE>)
	       (<EQUAL? .OBJ ,PSEUDO-OBJECT>
		<COND (<EQUAL? ,LAST-PSEUDO-LOC ,HERE>
		       <RTRUE>)
		      (T
		       <RFALSE>)>)
	       (<NOT .L>
		<RFALSE>)
	       (<EQUAL? .L ,GLOBAL-OBJECTS>
		<RTRUE>)	       
	       (<AND <EQUAL? .L ,LOCAL-GLOBALS>
		     <GLOBAL-IN? .OBJ ,HERE>>
		<RTRUE>)
	       (<NOT <EQUAL? <META-LOC .OBJ> ,HERE>>
		<RFALSE>)
	       (<EQUAL? .L ,WINNER ,HERE>
		<RTRUE>)
	       (<AND <FSET? .L ,OPENBIT>
		     <ACCESSIBLE? .L>>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE VISIBLE? (OBJ "AUX" (L <LOC .OBJ>)) ;"can player SEE object"
	 ;"revised 5/2/84 by SEM and SWG"
	 <COND (<ACCESSIBLE? .OBJ>
		<RTRUE>)
	       (<AND <SEE-INSIDE? .L>
		     <VISIBLE? .L>>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE META-LOC (OBJ)
	 <REPEAT ()
		 <COND (<NOT .OBJ>
			<RFALSE>)
		       (<IN? .OBJ ,GLOBAL-OBJECTS>
			<RETURN ,GLOBAL-OBJECTS>)>
		 <COND (<IN? .OBJ ,ROOMS>
			<RETURN .OBJ>)
		       (T
			<SET OBJ <LOC .OBJ>>)>>>

<ROUTINE OTHER-SIDE (DOBJ "AUX" (P 0) TEE) ;"finds room on others side of door"
	 <REPEAT ()
		 <COND (<L? <SET P <NEXTP ,HERE .P>> ,LOW-DIRECTION>
			<RETURN <>>)
		       (T
			<SET TEE <GETPT ,HERE .P>>
			<COND (<AND <EQUAL? <PTSIZE .TEE> ,DEXIT>
				    <EQUAL? <GETB .TEE ,DEXITOBJ> .DOBJ>>
			       <RETURN .P>)>)>>>

<ROUTINE HELD? (OBJ "OPTIONAL" (CONT <>))
	 <COND (<NOT .CONT>
		<SET CONT ,WINNER>)>
	 <COND (<NOT .OBJ>
		<RFALSE>)
	       (<IN? .OBJ .CONT>
		<RTRUE>)
	       (<IN? .OBJ ,ROOMS>
		<RFALSE>)
	       (<IN? .OBJ ,GLOBAL-OBJECTS>
		<RFALSE>)
	       (T
		<HELD? <LOC .OBJ> .CONT>)>>

<ROUTINE SEE-INSIDE? (OBJ)
	 <AND .OBJ
	      <NOT <FSET? .OBJ ,INVISIBLE>>
	      <OR <FSET? .OBJ ,TRANSBIT>
	          <FSET? .OBJ ,OPENBIT>>>>

<ROUTINE GLOBAL-IN? (OBJ1 OBJ2 "AUX" TEE)
	 <COND (<SET TEE <GETPT .OBJ2 ,P?GLOBAL>>
		<ZMEMQB .OBJ1 .TEE <- <PTSIZE .TEE> 1>>)>>

<ROUTINE FIND-IN (WHERE WHAT "AUX" W)
	 <SET W <FIRST? .WHERE>>
	 <COND (<NOT .W>
		<RFALSE>)>
	 <REPEAT ()
		 <COND (<FSET? .W .WHAT>
			<RETURN .W>)
		       (<NOT <SET W <NEXT? .W>>>
			<RETURN <>>)>>>

<ROUTINE LOC-CLOSED ()
	 <COND (<AND <FSET? <LOC ,PRSO> ,CONTBIT>
		     <NOT <FSET? <LOC ,PRSO> ,OPENBIT>>
		     <FSET? ,PRSO ,TAKEBIT>>
		<TELL "But">
		<ARTICLE <LOC ,PRSO> T>
		<TELL " is closed!" CR>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE DO-WALK (DIR)
	 <SETG P-WALK-DIR .DIR>
	 <PERFORM ,V?WALK .DIR>>

<ROUTINE STOP ()
	 <SETG P-CONT <>>
	 <SETG QUOTE-FLAG <>>
	 <RFATAL>>

<ROUTINE ROB (WHO "OPTIONAL" (WHERE <>) "AUX" N X)
	 <SET X <FIRST? .WHO>>
	 <REPEAT ()
		 <COND (<ZERO? .X>
			<RETURN>)>
		 <SET N <NEXT? .X>>
		 <COND (<AND <EQUAL? .WHERE ,BIGTOP>
			     <FSET? .X ,WORNBIT>>
			<FSET .X ,REWEARBIT>)>
		 <COND (<AND <EQUAL? .WHERE ,PROTAGONIST>
			     <FSET? .X ,REWEARBIT>>
			<FSET .X ,WORNBIT>)
		       (T
		        <FCLEAR .X ,WORNBIT>)>
		 <MOVE .X .WHERE>
		 <SET X .N>>>

<ROUTINE MOVE-TAKEBIT (LOC1 LOC2 "AUX" OBJ)	 
	 <REPEAT ()
		 <SET OBJ <FIND-IN .LOC1 ,TAKEBIT>>
		 <COND (.OBJ		        
			<MOVE .OBJ .LOC2>)
		       (T
		        <RTRUE>)>>>

;<ROUTINE HOLDING-ONE-BUT-NOT-BOTH? (ONE TWO)
	 <COND (<AND <HELD? .ONE>
		     <HELD? .TWO>>
		<RFALSE>)
	       (<HELD? .ONE>
		<RTRUE>)
	       (<HELD? .TWO>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE HACK-HACK (STR)
	 <TELL .STR>
	 <ARTICLE ,PRSO T>
	 <TELL <PICK-ONE ,HO-HUM> CR>>

<ROUTINE ARTICLE (OBJ "OPTIONAL" (THE <>))
	 <COND (<NOT .OBJ>
		<SET OBJ ,NOT-HERE-OBJECT>)>
	 <COND (<NOT <FSET? .OBJ ,NARTICLEBIT>>
		<COND (.THE
		       <TELL " the">)
		      (<FSET? .OBJ ,NOA>
		       <TELL " " D .OBJ>
		       <RTRUE>)
		      (<FSET? .OBJ ,VOWELBIT>
		       <TELL " an">)
		      (T
		       <TELL " a">)>)>
	 <TELL " " D .OBJ>>

<GLOBAL LINE-MERGE
	<LTABLE 0 
	 "flock in droves"
	 "defect nearly en masse"
	 "virtually hemorrhage">>

<GLOBAL HO-HUM
	<LTABLE 0 
	 " doesn't do anything."
	 " accomplishes nothing."
	 " has no desirable effect.">>		 

<GLOBAL YUKS
	<LTABLE 0 
	 "What a concept."
         "Nice try."
	 "You can't be serious."
	 "Not bloody likely.">>

;"1-Highlight that remark. 2 -Drag it over to the Trash icon. 3 - Empty trash."
<GLOBAL IMPOSSIBLES
	<LTABLE 0 
	 "Fiddle-de-dee! Rot! Rubbish! Figs!"
	 "Absolutely insane."
	 "There you go again ..."
	 "Humbug.">>

<GLOBAL WASTES
	<LTABLE 0 
	  "Complete waste of time."
	  "Useless. Utterly useless."
	  "Not in the least bit helpful.">>