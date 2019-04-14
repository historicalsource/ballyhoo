"BIGTOP for BALLYHOO: Copyright (C)1984 Infocom, Inc."

<OBJECT CIRCUS
	(IN GLOBAL-OBJECTS)
	(DESC "circus")
	(SYNONYM SHOW ACT FEAT)
	(ADJECTIVE CIRCUS BALLYHOO)
	(FLAGS NDESCBIT)
	(ACTION CIRCUS-F)>

;"RMUNGBIT = guard told your about circus/munrab"

;<OBJECT CIRCUS 
	(IN GLOBAL-OBJECTS)
	(DESC "The Traveling Circus That Time Forgot, Inc.")
	(SYNONYM CIRCUS FORGOT)
	(ADJECTIVE TRAVELING TIME)
	(FLAGS NDESCBIT)
	;(ACTION CIRCUS-F)>

<ROUTINE CIRCUS-F ()
	 <COND (<AND <VERB? EXAMINE>
		     <EQUAL? ,HERE ,STANDS-ROOM>>
	        <TELL 
"How the crowd's enjoying a show that's so hard to see is hard to see." CR>)>>
		      
<ROOM UNDER-STANDS
      (IN ROOMS)
      (DESC "Under the Bleachers")
      (SW PER EXIT-UNDER-STANDS)
      (UP PER NOT-UNDER-STANDS)
      (SOUTH PER EXIT-UNDER-STANDS)
      (FLAGS ONBIT RLANDBIT INDOORSBIT)
      (GLOBAL GRANDSTAND BIGTOP PATH)
      (ACTION UNDER-STANDS-F)>

<ROUTINE UNDER-STANDS-F (RARG)
	 <COND (<EQUAL? .RARG ,M-LOOK>
		<TELL 
"You're standing between the underside of the " D ,GRANDSTAND " and the
side wall of the " D ,BIGTOP ". Not unexpectedly, the " D ,GROUND " here
is strewn with garbage. The only exit is ">
		<COND (,WON-STANDS
		       <TELL "back under the tent">)
		      (T
		       <TELL "southwest">)>
		<TELL ,PERIOD>)>>

<ROUTINE EXIT-UNDER-STANDS ()
	 <COND (<EQUAL? ,P-WALK-DIR ,P?SW>
		<COND (,WON-STANDS
		       <TELL "The grandstand">
		       <TELL ,TELL-STANDS>
		       <TELL ", blocking the former exit." CR>
		       <RFALSE>)
	       	      (T
		       <RETURN ,WINGS>)>)
	       (<FSET? ,BIGTOP ,RMUNGBIT>
		<PERFORM ,V?CRAWL-UNDER ,BIGTOP>
		<RFALSE>)
	       (T
		<TELL "You bump into the side wall of the " D ,BIGTOP "." CR>
		<RFALSE>)>>

<ROUTINE NOT-UNDER-STANDS ()
	 <TELL "You're UNDER the stands, understand?" CR>
	 <SETG AWAITING-REPLY 7>
	 <ENABLE <QUEUE I-REPLY 2>>
	 <RFALSE>>

<OBJECT GARBAGE
	(IN UNDER-STANDS)
	(DESC "garbage")
	(SYNONYM GARBAGE TRASH)
	(FLAGS NDESCBIT NOA)
	(ACTION GARBAGE-F)>

<ROUTINE GARBAGE-F ()
	 <COND (<VERB? SEARCH SEARCH-OBJECT-FOR EXAMINE DIG MOVE LOOK-UNDER
		       LOOK-INSIDE>
		<COND (<IN? ,TICKET ,LOCAL-GLOBALS>
	               <MOVE ,TICKET ,HERE>
	               <SETG P-IT-OBJECT ,TICKET>
		       <SETG SCORE <+ ,SCORE 10>>
		       <TELL 
"Your foray into " D ,GARBAGE " reclamation pays off, as you turn up
the unmarked ticket of some luckless circus-goer." CR>)
	       	      (<AND <IN? ,GRANOLA ,LOCAL-GLOBALS>
			    <NOT <FSET? ,GRANOLA ,RMUNGBIT>>
			    ,WON-STANDS>
		       <SETG P-IT-OBJECT ,GRANOLA>
		       <MOVE ,GRANOLA ,HERE>
		       <TELL 
"Recalling the precise trajectory of your fallen " D ,GRANOLA ", you
uncover it after a brief excavation." CR>)
	       	      (<VERB? EXAMINE>
		       <RFALSE>)
		      (T
		       <TELL "You merely raise a stench." CR>)>)
		(<VERB? CLEAN>
		 <V-DIG>)
	       (<VERB? SMELL>
		 <TELL 
"It smells vaguely of " <PICK-ONE ,FOODS> " and " <PICK-ONE ,FOODS> "." CR>)>> 
		
<OBJECT GRANDSTAND
	(IN LOCAL-GLOBALS)
	(DESC "grandstand")
	(SYNONYM SEATS SEAT STAND STANDS)
	(ADJECTIVE GRANDSTAND BLEACHER BLUES BENCH RICKETY)
	(FLAGS NDESCBIT)
	(ACTION GRANDSTAND-F)>
	
<ROUTINE GRANDSTAND-F ()
	 <COND (<AND <VERB? EXAMINE>
		     <EQUAL? ,HERE ,UNDER-STANDS>>
		<SETG PRSO ,ROOMS>
		<PERFORM ,V?LOOK-UP ,PRSO>
		<RTRUE>)	       
	       (<VERB? CLIMB-UP CLIMB-FOO THROUGH BOARD>
		<COND (<EQUAL? ,HERE ,RING>
		       <DO-WALK ,P?NORTH>)
		      (T
		       <DO-WALK ,P?UP>)>)
	       (<VERB? CLIMB-DOWN>
		<COND (<EQUAL? ,HERE ,UNDER-STANDS>
		       <DO-WALK ,P?UP>)
		      (<EQUAL? ,HERE ,STANDS-ROOM>
		       <DO-WALK ,P?DOWN>)
		      (T
		       <TELL ,LOOK-AROUND CR>)>)
	       (<VERB? BOARD>
		<COND (<EQUAL? ,HERE ,UNDER-STANDS ,WINGS>
		       <DO-WALK ,P?UP>)
		      (<EQUAL? ,HERE ,RING>
		       <DO-WALK ,P?NORTH>)
		      (T
		       <TELL ,LOOK-AROUND CR>)>)>>		      

<ROOM STANDS-ROOM  
      (IN ROOMS)
      (DESC "Standing Room Only")      
      (NORTH PER N-OOF)
      (SOUTH PER S-OOF)
      (EAST PER E-OOF)
      (WEST PER W-OOF)
      (UP PER N-OOF)
      (DOWN PER S-OOF)
      (FLAGS ONBIT RLANDBIT INDOORSBIT)
      (GLOBAL BIGTOP GRANDSTAND TIGHTROPE-OBJECT)
      (ACTION STANDS-ROOM-F)>

<ROUTINE STANDS-ROOM-F (RARG)
	 <COND (<EQUAL? .RARG ,M-LOOK>
		<COND (,SIT-IN-STANDS
		       <TELL 
"You're in the \"blues,\" sitting" ,HIGH-ABOVE ". ">)>
		<COND (<AND <NOT <VERB? WALK>>
			    <NOT <EQUAL? ,TLOC 12>>>
		       <TELL 
"You know the exit from the " D ,GRANDSTAND " to be vaguely eastward and
down. ">)>
		<TELL 
"All around you the crowd is in a state of pandemonium">
		<COND (<NOT ,SIT-IN-STANDS>
		       <TELL 
". The paths of least resistance are ">
		       <COND (<EQUAL? ,TLOC 3 9>
			      <TELL <GET ,PATHS 1>>)
			     (<EQUAL? ,TLOC 11>
			      <TELL <GET ,PATHS 5>>)			     
			     (<EQUAL? ,TLOC 8>
			      <TELL <GET ,PATHS 2>>)			     
			     (<EQUAL? ,TLOC 12>
			      <TELL <GET ,PATHS 6>>)
			     (T
			      <TELL <GET ,PATHS ,TLOC>>)>)>
 		      <TELL ,PERIOD>)
	      (<EQUAL? .RARG ,M-END>
	       <COND (<AND <FSET? ,HAWKER ,RMUNGBIT>
		      	   <EQUAL? ,TLOC ,LOST-MONEY-LOC>>
	       	      <SETG WON-STANDS T>
	       	      <SETG SCORE <+ ,SCORE 10>>
	       	      <TELL CR 
"A man in the audience suddenly hails you, tossing the " D ,GRANOLA " in your
" D ,INTDIR ". It glances off " D ,HEAD ", falls through the stands and
right before it hits the ground, in a cold sweat you ">
	       	      <WAKE-UP>)
		     (<AND <EQUAL? ,TLOC 12>
			   <EQUAL? ,POCKET-CHANGE 1841>>
		      <TELL CR 
"Suddenly a hawker appears at the end of the row and you flag him down. ">
		      <MOVE ,HAWKER ,HERE>
		      <HAWKER-GESTURES>
		      <CRLF>
		      ;<DISABLE <INT I-STANDS>>
		      <SETG P-DOLLAR-FLAG T>
		      <SETG P-AMOUNT 185>
		      <PERFORM ,V?GIVE ,INTNUM ,HAWKER>
		      <SETG P-IT-OBJECT ,GLOBAL-MONEY>
		      <RTRUE>)
		     (<AND <PROB 50>
		           <NOT ,SIT-IN-STANDS>>
		      <TELL CR 
"The bank of people above you shouts, in chorus, \"" <PICK-ONE ,BITCHES> 
"!\"" CR>)>)
	      (<EQUAL? .RARG ,M-BEG>
	       <COND (<AND <VERB? SIT WALK>
		            ,SIT-IN-STANDS>	    	     
	       	      <TELL "But you are seated." CR>)
	      	     (<VERB? SIT>
	       	      <TELL "\"Oof! Get off of me!\"" CR>)>)>>
		       
<ROUTINE HAWKER-GESTURES ()
	 <TELL 
"The hawker can barely hear you above the crowd noise. He flashes one finger,
then eight fingers, then five fingers at you, and gestures to pass the money
through the crowd." CR>>

<GLOBAL HAWKER-DIRECTION <>>

<ROUTINE I-STANDS ()
	 <ENABLE <QUEUE I-STANDS -1>>
	 <SETG STANDS-C <+ ,STANDS-C 1>>
	 <COND (<AND <EQUAL? ,STANDS-C 12>
		     <EQUAL? ,HERE ,STANDS-ROOM>
		     <EQUAL? ,POCKET-CHANGE 1656>> ;"i.e. next move aft paying"
		<TELL CR 
"The audience settles back down to a state of pandemonium." CR>
		<RTRUE>)
	       (<AND <IN? ,HAWKER ,HERE>
		     <EQUAL? ,HERE ,STANDS-ROOM>>
		<MOVE ,HAWKER ,LOCAL-GLOBALS>
		<TELL CR "Trudging ">
	        <COND (<PROB 50>
		       <TELL "down">
		       <SETG HAWKER-DIRECTION ,P?DOWN>)
		      (T
		       <SETG HAWKER-DIRECTION ,P?UP>
		       <TELL "up">)>
		<SETG FOLLOW-FLAG 17>
		<ENABLE <QUEUE I-FOLLOW 2>>
	        <TELL "ward, the hawker disappears into the " D ,CROWD>
		<COND (<VERB? WALK-TO FOLLOW>
		       <TELL " before you can reach him">)>
		<TELL ,PERIOD>
		<RTRUE>) 
	       (<EQUAL? ,STANDS-C 2 3>
		<TELL CR "You hear a loud ">
		<COND (<EQUAL? ,STANDS-C 2>
		       <TELL "growl">)
		      (T
		       <TELL "roar">)>
		<TELL " nearby." CR>)
	       (<EQUAL? ,STANDS-C 4>
		<TELL CR 
"You realize the noise is your own stomach." CR>)
	       (<OR <EQUAL? ,STANDS-C 5>
	 	    <AND <G? ,STANDS-C 5>
			 <PROB 25>
			 <EQUAL? ,HERE ,STANDS-ROOM>
			 <NOT <EQUAL? ,STANDS-C 11 12 13>>
		         ;<NOT <EQUAL? ,TLOC 13>>>>
		<FSET ,HAWKER ,NDESCBIT>
		<MOVE ,HAWKER ,HERE>
	 	<TELL CR "A " D ,HAWKER " appears at the ">
	 	<COND (<OR <EQUAL? ,TLOC 1 2 3>		    
		    	   <EQUAL? ,TLOC 7 8 9>>
		       <TELL "west">)
	       	      (T
		       <TELL "east">)>
         	<TELL 
" end of your row, calling out in a sing-song manner, \"Get your " 
<PICK-ONE ,FOODS> " here. Get your " <PICK-ONE ,FOODS> " here.\"" CR>)>>

<GLOBAL FOODS
	<LTABLE 0  
	 "tofu"
	 "popcorn"
	 "peanuts"
	 "cotton candy"
	 "granola bars"
	 "yogurt"
	 "New Coke"	
	 "Old Coke">>

<OBJECT JUNK-FOOD	
	(IN LOCAL-GLOBALS)
	(DESC "refreshment")
	(SYNONYM CANDY COKE NUTS FOOD)
	(ADJECTIVE PEANUTS YOGURT TOFU NEW OLD POPCORN COTTON REFRESHMENT)
        (FLAGS NDESCBIT ;TAKEBIT TRYTAKEBIT EATBIT)
	(ACTION JUNK-FOOD-F)>

;<GLOBAL FOOD-ORDERED <>>
;<GLOBAL ADJ-FOOD-ORDERED <>>

<ROUTINE JUNK-FOOD-F ()
	 <COND (<VERB? BUY>
		;<SETG FOOD-ORDERED <GET ,P-NAMW 0>>
		;<SETG ADJ-FOOD-ORDERED <GET ,P-ADJW 0>>
		<COND (<AND <EQUAL? ,HERE ,STANDS-ROOM>
		       	    <IN? ,HAWKER ,HERE>>
		       <PERFORM ,V?TELL ,HAWKER>
		       <RTRUE>)
		      (<EQUAL? ,HERE ,STANDS-ROOM>
		       <TELL "The " D ,HAWKER "'s nowhere in sight." CR>)
		      (<AND <EQUAL? ,HERE ,WINGS>
			    <IN? ,HAWKER ,HERE>>
		       <COND (<FSET? ,HAWKER ,RMUNGBIT>
			      <TELL
"\"Sorry, I'm all sold out. I made a killing up there,\" he says, looking
exhausted but happy." CR>)
			     (T
			      <PERFORM ,V?TELL ,HAWKER>
			      <RTRUE>)>)
		       (<AND <EQUAL? ,HERE ,CON-AREA>
			     ,DREAMING>
		        <TELL "You're not alone in your hunger." CR>)>)
		(<OR <DONT-HANDLE? ,JUNK-FOOD>
		     <VERB? ASK-FOR ASK-ABOUT>>
		 <RFALSE>)
		(<AND <EQUAL? ,HERE ,WINGS>
		      <IN? ,HAWKER ,HERE>>
		 <TELL "The only remnant of the">
		 <COND (<EQUAL? ,JUNK-FOOD ,PRSO>
		        <PRSO-PRINT>)
		       (T
			<PRSI-PRINT>)>
		 <TELL " is ground into the " D ,HAWKER "'s uniform." CR>)>>

<OBJECT HAWKER 
	(IN LOCAL-GLOBALS)
	(DESC "hawker")
	(LDESC 
"One lone hawker stands waiting in the wings, taking his break.")
	(SYNONYM MAN HAWKER CONCES)
	(FLAGS ACTORBIT PERSON NDESCBIT OPENBIT CONTBIT SEARCHBIT)	
	(ACTION HAWKER-F)>

;"RMUNGBIT = he's told you in wings about your nuts waiting for you at 
             TLOC 1 in stands"

<ROUTINE HAWKER-F ()
	 <COND (<PAY-HAWKER?>
		<COND (<EQUAL? ,FOLLOW-FLAG 99>
		       <RFATAL>)
		      (T
		       <RTRUE>)>)	       
	       (<AND <VERB? FOLLOW WALK-TO>
		     <EQUAL? ,FOLLOW-FLAG 17>>
		<DO-WALK ,HAWKER-DIRECTION>)
	       (<AND <VERB? EXAMINE>
		     <EQUAL? ,HERE ,WINGS>>
		<TELL
"Yup, it's the same guy you encountered in the stands. He's empty-handed and
his uniform resembles modern art, a besplattered canvas of condiments." CR>)
	       (<AND <VERB? GIVE>
		     <PRSI? ,HAWKER>>
	        <PERFORM ,V?WAVE-AT ,HAWKER>
		<RTRUE>)
	       (<AND <EQUAL? ,HERE ,STANDS-ROOM>
		     <TOUCHING? ,HAWKER>>
		<CANT-REACH ,HAWKER>) 
	       (<TALKING-TO? ,HAWKER>
		<COND (<AND <EQUAL? ,HERE ,STANDS-ROOM>
			    <EQUAL? ,POCKET-CHANGE 1841>>
		       <ENABLE <QUEUE I-STANDS 2>> ;"Will leave on next turn"
		       <HAWKER-GESTURES>)
		      (T
		       <COND (<EQUAL? ,HERE ,STANDS-ROOM>
			      <COND (<VERB? WAVE-AT>
				     <TELL "He didn't notice you." CR>)
				    (T
				     <TELL 
"The crowd noise completely drowns you out." CR>)>)
			     (<OR ;"not bought both granola and banana?"
				  <NOT <EQUAL? ,POCKET-CHANGE 1281>>
				  <FSET? ,HAWKER ,RMUNGBIT>>
			      <TELL "Exhausted, he ignores you." CR>)
			     (T
			      <FSET ,HAWKER ,RMUNGBIT>
			      <TELL 
"\"Hey, you're the one I passed the granola bar to in the " D ,GRANDSTAND ". ">
			      <COND (<NOT ,ORDERED-GRANOLA>
				     <TELL 
"I know that's not what you ordered, but that's all I had left. ">)>
			      <TELL 
"Well, the guy that was sitting next to you is holding the granola for
you.\"" CR>)>)>
		<STOP>)>>
				 ;<COND (<OR ,FOOD-ORDERED
					 ,ADJ-FOOD-ORDERED>
				     <TELL 
"What? You say you'd really ordered">
				     <COND (<EQUAL? ,FOOD-ORDERED ,W?BAR>
					    <TELL " a ">)>
				     <COND (,ADJ-FOOD-ORDERED
					    <PRINTB ,ADJ-FOOD-ORDERED>)>
				     <COND (,FOOD-ORDERED 
					    <TELL " ">
					    <PRINTB ,FOOD-ORDERED>)>
				     <TELL "? Sorry. ">)>

<OBJECT CROWD 
	(IN WINGS)
	(DESC "crowd")
	(SYNONYM CROWD PEOPLE)
	(ADJECTIVE ;MOB AUDIENCE)
	(FLAGS ACTORBIT PERSON NDESCBIT)
	;(GERERIC GEN-BAR)
	(ACTION CROWD-F)>

<ROUTINE CROWD-F ()
	 <COND (<AND <VERB? LISTEN>
		     <EQUAL? ,HERE ,STANDS-ROOM>>
		<TELL "They're all madly screaming." CR>)
	       (<VERB? FOLLOW>
		<COND (<AND <EQUAL? ,HERE ,CON-AREA>
			    <NOT <FSET? ,BESIDE-BIGTOP ,TOUCHBIT>>>
		       <DO-WALK ,P?EAST>)
		      (<AND <EQUAL? ,HERE ,WINGS>
			    <NOT <FSET? ,CON-AREA ,TOUCHBIT>>>
	               <DO-WALK ,P?SOUTH>)>)
	       (<OR <AND <EQUAL? ,HERE ,WINGS>
		         <NOT <FSET? ,CON-AREA ,TOUCHBIT>>>
		    <AND <EQUAL? ,HERE ,CON-AREA>
			 <RUNNING? I-BOOST>>>
		<CROWD-GONE>)
	       (<TALKING-TO? ,CROWD>
		<TELL
"You have neither the voice nor the talent to capture the " D ,CROWD "'s
attention." CR>
	        <STOP>)
	       (<PAY-HAWKER?>
		<COND (<EQUAL? ,FOLLOW-FLAG 99>
		       <RFATAL>)
		      (T
		       <RTRUE>)>)
	       (<VERB? ;ENTER THROUGH>
		<COND (<EQUAL? ,HERE ,MIDWEST>
		       <DO-WALK ,P?NORTH>)
		      (T
		       <V-WALK-AROUND>)>)
	       (<VERB? EXAMINE>
		<TELL 
"Each member appears to have been born precisely one minute apart
from the next." CR>)>>

<ROUTINE CROWD-GONE ()
	 <TELL "The " D ,CROWD "'s gone ">
	 <COND (<EQUAL? ,HERE ,CON-AREA>
		<TELL "east">)
	       (T      
		<TELL "south">)>
	 <TELL ,PERIOD>>

<ROUTINE PAY-HAWKER? ()
	 <COND (<AND <EQUAL? ,POCKET-CHANGE 1841>
		     <IN? ,HAWKER ,HERE>
		     <PRSI? ,CROWD ,HAWKER>
		     <VERB? GIVE>>
		<COND (<AND <PRSO? ,INTNUM> 
		      	     ,P-DOLLAR-FLAG>
		       <COND (<G? ,P-AMOUNT ,POCKET-CHANGE>
		       	      <TELL ,THAT-MUCH>
		       	      <RTRUE>)
		      	     (<EQUAL? ,P-AMOUNT 185>
			      <SETG POCKET-CHANGE 1656>
			      <MOVE ,HAWKER ,LOCAL-GLOBALS>
			      ;<ENABLE <QUEUE I-STANDS 3>>
			      <SETG STANDS-C 10>
			      <SETG LOST-MONEY-LOC ,TLOC>
			      <TELL 
"Your $1.85 is passed from hand to hand all the way down the row. As
the hawker pockets your money, he's suddenly engulfed by the crowd, which
erupts into a standing ovation. The state of riot panic continues for
several anxious moments." CR>)
		             (<AND <NOT <EQUAL? ,P-AMOUNT 185>>
				   ,P-DOLLAR-FLAG>	
			      <TELL "The man seemed to indicate $1.85." CR>)
			     (<PRSO? ,INTNUM ,DOLLAR ,GLOBAL-MONEY>
		              <SETG FOLLOW-FLAG 99>
			      <ENABLE <QUEUE I-FOLLOW 2>>
			      <SPECIFY-MONEY>
		       	      <RTRUE>)>)
		       (<PRSO? ,GLOBAL-MONEY>
		       	<SETG P-DOLLAR-FLAG T>
		       	<SETG P-AMOUNT 185>
		       	<PERFORM ,V?GIVE ,INTNUM ,CROWD>
		       	<SETG P-IT-OBJECT ,GLOBAL-MONEY>
		       	<RTRUE>)
		       (T
			<RFALSE>)>)
		(T
		 <RFALSE>)>>

<GLOBAL DREAMING <>>

<GLOBAL STANDS-C 0>

<GLOBAL DREAM-C 0> ;"number of times you ask to be hypnotized"

<GLOBAL SIT-IN-STANDS T>

<GLOBAL MONEY-BEFORE-DREAM 0>

;<GLOBAL SCORE-BEFORE-DREAM 0>

;<GLOBAL MOVES-BEFORE-DREAM 0>

<GLOBAL TLOC 1>

<GLOBAL LOST-MONEY-LOC 0>

<GLOBAL WON-STANDS <>>

<GLOBAL PATHS
	<PLTABLE 
	 "down and east" 
	 "up and east"
	 0
	 "up, down and west"
	 "up and west"
	 "down and west"
	 "up, down and east"
	 0  
	 0
	 "up, down and west">>

<ROUTINE N-OOF ()
	 <COND (<OR <EQUAL? ,TLOC 2 4 5>		    
		    <EQUAL? ,TLOC 7 8 10>
		    <EQUAL? ,TLOC 11>>
		<PLOW-F T>)
	       (T
		<NO-GO 1>)>>

<ROUTINE S-OOF ()
	 <COND (<OR <EQUAL? ,TLOC 1 3 4>		    
		    <EQUAL? ,TLOC 6 7 9>
		    <EQUAL? ,TLOC 10 12>>
		<PLOW-F>)
	       (T
		<NO-GO 2>)>>

<ROUTINE E-OOF ()
	 <COND (<OR <EQUAL? ,TLOC 1 2 3>		    
		    <EQUAL? ,TLOC 7 8 9>>
		<SCISSOR-F T>)
	       (T
		<NO-GO 3>)>>

<ROUTINE W-OOF ()
	 <COND (<OR <EQUAL? ,TLOC 4 5 6>		    
		    <EQUAL? ,TLOC 10 11 12>>
		<SCISSOR-F>)
	       (T
		<NO-GO 4>)>>

<ROUTINE NO-GO (NUM)
	 <COND (<EQUAL? .NUM 1 2>
		<TELL "You have no ">
		<COND (<EQUAL? .NUM 1>
		       <TELL "up">)
		      (T
		       <TELL "down">)>
		<TELL "ward mobility here">)
	      (T
	       <TELL "The crowd is impenetrable to the ">
	       <COND (<EQUAL? .NUM 3>
		      <TELL "east">)
		     (T
		      <TELL "west">)>)>
	      <TELL ,PERIOD>
	      <RFALSE>>

<GLOBAL BITCHES
	<LTABLE 0
	 "Down in front"
	 "Move it"
	 "We can't see"
	 "Hey, park it">>

<ROUTINE SCISSOR-F ("OPTIONAL" (EAST? <>))
	 <FCLEAR ,STANDS-ROOM ,TOUCHBIT>	 
	 <COND (.EAST?
		<SETG TLOC <+ ,TLOC 3>>)
	       (T		
		<SETG TLOC <- ,TLOC 3>>)>
	 <TELL 
"The row of legs pivots away as you scissor awkwardly past." CR CR>
	 <RETURN ,STANDS-ROOM>>

<ROUTINE PLOW-F ("OPTIONAL" (UP? <>))
	 <FCLEAR ,STANDS-ROOM ,TOUCHBIT>
	 <TELL "You plow your way ">
	 <COND (.UP?
		<TELL "up">
		<SETG TLOC <- ,TLOC 1>>)
	       (T
		<TELL "down">
		<SETG TLOC <+ ,TLOC 1>>)>
	 <TELL "ward through the crowd">
	 <COND (<EQUAL? ,TLOC 13>
		<TELL " all the way into the wings." CR CR>
	 	<COND (<NOT <FSET? ,MONKEY ,RMUNGBIT>>
		       <FSET ,MONKEY ,RMUNGBIT>
		       <FCLEAR ,WINGS ,TOUCHBIT>
		       <MOVE ,ROAR ,LOCAL-GLOBALS>
		       <MOVE ,HAWKER ,LOCAL-GLOBALS>
		       <GOTO ,WINGS>
		       <CRLF>
		       <FCLEAR ,MONKEY ,NDESCBIT>
		       <MOVE ,MONKEY ,PROTAGONIST>
		       <TELL 
"As you exhale a sigh of relief, a smallish and hairy animal inexplicably
plops down upon you from the upper reaches of the " D ,BIGTOP "." CR>
		       <RFALSE>)
		      (T
		       <RETURN ,WINGS>)>)
	       (T
		<TELL ,PERIOD>
		<CRLF>
		<RETURN ,STANDS-ROOM>)>>

<OBJECT BIGTOP 
	(IN LOCAL-GLOBALS)
	(DESC "big top")
	(SYNONYM TOP TENT WALL BIGTOP)
	(ADJECTIVE BIG SIDE CANVAS)
	(FLAGS NDESCBIT TRYTAKEBIT)
	(ACTION BIGTOP-F)>

;"RMUNGBIT = crawled in first time from midwest"

<ROUTINE BIGTOP-F ()
	 <COND (<VERB? CRAWL-UNDER BOARD>
		<COND (<OR <EQUAL? ,HERE ,MIDWEST>
			   <AND <EQUAL? ,HERE ,UNDER-STANDS>
			        <FSET? ,BIGTOP ,RMUNGBIT>>>
		       <TELL 
"You creep under the side wall of the " D ,BIGTOP>
		       <COND (<EQUAL? ,HERE ,UNDER-STANDS>
			      <TELL 
", right where you crawled in before">)>
		       <TELL ,PERIOD>
		       <CRLF>
		       <FSET ,BIGTOP ,RMUNGBIT>
		       <COND (<EQUAL? ,HERE ,UNDER-STANDS>
			      <GOTO ,MIDWEST>)
			     (T
			      <GOTO ,UNDER-STANDS>)>)
		      (<EQUAL? ,HERE ,FAT-EAST ,FAT-WEST>
		       <SETG PRSO ,FAT>
		       <TELL-HIT-HEAD>)
		      (T
		       <TENT-BOUND>)>)
	       (<VERB? WALK-TO ;ENTER THROUGH>
		<COND (<OR <EQUAL? ,HERE ,CON-AREA ,WINGS ,MIDWEST>
			   <EQUAL? ,HERE ,BESIDE-BIGTOP>>
		       <DO-WALK ,P?NORTH>)
		      (<OR <EQUAL? ,HERE ,WINGS ,RING ,DEN>
			   <EQUAL? ,HERE ,STANDS-ROOM ,UNDER-STANDS>>
		       <TELL ,LOOK-AROUND CR>)>)
	       (<VERB? LEAVE EXIT DISEMBARK>
		<COND (<EQUAL? ,HERE ,WINGS ,RING>
		       <DO-WALK ,P?SOUTH>)
		      (<EQUAL? ,HERE ,DEN>
		       <DO-WALK ,P?EAST>)
		      (<EQUAL? ,HERE ,STANDS-ROOM ,UNDER-STANDS>
		       <V-WALK-AROUND>)
		      (T
		       <TELL ,LOOK-AROUND CR>)>)		      
	       (<AND <VERB? EXAMINE>
		     <NOT <EQUAL? ,HERE ,FAT-EAST ,FAT-WEST>>>
		<TELL
"Soiled by endless miles of travel and heavily patched in places, the
wide blue-and-white stripes nevertheless rise up to">
		<COND (<FSET? ,HERE ,INDOORSBIT>
		       <TELL 
" meet at the top of the towering center pole." CR>)
		      (T
		       <TELL " the black sky above." CR>)>)
	       (<AND <EQUAL? ,HERE ,FAT-EAST ,FAT-WEST>
		     <VERB? LOOK-UNDER RAISE>>
		<NOT-PEEP>)
	       (<AND <VERB? TAKE REMOVE>
		     <EQUAL? ,HERE ,FAT-EAST ,FAT-WEST>>
		<KIND-OF-PERFORMER>)>>

<OBJECT CENTER-POLE 
	(IN LOCAL-GLOBALS)
	(DESC "center pole")
	(SYNONYM POLE SAWDUST)
	(ADJECTIVE CENTER)
	(FLAGS NDESCBIT)
	(ACTION CENTER-POLE-F)>

<ROUTINE CENTER-POLE-F ()
	 <COND (<IS-NOUN? ,W?SAWDUST>
		<SETG PRSO ,SAWDUST>
		<RFALSE>)
	       (<AND <TOUCHING? ,CENTER-POLE>
		     <NOT <EQUAL? ,HERE ,RING>>>
		<CANT-REACH ,CENTER-POLE>)
	       (<VERB? CLIMB-FOO CLIMB-UP CLIMB-ON>
		<TELL 
"You barely get off the " D ,GROUND " before you slide back down." CR>)>>

<OBJECT RING-OBJECT 
	(IN LOCAL-GLOBALS)
	(DESC "ring")
	(SYNONYM RING)
	(ADJECTIVE SECOND PERFOR)
	(FLAGS NDESCBIT)
	(ACTION RING-OBJECT-F)>

<ROUTINE RING-OBJECT-F ()
	 <COND (<IS-NOUN? ,W?SECOND>
		<PERFORM ,PRSA ,LION-CAGE ,PRSI>
		<RTRUE>)
	       (T
		<GLOBAL-ROOM-F>)>>

<OBJECT POLE
	(IN NEAR-WAGON)
	(DESC "fiberglass pole")
	(FDESC 
"Part of a narrow pole is sticking out from under the wagon.")
	(SYNONYM POLE)
	(ADJECTIVE ;LONG FIBERGLASS NARROW)
	(FLAGS TAKEBIT)	
	(SIZE 80)>

<OBJECT BALLOON
	(IN PLATFORM-2)
	(DESC "balloon")
	(FDESC 
"Floating against the ceiling of the big top is a helium balloon.")	
	(SYNONYM BALLOON)
	(ADJECTIVE RED HELIUM)
	(FLAGS TAKEBIT TRANSBIT CONTBIT)	
        (SIZE 4)
	(ACTION BALLOON-F)>

<ROUTINE BALLOON-F ()
	<COND (<VERB? TAKE>
	       <FSET ,BALLOON ,TOUCHBIT>
	       <MOVE ,BALLOON ,PROTAGONIST>
	       <TELL
"You grab the helium-filled balloon at the frill where it is tied. The
balloon gives a constant upward tug at your fingertips." CR>)
	      (<VERB? EXAMINE>
	       <TELL "It's a bright red balloon which is ">
	       <COND (<FSET? ,BALLOON ,OPENBIT>
		      <TELL "untied">)
		     (T
		      <TELL "tied closed">)>
	       <TELL " and filled with helium." CR>)
	      (<OR <VERB? DROP THROW PUT>
		   <EQUAL? ,P-PRSA-WORD ,W?FREE>>	        
	       <BALLOON-FLIGHT>
	       <CRLF>)
	      (<VERB? UNTIE OPEN>
	       <COND (<NOT <HELD? ,BALLOON>>
		      <TELL ,NOT-HOLDING " the " D ,BALLOON "." CR>)
		     (<NOT <FSET? ,BALLOON ,OPENBIT>>
		      <FSET ,BALLOON ,OPENBIT>
		      <TELL 
"You untie the end of the " D ,BALLOON ", holding it closed." CR>)
		     (<AND <VERB? OPEN>
			   <FSET? ,BALLOON ,OPENBIT>>
		      <FSET ,BALLOON ,OPENBIT>
		      <BALLOON-FLIGHT>
		      <CRLF>)
		     (T
		      <TELL "It isn't tied." CR>)>)
	       (<AND <VERB? TIE CLOSE>
		     <NOT ,PRSI>>
		<COND (<FSET? ,BALLOON ,OPENBIT>
		       <FCLEAR ,BALLOON ,OPENBIT>
		       <TELL 
"Okay, the " D ,BALLOON " is once again tied closed." CR>)
		      (T
		       <TELL "It is." CR>)>)
	       (<VERB? INHALE>
		<TELL 
"It would be safer to inhale what's IN the balloon." CR>)
	        ;(<VERB? LOOK-INSIDE>
		 <V-COUNT>)
		(<HURT? ,BALLOON>
		 <TELL "You manage to puncture it. ">
		 <MOVE ,BALLOON ,LOCAL-GLOBALS>
		 <BALLOON-FLIGHT>
		 <CRLF>)>>

<ROUTINE BALLOON-FLIGHT ()
	 <FSET ,BALLOON ,TOUCHBIT>
	 <MOVE ,BALLOON ,LOCAL-GLOBALS>
	 <COND (<AND <NOT <FSET? ,BALLOON ,OPENBIT>>
		     <NOT <HURT? ,BALLOON>>>
		<TELL 
"The " D ,BALLOON " flies up and ">
                     <COND (<NOT <FSET? ,HERE ,INDOORSBIT>> 
	                    <TELL
"disappears into the night sky.">
			    <RTRUE>)
       		           (T
			    <TELL 
"gets punctured on the " D ,CEILING ". ">)>)>
		<TELL
"With helium spitting out of it, the fink zips wildly through the air
and disappears. ">>

<OBJECT HELIUM
	(IN BALLOON)
	(DESC "helium")
	(SYNONYM HELIUM)
	(FLAGS NDESCBIT NARTICLEBIT AIRBIT CLEARBIT)
	(SIZE 2)
	(ACTION HELIUM-F)>

<ROUTINE HELIUM-F ()
	 <COND (<VERB? INHALE>
		<COND ;(<NOT ,THUMB-THRU>
		       <TELL ,TIPPED-OFF>
		       <RTRUE>)
		      (<FSET? ,BALLOON ,OPENBIT>
		       <MOVE ,BALLOON ,LOCAL-GLOBALS>
		       <MOVE ,HELIUM ,LOCAL-GLOBALS>
		       <ENABLE <QUEUE I-HELIUM 2>>
		       <TELL
"The " D ,BALLOON " shrinks rapidly before your eyes as your chest
expands and tightens ... then it slips from your grasp! ">
		       <BALLOON-FLIGHT>
		       <TELL 
"You manage to momentarily hold the helium in your lungs." CR>
		       <PUTP ,PROTAGONIST ,P?ACTION ,PROTAGONIST-HACK-F>)
		      (T
		       <TELL "But the " D ,BALLOON " is tied closed." CR>)>)
		(<VERB? DROP>
		 <V-COUNT>)>>
 		 
<ROUTINE I-HELIUM ()
	 <DISABLE <INT I-HELIUM>>
	 <COND (<NOT ,SPEAK-HELIUM>
		<TELL CR "You exhale your lungsful of helium." CR>)>
	 <RFALSE>>
	 
<OBJECT NET
	(IN RING)
	(DESC "safety net")
	(SYNONYM NET)
	(ADJECTIVE SAFETY)
	(FLAGS NDESCBIT CONTBIT OPENBIT SURFACEBIT SEARCHBIT VEHBIT)
	(GENERIC GEN-NET)
	(ACTION NET-F)>

<ROUTINE NET-F ("OPTIONAL" (RARG <>))
	 <COND (<EQUAL? .RARG ,M-BEG>
		<COND (<AND <VERB? WALK>
			    <EQUAL? ,P-WALK-DIR ,P?DOWN ,P?OUT>> ;"generalize?"
		       <PERFORM ,V?DISEMBARK ,NET>
		       <RTRUE>)
		      (<VERB? WALK>		     
		       <OUT-OF-FIRST ,NET>)
		      (<VERB? LEAP>
		       <TELL
"After bouncing about the net a while you appreciate that much more the
talent of the " D ,BROS " Brothers." CR>)>)
	       (.RARG
		<RFALSE>)
	       (<AND <VERB? BOARD>
		     <IN? ,NET ,MUNRAB>>
		<TELL ,BASKET-CASE CR>)
	       (<AND <VERB? TAKE>
		     <IN? ,NET ,MUNRAB>>
		<TELL
D ,MUNRAB " looks flustered then yanks the coarsely woven net out of "
D ,HANDS ". \"I'm in charge here!\"" CR>)
	       (<AND <TOUCHING? ,NET>
		     <IN? ,NET ,GLOBAL-OBJECTS>> ;"moved to globals to"
		<CANT-SEE ,NET>)                 ;"ask jim for"
	       (<VERB? OPEN CLOSE>
		<CANT-OPEN>)
	       (<AND <VERB? DISEMBARK CLIMB-DOWN>
		     <EQUAL? <LOC ,PROTAGONIST> ,NET>>
		<MOVE ,PROTAGONIST ,HERE>
		<TELL 
"You climb out of the " D ,NET " with a bounce in your step." CR>)>> 

<OBJECT GLOBAL-NET
	(IN GLOBAL-OBJECTS)
	(DESC "safety net")
	(SYNONYM NET)
	(ADJECTIVE SAFETY)
	(GENERIC GEN-NET)
	(ACTION GLOBAL-NET-F)>

<ROUTINE GLOBAL-NET-F ()
	 <COND (<DONT-HANDLE? ,GLOBAL-NET>
		<RFALSE>)
	       (<OR <IN? ,NET ,LOCAL-GLOBALS>
		    <IN? ,NET ,GLOBAL-OBJECTS>
		    <AND <OR <IN? ,NET ,MUNRAB>
		             <IN? ,NET ,RING>>
		         <NOT <EQUAL? ,HERE ,TIGHTROPE-ROOM ,PLATFORM-1
				      ,PLATFORM-2>>>>
		<CANT-SEE <> "the net">)
	       (<VERB? LOOK-INSIDE EXAMINE>
		<PERFORM ,V?LOOK-DOWN>
		<RTRUE>)
	       (<AND <VERB? PUT>
		     <PRSI? ,GLOBAL-NET>>
		<PERFORM ,V?DROP ,PRSO>
		<RTRUE>)
	       (<VERB? LEAP THROUGH BOARD>
		<SETG HERE ,PLATFORM-1>
		<PERFORM ,V?LEAP-OFF ,PLATFORM>
		<RTRUE>)
	       (<TOUCHING? ,GLOBAL-NET>
		<CANT-REACH ,NET>)>>
		     
<ROUTINE GEN-NET ()
	 ,GLOBAL-NET>

<ROOM WINGS  
      (IN ROOMS)
      (DESC "In the Wings")
      ;(SYNONYM STATION WPDL)
      ;(ADJECTIVE RADIO)
      (NORTH PER RING-ENTER)
      (IN PER RING-ENTER)
      (SOUTH TO CON-AREA)
      (OUT TO CON-AREA)      
      (UP PER STANDS-ENTER)
      (NE PER STANDS-ENTER)
      (FLAGS ONBIT RLANDBIT INDOORSBIT)
      (GLOBAL BIGTOP GRANDSTAND RING-OBJECT CENTER-POLE PATH)
      (ACTION WINGS-F)>

<ROUTINE WINGS-F (RARG)
	 <COND (<AND <EQUAL? .RARG ,M-ENTER>
		     <EQUAL? ,POCKET-CHANGE 1281> ;"have paid BOTH times"
		     <FSET? ,LONG ,RMUNGBIT> ;"I.E. WON LINES"		
		     ,DREAMING>
		<DISABLE <INT I-STANDS>>
		<FCLEAR ,HAWKER ,NDESCBIT>
		<MOVE ,HAWKER ,WINGS>
		<MOVE ,JUNK-FOOD ,HAWKER>)
	       (<EQUAL? .RARG ,M-LOOK>
	        <TELL 
"The " D ,BIGTOP " can be entered to the north and exited to the south. ">
	        <COND (<OR ,WON-STANDS
			    <AND <EQUAL? ,MEET-COUNTER 10>
			         <NOT ,DREAMING>>>
		       <CRLF> <CRLF>)>
		<TELL
"To the northeast, the grandstand">
		<COND (,WON-STANDS
		       <TELL ,TELL-STANDS>)
		      (<AND <EQUAL? ,MEET-COUNTER 10> ;"IE, HEARD MEETING"
		            <NOT ,DREAMING>>
			<TELL 
" has been retracted slightly, revealing a passage">)			      
		      (T
		       <TELL " begins its precipitous rise">)>
		<TELL ,PERIOD>) 
	       (<AND <EQUAL? .RARG ,M-BEG>
		     <VERB? WAIT>>
		<TELL 
"Very theatrical of you, waiting in the wings. Expect no awards, however. ">
		<RFALSE>)
	       (<AND <EQUAL? .RARG ,M-END>
		     <OR <EQUAL? ,MEET-COUNTER 10>
			 <FSET? ,POLE ,TOUCHBIT>>
		     <NOT <FSET? ,PLATFORM-2 ,TOUCHBIT>>
		     <NOT ,DREAMING>
		     <IN? ,NET ,RING>
		     <NOT <FSET? ,WEST-CAMP ,TOUCHBIT>>> ;"so cant do later"
		<ENABLE <QUEUE I-FOLLOW 2>>
		<SETG FOLLOW-FLAG 14>
		<SETG P-IT-OBJECT ,JIM>		
		<MOVE ,NET ,LOCAL-GLOBALS>
		<FCLEAR ,RING ,TOUCHBIT>
		<TELL CR 
"A roustabout who is wearing a " D ,HEADPHONES " and carrying a large net
over his shoulder passes you and exits the " D ,BIGTOP "." CR>)
	      (<AND <EQUAL? .RARG ,M-END>
		    <MONKEY-ACTS?>>
	       <RFALSE>)>>

<ROUTINE RING-ENTER ()
	 <COND (,DREAMING
		<TELL 
"You are immediately driven out of the ring by a rousing chorus of boos." CR>
		<RFALSE>)
	       ;(<AND <HELD? ,MEAT>
		     <IN? ,ELSIE ,RING>>
		<TELL
"As you step into the ring, you peer into the round cage and notice that the
lions have quickened their breathing." CR CR>
		<RETURN ,RING>) 
	       (T
		<RETURN ,RING>)>>

<ROUTINE STANDS-ENTER ()
	 <COND (<AND <EQUAL? ,MEET-COUNTER 10>
		     <NOT ,DREAMING>
		     <NOT ,WON-STANDS>>
		<COND (<EQUAL? ,P-WALK-DIR ,P?UP>
		       <WALK-INTO-STANDS>
		       <RFALSE>)
		      (T
		       <RETURN ,UNDER-STANDS>)>)
	       (,DREAMING
		<COND (<HELD? ,MONKEY>
		       <MONKEY-DIRECTION>
		       <RFALSE>)
		      (T
		       <SETG TLOC 12>
		       <TELL "You forge ahead and up the steps." CR CR>
		       <RETURN ,STANDS-ROOM>)>)
	       (T
		<WALK-INTO-STANDS>
	        <RFALSE>)>> 

<ROUTINE MONKEY-DIRECTION ()
	 <TELL 
"Agitated by your choice of " D ,INTDIR ", the " D ,MONKEY " steers you
away from it." CR>>

<ROUTINE WALK-INTO-STANDS ()
	 <TELL 
"Climbing up into the deserted and littered grandstands produces a disorienting
sense of deja vu. You make a headachy descent down the steps." CR>
	 <RFALSE>>

<ROOM RING  
      (IN ROOMS)
      (DESC "Performance Ring")
      (UP PER UP-LADDER)
      (NORTH PER WALK-INTO-STANDS)
      (EAST PER WALK-INTO-STANDS)
      (SOUTH PER WING-EXIT)
      (OUT PER WING-EXIT)
      (WEST TO DEN IF LION-DOOR IS OPEN)
      (IN TO DEN IF LION-DOOR IS OPEN)      
      (FLAGS ONBIT RLANDBIT INDOORSBIT)
      (GLOBAL LADDER LION-DOOR BIGTOP LION-CAGE GRANDSTAND RING-OBJECT
	      TIGHTROPE-OBJECT CENTER-POLE)
      (ACTION RING-F)>

<ROUTINE RING-F (RARG)
	 <COND (<EQUAL? .RARG ,M-LOOK>
		<TELL 
"This is the arena's oval-shaped performance ring">
		<COND (<NOT ,END-GAME>
		       <TELL " which ">
		       <COND (<IN? ,NET ,RING>
                       	      <TELL 	       
"is occupied by a sagging, rectangular ">)
		      	     (T
		       	      <TELL
"appears deathly quiet without its circus atmosphere. Also missing is
its ">)> 
                	      <TELL
D ,NET ". A rope ladder dangles to within a foot of the " D ,GROUND ".">)
		     (T
		      <TELL ". ">
		      <TANGLED-ROPE>)>
		      <CRLF> <CRLF>
		      <TELL 
"Just west lies the entrance to a large, round cage that completely
encircles the second of the two rings. To the south the " D ,BIGTOP "'s
vaulted wing leads out into the open air. The arena's rickety grandstands
rise steeply north and east.">
		      <COND (,END-GAME
			     <TELL-APE>)>
		      <CRLF>)
	       (<AND <EQUAL? .RARG ,M-BEG>
		     <IN? ,NET ,MUNRAB>
		     <VERB? ASK-ABOUT YELL TELL TELL-ABOUT HELLO
			    REPLY>>
		<SETG P-CONT <>>
		<TELL 
"You're hardly recognized above the commotion." CR>
		<RTRUE>)
	       (<EQUAL? .RARG ,M-ENTER>
		<COND (,END-GAME
		       <MOVE ,APE ,RING>
		       <COND (<NOT <IN? ,NET ,MUNRAB>>
		       	      <MOVE ,NET ,GLOBAL-OBJECTS>)> ;"so can tell jim"
		       <RFALSE>)>
		<COND (<AND <EQUAL? ,P-WALK-DIR ,P?EAST ,P?OUT>
		            <IN? ,ELSIE ,CHUTE>
			    <IN? ,STAND ,DEN>>
		       <MOVE ,STAND ,RING>
		       <FCLEAR ,STAND ,VEHBIT>
		       <FSET ,STAND ,NDESCBIT>)>
	        <COND (<IN? ,MEAT ,DEN>
		       <MOVE ,MEAT ,LOCAL-GLOBALS>
		       <MOVE-LIONS ,RING>		       
		       <TELL 
,EXIT-DEN "s together finish off the meat and settle back on the " 
D ,SAWDUST "." CR CR>		       			      
		       <SETG ELSIE-COUNTER 0>
		       <RTRUE>)
		      (<AND <EQUAL? ,P-WALK-DIR ,P?EAST ,P?OUT>
		            <IN? ,ELSIE ,DEN>
			    <NOT <IN? ,MEAT ,DEN>>>
		       <DISABLE <INT I-LION>>
		       <TELL ,EXIT-DEN>
		       <COND (<AND <IN? ,MEAT ,CHUTE>
		                   <FSET? ,GRATE ,OPENBIT>>
		       	      <TELL "s slink out through the open grate.">
		       	      <ENABLE <QUEUE I-LION -1>>
		       	      <MOVE-LIONS ,CHUTE>)
		      	     (T
		       	      <COND (<EQUAL? ,ELSIE-COUNTER 0>
			      	     <TELL "s quit">)
			     	    (T
			      	     <TELL " quits">)>
		       	      <TELL " pacing and hunker">
		       	      <COND (<G? ,ELSIE-COUNTER 0>
			      	     <TELL "s">)>
		       	      <TELL " back down onto the sawdust.">
		       	      <SETG ELSIE-COUNTER 0>
			      <MOVE-LIONS ,RING>)>
		       <CRLF> <CRLF>)>)>>

<ROUTINE WING-EXIT ()
	 <COND (<HELD? ,STAND>
		<TELL 
"The " D ,STAND " is too bulky to be carried that distance." CR>
		<RFALSE>)
	       (T
		<RETURN ,WINGS>)>>

<ROUTINE TANGLED-ROPE ("OPTIONAL" (TOUCHING? <>))
	 <TELL "The rope ladder">
	 <COND (<EQUAL? ,HERE ,RING>
		<TELL " above " D ,HEAD>)>
	 <TELL 
" has been tangled around the platform from which it hangs.">
	 <COND (.TOUCHING?
		<CRLF>)>>

<GLOBAL APE-LOC <>>
;"1 = on plat-1. 
  2 = in apparatus
  3 = on plat-2 w/girl
  4 = on plat-2 w/out girl"

<ROUTINE TELL-APE ()
	 <COND (<NOT <VERB? LOOK-UP>>
		<CRLF> <CRLF>)>
	 <COND (<EQUAL? ,APE-LOC 1>
		<TELL 
"Craning your neck upward, you see " D ,APE " standing on the platform above
the rope " D ,LADDER>)
	       (<EQUAL? ,APE-LOC 2>
		<TELL ;"apparatus"
"The shadowy form of the great ape is ensconced among the guy wires above
the tightrope">)
	       (T    ;<EQUAL? ,APE-LOC 3>
		<TELL D ,APE " stands ">
		<COND (<EQUAL? ,HERE ,TIGHTROPE-ROOM ,PLATFORM-1>
		       <TELL "across from you ">)>
		<TELL 
"on the opposite platform, one of his great limbs grasping a guy wire for
balance">)>
	        <TELL 
". He is holding the limp form of a small girl under one arm.">>
	       		
<OBJECT STOOL
	(IN FAT-EAST)
	(DESC "stool")
	(SYNONYM STOOL)
	;(ADJECTIVE WOODEN)
	(FLAGS TAKEBIT VEHBIT)
	(SIZE 26)
	(ACTION STOOL-F)>

<ROUTINE STOOL-F ()
	 <COND (<VERB? EXAMINE>
		<TELL 
"One leg of the " D ,STOOL " is shorter than the other two." CR>)
	       (<VERB? BOARD STAND-ON>
		<TELL "It's too rickety to support your weight." CR>)
	       (<VERB? TAKE-OFF>
		<PERFORM ,V?DISEMBARK ,STOOL>
		<RTRUE>)>>  
		
<ROOM PLATFORM-1 
	(IN ROOMS)
	(DESC "Platform")
	(FLAGS ONBIT RLANDBIT INDOORSBIT)
     	(EAST PER PLATFORM-EXIT-F)
	(DOWN PER DOWN-LADDER)
	(UP PER CLIMB-GUY)
        (GLOBAL TIGHTROPE-OBJECT LADDER PLATFORM CENTER-POLE BIGTOP) 
	(GROUND-LOC RING)
	(ACTION PLATFORM-1-F)>

<ROUTINE PLATFORM-1-F (RARG)
	 <COND (<EQUAL? .RARG ,M-LOOK>
		<PLATFORM-ROOM-DESC>
		<COND (,END-GAME
		       <TELL-APE>)>
		<CRLF>)
	       (<AND <EQUAL? .RARG ,M-ENTER>
		     ,END-GAME>
		<MOVE ,APE ,PLATFORM-1>)>>

<ROUTINE CLIMB-GUY ()	
	 <PERFORM ,V?CLIMB-ON ,GUY-WIRES>
	 <RFALSE>>

<ROOM PLATFORM-2  
	(IN ROOMS)
	(DESC "Platform")
	(FLAGS ONBIT RLANDBIT INDOORSBIT)
     	(WEST PER PLATFORM-EXIT-F)
	(GLOBAL PLATFORM TIGHTROPE-OBJECT BIGTOP CENTER-POLE)
	(GROUND-LOC RING)
	(ACTION PLATFORM-2-F)>

<ROUTINE PLATFORM-2-F (RARG)
	 <COND (<EQUAL? .RARG ,M-LOOK>
		<PLATFORM-ROOM-DESC>
		<COND (,END-GAME
		       <TELL-APE>)>
		<CRLF>)>>

<ROUTINE PLATFORM-ROOM-DESC ()
	 <TELL 
"You're standing on a small, unstable platform which is suspended"
,HIGH-ABOVE " by guy wires converging on it from all directions. ">
	 <COND (<EQUAL? ,HERE ,PLATFORM-1>
		<TELL "A rope ladder dangles from the platform and t">)
	       (T
		<TELL "T">)>
	<TELL "he tightrope stretches ">
         <COND (<EQUAL? ,HERE ,PLATFORM-1>
		<TELL "east">)
	       (T
	        <TELL "west">)>
	 <TELL " to the opposite platform">
	 <COND (<EQUAL? ,APE-LOC 3>
		<TELL 
" where the attention of everyone in the " D ,BIGTOP " is focused">)>
	 <TELL ".">>

<GLOBAL HEADING-EAST? <>>

<GLOBAL ON-ROPE 0>

<ROOM TIGHTROPE-ROOM
	(IN ROOMS)
	(DESC "Walking a Tightrope")
	(FLAGS ONBIT RLANDBIT INDOORSBIT)
	(EAST PER ACROSS-ROPE)
	(WEST PER ACROSS-ROPE)
      	(GLOBAL PLATFORM TIGHTROPE-OBJECT BIGTOP CENTER-POLE)
	(GROUND-LOC RING)
	(ACTION TIGHTROPE-ROOM-F)>

<ROUTINE TIGHTROPE-ROOM-F (RARG)
	  <COND (<EQUAL? .RARG ,M-LOOK>
		 <TELL "You are standing, ">
		 <COND (<HELD? ,POLE>			    
			<TELL "poised">)
		       (T
		        <TELL "perched " <PICK-ONE ,DANGERS>>)>
		 <TELL 
,HIGH-ABOVE ", " <GET ,ROPES ,ON-ROPE> " across the " D ,TIGHTROPE-OBJECT ".">
		 <COND (,END-GAME
		        <TELL-APE>)>
		 <CRLF>)
		(<EQUAL? .RARG ,M-BEG>
		 <COND (<OR <VERB? LEAP LEAP-OFF WEAR>
		            <AND <VERB? WALK>
			         <EQUAL? ,P-WALK-DIR ,P?DOWN>>
			    <AND <VERB? DROP THROW>
			         <PRSO? ,POLE>>>
                      	<TELL ,UNBALANCED>
		      	<FLYING>		      
		      	<TELL "And you fall ...">
		      	<FALL-DOWN>)>)
	        (<AND <EQUAL? .RARG ,M-ENTER>
		     ,END-GAME>
		 <MOVE ,APE ,TIGHTROPE-ROOM>)>>

<GLOBAL DANGERS 
	<LTABLE 0 
	"perilously"
	"nakedly"
	"precariously"
	"dubiously">>

<GLOBAL ROPES
	<PLTABLE  
	 "a couple of baby steps"
	 "just part of the way"
	 "about midway"
	 "most of the way"
	 "nearly all the way">>

<OBJECT TIGHTROPE-OBJECT
	(IN LOCAL-GLOBALS)
	(DESC "tightrope")
	(SYNONYM ROPE WIRE TIGHTR HIGH-)
	(ADJECTIVE TIGHT HIGH)
	(FLAGS NDESCBIT TRYTAKEBIT)
	(ACTION TIGHTROPE-OBJECT-F)>
	
<ROUTINE TIGHTROPE-OBJECT-F ()
	 <COND (<AND <EQUAL? ,HERE ,RING>
		     <TOUCHING? ,TIGHTROPE-OBJECT>>
		<CANT-REACH ,TIGHTROPE-OBJECT>)
	       (<VERB? CLIMB-ON TAKE>
		     ;<NOT <EQUAL? ,P-PRSA-WORD ,W?GET>>
		<TELL ,NO-TALENT CR>)
	       (<AND <VERB? THROUGH BOARD WALK-TO CLIMB-ON>
		     <EQUAL? ,HERE ,PLATFORM-1 ,PLATFORM-2 ,TIGHTROPE-ROOM>>
		<COND (<OR <EQUAL? ,HERE ,PLATFORM-1>
		            ,HEADING-EAST?>
		       <DO-WALK ,P?EAST>)
		      (<OR <EQUAL? ,HERE ,PLATFORM-2>
		           <AND <EQUAL? ,HERE ,TIGHTROPE-ROOM>
				<NOT ,HEADING-EAST?>>>
		       <DO-WALK ,P?WEST>)>)>>		      
		      
<OBJECT GUY-WIRES
	(IN GLOBAL-OBJECTS)
	(DESC "apparatus")
	(SYNONYM WIRES WIRE APPARATUS)
	(ADJECTIVE GUY SUPPORTING)
	(FLAGS NDESCBIT VOWELBIT)
	(ACTION GUY-WIRES-F)>

<ROUTINE GUY-WIRES-F ()
         <COND (<NOT <SEE-WIRES?>>
		<CANT-SEE <> "the guy wires">
		<STOP>)
	       (<AND <NOT <EQUAL? ,HERE ,PLATFORM-1 ,PLATFORM-2>>
		     <TOUCHING? ,GUY-WIRES>>
		<CANT-REACH ,GUY-WIRES>)
	       (<VERB? CLIMB-UP CLIMB-FOO SHAKE CLIMB-ON MOVE>
		<COND (<EQUAL? ,APE-LOC 2>		       
		       <SETG APE-LOC 3>
	       	       <TELL 
"You're not very good at aping " D ,APE " in this respect, but the
vibrations of your attempt serve to flush him from his perch among the
guy wires and onto the opposite platform.">
		       <COND (<EQUAL? <META-LOC ,RADIO> ,PLATFORM-2>
		              <TELL " \"Crunch!\"">)>
		       <CRLF>)
		      (<NOT <VERB? SHAKE MOVE>>
		       <TELL ,NO-TALENT CR>)>)>>

<ROUTINE SEE-WIRES? ()
	 <COND (<OR <EQUAL? ,HERE ,PLATFORM-1 ,PLATFORM-2 ,TIGHTROPE-ROOM>
	            <EQUAL? ,HERE ,RING>>
		<RTRUE>)
	       (T
		<RFALSE>)>>  

<OBJECT PLATFORM
	(IN LOCAL-GLOBALS)
	(DESC "platform")
	(SYNONYM PLATFORM)
	(ADJECTIVE SMALL UNSTABLE OPPOSITE)
	(FLAGS NDESCBIT)
	(ACTION PLATFORM-F)>

<ROUTINE PLATFORM-F ()
	 <COND (<IS-ADJ? ,W?OPPOSITE>
		<COND (<VERB? WALK-TO THROUGH>
		       <COND (<OR ,HEADING-EAST?
				  <EQUAL? ,HERE ,PLATFORM-1>>
			      <DO-WALK ,P?EAST>)
			     (<EQUAL? ,HERE ,PLATFORM-2>
			      <DO-WALK ,P?WEST>)>)
		      (<TOUCHING? ,PLATFORM>
		       <CANT-REACH ,PLATFORM>)>) 
	       (<AND <VERB? LOOK-ON>
		     <EQUAL? ,HERE ,PLATFORM-1 ,PLATFORM-2>>
		<V-LOOK>
		<RTRUE>)
	       (<VERB? PUT-ON>
		<COND (<EQUAL? ,HERE ,PLATFORM-1 ,PLATFORM-2>
		       <PERFORM ,V?DROP ,PRSO>
		       <RTRUE>)
		      (T
		       <CANT-REACH ,PLATFORM>)>)
	       (<VERB? THROUGH WALK-TO BOARD>
		<COND (<EQUAL? ,HERE ,PLATFORM-1 ,PLATFORM-2>
		       <TELL ,LOOK-AROUND CR>)
		      (<EQUAL? ,HERE ,TIGHTROPE-ROOM>
		       <COND (,HEADING-EAST?
			      <DO-WALK ,P?EAST>)
			     (T
			      <DO-WALK ,P?WEST>)>)
		      (T	     
	       	       <CANT-SEE ,PLATFORM>)>)
	       (<VERB? LEAP LEAP-OFF>
		<COND (<AND <EQUAL? ,HERE ,TIGHTROPE-ROOM>
		            <VERB? LEAP-OFF>>
		       <TELL ,LOOK-AROUND CR>)		      
		      (T
		       <TELL ,UNBALANCED>
		       <FLYING>		      
		       <TELL "And you fall ...">
		       <FALL-DOWN>)>)>>

<ROUTINE PLATFORM-EXIT-F ()
         <COND (<EQUAL? ,APE-LOC 2>
		<TELL 
D ,APE ", perched above you, is restless enough to make the " 
D ,TIGHTROPE-OBJECT " too herky-jerky to walk across." CR>
		<RFALSE>) 
	       (<OR <FSET? ,SUIT ,WORNBIT>
		    <FSET? ,DRESS ,WORNBIT>>
		<TELL "You're not dressed for wire-walking." CR>
		<RFALSE>)
	       (<AND <NOT <HELD? ,POLE>>
		     <NOT ,END-GAME>>
		<ENABLE <QUEUE I-TREMBLE <+ 2 <RANDOM 3>>>>)>
 	 <COND (<EQUAL? ,P-WALK-DIR ,P?EAST>
		<SETG HEADING-EAST? T>)
	       (T
		<SETG HEADING-EAST? <>>)>
	 <SETG ON-ROPE 1>
	 <FCLEAR ,TIGHTROPE-ROOM ,TOUCHBIT>
	 <RETURN ,TIGHTROPE-ROOM>>

<GLOBAL LEAN-NORTH? <>>

<GLOBAL TREMBLE-C 0>

<ROUTINE I-TREMBLE ()
	 <SETG TREMBLE-C <+ ,TREMBLE-C 1>>
         <ENABLE <QUEUE I-TREMBLE -1>>
	 <COND (<EQUAL? ,TREMBLE-C 4>
		<TELL
"You're really fighting it now, the high wire starts acting like a jump rope. ">
	        <FLYING>
	        <CRLF>
		<TELL <PICK-ONE ,FALL-GAG>>
	        <TELL " right before you plummet ...">
                <FALL-DOWN>)
	       (<AND <G? ,TREMBLE-C 1>
		     <NOT <VERB? LEAN>>>
		<TELL 
"You're still out of balance, " <PICK-ONE ,LEANS> " now, to the ">
	        <COND (,LEAN-NORTH?
		       <TELL "north." CR>)
		      (T
		       <TELL "south." CR>)>
		<RTRUE>)
	       (<EQUAL? ,TREMBLE-C 1>
		<TELL "You find " D ,ME>	        
		<LEANING>
		<COND (<PROB 50>
		       <LEAN T>)
		      (T
		       <LEAN>)>)>>

<ROUTINE LEANING ()
	 <TELL " leaning " <PICK-ONE ,LEANS> " to the">>

<ROUTINE LEAN ("OPTIONAL" (NORTH? <>))
	 <COND (.NORTH?
		<TELL " north">	               
	        <SETG LEAN-NORTH? T>)
	       (T
		<TELL " south">
	        <SETG LEAN-NORTH? <>>)>
	 <TELL ,PERIOD>>
	       
<GLOBAL LEANS 
	<LTABLE 0 
	"almost imperceptibly"
	"just a hair"
	"quite noticeably"
	"radically">>

<GLOBAL FALL-GAG
	<LTABLE 0 
	"You're doing a pretty good Elvis"
	"Flailing away to regain some balance, you nearly slip a disk">>

<ROUTINE FLYING ("AUX" OBJ)
	 <COND (<SET OBJ <FIRST? ,PROTAGONIST>>
	        <COND (<NEXT? .OBJ>
		       <TELL "Everything you're holding">)
		      (T
		       <TELL "Oops,">
		       <ARTICLE .OBJ T>)>
	        <TELL " goes flying. ">)
	       (T
		<RFALSE>)>>

<ROUTINE FALL-DOWN ()
	 <DISABLE <INT I-TREMBLE>>
	 <SETG TREMBLE-C 0>
	 <SETG LEAN-NORTH? <>>
	 <FCLEAR ,TIGHTROPE-OBJECT ,RMUNGBIT>
	 <FCLEAR ,TIGHTROPE-ROOM ,TOUCHBIT>
	 <CARRIAGE-RETURNS 14>
	 <COND (<IN? ,NET ,MUNRAB>
		<JIGS-UP 1 
"... and the group below zigs instead of zags.">)
	       (<NOT <IN? ,NET ,RING>>
		<JIGS-UP 1 "... to an inglorious circus death.">
		<RTRUE>)
	       (T
		<SETG HERE ,RING>
		<ROB ,PROTAGONIST ,RING>
		<MOVE ,PROTAGONIST ,NET>
	        <TELL
"... deeply into the " D ,NET ", which heaves you high into the air ... then 
catches you back down." CR>)>>

<ROUTINE ACROSS-ROPE ()
	 <COND (<OR <AND <EQUAL? ,P-WALK-DIR ,P?WEST>
		          ,HEADING-EAST?>
	      	    <AND <EQUAL? ,P-WALK-DIR ,P?EAST>
			 <NOT ,HEADING-EAST?>>>
                <COND (,END-GAME
		       <COND (<EQUAL? ,ON-ROPE 1>
			      <SETG ON-ROPE 5>)
			     (<EQUAL? ,ON-ROPE 2>
			      <SETG ON-ROPE 4>)
			     (<EQUAL? ,ON-ROPE 4>
			      <SETG ON-ROPE 2>)
			     (<EQUAL? ,ON-ROPE 5>
			      <SETG ON-ROPE 1>)>
			<COND (,HEADING-EAST?
			       <SETG HEADING-EAST? <>>)
			      (T
			       <SETG HEADING-EAST? T>)>
		        <TELL 
"A daring turnaround on the tightrope! You regain your balance." CR>
		        <RFALSE>) 
		       (T
			<TELL
"A bold attempt to excite the arena seats! ">		
		        <FLYING>
	        	<TELL "You sink ...">
			<FALL-DOWN>
			<RFALSE>)>)               
	       (<RUNNING? ,I-TREMBLE>
		<COND (<0? ,TREMBLE-C>
		       <TELL "A quiver shoots through your leading foot,">)
		      (<EQUAL? ,TREMBLE-C 2 3>
		       <TELL "Your trailing foot begins to quake,">)
		      (T
		       <TELL "You're too unstable." CR>
		       <RFALSE>)>
		<TELL " stopping you dead on the wire." CR>
		<RFALSE>)
	       (<NOT <EQUAL? ,ON-ROPE 5>>
		<SETG ON-ROPE <+ ,ON-ROPE 1>>
	        <TELL "You take a couple of tentative steps across the wire">
		<COND (<EQUAL? ,ON-ROPE 3>
		       <TELL ", reaching the halfway point">)>
		<COND (<AND <EQUAL? ,APE-LOC 3>
			    ,HEADING-EAST?>
		       <COND (<EQUAL? ,ON-ROPE 2>
		       	      <TELL 
". " D ,APE " lets out an aggressive scream that echoes throughout the "
D ,BIGTOP ".">)
		             (<EQUAL? ,ON-ROPE 3>
			      <TELL 
". The gorilla raps his knuckles against his mighty chest. You can feel the
vibration on your toes.">)
			     (<EQUAL? ,ON-ROPE 4>
			      <COND (<AND <HELD? ,RADIO>
					  <EQUAL? ,STATION 1170>
					  <FSET? ,RADIO ,ONBIT>
					  ,CALLED-STATION>
			      	      <TELL 
". As the heavenly music drifts to within earshot of " D ,APE ", the beast
is becalmed, and he loosens his grip on the girl.">)
			            (T  
			             <TELL
". " D ,APE " appears determined to bring down the " D ,BIGTOP " if you take
one more step.">)>)
		            (<EQUAL? ,ON-ROPE 5>
			     <COND (<AND <HELD? ,RADIO>
					 <EQUAL? ,STATION 1170>
					 <FSET? ,RADIO ,ONBIT>
					 ,CALLED-STATION>
				    <SETG APE-LOC 4>
				    <ROB ,PROTAGONIST ,LOCAL-GLOBALS>
				    <MOVE-TAKEBIT ,RING ,WINGS>
				    <ROB ,RING ,LEFT-HANGING>
				    <MOVE ,GIRL ,LEFT-HANGING>
				    <MOVE ,THUMB ,LEFT-HANGING>
				    <MOVE ,GANG ,LEFT-HANGING>
				    <MOVE ,MUNRAB ,LEFT-HANGING>
				    <SETG END-GAME-C 0>
				    <MOVE ,TIGHTROPE-OBJECT ,LEFT-HANGING>
				    <TELL 
". You are now almost close enough to reach out and touch " D ,APE ", and the
effect of the music is to utterly relax the great ape. He lets loose the
girl like a rag doll ... falling ... falling ... falling ... deep into
the safety of the net!|
|
The cheers of joy and relief from the group encircling the net interrupt "
D ,APE "'s listening pleasure. With a stomp, he bounces you off your perch
and on your way down, you catch the wire with " D ,HANDS ", thus saving
two lives in the same move. You dangle here as the crowd below continues
their self-congratulation and rejoicing." CR CR>
				   ;<FSET ,LEFT-HANGING ,TOUCHBIT>
				   <FSET ,MUNRAB ,NDESCBIT>
				   <FSET ,THUMB ,NDESCBIT>
				   <SETG POCKET-CHANGE 0>
				   <SETG SCORE <+ ,SCORE 10>>
				   <GOTO ,LEFT-HANGING>
				   <RFALSE>)
				  (T
				   <JIGS-UP 1   
". With a stomp of its big foot, the ape bounces you off the wire and sends
you into a swan dive. You miss the net, which is properly positioned under
Chelsea.">)>)
		            (T
		      	     <RFALSE>)>
	       	      <CRLF>
	       	      <RFALSE>)
	      	     (T
	       	      <TELL " ..." CR>
	       	      <RETURN ,TIGHTROPE-ROOM>)>)
	     (T 
	      <RETURN <PLATFORM-RETURN>>)>>

<ROOM LEFT-HANGING
      (IN ROOMS)
      (DESC "Left Hanging")
      (LDESC "You're hanging from the high wire.")
      (FLAGS RLANDBIT ONBIT INDOORSBIT)
      (DOWN PER DOWN-LEFT)
      (GLOBAL RING-OBJECT TIGHTROPE-OBJECT)
      (ACTION LEFT-HANGING-F)>

<ROUTINE LEFT-HANGING-F (RARG)
	 <COND (<EQUAL? .RARG ,M-BEG>
		<COND (<VERB? ASK-ABOUT YELL TELL TELL-ABOUT HELLO REPLY
			      HELP>
		       <SETG P-CONT <>>
		       <TELL 
"You can't be heard above the commotion below." CR>)
		      (<VERB? RELEASE DROP LEAP CLAP APPLAUD REMOVE LEAP-OFF
			      THROUGH>
		       <SETG END-GAME-C 3>
		       <RTRUE>)
		      (<VERB? LOOK-DOWN>
		       <TELL "Your neck aches as you attempt it." CR>)
		      (<OR <AND <VERB? WALK>
		       	        <EQUAL? ,P-WALK-DIR ,P?EAST ,P?WEST>>
			   <AND <VERB? RAISE>
			        <PRSO? ,ME>>>
		       <TELL "The strength is lacking." CR>)
		      (<AND <TOUCHING-VERB?>
			    <NOT <EQUAL? ,PRSO ,ME ,HANDS ,TIGHTROPE-OBJECT>>
			    <NOT <EQUAL? ,PRSI ,ME ,HANDS ,TIGHTROPE-OBJECT>>>
		       <TELL "That's unreachable." CR>)
		      (T
		       <RFALSE>)>
		<RTRUE>)>>

<ROUTINE DOWN-LEFT ()
	 <PERFORM ,V?LEAP>
	 <RFALSE>>

<ROUTINE PLATFORM-RETURN ("AUX" FOO)
	 <COND (,HEADING-EAST?
		<SET FOO ,PLATFORM-2>)
	       (T
	        <SET FOO ,PLATFORM-1>)>
	 <SETG ON-ROPE 0>
	 <DISABLE <INT I-TREMBLE>>
	 <SETG HEADING-EAST? <>>
	 <COND (<AND <EQUAL? .FOO ,PLATFORM-2>
		     <NOT <FSET? ,PLATFORM-2 ,TOUCHBIT>>>
		<SETG SCORE <+ ,SCORE 10>>
		<TELL 
"\"Ta Daaaaaaaaaaa.\" Those familiar notes from tonight's show reverberate
through your body in triumph." CR CR>)>
	 <RETURN .FOO>>


;" *** Lion stuff *** "

<ROOM DEN
      (IN ROOMS)
      (DESC "Lions' Den")
      (EAST TO RING IF LION-DOOR IS OPEN)
      (OUT TO RING IF LION-DOOR IS OPEN)
      (SOUTH PER GRATE-ENTER)
      (FLAGS RLANDBIT ONBIT INDOORSBIT)
      (GLOBAL LION-DOOR LION-CAGE BIGTOP CENTER-POLE RING-OBJECT)
      (ACTION DEN-F)>

<ROUTINE DEN-F (RARG)
	 <COND (<EQUAL? .RARG ,M-LOOK>
		<TELL 
"Here inside the round cage you stand in a dingy indoor twilight,
surrounded by a panorama of closely spaced bars. The " D ,LION-DOOR "
that you're still keeping an eye on is to the east.|
|
Built into the southern side of the round cage there is a square grate which ">
	       <COND (<FSET? ,GRATE ,OPENBIT>
		      <TELL "is raised, revealing">)
		     (T
		      <TELL "is lowered, blocking">)>
		<TELL " some sort of passage." CR>
		<COND (<AND <IN? ,STAND ,DEN>
			    <FSET? ,STAND ,NDESCBIT>>
		       <CRLF>
		       <COND (<AND <FSET? ,LION-CAGE ,RMUNGBIT>
				   <NOT <FSET? ,CASE ,TOUCHBIT>>>
			      <TELL 
"The " D ,STAND " is" ,LION-STAND-MOVED>)
			    (T
			     <TELL "A " D ,STAND " sits here.">)>
			<CRLF>)>)
	       (<EQUAL? .RARG ,M-ENTER>
		<COND (<IN? ,ELSIE ,RING>
	               <TELL 
"The big cats suddenly spring out of their slumber, and begin moving stealthily
around the den">
		       <COND (<NOT <FSET? ,MEAT ,RMUNGBIT>>
			      <TELL ", as if in preparation for a feeding">)>
		       <TELL ,PERIOD CR>
		       <MOVE-LIONS ,DEN>
		       <ENABLE <QUEUE I-LION 2>>)>
		<COND (<AND <IN? ,STAND ,RING>
			    <FSET? ,STAND ,NDESCBIT>>
		       <FCLEAR ,STAND ,NDESCBIT>
		       <FSET ,STAND ,VEHBIT>
		       <MOVE ,STAND ,DEN>)>)>>

<ROUTINE GRATE-ENTER ()
	 <COND (<NOT <FSET? ,GRATE ,OPENBIT>>
		<TELL 
"The " D ,GRATE " is lowered over the passage." CR>
		<RFALSE>)
	       (<AND <IN? ,NIMROD ,HERE>
		     <NOT <FSET? ,GRATE ,OPENBIT>>>
		<PERFORM ,V?OPEN ,GRATE>
		<RFALSE>)
	       (T
		<V-DIG>
		<RFALSE>)>>

<ROUTINE I-LION ("AUX" (ELSIE-STOP <>))
	 <COND (<IN? ,ELSIE ,CHUTE>
		<SETG ELSIE-COUNTER <+ ,ELSIE-COUNTER 1>>
		<COND (<G? ,ELSIE-COUNTER 7>
		       <MOVE ,MEAT ,LOCAL-GLOBALS>
		       <DISABLE <INT I-LION>>
		       <COND (<FSET? ,GRATE ,OPENBIT>
			      <SETG ELSIE-COUNTER 0>
			      <COND (<EQUAL? ,HERE ,DEN>
				     <MOVE-LIONS ,DEN>)
				    (T
				     <MOVE-LIONS ,RING>)>
			      <COND (<EQUAL? ,HERE ,BESIDE-BIGTOP ,DEN>
				     <TELL CR 
"The lions slink back into their den." CR>)>
			      <COND (<EQUAL? ,HERE ,DEN>
				     <ENABLE <QUEUE I-LION -1>>)>)>)>
		<RFALSE>)
	       (<AND <NOT <EQUAL? ,HERE ,DEN>> ;"meat in chute open"
		     <IN? ,MEAT ,CHUTE>>
		<MOVE-LIONS ,CHUTE>
	 	<ENABLE <QUEUE I-LION -1>>
		<COND (<EQUAL? ,HERE ,BESIDE-BIGTOP>
		       ;<ENABLE <QUEUE I-LION -1>>
		       <TELL CR 
"You see the pair of hungry cats slink into the chute from the " D ,BIGTOP "
and pounce on the " D ,MEAT "." CR>)>)	       
	       (T
		<COND (<EQUAL? ,HERE ,DEN>
		       <ENABLE <QUEUE I-LION -1>>
	 	       <CRLF>
		       <COND (<IN? ,MEAT ,DEN>
			      <COND (<ZERO? ,ELSIE-COUNTER>
				     <TELL ;CR 
"The lions continue mauling their">)
				    (T
				     <TELL 
"The " D ,NIMROD " keeps mauling his">)>
		       	     <TELL " dinner and watching you." CR>
			     <RTRUE>)  
			     (<EQUAL? ,ELSIE-COUNTER 0>		   
			      <TELL "Both lions continue">)
			     (T
			      <TELL "The " D ,NIMROD " keeps">
			      <SET ELSIE-STOP T>)>
		       <TELL 
" pacing nervously back and forth around the den, never letting you out of ">
		       <COND (.ELSIE-STOP
			      <TELL "its">)
			     (T
			      <TELL "their">)>
		       <TELL " sight.">
		       <COND (<AND .ELSIE-STOP
				   <VERB? LOOK>>
			      <TELL " The " D ,ELSIE " remains bogged down ">
			      <COND (<L? ,ELSIE-COUNTER 3>
				     <TELL "in front of the grate">)
				    (T
				     <TELL 
"off to one side of the " D ,LION-CAGE>)>		
			      <TELL ".">)>
		       <CRLF>)>)>> 

<OBJECT LION-CAGE 
	(IN LOCAL-GLOBALS)
	(DESC "lions' den")
	(SYNONYM DEN CAGE BAR BARS)
	(ADJECTIVE LIONS LION\'S ROUND LION)
	(FLAGS NDESCBIT)
	(GENERIC GEN-BAR)
	(ACTION LION-CAGE-F)>

;"RMUNGBIT = can see that lion stand has been moved"

<ROUTINE LION-CAGE-F ()
	 <COND (<VERB? UNLOCK LOCK OPEN CLOSE>
		<PERFORM ,PRSA ,LION-DOOR ,PRSI>
		<RTRUE>)
	       (<VERB? LOOK-INSIDE>
		<COND (<EQUAL? ,HERE ,DEN>
		       <V-LOOK>
		       <RTRUE>)
		      (T
		       <COND (<IN? ,ELSIE ,RING>
			      <TELL ,YOU-SEE  
" a pair of sleepyheaded lions resting on their haunches in the sawdust.">)
			     (T
			      <TELL
"The " D ,LION-CAGE " is still, and void of life.">)>
		       <COND (<FSET? ,STAND ,NDESCBIT>
			      <TELL 
" There is an enclosed " D ,STAND " in the " D ,LION-CAGE>
			      <COND (<NOT <FSET? ,MIDWEST ,TOUCHBIT>>
				     <FSET ,LION-CAGE ,RMUNGBIT>
				     <FCLEAR ,DEN ,TOUCHBIT>)>
			      <COND (<AND <FSET? ,MIDWEST ,TOUCHBIT>
				          <FSET? ,LION-CAGE ,RMUNGBIT>
					  <NOT <IN? ,ELSIE ,CHUTE>>>
				     <TELL "," ,LION-STAND-MOVED>)
				    (T
				     <TELL ".">)>)>
		      <CRLF>)>)
	      (<AND <VERB? PUT>
		    <PRSI? ,LION-CAGE>
		    <NOT <IDROP>>>
		<COND (<EQUAL? ,HERE ,DEN>
		       <PERFORM ,V?DROP ,PRSO>
		       <RTRUE>)
		      (<AND <PRSO? ,MEAT>
			    <FSET? ,LION-DOOR ,OPENBIT>>
		       <TELL 
"This isn't feeding pigeons in the park here." CR>)
		      (<OR <EQUAL? ,PRSO ,MEAT>
			   <AND <G? <GETP ,PRSO ,P?SIZE> 25>
			        <NOT <EQUAL? ,PRSO ,POLE>>>>
		       <SETG PRSI ,CAGE>
		       <TELL-CLOSELY-SPACED>
		       <SETG PRSI ,LION-CAGE>)		      
		      (T		       
		       <V-DIG>)>)
	      (<VERB? REACH-IN>
	       <COND (<EQUAL? ,HERE ,DEN>
		      <TELL ,LOOK-AROUND CR>)
		     (<IN? ,NIMROD ,HERE>
		      <TELL "Very unwise." CR>)
		     (T
		      <TELL-WITHIN-REACH>)>)
	      (<VERB? CLIMB-ON CLIMB-FOO CLIMB-UP>
	       <PERFORM ,V?CLIMB-UP ,CAGE>
	       <RTRUE>)
	      (<VERB? BOARD ENTER THROUGH>
	       <COND (<EQUAL? ,HERE ,RING>
		      <DO-WALK ,P?WEST>)
		     (T
		      <TELL ,LOOK-AROUND>)>)
	      (<VERB? LEAVE EXIT DISEMBARK>
	       <COND (<EQUAL? ,HERE ,DEN>
		      <DO-WALK ,P?EAST>)
		     (T
		      <TELL ,LOOK-AROUND>)>)>>

<ROUTINE MOVE-LIONS (PLACE)
	 <MOVE ,ELSIE .PLACE>
	 <MOVE ,NIMROD .PLACE>
	 <MOVE ,LION-NAME .PLACE>
	 <COND (<EQUAL? .PLACE ,DUMMY-OBJECT ,CHUTE>
	        <RFALSE>)
	       (<EQUAL? .PLACE ,RING>
		<FSET ,STAND ,NDESCBIT>
		<FCLEAR ,STAND ,VEHBIT>)
	       (<EQUAL? .PLACE ,DEN>
		<FSET ,STAND ,VEHBIT>)>
	 <MOVE ,STAND .PLACE>>

<OBJECT STAND 
	(IN RING)
	(DESC "lion stand")
	(SYNONYM STAND PEDESTAL)
	(ADJECTIVE ENCLOSED LION ;RED)
	(FLAGS ;VEHBIT TAKEBIT SURFACEBIT CONTBIT OPENBIT SEARCHBIT NDESCBIT
	       RMUNGBIT)
	(SIZE 90)
	(CAPACITY 50)
	(ACTION STAND-F)>

;"NDESCBIT = stand is IN RING but is described as in den
	     On den-f m-enter, if ndescbit is set it's moved
	     to DEN"

<ROUTINE STAND-F ("OPTIONAL" (RARG <>))
	 <COND (<AND <EQUAL? .RARG ,M-BEG>
		     <VERB? WALK>
		     <NOT <EQUAL? ,P-WALK-DIR ,P?UP ;,P?DOWN>>>
		<COND (<EQUAL? ,P-WALK-DIR ,P?DOWN>
		       <PERFORM ,V?DISEMBARK ,STAND>
		       <RTRUE>)
		      (T
		       <OUT-OF-FIRST ,STAND>)>)
	       (.RARG
	        <RFALSE>)
	       (<VERB? OPEN CLOSE>
		<CANT-OPEN>)
	       (<VERB? EXAMINE>
		<TELL 
"The " D ,STAND " is a red three-foot-high, cylindrical pedestal. ">
		<COND (<FIRST? ,STAND>
		       <PERFORM ,V?LOOK-ON ,STAND>
		       <RTRUE>)>
		<CRLF>
		<RTRUE>)
	       (<VERB? LOOK-ON>
		<COND (<FIRST? ,STAND>
		       <TELL "There's">
		       <PRINT-CONTENTS ,STAND>)
		      (T
		       <TELL " nothing">)>
		<TELL " on the stand." CR>) 
	       (<AND <EQUAL? ,HERE ,RING>
		     <FSET? ,STAND ,NDESCBIT>
		     <TOUCHING? ,STAND>>
	        <CANT-REACH ,STAND>)
	       (<VERB? CLIMB-FOO>
		<PERFORM ,V?BOARD ,STAND>
		<RTRUE>)
	       (<AND <IN? ,NIMROD ,HERE>
		     <OR <VERB? BOARD>
		         <VERB? PUT PUT-ON>>>
		<PERFORM ,V?RAISE ,STAND>
		<RTRUE>)
               (<AND <VERB? LOOK-UNDER RAISE TAKE MOVE SEARCH LOOK-INSIDE
			    PUSH>
	             <PRSO? ,STAND>
		     <IN? ,CASE ,LOCAL-GLOBALS>>
		<COND (<EQUAL? <LOC ,PROTAGONIST> ,STAND>
		       <OUT-OF-FIRST ,STAND>)
		      (<IN? ,NIMROD ,HERE>
                       <TELL
"Jealous of your attempt to assume its throne, the shaggy king of beasts
repels you with a volcanic roar." CR>)  
		      (<AND <IN? ,NIMROD ,CHUTE>
			    <FSET? ,GRATE ,OPENBIT>>	
		       <BLIND-SIDE>)
		      (T			   
		       <FSET ,CASE ,TOUCHBIT>
		       <MOVE ,CASE ,PROTAGONIST>
		       <SETG SCORE <+ ,SCORE 10>>
		       <TELL 
"You tilt up the " D ,STAND " and see a " D ,CASE ", which you pick
up." CR>)>)
		 (<AND <VERB? PUT>
		       <PRSI? ,STAND>>
	          <V-DIG>)
		 (<VERB? LOOK-INSIDE>
	          <TELL ,EMPTY ,PERIOD>
		  <RTRUE>)>>

<ROUTINE WHIP-HOLD ()
	 <COND (<NOT <IN? ,WHIP ,PROTAGONIST>>
		<TELL ,NOT-HOLDING " a whip." CR>
		<RTRUE>)>>

<ROUTINE LION-NOT-HERE? (THING)
	 <COND (<AND <NOT <IN? ,NIMROD ,DEN>>
		     <TOUCHING? .THING>>
		<CANT-REACH .THING>
		<RTRUE>)>>

<OBJECT NIMROD
	(IN RING)
	(DESC "shaggy lion")
	(SYNONYM LION CAT MANE ANIMAL) 
	(ADJECTIVE BIG SHAGGY BLOND)	
	(FLAGS ACTORBIT NDESCBIT)
	(ACTION NIMROD-F)
	(SIZE 100)>

<ROUTINE NIMROD-F ()
	 <COND (<AND <NOT <EQUAL? ,PRSA ,V?GIVE ,V?SHOW>>
		     <LION-NOT-HERE? ,NIMROD>>
		<RTRUE>)
	       (<TALKING-TO? ,NIMROD>
		<TALK-TO-LION>
		<STOP>)
	       (<VERB? SEARCH RUB PUSH>
		<TELL 
"As " D ,HANDS " approaches, the lion backs you away with a head-bobbing
roar." CR>)
	       (<VERB? EXAMINE>
		<COND (<OR <IN? ,MEAT ,DEN>
			   <EQUAL? ,HERE ,RING>
			   <AND <IN? ,NIMROD ,CHUTE>
				<L? ,ELSIE-COUNTER 7>>>
		       <TELL 
"The lion appears savage and blond, like a Cosmo cover." CR>)
		      (T
	       	       <TELL 
"The lion wags its salivating tongue in stride, at times giving off a
deep-throated purr." CR>)>)
	       (<AND <VERB? THROW>
		     <PRSI? ,NIMROD>
		     <EQUAL? ,HERE ,RING>>
		<PERFORM ,V?PUT ,PRSO ,LION-CAGE>
		<RTRUE>)
	       (<AND <VERB? GIVE SHOW>
		     <HELD? ,PRSO>>
		<COND (<EQUAL? ,HERE ,RING>
		       <PERFORM ,V?PUT ,PRSO ,LION-CAGE>
		       <RTRUE>)
		      (<PRSO? ,MEAT>
		       <FEED-LION T>
		       <RTRUE>)
		      (<PRSO? ,WATER>
		       <NOT-INTERESTED>)
		      (<PRSO? ,MOUSE>
		       <RFALSE>)
		      (T
		       <MOVE ,PRSO ,HERE>
		       <TELL "As">
		       <ARTICLE ,PRSO T>
		       <TELL 
" falls to the sawdust, the shaggy beast lets out a gaping yawn. With your
open view of its choppers, this is only a little less intimidating than a
roar." CR>)>)
	       (<AND <VERB? WHIP>
		     <PRSI? ,WHIP>>
		<COND (<WHIP-HOLD>
		       <RTRUE>)
		      (T
		       <TELL
"Following the whip's backlash, the " D ,NIMROD>
		       <JIGS-UP 5 
" makes a powerful leap toward you, its full weight bowling you over.">
		       <RTRUE>)>)>>

<ROUTINE FEED-LION ("OPTIONAL" (TO-NIMROD? <>))
	 <MOVE ,MEAT ,DEN>
	 <FSET ,MEAT ,NDESCBIT>
	 <FSET ,MEAT ,RMUNGBIT>
	 <SETG ELSIE-COUNTER 0>
	 <TELL "The ">
	 <COND (.TO-NIMROD?
		<TELL D ,NIMROD>)
	       (T
		<TELL D ,ELSIE>)>
	 <ENABLE <QUEUE I-LION 2>>
	 <TELL 
" jaunts over to the meat and pounces on it, and now the other beast joins in
on the feast, each lion occasionally peering up at you." CR>> 
	 
<ROUTINE TALK-TO-LION ()
	 <TELL "The big cat pays you no heed." CR>>

<OBJECT ELSIE
	(IN RING)
	(DESC "smooth-bodied lion")
	(SYNONYM LION CAT ANIMAL)
	(ADJECTIVE BIG SMOOTH)
	(FLAGS ACTORBIT NDESCBIT FEMALE)
	(ACTION ELSIE-F)
	(SIZE 100)>
 
<ROUTINE ELSIE-F ()
	 <COND (<AND <NOT <VERB? GIVE SHOW>>
		     <LION-NOT-HERE? ,ELSIE>>
		<RTRUE>)
	       (<TALKING-TO? ,ELSIE>
		<TALK-TO-LION>
		<STOP>)
	       (<VERB? RUB SEARCH PUSH>
		<TELL 
"An ominous, deep-sounding purr from the " D ,ELSIE " keeps you away." CR>) 
	       (<VERB? EXAMINE>
		<COND (<OR <AND <NOT <ZERO? ,ELSIE-COUNTER>>
			        <EQUAL? ,HERE ,DEN>>
			   <EQUAL? ,HERE ,RING>>
		       <TELL 
"The big cat is stretched out lazily over the sawdust." CR>)
		      (<AND <NOT <IN? ,MEAT ,DEN>>
			    <NOT <EQUAL? ,HERE ,RING>>
			    <OR <IN? ,ELSIE ,CHUTE>
			        <EQUAL? ,ELSIE-COUNTER 0>>>
	       	       <TELL 
"With each stride the cat's muscle-laden shoulder bones pivot up and
down in tandem." CR>)>)
	       (<AND <VERB? THROW>
		     <PRSI? ,ELSIE>
		     <EQUAL? ,HERE ,RING>>
		<PERFORM ,V?PUT ,PRSO ,LION-CAGE>
		<RTRUE>)
	       (<AND <VERB? GIVE SHOW>
		     <HELD? ,PRSO>>
		<COND (<EQUAL? ,HERE ,RING>
		       <PERFORM ,V?PUT ,PRSO ,LION-CAGE>
		       <RTRUE>)
		      (<PRSO? ,MOUSE>
		       <RFALSE>)
		      (<PRSO? ,MEAT>
		       <FEED-LION>)
		      (T
		       <NOT-INTERESTED>)>)
	       (<AND <VERB? WHIP>
		     <PRSI? ,WHIP>>
		<COND (<WHIP-HOLD>
		       <RTRUE>)
		      (T
		       <SETG ELSIE-COUNTER <+ ,ELSIE-COUNTER 1>>
		       <COND (<EQUAL? ,ELSIE-COUNTER 1>
			      <TELL 
"As the whip cracks just inches above the " D ,ELSIE "'s hide, the puzzled
animal scratches to a halt in front of the grate. Leaning back on its haunches,
the lion flexes its forepaws." CR>)
			     (<EQUAL? ,ELSIE-COUNTER 2>
			      <TELL 
"\"Snap!\" The lion performs an obedient roll-over, flecking its hide with
sawdust." CR>)
                             (<EQUAL? ,ELSIE-COUNTER 3>
			      <TELL
"The " D ,ELSIE " cowers, does a couple of nervous pirouettes, then jaunts
off to the side of the " D ,LION-CAGE " where it hunkers down and lets out
a huge yawn." CR>)
			     (T
			      <BLIND-SIDE>)>)>)>>

<ROUTINE BLIND-SIDE ()
	 <JIGS-UP 2 
"You are suddenly blindsided in a lightning attack lead by claws which sink
deep into your jugular.">
	 <RTRUE>>

<GLOBAL ELSIE-COUNTER 0>

<OBJECT LION-NAME
        (IN RING)
	(DESC "lion")
	(SYNONYM ELSIE NIMROD LIONS CATS)
	(ADJECTIVE CAT BIG)
	(FLAGS NDESCBIT)
	(ACTION LION-NAME-F)>

;"rmungbit = guard told me about lion-name, showing face"

<ROUTINE LION-NAME-F ()
         <COND (<DONT-HANDLE? ,LION-NAME>
		<RFALSE>)
	       (T
		<COND (<VERB? EXAMINE>
		       <TELL 
"You glance at each lion and realize that, b">)			       
	              (T
		       <TELL "B">)>
		<TELL  
"ecause you were outside the " D ,BIGTOP " stuck waiting in line when the
lions were introduced, you're not certain who is who. You'll have to refer
to each as the " D ,NIMROD " or the " D ,ELSIE "." CR>
		<STOP>)>>

<OBJECT MEAT
	(IN BUCKET)
	(DESC "corpuscular lump of meat")
	(SYNONYM LUMP MEAT FOOD)
	(ADJECTIVE CORPUSCULAR)
	(FLAGS TAKEBIT EATBIT)
	(GENERIC GEN-FOOD)
	(ACTION MEAT-F)> 

;"RMUNGBIT = eaten by lions"

<ROUTINE MEAT-F ()
	 <COND (<AND <VERB? TAKE MOVE>
		     <IN? ,MEAT ,DEN>>
		<TELL "You'd">
		<TELL-WITHDRAW-STUMP T>)
	       (<VERB? EAT>
		<TELL 
"Just looking at the " D ,MEAT " makes you lose your appetite, if not
your lunch." CR>)
	       (<AND <VERB? DROP THROW>			 
		     <PRSO? ,MEAT>
		     <EQUAL? ,HERE ,DEN>
		     <IN? ,NIMROD ,HERE>>
		<COND (,PRSI
		       <TELL ,BAD-AIM ". ">)>
		<FEED-LION T>
		<RTRUE>)>>

<OBJECT BUCKET
	(IN ROUST-ROOM)
	(DESC "bucket")
	(SYNONYM BUCKET PAIL)
	(ADJECTIVE STEEL ;GALVANIZ)
	(FLAGS TAKEBIT CONTBIT OPENBIT SEARCHBIT)
	(SIZE 30)	
	(CAPACITY 25)
	(ACTION BUCKET-F)>

<ROUTINE BUCKET-F ("AUX" (FULL? <>)) ;"ie, full of water"
	 <SETG P-IT-OBJECT ,BUCKET>
	 <SET FULL? <IN? ,WATER ,BUCKET>>
	 <COND (<AND <VERB? TAKE-WITH>
		     <PRSO? ,GLOBAL-WATER ,WATER>>
		<PERFORM ,V?FILL ,BUCKET ,GLOBAL-WATER>
		<RTRUE>)
	       (<VERB? OPEN CLOSE>
		<V-COUNT>)
	       (<AND .FULL?
		     <VERB? THROW>>		
		<PERFORM ,V?DROP ,WATER>
		<MOVE ,BUCKET ,HERE>
		<RTRUE>)
	       (<VERB? STAND-ON>
		<TELL "It wouldn't be a very elevating experience." CR>)
	       (<VERB? EXAMINE>
	       	<TELL "It's made of galvanized steel and ">
		<COND (<FIRST? ,BUCKET>
		       <TELL "contains">
		       <PRINT-CONTENTS ,BUCKET>)
		      (T
		       <TELL "there's nothing in it">)>
		<TELL ,PERIOD>)
	       (<VERB? LOOK-INSIDE SEARCH EXAMINE>
		<TELL "The bucket ">
		<COND (<NOT <FIRST? ,BUCKET>>
		       <TELL "is empty">)
		      (T
		       <TELL "contains">
		       <COND (.FULL?
		       	      <TELL " a limpid pool of " D ,WATER>)
		      	     (T
		       	      <PRINT-CONTENTS ,BUCKET>)>)>
		<TELL ,PERIOD>
		<RTRUE>)
	       (<VERB? DRINK DRINK-FROM>
		<COND (.FULL?
		       <PERFORM ,V?DRINK ,WATER>)
		      (T
		       <EMPTY-BUCKET>)>
		<RTRUE>)
	       (<VERB? POUR EMPTY>
		<COND (.FULL?
		       <PERFORM ,V?POUR ,WATER>)
		      (T
		       <EMPTY-BUCKET>)>
		<RTRUE>)
	       (<AND <VERB? PUT>
		     <EQUAL? ,PRSI ,BUCKET>
		     <NOT <PRSO? ,WATER>>		     
		     .FULL?>
		<TELL "But">
		<ARTICLE ,PRSO T>
	        <TELL " would get all wet." CR>
		<RTRUE>)
	       (<AND <VERB? PUT>
		     <PRSI? ,BUCKET>
		     <G? <- <+ <WEIGHT ,PRSI> <GETP ,PRSO ,P?SIZE>>
		               <GETP ,PRSI ,P?SIZE>>
		         <GETP ,PRSI ,P?CAPACITY>>>	
		<RFALSE>)
	       (<AND <VERB? PUT>		     
		     <OR <AND <PRSO? ,CHEESE>
		              <IN? ,MOUSE ,BUCKET>>
		         <AND <PRSO? ,MOUSE>
		              <IN? ,CHEESE ,BUCKET>>>>
		<MOVE ,MOUSE ,BUCKET>
		<TELL "Done. ">
		<FEED-MOUSE>
		<RTRUE>)>>

;"of non-water objects"
<ROUTINE EMPTY-BUCKET ("AUX" OBJ)
	 <COND (<SET OBJ <FIRST? ,BUCKET>>
		<COND (<VERB? DRINK-FROM>
		       <PERFORM ,V?DRINK .OBJ>
		       <RTRUE>)
		      (T                   ;"verbs empty, pour"
		       <COND (<NEXT? .OBJ>
			      <TELL "The contents of the " D ,BUCKET " fall">)
			     (T
			      <TELL "Okay,">
			      <ARTICLE .OBJ T>
			      <TELL " falls">)>		       
		       <TELL " out of it." CR>
		       <COND (<AND <EQUAL? ,HERE ,DEN>
			      	   <IN? ,NIMROD ,HERE>
				   <IN? ,MEAT ,BUCKET>>
			      <PERFORM ,V?GIVE ,MEAT ,NIMROD>)
			     (<IN? ,MOUSE ,BUCKET>
			      <MOVE ,MOUSE ,LOCAL-GLOBALS>
			      <SCAMPER>)>
		       <ROB ,BUCKET ,HERE>
		       <RTRUE>)>)
	       (T
		<TELL ,EMPTY ,PERIOD>)>>

<ROUTINE NOT-HOLDING-WATER? ()
	 <COND (<NOT <IN? ,WATER ,BUCKET>>
		<TELL "You're not carrying any water." CR>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<OBJECT WATER
	(IN LOCAL-GLOBALS)
	(DESC "water")
	(SYNONYM WATER ;LIQUID DRINK)
	;(ADJECTIVE COOL)
	(FLAGS TAKEBIT NARTICLEBIT)
	(ACTION WATER-F)>

<ROUTINE WATER-F ()
	 <COND (<VERB? DRINK DRINK-FROM TASTE>
		<COND (<NOT-HOLDING-WATER?>
		       <RTRUE>)
		      (T
		       <TELL "You take a sip of the cool water." CR>)>)	       
	       (<AND <VERB? THROW DROP EMPTY TAKE PUT-ON PUT POUR>
		     <PRSO? ,WATER>>
		<COND (<NOT-HOLDING-WATER?>
		       <RTRUE>)
		      (T
		       <MOVE ,WATER ,LOCAL-GLOBALS>
		       <COND (<AND ,PRSI			           
				   <NOT <EQUAL? ,PRSI ,TAFT>>
			       	   <FSET? ,PRSI ,ACTORBIT>>
			      <COND (<EQUAL? ,PRSI ,FAT>
			      	     <TELL "Tina stays mostly dry." CR>
				     <RTRUE>)>				    
			      <COND (<NOT <AND ,PRSI
				               ,END-GAME
				               <PRSI? ,APE>>>
				     <TELL "Deftly,">
			      	     <ARTICLE ,PRSI T>
			      	     <TELL " sidesteps your splashing. ">)>)>
		       <TELL 
"The " D ,WATER " explodes into a zillion sparkling droplets that immediately
evaporate">		       
		       <TELL ,PERIOD>)>)
	       (<AND <VERB? PUT PUT-ON>
		     <PRSI? ,WATER>
		     <IN? ,WATER ,BUCKET>>
		<PERFORM ,V?PUT ,PRSO ,BUCKET>
		<RTRUE>)
	       (<AND <VERB? FEED GIVE>
		     <EQUAL? ,PRSO ,WATER>
		     <FSET? ,PRSI ,ACTORBIT>>
		<PERFORM ,V?POUR ,WATER>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<OBJECT WHIP
	(IN BAGGAGE-COMPARTMENT)
	(DESC "rawhide bullwhip")
	(SYNONYM BULLWHIP WHIP)
	(ADJECTIVE RAWHIDE BULL)
	(FLAGS TAKEBIT)
	(SIZE 10)
	(ACTION WHIP-F)>

<ROUTINE WHIP-F ()
	 <COND (<AND <VERB? WHIP>
		     <PRSI? ,WHIP>>
		<COND (<PRSO? ,WHIP>
		       <V-COUNT>)
		      (<PRSO? ,GROUND>
		       <V-DIG>)>)>>

<OBJECT LION-DOOR
	(IN LOCAL-GLOBALS)
	(DESC "cage door")
	(SYNONYM DOOR GATE LOCK)
	(ADJECTIVE ;ROUND CAGE)
	(FLAGS DOORBIT NDESCBIT LOCKEDBIT CAGEBIT)
	(ACTION LION-DOOR-F)>

<ROUTINE LION-DOOR-F ()
	 <COND (<AND <VERB? PUT>
		     <FSET? ,LION-DOOR ,OPENBIT>
		     <PRSO? ,MEAT>>
		<PERFORM ,V?PUT ,MEAT ,LION-CAGE>
		<RTRUE>)>>