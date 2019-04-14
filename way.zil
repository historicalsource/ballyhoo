"WAY for ballyhoo: copyright (c)1986 infocom, inc."

<ROOM MIDWEST
      (IN ROOMS)
      (DESC "Midway Entrance")
      (FLAGS ONBIT RLANDBIT)
      (WEST PER TURNSTILE-EXIT)
      (OUT PER TURNSTILE-EXIT)
      (EAST TO MID)
      (NORTH PER EXIT-UNDER-STANDS)
      (SOUTH TO MEN)
      (GLOBAL BANNER FRONT BIGTOP TURNSTILE MIDWAY MENAGERIE SLOT SAWDUST)
      (ACTION MIDWEST-F)> 

<ROUTINE MIDWEST-F (RARG)
	 <COND (<EQUAL? .RARG ,M-LOOK>
	        <TELL 
"To the west is the " D ,TURNSTILE " exit from the midway, which continues
east. The side of the " D ,BIGTOP " borders on the north. ">
	       <TELL-BANNER>)
	      (<EQUAL? .RARG ,M-ENTER>
	       <COND (<NOT <FSET? ,MIDWEST ,TOUCHBIT>>
	       	      <ENABLE <QUEUE I-DRUNK -1>>)
		     (<AND <IN? ,DICK ,MIDWEST>
			   <FSET? ,DICK ,RMUNGBIT>>
		      <MOVE ,FLASK ,DICK>)>)>>
	
<ROUTINE TELL-FRONT ("OPTIONAL" (MID? <>))
	 <TELL 
"Your eyes soak in the lavishly painted sideshow fronts ">
	 <COND (.MID?
		<TELL
"-- " D ,ANDREW " " D ,JENNY "'s to the south and Rimshaw's to">)
	       (T
		<TELL "which line the midway along">)>
         <TELL " the north. " CR>>

<ROUTINE TELL-BANNER ("OPTIONAL" (NORTH? <>))
	 <TELL "A soiled, " D ,BANNER " beckons ">
	 <COND (.NORTH?
		<TELL "north">)
	       (T
		<TELL "south">)>
	 <TELL ,PERIOD>> 

<ROOM MEN
      (IN ROOMS)
      (DESC "Menagerie")
      (FLAGS ONBIT RLANDBIT)
      (WEST PER APE-ENTER)
      (EAST PER BULL-ENTER)
      (NORTH TO MIDWEST)
      (SE TO NOOK) 
      (SW PER FENCE-EXIT)
      (GLOBAL CAGE APE-DOOR BANNER STRAW TENT CHAIN FENCE COMPARTMENT) ;"8"
      (ACTION MEN-F)>

<ROUTINE MEN-F (RARG)
	 <COND (<EQUAL? .RARG ,M-LOOK>
		<TELL
"This scrawny patch of dirt offers a square cage on its west side; an open
tent giving off a dank, earthy smell on its east side; and a well-worn path
along the tent to the southeast. ">
		<TELL-BANNER T>
		<COND (<NOT <IN? ,BULL ,MEN>>
		       <CRLF>
		       <TELL-BULL-HOLE>)>)
	       (<EQUAL? .RARG ,M-ENTER>
		<COND (<AND <EQUAL? ,P-WALK-DIR ,P?EAST ,P?OUT>
			    <NOT ,END-GAME>>
		       <MOVE ,APE ,MEN>)>
	        ;<COND (<AND <EQUAL? .RARG ,M-ENTER>
		     	    <IN? ,TRAP ,LOCAL-GLOBALS>>
		<MOVE ,TRAP ,PROP-ROOM>)>)
	       (<AND <EQUAL? .RARG ,M-END>
		     <IN? ,BULL ,MEN>
		     <NOT <ENABLED? ,I-BULL>>
		     <NOT <VERB? LISTEN>>
		     <PROB 20>>
		<ENABLE <QUEUE I-CHAINS 1>>)>>

<ROUTINE I-CHAINS ()
	 <TELL CR 
"The slow-moving sound of " D ,CHAIN "s from inside the tent is heard." CR>
	 <RFALSE>>

<ROUTINE APE-ENTER ()
	 <COND (<OR ,END-GAME
		    <FSET? ,APE-DOOR ,OPENBIT>>
		<COND (<EQUAL? ,HERE ,APE-ROOM>
		       <RETURN ,MEN>)
		      (T
		       <RETURN ,APE-ROOM>)>)
	       (T
		<TELL "The " D ,APE-DOOR " is ">
		<OPEN-CLOSED ,APE-DOOR>
		<TELL ,PERIOD>
		<RFALSE>)>>

<ROUTINE BULL-ENTER ("AUX" (FOO ,MEN))
	 <COND (<AND <EQUAL? ,HERE ,MEN>
		     <IN? ,BULL ,HERE>>		
		<TELL 
"With upraised tusks and flailing trunk, the " D ,BULL " backs you off." CR>
		<RFALSE>)
	       (T
		<TELL
"Mindful of where you step, you walk ">
		<COND (<EQUAL? ,HERE ,MEN>
		       <SET FOO ,BULL-ROOM>
		       <TELL "in">)
		      (T
		       <TELL "out">)>
		<TELL "side the tent." CR CR>
		<RETURN .FOO>)>>

<ROUTINE FENCE-EXIT ()
	 <COND (<NOT <IN? ,BULL ,MEN>>
		<COND (<EQUAL? ,HERE ,NEAR-WAGON>
		       <RETURN ,MEN>)
		      (T
		       <COND (<NOT <FSET? ,LADDER ,RMUNGBIT>>
			      <TELL 
"Walking through the damaged fence, y">
			      <NOTICE-LADDER>)>
		       <RETURN ,NEAR-WAGON>)>)
	       (T
		<TELL "A " D ,FENCE " stops you." CR>
		<RFALSE>)>>

<OBJECT APE
	(IN MEN)
	(DESC "Mahler")
	(SYNONYM MAHLER APE GORILLA BEAST)
	(ADJECTIVE HAIRY)
	(FLAGS ACTORBIT NARTICLEBIT NDESCBIT SEARCHBIT OPENBIT CONTBIT)
	(ACTION APE-F)>

;" APE rmungbit = Ape is happy with music"

<ROUTINE APE-F ()
	 <COND (<AND <FSET? ,APE ,RMUNGBIT>
		     <OR <VERB? EXAMINE>
		     	 <TALKING-TO? ,APE>>>
		    <TELL
"He seems off in another world with his music." CR>
		    <STOP>)
	       (<VERB? EXAMINE>
		<TELL 
D ,APE " appears as a huge ball of dark fur with a thumping breastplate
and a crinkled mug, both high-gloss black. ">
			<COND (<EQUAL? ,HERE ,APE-ROOM>
                               <TELL 
"He's looking down at you quizzically.">)
			      (<IN? ,GIRL ,APE>
			       <TELL 
"The girl dangles from the ape's grip.">)>
		<CRLF>)
	       (<TALKING-TO? ,APE>
	        <COND (<EQUAL? ,HERE ,MEN>
		       <TELL 
"The ape seems wearied by the familiar attention you're paying him." CR>)
		      (<NOT ,END-GAME>	
		       <TELL
D ,APE " stares at you through his deep-set jaundiced eyes." CR>)
		      (T
		       <TELL
"You're not close enough for meaningful communication." CR>)>
		<STOP>)
	       (<AND <NOT <EQUAL? ,HERE ,APE-ROOM>>
		     <TOUCHING? ,APE>>
		<CANT-REACH ,APE>)
	       (<AND <VERB? RUB>
		     <NOT ,PRSI>>
		<TELL
"The hair is coarse and bristly against the palm of " D ,HANDS ". The
gorilla is too puzzled by your intrusion, however, to enjoy such a
creature comfort." CR>)
	       (<AND <VERB? PUT-ON>
		     <PRSO? ,HEADPHONES>>
		<PERFORM ,V?GIVE ,HEADPHONES ,APE>
		<RTRUE>)        
	       (<VERB? GIVE SHOW>
		<COND (<IDROP>
		       <RTRUE>)
		      (<PRSO? ,MOUSE ,WATER>
		       <RFALSE>)
		      (<TRAP-SET?>
		       <ENABLE <QUEUE I-CURSE -1>>
		       <TELL 
,INSTANT "in many a beast's life between his recognition that someone has
caused him great harm and his moment of striking back, during which time
his imminent victim usually says ... well, go ahead ..." CR>)
		      (<AND <PRSO? ,RADIO>
		            <FSET? ,RADIO ,ONBIT>>
		       <SETG APE-C 4>
		       <TELL 
D ,APE " looks expectantly at the device, but as it rests in his hairy clutches
the static-emission from the radio quickly grates on his sensitive nerves.
He shoves it back to you, then really begins to give you static." CR>)
		      (<AND <PRSO? ,HEADPHONES>
			    <RUNNING? ,I-RUN>  
			    <EQUAL? ,KNOB-SET ,V?PLAY>>
		       <COND (<EQUAL? <GET ,TAPE-TABLE ,ON-TAPE> 2>
			      <SETG SCORE <+ ,SCORE 10>>
			      <MOVE ,HEADPHONES ,APE>
			      <FSET ,APE ,RMUNGBIT>
			      <ENABLE <QUEUE I-MOVE-DICK 1>>
			      <TELL 
"From the looks of him -- an undeniable lowbrow. But now " D ,APE ", true
to his name, displays a quite highbrow taste in music. He ushers the
headphones over to the " D ,CORNER " of his " D ,CAGE ", his savage
breast to soothe.">)
			     (<RUNNING? ,I-RUN>
			      <TELL 
D ,APE " refuses to have anything to do with the headphones.">)>
		       <CRLF>)
		     (<PRSO? ,BALLOON>
		      <BALLOON-FLIGHT>
		      <TELL D ,APE " just scratches his head." CR>)
		     (T
		      <MOVE ,PRSO ,HERE>
		      <TELL D ,APE " holds">
		      <ARTICLE ,PRSO T>
		      <TELL 
" limply in his massive hand for a moment then lets it drop">
		      <COND (<PRSO? ,MEAT>
			     <TELL 
". It doesn't look like part of his normal diet">)>
		      <TELL ,PERIOD>)>)
	      (<HURT? ,APE>
	       <TELL 
"In the face of your attack, " D ,APE " simply scrunches his nose in curiosity.
This has the effect of withering the fierce expression on your face and
botching your follow-through. With the playfulness that is characteristic
of the great apes, " D ,APE>
	       <LUGGAGE>
	       <RTRUE>)
	      (<AND <EQUAL? ,FOLLOW-FLAG 9>
		    <VERB? FOLLOW>>
	       <DO-WALK ,P?NORTH>
	       <RTRUE>)>>  

<GLOBAL APE-C 0>

<ROUTINE I-APE ()	 
	 <COND (<OR <AND <NOT <EQUAL? ,HERE ,APE-ROOM>>
			 <NOT <FSET? ,APE ,RMUNGBIT>>>
		    <RUNNING? ,I-CURSE>>
		<DISABLE <INT I-APE>>
		<SETG APE-C 0>				
		<RFALSE>)
	       (<FSET? ,APE ,RMUNGBIT>
	        <COND (<OR <NOT <EQUAL? <GET ,TAPE-TABLE ,ON-TAPE> 2>>
			   <NOT <RUNNING? ,I-RUN>>>
		       <FCLEAR ,APE ,RMUNGBIT>
		       <SETG APE-C 0>
		       <FSET ,HEADPHONES ,INVISIBLE>
		       <DISABLE <INT I-RUN>>
		       <COND (<EQUAL? ,HERE ,APE-ROOM ,MEN>
			      <TELL CR
D ,APE " suddenly lets out a primal, deafening scream that rattles the bars
of his cage. You can hear the " D ,HEADPHONES " being reduced to dust in the
ape's tense grip. ">
		       	      <COND (<EQUAL? ,HERE ,APE-ROOM>
			      	     <APE-DEATH>)
			     	    (T
			      	     <TELL 
"With that volcanic emotional response to the end of his listening pleasure, "
D ,APE " settles back down onto the straw." CR>)>)>) 
		      (T
		       <RFALSE>)>)
	       (T
		<SETG APE-C <+ ,APE-C 1>>
		<COND (<NOT <EQUAL? ,FOLLOW-FLAG 99>>
		       <CRLF>)>
		<COND (<EQUAL? ,APE-C 1>
		       <MOVE ,APE ,HERE> ;"used to be in m-enter"
		       <TELL
D ,APE " gets up from his doldrums and stares down at you">
		       <COND (<FSET? ,SUIT ,WORNBIT>
			      <TELL 
". If apes could laugh, this one would -- at the sight of you standing
there expectantly in your hairy suit. Instead the gorilla is bewildered, and
starts">)
			     (T
			      <TELL ",">)>
		       <TELL 
" tilting his head slowly to one side.">)
		      (<EQUAL? ,APE-C 2 3 4>
		       <TELL <PICK-ONE ,APES>>)
	              (<EQUAL? ,APE-C 5>
		       <TELL
D ,APE " bellows out a roar that backs you toward the cage door.">)
	              (<EQUAL? ,APE-C 6>
		       <TELL
"Agitated by your presence, " D ,APE " appears on the verge of attack.">)
	              (<EQUAL? ,APE-C 7>
		       <APE-DEATH>)>
		<CRLF>)>>

<GLOBAL APES 
	<LTABLE 0 
"The gorilla picks his nose impassively."
"The ape begins mouthing some straw with his pliable lips."
"Excitedly, Mahler bounces up and down while baring his massive yellow
teeth at you.">>

<ROUTINE APE-DEATH ()
	 <JIGS-UP 4
"Like an eclipse the gorilla hovers over you then everything becomes
dark.">
	 <RTRUE>>

<ROUTINE LUGGAGE ()
	 <JIGS-UP 1
" treats you like a piece of luggage for about 30 minutes.">
	 <RTRUE>>

<ROOM APE-ROOM
      (IN ROOMS)
      (DESC "Inside Mahler's Cage")
      (EAST PER APE-ENTER)
      (OUT TO MEN IF APE-DOOR IS OPEN)
      (FLAGS RLANDBIT ONBIT INDOORSBIT)
      (GLOBAL CAGE APE-DOOR STRAW COMPARTMENT TRAP-DOOR)
      (ACTION APE-ROOM-F)>

<ROUTINE APE-ROOM-F (RARG)
	 <COND (<EQUAL? .RARG ,M-LOOK>
		<TELL
"You stand on the straw-covered cage floor, surrounded on four sides by
closely spaced iron bars. The ">
		<COND (<FSET? ,APE-DOOR ,OPENBIT>
		       <TELL "open">)
		      (T
		       <TELL "closed">)>
	       <TELL " " D ,APE-DOOR " is east">
	       <COND (<NOT <FSET? ,TRAP-DOOR ,INVISIBLE>>
		      <TELL " and a " D ,TRAP-DOOR " here is ">
		      <OPEN-CLOSED ,TRAP-DOOR>)>
	       <TELL ".">
	       <COND (<AND <IN? ,APE ,HERE>
			   <NOT <EQUAL? ,P-WALK-DIR ,P?IN ,P?WEST>>>
		      <TELL CR CR D ,APE " is ">
		      <COND (<FSET? ,APE ,RMUNGBIT>
			     <TELL 
"slumped over in the " D ,CORNER " of his cage listening to the "
D ,HEADPHONES ".">)
			    (T
			     <TELL 
"staring at you with deep-set, jaundiced eyes.">)>)>
	       <CRLF>)
	      (<AND <EQUAL? .RARG ,M-ENTER>
		    <NOT ,END-GAME>>
	       <MOVE ,APE ,APE-ROOM>
	       <ENABLE <QUEUE I-APE -1>>)
	      (<AND <EQUAL? .RARG ,M-END>
		    <EQUAL? <GET ,TAPE-TABLE ,ON-TAPE> 2>
		    ;<EQUAL? ,APE-C 2>
		    <HELD? ,HEADPHONES>
		    <RUNNING? ,I-RUN>  
	            <EQUAL? ,KNOB-SET ,V?PLAY>>
	       <TELL CR "Mahler snatches away the " D ,HEADPHONES "." CR CR>
	       <PERFORM ,V?GIVE ,HEADPHONES ,APE>
	       <RTRUE>)>>

<OBJECT APE-DOOR
	(IN LOCAL-GLOBALS)
	(DESC "cage door")
	(SYNONYM DOOR GATE LOCK)
	(ADJECTIVE ;APE CAGE)
	(FLAGS DOORBIT NDESCBIT LOCKEDBIT CAGEBIT)
	;(ACTION APE-DOOR-F)>

;<ROUTINE APE-DOOR-F ()
    	 <COND (<AND <VERB? PUT> 
		     <EQUAL? ,PRSI ,APE-DOOR>>
		<COND (<G? <GETP ,PRSO ,P?SIZE> 20>
		       <TELL "It won't fit through the door." CR>)
		      (T
		       <MOVE ,PRSO ,MEN>
		       <TELL
"The " D ,PRSO " goes through the ape-door into the darkness below." CR>)>)>>

<OBJECT COMPARTMENT
	(IN LOCAL-GLOBALS)
	(DESC "compartment")
	(SYNONYM COMPAR)
	(ADJECTIVE SMALL RECTANGULAR)
	(FLAGS NDESCBIT CONTBIT)
	(CAPACITY 50)
	(ACTION COMPARTMENT-F)>

<ROUTINE COMPARTMENT-F ()
	 <COND (<EQUAL? ,HERE ,APE-ROOM>
		<COND (<NOT <FSET? ,TRAP-DOOR ,OPENBIT>>
		       <CANT-SEE ,COMPARTMENT>)
		      (<VERB? OPEN CLOSE>
		       <PERFORM ,PRSA ,TRAP-DOOR>
		       <RTRUE>)
		      (<VERB? LOOK-INSIDE SEARCH>
		       <TELL "There is">
		       <COND (<NOT <FSET? ,RIBBON ,TOUCHBIT>>
			      <MOVE ,RIBBON ,COMPARTMENT>)>
		       <PRINT-CONTENTS ,COMPARTMENT>
		       <TELL " in the " D ,COMPARTMENT "." CR>
		       <COND (<NOT <FSET? ,RIBBON ,TOUCHBIT>>
			      <MOVE ,RIBBON ,HERE>)>
		       <RTRUE>)
		      (<VERB? THROUGH ENTER BOARD>
		       <TELL "It's too small for you." CR>)
		      (<VERB? PUT>
		       <V-DIG>)>)
	       (<EQUAL? ,HERE ,MEN>
		<COND (<VERB? LOOK-INSIDE OPEN CLOSE PUT THROUGH BOARD ENTER>
		       <TELL 
,YOU-SEE " no openings to the " D ,COMPARTMENT "." CR>)
		      (<AND <VERB? KNOCK>
			    <NOT <FSET? ,TRAP-DOOR ,RMUNGBIT>>>
		       <TELL
"You detect a brief sound of movement in return, but can't tell if it's
coming from " D ,APE " or from inside the " D ,COMPARTMENT "." CR>)>)
	      (<AND <EQUAL? ,HERE ,APE-ROOM>
	            <VERB? OPEN CLOSE>>
	       <PERFORM ,PRSA ,TRAP-DOOR>)>>
	       
<OBJECT TRAP-DOOR
	(IN LOCAL-GLOBALS)
	(DESC "trap door")
	(SYNONYM OUTLINE DOOR TRAP)
	(ADJECTIVE TRAP)
	(FLAGS NDESCBIT DOORBIT INVISIBLE)
	(ACTION TRAP-DOOR-F)>

;"RMUNGBIT = have opened it first time. Now no sound when knock on compartmnt"

<ROUTINE TRAP-DOOR-F ()
	 <COND (<AND <VERB? RAISE OPEN>
		     <NOT <FSET? ,TRAP-DOOR ,OPENBIT>>>
		<COND (<OR <FSET? ,APE ,RMUNGBIT>
			   <NOT <IN? ,APE ,HERE>>>
		       <FSET ,TRAP-DOOR ,OPENBIT>
		       <FSET ,TRAP-DOOR ,RMUNGBIT>
		       <TELL 
"As the " D ,TRAP-DOOR " hinges upward, you can see a " D ,COMPARTMENT 
" that is empty">
		       <COND (<AND <FSET? ,RIBBON ,INVISIBLE>
				   <NOT <FSET? ,RIBBON ,TOUCHBIT>>>
			      <FCLEAR ,RIBBON ,INVISIBLE>
			      <TELL " but for a small red ribbon">)>
		       <TELL ,PERIOD>)
		      (T
		       <TELL 
"Bulky and difficult to grip, the " D ,TRAP-DOOR " resists the labored
attempt of " D ,HANDS "s which are especially sweat-drenched with " D ,APE 
" hovering over you." CR>)>)
	       (<AND <VERB? CLOSE LOWER>
		     <FSET? ,TRAP-DOOR ,OPENBIT>>
		<COND (<NOT <FSET? ,RIBBON ,TOUCHBIT>>
		       <FSET ,RIBBON ,INVISIBLE>)>
		<FCLEAR ,TRAP-DOOR ,OPENBIT>
		<TELL "It lowers over the " D ,COMPARTMENT "." CR>)
	       (<AND <VERB? LOOK-INSIDE>
		     <FSET? ,TRAP-DOOR ,OPENBIT>>
		<PERFORM ,V?LOOK-INSIDE ,COMPARTMENT>
		<RTRUE>)>>

<OBJECT RIBBON
	(IN APE-ROOM)
	(DESC "ribbon")
	(SYNONYM RIBBON)
	(ADJECTIVE RED BRIGHT CLOTH ;STUNNING ;SMALL)
	(FLAGS TAKEBIT NDESCBIT INVISIBLE WEARBIT)
	(SIZE 2)
	(ACTION RIBBON-F)>
		
;"RMUNGBIT = set on v-examine, cleared as player wins count-back for memory"

<ROUTINE RIBBON-F ()
	 <COND (<VERB? EXAMINE>
		<TELL 
"Though cut from ordinary cloth, the ribbon is a stunning bright red." CR>)
	       (<AND <VERB? TIE>
		     <PRSI? ,ME>>
		<PERFORM ,V?WEAR ,RIBBON>
		<RTRUE>)
	       (<AND <FSET? ,RIBBON ,WORNBIT>
		     <VERB? UNTIE>>
		<PERFORM ,V?REMOVE ,RIBBON>
		<RTRUE>)>>

<OBJECT CAGE
	(IN LOCAL-GLOBALS)
	(DESC "cage")
	(SYNONYM CAGE BARS BAR)
	(ADJECTIVE SQUARE)
	(FLAGS NDESCBIT)
	(GENERIC GEN-BAR)
	(ACTION CAGE-F)>
			      
<ROUTINE CAGE-F ()
	 <COND (<AND <VERB? EXAMINE>
		     <EQUAL? ,HERE ,MEN ,APE-ROOM>
		     ,END-GAME>
		<TELL 
"Several of the vertical bars are bent to either side." CR>)
	       (<AND <VERB? EXAMINE>
		     <EQUAL? ,HERE ,NOOK>>
		<TELL "It's not as high as " D ,APE "'s cage." CR>) 
	       (<AND <VERB? PUT-ON>
		     <PRSI? ,CAGE>>
		<COND (<EQUAL? ,HERE ,ON-CAGE>
		       <PERFORM ,V?DROP ,PRSO>
		       <RTRUE>)
		      (<EQUAL? ,HERE ,NOOK>
		       <MOVE ,PRSO ,ON-CAGE>
		       <TELL "Done." CR>)>)
	       (<VERB? LOOK-ON>
		<COND (<EQUAL? ,HERE ,ON-CAGE>
		       <V-LOOK>)
		      (<EQUAL? ,HERE ,NOOK>
		       <TELL "It's too high." CR>)>)
	       (<VERB? UNLOCK LOCK OPEN CLOSE>
		<COND (<EQUAL? ,HERE ,NOOK ,ROUST-ROOM>
		       <PERFORM ,PRSA ,ROUST-DOOR ,PRSI>)
		      (T
		       <PERFORM ,PRSA ,APE-DOOR ,PRSI>)>
		<RTRUE>)
	       (<VERB? LOOK-INSIDE>
		<COND (<EQUAL? ,HERE ,ROUST-ROOM ,APE-ROOM>
		       <V-LOOK>
		       <RTRUE>)
		      (<EQUAL? ,HERE ,ON-CAGE>
		       <NO-POSITION>)
		      (T		       
		       <COND (<EQUAL? ,HERE ,MEN>
		              <TELL "Peering into the cage, you observe ">
			      <COND (<FSET? ,APE ,RMUNGBIT>
				     <TELL 
D ,APE " hunched in the " D ,CORNER " listening to the " D ,HEADPHONES>)
				    (<IN? ,APE ,HERE>
			      	     <TELL 
"a gargantuan and thoroughly bored gorilla sitting on a helter-skelter bed
of straw">)
				    (T
				     <TELL "nothing but straw">)>)
			     (T
			      <TELL
"The confines of the cage are so darkly shaded that you cannot distinguish
anything inside">
			      <COND (<FSET? ,KEY ,TRYTAKEBIT>
				     <TELL 
", except for a hoop key ring hanging against the far " D ,WALLS " which
happens to be illuminated by a spot of soft light">)>)>
			     <TELL ,PERIOD>)>)
	       (<AND <VERB? PUT>
		     <PRSI? ,CAGE>
		     <NOT <IDROP>>>
		<COND (<EQUAL? ,HERE ,ROUST-ROOM ,APE-ROOM>
		       <PERFORM ,V?DROP ,PRSO>
		       <RTRUE>)
		      (<AND <FSET? ,KEY ,TRYTAKEBIT>
			    <PRSO? ,POLE>>
		       <PERFORM ,V?TAKE-WITH ,KEY ,POLE>
		       <RTRUE>)
		      (<AND <G? <GETP ,PRSO ,P?SIZE> 25>
			    <NOT <EQUAL? ,PRSO ,POLE>>>
		       <TELL-CLOSELY-SPACED>)		      
		      (<AND <EQUAL? ,HERE ,MEN>
			    <IN? ,APE ,MEN>>
		       <TELL D ,APE " completely ignores">
		       <ARTICLE ,PRSO T>
		       <TELL 
", as he would anything from this distance, so you withdraw it." CR>)
		      (T		       
		       <V-DIG>)>)
	       (<VERB? ENTER BOARD THROUGH>
		<COND (<EQUAL? ,HERE ,APE-ROOM ,ROUST-ROOM ,ON-CAGE>
		       <TELL ,LOOK-AROUND CR>)
		      (<EQUAL? ,HERE ,MEN>
		       <DO-WALK ,P?WEST>)
		      (<EQUAL? ,HERE ,NOOK>
		       <DO-WALK ,P?NORTH>)>)
	       (<AND <VERB? DISEMBARK>
		     <EQUAL? ,HERE ,APE-ROOM ,ROUST-ROOM>>
		<DO-WALK ,P?OUT>
		<RTRUE>)
	       (<VERB? LOOK-UNDER>
		<COND (<OR <EQUAL? ,HERE ,MEN>
			   <AND <EQUAL? ,HERE ,APE-ROOM>
			        <FSET? ,APE-DOOR ,OPENBIT>>>
	        <TELL
"Below the surface of the cage floor there appears to be a rectangular "
D ,COMPARTMENT " of sorts." CR>)
		      (<EQUAL? ,HERE ,APE-ROOM>
		       <PERFORM ,V?EXAMINE ,APE-DOOR>
		       <RTRUE>)>)
	       (<VERB? REACH-IN>
		<COND (<EQUAL? ,HERE ,APE-ROOM ,ROUST-ROOM>
		       <TELL ,LOOK-AROUND CR>)
		      (<EQUAL? ,HERE ,NOOK>
		       <COND (<FSET? ,HEADPHONES ,TRYTAKEBIT>
			      <PERFORM ,V?TAKE ,HEADPHONES>
			      <RTRUE>)
			     (<FSET? ,KEY ,TRYTAKEBIT>
			      <PERFORM ,V?TAKE ,KEY>
			      <RTRUE>)
			     (T
			      <TELL-WITHIN-REACH>)>)
		      (<AND <EQUAL? ,HERE ,MEN>
			    <IN? ,APE ,HERE>>
		       <PERFORM ,V?RUB ,APE>
		       <RTRUE>)>)
	       (<VERB? CLIMB-ON CLIMB-UP CLIMB-FOO>		
		<COND (<EQUAL? ,HERE ,ON-CAGE ,ROUST-ROOM>
		       <TELL ,LOOK-AROUND CR>)
		      (<EQUAL? ,HERE ,NOOK>
		       <DO-WALK ,P?UP>)
		      	(T
		       <TELL
"Grabbing hold of the rusted iron bars, you hike one leg up into the air,
and then, as would a prisoner, hang your head in despair." CR>)>)
	       (<VERB? CLIMB-DOWN>
		<COND (<EQUAL? ,HERE ,ON-CAGE>
		       <DO-WALK ,P?DOWN>)
		      (T
		       <TELL ,LOOK-AROUND CR>)>)>>
		
<ROUTINE NO-POSITION ()
	 <TELL 
"You're in no position to do that." CR>>

<ROOM ON-CAGE
      (IN ROOMS)
      (DESC "Top of Cage")
      (FLAGS ONBIT RLANDBIT)
      (UP PER UP-LADDER)
      (DOWN PER UP-DOWN-CAGE)
      (GLOBAL CAGE TENT LADDER)
      (GROUND-LOC NOOK)
      (ACTION ON-CAGE-F)>

<ROUTINE ON-CAGE-F (RARG)
	 <COND (<EQUAL? .RARG ,M-LOOK>
		<TELL
"You're standing in semidarkness on top of a cage next to the elephant
tent which rises above. " ,YOU-SEE ", faintly, a rope ladder hanging from the
top edge of the tent." CR>)>> 

<ROUTINE UP-DOWN-CAGE ()
	 <COND (<CANT-CLIMB?>
		<TELL "Your arms are too full." CR>
	        <RFALSE>)>
	 <TELL "You ">
	 <COND (<EQUAL? ,HERE ,NOOK>
		<TELL "hoist " D ,ME " up and onto the " D ,CAGE "." CR CR>
		<RETURN ,ON-CAGE>)
	       (T
		<COND (<NOT ,DIED>		       
		       <TELL "fall awkwardly">)
		      (T
	               <TELL "clamber">)>
		<TELL " down from the " D ,CAGE "." CR>
		<COND (<NOT ,DIED>
		       <ENABLE <QUEUE I-DEMISE 2>>
		       <SETG DIED T>
		       <TELL-DIED>
		       <MOVE ,PROTAGONIST ,NOOK>
		       <SETG HERE ,NOOK>)
		      (T
		       <CRLF>
		       <RETURN ,NOOK>)>
		<RFALSE>)>>

<ROOM BULL-ROOM
      (IN ROOMS)
      (DESC "Elephant Tent")
      (FLAGS ONBIT RLANDBIT INDOORSBIT)
      ;(EAST TO CLOSET)
      (WEST PER BULL-ENTER)
      (GLOBAL SAWDUST TENT CHAIN BURN-HOLE)
      (ACTION BULL-ROOM-F)>
      
<ROUTINE BULL-ROOM-F (RARG)
	 <COND (<EQUAL? .RARG ,M-LOOK>
		<TELL
"The " D ,GROUND " here is covered with matted-down sawdust that emits a
strong earthy smell. By all evidence, this tent used to house an elephant."
CR>)>>  

<ROOM CLOSET
      (IN ROOMS)
      (DESC "Wardrobe Closet")
      (FLAGS ONBIT RLANDBIT INDOORSBIT)
      (UP PER UP-STAIRS)
      (GLOBAL STAIRCASE)
      (ACTION CLOSET-F)>

<ROUTINE CLOSET-F (RARG)
	 <COND (<EQUAL? .RARG ,M-LOOK>
		<TELL
"You are standing amid a kaleidoscope of his-and-her garments, a view as
if from inside a clothes drier in mid-cycle">
		<COND (<OR <FSET? ,DRESS ,NDESCBIT>
			   <FSET? ,SHAWL ,NDESCBIT>>
		       <TELL ". Among the mentionables ">
		       <COND (<AND  <FSET? ,DRESS ,NDESCBIT>
			            <FSET? ,SHAWL ,NDESCBIT>>
			      <TELL 
"are a sequin-dress/safari-suit combination, and a
knitted-shawl/leather-jacket combo">)
			     (T
			      <TELL "is">
			      <COND (<FSET? ,DRESS ,NDESCBIT>
				     <TELL " a " D ,DRESS>)
				    (T
				     <TELL " a " D ,SHAWL>)>)>)>
		<TELL 
"." CR CR "Stairs against the wall lead upward." CR>)>>
   		       
<OBJECT CLOSET-OBJECT
	(IN CLOSET)
	(DESC "closet")
	(SYNONYM CLOSET)
	(ADJECTIVE WARDROBE)
	(FLAGS NDESCBIT)
	(ACTION GLOBAL-ROOM-F)>

<OBJECT DRESS
	(IN CLOSET)
	(DESC "dress-suit combination")
	(SYNONYM COMBINATION DRESS SUIT POCKET)
	(ADJECTIVE SEQUIN SAFARI SLIT GARMENT)
	(FLAGS NDESCBIT WEARBIT CONTBIT SEARCHBIT TAKEBIT OPENBIT)
	(SIZE 15)
	(CAPACITY 4)
	(ACTION DRESS-F)>

<ROUTINE DRESS-F () 
	 <COND (<VERB? EXAMINE>
		<TELL "The sequins glimmer in the ">
		<COND (<NOT <FSET? ,HERE ,INDOORSBIT>>
		       <TELL "moon">)>
		<TELL 
"light. There's a small slit of a pocket on the hip of the dress." CR>)
	       (<VERB? OPEN LOOK-INSIDE SEARCH REACH-IN>
		<COND (<IN? ,VEIL ,LOCAL-GLOBALS>
		       <MOVE ,VEIL ,DRESS>)>
	        <TELL ,YOU-SEE>
		<PRINT-CONTENTS ,DRESS>
		<TELL " in the pocket." CR>) 
	       (<VERB? CLOSE>
		<TELL "It's only a slit of a pocket." CR>)
	       (<AND <VERB? WEAR>
		     <FSET? ,SUIT ,WORNBIT>>
		<WONT-FIT-OVER ,SUIT>)
	       (<AND <VERB? WEAR>
		     <FSET? ,SHAWL ,WORNBIT>>
		<WONT-FIT-OVER ,SHAWL>)
	       (<AND <VERB? WEAR TAKE-OFF REMOVE>
		     <FSET? ,DRESS ,WORNBIT>>
		<COND (<FSET? ,SHAWL ,WORNBIT>
		       <REMOVE-FIRST ,SHAWL>
		       <RTRUE>)>
	       	<TELL "You wriggle ">
		<COND (<VERB? WEAR>
		       <TELL "into">
		       <MOVE ,DRESS ,PROTAGONIST>
		       <FSET ,DRESS ,WORNBIT>)
		      (T
		       <TELL "out of">
		       <FCLEAR ,DRESS ,WORNBIT>)>
		<TELL " the " D ,DRESS "." CR>)>>

<OBJECT VEIL
	(IN LOCAL-GLOBALS)
	(DESC "veil")
	(SYNONYM VEIL)
	(FLAGS WEARBIT TAKEBIT)
	(SIZE 3)
	(ACTION VEIL-F)>

<ROUTINE VEIL-F ()
	 <COND (<VERB? LOOK-INSIDE>
		<COND (<FSET? ,VEIL ,WORNBIT>
		       <V-LOOK>)
		      (T
		       <PERFORM ,V?EXAMINE ,VEIL>
		       <RTRUE>)>)
	        (<AND <VERB? WEAR>
		      <FSET? ,MASK ,WORNBIT>>
		 <WONT-FIT-OVER ,MASK>
		 <RTRUE>)>>

<ROUTINE WONT-FIT-OVER (OBJ)
	 <TELL "It won't fit over the " D .OBJ "." CR>>

<OBJECT SHAWL
	(IN CLOSET)
	(DESC "shawl-jacket combo")
	(SYNONYM JACKET SHAWL COMBO) 
	(ADJECTIVE LEATHER KNITTED)
	(FLAGS NDESCBIT WEARBIT TAKEBIT)
	(ACTION SHAWL-F)>

<ROUTINE SHAWL-F ()
	 <COND (<AND <VERB? WEAR>
		     <FSET? ,SUIT ,WORNBIT>>
		<WONT-FIT-OVER ,SUIT>)>>

<ROOM ON-TENT
      (IN ROOMS)
      (DESC "On the Tent")
      (FLAGS ONBIT RLANDBIT)
      (DOWN PER POKE-EXIT)
      (GLOBAL LADDER TENT BURN-HOLE)
      (GROUND-LOC NOOK)
      (ACTION ON-TENT-F)>

<ROUTINE ON-TENT-F (RARG)
	 <COND (<EQUAL? .RARG ,M-LOOK>
		<TELL
"You are standing unsteadily on top of a gabled tent. ">
	        <COND (<NOT <RUNNING? ,I-POKE>>
		       <TELL 
"On one edge of the tent a rope " D ,LADDER " drops down.">)>
		<CRLF>)
	       (<EQUAL? .RARG ,M-BEG>
		<COND (<AND <VERB? WALK>
		            <NOT <EQUAL? ,P-WALK-DIR ,P?DOWN>>>
		       <PERFORM ,V?WALK-AROUND>
		       <RTRUE>)		
	              (<VERB? WALK-AROUND>
		       <TELL 
"With lousy footing and a lousy sense of " D ,INTDIR " up here, you take a
few wobbly steps." CR>
		       <SETG NOT-MOVED-C 0>
		       <RTRUE>)
		      (T
		       <RFALSE>)>)
	       (<AND <EQUAL? .RARG ,M-ENTER>	
		     <RUNNING? ,I-CHASE>>
		<DISABLE <INT I-CHASE>>
	        <ENABLE <QUEUE I-POKE -1>>)>>

<ROUTINE POKE-EXIT ()
	 <COND (<RUNNING? ,I-POKE>
		<TELL "You can't seem to locate the rope ladder." CR>
	 	<RFALSE>)
	       (T
		<DOWN-LADDER>)>>

<GLOBAL NOT-MOVED-C 0> ;"If 3, you die. Set to 0 when you V-WALK-AROUND"

<GLOBAL POKE-C 0> ;"Incremented each time I-POKE runs"
		  
<GLOBAL WON-ON-TENT <>>

<ROUTINE I-POKE ()
	 <SETG NOT-MOVED-C <+ ,NOT-MOVED-C 1>>
	 <SETG POKE-C <+ ,POKE-C 1>>
	 <CRLF>
	 <COND (<OR <EQUAL? ,POKE-C 2 4 7>
		    <EQUAL? ,POKE-C 9 12>>
		<FCLEAR ,BURN-HOLE ,INVISIBLE>
	        <TELL  
"Suddenly, and with a muffled \"pop,\" a sleek metal shaft is thrust
upward through the canvas. ">
	 	<COND (<OR <G? ,NOT-MOVED-C 3>
		           <EQUAL? ,POKE-C 12>>
		       <JIGS-UP 3 
"Its business end makes electrifying contact with your skin.">
		       <RTRUE>)
		      (<EQUAL? ,POKE-C 4 9> 
		       <MOVE ,PROD ,HERE>
		       <TELL 
"It lingers momentarily, its business end sending a wisp of smoke into the
night air.">)
		      (T
		       <TELL-PROD-WITHDRAW>)>)
	      (<EQUAL? ,POKE-C 5 10>
	       <MOVE ,PROD ,LOCAL-GLOBALS>
	       <TELL-PROD-WITHDRAW>)
	      (<OR <EQUAL? ,POKE-C 1 3 6>
	           <EQUAL? ,POKE-C 8 11>>
	       <TELL
"You can hear, from inside the tent, what sounds like a ladder being
moved across the " D ,GROUND ", then the plod of footsteps coming nearer
and louder.">)
	      (<EQUAL? ,POKE-C 17>
	       <TELL 
"Still in your death-grip, the prod pivots dangerously close to your forearm,
and you feel its electronic heat.">)
	      (<EQUAL? ,POKE-C 18>
	       <TELL "The " D ,PROD " slips a bit in your sweaty grip.">)
	      (<EQUAL? ,POKE-C 19>
	       <JIGS-UP 3 "The prod is violently thrust into your stomach!">
	       <RTRUE>)
	      (T
	       <RFALSE>)>
	<CRLF>>
	      
<ROUTINE TELL-PROD-WITHDRAW ()
	 <TELL 
"The prod, finding no contact, is withdrawn through its burn hole.">>

<OBJECT PROD
	(IN LOCAL-GLOBALS)
	(DESC "elephant prod")
	(SYNONYM PROD SHAFT STUNNER)	
	(ADJECTIVE ELEPHANT CRUDE ELECTRONIC METAL)
	(FLAGS NDESCBIT TAKEBIT VOWELBIT)
	(ACTION PROD-F)>

<ROUTINE PROD-F ()
	 <COND (<VERB? EXAMINE>
		<TELL
"The metal shaft is rigged with a crude electronic stunner at its end." CR>)
	       (<VERB? TAKE>
		<SETG POKE-C 15>
		<MOVE ,PROD ,PROTAGONIST>
		<TELL 
"You grip the shaft tightly as its owner begins jostling it dangerously.">
		<RTRUE>)
	       (<VERB? PUSH MOVE THROW RAISE SHAKE>
		<SETG SCORE <+ ,SCORE 10>>
		<MOVE ,PROD ,LOCAL-GLOBALS>
		<SETG WON-ON-TENT T>		
	        <DISABLE <INT I-POKE>>
		<ENABLE <QUEUE I-MOVE-DICK 10>>
		<TELL
"Sounds of awkward footwork and cursing come from inside the tent as your
opponent struggles with you and finally gets the shaft. There is a shriek
of bloodcurdling terror as he takes the " D ,PROD ", which sears loudly
through the " D ,CANVAS ", down with him.|
|
Moments later, you hear someone helping the victim, who is groaning in pain,
out of the tent. The " D ,LADDER " is also dragged out." CR>)
	       (<OR <VERB? DROP GIVE PUT PUT-ON THROW THROW-OFF>
		    <AND <TOUCHING? ,PROD>
			 <IS-NOUN? ,W?STUNNER>>>
		<SETG POKE-C 18>
		<TELL "Blunder!" CR>)>>

<OBJECT BURN-HOLE
	(IN LOCAL-GLOBALS)
	(DESC "burn hole")
	(SYNONYM HOLE HOLES)	
	(ADJECTIVE BURN)
	(FLAGS NDESCBIT)
	(ACTION BURN-HOLE-F)>   

<ROUTINE BURN-HOLE-F ()
	 <COND (<VERB? LOOK-INSIDE>
		<TELL "You ">
		<COND (<RUNNING? ,I-POKE>
		       <TELL 
"glimpse some movement below but are too disoriented to make it out">)
		      (T
		       <TELL "can't make anything out">)>
		<TELL ,PERIOD>)
	       (<VERB? ENTER THROUGH BOARD>
		<TELL "It's too small." CR>)>>  

<ROUTINE I-MOVE-DICK ()
	 <ENABLE <QUEUE I-MOVE-DICK -1>>
	 <COND (<AND <NOT <EQUAL? ,HERE ,MIDWEST>>
		     <FSET? ,CLOWN-ALLEY ,TOUCHBIT>
		     <NOT <IN? ,DICK ,MIDWEST>>>
		<SETG DICK-DRUNK T>
		<MOVE ,DICK ,MIDWEST>
		<FSET ,DICK ,RMUNGBIT>		
		<MOVE ,TRADE-CARD ,GLOBAL-OBJECTS>
		<MOVE ,NOTE ,GLOBAL-OBJECTS>
	        <FCLEAR ,DICK ,NDESCBIT>
		<DISABLE <INT I-MOVE-DICK>>)
	       (T
		<RFALSE>)>>

<OBJECT TENT
	(IN LOCAL-GLOBALS)
	(DESC "tent")
	(SYNONYM TENT ENTRANCE CANVAS)	
	(ADJECTIVE ELEPHANT ;BULL DROOPY)
	(FLAGS NDESCBIT)
	(GENERIC GEN-TENT)
	(ACTION TENT-F)>

<ROUTINE TENT-F ()
	 <COND ;(<VERB? EXAMINE>
		<COND (<EQUAL? ,HERE ,ON-CAGE>
		       <TELL 
,YOU-SEE ", faintly, a rope " D ,LADDER " against the " D ,TENT "." CR>)
		      (T
		       <RFALSE>)>)
	       (<VERB? CLIMB-ON CLIMB-UP CLIMB-FOO>
		<COND (<EQUAL? ,HERE ,ON-CAGE>
		       <PERFORM ,V?CLIMB-UP ,LADDER>
		       <RTRUE>)>)
	       (<VERB? ENTER THROUGH WALK-TO BOARD>
		<COND (<EQUAL? ,HERE ,MEN>
		       <DO-WALK ,P?EAST>)
		      (<EQUAL? ,HERE ,BACK-YARD>
		       <DO-WALK ,P?WEST>)
		      (<EQUAL? ,HERE ,WEST-CAMP>
		       <PERFORM ,V?THROUGH ,CANVAS>
		       <RTRUE>)
		      (<EQUAL? ,HERE ,PROP-ROOM ,BULL-ROOM>
		       <TELL ,LOOK-AROUND CR>)
		      (T
		       <V-WALK-AROUND>)>)
	       (<VERB? CRAWL-UNDER>
		<COND (<AND <EQUAL? ,HERE ,PROP-ROOM>
		       	    <FSET? ,CANVAS ,RMUNGBIT>>
		       <DO-WALK ,P?SOUTH>)
		      (<EQUAL? ,HERE ,WEST-CAMP>
		       <PERFORM ,V?THROUGH ,CANVAS>
		       <RTRUE>)
		      (T
		       <TENT-BOUND>)>)
	       (<VERB? LOOK-INSIDE>
		<COND (<EQUAL? ,HERE ,BULL-ROOM ,PROP-ROOM>
		       <V-LOOK>)
		      (<EQUAL? ,HERE ,MEN>
		       <COND (<IN? ,BULL ,HERE>
		       	      <PERFORM ,V?EXAMINE ,BULL>)
		      	     (T
		       	      <PERFORM ,V?LOOK-INSIDE ,ME>)>)
		      (<EQUAL? ,HERE ,BACK-YARD>
		       <TELL 
"You can't see anything past the shadowy entrance." CR>)
		      (<EQUAL? ,HERE ,WEST-CAMP>
		       <PERFORM ,V?EXAMINE ,CANVAS>
		       <RTRUE>)>)
		(<AND <VERB? LOOK-BEHIND>
		      <EQUAL? ,HERE ,NOOK>>
		 <PERFORM ,V?EXAMINE ,FRONT>
		 <RTRUE>)>>

<OBJECT BULL
	(IN MEN)
	(DESC "elephant")
	(SYNONYM ELEPHANT BULL TRUNK HANNIBAL)	
	(ADJECTIVE JUNGLE BIG AFRICAN TUSK TUSKS TRUNK PACHYDERM)
	(FLAGS NDESCBIT ACTORBIT VOWELBIT)
	(ACTION BULL-F)>

<ROUTINE BULL-F ()
	 <COND (<VERB? EXAMINE>
		<TELL 
"Behind two soulful eyes, gleaming white tusks, and lush palm-like ears
stands the huge gray elephantine bulk that is Hannibal of the Jungle." CR>)
	       (<TALKING-TO? ,BULL>
		<TELL "The " D ,BULL " merely eyes you passively." CR>
		<STOP>)
	       (<VERB? UNLOCK>
		<CANT-REACH ,CHAIN>)
	       (<AND <VERB? THROW PUT-UNDER>
		     <PRSO? ,MOUSE ,DEAD-MOUSE>>
		<PERFORM ,V?GIVE ,PRSO ,BULL>
		<RTRUE>)
	       (<VERB? CRAWL-UNDER>
		<DO-WALK ,P?EAST>)
	       (<OR <AND <VERB? PUT>
			 <PRSI? ,BULL>>
		     <AND <VERB? GIVE SHOW>
		          <PRSI? ,BULL>>>
		<COND (<IDROP>
		       <RTRUE>)
		      (<PRSO? ,BALLOON>
		       <BALLOON-FLIGHT>
		       <CRLF>)
		      (<AND <PRSO? ,DEAD-MOUSE>
			    <NOT <FSET? ,DEAD-MOUSE ,RMUNGBIT>>>
		       <FSET ,DEAD-MOUSE ,RMUNGBIT>
		       <TELL 
"The old bromide about " D ,BULL "s being afraid of mice is in fact, you
suddenly recall, based on the big pachyderms' fear of losing their balance by
stepping on little squishy things like people or scampering rodents.
(Hence Gloria Golotov's fearlessness tonight while lying under Hannibal's
mighty hoof.)|
|
Glumly, you poke the " D ,DEAD-MOUSE "'s cold, soft belly and realize
it lacks the pizzazz to get Hannibal to dancing." CR>)
		      (<EQUAL? ,PRSO ,MOUSE>
		       <COND (<NOT <IN? ,MOUSE ,PROTAGONIST>>
			      <TELL ,NOT-HOLDING " the " D ,MOUSE "." CR>)
			     (<FSET? ,BULL ,RMUNGBIT>
			      <MOVE ,MOUSE ,LOCAL-GLOBALS>
			      <ENABLE <QUEUE I-BULL 2>>
			      <TELL
"A humid stream of air from the " D ,BULL "'s trunk blasts your face. The " 
D ,MOUSE " wriggles from your grip and scurries across the " D ,SAWDUST
" under Hannibal." CR>)
			     (T
			      <FSET ,BULL ,RMUNGBIT>
			      <TELL 
"The mouse itself is in a fright. It squirms across the back of " D ,HANDS ",
and then dangles once again from your grip.|
|
Wide-eyed, the bull " D ,BULL " takes one giant lumbering step backward.
Its " D ,CHAIN "s jingle as the bull begins rocking with slow-motion
nervousness from side to side." CR>)>)
		       (<OR <EQUAL? ,PRSO ,WATER>			    
			    <AND <EQUAL? ,PRSO ,BUCKET>
			         <IN? ,WATER ,BUCKET>>>
			<COND (<FSET? ,BULL ,RMUNGBIT>
			       <PERFORM ,V?HELLO ,BULL>
			       <RTRUE>)>
			<MOVE ,WATER ,LOCAL-GLOBALS>
			<ENABLE <QUEUE I-BULL 2>>
		        <TELL
"Hannibal eagerly snakes his thick trunk over to the " D ,BUCKET
" and with a quick snort siphons out all of the " D ,WATER "." CR>)   
		       (T
			<TELL 
"With its lazy trunk, the bull grasps the " D ,PRSO>
			<COND (<TRAP-SET?>
			       <FSET ,TRAP ,RMUNGBIT>
			       <TELL 
" which snaps down hard, barely tickling the thick skin of the pachyderm,
who">)
			      (T	
			       <TELL " and">)>
			<TELL " flings it ">
		<COND (<OR <PROB 50>
			   <PRSO? ,TRAP>>
		       <MOVE ,PRSO ,HERE>
		       <TELL "in your " D ,INTDIR>)
		      (T
		       <MOVE ,PRSO ,BULL-ROOM>
		       <TELL "behind itself">)>
		<TELL ,PERIOD>)>)
	       (<VERB? RUB>
		<TELL 
"You can feel the warm, slobbery end of the " D ,BULL "'s trunk against
your cheek." CR>)
	       (<VERB? LOOK-BEHIND>
		<DO-WALK ,P?EAST>
		<RTRUE>)
	       (<AND <VERB? FOLLOW>
		     <EQUAL? ,FOLLOW-FLAG 12>>
		<DO-WALK ,P?SW>
		<RTRUE>)>> 

<ROUTINE I-BULL ()
	 <COND (<FSET? ,BULL ,RMUNGBIT>
	 	<SETG SCORE <+ ,SCORE 10>>
		<MOVE ,BULL ,LOCAL-GLOBALS>
		<COND (<EQUAL? ,HERE ,MEN ,APE-ROOM>
		       <FCLEAR ,MEN ,TOUCHBIT>
		       <FCLEAR ,NEAR-WAGON ,TOUCHBIT>
		       <ENABLE <QUEUE I-FOLLOW 2>>
		       <SETG FOLLOW-FLAG 12>
		       <TELL CR 
"Loudly trumpeting its frustration, Hannibal of the Jungle thunders
out of the tent, shearing its " D ,CHAIN " with a dull thud. The raging
bull stampedes ">
		       <COND (<EQUAL? ,HERE ,APE-ROOM>
			      <TELL "past you and ">)>
		       <TELL "through a fence to the southwest." CR>)>
		<RTRUE>)
	       (<EQUAL? ,HERE ,MEN>
		<COND (<PROB 50>
		       <TELL CR 
"Spouting point-blank from the " D ,BULL "'s trunk, a blast of warm " 
D ,WATER " sprays you in the face.">)
		      (T
		       <TELL CR
"The " D ,BULL " lazily draws its trunk upward, ejecting the " D ,WATER
" across its broad back.">)>
		       <CRLF>
		       <RTRUE>)
	       (T
		<RFALSE>)>>
		
<ROUTINE QUEUE-THUMB? ()
	 <COND (<AND ,THUMB-TAPPED
		     ,HYP-BOX
		     <NOT <IN? ,BULL ,MEN>>>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE I-THUMB ()
	 <ENABLE <QUEUE I-THUMB -1>>
	 <COND (<OR <AND <FSET? ,THUMB ,RMUNGBIT>
		         <NOT <IN? ,THUMB ,HERE>>>
		    <NOT ,HELPED-THUMB>>
		<COND (<NOT ,WARPED-DOOR-BROKEN>
		       <MOVE ,THUMB ,CLOWN-ALLEY>)>
	        <DISABLE <INT I-THUMB>>
		<RFALSE>)
	       (T
		<FCLEAR ,THUMB ,NDESCBIT>
	 	<FCLEAR ,BLUE-DOOR ,RMUNGBIT>
	 	<FSET ,DEALER ,RMUNGBIT>	 
	 	<COND (<NOT <FSET? ,THUMB ,RMUNGBIT>>
		       <MOVE ,THUMB ,HERE>
		       <FSET ,THUMB ,RMUNGBIT>
		       <TELL CR 
"For an instant you can hear the treading of light feet on the ground.
The figure of " D ,THUMB " appears out of the darkness, flailing his small
arms and babbling up at you in his native tongue. He then pauses a moment
to think." CR>)
	       	      (T
		       <DISABLE <INT I-THUMB>>
	       	       <TELL CR 
"Suddenly animated again by an idea, the little comrade taps on your foot
and points stridently in the direction of the Blue Room. He then looks
around with an air of suspicion, backing cautiously away into the night." CR>
	               <ROB ,UPPER ,MASK>
		       <ROB ,LOWER ,MASK>
		       <MOVE ,THUMB ,CLOWN-ALLEY>
		       <SETG FOLLOW-FLAG 1>
		       <ENABLE <QUEUE I-FOLLOW 2>>)>)
	       (T
		<RFALSE>)>>  

<OBJECT CHAIN
	(IN LOCAL-GLOBALS)
	(DESC "massive chain")
	(SYNONYM CHAIN CHAINS MENAGERIE)
	(ADJECTIVE MASSIVE)
	(FLAGS TRYTAKEBIT NDESCBIT TAKEBIT)
	(ACTION CHAIN-F)>

<ROUTINE CHAIN-F ()
	 <COND (<IS-NOUN? ,W?MENAGERIE>
		<SETG PRSO ,MENAGERIE>
		<GLOBAL-ROOM-F>)
	       (<AND <TOUCHING? ,CHAIN>
		     <IN? ,BULL ,HERE>>
		<CANT-REACH ,CHAIN>)
	       (<VERB? TAKE TIE>
		<TELL "You barely manage to budge the " D ,CHAIN "." CR>)>>

<ROOM NOOK
      (IN ROOMS)
      (DESC "Menagerie Nook")
      (FLAGS ONBIT RLANDBIT)      
      (EAST PER BLUE-DOOR-ENTER)
      (NORTH TO ROUST-ROOM IF ROUST-DOOR IS OPEN)
      (IN PER NOOK-EXIT)
      (NW TO MEN)
      ;(WEST TO MEN)
      (UP PER UP-DOWN-CAGE)
      (GLOBAL ROUST-DOOR CAGE STRAW TENT FRONT BLUE-DOOR)
      (ACTION NOOK-F)>

<ROUTINE NOOK-F (RARG)
	 <COND (<EQUAL? .RARG ,M-LOOK>	
		<TELL
"You are standing outside of the elephant " D ,TENT ". Along its side wall
to the north sits a " D ,CAGE " with " D ,STRAW " poking out of it. The
menagerie is northwest of here.|
|
Facing you on the east side there is a big old plywood sideshow front,
faded beyond recognition. It serves as the barrier wall of an enclosed
structure behind the elephant tent." CR>)
	       (<AND <EQUAL? .RARG ,M-BEG>
		     <ENABLED? ,I-DEMISE>
		     <VERB? RESTORE QUIT RESTART>>
		<TELL "Not so fast." CR>)>>
	
<ROUTINE NOOK-EXIT ()
	 <COND (<FSET? ,BLUE-DOOR ,OPENBIT>
	        <RETURN ,BLUE-ROOM>)
	       (<FSET? ,ROUST-DOOR ,OPENBIT>
	        <RETURN ,ROUST-ROOM>)
	       (T
		<V-WALK-AROUND>
		<RFALSE>)>>

<ROUTINE BLUE-DOOR-ENTER ()
	 <COND (<FSET? ,BLUE-DOOR ,INVISIBLE>
		<TELL ,CANT-GO CR>
		<RFALSE>)
	       (<NOT <FSET? ,BLUE-DOOR ,OPENBIT>>
		<TELL "The " D ,BLUE-DOOR " is closed." CR>
		<RFALSE>)
	       (T
		<RETURN ,BLUE-ROOM>)>>

<OBJECT PATH
	(IN LOCAL-GLOBALS)
	(DESC "path")
	(SYNONYM PATH PASSAGE)
	(FLAGS NDESCBIT TRYTAKEBIT)
	(ACTION PATH-F)>

<ROUTINE PATH-F ()
	 <COND (<NOT <AND <EQUAL? ,MEET-COUNTER 10>
		          <NOT ,DREAMING>>>
		<CANT-SEE ,PATH>)
	       (<VERB? FOLLOW TAKE WALK-TO BOARD THROUGH>
		<COND (<EQUAL? ,HERE ,MEN>
		       <DO-WALK ,P?SE>)
		      (<EQUAL? ,HERE ,NOOK>
		       <DO-WALK ,P?NW>)
		      (<EQUAL? ,HERE ,WINGS>
		       <DO-WALK ,P?NE>)
		      (<EQUAL? ,HERE ,UNDER-STANDS>
		       <DO-WALK ,P?SW>)>)>>

<OBJECT STRAW
	(IN LOCAL-GLOBALS)
	(DESC "straw")
	(SYNONYM STRAW LAYER BED)
	(ADJECTIVE COURSE)
	(FLAGS TRYTAKEBIT NOA)
	(ACTION STRAW-F)>

<ROUTINE STRAW-F ()
	 <COND (<OR <VERB? MOVE RAISE SEARCH LOOK-INSIDE DIG>
		    <AND <EQUAL? ,HERE ,APE-ROOM>
		         <VERB? TAKE>>>
		<PERFORM ,V?LOOK-UNDER ,STRAW>
		<RTRUE>)	       
	       (<VERB? TAKE> ;"to weave baskets? the last straw"
		<SETG AWAITING-REPLY 5>
		<ENABLE <QUEUE I-REPLY 2>>
		<TELL "So you're taking up basket-weaving now?" CR>)>>

<OBJECT SAWDUST
	(IN LOCAL-GLOBALS)
	(DESC "sawdust")
	(SYNONYM SAWDUST)
	;(ADJECTIVE COURSE)
	(FLAGS TRYTAKEBIT NOA)
	;(ACTION SAWDUST-F)>

<OBJECT GLOBAL-SAWDUST ;"cf., above"
	(IN GLOBAL-OBJECTS)
	(DESC "sawdust")
	(SYNONYM SAWDUST)
	;(ADJECTIVE COURSE)
	(FLAGS NDESCBIT TRYTAKEBIT NOA)
	(ACTION GLOBAL-SAWDUST-F)>

<ROUTINE GLOBAL-SAWDUST-F ()
	 <COND (<DONT-HANDLE? ,SAWDUST>
		<RFALSE>)
	       (<NOT <EQUAL? ,HERE ,RING>>
		<CANT-SEE <> "any sawdust">)>>

<OBJECT ROUST-DOOR
	(IN LOCAL-GLOBALS)
	(DESC "cage door")
	(SYNONYM DOOR GATE LOCK)
	(ADJECTIVE CAGE)
	(FLAGS DOORBIT NDESCBIT LOCKEDBIT CAGEBIT)
	(GENERIC GEN-NOOK-DOOR-F)
	;(ACTION ROUST-DOOR-F)>

;<ROUTINE ROUST-DOOR-F ()
    	 <COND (<AND <VERB? PUT> 
		     <EQUAL? ,PRSI ,ROUST-DOOR>>
		<COND (<G? <GETP ,PRSO ,P?SIZE> 20>
		       <TELL "It won't fit through the door." CR>)
		      (T
		       <MOVE ,PRSO ,MEN>
		       <TELL
"The " D ,PRSO " goes through the lion-door into the darkness below." CR>)>)>>

<ROOM ROUST-ROOM
      (IN ROOMS)
      (DESC "Inside Cage")
      (OUT TO NOOK IF ROUST-DOOR IS OPEN)
      (SOUTH TO NOOK IF ROUST-DOOR IS OPEN)
      (FLAGS RLANDBIT ONBIT INDOORSBIT)
      (GLOBAL ROUST-DOOR STRAW CAGE)
      (ACTION ROUST-ROOM-F)>

<ROUTINE ROUST-ROOM-F (RARG)
	 <COND (<EQUAL? .RARG ,M-LOOK>
		<TELL
"This barred rectangular hovel is blanketed with straw and has the look,
if not the smell, of a human dwelling. Its southside door ">
		<COND (<FSET? ,ROUST-DOOR ,OPENBIT>
		       <TELL "stands open">)
		      (T
		       <TELL "is closed">)>
		<TELL ,PERIOD>)>> 

<OBJECT KEY
	(IN NOOK)   
	(DESC "skeleton key")
	(SYNONYM KEY RING KEYS)
	(ADJECTIVE SKELETON KEY HOOP)
	(FLAGS NDESCBIT TAKEBIT TRYTAKEBIT)
	(SIZE 4)
	(ACTION KEY-F)>

;"TRYTAKEBIT for KEY = KEY is still on wall"

<ROUTINE KEY-F ()
	 <COND (<AND <IS-NOUN? ,W?KEYS>
		     <NOT <FSET? ,KEY ,TRYTAKEBIT>>>
		<TELL "(It's just one key.)" CR CR>)>
		<REAL-KEY-F>>

<ROUTINE REAL-KEY-F ()
	 <COND (<TAKE-WITH-POLE?>
		<RTRUE>)
	       (<AND <TOUCHING? ,PRSO> ;"V-TAKE-WITH is NOT in touching"
		     <NOT <EQUAL? ,PRSA ,V?PUT>>
		     <FSET? ,KEY ,TRYTAKEBIT>>
		<COND (<PRSI? ,POLE>
		       <RFALSE>)>
		<CANT-REACH ,KEY>)
	       (<VERB? EXAMINE>
		<TELL "The " D ,KEY " is attached to a hoop ring." CR>)
	       (<AND <VERB? PUT>
		     ;<PRSI? ,KEY>
		     <NOT <IDROP>>>
		<COND (<AND <PRSO? ,POLE>
			    <FSET? ,KEY ,TRYTAKEBIT>>
		       <PERFORM ,V?TAKE-WITH ,KEY ,POLE>
		       <RTRUE>)
		      (T
		       <RFALSE>)>)
	       (<OR <AND <VERB? REMOVE OPEN>
			 <PRSO? ,KEY>>
		    <AND <VERB? TAKE>
		         <PRSI? ,KEY>
		         <PRSO? ,KEY>>>
		<TELL "The key ring is welded shut." CR>)>>

<ROUTINE TAKE-WITH-POLE? ()
	 <COND (<AND <FSET? ,PRSO ,TRYTAKEBIT>
		     <VERB? TAKE-WITH MOVE KILL>
		     <PRSI? ,POLE>>
		<MOVE ,PRSO ,PROTAGONIST>
		<FCLEAR ,PRSO ,TRYTAKEBIT>
		<FCLEAR ,PRSO ,NDESCBIT>
		<COND (<AND <EQUAL? ,PRSO ,KEY>
			    <NOT <FSET? ,KEY ,TOUCHBIT>>>
		       <SETG SCORE <+ ,SCORE 10>>)>
		<FSET ,PRSO ,TOUCHBIT>
		<TELL 
"Using the " D ,POLE ", you fish the hoop ring off the " D ,WALLS
". It slides down the raised pole and jingles into " D ,HANDS "." CR>)
	       (T
		<RFALSE>)>>

;<OBJECT KEY-RING
	(IN NOOK)
	(DESC "key ring")
	(SYNONYM RING)
	(ADJECTIVE KEY)
	(FLAGS TAKEBIT TRYTAKEBIT OPENBIT CONTBIT SEARCHBIT NDESCBIT)
	(ACTION KEY-RING-F)>

;<ROUTINE KEY-RING-F ()
	 <COND (<KEY-REACH?>
		<RTRUE>)>>

<OBJECT JIM
	(IN LOCAL-GLOBALS)
	(DESC "roustabout")
	(DESCFCN JIM-DESCFCN)
	(SYNONYM ROUSTABOUT MAN)
     	(FLAGS ACTORBIT PERSON CONTBIT OPENBIT SEARCHBIT)
    	(ACTION JIM-F)>

;"RMUNGBIT = have got him under my spell"

<ROUTINE JIM-F ()
	 <COND (<EQUAL? ,JIM ,WINNER>
		<COND (<AND <FSET? ,JIM ,RMUNGBIT>
		       	    <NOT <VERB? HELLO>>>
		       <TELL "The " D ,JIM>
	               <COND (<OR <AND <VERB? FIND TAKE WHERE>
			    	       <PRSO? ,NET ,GLOBAL-NET>>
				  <AND <VERB? PUT-UNDER>
				       <PRSO? ,NET ,GLOBAL-NET>
				       <PRSI? ,TIGHTROPE-OBJECT>>>
		       	      <SETG FOLLOW-FLAG 5>
			      <SETG SCORE <+ ,SCORE 10>>
			      <SETG P-IT-OBJECT ,JIM-GLOBAL>
			      <ENABLE <QUEUE I-FOLLOW 3>>
			      <MOVE ,JIM ,LOCAL-GLOBALS>
		       	      <ENABLE <QUEUE I-END-GAME 3>>
		       	      <TELL " goes tearing out through the wings.">)
		             (T
		       	      <TELL 
", though he possesses a vocabulary of over 800 words and can comprehend
something a bit more complex than a simple two-word command, seems unable
to act upon your words, perhaps because this is not one of his usual
duties.">)>
		<CRLF>
		<STOP>)      
	       (T
		<SETG WINNER ,PROTAGONIST>
	        <PERFORM ,V?ASK-ABOUT ,JIM ,MUNRAB>
		<SETG WINNER ,JIM>
		<RTRUE>)>)
	       (<AND <VERB? ASK-ABOUT>
		     <PRSO? ,JIM>>
		<TELL 
"The " D ,JIM ", alas, doesn't relate well to strangers. He ignores you."
CR>)	
	       (<VERB? EXAMINE>	
		<COND (<FSET? ,JIM ,RMUNGBIT>
		       <TELL "He's standing at attention">)
		      (T
		       <TELL 
"He looks flea-bitten, slack-jawed and hangdog">)>
		<TELL ,PERIOD>)
	       (<AND <VERB? FOLLOW>
		     <EQUAL? ,FOLLOW-FLAG 14 5>>
		<DO-WALK ,P?SOUTH>)>>
		      
<ROUTINE JIM-DESCFCN ("OPTIONAL" X)
	 <TELL "A " D ,JIM " stands nearby.">>

<OBJECT JIM-GLOBAL           ;"for talking to thru phones" 
	(IN GLOBAL-OBJECTS)
	(DESC "roustabout")
	(SYNONYM ROUSTABOUT)
	(FLAGS NDESCBIT ACTORBIT)
	(ACTION JIM-GLOBAL-F)>

<ROUTINE JIM-GLOBAL-F ()
	 <COND (<AND <VERB? FOLLOW>
		     <EQUAL? ,FOLLOW-FLAG 14 5>>
		<DO-WALK ,P?SOUTH>)
	       (<DONT-HANDLE? ,JIM-GLOBAL>
		<RFALSE>)
	       (<AND <IN? ,HEADPHONES ,HERE>
		     <TALKING-TO? ,JIM-GLOBAL>
		     <NOT <VERB? WAVE-AT ALARM>>>
		<SETG WINNER ,PROTAGONIST>
		<PERFORM ,V?TALK-INTO ,HEADPHONES>
		<RTRUE>)	       
	       (T
		<CANT-SEE ,JIM-GLOBAL>
		<STOP>)>>
	
<OBJECT MALCOM
	(IN LOCAL-GLOBALS)
	(DESC "Malcom")
	(SYNONYM MALCOM)
     	(ADJECTIVE MYSTIC)
	(FLAGS ACTORBIT PERSON NARTICLEBIT)>

<OBJECT BROS
	(IN LOCAL-GLOBALS)
	(DESC "Genatossio")
	(SYNONYM BROTHER)
     	(ADJECTIVE GENATOSSIO)
	(FLAGS ACTORBIT PERSON NARTICLEBIT)>

<OBJECT GLORIA
	(IN LOCAL-GLOBALS)
	(DESC "Gloria")
	(SYNONYM GLORIA)
     	(ADJECTIVE GLORIOUS)
	(FLAGS ACTORBIT PERSON NARTICLEBIT)>

<OBJECT DUFFY
	(IN LOCAL-GLOBALS)
	(DESC "Sgt. Duffy")     	
	(SYNONYM DUFFY)
	(ADJECTIVE SGT SERGEANT)
	(FLAGS ACTORBIT PERSON NARTICLEBIT)
	(ACTION DUFFY-F)>

<ROUTINE DUFFY-F ()
	 <COND (<AND <EQUAL? ,PRSI ,DUFFY>
		     <VERB? ASK-ABOUT TELL-ABOUT ASK-FOR>>
		<RFALSE>)
	       (T
		<TELL "This isn't his usual beat." CR>)>>

<OBJECT HEADPHONES 
	(IN ROUST-ROOM)
	(DESC "pair of headphones")
      	(FDESC 
"In contrast with the seedy surroundings, an expensive-looking pair of
headphones lies on the straw.")
	(SYNONYM PAIR HEADPHONES PLAYER COUNTER)
	(ADJECTIVE CASSETTE CONTROL MIKE MICROP EXPENSIVE TAPE)
	(FLAGS LIGHTBIT ;ONBIT WEARBIT 
	       TAKEBIT OPENBIT CONTBIT ;TRYTAKEBIT ;NDESCBIT ;SEARCHBIT)
    	(SIZE 10)        
	(ACTION HEADPHONES-F)>

;"RMUNGBIT = have tried to wear phones once"
;"TRYTAKEBIT = they hang on wall in roust-cage/nook"

<ROUTINE HEADPHONES-F ("AUX" NUM)   ;"kludge"	 
	 <COND (<AND <IN? ,HEADPHONES ,APE>
		     <NOT <VERB? TAKE>>
			  <OR <VERB? EXAMINE REWIND PLAY ADVANCE LAMP-OFF
				RECORD LAMP-ON>
		         <TOUCHING? ,HEADPHONES>>>
		<TELL D ,APE " has the " D ,HEADPHONES "." CR>
		<RTRUE>)
	       ;(<AND <TOUCHING? ,HEADPHONES>
		     <IN? ,HEADPHONES ,APE>
		     <EQUAL? ,HERE ,MEN>>
		<CANT-REACH ,HEADPHONES>
		<RTRUE>)>
	 <COND (<AND <VERB? LAMP-OFF EJECT ;RECORD PLAY REWIND ADVANCE>
		     <EQUAL? ,KNOB-SET ,V?RECORD>>
		<RECORD-TAPE T>)>
	 <COND (<VERB? EXAMINE READ>
	        <SET NUM <* ,ON-TAPE 62>>
	        <TELL 
"It's a nice " D ,HEADPHONES " with a built-in cassette player which
contains a tape, which is now ">
	       	<COND (<EQUAL? ,KNOB-SET ,V?PLAY>
		       <TELL "playing">)
	       	      (<EQUAL? ,KNOB-SET ,V?ADVANCE>
	               <TELL "advancing">)
	       	      (<EQUAL? ,KNOB-SET ,V?REWIND>
		       <TELL "rewinding">)
		      (<EQUAL? ,KNOB-SET ,V?RECORD>
		       <TELL "recording">)
		      (T
		       <TELL "not spinning">)>
		<TELL 
". The controls allow you to either play, record, advance, rewind or eject
the tape. A counter on the player reads [" N .NUM "]." CR>)
	       (<EQUAL? ,PRSA ,KNOB-SET>
		<COND (<VERB? LAMP-ON PLAY>
		       ;<SETG PRSA ,V?EXAMINE>
		       <TELL "It's already playing." CR>)
		      (T
		       <TELL "That's what the tape is already doing." CR>)>)
	       (<OR <AND <VERB? PLAY ADVANCE RECORD>
			 <EQUAL? ,ON-TAPE 15>>
		    <AND <VERB? REWIND>
			 <EQUAL? ,ON-TAPE 0>>>
	        <TELL "You're at the very ">
		<COND (<EQUAL? ,ON-TAPE 15>
		       <TELL "end">)
		      (T
		       <TELL "beginning">)>
		<TELL " of the tape." CR>)
	       (<VERB? PLAY ADVANCE RECORD REWIND>		       
		<ENABLE <QUEUE I-RUN -1>>
	        <SETG KNOB-SET ,PRSA>		       
	        <COND (<VERB? RECORD>
		       <TELL "The small mike crackles open." CR>)
		      (T 		;"1 2 3" 
		       <TAPE-PRINT T>)>
		<RTRUE>)
	       (<VERB? LAMP-ON>		
		<PERFORM ,V?PLAY ,HEADPHONES>
		<RTRUE>)
	       (<VERB? LAMP-OFF EJECT>
		<SETG KNOB-SET <>>
		<TELL "The tape ">
		<COND (<RUNNING? ,I-RUN>		       
		       <TELL "stops spinning">)
		      (<VERB? LAMP-OFF>
		       <TELL "isn't even running." CR>
		       <RTRUE>)>
		<COND (<AND <VERB? EJECT>
			    <RUNNING? ,I-RUN>>
		       <TELL " but ">)>
		<COND (<VERB? EJECT>
		       <TELL "simply will not eject">)>
		<DISABLE <INT I-RUN>>
		<TELL ,PERIOD>)
	       (<VERB? OPEN>
		<TELL "The headphones won't open up." CR>)
	       (<VERB? WEAR>
		<TELL 
"The headphones, seemingly tailored for a pinhead, fit you like a vise.
And since they can be listened to without being worn, you remove them." CR>)
	       (<AND <VERB? TAKE>
		     <IN? ,HEADPHONES ,APE>
		     <FSET? ,APE ,RMUNGBIT>>
	        <TELL
D ,APE " has a fit as you snatch away the source of his listening pleasure. ">
		       <APE-DEATH>)
               (<VERB? LISTEN>
		<COND (<IN? ,HEADPHONES ,APE>
		       <TELL "It's " ,CLASSICAL>)
		      (<AND <EQUAL? ,KNOB-SET ,V?PLAY>
			    <EQUAL? <GET ,TAPE-TABLE ,ON-TAPE> 2 0>>
		       <PERFORM ,V?LISTEN ,MUSIC>
		       <RTRUE>)
		      (<EQUAL? ,KNOB-SET ,V?PLAY ,V?REWIND ,V?ADVANCE>
		       <SETG FOLLOW-FLAG 99>
		       <ENABLE <QUEUE I-FOLLOW 1>>
		       <RTRUE>)>)
	       (<VERB? TELL TALK-INTO>    ;"V-TELL can't move clock"
		<TELL "It would only fall on deaf ears." CR>
		<SETG CLOCK-WAIT T>
		<RTRUE>)>> 

<GLOBAL KNOB-SET <>> ;"set to a verb atom"

;"For the non-programmer: each element, 0 to 15 inclusive, is a discrete 
minute on the tape. An element of 0 is rock music, of 1 is back-ground
hiss, of 2 is classical music, 4 is AM radio noise" 

<GLOBAL TAPE-TABLE
        <TABLE 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0>>

<GLOBAL ON-TAPE 6> ;"Discrete location on tape from 0 to 15 inclusive"

<ROUTINE RECORD-TAPE ("OPTIONAL" (NOT-ADVANCE? <>))
         ;<COND (<EQUAL? ,ON-TAPE 0>
		<SET BEG T>)
	       (T
		<SETG ON-TAPE <+ ,ON-TAPE 1>>)>
	 <COND (<AND <VERB? TALK-INTO>
		     <PRSO? ,HEADPHONES>>
		<PUT ,TAPE-TABLE ,ON-TAPE 3>)
	       (<CLASSICAL-PLAYING?>
		<PUT ,TAPE-TABLE ,ON-TAPE 2>)
	       (<AND <GETP <META-LOC ,RADIO> ,P?GROUND-LOC>
		     <EQUAL? <META-LOC ,RADIO> <META-LOC ,HEADPHONES>>
		     <FSET? ,RADIO ,ONBIT>>
		<PUT ,TAPE-TABLE ,ON-TAPE 4>)	       
	       (T
		<PUT ,TAPE-TABLE ,ON-TAPE 1>)>
	<COND (.NOT-ADVANCE?
	       <RTRUE>)>
	<SETG ON-TAPE <+ ,ON-TAPE 1>>
	<RTRUE>>
	  
<ROUTINE TAPE-PRINT ("OPTIONAL" (TURN? <>) "AUX" (FF? <>) (CR? T))
	 <COND (<EQUAL? ,FOLLOW-FLAG 99>
		;<AND <VERB? LISTEN>
		     <PRSO? ,HEADPHONES>>
		<SET CR? <>>)>
	 <COND (<NOT <VISIBLE? ,HEADPHONES>>
		<RFALSE>)
	       (<EQUAL? ,KNOB-SET ,V?ADVANCE ,V?REWIND>
		<COND (<EQUAL? ,KNOB-SET ,V?ADVANCE>
		       <SET FF? T>)>
	 	       <COND (.TURN?
			      <TELL-TURN-KNOB>
			      <TELL "the cassette tape begins to ">
			      <COND (.FF?
		       		     <TELL "advance">)
		      		    (T
		       		     <TELL "rewind">)>
			      <TELL " rapidly">)
	       		     (T
			      <COND (.CR?
				     <CRLF>)>
			      <TELL "The tape continues whirring ">
			      <COND (.FF?
		       		     <TELL "forward">)
		      		    (T
		       		     <TELL "backward">)>)>
		<TELL ,PERIOD>)
	       (<EQUAL? ,KNOB-SET ,V?PLAY>
	 	<COND (.TURN?
		       <TELL-TURN-KNOB>
		       <TELL "you hear from the headphones ">)
		      (T
		       <COND (.CR?
			      <CRLF>)>
		<TELL "The tape continues to play, emitting ">)>
	        <COND (<0? <GET ,TAPE-TABLE ,ON-TAPE>>
	               <TELL "the blare of a Jimi Hendrix guitar solo">
		       <COND (<EQUAL? ,ON-TAPE 3 4> ;"on-tape starts at 6"
		       	      <TELL 
". You can also hear, in the background, the subliminal low tones of a ">
			      <COND (<FSET? ,HYP ,RMUNGBIT>
				     <TELL 
"voice you recognize as Rimshaw's.">)
				    (T
				     <TELL "hypnotic voice.">)>
			      <TELL
" He repeats these words over and over again: \"At the clap of my hands
you shall obey my every command.\"" CR>
			      <RTRUE>)>)
	       	      (<EQUAL? <GET ,TAPE-TABLE ,ON-TAPE> 2>
			   ;<EQUAL? ,ON-TAPE 15>			   
		       <TELL "the sounds of classical music">)
	       	      ;(<EQUAL? <GET ,TAPE-TABLE ,ON-TAPE> 3>
		       <TELL "the sound of your own voice babbling away">)
	       	      (<EQUAL? <GET ,TAPE-TABLE ,ON-TAPE> 4>
		       <TELL "the noise of AM radio">)
		      (T
		       <TELL "background hiss">)>
		<TELL ,PERIOD>)>
	  ;<COND (<OR <G? ,ON-TAPE 15>
		     <L? ,ON-TAPE 1>>
		 <STOP-TAPE>
		 <RTRUE>)>
	  <COND (<AND .TURN?
		      <L? ,ON-TAPE 16>> 
		 <TELL-COUNTER T>)>
	  <RTRUE>>

<ROUTINE TELL-TURN-KNOB ()
	 ;<ENABLE <QUEUE I-RUN 2>>
	 <TELL "You adjust the controls and ">>

<ROUTINE I-RUN ("AUX" NUM)
	 <COND (<EQUAL? ,KNOB-SET ,V?PLAY>
		<SETG ON-TAPE <+ ,ON-TAPE 1>>)
	       (<EQUAL? ,KNOB-SET ,V?ADVANCE>
	        <SETG ON-TAPE <+ ,ON-TAPE 5>>)
	       (<EQUAL? ,KNOB-SET ,V?REWIND>
		<SETG ON-TAPE <- ,ON-TAPE 5>>)>
	 <COND (<IN? ,HEADPHONES ,APE>
		<RFALSE>)>
	 <COND (<EQUAL? ,KNOB-SET ,V?RECORD>		
		<RECORD-TAPE>)              ;"advances on-tape by one"
	       (<AND <NOT <EQUAL? ,ON-TAPE 16>>
		     <EQUAL? <META-LOC ,HEADPHONES> ,HERE>
		     <EQUAL? ,KNOB-SET ,V?PLAY ,V?ADVANCE ,V?REWIND>
		     <NOT <ENABLED? ,I-DEMISE>>
		     <NOT <AND <OR <EQUAL? ,PRSA ,V?LAMP-ON ,V?PLAY>
				   <EQUAL? ,PRSA ,V?ADVANCE ,V?REWIND>>
		     	       <PRSO? ,HEADPHONES>>>>
	        <TAPE-PRINT>)>	 
	 <COND (<OR <G? ,ON-TAPE 15>
		    <L? ,ON-TAPE 1>>
		<COND (<AND <EQUAL? ,KNOB-SET ,V?RECORD>
			    <EQUAL? ,ON-TAPE 15>>
		       <RECORD-TAPE T>)>
	        <STOP-TAPE>)> 
	 <COND (<AND <VERB? EXAMINE>
		     <PRSO? ,HEADPHONES>>
		<RTRUE>)
	       (<AND <NOT <EQUAL? ,PRSA ,V?PLAY ,V?REWIND>>
		     <NOT <EQUAL? ,PRSA ,V?ADVANCE ,V?LAMP-ON>>
		     <VISIBLE? ,HEADPHONES>>
		<TELL-COUNTER>)>
	 <RTRUE>>

<ROUTINE TELL-COUNTER ("OPTIONAL" (TURN-KNOB? <>) "AUX" TAPE-LOC)
	 <SET TAPE-LOC ,ON-TAPE>	 
	 <COND (.TURN-KNOB?
		<COND (<EQUAL? ,KNOB-SET ,V?REWIND>
		       <SET TAPE-LOC <- ,ON-TAPE 5>>)
		      (<EQUAL? ,KNOB-SET ,V?PLAY>
		       <SET TAPE-LOC <+ ,ON-TAPE 1>>)
		      (<EQUAL? ,KNOB-SET ,V?ADVANCE>
		       <SET TAPE-LOC <+ ,ON-TAPE 5>>)>)>
	 <SET TAPE-LOC <* .TAPE-LOC 62>>
	 <COND (<AND <G? .TAPE-LOC 0>
		     <L? .TAPE-LOC 931>>
		<TELL "The counter reads [" N .TAPE-LOC "]." CR>)>
	 <RTRUE>>

<ROUTINE STOP-TAPE ()
	 <SETG KNOB-SET <>>
	 <DISABLE <INT I-RUN>>		
	 <COND (<VISIBLE? ,HEADPHONES>
	        <TELL "The tape suddenly halts." CR>)>
	 <COND (<G? ,ON-TAPE 15>
		<SETG ON-TAPE 15>)
	       (T
	        <SETG ON-TAPE 0>)>
	 <RTRUE>>

<OBJECT MUSIC
	(IN GLOBAL-OBJECTS)
	(DESC "music")
	(SYNONYM MUSIC)
	(ADJECTIVE CLASSIC)
	(FLAGS NDESCBIT CLEARBIT)	
	(ACTION MUSIC-F)>

<ROUTINE MUSIC-F () 
	 <COND (<OR <AND <CLASSICAL-PLAYING?>
			 <VISIBLE? ,RADIO>>
		     <AND <RUNNING? ,I-RUN>  
			 <EQUAL? ,KNOB-SET ,V?PLAY>
		         <EQUAL? <GET ,TAPE-TABLE ,ON-TAPE> 2 0>>>
		<COND (<VERB? LISTEN>
		       <COND (<OR <AND <CLASSICAL-PLAYING?>
				       <VISIBLE? ,RADIO>>
				  <EQUAL? <GET ,TAPE-TABLE ,ON-TAPE> 2>>
			      <TELL "It has a calming effect on you." CR>)
			     (T
			      <TELL "It's pretty irritating." CR>)>)
		      (<AND <VERB? RECORD>
			    <VISIBLE? ,HEADPHONES>>
		       <PERFORM ,V?RECORD ,HEADPHONES>
		       <RTRUE>)>)
	      (T
	       <CANT-SEE ,MUSIC>)>>

<ROUTINE CLASSICAL-PLAYING? ()
 	 <COND (<AND <GETP <META-LOC ,RADIO> ,P?GROUND-LOC>
		     <EQUAL? <META-LOC ,RADIO> <META-LOC ,HEADPHONES>>
		     <FSET? ,RADIO ,ONBIT>
		     <EQUAL? ,STATION 1170>>
		<RTRUE>)
	       (T
		<RFALSE>)>>

;"Midway attractions"

<ROOM PARLOR
      (IN ROOMS)
      (DESC "Hypnotist's Parlor")
      (FLAGS ONBIT RLANDBIT INDOORSBIT)
      (SOUTH TO MID)
      (OUT TO MID)
      (ACTION PARLOR-F)>

<ROUTINE PARLOR-F (RARG)
	 <COND (<EQUAL? .RARG ,M-LOOK>
		<TELL 
"The parlor, with its tufted black leather sofa, softly lighted chandelier
and darkly varnished paneling strives for a subdued turn-of-the-century motif
and is purposefully dimmed -- thus setting the mood for conveyance, for
squinting." CR>)
	       (<AND <EQUAL? .RARG ,M-BEG>
		     <IN? ,HYP ,HERE>>
		<COND (<AND <VERB? EXAMINE>
		       	    <PRSO? ,SOFA ,CHANDELIER>
		       	    <NOT <FSET? ,PRSO ,RMUNGBIT>>>
		       <FSET ,PRSO ,RMUNGBIT>
		       <TELL
"Before you can fix your gaze upon the " D ,PRSO ", " D ,HYP " speaks, \"You
are wondering about the " D ,PRSO ". But I can assure you, there is nothing
at all " <PICK-ONE ,YAWNS> " about it. Observe for " D ,ME ".\" Rimshaw
gestures in a grand manner toward">
		       <ARTICLE ,PRSO T>
		       <TELL  ". Amazing." CR>)
		      (<AND <VERB? DROP THROW>
			    <FSET? ,PRSO ,TAKEBIT>
			    <NOT <FSET? ,PRSO ,WORNBIT>>
			    <NOT <EQUAL? ,PRSO ,MOUSE ,BALLOON ,TICKET>>>
		       <HYP-HAND-BACK>)>)>>

<OBJECT PARLOR-OBJECT
	(IN PARLOR)
	(DESC "parlor")
	(SYNONYM PARLOR)
	;(ADJECTIVE HYPNOT)
	(FLAGS NDESCBIT)	
	(ACTION GLOBAL-ROOM-F)>

<OBJECT CHANDELIER
	(IN PARLOR)
	(DESC "chandelier")
	(SYNONYM CHANDELIER LIGHT)
	(FLAGS LIGHTBIT NDESCBIT)
	(ACTION LIGHT-F)>

<GLOBAL HYP-BOX <>>

<ROUTINE HYP-HAND-BACK ()
	 <TELL 
D ,HYP " is also Rimshaw the Immaculate. He hands">
	 <ARTICLE ,PRSO T>
	 <TELL " back to you." CR>>

<OBJECT TICKET
	(IN LOCAL-GLOBALS)
	(DESC "your ticket")
	(SYNONYM TICKET OAKLEY DUCAT DUCKET)
	(ADJECTIVE MY YOUR ANNIE)
	(LDESC "Your ticket lies here.")
	(FLAGS TAKEBIT CONTBIT OPENBIT NARTICLEBIT)
        (SIZE 2)
	(ACTION TICKET-F)>

<ROUTINE TICKET-F ()
	 <COND (<VERB? PUSH PUNCH CUT>
		<TELL ,SPECIFIC>)
	       (<VERB? LOOK-INSIDE EXAMINE READ>
		<PERFORM ,V?EXAMINE ,PINK-BOX>
		<SETG P-IT-OBJECT ,TICKET>
		<RTRUE>)
	       (<AND <VERB? PUT-UNDER>
		     <EQUAL? ,PRSI ,FRONT>
		     <EQUAL? ,HERE ,NOOK>>
	       <PERFORM ,V?PUT-UNDER ,PRSO ,BLUE-DOOR>
	       <RTRUE>)
	       (<AND <VERB? TAKE>
		     <IN? ,TICKET ,DEALER>>
		<TELL "The " D ,DEALER " yanks it back." CR>)>>

<OBJECT BLUE-BOX
	(IN TICKET)
	(DESC "blue dot")
	(SYNONYM DOT)
	(ADJECTIVE BLUE)
	(FLAGS NDESCBIT)
	(ACTION BOX-F)>

<OBJECT PINK-BOX
	(IN TICKET)
	(DESC "pink dot")
	(SYNONYM DOT)
	(ADJECTIVE PINK)
	(FLAGS NDESCBIT)
	(ACTION BOX-F)>

<ROUTINE BOX-F ()
	 <COND (<OR <VERB? PUSH PUNCH CUT>
		    <EQUAL? ,P-PRSA-WORD ,W?POKE>>
		<COND (<NOT <IN? ,TICKET ,PROTAGONIST>>
		       <SETG P-IT-OBJECT ,TICKET>
		       <TELL ,NOT-HOLDING " the ticket." CR>)
		      (<FSET? ,PRSO ,RMUNGBIT>
		       <TELL "It already is." CR>)
		      (<OR <AND <PRSO? ,BLUE-BOX>
			        <FSET? ,PINK-BOX ,RMUNGBIT>>
			   <AND <PRSO? ,PINK-BOX>
				<FSET? ,BLUE-BOX ,RMUNGBIT>>>
		       <SETG AWAITING-REPLY 3>
	               <ENABLE <QUEUE I-REPLY 2>>
		       <TELL
"Were you ever considering a career with the circus?" CR>)
		      (T
		       <FSET ,PRSO ,RMUNGBIT>
		       <TELL "You perforate the " D ,PRSO "." CR>)>)
	       (<AND <VERB? DROP THROW PUT GIVE>
		     <PRSO? ,BLUE-BOX ,PINK-BOX>>
		<PERFORM ,PRSA ,TICKET ,PRSI>
		<RTRUE>)
	       (<VERB? EXAMINE>
		<IN-PACKAGE ,TICKET>)>>

<ROUTINE MAN-OR-WOMAN (MAN WOMAN)
	 <COND (<FSET? ,BLUE-BOX ,RMUNGBIT>
	 	<TELL .MAN>)
	       (T
		<TELL .WOMAN>)>>

<OBJECT HYP
	(IN PARLOR)
	(DESC "Rimshaw the Incomparable")
	(DESCFCN HYP-DESC)
	(SYNONYM MAN ;INCOMP RIMSHA PHRENO PALM-READER)
	;(ADJECTIVE MAN RIMSHA)
	(FLAGS NARTICLEBIT ACTORBIT PERSON CONTBIT OPENBIT SEARCHBIT)
	(ACTION HYP-F)>

;"RMUNGBIT = have TALKED-TO? him once and got spiel"

<ROUTINE HYP-F ()
      	 <COND (<AND <NOT <FSET? ,HYP ,RMUNGBIT>>
		     <VERB? TELL>>
		<RFALSE>)
	       (<AND <NOT <FSET? ,HYP ,RMUNGBIT>>
		     <NOT <VERB? ASK-ABOUT>>
		     <OR <TALKING-TO? ,HYP>	
		         <AND <VERB? GIVE SHOW THROW>
			      <PRSO? ,TICKET>>>>
	         <FSET ,HYP ,RMUNGBIT>
		 <TELL
"Rimshaw steps nearer, speaking in a very spiritual tone, \"I can tell
immediately that you " D ,ME " possess great powers of transcendence. It
is your eyes which bespeak your affinity with those mysterious energies
that choose to remain unseen.">
		<COND (<AND <VERB? GIVE SHOW THROW>
			    <PRSO? ,TICKET>>
		       <TELL "\"" CR CR>
		       <TELL-WHAT-NOW>)
		      ;(<AND <VERB? TELL>
			    ,P-CONT>
		       <SETG WINNER ,PRSO>
		       <SETG HERE <LOC ,WINNER>>
		       <RTRUE>)
		      (<AND <EQUAL? ,WINNER ,HYP>
		            <VERB? HYPNOTISE>
			    <EQUAL? ,PRSO ,ME>
			    <HELD? ,TICKET>>
		        <CRLF> <CRLF>
			<TELL-WHAT-NOW <> T>
			<CRLF> <CRLF>
			<PERFORM ,V?HYPNOTISE ,ME>
			<RTRUE>)
		      (T
		       <SETG P-IT-OBJECT ,HYP>
		       <TELL " Ticket, please.\"" CR>
		<STOP>)>)
	       (<EQUAL? ,WINNER ,HYP>
                <COND (<AND <VERB? TELL-ABOUT>
	                    <PRSO? ,ME>
			    ;<NOT <EQUAL? ,PRSI ,HEAD ,FORTUNE ,HANDS>>>
	               <SETG WINNER ,PROTAGONIST>
	               <PERFORM ,V?ASK-ABOUT ,HYP ,PRSI>
	               <SETG WINNER ,HYP>
	               <RTRUE>)
	              (<VERB? HELLO>
	               <SETG WINNER ,PROTAGONIST>
	               <PERFORM ,V?HELLO ,HYP>
	               <SETG WINNER ,HYP>
	               <RTRUE>)
		      (<AND <VERB? HYPNOTISE>
			    <PRSO? ,ME>>
		       <COND (<TICKET-CHECK? ,PARLOR>
			      <RTRUE>)
			     (T
			      <COND (<NOT <EQUAL? <LOC ,PROTAGONIST> ,SOFA>>
				     <TELL 
"You settle into the tufted " D ,SOFA " and ">)>
			      <TELL
D ,HYP " approaches you purposefully. Poised in front of you, the hypnotist
points both of his hands' tension-filled fingers at you and commands,
\"RE-LAX!!! Now count backward slowly from 100.\"" CR CR>
			      <SETG P-CONT <>> 
			      <TELL 
"With transcendental calm you begin mouthing the words one hundred,
ninety-nine, ninety-eight ...">
			      <DREAM>)>)  
		      (<OR <AND <VERB? RUB READ EXAMINE>
			        <PRSO? ,HEAD>>
			   <AND <VERB? TELL-ABOUT>
			        <PRSO? ,ME>
				<PRSI? ,HEAD>>>
		       <COND (<TICKET-CHECK? ,HEAD>
		       	      <RTRUE>)
			     (T
			      <SETG DREAM-C <+ ,DREAM-C 1>>
			      <FSET ,HEAD ,RMUNGBIT>
			      <TELL
D ,HYP " places his fingertips on top of your skull and begins going
carefully over its hills and valleys, pausing occasionally for comment.
\"Intelligence: I ascertain you play Infocom games. Personally I enjoyed
\"Enchanter\" ... Romance: A ">
			      <COND (<FSET? ,PINK-BOX ,RMUNGBIT>
				     <TELL "tall handsome stranger">)
				    (T
				     <TELL "woman of mysterious beauty">)>
			      <TELL "
will soon come into your life ... Travel: You will visit the Grand Canyon
before the year is out.\"|
|
With this, Rimshaw gives a perfunctory slap up the side of your head and
says, \"End of Session.\"" CR>)>)
		      (<OR <AND <VERB? READ RUB EXAMINE>
			        <PRSO? ,HANDS>>
			   <AND <VERB? TELL READ EXAMINE>
			        <PRSO? ,FORTUNE>>
			   <AND <VERB? TELL-ABOUT>
			        <PRSO? ,ME>
				<PRSI? ,FORTUNE ,HANDS>>>
		       <COND (<TICKET-CHECK? ,HANDS>
			      <RTRUE>)			     
			     (T
			      <FSET ,HANDS ,RMUNGBIT>
			      <SETG DREAM-C <+ ,DREAM-C 1>>
			      <TELL 
D ,HYP " takes " D ,HANDS " and studies the palm lines with the intensity
of a cartographer, finally saying in a dramatic whisper, \"Tonight you
have an appointment with destiny.\"" CR>)>)
		      (T
		       <TELL "Rimshaw remains aloof." CR>
                       <STOP>)>)                 ;"end of winner"
	       (<VERB? GIVE SHOW THROW>
	        <COND (<PRSO? ,TICKET>
		       <COND (,HYP-BOX
			      <COND (<OR <NOT ,WON-STANDS>
				         <L? ,DREAM-C 4>>
				     <TELL-WHAT-NOW T>)
				    (T
				     <TELL                           
"\"I have done all that I can do. No more.\"" CR>)>)
			     (T     
			      <TELL-WHAT-NOW>)>)
		      (<PRSO? ,HANDS>
		       <SETG WINNER ,HYP>
		       <PERFORM ,V?READ ,HANDS>
		       <SETG WINNER ,PROTAGONIST>
		       <RTRUE>)              
		      (<AND <PRSO? ,HEADPHONES>
			    <NOT ,TAPE-SHOW>>
		       <SETG TAPE-SHOW T>
		       <TELL 
D ,HYP " begins to lose his composure, regains it again quickly, does a
slow burn, stomps around the " D ,PARLOR-OBJECT " a bit, then reassumes
his previous lordly manner." CR>) 
		      (<NOT <FSET? ,MASK ,WORNBIT>>
		       <PERFORM ,V?ASK-ABOUT ,HYP ,PRSO>
		       <RTRUE>)>)	       
	       (<AND <VERB? ASK-ABOUT>
		     <PRSI? ,HEAD ,HANDS ,FORTUNE>>
	        <SETG WINNER ,HYP>
	        <PERFORM ,V?READ ,PRSI>
		<SETG WINNER ,PROTAGONIST>
		<RTRUE>)
	       (<AND <VERB? ASK-ABOUT>
		     <PRSO? ,HYP>>
		<TELL 
D ,HYP " draws his hand to his forehead, closes his eyes, meditates a
moment, then offers, \"About">
		<COND (<OR <IN? ,PRSI ,ROOMS>
			   <EQUAL? ,PRSI ,HYP>>
		       <TELL " that">)
		      (T
		       <ARTICLE ,PRSI T>)>
		<COND (<PROB 50>
		       <TELL " I am unable">)
		      (T
		       <TELL " it is impossible for me">)>
		<TELL " to soothsay.\"" CR>)>>
                                                        
<ROUTINE HYP-DESC ("OPTIONAL" X)
	 <SETG P-IT-OBJECT ,HYP>
	 <TELL  
"Standing here, attired in an immaculate black tuxedo, is none other than
Rimshaw himself.">>

<GLOBAL TAPE-SHOW <>>

<ROUTINE TICKET-CHECK? ("OPTIONAL" (OBJ <>))
	 <COND (<NOT ,HYP-BOX>
		<TELL "\"Ticket, please.\"" CR>
		<RTRUE>)
	       (<OR <FSET? .OBJ ,RMUNGBIT> 
		    <AND <EQUAL? ,PRSA ,V?HYPNOTISE>
			 <OR <G? ,DREAM-C 3>
			     ,WON-STANDS>>>
		       <TELL 
"With the arrogant self-satisfaction common to members of his profession,
he responds, \"It's been done.\"" CR>
	               <RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE TELL-WHAT-NOW ("OPTIONAL" (LOOKS-AT? <>) (NO-Q? <>))
	 <SETG HYP-BOX T>
	 <ENABLE <QUEUE I-HYP 2>>   ;"ie, rimshaw is winner for"
	 <TELL "He ">               ;"in v-hypnotise"
	 <COND (.LOOKS-AT?                
		<TELL "glances at">)
	       (T
		<TELL "punches">)> 
 	 <TELL " your ticket and hands it back.">
	 <SETG P-IT-OBJECT ,HYP>
	 <COND (.NO-Q?
		<RTRUE>)>
	 <TELL " \"Whadda you want?\"" CR>> 

<ROUTINE I-HYP ()
	 <DISABLE <INT I-HYP>>
	 <COND (<FSET? ,CANVAS ,RMUNGBIT>
		<FCLEAR ,TRAP ,NDESCBIT>)>
	 <RFALSE>>

<ROUTINE DREAM ()
	 <ROB ,PROTAGONIST ,BIGTOP>
	 <MOVE-TAKEBIT ,WINGS ,BANNER>
	 <MOVE-TAKEBIT ,CON-AREA ,BUTTON>
	 <MOVE ,LONG ,CON-AREA>
	 <MOVE ,CONCESSIONAIRE ,CON-AREA>
	 <MOVE ,CON-STAND ,CON-AREA>
	 <MOVE ,ROAR ,STANDS-ROOM>
	 <MOVE ,UNIFORM ,HAWKER>
	 ;<SETG SCORE-BEFORE-DREAM ,SCORE>
	 ;<SETG MOVES-BEFORE-DREAM ,MOVES>
	 ;<SETG SCORE 16>
	 ;<SETG MOVES 7>
	 <SETG SIT-IN-STANDS T>
	 <SETG MONEY-BEFORE-DREAM ,POCKET-CHANGE>
	 <SETG POCKET-CHANGE 1841>
	 <SETG DREAMING T>	 
	 <SETG STANDS-C 0>
	 <SETG TLOC 1>
	 <FCLEAR ,CON-AREA ,TOUCHBIT>
	 <FCLEAR ,STANDS-ROOM ,TOUCHBIT>
	 <ENABLE <QUEUE I-STANDS 1>>
         <TELL CR CR 
"Your mind begins to drift back, back, back into the most recently forgotten
past ..." CR CR>	 
	 <GOTO ,STANDS-ROOM>>

<ROUTINE WAKE-UP ("OPTIONAL" (FORCED? <>))
	 <ROB ,BIGTOP ,PROTAGONIST>
	 <ROB ,BANNER ,WINGS>
         <ROB ,BUTTON ,CON-AREA>
	 <FCLEAR ,LONG ,TOUCHBIT>
	 <FCLEAR ,WINGS ,TOUCHBIT>
	 <FCLEAR ,HAWKER ,RMUNGBIT>
	 <FCLEAR ,MONKEY ,RMUNGBIT>
	 <FCLEAR ,LONG ,RMUNGBIT>
	 <FCLEAR ,JERRY ,RMUNGBIT>
	 <FCLEAR ,TEAM ,RMUNGBIT>
	 <FCLEAR ,BANANA ,RMUNGBIT>
	 <MOVE ,CONCESSIONAIRE ,LOCAL-GLOBALS>
	 <MOVE ,JUNK-FOOD ,LOCAL-GLOBALS>
	 <MOVE ,BANANA ,LOCAL-GLOBALS>
	 <MOVE ,UNIFORM ,THUMB>
	 <MOVE ,MONKEY ,DICK>
	 <MOVE ,LONG ,LOCAL-GLOBALS>
	 <MOVE ,SHORT ,LOCAL-GLOBALS>
	 <MOVE ,HAWKER ,LOCAL-GLOBALS>	
	 <MOVE ,CON-STAND ,LOCAL-GLOBALS>	 
	 ;<SETG FOOD-ORDERED <>>
	 ;<SETG ADJ-FOOD-ORDERED <>>
	 <SETG ORDERED-GRANOLA <>>
	 <SETG POCKET-CHANGE ,MONEY-BEFORE-DREAM>
	 <SETG HERE ,PARLOR>
         <SETG DREAMING <>>
	 <SETG LINE-COUNTER 0>
	 <SETG PLAYER-NUM 1>
         <DISABLE <INT I-BAD-LUCK>>
	 <DISABLE <INT I-STANDS>>
	 <MOVE ,PROTAGONIST ,SOFA>
	 <COND (<VERB? ALARM>
		<TELL "You suddenly drift back to reality ...">
		<COND (<NOT ,WON-STANDS>
		       <TELL 
" " D ,HYP " looks disappointed at your limited progress under hypnosis">
		       <COND (<L? ,DREAM-C 4>
			      <TELL 
" but he seems willing to try again">)>)>)
	       (T
	        <TELL "wake up ...">)> ;"WIN THE STANDS PUZZLE?"
	 <TELL "." CR CR>
	 <V-LOOK>>

;<OBJECT WATCH
	(IN HYP)
	(DESC "pocket watch")
      	(SYNONYM WATCH)
     	(ADJECTIVE POCKET)
	(FLAGS TRYTAKEBIT NDESCBIT)
    	(SIZE 7)
	;(ACTION WATCH-F)>

;<ROUTINE WATCH-F ()
	 <COND (<VERB? TAKE>
		<TELL "  ">)>>

<OBJECT SOFA
	(IN PARLOR)
	(DESC "leather sofa")
	(SYNONYM SOFA COUCH)
	(ADJECTIVE TUFTED BLACK LEATHER)
	(FLAGS VEHBIT CONTBIT SURFACEBIT NDESCBIT OPENBIT)
	(ACTION SOFA-F)>

;"RMUNGBIT = Hypno. has read your mind about sofa"

<ROUTINE SOFA-F ("OPTIONAL" (RARG <>))
	 <COND (<AND <EQUAL? .RARG ,M-BEG>
		     <VERB? WALK>>
		<OUT-OF-FIRST ,SOFA>)
	       (<AND <EQUAL? .RARG ,M-BEG>
		     <VERB? DROP THROW>>
		<HYP-HAND-BACK>)
	       (.RARG
		<RFALSE>)
	       (<VERB? LIE-DOWN>
		<TELL "This is hypnotism, not psychoanalysis." CR>)
	       (<VERB? OPEN CLOSE>
		<CANT-OPEN>)
	       (<AND <VERB? PUT-ON>
		     <PRSI? SOFA>>
		<PERFORM ,V?DROP ,PRSO>
		<RTRUE>)>>

<OBJECT TUX
	(IN HYP)
	(DESC "tuxedo")
	(SYNONYM TUX TUXEDO)
	(ADJECTIVE BLACK)
	(FLAGS NDESCBIT TRYTAKEBIT)
	(ACTION TUX-F)>

<ROUTINE TUX-F ()
	 <COND (<VERB? REMOVE TAKE>
		<KIND-OF-PERFORMER ,HYP>)>>

<OBJECT FORTUNE
	(IN GLOBAL-OBJECTS)
	(DESC "future")
	(SYNONYM FORTUNE FUTURE)
	(ADJECTIVE MY)
	(FLAGS NDESCBIT)
	(ACTION FORTUNE-F)>
		
<ROUTINE FORTUNE-F ()
	 <COND (<AND <VERB? TELL>
		     <ENABLED? ,I-HYP>>
		<SETG WINNER ,HYP>
		<PERFORM ,PRSA ,PRSO>
		<SETG WINNER ,PROTAGONIST>
		<RTRUE>)>>

<ROOM MID 
      (IN ROOMS)
      (DESC "Midway of Midway")
      (FLAGS ONBIT RLANDBIT)
      (WEST TO MIDWEST)
      (EAST TO MIDEAST)
      (NORTH TO PARLOR)
      (SOUTH TO BOUDOIR)
      (GLOBAL FRONT MIDWAY)
      (ACTION MID-F)>
	
<ROUTINE MID-F (RARG)
	 <COND (<EQUAL? .RARG ,M-LOOK>
		<TELL 
"This is about midway along the midway. "> 
	        <TELL-FRONT T>
		<COND (<IN? ,CROWD ,HERE>
		      <TELL CR 
"On the north side of the midway, a crowd is drawn tightly around a
sideshow entrance." CR>)>)
	       ;(<AND <EQUAL? .RARG ,M-ENTER>
		     <NOT <FSET? ,MID ,TOUCHBIT>>
		     <G? ,SCORE 7>
		     <L? ,SCORE 11>>
		<MOVE ,CROWD ,MID>)>>

<OBJECT MIDWAY 
	(IN LOCAL-GLOBALS)
	(DESC "midway")
	(SYNONYM MIDWAY)
	;(ADJECTIVE)
	(FLAGS NDESCBIT)
	(ACTION GLOBAL-ROOM-F)>

<OBJECT MENAGERIE 
	(IN LOCAL-GLOBALS)
	(DESC "menagerie")
	(SYNONYM MENAGERIE)
	(FLAGS NDESCBIT)
	(ACTION GLOBAL-ROOM-F)>

<OBJECT FRONT 
	(IN LOCAL-GLOBALS)
	(DESC "sideshow front")
	(SYNONYM FRONTS FRONT PLACARD ENTRANCE)
	(ADJECTIVE JENNY ANDREW RIMSHA TINA\'S SIDESHOW BIG OLD PLYWOOD)
	(FLAGS NDESCBIT RMUNGBIT)
	(ACTION FRONT-F)>

<ROUTINE FRONT-F ()
	 <COND (<VERB? EXAMINE READ>
		<TELL "The " D ,FRONT>
		<COND (<EQUAL? ,HERE ,MIDWEST>
		       <TELL " heralding the charms of Tina is">)
		      (<EQUAL? ,HERE ,NOOK ,MIDEAST>
		       <TELL " is">)
		      (T
		       <TELL "s are">)>
	        <COND (<EQUAL? ,HERE ,NOOK>
		       <TELL " warped and faded beyond recognition." CR>
		       <RTRUE>)
		      (T
		       <TELL 
" an eyeful of dazzling, flamboyant artwork similar to that represented
in the circus program along with glowing introductions of the performers. ">
	       		<COND (<EQUAL? ,HERE ,MID>
		      	       <TELL "Each ">)
		     	      (T
		      	       <TELL "The ">)>
	       		<TELL "front has a small entrance." CR>)>)
	      (<AND <VERB? LOOK-BEHIND>
		    <EQUAL? ,HERE ,NOOK>>
	       <TELL 
"You can't. The " D ,FRONT " serves as a barrier to an enclosed area." CR>)
	      (<VERB? THROUGH ENTER WALK-TO>
	       <COND (<EQUAL? ,HERE ,MID>
		      <TELL "North or south?" CR>)
		     (<EQUAL? ,HERE ,MIDEAST>
		      <DO-WALK ,P?NORTH>)
		     (<EQUAL? ,HERE ,NOOK>
		      <DO-WALK ,P?EAST>)>)
	      (<AND <VERB? PUT-UNDER>
		    <PRSO? TICKET>
		    <EQUAL? ,HERE ,NOOK>>
	        <COND (<NOT <EQUAL? ,CLOWN-COUNTER 7>>
		       <TELL ,TIPPED-OFF>
		       <RTRUE>)>
		<FCLEAR ,BLUE-DOOR ,INVISIBLE>
		<COND (<AND <EQUAL? ,BOUNCE-C 0>
			    <NOT <FSET? ,BLUE-ROOM ,TOUCHBIT>>>
			<SETG SCORE <+ ,SCORE 10>>)>
			<TELL 
"The ticket disappears under the plywood">
		<COND (<AND <EQUAL? ,BLUE-ROOM-ENTER-NUMBER 2>
			    <NOT <FSET? ,DEALER ,RMUNGBIT>>> ;<G? ,BOUNCE-C 19>
		       <COND (<FSET? ,BLUE-DOOR ,RMUNGBIT> 
			      <MOVE ,TICKET ,LOCAL-GLOBALS>
			      <TELL ,PERIOD>                
			      <RTRUE>)
			     (T
			      <FSET ,BLUE-DOOR ,RMUNGBIT>)>		       
	       	       <TELL " and then ">
		       <COND (<AND <EQUAL? ,BLUE-ROOM-ENTER-NUMBER 2>
				   ;<G? ,BOUNCE-C 19>
			           <NOT <FSET? ,DEALER ,RMUNGBIT>>>
			      <MOVE ,TICKET ,HERE>
			      <TELL "reappears." CR>)
			     (T
			      <FCLEAR ,BLUE-DOOR ,RMUNGBIT>
			      <WIN-BLUE-DOOR>)>) ;"second time around"
		      (T
		       <WIN-BLUE-DOOR T>)>)>> 
		
<ROUTINE I-BLUE-DOOR ()
	 <FCLEAR ,BLUE-DOOR ,OPENBIT>
	 <COND (<EQUAL? ,HERE ,BLUE-ROOM ,NOOK>
	 	<COND (<NOT <AND <VERB? CLOSE>
				 <PRSO? ,BLUE-DOOR>>>
		       <CRLF>)>
		<TELL 
"The spring-loaded " D ,BLUE-DOOR " slides shut." CR>)>>

<OBJECT BLUE-DOOR
	(IN LOCAL-GLOBALS)
	(DESC "secret panel")
	(SYNONYM PANEL OPENING DOOR)
	(ADJECTIVE SECRET SPRING)
	(FLAGS NDESCBIT DOORBIT INVISIBLE)
	(GENERIC GEN-NOOK-DOOR-F)
	(ACTION BLUE-DOOR-F)>

;"BLUE-DOOR RMUNGBIT = I've been kicked out and my ticket has been given
		       back to me, if I give it under door AGAIN, it is
		       NOT given back to me"

<ROUTINE BLUE-DOOR-F ()
	 <COND (<AND <VERB? PUT-UNDER>
		     <PRSO? ,TICKET>>
		<PERFORM ,V?PUT-UNDER ,TICKET ,FRONT>
		<RTRUE>)
	       (<VERB? WALK-TO THROUGH BOARD>
		<COND (<EQUAL? ,HERE ,NOOK>
		       <DO-WALK ,P?EAST>)
		      (<EQUAL? ,HERE ,BLUE-ROOM>
		       <DO-WALK ,P?WEST>)>)
               (<VERB? OPEN>
		<COND (<EQUAL? ,HERE ,BLUE-ROOM>
		       <COND (<EQUAL? ,BLUE-ROOM-ENTER-NUMBER 1>
			      <SETG BLUE-ROOM-ENTER-NUMBER 2>
			      <SETG FORCED-BET T>
			      <TELL "You decide instead to make ">
			      <COND (,BET-ONCE
				     <TELL "one last">)
				    (T	
				     <TELL "a">)>
			      <TELL 
" bet, and plunk 1 dollar down on the table." CR CR>
			      <SETG P-DOLLAR-FLAG T>
			      <SETG P-AMOUNT 100>
			      <PERFORM ,V?BET ,INTNUM>
			      <RTRUE>)>      
		       <ENABLE <QUEUE I-BLUE-DOOR 2>>
		       <RFALSE>)
		      (T
		       <TELL "There's no handle." CR>)>)
	       (<AND <VERB? CLOSE>
		     <FSET? ,BLUE-DOOR ,OPENBIT>>
		<RTRUE>)>>

<ROUTINE GEN-NOOK-DOOR-F ()
	 <COND (<VERB? PUT-UNDER>
		,BLUE-DOOR)>>
		     

<GLOBAL FORCED-BET <>> 

<ROUTINE WIN-BLUE-DOOR ("OPTIONAL" (AND? <>))
	 <FSET ,BLUE-DOOR ,OPENBIT>
	 <MOVE ,TICKET ,BLUE-ROOM>
	 <ENABLE <QUEUE I-BLUE-DOOR 3>>
	 <COND (.AND?
		<TELL " and ">)>
	 <TELL 
"moments later a " D ,BLUE-DOOR " in the old sideshow front slides open." CR>>

<ROOM FAT-WEST
      (IN ROOMS)
      (DESC "West Half of Fat Lady")
      (SOUTH PER AROUND-FAT)
      (OUT PER AROUND-FAT)
      (NE PER AROUND-FAT)
      (SE PER AROUND-FAT)
      (FLAGS ONBIT RLANDBIT INDOORSBIT)
      (GLOBAL BIGTOP)
      (ACTION FAT-ROOM-F)>
        
<ROOM FAT-EAST
      (IN ROOMS)
      (DESC "East Half of Fat Lady")
      (NW PER AROUND-FAT)
      (SW PER AROUND-FAT)
      (FLAGS ONBIT RLANDBIT INDOORSBIT)
      (GLOBAL BIGTOP)
      (ACTION FAT-ROOM-F)>

<ROUTINE FAT-ROOM-F (RARG)
	 <COND (<EQUAL? .RARG ,M-LOOK>
		<COND (<EQUAL? ,HERE ,FAT-WEST>
		       <TELL 
"Dominating this once spacious room, geographic in her enormity, mountainous
in her irreducibility, t">)
		      (T
		       <TELL "T">)>
	       <TELL
 "he " D ,FAT " sits (though no chair is visible) breathtakingly to the ">
               <COND (<EQUAL? ,HERE ,FAT-WEST>
		      <TELL "east">)
		     (T
		      <TELL "west">)>
	       <TELL ". ">
	       <TELL "Paths around the attraction lead ">
	       <COND (<EQUAL? ,HERE ,FAT-WEST>
		      <TELL "northeast and southeast. The exit is south." CR>
		      <RTRUE>)
		     (T
		      <TELL "northwest and southwest." CR>)>)>>

<ROUTINE AROUND-FAT ()
	 <SETG HANDOUT <>>
	 <COND (<HELD? ,FAT-HAND>
		<TELL "Not while you're holding the " D ,FAT-HAND "!" CR>
		<RFALSE>)
	       (<EQUAL? ,P-WALK-DIR ,P?SOUTH ,P?OUT>
		<RETURN ,MIDEAST>)
	       (<OR <AND <EQUAL? ,P-WALK-DIR ,P?EAST>
		         <EQUAL? ,HERE ,FAT-WEST>>
		    <AND <EQUAL? ,P-WALK-DIR ,P?WEST>
		         <EQUAL? ,HERE ,FAT-EAST>>>
		<TELL "The " D ,FAT "'s in the way." CR>
		<RFALSE>)  
		(T
	        <TELL 
"It's a long haul, the scenery changing little. Eventually you arrive at
..." CR CR>
	        <COND (<EQUAL? ,HERE ,FAT-EAST>
		       <MOVE-FAT ,FAT-WEST>)
	              (T
		       <MOVE-FAT ,FAT-EAST>)>)>>

<ROUTINE MOVE-FAT (PLACE)
	 <COND (<IN? ,RADIO ,FAT>
		<COND (<FSET? ,RADIO ,NDESCBIT>
		       <FCLEAR ,RADIO ,NDESCBIT>)
	       	      (T
		       <FSET ,RADIO ,NDESCBIT>)>)>
	 <MOVE ,FAT .PLACE>
	 <MOVE ,FAT-HAND .PLACE>
	 <RETURN .PLACE>>

<OBJECT FAT
	(IN FAT-WEST)
	(DESC "fat lady")
	(SYNONYM LADY TINA WOMAN)
	(ADJECTIVE FAT)
	(FLAGS ACTORBIT PERSON NDESCBIT CONTBIT OPENBIT FEMALE)
	(ACTION FAT-F)>

<GLOBAL HANDOUT <>>

<ROUTINE FAT-F ()
	 <COND (<OR <TALKING-TO? ,FAT>
		    <AND <VERB? GIVE SHOW>
			 <PRSI? ,FAT>
			 <NOT <FSET? ,PRSO ,EATBIT>>>>
		<COND (<AND <IN? ,RADIO ,FAT>
			    <NOT <FSET? ,RADIO ,NDESCBIT>>>
		       <TELL 
"She doesn't seem to notice you with that radio in her ear." CR>)
		      (T
		       <COND (<AND <FSET? ,GRANOLA ,RMUNGBIT>
				   <IN? ,RADIO ,FAT>>		              
			      <TELL 
"She merely sighs wistfully, which creates a gale-force gust"> 
			      <COND (<NOT ,HANDOUT>
				     <SETG HANDOUT T>
				     <COND (<NOT <HELD? ,FAT-HAND>>
					    <TELL
", and cranes her wrecking-ball-sized hand over to you">)>)>
			      <TELL ,PERIOD>)
		             (T
		              <TELL "She appears oblivious">
			      <COND (<FSET? ,GRANOLA ,RMUNGBIT>
				     <TELL ", once again,">)>
			      <TELL " to both sight and sound." CR>)>)>
		      <STOP>)
	       (<HURT? ,FAT>
		<TELL "The " D ,FAT " is unaffected by your malice." CR>)
	       (<VERB? BOARD CLIMB-ON CLIMB-UP CLIMB-FOO>
		<TELL "The slope is too steep." CR>)
	       (<VERB? SMELL>
		<TELL "There's no smell." CR>)  
	       (<VERB? EXAMINE>
		<TELL 
"The " D ,FAT " is wearing a " D ,BIGTOP ", and the expression on her face
is sad and distant, almost Rushmorean. "> 
		<COND (<AND <NOT <FSET? ,RADIO ,NDESCBIT>>
			    <IN? ,RADIO ,FAT>>
		       <TELL 
"She appears to be holding a small radio up to her ear.">)
		      (,HANDOUT
		       <TELL "The " D ,FAT-HAND " is reached out.">)>
		<CRLF>)
	       (<AND <VERB? GIVE SHOW>
		     <PRSI? ,FAT>>
		<COND (<AND <IN? ,RADIO ,FAT>
			    <NOT <FSET? ,RADIO ,NDESCBIT>>>
		       ;<SETG WINNER ,PROTAGONIST>
		       <PERFORM ,V?HELLO ,FAT>
		       <STOP>)
		      (<PRSO? ,GRANOLA>
		       <MOVE ,GRANOLA ,LOCAL-GLOBALS>
		       <FSET ,GRANOLA ,RMUNGBIT>   ;"She's eaten the food"
		       <TELL 
"Tina is quick to confiscate the " D ,GRANOLA " from " D ,HANDS " and
grinds it up without hesitation. Turning her far-away gaze slowly in your
direction, she seems to notice you for the first time this evening." CR>)
		      (<FSET? ,PRSO ,EATBIT>
		       <TELL 
"The " D ,PRSO " is obviously not part of her usual diet, since she ignores
it." CR>)>)
	       (<VERB? KISS>
		<COND (<HELD? ,FAT-HAND>
		       <PERFORM ,V?KISS ,FAT-HAND>
		       <RTRUE>)
		      (<FSET? ,BLUE-BOX ,RMUNGBIT>
		       <TELL
"The " D ,FAT " is far too distant for your affection." CR>)>)
	       (<AND <VERB? SHAKE-WITH>
		     <PRSO? ,HANDS>>
		<PERFORM ,V?TAKE ,FAT-HAND>
		<RTRUE>)
	       (<VERB? WALK-AROUND>
		<COND (<EQUAL? ,HERE ,FAT-WEST>
		       <DO-WALK ,P?NE>)
		      (T
		       <DO-WALK ,P?NW>)>
		<RTRUE>)>>

<OBJECT FAT-HAND
	(IN FAT-WEST)
	(DESC "fat lady's hand")
	(SYNONYM HAND)
	(ADJECTIVE HER FAT LADY\'S TINA TINAS TINA\'S)
	(FLAGS NDESCBIT TAKEBIT TRYTAKEBIT)
	(SIZE 80)
	(ACTION FAT-HAND-F)>

<ROUTINE FAT-HAND-F ()
	 <COND (<VERB? EXAMINE>
		<TELL 
"It looks like an enormously over-inflated rubber glove." CR>)
	       (<VERB? TAKE>
		<COND (,HANDOUT
		       <MOVE ,FAT-HAND ,PROTAGONIST> 
		       <FCLEAR ,FAT-HAND ,NDESCBIT>
		       <SETG HANDOUT <>>
		       <TELL 
"As you take hold, the " D ,FAT-HAND " becomes relaxed, its full weight now
residing in your arms like a sandbag and making your knees buckle." CR>)
		       (T
			<CANT-REACH ,FAT-HAND>
			<TELL 
". It's too far ... \"inland\" if you will." CR>)>)
	       (<VERB? DROP>
		<MOVE ,FAT-HAND ,HERE>
		<FSET ,FAT-HAND ,NDESCBIT>
		<SETG HANDOUT <>>
	        <TELL "The hand is craned away from you." CR>)
	       (<AND <VERB? PUT>	
		     <PRSI? ,FAT-HAND>>
		<PERFORM ,V?GIVE ,PRSO ,FAT>
		<RTRUE>)
	       (<AND <VERB? THROW GIVE PUT PUT-ON>
		     <EQUAL? ,PRSO ,FAT-HAND>>
		<TELL "It's too unwieldy." CR>)
	       (<VERB? SHAKE>
		<COND (<HELD? ,FAT-HAND>
		       <TELL 
"Though unable to budge the " D ,FAT-HAND ", your friendly intentions
are nevertheless understood. "> 
		       <WIN-FAT>
		       <RTRUE>)
		      (,HANDOUT
		       <PERFORM ,V?TAKE ,FAT-HAND>
		       <COND (<IN? ,FAT-HAND ,PROTAGONIST>
			      <CRLF>
		       	      <WIN-FAT>
		       	      <RTRUE>)>)
		      (T
		       <TELL ,NOT-HOLDING " " D ,FAT-HAND "." CR>)>)
	       (<VERB? KISS>
		<COND (<NOT <HELD? ,FAT-HAND>>
		       <PERFORM ,V?DROP ,PRSO>
		       <RTRUE>)
	       	      (T            ;<FSET? ,BLUE-BOX ,RMUNGBIT>
		       <WIN-FAT>)>)
	       (<VERB? RUB>
		<COND (<OR <HELD? ,FAT-HAND>
			   ,HANDOUT>
		       <WIN-FAT>)
		      (T
		       <PERFORM ,V?TAKE ,FAT-HAND>)>		
		<RTRUE>)>>

<ROUTINE WIN-FAT ()
	 <COND (<EQUAL? ,HERE ,FAT-EAST>
		<MOVE ,RADIO ,FAT-WEST>)
	       (T
	        <MOVE ,RADIO ,FAT-EAST>)>
         <SETG HANDOUT <>>
	 <FSET ,RADIO ,ONBIT>
         <FCLEAR ,RADIO ,NDESCBIT>
         <FSET ,FAT-HAND ,NDESCBIT>
	 <ENABLE <QUEUE I-RADIO -1>>
         <MOVE ,FAT-HAND ,HERE>		       
	 <TELL 
"The " D ,FAT " appears quite taken by your kindnesses. She clasps both her
hands up to her chins, and stares ahead in teary silence." CR>>

<OBJECT RADIO
	(IN FAT)
	(DESC "transistor radio")
	(SYNONYM RADIO)
	(ADJECTIVE TRANSISTOR SMALL)
	(FLAGS LIGHTBIT ;ONBIT 
	       TAKEBIT ;TRYTAKEBIT OPENBIT CONTBIT ;NDESCBIT ;SEARCHBIT)
	(ACTION RADIO-F)>

<GLOBAL STATION 856>

<ROUTINE RADIO-F ()
	 <COND (<DONT-HANDLE? ,RADIO>
		<RFALSE>)
	       (<AND <IN? ,RADIO ,FAT>
		     <FSET? ,RADIO ,NDESCBIT>>
		<CANT-SEE ,RADIO>)
	       (<VERB? OPEN CLOSE>
		<TELL "It's one of those non-opening models." CR>)
	       (<VERB? RECORD>
		<PERFORM ,V?RECORD>
		<RTRUE>)
	       (<AND <TOUCHING? ,RADIO>
		     <IN? ,RADIO ,FAT>>
		<FSET ,RADIO ,NDESCBIT>
		<TELL
"The " D ,FAT " casually passes the " D ,RADIO " over to her opposite
hand." CR>)	       
	       (<AND <VERB? EXAMINE>
		     <NOT <IN? ,RADIO ,FAT>>>
		<TELL "The AM dial is ">
		<COND (<FSET? ,RADIO ,ONBIT>
		       <TELL "illuminated and set to " N ,STATION "." CR>)
		      (T
		       <TELL "darkened." CR>)>)
	        (<VERB? LISTEN>
		 <COND (<IN? ,RADIO ,FAT>
			<TELL "You're not close enough." CR>)
		       (<AND <FSET? ,RADIO ,ONBIT>
			     <VISIBLE? ,RADIO>>
		        <RTRUE>)
		       (T
		        <RFALSE>)>) 
		(<VERB? SET>
		 <PERFORM ,V?SET ,DIAL ,PRSI>	
		 <RTRUE>)
		(<VERB? LAMP-ON>
		 <COND (<NOT <FSET? ,RADIO ,ONBIT>>
		 	<FSET ,RADIO ,ONBIT>
		 	<ENABLE <QUEUE I-RADIO -1>>
		 	<TELL 
"The " D ,DIAL " bursts forth in a circle of light." CR>)
		       (T
			<TELL "It is." CR>)>)
		(<VERB? LAMP-OFF>
		 <COND (<FSET? ,RADIO ,ONBIT>
		 	<DISABLE <INT I-RADIO>>
		 	<FCLEAR ,RADIO ,ONBIT>
		 	<TELL 
"The " D ,DIAL " flickers and grows dark." CR>)
		       (T
		        <TELL "It's already off." CR>)>)>>

<ROUTINE I-RADIO ()
	 <COND (<AND <VISIBLE? ,RADIO>
		     <FSET? ,RADIO ,ONBIT>
		     <NOT <ENABLED? ,I-DEMISE>>>
		<COND (<NOT <AND <VERB? LISTEN>
				 <PRSO? ,RADIO>>>
		       <CRLF>)>
		<TELL
"Drifting out from the radio is ">
		<COND (<GETP ,HERE ,P?GROUND-LOC>
		       <COND (<AND <EQUAL? ,STATION 1170>
				   <FSET? ,DIAL ,RMUNGBIT>
				   <NOT ,CALLED-STATION>>
			      <TELL 
"an appeal for cash: The announcer repeats that she will not play a
certain piece by Vivaldi until just one more caller phones in a pledge." CR>
			      <RTRUE>)
			     (<EQUAL? ,STATION 1170>
		              <TELL ,CLASSICAL>
			      <COND (<AND <EQUAL? ,ON-ROPE 3 4>
					  <EQUAL? ,APE-LOC 3>
					  <NOT <FSET? ,DIAL ,RMUNGBIT>>>
				     <FSET ,DIAL ,RMUNGBIT>
				     <TELL CR 
"There is a sudden break in the music. A female announcer comes on the
air and, after reminding her audience that this is Pledge Week for WPDL,
in a honeyed voice begins making an appeal for cash." CR>)>
			      <RTRUE>)
		             (T
			      <TELL 
"the typical noisy hubbub of AM radio.">
		       <CRLF>
		       <RTRUE>)>)
		      (T
		       <TELL "a jumble of static." CR>
		       <RTRUE>)>)>>

<OBJECT WPDL
	(IN GLOBAL-OBJECTS)
	(DESC "WPDL")
	(SYNONYM WPDL)	
	(FLAGS NDESCBIT NARTICLEBIT)
	(ACTION WPDL-F)>

<ROUTINE WPDL-F ()
	 <COND (<DONT-HANDLE? ,WPDL>
		<RFALSE>)
	       (<AND <NOT <VISIBLE? ,RADIO>>
		     <NOT <EQUAL? ,HERE ,OFFICE>>>
		<CANT-SEE <> "the radio">)
	       (<AND <VERB? LISTEN>
		     <EQUAL? ,STATION 1170>>
		<PERFORM ,V?LISTEN ,RADIO>
		<RTRUE>)
	       (<OR <AND <VERB? SET>
		         <PRSO? ,DIAL>>
		    <AND <VERB? LAMP-ON>
			 <PRSO? ,WPDL>>>
		<SETG P-NUMBER 1170>
		<PERFORM ,V?SET ,DIAL ,INTNUM>
		<RTRUE>)>>

;<ROUTINE ELEVATED? ()
 	 <COND (<OR <EQUAL? ,HERE ,PLATFORM-1 ,PLATFORM-2 ,ON-WAGON>
	            <EQUAL? ,HERE ,TIGHTROPE-ROOM ,ON-TENT ,ON-WAGON>
		    <EQUAL? ,HERE ,ON-CAGE>>
		<RTRUE>)
	       (T
		<RFALSE>)>>

 ;"Ape proves to be essentially a lowbrow with highbrow tastes in music."

<OBJECT DIAL          ;"Ape get static from radio, you get static from ape"
	(IN RADIO)   
	(DESC "radio dial")
	(SYNONYM DIAL ;LIGHT CIRCLE STATION)
	(ADJECTIVE RADIO ;STATION AM)
	(FLAGS NDESCBIT)
	(ACTION DIAL-F)>

;"RMUNGBIT = FUNDRAISING BEGINS IN I-RADIO"

<ROUTINE DIAL-F ()
	 <COND (<VERB? EXAMINE READ>	
		<PERFORM ,V?EXAMINE ,RADIO>
		<RTRUE>)
	       (<AND <VERB? SET TUNE LAMP-ON LAMP-OFF>
		     <AND <IN? ,RADIO ,FAT>>>
	        <PERFORM ,V?TAKE ,RADIO>
		<RTRUE>)
	       (<AND <VERB? SET>
		     <EQUAL? ,PRSI ,INTNUM>>
		<COND (,P-DOLLAR-FLAG
		       <V-DIG>)
		      (<NOT <FSET? ,RADIO ,ONBIT>>
		       <TELL 
"The dial is darkened and the numbers invisible." CR>)
		      (<EQUAL? ,P-NUMBER ,STATION>
		       <TELL "That's where it's tuned to now!" CR>)
		      (<OR <G? ,P-NUMBER 1600>
			   <L? ,P-NUMBER 550>>
		       <TELL "That's off the AM scale." CR>)
		      (T
		       <SETG STATION ,P-NUMBER>
		       <COND (<GETP ,HERE ,P?GROUND-LOC>
		       	      <COND (<EQUAL? ,P-NUMBER 1170>
				     <TELL "You ">		
				     <COND (<AND <FSET? ,DIAL ,RMUNGBIT>
						 <NOT ,CALLED-STATION>>	
					    <TELL "should ">)>
				     <TELL
"have found an oasis of nice, soothing music." CR>
				     <RTRUE>)
                                    ;(<PROB 50>
				     <SIGNAL>)
				    (T
				     <TELL 
"The very erratic signal is carrying, for the moment, ">
		       	             <COND (<PROB 35>
				            <TELL "the latest in post-punk.">)
				           (<PROB 32>
				            <TELL "an advertising pitch.">)
				           (T
				            <TELL "a radio call-in debate.">)>
			             <CRLF>)>)
			      (T
			       <SIGNAL T>)>)>)>>

<ROUTINE SIGNAL ("OPTIONAL" (GROUNDED? <>))
	 <TELL
"You pick up a faint signal at " N ,P-NUMBER " ... then it drifts into
static.">
	 <COND (.GROUNDED?
		<TELL
" The reception here is horrible.">)>
	 <CRLF>>

<OBJECT STAIRCASE 
	(IN LOCAL-GLOBALS)
	(DESC "spiral staircase")
	(SYNONYM STAIRS STAIRCASE STAIR STAIRW)
	(ADJECTIVE SPIRAL)
	(FLAGS NDESCBIT)
	(ACTION STAIRCASE-F)>

;"RMUNGBIT = andrew blocking it off"

<ROUTINE STAIRCASE-F ()
	 <COND (<VERB? ;CLIMB-ON CLIMB-UP CLIMB-FOO>
		<DO-WALK ,P?UP>)>>

<ROUTINE UP-STAIRS ()
 	 <COND (<IN? ,ANDREW ,HERE>
		<TELL D ,ANDREW>
		<COND (<NOT <FSET? ,STAIRCASE ,RMUNGBIT>>
		       <TELL
" goose-steps to a position in front of the " D ,STAIRCASE ", dragging
Jenny's high heel across the ground. There " D ,ANDREW>)
		      (T
		       <FSET ,STAIRCASE ,RMUNGBIT>)>
	        <TELL 
" stands blocking your way up. Stiffly, he pats his holster a couple of times
and you hear its leather crinkle." CR>
		<RFALSE>)
	       (<AND <FSET? ,CLOSET ,TOUCHBIT>
		     <EQUAL? ,HERE ,CLOSET>>
		<TELL "You come out of the closet">)
	       (T
		<TELL 
"With a bizarre twist, the " D ,STAIRCASE " leads up over the " D ,WALLS "
and then down">)>
	 <TELL ,PERIOD>
	 <CRLF>
	 <COND (<EQUAL? ,HERE ,CLOSET>
		<RETURN ,BOUDOIR>)	
	       (T
		<RETURN ,CLOSET>)>>

<ROOM BOUDOIR
      (IN ROOMS)
      (DESC "Jennifer's Boudoir")
      (FLAGS ONBIT RLANDBIT INDOORSBIT)
      (NORTH TO MID)
      (OUT TO MID)
      (UP PER UP-STAIRS)
      (GLOBAL STAIRCASE)
      (ACTION BOUDOIR-F)>

<ROUTINE BOUDOIR-F (RARG)
	 <COND (<EQUAL? .RARG ,M-LOOK>
		<TELL 
"This is a cozy little drawing room where guests are received. On the
gloomy west side of the room, a " D ,STAIRCASE " leads upward." CR>)>>

<OBJECT HERM
	(IN BOUDOIR)
	(DESC "Andrew Jenny")
	(DESCFCN HERM-DESC)
	(SYNONYM JENNY PAIR HERMAPHRODITE ATTRACTION)
        (ADJECTIVE ANDREW ANDY)
	(FLAGS ACTORBIT PERSON NARTICLEBIT)
	(GENERIC GEN-JENNY-F)
	(ACTION HERM-F)>

;"RMUNGBIT = asked guard about herm-andrew-jenny once"

<ROUTINE HERM-F ()
	 <COND (<OR <TALKING-TO? ,HERM>
		    <EQUAL? ,HERM ,WINNER>
	            <VERB? GIVE SHOW>>
		<TELL
"As two distinct personalities, the pair must be addressed individually." CR>
		<STOP>)
	       (<VERB? EXAMINE>
		<TELL 
"[You can't use the verb \"">
		<PRINTB ,P-PRSA-WORD>
		<COND (<EQUAL? ,P-PRSA-WORD ,W?EXAMINE>
		       <TELL "e">)> 
                <TELL 
"\" with multiple personalities. Each must be observed individually.]" CR>)
	       (<AND <VERB? FOLLOW>
		     <EQUAL? ,FOLLOW-FLAG 6>>
	        <DO-WALK ,P?NORTH>)>>

<ROUTINE HERM-DESC ("OPTIONAL" X)
	 <SET P-IT-OBJECT ,ANDREW>
	 <TELL 
"Andrew Jenny is the attraction of this sideshow. He appears standoffish,
she's looking bored.">>

<OBJECT ANDREW
	(IN BOUDOIR)
	(DESC "Andrew")
	(SYNONYM ANDREW ANDY MAN)
        (FLAGS NARTICLEBIT ACTORBIT PERSON CONTBIT OPENBIT SEARCHBIT NDESCBIT)
	(ACTION ANDREW-F)>

<ROUTINE ANDREW-F ()
      	 <COND (<EQUAL? ,ANDREW ,WINNER>
                <COND (<AND <VERB? TELL-ABOUT>
	                    <PRSO? ,ME>>
	               <SETG WINNER ,PROTAGONIST>
	               <PERFORM ,V?ASK-ABOUT ,ANDREW ,PRSI>
	               <SETG WINNER ,ANDREW>
	               <RTRUE>)
	              (<VERB? HELLO>
	               <SETG WINNER ,PROTAGONIST>
	               <PERFORM ,V?HELLO ,ANDREW>
	               <SETG WINNER ,ANDREW>
	               <RTRUE>)
		      (T
		       <TELL 
"Andrew displays a tight-lipped military reserve, and says nothing." CR>
                       <STOP>)>)	      
	       (<VERB? EXAMINE>
		<ENABLE <QUEUE I-TURNSTILE 2>>
	        <TELL 
D ,ANDREW "'s wearing an army boot, combat fatigues with a black leather
shoulder holster, and a pith helmet. He sneers at you, his handlebar mustache
nearly poking his eye. \"What are you staring at!\"" CR>)
	       (<SPILL-BEANS?>
		<RFATAL>)
	       (<AND <VERB? ASK-ABOUT>
		     <PRSO? ,ANDREW>>
		<COND (<PRSI? ,JENNY>
		       <TELL 
D ,ANDREW " turns sarcastic. \"My 'better' half -- ugh! Well ... can't live
with 'er, can't live without 'er.\"" CR>)>)
	      (<AND <VERB? FOLLOW>
		    <EQUAL? ,FOLLOW-FLAG 6>>
	       <DO-WALK ,P?NORTH>)>>

<OBJECT ANDREW-CLOTHES
	(IN ANDREW)
	(DESC "Andrew's outfit")
	(SYNONYM OUTFIT BOOT HOLSTER HELMET)
	(ADJECTIVE BLACK LEATHER FATIGUES SHOULDER ARMY PITH)
	(FLAGS NDESCBIT TRYTAKEBIT NARTICLEBIT)
	(ACTION ANDREW-CLOTHES-F)>

<ROUTINE ANDREW-CLOTHES-F ()
	 <COND (<VERB? TAKE RAISE RUB PUSH SEARCH REMOVE LOOK-INSIDE>
		<COND (,END-GAME
		       <V-DIG>
		       <RTRUE>)>
		<TELL
D ,ANDREW " snaps his half body into a martial arts fighting pose, which puts
you off." CR>)
	       (<VERB? EXAMINE>
		<TELL 
"The overall effect of " D ,ANDREW-CLOTHES " is unmistakable: He's dressed
to kill." CR>)>>  

<OBJECT JENNY
	(IN BOUDOIR)
	(DESC "Jenny")
	(SYNONYM JENNY JENNIF WOMAN)
	(FLAGS NARTICLEBIT ACTORBIT PERSON CONTBIT OPENBIT SEARCHBIT NDESCBIT
	       FEMALE)
	(GENERIC GEN-JENNY-F)
	(ACTION JENNY-F)>

<ROUTINE GEN-JENNY-F ()
	 ,JENNY>

;"trying to affect the accent of a southern belle, sounds like a ding-a-ling" 
<ROUTINE JENNY-F ()
      	 <COND (<EQUAL? ,JENNY ,WINNER>
                <COND (<AND <VERB? TELL-ABOUT>
	                    <PRSO? ,ME>>
	               <SETG WINNER ,PROTAGONIST>
	               <PERFORM ,V?ASK-ABOUT ,JENNY ,PRSI>
	               <SETG WINNER ,JENNY>
	               <RTRUE>)
	              (<VERB? HELLO>
	               <SETG WINNER ,PROTAGONIST>
	               <PERFORM ,V?HELLO ,JENNY>
	               <SETG WINNER ,JENNY>
	               <RTRUE>)
		      (T
		       <TELL "Jenny remains aloof." CR>
                       <STOP>)>)                 ;"end of winner"
	        (<VERB? EXAMINE>
		 <TELL 
"She has on a svelte calf-length black evening dress and a pink feather
boa draped over her shoulder." CR>)  
	        (<SPILL-BEANS?>
		 <RFATAL>)	       
	       (<AND <VERB? ASK-ABOUT>
		     <PRSO? ,JENNY>>
		<COND (<PRSI? ANDREW>
		       <TELL 
"She sighs. \"Mr. Tough Guy, huh? Deep down he's not really this mean.
Just don't get on his bad side, honey.\"" CR>)>)
	       (<AND <VERB? FOLLOW>
		    <EQUAL? ,FOLLOW-FLAG 6>>
	       <DO-WALK ,P?NORTH>)>>

<OBJECT JENNY-CLOTHES
	(IN JENNY)
	(DESC "Jenny's apparel")
	(SYNONYM BOA DRESS ARANGEMENT APPAREL)
	(ADJECTIVE PINK FEATHER JENNY EVENING BLACK FRUIT \'N\' FLOWER)
	(FLAGS NDESCBIT TRYTAKEBIT NARTICLEBIT)
	(ACTION JENNY-CLOTHES-F)>

<ROUTINE JENNY-CLOTHES-F ()
	 <COND (<VERB? TAKE RUB REMOVE LOOK-INSIDE SEARCH PICK>
		<COND (,END-GAME 
		       <V-DIG>
		       <RTRUE>)>
		<TELL
D ,JENNY " flicks her feather boa into your face, tickling your nose. \"Quit
that, honey.\"" CR>)
	       (<VERB? RAISE LOOK-UNDER>
		<NOT-PEEP>)>>

<ROUTINE NOT-PEEP ()
	 <TELL "This is a sideshow, not a peep show." CR>>
		
<ROUTINE SPILL-BEANS? ()
	<COND (<OR <AND <VERB? SHOW GIVE>
			<PRSO? ,CASE>			
			<FSET? ,CASE ,RMUNGBIT>
			,GUARD-FELT-CASE>
	       	   <AND <PRSI? ,STAND ,LION-NAME ,LION-CAGE ,GIRL 
			       ,NIMROD ,CASE>
		    	<OR <AND <VERB? ASK-ABOUT TELL-ABOUT>		   	
		             	 <PRSO? ,ANDREW ,JENNY ,HERM>
			     	 <FSET? ,CASE ,RMUNGBIT>>  ;"Andy realizes"
		            <AND <VERB? TELL-ABOUT>
				 ,GUARD-FELT-CASE>>>>	
	       <MOVE ,ANDREW ,LOCAL-GLOBALS>
	       <MOVE ,JENNY ,LOCAL-GLOBALS>
	       <MOVE ,HERM ,LOCAL-GLOBALS>
	       <SETG FOLLOW-FLAG 6> 
	       <ENABLE <QUEUE I-FOLLOW 2>>
	       <SETG SCORE <+ ,SCORE 10>>
	       <TELL
"Jenny looks very pensive for a few moments. As the memory of events in
which she unknowingly took part slowly dawns upon the hemisphere of her
mind, a tear starts to well up in her eye, loads up with mascara, and
spills down her cheek. ">
	       <COND (<HELD? ,CASE>
		      <MOVE ,CASE ,ANDREW>
		      <FSET ,CASE ,INVISIBLE>
		      <TELL
"Andrew impulsively snatches the " D ,CASE " from you. " CR CR>)>
	       <TELL 
"\"Aha!\" squeals Jenny, as she seems to recollect more details of Andrew's
dirty dealings. \"And you're supposed to meet later on with your fellow
thugs at Katz's trailer, the big brute. Well you can just forget about it,
Andrew!\"|
|
There ensues a hurly-burly struggle between the opposing personalities trapped
within the one body. Jenny chases Andrew out of the sideshow amid shrieks
of rage which echo down the midway." CR>
	       <RTRUE>)
	      (T
	       <RFALSE>)>>

<GLOBAL GUARD-FELT-CASE <>>

<OBJECT CASE
	(IN LOCAL-GLOBALS)
	(DESC "cigarette case")
	(SYNONYM CASE)
	(ADJECTIVE CIGARETTE ;COMPACT)
	(FLAGS TAKEBIT CONTBIT)
	(CAPACITY 1)
	(ACTION CASE-F)>

;"rmungbit = have show case to herm after I know its significance"

<ROUTINE CASE-F ()
	 <COND (<VERB? EXAMINE>
		<TELL
"It is gilded with gold leaf and shows intricate design work on
its face." CR>)
	       (<AND ,GUARD-FELT-CASE
		     <IN? ,ANDREW ,HERE>
		     <NOT <FSET? ,CASE ,RMUNGBIT>>
		     <OR <AND <VERB? SHOW GIVE>
		              <EQUAL? ,PRSI ,ANDREW ,JENNY ,HERM>>
		         <AND <VERB? TELL-ABOUT ASK-ABOUT>
			      <EQUAL? ,PRSI ,CASE>
			      <EQUAL? ,PRSO ,ANDREW ,JENNY ,HERM>>>>
		<FSET ,CASE ,RMUNGBIT>
		<TELL
"As " D ,ANDREW " realizes you know him to be the owner of the " D ,CASE
", his eye gets wide, and then, behind his distinguished exterior, he
begins to turn shades of purple." CR>)>>

;<OBJECT FLUFF
	(IN LOCAL-GLOBALS)
	(DESC "lavender fluff")
	(SYNONYM FLUFF WHISP)
	(ADJECTIVE LAVENDER SCANT)
	(FLAGS TAKEBIT)
	(ACTION FLUFF-F)>

;"FLUFF RMUNGBIT = fluff has been seen and lost by Andrew-Jenny"

;<ROUTINE FLUFF-F ()
	 <COND (<AND <VERB? SHOW GIVE>
		     <EQUAL? ,PRSI ,ANDREW ,JENNY>>
	        <FSET ,FLUFF ,RMUNGBIT>
		<MOVE ,FLUFF ,LOCAL-GLOBALS>
		<TELL
"As Andrew hears where you came across the " D ,FLUFF ", his eye gets
wide, and he takes a swipe at the fluff, which drifts away through the
air." CR>)>>

<ROOM MIDEAST
      (IN ROOMS)
      (DESC "Far End of Midway")
      (FLAGS ONBIT RLANDBIT)
      (WEST TO MID)
      (NORTH TO FAT-WEST)
      (IN TO FAT-WEST)
      (GLOBAL FRONT MIDWAY)
      (ACTION MIDEAST-F)>

<ROUTINE MIDEAST-F (RARG)
	 <COND (<EQUAL? .RARG ,M-LOOK>
		<TELL 
"You've reached the far end of the midway. A sideshow front to the north
advertises the \"827 Pounds of Feminine Charm\" that is Tina." CR>)>>

<GLOBAL DRUNK-COUNTER 0>

<ROUTINE I-DRUNK ()
	 <SETG DRUNK-COUNTER <+ ,DRUNK-COUNTER 1>>
	 <FCLEAR ,VOICES ,INVISIBLE>
	 <COND (<AND <EQUAL? ,DRUNK-COUNTER 3>
		     <EQUAL? ,HERE ,MIDWEST>>
		<TELL CR 
"The " D ,DICK " examines the label of the flask that he's holding
then takes a slug." CR>)
	       (<AND <EQUAL? ,DRUNK-COUNTER 5>
		     <EQUAL? ,HERE ,MIDWEST>>		
		<ENABLE <QUEUE I-FOLLOW 2>>
		<SETG FOLLOW-FLAG 11>
		<TELL CR 
"The pitchman gives the " D ,DICK " a final slap on the back and leads him
through the " D ,TURNSTILE "." CR>)>
	 <COND (<OR <NOT <EQUAL? ,HERE ,MIDWEST>>
		    <EQUAL? ,FOLLOW-FLAG 11>>
		<MOVE ,CON ,LOCAL-GLOBALS>		
		<MOVE ,DICK ,LOCAL-GLOBALS>
		<MOVE ,KIESTER ,LOCAL-GLOBALS>
		<FSET ,VOICES ,INVISIBLE>
		<DISABLE <INT I-DRUNK>>)>>

<OBJECT CON
	(IN MIDWEST)
	(DESC "Billy Monday")
	(DESCFCN CON-DESC)
	(SYNONYM BILLY BILL PITCHMAN MONDAY)
	(ADJECTIVE MAN BILLY ;PITCHMAN)
	(FLAGS ACTORBIT PERSON NARTICLEBIT SEARCHBIT CONTBIT OPENBIT)
	(ACTION CON-F)>

;" CON RMUNGBIT = Con has forced drink on detective"

<ROUTINE CON-F ()
	 <COND (<EQUAL? ,CON ,WINNER>
                <COND (<AND <VERB? TELL-ABOUT>
	                    <PRSO? ,ME>>
	               <SETG WINNER ,PROTAGONIST>
	               <PERFORM ,V?ASK-ABOUT ,CON ,PRSI>
	               <SETG WINNER ,CON>
	               <RTRUE>)
	              (<VERB? HELLO>
	               <SETG WINNER ,PROTAGONIST>
	               <PERFORM ,V?HELLO ,CON>
	               <SETG WINNER ,CON>
	               <RTRUE>)
		      (<AND <VERB? YES>
			    <EQUAL? ,AWAITING-REPLY 8>>
		       <V-YES>)
		      (<AND <VERB? NO>
			    <EQUAL? ,AWAITING-REPLY 8>>
		       <V-NO>)
		      (T
		       <TELL "He just grins, revealing a gold tooth." CR>)>)
	       (<AND <VERB? LISTEN>
		     <EQUAL? ,HERE ,MIDWEST>>
	        <PERFORM ,V?LISTEN ,VOICES>
	        <RTRUE>)
	       (<VERB? EXAMINE>
		<COND (<EQUAL? ,HERE ,MIDWEST>
		       <TELL 
"He's all smiles and solicitude toward the " D ,DICK "." CR>)>)
	       (<AND <VERB? ASK-ABOUT>
		     <PRSO? ,CON>>
		<COND (<PRSI? ,FLASK>
	               <TELL "He takes a deep breath. \"Well, ">
		       <MAN-OR-WOMAN "brother" "sister">
		       <TELL 
", step right up -- I don't care what's your sickness, I don't care what's
draggin' you down, don't tell me 'cause I don't want to know whether
it's pyorrhea, anorexia nervosa, sick headache, goiter, varicose veins, bilious
derangements, nervous debility ...\" The pitchman realizes he's getting nowhere
with you and turns his attention back to the detective." CR>)    
		      (T
		       <TELL "\"I don't know much about that,\" he ">
		       <COND (<PRSI? ,GIRL>   ;"etc. sensitive shit"
			      <TELL-GRIN>)
			     (T
			      <TELL "says.">)>
		       <SETG AWAITING-REPLY 8>
		       <ENABLE <QUEUE I-REPLY 2>>
		       <TELL
" \"But have you asked me about " D ,FLASK "?\"" CR>)>)
		(<VERB? FOLLOW>
		 <COND (<EQUAL? ,FOLLOW-FLAG 7 11>
	                <DO-WALK ,P?WEST>)
		       (<EQUAL? ,FOLLOW-FLAG 15>
		        <DO-WALK ,P?UP>)>)>>
	
<ROUTINE CON-DESC ("OPTIONAL" X)
	 <COND (<EQUAL? ,HERE ,MIDWEST>
		<TELL
"Next to the " D ,BIGTOP ", the " D ,DICK " is talking to a pitchman who's
carrying an open trunk that's strapped to his upper body.">)
	       (T
		<TELL D ,CON " is here.">)>>

<ROUTINE TELL-GRIN ()
	<TELL "grins, revealing a gold tooth.">>

<OBJECT SMOKE
	(IN BLUE-ROOM)
	(DESC "cloud of smoke")
	(SYNONYM SMOKE CLOUD)
	(ADJECTIVE CIGARETTE)
	(FLAGS NDESCBIT)
	(ACTION SMOKE-F)>

<ROUTINE SMOKE-F ()
	 <COND (<VERB? THROUGH WALK-TO>
		<PERFORM ,V?WALK-TO ,POKER>
		<RTRUE>)>>

<ROOM BLUE-ROOM
      (IN ROOMS)
      (DESC "Blue Room")
      (FLAGS ONBIT RLANDBIT INDOORSBIT)
      (WEST TO NOOK IF BLUE-DOOR IS OPEN)
      (OUT TO NOOK IF BLUE-DOOR IS OPEN)
      (GLOBAL BLUE-DOOR POKER)
      ;(PSEUDO "SMOKE")
      (ACTION BLUE-ROOM-F)>

<ROUTINE BLUE-ROOM-F (RARG)
	 <COND (<EQUAL? .RARG ,M-ENTER>
		<SETG BLUE-ROOM-ENTER-NUMBER <+ ,BLUE-ROOM-ENTER-NUMBER 1>>
		<COND (<FSET? ,DEALER ,RMUNGBIT> ;"new dealer"
		       <MOVE ,TICKET ,DEALER>
		       <ENABLE <QUEUE I-CHASE -1>>)>
		<ENABLE <QUEUE I-BLUE-DOOR 1>>
		<TELL 
"As you enter, a blue haze of smoke stings your eyeballs." CR CR>)
	       (<EQUAL? .RARG ,M-LOOK>
		<TELL
"In the far " D ,CORNER " of this tented enclosure a thick, undulating cloud
of smoke hovers over a " D ,POKER ". Straight across from you a tight-jawed
dealer stands over a " D ,TABLE " covered with a green floor-length
tablecloth." CR>)
	       (<EQUAL? .RARG ,M-BEG>
	        <COND (<AND <NOT <EQUAL? ,BLUE-ROOM-ENTER-NUMBER 1>>
			    <NOT <FSET? ,DEALER ,RMUNGBIT>>>
		       <SETG BOUNCE-C <+ ,BOUNCE-C 1>>
	               <COND (<AND <EQUAL? ,BOUNCE-C 1>
				   ,HELPED-THUMB>
		       	      <FSET ,THUMB ,NDESCBIT>
		       	      <MOVE ,THUMB ,HERE>)
		      	     (<AND <G? ,BOUNCE-C 20>
				   <EQUAL? ,BLUE-ROOM-ENTER-NUMBER 2>>
		       	      <ENABLE <QUEUE KICKED-OUT-FIRST-TIME 1>>)>)
		      (<AND <G? ,CHASE-C 2>
			    <OR <TALKING-TO? ,DEALER>
			        <TALKING-TO? ,CON>
			        <AND <VERB? GIVE SHOW>
				     <PRSI? ,DEALER ,CON>>>>
		       <TELL "You get no response from him." CR>
		       <SETG P-CONT <>>
		       <RTRUE>)>
		<COND (<VERB? BET>
		       <COND (<FSET? ,DEALER ,RMUNGBIT>
			      <COND (<IN? ,DEALER ,HERE>
				     <TELL "He refuses to deal with you." CR>
				     <SETG P-IT-OBJECT ,DEALER>)
				    (T
				     <TELL "All bets are off." CR>)>
			      <RTRUE>)
			     (<PRSO? ,DOLLAR> ;"to dollar-f"
			      <RFALSE>)
			     (<OR <PRSO? ,GLOBAL-MONEY>
				  <OR <ZERO? ,P-AMOUNT>
				      <NOT ,P-AMOUNT>>>
			      <SPECIFY-MONEY T>
			      <RFATAL>)
			     (<AND <PRSO? ,INTNUM>
			           <NOT ,P-DOLLAR-FLAG>>;"set to <> in parser"
		              <SPECIFY-MONEY T>
			      <RFATAL>)			     
			     (<NOT <EQUAL? ,PRSO ,INTNUM ,DOLLAR>>
			      <TELL "You can only bet money." CR>)
		      	     (<L? ,POCKET-CHANGE ,P-AMOUNT>
		       	      <TELL "You can't bet more than you have." CR>
		       	      <STOP>)
		      	     (<AND <G? ,POCKET-CHANGE 30326>
				   <EQUAL? ,BLUE-ROOM-ENTER-NUMBER 2>>
			      <TELL 
"The " D ,DEALER " examines your winnings.">
			      <EIGHTY-SIX>)
			     (<G? 25 ,P-AMOUNT>
				   ;<NOT <EQUAL? ,PRSO ,DOLLAR>>
		       	      <TELL "\"The minimum bet is 25 cents.\"" CR>
			      <STOP>)
		      	     (<L? 200 ,P-AMOUNT>
			      <TELL 
"\"No bets over 2 dollars. House rules.\"" CR>)
			     (T
		       	      <COND (<NOT ,BET-ONCE>
			             <TELL
"The " D ,DEALER " shuffles the four decks and breathes a sigh." CR>)>
			      <SETG BET-ONCE T>
			      <COND (<OR <EQUAL? ,BLUE-ROOM-ENTER-NUMBER 2>
					 <AND ,HELPED-THUMB
					      <OR <G? ,POCKET-CHANGE 23000>
				                  <L? ,POCKET-CHANGE 401>>>>
	  			     <SETG BLUE-ROOM-ENTER-NUMBER 2>
				     <SETG FORCED-BET T>
				     <FSET ,THUMB ,NDESCBIT>
		       	             <MOVE ,THUMB ,HERE>)>
			      ;<COND (<EQUAL? ,PRSO ,DOLLAR>
				     <COND (<IS-ADJ? ,W?TWO>
					    <SETG P-AMOUNT 200>)
					   (T
					    <SETG P-AMOUNT 100>)>
				     <SETG P-DOLLAR-FLAG T>)>
			      <SETG POCKET-CHANGE <+ ,POCKET-CHANGE
					     <PLAY-HAND ,P-AMOUNT>>>)>
		<RTRUE>)>)>>

<GLOBAL BET-ONCE <>>

<GLOBAL BLUE-ROOM-ENTER-NUMBER 0>

<GLOBAL BOUNCE-C 0>  ;"added to in blue-room m-beg, on 1 tapped by 
		      Thumb, on 20 thrown out of blue-room and set to 25."
		     ;"can get by door if dealer-rmungbit (new dealer) set at
		      I-Thumb as tells of danger."   		
		     		       
<GLOBAL THUMB-TAPPED <>>

<ROUTINE KICKED-OUT-FIRST-TIME ()
	 <COND (<EQUAL? ,HERE ,BLUE-ROOM>
		<TELL CR
D ,CON " suddenly emerges from the cloud of smoke in the "
D ,CORNER " and whispers something to the " D ,DEALER ". ">
	 	<EIGHTY-SIX>)>>
		
<ROUTINE EIGHTY-SIX ()
	 ;<MOVE ,THUMB ,LOCAL-GLOBALS>
	 <SETG BOUNCE-C 25>
	 <DISABLE <INT I-CHASE>> ;"dont follow Billy"
	 <FCLEAR ,BLUE-DOOR ,OPENBIT>
	 <DISABLE <INT I-BLUE-DOOR>>
	 <TELL 
"The " D ,DEALER " summarily eighty-sixes you from the room." CR CR>
	 <GOTO ,NOOK>>

<GLOBAL CHASE-C 0>
	       
<GLOBAL DEALER-JOKE <>>

<ROUTINE JOKE-TIME? (GLOB)
	 <COND (<AND <NOT .GLOB>
		     <OR <FSET? ,SHAWL ,WORNBIT>
			 <FSET? ,DRESS ,WORNBIT>>>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE I-CHASE ()
	 <COND (<AND <L? ,CHASE-C 4> ;"not added to till below"
		     <NOT <EQUAL? ,HERE ,BLUE-ROOM>>>
		<DISABLE <INT I-CHASE>>
		<RFALSE>)>
	 <SETG CHASE-C <+ ,CHASE-C 1>>
	 <COND (<EQUAL? ,CHASE-C 1>
		<TELL 
"You notice a different dealer standing behind the " D ,TABLE ". He is
scrutinizing " D ,TICKET ".">
	        <COND (<JOKE-TIME? ,DEALER-JOKE>
		       <SETG DEALER-JOKE T>
		       <TELL 
" He glances at you and gives off a look that says, \"I've just about
seen it all now.\"">)>
		<CRLF>)	       
	       (<EQUAL? ,CHASE-C 2>
	        <MOVE ,BLACKJACK ,LOCAL-GLOBALS>
		<MOVE ,DEALER ,LOCAL-GLOBALS>
	        <TELL CR 
"The " D ,DEALER " gathers up the cards and disappears into the " D ,SMOKE 
"." CR>)
	       (<EQUAL? ,CHASE-C 3>
		<MOVE ,CON ,HERE>
		<MOVE ,DEALER ,HERE>
		<TELL CR 
"You see the dealer approaching with " D ,CON "." CR>)
	       (<EQUAL? ,CHASE-C 4>
	        <MOVE ,CON ,LOCAL-GLOBALS>
	        <SETG FOLLOW-FLAG 7>
		<ENABLE <QUEUE I-FOLLOW 2>>
		;<FSET ,BLUE-DOOR ,OPENBIT>
		<ENABLE <QUEUE I-BLUE-DOOR 2>>
	        <TELL CR 
"The pair of thugs hurry up to confront you. ">
		<COND (<IN? ,KIESTER ,LOCAL-GLOBALS>
		       <EIGHTY-SIX>
		       <RFALSE>)
		      (<HELD? ,KIESTER>
		       <MOVE ,KIESTER ,LOCAL-GLOBALS>
		       <TELL 
"Scuffling with you over the " D ,KIESTER ", they manage to wrestle it
away. " D ,CON " shouts \"Hey Rube!\" then">)
		      (T
		       <TELL D ,CON " grabs the " D ,KIESTER ",">
		       <MOVE ,KIESTER ,LOCAL-GLOBALS>)>
		<COND (<FSET? ,BLUE-DOOR ,OPENBIT>
		       <TELL " sights the open">)
		      (T
		       <TELL " throws open the">
		       <FSET ,BLUE-DOOR ,OPENBIT>
		       <ENABLE <QUEUE I-BLUE-DOOR 2>>)> 
		<TELL
" panel and bolts through the opening as the dealer ">
		<COND (<FSET? ,PINK-BOX ,RMUNGBIT>
		       <TELL "shoves you away">)
		      (T
		       <TELL
"doubles you over with a punch to your midsection">)>
		<TELL ,PERIOD>
		<RTRUE>)
	       (<AND <L? ,CHASE-C 8>
		     <EQUAL? ,HERE ,NOOK>>
		<SETG CHASE-C 7>
		<SETG FOLLOW-FLAG 15>
		<ENABLE <QUEUE I-FOLLOW 2>>
	        <TELL CR
"You see the silhouette of a man on top of the cage. He throws something bulky
onto the tent, then climbs up after it." CR>
		<RTRUE>)
	       (<G? ,CHASE-C 12>
		<DISABLE <INT I-CHASE>>)>>
		     
<OBJECT DEALER
	(IN BLUE-ROOM)
	(DESC "dealer")
	(SYNONYM DEALER MAN)
	(ADJECTIVE BLACKJACK TIGHT DIFFERENT NEW)
	(FLAGS ACTORBIT PERSON NDESCBIT CONTBIT OPENBIT SEARCHBIT)
	(ACTION DEALER-F)>

;"DEALER RMUNGBIT = Change of dealers taken place as Thumb tell you about it"

<ROUTINE DEALER-F ()
	 <COND (<OR <TALKING-TO? ,DEALER>
		    <AND <VERB? SHOW GIVE>
			 <PRSI? ,DEALER>>>
	        <COND (<FSET? ,DEALER ,RMUNGBIT>
		       <TELL
"This dealer is even less friendly than the first. He plain ignores you." CR>)
		      (T
		       <TELL
"Poker-faced and eagle-eyed, he doesn't ">
		       <COND (<VERB? HELLO>
		       	      <TELL "acknowledge">)
		      	     (T
		       	      <TELL "respond">)>
	               <TELL ", but merely gestures for you to bet." CR>)>
		<STOP>)
	       (<VERB? BET>
		<SPECIFY-MONEY T>)
	       (<HURT? ,DEALER>
		<TELL "He's bigger than you." CR>)
	       (<AND <VERB? FOLLOW WALK-TO>
		     <NOT <IN? ,DEALER ,HERE>>
		     <EQUAL? ,HERE ,BLUE-ROOM>>
		<PERFORM ,V?WALK-TO ,POKER>
		<RTRUE>)>> 

<ROUTINE WALK-INTO-CON ()
	 <TELL 
"As you approach, " D ,CON>
	 <COND (<NOT <IN? ,CON ,HERE>>
		<TELL " appears and">)>
	 <TELL " intercepts you">
	 <COND (<HELD? ,KIESTER>
	      	<MOVE ,KIESTER ,LOCAL-GLOBALS>
		<TELL ", snatching away the " D ,KIESTER>)>
	 <TELL ". ">>

<OBJECT TABLE 
	(IN BLUE-ROOM)
	(DESC "blackjack table")
	(SYNONYM TABLECLOTH CLOTH TABLE)
        (ADJECTIVE BLACKJACK GREEN)	
	(FLAGS NDESCBIT)
	(ACTION TABLE-F)>

;"TABLE RMUNGBIT = have examined THUMB once" 

<ROUTINE TABLE-F ()
	 <COND (<AND <VERB? LOOK-UNDER MOVE RAISE>
		     <IN? ,THUMB ,HERE>>
		<PERFORM ,V?EXAMINE ,THUMB>
		<RTRUE>)
	       (<VERB? LOOK-UNDER MOVE RAISE>
		<COND (<AND <FSET? ,DEALER ,RMUNGBIT>
		            <FSET? ,KIESTER ,TRYTAKEBIT>>
		       <MOVE ,KIESTER ,HERE>
	               <FCLEAR ,KIESTER ,OPENBIT>
		       <FSET ,KIESTER ,LOCKEDBIT>
		       <TELL 
,YOU-SEE " what appears to be a suitcase under the " D ,TABLE "." CR>)
		      (T
		       <V-LOOK-UNDER>
		       <RTRUE>)>)
	       (<AND <VERB? PUT-ON>
		     <PRSI? ,TABLE>>
		<COND (<OR <AND <PRSO? ,INTNUM>
			        ,P-DOLLAR-FLAG>
		           <PRSO? ,GLOBAL-MONEY>>
		       <PERFORM ,V?BET ,PRSO>
		       <RTRUE>)
		      (T
		       <COND (<IN? ,DEALER ,HERE>
			      <PERFORM ,V?TAKE ,BLACKJACK>
		       	      <RTRUE>)
			     (T
			      <V-DIG>)>)>)>>

<OBJECT BLACKJACK
	(IN BLUE-ROOM)
	(DESC "deck of cards")
	(SYNONYM BLACKJACK GAME DECK CARDS) ;"GAME MUST REMAIN SYN. - parser"
	(ADJECTIVE BLACKJACK CARD DECKS GRIFT)
	(FLAGS NDESCBIT TRYTAKEBIT)
	(GENERIC GEN-BLACKJACK-F)
	(ACTION BLACKJACK-F)>

<ROUTINE GEN-BLACKJACK-F ()
	 ,BLACKJACK>

<ROUTINE BLACKJACK-F ()
	 <COND (<VERB? PLAY>
		<PERFORM ,V?PUT-ON ,GLOBAL-MONEY ,TABLE>
		<RTRUE>)
	       (<VERB? EXAMINE COUNT>	
		<TELL "Four decks are being used. They look clean." CR>)
	       (<VERB? TAKE>
		<TELL "The dealer stays " D ,HANDS "." CR>)>> 

<OBJECT POKER
	(IN LOCAL-GLOBALS) ;"so blackjack will be found if TABLE referred to"
	(DESC "poker game")
	(SYNONYM POKER GAME TABLE)
	(ADJECTIVE POKER)
	(FLAGS NDESCBIT)
	(GENERIC GEN-BLACKJACK-F)
	(ACTION POKER-F)>

<ROUTINE POKER-F ()
	 <COND (<AND <VERB? WALK-TO PLAY THROUGH>
		     <EQUAL? ,HERE ,BLUE-ROOM>>
		<COND (<IN? ,DEALER ,HERE>
		       <TELL 
"The " D ,DEALER " bars your way, indicating the " D ,POKER "'s private.
Considering the lack of oxygen at the table and the probability of marked
cards, you wouldn't have survived long in the " D ,POKER " anyway." CR>)
		      (T
		       <WALK-INTO-CON>
		       <EIGHTY-SIX>)>)>>

<OBJECT KIESTER 
	(IN CON)
	(DESC "keister")
	(SYNONYM KEISTER TRUNK CASE SUITCASE)
        (ADJECTIVE SUIT)
	(CAPACITY 60)
        (SIZE 70)
	(FLAGS CONTBIT OPENBIT SEARCHBIT TAKEBIT TRYTAKEBIT NDESCBIT)
	(ACTION KIESTER-F)>

<ROUTINE KIESTER-F ()
	 <COND (<VERB? TAKE OPEN CLOSE PUT>
		<COND (<IN? ,KIESTER ,CON>
		       <TELL
"The " D ,JUNK " klinks together as Billy nonchalantly pushes you
away." CR>)
	       	      (<AND <NOT <FSET? ,KIESTER ,TOUCHBIT>>
			    <VERB? TAKE>>		       
		       <FCLEAR ,KIESTER ,TRYTAKEBIT>
		       <FSET ,KIESTER ,TOUCHBIT>
		       <MOVE ,KIESTER ,PROTAGONIST>
		       <TELL 
"As you lift it, you can hear a muffled scream from inside." CR>)
		      (T
		       <RFALSE>)>)>>

<OBJECT JUNK 
	(IN KIESTER)
	(DESC "jumble of trinkets")
	(SYNONYM JUMBLE TRINKET)
	(FLAGS TRYTAKEBIT)
	(GENERIC GEN-FOOD)
        (ACTION JUNK-F)>

<ROUTINE JUNK-F ()
	 <COND (<AND <EQUAL? ,HERE ,MIDWEST>
		     <VERB? BUY TAKE>>
		<PERFORM ,PRSA ,FLASK>
		<RTRUE>)>>
			   
<OBJECT FLASK 
	(IN LOCAL-GLOBALS)
	(DESC 
"Dr. Nostrum's Prehydrogenated Genuine Preparation of Naturally Nitrated
Compound Herbified Extract")
	(SYNONYM EXTRACT NOSTRUM FLASK ;BOTTLE LABEL)
	(ADJECTIVE DR PREPARATION PREHYDRO GENUINE NATURALLY NITRATED COMPOUND
		   HERBIFIED)
	(FLAGS TRYTAKEBIT NDESCBIT NARTICLEBIT)
        (ACTION FLASK-F)>

<ROUTINE FLASK-F ()
	 <COND (<VERB? OPEN CLOSE>
		<TELL "There's no cap." CR>)
	       (<VERB? LOOK-INSIDE EXAMINE>
		<TELL "It looks like pretty potent stuff." CR>)	       
	       (<AND <IN? ,DICK ,MIDWEST>
		     <NOT ,DICK-DRUNK>>
		<COND (<VERB? DRINK-FROM DRINK TAKE READ MOVE>
		       <TELL
"You're interfering with the hospitality that " D ,CON " is paying the "
D ,DICK ". Billy shoves you away, and his " D ,JUNK " clinks together
in his " D ,KIESTER "." CR>)
		      (<VERB? BUY>
		       <TELL 
"\"I'm sorry, we're fresh out,\" the pitchman ">
		       <TELL-GRIN>
		       <CRLF>)>)	       
	       (<VERB? READ>
		<TELL 
"It's the usual ballyhoo for " D ,FLASK "." CR>)
	       (<VERB? DRINK-FROM DRINK TAKE READ MOVE>
		<COND (<IN? ,FLASK ,JOEY>
		       <TAKE-FLASK-RAG>
		       <RTRUE>)
	       	      (<IN? ,FLASK ,DICK>
		       <TELL 
"The " D ,DICK ", being dead drunk, has a rigor mortis grip on it." CR>)>)>>

<OBJECT RAG 
	(IN LOCAL-GLOBALS)
	(DESC "dirty rag")
	(SYNONYM RAG)
	(ADJECTIVE DIRTY)	
	(FLAGS TRYTAKEBIT)
        (ACTION RAG-F)>

;"RMUNGBIT = tried to take it or flask first time"

<ROUTINE RAG-F ()
	 <COND (<VERB? TAKE>
		<TAKE-FLASK-RAG>
		<RTRUE>)>>

<ROUTINE TAKE-FLASK-RAG ()
	 <TELL 
"Chuckles pulls back">
	 <ARTICLE ,PRSO T>
	 <TELL ". ">
	 <COND (<NOT <FSET? ,RAG ,RMUNGBIT>>
	        <FSET ,RAG ,RMUNGBIT>
		<TELL 
"\"Why do all the towners think they can get away with harassing
us poor innocent clowns?\"">)>
	 <CRLF>>