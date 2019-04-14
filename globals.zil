"GLOBALS for
		                BALLYHOO
	(c) Copyright 1986 Infocom, Inc.  All Rights Reserved."

<DIRECTIONS ;"Do not change the order of the first 8 without consulting MARC!"
 	    NORTH NE EAST SE SOUTH SW WEST NW UP DOWN IN OUT>

<GLOBAL HERE <>>

<GLOBAL LIT T>

<GLOBAL MOVES 0>

<GLOBAL SCORE 0>

;<GLOBAL INDENTS
	<PTABLE ""
	        "  "
	        "    "
	        "      "
	        "        "
	        "          ">>

;"global objects and associated routines"

<OBJECT GLOBAL-OBJECTS
	(FLAGS INVISIBLE TOUCHBIT SURFACEBIT TRYTAKEBIT OPENBIT
	       SEARCHBIT TRANSBIT WEARBIT RMUNGBIT ONBIT
	       LIGHTBIT RLANDBIT WORNBIT VEHBIT INDOORSBIT
	       LOCKEDBIT EATBIT CAGEBIT CONTBIT PERSON
	       VOWELBIT NDESCBIT DOORBIT ACTORBIT FEMALE
	       NOA AIRBIT CLEARBIT REWEARBIT)>

<OBJECT LOCAL-GLOBALS
	(IN GLOBAL-OBJECTS)
	(SYNONYM ZZMGCK)
	(DESCFCN 0)
        (GLOBAL GLOBAL-OBJECTS)
	(FDESC "F")
	(LDESC "F")
	(PSEUDO "FOOBAR" V-WALK)
	(SIZE 0)
	(TEXT "")
	(CAPACITY 0)>
;"Yes, this synonym for LOCAL-GLOBALS needs to exist... sigh"

<OBJECT ROOMS
	(IN TO ROOMS)>

<OBJECT BACK
	(IN GLOBAL-OBJECTS)
	(DESC "your back")
	(SYNONYM BACK SHOULDER STOMACH)
	(ADJECTIVE YOUR MY)
	(FLAGS NARTICLEBIT NDESCBIT)
	(ACTION BACK-F)>

<ROUTINE BACK-F ()
	 <COND (<IS-NOUN? ,W?STOMACH>
	        <COND (<VERB? LISTEN>
		       <PERFORM ,V?LISTEN ,ROAR>
		       <RTRUE>)
		      (T
		       <V-COUNT>)>)>>

<OBJECT INTDIR
	(IN GLOBAL-OBJECTS)
	(DESC "direction")
	(SYNONYM DIRECTION)
	(ADJECTIVE NORTH EAST SOUTH WEST ; "UP DOWN" NE NW SE SW)
    ;  "(NE 0)
	(SE 0)
	(SW 0)
	(NW 0)" >
	       
;<OBJECT INTNUM
	(IN GLOBAL-OBJECTS)
	(DESC "number")
	(SYNONYM INTNUM)
	(ADJECTIVE NUMBER)>

<OBJECT INTNUM
	(IN GLOBAL-OBJECTS)
	(SYNONYM NUMBER INTNUM)
	;(DESC "number")
	(SDESC "number")
	(ACTION INTNUM-F)>

<ROUTINE INTNUM-F ()
	 <COND (<AND ,P-DOLLAR-FLAG
		     <NOT <EQUAL? ,PRSA ,V?TAKE ,V?ASK-FOR ,V?BET>>
		     ;<NOT <EQUAL? ,PRSA ,V?COUNT-BACK>>
		     <EQUAL? ,WINNER ,PROTAGONIST>
		     <G? ,P-AMOUNT ,POCKET-CHANGE>>
		<TELL ,THAT-MUCH>)
	       (<EQUAL? ,P-NUMBER 21>
		<COND (<EQUAL? ,INTNUM ,PRSO>
		       <PERFORM ,PRSA ,BLACKJACK ,PRSI>)
		      (T
		       <PERFORM ,PRSA ,PRSO ,BLACKJACK>)>
		<RTRUE>)>>

<GLOBAL POCKET-CHANGE 1281>

<OBJECT GLOBAL-MONEY
	(IN GLOBAL-OBJECTS)
	(SYNONYM MONEY CASH)
	(ADJECTIVE COIN COINS MY)
	(DESC "money")
	(FLAGS NOA ;NARTICLEBIT)
	(ACTION GLOBAL-MONEY-F)>

<ROUTINE GLOBAL-MONEY-F ()
	 <COND (<DONT-HANDLE? ,GLOBAL-MONEY>
		<RFALSE>)
	       (<VERB? FIND>
		<V-DIG>
		<RTRUE>)
	       (<VERB? PASS>
		<RFALSE>)
	       (<G? ,POCKET-CHANGE 0>
		<COND (<VERB? COUNT>
		       <TELL "You're carrying ">
		       <PRINT-AMOUNT ,POCKET-CHANGE>
		       <TELL ,PERIOD>)
		      (<VERB? EXAMINE>
		       <TELL "It looks a lot like ">
		       <PRINT-AMOUNT ,POCKET-CHANGE>
		       <TELL ,PERIOD>)
		      (<VERB? TAKE>
		       <HAVE-IT>)
		      (T
		       <TELL 
"Treating your hard-earned cash this way won't get you anywhere." CR>
		       <RFATAL>)>)
	       
	       (T 
		<CANT-SEE ,GLOBAL-MONEY>)>>

<OBJECT DOLLAR
	(IN GLOBAL-OBJECTS)
	(SYNONYM DOLLAR BILL BUCK BUCKS)
	(ADJECTIVE DOLLAR TWO)
	(DESC "dollar")
	;(FLAGS NARTICLEBIT)
	(ACTION DOLLAR-F)>

<ROUTINE DOLLAR-F ()
	 <COND (<AND <L? ,POCKET-CHANGE 100>
		     <NOT <ZERO? ,POCKET-CHANGE>>>
		<TELL ,THAT-MUCH>)
	       (,P-MULT
		<SPECIFY-MONEY>
		<RFATAL>)
	       (<VERB? BET>
		<COND (<EQUAL? <GET ,P-ADJW 0> ,W?TWO>
		       <SETG P-AMOUNT 200>)
		      (T
		       <SETG P-AMOUNT 100>)>
	        <SETG P-DOLLAR-FLAG T>
		<PERFORM ,V?BET ,INTNUM>
		<RTRUE>)
	       (<NOT <VERB? EXAMINE>>
		<GLOBAL-MONEY-F>)>>

<OBJECT PSEUDO-OBJECT
	(DESC "pseudo")
	(ACTION ME-F)>

<OBJECT IT
	(IN GLOBAL-OBJECTS)
	(SYNONYM IT THEM HER HIM)
	(DESC "it")
	(FLAGS VOWELBIT NARTICLEBIT NDESCBIT TOUCHBIT)>

<OBJECT NOT-HERE-OBJECT
	(DESC "it")
	(FLAGS NARTICLEBIT)
	(ACTION NOT-HERE-OBJECT-F)>

<ROUTINE NOT-HERE-OBJECT-F ("AUX" TBL (PRSO? T) OBJ (X <>))
	 <COND (<AND <PRSO? ,NOT-HERE-OBJECT>
		     <PRSI? ,NOT-HERE-OBJECT>>
		<TELL "[Those things aren't here!]" CR>
		<RTRUE>)
	       (<PRSO? ,NOT-HERE-OBJECT>
		<SET TBL ,P-PRSO>)
	       (T
		<SET TBL ,P-PRSI>
		<SET PRSO? <>>)>
	 <COND (.PRSO?
		<COND (<OR <EQUAL? ,PRSA ,V?FIND ,V?FOLLOW ,V?PHONE>
			   <EQUAL? ,PRSA ,V?WHAT ,V?WHERE ,V?WHO>
			   <EQUAL? ,PRSA ,V?WAIT-FOR ,V?WALK-TO ,V?PHONE-WITH>
			   <EQUAL? ,PRSA ,V?BUY ,V?CALL ;,V?SAY>
			   <AND <EQUAL? ,PRSO ,GIRL>
				<EQUAL? ,PRSA ,V?LISTEN>
				<IN? ,GIRL ,LOCAL-GLOBALS>>>
		       <SET X T>
		       <COND (<SET OBJ <FIND-NOT-HERE .TBL .PRSO?>>
			      <COND (<NOT <EQUAL? .OBJ ,NOT-HERE-OBJECT>>
				     <RTRUE>)>)
			     (T
			      <RFALSE>)>)>)
	       
	      (T
	       <COND (<OR <EQUAL? ,PRSA ,V?ASK-ABOUT ,V?ASK-FOR ,V?TELL-ABOUT>
		      	  <EQUAL? ,PRSA ,V?SEARCH-OBJECT-FOR>>
		      <SET X T>
		      <COND (<SET OBJ <FIND-NOT-HERE .TBL .PRSO?>>
			     <COND (<NOT <EQUAL? .OBJ ,NOT-HERE-OBJECT>>
				    <RTRUE>)>)
			    (T
			     <RFALSE>)>)>)>
;"Here is the default 'cant see any' printer"
	 <COND (.X
		<TELL ,SPECIFIC>)	       
	       (<EQUAL? ,WINNER ,PROTAGONIST>
		<TELL "[You can't ">
		<COND (<EQUAL? ,P-XNAM ,W?CONVER ,W?VOICE ,W?VOICES>
		       <TELL "hear">)
		      (T
		       <TELL "see">)>
		<COND (<NOT <NAME? ,P-XNAM>>
		       <TELL " any">)> 
		<NOT-HERE-PRINT .PRSO?>
		<TELL " here.]" CR>)
	       (<OR <EQUAL? ,THUMB ,WINNER>
		    <AND <EQUAL? ,DICK ,WINNER>
		         <OR <FSET? ,DICK ,RMUNGBIT>
			     ,DICK-UNRESPONSIVE>>>
		<RFALSE>)
	       (<EQUAL? ,WINNER ,GUARD>
	        <RFALSE>)
	       (T
		<TELL "Looking confused,">
		<ARTICLE ,WINNER T>
		<TELL " says, \"I don't see">
		<COND (<NOT <NAME? ,P-XNAM>>
		       <TELL " any">)>
		<NOT-HERE-PRINT .PRSO?>
		<TELL " here!\"" CR>)>
	 <STOP>>

<ROUTINE FIND-NOT-HERE (TBL PRSO? "AUX" M-F OBJ)
;"Protocol: return T if case was handled and msg TELLed, NOT-HERE-OBJECT
  if 'can't see' msg TELLed, <> if PRSO/PRSI ready to use"
;"Special-case code goes here. <MOBY-FIND .TBL> returns # of matches. If 1,
then P-MOBY-FOUND is it. You can treat the 0 and >1 cases alike or differently.
Always return RFALSE (not handled) if you have resolved the problem."
	<SET M-F <MOBY-FIND .TBL>>
	;<COND (,DEBUG
	       <TELL "[Found " N .M-F " obj]" CR>)>
	<COND (<EQUAL? 1 .M-F>
	       ;<COND (,DEBUG
		      <TELL "[Namely: " D ,P-MOBY-FOUND "]" CR>)>
	       <COND (.PRSO?
		      <SETG PRSO ,P-MOBY-FOUND>
		      <SETG P-IT-OBJECT ,PRSO>)
		     (T
		      <SETG PRSI ,P-MOBY-FOUND>)>
	       <RFALSE>)
	      (<AND <L? 1 .M-F>
		    <SET OBJ <APPLY <GETP <SET OBJ <GET .TBL 1>> ,P?GENERIC>>>>
;"Protocol: returns .OBJ if that's the one to use
  		    ,NOT-HERE-OBJECT if case was handled and msg TELLed
		    <> if WHICH-PRINT should be called"
	       ;<COND (,DEBUG
		      <TELL "[Generic: " D .OBJ "]" CR>)>
	       <COND (<EQUAL? .OBJ ,NOT-HERE-OBJECT>
		      <RTRUE>)
		     (.PRSO?
		      <SETG PRSO .OBJ>
		      <SETG P-IT-OBJECT ,PRSO>)
		     (T
		      <SETG PRSI .OBJ>)>
	       <RFALSE>)
	      (T
	       ,NOT-HERE-OBJECT)>>

<ROUTINE NOT-HERE-PRINT (PRSO?)
	 <COND (<EQUAL? ,P-XNAM ,EDDIE>
		<TELL "anyone by that name">)
	       (,P-OFLAG
	        <COND (,P-XADJ
		       <TELL " ">
		       <PRINTB ,P-XADJN>)>
	        <COND (,P-XNAM
		       <TELL " ">
		       <PRINTB ,P-XNAM>)>)
               (.PRSO?
	        <BUFFER-PRINT <GET ,P-ITBL ,P-NC1> <GET ,P-ITBL ,P-NC1L> <>>)
               (T
	        <BUFFER-PRINT <GET ,P-ITBL ,P-NC2> <GET ,P-ITBL ,P-NC2L> <>>)>>

<OBJECT LIGHT
	(IN GLOBAL-OBJECTS)
	(DESC "light")
	(SYNONYM LIGHT LIGHTS LAMP SPOTLIGHT)
	(ADJECTIVE GLARING)
	(FLAGS LIGHTBIT)
	(ACTION LIGHT-F)>

<ROUTINE LIGHT-F ()
	 <COND (<VERB? LAMP-ON LAMP-OFF>
		<TELL "You've no access to the lighting equipment." CR>)>>

<OBJECT DARKNESS
	(IN GLOBAL-OBJECTS)
	(DESC "darkness")
	(SYNONYM DARK DARKNESS)
	(FLAGS NARTICLEBIT)
        (ACTION DARKNESS-F)>

<ROUTINE DARKNESS-F ()
	 <COND (<VERB? THROUGH BOARD WALK-TO>
		<V-WALK-AROUND>)>>

;<OBJECT HELLO-OBJECT
	(IN GLOBAL-OBJECTS)
	(DESC "greeting")
	(SYNONYM HELLO HI)
	(FLAGS NDESCBIT)
	;(ACTION HELLO-OBJECT-F)>

;<OBJECT GLOBAL-SLEEP
	(IN GLOBAL-OBJECTS)
	(DESC "sleep")
	(SYNONYM SLEEP NAP SNOOZE)
	(FLAGS NARTICLEBIT)
	(ACTION GLOBAL-SLEEP-F)>

;<ROUTINE GLOBAL-SLEEP-F ()
	 <COND (<VERB? WALK-TO TAKE>
		<PERFORM ,V?SLEEP>
		<RTRUE>)>>

<OBJECT GROUND
	(IN GLOBAL-OBJECTS)
	(SYNONYM FLOOR GROUND FIELD)
	(ADJECTIVE GRASSY ARENA)
	(DESC "ground")
	(ACTION GROUND-F)>

<ROUTINE GROUND-F ()
	 <COND (<VERB? CLIMB-UP CLIMB-ON CLIMB-FOO BOARD>
		<V-DIG>)
	       (<VERB? LOOK-UNDER>
		<V-COUNT>)
	       (<AND <VERB? SEARCH-OBJECT-FOR>
		     <EQUAL? ,HERE ,UNDER-STANDS>
		     <PRSO? ,GROUND>>
		<PERFORM ,V?SEARCH-OBJECT-FOR ,GARBAGE ,PRSI>
		<RTRUE>)
	       (<AND <VERB? EXAMINE>
		     <EQUAL? ,HERE ,PLATFORM-1 ,PLATFORM-2 ,TIGHTROPE-ROOM>>
		<PERFORM ,V?LOOK-DOWN>
		<RTRUE>)
	       (<AND <VERB? EXAMINE>
		     <EQUAL? ,HERE ,APE-ROOM>>
		<V-LOOK>)
	       (<VERB? THROUGH> ;"cross"
	        <V-WALK-AROUND>)
	       (<VERB? LEAVE>
		<DO-WALK ,P?UP>)>>

<OBJECT WALLS
	(IN GLOBAL-OBJECTS)
	(FLAGS NDESCBIT TOUCHBIT)
	(DESC "wall")
	(SYNONYM WALL WALLS)
	(ADJECTIVE SIDE)
	(ACTION WALLS-F)>

<ROUTINE WALLS-F ()
	 <COND (<EQUAL? ,HERE ,PROP-ROOM ,WEST-CAMP>
		<PERFORM ,PRSA ,CANVAS>
		<RTRUE>)
	       (<AND <VERB? PUT>
		     <PRSO? ,THUMB>
		     <EQUAL? ,HERE ,TAMER-ROOM>>
	        <PERFORM ,V?PUT ,THUMB ,CRAWL-SPACE>
		<RTRUE>)
	       (<AND <VERB? KNOCK>		     
		     <EQUAL? ,HERE ,TAMER-ROOM>
		     <IN? ,GIRL ,LOCAL-GLOBALS>
		     <NOT ,GIRL-CRIED>>
	       	<TELL-WIMPER>)>>

<OBJECT HOME
	(IN LOCAL-GLOBALS)
	(DESC "home")
	(SYNONYM HOME)>

<ROUTINE TELL-WIMPER ()
	 <SETG GIRL-CRIED T>
	 <TELL 
"You can hear a faint whimper coming from the " D ,CRAWL-SPACE "." CR>>

<OBJECT CEILING
	(IN GLOBAL-OBJECTS)
	(FLAGS NDESCBIT TOUCHBIT)
	(DESC "ceiling")
	(SYNONYM CEILIN ROOF)
	(ACTION CEILING-F)>

<ROUTINE CEILING-F ()
	 <COND (<AND <EQUAL? ,HERE ,ON-WAGON>
		     <IN? ,MUNRAB ,ON-WAGON>>
		<PERFORM ,V?KNOCK ,OFFICE-DOOR>
		<RTRUE>)
	       (<VERB? LOOK-UNDER>
		<PERFORM ,V?LOOK>
		<RTRUE>)>>

<OBJECT CORNER
	(IN GLOBAL-OBJECTS)
	(DESC "corner")
	(SYNONYM CORNER)
	(FLAGS NDESCBIT)
	(ACTION CORNER-F)>

<ROUTINE CORNER-F ()
	 <COND (<VERB? EXAMINE LOOK-INSIDE>
	        <V-LOOK>
	        <RTRUE>)
	       (<VERB? WALK-TO ENTER THROUGH>
	        <COND (<EQUAL? ,HERE ,BLUE-ROOM>
		       <PERFORM ,V?WALK-TO ,POKER>
		       <RTRUE>)
		      (T
		       <TELL 
"You're close enough to the " D ,CORNER " already." CR>)>)>>

<OBJECT EGRESS
	(IN GLOBAL-OBJECTS)
	(DESC "egress")
	(SYNONYM EGRESS)
	(FLAGS NDESCBIT VOWELBIT)
	(ACTION EGRESS-F)>

<ROUTINE EGRESS-F ()
	 <COND (<VERB? WHAT>
		<TELL
"You'd have to see it to believe it." CR>)	
	       (<VERB? WALK-TO>
		<DO-WALK ,P?OUT>)>>

<OBJECT LADDER
	(IN LOCAL-GLOBALS)
	(DESC "ladder")
	(SYNONYM LADDER ;ROPE STEPLADDER)
	(ADJECTIVE ROPE SMALL)
	(FLAGS NDESCBIT TRYTAKEBIT)
	(ACTION LADDER-F)>

;"LADDER rmungbit = have walked SW from broken fence and seen ladder on wagon"

<ROUTINE LADDER-F ()
	 <COND (<AND <EQUAL? ,HERE ,NEAR-WAGON>
		     <NOT <FSET? ,LADDER ,RMUNGBIT>>>
		<CANT-SEE ,LADDER>)
	       (<VERB? TAKE>
		<COND (<EQUAL? ,P-PRSA-WORD ,W?TAKE ,W?GET ,W?REMOVE>
		       <TELL "It's not takeable." CR>)
		      (T
		       <PERFORM ,V?CLIMB-FOO ,LADDER>)>
		<RTRUE>)
	       (<EQUAL? ,HERE ,ON-TENT>	
		<COND (<VERB? EXAMINE FIND CLIMB-DOWN CLIMB-FOO>
		       <COND (<ENABLED? ,I-POKE>
		              <TELL 
"You desperately grope in the darkness for the rope ladder, but can't
seem to find it." CR>
			      <RTRUE>)
		       	     (T
			      <TELL "You can barely see the ladder. ">
			      <COND (<VERB? CLIMB-DOWN CLIMB-FOO>
				     <DO-WALK ,P?DOWN>
				     <RTRUE>)>
			      <CRLF>
			      <RTRUE>)>)
		       (T
		        <COND (<ENABLED? ,I-POKE>
			       <CANT-SEE ,LADDER>)
			      (T
			       <RFALSE>)>)>)
	       (<AND ,END-GAME
		     <EQUAL? ,HERE ,RING ,PLATFORM-1>
		     <NOT <EQUAL? <LOC ,PROTAGONIST> ,STAND>>	              
		     <NOT <VERB? UNTIE>>>
		     <COND (<TOUCHING? ,LADDER>
			    <DO-WALK ,P?UP>)
		           (<VERB? EXAMINE>
			    <TANGLED-ROPE T>)>)			   
	       (<AND <VERB? UNTIE TAKE-WITH>
		     <PRSI? ,POLE>>
		<PERFORM ,V?UNTIE ,LADDER>
		<RTRUE>)
	       (<AND <VERB? CLIMB-UP CLIMB-FOO>
		     <EQUAL? ,HERE ,CLOWN-ALLEY>>
		<PERFORM ,V?BOARD ,UPPER>
		<RTRUE>)
	       (<AND <VERB? CLIMB-FOO>
		     <EQUAL? ,HERE ,ON-WAGON>>
		<PERFORM ,V?CLIMB-DOWN ,LADDER>
		<RTRUE>)
	       (<VERB? CLIMB-UP CLIMB-FOO>
		<DO-WALK ,P?UP>)
	       (<VERB? CLIMB-DOWN>
		<COND (<EQUAL? ,HERE ,ON-WAGON>
		       <COND (<NOT <CLIMB?>>
		       	      <COND (<RUNNING? ,I-OFFICE>
				     <MUNRAB-ENTERS-OFFICE T>)>
			      <GOTO ,NEAR-WAGON>
			      <RTRUE>)>
		       <RTRUE>)
		      (T
		       <DO-WALK ,P?DOWN>)>)>>

<ROUTINE CLIMB? ("AUX" X (TO-GROUND? T) (GROUND <>))
	 <COND (<AND ,END-GAME
		     <EQUAL? ,HERE ,RING>
		     <NOT <IN? ,PROTAGONIST ,STAND>>>
		<TELL 
"The rope " D ,LADDER ", which is tangled around its platform, dangles down
a couple of feet out of your reach." CR>
		<RTRUE>)
	       (<CANT-CLIMB?>		     		
	        <SET X <FIRST? ,PROTAGONIST>>
		<REPEAT ()
			<COND (<AND <NOT <FSET? .X ,WORNBIT>>
			            <NOT <EQUAL? .X ,BALLOON ,MOUSE>>>
			       <RETURN>)
			      (T
			       <SET X <NEXT? .X>>)>>
		<COND (<SET GROUND <GETP ,HERE ,P?GROUND-LOC>>
		       <MOVE .X .GROUND>)
		      (T
		       <SET TO-GROUND? <>>
		       <MOVE .X ,HERE>)>
		<TELL 
"Trying to grip the " D ,LADDER ", you fumble away">
		<ARTICLE .X T>
		<COND (.TO-GROUND?
		       <TELL " and it falls to the ground below">)>
		<TELL ,PERIOD>
		<RTRUE>)	       
	       (<AND <EQUAL? ,APE-LOC 1>
		     <EQUAL? ,HERE ,RING>>
		<SETG APE-LOC 2>
		<FCLEAR ,PLATFORM-1 ,TOUCHBIT>
		<TELL 
"As you hoist " D ,ME " onto the " D ,LADDER ", the platform buckles with the
addition of your weight. " D ,APE " is spooked, and ">
		<COND (<NOT <IN? ,NET ,MUNRAB>>
		       <TELL 
"loses his bundle which falls tragically in front of your horrified face
to the ground below.">
		       <FINISH>)
		      (T
		       <TELL 
"clambers up into the supporting apparatus as you board the platform." CR CR>
		       <COND (<AND <EQUAL? <META-LOC ,RADIO> ,PLATFORM-1>
			      	   <FSET? ,RADIO ,ONBIT>
				   <EQUAL? ,STATION 1170>>
			      <TELL 
"In his distress, " D ,APE " must not have noticed the radio playing." CR CR>)>
		       <GOTO ,PLATFORM-1>
		       <RTRUE>)>)
	       (T		 
		<RFALSE>)>>
	    
<ROUTINE CANT-CLIMB? ()
	 <COND (<AND <OR <G? <CCOUNT ,PROTAGONIST> 2>	
		         <G? <WEIGHT ,PROTAGONIST> 30>>
		     <NOT <HELD? ,POLE>>>
		<RTRUE>)
	       (<OR <AND <HELD? ,POLE>
		         <G? <CCOUNT ,PROTAGONIST> 1>>
		    <HELD? ,STAND>>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE UP-LADDER ()
	 <COND (<AND <EQUAL? ,HERE ,NEAR-WAGON>
		     <NOT <FSET? ,LADDER ,RMUNGBIT>>>
		<TELL ,CANT-GO CR>
		<RFALSE>)>
	 <COND (<NOT <CLIMB?>>
	 	<TELL-CLIMBING>
		<COND (<EQUAL? ,HERE ,RING>
		       <RETURN ,PLATFORM-1>)
	       	      (<EQUAL? ,HERE ,NEAR-WAGON>
		       <RETURN ,ON-WAGON>)
	       	      (T
		       <RETURN ,ON-TENT>)>)
	      (T
	       <RFALSE>)>>
	 
<ROUTINE DOWN-LADDER ()
	 <COND (<NOT <CLIMB?>>
	 	<TELL-CLIMBING>
		<COND (<EQUAL? ,HERE ,PLATFORM-1>
		       <RETURN ,RING>)
	       	      (<EQUAL? ,HERE ,ON-WAGON>
		       <RETURN ,NEAR-WAGON>)
	       	      (T
		       <RETURN ,ON-CAGE>)>)
	       (T
		<RFALSE>)>>

<ROUTINE TELL-CLIMBING ()
	 <COND (<AND <EQUAL? ,HERE ,ON-WAGON>
		     <RUNNING? ,I-OFFICE>>
	        <MUNRAB-ENTERS-OFFICE T>
		<RTRUE>)
	       (T
		<TELL "You grasp the " D ,LADDER " firmly and climb ">
	 	<COND (<EQUAL? ,P-WALK-DIR ,P?UP>
		       <TELL "up">)
	       	      (T
		       <TELL "down">)>)>
	 	<TELL " ..." CR CR>>

<OBJECT AIR
	(IN GLOBAL-OBJECTS)
	(DESC "air")
	(SYNONYM AIR)
	(FLAGS VOWELBIT NARTICLEBIT AIRBIT)
	(ACTION AIR-F)>

<ROUTINE AIR-F ()
	 <COND (<VERB? SMELL>
		<PERFORM ,V?SMELL>
		<RTRUE>)>>

;<OBJECT SKY
	(IN GLOBAL-OBJECTS)
	(DESC "sky")
	(SYNONYM SKY)
	(ACTION SKY-F)>

;<ROUTINE SKY-F ()
	 <COND (<NOT <FSET? ,HERE ,OUTSIDEBIT>>
		<CANT-SEE ,SKY>)
	       (<AND <IN? ,FLEET ,HERE>
		     <VERB? EXAMINE>>
		<TELL
"The sky is filled with the ships of the " D ,FLEET "." CR>)>>

;<OBJECT STAR
	(IN GLOBAL-OBJECTS)
	(DESC "sun")
	(SYNONYM STAR SUN SYSTEM SOL)
	(ADJECTIVE APPROA STAR SOLAR SMALL UNREGA YELLOW ORANGE)
	(FLAGS NDESCBIT)
	(ACTION STAR-F)>

;<ROUTINE STAR-F ()
     <COND (<VERB? EXAMINE>
	    <COND (<EQUAL? ,HERE ,WAR-CHAMBER>
		   <TELL
"The approaching star is a small, unregarded yellow sun, with nine planets of
varying sizes. The " D ,THIRD-PLANET " catches your attention.">
		   <CRLF>)
		  (<EQUAL? ,HERE ,DAIS ,SPEEDBOAT>
		   <TELL "The sun is a smallish orange star." CR>)
		  (<EQUAL? ,HERE ,FRONT-OF-HOUSE ,COUNTRY-LANE ,BACK-OF-HOUSE>
		   <TELL "The sun is a smallish yellow star." CR>)
		  (T
		   <CANT-SEE ,STAR>)>)>>

<OBJECT HANDS
	(IN GLOBAL-OBJECTS)
	(SYNONYM HANDS HAND PALM)
	(ADJECTIVE ;BARE MY YOUR)
	(DESC "your hand")
	(FLAGS NDESCBIT TOUCHBIT NARTICLEBIT)
	(ACTION HANDS-F)>

;"RMUNGBIT for hands = Rimshaw has read palm"

<ROUTINE HANDS-F ("AUX" ACTOR)
	 <COND (<VERB? WAVE>
	        <SETG PRSO <>>
		<PERFORM ,V?WAVE-AT>
		<RTRUE>)
	       (<AND <VERB? READ RUB>
		     <PRSO? ,HANDS>
		     <ENABLED? ,I-HYP>>
	        <SETG WINNER ,HYP>
		<PERFORM ,PRSA ,PRSO>
		<SETG WINNER ,PROTAGONIST>
		<RTRUE>)
	       (<VERB? READ EXAMINE>
		<TELL "Your lifeline is very short." CR>)
	       (<VERB? CLAP>
		<SETG PRSO <>>
		<PERFORM ,V?CLAP>
		<RTRUE>)
	       (<AND <VERB? PUT>
		     <PRSI? ,HANDS>>
		<PERFORM ,V?TAKE ,PRSO>
		<RTRUE>)  
	       (<VERB? SHAKE>
		<COND (<SET ACTOR <FIND-IN ,HERE ,PERSON>>
		       <COND (<EQUAL? .ACTOR ,FAT>
			      <PERFORM ,V?SHAKE ,FAT-HAND>)
			     (T
			      <PERFORM ,V?THANK .ACTOR>)>
		       <RTRUE>)
		      (T
		       <TELL "Glad to meet you." CR>)>)>>

;<OBJECT FLY
	(IN GLOBAL-OBJECTS)
	(DESC "your fly")
	(SYNONYM FLY)
	(ADJECTIVE YOUR MY)
	(FLAGS NARTICLEBIT DOORBIT)>

;<ROUTINE BACK-F ()               ;"verbose version"
	 <COND (<VERB? EXAMINE>
		<COND (<IN? ,MONKEY ,PROTAGONIST>
		       <TELL
"Out of the corner of your eye you see a dark, hairy object which 
just now scampers to your opposite shoulder. There is no longer any
doubt: You have a monkey on your back." CR>)
		      (T
		       <RFALSE>)>)>>

<OBJECT MONKEY 
        (IN DICK) 
	(DESC "monkey")
	(SYNONYM MONKEY MUGSY ANIMAL)
	(FLAGS NDESCBIT ACTORBIT)
	(ACTION MONKEY-F)>

;"MONKEY RMUNGBIT = he falls upon you for first and only time"

<ROUTINE MONKEY-F ()
	 <COND (<AND <IN? ,MONKEY ,DICK>
		     <IN? ,DICK ,HERE>>
		<TELL
"Obviously, the " D ,DICK " doesn't ACTUALLY have a " D ,MONKEY "
on his back. This is merely a metaphor indicating \"obsession\" or
\"addiction\"; in the detective's case, the latter." CR>)
	       (<IN? ,MONKEY ,PROTAGONIST>
	        <COND (<VERB? EXAMINE>
		       <TELL
"\"Obsessed\" though you may be, that is no metaphorical " D ,MONKEY 
". It's high-strung, ill-mannered and foul-smelling." CR>)
		      (<OR <HURT? ,MONKEY>
			   <VERB? TAKE REMOVE FOLLOW MOVE>>
		       <TELL 
"The animal darts over to your opposite shoulder, piercing your ear with a
shriek." CR>)
		      (<VERB? RUB>
		       <TELL 
"He snaps his primate choppers at " D ,HANDS " and you flinch." CR>) 
	       	      (<AND <VERB? GIVE SHOW>
			    <PRSI? ,MONKEY>>
		       <COND (<PRSO? ,BANANA>
			      <COND (<FSET? ,BANANA ,RMUNGBIT>
			      	     <MOVE ,BANANA ,MONKEY>
			       	     <FSET ,BANANA ,NDESCBIT>
			      	     <TELL 
"The human-like hand of the " D ,MONKEY " grasps it and chomps away while
clinging ever more tightly onto " D ,BACK "." CR>)
				    (T
				     <NOT-INTERESTED>)>)
			     (T
			      <PERFORM ,V?TAKE ,MONKEY>
			      <RTRUE>)>)
		      (<TALKING-TO? ,MONKEY>
		       <TELL "It screeches loudly." CR>
		       <STOP>)
		      (<VERB? SMELL>
		       <TELL "Foul." CR>)>)>>
	       
<OBJECT HEAD
	(IN GLOBAL-OBJECTS)
	(DESC "your head")
	(SYNONYM HEAD SKULL BUMP BUMPS) 
	(ADJECTIVE YOUR MY)
	(FLAGS NARTICLEBIT)
	(ACTION HEAD-F)>

;"RMUNGBIT = have been felt by Rimshaw"

<ROUTINE HEAD-F ()
	 <COND (<AND <VERB? RUB READ>
		     <PRSO? ,HEAD>
		     <ENABLED? ,I-HYP>>
	        <SETG WINNER ,HYP>
		<PERFORM ,PRSA ,PRSO>
		<SETG WINNER ,PROTAGONIST>
		<RTRUE>)>>

<OBJECT PROTAGONIST
	(SYNONYM PROTAG)
	(DESC "it")
	(FLAGS NDESCBIT INVISIBLE)
	(ACTION PROTAGONIST-F)>

;"RMUNGBIT = can win the DID puzzle of yes-no stuff"

<ROUTINE PROTAGONIST-F ()
	 <RFALSE>>

<ROUTINE PROTAGONIST-HACK-F ()
	 <COND (<FSET? ,MASK ,WORNBIT>
		<COND (<OR <NOT <EQUAL? ,WINNER ,PROTAGONIST>>
		           <VERB? ASK-ABOUT TELL TELL-ABOUT HELLO REPLY>>
		       <TELL "The " D ,MASK " muffles your words." CR>
		       <SETG P-IT-OBJECT ,MASK>
		       <STOP>)
		      (<AND <VERB? INHALE KISS>
			    ,PRSO>
		       <TELL "The " D ,MASK " is in the way." CR>
		       <SETG P-IT-OBJECT ,MASK>
		       <STOP>)
		      (T
		       <RFALSE>)>)
		(<AND <ENABLED? ,I-HELIUM>
		      <NOT <TALKING-TO? ,GUARD>>
		      <NOT <EQUAL? ,PRSO ,HEADPHONES>>
		      <OR <VERB? ASK-ABOUT TELL TELL-ABOUT HELLO REPLY>
			  <NOT <EQUAL? ,WINNER ,PROTAGONIST>>>>
		 <SETG SPEAK-HELIUM T>
		 <PUTP ,PROTAGONIST ,P?ACTION ,PROTAGONIST-F>
		 <TELL
"As a squeaky voice emerges, you're surprised">
		 <COND (<AND ,PRSO
			     <NOT <EQUAL? ,PRSO ,ME>>> 
		        <TELL " but">
		 	<ARTICLE ,PRSO T>
		 	<TELL " isn't at all amused">)>
		 <TELL ,PERIOD>
		 <STOP>)>>

<OBJECT YOU
	(IN GLOBAL-OBJECTS)
	(SYNONYM YOU YOURSELF HIMSELF HERSELF)
	(DESC "himself or herself")
	(FLAGS NDESCBIT NARTICLEBIT)
	(ACTION YOU-F)>

<ROUTINE YOU-F ()
	 <COND (<AND <VERB? ASK-ABOUT>
		     <EQUAL? ,PRSI ,YOU>>
		<PERFORM ,V?ASK-ABOUT ,PRSO ,PRSO>
		<RTRUE>)
	       (<AND <VERB? TELL-ABOUT> 
		     <EQUAL? ,PRSI ,YOU>>
		<PERFORM ,V?TELL-ABOUT ,PRSO ,WINNER>
		<RTRUE>)>>
 
<OBJECT ME
	(IN GLOBAL-OBJECTS)
	(SYNONYM I ME MYSELF SUCKER)
	(DESC "yourself")
	(FLAGS ACTORBIT TOUCHBIT NARTICLEBIT)
	;(GENERIC SUCKER-F)
	(ACTION ME-F)>

<ROUTINE ME-F ("AUX" OLIT) 
	 <COND (<VERB? TELL>
	        <TELL
"Talking to yourself is a sign that it's getting late." CR>
		<STOP>)
	       (<VERB? LISTEN>
		<TELL "Yes?" CR>)
	       (<VERB? ALARM>
		<COND (,DREAMING		       
		       <WAKE-UP>)
		      (T
		       <TELL ,YOU-ARE CR>)>)
	       (<VERB? TAKE KILL MUNG>
		<TELL ,BASKET-CASE CR>)
	       (<AND <VERB? THROW POUR PUT-ON>		     
		     <PRSO? ,WATER>>
	        <MOVE ,WATER ,LOCAL-GLOBALS>
		<TELL ,ALL-WET>)
	       (<AND <VERB? GIVE>
		     <PRSI? ,ME>>
		<PERFORM ,V?TAKE ,PRSO>
		<RTRUE>)
	       (<VERB? MOVE>
		<V-WALK-AROUND>)
	       (<VERB? SEARCH>
		<V-INVENTORY>
		<RTRUE>)
	       (<AND <VERB? WHIP>
		     <PRSI? ,WHIP>>
		<COND (<WHIP-HOLD>
		       <RTRUE>)
		      (T
		       <TELL 
"You may feel this mystery has got you whipped, but now it's clear you've 
actually beaten yourself." CR>
		      <RTRUE>)>)
	       (<VERB? FIND>
		<TELL "You're right here!" CR>)
	       ;(<VERB? WHO>
		<TELL "You are " D ,IDENTITY-FLAG "." CR>)
	       	(<VERB? FOLLOW>
		 <V-WALK-AROUND>)>>

<OBJECT GLOBAL-ROOM
	(IN GLOBAL-OBJECTS)
	(DESC "room")
	(SYNONYM ROOM PLACE ARENA)
	;(ADJECTIVE AREA)
	(ACTION GLOBAL-ROOM-F)>

<ROUTINE GLOBAL-ROOM-F ()
	 <COND (<VERB? LOOK LOOK-INSIDE EXAMINE>
		<V-LOOK>
		<RTRUE>)
	       (<AND <VERB? SEARCH>
		     <EQUAL? ,HERE ,TAMER-ROOM>
		     <IN? ,CROWBAR ,LOCAL-GLOBALS>>
		<PERFORM ,V?CLOSE ,TAMER-DOOR>
		<RTRUE>)
	       (<VERB? THROUGH WALK-TO ENTER>
		<COND (<AND <PRSO? ,RING>
			    <EQUAL? ,HERE ,WINGS>>
		       <DO-WALK ,P?NORTH>)
		      (<AND <PRSO? ,MENAGERIE>
			    <EQUAL? ,HERE ,MIDWEST>>
		       <DO-WALK ,P?SOUTH>)
		      (<AND <PRSO? ,MIDWAY>
			    <EQUAL? ,HERE ,CON-AREA>>
		       <DO-WALK ,P?EAST>)
		      (T
		       <V-WALK-AROUND>)>)
	       (<VERB? LEAVE EXIT>
		<DO-WALK ,P?OUT>)
	       (<VERB? WALK-AROUND>
                <TELL
"Walking around here reveals nothing new. To move elsewhere, just type
the desired direction." CR>)
	       (<VERB? LAMP-ON>
		<PERFORM ,V?LAMP-ON ,LIGHT>
		<RTRUE>)>>

<OBJECT VOICES
	(IN GLOBAL-OBJECTS)
	(DESC "conversation")
	(SYNONYM CONVER VOICES VOICE)
	(FLAGS INVISIBLE CLEARBIT)
	(GENERIC GEN-VOICE-F)
	(ACTION VOICES-F)>

<ROUTINE VOICES-F ()
	 <COND (<VERB? LISTEN>
		<COND (<EQUAL? ,HERE ,MIDWEST>
		       <TELL
"The scratchy recording of a calliope, blaring out from unseen speakers,
is drowning out the voices." CR>)
		      (<RUNNING? ,I-MEET>
		       <COND (<EQUAL? ,MEET-COUNTER 7 8>
			      <RTRUE>)
			     (T
			      <TELL "They're too muffled." CR>)>)
		      (T
		       <CANT-SEE ,VOICES>)>)>>
		      
<OBJECT HIGH-VOICE
	(IN GLOBAL-OBJECTS)
	(DESC "voice")
	(SYNONYM VOICE)
        (ADJECTIVE HIGH HIGH- ;SQUEEKY)
	(FLAGS ;INVISIBLE NDESCBIT CLEARBIT)
	(GENERIC GEN-VOICE-F)
	(ACTION HIGH-VOICE-F)>

<ROUTINE HIGH-VOICE-F ("AUX" ACTOR)
	 <COND (<VERB? LISTEN>
		<COND (<EQUAL? <META-LOC ,THUMB> ,HERE>
		       <PERFORM ,V?LISTEN ,THUMB>
		       <RTRUE>)
		      (<ZERO? <GET ,P-ADJW 0>>
		       <CANT-SEE ,VOICES>)
		      (T
		       <CANT-SEE <> "the midget">)>)
	       (<VERB? TALK-INTO>
		<COND (<IN? ,GUARD ,HERE>
		       <COND (<ENABLED? ,I-HELIUM>
			      <PERFORM ,V?HELLO ,GUARD>
			      <RTRUE>)
			     (T
			      <TELL 
"The guard turns his head toward you but seems unmoved by your falsetto
performance." CR>)>)
		     (<SET ACTOR <FIND-IN ,HERE ,PERSON>> ;"me isn't person"
		      <TELL 
"Hardly amused, " D .ACTOR " ignores your performance." CR>)
		     (<SET ACTOR <FIND-IN ,HERE ,ACTORBIT>>
		      <PERFORM ,V?TELL .ACTOR>
		      <RTRUE>)
		     (T
		      <PERFORM ,V?TELL ,ME>
		      <RTRUE>)>)
		(<DONT-HANDLE? ,HIGH-VOICE>
		 <RFALSE>)
	        (T
		 <CANT-SEE ,VOICES>)>>

<ROUTINE GEN-VOICE-F ()
	 ,VOICES>

<OBJECT ROAR
	(IN LOCAL-GLOBALS)
	(DESC "roar")
	(SYNONYM ROAR GROWL)
        (ADJECTIVE LOUD)
	(FLAGS NDESCBIT CLEARBIT)
	(ACTION ROAR-F)>

<ROUTINE ROAR-F ()
	 <COND (<VERB? LISTEN>
		<TELL "\"Rrrrr...grrrrr.\"" CR>)>> 

<ROUTINE TALKING-TO? (ACTOR)
	 <COND (<OR <ASKING? .ACTOR>
		    <EQUAL? ,WINNER .ACTOR>>
		<RTRUE>)
	       (<AND <VERB? TELL TELL-ABOUT HELLO WAVE-AT REPLY YELL ALARM>
		     <EQUAL? ,PRSO .ACTOR>>
	        <RTRUE>) 
	       (T
		<RFALSE>)>>

<ROUTINE ASKING? (ACTOR)
	 <COND (<AND <VERB? ASK-ABOUT ASK-FOR>
		     <EQUAL? ,PRSO .ACTOR>>
	        <RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE TOUCHING? (THING)
	 <COND (<AND <TOUCHING-VERB?>
       		     <EQUAL? ,PRSO .THING>>
		<RTRUE>)
	       (<HURT? .THING>
		<RTRUE>)
	       (<AND <PRSI? .THING>
		     <VERB? SHOW GIVE PUT PUT-ON>>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE TOUCHING-VERB? ()
	 <COND (<OR <EQUAL? ,PRSA ,V?TAKE ,V?RUB ,V?SHAKE>
		    <EQUAL? ,PRSA ,V?SPIN ,V?CLEAN ,V?KISS>
		    <EQUAL? ,PRSA ,V?PUSH ,V?CLOSE ,V?LOOK-UNDER>
	            <EQUAL? ,PRSA ,V?MOVE ;,V?TAKE-WITH ,V?OPEN ,V?KNOCK>
		    <EQUAL? ,PRSA ,V?SET ,V?SHAKE ,V?RAISE>
		    <EQUAL? ,PRSA ,V?UNLOCK ,V?LOCK ,V?CLIMB-UP>
		    <EQUAL? ,PRSA ,V?CLIMB-FOO ,V?CLIMB-DOWN ,V?CLIMB-ON>
		    <EQUAL? ,PRSA ,V?BOARD ,V?THROUGH ,V?LAMP-ON>
		    <EQUAL? ,PRSA ,V?BITE ,V?KICK ,V?KILL>
		    <EQUAL? ,PRSA ,V?MUNG ,V?WHIP ,V?PUSH>
		    <EQUAL? ,PRSA ,V?LEAP ,V?LAMP-OFF ,V?PUT>
		    <EQUAL? ,PRSA ,V?PUT-ON ,V?SEARCH ,V?LOOK-INSIDE>
		    <EQUAL? ,PRSA ,V?POUR ,V?EAT>>
		<RTRUE>)	
	       (T
		<RFALSE>)>>

<ROUTINE DISTURB? (THING)
	 <COND (<OR <TOUCHING? .THING>
		    <TALKING-TO? .THING>>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE HURT? (THING)
	 <COND (<AND <OR <EQUAL? ,PRSA ,V?MUNG ,V?KICK ,V?KILL>
			 <EQUAL? ,PRSA ,V?KNOCK ,V?CUT ,V?WHIP>
			 <EQUAL? ,PRSA ,V?BITE ,V?PUSH>>
		     <EQUAL? ,PRSO .THING>>
		<RTRUE>)
	       ;(<AND <VERB? THROW>
		     <EQUAL? ,PRSI .THING>>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE TELL-WITHIN-REACH ()
	 <TELL "There is nothing within your reach." CR>>

<ROUTINE NOT-INTERESTED ()
	 <TELL
"The " D ,PRSI " doesn't seem interested in the " D ,PRSO "." CR>>

<ROUTINE TELL-CLOSELY-SPACED ("OPTIONAL" (PRSO? <>))	
         <TELL "The bars of the ">
	 <COND (.PRSO?
		<TELL D ,PRSO>)
	       (,PRSI
   		<TELL D ,PRSI>)
	       (T
		<TELL "thing">)>
	 <TELL " are too closely spaced." CR>>

<ROUTINE CANT-REACH (THING)
	 <TELL "You" <PICK-ONE ,REACHES>>
	 <ARTICLE .THING T>
	 <COND (<EQUAL? .THING ,APE ,NIMROD ,ELSIE>
		<TELL ", luckily." CR>)
	       (<NOT <EQUAL? .THING ,FAT-HAND>>
		<TELL ,PERIOD>)>
	 <RTRUE>>

<GLOBAL REACHES
        <LTABLE 0
	"'re not close enough to"
	" can't reach">>

;<ROUTINE UNIMPORTANT-THING-F ()
	 <COND (<AND <VERB? ASK-ABOUT>
		     <PRSO? ,GUIDE>>
		<RFALSE>)
	       (T
		<TELL "That's not important; leave it alone." CR>)>>

;"Like Jerrys GLOBAL-NOT-HERE-PRINT"

<ROUTINE CANT-SEE ("OPTIONAL" (OBJ <>) (STRING <>))
	 ;(,P-MULT <SETG P-NOT-HERE <+ ,P-NOT-HERE 1>>)	       
		<TELL "[You can't ">
		<COND (<AND .OBJ
			    <OR <EQUAL? .OBJ ,VOICES ,HIGH-VOICE ,ROAR>
				<EQUAL? .OBJ ,MUSIC ,WHIMPER>>>
		       <TELL "hear">)
		      (T
		       <TELL "see">)>
	        <COND (.OBJ		       
		       <COND (<NOT <AND <EQUAL? .OBJ ,PRSO>
				        <NAME? <GET ,P-NAMW 0>>>>
		       	      <TELL " any">)>)>
	        <COND (<NOT .OBJ>
		       <TELL " " .STRING>)
		      (<EQUAL? .OBJ ,PRSI>
		       <PRSI-PRINT>)
	              (T
		       <PRSO-PRINT>)>
	       <TELL " here.]" CR>
	       <SETG P-WON <>>
	       <STOP>>

;<ROUTINE TELL-ME-HOW ()
	 <TELL "You must tell me how to do that to">
	 <ARTICLE ,PRSO>
	 <TELL ,PERIOD>>

<ROUTINE YOU-CANT-USE (STRING)
	 <TELL "[You can't use " .STRING " that way.]" CR>>

<ROUTINE CANT-OPEN ()
	 <COND (<VERB? OPEN CLOSE>	
		<TELL "You can't ">	
		<COND (<VERB? OPEN>
		       <TELL "open">)
		      (T
		       <TELL "close">)>
		<ARTICLE ,PRSO>
		<TELL ,PERIOD>)>>

<ROUTINE CARRIAGE-RETURNS (CNT)
	 <REPEAT ()
		 <CRLF>
	         <SET CNT <- .CNT 1>>
		 <COND (<0? .CNT>
			<RTRUE>)>>>

<ROUTINE OUT-OF-FIRST (VEHICLE)
	 <TELL "You'll have to get ">
	 <COND (<EQUAL? <LOC ,PROTAGONIST> ,STAND ,SOFA>
		<TELL "off">)
	       (T
		<TELL "out">)>
	 <TELL " of the " D .VEHICLE " first." CR>>

<ROUTINE CRAWL-DIR ()
	 <COND (<EQUAL? ,P-PRSA-WORD ,W?CRAWL>
		<DO-WALK ,P-DIRECTION>)
	       (<GLOBAL-IN? ,BIGTOP ,HERE>
		<PERFORM ,V?CRAWL-UNDER ,BIGTOP>)
	       (<GLOBAL-IN? ,TENT ,HERE>
		<PERFORM ,V?CRAWL-UNDER ,TENT>)
	       (T
		<CANT-SEE ,TENT>)>
	 <RTRUE>>		

<ROUTINE TELL-HIT-HEAD ()
	 <TELL "You hit your head against">
	 <ARTICLE ,PRSO T>
	 <TELL " as you attempt this." CR>>

<ROUTINE IS-NOUN? (TEST-NOUN)            ;"prso"         ;"prsi"
	 <COND (<EQUAL? .TEST-NOUN <GET ,P-NAMW 0> <GET ,P-NAMW 1>>
		<RTRUE>)
	       (T
		<RFALSE>)>>

;<ROUTINE IS-ADJ? (OBJ TEST-ADJECTIVE "AUX" INPUT-ADJECTIVE)
	 <COND (<EQUAL? .OBJ ,PRSO>
		<SET INPUT-ADJECTIVE <GET ,P-ADJW 0>>)
	       (T
		<SET INPUT-ADJECTIVE <GET ,P-ADJW 1>>)>
	 <COND (<EQUAL? .TEST-ADJECTIVE .INPUT-ADJECTIVE>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE IS-ADJ? (TEST-ADJ)
	 <COND (<EQUAL? .TEST-ADJ <GET ,P-ADJW 0> <GET ,P-ADJW 1>>
		<RTRUE>)
	       (T
		<RFALSE>)>>
	 
;<ROUTINE IS-VERB? (TEST-VERB)
	 <COND (<EQUAL? .TEST-ADJ <GET ,P-ADJW 0> <GET ,P-ADJW 1>>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE SPECIFY-MONEY ("OPTIONAL" (BET? <>))
	 <SETG P-CONT <>>
	 <TELL
"[Specify an amount of money, such as: ">
	 <COND (.BET? 
		<TELL "BET ">)>
	 <TELL "75 CENTS, or ">
	 <COND (.BET? 
		<TELL "BET ">)>
	 <TELL "$1.50.]|">>

<ROUTINE TELL-SEE-MANUAL ()
	 <TELL 
"[Please consult your manual for the correct way to talk to characters.]" CR>>

<ROUTINE OPEN-CLOSED (THING)
	 <COND (<FSET? .THING ,OPENBIT>
		<TELL "open">)
	       (T
		<TELL "closed">)>>

<GLOBAL LOOK-AROUND "Look around you.">

<GLOBAL YAWNS <LTABLE 0 "unusual" "interesting" "extraordinary" "special">>

<GLOBAL ALREADY-OPEN "It's already open.">

<GLOBAL ALREADY-CLOSED "It's already closed.">

<GLOBAL TOO-DARK "It's too dark to see.">

<GLOBAL CANT-GO "You can't go that way.">

<GLOBAL IT-LOOKS-LIKE "It looks like">

<GLOBAL NOT-HOLDING "You're not holding">

<GLOBAL UNBALANCED "Confirmed. You are a completely unbalanced person. ">

<GLOBAL HIGH-ABOVE " high above the arena floor">

<GLOBAL YOU-SEE "You can see">

<GLOBAL TAIL-END "standing at the tail end of">

<GLOBAL YOU-ARE "You already are.">

<GLOBAL REFERRING "[It's unclear what you're referring to.]">

<GLOBAL TREADMILL " treadmilling its tiny front foreclaws against the
steely inside of the bucket">

<GLOBAL INSTANT "You have just encountered that brief instant of time ">

<GLOBAL BASKET-CASE "You're not a basket case. Yet.">

<GLOBAL PERIOD ".|">

<GLOBAL TELL-STANDS " has been moved back to its original position">

<GLOBAL HOW "How do you intend this?">

<GLOBAL BUSY "You get a constant busy signal.|">

<GLOBAL CLASSICAL "soothing classical music.|">

<GLOBAL EXIT-DEN "As you exit the den, the lion">

<GLOBAL GUARD-CALLS "From inside his cage, Harry calls out, ">

<GLOBAL TIPPED-OFF "You haven't been tipped off about that yet.|">

<GLOBAL NO-TALENT "This bit of gymnastics is beyond your talent.">

<GLOBAL SPECIFIC "You'll have to be more specific.|">

<GLOBAL BAD-SENTENCE "[That sentence isn't one I recognize.]">

<GLOBAL THAT-MUCH "You don't have that much.|">

<GLOBAL LIONS-WAIT 
"The lions seem eager to go after the meat, but your presence here is making
them hesitate.">

<GLOBAL BAD-AIM "Your aim is way off">

<GLOBAL BEAT-IT "\"Show's over. Beat it, sucker.\"|">

<GLOBAL LION-STAND-MOVED
	" sitting a few yards away from where you first saw it.">

<GLOBAL EMPTY "It's empty">

<GLOBAL ALL-WET "You're all wet.|">