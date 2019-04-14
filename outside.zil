"OUTSIDE for
		               BALLYHOO
	(c) Copyright 1984 Infocom, Inc.  All Rights Reserved." 
	
 <ROOM CON-AREA  
	(IN ROOMS)
	(DESC "Connection")	
	(NORTH TO WINGS)
	(SOUTH TO NEAR-WAGON)
	(WEST TO BESIDE-BIGTOP)
	(EAST PER TURNSTILE-EXIT)
	(SW TO BACK-YARD)
	(IN TO WINGS)
	(FLAGS ONBIT RLANDBIT)
	(GLOBAL BIGTOP BANNER TURNSTILE MIDWAY SLOT)
	(ACTION CON-AREA-F)>

<ROUTINE CON-AREA-F (RARG)
	 <COND (<EQUAL? .RARG ,M-LOOK>	
	   	<TELL
"This area of matted-down crabgrass lies between the vaulted " D ,BIGTOP
" entrance to the north and the enticements of the midway to the east, where
a " D ,BANNER " hangs crookedly above a " D ,TURNSTILE ". There is a " 
D ,FOUNTAIN " near the side wall of the tent. ">
	        <COND (<NOT ,DREAMING>
		       <TELL 
"You can enter the night to the west and south.">)
		      (T
		       <TELL CR CR 
"Stretching away from a small concession stand ">
		       <COND (<IN? ,SHORT ,HERE>
			      <TELL "are a " D ,SHORT " and">)
			     (T
			      <TELL "is">)>
		       <TELL " a " D ,LONG " of suckers.">)>
		<CRLF>)			      
	       (<EQUAL? .RARG ,M-ENTER>		
		<COND (<AND <EQUAL? ,P-WALK-DIR ,P?SOUTH ,P?OUT>
		            <NOT ,DREAMING>>
		       <TELL 
"You emerge into the warm night air of summer." CR CR>
	   	       <COND (<NOT <FSET? ,CON-AREA ,TOUCHBIT>>
	               	      <MOVE ,CROWD ,CON-AREA>
			      <ENABLE <QUEUE I-BOOST -1>>)>)>
		<COND (<AND <QUEUE-THUMB?>
			    <NOT ,DREAMING>>
		       <ENABLE <QUEUE I-THUMB 1>>)>)
	       (<AND ,DREAMING
		     <EQUAL? .RARG ,M-BEG>
		     <VERB? WALK>
		     <NOT <EQUAL? ,P-WALK-DIR ,P?NORTH>>>
		<COND (<HELD? ,MONKEY>
		       <MONKEY-DIRECTION>)
		      (T
		       <TELL "That's not the way you remember it." CR>)>
		<RTRUE>)
	       (<EQUAL? .RARG ,M-BEG>
		<FSET ,LONG ,VEHBIT>
		<FSET ,SHORT ,VEHBIT>
		<COND (<AND <NOT <FSET? ,LONG ,RMUNGBIT>> ;"won lines?"
		       	    <VERB? BOARD>
		       	    <PRSO? ,LONG>
		            <G? ,LINE-COUNTER 3>>
		       <ENTER-LINE T>)
		      (T
		       <RFALSE>)>)
	       (<AND <EQUAL? .RARG ,M-END>
		     <MONKEY-ACTS?>>		     
		<RFALSE>)>>

<ROUTINE MONKEY-ACTS? ()
	 <COND (<AND <IN? ,MONKEY ,PROTAGONIST>
		     <PROB 60>>
		<TELL CR 
"The " D ,MONKEY " on " D ,BACK " " <PICK-ONE ,MONKEYS>>
		<TELL ,PERIOD>)
	       (T
		<RFALSE>)>>

<GLOBAL MONKEYS 
	<LTABLE 0 
	"nervously bounces its weight up and down"
	"idly grooms areas of your scalp"
	"vocalizes excitedly in your ear"
	"breathes its jungle breath down your neck">>

<OBJECT BANNER
	(IN LOCAL-GLOBALS)
	(DESC "sagging banner")
	(SYNONYM BANNER)
	(ADJECTIVE SAGGING)
	(FLAGS NDESCBIT)
	(ACTION BANNER-F)>

<ROUTINE BANNER-F ()
	 <COND (<VERB? READ EXAMINE>
		<CRLF>
		<COND (<EQUAL? ,HERE ,CON-AREA>	
		       <TELL "\"TO SIDESHOWS">)
		      (<EQUAL? ,HERE ,MIDWEST>
		       <TELL "\"TO MENAGERIE">)
		      (T
		       <TELL "\"THIS WAY TO THE EGRESS">)>
		<TELL "\"" CR>)
	       (<TOUCHING? ,BANNER>
		<CANT-REACH ,BANNER>)>>

<OBJECT LONG
	(IN LOCAL-GLOBALS)
	(DESC "long line")
	(SYNONYM LINE PEOPLE SUCKER FRONT)
	(ADJECTIVE LONG LONGER CONCES PEOPLE)
	(FLAGS VEHBIT NDESCBIT)
	(GENERIC GEN-LINE-F)
	(ACTION LONG-F)>

;"RMUNGBIT = have won and got nuts, now no lines move at all"

<ROUTINE LONG-F ("OPTIONAL" (RARG <>))
	 <COND (<EQUAL? .RARG ,M-ENTER>       	       
	        <COND (<NOT <FSET? ,LONG ,TOUCHBIT>>
	               <FSET ,LONG ,TOUCHBIT>
               	       <ENABLE <QUEUE I-BAD-LUCK 5>>
	               <RFALSE>)>)
	       (<EQUAL? .RARG ,M-BEG>
	        <COND (<GET-OUT-OF-LINE? ,LONG>
		       <RTRUE>)
		      (<VERB? WALK>
		       <OUT-OF-FIRST ,LONG>)
		      (<AND <IN? ,SHORT ,CON-AREA>
		            <NOT <IN? ,TEAM ,CON-AREA>>
			    <VERB? WAIT>>
	               <TELL 
"Time itself, let alone the " D ,LONG ", has " D ,GROUND " to an agonizing
halt." CR>
	        <SETG CLOCK-WAIT T>
	        <RTRUE>)>)
	       (.RARG
		<RFALSE>)
	       (T
		<LINES-F>)>>

<OBJECT SHORT
        (IN LOCAL-GLOBALS)
	(DESC "short line")
	(SYNONYM LINE PEOPLE SUCKER FRONT)
	(ADJECTIVE SHORTER SHORT CONCES PEOPLE)
	(FLAGS ;VEHBIT NDESCBIT) 
	(GENERIC GEN-LINE-F)
	(ACTION SHORT-F)>

;"RMUNGBIT = used in gen-line-f for GET OUT OF LINE"

<ROUTINE SHORT-F ("OPTIONAL" (RARG <>))
	 <COND (<EQUAL? .RARG ,M-BEG>
       	        <COND (<GET-OUT-OF-LINE? ,SHORT>
		       <RTRUE>)
		      (<VERB? WALK>
		       <OUT-OF-FIRST ,SHORT>)>)
	       (.RARG
		<RFALSE>)
	       (T
		<LINES-F>)>>
		
<ROUTINE LINES-F ()
	 <COND (<AND <EQUAL? ,HERE ,CON-AREA>
		     <OR <AND <VERB? BOARD THROUGH WALK-TO>
		         ,IN-FRONT-FLAG>
		         <EQUAL? ,P-PRSA-WORD ,W?CUT>
		         <AND <VERB? BOARD THROUGH WALK-TO>
			      <IS-NOUN? ,W?FRONT>>>>
		<COND (<EQUAL? <LOC ,PROTAGONIST> ,LONG ,SHORT>
		       <OUT-OF-FIRST <LOC ,PROTAGONIST>>
		       <RTRUE>)
		      (T 
		       <PERFORM ,V?WALK-TO ,CON-STAND>
		       <RTRUE>)>)
	       (T
		<RFALSE>)>>

<ROUTINE GET-OUT-OF-LINE? (LINE)
	 <COND (<AND <VERB? DISEMBARK>
	             <EQUAL? ,P-PRSA-WORD ,W?GET>
		     <IS-NOUN? ,W?LINE>
		     <ZERO? <GET ,P-ADJW 0>>
		     <NOT <FSET? ,SHORT ,RMUNGBIT>>>
	        <FSET ,SHORT ,RMUNGBIT>
	        <TELL 
"You begin ranting and raving and throwing a tantrum and all of those things
attendant upon someone getting way out of line. You feel better, but it
doesn't advance the " D .LINE "." CR>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE GEN-LINE-F ("AUX" LINE)
	 <COND (<AND <VERB? DISEMBARK EXIT>
		     <EQUAL? <LOC ,PROTAGONIST> ,LONG ,SHORT>>
		<LOC ,PROTAGONIST>)
	       (<EQUAL? ,P-NAM ,W?SUCKER> ;"only happens with two lines"
		,ME)                      ;"since me is global object"
	       (<NOT <EQUAL? ,HERE ,CON-AREA>>
		,LONG)
	       (<AND <VERB? DISEMBARK>
		     <NOT <EQUAL? <LOC ,PROTAGONIST> ,LONG ,SHORT>>>
		,LONG)
	       (T
		<RFALSE>)>>

;<OBJECT FRONT-OF-LINE
	(IN GLOBAL-OBJECTS)
	(DESC "line")
	(SYNONYM FRONT LINE BEGIN)
	(ADJECTIVE LONG LONGER SHORT SHORTER)
	(FLAGS NDESCBIT)
	(ACTION FRONT-OF-LINE-F)>

<GLOBAL LINE-COUNTER 0>

<ROUTINE I-BAD-LUCK ()	 
	 <COND (<EQUAL? <LOC ,PROTAGONIST> ,SHORT>
		<FCLEAR ,LONG ,VEHBIT>)
	       (<EQUAL? <LOC ,PROTAGONIST> ,LONG>
		<FCLEAR ,SHORT ,VEHBIT>)
	       ;(<IN? ,PROTAGONIST ,HERE> ;"in con-area m-beg"
		<FSET ,LONG ,VEHBIT>
		<FSET ,SHORT ,VEHBIT>)>
	 <COND (<ZERO? ,LINE-COUNTER>
                <MOVE ,SHORT ,CON-AREA>
		<SETG LINE-COUNTER 1>
		<ENABLE <QUEUE I-BAD-LUCK -1>>
		<TELL CR 
"Right next to the " D ,LONG " a much shorter line begins to form." CR>)
	       (<AND <EQUAL? ,LINE-COUNTER 1>   
		     <IN? ,PROTAGONIST ,SHORT>>
	        <SETG LINE-COUNTER 2>)
	       (<AND <EQUAL? ,LINE-COUNTER 2> 
		     <IN? ,PROTAGONIST ,SHORT>>
		<SETG LINE-COUNTER 3>
	        <MOVE ,TEAM ,CON-AREA>
		<MOVE ,JERRY ,CON-AREA>
		<TELL CR
"The face of the man ahead of you lights up as he spots something.
\"Hey, guys! It's ME, Jerry,\" he yells to a sizable group nearby, and
they approach." CR>)
	       (<AND <EQUAL? ,LINE-COUNTER 3>
		     <EQUAL? <LOC ,PROTAGONIST> ,SHORT>>
		<SETG LINE-COUNTER 4>	        
	        <FSET ,LONG ,VEHBIT>
	        <MOVE ,PROTAGONIST ,LONG>
		<FCLEAR ,SHORT ,VEHBIT>
		<PLAYER-NUM-CHECK>
		<TELL CR
"\"Haven't seen you turkeys in years. Howda hell are you guys?\" They
all reintroduce themselves. \"Hey -- you clowns thirsty? Get in here, I'll
buy y'all beer.\"|
|
\"You sure it's not a problem?\" asks the " <GET ,PLAYERS ,PLAYER-NUM> ".|
|
\"Heck no, just scoot in right here.\"|
|
With both your resolve and your heaving bosom firm against the crush of
interlopers, you are nevertheless forced to backpedal." CR>
	       <RTRUE>)
	      (<AND <EQUAL? ,LINE-COUNTER 4>
	       	    <IN? ,PROTAGONIST ,LONG>>
               <PLAYER-NUM-CHECK>
	       <TELL CR "Jerry continues " <PICK-ONE ,GREETINGS>
		        " the " <GET ,PLAYERS ,PLAYER-NUM> "." CR>
	       <COND (<AND <EQUAL? ,PLAYER-NUM 5>
			   <NOT <FSET? ,CON-STAND ,RMUNGBIT>>>
		      <FSET ,CON-STAND ,RMUNGBIT>
		      <TELL CR
"Out of the " D ,CORNER " of your eye, you see the line you first entered
suddenly kicking into gear and really begin moving." CR>)>
	       <RTRUE>)
	      (<AND <IN? ,PROTAGONIST ,HERE>
		    <EQUAL? ,LINE-COUNTER 4>> ;"entering short line aft Jerry"
	       <MOVE ,TEAM ,LOCAL-GLOBALS>	       
	       <MOVE ,JERRY ,LOCAL-GLOBALS>
	       <SETG LINE-COUNTER 5>
	       <RFALSE>)
	      (<AND <EQUAL? <LOC ,PROTAGONIST> ,LONG>
		    <EQUAL? ,LINE-COUNTER 5>>
	       <SETG LINE-COUNTER 6>
	       <TELL CR
"You notice the woman who had been next to you in the line you first
entered walk away from it with an overflowing tray of goodies." CR>)
	      (<AND <EQUAL? <LOC ,PROTAGONIST> ,LONG>
		    <EQUAL? ,LINE-COUNTER 6>>
	       <SETG LINE-COUNTER 7>
	       <TELL CR
"A baby's cry suddenly pierces the air like a siren." CR>)>>
		
<ROUTINE ENTER-LINE ("OPTIONAL" (WIN? <>))
	 <TELL 
"A lot of other people must ">
	 <COND (.WIN?
		<TELL "not ">)>
	 <TELL 
"have had the same idea as you, as they " <PICK-ONE ,LINE-MERGE> " over to ">
	 <COND (.WIN? 
		<DISABLE <INT I-BAD-LUCK>>
		<FSET ,LONG ,RMUNGBIT>   ;"idicates you've WON the lines"
	        <MOVE ,PROTAGONIST ,HERE>
		<MOVE ,BANANA ,PROTAGONIST>
		<SETG POCKET-CHANGE <- ,POCKET-CHANGE 375>>
		;<SETG POCKET-CHANGE 1281> ;"will = 1281 if bought bar too."
		<TELL 
"the " D ,SHORT ". Steaming to the front of the line, you get a " 
D ,BANANA " pushed at you and are whisked to the side before you can
even count your change.">)
	       (T
		<TELL 
"your chosen line, bunching in ahead of you and making it the longer of the
two.">)>
	 <CRLF>>

<OBJECT GRANOLA
	(IN LOCAL-GLOBALS)
	(DESC "one-dollar-and-85-cent granola bar")
	(SYNONYM GRANOLA BAR BARS FOOD)
	(ADJECTIVE CANDY ONE-DOLLAR GRANOLA)
	(FLAGS TAKEBIT EATBIT VOWELBIT)
	(GENERIC GEN-BAR)
	(ACTION GRANOLA-F)>

<GLOBAL ORDERED-GRANOLA <>>

<ROUTINE GRANOLA-F ()
	 <COND (<VERB? OPEN CLOSE>
		<TELL "There's no wrapper." CR>)
	       (<VERB? BUY>
		<COND (<AND <EQUAL? ,HERE ,STANDS-ROOM>
			    <IN? ,HAWKER ,HERE>
			    <EQUAL? ,POCKET-CHANGE 1841>>
		       <SETG ORDERED-GRANOLA T>)>
		<PERFORM ,V?BUY ,JUNK-FOOD>
		<RTRUE>)
	       (<VERB? EAT>
		<TELL 
"You abstain, since health foods tend to make you sick." CR>)>>

<ROUTINE GEN-BAR ()
	 ,GRANOLA>

<OBJECT BANANA
	(IN LOCAL-GLOBALS)
	(DESC "two-dollar-and-25-cent frozen banana")
	(SYNONYM BANANA FRUIT CHOCOLATE FOOD)
	(ADJECTIVE TWO-DOLLAR FROZEN)
	(FLAGS TAKEBIT EATBIT)
	(GENERIC GEN-FOOD)
	(ACTION BANANA-F)>

;"RMUNGBIT = banana is broken, monkey is interested"

<ROUTINE BANANA-F ()
	 <COND (<VERB? EXAMINE>
		<TELL "The " D ,BANANA " is ">
		<COND (<NOT <FSET? ,BANANA ,RMUNGBIT>>
		       <TELL "entirely ">)>
		<TELL "coated with chocolate." CR>)
	       (<AND <VERB? BUY>
		     <EQUAL? ,HERE ,CON-AREA>
		     ,DREAMING>
		<PERFORM ,V?BUY ,JUNK-FOOD>
		<RTRUE>)
	       (<OR <VERB? MUNG REMOVE TASTE>
		    <AND <VERB? TAKE>
			 ,PRSI>>
		<FSET ,BANANA ,RMUNGBIT>
		<TELL 
"As the " D ,MONKEY " on " D ,BACK " catches a whiff of the tangy fruit
beneath the chocolate, you feel its primal heart begin to race and, on
the back of your neck, its warm breath quicken." CR>
	        <COND (<NOT <HELD? ,BANANA>>
		       <CRLF>
		       <MOVE ,BANANA ,PROTAGONIST>
		       <PERFORM ,V?DROP ,BANANA>)>
	        <RTRUE>)
	       (<VERB? EAT BITE>
		<COND (<FSET? ,BANANA ,RMUNGBIT>
		       <MOVE ,BANANA ,LOCAL-GLOBALS>
		       <TELL 
"It gives you a brief, but intense, headache." CR>)
		      (T
		       <PERFORM ,V?MUNG ,BANANA>
		       <RTRUE>)>)
	       (<AND <VERB? DROP THROW>
		     <FSET? ,BANANA ,RMUNGBIT>>
		<MOVE ,MONKEY ,LOCAL-GLOBALS>
		<MOVE ,BANANA ,LOCAL-GLOBALS>
		<TELL 
"Following its jungle appetite, the " D ,MONKEY " dismounts " D ,BACK ",
pounces on the banana, and saunters away with it." CR>)>>

<ROUTINE GEN-FOOD ()
	 ,JUNK-FOOD>	   

<OBJECT JERRY
	(IN LOCAL-GLOBALS)
	(DESC "Jerry")
	(SYNONYM MAN JERRY PITCHER)
      	(FLAGS NDESCBIT ACTORBIT PERSON NARTICLEBIT)
	(ACTION JERRY-F)>

<ROUTINE JERRY-F ()
	 <COND ;(<LOST-TRACK?>
		<RTRUE>)
	       (<EQUAL? ,JERRY ,WINNER>
                <SETG WINNER ,PROTAGONIST>
	        <PERFORM ,V?HELLO ,JERRY>
	        <SETG WINNER ,JERRY>
	        <RTRUE>)
	       (<TALKING-TO? ,JERRY>
		<TELL
"The team is far too deeply engaged in nostalgia to pay any notice." CR>
		<STOP>)
	       (<VERB? BOARD THROUGH>
		 ;,IN-FRONT-FLAG
		<PERFORM ,V?KILL ,JERRY>
		<RTRUE>)
	       (<HURT? ,JERRY>
	        <FIGHT>
		<FSET ,JERRY ,RMUNGBIT>)>>

<OBJECT TEAM
        (DESC "group of ballplayers")
	(SYNONYM GROUP BALLPLAYERS BASEMAN FIELDER)
	(ADJECTIVE FIRST SECOND THIRD LEFT CENTER RIGHT CATCHER SHORTSTOP)
	(FLAGS NDESCBIT ACTORBIT PERSON)
	(ACTION TEAM-F)>

<ROUTINE TEAM-F ()
	 <COND ;(<LOST-TRACK?>
		<RTRUE>)
	       (<HURT? ,TEAM>
	        <FIGHT>
		<FSET ,TEAM ,RMUNGBIT>)
	       (<TALKING-TO? ,TEAM>                    
		<SETG WINNER ,PROTAGONIST>
	        <PERFORM ,V?HELLO ,JERRY>
	        <SETG WINNER ,TEAM>
	        <RTRUE>)
	       (<VERB? BOARD THROUGH>
		 ;,IN-FRONT-FLAG
		<PERFORM ,V?KILL ,TEAM>
		<RTRUE>)
	       (<VERB? COUNT>
		<TELL "Nine players, altogether." CR>)>>

;<ROUTINE LOST-TRACK? ()
	 <COND (<G? ,LINE-COUNTER 5>
	        <TELL "You've lost track of the team." CR>)>>

<ROUTINE FIGHT ()
	 <COND (<AND <FSET? ,JERRY ,RMUNGBIT>
		     <FSET? ,TEAM ,RMUNGBIT>>
		     <JIGS-UP 5 
"With the ensuing rhubarb, you end up on the permanently disabled list.">)
		    (T
	             <PLAYER-NUM-CHECK>
		     <TELL
"The " <GET ,PLAYERS ,PLAYER-NUM> " steps in between. \"This ">
		     <MAN-OR-WOMAN "clown" "chick">
		     <TELL " giving you trouble">
		     <COND (<PRSO? ,JERRY>
			    <TELL ", Jerry">)>
		     ;<PLAYER-NUM-CHECK>
		     <SETG PLAYER-NUM <RANDOM 8>>		      
		     <TELL 
"?\" Then the " <GET ,PLAYERS ,PLAYER-NUM> " backs you off with a nasty
stare." CR>)>>

<ROUTINE PLAYER-NUM-CHECK ()
	 <COND (<OR <IS-NOUN? ,W?FIELDER>
		    <IS-ADJ? ,W?LEFT>
		    <IS-ADJ? ,W?CENTER>
		    <IS-ADJ? ,W?RIGHT>>
		<SETG PLAYER-NUM <+ 3 <RANDOM 4>>>)
	       (<OR <IS-NOUN? ,W?BASEMAN>
		    <IS-ADJ? ,W?FIRST>
		    <IS-ADJ? ,W?SECOND>
		    <IS-ADJ? ,W?THIRD>>
		<SETG PLAYER-NUM <RANDOM 5>>)
	       (<IS-NOUN? ,W?CATCHER>
		<SETG PLAYER-NUM <RANDOM 3>>)
	       (<IS-NOUN? ,W?SHORTSTOP>
		<SETG PLAYER-NUM <+ 4 <RANDOM 3>>>)
	       (T
		<SETG PLAYER-NUM <RANDOM 8>>)>>

;<ROUTINE PLAYER-NUM-CHECK ()
	 <COND (<EQUAL? ,PLAYER-NUM 8>
		<SETG PLAYER-NUM 1>)
	       (T
		<SETG PLAYER-NUM <+ ,PLAYER-NUM 1>>)>>

<GLOBAL PLAYER-NUM 1>

;"the pitcher is Jerry"
<GLOBAL PLAYERS
	<PLTABLE  
	 "left fielder"
	 "right fielder"
	 "center fielder"
	 "shortstop"
	 "catcher"
	 "second baseman"
	 "first baseman"
	 "third baseman">>

<GLOBAL GREETINGS 
	<LTABLE 0   
	"glad-handing"
	"reminiscing with"
	"ribbing"
	"backslapping"
	"jiving with">> 

<OBJECT CON-STAND
	(IN LOCAL-GLOBALS)
	(DESC "concession stand")
	(SYNONYM STAND BLOOMER)
	(ADJECTIVE CONCES)
	(FLAGS NDESCBIT)
	(ACTION CON-STAND-F)>

;"RMUNGBIT = in i-bad-luck other line has kicked into gear"

<ROUTINE CON-STAND-F ()
	 <COND (<VERB? EXAMINE>
		<TELL
"It's just a ramshackle little stand, apparently staffed by ramshackle
little people from the looks of the service everyone is getting." CR>) 
	       (<AND <VERB? WALK-TO THROUGH ENTER BOARD>
		     <EQUAL? ,HERE ,CON-AREA>
		     ,DREAMING>
		<COND (<EQUAL? <LOC ,PROTAGONIST> ,LONG ,SHORT>
		       <OUT-OF-FIRST <LOC ,PROTAGONIST>>)
	              (T
		       <TELL
"You pass through a gauntlet of angry side-glances, outright dirty looks
and verbal abuse. The concessionaire -- \"Okay who's next?\" -- serves
somebody else and you walk back against a stream of sadistic sneers." CR>)>)>>

<OBJECT CONCESSIONAIRE
	(IN LOCAL-GLOBALS)
	(DESC "concessionaire")
	(SYNONYM CONCES)
	;(ADJECTIVE CONCES)
	(FLAGS NDESCBIT)
	(ACTION CONCESSIONAIRE-F)>

<ROUTINE CONCESSIONAIRE-F ()
	 <COND (<OR <TALKING-TO? ,CONCESSIONAIRE>
		    <VERB? BUY>>
		<TELL 
"You're not close enough to the " D ,CONCESSIONAIRE "." CR>
		<STOP>)
	       (<AND <VERB? WALK-TO>
		     <EQUAL? ,HERE ,CON-AREA>
		     ,DREAMING>
		<PERFORM ,V?WALK-TO ,CON-STAND>
	        <RTRUE>)>>

<OBJECT FOUNTAIN
	(IN CON-AREA)
	(DESC "drinking fountain")
	(SYNONYM FOUNTAIN ;DRAIN SPOUT)
	(ADJECTIVE DRINKING)
	(FLAGS NDESCBIT)
	(ACTION FOUNTAIN-F)>

<ROUTINE FOUNTAIN-F ()
	 <COND (<VERB? EXAMINE>
		<TELL
"It's your standard " D ,FOUNTAIN ", with a button next to the spout." CR>)
	       (<VERB? DRINK-FROM>
		<PERFORM ,V?PUSH ,BUTTON>
		<RTRUE>)>>

<OBJECT BUTTON
	(IN CON-AREA)
	(DESC "button")
	(SYNONYM BUTTON)
	(FLAGS NDESCBIT)
	(ACTION BUTTON-F)>

<ROUTINE BUTTON-F ()
	 <COND (<AND <EQUAL? <LOC ,PROTAGONIST> ,LONG ,SHORT>
		     <TOUCHING? ,BUTTON>>
		<OUT-OF-FIRST <LOC ,PROTAGONIST>>)
	       (<VERB? PUSH>		
	        <COND (<RUNNING? ,I-BOOST>
		       <COND (<EQUAL? ,BOOST-COUNTER 3>
			      <SETG HELPED-THUMB T>
			      <THUMB-DRINKS>
			      <BOOST-EXIT>)
			     (T
			      <TELL "Somebody else is ahead of you." CR>)>)
		      (<PROB 50>
		       <TELL 
"A jet of water hits you square in the eye." CR>)
		      (T
		       <TELL
"The sip of water is refreshing on this hot night." CR>)>)>>

<OBJECT GLOBAL-WATER
	(IN GLOBAL-OBJECTS)
	(DESC "water")
	(SYNONYM DRINK WATER)
	(FLAGS NDESCBIT)
	(ACTION GLOBAL-WATER-F)>

<ROUTINE GLOBAL-WATER-F ()
	 <COND (<EQUAL? ,HERE ,CON-AREA>
		<COND (<VERB? TAKE DRINK TASTE>
		       <PERFORM ,V?PUSH ,BUTTON>
		       <RTRUE>)
		      (T
		       <RFALSE>)>)
	       (T
	        <CANT-SEE ,GLOBAL-WATER>)>>

<ROOM BACK-YARD
      (IN ROOMS)
      (DESC "Back Yard")
      (NORTH TO BESIDE-BIGTOP)
      (SOUTH PER TURNSTILE-EXIT)
      (EAST TO NEAR-WAGON)
      (WEST TO PROP-ROOM)
      (NE TO CON-AREA)
      (FLAGS ONBIT RLANDBIT)
      (GLOBAL TURNSTILE TENT FENCE)
      (ACTION BACK-YARD-F)>

<ROUTINE BACK-YARD-F (RARG)
	 <COND (<EQUAL? .RARG ,M-LOOK>
		<TELL 
"You're standing in front of the " D ,TURNSTILE " entrance to a fenced-in
area, which is south. To the west stands a droopy tent, and the field
continues north and east." CR>)
	       (<AND <EQUAL? .RARG ,M-ENTER>
		     <ZERO? ,CLOWN-EXIT-COUNTER>
		     <NOT <RUNNING? ,I-BOOST>>
		     <NOT <FSET? ,BURNED-CAGE ,RMUNGBIT>>>
		<FSET ,BURNED-CAGE ,RMUNGBIT>
		<MOVE ,JOEY ,BACK-YARD>
		;<MOVE ,THUMB ,BACK-YARD> ;"in i-clown-exit"
		<MOVE ,FLOWER ,THUMB>
		<ENABLE <QUEUE I-CLOWN-EXIT -1>>)
	       (<EQUAL? .RARG ,M-BEG>
		<COND (<AND <NOT <RUNNING? ,I-CLOWN-EXIT>>
			    <CANT-WALK?>>
		       <RTRUE>)
		      (<AND <RUNNING? ,I-CLOWN-EXIT>
		     	    <VERB? WALK>
		     	    <HELD? ,THUMB>>
		       <SETG CLOWN-EXIT-COUNTER 7>
		       <TELL 
"The midget becomes restless in your arms, halting your stroll." CR>)>)
	       (<AND <EQUAL? .RARG ,M-END>
		     <AND ,CLOWN-ALLEY-SCENE>
		     <NOT <FSET? ,BURNED-CAGE ,TOUCHBIT>>>
		<FSET ,BURNED-CAGE ,TOUCHBIT>
		<TELL CR ,GUARD-CALLS
"\"You're still around kicking sawdust, huh? Let me give a tip: Be careful,
there's no telling what, or who, could be lurking around the lot here at
night.\"" CR>)
	       (<AND <EQUAL? .RARG ,M-END>
		     <IN? ,GIRL ,PROTAGONIST>
		     <NOT ,GUARD-KNEW>>
		<SETG GUARD-KNEW T>
		<TELL CR 
,GUARD-CALLS "\"Nice going, towner. It just shows you what can be accomplished
when you start out the evening with a little " D ,HELIUM ", eh?" CR>)>>
		     
<GLOBAL GUARD-KNEW <>>

<GLOBAL CLOWN-EXIT-COUNTER 0> ;"REMEMBER, adds one at begin. of INT"

<GLOBAL THUMB-THRU <>>

<ROUTINE I-CLOWN-EXIT ("AUX" (NOT-HOLDING <>))
	 <COND (<NOT <HELD? ,THUMB>>	
		<SET NOT-HOLDING T>)>
	 <SETG CLOWN-EXIT-COUNTER <+ 1 ,CLOWN-EXIT-COUNTER>>
	 <COND (<NOT <EQUAL? ,HERE ,BACK-YARD>>
		<SETG CLOWN-EXIT-COUNTER 8>)>
	 <COND (<EQUAL? ,CLOWN-EXIT-COUNTER 1>
		<MOVE ,THUMB ,BACK-YARD>
	        <RTRUE>)
	       (<EQUAL? ,CLOWN-EXIT-COUNTER 2>
	        <MOVE ,JOEY ,CLOWN-ALLEY>
		<SETG FOLLOW-FLAG 2>
		<ENABLE <QUEUE I-FOLLOW 2>>
		<COND (<NOT ,HELPED-THUMB>
		       <SETG CLOWN-EXIT-COUNTER 7>)>
	        ;<MOVE ,GUARD ,BACK-YARD>
		<TELL CR 
"The tall clown, whom you now recognize as Chuckles, barks a hello into the
cage. You hear an electronic buzz from the " D ,TURNSTILE " and Chuckles passes
through.">)
	       (<AND <EQUAL? ,CLOWN-EXIT-COUNTER 3>
		     .NOT-HOLDING>
		<TELL CR
D ,THUMB " performs an impromptu handstand.">)
	       (<AND <EQUAL? ,CLOWN-EXIT-COUNTER 4>
		     .NOT-HOLDING>
		<TELL CR 
D ,THUMB " belts out a few verses of a Russian folk song in his high-pitched,
squeaky voice while standing on his head.">)
	       (<AND <EQUAL? ,CLOWN-EXIT-COUNTER 5>
		     .NOT-HOLDING>
		<TELL CR 
"The midget performer does several cartwheels in a figure-eight pattern around
the grass field.">)
	       (<AND <EQUAL? ,CLOWN-EXIT-COUNTER 6>
		     .NOT-HOLDING>
		<TELL CR 
"In front of you, " D ,THUMB " terminates his acrobatics on one knee with
a grand gesture of his small arms.">) 
	       (<AND <EQUAL? ,CLOWN-EXIT-COUNTER 7>
		     .NOT-HOLDING>
		<TELL CR 
 D ,THUMB " is pausing to rest.">)
	       (<EQUAL? ,CLOWN-EXIT-COUNTER 8>
		<DISABLE <INT I-CLOWN-EXIT>>
		<COND (<EQUAL? ,HERE ,BACK-YARD>
		       <COND (<HELD? ,THUMB>
			      <TELL CR
"Wriggling out of your hold, ">)
			     (T
			      <CRLF>)>
	               <TELL
D ,THUMB ", in his squeaky and high-pitched voice, says \"Hello Harry\" toward
the " D ,BURNED-CAGE ". You hear a buzzing sound from the " D ,TURNSTILE " as
the midget reaches up to its lowest rung and passes through ..." CR>)>
		<SETG THUMB-THRU T>
		<DISABLE <INT I-TURNSTILE>>
		<FCLEAR ,THUMB ,NDESCBIT>
		<FCLEAR ,JOEY ,NDESCBIT>
		<SETG FOLLOW-FLAG 2>
		<ENABLE <QUEUE I-FOLLOW 2>>
	        <MOVE ,FLOWER ,LOCAL-GLOBALS>
		<MOVE ,THUMB ,CLOWN-ALLEY>
		<MOVE ,JOEY ,CLOWN-ALLEY>
		<RTRUE>)
	       (T
		<RFALSE>)>
	 <CRLF>>

<OBJECT CHUTE
	(IN BESIDE-BIGTOP)
	(DESC "barred passage")
	(SYNONYM PASSAGE CHUTE BAR BARS)
	(ADJECTIVE BARRED ;WILD ;ANIMAL)
	(DESCFCN CHUTE-DESC)
	(FLAGS CONTBIT OPENBIT TRANSBIT ;NDESCBIT)
	(CAPACITY 500)
	(CONTFCN IN-CHUTE)
	(GENERIC GEN-BAR)
	(ACTION CHUTE-F)>

<ROUTINE CHUTE-DESC ("OPTIONAL" X)
	 <TELL 
"About waist-high, a barred passage for wild animals extends several yards
out from the " D ,BIGTOP>
	 <COND (<IN? ,NIMROD ,CHUTE>		
		<COND (<NOT <IN? ,MEAT ,CHUTE>>
		       <TELL  
". The " D ,CHUTE " is being patrolled by two large ">
		       <COND (<NOT <FSET? ,GRATE ,OPENBIT>>
			      <TELL "and bewildered ">)>
		       <TELL "cats">)
		      (<IN? ,MEAT ,CHUTE>
		       <TELL 
". Inside the chute, Nimrod and Elsie are loudly digging their chops into
the " D ,MEAT>)>)>
	        <TELL ".">>

<ROUTINE CHUTE-F ("OPTIONAL" (RARG <>))
	 <COND (<VERB? EXAMINE LOOK-INSIDE>
		<COND (<AND <OR <IS-NOUN? ,W?BAR>
			        <IS-NOUN? ,W?BARS>>
			    <VERB? EXAMINE>>
		        <RFALSE>)
		      (<IN? ,ELSIE ,CHUTE>
		       <TELL "Two lions are ">
		       <COND (<IN? ,MEAT ,CHUTE>
			      <TELL "chomping on some meat inside">)
			     (T
			      <TELL "strolling the length of">)>
		       <TELL " the " D ,CHUTE>
		       <MOVE-LIONS ,DUMMY-OBJECT>
		       <COND (<IN? ,MEAT ,CHUTE>
			      <MOVE ,MEAT ,DUMMY-OBJECT>)>
		       <COND (<FIRST? ,CHUTE>
			      <TELL ", which also contains">
			      <PRINT-CONTENTS ,CHUTE>)>
		       <MOVE-LIONS ,CHUTE>
		       <COND (<IN? ,MEAT ,DUMMY-OBJECT>
			      <MOVE ,MEAT ,CHUTE>)>
		       <TELL ,PERIOD>)>)
	       (<VERB? BOARD THROUGH ENTER>
		<TELL-CLOSELY-SPACED T>)
	       (<VERB? FOLLOW>
		<TELL "It leads right into the " D ,BIGTOP "." CR>)
	      (<VERB? OPEN CLOSE>
	       <TELL "The rusty grate is inside the " D ,BIGTOP "." CR>)
	      (<VERB? WALK-AROUND>
	       <PERFORM ,V?LOOK-BEHIND ,CHUTE>
	       <RTRUE>)
	      (<AND <VERB? PUT>
		    <PRSI? ,CHUTE>>
		<COND (<PRSO? ,MOUSE ,BALLOON>
		       <RFALSE>)
		      (<AND <G? <GETP ,PRSO ,P?SIZE> 20>
			    <NOT <EQUAL? ,PRSO ,POLE>>>
		       <TELL-CLOSELY-SPACED>)		      
		      (T		       
		       <COND (<AND <PRSO? ,MEAT>
		     	           <FSET? ,GRATE ,OPENBIT>>
			      <ENABLE <QUEUE I-LION 2>>)>
		       <MOVE ,PRSO ,CHUTE>
		       <TELL "You slip">
		       <ARTICLE ,PRSO T>
		       <TELL " into the " D ,CHUTE "." CR>)>)
		(<AND <VERB? REACH-IN>
		      <IN? ,NIMROD ,CHUTE>>
		 <TELL "You'd">
		 <TELL-WITHDRAW-STUMP>)>>

<ROUTINE IN-CHUTE ()
	 <COND (<AND <VERB? TAKE MOVE RUB>
		     <EQUAL? ,HERE ,BESIDE-BIGTOP>>
		<COND (<IN? ,ELSIE ,CHUTE>
		       <TELL 
"If you reached into the " D ,CHUTE " you'd">
		       <TELL-WITHDRAW-STUMP T>)
	       	      (<AND <VERB? TAKE>
		            <PRSO? ,MEAT>
		            <FSET? ,GRATE ,OPENBIT>>
		       <CANT-REACH ,MEAT>)
	       	      ;(<AND <VERB? TAKE>
		     	    <G? <GETP ,PRSO ,P?SIZE> 20>
		     	    <NOT <EQUAL? ,PRSO ,POLE>>>
		       <TELL-CLOSELY-SPACED>)
		      (T
		       <RFALSE>)>)
	       (T
		<RFALSE>)>>

<ROUTINE TELL-WITHDRAW-STUMP ("OPTIONAL" (PRSO? <>))
	 <TELL 
" likely withdraw a stump instead of " D ,HANDS>
	 <COND (.PRSO?
		<TELL " or">
	 	<ARTICLE ,PRSO T>)>
	 <TELL ,PERIOD>>

<OBJECT GRATE
	(IN DEN)
	(DESC "rusty grate")
	(SYNONYM GRATE CHUTE PASSAGE)
	(ADJECTIVE SQUARE RUSTY)
	(FLAGS NDESCBIT DOORBIT)
	(ACTION GRATE-F)>

;"RMUNGBIT = have opened it once while lions feed in den - lions pivot around
	     their dinner"

<ROUTINE GRATE-F ()
	 <COND (<AND <VERB? PUT>
		     <PRSI? ,GRATE>>
		<COND (<PRSO? ,BALLOON>
		       <RFALSE>)
		      (<FSET? ,GRATE ,OPENBIT>
		       <MOVE ,PRSO ,CHUTE>
		       <TELL "You fling">
		       <ARTICLE ,PRSO T>
		       <TELL " into the darkness of the passage. ">
		       <COND (<PRSO? ,MOUSE>
			      <MOVE ,MOUSE ,LOCAL-GLOBALS>)
			     (<AND <IN? ,NIMROD ,DEN>
				   <PRSO? ,MEAT>>
			      <TELL ,LIONS-WAIT>)>
		       <CRLF>
		       <RTRUE>)
		      (T
		       <TELL "The " D ,GRATE " is closed." CR>)>)
	       (<OR <AND <NOT <FSET? ,GRATE ,OPENBIT>>
		         <VERB? OPEN RAISE PUSH>>
		    <AND <FSET? ,GRATE ,OPENBIT>
			 <VERB? CLOSE LOWER PUSH>>>
		<COND (<IN? ,ELSIE ,CHUTE>
		       <COND (<VERB? OPEN RAISE>
		       	      <JIGS-UP 2 
"With the force and brightness of a supernova, Nimrod's mane suddenly
bursts from the dark passage.">)
			     (T
			      <OPEN-GRATE>)>)		         
		      (<IN? ,MEAT ,HERE>
		       <COND (<FSET? ,GRATE ,RMUNGBIT>
			      <OPEN-GRATE>)
			     (T
			      <FSET ,GRATE ,RMUNGBIT>
			      <OPEN-GRATE T>)>)
		      (<EQUAL? ,ELSIE-COUNTER 0>
		       <TELL 
"Like sentries on guard, the pacing lions prevent this." CR>)
		      (<L? ,ELSIE-COUNTER 3>
	       	       <TELL 
"The " D ,ELSIE " is blocking access to the " D ,GRATE "." CR>)
		     (<NOT <HELD? ,STOOL>>
		      <TELL 
"You're unable to get close enough without the " D ,NIMROD " getting too close
to you." CR>)
		     (T
		      <TELL
"Using the stool as a barrier against the " D ,NIMROD ", you're able to reach
it. ">
		       	     <OPEN-GRATE>)>)
		(<VERB? LOOK-INSIDE EXAMINE>
		 <TELL "The ">
      		 <COND (<FSET? ,GRATE ,OPENBIT>
			<TELL "open">)
		       (T
			<TELL "closed">)>
		 <TELL 
" " D ,GRATE " leads to a passage going away from the round cage. "
,YOU-SEE " that it is empty up to the point where it extends outside of the
big top." CR>)
		(<AND <OR <TOUCHING? ,GRATE>
		          <VERB? WALK-TO BOARD THROUGH>>
		      <IN? ,ELSIE ,HERE>
		      <NOT <EQUAL? ,ELSIE-COUNTER 3>>
		      <NOT <IN? ,MEAT ,HERE>>
		      ;<NOT <HELD? ,STOOL>>>
		 <TELL "You can't get over to the grate." CR>
		 <RTRUE>)
	        (<VERB? BOARD THROUGH ENTER>
		 <COND (<FSET? ,GRATE ,OPENBIT>
		 	<TELL "That's dangerous and foolhardy." CR>)  
		       (T
			<TELL "The grate is closed." CR>)>
		 <RTRUE>)>>
					      
<ROUTINE OPEN-GRATE ("OPTIONAL" (EATING-MEAT? <>))
	 <COND (.EATING-MEAT?
		<TELL "The ">
		<COND (<ZERO? ,ELSIE-COUNTER>
		       <TELL "lions rotate">)
		      (T
		       <TELL D ,NIMROD " rotates">)>
		<TELL 
" around the lump of meat, continuing to feed while watching you. ">)>
	 <TELL "The " D ,GRATE " slides ">
         <COND (<VERB? OPEN RAISE>
	        <FSET ,GRATE ,OPENBIT>
		<TELL "up, jamming into place. ">
		<COND (<IN? ,MEAT ,CHUTE>
		       <TELL ,LIONS-WAIT>)>
		<CRLF>)
	       (T
		<FCLEAR ,GRATE ,OPENBIT>
	        <TELL "down to the " D ,GROUND "." CR>)>>

<ROOM BESIDE-BIGTOP
      (IN ROOMS)
      (DESC "Beside the Big Top")       
      (SOUTH TO BACK-YARD)
      (NORTH "You bump into the side wall of the big top.")
      (SE TO NEAR-WAGON)
      (EAST TO CON-AREA)
      (WEST "It's too dark and unfamiliar out there.")
      (FLAGS ONBIT RLANDBIT)
      (GLOBAL BIGTOP)
      (ACTION BESIDE-BIGTOP-F)>

<ROUTINE BESIDE-BIGTOP-F (RARG)
	 <COND (<EQUAL? .RARG ,M-LOOK>
		<TELL
"You're standing next to the " D ,BIGTOP ", which is gently flapping in the
warm breeze." CR>)>>

;"Wagon and office stuff"

<ROOM NEAR-WAGON
      (IN ROOMS)
      (DESC "Near White Wagon")
      (NORTH TO CON-AREA)
      (SOUTH PER EGRESS-EXIT)
      (OUT PER EGRESS-EXIT)
      (NW TO BESIDE-BIGTOP)
      (EAST TO OFFICE IF OFFICE-DOOR IS OPEN)
      (IN TO OFFICE IF OFFICE-DOOR IS OPEN)
      (WEST TO BACK-YARD)
      (NE PER FENCE-EXIT)
      (UP PER UP-LADDER)
      (GLOBAL OFFICE-DOOR BANNER FENCE WAGON LADDER)
      (FLAGS ONBIT RLANDBIT)
      (ACTION NEAR-WAGON-F)>

<ROUTINE NEAR-WAGON-F (RARG)
	 <COND (<EQUAL? .RARG ,M-LOOK>
		<TELL
"You are standing on a gentle upslope of the grassy field, next to a rather
imposing trailer whose door is ">
		<COND (<FSET? ,OFFICE-DOOR ,OPENBIT>
		       <TELL "open">)
		      (T
		       <TELL "closed">)>
		<TELL " to the east">
		<COND (<FSET? ,LADDER ,RMUNGBIT>
		       <TELL 
". Attached to the rear of the trailer is a step" D ,LADDER>)>
		<TELL
". In dark panorama, the field continues north and west -- and south, where
a large banner has been erected." CR>
		<COND (<FSET? ,LADDER ,RMUNGBIT>
		       <CRLF>
		       <TELL-BULL-HOLE>)>)
	       (<EQUAL? .RARG ,M-ENTER>
		<COND (<QUEUE-THUMB?>
		       <ENABLE <QUEUE I-THUMB 1>>)>
		<COND (<AND <IN? ,BULL ,LOCAL-GLOBALS>
			    <NOT <FSET? ,LADDER ,RMUNGBIT>>>
		       <TELL "Y">
		       <NOTICE-LADDER>)>)
 	       (<AND <EQUAL? .RARG ,M-BEG>
		     <IN? ,MUNRAB ,MEN>
		     <IN? ,GIRL ,PROTAGONIST>
		     <VERB? WALK>
		     <NOT <EQUAL? ,P-WALK-DIR ,P?NE>>>
		<DONT-WALK ,GIRL>)>>
		   
<ROUTINE NOTICE-LADDER ()
	 <FSET ,LADDER ,RMUNGBIT>
	 <TELL 
"ou come to the " D ,WAGON " and notice a stepladder attached to its rear."
CR CR>>

<GLOBAL EGRESS-C 0>
;<GLOBAL KNOW-EGRESS <>>

<ROUTINE EGRESS-EXIT ()
	 <SETG EGRESS-C <+ ,EGRESS-C 1>>
	 <COND (<EQUAL? ,EGRESS-C 1>
		<SETG AWAITING-REPLY 10>
		<ENABLE <QUEUE I-ARGUMENT 2>>
		<TELL 
"Are you sure you're mentally and otherwise prepared to meet up with
an " D ,EGRESS "?" CR>  
		<RFALSE>)
	       (<EQUAL? ,EGRESS-C 2>
		<SETG AWAITING-REPLY 11>
		<ENABLE <QUEUE I-ARGUMENT 2>>
		<TELL 
"Then you're fully aware of the ferociousness of this rare mammalian species,
right?" CR>
		<RFALSE>)
	       (<EQUAL? ,EGRESS-C 3>
		<DISABLE <INT I-ARGUMENT>>
		<SETG AWAITING-REPLY 12>
		<ENABLE <QUEUE I-REPLY 2>>
		<TELL
"Alright, so you know all about " D ,EGRESS "es. But do you really want to
leave the circus in all of its mystery and all of its pageantry behind?" CR>
		<RFALSE>)
	       (<G? ,EGRESS-C 3>
		<DISABLE <INT I-ARGUMENT>>
		<SETG AWAITING-REPLY <>>
		<FINISH>)>>

<ROUTINE I-ARGUMENT ()
	 <COND (<OR <EQUAL? ,P-WALK-DIR ,P?SOUTH>
		    <AND <EQUAL? ,AWAITING-REPLY 10>
			 <VERB? YES>>
		    <AND <EQUAL? ,AWAITING-REPLY 11>
			 <VERB? NO>>>
		<RTRUE>)
	       (T
		<SETG AWAITING-REPLY <>>
	 	<SETG EGRESS-C 0>)>>

<ROUTINE TELL-BULL-HOLE ()
	 <TELL 
"There is an elephant-sized hole in the fence to the ">
	 <COND (<EQUAL? ,HERE ,MEN>
		<TELL "southwest">)
	       (T
		<TELL "northeast">)>
	<TELL ,PERIOD>>

<ROOM ON-WAGON
      (IN ROOMS)
      (DESC "On the Wagon")
      (DOWN PER DOWN-WAGON)
      (IN PER IN-PANEL)
      (FLAGS ONBIT RLANDBIT)
      ;(PSEUDO "CRANK" CRANK-PSEUDO)
      (GLOBAL PANEL LADDER OFFICE-DOOR WAGON OFFICE-OBJECT)
      (GROUND-LOC NEAR-WAGON)
      (ACTION ON-WAGON-F)>

<ROUTINE ON-WAGON-F (RARG)
	 <COND (<EQUAL? .RARG ,M-LOOK>
		<TELL 
"You are on the wagon, a condition in which you're not likely to find the
detective. The aluminum roofing gives way slightly underfoot. You observe a "
D ,PANEL>
		<COND (<FSET? ,PANEL ,OPENBIT>
		       <TELL ", which is open">)>
		<TELL ", and next to it, a kind of crank." CR>)
	       (<EQUAL? .RARG ,M-ENTER>
		<FCLEAR ,OFFICE-DOOR ,RMUNGBIT>
	        <COND (<NOT <FSET? ,ON-WAGON ,TOUCHBIT>>  ;"door opens,closes"
	               <ENABLE <QUEUE I-OFFICE 1>>)>)
	       (<AND <EQUAL? .RARG ,M-BEG>
		     <IN? ,MUNRAB ,HERE>
		     <FSET? ,PANEL ,OPENBIT>
		     <OR <AND <VERB? LEAP>
			      <NOT ,PRSO>>
		    	 <AND <VERB? LEAP KICK KILL ;KNOCK>
		    	      <PRSO? ,WAGON>>>>
		<TELL 
D ,MUNRAB " must have pretty bad hearing, since he doesn't seem to
notice the noise coming from the roof." CR>)>>

<ROUTINE IN-PANEL ()
	 <COND (<NOT <FSET? ,PANEL ,OPENBIT>>
		<TELL "The " D ,PANEL " is closed." CR>
		<RFALSE>)
	       (<IN? ,MUNRAB ,ON-WAGON>
	        <TELL 
"Aghast by your dropping in on him like this, " D ,MUNRAB>
		<JIGS-UP 3  
" grabs the nearest weapon-like object, which happens to be a gold-plated
letter opener, and goes for the throat.">
		<RFALSE>)
	       ;(<G? <WEIGHT ,PROTAGONIST> 20>
		<TELL 
"It's too tight a squeeze with what you're carrying." CR>
		<RFALSE>)	        
	       (T
		<TELL "You wriggle through the panel opening." CR CR>
		<RETURN ,OFFICE>)>>

<OBJECT WAGON
	(IN LOCAL-GLOBALS)
	(DESC "white wagon")
	(SYNONYM WAGON TRAILER LOGO)
	(ADJECTIVE WHITE)
	(FLAGS NDESCBIT)
	(ACTION WAGON-F)>

<ROUTINE WAGON-F ()
	 <COND (<AND <VERB? EXAMINE READ>
		     <EQUAL? ,HERE ,NEAR-WAGON>>
		<TELL
"The familiar logo for \"The Travelling Circus That Time Forgot, Inc.\" is
emblazoned across the long side of the " D ,WAGON>
	        <COND (<IS-NOUN? ,W?LOGO>
		       <TELL ,PERIOD>
		       <RTRUE>)>
		<TELL ". The ">
		<OPEN-CLOSED ,OFFICE-DOOR>
		<TELL " " D ,OFFICE-DOOR " is at the east">
		<COND (<FSET? ,LADDER ,RMUNGBIT>
		       <TELL ", and there's">
		       <TELL-LADDER>)>
		<TELL ,PERIOD>)
	       (<AND <VERB? LOOK-INSIDE>
		     <EQUAL? ,HERE ,ON-WAGON>>
		<PERFORM ,V?LOOK-INSIDE ,PANEL>
		<RTRUE>)
	       (<VERB? PUT>
		<COND (<AND <FSET? ,PANEL ,OPENBIT>
			    <IN? ,MUNRAB ,ON-WAGON>>
		       <STARTLE-MUNRAB>)
		      (T
		       <V-DIG>)>)
	       (<VERB? PUT-ON>
		<COND (<EQUAL? ,HERE ,ON-WAGON>
		       <PERFORM ,V?DROP ,PRSO>
		       <RTRUE>)
		      (T
		       <V-DIG>)>)
	       (<VERB? WALK-AROUND LOOK-BEHIND>
		<COND (<FSET? ,LADDER ,RMUNGBIT>
		       <TELL "You see">
		       <TELL-LADDER>)
		      (T
		       <TELL "A " D ,FENCE " prevents this">)>
		 <TELL ,PERIOD>)
	       (<VERB? KNOCK>
		<PERFORM ,V?KNOCK ,OFFICE-DOOR>
		<RTRUE>)
	       (<VERB? WALK-TO THROUGH ENTER BOARD>
		<COND (<EQUAL? ,HERE ,ON-WAGON ,NEAR-WAGON>
		       <DO-WALK ,P?IN>)
		      (<EQUAL? ,HERE ,OFFICE>
		       <TELL ,LOOK-AROUND CR>)>)
	       (<VERB? DISEMBARK>
		<COND (<EQUAL? ,HERE ,ON-WAGON>
		       <PERFORM ,V?CLIMB-DOWN ,LADDER>
		       <RTRUE>)
		      (<EQUAL? ,HERE ,OFFICE>
		       <DO-WALK ,P?UP>)>)
	       (<AND <VERB? CLIMB-UP CLIMB-FOO CLIMB-ON>
		     <FSET? ,LADDER ,RMUNGBIT>>
		<DO-WALK ,P?UP>)
	       (<AND <VERB? LOOK-UNDER>
		     <NOT <FSET? ,POLE ,TOUCHBIT>>
		     <IN? ,POLE ,HERE>>
		<TELL <GETP ,POLE ,P?FDESC> CR>
		<RTRUE>)>> 

<ROUTINE TELL-LADDER ()
	 <TELL " a narrow ladder attached to the back of the wagon">>

<ROUTINE DOWN-WAGON ()
	 <COND (<FSET? ,PANEL ,OPENBIT>
		<TELL 
"[Do you want to climb down the ladder or climb in through the opening? Type
CLIMB DOWN LADDER or IN.]" CR>
		<SETG CLOCK-WAIT T>
		<RFALSE>)
	       (T
		<DOWN-LADDER>)>>

<OBJECT CRANK
	(IN ON-WAGON)
	(DESC "crank")
	(SYNONYM CRANK)
	(FLAGS NDESCBIT)
	(ACTION CRANK-F)>

<ROUTINE CRANK-F ()
	 <COND (<AND <VERB? SET>
		     <NOT ,PRSI>>
		<TELL 
"The crank is rotated ">
		<COND (<FSET? ,PANEL ,RMUNGBIT>
		       <TELL "but the " D ,PANEL " doesn't open.">)
		      (T			
		       <TELL "and the " D ,PANEL " gradually slides ">
		       <COND (<FSET? ,PANEL ,OPENBIT>
		       	      <FCLEAR ,PANEL ,OPENBIT>
		       	      <TELL "closed.">)
		      	     (T
		       	      <FSET ,PANEL ,OPENBIT>
		       	      <TELL "open.">)>)>
		<CRLF>)>>

<OBJECT PANEL
	(IN LOCAL-GLOBALS)
	(DESC "square aluminum panel")
	(SYNONYM PANEL OPENING)
	(ADJECTIVE ALUMINUM SQUARE)
	(FLAGS NDESCBIT DOORBIT)
	(ACTION PANEL-F)>

<ROUTINE PANEL-F ()           ;"The open-close shit only for testing in Zil"
	 <COND (<VERB? CLIMB-DOWN THROUGH BOARD>
		<DO-WALK ,P?IN>)
	       (<VERB? LOOK-INSIDE>
		<COND (<OR <NOT <FSET? ,PANEL ,OPENBIT>>
			   <EQUAL? ,HERE ,OFFICE>>
		       <PERFORM ,V?EXAMINE ,PANEL>
		       <RTRUE>)
		      (T
		       <TELL ,YOU-SEE>
		       <COND (<IN? ,MUNRAB ,ON-WAGON>
			      <TELL 
" the top view of " D ,MUNRAB "'s schlock of silvery blow-dried hair. He
is busy at his desk.">)
			     (T
			      <TELL " an unoccupied office.">)>
		       <CRLF>)>)
	       (<AND <VERB? PUT PUT-ON>
		     <PRSI? ,PANEL>>
		<V-DIG>)
	       (<OR <AND <VERB? OPEN>
			 <NOT <FSET? ,PANEL ,OPENBIT>>>
		    <AND <VERB? CLOSE>
			 <FSET? ,PANEL ,OPENBIT>>>
		<COND (<EQUAL? ,HERE ,OFFICE>
		       <CANT-SEE <> "the crank">)
		      (T
		       <PERFORM ,V?SET ,CRANK>
		       <RTRUE>)>)>>

<ROOM OFFICE
      (IN ROOMS)
      (DESC "Office")
      (UP PER UP-OFFICE)
      (WEST TO NEAR-WAGON IF OFFICE-DOOR IS OPEN)
      (OUT TO NEAR-WAGON IF OFFICE-DOOR IS OPEN)
      (FLAGS ONBIT RLANDBIT INDOORSBIT)
      (GLOBAL PANEL OFFICE-DOOR WAGON OFFICE-OBJECT)
      (PSEUDO "MEMOS" MEMOS-F "MEMO" MEMOS-F)
      (ACTION OFFICE-F)>
		
<ROUTINE OFFICE-F (RARG)
	 <COND (<EQUAL? .RARG ,M-LOOK>
		<TELL
"This is " D ,MUNRAB "'s plush inner sanctum, containing all the furnishings
of the well-appointed, modern office -- including a shiny, expansive " D ,DESK 
". Along one " D ,WALLS ", below some framed sheepskin, runs a " D ,BOOKS ".|
|
The ">
	        <COND (<FSET? ,OFFICE-DOOR ,OPENBIT>
		       <TELL "open">)
		      (T
		       <TELL "closed">)>
		<TELL 
" " D ,OFFICE-DOOR " on the west wall appears lockable without a key." CR>)
	       (<AND <EQUAL? .RARG ,M-ENTER>
		     <NOT <FSET? ,OFFICE ,TOUCHBIT>>>
		<SETG SCORE <+ ,SCORE 10>>
		<RFALSE>)>>

<OBJECT SHEET
	(IN DESK)
	(DESC "spreadsheet")
	(SYNONYM SPREADSHEET SHEET PRINTOUT)	
	(ADJECTIVE COMPUTER)
	(FLAGS ;NDESCBIT TAKEBIT)
	(ACTION SHEET-F)>

;"RMUNGBIT = Clown knows about "

<GLOBAL SEEN-SHEET <>> ;"player has seen sheet"

<ROUTINE SHEET-F ()
	 <COND (<VERB? READ EXAMINE>
		<SETG SEEN-SHEET T>
	        <TELL
"The spreadsheet shows lists of declining numbers which appear to be the
salary of one performer named Eddie Smaldone." CR>)>>

<OBJECT PHONE
	(IN DESK)
	(DESC "telephone")
	(SYNONYM TELEPH PHONE)
	(FLAGS ;NDESCBIT TRYTAKEBIT TAKEBIT)
	(ACTION PHONE-F)>

<ROUTINE PHONE-F ()
	 <COND (<VERB? REPLY>
		<TELL "The ringing is only in your ears." CR>)
	       (<VERB? TAKE>
		<TELL "You hear a dial tone." CR>)
	       (<VERB? HANG-UP DROP>
		<TELL "Slam!" CR>)>>
 
<OBJECT POLICE
	(IN GLOBAL-OBJECTS)
	(DESC "police")
	(SYNONYM POLICE COPS STATION)
	(ADJECTVIE POLICE)
	(FLAGS NDESCBIT)
	(ACTION POLICE-F)>

<ROUTINE POLICE-F ()
	 <COND (<DONT-HANDLE? ,POLICE>
		<RFALSE>)
	       (T
		<CANT-SEE ,POLICE>)>>

<OBJECT FENCE 
	(IN LOCAL-GLOBALS)
	(DESC "chain link fence")
	(SYNONYM FENCE HOLE)
	(ADJECTIVE CHAIN LINK ;ELEPHANT)
	(FLAGS NDESCBIT)
	(ACTION FENCE-F)>

<ROUTINE FENCE-F ()
	 <COND (<AND <IN? ,BULL ,MEN>
		     <IS-NOUN? ,W?HOLE>>
		<CANT-SEE <> "the hole">)
	       (<AND <VERB? EXAMINE>
		     <NOT <IN? ,BULL ,MEN>>
		     <EQUAL? ,HERE ,MEN ,NEAR-WAGON>>
		<TELL-BULL-HOLE>)
	       (<VERB? CLIMB-UP CLIMB-FOO CLIMB-ON CLIMB-OVER>
	 	<TELL
"Though hastily constructed, the " D ,FENCE " succeeds as a barrier." CR>)     
	       (<VERB? THROUGH WALK-TO ENTER>
		<COND (<EQUAL? ,HERE ,MEN>
		       <DO-WALK ,P?SW>)
		      (<EQUAL? ,HERE ,NEAR-WAGON>
		       <DO-WALK ,P?NE>)>)>>

<OBJECT EDDIE 
	(IN GLOBAL-OBJECTS)
	(DESC "Eddie Smaldone")
	(SYNONYM EDDIE SMALDO MAN)
	(ADJECTIVE EDDIE ED)
	(FLAGS NDESCBIT NARTICLEBIT ACTORBIT PERSON)
	(ACTION EDDIE-F)>

;"Eddie Rmungbit = Player knows (from guard) the ID of this name"

<GLOBAL JOEY-NAME-KNOWN <>>

<ROUTINE EDDIE-F ()
	 <COND (<AND <DONT-HANDLE? ,EDDIE>
		     <NOT <EQUAL? ,PRSA ,V?FOLLOW>>>
		<RFALSE>)
	       (<VERB? FOLLOW>
		<COND (<EQUAL? ,FOLLOW-FLAG 2>
		       <DO-WALK ,P?SOUTH>)
		      (<EQUAL? ,FOLLOW-FLAG 3>
		       <DO-WALK ,P?WEST>)
	              (<EQUAL? ,FOLLOW-FLAG 4>
		       <DO-WALK ,P?EAST>)>)
	       (<NOT <FSET? ,EDDIE ,RMUNGBIT>>
		<TELL "You don't know anyone here by that name." CR>
		<RFATAL>)
	       (<NOT <IN? ,JOEY ,HERE>>
		<CANT-SEE ,EDDIE>)
	       (<TALKING-TO? ,EDDIE>
		<COND (,JOEY-NAME-KNOWN
		       <COND (<AND <NOT ,WON-JOEY>
				   <JOEY-SCARED?>>
			      <RFATAL>)>
		       <TELL "To your words " D ,JOEY " responds not." CR>
		       <STOP>)
		      (T
		       <SETG JOEY-NAME-KNOWN T>
		       <SETG SCARE-NUMBER <+ ,SCARE-NUMBER 1>>
		       <COND (<AND <NOT ,WON-JOEY>
			      	   <JOEY-SCARED?>>
			      <RFATAL>)>
		       <TELL 
D ,JOEY " snorts at the sound of the name and continues wiping the "
D ,TAMER-TRAILER "." CR>
		       <STOP>)>)
	       (T
		<SETG JOEY-NAME-KNOWN T>
		<COND (<AND <NOT ,WON-JOEY>
			    <JOEY-SCARED?>>
		       <RFATAL>)
	       	      (T
		       <JOEY-F>)>)>>

<ROUTINE DONT-HANDLE? (PERSON) ;"or thing"
	 <COND (<AND <EQUAL? .PERSON ,PRSO>
		     <VERB? FIND FOLLOW WHAT WHERE WALK-TO CALL PHONE 
			    PHONE-WITH>>
		<RTRUE>)
	       (<AND <EQUAL? .PERSON ,PRSI>
		     <VERB? ASK-ABOUT TELL-ABOUT ASK-FOR>>
		<RTRUE>)>>

<ROUTINE MEMOS-F ()
	 <COND (<VERB? SEARCH MOVE LOOK-UNDER PUSH>
		<TELL "This reveals nothing new." CR>)
	       (<VERB? READ EXAMINE>
		<TELL 
"The handwriting is frantic and mostly illegible. From what you can make out,
the memos, all dated before today, contain threats and expressions of rage
from " D ,MUNRAB " toward most of his circus employees." CR>)   
	       (<VERB? TAKE>
		<ENABLE <QUEUE I-REPLY 2>>
		<SETG AWAITING-REPLY 4>
		<TELL "You? Take a memo?" CR>)>>

<GLOBAL OFFICE-C 0>

<ROUTINE I-OFFICE ()
	 <COND (<FSET? ,OFFICE-DOOR ,RMUNGBIT>
		<FCLEAR ,OFFICE-DOOR ,RMUNGBIT>
		<RFALSE>)>
	 <SETG OFFICE-C <+ ,OFFICE-C 1>>
	 <COND (<EQUAL? ,OFFICE-C 1>
		<TELL CR 
"Below you, the " D ,OFFICE-DOOR " swings open and then closed." CR>)
	       (<EQUAL? ,OFFICE-C 4>
		<COND (<EQUAL? ,HERE ,OFFICE>
		       <COND (<AND <VERB? OPEN>
				   <PRSO? ,OFFICE-DOOR>>
			      <TELL "You hesitate as you ">)
			     (T
		       	      <TELL CR "You ">)>
		       <TELL 
"hear footsteps and hushed voices approaching the wagon." CR>)
		      (T
		       <MUNRAB-ENTERS-OFFICE>)>) ;"can only be on-wagon?" 
	       (<G? ,OFFICE-C 4>
		<COND (<EQUAL? ,HERE ,OFFICE>
		       <COND (<OR <EQUAL? ,OFFICE-C 12>
				  <NOT <FSET? ,OFFICE-DOOR ,LOCKEDBIT>>>
			      <BARGE-OFFICE>
			      <RTRUE>)
		             (<OR <EQUAL? ,OFFICE-C 5 7 9>
				  <EQUAL? ,OFFICE-C 11>>
		       	      <TELL CR "You can hear someone outside ">
			      <COND (<NOT <EQUAL? ,OFFICE-C 5>>
				     <TELL "still ">)>
			      <TELL "trying to force open the door." CR>)>)
		      (T
	               <MUNRAB-ENTERS-OFFICE>
		       <RTRUE>)>)>>

<ROUTINE MUNRAB-ENTERS-OFFICE ("OPTIONAL" (DOWN-LADDER? <>))
	<DISABLE <INT I-OFFICE>>
	<MOVE ,MUNRAB ,OFFICE>
	<FSET ,OFFICE-DOOR ,LOCKEDBIT>
	<FCLEAR ,DESK ,RMUNGBIT>
	<FSET ,PANEL ,RMUNGBIT>
	<COND (.DOWN-LADDER?
	       <TELL
D ,MUNRAB " reappears out of the darkness and quickly enters the " D ,WAGON 
" just as you scramble down the ladder." CR CR>
	       <FCLEAR ,PANEL ,OPENBIT>
	       <RTRUE>)
	      (T
	       <TELL CR
"You can hear someone, presumably " D ,MUNRAB ", barge into the office">
	       <COND (<FSET? ,PANEL ,OPENBIT>
	       	      <TELL 
". By remote control he slides the " D ,PANEL " closed">)>
	       <FCLEAR ,PANEL ,OPENBIT>
	       <TELL ,PERIOD>)>>

<ROUTINE BARGE-OFFICE ()
	 <TELL CR 
D ,MUNRAB " suddenly barges into the office; he's shakily gripping a small
caliber pistol. ">
	 <JIGS-UP 5 "A shot rings out.">>

<OBJECT OFFICE-DOOR
	(IN LOCAL-GLOBALS)
	(DESC "office door")
	(SYNONYM DOOR LOCK)
	(ADJECTIVE OFFICE)
	(FLAGS NDESCBIT DOORBIT LOCKEDBIT VOWELBIT)
	(ACTION OFFICE-DOOR-F)>

<ROUTINE OFFICE-DOOR-F ()
	 <COND (<AND <VERB? EXAMINE>
		     <EQUAL? ,HERE ,OFFICE>>
		<TELL "It is lockable from this side." CR>)
	       (<AND <VERB? OPEN LOCK UNLOCK>
		     <EQUAL? ,HERE ,ON-WAGON>>
		<NO-POSITION>
		<RTRUE>)
	      (<AND <VERB? OPEN>     ;"You hesitate - handled by I-OFFICE"
		    <NOT <FSET? ,OFFICE-DOOR ,LOCKEDBIT>>
		    <EQUAL? ,HERE ,OFFICE>
		    <RUNNING? ,I-OFFICE>
		    <L? ,OFFICE-C 4>>
	       <SETG OFFICE-C 3>
	       <RTRUE>)                 
	      ;(<AND <VERB? OPEN UNLOCK> ;"In I-OFFICE if door is unlocked" 
		    <G? ,OFFICE-C 5>
		    <RUNNING? ,I-OFFICE>>
	       <BARGE-OFFICE>)
	      ;(<AND <VERB? LOCK UNLOCK>
		     <NOT <EQUAL? ,HERE ,OFFICE>>> 
		<PRE-LOCK>)
	       (<VERB? KNOCK>
		<COND (<FSET? ,OFFICE ,TOUCHBIT>
		           ;<AND <EQUAL? ,HERE ,NEAR-WAGON>
				<FSET? ,OFFICE-DOOR ,RMUNGBIT>>
		       <RFALSE>)
		      (<IN? ,MUNRAB ,ON-WAGON>
		       <COND (<EQUAL? ,HERE ,ON-WAGON>
		       	      <FCLEAR ,OFFICE-DOOR ,LOCKEDBIT>
		       	      <MOVE ,MUNRAB ,LOCAL-GLOBALS>
		       	      <ENABLE <QUEUE I-OFFICE -1>>
		       	      <TELL
"Below you "D ,MUNRAB " very cautiously steps outside and begins poking around,
closing the door behind him. He wanders into the darkness." CR>)
		       	     (<NOT <FSET? ,OFFICE-DOOR ,RMUNGBIT>>
			      <FSET ,OFFICE-DOOR ,RMUNGBIT>
		              <ENABLE <QUEUE I-OFFICE 4>>
		              <TELL 
D ,MUNRAB " pops his head out of his office, scowls at you for a moment,
then withdraws, shutting the door." CR>)>)>)>>

<ROUTINE CLIMB-PANEL ()
	 <TELL
"You climb onto the desk, and hoist yourself through the panel opening."CR CR>>

<GLOBAL NOT-REACH " able to reach the opening">

<ROUTINE UP-OFFICE ()
	 <COND (<FSET? ,DESK ,RMUNGBIT>
		<SETG OFFICE-C 5>     ;"this move munrab enters in I-OFFICE"
		<CLIMB-PANEL>
		<RETURN ,ON-WAGON>)
	       (,END-GAME
		<V-DIG>
		<RFALSE>)
	       (T
		<TELL "You're not" ,NOT-REACH "." CR>
		<RFALSE>)>>

<OBJECT OFFICE-OBJECT
	(IN LOCAL-GLOBALS)
	(DESC "office")
	(SYNONYM OFFICE)
	(ADJECTIVE MUNRAB)
	(FLAGS NDESCBIT VOWELBIT)
	(ACTION OFFICE-OBJECT-F)>

<ROUTINE OFFICE-OBJECT-F ()
	 <COND (<AND <EQUAL? ,HERE ,ON-WAGON>
		     <NOT <FSET? ,PANEL ,OPENBIT>>>
		<PERFORM ,V?EXAMINE ,PANEL>
		<RTRUE>)
	       (<AND <VERB? LOCK UNLOCK OPEN CLOSE>
		     <PRSO? ,OFFICE-OBJECT>
		     <EQUAL? ,HERE ,OFFICE>>
		<PERFORM ,PRSA ,OFFICE-DOOR ,PRSI>
		<RTRUE>)
	       (<AND <VERB? LOOK-INSIDE>
		     <EQUAL? ,HERE ,ON-WAGON>>
		<PERFORM ,V?LOOK-INSIDE ,PANEL>
		<RTRUE>)
	       (<AND <EQUAL? ,HERE ,OFFICE>
		     <VERB? DISEMBARK>>
		<DO-WALK ,P?UP>)
	       (<EQUAL? ,HERE ,OFFICE>
		<GLOBAL-ROOM-F>)>>
		
<OBJECT DESK
	(IN OFFICE)
	(DESC "cherry-hardwood desk")
	(SYNONYM DESK DRAWER)
	(ADJECTIVE HARDWOOD CHERRY ;EXPANSIVE DESK)
	(FLAGS NDESCBIT CONTBIT OPENBIT TRANSBIT SURFACEBIT LOCKEDBIT)
	(CAPACITY 200)
	(ACTION DESK-F)>
  
;"RMUNGBIT = desk has been moved "

<ROUTINE DESK-F ()
	 <COND (<VERB? CLIMB-ON BOARD STAND-ON>
		<COND (<FSET? ,DESK ,RMUNGBIT>
		       <CLIMB-PANEL> 
		       <GOTO ,ON-WAGON>)
		       (T
			<TELL 
"You would not be" ,NOT-REACH  " from where the desk is." CR>)>)	       
	       (<OR <VERB? OPEN LOOK-INSIDE CLOSE>
		    <AND <VERB? EXAMINE>
			 <IS-NOUN? ,W?DRAWER>>>
		<TELL "The drawers are all locked up." CR>)
	       (<VERB? EXAMINE LOOK-ON SEARCH>
		<TELL
"The desk is blanketed with a flurry of memos, on top of which rest">
		<COND (<EQUAL? <CCOUNT ,DESK> 1>
		       <TELL "s">)>
		<PRINT-CONTENTS ,DESK>
		<TELL ,PERIOD>)
	       (<OR <VERB? PUSH MOVE>
		    <AND <VERB? PUT-UNDER>
			 <EQUAL? ,PRSI ,PANEL>>>
		<COND (<OR ,END-GAME
		           <FSET? ,DESK ,RMUNGBIT>>
		       <V-DIG>)		      
		      (T
		       <FSET ,DESK ,RMUNGBIT>
		       <TELL
"With all your weight behind it, the desk screeches across the floor to
a position under the " D ,PANEL "." CR>)>)>>

<OBJECT CHAIR
	(IN OFFICE)
	(DESC "chair")
	(SYNONYM CHAIR)
	(FLAGS VEHBIT TRYTAKEBIT CONTBIT SURFACEBIT NDESCBIT OPENBIT)
	(ACTION CHAIR-F)>

<ROUTINE CHAIR-F ("OPTIONAL" (RARG <>))
	 <COND (.RARG
		<RFALSE>)
	       (<VERB? OPEN CLOSE>
		<CANT-OPEN>)
	       (<AND <VERB? PUT-ON>
		     <PRSI? ,CHAIR>>
		<V-DIG>)
	       (<OR <AND <PRSO? ,CHAIR>
		         <VERB? MOVE PUSH>>
		    <AND <VERB? PUT-UNDER>
			 <PRSI? ,PANEL>>>
		<TELL 
"You wouldn't be" ,NOT-REACH " from the " D ,CHAIR "." CR>)>>
		       
<OBJECT DESK-ON-WAGON
	(IN ON-WAGON)
	(DESC "desk")
	(SYNONYM DESK)
	;(ADJECTIVE)
	(FLAGS NDESCBIT)
	(ACTION DESK-ON-WAGON-F)>

;"RMUNGBIT = will give hint in STARTLE-MUNRAB"

<ROUTINE DESK-ON-WAGON-F ()
	 <COND (<NOT <FSET? ,PANEL ,OPENBIT>>
		<CANT-SEE ,DESK-ON-WAGON>)
	       (<AND <VERB? PUT-ON PUT THROW>
		     <PRSI? ,DESK-ON-WAGON>>
		<STARTLE-MUNRAB>)
	       (<TOUCHING? ,DESK-ON-WAGON>
		<CANT-REACH ,DESK-ON-WAGON>)>>

<ROUTINE STARTLE-MUNRAB ()
	 <TELL 
"You hesitate, fearful of startling a man who's experiencing the kind of
pressure that " D ,MUNRAB " is under. ">
	 <COND (<FSET? ,DESK-ON-WAGON ,RMUNGBIT>
		<TELL 
"There must be another way of getting him out from behind his desk and
drawing him out of the " D ,WAGON ".">)>
	 <CRLF>
	 <FSET ,DESK-ON-WAGON ,RMUNGBIT>
	 <RTRUE>>

<OBJECT DEGREE 
	(IN OFFICE)
	(DESC "diploma")
        (SYNONYM SHEEPSKIN DIPLOMA)
        (ADJECTIVE FRAMED)
	(FLAGS NDESCBIT)
	(ACTION DEGREE-F)>

<ROUTINE DEGREE-F ()
	 <COND (<VERB? EXAMINE READ>
		<TELL "It's an MBA from Harvard Business School." CR>)>>

<OBJECT BOOKS 
	(IN OFFICE)
	(DESC "shelf of books")
        (SYNONYM SHELF BOOKS BOOK BIOGRAPHIES)
        (FLAGS NDESCBIT TRYTAKEBIT)
	(ACTION BOOKS-F)>

;"Mention in browsie that he went to Harvard B.S."
<ROUTINE BOOKS-F ()
	 <COND (<VERB? EXAMINE>
		<TELL
"There are biographies on Walt Disney and Benito Mussolini, a treatise by 
Machiavelli, and a copy of \"What They Don't Teach You at Harvard Business
School.\"" CR>)
	       (<VERB? OPEN READ TAKE>
		<V-DIG>)>> 

<OBJECT BURNED-CAGE
	(IN BACK-YARD)
	(DESC "burned cage")
	(SYNONYM CAGE BOOTH)
	(ADJECTIVE FIRE-DAMAGED VERTICAL)
	(FLAGS NDESCBIT ;CONTBIT ;OPENBIT ;TRANSBIT ;SURFACEBIT)
	(ACTION BURNED-CAGE-F)>

;"RMUNGBIT is set when on Back-yard M-enter, when I-CLOWN-EXIT starts"

<ROUTINE BURNED-CAGE-F ()
	 <COND (<VERB? LOOK-INSIDE>
	        ;<COND (<IN? ,GUARD ,LOCAL-GLOBALS>
		       <MOVE ,GUARD ,HERE>)>
		<TELL ,YOU-SEE 
" the silhouette of a man sitting quietly in semidarkness." CR>)
	       (<AND <VERB? PUT>
		     <PRSI? ,BURNED-CAGE>>
		<TELL "The guard hands">
		<ARTICLE ,PRSO T>
		<TELL " back to you." CR>)
	       (<VERB? EXAMINE>
		<TELL 
"The fire-damaged cage, perhaps once the home of some big jungle cat, has been
converted into some kind of vertical booth." CR>)
	       (<VERB? OPEN ENTER BOARD THROUGH>
	        <TELL 
"Your attempt merely rattles the cage, and the " D ,GUARD " growls at you to
back off." CR>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<GLOBAL GUARD-C 0>

<OBJECT GUARD
	(IN BACK-YARD)
	(DESC "guard")
	(SYNONYM GUARD HARRY SILHOETTE MAN)
	;(ADJECTIVE MR)
	(FLAGS ACTORBIT NDESCBIT PERSON CONTBIT SEARCHBIT OPENBIT)
	(ACTION GUARD-F)>

;"rmungbit = guard told you about being a first of may, cant talk to others"

<ROUTINE GUARD-F ()
      	 <COND (<AND <TALKING-TO? ,GUARD>
		     <NOT <VERB? WAVE-AT ALARM>>
		     <ENABLED? ,I-HELIUM>>
		<SETG SCORE <+ ,SCORE 10>>
		<SETG SPEAK-HELIUM T>
		<ENABLE <QUEUE I-TURNSTILE 2>>
	        <TELL 
"The sound of your high-pitched, lighter-than-air voice is startling to "
D ,ME ", but very familiar to the " D ,GUARD ". You can hear an
electromechanical buzzing sound from the " D ,TURNSTILE "." CR> 
		<STOP>)
	       (<EQUAL? ,GUARD ,WINNER>
                <COND (<AND <VERB? TELL-ABOUT>
	                    <PRSO? ,ME>>			   
	               <SETG WINNER ,PROTAGONIST>
	               <PERFORM ,V?ASK-ABOUT ,GUARD ,PRSI>
	               <SETG WINNER ,GUARD>
	               <RTRUE>)
		      (<VERB? WHO WHAT>
		       <SETG WINNER ,PROTAGONIST>
		       <PERFORM ,V?ASK-ABOUT ,GUARD ,PRSO>
		       <SETG WINNER ,GUARD>
		       <RTRUE>)
		      (<AND <VERB? RUB>
		       	    <HELD? ,PRSO ,PROTAGONIST>>
		       <SETG WINNER ,PROTAGONIST>
		       <PERFORM ,V?GIVE ,PRSO ,GUARD>
		       <SETG WINNER ,GUARD>
		       <RTRUE>)
		      (<AND <VERB? WHERE>
			    <PRSO? ,GIRL>>
		       <SETG WINNER ,PROTAGONIST>
		       <PERFORM ,V?ASK-ABOUT ,GUARD ,PRSO>
		       <SETG WINNER ,GUARD>
		       <RTRUE>)
		      (<VERB? HELLO THANK>
	               <SETG WINNER ,PROTAGONIST>
	               <PERFORM ,PRSA ,GUARD>
	               <SETG WINNER ,GUARD>
	               <RTRUE>)
		      (<AND <VERB? YES>
			    <EQUAL? ,AWAITING-REPLY 6>>
		       <V-YES>)
		      (<AND <VERB? NO>
			    <EQUAL? ,AWAITING-REPLY 6>>
		       <V-NO>)
		      (T 
		       <TELL "The guard just sits quietly in his cage." CR>
		       <STOP>)>)
	      (<AND <VERB? KISS>
		    <FSET? ,PINK-BOX ,RMUNGBIT>>
	       <TELL "Of course, he's your blind date." CR>)
	      (<HURT? ,GUARD>
	       <JIGS-UP 5  
"You are suddenly skewered by a white cane honed to needle-sharpness.">)
	      (<VERB? EXAMINE>
	       <TELL 
,YOU-SEE " the shadowy outline of a man who's wearing a dark " D ,SUNGLASSES
"." CR>)
	      (<AND <VERB? GIVE>
	       	    <PRSI? ,GUARD>>	       
	       <COND (<PRSO? ,WHIP>
		      <PERFORM ,V?ASK-ABOUT ,GUARD ,WHIP>
		      <RTRUE>)
		     (<PRSO? ,GIRL ,THUMB>
		      <TELL "The " D ,GUARD " refuses " D ,PRSO "." CR>)
		     (<TRAP-SET?>
		      <TELL 
"Harry must've smelled a rat, since he rejects your offer out of hand,
thereby putting a damper on your sadistic glee." CR>)
		     (T
		      <TELL 
"While you're still holding">
	       	      <ARTICLE ,PRSO T>
	       	      <TELL 
", the guard moves his hands gently over it and says, ">
	       	      <COND (<PRSO? ,CASE>
		      	     <SETG GUARD-FELT-CASE T>
		      	     <TELL 
"\"Oh, that's Andrew's " D ,CASE ". He's one to steal a smoke now and then;
behind Jenny's back, of course. She'd kill him if she ever found out.\"" CR>)
		     	   (T	
		      	    <TELL "\"Feels like">		
	       	      	    <COND (<EQUAL? ,PRSO ,SHEET>
				   <TELL " paper">)
			          (<EQUAL? ,PRSO ,TAFT>
				   <TELL " cardboard">)
				  (T
				   <ARTICLE ,PRSO>)>
	       	      	    <TELL " to me.\"" CR>)>)>)
	      (<AND <VERB? SHOW>
		    <NOT <EQUAL? ,PRSO ,MUSIC ,RADIO ,HEADPHONES>>
		    <PRSI? ,GUARD>>
	       <TELL
"Not surprisingly, the " D ,GUARD " is oblivious to">
	       <ARTICLE ,PRSO T>
	       <TELL ,PERIOD>)
	      (<VERB? THANK>
	       <TELL "The " D ,GUARD " nods slowly." CR>)
	      (<VERB? HELLO>
	       <TELL "\"Well, good evening to you.\"" CR>)
	      (<AND <VERB? ASK-ABOUT>
		    <PRSO? ,GUARD>>
	       <COND (<PRSI? ,GIRL>
		       <COND (<FSET? ,PROTAGONIST ,RMUNGBIT> ;"won puzzle"
		       	      <TELL "The " D ,GUARD " remains silent." CR>)
		      	     (T
		       	      <ENABLE <QUEUE I-DID 2>>
		       	      <SETG AWAITING-REPLY 6>
		       	      <TELL
"\"But you already asked me about her, right?\"" CR>)>)
		     (<PRSI? ,FAT>
		      <TELL
"\"Well, she's tried various diets, but then " D ,MUNRAB " orders our "
D ,JIM " to increase the frequency of her feedings." CR>)
		     (<PRSI? ,HYP>
		      <TELL 
"\"" D ,HYP "? Harrumph. Don't waste your money.\"" CR>)
		     (<PRSI? ,THUMB>
		      <TELL
"\"A very popular attraction, small but charismatic.\"" CR>)
		     (<PRSI? ,TAMER>
		      <TELL 
"\"Nothing but a glory hog, and always just one step ahead of the ASPCA.\""
CR>) 
		     (<AND <PRSI? ,JOEY>
			   <NOT <FSET? ,JOEY ,RMUNGBIT>>>
		      <FSET ,JOEY ,RMUNGBIT>
		      <TELL
"\"A very accomplished performer, takes a lot of pride in his craft.
Until...\" The " D ,GUARD " stops himself." CR>)  
		     (<PRSI? ,CIRCUS ,MUNRAB>
		      <COND (<FSET? ,CIRCUS ,RMUNGBIT>
			     <TELL "\"I've given my opinion.\"" CR>)
			    (T
			     <FSET ,CIRCUS ,RMUNGBIT>
			     <TELL 
"He suddenly blurts out, \"Well I can tell you this is one circus that's
headed for the barn. It's that doggone " D ,MUNRAB " and his vainglorious
dreams. They're not panning out for him, and the more he puts the squeeze
on all of us, the more dangerous this lot becomes.\"" CR>)>) 
		     (<PRSI? ,HERM ,ANDREW ,JENNY>
		      <COND (<NOT <FSET? ,HERM ,RMUNGBIT>>
			     <FSET ,HERM ,RMUNGBIT>
			     <COND (<PRSI? ,JENNY>
				    <TELL "\"She">)
				   (T
				    <TELL "\"He">)>
			     <TELL 
" ... er, they ... uh, whatever it is -- bizarre is all I can say. You'd
swear they were two different people.\"" CR>)
			    (T
			     <TELL
"\"" D ,ANDREW "'s always considered " D ,JENNY " a thorn in his side. Of
course, " D ,JENNY "'s always trying to keep him on the straight and narrow.
Which is cherry pie, considering this is the circus life and all.\"" CR>)>) 
		     (<PRSI? ,JIM ,JIM-GLOBAL>
		      <TELL
"\"Yea, sad story. Just another guy who fell out the social safety net, if
you will, and landed in the circus. And not on his feet either. So " D ,MUNRAB
" overworks him, has him living in a cage. That's the life here, that's the
circus life for the most.\"" CR>) 
		     (<PRSI? ,BURNED-CAGE>
	              <TELL "\"It's home.\"" CR>)
		     (<PRSI? ,EDDIE>
	              <COND (<NOT ,SEEN-SHEET>
			     <TELL "You don't know anyone by that name." CR>)
			    (T
			     <FSET ,EDDIE ,RMUNGBIT>
		      	     <TELL
"\"That's " D ,JOEY "'s real name.\"" CR>)>)
		     (<PRSI? ,BULL> ;"OR an elephant is like a rope ..."
		      <TELL
"\"Very funny. Asking someone in my condition to describe an " D ,BULL ".\""
CR>)
		     (<PRSI? ,APE>
		      <TELL
"\"" D ,APE "? I used to work with him. You know you could practically put him
to sleep with soft music. That's how he got his name. Along with his
mean streak too, of course. In fact I used to play the violin for him at
night after all the towners would go home. That was the old days.\"" CR>)
		    (<PRSI? ,CON>
		     <TELL
"\"He used to sell Amway. Then he joined on here as a Monday Man, which is
where he got his name. All that was before Munrab, of course.\"" CR>)
		    (<PRSI? ,LION-NAME ,ELSIE ,NIMROD ,WHIP ,GUARD ,SUNGLASSES>
		     <COND (<FSET? ,LION-NAME ,RMUNGBIT>
			    <TELL 
"\"I would rather not talk any further about my past life with the
lions.\"" CR>)
			   (T
			    <FSET ,LION-NAME ,RMUNGBIT>
			    <TELL 
"After a moment of tense silence, the guard impulsively tears off his
sunglasses and thrusts his head forward into the light. You flinch at the
sight of a slashing scar which engulfs both eye sockets.| 
|
The guard calms back down. \"Nimrod did this to me. He refuses the
whip, unlike Elsie, who is controlled only by the whip.\"" CR>)>)
		      (T
		       <TELL "\"I really can't say.\"" CR>
		       <RTRUE>)>
	       <SETG GUARD-C <+ ,GUARD-C 1>>
	       <COND (<AND <NOT <FSET? ,GUARD ,RMUNGBIT>>
			   <G? ,GUARD-C 2>			   
			   <NOT <ENABLED? ,I-DID>>
			   <NOT <PRSI? ,LION-NAME ,NIMROD ,ELSIE>>>
		      <FSET ,GUARD ,RMUNGBIT> 
		      <TELL CR 
"The guard breathes a sigh, and continues, \"I don't need eyeballs to size
up a First of May like you. Listen to me, if you think you're going to sport
around the lot asking a bunch of questions and expect answers, forget
it. These people are in no mood for lot loafers.\"" CR>)>
	       <RTRUE>)>>

<GLOBAL SPEAK-HELIUM <>>

<OBJECT SUNGLASSES
	(IN GUARD)
	(DESC "pair of sunglasses")
	(SYNONYM PAIR SUNGLASSES GLASSES SHADES)
	(ADJECTIVE ;RECTANGULAR DARK)
	(FLAGS NDESCBIT TRYTAKEBIT)
	(ACTION SUNGLASSES-F)>

<ROUTINE SUNGLASSES-F ()
	 <COND (<VERB? TAKE>
		<TELL "You can't, since that would be blind theft." CR>)>>

<OBJECT TURNSTILE
	(IN LOCAL-GLOBALS)
	(DESC "turnstile")
	(SYNONYM TURNSTILE STILE)
	(ADJECTIVE TURN)
	(FLAGS NDESCBIT)
	(ACTION TURNSTILE-F)>

<ROUTINE TURNSTILE-F ()
	 <COND (<VERB? EXAMINE>
		<TELL
"It's the fish skeleton type, with three sets of horizontal ribs extending from
a vertical spine.">
		<COND (<EQUAL? ,HERE ,CON-AREA>
		       <TELL 
" Built into the " D ,TURNSTILE " is a " D ,SLOT ".">)>
		<CRLF>)
	       (<AND <VERB? PUT>
		     <PRSO? TICKET>>
		<COND (<EQUAL? ,HERE ,CON-AREA>
		       <PERFORM ,V?PUT ,TICKET ,SLOT>
		       <RTRUE>)
		      (T
		       <CANT-SEE <> "the slot">)>)
	       (<VERB? CLIMB-OVER CLIMB-ON CLIMB-UP CLIMB-FOO LEAP>
		<TELL "You cannot scale the " D ,TURNSTILE "." CR>)
	       (<VERB? OPEN SET PUSH THROUGH WALK-TO MOVE>
		<COND (<EQUAL? ,HERE ,EAST-CAMP>
		       <DO-WALK ,P?NORTH>)
		      (<EQUAL? ,HERE ,BACK-YARD>
		       <DO-WALK ,P?SOUTH>)
		      (<EQUAL? ,HERE ,CON-AREA>
		       <DO-WALK ,P?EAST>)
		      (<EQUAL? ,HERE ,MIDWEST>
		       <DO-WALK ,P?WEST>)>)>>

<OBJECT PSEUDO-TURNSTILE     ;"so can have a descfcn, turnstile is in loc-glo"
	(IN BACK-YARD)
	(DESC "turnstile")
	(SYNONYM SKELETON)
	(ADJECTIVE FISH)
	(DESCFCN PSEUDO-TURNSTILE-DESC)
	;(FLAGS NDESCBIT)
	(ACTION TURNSTILE-F)>

<ROUTINE PSEUDO-TURNSTILE-DESC ("OPTIONAL" X)
	 <TELL
"Adjacent to the turnstile to your south is a vertical cage.">>

<OBJECT SLOT
	(IN LOCAL-GLOBALS)
	(DESC "narrow slot")
	(SYNONYM SLOT HOLE)
	(ADJECTIVE NARROW)
	(FLAGS NDESCBIT CONTBIT OPENBIT)
	(ACTION SLOT-F)>

<ROUTINE SLOT-F ()
	 <COND (<EQUAL? ,HERE ,MIDWEST>
		<TELL 
"The slot's on the other side of the " D ,TURNSTILE "." CR>)
	       (<AND <VERB? PUT>
		     <PRSI? ,SLOT>>
		<COND (<PRSO? ,PINK-BOX ,BLUE-BOX>
		       <RFALSE>)
		      (<PRSO? ,TICKET>		       
		       <TELL 
"You feed " D ,TICKET " into the slot ">
		       <COND (<OR <FSET? ,BLUE-BOX ,RMUNGBIT>
				  <FSET? ,PINK-BOX ,RMUNGBIT>>
			      <ENABLE <QUEUE I-TURNSTILE 2>>
			      <TELL 
"and hear all kinds of internal computations being made, then the ticket rolls
out into " D ,HANDS "." CR>) 
			     (T
			      <TELL 
"but it's immediately rejected. Perhaps you didn't follow the directions
on the ticket." CR>)>)
		       (T
		        <TELL "The slot is not configured to accept">
		        <ARTICLE ,PRSO T>
			<TELL ,PERIOD>)>)
		(<VERB? EXAMINE>
		 <TELL "The " D ,SLOT " is a few inches long." CR>)
	        (<VERB? LOOK-INSIDE>
		 <TELL "It's dark." CR>)
		(<VERB? OPEN CLOSE>
		 <V-COUNT>)>>
		        
<ROUTINE I-TURNSTILE ()
	 <DISABLE <INT I-TURNSTILE>>
	 <COND (<EQUAL? ,HERE ,BACK-YARD ,CON-AREA>
		<TELL CR "The " D ,TURNSTILE " goes \"click.\"" CR>)>
	 <RFALSE>>

<ROUTINE TURNSTILE-EXIT ()
	 <COND (<OR <ENABLED? ,I-TURNSTILE>
		    <EQUAL? ,HERE ,EAST-CAMP ,MIDWEST>>
	        <COND (<AND <NOT <FSET? ,CANVAS ,RMUNGBIT>>
			    <EQUAL? ,HERE ,EAST-CAMP>>
		       <COND (<NOT <FSET? ,PSEUDO-TURNSTILE ,RMUNGBIT>>
			      <FSET ,PSEUDO-TURNSTILE ,RMUNGBIT>
			      <TELL
"The image of a burning bridge suddenly pops into your mind as you
veer away from the " D ,TURNSTILE "." CR>
			      <RFALSE>)>)>		 	      
		<TELL-PASS-TURNSTILE>
		<COND (<EQUAL? ,HERE ,BACK-YARD>
		       <RETURN ,EAST-CAMP>)
		      (<EQUAL? ,HERE ,EAST-CAMP>
		       <RETURN ,BACK-YARD>)
		      (<EQUAL? ,HERE ,MIDWEST>
		       <RETURN ,CON-AREA>)
		      (T
		       <RETURN ,MIDWEST>)>)
	       (T
		<TELL 
"The " D ,TURNSTILE " won't budge." CR>
		<RFALSE>)>>

<ROUTINE TELL-PASS-TURNSTILE ()
	 <TELL "You pass through the creaky " D ,TURNSTILE>
	 <COND (<AND <RUNNING? ,I-CLOWN-EXIT>
		     <NOT <IN? ,THUMB ,CLOWN-ALLEY>>>
		<SETG CLOWN-EXIT-COUNTER 7>
		<TELL " right behind a scrambling " D ,THUMB>)>
	 <TELL "." CR CR>>

<ROOM PROP-ROOM
      (IN ROOMS)
      (DESC "Inside Prop Tent")
      (EAST PER EXIT-PROP-ROOM)
      (OUT PER EXIT-PROP-ROOM)
      (SOUTH PER PLEAT-EXIT)
      (FLAGS ONBIT RLANDBIT INDOORSBIT)
      (ACTION PROP-ROOM-F)
      (GLOBAL CANVAS TENT)>

<ROUTINE PROP-ROOM-F (RARG)
	 <COND (<EQUAL? .RARG ,M-ENTER>
		<COND (<EQUAL? ,MEET-COUNTER 0>		            
		       <ENABLE <QUEUE I-MEET 1>>)>
		<COND (<AND <NOT <FSET? ,MOUSE ,TOUCHBIT>>
			    <FSET? ,TRAP ,TOUCHBIT>
			    <IN? ,CHEESE ,PROP-ROOM>>
		       <MOVE ,CHEESE ,LOCAL-GLOBALS>
		       <TELL 
"You immediately notice that the " D ,CHEESE " you left here is gone." CR CR>
		       <RFALSE>) 
		      (<AND <IN? ,TRAP ,PROP-ROOM>
		       	    <FSET? ,TRAP ,TOUCHBIT>
		       	    <NOT <FSET? ,MOUSE ,TOUCHBIT>>>
		       <MOVE ,MOUSE ,PROP-ROOM>		
		       <COND (<NOT <IN? ,CHEESE ,TRAP>>
		       	      <MOVE ,MOUSE ,LOCAL-GLOBALS>
		       	      <RFALSE>)>
	               <COND (<FSET? ,TRAP ,RMUNGBIT>
		       	      <COND (<FSET? ,CHEESE ,RMUNGBIT> ;"second visit"
			      	     <FSET ,TRAP ,NDESCBIT>)  ;"mouse now seen"
			     	    (T
			      	     <FSET ,CHEESE ,RMUNGBIT>)>) ;"first visit"
      ;"Mouse dies"          (T 
		       	      <COND (<FSET? ,CHEESE ,RMUNGBIT> ;"second visit"
			      	     <FSET ,TRAP ,RMUNGBIT>
		              	     <FCLEAR ,TRAP ,NDESCBIT>
		              	     ;<FCLEAR ,MOUSE ,TRYTAKEBIT>
			      	     <MOVE ,CHEESE ,LOCAL-GLOBALS>
			      	     <MOVE ,MOUSE ,LOCAL-GLOBALS>
		              	     <MOVE ,DEAD-MOUSE ,TRAP>
		              	     <TELL 
"You hear a loud \"SNAP!\" as you enter." CR CR>)
			     	    (T                  ;"first visit trap-set"
			      	     <FSET ,CHEESE ,RMUNGBIT> 
				     ;<MOVE ,MOUSE ,LOCAL-GLOBALS>)>)>)>)
	       (<EQUAL? .RARG ,M-LOOK>
		<TELL
"This dimly lighted tent houses a ragtag collection of outrageous props
and wacky devices, including a midget automobile that's garaged in here.">
		<COND (<FSET? ,CANVAS ,RMUNGBIT>
		       <TELL 
" To the shadowy south is where you passed through the pleats of the " 
D ,CANVAS ".">)>
		<CRLF>)
	       (<EQUAL? .RARG ,M-BEG>
	        <COND (<AND ,HIDING		     
		       	    <RUNNING? ,I-MEET>
		       	    <G? ,MEET-COUNTER 1>
			    <OR <DISTURB? ,MUNRAB>
			   	<DISTURB? ,DICK>
			   	<VERB? WALK STAND DISEMBARK TAKE>>>
	               <END-MEETING>)
		      (<AND <IN? ,MUNRAB ,HERE>
			    <VERB? EXAMINE>
			    <EQUAL? ,PRSO ,MUNRAB ,DICK>>
		       <TELL "You take a peek ... " CR CR>
		       <RFALSE>)>)>>  
	       
<ROUTINE PLEAT-EXIT ()
	 <COND (<RUNNING? ,I-MEET>
		<EXIT-PROP-ROOM>
		<RFALSE>)
	       (<FSET? ,CANVAS ,RMUNGBIT>
		<TELL-PASS-CANVAS>
		<COND (<EQUAL? ,HERE ,WEST-CAMP>
		       <RETURN ,PROP-ROOM>)
		      (T
		       <RETURN ,WEST-CAMP>)>)
	       (<EQUAL? ,HERE ,WEST-CAMP>
		<SETG P-IT-OBJECT ,CANVAS>
		<TELL "You encounter a pleated wall of canvas.">)
	       (T
		<TELL ,CANT-GO>)>      ;"too dark in this corner"
	 	<CRLF>
		<RFALSE>>

<ROUTINE TELL-PASS-CANVAS ()
 	 <COND (<AND <EQUAL? ,MEET-COUNTER 10>
		     <IN? ,TRAP ,LOCAL-GLOBALS>>
		<MOVE ,TRAP ,PROP-ROOM>
		<ENABLE <QUEUE I-HYP 1>>
		<TELL 
"You make your way through the pleats, and just inside the tent you notice
a small " D ,TRAP " on the " D ,GROUND>)
	       (T
		<TELL 
"The rough-hewn canvas is abrasive as you pass through">)>
	 <TELL " ..." CR CR>>

<ROUTINE EXIT-PROP-ROOM ()
	 <COND (<L? ,MEET-COUNTER 7>
		<COND (<OR <RUNNING? ,I-MEET>
			   <EQUAL? ,MEET-COUNTER 0 1>>
		       <COND (<EQUAL? ,MEET-COUNTER 0 1>
		       	      <TELL
"Taft's eyes follow your movement, halting you unsettlingly.">)
		      	     (T
		       	      <TELL 
"Realizing you could be facing trespassing charges, you hesitate.">)>
		       <CRLF>
		       <RFALSE>)>)
	       (T
	        <RETURN ,BACK-YARD>)>>

<OBJECT TRAP
	(IN LOCAL-GLOBALS)
	(SDESC "piece of wood")
	(SYNONYM TRAP PIECE WOOD MOUSETRAP)
	(ADJECTIVE MOUSE SMALL)
	;(FDESC "A small piece of wood lies on the ground.")
	(FLAGS TAKEBIT CONTBIT SURFACEBIT SEARCHBIT TRANSBIT OPENBIT NDESCBIT)
	(SIZE 5)
	(CAPACITY 1)
	(GENERIC GEN-MOUSE-F)
	(ACTION TRAP-F)>

;"RMUNGBIT for TRAP = the killer bar is DOWN, SNAPPED, UNSPRUNG"
;"NDESCBIT for TRAP = Mouse is feeding at it"

<ROUTINE TRAP-F ()
	 <COND (<AND <VERB? EXAMINE LOOK-INSIDE>
		     <FSET? ,TRAP ,TOUCHBIT>>
		<TELL "The " D ,TRAP " is">
		<COND (<FSET? ,TRAP ,RMUNGBIT>
		       <TELL " not">)>
		<TELL " set">
		<COND (<IN? ,CHEESE ,TRAP>
		       <TELL "; there is a bit of cheese in the trap">)
		      (<IN? ,MOUSE ,TRAP>
		       <TELL ". A " D ,DEAD-MOUSE " rests under the bar">)>
		<TELL ,PERIOD>)
	       (<AND <VERB? PUT-ON>
		     <PRSO? ,BUCKET>>
		<COND (<AND <FSET? ,TRAP ,NDESCBIT> ;"mouse feeds"
		       	    <IN? ,MOUSE ,HERE>>
		       <PERFORM ,V?TAKE-WITH ,MOUSE ,BUCKET>
		       <RTRUE>)
		      (T
		       <V-DIG>)>)
	       (<AND <TOUCHING? ,TRAP>
		     <FSET? ,TRAP ,NDESCBIT>>
		<TELL "Blunder of blunders! ">
		<PERFORM ,V?RUB ,MOUSE>		
		<RTRUE>)	       
	       (<OR <AND <VERB? OPEN>
			 <NOT ,PRSI>>
		    <AND <VERB? SET>
			 <NOT ,PRSI>>>
		<COND (<IN? ,MOUSE ,TRAP>
		       <TELL "A " D ,DEAD-MOUSE " is in it!" CR>)
		      (<FSET? ,TRAP ,RMUNGBIT>
		       <FCLEAR ,TRAP ,RMUNGBIT>
		       <TELL "Painstakingly, you set the trap." CR>
		       <RTRUE>)
		      (T
		       <RASH-ACT T>)>)
	       (<AND <VERB? PUT PUT-ON>
		     <PRSO? ,CHEESE>>
		<COND (<FSET? ,TRAP ,RMUNGBIT>
		       <MOVE ,CHEESE ,TRAP>
		       <TELL 
"The " D ,CHEESE " is now clamped into the trap." CR>)
		      (T
		       <RASH-ACT>
		       <RTRUE>)>)
	       (<AND <VERB? TAKE>		     
		     <FSET? ,TRAP ,TOUCHBIT>		     
		     <NOT <FSET? ,TRAP ,RMUNGBIT>>>
		<COND (<EQUAL? <ITAKE> T>
		       <TELL 
"With great care you pick up the loaded " D ,TRAP "." CR>)>
		<RTRUE>)
	       (<AND <TOUCHING? ,TRAP>
		     <NOT <FSET? ,TRAP ,RMUNGBIT>>
		     <NOT <VERB? PUT-ON>>>		
		<PUTP ,TRAP ,P?SDESC "mousetrap">
		<COND (<AND <NOT <VERB? WHIP>>
			    <OR <NOT ,PRSI>
			        <EQUAL? ,PRSI ,HANDS>>>		       
		       <COND (<FSET? ,TRAP ,TOUCHBIT>
		       	      <RASH-ACT>
		       	      <RTRUE>)>
		       <FSET ,TRAP ,RMUNGBIT>
		       <ENABLE <QUEUE I-CURSE -1>>
		       <FSET ,TRAP ,TOUCHBIT>
		       <FCLEAR ,TRAP ,NDESCBIT>
		       <MOVE ,TRAP ,PROTAGONIST>
		       <MOVE ,CHEESE ,TRAP>
		       <TELL ,INSTANT "between the
realization that you've caused " D ,ME " excruciating Pain and the
actual onslaught of such Pain, during which time most people speak with
exclamation points and ... well, say things like ..." CR>
		       <RFATAL>)
		      (T
		       <BACKFLIP>)>)	       
	       (<VERB? CLOSE>
		<COND (<FSET? ,TRAP ,RMUNGBIT>
		       <TELL "It is." CR>)
		      (T
		       <BACKFLIP>)>
		<RTRUE>)>>

<ROUTINE TRAP-SET? ()
	 <COND (<AND <EQUAL? ,PRSO ,TRAP>
	             <NOT <FSET? ,TRAP ,RMUNGBIT>>>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE BACKFLIP ()
	 <COND (<NOT <FSET? ,TRAP ,TOUCHBIT>>
		<MOVE ,CHEESE ,TRAP>)>
	 <FSET ,TRAP ,TOUCHBIT>
	 <FSET ,TRAP ,RMUNGBIT>	 
	 <TELL "\"Snap!\" The ">
	 <COND (<EQUAL? ,PRSO ,TRAP>
		<TELL D ,PRSO>
		<COND (<VERB? PUT>
		       <TELL " touches the side of the " D ,PRSI " and">)>)
	       (T
		<TELL D ,PRSI>)>
	 <TELL " does a backflip ">
	 <COND (<HELD? ,TRAP>
		<TELL "out of " D ,HANDS "s and ">)>
	 <TELL "into the air." CR>
	 <MOVE ,TRAP ,HERE>>
		       
<ROUTINE RASH-ACT ("OPTIONAL" (ALREADY <>))
	 <TELL 
"A rash act, considering the trap is ">
	 <COND (.ALREADY
		<TELL "already ">)>
	 <TELL "loaded." CR>>

<ROUTINE I-CURSE ()
	 <RFALSE>>

;"Used with pick-one"
<GLOBAL COACH
	<LTABLE 0
	"Come on, you can do better than that."
	"No no no -- you must FEEL the role."
	"Come on, your grandmother gets angrier than that."
	"You're just prolonging the agony.">>
	
;"Used with pick-one"
<GLOBAL TOO-DIRTY
	<LTABLE 0
	"Keep in mind this is family entertainment."
	"Easy there! You're jeopardizing our \"G\" rating."  
	"This is a circus, not an Eddie Murphy concert!"
	"Stick to the script -- no more improvising.">>

<OBJECT CHEESE
	(IN LOCAL-GLOBALS)
	(DESC "cheese morsel")
	(SYNONYM CHEESE MORSEL FOOD)
	(ADJECTIVE CHEESE)
	(FLAGS TAKEBIT TRYTAKEBIT EATBIT)
	(SIZE 1)	
	(ACTION CHEESE-F)>

;"CHEESE RMUNGBIT = entered prop-room subsequent to first time after mouse
		    is here. mouse is seen feeding" 

<ROUTINE CHEESE-F ()
	 <COND (<AND <TOUCHING? ,CHEESE>
		     <FSET? ,TRAP ,NDESCBIT>>
		<PERFORM ,V?RUB ,MOUSE>
		<RTRUE>)
	       (<AND <TOUCHING? ,CHEESE>
		     <NOT <FSET? ,TRAP ,RMUNGBIT>>
		     <IN? ,CHEESE ,TRAP>>
		<RASH-ACT>)
	       (<AND <VERB? TAKE>
		     <IN? ,CHEESE ,TRAP>
		     <NOT <FSET? ,TRAP ,RMUNGBIT>>
		     <EQUAL? <ITAKE> T>>
		<TELL 
"With great care, you take the cheese." CR>)
	       (<VERB? EAT>
		<MOVE ,CHEESE ,LOCAL-GLOBALS>
		<TELL 
"Your nose twitches as you nibble away the " D ,CHEESE "." CR>)
	       (<VERB? SMELL>
		<TELL "Camembert, 1979." CR>)>>

<OBJECT MOUSE
	(IN LOCAL-GLOBALS)
	(SDESC "field mouse")
	(SYNONYM MOUSE RODENT)
	(DESCFCN MOUSE-DESC)
	(ADJECTIVE FIELD GREY GRAY)
	(FLAGS TAKEBIT TRYTAKEBIT ;ACTORBIT)
	(SIZE 5)	
	(GENERIC GEN-MOUSE-F)
	(ACTION MOUSE-F)>

<ROUTINE MOUSE-DESC ("OPTIONAL" X)
	 <COND (<FSET? ,TRAP ,NDESCBIT>
		<TELL 
"Over in the " D ,CORNER ", a " D ,MOUSE " gnaws timidly at the " D ,TRAP ".">)
	       (T
		<TELL 
"You can hear the faint scurryings of a rodent somewhere in the tent.">)>>

<GLOBAL MOUSE-PISSED T>

<ROUTINE MOUSE-F ("AUX" X)
	 <COND (<AND <NOT <HELD? ,MOUSE>>
		     <NOT <IN? ,MOUSE ,BUCKET>>
		     <NOT <VERB? LISTEN>>
		     <NOT <FSET? ,TRAP ,NDESCBIT>> ;"trap ndesc when mouse at"
		     <EQUAL? ,HERE ,PROP-ROOM>>
		<CANT-SEE ,MOUSE>)
	       (<VERB? EXAMINE>
		<COND (<IN? ,MOUSE ,PROTAGONIST>
		       <TELL 
"The " D ,MOUSE " calms for a moment, twitches its bewhiskered snout at you,
then continues swimming its forepaws silently into the air." CR>)
		      (<AND <IN? ,MOUSE ,BUCKET>
			    ,MOUSE-PISSED>
		       <TELL 
"It keeps" ,TREADMILL ". That noise is getting to you." CR>)>)
	       (<AND <VERB? GIVE>
		     <PRSO? ,CHEESE>>
		<COND (<IN? ,MOUSE ,PROTAGONIST>
		       <TELL "It's in no position for a feeding." CR>)
		      (T
		       <FEED-MOUSE>)>)
	       (<AND <VERB? TAKE>
		     <IN? ,MOUSE ,BUCKET>>
		<COND (<EQUAL? <ITAKE> T>
		       <SETG MOUSE-PISSED T>
		       ;<FSET ,MOUSE ,TOUCHBIT> ;"done in ITAKE"
		       ;<MOVE ,MOUSE ,PROTAGONIST>
		       <TELL 
"You grasp the slick, narrow tail and lift, feeling the rodent's buzzing
metabolism vibrate at your fingertips." CR>)>
		<RTRUE>)
	       (<AND <NOT <FSET? ,MOUSE ,TOUCHBIT>>
		     <OR <AND <VERB? PUT-ON>
			      <PRSO? ,BUCKET>>
		    	 <AND <VERB? TAKE-WITH TAKE> ;"CATCH _ IN _"
		              <PRSI? ,BUCKET>>>>
		<COND (<IN? ,WATER ,BUCKET>
		       <PERFORM ,V?DROP ,WATER>
		       <CRLF>
		       <PERFORM ,V?RUB ,MOUSE>
		       <RTRUE>)
		      (<SET X <FIRST? ,BUCKET>>
		       <TELL "Tumbling out of your " D ,BUCKET " come">
		       <COND (<NOT <NEXT? .X>>
			      <TELL "s">)>
		       <PRINT-CONTENTS ,BUCKET T>
		       <TELL ,PERIOD>
		       <ROB ,BUCKET ,HERE>
		       <CRLF>
		       <PERFORM ,V?RUB ,MOUSE>
		       <RTRUE>)>
		<FCLEAR ,TRAP ,NDESCBIT>		
		<FSET ,MOUSE ,TOUCHBIT>
	        <SETG SCORE <+ ,SCORE 10>>
		<MOVE ,MOUSE ,BUCKET>
		<TELL
"You can almost hear the tramplings of the world beating a path to your door
as, with a deft swoop of the " D ,BUCKET ", you capture the " D ,MOUSE ".
It immediately begins" ,TREADMILL "." CR>)
	       (<AND <FSET? ,TRAP ,NDESCBIT> ;"second visit"
	             <DISTURB? ,MOUSE>
		     <NOT <HELD? ,MOUSE>>>
		<FCLEAR ,TRAP ,NDESCBIT>
		<MOVE ,MOUSE ,LOCAL-GLOBALS>
		<TELL "By fits and starts the mouse ">
		<COND (<VERB? TAKE>
		       <TELL "eludes " D ,HANDS " and ">)>
		<TELL "makes an exit." CR>)	         
	      (<AND <VERB? DROP THROW PUT PUT-ON GIVE>
		    <PRSO? ,MOUSE>
		    <NOT <PRSI? ,BUCKET>>>
		<MOVE ,MOUSE ,LOCAL-GLOBALS>
		<SCAMPER T>)
	      (<VERB? RUB>
	       <TELL "It nips at " D ,HANDS "." CR>)>>

<ROUTINE FEED-MOUSE ()
	 <MOVE ,CHEESE ,LOCAL-GLOBALS>
	 <SETG MOUSE-PISSED <>>
	 <TELL 
"The mouse gnaws away at the cheese and peeps softly upon finishing it." CR>>

<ROUTINE GEN-MOUSE-F ()
	 ,MOUSE>

<ROUTINE SCAMPER ("OPTIONAL" (HANDED? <>))
	 <TELL "The mouse ">
	 <COND (.HANDED?
		<TELL "scampers out of " D ,HANDS ", ">)>
	 <TELL 
"hits the " D ,GROUND " running and darts out of sight." CR>>

<OBJECT DEAD-MOUSE
	(IN LOCAL-GLOBALS)
	(DESC "dead mouse")
	(SYNONYM MOUSE RODENT)	
	(ADJECTIVE FIELD GREY DEAD)
	(FLAGS TAKEBIT)
	(SIZE 8)	
	(GENERIC GEN-MOUSE-F)>

<OBJECT MASK
	(IN BESIDE-BIGTOP)
	(DESC "clown mask")
	(FDESC 
"A cheap plastic clown mask, having been carelessly dropped here, is
lying face-up on the ground.")
	(SYNONYM MASK)
	(ADJECTIVE CLOWN CHEAP PLASTIC)
	(FLAGS TAKEBIT WEARBIT)
	(SIZE 15)	
	(ACTION MASK-F)>

<ROUTINE MASK-F ()
	 <SETG P-IT-OBJECT ,MASK>	 
	 <COND (<AND <VERB? EXAMINE>
		     <FSET? ,MASK ,WORNBIT>>
		<TELL "You're wearing it!" CR>)
	       (<VERB? WEAR>
	        <COND (<FSET? ,VEIL ,WORNBIT>
		       <WONT-FIT-OVER ,VEIL>
		       <RTRUE>)>
		<PUTP ,PROTAGONIST ,P?ACTION ,PROTAGONIST-HACK-F>
		<FSET ,MASK ,WORNBIT>
		<TELL "You put on the " D ,MASK "." CR>) 
	       (<AND <VERB? LOOK-INSIDE>
		     <FSET? ,MASK ,WORNBIT>>
		<TELL ,YOU-ARE CR>)>>

<OBJECT SUIT
	(IN PROP-ROOM)
	(DESC "gorilla suit")
	(LDESC "Lying here in a heap is a gorilla suit.")
	(SYNONYM SUIT HEAP)
	(ADJECTIVE GORILLA APE ;HEAVY ;ITCHY ;HAIRY)
	(FLAGS TAKEBIT WEARBIT)
	(SIZE 30)
	(ACTION SUIT-F)>

<ROUTINE SUIT-F ()
	 <COND (<AND <VERB? LOOK-INSIDE>
		     <FSET? ,SUIT ,WORNBIT>>
		<PERFORM ,V?LOOK-UNDER ,SUIT>
		<RTRUE>)
	       (<VERB? LOOK-INSIDE>
		<TELL "There's nothing in it." CR>)	       
	       (<AND <VERB? PUT>
		     <PRSI? ,SUIT>>
		<TELL <PICK-ONE ,WASTES> CR>)
	       (<AND <FSET? ,DRESS ,WORNBIT>
		     <VERB? WEAR BOARD>>
		<WONT-FIT-OVER ,DRESS>)
	       (<AND <FSET? ,SHAWL ,WORNBIT>
		     <VERB? WEAR BOARD>>
		<WONT-FIT-OVER ,SHAWL>)
	       (<AND <VERB? WEAR BOARD REMOVE TAKE-OFF DISEMBARK>
		     <FSET? ,SUIT ,WORNBIT>>
		<TELL "You laboriously climb ">
	 	<COND (<VERB? WEAR BOARD>
	       	       <MOVE ,SUIT ,PROTAGONIST>
		       <FSET ,SUIT ,WORNBIT>
		       <TELL "into">)
	       	      (T
		       <FCLEAR ,SUIT ,WORNBIT>
		       <TELL "out of">)>
		<TELL " the heavy, itchy " D ,SUIT "." CR>)
	       (<VERB? EXAMINE>
		<TELL
"It's a 3-H " D ,SUIT " -- heavy, hairy and headless." CR>)>>
		       		      
<OBJECT CAR
	(IN PROP-ROOM)
	(DESC "midget car")
	(SYNONYM CAR AUTO AUTOMOBILE SEAT)
	(ADJECTIVE SMALL MIDGET ;MINIATURE)
	(FLAGS TRYTAKEBIT OPENBIT CONTBIT SEARCHBIT NDESCBIT)	
	(ACTION CAR-F)>

<ROUTINE CAR-F ()
	 <COND (<VERB? OPEN CLOSE>
		<V-COUNT>)
	       (<VERB? EXAMINE SMELL>
		<COND (<NOT <EQUAL? ,P-PRSA-WORD ,W?SMELL>>
		       <TELL
"The tiny car, just a slice of lemon, is in pretty bad shape. ">)>
	        <TELL "It smells of gasoline and burnt oil." CR>)
	       (<AND <PRSI? ,CAR>
		     <VERB? PUT PUT-ON>>
		<V-DIG>)
	       (<VERB? LOOK-INSIDE>
		<TELL 
"It's a one-seater, sporting only an ignition switch on the dash board."
CR>)
	       (<VERB? BOARD THROUGH ENTER CLIMB-ON DRIVE>
		<COND (<FSET? ,CAR ,RMUNGBIT>
		       <TELL ,BASKET-CASE CR>)
		      (T
		       <FSET ,CAR ,RMUNGBIT>
		       <TELL
"Only a basket case or a child would fit in there." CR>)>)
	       (<VERB? LAMP-ON>
		<PERFORM ,PRSA ,SWITCH>
		<RTRUE>)>>

<OBJECT SWITCH
	(IN PROP-ROOM)
	(DESC "ignition switch")
	(SYNONYM SWITCH)
	(ADJECTIVE IGNITION)
	(FLAGS NDESCBIT VOWELBIT)
	(ACTION SWITCH-F)>

<ROUTINE SWITCH-F ()
	 <COND (<VERB? LAMP-ON SET PUSH THROW>
		<COND (<IN? ,MUNRAB ,HERE>
		       <TELL "That surely will get you caught." CR>)
		      (<NOT <FSET? ,SWITCH ,RMUNGBIT>>
		       <FSET ,SWITCH ,RMUNGBIT>
		       <TELL 
"The " D ,CAR " chugs violently for a couple of seconds, lets out a big bang,
then dies." CR>)
		      (<PROB 35>
		       <TELL 
"The " D ,CAR " backfires loudly and comically." CR>)
		      (T
		       <TELL "Nothing happens." CR>)>)>>
		      
<GLOBAL DID-C 0>

<ROUTINE I-DID ()
	 <ENABLE <QUEUE I-DID -1>>
	 <SETG DID-C <+ ,DID-C 1>>
	 <COND (<VERB? YES NO>
		<RFALSE>)
	       (T
		<FCLEAR ,PROTAGONIST ,RMUNGBIT> ;"cant win did puzzle"
		<SETG DID-C 0>
		<SETG AWAITING-REPLY <>>
		<DISABLE <INT I-DID>>)>>
	       
<OBJECT TAFT
	(IN PROP-ROOM)
	(DESC "figure of President Taft")	
	(DESCFCN TAFT-DESC)
	(SYNONYM TAFT PROP CHARACTER FIGURE)
	(ADJECTIVE PRESIDENT WILLIAM HOWARD CARDBOARD)
	(FLAGS TAKEBIT ACTORBIT PERSON)
	(SIZE 50)
	(ACTION TAFT-F)>

<ROUTINE TAFT-DESC ("OPTIONAL" X)
         <TELL "President William Howard Taft is here.">>

;"RMUNGBIT = character is now known as cardboard, not human"

<ROUTINE TAFT-F ()
	 <COND (<AND <VERB? EXAMINE>
		     <NOT <HELD? ,TAFT>>>
		<TELL
"The imposing " D ,TAFT " stands quite still." CR>)
               (<OR <TALKING-TO? ,TAFT>
		    <VERB? WHIP>>
		<TELL 
"He remains silent, unimpeachably frozen." CR>
		<STOP>)
	       (<OR <TOUCHING? ,TAFT>
		    <VERB? WALK-AROUND LOOK-BEHIND>>
	        <COND (<NOT <FSET? ,TAFT ,RMUNGBIT>>
		       <FSET ,TAFT ,RMUNGBIT>
		       <TELL
"Taft wobbles slightly, revealing himself to be nothing but a cardboard
character, a mere prop." CR>)
		      (T
		       <RFALSE>)>)
		(<AND <VERB? HIDE-BEHIND>
		      <NOT ,HIDING>
		      <RUNNING? ,I-MEET>>
		 <HIDE-BEHIND-TAFT>)>> 
		
<ROUTINE HIDE-BEHIND-TAFT ("OPTIONAL" (FORCED <>))
	 <COND (.FORCED
		<TELL "Fear motivates you to">
	        <SETG MEET-COUNTER 7>)
	       (T
	        <TELL "You">
		<SETG MEET-COUNTER 6>)>
	 <COND (<HELD? ,TAFT>
		<MOVE ,TAFT ,HERE>
		<TELL " set Taft down then">)>
	 <SETG HIDING T>
	 <FSET ,TAFT ,NDESCBIT>
	 <TELL " crouch behind the cardboard character." CR>
	 <RTRUE>>

<GLOBAL HIDING <>>

<GLOBAL MEET-COUNTER 0> ;"they ENTER prop-tent on number 7; LEAVE on 9"

<ROUTINE I-MEET ()
	 <ENABLE <QUEUE I-MEET -1>>
	 <FCLEAR ,VOICES ,INVISIBLE>
	 <SETG MEET-COUNTER <+ ,MEET-COUNTER 1>>
	 <COND (<OR <EQUAL? ,MEET-COUNTER 1 3>
	            <EQUAL? ,MEET-COUNTER 6>>
		<TELL CR
"You can hear muffled voices coming from outside"> 
		<COND (<NOT <EQUAL? ,MEET-COUNTER 1>>
		       <TELL ", getting louder and nearer">)>
		<COND (<EQUAL? ,MEET-COUNTER 1>
		       <TELL 
" and see two ominous shadows cast against the side wall of the tent">)>
		<TELL ".">
		<COND (<EQUAL? ,MEET-COUNTER 3>
		       <TELL 
" You feel the childish embarrassment of being trapped.">)>
	       <CRLF>)
	       (<EQUAL? ,MEET-COUNTER 5>
		<TELL CR 
"You hear one voice say, \"Let's duck in here.\"" CR>)
	       (<EQUAL? ,MEET-COUNTER 7>
		<MOVE ,MUNRAB ,PROP-ROOM>
	     	<MOVE ,DICK ,PROP-ROOM>
		<COND (<NOT ,HIDING>
		       <CRLF>
		       <HIDE-BEHIND-TAFT T>)>
	        <TELL CR 
"From behind the " D ,TAFT " you hear footsteps enter the tent, a pause,
then hushed conversation." CR>
		<RTRUE>)
	       (<EQUAL? ,MEET-COUNTER 8>
		<COND (<NOT <AND <VERB? LISTEN>
				 <PRSO? ,VOICES>>>
		       <CRLF>)>
		<TELL 
"\"So, Munrab, what is it? Why have you called me here?\"| 
|
\"Listen, Detective, I've had a terrible day in your lousy little town, so
let me be brief. Receipts have been down all month, tonight's " D ,CON-STAND
" sales were especially small, the towners were tightfisted, they nearly
leveled my grandstand, and on top of that somebody's kidnapped my daughter,
Chelsea. That's where you come in. Here's the most recent picture of her
-- a pretty good likeness in my opinion.\"|
|
\"" D ,MUNRAB ", why are we whispering?\"" CR>)
	       (<EQUAL? ,MEET-COUNTER 9>
		<END-MEETING>)>>
	
<ROUTINE END-MEETING ()
	 <DISABLE <INT I-MEET>>	 
	 <FSET ,VOICES ,INVISIBLE>
	 <FCLEAR ,WINGS ,TOUCHBIT> ;"NEW PASSAGE"
	 <FCLEAR ,TAFT ,NDESCBIT>
	 <COND (<EQUAL? ,MEET-COUNTER 9>
		<COND (<NOT <AND <VERB? LISTEN>
			         <PRSO? ,VOICES>>>
		       <CRLF>)>
		<TELL
"\"I don't know, because it's a mystery I guess. Anyhow, it's not because
I suspect any of my own people here on the lot.\" There's a pause. \"I've
got a pretty loyal crew here. Sure, I work the guys a fair amount, but hey,
no one joins the circus expecting a holiday.\"|
|
Lacking all passion and professionalism, the detective replies, \"I'll
suspect who you want me to suspect. You're paying the bill.\"|
|
\"Here, see, the language of this ransom note clearly shows that it's not
an inside job. Detective, I don't know what kind of crazies are running
loose in this town, but I'm afraid harm might come to my daughter if the
police were to show up. God knows this circus doesn't need that kind of
publicity, anyway. So I'm relying on you and you alone.\"|
|
\"I'd better hold on to that note, Munrab.\"|
|
\"Alright, then get going.\"|
|
You can hear " D ,MUNRAB " and the " D ,DICK " ">)
	       (T
	        <TELL 
D ,MUNRAB " and the " D ,DICK " notice you and they ">)>
	 <TELL "hustle out of the tent">
	 <MOVE ,MUNRAB ,ON-WAGON>	 
	 <MOVE ,DICK ,MIDWEST>
	 <MOVE ,FLASK ,DICK>
	 <MOVE ,TRADE-CARD ,LOCAL-GLOBALS>
	 <COND (<AND ,HIDING
		     <NOT <VERB? STAND>>>
		<TELL ". You stand up.">)
	       (T
		<TELL ".">)>
	 <SETG P-IT-OBJECT ,MUNRAB>
	 <SETG HIDING <>>
	 <SETG MEET-COUNTER 10> ;"I.E., can get to under the stands now"
	 <SETG FOLLOW-FLAG 13>
	 <ENABLE <QUEUE I-FOLLOW 2>>
	 <CRLF>
	 <STOP>>

<OBJECT MUNRAB
	(IN ON-WAGON)
	(DESC "Mr. Munrab")
	(DESCFCN MUNRAB-DESC)
	(SYNONYM MUNRAB OWNER MAN)
	(ADJECTIVE MR CIRCUS)
	(FLAGS ACTORBIT NARTICLEBIT PERSON NDESCBIT OPENBIT CONTBIT SEARCHBIT)
	(ACTION MUNRAB-F)>

;"RMUNGBIT = in end-game told about cost of tightrope"

<ROUTINE MUNRAB-F ()
	 <COND (<EQUAL? ,HERE ,ON-WAGON ,OFFICE>
		<COND (<OR <AND <NOT <FSET? ,PANEL ,OPENBIT>>
			        <TALKING-TO? ,MUNRAB>>
			   <NOT <FSET? ,PANEL ,OPENBIT>>>
		       <CANT-SEE ,MUNRAB>
		       <STOP>)
		      (<OR <DISTURB? ,MUNRAB>
			   <VERB? APPLAUD>>
		       <STARTLE-MUNRAB>
		       <STOP>)>)
	       (<AND <EQUAL? ,HERE ,PROP-ROOM>
		     <TOUCHING? ,MUNRAB>>
		<CANT-REACH ,MUNRAB>)
	       (<AND <VERB? LISTEN>
		     <EQUAL? ,HERE ,PROP-ROOM>>
	        <PERFORM ,V?LISTEN ,VOICES>
	        <RTRUE>)
	       (<VERB? EXAMINE>
		<TELL 
"He gives off the dual expressions of indigestion and indignation." CR>) 
	       (<AND ,END-GAME 
		     <TALKING-TO? ,MUNRAB>>
		<COND (<FSET? ,MUNRAB ,RMUNGBIT>
		       <TELL 
"Completely distraught, " D ,MUNRAB " is now incommunicado." CR>)
		      (T
		       <FSET ,MUNRAB ,RMUNGBIT>
		       <TELL
"\"Hey you, you're gonna pay for this! And do you know the replacement cost
of a tightrope apparatus!\"" CR>)>
	       <STOP>)
	      (<VERB? FOLLOW>
	       <COND (<EQUAL? ,FOLLOW-FLAG 8>
		      <DO-WALK ,P?NE>)
		     (<EQUAL? ,FOLLOW-FLAG 9>
		      <DO-WALK ,P?NORTH>)
		     (<EQUAL? ,FOLLOW-FLAG 13>
		      <DO-WALK ,P?EAST>)>)>>

<ROUTINE MUNRAB-DESC ("OPTIONAL" X)	 
	 <COND (<AND <IN? ,NET ,MUNRAB>
		     <EQUAL? ,HERE ,RING>>
		;<ENABLE <QUEUE I-END-GAME 2>>
		<TELL 
"The " D ,NET " is being held by the motley circle of " D ,MUNRAB ", the " 
D ,JIM ", ">
		<COND (,GANG-HERE
		       <TELL-GROUP>)>
	        ;<COND (<IN? ,GUARD ,HERE>
		       <TELL ", the guard, ">)>
		<TELL "and " D ,THUMB>)
	       (T
		<TELL 
D ,MUNRAB ", pacing pitifully back and forth across the ring, is a complete
wreck">)>
	 <TELL ".">>

<GLOBAL GANG-HERE <>>

<ROUTINE TELL-GROUP ()
	 <TELL 
D ,HERM ", " D ,JOEY ", " D ,HYP ", " D ,CON ", " D ,TAMER " ">>

<OBJECT GANG
	(IN LOCAL-GLOBALS)
	(DESC "group")
	(SYNONYM GROUP CIRCLE COMPANY GAGGLE)
     	(FLAGS ACTORBIT PERSON NDESCBIT)
    	(ACTION GANG-F)>

<ROUTINE GANG-F ()
	 <COND (<TALKING-TO? ,GANG>
		<PERFORM ,V?TELL ,CON>
		<RTRUE>)
	       (<VERB? EXAMINE>
		<TELL "There's " D ,MUNRAB ", the " D ,JIM ", ">
		<TELL-GROUP>
		<TELL "and " D ,THUMB "." CR>)>>

<OBJECT DICK
	(IN LOCAL-GLOBALS)
	(DESC "detective")
      	(DESCFCN DICK-DESC)
	(SYNONYM DICK DETECTIVE MAN DRUNK)
     	(FLAGS ACTORBIT PERSON CONTBIT OPENBIT SEARCHBIT NDESCBIT)
    	(ACTION DICK-F)>

;"RMUNGBIT = dick in bull-room, too sick to respond, needs water"

<ROUTINE DICK-F ()
	 <COND (<AND <NOT ,DICK-DRUNK>
		     <TALKING-TO? ,DICK>
		     <EQUAL? ,HERE ,MIDWEST>>
		<TELL "He just gives you a ">
		<COND (<G? ,DRUNK-COUNTER 2>
		       <TELL "glassy-eyed">)
		      (T
		       <TELL "stern">)>
		<TELL " look and ignores you." CR>
		<STOP>)
	       (<EQUAL? ,WINNER ,DICK>
                <COND (<AND <NOT <FSET? ,DICK ,RMUNGBIT>>
		            <IN? ,NOTE ,GLOBAL-OBJECTS>>
		       <COND (<AND <VERB? GIVE>
			    	   <PRSO? ,NOTE ,TRADE-CARD>
			    	   <PRSI? ,ME>>
		       	      <GET-NOTE>)
			     (<AND <VERB? SGIVE>
			           <PRSO? ,ME>
			           <PRSI? ,NOTE ,TRADE-CARD>>
			      <GET-NOTE>)
			     (<AND <VERB? FIND WHERE>
			    	   <PRSO? ,NOTE ,TRADE-CARD>>
			      <GET-NOTE>)
			     (<AND <VERB? TELL-ABOUT>
				   <PRSO? ,ME>
				   <PRSI? ,NOTE ,TRADE-CARD>>
			      <GET-NOTE>)
			     (T
			      <SETG WINNER ,PROTAGONIST>
			      <PERFORM ,V?HELLO ,DICK>
			      <SETG WINNER ,DICK>
			      <RTRUE>)>)
		      (<VERB? WHERE>
		       <PERFORM ,V?ASK-ABOUT ,DICK ,PRSO>
		       <RTRUE>)
		      (<OR <VERB? HELLO>
			   <AND <VERB? TELL-ABOUT>
	                        <PRSO? ,ME>>>
	               <SETG WINNER ,PROTAGONIST>
	               <PERFORM ,V?ASK-ABOUT ,DICK ,APE> ;"to any default"
	               <SETG WINNER ,DICK>
	               <RTRUE>)	              	
		      (T 
		      <TELL "The " D ,DICK " appears unable to respond." CR>)>)
	      (<AND <EQUAL? ,HERE ,PROP-ROOM>
		    <TOUCHING? ,DICK>>
	       <CANT-REACH ,DICK>)
	      (<AND <OR ,DICK-UNRESPONSIVE
			<FSET? ,DICK ,RMUNGBIT>>
	       	    <VERB? GIVE SHOW>
		    <PRSI? ,DICK>>
	       <PERFORM ,V?ASK-ABOUT ,DICK ,COAT>
	       <RTRUE>)
	      (<AND <VERB? SHOW GIVE>
		    <PRSO? ,RIBBON ,SCRAP ,CASE>>
	       <TELL 
"Not surprisingly, the " D ,PRSO " doesn't ring a bell for the " 
D ,DICK "." CR>)
	      (<AND ,DICK-DRUNK
		    <HURT? ,DICK>>
	       <TELL "You're beating a dead-drunk horse." CR>)
	      (<AND <VERB? ASK-ABOUT ASK-FOR TELL-ABOUT HELLO>
		    <PRSO? ,DICK>>		
	       <COND (<FSET? ,DICK ,RMUNGBIT>
		      <TELL 
"You're having about as much luck as Rimshaw trying to communicate with
the dead, even though the " D ,DICK " still lives on." CR>)
	             (<AND <PRSI? ,TRADE-CARD ,NOTE ,GIRL ,MUNRAB ,CON>
			   <IN? ,NOTE ,GLOBAL-OBJECTS>>
		      <GET-NOTE>)
		     (,DICK-UNRESPONSIVE
		      <TELL 
"Just his attempting to think or speak or move is obviously causing the " 
D ,DICK " great pain." CR>)
		     (T
		      <SETG DICK-UNRESPONSIVE T>
		      <TELL 
"As his jawbone pivots open for speech, some monstrous pain seems to ricochet
off the plates of the " D ,DICK "'s skull. He settles back into the "
D ,SAWDUST "." CR>)>)
	      (<AND <VERB? LISTEN>
		    <EQUAL? ,HERE ,MIDWEST>
		    <NOT ,DICK-DRUNK>>
	       <PERFORM ,V?LISTEN ,VOICES>
	       <RTRUE>)
	      (<VERB? SEARCH>
	       <PERFORM ,V?SEARCH ,COAT>
	       <RTRUE>)
	      (<VERB? SEARCH-OBJECT-FOR>
	       <PERFORM ,V?SEARCH-OBJECT-FOR ,COAT ,PRSI>
	       <RTRUE>)
	      (<AND <VERB? THROW POUR PUT-ON>
		    <PRSO? ,WATER>>
		<COND (<FSET? ,DICK ,RMUNGBIT>
		       <FCLEAR ,DICK ,RMUNGBIT>
		       <MOVE ,WATER ,LOCAL-GLOBALS>
		       <MOVE ,FLASK ,LOCAL-GLOBALS>
		       <TELL 
"The cool wave of water breaks upon the " D ,DICK "'s face with a \"whooosh.\"
He comes up for air, wide-eyed and woken-up.|
|
Glancing down at the flask of Dr. Nostrum's, he heaves it against the
turnstile, and it explodes into a cloud of acrid smoke surrounded by twinkling
flying shards of glass. Lucky no one got hurt." CR>)
		      (,DICK-DRUNK
		       <TELL "He's already soaked." CR>)>)    
	       (<AND <VERB? ALARM SHAKE RAISE>
		     ,DICK-DRUNK>
		<TELL 
"Making fists around the coat's lapel, you give a yank, but the " 
D ,DICK "'s ">
		<COND (<FSET? ,DICK ,RMUNGBIT>
		       <TELL "overheated ">)>
		<TELL "skull merely falls to his opposite shoulder." CR>)
	       (<VERB? EXAMINE>
	        <TELL "Wearing a " D ,COAT " and ">
		<COND (<AND <NOT ,DICK-DRUNK>
			    <EQUAL? ,HERE ,MIDWEST>>
		       <TELL 
"cradling a flask of Dr. Nostrum's in his hands,">)
		      (<EQUAL? ,HERE ,PROP-ROOM>
		       <TELL "looking otherwise disheveled,">)>
		<COND (<AND <EQUAL? ,HERE ,MIDWEST>	
			    ,DICK-DRUNK>	
		       <COND (<IN? ,FLASK ,DICK>
			      <TELL "still clutching the flask">)
			     (T
			      <TELL "looking downtrodden">)>
		       <TELL ",
the " D ,DICK " continues to breathe, but that's about all.">
		       <COND (<FSET? ,DICK ,RMUNGBIT>
			      <TELL 
" His face is damp with fever.">)>)
		      (T
		       <TELL
" he appears to have some kind of " D ,MONKEY " on his back.">)>
	       <CRLF>)
	      (<VERB? FOLLOW>
	       <COND (<EQUAL? ,FOLLOW-FLAG 9>
		      <DO-WALK ,P?SW>)
		     (<EQUAL? ,FOLLOW-FLAG 11>
		      <DO-WALK ,P?WEST>)
		     (<EQUAL? ,FOLLOW-FLAG 13>
		      <DO-WALK ,P?EAST>)>)>>

<ROUTINE GET-NOTE ()
	 <MOVE ,TRADE-CARD ,HERE>
	 <MOVE ,NOTE ,HERE>
	 <SETG P-IT-OBJECT ,TRADE-CARD>
	 <TELL
"With much pain, slowness, and remorse, the " D ,DICK " retrieves what looks
to be a " D ,NOTE  " and a " D ,TRADE-CARD " out of the inner lining of his "
D ,COAT " and lays them on the " D ,SAWDUST "." CR>>

<GLOBAL DICK-DRUNK <>> ;"says he's lying in midwest, not with billy" 
<GLOBAL DICK-UNRESPONSIVE <>>

<ROUTINE DICK-DESC ("OPTIONAL" X)
	 <COND (,DICK-DRUNK
		<TELL 
"Over next to the " D ,BIGTOP ", you can see the rumpled form of the " 
D ,DICK " lying in the " D ,SAWDUST ".">)
	       (T
	        <TELL "The " D ,DICK " is here.">)>>

<OBJECT COAT
	(IN DICK)
	(DESC "rumpled trenchcoat")
      	(SYNONYM TRENCH COAT)
     	(ADJECTIVE RUMPLED COAT)
	(FLAGS CONTBIT NDESCBIT SEARCHBIT TRYTAKEBIT OPENBIT)
    	(SIZE 15)
	(CAPACITY 10)
	(ACTION COAT-F)>

<ROUTINE COAT-F ()
	 <COND (<AND <VERB? LOOK-INSIDE SEARCH SEARCH-OBJECT-FOR OPEN>
		     <EQUAL? ,HERE ,MIDWEST>
		     ,DICK-DRUNK>
		<TELL 
"You're unable to search the coat thoroughly, since the " D ,DICK " is wearing
it." CR>)
	       (<AND <EQUAL? ,HERE ,PROP-ROOM>
		     <OR <TOUCHING? ,COAT>
			 <VERB? LOOK-INSIDE>>>
		<CANT-REACH ,DICK>)
	       (<AND <EQUAL? ,HERE ,MIDWEST>
		     <NOT ,DICK-DRUNK>
		     <VERB? LOOK-INSIDE OPEN CLOSE SEARCH PICK>>
		<PERFORM ,V?TAKE ,FLASK>
		<RTRUE>)
	       (<VERB? CLOSE>
		<V-DIG>)
	       (<AND <VERB? PUT>	
		     <PRSI? ,COAT>>
		<V-DIG>)
	       (<VERB? TAKE REMOVE OPEN>
		<COND (,DICK-DRUNK
		       <TELL 
"It's harder than trying to husk an ear of corn; you finally give up." CR>)
		      (T
		       <TELL <PICK-ONE ,YUKS> CR>)>)>>

<OBJECT TRADE-CARD
	(IN DICK)
	(DESC "trade card")
      	(SYNONYM CARD PICTURE)
	(ADJECTIVE TRADE)
	(FLAGS TAKEBIT)
    	(SIZE 4)
	;(GENERIC GEN-GIRL-F)
	(ACTION TRADE-CARD-F)>

<ROUTINE TRADE-CARD-F ()
	 <COND (<DONT-HANDLE? ,TRADE-CARD>
		<RFALSE>)
	       (<IN? ,TRADE-CARD ,GLOBAL-OBJECTS>
		<CANT-SEE ,TRADE-CARD>)
	       (<AND <EQUAL? ,HERE ,PROP-ROOM>
		     <IN? ,TRADE-CARD ,DICK>>
		<TELL "It's out of your sight." CR>)
	       (<AND <VERB? COMPARE>
		     <EQUAL? ,GIRL ,PRSO ,PRSI>>
		<TELL
"The girl depicted on the " D ,TRADE-CARD " indeed appears as an idealized
portrait of " D ,GIRL "." CR>)
	       (<AND <VERB? COMPARE>
		     <EQUAL? ,RIBBON ,PRSO ,PRSI>>
	        <TELL "It looks like the same " D ,RIBBON "." CR>)
	       (<VERB? EXAMINE>
		<IN-PACKAGE ,TRADE-CARD>)>>

<ROUTINE IN-PACKAGE (OBJ)
         <TELL "[A replica of">
	 <ARTICLE .OBJ T>
	 <TELL " is included in your Ballyhoo package.]" CR>>

<OBJECT NOTE
	(IN LOCAL-GLOBALS)
	(DESC "ransom note")
	(SYNONYM NOTE)	
	(ADJECTIVE RANSOM)
	(FLAGS TAKEBIT)
	(ACTION NOTE-F)>

<ROUTINE NOTE-F ()
	 <COND (<DONT-HANDLE? ,NOTE>
		<RFALSE>)
	       (<IN? ,NOTE ,GLOBAL-OBJECTS>
		<CANT-SEE ,NOTE>)
	       (<VERB? READ EXAMINE>
		<FIXED-FONT-ON>
		<TELL 
"The note is made from letters clipped out of a newspaper. It reads:"
CR CR
"    thE kId iS sAFe aND sOUnD.|
|
    FOr nOw. DoNT leaVe TowN|
|
    WItHOut HeR -|
|
    staY tuNeD foR deTaILs" CR>
		<FIXED-FONT-OFF>)>>

<ROOM WEST-CAMP
      (IN ROOMS)
      (DESC "Camp, West")      
      (NORTH PER PLEAT-EXIT)
      (OUT PER PLEAT-EXIT)
      (SOUTH TO CLOWN-ALLEY IF WARPED-DOOR IS OPEN)
      (IN TO CLOWN-ALLEY IF WARPED-DOOR IS OPEN)
      (EAST TO EAST-CAMP)
      (FLAGS ONBIT RLANDBIT)
      (GLOBAL WARPED-DOOR FENCE CANVAS CLOWN-TRAILER TENT CAMP)
      (ACTION WEST-CAMP-F)>

<ROUTINE WEST-CAMP-F (RARG)
	 <COND (<EQUAL? .RARG ,M-LOOK>
		<CAMP-DESC>
		<TELL CR
"At the northern border of the camp there is a pleated canvas wall, on
either side of which runs the fence that was meant to keep you out. To the
south, you see the long side of a dilapidated trailer, which sits off-kilter."
CR>)
	       (<AND <EQUAL? .RARG ,M-BEG>
		     <CANT-WALK?>>
		<RTRUE>)>>
  
<ROUTINE CANT-WALK? ()
	 <COND (<VERB? WALK>
		<COND (<AND <IN? ,THUMB ,PROTAGONIST>
			    <EQUAL? ,HERE ,WEST-CAMP ,EAST-CAMP>
	            	    <EQUAL? ,P-WALK-DIR ,P?NORTH>>
		       <DONT-WALK ,THUMB>)
		      (<AND <IN? ,GIRL ,PROTAGONIST>
			    <OR <AND <EQUAL? ,HERE ,EAST-CAMP>
				     <EQUAL? ,P-WALK-DIR ,P?WEST ,P?EAST>>
				<AND <EQUAL? ,HERE ,BACK-YARD>
				     <NOT <EQUAL? ,P-WALK-DIR ,P?EAST>>>
				<AND <EQUAL? ,HERE ,NEAR-WAGON>
				     <NOT <EQUAL? ,P-WALK-DIR ,P?SOUTH>>>>>
		       <DONT-WALK ,GIRL>)
		      (T
		       <RFALSE>)>)
	       (T
		<RFALSE>)>>
					  
<ROUTINE DONT-WALK (PERSON)
	 <COND (<EQUAL? .PERSON ,THUMB>
		<TELL D ,THUMB " gets restless in your arms">)
	       (T
		<TELL D ,GIRL " looks afraid">)>
	 <TELL " when you start that way so you stop." CR>> 

<OBJECT CANVAS
	(IN LOCAL-GLOBALS)
	(DESC "canvas wall")
	(SYNONYM PLEATS WALL PLEAT)
	(ADJECTIVE PLEATED DARK CANVAS DARKLY SHADOW)
	(FLAGS NDESCBIT)
        (GENERIC GEN-TENT)
	(ACTION CANVAS-F)>

;"RMUNGBIT = canvas wall has been walked through, now is described in 2 rooms"

<ROUTINE CANVAS-F ()   
	 <COND ;(<AND <EQUAL? ,HERE ,PROP-ROOM>
		     <NOT <FSET? ,CANVAS ,RMUNGBIT>>>
		<CANT-SEE ,CANVAS>)
	       (<VERB? EXAMINE>
		<COND (<AND <RUNNING? ,I-MEET>
			    ;<NOT <IN? ,MUNRAB ,HERE>>
			    <IS-ADJ? ,W?SHADOW>>
		       <TELL "Very ominous." CR>)
		      (<AND <NOT <FSET? ,CANVAS ,RMUNGBIT>>
			    <EQUAL? ,HERE ,PROP-ROOM>>
		       <RFALSE>)
		      (T
	       	       <TELL 
"The " D ,CANVAS " is deeply shadowed by its many pleats." CR>)>)
	       (<AND <EQUAL? ,HERE ,WEST-CAMP>
		     <VERB? OPEN RUB RAISE LOOK-UNDER LOOK-INSIDE MOVE>>
		<TELL 
"One pleat opens up to reveal more darkly shadowed pleats." CR>)
	       (<AND <VERB? WALK-TO BOARD THROUGH CRAWL-UNDER>
		     <EQUAL? ,HERE ,WEST-CAMP ,PROP-ROOM>>
		<COND (<OR <EQUAL? ,HERE ,WEST-CAMP>
			   <FSET? ,CANVAS ,RMUNGBIT>>
		       <COND (<NOT <FSET? ,CANVAS ,RMUNGBIT>>
		       	      <SETG SCORE <+ ,SCORE 10>>)>
		       <TELL-PASS-CANVAS>
		       <FSET ,CANVAS ,RMUNGBIT>		       
		       <COND (<EQUAL? ,HERE ,WEST-CAMP>
		       	      <GOTO ,PROP-ROOM>)
		      	     (T
		       	      <GOTO ,WEST-CAMP>)>)
		      (T
		       <TELL
"This side of the tent is too dark and shadowy to make out the confines
of the " D ,CANVAS "." CR>)>)>>
		       
<ROUTINE GEN-TENT ()
	 ,TENT>

<ROUTINE TENT-BOUND ()
	 <TELL 
"The " D ,PRSO " appears securely bound here." CR>>

<ROOM EAST-CAMP
      (IN ROOMS)
      (DESC "Camp, East")
      (NORTH PER TURNSTILE-EXIT)
      (OUT PER TURNSTILE-EXIT)
      (SOUTH "A fence blocks your way.")
      (WEST TO WEST-CAMP)
      (EAST TO TAMER-ROOM IF TAMER-DOOR IS OPEN)
      (IN TO TAMER-ROOM IF TAMER-DOOR IS OPEN)
      (FLAGS ONBIT RLANDBIT)
      (GLOBAL TURNSTILE FENCE TAMER-TRAILER TAMER-DOOR CURTAINS WINDOW
	      BAGGAGE-COMPARTMENT CAMP)
      (ACTION EAST-CAMP-F)>

<ROUTINE EAST-CAMP-F (RARG)
	 <COND (<EQUAL? .RARG ,M-LOOK>
		<CAMP-DESC>
		<TELL CR
"At the eastern end of the camp sits one lone " D ,TAMER-TRAILER "."
CR>) 	       
	       (<EQUAL? .RARG ,M-BEG>
		<COND (<CANT-WALK?>
		       <RTRUE>)
		      (<AND <VERB? WAIT>
			    <EQUAL? ,WIPE-C 100>
			    <IN? ,JENNY ,LOCAL-GLOBALS>>
	               <TELL 
"It doesn't appear the meeting is about to start soon." CR>)>)
	       (<AND <EQUAL? .RARG ,M-ENTER>
		     <FSET? ,CASE ,TOUCHBIT>
		     <FSET? ,RIBBON ,TOUCHBIT>
		     <FSET? ,SHEET ,TOUCHBIT>
		     <NOT ,WON-JOEY>
		     ,WON-ON-TENT
		     ,CLOWN-ALLEY-SCENE>
		<SETG WIPE-C 0>
		<MOVE ,FLASK ,JOEY>
		<MOVE ,RAG ,JOEY>
		<ENABLE <QUEUE I-JOEY -1>>
		<MOVE ,JOEY ,EAST-CAMP>)>>
			    
<OBJECT TAMER
	(IN TAMER-ROOM)
	(DESC "Gottfried Wilhelm von Katzenjammer")
	(SYNONYM KATZEN KATZ TRAINER TAMER)
	(ADJECTIVE MAN HERR VON GOTTFR WILHEL LION)
	(FLAGS PERSON ACTORBIT NARTICLEBIT)
	(ACTION TAMER-F)>

<ROUTINE TAMER-F ()
	 <COND (<TALKING-TO? ,TAMER>
		<TELL "\"Was ist das!\"" CR>
		<STOP>)
	       (<AND <VERB? FOLLOW>
		     <EQUAL? ,FOLLOW-FLAG 16>>
		<DO-WALK ,P?EAST>)>>

<ROOM TAMER-ROOM
      (IN ROOMS)
      (DESC "Inside Trailer")
      (WEST TO EAST-CAMP IF TAMER-DOOR IS OPEN)
      (OUT TO EAST-CAMP IF TAMER-DOOR IS OPEN)
      (FLAGS ONBIT RLANDBIT)
      (GLOBAL CURTAINS WINDOW TAMER-DOOR TAMER-TRAILER)
      (ACTION TAMER-ROOM-F)>

<ROUTINE TAMER-ROOM-F (RARG)
	 <COND (<EQUAL? .RARG ,M-ENTER>
		<STEP-INTO-TRAILER>
		<COND (<RUNNING? ,I-TAMER>  ;"so you can close door, I-TAMER"
		       <MOVE ,TAMER ,LOCAL-GLOBALS>
		       <ENABLE <QUEUE I-TAMER 3>>)>)
	       (<EQUAL? .RARG ,M-LOOK>
		<TELL
"These quarters are furnished in a foreigner's vision of American Rugged
Individualism. ">
		<COND (<FSET? ,MOOSE ,NDESCBIT>
		       <TELL 
"The head of a moose, for example, hangs as a trophy against">)
		      (T
		       <TELL "There's an opening to a " D ,CRAWL-SPACE " in">)>
		<TELL 
" one wall. Against the west wall the door stands ">
		<OPEN-CLOSED ,TAMER-DOOR>
		<TELL " and a gaily decorated " D ,CURTAINS>
		<COND (<FSET? ,CURTAINS ,OPENBIT>
		       <TELL " is open at">)
		      (T
		       <TELL " covers">)>	
	        <TELL " the " D ,WINDOW "." CR>)>>

<ROUTINE STEP-INTO-TRAILER ()
	 <TELL "You step up into the trailer." CR CR>>

<OBJECT MOOSE 
	(IN TAMER-ROOM)
	(DESC "moose head")
	(SYNONYM HEAD TROPHY ANTLER)
	(ADJECTIVE MOOSE)
	(FLAGS NDESCBIT TAKEBIT)
	(SIZE 90)
	(ACTION MOOSE-F)>

<ROUTINE MOOSE-F ()
	 <COND (<AND <VERB? MOVE PUSH TAKE LOOK-BEHIND>
		     <FSET? ,MOOSE ,NDESCBIT>>
		<FCLEAR ,MOOSE ,NDESCBIT>
		<FCLEAR ,CRAWL-SPACE ,INVISIBLE>
	        <TELL
"The " D ,MOOSE " drops to the floor with a loud thud, revealing an opening,
about one foot square, to a " D ,CRAWL-SPACE "." CR>)
	       (<AND <VERB? PUT PUT-ON>
		     <PRSI? ,WALLS>
		     <EQUAL? ,HERE ,TAMER-ROOM>>
		<TELL "It won't reattach to the " D ,WALLS "." CR>)
	       (<VERB? DRINK>
		<TELL "It's very very dry, undrinkably so." CR>)>>
		     
<OBJECT CRAWL-SPACE 
	(IN TAMER-ROOM)
	(DESC "crawl space")
	(SYNONYM OPENING SPACE HOLE)
	(ADJECTIVE ;HALLOW CRAWL SQUARE)
	(FLAGS NDESCBIT INVISIBLE)
	(ACTION CRAWL-SPACE-F)>
		
<ROUTINE CRAWL-SPACE-F ()
	 <COND (<VERB? LOOK-INSIDE>
		<TELL "It is completely dark inside the opening." CR>)
	       (<VERB? REACH-IN>
		<COND (<IN? ,GIRL ,HERE>
		       <PERFORM ,V?TAKE ,GIRL>
		       <RTRUE>)
		      (T
		       <TELL-WITHIN-REACH>)>)
	       (<VERB? EXAMINE>
		<TELL "The square hole is about a foot wide." CR>)
	       (<AND <VERB? PUT-ON>
		     <PRSO? ,MOOSE>>
		<PERFORM ,V?PUT-ON ,MOOSE ,WALLS>
		<RTRUE>)
	       (<VERB? PUT>		
		<COND (<PRSO? ,GIRL>
		       <RFALSE>)
		      (<L? <GETP ,PRSO ,P?SIZE> 75>
		       <FSET ,PRSO ,INVISIBLE>
		       <MOVE ,PRSO ,CRAWL-SPACE>
		       <COND (<PRSO? ,THUMB>
			      <ENABLE <QUEUE I-TAMER 3>>
			      <TELL 
"A wide-eyed " D ,THUMB " goes easily through the opening and">)
			     (T
			      <TELL "As you release">
		       	      <ARTICLE ,PRSO T>
		       	      <TELL " it">)>
		       <TELL 
" drops to the floor on the other side of the wall. ">
		       <COND (<AND <IN? ,GIRL ,LOCAL-GLOBALS>
			           <NOT ,GIRL-CRIED>>
			      <TELL-WIMPER>
			      <RTRUE>)
			     (T
			      <CRLF>
			      <RTRUE>)>)
		      (T
		       <TELL "It doesn't fit.">)>
		 <CRLF>)
		(<VERB? BOARD ENTER THROUGH>
		 <TELL 
"Despite your writhing and squirming at the opening, it would seem only
a contortionist or a Houdini would fit through it." CR>)>> 

<GLOBAL GIRL-CRIED <>>

<OBJECT WINDOW 
	(IN LOCAL-GLOBALS)
	(DESC "window")
	(SYNONYM WINDOW)
	(FLAGS NDESCBIT TRANSBIT)
	(ACTION WINDOW-F)>

<ROUTINE WINDOW-F ()
	 <COND (<VERB? OPEN CLOSE BOARD THROUGH>
	        <TELL "It refuses to budge." CR>)
	       (<VERB? LOOK-INSIDE>
		<COND (<FSET? ,CURTAINS ,OPENBIT>
		       <TELL ,YOU-SEE>
		       <COND (<EQUAL? ,HERE ,EAST-CAMP>
		       	      <TELL " the inside of the trailer.">)
			     (T
			      <TELL " the performers' camp.">)>)
		     (T
		      <TELL 
"The " D ,CURTAINS "s are drawn over the " D ,WINDOW ".">)>
		<CRLF>)>>

<OBJECT CURTAINS 
	(IN LOCAL-GLOBALS)
	(DESC "curtain")
	(SYNONYM CURTAINS DECORATION)
	;(ADJECTIVE ;BUFFALO ;COWBOY ;GUNFIGHT)
	(FLAGS NDESCBIT DOORBIT)
	(ACTION CURTAINS-F)>

<ROUTINE CURTAINS-F ()
	 <COND (<AND <TOUCHING? ,CURTAINS>
		     <EQUAL? ,HERE ,EAST-CAMP>>
		<TELL 
"The " D ,CURTAINS "s are inside the trailer, hence unreachable." CR>)
	       (<VERB? EXAMINE>
		<TELL "The ">
		<COND (<FSET? ,CURTAINS ,OPENBIT>
		       <TELL "open ">)
		      (T
		       <TELL "closed ">)>
		<TELL 
D ,CURTAINS " is decorated with little Wild West scenes: cowboys mowing down
buffalo, gunfights, and the like." CR>)>>
		
<OBJECT TAMER-TRAILER 
	(IN LOCAL-GLOBALS)
	(DESC "trailer")
	(SYNONYM TRAILER SIDING WAGON)
	(ADJECTIVE ALUMINUM CHALKY LONE)
	(FLAGS NDESCBIT)
	(ACTION TAMER-TRAILER-F)>

<ROUTINE TAMER-TRAILER-F ()
	 <COND (<VERB? EXAMINE>
	        <COND (<EQUAL? ,HERE ,EAST-CAMP>
		       <TELL 
"The " D ,TAMER-TRAILER " with its chalky aluminum siding has all the charm
of a generic beer can. In contrast, a garishly painted sign hangs over both
the door, which is">
		       <COND (<FSET? ,TAMER-DOOR ,OPENBIT>
			      <TELL " open">)
			     (T
			      <TELL " closed">)>
		       <TELL 
", and a window. Built into the side of the " D ,TAMER-TRAILER " is ">
		       <COND (<FSET? ,BAGGAGE-COMPARTMENT ,OPENBIT>
			      <TELL "an open ">)
			     (T
			      <TELL "some kind of baggage ">)>
		       <TELL D ,BAGGAGE-COMPARTMENT ".">
		       <CRLF>)
		      (T
		       <V-LOOK>)>)
	       (<VERB? ENTER BOARD THROUGH>
		<COND (<EQUAL? ,HERE ,TAMER-ROOM>
		       <TELL ,LOOK-AROUND CR>)
		      (T
		       <DO-WALK ,P?EAST>)>)
	       (<VERB? LOOK-INSIDE>
		<COND (<EQUAL? ,HERE ,TAMER-ROOM>
		       <V-LOOK>)
		      (T
		       <PERFORM ,V?LOOK-INSIDE ,WINDOW>
		       <RTRUE>)>)
	       (<AND <TOUCHING? ,TAMER-TRAILER>
		     <IN? ,JOEY ,HERE>>
		<PERFORM ,V?KNOCK ,TAMER-DOOR>
		<RTRUE>)
	       (<VERB? OPEN CLOSE UNLOCK LOCK>
		<PERFORM ,PRSA ,TAMER-DOOR ,PRSI>
		<RTRUE>)>>

<OBJECT TAMER-SIGN 
	(IN EAST-CAMP)
	(DESC "sign")
	(SYNONYM SIGN)
	(ADJECTIVE GARISH PAINTED)
	(FLAGS NDESCBIT)
	(ACTION TAMER-SIGN-F)>

<ROUTINE TAMER-SIGN-F ()
	 <COND (<VERB? READ EXAMINE>
		<FIXED-FONT-ON>
		<TELL
"               Home Of|
  " D ,TAMER "|
|
     KATZENJAMMER OF THE BIG CATS|">
		<FIXED-FONT-OFF>)>>

<OBJECT CAMP 
	(IN LOCAL-GLOBALS)
	(DESC "camp")
	(SYNONYM CAMP)
	(ADJECTIVE PERFOR)
	(FLAGS NDESCBIT)
	(ACTION GLOBAL-ROOM-F)>

<OBJECT TAMER-DOOR 
	(IN LOCAL-GLOBALS)
	(DESC "trailer door")
	(SYNONYM DOOR LOCK)
	(ADJECTIVE TRAILER)
	(FLAGS DOORBIT LOCKEDBIT)
	(ACTION TAMER-DOOR-F)>

<ROUTINE TAMER-DOOR-F ()
	 <COND (<AND <TOUCHING? ,TAMER-DOOR>
		     <IN? ,JOEY ,HERE>>
	        <TELL
D ,JOEY " shields the " D ,TAMER-TRAILER " from you. \"Keep away. The liquid
hasn't dried yet.\"" CR>)
	       (<AND <VERB? CLOSE LOOK-BEHIND>
		     <EQUAL? ,HERE ,TAMER-ROOM>
		     <IN? ,CROWBAR ,LOCAL-GLOBALS>>
		<FCLEAR ,TAMER-DOOR ,OPENBIT>
	        <MOVE ,CROWBAR ,HERE>
		<SETG P-IT-OBJECT ,CROWBAR>
		<TELL 
"As the " D ,TAMER-DOOR " is closed, you notice a " D ,CROWBAR " leaning
against the wall, where it looks more like a weapon than a tool." CR>)   
	       (<VERB? KNOCK>
		<COND (<AND <IN? ,TAMER ,TAMER-ROOM>
		            ,WON-JOEY>
		       <TELL 
,YOU-SEE " the " D ,CURTAINS "s part slightly and then ">
		       <COND (<AND <FSET? ,VEIL ,WORNBIT>
			           <FSET? ,DRESS ,WORNBIT>
			    	   <FSET? ,SHAWL ,WORNBIT>>
		       	      <FSET ,CURTAINS ,OPENBIT>
		       	      <FSET ,TAMER-DOOR ,OPENBIT>
		       	      <FCLEAR ,TAMER-DOOR ,LOCKEDBIT>
		       	      <FCLEAR ,TAMER-DOOR ,RMUNGBIT>
		       	      <FSET ,TAMER ,NDESCBIT>
			      <MOVE ,TAMER ,HERE>
		       	      <ENABLE <QUEUE I-TAMER 1>>
		       	      <TELL 
"you hear through the window a hushed voice with a thick German accent.| 
|
\"Andrew, where is Eddie?! And Willie! We must talk over what to do.
I go now and bring back them, and the " D ,JIM " too. You be guarding in here,
when I will come back.\"|
|
The " D ,TAMER-DOOR " swings inward, and out of the " D ,TAMER-TRAILER
" steps the robust personage of the " D ,TAMER "." CR>)
		      	     (T
		       	      <FSET ,TAMER-DOOR ,RMUNGBIT>
		       	      <ENABLE <QUEUE I-TAMER 10>>
		       	      <TELL "draw closed." CR>)>)
		      (T
		       <RFALSE>)>)
	       (T
		<RFALSE>)>> 
		     
<OBJECT CROWBAR 
	(IN LOCAL-GLOBALS)
	(DESC "crowbar")
	(SYNONYM CROWBAR BAR TOOL) 
	(ADJECTIVE CROW)
	(FLAGS TAKEBIT)
	(SIZE 20)
	(GENERIC GEN-BAR)>

<GLOBAL TAMER-C 0>
 
<GLOBAL END-GAME <>>

<GLOBAL CALLED-STATION <>>

<GLOBAL END-GAME-C 0>

<ROUTINE I-END-GAME ()
	 <SETG END-GAME-C <+ ,END-GAME-C 1>>
         <COND (<EQUAL? ,HERE ,LEFT-HANGING>
		<COND (<EQUAL? ,END-GAME-C 2>
		       <TELL CR 
"Down below, oblivious of your plight, all of the circus folk are making
noises of mutual forgiveness and reconciliation in the new spirit of
togetherness brought on by the dramatic, emotionally charged rescue of
" D ,MUNRAB "'s daughter." CR>)
		      (<EQUAL? ,END-GAME-C 3>
		       <TELL CR 
"You can feel your grip loosen as the crowd below continues its orgy of
feeling." CR>)
		      (<EQUAL? ,END-GAME-C 4>
		       <TELL "Your sweaty hands slip off the wire.">
		       <CARRIAGE-RETURNS 14>
		       <TELL
"The story of your evening's heroic deeds must have just been passed among
the circus people below, because you feel the sudden pressure of your
shoulders sinking deeply into the " D ,NET " and with a rousing chorus of
\"Hip hip hooray!\" you are flung back high into the air, where you view the
smiling upturned faces of your circle of boosters.|
|
You float back down and on the second blast-off -- \"Hip hip hooray!\" -- you
pass out, not so much from the acceleration as from the sheer exhilaration
of having saved The Traveling Circus That Time Forgot, Inc." CR>
		      <FINISH>)>)
	       (<IN? ,JIM ,LOCAL-GLOBALS>
	        <ENABLE <QUEUE I-END-GAME -1>>
		<MOVE ,JIM ,RING>
	  	<MOVE ,NET ,MUNRAB>
	  	<MOVE ,THUMB RING>
		<FSET ,THUMB ,NDESCBIT>
		<FSET ,JIM ,NDESCBIT>
		<COND (<EQUAL? ,HERE ,RING>
		       <TELL CR
"The " D ,JIM " comes sprinting through the wings with the " D ,NET " slung
over his shoulder and the midget " D ,THUMB " in tow. " D ,MUNRAB " and his
two employees each grab part of the net, and they try to position it
directly under the imperiled little girl." CR>)>)
	       (<AND <EQUAL? ,HERE ,RING>
		     <FSET? ,DIAL ,RMUNGBIT> ;"fundraising"
		     <NOT ,GANG-HERE>>
		<MOVE ,TAMER ,HERE>
		<MOVE ,ANDREW ,HERE>
		<MOVE ,JENNY ,HERE>
		<MOVE ,HERM ,HERE>
		<MOVE ,JOEY ,HERE>
		<MOVE ,HYP ,HERE>
		<MOVE ,CON ,HERE>
		<MOVE ,GANG ,HERE>
		<SETG GANG-HERE T>
	        <FSET ,HERM ,NDESCBIT>
		<FSET ,CON ,NDESCBIT>
		<FSET ,HYP ,NDESCBIT>
		<FSET ,JOEY ,NDESCBIT>
		<TELL CR 
"Just now a gaggle of circus performers -- ">
		<TELL-GROUP>
		<TELL 
"-- appear through the wings. Quickly assessing the situation, the group
seems to suddenly, gut-wrenchingly accept the burden of responsibility for the
calamity that has occurred. Their immediate reaction is the instinct to help,
and each grabs part of the net." CR>)
	       (<AND <IN? ,NET ,MUNRAB>
		     <EQUAL? ,HERE ,RING>>
		<ENABLE <QUEUE I-END-GAME -1>>
		<TELL CR
"Munrab & Company, their faces anxiously upturned, are pulling the " D ,NET " 
every which way, kicking sawdust from one end of the ring to the other." CR>
		<RTRUE>)>>

;<OBJECT RADIO-STATION 
	(IN LOCAL-GLOBALS)
	(DESC "station")
	(SYNONYM STATION) 
	(ADJECTIVE RADIO)
	(FLAGS NDESCBIT)>

<ROUTINE I-TAMER ()
	 <COND (<FSET? ,TAMER-DOOR ,RMUNGBIT>
		<FCLEAR ,TAMER-DOOR ,RMUNGBIT>
		<RFALSE>)
	       (<AND <EQUAL? ,HERE ,TAMER-ROOM>
		     <IN? ,THUMB ,CRAWL-SPACE> ;"called for 3 when put in"
		     <IN? ,GIRL ,LOCAL-GLOBALS>> ;"important test - below"
		<ENABLE <QUEUE I-TAMER -1>>
		<SETG TAMER-C 0>
	        <FSET ,GIRL ,RMUNGBIT>
		<TELL CR "Coming from the other side of the wall is a scurrying noise. Then "> 
		<TELL-BOOST-GIRL>
		<RTRUE>)
 	       (T
		<ENABLE <QUEUE I-TAMER -1>>
		<SETG TAMER-C <+ ,TAMER-C 1>>		
	        <COND (<AND <NOT <IN? ,GIRL ,LOCAL-GLOBALS>>
		       	    <FSET? ,GIRL ,RMUNGBIT>
			    <EQUAL? ,HERE ,TAMER-ROOM>>
		       <COND (<EQUAL? ,TAMER-C 1 3>
		       	      <MOVE ,GIRL ,CRAWL-SPACE>
		       	      <TELL CR "The girl drops out of view" >
			      <COND (<EQUAL? ,TAMER-C 3>
				     <TELL 
"; you hear foot-stomping from inside the " D ,CRAWL-SPACE " and then
a long silence">)>
			      <TELL ,PERIOD>)
		      	     (<EQUAL? ,TAMER-C 2>
		       	      <TELL-BOOST-GIRL T>)>
		       <RTRUE>)
		      (<AND <EQUAL? ,TAMER-C 2>
			    <IN? ,GIRL ,LOCAL-GLOBALS>>
		       <MOVE ,TAMER ,LOCAL-GLOBALS>
		       <COND (<EQUAL? ,HERE ,EAST-CAMP>			      
			      <FCLEAR ,TAMER-DOOR ,OPENBIT>
			      <FSET ,TAMER-DOOR ,LOCKEDBIT>
			      <ENABLE <QUEUE I-FOLLOW 2>>
			      <SETG FOLLOW-FLAG 16>
			      <FCLEAR ,CURTAINS ,OPENBIT>
			      <TELL CR 
D ,TAMER ", with a confused look on his face, stares at you
as if he'd never seen a sideshow freak in his life.">
			      <COND (<FSET? ,VEIL ,WORNBIT>
				     <TELL " He peels back your veil,">)
	        		    (T
				     <TELL " He">)>
			      <TELL
" shoves you to the " D ,GROUND ", and steps up into the " 
D ,TAMER-TRAILER ". You bring " D ,ME " to your feet." CR>)>)
		       ;(<AND <G? ,TAMER-C 7>
			     <EQUAL? ,HERE ,TAMER-ROOM>
			     <NOT <HELD? ,THUMB>>
			     <NOT <VERB? WALK OPEN>>
			     <OR <FSET? ,TAMER-DOOR ,OPENBIT>
				 <FSET? ,CURTAINS ,OPENBIT>>>
		        <TELL CR 
"Out of the " D ,CORNER " of your eye, you notice a flash of color passing
in front of the ">
		        <COND (<FSET? ,WINDOW ,OPENBIT>
			       <TELL D ,WINDOW>)
			      (T
			       <TELL D ,TAMER-DOOR>)>
			<TELL 
". " D ,JOEY " barges through the door, and taunts you with your old
nemesis, the " D ,PROD ". ">
		        <JIGS-UP 3  
"With a lightning thrust, he makes contact.">)>)>>

<ROUTINE TELL-BOOST-GIRL ("OPTIONAL" (AGAIN? <>))
	 <MOVE ,GIRL ,HERE>
	 ;<CRLF>
	 <COND (.AGAIN?
		<TELL CR "Once again ">)>
	 <TELL "you can hear the strained voice of " D ,THUMB " cursing in Russian as he gives a boost to his human cargo. ">
	 <COND (.AGAIN?
		<TELL CR 
"The girl is held precariously up to the opening." CR>)
	       (T
	        <TELL CR CR  
"Slowly rising into view through the opening comes the expressionless face
of the missing girl, framed by her tousled and ribbonless hair, seeming too
tired to be frightened.|
|
She pauses there for an instant, a portrait of innocence within a
jagged plywood frame." CR>)>>

<OBJECT GIRL 
	(IN LOCAL-GLOBALS)
	(DESC "Chelsea")
	(SYNONYM GIRL CHELSEA)
	(ADJECTIVE LITTLE)
	(FLAGS PERSON ACTORBIT TAKEBIT NARTICLEBIT FEMALE)
	(SIZE 50)
	;(GENERIC GEN-GIRL-F)
	(ACTION GIRL-F)>

;"RMUNGBIT = girl's being raised and lowered in crawl-space"

<ROUTINE GIRL-F ()
	 <COND (<AND <VERB? LISTEN>
		     <IN? ,GIRL ,LOCAL-GLOBALS>
		     ,GIRL-CRIED>
		<TELL "You don't hear the " D ,WHIMPER " now." CR>)
	       (<VERB? EXAMINE>
		<TELL
"She looks exhausted, but also somehow strengthened by her travails
this evening." CR>)
	       (<TALKING-TO? ,GIRL>
		<COND (<IN? ,GIRL ,APE>
		       <SETG WINNER ,PROTAGONIST>
		       <PERFORM ,V?TELL ,APE>
		       <STOP>)
		      (T
		       <TELL
"The girl merely looks at you with frightened eyes. She has learned her
lesson about not talking to strangers." CR>
		<STOP>)>) 
	       (<AND <VERB? TAKE>
		     <FSET? ,GIRL ,RMUNGBIT>
		     <EQUAL? <ITAKE> T>>
		<DISABLE <INT I-TAMER>>
		<ENABLE <QUEUE I-GIRL -1>>
	        <MOVE ,THUMB ,LOCAL-GLOBALS>
		<SETG SCORE <+ ,SCORE 10>>
		<SETG FOLLOW-FLAG 10>
		<ENABLE <QUEUE I-FOLLOW 2>>
		<FCLEAR ,THUMB ,INVISIBLE>
		<FCLEAR ,GIRL ,RMUNGBIT>
	        <FCLEAR ,APE-DOOR ,OPENBIT>
		<FSET ,APE-DOOR ,LOCKEDBIT>
		<TELL 
"You hoist the girl from out of the " D ,CRAWL-SPACE ". " D ,THUMB 
", exhilarated by the rescue, climbs out of the opening unassisted,
and then exits the " D ,TAMER-TRAILER "." CR>
	        <RTRUE>)
	       (<AND <VERB? GIVE SHOW>
		     <PRSO? ,TRADE-CARD>>
		<TELL "\"That's me,\" she says." CR>)
	       (<AND <VERB? DROP PUT THROW GIVE>
		     <PRSO? ,GIRL>>
		<COND (<AND ,PRSI
			    <FSET? ,PRSI ,TAKEBIT>>
		       <TELL "She resists">)
		      (T
		       <TELL 
"With fear in her eyes, she resists your abandonment">)>
		<TELL ,PERIOD>)
	       (<OR <AND <VERB? GIVE PUT-ON>
		         <PRSI? ,GIRL>>
		    <AND <VERB? TIE>
			 <PRSO? RIBBON>>>
		<TELL 
"Understandably, " D ,GIRL " is reluctant to accept gifts from strangers">
		<COND (<PRSO? ,RIBBON>
		       <TELL ", even her own " D ,RIBBON>)>
		<TELL ,PERIOD>) 
	       (<AND <TOUCHING? ,GIRL>
		     <IN? ,GIRL ,APE>>
		<CANT-REACH ,GIRL>)
	       (<VERB? SAVE-SOMETHING>
		<TELL ,HOW CR>)
	       (<AND <VERB? FOLLOW>
		     <EQUAL? ,FOLLOW-FLAG 9>>
		<DO-WALK ,P?NORTH>)>>

<ROUTINE I-GIRL ()
	 <COND (<AND <EQUAL? ,HERE ,NEAR-WAGON>
		     <IN? ,MUNRAB ,OFFICE>
		     <IN? ,GIRL ,PROTAGONIST>>
		<FCLEAR ,OFFICE-DOOR ,LOCKEDBIT>		
		<FSET ,OFFICE-DOOR ,OPENBIT>
	        <MOVE ,MUNRAB ,MEN>
		<FSET ,MUNRAB ,NDESCBIT>
		<ENABLE <QUEUE I-FOLLOW 2>>
		<SETG P-IT-OBJECT ,MUNRAB>
		<SETG FOLLOW-FLAG 8>
		<TELL CR
"As you approach the " D ,WAGON ", " D ,MUNRAB " steps down from
inside his office and, as his eyes fall upon the figure of you
carrying the only bit of preciousness in his life, it's as if he were
jolted by an " D ,PROD ". For an instant, his confused mind appears to
be sending him strong fight-or-flight messages, for suddenly he dashes
off through the hole in the fence." CR>)
	       (<IN? ,MUNRAB ,MEN>
		<COND (<EQUAL? ,HERE ,NEAR-WAGON>
		       <TELL CR 
"The little girl begins whining at you to follow her father, and off you
go." CR CR>
		       <GOTO ,MEN>)>
	       	<DISABLE <INT I-GIRL>>
		<ENABLE <QUEUE I-END-GAME -1>>
		<ENABLE <QUEUE I-FOLLOW 2>>
		<SETG FOLLOW-FLAG 9>
	        <SETG END-GAME T>
		<SETG APE-LOC 1>
		<MOVE ,JIM ,RING>
		<MOVE ,MUNRAB ,RING>
	        <MOVE ,GIRL ,APE>
		<MOVE ,DICK ,LOCAL-GLOBALS>
	        <MOVE ,APE ,LOCAL-GLOBALS>
		<FCLEAR ,MUNRAB ,NDESCBIT>		
		<FCLEAR ,RING ,TOUCHBIT>
	        <FCLEAR ,CLOWN-ALLEY ,TOUCHBIT>
	        <FSET ,GIRL ,NDESCBIT>
		<FSET ,APE ,NDESCBIT>
		<TELL CR 
D ,MUNRAB ", standing here desperate and alone in the middle of the
menagerie, is calling out in every direction for the detective.|
|
The sotted sleuth comes staggering in from the midway, and " D ,MUNRAB
", pointing confidently at you, delivers the order, \"There is the
perpetrator. Shoot ">
		<MAN-OR-WOMAN "him" "her">
		<TELL
".\" As the " D ,DICK " stumbles toward you, your ears are pierced by "
D ,GIRL " screaming at the top of her lungs, and then by the screech of
bending metal. Suddenly, you're blindsided by a wall of bristly animal fur
which knocks you to the ground. You get up dazed, and see " D ,MUNRAB "
chasing a giant ape to the north while the detective slinks away through
the hole in the fence." CR>)>>
				
<OBJECT WHIMPER
	(IN TAMER-ROOM)
	(DESC "whimper")
	(SYNONYM WHIMPER)
	(FLAGS NDESCBIT CLEARBIT)	
	(ACTION WHIMPER-F)>

<ROUTINE WHIMPER-F ()
	 <COND (<AND <VERB? LISTEN FOLLOW FIND>
		     ,GIRL-CRIED>
		<PERFORM ,V?LISTEN ,GIRL>
		<RTRUE>)
	       (T
		<CANT-SEE ,WHIMPER>)>>

<OBJECT BAGGAGE-COMPARTMENT 
	(IN EAST-CAMP)
	(DESC "compartment")
	(SYNONYM COMPAR)
	(ADJECTIVE BAGGAGE)
	(FLAGS NDESCBIT CONTBIT CAGEBIT LOCKEDBIT)
	(CAPACITY 50)
	(ACTION BAGGAGE-COMPARTMENT-F)>

<ROUTINE BAGGAGE-COMPARTMENT-F ()
	 <COND (<AND <TOUCHING? ,BAGGAGE-COMPARTMENT>
		     <IN? ,JOEY ,HERE>>
		<PERFORM ,V?KNOCK ,TAMER-DOOR>)>>

<ROUTINE CAMP-DESC ()
	 <TELL "You're in the ">
	 <COND (<EQUAL? ,HERE ,WEST-CAMP>
		<TELL "west">)
	       (T
		<TELL "east">)>
	 <TELL
" end of the performers' camp. It is unevenly lighted by a number
of glaring spotlights which ring the camp, creating a stage-like
patchwork of light and dark." CR>>

<OBJECT THUMB
	(IN CON-AREA)
	(DESC "Comrade Thumb")
	(DESCFCN THUMB-DESCFCN)
	(SYNONYM THUMB MIDGET MAN GENERAL)
	(ADJECTIVE COMRAD CONSTA MIDGET LITTLE)
	(FLAGS ACTORBIT PERSON NARTICLEBIT TAKEBIT NDESCBIT CONTBIT OPENBIT
	       SEARCHBIT)
	(SIZE 70)
	(ACTION THUMB-F)>

;"THUMB RMUNGBIT = has arrived in I-THUMB and will run away next move"

;" I dont understand = Ya ne ponimayu.
   I dont speak English = Ya ne govoryu po-anglijski
   What? = Shto?"

<ROUTINE THUMB-F ()
	 <COND (<EQUAL? ,THUMB ,WINNER>
		<COND (<VERB? HELLO>
		       <SETG WINNER ,PROTAGONIST>
		       <PERFORM ,V?HELLO ,THUMB>
		       <SETG WINNER ,THUMB>
		       <RTRUE>)
		      (<AND <VERB? TELL-ABOUT>
			    <PRSO? ,ME>>
		       <SETG WINNER ,PROTAGONIST>
		       <PERFORM ,V?ASK-ABOUT ,THUMB ,ME>
		       <SETG WINNER ,THUMB>
		       <RTRUE>)>)
	       (<VERB? HELLO WAVE-AT>
		<TELL 
"He gives you a slow and dramatic wave, as if to a great audience." CR>)
		(<TALKING-TO? ,THUMB>		     
		 <COND (<RUNNING? ,CLOWN-ALLEY>
		       <PERFORM ,V?RUB ,JOEY>
		       <RTRUE>)
		      (T
		       <TELL 
"Unable to comprehend what you're saying, he shrugs his shoulders." CR>
		<STOP>)>)
	       (<AND <VERB? EXAMINE>
		     <RUNNING? ,I-CLOWN-EXIT>>
		<TELL "He rolls his eyes back in a theatrical way." CR>)
	       (<AND <VERB? LISTEN>
		     <EQUAL? ,CLOWN-EXIT-COUNTER 4>
		     <NOT <HELD? ,THUMB>>>
		<TELL
"It's certainly not the hit parade." CR>)
	       (<AND <VERB? DROP GIVE THROW PUT>		     
		     <PRSO? ,THUMB>
		     <NOT <EQUAL? ,PRSI ,CRAWL-SPACE>>>
		<TELL "He squirms out of your hold">
		<COND (<AND <EQUAL? ,HERE ,TAMER-ROOM>
			    <NOT <FSET? ,TAMER-DOOR ,OPENBIT>>>
		       <FSET ,TAMER-DOOR ,OPENBIT>
		       <TELL ", opens the door,">)>
		<COND (<NOT <RUNNING? ,I-CLOWN-EXIT>>
		       <TELL " and flees into the night">
		       <MOVE ,THUMB ,LOCAL-GLOBALS>)
		      (T
		       <SETG CLOWN-EXIT-COUNTER 7>
		       <MOVE ,THUMB ,HERE>)>
		<TELL ,PERIOD>)
	       (<OR <AND <VERB? RAISE PICK-UP>
			 <NOT ,PRSI>>
		    <AND <VERB? RAISE>
			 <EQUAL? ,PRSI ,FOUNTAIN ,BUTTON>>>		 
		<COND (<RUNNING? ,I-BOOST>
		       <SETG HELPED-THUMB T>
		       <TELL "Once elevated, ">
		       <THUMB-DRINKS>
		       <BOOST-EXIT>)
		      (T
		       <PERFORM ,V?TAKE ,THUMB>
		       <RTRUE>)>)
	       (<EQUAL? ,HERE ,BLUE-ROOM>
	        <COND (<DISTURB? ,THUMB>
		       <TELL 
"Curious, the " D ,DEALER " peeks under the " D ,TABLE " and flushes "
D ,THUMB ", who sprints through the " D ,BLUE-DOOR ". ">
	               <EIGHTY-SIX>)
		      (<VERB? EXAMINE>
		       <COND (<AND <FSET? ,TABLE ,RMUNGBIT>
				   <EQUAL? ,HERE ,BLUE-ROOM>>
			      <PERFORM ,V?RUB ,THUMB>
			      <RTRUE>)
			     (<AND <RUNNING? ,I-CLOWN-ALLEY>
				   <EQUAL? ,HERE ,CLOWN-ALLEY>
				   ,HELPED-THUMB>
			      <TELL "He winks at you and flashes a smile." CR>)
			     (T
			      <FSET ,TABLE ,RMUNGBIT>
			      <TELL ,YOU-SEE
" a trembling midget hand pull the tablecloth back down." CR>)>)>)     
	       (<AND <VERB? TAKE>
		     <PRSO? ,THUMB>>
	        <COND (<OR <EQUAL? ,HERE ,RING>
			   <RUNNING? ,I-CLOWN-ALLEY>>
		       <TELL "He">
		       <COND (,HELPED-THUMB
			     <TELL "'s had it with the upsy-daisy stuff and">)>
		       <COND (<EQUAL? ,HERE ,RING>
			      <TELL " resists furiously">)
			     (T
			      <TELL " leans back out of reach">)>
		       <TELL ,PERIOD>)
		      (<RUNNING? ,I-BOOST>
		       <PERFORM ,V?RAISE ,THUMB>
		       <RTRUE>)
		      (<OR <RUNNING? ,I-THUMB>
			   <AND <RUNNING? ,I-CLOWN-EXIT>
				<NOT ,HELPED-THUMB>>>
		       <TELL 
"As you reach down, he scampers between your legs">
		       <COND (<OR <NOT <RUNNING? ,I-CLOWN-EXIT>>
				  <RUNNING? ,I-THUMB>>
			      <TELL 
", giggling in his strangely high-pitched, compressed voice">)>
		       <TELL ,PERIOD>)
		      (<AND <RUNNING? ,I-CLOWN-EXIT>
			    <EQUAL? <ITAKE> T>>
		       <COND (<G? ,CLOWN-EXIT-COUNTER 3>
			      <SETG CLOWN-EXIT-COUNTER 3>)>
		       <MOVE ,FLOWER ,THUMB>
		       <TELL 
"As you put your hands on the midget, for an instant he squirms, then, deciding
you mean no harm, relaxes in your grip and you're able to lift him.|
|
You notice him wearing a daisy in the lapel of his uniform." CR>
		       <RTRUE>)
		      (<EQUAL? <ITAKE> T>
		       <TELL 
"You cradle the little performer in your arms and he allows you to lift
him." CR>)>
		<RTRUE>)
	       (<VERB? MOVE>
		<V-DIG>)
	       (<VERB? FOLLOW>
		<COND (<EQUAL? ,FOLLOW-FLAG 1 10>
		       <DO-WALK ,P?WEST>)
		      (<EQUAL? ,FOLLOW-FLAG 2>
		       <COND (<EQUAL? ,HERE ,BACK-YARD>
			      <DO-WALK ,P?SOUTH>)
			     (T
			      <DO-WALK ,P?WEST>)>)>)>>

;"NDESCBIT for when he's sleeping, desc in clown-alley-f"

<ROUTINE THUMB-DESCFCN ("OPTIONAL" X)
	 <COND (<AND <EQUAL? ,HERE ,CLOWN-ALLEY>
		     <RUNNING? ,I-CLOWN-ALLEY>>
		<TELL 
"Sitting on an upper bunk, with his arms folded and legs swinging,
is Comrade Thumb.">)
	       (<FSET? ,CROWBAR ,TOUCHBIT>
		<TELL 
"Lying perfectly still in the " D ,UPPER ", yet with his eyes wide open, is "
D ,THUMB ".">)
	       (T
		<TELL "Comrade Thumb is here.">)>>

<ROUTINE THUMB-DRINKS ()
	 <TELL D ,THUMB " slurps his fill of " D ,WATER  ". He then plops
down, gives you a quick salute,">>
	       
<OBJECT UNIFORM
	(IN THUMB)
	(DESC "uniform")
	(SYNONYM UNIFORM)
	(ADJECTIVE RUSSIAN GENERAL)
	(FLAGS NDESCBIT TRYTAKEBIT VOWELBIT)	
	(ACTION UNIFORM-F)>

<ROUTINE UNIFORM-F ()
	 <COND (<AND <IN? ,UNIFORM ,THUMB>
		     <VERB? TAKE REMOVE>>		
		<KIND-OF-PERFORMER ,THUMB>)>>

<ROUTINE KIND-OF-PERFORMER ("OPTIONAL" (PERSON <>))
	 <COND (.PERSON
		<TELL D .PERSON>)
	       (T
		<TELL "Tina">)>
	 <TELL " is not that kind of performer." CR>>

<OBJECT FLOWER
	(IN LOCAL-GLOBALS)
	(DESC "flower")
	(SYNONYM FLOWER DAISY)
	(FLAGS NDESCBIT TRYTAKEBIT)	
	(ACTION FLOWER-F)>

<ROUTINE FLOWER-F ()
	 <COND (<VERB? EXAMINE TAKE PICK RUB SMELL>
		<COND (<FSET? ,FLOWER ,RMUNGBIT>
		       <TELL 
"You're not going to fall for that trick twice." CR>
		       <RTRUE>)
		      (<NOT <VERB? SMELL>>
		       <TELL "As you reach for it, t">)
		      (T
		       <TELL "T">)>
		<FSET ,FLOWER ,RMUNGBIT>
		<TELL		
"he daisy spritzes some water in your face, and " D ,THUMB "'s cherubic
face lets out a squeal of delight." CR>)>>

<GLOBAL BOOST-COUNTER 0>

<GLOBAL HELPED-THUMB <>>

<ROUTINE I-BOOST ()
	 <SETG BOOST-COUNTER <+ ,BOOST-COUNTER 1>>
	 <COND (<EQUAL? ,BOOST-COUNTER 7>
		<BOOST-EXIT>)
	       (T
	        <COND (<EQUAL? ,HERE ,CON-AREA>
		       <CRLF>
		       <COND (<EQUAL? ,BOOST-COUNTER 1>
			      <TELL
"The last of the crowd just now trickles eastward through the " 
D ,TURNSTILE ".|
|
A midget decked out in a Russian general's uniform is standing before">)
		             (<EQUAL? ,BOOST-COUNTER 2>
	                      <TELL
"The little general gets up on his tiptoes in front of">)
	                     (<EQUAL? ,BOOST-COUNTER 3>
		              <TELL 
"Attempting to do a pull-up, Comrade Thumb manages to sprawl himself onto" >)
	            	     (<EQUAL? ,BOOST-COUNTER 4>
		              <TELL
"Straining his neck to reach the spout, the midget gropes for the button,
loses his grip and plops to the " D ,GROUND " before" >)
	                    (<EQUAL? ,BOOST-COUNTER 5>
		             <TELL
"The midget looks up at you sadly, then at">)
	                    (<EQUAL? ,BOOST-COUNTER 6>
		             <TELL
"Comrade Thumb flaps his little arms once in frustration,">
                             <BOOST-EXIT>
			     <RFALSE>)>
	              <TELL " the " D ,FOUNTAIN "." CR>)
		     (T
		      <RFALSE>)>)>>

<ROUTINE BOOST-EXIT ()
	 <MOVE ,THUMB ,LOCAL-GLOBALS>	 
	 <DISABLE <INT I-BOOST>>
	 <MOVE ,CROWD ,STANDS-ROOM>
	 <COND (<AND <EQUAL? ,HERE ,CON-AREA>
		     <L? ,BOOST-COUNTER 7>>
		<TELL " and waddles off into the darkness." CR>
		<SETG FOLLOW-FLAG 1>
		<ENABLE <QUEUE I-FOLLOW 2>>)>
	 <RTRUE>> 

<OBJECT JOEY
	(IN LOCAL-GLOBALS)
	(DESC "Chuckles")
	(DESCFCN JOEY-DESC)
	(SYNONYM CHUCKLES CLOWN JOEY MAN)
	(ADJECTIVE ;JOEY LANKY TALL)
	(FLAGS ACTORBIT PERSON NARTICLEBIT CONTBIT OPENBIT SEARCHBIT)
	(ACTION JOEY-F)>

;"RMUNGBIT = asked guard about him"

<ROUTINE JOEY-DESC ("OPTIONAL" X)
	 <COND (<RUNNING? ,I-CLOWN-ALLEY>
		<TELL
"Chuckles the clown is leaning in front of a mirror, removing his makeup.">)
	       (<EQUAL? ,HERE ,BACK-YARD>
		<TELL
"A tall and lanky clown in baggy pants trudges out of the ">
		<COND (<EQUAL? ,P-WALK-DIR ,P?EAST>
		       <TELL D ,DARKNESS>)
		      (T
		       <TELL "tent">)>
		<TELL
" and toward the " D ,TURNSTILE ". " D ,THUMB " follows behind.">)
	       (<EQUAL? ,HERE ,EAST-CAMP>
		<TELL
"Chuckles is standing, out of costume, in front of the aluminum trailer.">
		<COND (<EQUAL? ,WIPE-C 0>
		       <TELL " As you approach, ">
		       <COND (<JOKE-TIME? ,JOEY-JOKE>
			      <SETG JOEY-JOKE T>
			      <TELL 
"he glances at you and says, \"Pick up an application at the " D ,WAGON 
", not here.\"">)
			     (T
			      <TELL "he begins polishing away at it.">)>)>)>>

<GLOBAL JOEY-JOKE <>>

<ROUTINE JOEY-F ()
      	 <COND (<EQUAL? ,WINNER ,JOEY>  ;"EDDIE omitted"
                <COND (<AND <VERB? TELL-ABOUT>
	                    <PRSO? ,ME>>
	               <SETG WINNER ,PROTAGONIST>
	               <PERFORM ,V?ASK-ABOUT ,JOEY ,PRSI>
	               <SETG WINNER ,JOEY>
	               <RTRUE>)
	              (<VERB? HELLO>
	               <SETG WINNER ,PROTAGONIST>
	               <PERFORM ,V?HELLO ,JOEY>
	               <SETG WINNER ,JOEY>
	               <RTRUE>)
		      (<AND <VERB? YOU-ARE-OBJECT>
			    <PRSO? ,EDDIE>>
		       <SETG WINNER ,PROTAGONIST>
		       <PERFORM ,V?TELL ,EDDIE>
		       <SETG WINNER ,JOEY>
		       <RTRUE>)
		      (T
		       <TELL ,BEAT-IT>
                       <STOP>)>)                 ;"end of winner"
	       (<AND <VERB? ASK-ABOUT TELL-ABOUT>
		     <PRSI? ,EDDIE>
		     <FSET? ,EDDIE ,RMUNGBIT>>
		<PERFORM ,V?HELLO ,EDDIE>
		<RTRUE>)
	       (<AND <TALKING-TO? ,JOEY>		
		     <RUNNING? ,I-CLOWN-ALLEY>>
		<PERFORM ,V?RUB ,JOEY>
		<RTRUE>)
	       (<AND <TALKING-TO? ,JOEY>
		     <NOT <VERB? TELL>>>
	    	<TELL ,BEAT-IT>
		<STOP>)
	       (<VERB? FOLLOW>
		<COND (<EQUAL? ,FOLLOW-FLAG 2>
		       <DO-WALK ,P?SOUTH>)
		      (<EQUAL? ,FOLLOW-FLAG 3>
		       <DO-WALK ,P?WEST>)
	              (<EQUAL? ,FOLLOW-FLAG 4>
		       <DO-WALK ,P?EAST>)>)
	       (<AND <VERB? GIVE SHOW>
	             <PRSI? ,JOEY ,EDDIE>>
		<SETG P-IT-OBJECT ,JOEY>
	        <COND (<AND <PRSO? RIBBON>
			    <NOT <FSET? ,RIBBON ,RMUNGBIT>>>
		       <SETG SCARE-NUMBER <+ ,SCARE-NUMBER 1>>
		       <FSET ,RIBBON ,RMUNGBIT>
		       <COND (<JOEY-SCARED?>
			      <RFATAL>)
			     (<FSET? ,TRADE-CARD ,RMUNGBIT>
			      <HATE-TO-SEE>
			      <ELBOW-GREASE>)
		       	    (T
			     <TELL "\"Never saw it before in my life.\"" CR>)>)
		      (<AND <PRSO? TRADE-CARD>
			    <NOT <FSET? ,TRADE-CARD ,RMUNGBIT>>>
		       <SETG SCARE-NUMBER <+ ,SCARE-NUMBER 1>>
		       <FSET ,TRADE-CARD ,RMUNGBIT>
		       <COND (<JOEY-SCARED?>
			      <RFATAL>)
			     (<FSET? ,RIBBON ,RMUNGBIT>
			      <TELL 
"\"That ribbon in her hair looks like yours.\" He pauses. ">
			      <HATE-TO-SEE>
			      <ELBOW-GREASE>
			      <RTRUE>)
		       	    (T
			     <TELL 
"\"Good product. I'd highly recommend it.\"" CR>)>)
		      (<AND <PRSO? ,SCRAP>
		       	    <NOT <FSET? ,SCRAP ,RMUNGBIT>>>
		       <FSET ,SCRAP ,RMUNGBIT>
		       <SETG SCARE-NUMBER <+ ,SCARE-NUMBER 1>>
		       <TELL 
D ,JOEY " looks skeptically at the " D ,SCRAP " while listening to you
tell where you found it. ">
		       <COND (<JOEY-SCARED? T>
			      <RFATAL>)
			     (<FSET? ,NOTE ,RMUNGBIT>
			      <CHERRY-PIE>
			      <ELBOW-GREASE>)
			     (T
			      <TELL CR CR 
"\"Yea, I make paper dolls for the local kids. It's part of my act. So
what?\"" CR>)>
		       <RTRUE>)
		      (<AND <PRSO? ,NOTE>
		       	    <NOT <FSET? ,NOTE ,RMUNGBIT>>>
		       <FSET ,NOTE ,RMUNGBIT>
		       <SETG SCARE-NUMBER <+ ,SCARE-NUMBER 1>>
		       <TELL 
"He reads the " D ,NOTE ", silently mouthing the words. ">
		       <COND (<JOEY-SCARED? T>
			      <RFATAL>)
			     (<FSET? ,SCRAP ,RMUNGBIT>
			      <CHERRY-PIE>
			      <ELBOW-GREASE>)
			     (T
			      <TELL
"He deadpans, \"Fascinating. Don't let the " D ,DICK " find you with
that.\"" CR>)>
		       <RTRUE>)
		      (<AND <PRSO? ,SHEET>	
		       	    <NOT <FSET? ,SHEET ,RMUNGBIT>>>
		       <FSET ,SHEET ,RMUNGBIT>
		       <SETG SCARE-NUMBER <+ ,SCARE-NUMBER 1>>
		       <TELL
"Chuckles's eyes dart between the various numbers in the multiple columns on
the "  D ,SHEET ". ">
		      <COND (<JOEY-SCARED? T>
			     <RFATAL>)
			    (,JOEY-NAME-KNOWN
			     <TELL 
"\"So what? It's tough all over. I don't hold any grudge against "
D ,MUNRAB ". Hell, I'm just a clown, a happy clown.\" ">
			     <ELBOW-GREASE>)
			    (T
			     <TELL 
"\"I don't know anyone by that name.\"" CR>)>)
		     (<PRSO? ,SHEET ,NOTE ,SCRAP ,RIBBON ,TRADE-CARD>
		      <TELL "He ignores it this time." CR>)>)>>

<ROUTINE HATE-TO-SEE ()
	 <TELL
"\"I'd hate to be caught red-handed holding that " D ,RIBBON " if I were
you.\" ">>

<GLOBAL WON-JOEY <>>

<GLOBAL WIPE-C 100> ;"begins on east-camp m-enter, on 8 Joey enters trailer,
		     he comes here as you m-enter every time. 100 is he hasn't
		     come out once yet."
<ROUTINE I-JOEY ()
 	 <SETG WIPE-C <+ ,WIPE-C 1>>
	 <COND (<EQUAL? ,WIPE-C 8>		
		<MOVE ,JOEY ,LOCAL-GLOBALS>
	        <COND (<EQUAL? ,HERE ,EAST-CAMP>
		       <TELL-SCREWS "enters">
		       OH<SETG FOLLOW-FLAG 4>
		       <ENABLE <QUEUE I-FOLLOW 2>>
		       <TELL  " the " D ,TAMER-TRAILER "." CR>)>)
	       (<AND <EQUAL? ,HERE ,EAST-CAMP>
		     <EQUAL? ,WIPE-C 2 4 6>
		     <NOT <AND <VERB? SHOW GIVE>
			       <PRSI? ,JOEY>>>>
		<TELL CR
D ,JOEY " dribbles a little Dr. Nostrum's onto his rag and continues wiping
away at the " D ,TAMER-TRAILER "." CR>)>>

<ROUTINE ELBOW-GREASE ()
	 <TELL D ,JOEY>
	 <COND (<EQUAL? ,SCARE-NUMBER 2>
		<TELL ", unable to mask his concern,">)
	       (<EQUAL? ,SCARE-NUMBER 3>
		<TELL ", looking unclownly and perturbed,">)
	       (<EQUAL? ,SCARE-NUMBER 4>
		<TELL 
" does a slow burn as he continues cleaning the " D ,TAMER-TRAILER "." CR>
		<RTRUE>)>
	 <TELL " applies extra elbow grease to his cleaning." CR>>

<GLOBAL SCARE-NUMBER 0>

<ROUTINE JOEY-SCARED? ("OPTIONAL" (CRLF? <>))
	 <COND (<AND ,JOEY-NAME-KNOWN
		     <FSET? ,NOTE ,RMUNGBIT>
		     <FSET? ,SHEET ,RMUNGBIT>
		     <FSET? ,SCRAP ,RMUNGBIT>
		     <FSET? ,TRADE-CARD ,RMUNGBIT>
		     <FSET? ,RIBBON ,RMUNGBIT>>
	       	<SETG WON-JOEY T>
	 	<DISABLE <INT I-JOEY>>
	 	<MOVE ,JOEY ,LOCAL-GLOBALS>
	        <SETG SCORE <+ ,SCORE 10>>
		<COND (.CRLF? 
		       <CRLF> <CRLF>)>
		<TELL-SCREWS "hustles off to the west">
		<SETG FOLLOW-FLAG 3>
		<ENABLE <QUEUE I-FOLLOW 2>>
		<TELL ,PERIOD>
		<RTRUE>)
	       (T
	        <RFALSE>)>>

<ROUTINE TELL-SCREWS (STRING)
	 <COND (,WON-JOEY
		<TELL 
"Looking like a clown with a hotfoot, ">)>
	        <TELL 
D ,JOEY " suddenly screws the cap onto the flask of Dr. Nostrum's and " 
.STRING>>

<ROUTINE CHERRY-PIE ()
 	 <TELL CR CR
"\"So you think you've fingered me for this note. Pretty thin stuff, if
you ask me. Besides, I've got no gripes against the bossman. Why, here I
am doing cherry pie in the middle of the night.\" ">>

<ROOM CLOWN-ALLEY
      (IN ROOMS)
      (DESC "Clown Alley")
      (NORTH PER EXIT-CLOWN-ALLEY)
      (OUT PER EXIT-CLOWN-ALLEY)
      (FLAGS ONBIT RLANDBIT INDOORSBIT)
      (GLOBAL WARPED-DOOR LADDER CLOWN-TRAILER)
      (ACTION CLOWN-ALLEY-F)>

<GLOBAL CLOWN-ALLEY-SCENE <>>

<ROUTINE CLOWN-ALLEY-F (RARG)
	 <COND (<EQUAL? .RARG ,M-LOOK>
		<TELL
"The gut of the trailer exposes the underside of circus life -- grungy
costumes strewn about, crooked and cracked mirrors, the musty odor of
fresh makeup mingled with clown sweat infusing the air.|
|
Against the wall is a row of cramped-looking bunks, and running from the
floor to one " D ,UPPER " is a small ladder. ">
		<COND (<OR <FIRST? ,UPPER>
			   <FIRST? ,LOWER>>
		       <TELL ,YOU-SEE>
		       <COND (<FIRST? ,LOWER>			      
			      <PRINT-BUNKS ,LOWER ,UPPER>)
			     (T
			      <PRINT-BUNKS ,UPPER ,LOWER>)>)>		 
		<CRLF>)
     	       (<EQUAL? .RARG ,M-ENTER>
		<STEP-INTO-TRAILER>	        
		<COND (<NOT ,CLOWN-ALLEY-SCENE>
		       <SETG CLOWN-ALLEY-SCENE T>
		       <SETG CLOWN-COUNTER 0>
		       <ENABLE <QUEUE I-CLOWN-ALLEY -1>>)>)
	       (<AND <EQUAL? .RARG ,M-BEG>
		     <ENABLED? ,I-CLOWN-ALLEY>>
		<COND (<OR <AND <VERB? REMOVE TAKE-OFF>
			        <PRSO? ,MASK>>
			   <NOT <FSET? ,MASK ,WORNBIT>>>
		       <FCLEAR ,MASK ,WORNBIT>
		       <TELL ;CR "Y">
		       <UNMASK>)
		      ;(<AND <FSET? ,WARPED-DOOR ,OPENBIT>
			    <EQUAL? ,P-WALK-DIR ,P?NORTH ,P?OUT>>
		       <TELL
"Sensing your eagerness to leave Chuckles recognizes, chases out ...">)
		      (<DISTURB? ,JOEY>
		       <COND (<EQUAL? ,FOLLOW-FLAG 99>
			      <CRLF>)>
		       <TELL
"Chuckles whirls around, strips you of your disguise and y">
		       <UNMASK>)
		      (T
		       <RFALSE>)>)>>

<ROUTINE PRINT-BUNKS (B1 B2)
  	 <PRINT-CONTENTS .B1>
	 <TELL " sitting on the " D .B1>
	 <COND (<FIRST? .B2>
		<TELL", and">
	 	<PRINT-CONTENTS .B2>
         	<TELL " on the " D .B2>)>
	 <TELL ".">>

<ROUTINE EXIT-CLOWN-ALLEY ()
	 <COND (<NOT <FSET? ,WARPED-DOOR ,OPENBIT>>
		<TELL "The " D ,WARPED-DOOR " is closed." CR>
		<RFALSE>)
	       (<AND <RUNNING? ,I-CLOWN-ALLEY>
		     <HELD? ,TRAY>>
		<MOVE ,TRAY ,LOCAL-GLOBALS>
		<TELL 
D ,JOEY " notices a little squirreliness on your part, confronts you, grabs
the " D ,TRAY ", and throws you out." CR CR>
		<RETURN ,WEST-CAMP>)
	       (T
		<RETURN ,WEST-CAMP>)>> 
		

<OBJECT CLOWN-TRAILER
	(IN LOCAL-GLOBALS)
	(DESC "trailer")
	(SYNONYM TRAILER ALLEY WAGON)
	(ADJECTIVE CLOWN DILAPI)
	(FLAGS NDESCBIT)
	(ACTION CLOWN-TRAILER-F)>

<ROUTINE CLOWN-TRAILER-F ()
	 <COND (<VERB? EXAMINE>
	        <COND (<EQUAL? ,HERE ,WEST-CAMP>
		       <TELL
"It's a vintage model that's seen plenty of bad road. The door, which is "> 
		       <COND (<FSET? ,WARPED-DOOR ,OPENBIT>
			      <TELL "open">)
			     (T
			      <TELL "closed">)>
		       <TELL ", appears warped." CR>)
		      (T
		       <V-LOOK>)>)
	       (<AND <VERB? SMELL>
		     <EQUAL? ,HERE ,CLOWN-ALLEY>>
		<PERFORM ,V?SMELL>
		<RTRUE>)	       
	       (<VERB? OPEN CLOSE UNLOCK LOCK>
		<PERFORM ,PRSA ,WARPED-DOOR ,PRSI>
		<RTRUE>)
	       (<VERB? WALK-TO THROUGH ENTER>		     
		<COND (<EQUAL? ,HERE ,WEST-CAMP>
		       <DO-WALK ,P?IN>)
		      (<EQUAL? ,HERE ,CLOWN-ALLEY>
		       <TELL ,LOOK-AROUND CR>)>)>> 	 

;"CLOWN-COUNTER OF 6 is a win"

<ROUTINE I-CLOWN-ALLEY ()
	 <COND (<FSET? ,WARPED-DOOR ,RMUNGBIT>
		<FCLEAR ,WARPED-DOOR ,RMUNGBIT>
		<RFALSE>)>
	 <SETG CLOWN-COUNTER <+ 1 ,CLOWN-COUNTER>> 
   	 <COND (<AND <NOT <EQUAL? ,HERE ,CLOWN-ALLEY>>
		     <FSET? ,WARPED-DOOR ,OPENBIT>>
		<DISABLE <INT I-CLOWN-ALLEY>>
		<FCLEAR ,WARPED-DOOR ,OPENBIT>
	        <FSET ,WARPED-DOOR ,LOCKEDBIT>
		<COND (<EQUAL? ,HERE ,WEST-CAMP>
		       <TELL CR 
"The " D ,WARPED-DOOR " is slammed shut." CR>)>)
	       (T
		<COND (<EQUAL? ,CLOWN-COUNTER 2>
		       <SETG P-IT-OBJECT ,WARPED-DOOR>
		       <TELL CR 
"Chuckles speaks, \"Sorry about the door, Malcom, but Johnny Tin Plate's
out there nosing around.">
		       <COND (<FSET? ,WARPED-DOOR ,OPENBIT>
			      <TELL " Close it, will you?">)>
		       <TELL "\"">)
	              (<AND <EQUAL? ,CLOWN-COUNTER 3>
			    <NOT ,HELPED-THUMB>>
		       <TELL CR 
D ,THUMB " mutters something in Russian to Chuckles." CR CR>
		       <PERFORM ,V?RUB ,JOEY>
		       <RTRUE>)
	       	      (<EQUAL? ,CLOWN-COUNTER 4>
		       <TELL CR 
"\"Let's just hope he doesn't find the grift.">
		       <COND (<FSET? ,WARPED-DOOR ,OPENBIT>
			      <TELL " Close the door, huh?">)>
		       <TELL "\"">)		       
	              (<EQUAL? ,CLOWN-COUNTER 6>
		       <COND (<FSET? ,WARPED-DOOR ,OPENBIT>
			      <SETG FOLLOW-FLAG 99>
			      <ENABLE <QUEUE I-FOLLOW 2>>
			      <PERFORM ,V?RUB ,JOEY>
			      <RTRUE>)
			     (T
			      <SETG CLOWN-COUNTER 7>
			      <TELL CR 
"\"It'll be okay unless somebody tips him off about shoving Annie Oakley
under the old front by the elephant tent --\"" CR CR "His voice suddenly
halts. ">
		       <PERFORM ,V?RUB ,JOEY>
	               <RTRUE>)>)
	              (T
		       <RFALSE>)>
	         <CRLF>)
		(T
		 <RFALSE>)>>

<GLOBAL UNMASKED? <>>

<ROUTINE UNMASK ()
	 <SETG UNMASKED? T>
	 <DISABLE <INT I-CLOWN-ALLEY>>	 
	 <FCLEAR ,WARPED-DOOR ,OPENBIT>	 
	 <FSET ,WARPED-DOOR ,LOCKEDBIT>	 
	 <TELL 
"ou're suddenly eye-to-eye with a very unhappy clown whose greasepaint red
horseshoe smile practically melts off his face. " CR CR>
	 <COND (<OR <NOT <FSET? ,MASK ,WORNBIT>>
		    <HELD? ,TRAY>>
		<TELL "Snatching away the ">
		<COND (<AND <NOT <FSET? ,MASK ,WORNBIT>>
			    <HELD? ,TRAY>>
		       <TELL  D ,MASK " and the " D ,TRAY ", ">)
	       	      (<HELD? ,TRAY>
		       <TELL D ,TRAY ", ">)
		      (T
		       <TELL D ,MASK ", ">)>)>
	 <MOVE ,TRAY ,LOCAL-GLOBALS>
	 <TELL 
"Chuckles seizes you by the scruff of your neck, and the irate clown hustles you out of the " D ,CLOWN-TRAILER "." CR CR>
	<FCLEAR ,MASK ,WORNBIT>
	<MOVE ,MASK ,LOCAL-GLOBALS>
	<GOTO ,WEST-CAMP>> 

<OBJECT TRAY
	(IN LOWER)
        (DESC "ash tray")
	(SYNONYM TRAY ASHTRAY)
	(ADJECTIVE ASH)
	(FLAGS OPENBIT TRANSBIT CONTBIT TAKEBIT SEARCHBIT VOWELBIT)
	(SIZE 4)
	(CAPACITY 2)
	(ACTION TRAY-F)>

<ROUTINE TRAY-F ()
	 <COND (<AND <VERB? EMPTY SEARCH>
		     <IN? ,ASH ,TRAY>>
		<PERFORM ,V?MOVE ,ASH>
		<RTRUE>)
	       (<VERB? OPEN CLOSE>
		<V-COUNT>)>>

<OBJECT ASH
	(IN TRAY)
	(DESC "heap of black ash")
	(SYNONYM ASHES ASH HEAP)
	(ADJECTIVE ;DARK BLACK)
	(FLAGS TAKEBIT)
	(SIZE 1)
	(ACTION ASH-F)>

;"ASH rmungbit = have disturbed the ashes, revealing newsprint"

<ROUTINE ASH-F ()
	 <COND (<VERB? EXAMINE>
		<TELL 
"The ash, by its jet blackness, does not appear to be the remnant of
tobacco." CR>)
	       (<VERB? TAKE SEARCH RUB LOOK-INSIDE LOOK-UNDER MOVE>
		<COND (<FSET? ,ASH ,RMUNGBIT>
		       <TELL
"The ashes sift through your fingers." CR>)
		      (T
		       <FSET ,ASH ,RMUNGBIT>
		       <MOVE ,SCRAP ,TRAY>
		       <TELL
"In disturbing the " D ,ASH ", a " D ,SCRAP " is revealed." CR>)>)
	       (<VERB? EMPTY DROP POUR>
		<MOVE ,ASH ,LOCAL-GLOBALS>
		<TELL "The ashes swirl through the air and disappear">
		<COND (<OR <AND <FSET? ,ASH ,RMUNGBIT>
			        <IN? ,SCRAP ,TRAY>>
			   <NOT <FSET? ,ASH ,RMUNGBIT>>>
		       <MOVE ,SCRAP ,HERE>
		       <TELL 
" as a tiny " D ,SCRAP " floats down">)>
		<TELL ,PERIOD>)>>

<OBJECT SCRAP
	(IN LOCAL-GLOBALS)
	(DESC "scrap of newsprint")
	(SYNONYM NEWSPRINT PRINT SCRAP M)
	;(ADJECTIVE LETTER NEWS TINY)
	(FLAGS TAKEBIT)
	(SIZE 1)
	(ACTION SCRAP-F)>

<ROUTINE SCRAP-F ()
	 <COND (<VERB? EXAMINE>
		<TELL
"The " D ,SCRAP " is about an inch square." CR>)
	       (<AND <VERB? COMPARE>
		     <EQUAL? ,NOTE ,PRSO ,PRSI>>
		<TELL 
"The \"M\" on the " D ,SCRAP " looks like it was cut from the the same
newspaper as the letters on the " D ,NOTE "." CR>)  
	       (<VERB? READ>
		<TELL 
"There's a paragraph of yak trivia on one side, and the letter \"M\" in
48-point type on the other." CR>)>>

<OBJECT COSTUME
	(IN CLOWN-ALLEY)
	(DESC "costume")
	(SYNONYM COSTUM)
	(ADJECTIVE GRUNGY)
	(FLAGS TRYTAKEBIT NDESCBIT)
	(ACTION COSTUME-F)>

<ROUTINE COSTUME-F ()
	 <COND (<VERB? TAKE>
		<TELL "Nope, too repulsive." CR>)>>

<OBJECT MIRROR
	(IN CLOWN-ALLEY)
	(DESC "mirror")
	(SYNONYM MIRROR)
	(FLAGS NDESCBIT)
	(ACTION MIRROR-F)>

<ROUTINE MIRROR-F ()
	 <COND (<VERB? LOOK-INSIDE>
		<COND (<FSET? ,MASK ,WORNBIT>
		       <TELL 
,YOU-SEE " your beady eyes through the " D ,MASK "." CR>)
		      (T
		       <PERFORM ,V?EXAMINE ,ME>
		       <RTRUE>)>)>>

<OBJECT UPPER
	(IN CLOWN-ALLEY)
	(DESC "upper bunk")
	(SYNONYM BUNK BED BUNKS)
	(ADJECTIVE UPPER)
	(FLAGS NDESCBIT OPENBIT SURFACEBIT TRANSBIT CONTBIT VOWELBIT)
	(CAPACITY 100)
	(ACTION BUNK-F)>

;"UPPER RMUNGBIT = tried to get on the bunk"

<OBJECT LOWER
	(IN CLOWN-ALLEY)
	(DESC "lower bunk")
	(SYNONYM BUNK BED BUNKS)
	(ADJECTIVE LOWER)
	(FLAGS NDESCBIT OPENBIT SURFACEBIT TRANSBIT CONTBIT SEARCHBIT)
	(CAPACITY 150)
	(ACTION BUNK-F)>

;"LOWER RMUNGBIT = tried to get on the bunk"

<ROUTINE BUNK-F ()
	 <COND (<AND <VERB? EXAMINE LOOK-INSIDE>
		     <EQUAL? ,PRSO ,UPPER>
		     <IN? ,THUMB ,HERE>>
		<TELL D ,THUMB " is there. ">
		<COND (<FIRST? ,UPPER>
		       <RFALSE>)>
		<CRLF>
		<RTRUE>)
	       (<VERB? BOARD CLIMB-ON CLIMB-FOO THROUGH>
		<COND (<EQUAL? ,PRSO ,UPPER>
		       <SETG PRSO ,CEILING>
		       <FSET ,UPPER ,RMUNGBIT>)
		      (T
		       <SETG PRSO ,UPPER>
		       <FSET ,LOWER ,RMUNGBIT>)>
		<SETG CLOCK-WAIT T>
		<TELL-HIT-HEAD>
		<COND (<AND <FSET? ,UPPER ,RMUNGBIT>
			    <FSET? ,LOWER ,RMUNGBIT>>
		        <TELL 
"Hadn't you really ought to stop trying to sleep around like this?" CR>
		        <SETG AWAITING-REPLY 2>
	                <ENABLE <QUEUE I-REPLY 2>>
			<SETG CLOCK-WAIT T>)>
		<RTRUE>)>>

<OBJECT WARPED-DOOR
	(IN LOCAL-GLOBALS)
	(DESC "trailer door")
	(SYNONYM DOOR LOCK)
	(ADJECTIVE WARPED TRAILER DAMAGE)
	(FLAGS NDESCBIT DOORBIT LOCKEDBIT)
	(ACTION WARPED-DOOR-F)>

;"RMUNGBIT = Chuckles wont answer"

<GLOBAL CLOWN-COUNTER 25> ;"25 means door NOT opened for you yet,
			    Zero thru 9 is the undressing clown script."
			  
<GLOBAL WARPED-DOOR-BROKEN <>>

<ROUTINE WARPED-DOOR-F ()
         <COND (<AND <VERB? OPEN PICK>
		     <NOT <FSET? ,WARPED-DOOR ,OPENBIT>>
		     ,PRSI>
		<COND (<EQUAL? ,PRSI ,CROWBAR>
		       <SETG WARPED-DOOR-BROKEN T>
		       <FSET ,WARPED-DOOR ,OPENBIT>
		       <FCLEAR ,WARPED-DOOR ,LOCKEDBIT>
		       <FCLEAR ,CLOWN-ALLEY ,TOUCHBIT>
		       <TELL
"You wedge the " D ,CROWBAR " between the frame and the door then give it
a yank. The " D ,WARPED-DOOR " pops open." CR>)
		      (T
		       <TELL ,IT-LOOKS-LIKE>
		       <ARTICLE ,PRSI T>
		       <TELL " is unequal to the task." CR>)>)
	       (<AND <VERB? OPEN PICK>
		     <NOT ,WARPED-DOOR-BROKEN>
		     <NOT ,PRSI>
		     <HELD? ,CROWBAR>>
		<TELL "(with the " D ,CROWBAR ")" CR>
		<PERFORM ,V?OPEN ,WARPED-DOOR ,CROWBAR>
		<RTRUE>)
	       (<AND <VERB? CLOSE>
		     ,WARPED-DOOR-BROKEN>
		<TELL "The damaged door creaks back open." CR>)
	       (<AND <VERB? CLOSE>
		     <EQUAL? ,HERE ,WEST-CAMP>
		     <IN? ,JOEY ,CLOWN-ALLEY>
		     <NOT <FSET? ,CLOWN-ALLEY ,TOUCHBIT>>>
		<FSET ,WARPED-DOOR ,LOCKEDBIT>
		<RFALSE>)
	       (<VERB? EXAMINE>
		<TELL 
,YOU-SEE " that the door is warped slightly along its edge." CR>)
	       (<VERB? KNOCK>
		<COND (<OR ,UNMASKED?
		           <FSET? ,WARPED-DOOR ,RMUNGBIT>
			   <EQUAL? ,HERE ,CLOWN-ALLEY>
			   <NOT <EQUAL? ,CLOWN-COUNTER 25>>>
		       <RFALSE>)
		      (T
		       <TELL
"Chuckles pops his head out from behind the " D ,WARPED-DOOR " and ">
		       <COND (<AND <FSET? ,MASK ,WORNBIT>
				   <NOT <FSET? ,SHAWL ,WORNBIT>>
				   <NOT <FSET? ,DRESS ,WORNBIT>>>
			      <SETG SCORE <+ ,SCORE 10>>
			      <SETG CLOWN-COUNTER 0>
			      <ENABLE <QUEUE I-CLOWN-ALLEY 3>>
			      <FSET ,WARPED-DOOR ,OPENBIT>
		              <FCLEAR ,WARPED-DOOR ,LOCKEDBIT>
			      <TELL
"squints at you through a layer of cold cream, then flings the door open. He
withdraws into the trailer." CR>)
			     (T
			      <FSET ,WARPED-DOOR ,RMUNGBIT>
			      <ENABLE <QUEUE I-CLOWN-ALLEY 5>>
			      <TELL
"shades his eyes to look at you. \"Beat it, lotlice,\" he says, withdrawing
into the trailer and closing the door." CR>)>)
		             (T
			      <RFALSE>)>)>>