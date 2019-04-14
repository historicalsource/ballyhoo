"PARSER for
		               BALLYHOO
	 (c) Copyright 1986 Infocom, Inc.  All Rights Reserved"

;"Parser global variable convention:  All parser globals will begin
with 'P-'. Local variables are not restricted in any way." 

<SETG SIBREAKS ".,\"">

<GLOBAL P-AND <>>

<GLOBAL IN-FRONT-FLAG <>> 

<GLOBAL PRSA <>>

<GLOBAL PRSI <>>

<GLOBAL PRSO <>>

<GLOBAL P-TABLE 0>  

<GLOBAL P-ONEOBJ 0> 

<GLOBAL P-SYNTAX 0> 

<GLOBAL P-CCTBL <TABLE 0 0 0 0>>  

;"pointers used by CLAUSE-COPY (source/destination beginning/end pointers)"
<CONSTANT CC-SBPTR 0>
<CONSTANT CC-SEPTR 1>
<CONSTANT CC-DBPTR 2>
<CONSTANT CC-DEPTR 3>

<GLOBAL P-LEN 0>

<GLOBAL WINNER 0>   

<GLOBAL P-LEXV <ITABLE BYTE 120>>
<GLOBAL AGAIN-LEXV <ITABLE BYTE 120>>
<GLOBAL RESERVE-LEXV <ITABLE BYTE 120>>
<GLOBAL RESERVE-PTR <>>

<GLOBAL P-INBUF <ITABLE BYTE 60>> ;"INBUF - Input buffer for READ"
<GLOBAL RESERVE-INBUF <ITABLE BYTE 60>> ; "FIX #36"

<GLOBAL OOPS-INBUF <ITABLE BYTE 60>>
<GLOBAL OOPS-TABLE <TABLE <> <> <> <>>>
<CONSTANT O-PTR 0>
<CONSTANT O-START 1>
<CONSTANT O-LENGTH 2>
<CONSTANT O-END 3>

<GLOBAL P-CONT <>> ;"Parse-cont variable"  

<GLOBAL P-IT-OBJECT <>>

<GLOBAL LAST-PSEUDO-LOC <>>

<GLOBAL P-OFLAG <>> ;"Orphan flag" 

<GLOBAL P-MERGED <>>

<GLOBAL P-ACLAUSE <>>    

<GLOBAL P-ANAM <>>  

<GLOBAL P-AADJ <>>

;"Parser variables and temporaries"

<CONSTANT P-LEXWORDS 1> ;"Byte offset to # of entries in LEXV"
<CONSTANT P-LEXSTART 1> ;"Word offset to start of LEXV entries"
<CONSTANT P-LEXELEN 2> ;"Number of words per LEXV entry"
<CONSTANT P-WORDLEN 4>
<CONSTANT P-PSOFF 4> ;"Offset to parts of speech byte"
<CONSTANT P-P1OFF 5> ;"Offset to first part of speech"
<CONSTANT P-P1BITS 3> ;"First part of speech bit mask in PSOFF byte"
<CONSTANT P-ITBLLEN 9>

<GLOBAL P-ITBL
	<TABLE 0 0 0 0 0 0 0 0 0 0>>  

<GLOBAL P-OTBL
	<TABLE 0 0 0 0 0 0 0 0 0 0>>  

<GLOBAL P-VTBL
	<TABLE 0 0 0 0>>

<GLOBAL P-OVTBL
	<TABLE 0 0 0 0>>

<GLOBAL P-NCN 0>    

<CONSTANT P-VERB 0> 

<CONSTANT P-VERBN 1>

<CONSTANT P-PREP1 2>

<CONSTANT P-PREP1N 3>    

<CONSTANT P-PREP2 4>    

<CONSTANT P-NC1 6>  

<CONSTANT P-NC1L 7> 

<CONSTANT P-NC2 8>  

<CONSTANT P-NC2L 9> 

<GLOBAL QUOTE-FLAG <>>

;<GLOBAL P-INPUT-WORDS <>>

<GLOBAL P-END-ON-PREP <>>

<GLOBAL P-PRSA-WORD <>>

" Grovel down the input finding the verb, prepositions, and noun clauses.
   If the input is <direction> or <walk> <direction>, fall out immediately
   setting PRSA to ,V?WALK and PRSO to <direction>.  Otherwise, perform
   all required orphaning, syntax checking, and noun clause lookup."   

<ROUTINE PARSER ("AUX" (PTR ,P-LEXSTART) WRD (VAL 0) (VERB <>) ;(DONT <>)
		      OMERGED OWINNER OLEN LEN (DIR <>) (NW 0) (LW 0) (CNT -1))
	<REPEAT ()
		<COND (<G? <SET CNT <+ .CNT 1>> ,P-ITBLLEN> <RETURN>)
		      (T
		       <COND (<NOT ,P-OFLAG>
			      <PUT ,P-OTBL .CNT <GET ,P-ITBL .CNT>>)>
		       <PUT ,P-ITBL .CNT 0>)>>
	<SETG IN-FRONT-FLAG <>>
	<SETG P-DOLLAR-FLAG <>>
	;<SETG STOP-HACK <>>
	<SET OMERGED ,P-MERGED>
	<SET OWINNER ,WINNER>
	<PUT ,P-NAMW 0 <>>
	<PUT ,P-NAMW 1 <>>
	<PUT ,P-ADJW 0 <>>
	<PUT ,P-ADJW 1 <>>
	<SETG P-ADVERB <>>
	<SETG P-MERGED <>>
	<SETG P-END-ON-PREP <>>
	<PUT ,P-PRSO ,P-MATCHLEN 0>
	<PUT ,P-PRSI ,P-MATCHLEN 0>
	<PUT ,P-BUTS ,P-MATCHLEN 0>
	<COND (<AND <NOT ,QUOTE-FLAG> <N==? ,WINNER ,PLAYER>>
	       <SETG WINNER ,PLAYER>
	       <COND (<NOT <FSET? <LOC ,WINNER> ,VEHBIT>>
		      <SETG HERE <LOC ,WINNER>>)>
	       <SETG LIT <LIT? ,HERE>>)>
	<COND (,RESERVE-PTR
	       <SET PTR ,RESERVE-PTR>
	       <STUFF ,P-LEXV ,RESERVE-LEXV>
	       <INBUF-STUFF ,P-INBUF ,RESERVE-INBUF> ;"rfix no. 36"
	       <COND (<AND <EQUAL? ,VERBOSITY 1 2>
			   <==? ,PLAYER ,WINNER>>
		      <CRLF>)>
	       <SETG RESERVE-PTR <>>
	       <SETG P-CONT <>>)
	      (,P-CONT
	       <SET PTR ,P-CONT>
	       <COND (<AND <EQUAL? ,VERBOSITY 1 2>
			   <==? ,PLAYER ,WINNER>>
		      <CRLF>)>
	       <SETG P-CONT <>>)
	      (T
	       <SETG WINNER ,PLAYER>
	       <SETG QUOTE-FLAG <>>
	       <COND (<NOT <FSET? <LOC ,WINNER> ,VEHBIT>>
		      <SETG HERE <LOC ,WINNER>>)>
	       <SETG LIT <LIT? ,HERE>>
	       <COND (<EQUAL? ,VERBOSITY 1 2>
		      <CRLF>)>
	       <TELL ">">
	       <READ ,P-INBUF ,P-LEXV>
	       <SET OLEN <GETB ,P-LEXV ,P-LEXWORDS>>)>
	<SETG P-LEN <GETB ,P-LEXV ,P-LEXWORDS>>
	<COND (<0? ,P-LEN>
	       <TELL "[I beg your pardon?]" CR>
	       <RFALSE>)
	      (<EQUAL? <GET ,P-LEXV .PTR> ,W?OOPS>
	       <COND (<EQUAL? <GET ,P-LEXV <+ .PTR ,P-LEXELEN>> ;"rfix 36"
			      ,W?PERIOD ,W?COMMA>
		      <SET PTR <+ .PTR ,P-LEXELEN>>
		      <SETG P-LEN <- ,P-LEN 1>>)>
	       <COND (<NOT <G? ,P-LEN 1>>
		      <YOU-CANT-USE "OOPS">
		      <RFALSE>)
		     (<GET ,OOPS-TABLE ,O-PTR>
		      <COND (<G? ,P-LEN 2>
			     <TELL
"[Warning: Only the first word after OOPS is used.]" CR>)>
			   <PUT ,AGAIN-LEXV <GET ,OOPS-TABLE ,O-PTR>
			   <GET ,P-LEXV <+ .PTR ,P-LEXELEN>>>
		      <SETG WINNER .OWINNER> ;"Fixes OOPS w/char"
		      <INBUF-ADD <GETB ,P-LEXV <+ <* .PTR ,P-LEXELEN> 6>>
				 <GETB ,P-LEXV <+ <* .PTR ,P-LEXELEN> 7>>
				 <+ <* <GET ,OOPS-TABLE ,O-PTR> ,P-LEXELEN> 3>>
		      <STUFF ,P-LEXV ,AGAIN-LEXV>
		      <SETG P-LEN <GETB ,P-LEXV ,P-LEXWORDS>>;"Will this help?"
		      <SET PTR <GET ,OOPS-TABLE ,O-START>>
		      <INBUF-STUFF ,P-INBUF ,OOPS-INBUF>)
		     (T
		      <PUT ,OOPS-TABLE ,O-END <>>
		      <TELL "[There was no word to replace.]" CR>
		      <RFALSE>)>)
	      (T <PUT ,OOPS-TABLE ,O-END <>>)>
	<COND (<EQUAL? <GET ,P-LEXV .PTR> ,W?AGAIN ,W?G>
	       <SETG P-DOLLAR-FLAG T> 			;"added JO"
	       <COND (<OR ,P-OFLAG
		          <RUNNING? I-CURSE>>
		      <YOU-CANT-USE "AGAIN">
		      <RFALSE>)
		     ;(<RUNNING? ,I-CURSE>
		      <CLEAN-TALK?>
		      <RFALSE>)
	       	     (<NOT ,P-WON>
		      <TELL "[That would just repeat a mistake.]" CR>
		      <RFALSE>)
		     (<AND <NOT <EQUAL? .OWINNER ,PLAYER>>
			   <NOT <VISIBLE? .OWINNER>>>
		      <TELL "[You can't see">
		      <ARTICLE .OWINNER T>
		      <TELL " any more.]" CR>
		      <RFALSE>)
		     (<G? ,P-LEN 1>
		      <COND (<OR <EQUAL? <GET ,P-LEXV <+ .PTR ,P-LEXELEN>>
					,W?PERIOD ,W?COMMA ,W?THEN>
				 <EQUAL? <GET ,P-LEXV <+ .PTR ,P-LEXELEN>>
					,W?AND>>
			     <SET PTR <+ .PTR <* 2 ,P-LEXELEN>>>
			     <PUTB ,P-LEXV ,P-LEXWORDS
				   <- <GETB ,P-LEXV ,P-LEXWORDS> 2>>)
			    (T
			     <TELL ,BAD-SENTENCE CR>
			     <RFALSE>)>)
		     (T
		      <SET PTR <+ .PTR ,P-LEXELEN>>
		      <PUTB ,P-LEXV ,P-LEXWORDS 
			    <- <GETB ,P-LEXV ,P-LEXWORDS> 1>>)>
	       <COND (<G? <GETB ,P-LEXV ,P-LEXWORDS> 0>
		      <STUFF ,RESERVE-LEXV ,P-LEXV>
		      <INBUF-STUFF ,RESERVE-INBUF ,P-INBUF>
		      <SETG RESERVE-PTR .PTR>)
		     (T
		      <SETG RESERVE-PTR <>>)>
	       ;<SETG P-LEN <GETB ,AGAIN-LEXV ,P-LEXWORDS>>
	       <SETG WINNER .OWINNER>
	       <SETG P-MERGED .OMERGED>
	       <INBUF-STUFF ,P-INBUF ,OOPS-INBUF>
	       <STUFF ,P-LEXV ,AGAIN-LEXV>
	       <SET CNT -1>
	       <SET DIR ,AGAIN-DIR>
	       <REPEAT ()
		<COND (<IGRTR? CNT ,P-ITBLLEN> <RETURN>)
		      (T <PUT ,P-ITBL .CNT <GET ,P-OTBL .CNT>>)>>)
	      (T
	       <STUFF ,AGAIN-LEXV ,P-LEXV>
	       <INBUF-STUFF ,OOPS-INBUF ,P-INBUF>
	       <PUT ,OOPS-TABLE ,O-START .PTR>
	       <PUT ,OOPS-TABLE ,O-LENGTH <* 4 ,P-LEN>> ;"rfix no. 36"	       
	       <SET LEN
		    <* 2 <+ .PTR <* ,P-LEXELEN <GETB ,P-LEXV ,P-LEXWORDS>>>>>
	       <PUT ,OOPS-TABLE ,O-END <+ <GETB ,P-LEXV <- .LEN 1>>
					  <GETB ,P-LEXV <- .LEN 2>>>>	      
	       <SETG RESERVE-PTR <>>
	       <SET LEN ,P-LEN>
	       ;<SETG P-DIR <>>
	       <SETG P-NCN 0>
	       <SETG P-GETFLAGS 0>
	       <REPEAT ()
		<COND (<L? <SETG P-LEN <- ,P-LEN 1>> 0>
		       <SETG QUOTE-FLAG <>>
		       <RETURN>)   ;"NEXT two clauses added by JO via PROF"
		      (<CLEAN-TALK? <SET WRD <GET ,P-LEXV .PTR>>>
		       <RFALSE>)
		      (<BUZZER-WORD? <SET WRD <GET ,P-LEXV .PTR>>>
		       <RFALSE>)		      
		      (<OR <SET WRD <GET ,P-LEXV .PTR>>
			   <SET WRD <NUMBER? .PTR>>>
		       <COND (<AND <==? .WRD ,W?TO>
				   <EQUAL? .VERB ,ACT?TELL ,ACT?ASK>
				   ;"next clause added 8/20/84 by JW to
				     enable TELL MY NAME TO BEAST"
				   <WT? <GET ,P-LEXV <+ .PTR ,P-LEXELEN>>
					,PS?VERB ,P1?VERB>>
			      <PUT ,P-ITBL ,P-VERB ,ACT?TELL>
			      <SET WRD ,W?QUOTE>)
			     (<AND <==? .WRD ,W?THEN>
				   <G? ,P-LEN 0>
				   <NOT .VERB>
				   <NOT ,QUOTE-FLAG>>
			      <PUT ,P-ITBL ,P-VERB ,ACT?TELL>
			      <PUT ,P-ITBL ,P-VERBN 0>
			      <SET WRD ,W?QUOTE>)
			     (<AND <EQUAL? .WRD ,W?PERIOD>
				   <EQUAL? .LW ,W?MR ,W?DR ;,W?ST>>
			      <SETG P-NCN <- ,P-NCN 1>>
			      <CHANGE-LEXV .PTR .LW T>
			      <SET WRD .LW>
			      <SET LW 0>)>
		       <COND (<OR <EQUAL? .WRD ,W?THEN ,W?PERIOD>
				  <EQUAL? .WRD ,W?QUOTE>> 
			      <COND (<EQUAL? .WRD ,W?QUOTE>
				     <COND ;"Following clause added 8/7/84
					     for CARVE 'FOO' IN BAR"
				           ;(<EQUAL? .VERB ,ACT?CARVE ,ACT?MY>
					    <CHANGE-LEXV .PTR ,W?THE>
					    <SETG P-LEN <+ ,P-LEN 1>>
					    <AGAIN>)
					   (,QUOTE-FLAG
					    <SETG QUOTE-FLAG <>>)
					   (T <SETG QUOTE-FLAG T>)>)>
			      <OR <0? ,P-LEN>
				  <SETG P-CONT <+ .PTR ,P-LEXELEN>>>
			      <PUTB ,P-LEXV ,P-LEXWORDS ,P-LEN>
			      <RETURN>)
			     (<AND <SET VAL
					<WT? .WRD ,PS?DIRECTION ,P1?DIRECTION>>
				       <EQUAL? .VERB <> ,ACT?WALK ,ACT?GO>
				   <OR <EQUAL? .LEN 1>
				       <AND <EQUAL? .LEN 2>
					    <EQUAL? .VERB ,ACT?WALK ,ACT?GO>>
				       <AND <EQUAL? <SET NW
						     <GET ,P-LEXV
							  <+ .PTR ,P-LEXELEN>>>
					            ,W?THEN
					            ,W?PERIOD
					            ,W?QUOTE>
					    <NOT <L? .LEN 2>>>
				       <AND ,QUOTE-FLAG
					    <==? .LEN 2>
					    <EQUAL? .NW ,W?QUOTE>>
				       <AND <G? .LEN 2>
					    <EQUAL? .NW ,W?COMMA ,W?AND>>>>
			      <SET DIR .VAL>
			      <COND (<EQUAL? .NW ,W?COMMA ,W?AND>
				     <CHANGE-LEXV <+ .PTR ,P-LEXELEN>
					  ,W?THEN>)>
			      <COND (<NOT <G? .LEN 2>>
				     <SETG QUOTE-FLAG <>>
				     <RETURN>)>)
			     (<AND <SET VAL <WT? .WRD ,PS?VERB ,P1?VERB>>
				   <NOT .VERB>>
			      <SETG P-PRSA-WORD .WRD>
			      <SET VERB .VAL>
			      <PUT ,P-ITBL ,P-VERB .VAL>
			      <PUT ,P-ITBL ,P-VERBN ,P-VTBL>
			      <PUT ,P-VTBL 0 .WRD>
			      <PUTB ,P-VTBL 2 <GETB ,P-LEXV
						    <SET CNT
							 <+ <* .PTR 2> 2>>>>
			      <PUTB ,P-VTBL 3 <GETB ,P-LEXV <+ .CNT 1>>>)
			     (<OR <SET VAL <WT? .WRD ,PS?PREPOSITION 0>>
				  <AND <OR <EQUAL? .WRD ,W?ALL ,W?ONE ,W?BOTH>
					   <WT? .WRD ,PS?ADJECTIVE>
					   <WT? .WRD ,PS?OBJECT>>
				       <SET VAL 0>>>
			      <COND (<AND <G? ,P-LEN 0>
				      <EQUAL? <GET ,P-LEXV <+ .PTR ,P-LEXELEN>>
					      ,W?OF>
				      <0? .VAL>
				      <NOT <EQUAL? .WRD ,W?ALL ,W?ONE ,W?A>>
				      <NOT <EQUAL? .WRD ,W?BOTH>>>
				      <COND (<EQUAL? .WRD ,W?FRONT ,W?HEAD>
					     <SETG IN-FRONT-FLAG T>)>)
				    (<AND <NOT <0? .VAL>>
				          <OR <0? ,P-LEN>
					      <EQUAL? <GET ,P-LEXV <+ .PTR 2>>
						      ,W?THEN ,W?PERIOD>>>
				     <SETG P-END-ON-PREP T>
				     <COND (<L? ,P-NCN 2>
					    <PUT ,P-ITBL ,P-PREP1 .VAL>
					    <PUT ,P-ITBL ,P-PREP1N .WRD>)>)
				    (<EQUAL? ,P-NCN 2>
				     <TELL
"[There were too many nouns in that sentence.]" CR>
				     <RFALSE>)
				    (T
				     <SETG P-NCN <+ ,P-NCN 1>>
				     ;"This COND added 8/7/84 for IN FRONT OF"
				     <COND (<AND <EQUAL? .VAL ,PR?IN>
						 <EQUAL? <GET ,P-LEXV
							      <+ .PTR 2>>
							 ,W?FRONT>>
					    <SETG IN-FRONT-FLAG T>)
					   (<OR <EQUAL? <GET ,P-LEXV
							      <+ .PTR 2>>
						         ,W?FRONT ,W?HEAD>
					        <EQUAL? <GET ,P-LEXV
							      <+ .PTR 3>>
							 ,W?FRONT ,W?HEAD>
						<EQUAL? <GET ,P-LEXV
							      <+ .PTR 4>>
						         ,W?FRONT ,W?HEAD>>
					    <SETG IN-FRONT-FLAG T>)
					   (<AND <EQUAL? .VAL ,PR?DOWN>
						 <EQUAL? <GET ,P-LEXV
							      <+ .PTR 2>>
							 ,W?IN>
						 <EQUAL? <GET ,P-LEXV
							      <+ .PTR 4>>
							 ,W?FRONT>>
					    <SETG IN-FRONT-FLAG T>)>
				     <OR <SET PTR <CLAUSE .PTR .VAL .WRD>>
					 <RFALSE>>
				     <COND (<L? .PTR 0>
					    <SETG QUOTE-FLAG <>>
					    <RETURN>)>)>)
			     ;(<AND <NOT .VERB>
				   <EQUAL? .WRD ,W?DON\'T ,W?DONT>>
			      <SET DONT T>)
			     (<WT? .WRD ,PS?BUZZ-WORD>)
			     (<AND <EQUAL? .VERB ,ACT?TELL>
				   <WT? .WRD ,PS?VERB ,P1?VERB>
				   ;"Next expr added to fix FORD, TELL ME WHY"
				   ;"NOT taken out of said expr to fix fix"
				   <EQUAL? ,WINNER ,PLAYER>>
			      <TELL-SEE-MANUAL>
			      <RFALSE>)
			     (T
			      <CANT-USE .PTR>
			      <RFALSE>)>)
		      (T
		       <UNKNOWN-WORD .PTR>
		       <RFALSE>)>
		<SET LW .WRD>
		<SET PTR <+ .PTR ,P-LEXELEN>>>)>
	<PUT ,OOPS-TABLE ,O-PTR <>>
	<COND (.DIR
	       <SETG PRSA ,V?WALK>
	       <SETG PRSO .DIR>
	       <SETG P-OFLAG <>>
	       <SETG P-WALK-DIR .DIR>
	       <SETG AGAIN-DIR .DIR>
	       ;<SETG DONT-FLAG .DONT>
	       <RETURN T>)>
	<SETG P-WALK-DIR <>>
	<SETG AGAIN-DIR <>>
	<COND ;(<OR <NOT ,P-OFLAG>
	       	   <NOT <ORPHAN-MERGE>>>
	       <SETG DONT-FLAG .DONT>)
	      (,P-OFLAG
	       <ORPHAN-MERGE>)>
	<COND (<AND <SYNTAX-CHECK>
		    <SNARF-OBJECTS>
		    <MANY-CHECK>
		    <TAKE-CHECK>>
	       T)>>

;<ROUTINE CHANGE-LEXV (PTR WRD)
	 <PUT ,P-LEXV .PTR .WRD>
	 <PUT ,AGAIN-LEXV .PTR .WRD>>

<ROUTINE CHANGE-LEXV (PTR WRD "OPTIONAL" (PTRS? <>) "AUX" X Y Z)
	 <COND (.PTRS?
		<SET X <+ 2 <* 2 <- .PTR ,P-LEXELEN>>>>
		<SET Y <GETB ,P-LEXV .X>>
		<SET Z <+ 2 <* 2 .PTR>>>
		<PUTB     ,P-LEXV .Z .Y>
		<PUTB ,AGAIN-LEXV .Z .Y>
		<SET Y <GETB ,P-LEXV <+ 1 .X>>>
		<SET Z <+ 3 <* 2 .PTR>>>
		<PUTB     ,P-LEXV .Z .Y>
		<PUTB ,AGAIN-LEXV .Z .Y>)>
	 <PUT ,P-LEXV .PTR .WRD>
	 <PUT ,AGAIN-LEXV .PTR .WRD>>

;<GLOBAL DONT-FLAG <>>

<GLOBAL P-WALK-DIR <>>

<GLOBAL AGAIN-DIR <>>

<GLOBAL P-DIRECTION <>>

;"For AGAIN purposes, put contents of one LEXV table into another."
<ROUTINE STUFF (DEST SRC "OPTIONAL" (MAX 29) "AUX" (PTR ,P-LEXSTART) (CTR 1)
						   BPTR)
	 <PUTB .DEST 0 <GETB .SRC 0>>
	 <PUTB .DEST 1 <GETB .SRC 1>>
	 <REPEAT ()
	  <PUT .DEST .PTR <GET .SRC .PTR>>
	  <SET BPTR <+ <* .PTR 2> 2>>
	  <PUTB .DEST .BPTR <GETB .SRC .BPTR>>
	  <SET BPTR <+ <* .PTR 2> 3>>
	  <PUTB .DEST .BPTR <GETB .SRC .BPTR>>
	  <SET PTR <+ .PTR ,P-LEXELEN>>
	  <COND (<IGRTR? CTR .MAX>
		 <RETURN>)>>>

;"Put contents of one INBUF into another"
<ROUTINE INBUF-STUFF (DEST SRC "AUX" (CNT -1))
	 <REPEAT ()
	  <COND (<IGRTR? CNT 59> <RETURN>)
		(T <PUTB .DEST .CNT <GETB .SRC .CNT>>)>>> 

;"Put the word in the positions specified from P-INBUF to the end of
OOPS-INBUF, leaving the appropriate pointers in AGAIN-LEXV"
<ROUTINE INBUF-ADD (LEN BEG SLOT "AUX" DBEG (CTR 0) TMP)
	 <COND (<SET TMP <GET ,OOPS-TABLE ,O-END>>
		<SET DBEG .TMP>)
	       (T
		<SET DBEG <+ <GETB ,AGAIN-LEXV
				   <SET TMP <GET ,OOPS-TABLE ,O-LENGTH>>>
			     <GETB ,AGAIN-LEXV <+ .TMP 1>>>>)>
	 <PUT ,OOPS-TABLE ,O-END <+ .DBEG .LEN>>
	 <REPEAT ()
	  <PUTB ,OOPS-INBUF <+ .DBEG .CTR> <GETB ,P-INBUF <+ .BEG .CTR>>>
	  <SET CTR <+ .CTR 1>>
	  <COND (<EQUAL? .CTR .LEN> <RETURN>)>>
	 <PUTB ,AGAIN-LEXV .SLOT .DBEG>
	 <PUTB ,AGAIN-LEXV <- .SLOT 1> .LEN>>

;"Check whether word pointed at by PTR is the correct part of speech.
   The second argument is the part of speech (,PS?<part of speech>).  The
   3rd argument (,P1?<part of speech>), if given, causes the value
   for that part of speech to be returned."
<ROUTINE WT? (PTR BIT "OPTIONAL" (B1 5) "AUX" (OFFS ,P-P1OFF) TYP) 
	<COND (<BTST <SET TYP <GETB .PTR ,P-PSOFF>> .BIT>
	       <COND (<G? .B1 4> <RTRUE>)
		     (T
		      <SET TYP <BAND .TYP ,P-P1BITS>>
		      <COND (<NOT <==? .TYP .B1>> <SET OFFS <+ .OFFS 1>>)>
		      <GETB .PTR .OFFS>)>)>>

;" Scan through a noun clause, leave a pointer to its starting location"
<ROUTINE CLAUSE (PTR VAL WRD "AUX" OFF NUM (ANDFLG <>) (FIRST?? T) NW (LW 0))
	<SET OFF <* <- ,P-NCN 1> 2>>
	<COND (<NOT <==? .VAL 0>>
	       <PUT ,P-ITBL <SET NUM <+ ,P-PREP1 .OFF>> .VAL>
	       <PUT ,P-ITBL <+ .NUM 1> .WRD>
	       <SET PTR <+ .PTR ,P-LEXELEN>>)
	      (T <SETG P-LEN <+ ,P-LEN 1>>)>
	<COND (<0? ,P-LEN> <SETG P-NCN <- ,P-NCN 1>> <RETURN -1>)>
	<PUT ,P-ITBL <SET NUM <+ ,P-NC1 .OFF>> <REST ,P-LEXV <* .PTR 2>>>
	<COND (<EQUAL? <GET ,P-LEXV .PTR> ,W?THE ,W?A ,W?AN>
	       <PUT ,P-ITBL .NUM <REST <GET ,P-ITBL .NUM> 4>>)>
	<REPEAT ()
		<COND (<L? <SETG P-LEN <- ,P-LEN 1>> 0>
		       <PUT ,P-ITBL <+ .NUM 1> <REST ,P-LEXV <* .PTR 2>>>
		       <RETURN -1>)>
		<COND (<OR <SET WRD <GET ,P-LEXV .PTR>>
			   <SET WRD <NUMBER? .PTR>>>
		       <COND (<0? ,P-LEN> <SET NW 0>)
			     (T <SET NW <GET ,P-LEXV <+ .PTR ,P-LEXELEN>>>)>
		       <COND (<AND <EQUAL? .WRD ,W?PERIOD>
				   <EQUAL? .LW ,W?MR ,W?DR>> ;"DR added JO"
			      <SET LW 0>)
			     (<EQUAL? .WRD ,W?AND ,W?COMMA> <SET ANDFLG T>)
			     (<EQUAL? .WRD ,W?ALL ,W?ONE ,W?BOTH>
			      <COND (<==? .NW ,W?OF>
				     <SETG P-LEN <- ,P-LEN 1>>
				     <SET PTR <+ .PTR ,P-LEXELEN>>)>)
			     (<OR <EQUAL? .WRD ,W?THEN ,W?PERIOD>
				  <AND <WT? .WRD ,PS?PREPOSITION>
				       <GET ,P-ITBL ,P-VERB>
				          ;"ADDED 4/27 FOR TURTLE,UP"
				       <NOT .FIRST??>>>
			      <SETG P-LEN <+ ,P-LEN 1>>
			      <PUT ,P-ITBL
				   <+ .NUM 1>
				   <REST ,P-LEXV <* .PTR 2>>>
			      <RETURN <- .PTR ,P-LEXELEN>>)
			     ;"This next clause was 2 clauses further down"
			     ;"This attempts to fix EDDIE, TURN ON COMPUTER"
			     (<AND .ANDFLG
				   <EQUAL? <GET ,P-ITBL ,P-VERB> 0>>
			      <SET PTR <- .PTR 4>>
			      <CHANGE-LEXV <+ .PTR 2> ,W?THEN>
			      <SETG P-LEN <+ ,P-LEN 2>>)
			     (<WT? .WRD ,PS?OBJECT>
			      <COND ;"First clause added 1/10/84 to fix
				      'verb AT synonym OF synonym' bug"
			            (<AND <G? ,P-LEN 0>
					  <EQUAL? .NW ,W?OF>
					  <NOT <EQUAL? .WRD ,W?ALL ,W?ONE>>>
				     T)
				    (<AND <WT? .WRD
					       ,PS?ADJECTIVE
					       ,P1?ADJECTIVE>
					  <NOT <==? .NW 0>>
					  <OR <WT? .NW ,PS?OBJECT>
					      <WT? .NW ,PS?ADJECTIVE>>>)
				    (<AND <NOT .ANDFLG>
					  <NOT <EQUAL? .NW ,W?BUT ,W?EXCEPT>>
					  <NOT <EQUAL? .NW ,W?AND ,W?COMMA>>>
				     <PUT ,P-ITBL
					  <+ .NUM 1>
					  <REST ,P-LEXV <* <+ .PTR 2> 2>>>
				     <RETURN .PTR>)
				    (T <SET ANDFLG <>>)>)
			     ;"next clause replaced by following on from games
			       with characters"
			     ;(<AND <OR ,P-MERGED
				       ,P-OFLAG
				       <NOT <EQUAL? <GET ,P-ITBL ,P-VERB> 0>>>
				   <OR <WT? .WRD ,PS?ADJECTIVE>
				       <WT? .WRD ,PS?BUZZ-WORD>>>)
			     (<OR <WT? .WRD ,PS?ADJECTIVE>
				  <WT? .WRD ,PS?BUZZ-WORD>>)
			     (<WT? .WRD ,PS?PREPOSITION> T)
			     (T
			      <CANT-USE .PTR>
			      <RFALSE>)>)
		      (T <UNKNOWN-WORD .PTR> <RFALSE>)>
		<SET LW .WRD>
		<SET FIRST?? <>>
		<SET PTR <+ .PTR ,P-LEXELEN>>>> 

;<ROUTINE NUMBER? (PTR "AUX" CNT BPTR CHR (SUM 0) (TIM <>))
	 <SET CNT <GETB <REST ,P-LEXV <* .PTR 2>> 2>>
	 <SET BPTR <GETB <REST ,P-LEXV <* .PTR 2>> 3>>
	 <REPEAT ()
		 <COND (<L? <SET CNT <- .CNT 1>> 0> <RETURN>)
		       (T
			<SET CHR <GETB ,P-INBUF .BPTR>>
			<COND (<==? .CHR 58>
			       <SET TIM .SUM>
			       <SET SUM 0>)
			      (<G? .SUM 32000> <RFALSE>)
			      (<AND <L? .CHR 58> <G? .CHR 47>>
			       <SET SUM <+ <* .SUM 10> <- .CHR 48>>>)
			      (T <RFALSE>)>
			<SET BPTR <+ .BPTR 1>>)>>
	 <CHANGE-LEXV .PTR ,W?INTNUM>
	 <COND (<G? .SUM 3000>      ;"this 3000 used to be 1000"
		<RFALSE>)
	       (.TIM
		<COND (<L? .TIM 8>
		       <SET TIM <+ .TIM 12>>)
		      (<G? .TIM 23>
		       <RFALSE>)>
		<SET SUM <+ .SUM <* .TIM 60>>>)>
	 <SETG P-NUMBER .SUM>
	 ,W?INTNUM>

<ROUTINE NUMBER? (PTR "AUX" CNT BPTR CHR (SUM 0) (TIM <>) (DOLLAR <>)
			    (EXC <>) CCTR TMP NW)
	 <SET CNT <GETB <REST ,P-LEXV <* .PTR 2>> 2>>
	 <SET BPTR <GETB <REST ,P-LEXV <* .PTR 2>> 3>>
	 <REPEAT ()
		 <COND (<L? <SET CNT <- .CNT 1>> 0> <RETURN>)
		       (T
			<SET CHR <GETB ,P-INBUF .BPTR>>
			<COND (<==? .CHR 58>
			       <COND (.EXC <RFALSE>)>
			       <SET TIM .SUM>
			       <SET SUM 0>)
			      (<G? .SUM 9999> <RFALSE>)
			      (<AND <L? .CHR 58> <G? .CHR 47>>
			       <SET SUM <+ <* .SUM 10> <- .CHR 48>>>)
			      (<EQUAL? .CHR %<ASCII !\$>>
			       <SET DOLLAR T>)
			      (T <RFALSE>)>
			<SET BPTR <+ .BPTR 1>>)>>
	 <CHANGE-LEXV .PTR ,W?INTNUM>
	 <SET NW <GET ,P-LEXV <+ .PTR ,P-LEXELEN>>>
	 <COND (<AND .DOLLAR
		     <EQUAL? .NW ,W?PERIOD>
		     <G? ,P-LEN 1>>
		<COND (<SET TMP <CENTS-CHECK <+ .PTR <* ,P-LEXELEN 2>>>>
		       <COND (<EQUAL? .TMP 100> <SET TMP 0>)>
		       <SET SUM <+ <* 100 .SUM> .TMP>>
		       <SET CCTR <- ,P-LEN 2>>
		       <REPEAT ()
			 <COND (<DLESS? CCTR 0> <RETURN>)
			       (T
				<SET PTR <+ .PTR ,P-LEXELEN>>
				<CHANGE-LEXV .PTR
				    <GET ,P-LEXV <+ .PTR <* 2 ,P-LEXELEN>>>>
				<PUTB ,P-LEXV <+ <* .PTR 2> 2>
				    <GETB ,P-LEXV
				       <+ <* <+ .PTR <* 2 ,P-LEXELEN>> 2> 2>>>
				<PUTB ,P-LEXV <+ <* .PTR 2> 3>
				    <GETB ,P-LEXV
				     <+ <* <+ .PTR <* 2 ,P-LEXELEN>> 2> 3>>>)>>
		       <SETG P-LEN <- ,P-LEN 2>>
		       <PUTB ,P-LEXV ,P-LEXWORDS
			     <- <GETB ,P-LEXV ,P-LEXWORDS> 2>>)>)
	       (.DOLLAR
		<SET SUM <* .SUM 100>>)
	       (<EQUAL? .NW ,W?DOLLAR>
		<SET DOLLAR T>
		<SET SUM <* .SUM 100>>)
	       (<EQUAL? .NW ,W?CENT ,W?CENTS>
		<SET DOLLAR T>)>
	 <COND (<G? .SUM 9999> <RFALSE>)
	       (.EXC
		<SETG P-EXCHANGE 0>)
	       (.TIM
		<SETG P-EXCHANGE 0>
		<COND (<G? .TIM 23> <RFALSE>)
		      ;(<G? .TIM 19> T)
		      ;(<G? .TIM 12> <RFALSE>)
		      ;(<G? .TIM  7> T)
		      ;(T <SET TIM <+ 12 .TIM>>)>
		<SET SUM <+ .SUM <* .TIM 60>>>)
	       (T
		<SETG P-EXCHANGE 0>)>
	 <COND (<AND .DOLLAR
		     <G? .SUM 0>>
		<SETG P-AMOUNT .SUM>
		<SETG P-DOLLAR-FLAG T>
		;<FSET ,INTNUM ,NARTICLEBIT>
		<PUTP ,INTNUM ,P?SDESC "money">
		,W?MONEY)
	       (T
		<SETG P-NUMBER .SUM>
		;<FCLEAR ,INTNUM ,NARTICLEBIT>
		<PUTP ,INTNUM ,P?SDESC "number">
		,W?NUMBER)>>

<ROUTINE CENTS-CHECK (PTR "AUX" CNT BPTR (CCTR 0) CHR (SUM 0))
	 <SET CNT <GETB <REST ,P-LEXV <* .PTR 2>> 2>>
	 <SET BPTR <GETB <REST ,P-LEXV <* .PTR 2>> 3>>
	 <REPEAT ()
		 <COND (<L? <SET CNT <- .CNT 1>> 0> <RETURN>)
		       (T
			<SET CHR <GETB ,P-INBUF .BPTR>>
			<SET CCTR <+ .CCTR 1>>
			<COND (<G? .CCTR 2> <RFALSE>)
			      (<AND <L? .CHR 58> <G? .CHR 47>>
			       <SET SUM <+ <* .SUM 10> <- .CHR 48>>>)
			      (T <RFALSE>)>
			<SET BPTR <+ .BPTR 1>>)>>
	 <COND (<0? .SUM>
		<RETURN 100>)
	       (<EQUAL? .CCTR 1>
		<RETURN <* 10 .SUM>>)
	       (T <RETURN .SUM>)>>

<GLOBAL P-NUMBER 0>

<GLOBAL P-EXCHANGE <>>

<GLOBAL P-DOLLAR-FLAG <>>

<GLOBAL P-AMOUNT 0>

<ROUTINE ORPHAN-MERGE ("AUX" (CNT -1) TEMP VERB BEG END (ADJ <>) WRD) 
   <SETG P-OFLAG <>>
   <COND (<OR <==? <WT? <SET WRD <GET <GET ,P-ITBL ,P-VERBN> 0>>
			,PS?VERB ,P1?VERB>
		   <GET ,P-OTBL ,P-VERB>>
	      <WT? .WRD ,PS?ADJECTIVE>>
	  <SET ADJ T>)
	 (<AND <WT? .WRD ,PS?OBJECT ,P1?OBJECT>
	       <EQUAL? ,P-NCN 0>>
	  <PUT ,P-ITBL ,P-VERB 0>
	  <PUT ,P-ITBL ,P-VERBN 0>
	  <PUT ,P-ITBL ,P-NC1 <REST ,P-LEXV 2>>
	  <PUT ,P-ITBL ,P-NC1L <REST ,P-LEXV 6>>
	  <SETG P-NCN 1>)>
   <COND (<AND <NOT <0? <SET VERB <GET ,P-ITBL ,P-VERB>>>>
	       <NOT .ADJ>
	       <NOT <==? .VERB <GET ,P-OTBL ,P-VERB>>>>
	  <RFALSE>)
	 (<==? ,P-NCN 2> <RFALSE>)
	 (<==? <GET ,P-OTBL ,P-NC1> 1>
	  <COND (<OR <==? <SET TEMP <GET ,P-ITBL ,P-PREP1>>
			  <GET ,P-OTBL ,P-PREP1>>
		     <0? .TEMP>>
		 <COND (.ADJ
			<PUT ,P-OTBL ,P-NC1 <REST ,P-LEXV 2>>
			<COND (<0? <GET ,P-ITBL ,P-NC1L>>
			       <PUT ,P-ITBL ,P-NC1L <REST ,P-LEXV 6>>)>
			<COND (<0? ,P-NCN> <SETG P-NCN 1>)>)
		       (T
			<PUT ,P-OTBL ,P-NC1 <GET ,P-ITBL ,P-NC1>>
			;<PUT ,P-OTBL ,P-NC1L <GET ,P-ITBL ,P-NC1L>>)>
		 <PUT ,P-OTBL ,P-NC1L <GET ,P-ITBL ,P-NC1L>>)
		(T <RFALSE>)>)
	 (<==? <GET ,P-OTBL ,P-NC2> 1>
	  <COND (<OR <==? <SET TEMP <GET ,P-ITBL ,P-PREP1>>
			  <GET ,P-OTBL ,P-PREP2>>
		     <0? .TEMP>>
		 <COND (.ADJ
			<PUT ,P-ITBL ,P-NC1 <REST ,P-LEXV 2>>
			<COND (<0? <GET ,P-ITBL ,P-NC1L>>
			       <PUT ,P-ITBL ,P-NC1L <REST ,P-LEXV 6>>)>)>
		 <PUT ,P-OTBL ,P-NC2 <GET ,P-ITBL ,P-NC1>>
		 <PUT ,P-OTBL ,P-NC2L <GET ,P-ITBL ,P-NC1L>>
		 <SETG P-NCN 2>)
		(T <RFALSE>)>)
	 (,P-ACLAUSE
	  <COND (<AND <NOT <==? ,P-NCN 1>> <NOT .ADJ>>
		 <SETG P-ACLAUSE <>>
		 <RFALSE>)
		(T
		 <SET BEG <GET ,P-ITBL ,P-NC1>>
		 <COND (.ADJ <SET BEG <REST ,P-LEXV 2>> <SET ADJ <>>)>
		 <SET END <GET ,P-ITBL ,P-NC1L>>
		 <REPEAT ()
			 <SET WRD <GET .BEG 0>>
			 <COND (<==? .BEG .END>
				<COND (.ADJ <ACLAUSE-WIN .ADJ> <RETURN>)
				      (T <SETG P-ACLAUSE <>> <RFALSE>)>)
			       (<AND <NOT .ADJ>
				     <OR <BTST <GETB .WRD ,P-PSOFF>
					       ,PS?ADJECTIVE> ;"same as WT?"
					 <EQUAL? .WRD ,W?ALL ,W?ONE>>>
				<SET ADJ .WRD>)
			       (<==? .WRD ,W?ONE>
				<ACLAUSE-WIN .ADJ>
				<RETURN>)
			       (<BTST <GETB .WRD ,P-PSOFF> ,PS?OBJECT>
				<COND (<EQUAL? .WRD ,P-ANAM>
				       <ACLAUSE-WIN .ADJ>)
				      (T
				       <NCLAUSE-WIN>)>
				<RETURN>)>
			 <SET BEG <REST .BEG ,P-WORDLEN>>
			 <COND (<EQUAL? .END 0>
				<SET END .BEG>
				<SETG P-NCN 1>
				<PUT ,P-ITBL ,P-NC1 <BACK .BEG 4>>
				<PUT ,P-ITBL ,P-NC1L .BEG>)>>)>)>
   <PUT ,P-VTBL 0 <GET ,P-OVTBL 0>>
   <PUTB ,P-VTBL 2 <GETB ,P-OVTBL 2>>
   <PUTB ,P-VTBL 3 <GETB ,P-OVTBL 3>>
   <PUT ,P-OTBL ,P-VERBN ,P-VTBL>
   <PUTB ,P-VTBL 2 0>
   ;<AND <NOT <==? <GET ,P-OTBL ,P-NC2> 0>> <SETG P-NCN 2>>
   <REPEAT ()
	   <COND (<G? <SET CNT <+ .CNT 1>> ,P-ITBLLEN>
		  <SETG P-MERGED T>
		  <RTRUE>)
		 (T <PUT ,P-ITBL .CNT <GET ,P-OTBL .CNT>>)>>
   T>

<ROUTINE ACLAUSE-WIN (ADJ) 
	<PUT ,P-ITBL ,P-VERB <GET ,P-OTBL ,P-VERB>>
	<PUT ,P-CCTBL ,CC-SBPTR ,P-ACLAUSE>
	<PUT ,P-CCTBL ,CC-SEPTR <+ ,P-ACLAUSE 1>>
	<PUT ,P-CCTBL ,CC-DBPTR ,P-ACLAUSE>
	<PUT ,P-CCTBL ,CC-DEPTR <+ ,P-ACLAUSE 1>>
	<CLAUSE-COPY ,P-OTBL ,P-OTBL .ADJ>
	<AND <NOT <==? <GET ,P-OTBL ,P-NC2> 0>> <SETG P-NCN 2>>
	<SETG P-ACLAUSE <>>
	<RTRUE>>

<ROUTINE NCLAUSE-WIN ()
        <PUT ,P-CCTBL ,CC-SBPTR ,P-NC1>
	<PUT ,P-CCTBL ,CC-SEPTR ,P-NC1L>
	<PUT ,P-CCTBL ,CC-DBPTR ,P-ACLAUSE>
	<PUT ,P-CCTBL ,CC-DEPTR <+ ,P-ACLAUSE 1>>
	<CLAUSE-COPY ,P-ITBL ,P-OTBL>
	<AND <NOT <==? <GET ,P-OTBL ,P-NC2> 0>> <SETG P-NCN 2>>
	<SETG P-ACLAUSE <>>
	<RTRUE>>

;"Print undefined word in input.
   PTR points to the unknown word in P-LEXV"   

<ROUTINE WORD-PRINT (CNT BUF)
	 <REPEAT ()
		 <COND (<DLESS? CNT 0> <RETURN>)
		       (ELSE
			<PRINTC <GETB ,P-INBUF .BUF>>
			<SET BUF <+ .BUF 1>>)>>>

<ROUTINE UNKNOWN-WORD (PTR "AUX" BUF)
	<PUT ,OOPS-TABLE ,O-PTR .PTR>
	<TELL "[I don't know the word \"">
	<WORD-PRINT <GETB <REST ,P-LEXV <SET BUF <* .PTR 2>>> 2>
		    <GETB <REST ,P-LEXV .BUF> 3>>
	<TELL ".\"]" CR>
	<SETG QUOTE-FLAG <>>
	<SETG P-OFLAG <>>>

<ROUTINE CANT-USE (PTR "AUX" BUF)
	<TELL "[You used the word \"">
	<WORD-PRINT <GETB <REST ,P-LEXV <SET BUF <* .PTR 2>>> 2>
		    <GETB <REST ,P-LEXV .BUF> 3>>
	<TELL "\" in a way that I don't understand.]" CR>
	<SETG QUOTE-FLAG <>>
	<SETG P-OFLAG <>>>

;" Perform syntax matching operations, using P-ITBL as the source of
   the verb and adjectives for this input.  Returns false if no
   syntax matches, and does it's own orphaning.  If return is true,
   the syntax is saved in P-SYNTAX."

<GLOBAL P-SLOCBITS 0>

<CONSTANT P-SYNLEN 8>

<CONSTANT P-SBITS 0>

<CONSTANT P-SPREP1 1>

<CONSTANT P-SPREP2 2>

<CONSTANT P-SFWIM1 3>

<CONSTANT P-SFWIM2 4>

<CONSTANT P-SLOC1 5>

<CONSTANT P-SLOC2 6>

<CONSTANT P-SACTION 7>

<CONSTANT P-SONUMS 3>
    
<ROUTINE SYNTAX-CHECK
	("AUX" SYN LEN NUM OBJ (DRIVE1 <>) (DRIVE2 <>) PREP VERB TMP)
	<COND (<0? <SET VERB <GET ,P-ITBL ,P-VERB>>>
	       <TELL "[There was no verb in that sentence!]" CR>
	       <RFALSE>)>
	<SET SYN <GET ,VERBS <- 255 .VERB>>>
	<SET LEN <GETB .SYN 0>>
	<SET SYN <REST .SYN>>
	<REPEAT ()
		<SET NUM <BAND <GETB .SYN ,P-SBITS> ,P-SONUMS>>
		<COND (<G? ,P-NCN .NUM> T)
		      (<AND <NOT <L? .NUM 1>>
			    <0? ,P-NCN>
			    <OR <0? <SET PREP <GET ,P-ITBL ,P-PREP1>>>
				<==? .PREP <GETB .SYN ,P-SPREP1>>>>
		       <SET DRIVE1 .SYN>)
		      (<==? <GETB .SYN ,P-SPREP1> <GET ,P-ITBL ,P-PREP1>>
		       <COND (<AND <==? .NUM 2> <==? ,P-NCN 1>>
			      <SET DRIVE2 .SYN>)
			     (<EQUAL? <GETB .SYN ,P-SPREP2>
				      <GET ,P-ITBL ,P-PREP2>>
			      <SYNTAX-FOUND .SYN>
			      <RTRUE>)>)>
		<COND (<DLESS? LEN 1>
		       <COND (<OR .DRIVE1 .DRIVE2> <RETURN>)
			     (T
			      <V-TELL-TIME>
			      <RFALSE>)>)
		      (T <SET SYN <REST .SYN ,P-SYNLEN>>)>>
	<COND (<AND .DRIVE1
		    <SET OBJ
			 <GWIM <GETB .DRIVE1 ,P-SFWIM1>
			       <GETB .DRIVE1 ,P-SLOC1>
			       <GETB .DRIVE1 ,P-SPREP1>>>>
	       <PUT ,P-PRSO ,P-MATCHLEN 1>
	       <PUT ,P-PRSO 1 .OBJ>
	       <SYNTAX-FOUND .DRIVE1>)
	      (<AND .DRIVE2
		    <SET OBJ
			 <GWIM <GETB .DRIVE2 ,P-SFWIM2>
			       <GETB .DRIVE2 ,P-SLOC2>
			       <GETB .DRIVE2 ,P-SPREP2>>>>
	       <PUT ,P-PRSI ,P-MATCHLEN 1>
	       <PUT ,P-PRSI 1 .OBJ>
	       <SYNTAX-FOUND .DRIVE2>)
	      (<EQUAL? .VERB ,ACT?FIND ;,ACT?WHAT>
	       <TELL "[That question can't be answered.]" CR>
	       <RFALSE>)
	      (T
	       <COND (<EQUAL? ,WINNER ,PLAYER>
		      <ORPHAN .DRIVE1 .DRIVE2>
		      <TELL "[Wh">)
		     (T
		      <TELL
"[Your command was not complete. Next time, type wh">)>
	       <COND (<OR <EQUAL? .VERB ,ACT?WALK ,ACT?GO ,ACT?LEAN>
			  <EQUAL? ,P-PRSA-WORD ,W?CRAWL>>
		      <TELL "ere">)
		     (<OR <AND .DRIVE1
			       <==? <GETB .DRIVE1 ,P-SFWIM1> ,ACTORBIT>>
			  <AND .DRIVE2
			       <==? <GETB .DRIVE2 ,P-SFWIM2> ,ACTORBIT>>>
		      <TELL "om">)
		     (T <TELL "at">)>
	       <COND (<EQUAL? ,WINNER ,PLAYER>
		      <TELL " do you want to ">)
		     (T
		      <TELL " you want">
		      <ARTICLE ,WINNER T>
		      <TELL " to ">)>
	       ;<SET TMP <GET ,P-OTBL ,P-VERBN>>
	       ;<COND (<EQUAL? .TMP 0>
		      <TELL "tell">)
		     (<0? <GETB ,P-VTBL 2>>
		      <PRINTB <GET .TMP 0>>)
		     (T
		      <WORD-PRINT <GETB .TMP 2> <GETB .TMP 3>>
		      <PUTB ,P-VTBL 2 0>)>
	       <VERB-PRINT>
	       <COND (.DRIVE2
		      <CLAUSE-PRINT ,P-NC1 ,P-NC1L>)>
	       <SETG P-OFLAG T>
	       <PREP-PRINT <COND (.DRIVE1 <GETB .DRIVE1 ,P-SPREP1>)
				 (T <GETB .DRIVE2 ,P-SPREP2>)>>
	       <COND (<EQUAL? ,WINNER ,PLAYER>
		      <SETG P-OFLAG T>
		      <TELL "?]" CR>)
		     (T
		      <SETG P-OFLAG <>>
		      <TELL ".]" CR>)>
	       <RFALSE>)>> 
		
<ROUTINE VERB-PRINT ("AUX" TMP)
	<SET TMP <GET ,P-ITBL ,P-VERBN>>	;"? ,P-OTBL?"
	<COND (<==? .TMP 0> <TELL "tell">)
	      (<0? <GETB ,P-VTBL 2>>
	       <PRINTB <GET .TMP 0>>)
	      (T
	       <WORD-PRINT <GETB .TMP 2> <GETB .TMP 3>>
	       <PUTB ,P-VTBL 2 0>)>>

<ROUTINE CANT-ORPHAN ()
	 <TELL "\"I don't understand! What are you referring to?\"" CR>
	 <RFALSE>>

<ROUTINE ORPHAN (D1 D2 "AUX" (CNT -1))
	<COND (<NOT ,P-MERGED>
	       <PUT ,P-OCLAUSE ,P-MATCHLEN 0>)>
	<PUT ,P-OVTBL 0 <GET ,P-VTBL 0>>
	<PUTB ,P-OVTBL 2 <GETB ,P-VTBL 2>>
	<PUTB ,P-OVTBL 3 <GETB ,P-VTBL 3>>
	<REPEAT ()
		<COND (<IGRTR? CNT ,P-ITBLLEN> <RETURN>)
		      (T <PUT ,P-OTBL .CNT <GET ,P-ITBL .CNT>>)>>
	<COND (<==? ,P-NCN 2>
	       <PUT ,P-CCTBL ,CC-SBPTR ,P-NC2>
	       <PUT ,P-CCTBL ,CC-SEPTR ,P-NC2L>
	       <PUT ,P-CCTBL ,CC-DBPTR ,P-NC2>
	       <PUT ,P-CCTBL ,CC-DEPTR ,P-NC2L>
	       <CLAUSE-COPY ,P-ITBL ,P-OTBL>)>
	<COND (<NOT <L? ,P-NCN 1>>
	       <PUT ,P-CCTBL ,CC-SBPTR ,P-NC1>
	       <PUT ,P-CCTBL ,CC-SEPTR ,P-NC1L>
	       <PUT ,P-CCTBL ,CC-DBPTR ,P-NC1>
	       <PUT ,P-CCTBL ,CC-DEPTR ,P-NC1L>
	       <CLAUSE-COPY ,P-ITBL ,P-OTBL>)>
	<COND (.D1
	       <PUT ,P-OTBL ,P-PREP1 <GETB .D1 ,P-SPREP1>>
	       <PUT ,P-OTBL ,P-NC1 1>)
	      (.D2
	       <PUT ,P-OTBL ,P-PREP2 <GETB .D2 ,P-SPREP2>>
	       <PUT ,P-OTBL ,P-NC2 1>)>> 
 
<ROUTINE CLAUSE-PRINT (BPTR EPTR "OPTIONAL" (THE? T)) 
	<BUFFER-PRINT <GET ,P-ITBL .BPTR> <GET ,P-ITBL .EPTR> .THE?>>    
 
<ROUTINE BUFFER-PRINT (BEG END CP "AUX" (NOSP <>) WRD (FIRST?? T) (PN <>))
	 <REPEAT ()
		<COND (<EQUAL? .BEG .END>
		       <RETURN>)
		      (T
		       <COND (.NOSP
			      <SET NOSP <>>)
			     (T
			      <TELL " ">)>
		       <COND (<EQUAL? <SET WRD <GET .BEG 0>> ,W?PERIOD>
			      <SET NOSP T>)
			     (<EQUAL? .WRD ,W?ME>
			      <DPRINT ,ME>
			      <SET PN T>)
			     (<NAME? .WRD>
			      <CAPITALIZE .BEG>
			      <SET PN T>)
			     (T
			      <COND (<AND .FIRST?? <NOT .PN> .CP>
				     <TELL "the ">)>
			      <COND (<OR ,P-OFLAG ,P-MERGED> <PRINTB .WRD>)
				    (<AND <==? .WRD ,W?IT>
					  <ACCESSIBLE? ,P-IT-OBJECT>>
				     <DPRINT ,P-IT-OBJECT>)
				    (T
				     <WORD-PRINT <GETB .BEG 2>
						 <GETB .BEG 3>>)>
			      <SET FIRST?? <>>)>)>
		<SET BEG <REST .BEG ,P-WORDLEN>>>>

<ROUTINE NAME? (WRD)
	 <COND (<OR <EQUAL? .WRD ,W?HARRY ,W?ELSIE ,W?NIMROD>
		    <EQUAL? .WRD ,W?SMALDO ,W?EDDIE ,W?HARRY>
		    <EQUAL? .WRD ,W?CONSTA ,W?THUMB ,W?COMRAD>
		    <EQUAL? .WRD ,W?CHUCKLES ,W?JENNY ,W?ANDREW>
		    <EQUAL? .WRD ,W?BILL ,W?BILLY ,W?MONDAY>
		    <EQUAL? .WRD ,W?GOTTFR ,W?KATZEN W?WILHEL>
		    <EQUAL? .WRD ,W?MUNRAB ,W?HERR ,W?TINA>
		    <EQUAL? .WRD ,W?RIMSHA ;,W?INCOMP ,W?HOWARD>
		    <EQUAL? .WRD ,W?ED ,W?COKE ,W?WILLIAM>
		    <EQUAL? .WRD ,W?JERRY ,W?ANNIE ,W?OAKLEY>
		    <EQUAL? .WRD ,W?MAHLER ,W?KATZ ,W?JOEY>
		    <EQUAL? .WRD ,W?CHELSEA ,W?TAFT ,W?HANNIBAL>
		    <EQUAL? .WRD ,W?ANDY ,W?JENNIF ,W?MR>
		    <EQUAL? .WRD ,W?GENATOSSIO ,W?MALCOM ,W?GLORIA>
		    <EQUAL? .WRD ,W?DUFFY ,W?SGT>>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<ROUTINE CAPITALIZE (PTR)
	 <COND (<OR ,P-OFLAG ,P-MERGED>
		<PRINTB <GET .PTR 0>>)
	       (T
		<PRINTC <- <GETB ,P-INBUF <GETB .PTR 3>> 32>>
		<WORD-PRINT <- <GETB .PTR 2> 1> <+ <GETB .PTR 3> 1>>)>>

<ROUTINE PREP-PRINT (PREP "AUX" WRD)
	<COND (<NOT <0? .PREP>>
	       <TELL " ">
	       <COND (<EQUAL? .PREP ,PR?THROUGH>
		      <TELL "through">)
		     (T
		      <SET WRD <PREP-FIND .PREP>>
		      <PRINTB .WRD>)>)>>    
 
<ROUTINE CLAUSE-COPY (SRC DEST "OPTIONAL" (INSRT <>) "AUX" BEG END)
	<SET BEG <GET .SRC <GET ,P-CCTBL ,CC-SBPTR>>>
	<SET END <GET .SRC <GET ,P-CCTBL ,CC-SEPTR>>>
	<PUT .DEST
	     <GET ,P-CCTBL ,CC-DBPTR>
	     <REST ,P-OCLAUSE
		   <+ <* <GET ,P-OCLAUSE ,P-MATCHLEN> ,P-LEXELEN> 2>>>
	<REPEAT ()
		<COND (<==? .BEG .END>
		       <PUT .DEST
			    <GET ,P-CCTBL ,CC-DEPTR>
			    <REST ,P-OCLAUSE
				  <+ <* <GET ,P-OCLAUSE ,P-MATCHLEN> ,P-LEXELEN>
				     2>>>
		       <RETURN>)
		      (T
		       <COND (<AND .INSRT <==? ,P-ANAM <GET .BEG 0>>>
			      <CLAUSE-ADD .INSRT>)>
		       <CLAUSE-ADD <GET .BEG 0>>)>
		<SET BEG <REST .BEG ,P-WORDLEN>>>>  


<ROUTINE CLAUSE-ADD (WRD "AUX" PTR)
	<SET PTR <+ <GET ,P-OCLAUSE ,P-MATCHLEN> 2>>
	<PUT ,P-OCLAUSE <- .PTR 1> .WRD>
	<PUT ,P-OCLAUSE .PTR 0>
	<PUT ,P-OCLAUSE ,P-MATCHLEN .PTR>>   
 
<ROUTINE PREP-FIND (PREP "AUX" (CNT 0) SIZE)
	<SET SIZE <* <GET ,PREPOSITIONS 0> 2>>
	<REPEAT ()
		<COND (<IGRTR? CNT .SIZE> <RFALSE>)
		      (<==? <GET ,PREPOSITIONS .CNT> .PREP>
		       <RETURN <GET ,PREPOSITIONS <- .CNT 1>>>)>>>  
 
<ROUTINE SYNTAX-FOUND (SYN)
	<SETG P-SYNTAX .SYN>
	<SETG PRSA <GETB .SYN ,P-SACTION>>>   
 
<GLOBAL P-GWIMBIT 0>
 
<ROUTINE GWIM (GBIT LBIT PREP "AUX" OBJ)
	<COND (<==? .GBIT ,RLANDBIT>
	       <RETURN ,ROOMS>)>
	<SETG P-GWIMBIT .GBIT>
	<SETG P-SLOCBITS .LBIT>
	<PUT ,P-MERGE ,P-MATCHLEN 0>
	<COND (<GET-OBJECT ,P-MERGE <>>
	       <SETG P-GWIMBIT 0>
	       <COND (<==? <GET ,P-MERGE ,P-MATCHLEN> 1>
		      <SET OBJ <GET ,P-MERGE 1>>
		      <TELL "[">
		      <COND (<AND <NOT <0? .PREP>>
				  <NOT ,P-END-ON-PREP>>
			     <PRINTB <SET PREP <PREP-FIND .PREP>>>
			     <COND (<==? .PREP ,W?OUT>
				    <TELL " of">)>
			     <COND (<NOT <FSET? .OBJ ,NARTICLEBIT>>
				    <TELL " the ">)
				   (T
				    <TELL " ">)>)>
		      <TELL D .OBJ "]" CR>
		      .OBJ)>)
	      (T <SETG P-GWIMBIT 0> <RFALSE>)>>   
 
<ROUTINE SNARF-OBJECTS ("AUX" PTR)
	<COND (<NOT <==? <SET PTR <GET ,P-ITBL ,P-NC1>> 0>>
	       <SETG P-PHR 0>
	       <SETG P-SLOCBITS <GETB ,P-SYNTAX ,P-SLOC1>>
	       <OR <SNARFEM .PTR <GET ,P-ITBL ,P-NC1L> ,P-PRSO> <RFALSE>>
	       <OR <0? <GET ,P-BUTS ,P-MATCHLEN>>
		   <SETG P-PRSO <BUT-MERGE ,P-PRSO>>>)>
	<COND (<NOT <==? <SET PTR <GET ,P-ITBL ,P-NC2>> 0>>
	       <SETG P-PHR 1>
	       <SETG P-SLOCBITS <GETB ,P-SYNTAX ,P-SLOC2>>
	       <OR <SNARFEM .PTR <GET ,P-ITBL ,P-NC2L> ,P-PRSI> <RFALSE>>
	       <COND (<NOT <0? <GET ,P-BUTS ,P-MATCHLEN>>>
		      <COND (<==? <GET ,P-PRSI ,P-MATCHLEN> 1>
			     <SETG P-PRSO <BUT-MERGE ,P-PRSO>>)
			    (T <SETG P-PRSI <BUT-MERGE ,P-PRSI>>)>)>)>
	<RTRUE>>  

<ROUTINE BUT-MERGE (TBL "AUX" LEN BUTLEN (CNT 1) (MATCHES 0) OBJ NTBL)
	<SET LEN <GET .TBL ,P-MATCHLEN>>
	<PUT ,P-MERGE ,P-MATCHLEN 0>
	<REPEAT ()
		<COND (<DLESS? LEN 0> <RETURN>)
		      (<ZMEMQ <SET OBJ <GET .TBL .CNT>> ,P-BUTS>)
		      (T
		       <PUT ,P-MERGE <+ .MATCHES 1> .OBJ>
		       <SET MATCHES <+ .MATCHES 1>>)>
		<SET CNT <+ .CNT 1>>>
	<PUT ,P-MERGE ,P-MATCHLEN .MATCHES>
	<SET NTBL ,P-MERGE>
	<SETG P-MERGE .TBL>
	.NTBL>    
 
<GLOBAL P-NAM <>>   
 
<GLOBAL P-NAMW <TABLE 0 0>>

<GLOBAL P-ADJ <>>   
 
<GLOBAL P-ADJW <TABLE 0 0>>

<GLOBAL P-PHR 0>

<GLOBAL P-ADVERB <>>

<GLOBAL P-ADJN <>>  
 
<GLOBAL P-PRSO <ITABLE NONE 50>>

<GLOBAL P-PRSI <ITABLE NONE 50>>

<GLOBAL P-BUTS <ITABLE NONE 50>>

<GLOBAL P-MERGE <ITABLE NONE 50>>

<GLOBAL P-OCLAUSE <ITABLE NONE 50>>
 
<GLOBAL P-MATCHLEN 0>    
 
<GLOBAL P-GETFLAGS 0>    
 
<CONSTANT P-ALL 1>  
 
<CONSTANT P-ONE 2>  
 
<CONSTANT P-INHIBIT 4>   

;<GLOBAL P-CSPTR <>>
;<GLOBAL P-CEPTR <>>

<ROUTINE SNARFEM (PTR EPTR TBL "AUX" (BUT <>) LEN WV WRD NW (WAS-ALL <>))
   <SETG P-AND <>>
   <COND (<==? ,P-GETFLAGS ,P-ALL>
	  <SET WAS-ALL T>)>
   <SETG P-GETFLAGS 0>
   ;<SETG P-CSPTR .PTR>
   ;<SETG P-CEPTR .EPTR>
   <PUT ,P-BUTS ,P-MATCHLEN 0>
   <PUT .TBL ,P-MATCHLEN 0>
   <SET WRD <GET .PTR 0>>
   <REPEAT ()
	   <COND (<==? .PTR .EPTR>
		  <SET WV <GET-OBJECT <OR .BUT .TBL>>>
		  <COND (.WAS-ALL <SETG P-GETFLAGS ,P-ALL>)>
		  <RETURN .WV>)
		 (T
		  <SET NW <GET .PTR ,P-LEXELEN>>
		  <COND (<EQUAL? .WRD ,W?ALL ,W?BOTH>
			 <SETG P-GETFLAGS ,P-ALL>
			 <COND (<==? .NW ,W?OF>
				<SET PTR <REST .PTR ,P-WORDLEN>>)>)
			(<CLEAN-TALK? .WRD> ;"This clause at PARSER too"
			 <RFALSE>)   
		        (<BUZZER-WORD? .WRD>
			 <RFALSE>)
			(<EQUAL? .WRD ,W?BUT ,W?EXCEPT>
			 <OR <GET-OBJECT <OR .BUT .TBL>> <RFALSE>>
			 <SET BUT ,P-BUTS>
			 <PUT .BUT ,P-MATCHLEN 0>)
			(<EQUAL? .WRD ,W?A ,W?ONE>
			 <COND (<NOT ,P-ADJ>
				<SETG P-GETFLAGS ,P-ONE>
				<COND (<==? .NW ,W?OF>
				       <SET PTR <REST .PTR ,P-WORDLEN>>)>)
			       (T
				<SETG P-NAM ,P-ONEOBJ>
				<OR <GET-OBJECT <OR .BUT .TBL>> <RFALSE>>
				<AND <0? .NW> <RTRUE>>)>)
			(<AND <EQUAL? .WRD ,W?AND ,W?COMMA>
			      <NOT <EQUAL? .NW ,W?AND ,W?COMMA>>>
			 <SETG P-AND T>
			 <OR <GET-OBJECT <OR .BUT .TBL>> <RFALSE>>
			 T)
			(<WT? .WRD ,PS?BUZZ-WORD>)
			(<EQUAL? .WRD ,W?AND ,W?COMMA>)
			(<==? .WRD ,W?OF>
			 <COND (<0? ,P-GETFLAGS>
				<SETG P-GETFLAGS ,P-INHIBIT>)>)
			(<AND <SET WV <WT? .WRD ,PS?ADJECTIVE ,P1?ADJECTIVE>>
			      <ADJ-CHECK .WRD>
			      <NOT <EQUAL? .NW ,W?OF>>> ;"RFIX NO. 40"
			 <SETG P-ADJ .WV>
			 <SETG P-ADJN .WRD>)
			(<WT? .WRD ,PS?OBJECT ,P1?OBJECT>
			 <SETG P-NAM .WRD>
			 <SETG P-ONEOBJ .WRD>)>)>
	   <COND (<NOT <==? .PTR .EPTR>>
		  <SET PTR <REST .PTR ,P-WORDLEN>>
		  <SET WRD .NW>)>>>

<ROUTINE BUZZER-WORD? (WORD)     ;"Only DIRTY-WORD - LIGHT-WEIGHT? remains"
         <COND (<EQUAL? .WORD ,W?SAY>
	        <TELL-SEE-MANUAL>
		<RTRUE>)
               (<OR <DIRTY-WORD? .WORD> ;"stopped in clean-talk?"
		    <LIGHT-WEIGHT? .WORD>> 
	        <COND (<EQUAL? ,FOLLOW-FLAG 7>
		       <TELL "It didn't hurt that much." CR>)
		      (T
		       <TELL "[That's uncalled for.]" CR>)>
		<RTRUE>)               
               ;(<OR <EQUAL? .WORD ,W?NW ,W?NORTHW ,W?NE>
	            <EQUAL? .WORD ,W?SW ,W?SOUTHW ,W?NORTHE>
	            <EQUAL? .WORD ,W?SE ,W?SOUTHE>>
	        ;<TELL "(You don't need to use \"">
	        ;<PRINTB .WORD>
	        ;<TELL "\" directions in this story.)" CR>
		;<V-BAD-DIRECTION>
		;<RTRUE>)	       
	       ;(<EQUAL? .WORD ,W?MOUSE ,W?RAT ,W?RODENT>
		<COND (<AND <EQUAL? ,HERE ,INSIDE-CHURCH>
			    <NOT <FSET? ,CHURCH ,TOUCHBIT>>>
		       <TELL 
"It disappeared before you could get a good look." CR>)
		      (T
		       <CANT-SEE-ANY>)>
		<RTRUE>)	       
	       ;(<AND <EQUAL? .WORD ,W?FUZZY ,W?BLURRY ,W?BLURRED>
		     <NOT ,FUZZY?>>
		<TELL ,YOU-SEE "nothing ">
		<PRINTB .WORD>
		<TELL " here!" CR>
		<RTRUE>)
	       ;(<EQUAL? .WORD ,W?CORKY>
		<COND (<IN? ,CRISP ,HERE>
		       <TELL D ,CRISP 
" reddens. \"Don't use that name in front of me!\"">)
		      (T
		       <TELL "(" D ,CRISP 
			     " hates it when you use that name!)">)>
		<CRLF>
		<RTRUE>)
	       (T
		<RFALSE>)>>

<GLOBAL CURSE-C 0>

<GLOBAL CURSED-ONCE? <>>

<ROUTINE CLEAN-TALK? (WORD)
	 <COND (<RUNNING? ,I-CURSE>
		;<L? ,P-LEN 1>
		<SETG P-CONT <>>
		<SETG CURSE-C <+ ,CURSE-C 1>>		
	        <COND (<EQUAL? ,HERE ,APE-ROOM>
		       <COND (<DIRTY-WORD? .WORD>
			      <TELL D ,APE " takes it as an insult. He">)
			     (<LIGHT-WEIGHT? .WORD>
			      <TELL 
"No respecter of nuance in language, " D ,APE>)
			     (T
			      <TELL "No time for that. " D ,APE>)>
		       <LUGGAGE>
		       <RTRUE>)		       
		      (<DIRTY-WORD? .WORD>
		       <TELL <PICK-ONE ,TOO-DIRTY> CR>)
		      (<LIGHT-WEIGHT? .WORD>
       		       <COND (,CURSED-ONCE?
			      <SETG CURSED-ONCE? <>>
			      <DISABLE <INT I-CURSE>>
			      <TELL 
"Cut! Cut! Okay, that's a wrap." CR>)
			     (T
			      <SETG CURSED-ONCE? T>
			      <TELL
"Bravisimo! Once more now, with feeling." CR>)>)
		      (<G? ,CURSE-C 4>
		       <SETG CURSE-C 0>
		       <DISABLE <INT I-CURSE>>
		       <TELL 
"You've lost the opportunity to curse the pain, and it overtakes you:
\"Aaaaaaaarrrrrrrrrrgggggggghhhhhhh.\"" CR>)
		      (T
		       <TELL <PICK-ONE ,COACH> CR>)>)		      
	       (T
		<RFALSE>)>>

<BUZZ FUCK FUCKED CURSE GODDAMNED CUSS DAMN SHIT ASSHOLE CUNT
      SHITHEAD PISS BASTARD SCREW FUCKING DAMNED PEE COCKSUCKER BITCH
      HELL SHUCKS HECK DARN FUDGE DAGNAB DRAT SHOOT OUCH>

<ROUTINE DIRTY-WORD? (WORD)
         <COND (<OR <EQUAL? .WORD ,W?SHIT ,W?FUCK ,W?BITCH>
	            <EQUAL? .WORD ,W?SHITHEAD ,W?PISS ;,W?SUCK>
	            <EQUAL? .WORD ,W?BASTARD ,W?SCREW ,W?FUCKING>
		    <EQUAL? .WORD ,W?FUCKED ,W?CUNT ,W?ASSHOLE>
		    <EQUAL? .WORD ,W?GODDAMNED ,W?COCKSUCKER>>
		<RTRUE>)
	       (T
		<RFALSE>)>>
	        
<ROUTINE LIGHT-WEIGHT? (WORD)
	 <COND (<OR <EQUAL? .WORD ,W?CURSE ,W?DAMN ,W?DAMNED>
		    <EQUAL? .WORD ,W?HELL ,W?DARN ,W?SHUCKS>
		    <EQUAL? .WORD ,W?PEE ,W?FUDGE ,W?HECK>
		    <EQUAL? .WORD ,W?CUSS ,W?DAGNAB ,W?OUCH>
		    <EQUAL? .WORD ,W?DRAT ,W?SHOOT>>
		<RTRUE>)
	       (T
		<RFALSE>)>>

;<ROUTINE ADJ-CHECK (WRD) ;"original ADJ-CHECK"
	 <COND (<NOT ,P-ADJ>
		<RTRUE>)
	       (<EQUAL? ,P-ADJ ,W?INNER ,W?OUTER>
		<RFALSE>)
	       (T
		<RTRUE>)>>

;"this ADJ-CHECK will grab the first adjective rather than the last, unless it
  comes across INNER or OUTER"
<ROUTINE ADJ-CHECK (WRD)
	 <COND (<NOT ,P-ADJ>
		<RTRUE>)
	       ;(<EQUAL? .WRD ,W?INNER ,W?OUTER>
		<RTRUE>)>>		

<CONSTANT SH 128>   
 
<CONSTANT SC 64>    
 
<CONSTANT SIR 32>   
 
<CONSTANT SOG 16>   
 
<CONSTANT STAKE 8>  
 
<CONSTANT SMANY 4>  
 
<CONSTANT SHAVE 2>  

<GLOBAL NOUN-MISSING "[There seems to be a noun missing in that sentence.]">

<ROUTINE GET-OBJECT (TBL "OPTIONAL" (VRB T)
		      "AUX" ;GEN BITS LEN XBITS TLEN (GCHECK <>) (OLEN 0) OBJ)
	 <SET XBITS ,P-SLOCBITS>
	 <SET TLEN <GET .TBL ,P-MATCHLEN>>
	 <COND (<BTST ,P-GETFLAGS ,P-INHIBIT> <RTRUE>)>
	 <COND (<AND <NOT ,P-NAM> ,P-ADJ>
		<COND (<WT? ,P-ADJN ,PS?OBJECT ,P1?OBJECT>
		       <SETG P-NAM ,P-ADJN>
		       <SETG P-ADJ <>>)
		      (<SET BITS <WT? ,P-ADJN ,PS?DIRECTION ,P1?DIRECTION>>
		       <SETG P-DIRECTION .BITS>)>)> ;"Added by JW 4-17-85"
	 <COND (<AND <NOT ,P-NAM>
		     <NOT ,P-ADJ>
		     <NOT <==? ,P-GETFLAGS ,P-ALL>>
		     <0? ,P-GWIMBIT>>
		<COND (.VRB
			  ;<NOT <EQUAL? ,P-PRSA-WORD ,W?LEAN>> ;"added JO"
		       <TELL ,NOUN-MISSING CR>)>
		<RFALSE>)>
	 <COND (<OR <NOT <==? ,P-GETFLAGS ,P-ALL>> <0? ,P-SLOCBITS>>
		<SETG P-SLOCBITS -1>)>
	 <SETG P-TABLE .TBL>
	 <PROG ()
	       <COND (.GCHECK <GLOBAL-CHECK .TBL>)
		     (T
		      <COND (,LIT
			     <FCLEAR ,PLAYER ,TRANSBIT>
			     <DO-SL ,HERE ,SOG ,SIR>
			     <FSET ,PLAYER ,TRANSBIT>)>
		      <DO-SL ,PLAYER ,SH ,SC>)>
	       <SET LEN <- <GET .TBL ,P-MATCHLEN> .TLEN>>
	       <COND (<BTST ,P-GETFLAGS ,P-ALL> ;<AND * <NOT <EQUAL? .LEN 0>>>)
		     (<AND <BTST ,P-GETFLAGS ,P-ONE>
			   <NOT <0? .LEN>>> ;"WAS semied JO - 8/31/85"
		      <COND (<NOT <==? .LEN 1>>
			     <PUT .TBL 1 <GET .TBL <RANDOM .LEN>>>
			     <TELL "[How about the ">
			     <DPRINT <GET .TBL 1>>
			     <TELL "?]" CR>)>
		      <PUT .TBL ,P-MATCHLEN 1>)
		     (<OR <G? .LEN 1>
			  <AND <0? .LEN> <NOT <==? ,P-SLOCBITS -1>>>>
		      <COND (<==? ,P-SLOCBITS -1>
			     <SETG P-SLOCBITS .XBITS>
			     <SET OLEN .LEN>
			     <PUT .TBL
				  ,P-MATCHLEN
				  <- <GET .TBL ,P-MATCHLEN> .LEN>>
			     <AGAIN>)
			    (T
			     <PUT ,P-NAMW ,P-PHR ,P-NAM>
	                     <PUT ,P-ADJW ,P-PHR ,P-ADJN>
			     <COND (<ZERO? .LEN> 
				    <SET LEN .OLEN>)>
			     <COND (<AND ,P-NAM
				      <SET OBJ <GET .TBL <+ .TLEN 1>>>
				      <SET OBJ <APPLY <GETP .OBJ ,P?GENERIC>>>>
				    <COND (<EQUAL? .OBJ ,NOT-HERE-OBJECT>
					   <RFALSE>)>
				    <PUT .TBL 1 .OBJ>
				    <PUT .TBL ,P-MATCHLEN 1>
				    <SETG P-NAM <>>
				    <SETG P-ADJ <>>
				    <RTRUE>)
			      	   (<AND .VRB ;".VRB added 8/14/84 by JW"
					 <NOT <==? ,WINNER ,PROTAGONIST>>>
				    <CANT-ORPHAN>
				    <SETG P-NAM <>>
				    <SETG P-ADJ <>>
				    <RFALSE>)
				   (<AND .VRB ,P-NAM>
				    <WHICH-PRINT .TLEN .LEN .TBL>
				    <SETG P-ACLAUSE
					  <COND (<==? .TBL ,P-PRSO> ,P-NC1)
						(T ,P-NC2)>>
				    <SETG P-AADJ ,P-ADJ>
				    <SETG P-ANAM ,P-NAM>
				    <ORPHAN <> <>>
				    <SETG P-OFLAG T>)
				   (.VRB               ;"added JO"
					 ;<NOT <EQUAL? ,P-PRSA-WORD ,W?LEAN>>
				    <TELL ,NOUN-MISSING CR>)>
			     <SETG P-NAM <>>
			     <SETG P-ADJ <>>
			     <RFALSE>)>)>
	       <COND (<AND <0? .LEN> .GCHECK>
		      <PUT ,P-NAMW ,P-PHR ,P-NAM>
	              <PUT ,P-ADJW ,P-PHR ,P-ADJN>
		      <COND (.VRB
			     <SETG P-SLOCBITS .XBITS>
			     <COND (<OR ,LIT
					<EQUAL? ,PRSA ,V?TELL>
					<EQUAL? ,PRSA ,V?WHERE ,V?WHAT ,V?WHO>>
				    ;"Changed 6/10/83 - MARC"
				    <OBJ-FOUND ,NOT-HERE-OBJECT .TBL>
				    <SETG P-XNAM ,P-NAM>
				    <SETG P-XADJ ,P-ADJ>
				    <SETG P-XADJN ,P-ADJN>
				    <SETG P-NAM <>>
				    <SETG P-ADJ <>>
				    <SETG P-ADJN <>>
				    <RTRUE>)
				   (T
				    <TELL ,TOO-DARK CR>)>)>
		      <SETG P-NAM <>>
		      <SETG P-ADJ <>>
		      <RFALSE>)
		     (<0? .LEN> <SET GCHECK T> <AGAIN>)>
	       <SETG P-SLOCBITS .XBITS>
	       <PUT ,P-NAMW ,P-PHR ,P-NAM>
	       <PUT ,P-ADJW ,P-PHR ,P-ADJN>
	       <SETG P-NAM <>>
	       <SETG P-ADJ <>>
	       <RTRUE>>>

<CONSTANT LAST-OBJECT 0>  ;"ZILCH should stick the # of the last object here"

<ROUTINE MOBY-FIND (TBL "AUX" (OBJ 1) LEN FOO NAM ADJ)
  <SET NAM ,P-NAM>
  <SET ADJ ,P-ADJ>
  <SETG P-NAM ,P-XNAM>
  <SETG P-ADJ ,P-XADJ>
  ;<COND (,DEBUG
	 <TELL "[MOBY-FIND called, P-NAM=">
	 <PRINTB ,P-NAM>
	 <TELL "]" CR>)>
  <PUT .TBL ,P-MATCHLEN 0>
  %<COND (<GASSIGNED? ZILCH>	;<NOT <ZERO? <GETB 0 18>>>	;"ZIP case"
	 '<PROG ()
	 <REPEAT ()
		 <COND (<AND ;<SET FOO <META-LOC .OBJ T>>
			     <NOT <IN? .OBJ ,ROOMS>>
			     <SET FOO <THIS-IT? .OBJ>>>
			<SET FOO <OBJ-FOUND .OBJ .TBL>>)>
		 <COND (<IGRTR? OBJ ,LAST-OBJECT>
			<RETURN>)>>>)
	(T		;"ZIL case"
	 '<PROG ()
	 <SETG P-SLOCBITS -1>
	 <SET FOO <FIRST? ,ROOMS>>
	 <REPEAT ()
		 <COND (<NOT .FOO>
			<RETURN>)
		       (T
			<SEARCH-LIST .FOO .TBL ,P-SRCALL T>
			<SET FOO <NEXT? .FOO>>)>>
	 <DO-SL ,LOCAL-GLOBALS 1 1 .TBL T>
	 <SEARCH-LIST ,ROOMS .TBL ,P-SRCTOP T>>)>
  <COND (<EQUAL? <SET LEN <GET .TBL ,P-MATCHLEN>> 1>
	 <SETG P-MOBY-FOUND <GET .TBL 1>>)>
  <SETG P-NAM .NAM>
  <SETG P-ADJ .ADJ>
  <RETURN .LEN>>

;<ROUTINE MOBY-FIND (TBL "AUX" FOO LEN)
	 <SETG P-MOBY-FLAG T>
	 <SETG P-SLOCBITS -1>
	 <SETG P-TABLE .TBL>
	 <SETG P-NAM ,P-XNAM>
	 <SETG P-ADJ ,P-XADJ>
	 <PUT .TBL ,P-MATCHLEN 0>
	 <SET FOO <FIRST? ,ROOMS>>
	 <REPEAT ()
		 <COND (<NOT .FOO> <RETURN>)
		       (T
			<SEARCH-LIST .FOO .TBL ,P-SRCALL>
			<SET FOO <NEXT? .FOO>>)>>
	 <DO-SL ,LOCAL-GLOBALS 1 1>
	 <SEARCH-LIST ,ROOMS .TBL ,P-SRCTOP>
	 <COND (<EQUAL? <SET LEN <GET .TBL ,P-MATCHLEN>> 1>
		<SETG P-MOBY-FOUND <GET .TBL 1>>)>
	 <SETG P-MOBY-FLAG <>>
	 <SETG P-NAM <>>
	 <SETG P-ADJ <>>
	 .LEN>

<GLOBAL P-MOBY-FOUND <>>   
<GLOBAL P-MOBY-FLAG <>>
<GLOBAL P-XNAM <>>
<GLOBAL P-XADJ <>>
<GLOBAL P-XADJN <>>

<ROUTINE WHICH-PRINT (TLEN LEN TBL "AUX" OBJ RLEN)
	 <SET RLEN .LEN>
	 <TELL "[Which">
         <COND (<OR ,P-OFLAG
		    ,P-MERGED
		    ,P-AND>
		<TELL " ">
		<PRINTB ,P-NAM>)
	       (<EQUAL? .TBL ,P-PRSO>
		<CLAUSE-PRINT ,P-NC1 ,P-NC1L <>>)
	       (T
		<CLAUSE-PRINT ,P-NC2 ,P-NC2L <>>)>
	 <TELL " do you mean, ">
	 <REPEAT ()
		 <SET TLEN <+ .TLEN 1>>
		 <SET OBJ <GET .TBL .TLEN>>
		 <COND (<NOT <FSET? .OBJ ,NARTICLEBIT>>
			<TELL "the ">)>
		 <TELL D .OBJ>
		 <COND (<EQUAL? .LEN 2>
		        <COND (<NOT <EQUAL? .RLEN 2>>
			       <TELL ",">)>
		        <TELL " or ">)
		       (<G? .LEN 2>
			<TELL ", ">)>
		 <COND (<L? <SET LEN <- .LEN 1>> 1>
		        <TELL "?]" CR>
		        <RETURN>)>>>

<ROUTINE GLOBAL-CHECK (TBL "AUX" LEN RMG RMGL (CNT 0) OBJ OBITS FOO)
	<SET LEN <GET .TBL ,P-MATCHLEN>>
	<SET OBITS ,P-SLOCBITS>
	<COND (<SET RMG <GETPT ,HERE ,P?GLOBAL>>
	       <SET RMGL <- <PTSIZE .RMG> 1>>
	       <REPEAT ()
		       <COND (<THIS-IT? <SET OBJ <GETB .RMG .CNT>>>
			      <OBJ-FOUND .OBJ .TBL>)>
		       <COND (<IGRTR? CNT .RMGL> <RETURN>)>>)>
	<COND (<SET RMG <GETPT ,HERE ,P?PSEUDO>>
	       <SET RMGL <- </ <PTSIZE .RMG> 4> 1>>
	       <SET CNT 0>
	       <REPEAT ()
		       <COND (<==? ,P-NAM <GET .RMG <* .CNT 2>>>
			      <SETG LAST-PSEUDO-LOC ,HERE>
			      <PUTP ,PSEUDO-OBJECT
				    ,P?ACTION
				    <GET .RMG <+ <* .CNT 2> 1>>>
			      <SET FOO
				   <BACK <GETPT ,PSEUDO-OBJECT ,P?ACTION> 5>>
			      <PUT .FOO 0 <GET ,P-NAM 0>>
			      <PUT .FOO 1 <GET ,P-NAM 1>>
			      <OBJ-FOUND ,PSEUDO-OBJECT .TBL>
			      <RETURN>)
		             (<IGRTR? CNT .RMGL> <RETURN>)>>)>
	<COND (<==? <GET .TBL ,P-MATCHLEN> .LEN>
	       <SETG P-SLOCBITS -1>
	       <SETG P-TABLE .TBL>
	       <DO-SL ,GLOBAL-OBJECTS 1 1>
	       <SETG P-SLOCBITS .OBITS>
	       ;<COND (<AND <0? <GET .TBL ,P-MATCHLEN>>
			   <EQUAL? ,PRSA ,V?LOOK-INSIDE ,V?SEARCH ,V?EXAMINE>>
		      <DO-SL ,ROOMS 1 1>)>)>>
 
<ROUTINE DO-SL (OBJ BIT1 BIT2 "AUX" BTS)
	<COND (<BTST ,P-SLOCBITS <+ .BIT1 .BIT2>>
	       <SEARCH-LIST .OBJ ,P-TABLE ,P-SRCALL>)
	      (T
	       <COND (<BTST ,P-SLOCBITS .BIT1>
		      <SEARCH-LIST .OBJ ,P-TABLE ,P-SRCTOP>)
		     (<BTST ,P-SLOCBITS .BIT2>
		      <SEARCH-LIST .OBJ ,P-TABLE ,P-SRCBOT>)
		     (T <RTRUE>)>)>>  
 
<CONSTANT P-SRCBOT 2>    
 
<CONSTANT P-SRCTOP 0>    
 
<CONSTANT P-SRCALL 1>    
 
<ROUTINE SEARCH-LIST (OBJ TBL LVL "AUX" FLS NOBJ)
	<COND (<SET OBJ <FIRST? .OBJ>>
	       <REPEAT ()
		       <COND (<AND <NOT <==? .LVL ,P-SRCBOT>>
				   <GETPT .OBJ ,P?SYNONYM>
				   <THIS-IT? .OBJ>>
			      <OBJ-FOUND .OBJ .TBL>)>
		       <COND (<AND <OR <NOT <==? .LVL ,P-SRCTOP>>
				       <FSET? .OBJ ,SEARCHBIT>
				       <FSET? .OBJ ,SURFACEBIT>>
				   <SET NOBJ <FIRST? .OBJ>>>
			      <COND (<OR <FSET? .OBJ ,OPENBIT>
					 <FSET? .OBJ ,TRANSBIT>
					 ,P-MOBY-FLAG>
				     <SET FLS
					  <SEARCH-LIST
					   .OBJ
					   .TBL
					   <COND (<FSET? .OBJ ,SURFACEBIT>
						  ,P-SRCALL)
						 (<FSET? .OBJ ,SEARCHBIT>
						  ,P-SRCALL)
						 (T ,P-SRCTOP)>>>)>)>
		       <COND (<SET OBJ <NEXT? .OBJ>>) (T <RETURN>)>>)>> 
 
<ROUTINE OBJ-FOUND (OBJ TBL "AUX" PTR)
	<SET PTR <GET .TBL ,P-MATCHLEN>>
	<PUT .TBL <+ .PTR 1> .OBJ>
	<PUT .TBL ,P-MATCHLEN <+ .PTR 1>>>

<ROUTINE TAKE-CHECK () 
	<AND <ITAKE-CHECK ,P-PRSO <GETB ,P-SYNTAX ,P-SLOC1>>
	     <ITAKE-CHECK ,P-PRSI <GETB ,P-SYNTAX ,P-SLOC2>>>> 

;"the original for circus - with money added below to return true"
<ROUTINE ITAKE-CHECK (TBL IBITS "AUX" PTR OBJ TAKEN) ;"changed by MARC 11/83"
   <COND (<AND <SET PTR <GET .TBL ,P-MATCHLEN>>
	       <OR <BTST .IBITS ,SHAVE>
	           <BTST .IBITS ,STAKE>>>
	  <REPEAT ()
	    <COND (<L? <SET PTR <- .PTR 1>> 0>
		   <RETURN>)
		  (T
		   <SET OBJ <GET .TBL <+ .PTR 1>>>
		   <COND (<==? .OBJ ,IT>
			  <COND (<NOT <ACCESSIBLE? ,P-IT-OBJECT>>
				 <TELL ,REFERRING CR>
				 <RFALSE>)
				(T
				 <SET OBJ ,P-IT-OBJECT>)>)>
		   <COND (<OR <HELD? .OBJ>                    ;"added JO"
	                      <EQUAL? .OBJ ,GLOBAL-MONEY ,INTNUM ,HANDS>
			      <EQUAL? .OBJ ,DOLLAR>
			      <AND <EQUAL? ,HERE ,LEFT-HANGING>
				   <EQUAL? .OBJ ,TIGHTROPE-OBJECT>>>
			  T)
			 (T
			  <SETG PRSO .OBJ>
			  <COND (<FSET? .OBJ ,TRYTAKEBIT>
				 <SET TAKEN T>)
				(<NOT <==? ,WINNER ,PROTAGONIST>>
				 <SET TAKEN <>>)
				(<AND <BTST .IBITS ,STAKE>
				      <EQUAL? <ITAKE <>> T>>
				 <SET TAKEN <>>)
				(T
				 <SET TAKEN T>)>
			  <COND (<AND .TAKEN <BTST .IBITS ,SHAVE>>
				 <COND (<L? 1 <GET .TBL ,P-MATCHLEN>>
				        <TELL ,NOT-HOLDING
					      " all those things!">
					<CRLF>
					<RFALSE>)
				       (<EQUAL? .OBJ ,NOT-HERE-OBJECT>
					<COND (<AND <EQUAL? ,HERE ,PARLOR>
						    <EQUAL? .OBJ ,PRSO>>
					       <CANT-SEE ,PRSO>)
				       	      (T
					       <CANT-SEE <> "that">)>
					<RFALSE>)>
				 <COND (<EQUAL? ,WINNER ,PROTAGONIST>
					<TELL ,NOT-HOLDING>)
				       (T
					<TELL "It doesn't look like">
					<ARTICLE ,WINNER T>
					<TELL " is holding">)>
				 <ARTICLE .OBJ T>
				 <SETG P-IT-OBJECT .OBJ>
				 <TELL ,PERIOD>
				 <RFALSE>)
				(<AND <NOT .TAKEN>
				      <==? ,WINNER ,PROTAGONIST>>
				 <TELL "[Taking">
				 <ARTICLE .OBJ T>
				 <TELL " first]" CR>)>)>)>>)
	       (T)>>

;"From JW Western - with money stuff -- ABORTED"
;<ROUTINE ITAKE-CHECK (TBL BITS "AUX" PTR OBJ TAKEN)
	 <COND (<AND <SET PTR <GET .TBL ,P-MATCHLEN>>
		     <OR <BTST .BITS ,SHAVE>
			 <BTST .BITS ,STAKE>>>
		<REPEAT ()
			<COND (<L? <SET PTR <- .PTR 1>> 0> <RETURN>)
			      (T
			       <SET OBJ <GET .TBL <+ .PTR 1>>>
			       <COND (<==? .OBJ ,IT>
				      <COND (<NOT <ACCESSIBLE? ,P-IT-OBJECT>>
					     <TELL ,REFERRING CR>
					     <RFALSE>)
					    (T <SET OBJ ,P-IT-OBJECT>)>)
				     ;(<==? .OBJ ,HIM-HER>
				      <SET OBJ ,P-HIM-HER>)>
			       <COND (<NOT <HELD? .OBJ>>
				      <SETG PRSO .OBJ>
				      <COND (<FSET? .OBJ ,TRYTAKEBIT>
					     <SET TAKEN T>)
					    (<NOT <==? ,WINNER ,PROTAGONIST>>
					     <SET TAKEN <>>)
					    (<AND <BTST .BITS ,STAKE>
						  <==? <ITAKE <>> T>>
					     <SET TAKEN <>>)
					    (T <SET TAKEN T>)>
				      <COND (<AND .TAKEN <BTST .BITS ,SHAVE>>
					     <COND ;(<OR
						     <EQUAL? .OBJ ,GLOBAL-MONEY
						     ;,RIDICULOUS-MONEY-KLUDGE>
						     <AND <==? .OBJ ,INTNUM>
							  ,P-DOLLAR-FLAG>
						     <AND <==? .OBJ ,IT>
						      <EQUAL? ,P-IT-OBJECT
						      ;,RIDICULOUS-MONEY-KLUDGE
						       ,INTNUM ,GLOBAL-MONEY>>>
						 <TELL "You can't afford to.">)
						    (T
						     <TELL "You don't have ">
					     	     <COND (<EQUAL? .OBJ
							      ,NOT-HERE-OBJECT>
						    	    <TELL "that." CR>)
						   	   (T
						    	   <ARTICLE .OBJ>
							   <TELL ,PERIOD>)>)>
					     <RFALSE>)
					    (<AND <NOT .TAKEN>
						  <==? ,WINNER ,PROTAGONIST>>
					     <TELL "[taking ">
					     <COND (<OR <G?
							 <GET ,P-PRSI
							      ,P-MATCHLEN>
							 0>
							<G?
							 <GET .TBL ,P-MATCHLEN>
							 1>>
						    <THE? .OBJ>
						    <TELL D .OBJ>)
						   (T <TELL "it">)>
					     <TELL " first]" CR>)>)>)>>)
	       (T)>>

<ROUTINE MANY-CHECK ("AUX" (LOSS <>) TMP)
	<COND (<AND <G? <GET ,P-PRSO ,P-MATCHLEN> 1>
		    <NOT <BTST <GETB ,P-SYNTAX ,P-SLOC1> ,SMANY>>>
	       <SET LOSS 1>)
	      (<AND <G? <GET ,P-PRSI ,P-MATCHLEN> 1>
		    <NOT <BTST <GETB ,P-SYNTAX ,P-SLOC2> ,SMANY>>>
	       <SET LOSS 2>)>
	<COND (.LOSS
	       <TELL "[You can't use multiple ">
	       <COND (<EQUAL? .LOSS 2>
		      <TELL "in">)>
	       <TELL "direct objects with \"">
	       <SET TMP <GET ,P-ITBL ,P-VERBN>>
	       <COND (<0? .TMP>
		      <TELL "tell">)
		     (<OR ,P-OFLAG ,P-MERGED>
		      <PRINTB <GET .TMP 0>>)
		     (T
		      <WORD-PRINT <GETB .TMP 2> <GETB .TMP 3>>)>
	       <TELL ".\"]" CR>
	       <RFALSE>)
	      (T)>>  
 
<ROUTINE ZMEMQ (ITM TBL "OPTIONAL" (SIZE -1) "AUX" (CNT 1)) 
	<COND (<NOT .TBL> <RFALSE>)>
	<COND (<NOT <L? .SIZE 0>> <SET CNT 0>)
	      (ELSE <SET SIZE <GET .TBL 0>>)>
	<REPEAT ()
		<COND (<==? .ITM <GET .TBL .CNT>> <RTRUE>)
		      (<IGRTR? CNT .SIZE> <RFALSE>)>>>    

<ROUTINE ZMEMQB (ITM TBL SIZE "AUX" (CNT 0)) 
	<REPEAT ()
		<COND (<EQUAL? .ITM <GETB .TBL .CNT>>
		       <RTRUE>)
		      (<IGRTR? CNT .SIZE>
		       <RFALSE>)>>>

<ROUTINE LIT? (RM "OPTIONAL" (RMBIT T) "AUX" OHERE (LIT <>))
	<SETG P-GWIMBIT ,ONBIT>
	<SET OHERE ,HERE>
	<SETG HERE .RM>
	<COND (<AND .RMBIT
		    <FSET? .RM ,ONBIT>>
	       <SET LIT T>)
	      (T
	       <PUT ,P-MERGE ,P-MATCHLEN 0>
	       <SETG P-TABLE ,P-MERGE>
	       <SETG P-SLOCBITS -1>
	       <COND (<EQUAL? .OHERE .RM>
		      <DO-SL ,WINNER 1 1>
		      <COND (<AND <NOT <EQUAL? ,WINNER ,PLAYER>>
				  <IN? ,PLAYER .RM>>
			     <DO-SL ,PLAYER 1 1>)>)>
	       <DO-SL .RM 1 1>
	       <COND (<G? <GET ,P-TABLE ,P-MATCHLEN> 0>
		      <SET LIT T>)>)>
	<SETG HERE .OHERE>
	<SETG P-GWIMBIT 0>
	.LIT>

<ROUTINE PRSO-PRINT ("AUX" PTR)
	 <COND (<OR ,P-MERGED
		    <==? <GET <SET PTR <GET ,P-ITBL ,P-NC1>> 0> ,W?IT>>
		<TELL " " D ,PRSO>)
	       (T <BUFFER-PRINT .PTR <GET ,P-ITBL ,P-NC1L> <>>)>>

<ROUTINE PRSI-PRINT ("AUX" PTR)
	 <COND (<OR ,P-MERGED
		    <==? <GET <SET PTR <GET ,P-ITBL ,P-NC2>> 0> ,W?IT>>
		<TELL " " D ,PRSO>)
	       (T <BUFFER-PRINT .PTR <GET ,P-ITBL ,P-NC2L> <>>)>>

;"former CRUFTY.ZIL routine"

<ROUTINE THIS-IT? (OBJ "AUX" SYNS) 
 <COND (<FSET? .OBJ ,INVISIBLE> <RFALSE>)
       (<AND ,P-NAM
	     <NOT <ZMEMQ ,P-NAM
			 <SET SYNS <GETPT .OBJ ,P?SYNONYM>>
			 <- </ <PTSIZE .SYNS> 2> 1>>>>
	<RFALSE>)
       (<AND ,P-ADJ
	     <OR <NOT <SET SYNS <GETPT .OBJ ,P?ADJECTIVE>>>
		 <NOT <ZMEMQB ,P-ADJ .SYNS <- <PTSIZE .SYNS> 1>>>>>
	<RFALSE>)
       (<AND <NOT <0? ,P-GWIMBIT>> <NOT <FSET? .OBJ ,P-GWIMBIT>>>
	<RFALSE>)>
 <RTRUE>>