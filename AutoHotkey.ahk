
;##############  Initialize 
	/*
		2017-08-17 10.00
			Onlythings that needs to be in the beginning here 
			*/

	#SingleInstance force
		/*
		; Ensures that only the last executed instance of script is running
		2018-03-04 11.16
			moved here due to it not working at previous location 
		*/
		if not A_IsAdmin ; added 2017-09-26 11.52 to fix Everything and PDF Annotator issue  
			{
			Run *RunAs "%A_ScriptFullPath%"  ; Requires v1.0.92.01+
			ExitApp
			}

			SetCapslockState, Off 	; Turns of capslock if it is active when script is loaded (requires that capslock is not pressed while AutoHotkey is loading 
					; 2016-07-16 10.25 Added this to solve issue of capslock getting stuck if it is pressed during reload of AutoHotkey script (or active when AutoHotkey is activated)
				; this solves everything except when capslock is pressed while AutoHotkey is reloading.
			
			SetStoreCapslockMode, Off ;2015-11-13 seems to have solved all capslock problems 
			;$Capslock up:: SetStoreCapslockMode, Off ; this causes problems 
			SetCapslockState, AlwaysOff ; this solves previous issues (many) with using CapsLock at end of sentence. This has to be in the beginning to work properly  
					; if I use ANY OF THESE, above stops working 
						;$~CapsLock::SetCapsLockState, AlwaysOff ; 2014-07-21: should solve most CapsLock issues, BUT does not: [CapsLock:: return]
						;$~CapsLock up::SetCapsLockState Off ; 2014-07-21: should solve most CapsLock issues, BUT does not: [CapsLock:: return]
						;CapsLock::return 
						;^CapsLock:: 
							;; Toggle CapsLock:
							;If GetKeyState("CapsLock", "T"	)
							;SetCapsLockState Off
							;Else
							;SetCapsLockState On
						;Return 
			; SetControlState, Off 
			; SetStoreCapslockMode
		#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
			; SendMode Input  ; Recommended for new scripts due to its superior speed and reliability. 2018-02-27 11.35	commenting out sendmode input seems to have decreased StuckKey problems 
			SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
			SetTitleMatchMode 2 ; 2015-11-17 10.17 should not set use matchmode 3 due to PDF Annotator 
				; '˜UWinActive' matches based on keywords anywhere in title
				; a good alternative is regex
				; http://ahkscript.org/docs/commands/SetTitleMatchMode.htm 		
			; things added when getting right click volume control to work 
		; Recommended by StackOverflow AutoHotkey user 
			Process, Priority, ,High 
			;#InstallMouseHook ; 
			#InstallKeybdHook 
			; 2018-02-27 13.31 not sure it makes a difference regarding StuckKey
			; 2017-09-26 11.25 was commented out, testing uncommenting 
			#UseHook 
			; #EscapeChar \ ; this makes "\" the escape character, default is "`"

;##############  Include Scripts (
	; #Include C:\My Documents\Scripts\Utility Subroutines.ahk
	; #Include %A_ScriptDir%  ; Changes the working directory for subsequent #Includes and FileInstalls.
	; #Include C:\My Scripts  ; Same as above but for an explicitly named directory.

;##############  Functions  
	/*
	Reminders
		reverse chronological 
		having sleep >100 may be needed in order to prevent AutoHotkey from getting a key stuck 
		I think that all functions should end with return 
	To do 
		Evaluate 2017-12-01 solution 
		If not working 
			Evaluate other solution xstuck""
	Documentation
		2016-02-20 12.24 
			moved all global functions here 
	*/

	; StuckKeyUp 
		/*
		still getting the following keys stuck 
			^ 
			§ 
			! 
		added several things to try to solve this 
		
		2018-04-26 11.07
			added similar setting as for capslock
		2018-02-27 09.28
			added reload back temporarily yyy working here 
		2018-02-26 17.24
			on WRKPC Windows 10 the problem is ~ every time AltGr is used with together with some keys (not clear why only some keys, seems to be possibly due to AutoHotkey causing it)
		2017-06-01 19.39
			I think every combination needs to be sending same StuckKeyUp command including capslock 
		2017-04-28 12.11
		2018-02-26 16.57
			added capslock to activate StuckKeyUp 
			added eye based on 
				https://autohotkey.com/board/topic/3248-stuck-ctrl-key/page-2
				did not work at all 
		2017-12-15 10.58
			still issues with control getting stuck in 4h0 commands 
			it goes away from clicking <^, so should be possible to fix here 
		2017-12-01 12.01
			Commented out old way of sending control up etc and added new way (under evaluation). 
			Old way was working 
		2017-08-08 12.28
			removed reload so as to have StuckKeyUp anywhere in scripts 
		2017-07-04 22.10
			testing removing all combinations 
		2017-05-13 13.34
			should continue developing it 
			works in some situations 
			not sure that it should reload every time (may want to create version without constant relog reloading 
		*/
		;##############  Control Stuck control up (
			/*
			2018-04-06 11.51
				commented out everything here to see if this solves strange control not working (when performing ^c or ^x the control key is not working sometimes)
			2018-04-06 11.22
				expanded what is captured to make sure that control key never gets stuck 
			2018-04-04 14.10
				added below 
			*/
			
			; SetControlState, Off 

			; GetKeyState, stateRCtrl, RCtrl
			; GetKeyState, stateLCtrl, LCtrl

				; if stateLCtrl=D
				; Send {Ctrl Up}{Shift Up}
				; else 
				; Send {Ctrl Up}{Shift Up}
				; return 

			; Send {Ctrl Up}{Shift Up}
			; Send confirmation 1 ; this shows that this never gets activated 
			; return 


		#capslock up:: 
		!capslock up:: 
		^!capslock up::
		^capslock up:: 
		^capslock:: 
		capslock up:: 
		; $Capslock:: Send {Ctrl down}  ; tested does not work 2018-02-26 17.22 *
		; $Capslock up:: Send {Ctrl up} ; tested does not work 2018-02-26 17.22 
		§ & å:: ; StuckKeyUp 
			; send confirmation 1
			ReleaseModifiers()
			; send confirmation 2
			StuckKeyUp()
			return 

			; send confirmation 3.1
		StuckKeyUp(){
			sleep 300 
			send {<# up} 
			send {># up} 
			send {# up} 
			send {+ up} 
			send {<+ up} 
			send {! up} 
			send {<! up} 
			send {>! up} 
			send {^<^^>! up} 
			send {^<^>! up} 
			send {^ up} 
			send {Ctrl down} 
			send {Ctrl up}

			Send {§ up} 		
			Send {Shift Up}
			Send {LShift Up}
			Send {RShift Up}
			Send {Alt Up}
			Send {LAlt Up}
			Send {RAlt Up}
			Send {Control Up}
			Send {LControl Up}	
			Send {<^ down}		
			Send {<^ Up}		; solves some issues 
			Send {>^ down}		
			Send {>^ Up}		
			Send {RControl Up}
			Send {LControl Up}
			Send {LWin Up}
			Send {RWin Up}
			sleep 100 
			; reload, ; Avoid - Reloading AutoHotkey File causes functions depending on this function to break
			return 
			}

			; send confirmation 4

		; StuckKeyUpAlternative:
			; from https://autohotkey.com/boards/viewtopic.php?t=19711 
			; to be evaluated if 2017-12-01 solution does not work 
			:*:xstuckx::
		§ & ä:: ; ReleaseModifiers 
			ReleaseModifiers()
			return

	ReleaseModifiers(timeout := "") ; timeout in ms
			{
				static	aModifiers := ["Ctrl", "Alt", "Shift", "LWin", "RWin"]
				
				startTime := A_Tickcount
				while (isaKeyPhysicallyDown(aModifiers))
				{
					if (timeout && A_Tickcount - startTime >= timeout)
						return 1 ; was taking too long
					sleep, 5
				}
				return
			}

			isaKeyPhysicallyDown(Keys)
			{
			if isobject(Keys)
			{
				for Index, Key in Keys
				if getkeystate(Key, "P")
					return key
			}
			else if getkeystate(Keys, "P")
				return Keys ;keys!
			return 0
			}

		; stuck control key EYE
			; 2018-02-26 17.15 
		; below did not solve the stuck control key issue 

			; #Persistent
			; Settimer, EYE, 300
			; Return

			; EYE:
			; GetKeyState, state, Control
			; if state = D
			; {
			; SplashImage,,b x0 y715 H20 W50 ZY0 ZX0 fs9 ct1C3DB8 cw82BD3A, CONTROL, , ,Arial
			; SetTimer, CHEkIFupCtrl, 200
			; Return

			; CHEkIFupCtrl:
			; GetKeyState, state, Control
			; if state = U
			; {
			; SplashImage, Off
			; SetTimer, CHEkIFupCtrl, Off
			; }
			; Return
			; }
		; return

	SelectTextBetweenParen(){ ; Select text between parentheses 
		sleep 100 
		Send ^k 
		sleep 100 
		Send ^!e 
		return 
		}
		
	ahkBackupGlobal(){
		sleep 300
		send {f12}
		WinWait, Save As
		send ^{home}
		sleep 300
			sendraw backup 
			send {space}
			ahkDaTi2()
			send {space}
		sleep 1100
		send {enter} 
		return
		}

 	
	ahkSaveAgainWithEnter(){
		sleep 300
		send {f12} 
		WinWait, Save As
		ahkSelectFileToOverwrite()
		send !s 
		sleep 300
		send {enter} ; most programs require enter to replace existing file 
		sleep 300
		return
		}
	
	ahkSaveAgainWithY(){
		sleep 300
		send {f12} 
		WinWait, Save As
		ahkSelectFileToOverwrite()
		sleep 300
		send !s 
		sleep 300
		send y ; E.g. Excel requires "y"  
		sleep 300
		return
		}

	ahkSelectFileToOverwrite(){
		send +{tab 2} 
		sleep 100
		send {down} 
		sleep 100
		send {up}
		sleep 100
		send {down} 
		sleep 300
		return 
		}

	FocusChromeRTM(){
		sleep 100 
		send #
		sleep 100 
		winactivate, Google Chrome
		send ^1
		sleep 1100 
		sleep 200 
		send {esc}
		send t
		sleep 1100 
		send {left}
		send {right} 
		return 
		}

	FocusChromeNewTab(){
		/*
		2017-08-31 17.36
			shortened it 
		*/
	
		sleep 100 
		winactivate, Google Chrome 
		; winactivate, ahk_class Chrome_WidgetWin_1
		sleep 1100 
		send ^t
		sleep 100 
		send {left}
		send {right} 
		return 
		}

	ChromeNewTab(){
		sleep 100 
		send ^t
		sleep 100 
		send {left}
		send {right} 
		return 
		}

	PerformChromeAdressbarSearch(){ ; 2017-08-30 11.19 updated for speed 
		sleep 100 
		send {del}
		send {left}
		send {right} 
		send {space}
		sleep 100 
		send ^v
		sleep 100 
		send {enter}
		return 
		}

	Selecline(){
		send {end}
		sleep 100 
		send {end}
		sleep 100 
		send +{home}
		sleep 100
		send +{home}
		sleep 100
		return 
		}

	CopyFromCaretToStartOfLine(){
		send +{home}
		sleep 100
		send +{home}
		sleep 100
		send ^c
		sleep 100
		return 
		}
		
	ViewRHelpFile(){
		sleep 300 
		send +{home}
		sleep 100 
		send ^c
		clipwait 
		sleep 100 
		return
		}

	;############## copying and pasting 
		CopySelected(){
			sleep 100 ; 100 is too little and causes stuck keys 
			send ^c
			sleep 100 
			StuckKeyUp()
			return
			}

		CopySelectedSlow() ; 2017-01-09 replaced this with above for speeed 
			{
			sleep 300 
			send {ctrl down} 
			sleep 300
			Send c
			sleep 100
			send {ctrl up} 
			sleep 100
			return
			}

		CopySelectedAltTabPasteAltTab()
			{
			CopySelected() 
			AltTabph()
			sleep 50 
			send {enter}
			sleep 50 
			AltTabh()
			}
			
		CopySelectedAltTabMolcAltTab(){	
			CopySelected() 
			AltTabh()
			xahkmosclpcb() 
			sleep 50 
			send {enter}
			sleep 50 
			AltTabh()
			}

	;############## cutting and pasting 
		CutSelected(){
			sleep 100 ; 100 is too little and causes stuck keys 
			send ^x
			sleep 100 
			StuckKeyUp()
			return
			}

		CutSelectedSlow() ; 2017-01-09 replaced this with above for speeed 
			{
			sleep 300 
			send {ctrl down} 
			sleep 300
			Send x
			sleep 100
			send {ctrl up} 
			sleep 100
			return
			}

		CutSelectedAltTabPasteAltTab()
			{
			CutSelected() 
			AltTabph()
			sleep 50 
			send {enter}
			sleep 50 
			AltTabh()
			}
			
		CutSelectedAltTabMolcAltTab(){	
			CutSelected() 
			AltTabh()
			xahkmosclpcb() 
			sleep 50 
			send {enter}
			sleep 50 
			AltTabh()
			}


	;##############  moving and pasting   

		CopyURLAltTabpAltTab() ; 2017-01-09 decreased sleep time 
			{
			sleep 200 
			send !d
			sleep 200 
			send ^c
			AltTabph() 
			send {alt down} 
			sleep 200
			Send {tab}
			sleep 200
			send {alt up} 
			sleep 200
			send ^v
			sleep 100
			return
			}

		AltTabb() ; AltTab already exists (but avoid using it (has limitations)!) 
			{
			AltTabf()
			return 
			}

		AltTabph() ; AltTab already exists (but avoid using it (has limitations)!) 
			{
			AltTabf()
			sleep 100
			send ^v
			return
			}

		AltTabf() ; AltTab as function (I think I have had issues with AltTab) 
			{
			sleep 100 
			send {alt down} 
			sleep 100
			Send {tab}
			sleep 100
			send {alt up} 
			return
			}

		AltTabphSlow() ; AltTab already exists (but avoid using it (has limitations)!) 
			{
			sleep 300 
			send {alt down} 
			sleep 300
			Send {tab}
			sleep 500
			send {alt up} 
			sleep 400
			send ^v
			sleep 100
			return
			}


		; :*:öö5öö5::
			; CopySelectedAltTabPasteAltTab()
			; return 

		:*:atbmolw::
		:*:atmolw::
			CopySelectedAltTabMolcAltTab()
			return 

		:*:öö5öö7::
			CopySelectedAltTabMolcAltTab()
			return 


		CtrTabph() ; AltTab already exists (but avoid using it (has limitations)!) 
			{
			sleep 300 
			send {ctrl down} 
			sleep 300
			Send {tab}
			sleep 500
			send {ctrl up} 
			sleep 400
			send ^v
			sleep 100
			return
			}

		CtrSTabph() ; AltTab already exists (but avoid using it (has limitations)!) 
			{
			sleep 300 
			send {ctrl down} 
			send {lshift down} 
			sleep 300
			Send {tab}
			sleep 500
			send {ctrl up} 
			send {lshift up} 
			sleep 400
			send ^v
			sleep 100
			return
			}

		CtrTabh() 
			{
			sleep 300 
			send {ctrl down} 
			sleep 500
			Send {tab}
			sleep 500
			send {ctrl up} 
			return
			sleep 1100
			}

		AltTabh() ; AltTab already exists (but avoid using it (it has limitations)!) 
			{
			sleep 300 ; to prev
			send {alt down} 
			sleep 100
			Send {tab}
			sleep 100
			send {alt up} 
			sleep 300 ; 2017-03-13 20.46 shortened time delay from 1100 
			StuckKeyUp()
			return
			}

		Open4nppAndPasteHere()
			{
			sleep 300 
			Run notepad++.exe
			WinWait, Notepad++
			sleep 300 
			send ^v
			return
			}

		Open4nppNew()
			{
			Run notepad++.exe
			WinWait, Notepad++
			sleep 700 
			send ^n 
			return 
			}

		Open4nppNewp()
			{
			sleep 300 
			Open4nppNew()
			sleep 100
			send ^v	
			return 

			#IfwinActive ahk_group MicrosoftOffice 
			sleep 300 
			AltTabh()
			sleep 300 
			Open4nppNew()
			sleep 100
			send ^v	
			return 
			#ifwinActive

			return 
			}

		{	;##############  Save as  

		AhkSaveAsAdobe()
			{
			sleep 100
			xahkmolcb()
			sleep 100
			xahkrsppcb()
			sleep 100 
			send ^+s
			; WinWait, Save As, 1 ; 2016-08-29 16.54 does not work 
			; send {tab}
			sleep 3300
			; send {tab 4}
			send {enter}
			sleep 700
			send {home}
			sleep 100
			send ^v
			sleep 100
			send {space} 
			sleep 700
			send {home}
			sleep 100
			send 0 0 GIO
			sleep 100 
			send {space 3}
			sleep 100
			send {left}--
			sleep 100
			send {left}
			sleep 100
			send {<# up} ; solved some issues 
			sleep 100
			return 

			}

		AhkSaveAs()
			{
			send ^+s
			; WinWait, Save As
			; ;sleep 500
			; send {home}
			; sleep 100
			; send ^v
			; sleep 100
			; send {space} 
			; sleep 100
			; send {home}
			; sleep 100
			; send 0 0 GIO
			; sleep 100 
			; send {space 3}
			; sleep 100
			; send {left}--
			; sleep 100
			; send {left}
			; sleep 100
			return 
			}

		}
			;############End Save as  

		{	;##############  archive not used anymore  ##############
		Open4nppAndPasteOver()
			{
			sleep 300 
			Run notepad++.exe
			WinWait, Notepad++
			sleep 300 
			send ^a
			sleep 100 
			send ^v
			return
			}

		Open4nppAndPasteAtEnd()
			{
			sleep 300 
			WinActivate, temp.txt 
			WinWait temp.txt 
			sleep 300 
			send ^{end}
			send {enter}
			send ^v
			WinActivate, Notepad++ 
			return 		
			}

		}
			;############End archive not used anymore  ############## 


	;##############  Close unwanted windows whenever they appear  
		;#Persistent
		;SetTimer, CloseIrritatingWindows, 250 ; this with persistent requires that the script runs the function CloseIrritatingWindows every 250ms 
		:*:xcwinx::
		:*:xclwinx::
		:*:xclosewinx::
		:*:cwinx::
		:*:clwinx::
		:*:closewinx::
		#å::
			sleep 100
			CloseIrritatingWindows()
			sleep 100
			return 
		/*
		2018-03-24 12.38
			added "xxx wants to know your location"
			added reload at end since this seemed necessary to perform it multiple times after each other 
		*/
			CloseIrritatingWindows()
				{
				WinClose, SetPoint Settings
				WinClose, Exception 
				WinClose, Session Manager Error ; 
				WinClose, wants to ; remove  xxx wants to know your location
					; 2018-03-24 12.36 seems to work ok 
				WinClose, Dropbox ; remove "Dropbox almost no space" 
					; 2017-12-06 16.49 works, ok to have it requiring #å to activate 
				WinClose, NickServ
				WinWait, OneNote Security Notice, 8
				WinClose, OneNote Security Notice 
				WinClose, Microsoft Outlook, A timeout occured while communicating
				WinClose, Microsoft Outlook, A connection to the server could not be established
				sleep 100 
				WinWait, Confirm close
				WinClose, Confirm close
				sleep 100 
				WinWait, NickServ
				WinClose, NickServ
				WinClose, Buddy List
				WinWait, #djvi, , 8
				WinClose, #djvi
				reload 
					; 
				return
				}
			
	ReverseDirection(a1, a2, offset)
		{
			return offset  ; Offset is positive if a2 came after a1 in the original list; negative otherwise.
		}

	FindAndOpenLink(){ 
		sleep 700 
		send ^f
		sleep 700 
		send gorillavid
		sleep 700
		send {esc}
		sleep 900
		send ^f
		sleep 900 
		send watch
		sleep 300
		send {esc}			
		sleep 100 
		send {enter} ; opens in same tab 
			sleep 700
			send ^f
			sleep 1100 
			sendraw click here
			sleep 300
			send {esc}			
			sleep 100 
		send {enter}
			sleep 1100
			send ^f
			sleep 1900 
			sendraw conti
			sleep 300
			send {esc}			
			sleep 100 
			send {enter}
			sleep 700
		return 	
		}

	xreplacesppastecb(){
			haystack := Clipboard
			needle := "([\r\n])[\s]{1,}"
			replacement := " "
			result01 := RegExReplace(haystack, needle, replacement)
			haystack := result01
			needle := "[\h]{1,}"
			replacement := "|"
			result := RegExReplace(haystack, needle, replacement)
			Clipboard =
			Clipboard := result
			ClipWait
			sleep 100
			send ^v
			sleep 100
			send {<# up} ; solved some issues 
			return
		}

	xahkregexdefault(){
		; DO NOT use this method
		; 2016-03-20 17.55 
			; this method could wwork,but for it to work it needs to take the variables as input variables, which defeats the purpose
		
			
			haystack := Clipboard
			result := RegExReplace(haystack, needle, replacement)
		
			Clipboard =
			Clipboard := result
			ClipWait
			send {<# up} 
			return
		}	



;##############  working on  

	{	;##############  various (


		:*:numpfix::
		:*:numpadfix::
		:*:fixnumpadx::
			sleep 300
			SendAltNumpad7()
			StuckKeyUp()
			return

			SendAltNumpad7(){
			sleep 300
			send !{numpad7}  
			sleep 100
			return
			}

		}
		;############End various ) 

	; Control key stuck up
		; If GetKeyState("Ctrl")           ; If the OS believes the key to be in (logical state),
		; {
			; If !GetKeyState("Ctrl","P")  ; but  the user isn't physically holding it down (physical state)
			; {
				; Send {Blind}{Ctrl Up}
				; MsgBox,,, Ctrl released
				; KeyHistory
			; }
		; }
		; return 
		/*
		look in the KeyHistory (after closing the message box) in which situations the key gets stuck.
		2018-03-03 14.53
			created the test above as suggested on my StackOverflow question 
			https://stackoverflow.com/questions/49009176/autohotkey-getting-control-key-stuck
		*/

		; StuckKeyUp() 
				; 2018-02-28 18.29 
					; seems to be problems every other time AutoHotkey is reloaded if StuckKeyUp is here 



		; run AutoHotkey script as admin 
		/*
		2018-03-09 13.48
			below seems to still work on Windows 10
		*/

	{	;##############  Multiple clicks (
		#ifwinActive examplename
		{	;##############  Method 1 using SetTimer(

		; Example #3: Detection of single, double, and triple-presses of a hotkey. This
		; allows a hotkey to perform a different operation depending on how many times
		; you press it:

		#c::
		if winc_presses > 0 ; SetTimer already started, so we log the keypress instead.
		{
			winc_presses += 1
			return
		}
		; Otherwise, this is the first press of a new series. Set count to 1 and start
		; the timer:
		winc_presses = 1
		SetTimer, KeyWinC, 400 ; Wait for more presses within a 400 millisecond window.
		return

		KeyWinC:
		SetTimer, KeyWinC, off
		if winc_presses = 1 ; The key was pressed once.
		{
			Run, m:\  ; Open a folder.
		}
		else if winc_presses = 2 ; The key was pressed twice.
		{
			Run, m:\multimedia  ; Open a different folder.
		}
		else if winc_presses > 2
		{
			MsgBox, Three or more clicks detected.
		}
		; Regardless of which action above was triggered, reset the count to
		; prepare for the next series of presses:
		winc_presses = 0
		return 


		}
			;############End Method 1 using SetTimer) 

		#ifwinactive

		}
		;############End Multiple clicks ) 

	{	;##############  ClipboardReplace Settings   
		/*
		Reminders 
			Have to copy and paste Replace.ahk to %A_ScriptDir% (main AutoHotkey path)

		2017-08-05 19.51
			changed path to Replace.ahk to use #Include %A_ScriptDir%\Replace.ahk, meaning it is now using same directory as the main script. 
		2017-06-25 21.51
			moving everything below to separate script and then using that script to update latest version of ClipboardReplace 
		*/

		{	;##############  ClipboardReplace Configuration (

		; general settings 
		#Include c:\Dropbox\GitHub\ClipboardReplace\Config.ahk

		; Stenemo specific settings 
		#ifwinactive ClipboardReplace 

		!h::
			send !u
			send !c
			sleep 50
			xahkrmvmec()
			sleep 50
			reload ; can not have any commands after reload 
			return 		

		!t::
			sleep 100 
			CbrRepl()
			return 

			CbrRepl(){
				sleep 100 
				send !u
				send !c
				sleep 50
				xahkrmvmescb() ; removes trailing spaces 
				AltTabph() ; Goes back to starting position and pastes updated clipboard 
				sleep 50
				reload ; closes ClipboardReplace and updates other AutoHotkey scripts
				return 
				}
			return 

		return 
		#ifwinactive 
		}
			;############End ClipboardReplace Configuration )

		{	;##############  All ClipboardReplace hotstrings 
		; keeping all hotstrings here, and ~all ClipboardReplace in one place   

		:*:xlcbr::
		:*:xcbr::
			Cbreplm() 
			return

		:*:xci8::
		:*:xcbi8::
			send icp8
			sleep 1100 
			Cbreplm() 
			return 

		:*:xci9::
		:*:xcbi9::
			send icp9
			sleep 1100 
			Cbreplm() 
			return 

		:*:xcb8::
			send öcp8  
			sleep 1100 
			Cbreplm() 
			return 

		:*:xcb9:: 
			send öcp9
			sleep 1100
			Cbreplm() 
			return 

		:*:xcbpc::
			Cbreplm() 
			sleep 50 
			send |
			send !w
			send |
			send {left}
			return 

		{	;##############  ClipboardReplace RegEx replace 

		:*:xarpdp::
			; Cbreplm() 
			; sleep 50
			; send |
			; send !w
			; send |
			; send {left}
			; return 
			
			Cbreplm() 
			sleep 50
			send (\|)|($)
			sleep 50
			send !x
			send !w
			send d$1
			send {home}
			return 

		} 
			;############End ClipboardReplace RegEx replace 
			
		} 
			;############End All ClipboardReplace hotstrings 

		}
		;############End ClipboardReplace Settings

	{	;##############  Google Search script   
		; GoogleSearch 

		; Fanatic Guru
		; 2016 03 15
		; Version: 1.21
		;
		; Google Search of Highlighted Text
		; If Internet Explorer is already running it will add search as new tab
		
		; AUTO-EXECUTE
		RegRead, ProgID, HKEY_CURRENT_USER, Software\Microsoft\Windows\Shell\Associations\UrlAssociations\http\UserChoice, Progid
		Browser := "iexplore.exe"
		if (ProgID = "ChromeHTML")
		Browser := "chrome.exe"
		if (ProgID = "FirefoxURL")
		Browser := "firefox.exe"
		if (ProgID = "AppXq0fevzme2pys62n3e0fbqa7peapykr8v")
		Browser := "microsoft-edge:"

		; HOTKEYS
		::4egna::
		::4engna::
			sleep 50 
			click 1919, 140, 1
			sleep 50 
			click 1919, 140, 1
			sleep 50 
			click 1919, 140, 1
			sleep 50 
			click 1830, 211, 1
			sleep 500 
			send {tab 2}
			sleep 50
			send ^c
			sleep 300 
			sendraw test
			sleep 300 
			Query := Clipboard
			
			sendraw test
			Run,  "http://www.google.com/search?hl=en&q=" Query ; Web Search
			; ;%browser% %Address% 
			sleep 300 
			sendraw test
			return 
			
			; ahkEndnoteGoogleTitle()
				; {
				; Search := 1
				; Gosub Google
				; return 
				; }

		::a4gc::    ; <-- Google Web Search Using Highlighted Text
		::a4gcb::    
			Search := 1
			Gosub Google
			return 

		::a4gic::    ; <-- Google Image Search Using Highlighted Text
			Search := 2
			Gosub Google
			return

		::a4gmc::    ; <-- Google Map Search Using Highlighted Text
			Search := 3
			Gosub Google
			return

		; SUBROUTINES
		Google:
		; Save_Clipboard := ClipboardAll
		; Clipboard := ""
		; Send ^c
		; ClipWait, .5
		if !ErrorLevel
			Query := Clipboard
		else
			; InputBox, Query, Google Search, , , 200, 100, , , , , %Query%
			Query := Clipboard
			StringReplace, Query, Query, `r`n, %A_Space%, All 
			StringReplace, Query, Query, %A_Space%, `%20, All
			StringReplace, Query, Query, #, `%23, All
			Query := Trim(Query)
		if (Search = 1)
				Address := "http://www.google.com/search?hl=en&q=" Query ; Web Search
				; send #2
				; sleep 1100 
				; send ^t 
				; sleep 700 
				; send ^v 
		else if (Search = 2)
			Address := "http://www.google.com/search?site=imghp&tbm=isch&q=" Query ; Image Search 
		else
			Address := "http://www.google.com/maps/search/" Query ; Map Search
		; Clipboard := Save_Clipboard
		; Save_Clipboard := ""
		Run, %browser% %Address% 
		return


		}
		;############End Google Search  

	{	;##############  Dictionary Search  



		}
		;############End Dictionary Search  

	{	;##############  notes while going over AHKTuts  
		{	;##############  Download to a file  ##############

			:*:ahkt1:: ; this works as of 2015-07-23 16.41 
				UrlDownloadToFile, http://ahkscript.org/download/1.1/version.txt, C:\Dropbox\Downloads (web etc)\02TempFiles-impflr-review weekly and delete when not\temporaryfromAutoHotkey\temporaryfromAutoHotkey.txt
				UrlDownloadToFile, http://someorg.org/archive.zip, c:\Dropbox\Downloads (web etc)\02TempFiles-impflr-review weekly and delete when not\temporaryfromAutoHotkey\temporaryfromAutoHotkey.zip
				Return 
			:*:ahkdlcb::
			:*:adlcb::
			:*:ahkdluc::
			:*:ahkscb::
				varclipboard := clipboard ; stores the clipboard content into a variable
				UrlDownloadToFile, %varclipboard%, C:\Dropbox\Downloads (web etc)\02TempFiles-impflr-review weekly and delete when not\temporaryfromAutoHotkey\temporaryfromAutoHotkey.htm
				UrlDownloadToFile, %varclipboard%, C:\Dropbox\Downloads (web etc)\02TempFiles-impflr-review weekly and delete when not\temporaryfromAutoHotkey\temporaryfromAutoHotkey.txt
				UrlDownloadToFile, %varclipboard%, c:\Dropbox\Downloads (web etc)\02TempFiles-impflr-review weekly and delete when not\temporaryfromAutoHotkey\temporaryfromAutoHotkey.zip
				msgbox %varclipboard% saved in  c:\Dropbox\Downloads
				Return 

			; Example: Download text to a variable:
				whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
				whr.Open("GET", "http://ahkscript.org/download/1.1/version.txt", true)
				whr.Send()
				; Using 'true' above and the call below allows the script to remain responsive.
				whr.WaitForResponse()
				version := whr.ResponseText
				MsgBox % version
				return  
			}
			;############End Download to a file  ############## 

		{	;##############  Getting your IP address   ##############
			; Example: Make an asynchronous HTTP request.
				:*:ahkgtmyip::
				:*:ahkip::
				:*:ahkxip::
				:*:ahkmyip::
				:*:agtmyip::
				:*:amyip::
				:*:ahkmyip:: 
				req := ComObjCreate("Msxml2.XMLHTTP")
				; Open a request with async enabled.
				req.open("GET", "http://www.cmyip.com/", true)
				; Set our callback function (v1.1.17+).
				req.onreadystatechange := Func("Ready")
				; Send the request.  Ready() will be called when it's complete.
				req.send()
				/*
				; If you're going to wait, there's no need for onreadystatechange.
				; Setting async=true and waiting like this allows the script to remain
				; responsive while the download is taking place, whereas async=false
				; will make the script unresponsive.
				while req.readyState != 
					sleep 100
				*/
				#Persistent

				Ready() {
					global req
					if (req.readyState != 4)  ; Not done yet.
						return
					if (req.status == 200 || req.status == 304) ; OK.
							haystack := req.responseText 
							needle := ".*Address is ([\d\.]+).*" 
							replacement := "$1"
							result := RegExReplace(haystack, needle, replacement)
							Clipboard = %result%
					;Message user information 
						MsgBox % "My IP address (saved to clipboard) is: " result
					if (req.status == 201 || req.status == 306) ; no idea...
							MsgBox 16,, % "Status " req.status
					;ExitApp ; turns off AutoHotkey - rarely want this! 
				}
				return 


			; Example: Make an asynchronous HTTP request.
				:*:ahkxtest::
				req := ComObjCreate("Msxml2.XMLHTTP")
				; Open a request with async enabled.
				req.open("GET", "http://ahkscript.org/download/1.1/version.txt", true)
				; Set our callback function (v1.1.17+).
				req.onreadystatechange := Func("Readyexample")
				; Send the request.  Readyexample() will be called when it's complete.
				req.send()
				/*
				; If you're going to wait, there's no need for onReadyexamplestatechange.
				; Setting async=true and waiting like this allows the script to remain
				; responsive while the download is taking place, whereas async=false
				; will make the script unresponsive.
				while req.readyState != 4
					sleep 100
				*/
				#Persistent

				Readyexample() {
					global req
					if (req.readyState != 4)  ; Not done yet.
						return
					if (req.status == 200 || req.status == 304) ; OK.
						MsgBox % "Latest AutoHotkey version: " req.responseText
					else
						MsgBox 16,, % "Status " req.status
					ExitApp
				}
				return 
			;httpqueryx(url, "http://www.cmyip.com/") ; this is an outdated command 
			VarSetCapacity(url, 1) 
			send ok 
			return 
			;IP Address is\s([\d. ]+)
			}
			;############End Getting your IP address   ############## 
		}
		;############End notes while going over AHKTuts 

	{	;##############  Copy and paste related  ##############


		#v::
			sleep 100
			xahkrmvmepc()
			sleep 100
			return 

		{	;##############  End with !tab 
		; several below conflict with MediaMonkey everything below is more useful but solved differently so will consider solving this using different hotkeys instead 

			; ^#8::
				; sleep 500  
				; send +{home}
				; send ^c
				; AltTabh()
				; sleep 1100
				; send ^v
				; return

			; ^#9::
				; sleep 500  
				; send +{end}
				; send ^c
				; AltTabh()
				; sleep 1100
				; send ^v
				; return

			; ^#6::
				; sleep 500  
				; send ^+{left}
				; send ^c
				; AltTabh()
				; sleep 1100
				; send ^v
				; return

			; ^#7::
				; sleep 500  
				; send ^+{right}
				; send ^c
				; AltTabh()
				; sleep 1100
				; send ^v
				; return

			; ^#c::
				; sleep 500  
				; AltTabh()
				; sleep 1100
				; send ^v
				; return		
			; ^#w::
				; sleep 500  
				; send ^c
				; AltTabh()
				; sleep 1100
				; send ^v
				; return		

			; ^#a::
				; sleep 500  
				; send ^a
				; sleep 100  
				; send ^c
				; AltTabh()
				; sleep 1100
				; send ^v
				; return		

			; +#8:: 
				; sleep 500  
				; send +{home}
				; send ^x
				; AltTabh()
				; sleep 1100
				; send ^v
				; return

			; +#9:: ; to be replaced (in use) 
				; sleep 500  
				; send +{end}
				; send ^x
				; AltTabh()
				; sleep 1100
				; send ^v
				; return

			; +#6::
				; sleep 500  
				; send ^+{left}
				; send ^x
				; AltTabh()
				; sleep 1100
				; send ^v
				; return

			; +#7::
				; sleep 500  
				; send ^+{right}
				; send ^x
				; AltTabh()
				; sleep 1100
				; send ^v
				; return

			; +#c::
				; sleep 500  
				; AltTabh()
				; sleep 1100
				; send ^v
				; return		
			; +#w::
				; sleep 500  
				; send ^x
				; AltTabh()
				; sleep 1100
				; send ^v
				; return		

			; +#a::
				; sleep 500  
				; send ^a
				; sleep 100  
				; send ^x
				; AltTabh()
				; sleep 1100
				; send ^v
				; return		

		}
			;########### END End with !tab 

		{	;##############  End with ^tab ##############

			; ^#8::
				; sleep 500  
				; send +{home}
				; send ^c
				; AltTabh()
				; sleep 1100
				; send ^v
				; return

			; ^#9::
				; sleep 500  
				; send +{end}
				; send ^c
				; AltTabh()
				; sleep 1100
				; send ^v
				; return

			; ^#6::
				; sleep 500  
				; send ^+{left}
				; send ^c
				; AltTabh()
				; sleep 1100
				; send ^v
				; return

			; ^#7::
				; sleep 500  
				; send ^+{right}
				; send ^c
				; AltTabh()
				; sleep 1100
				; send ^v
				; return

			; ^#c::
				; sleep 500  
				; AltTabh()
				; sleep 1100
				; send ^v
				; return		
			; ^#w::
				; sleep 500  
				; send ^c
				; AltTabh()
				; sleep 1100
				; send ^v
				; return		

			; ^#a::
				; sleep 500  
				; send ^a
				; sleep 100  
				; send ^c
				; AltTabh()
				; sleep 1100
				; send ^v
				; return		

			; +#8::
				; sleep 500  
				; send +{home}
				; send ^x
				; AltTabh()
				; sleep 1100
				; send ^v
				; return

			; +#9::
				; sleep 500  
				; send +{end}
				; send ^x
				; AltTabh()
				; sleep 1100
				; send ^v
				; return

			; +#6::
				; sleep 500  
				; send ^+{left}
				; send ^x
				; AltTabh()
				; sleep 1100
				; send ^v
				; return

			; +#7::
				; sleep 500  
				; send ^+{right}
				; send ^x
				; AltTabh()
				; sleep 1100
				; send ^v
				; return

			; +#c::
				; sleep 500  
				; AltTabh()
				; sleep 1100
				; send ^v
				; return		
			; +#w::
				; sleep 500  
				; send ^x
				; AltTabh()
				; sleep 1100
				; send ^v
				; return		

			; +#a::
				; sleep 500  
				; send ^a
				; sleep 100  
				; send ^x
				; AltTabh()
				; sleep 1100
				; send ^v
				; return		

		}
			;########### END End with ^tab ##############

		{	;##############  When target location is Notepad++ ##############
		; i.e. no need to alttab to it 
		; several below conflict with MediaMonkey everything below is more useful but solved differently so will consider solving this using different hotkeys instead 

			; <!^#8::
				; sleep 500  
				; send +{home}
				; send ^c
				; Open4nppAndPasteHere()
				; return

			; <!^#9::
				; sleep 500  
				; send +{end}
				; send ^c
				; Open4nppAndPasteHere()
				; return

			; <!^#6::
				; sleep 500  
				; send ^+{left}
				; send ^c
				; Open4nppAndPasteHere()
				; return

			; <!^#7::
				; sleep 500  
				; send ^+{right}
				; send ^c
				; Open4nppAndPasteHere()
				; return

			; <!^#c::
				; sleep 500  
				; Open4nppAndPasteHere()
				; return		
			; <!^#w::
				; sleep 500  
				; send ^c
				; Open4nppAndPasteHere()
				; return		

			; <!^#a::
				; sleep 500  
				; send ^a
				; sleep 100  
				; send ^c
				; Open4nppAndPasteHere()
				; return		

			; <!+#8::
				; sleep 500  
				; send +{home}
				; send ^x
				; Open4nppAndPasteHere()
				; return

			; <!+#9::
				; sleep 500  
				; send +{end}
				; send ^x
				; Open4nppAndPasteHere()
				; return

			; <!+#6::
				; sleep 500  
				; send ^+{left}
				; send ^x
				; Open4nppAndPasteHere()
				; return

			; <!+#7::
				; sleep 500  
				; send ^+{right}
				; send ^x
				; Open4nppAndPasteHere()
				; return

			; <!+#c::
				; sleep 500  
				; Open4nppAndPasteHere()
				; return		

			; <!+#w::
				; sleep 500  
				; send ^x
				; Open4nppAndPasteHere()
				; return		

			; <!+#a::
				; sleep 500  
				; send ^a
				; sleep 100  
				; send ^x
				; Open4nppAndPasteHere()
				; return		

		}
			;########### END When target location is Notepad++ ##############


		}
		;########### END Copy and paste related  ##############


	{	;##############  programs that need to inactive Breevy abbreviations 
		;(previously Breevy inactive when programming) 
		GroupAdd, programming, RStudio
			; not working as of 2015-09-19 
		GroupAdd, programming, ahk_class RStudio  
		GroupAdd, programming, RStudio 
		#IfWinActive ahk_group programming
		::aoe::test 
			; not working as of 2015-09-19  
		#IfWinActive 
		}
		;###########END  programs that need to inactive Breevy abbreviations 

	{	;########### window movement etc  ##############
		:*:ahktest1::
		WinGetPos, X, Y, , , A  ; "A" to get the active window's pos.
		MsgBox, The active window is at %X%`,%Y%
		return 

		^!<+#w:: 
		WinGetTitle, WinName, A
		Gui, Font, s12, Arial
		Gui, Add, DropDownList, AltSubmit w275 vPosition gPosChoice
		, Select Position on the Screen||Right Half of Screen|Left Half of Screen
		|Top Half of Screen|Bottom Half of Screen|Center of Screen
		|Top Right Corner|Bottom Right Corner|Top Left Corner|Bottom Left Corner|
		Gui, Show, W300 H40 , Move Window
		Return
		PosChoice:
		Gui, Submit, NoHide

		WinGetPos,TX1,TY1,TW1,TH1,ahk_class Shell_TrayWnd

		WinGetPos,X1,Y1,W1,H1,Program Manager
		X2 := W1/2 
		Y2 := (H1)/2
		X4 := W1/4
		Y4 := H1/4

		X22 := W1/4
		Y22 := (H1)/2
		X42 := W1/8
		Y42 := H1/4

		If Position = 2
		{
			WinMove,%WinName%,,%X22%,0,%X22%,%H1%
		}
		If Position = 3
		{
			WinMove,%WinName%,,0,0,%X22%,%H1%
		}
		If Position = 4
		{
			WinMove,%WinName%,,0,0,%x2%,%Y22%
		}
		If Position = 5
		{
			WinMove,%WinName%,,0,%Y22%,%x2%,%Y22%
		}
		If Position = 6
		{
			WinMove,%WinName%,,%X42%,%Y42%,%X22%,%Y22%
		}
		If Position = 7
		{
			WinMove,%WinName%,,%X22%,0,%X22%,%Y22%
		}
		If Position = 8
		{
			WinMove,%WinName%,,%X22%,%Y22%,%X22%,%Y22%
		}
		If Position = 9
		{
			WinMove,%WinName%,,0,0,%X22%,%Y22%
		}
		If Position = 10
		{
			WinMove,%WinName%,,0,%Y22%,%X22%,%Y22%
		}
		Return

		12GuiClose:
		Gui, Destroy

		Return	 
		}
		;########End window movement etc  ############## 

	{	;##############  move mouse pointer commands (
		/*
		This is the default version of MoveMouse 

		To be done
			[right middle] click 

		2017-06-25 20.52
			started this 
		*/

		:*:mmtlx::
			Click 100, 225, 0  ; Move the mouse without clicking. 
			return 
		:*:mmtmx::
			Click 670, 106, 0  ; Move the mouse without clicking. 
			return 
		:*:mmtrx::
			Click 1700, 225, 0  ; Move the mouse without clicking. 
			return 

		:*:mmmlx::
			Click 100, 500, 0  ; Move the mouse without clicking. 
			return 
		:*:mmmx::
		:*:mmmmx::
			Click 900, 500, 0  ; Move the mouse without clicking. 
			return 
		:*:mmmrx::
			Click 1700, 500, 0  ; Move the mouse without clicking. 
			return 

		:*:mmblx::
			Click 100, 1100, 0  ; Move the mouse without clicking. 
			return 
		:*:mmbmx::
			Click 900, 1100, 0  ; Move the mouse without clicking. 
			return 
		:*:mmbrx::
			Click 1700, 1100, 0  ; Move the mouse without clicking. 
			return 

		}
		;############End move mouse pointer commands )
;##############  Global 
	/*
	This is for 
		Everything that works in so many programs it shouldn't use ifwinactive 
	Structure of this document 
		Hotkeys at the top 
		Hotstrings after 
		Groups of commands by category 
		functions at the end 
		
	2017-04-27 12.01
		Created this to start moving more things from Breevy to AutoHotkey 
	*/

	{	;##############  default surface pen hotkeys (
		/*

		2017-08-29 11.51
			this is for things that is useful always but that will rarely be used as surface pen will be program specific ~everywhere it is frequently used
		*/
		
		MButton:: ; 2017-11-03 solution to issue of not pressing mbutton in Chrome etc 
			sleep 300
			; Send {Click middle}
			; Send ^{Click middle}
			Send ^{Click m}
			; Send {Click m}
			sleep 100
			return

		#F20:: ; Single click surface pen global 
			sleep 300 
			send ^c
			FocusChromeNewTab()
			sleep 100 
			send define
			PerformChromeAdressbarSearch()
			return 

		#F19:: ; Doble click surface pen global 
			sleep 300 
			send ^c
			FocusChromeNewTab()
			sleep 100 
			PerformChromeAdressbarSearch()
			return 

		#F18:: ; long press surface pen global 
			{
				; run, C:\Windows\WinSxS\amd64_microsoft-windows-snippingtool-app_31bf3856ad364e35_10.0.15063.0_none_aad7db68c271ad4a\SnippingTool.exe ; opens program similar to Zizorz to take part of screen screenshot (added 2017-08-29 11.55 not tested) 
				; run, snippingtool.exe ; opens program similar to Zizorz to take part of screen screenshot (added 2017-08-29 11.55 not tested) 
					; 2017-08-29 13.15 not working 
				; run, SnippingTool.exe ; opens program similar to Zizorz to take part of screen screenshot (added 2017-08-29 11.55 not tested) 
				;https://support.microsoft.com/en-us/help/13776/windows-use-snipping-tool-to-capture-screenshots
				
				; Sleep, 500
				; send, ^{PrintScreen}
				; KeyWait, LButton, D
				; KeyWait, LButton, U
				; Sleep, 500
				; WinClose, ahk_exe SnippingTool.exe
				; return

			}

			; sleep 300
			; send #5
			; sleep 100
			; return

		appskey:: 
			send {appskey}
			return 

		appskey & down:: 
			send {PgDn}
			return 

		appskey & up:: 
			send {PgUp}
			return 

		appskey & left:: 
			send {home}
			return 

		appskey & right:: 
			send {end}
			return 

		}
		;############End default surface pen hotkeys )

	; Windows 10 startup settings 
		/*
		2018-03-14 13.03
			still using Breevy for Surface until I have it working correctly on WRKPC r
		2018-03-13 16.40
			Still working on making this fit Windows 10 changes 
		*/
		
		:*:xlevsa::
			NegativeScreenOnOff() 
			; will probably need to add several things that are currently only in xlewk 
			return 

		:*:xlevwk::
			NegativeScreenOnOff() 
			sleep 100 
			WorkDocumentationStart()
			DittoRestart()
			NumpadMouseRestart()
			sleep 100 
			CloseIrritatingWindows()
			sleep 100 
			send #1
			sleep 100 
			return 

		; :*:xlevsu:: yyy working here to be added 
			; NegativeScreenOnOff() 
			; sleep 100 
			; WorkDocumentationStart()
			; DittoRestart()
			; NumpadMouseRestart()
			; sleep 100 
			; send #1
			; sleep 100 
			; return 


		; Launch main results 
			§ & f8::
				sleep 100 
				MainResultsStart()
				return 

			MainResultsStart(){
					sleep 100 
					IfWinExist, results 3up02 pek02resus 3ua02 ULSAM PIVUS
						{
							WinActivate  ; Automatically uses the window found above. 
							
							return
						}
					else 
						{
							sendraw xlmr 
							send {space}
							WinWaitActive, results 3up02 pek02resus 3ua02 ULSAM PIVUS
							WinActivate
						
							; run C:\Dropbox\Work\Uppsala\project02\Results\MainResults\results 3up02 pek02resus 3ua02 ULSAM PIVUS cox-regression multproc main results mresus.xlsx 
								; using this would cause it to run as admin (Breevy not usable)
							; run, c:\Dropbox\Work\Uppsala\documentation\0 main documentation folder\Uppsala_documentation.docx 
						; sendraw xlmr
						sleep 100 
						; send {space}
							/*
							2018-03-29 14.23
								Commented out 
								This creates second Word instance 
							*/
						return 
						}
					}
				return 
		; Launch WorkDocumentation 
			/*
			2018-03-29 14.27
				commented out and using Breevy again 
			*/
				
			; :*:xld3::
				; WorkDocumentationStart()
				; return 

			WorkDocumentationStart(){
				sleep 100 
				sendraw xld3
				sleep 100 
				; run, c:\Dropbox\Work\Uppsala\documentation\0 main documentation folder\Uppsala_documentation.docx 
					/*
					2018-03-29 14.23
						Commented out 
						This creates second Word instance 
					*/
				return 
				}
			

	; Numpad Mouse Restart 
		capslock & f1::
		:*:nmrsx::
		:*:4nmrsx::
		:*:xlstanm::
		:*:xlnump::
			NumpadMouseRestart()
			return 

		NumpadMouseRestart()
			{
			Process, Exist, Numpad Mouse.exe
			If ErrorLevel <> 0
				{
				Process, Close, Numpad Mouse.exe
				sleep 300 
				run, C:\Dropbox\Installs\Keyboard Related\Numpad Mouse\Numpad Mouse.exe
				; run, *RunAs C:\Dropbox\Installs\Keyboard Related\Numpad Mouse\Numpad Mouse.exe
				; run, C:\Dropbox\Installs\Keyboard Related\Numpad Mouse\Numpad Mouse.exe
				}

			Else
				{
				run, C:\Dropbox\Installs\Keyboard Related\Numpad Mouse\Numpad Mouse.exe
				; sleep 3000 
				; send ^{NumpadMult}
				; sleep 500
				; send !s
				; send c
				}
			return
			}

	; Numpad Mouse onoff 
		:*:4nmonx:: 
		:*:4nmoff:: 
		:*:4nmtog:: 
		:*:4nmactv:: 
		:*:4nmacv: ; /in-/activate Numpad Mouse toggle Numpad Mouse
			sleep 500 
			send ^{numpaddiv}
			;Send {alt Down}
			;sleep 100
			;Send {f10 Down} 
			;sleep 100
			;Send {alt Up}{f10 Up}
			return

	{	;############# Default Strokeit and TouchMe Gesture hand gestures

		/*
		Main documentation for 
			Small programs (larger directly in the specific program section)
			Global commands 

		2017-08-30 11.51
			made more global commands in Strokeit 
			update entire list here 
		2017-05-01 19.09
			created small ifwinactive sections here for smaller programs 
		2017-04-30 18.08
			several commands available, listed in rpc  
		*/

		; All Strokeit Gestures and their global commands 

		/*
		The following should not be modified by AutoHotkey  
		; !#h::			;o reversed all Invert colors
		; Del delete; Z 2 and S Rv all
		; !'::			;M MediaMonkey p/p
		; !left::		;down left 
		; !right::		;down right

		; !f4::			;C most Close Window 
		; ^+Tab::		;/ up
		; ^+Tab::		;Up-Left
		; ^f::			;R
		; ^f::			;Rt Lt
		; ^f1::			;A
		; ^f2::			;B
		; ^f3::			;C Reverse
		; ^f4::			;D
		; ^f5::			;W reverse
		; ^f6::			;6
		; ^f7::			;X reverse
		; ^f8::			;D Reverse
		; ^f9::			;P
		; ^f10::		;A Reverse
		; ^f11::		;V\
		; ^l::			;e
		; ^n::			;N 
		; ^o::			;O
		; ^s::			;S and Z rv
		; ^T::			;\ Up
		; ^T::			;RtLtRt
		; ^Tab::		;Up-Right
		; ^Z::			;U
		; Down::		;J Reversed
		; !+right::		;RtLtRt

		*/

		; global 
		^!+F3::			;W alt tab 2016-03-28 15.12 this works in Windows 7 wrpc, and on surface Windows 8 
			sleep 100 
			send {alt down} 
			sleep 100
			Send {tab}
			sleep 100
			send {alt up} 
			return

		^!+F7:: 		; [N reversed] Media next
			Send {Media_Next}
			return 

		!+f11:: ; Strokeit left up 
			sleep 100
			; send ^{+} does not work to send plus sign
			Send {CTRLDOWN}{NumpadAdd}{CTRLUP}
			return

		!+f12:: ; Strokeit left down 
			sleep 100
			Send {CTRLDOWN}{NumpadSub}{CTRLUP}
			return

		; program specific with default commands here 
		; same in most 
		; ^w::			;\ Down most Close Tab 
		; ^Y::			;U Reversed most Redo 
		; F5::			;Up-Down most Refresh 
		; L::			;/Down / UP
		; PageDown::	;\\down
		; PageUp::		;\\Up
		; Up::			;J


		; ; Strokeit Always program specific gestures template 
		; !+F1::			;T upside
			; ; 2014-10-02 14.45 - had very strange issue with this changing the projector settings (after realising it it was easy to change it back (win+p, wait 2 secs, press enter, repeat if necessary) 
			; sleep 100
			; ; send available 
			; return

		; ^+s::			;Down Up
			; sleep 100
			; ; send available 
			; return

		; ^!+s::			;left right
			; sleep 100
			; ; send available 
			; return

		; ^!+f1::			;Left
			; sleep 100
			; ; send available 
			; return

		; ^!+f2::			;Right
			; sleep 100
			; ; send available 
			; return

		; ^!+f4::			;up down up
			; sleep 100
			; ; send available 
			; return

		; ^!+f5::			;Up
			; sleep 100
			; ; send available 
			; return

		; ^!+f6::			;Down
			; sleep 100
			; ; send available 
			; return

		; ^!+f9::			;down up down
			; sleep 100
			; ; send available 
			; return

		; ^!+f10::		;left right left
			; sleep 100
			; ; send available 
			; return

		; ^!+f11::		;right down 
			; sleep 100
			; ; send available 
			; return

		; ^!+f12::		;right up program specific
			; sleep 100
			; ; send available 
			; return

		; +#M::			;/ Up - / DownRestore All 
			; sleep 100
			; ; send available 
			; return

		; return 

		return 


		}
		;##########end Default Strokeit and TouchMe Gesture hand gestures 

	{	;##############  Hotstrings (
	/*
	This is the replacement of Breevy hotstrings (Breevy replacement replacing Breevy) 

	2017-12-15 11.28
		started using this section more 
	*/
	
	::senden::
	::snden::
	::sende::
	::snde::
		sleep 300
		sendraw send 
		sleep 100
		send {space} 
		sleep 100
		sendraw {enter}
		sleep 100
		return

	

	::sendc::
	::sndc::
		sleep 300
		sendraw send 
		sleep 100
		send {space} 
		sleep 100
		sendraw ^
		sleep 100
		return

	; Slowly scroll down scroll slowy 
	:*:scrdx::	; using {pgdn} 
		sleep 300
		loop 5
			{
			send {pgdn}
			sleep 2000
			}
		return

	:*:u9::
		send {enter}
		return 

	}
		;############End Hotstrings )  

	{	;##############  DEPRECATED Hotstrings (
	/*
	2018-04-22 11.50
		almost fully implemented new system
		commented out everything below 
	2017-12-05 10.05
		below is to be removed once Logitech F13-F24 method is fully implemented 
	*/
	
	:*:öö1::
			{ 
			Send !{left}
			StuckKeyUp()
			}
		return 

	:*:öö2::
		Send !{right}
		Return

	:*:öö3::
		Send ^{f4}
		Return
		
	:*:öö4::
		Send !{f4}
		Return

	; :*:öö5:: ;  
		; Send !{right}
		; Return

	:*:öö6::
		Send !#h
		Return

	:*:öö7::
		Send !'
		; Send {Media_Play_Pause} ; old before 171201 

		Return

	:*:åå1::
		Send ^+{tab}
		Return

	:*:åå2::
		Send ^{tab}
		Return
		
	:*:öö5öö1::
		Send !{left}
		Return

	:*:öö5öö2::
		Send !{right}
		Return

	:*:öö5öö3::
		Send ^{f4}
		Return
		
	:*:öö5öö4::
		Send !{f4}
		Return

	; :*:öö5öö5:: 
		; Send !{right}
		; Return

	:*:öö5öö6::
		Send !#h
		Return
		
	:*:öö5öö7::
		Send {Media_Play_Pause}
		Return

	:*:öö5åå1::
		Send ^+{tab}
		Return

	:*:öö5åå2::
		Sendraw test 
		Return
	
	:*:öö5öö5öö1::
		Send #1
		Return

	:*:öö5öö5öö2::
		Send #2
		Return

	:*:öö5öö5öö3::
		Send #3
		Return
		
	:*:öö5öö5öö4::
		Send #4
		Return

	:*:5öö5öö5öö5:: 
		Send #5
		Return

	:*:öö5öö5öö6::
		Send #6
		Return
		
	:*:öö5öö5öö7::
		Send #7
		Return

	:*:öö5öö5åå1::
		Send #8
		Return

	:*:öö5öö5åå2::
		Send #9
		Return
	

	}
		;############End DEPRECATED Hotstrings )

	{	;##############  Gaming  
		; Gaming scripts that are global 

			:*:xgmgx::
			:*:xsgmgx::
			:*:gamingx::
			:*:xgamingx::
			:*:xgamingmx::
			:*:sgamingx::
			:*:xsgamingx::
			:*:xsgamingmx::
			:*:xgamingcevth::
			:*:xgamingsevth::
			:*:xcgamingx::
			:*:xsgamingx::
			:*:ahksgamingx::
			:*:ahkgamingx::
			:*:ahksgaming::
			:*:ahkgaming::
				BreevyOnOff()
				StrokeitRestart()
				return

		; restart Breevy close Breevy turn off Breevy terminate Breevy 
			:*:xrsbvy::
			:*:bvyrsx::
			:*:xlbvy::
			:*:xl4b::
			:*:xl4bvy::
			:*:4bclosex::
			:*:4bclx::
			:*:xc4bx::
			:*:xcbvyx::
			:*:xclose4b::
			:*:xclosebvy::
			:*:4brsx::
			:*:xrs4bx::
			:*:xrsbvyx::
			:*:rsbvyx::
				BreevyRestart()
				return 

			BreevyOnOff()
				{
				Process, Exist, Breevy.exe
				If ErrorLevel <> 0
					Process, Close, Breevy.exe
				Else
					Run, c:\Program Files (x86)\Breevy\Breevy.exe ; 2017-10-22 takes > 5 seconds to start Breevy 
					; Run, c:\Breevy\Breevy.exe ; 2017-10-22 takes > 5 seconds to start Breevy 
				return
				}
			return

		BreevyRestart()
			{
			Process, Exist, Breevy.exe
			If ErrorLevel <> 0
				{
				Process, Close, Breevy.exe
				sleep 300 
				Run, c:\Program Files (x86)\Breevy\Breevy.exe ; 2017-10-22 takes > 5 seconds to start Breevy 
				; Run, *RunAs c:\Program Files (x86)\Breevy\Breevy.exe ; 2017-10-22 takes > 5 seconds to start Breevy 
				}
			Else
				; Run, *RunAs c:\Program Files (x86)\Breevy\Breevy.exe ; 2017-10-22 takes > 5 seconds to start Breevy 
				Run, c:\Program Files (x86)\Breevy\Breevy.exe ; 2017-10-22 takes > 5 seconds to start Breevy 
				; Run, c:\Breevy\Breevy.exe ; 2017-10-22 takes > 5 seconds to start Breevy 
			return
			}
			return

		; Ditto restart 
			:*:4dirsx::
			:*:dirsx::
			:*:dittorsx::
			:*:4dionx::
				sleep 100 
				DittoRestart()
				return 

			DittoRestart()
				{
				Process, Exist, Ditto.exe
				If ErrorLevel <> 0
					{
					Process, Close, Ditto.exe
					sleep 300 
					Run, C:\Dropbox\Installs\PortableApps\PortableApps\DittoPortable\App\Ditto\Ditto.exe 
					}
				Else
					Run, C:\Dropbox\Installs\PortableApps\PortableApps\DittoPortable\App\Ditto\Ditto.exe 
					; 2017-10-22 takes > 5 seconds to start Breevy 
					; Run, c:\Program Files (x86)\Breevy\Breevy.exe ; 2017-10-22 takes > 5 seconds to start Breevy 
					; Run, c:\Breevy\Breevy.exe ; 2017-10-22 takes > 5 seconds to start Breevy 
				return
				}
			return

		; Negative Screen restart 
				; restart NegativeScreen close NegativeScreen turn off NegativeScreen terminate NegativeScreen 

			f21:: 
			!#h::
			; capslock & f1:: 
			:*:rsnsx::
			:*:4nscrclosex::
			:*:4nscrclx::
			:*:xc4nscrx::
			:*:xcnscrx::
			:*:xclose4nscr::
			:*:xclosenscr::
			:*:4nscrrsx::
			:*:xrs4nscrx::
			:*:xrsnscrx::
				NegativeScreenOnOff()
				return 

			NegativeScreenOnOff()
				{
				Process, Exist, NegativeScreen.exe
				If ErrorLevel <> 0
					Process, Close, NegativeScreen.exe
				Else
					{
					; Run, c:\Breevy\Breevy.exe ; 2017-10-22 takes > 5 seconds to start Breevy 
					run, c:\Dropbox\installs\Negativescreen\NegativeScreen.exe
					sleep 300 
					send !#{f1} 
					; ")%(delay 2000ms)%(key alt+win+f1)
					}
				return
				}
			return


		; Strokeit running and restarting 
			/*

			2018-03-23 09.26
				removed *RunAs (I think it is causing more problem than it solves) 
			2018-03-11 10.58
				updated to use *RunAs, which seems to have solved some problems for Strokeit to interact with other programs run as administrator 
			*/
			
			:*:4sirsx::
			:*:sirsx::
			:*:xrssix::
				StrokeitRestart()
				return

			:*:4sioffx::
			:*:sioffx::
			:*:xclosesi::
			:*:xcsix::
			:*:xssix::
			:*:xsisx::
				StrokeitOnOff()
				return

			StrokeitOnOff()
				{
				Process, Exist, strokeit.exe
				If ErrorLevel <> 0
					Process, Close, strokeit.exe
				Else
					Run, c:\Program Files (x86)\StrokeIt\strokeit.exe ; added RunAs i.e. runas administrator 2018-03-07 13.21 
					; Run, c:\Program Files (x86)\StrokeIt\strokeit.exe
				return
				}
				return

			StrokeitRestart()
				{
				Process, Exist, strokeit.exe
				If ErrorLevel <> 0
					{
					Process, Close, strokeit.exe
					sleep 300 
					Run, c:\Program Files (x86)\StrokeIt\strokeit.exe 
					; Run, *RunAs c:\Program Files (x86)\StrokeIt\strokeit.exe 
					}
				Else
					Run, c:\Program Files (x86)\StrokeIt\strokeit.exe 
					; Run, *RunAs c:\Program Files (x86)\StrokeIt\strokeit.exe 
					; Run, c:\Program Files (x86)\StrokeIt\strokeit.exe
				return
				}
				return

			}
		;############End Gaming 

	;##############  mouse related 
		; All mouse related things are here, except music related 
		; also see 
			; https://autohotkey.com/docs/commands/Click.htm
			; https://autohotkey.com/docs/commands/Send.htm#Click

		{	;##############  important examples ##############
		return 
		Click  ; Click left mouse button at mouse Caret's current position.
		Click 100, 200  ; Click left mouse button at specified coordinates.
		Click 100, 200, 0  ; move mouse pointer - Move the mouse without clicking.  
		Click 100, 200 right  ; Click the right mouse button.
		Click 2  ; Perform a double-click.
		Click down  ; Presses down the left mouse button and holds it.
		Click up right  ; Releases the right mouse button.
		Send +{Click 100, 200}  ; Shift+LeftClick
		Send ^{Click 100, 200, right}  ; Control+RightClick
		return 
		} 
			;############End important examples ############## 
			
		{	;##############  Control mouse  ##############

		; determining position of mouse according to AutoHotkey
		:*:posahk::
		:*:ahkpos::
		:*:posmouse::
		:*:mousepos::
		:*:pznmouse::
		:*:mousepzn::
		:*:xpznCaret::
		:*:xCaretp::
		:*:xCaret::
		:*:xCaretp::

			MouseGetPos, xpos, ypos 
			Msgbox, The Caret is at X%xpos% Y%ypos%. 
			return 

		{	;##############  control mouse with caret (AKA input Caret)  
		; 2016-05-08 09.06 
			; updating to comment out all things never used (due to known conflicts with current system) 
		; caret is best term to use for input Caret

		{	;##############  special cases  ##############

		; move Caret to caret position and have it stay there. move mouse pointer to caret  moving mouse to 

		:*:mmcx::
		:*:mtcx::
		:*:mvtcx::
		:*:mvmcx::
		:*:mmcursx::
		:*:mmtcx::
			
			sleep 100 ; needed to wait for hotstring to be removed 
			MouseMove,(A_CaretX),(A_CaretY)
			return 

		}
			;############End special cases  ############## 

		{	;##############  Logitech F13-F24 Hotkeys Default behavior 

		/*

		Themes overview 
			""	same as ööhotstrings used to be 
			^	
			+	reverse 
			#	window control 
					scroll wheel 
					scroll wheel 
			!	Program specific 
			
		2017-12-12 08.43
			added scroll wheel alt tab 
		2017-12-05 09.53
			started using F13-F24 keys 
		*/

		; LControl & wheelup::ShiftAltTab ; works
		; LControl & wheeldown::AltTab	; works 

		SC056 & wheelup::ShiftAltTab 	; works but conflict when using capslock & 8 to scroll 
		SC056 & wheeldown::AltTab		; works but conflict when using capslock & 8 to scroll 

		; capslock & wheelup::ShiftAltTab ; works but conflict when using capslock & 8 to scroll 
		; capslock & wheeldown::AltTab	; works but conflict when using capslock & 8 to scroll 

		capslock & wheelup::Send {Volume_Up}	
		capslock & wheeldown::Send {Volume_Down}

		; ~#wheelup::Send {Volume_Up}		; does not work consistently 
		; ~#wheeldown::Send {Volume_Down}	; does not work consistently 

		; MButton::AltTabMenu 			; does not work consistently 
		; WheelDown::AltTab 			; does not work consistently 
		; WheelUp::ShiftAltTab 			; does not work consistently 

		f13::
			Send !{left}
			StuckKeyUp()
			return 

		^f13::
			Send ^c
			StuckKeyUp()
			return 

		!f13::
			; Send ^v
			StuckKeyUp()
			return 

		+f13::
			Send ^#b
			StuckKeyUp()
			return 

		#f13::
			Send ^#{left}
			StuckKeyUp()
			return 

		f14::
			Send !{right}
			Return

		^f14::
			Send ^v
			StuckKeyUp()
			return 

		!f14::
			AltTabph()
			StuckKeyUp()
			return 

		+f14::
			Send !{left}
			StuckKeyUp()
			return 

		#f14::
			Send ^#{right}
			StuckKeyUp()
			return 

		f15::
			Send ^{f4}
			Return
			
		f16::
			Send !{f4}
			Return

		f17 up:: 
			send l
			return 

		; F21:: ; Invert Colors 
			; send !#h 
			; StuckKeyUp()
			; Return

		f22 up:: ; Music play/pause 
			Send !'
			Return

		^f22::
			Send {Media_Play_Pause}
			StuckKeyUp()
			return 

		!f22::
			Send ^c
			StuckKeyUp()
			return 

		+f22::
			Send !{left}
			StuckKeyUp()
			return 

		#f22::
			Send ^#d
			StuckKeyUp()
			return 

		*f23:: ; Scroll wheel left
			Send ^+{tab}
			Return

		f24:: ; Scroll wheel right
			Send ^{tab}
			Return
			
		CapsLock & F24:: ; available 
			{
			/*
			this system can be used for § capslock etc, giving 
			
			""	
			^	
			^+	
			#	
			!	
			
			2017-12-05 10.07
				created this 
			*/ 

			GetKeyState, stateLCtrl, LCtrl
			GetKeyState, stateLAlt, LAlt
			GetKeyState, stateLShift, LShift
			GetKeyState, stateLWin, LWin
			GetKeyState, stateRCtrl, RCtrl
			GetKeyState, stateRAlt, RAlt
			GetKeyState, stateRShift, RShift
			GetKeyState, stateRWin, RWin
			GetKeyState, stateScrollLock, ScrollLock
			if stateLCtrl=D
				if stateLAlt=D
					if stateLShift=D
						if stateLWin=D ; ^!+#{x} 
							sendraw ^!+#{x} 
						else ; ^!+{x} 
							sendraw ^!+{x} 
					else if stateLWin=D ; ^!#{x} 
						sendraw ^!#{x} 
					else ; ^!{x}
						sendraw ^!{x}
				else if stateLShift=D
					if stateLWin=D ; ^+#{x} 
						sendraw ^+#{x} 
					else ; ^+{x}
						sendraw ^+{x}
				else if stateLWin=D ; ^#{x} 
					sendraw ^#{x} 
				else ; ^{x}
					sendraw ^{x}

			else if stateLAlt=D
					if stateLShift=D
						if stateLWin=D ; !+#{x} 
							sendraw !+#{x} 
						else ; !+{x} 
							sendraw !+{x} 
					else if stateLWin=D ; !#{x} 
						sendraw !#{x} 
					else ; !{x}
						sendraw !{x}
				else if stateLShift=D
					if stateLWin=D ; +#{x} 
						sendraw +#{x} 
					else ; +{x} 
						sendraw +{x}
				else if stateLWin=D ; #{x} 
					; There is an issue with § and # alone. 
					; 2017-06-01 might not be a problem when pressing § first 
					; 2016-06-30 have tried to fix it but given up for now, avoid it for now 
					sendraw #{x} 
				else ; {x} 
					{ 
					send !#h 
					StuckKeyUp()
					}
			return 
			}
	
		}
			;############End Logitech F13-F24 Hotkeys Default behavior 

		{	;##############  click
		; left click at caret 
		; 2016-03-29 18.49 x at end is necessary 

			:*:scx:: 
			:*:clcx:: ; in theory it should be cx, but not important enough to have two letter command 
				sleep 100
				MouseGetPos,X,Y
				MouseMove,(A_CaretX),(A_CaretY)
				Send {Click}
				MouseMove,(X),(Y)
				return 

		; double click at caret 
			; :*:xdcatc::
			; :*:xdccuc::

			:*:dcx:: 
				sleep 100 
				DoubleClickAtCaret(){
				sleep 100 
				MouseGetPos,X,Y
				MouseMove,(A_CaretX),(A_CaretY)
				Send {Click 2}  
				MouseMove,(X),(Y)
				return 
				}

			:*:tcx:: 
				sleep 100 
				MouseGetPos,X,Y
				MouseMove,(A_CaretX),(A_CaretY)
				Send {Click 3}  
				MouseMove,(X),(Y)
				return 

			:*:qcx:: 
				sleep 100 
				MouseGetPos,X,Y
				MouseMove,(A_CaretX),(A_CaretY)
				Send {Click 4}  
				MouseMove,(X),(Y)
				return 

		; ; left click at mouse 
			; :*:xemx:: 
				; sleep 100 
				; Send {Click}
				; return 

			; :*:xdmx:: ; 2016-03-29 18.49 can not be shortened to one c at end
				; sleep 100 
				; Send {Click 2}
				; return 

			; :*:xtmx:: ; 2016-03-29 18.49 can not be shortened to one c at end
				; sleep 100 
				; Send {Click 3}
				; return 

			; :*:xqmx:: 
				; sleep 100 
				; Send {Click 4}
				; return 

		; right click at caret 
			:*:rcx:: 
			:*:rscx:: 
			:*:rccx:: ; in theory this should be reserved for right control click, but this is more important
			:*:rccax:: 
			:*:rccx:: 
			:*:rccax:: 
				sleep 100 
				MouseGetPos,X,Y
				MouseMove,(A_CaretX),(A_CaretY)
				Send {Click right}
				MouseMove,(X),(Y)
				return 

			; :*:xdrcx:: ; 2016-03-29 18.49 can not be shortened to one c at end
				; sleep 100 
				; MouseGetPos,X,Y
				; MouseMove,(A_CaretX),(A_CaretY)
				; Send {Click right 2}  
				; MouseMove,(X),(Y)
				; return 

			; :*:xtrcx:: ; 2016-03-29 18.49 can not be shortened to one c at end
				; sleep 100 
				; MouseGetPos,X,Y
				; MouseMove,(A_CaretX),(A_CaretY)
				; Send {Click right 3}  
				; MouseMove,(X),(Y)
				; return 

			; :*:xqrcx:: 
				; sleep 100 
				; MouseGetPos,X,Y
				; MouseMove,(A_CaretX),(A_CaretY)
				; Send {Click right 4}  
				; MouseMove,(X),(Y)
				; return 

		; middle click at caret 
			:*:sicx:: 
			:*:icx:: 
			:*:iccx:: 
				sleep 100 
				MouseGetPos,X,Y
				MouseMove,(A_CaretX),(A_CaretY)
				Send {Click middle}
				MouseMove,(X),(Y)
				return 

			:*:dicx:: 
				sleep 100 
				MouseGetPos,X,Y
				MouseMove,(A_CaretX),(A_CaretY)
				Send {Click middle 2}  
				MouseMove,(X),(Y)
				return 

			:*:ticx:: 
				sleep 100 
				MouseGetPos,X,Y
				MouseMove,(A_CaretX),(A_CaretY)
				Send {Click middle 3}  
				MouseMove,(X),(Y)
				return 

			:*:xqicx:: 
				sleep 100 
				MouseGetPos,X,Y
				MouseMove,(A_CaretX),(A_CaretY)
				Send {Click middle 4}  
				MouseMove,(X),(Y)
				return 

		; middle click at mouse 
			:*:xeimx:: 
			:*:xicmx:: 
				sleep 100 
				Send {Click middle}
				return 

			:*:xdimx:: ; 2016-03-29 18.49 can not be shortened to one c at end
				sleep 100 
				Send {Click middle 2}
				return 

			:*:xtimx:: ; 2016-03-29 18.49 can not be shortened to one c at end
				sleep 100 
				Send {Click middle 3}
				return 

			:*:xqimx:: 
				sleep 100 
				Send {Click middle 4}
				return 

		}
			;############End click 

		{	;##############  ^click 
		; left click at caret 
		:*:ccx::
		:*:ccax::
		:*:xccx::
		:*:cccx::
		:*:xcccx::
		:*:cccax::
		:*:xcecx:: 
		:*:xcscx:: 
			sleep 700 
			MouseGetPos,X,Y
			MouseMove,(A_CaretX),(A_CaretY)
			Send ^{Click}
			MouseMove,(X),(Y)
			return 

		; control double click at caret
			; :*:xcdcatc::
			; :*:xcdccx::
			; :*:xcdccuc::


		:*:dccx::
		:*:cdccx::
		:*:dcccx::
		:*:xcdccax::
		:*:dcccax::

		:*:xcdcx:: 
		:*:xcdcax::
		:*:xcdcurx::
			ahkdctrlcac()
			return 

		; double control click at caret 
			ahkdctrlcac(){ 
				sleep 100 
				MouseGetPos,X,Y
				MouseMove,(A_CaretX),(A_CaretY)
				Send ^{Click 2}  
				MouseMove,(X),(Y)
				return 
				}

		:*:ctcx:: 
			sleep 100 
			MouseGetPos,X,Y
			MouseMove,(A_CaretX),(A_CaretY)
			Send ^{Click 3}  
			MouseMove,(X),(Y)
			return 

		:*:cqcx:: 
			sleep 100 
			MouseGetPos,X,Y
			MouseMove,(A_CaretX),(A_CaretY)
			Send ^{Click 4}  
			MouseMove,(X),(Y)
			return 

		; ; left click at mouse 
			; :*:xcem:: 
				; sleep 100 
				; Send ^{Click}
				; return 

			; :*:xcdm:: ; 2016-03-29 18.49 can not be shortened to one c at end
				; sleep 100 
				; Send ^{Click 2}
				; return 

			; :*:xctm:: ; 2016-03-29 18.49 can not be shortened to one c at end
				; sleep 100 
				; Send ^{Click 3}
				; return 

			; :*:xcqm:: 
				; sleep 100 
				; Send ^{Click 4}
				; return 

		; right click at caret 
			:*:cercx:: 
			:*:crcx:: 
				sleep 100 
				MouseGetPos,X,Y
				MouseMove,(A_CaretX),(A_CaretY)
				Send ^{Click right}
				MouseMove,(X),(Y)
				return 

			:*:cdrcx:: ; 2016-03-29 18.49 can not be shortened to one c at end
				sleep 100 
				MouseGetPos,X,Y
				MouseMove,(A_CaretX),(A_CaretY)
				Send ^{Click right 2}  
				MouseMove,(X),(Y)
				return 

			:*:ctrcx:: ; 2016-03-29 18.49 can not be shortened to one c at end
				sleep 100 
				MouseGetPos,X,Y
				MouseMove,(A_CaretX),(A_CaretY)
				Send ^{Click right 3}  
				MouseMove,(X),(Y)
				return 

			:*:cqrcx:: 
				sleep 100 
				MouseGetPos,X,Y
				MouseMove,(A_CaretX),(A_CaretY)
				Send ^{Click right 4}  
				MouseMove,(X),(Y)
				return 

		; ; right click at mouse 
			; :*:xcerm:: 
				; sleep 100 
				; Send ^{Click right}
				; return 

			; :*:xcdrm:: ; 2016-03-29 18.49 can not be shortened to one c at end
				; sleep 100 
				; Send ^{Click right 2}
				; return 

			; :*:xctrm:: ; 2016-03-29 18.49 can not be shortened to one c at end
				; sleep 100 
				; Send ^{Click right 3}
				; return 

			; :*:xcqrm:: 
				; sleep 100 
				; Send ^{Click right 4}
				; return 

		; middle click at caret 
			:*:ceicx:: 
			:*:cicx:: 
				sleep 100 
				MouseGetPos,X,Y
				MouseMove,(A_CaretX),(A_CaretY)
				Send ^{Click middle}
				MouseMove,(X),(Y)
				return 

			:*:cdicx:: ; 2016-03-29 18.49 can not be shortened to one c at end
				sleep 100 
				MouseGetPos,X,Y
				MouseMove,(A_CaretX),(A_CaretY)
				Send ^{Click middle 2}  
				MouseMove,(X),(Y)
				return 

			:*:cticx:: ; 2016-03-29 18.49 can not be shortened to one c at end
				sleep 100 
				MouseGetPos,X,Y
				MouseMove,(A_CaretX),(A_CaretY)
				Send ^{Click middle 3}  
				MouseMove,(X),(Y)
				return 

			:*:xcqicx:: 
				sleep 100 
				MouseGetPos,X,Y
				MouseMove,(A_CaretX),(A_CaretY)
				Send ^{Click middle 4}  
				MouseMove,(X),(Y)
				return 

		; middle click at mouse 
			:*:xceimx:: 
			:*:xccimx:: 
				sleep 100 
				Send ^{Click middle}
				return 

			:*:xcdimx:: ; 2016-03-29 18.49 can not be shortened to one c at end
				sleep 100 
				Send ^{Click middle 2}
				return 

			:*:xctimx:: ; 2016-03-29 18.49 can not be shortened to one c at end
				sleep 100 
				Send ^{Click middle 3}
				return 

			:*:xcqimx:: 
				sleep 100 
				Send ^{Click middle 4}
				return 

		}
			;############End ^click 

		{	;##############  !click
		; left click at caret 
			:*:ascx:: 
			:*:acx:: 
				sleep 100 
				MouseGetPos,X,Y
				MouseMove,(A_CaretX),(A_CaretY)
				Send !{Click}
				MouseMove,(X),(Y)
				return 

			:*:adcx:: 
				sleep 100 
				MouseGetPos,X,Y
				MouseMove,(A_CaretX),(A_CaretY)
				Send !{Click 2}  
				MouseMove,(X),(Y)
				return 

			:*:atcx:: 
				sleep 100 
				MouseGetPos,X,Y
				MouseMove,(A_CaretX),(A_CaretY)
				Send !{Click 3}  
				MouseMove,(X),(Y)
				return 

			:*:aqcx:: 
				sleep 100 
				MouseGetPos,X,Y
				MouseMove,(A_CaretX),(A_CaretY)
				Send !{Click 4}  
				MouseMove,(X),(Y)
				return 

		; left click at mouse 
			:*:asmx:: 
			:*:asmcx:: 
				sleep 100 
				Send !{Click}
				return 

			:*:admx:: 
			:*:admcx:: 
				sleep 100 
				Send !{Click 2}
				return 

			:*:atmx:: 
			:*:atmcx:: 
				sleep 100 
				Send !{Click 3}
				return 

			:*:aqmx:: 
			:*:aqmcx:: 
				sleep 100 
				Send !{Click 4}
				return 

		; right click at caret 
			:*:aercx:: 
			:*:arcx:: 
				sleep 100 
				MouseGetPos,X,Y
				MouseMove,(A_CaretX),(A_CaretY)
				Send !{Click right}
				MouseMove,(X),(Y)
				return 

			:*:adrcx:: ; 2016-03-29 18.49 can not be shortened to one c at end
				sleep 100 
				MouseGetPos,X,Y
				MouseMove,(A_CaretX),(A_CaretY)
				Send !{Click right 2}  
				MouseMove,(X),(Y)
				return 

			:*:atrcx:: ; 2016-03-29 18.49 can not be shortened to one c at end
				sleep 100 
				MouseGetPos,X,Y
				MouseMove,(A_CaretX),(A_CaretY)
				Send !{Click right 3}  
				MouseMove,(X),(Y)
				return 

			:*:aqrcx:: 
				sleep 100 
				MouseGetPos,X,Y
				MouseMove,(A_CaretX),(A_CaretY)
				Send !{Click right 4}  
				MouseMove,(X),(Y)
				return 

		; right click at mouse 
			:*:aermx:: 
				sleep 100 
				Send !{Click right}
				return 

			:*:adrmx:: ; 2016-03-29 18.49 can not be shortened to one c at end
				sleep 100 
				Send !{Click right 2}
				return 

			:*:atrmx:: ; 2016-03-29 18.49 can not be shortened to one c at end
				sleep 100 
				Send !{Click right 3}
				return 

			:*:aqrmx:: 
				sleep 100 
				Send !{Click right 4}
				return 

		; middle click at caret 
			:*:aeicx:: 
			:*:aicx:: 
				sleep 100 
				MouseGetPos,X,Y
				MouseMove,(A_CaretX),(A_CaretY)
				Send !{Click middle}
				MouseMove,(X),(Y)
				return 

			:*:adicx:: ; 2016-03-29 18.49 can not be shortened to one c at end
				sleep 100 
				MouseGetPos,X,Y
				MouseMove,(A_CaretX),(A_CaretY)
				Send !{Click middle 2}  
				MouseMove,(X),(Y)
				return 

			:*:aticx:: ; 2016-03-29 18.49 can not be shortened to one c at end
				sleep 100 
				MouseGetPos,X,Y
				MouseMove,(A_CaretX),(A_CaretY)
				Send !{Click middle 3}  
				MouseMove,(X),(Y)
				return 

			:*:aqicx:: 
				sleep 100 
				MouseGetPos,X,Y
				MouseMove,(A_CaretX),(A_CaretY)
				Send !{Click middle 4}  
				MouseMove,(X),(Y)
				return 

		; middle click at mouse 
			:*:aeimx:: 
				sleep 100 
				Send !{Click middle}
				return 

			:*:adimx:: ; 2016-03-29 18.49 can not be shortened to one c at end
				sleep 100 
				Send !{Click middle 2}
				return 

			:*:atimx:: ; 2016-03-29 18.49 can not be shortened to one c at end
				sleep 100 
				Send !{Click middle 3}
				return 

			:*:aqimx:: 
				sleep 100 
				Send !{Click middle 4}
				return 
		}
			;############End !click 

		{	;##############  +click
		; left click at caret 
			:*:xsecx:: 
				sleep 100 
				MouseGetPos,X,Y
				MouseMove,(A_CaretX),(A_CaretY)
				Send +{Click}
				MouseMove,(X),(Y)
				return 

			:*:xsdcx:: ; 2016-03-29 18.49 can not be shortened to one c at end
				sleep 100 
				MouseGetPos,X,Y
				MouseMove,(A_CaretX),(A_CaretY)
				Send +{Click 2}  
				MouseMove,(X),(Y)
				return 

			:*:xstcx:: ; 2016-03-29 18.49 can not be shortened to one c at end
				sleep 100 
				MouseGetPos,X,Y
				MouseMove,(A_CaretX),(A_CaretY)
				Send +{Click 3}  
				MouseMove,(X),(Y)
				return 

			:*:xsqcx:: 
				sleep 100 
				MouseGetPos,X,Y
				MouseMove,(A_CaretX),(A_CaretY)
				Send +{Click 4}  
				MouseMove,(X),(Y)
				return 

		; left click at mouse 
			:*:xsemx:: 
				sleep 100 
				Send +{Click}
				return 

			:*:xsdmx:: ; 2016-03-29 18.49 can not be shortened to one c at end
				sleep 100 
				Send +{Click 2}
				return 

			:*:xstmx:: ; 2016-03-29 18.49 can not be shortened to one c at end
				sleep 100 
				Send +{Click 3}
				return 

			:*:xsqmx:: 
				sleep 100 
				Send +{Click 4}
				return 

		; right click at caret 
			:*:xsercx:: 
			:*:xsrcx:: 
				sleep 100 
				MouseGetPos,X,Y
				MouseMove,(A_CaretX),(A_CaretY)
				Send +{Click right}
				MouseMove,(X),(Y)
				return 

			:*:xsdrcx:: ; 2016-03-29 18.49 can not be shortened to one c at end
				sleep 100 
				MouseGetPos,X,Y
				MouseMove,(A_CaretX),(A_CaretY)
				Send +{Click right 2}  
				MouseMove,(X),(Y)
				return 

			:*:xstrcx:: ; 2016-03-29 18.49 can not be shortened to one c at end
				sleep 100 
				MouseGetPos,X,Y
				MouseMove,(A_CaretX),(A_CaretY)
				Send +{Click right 3}  
				MouseMove,(X),(Y)
				return 

			:*:xsqrcx:: 
				sleep 100 
				MouseGetPos,X,Y
				MouseMove,(A_CaretX),(A_CaretY)
				Send +{Click right 4}  
				MouseMove,(X),(Y)
				return 

		; right click at mouse 
			:*:xsermx:: 
				sleep 100 
				Send +{Click right}
				return 

			:*:xsdrmx:: ; 2016-03-29 18.49 can not be shortened to one c at end
				sleep 100 
				Send +{Click right 2}
				return 

			:*:xstrmx:: ; 2016-03-29 18.49 can not be shortened to one c at end
				sleep 100 
				Send +{Click right 3}
				return 

			:*:xsqrmx:: 
				sleep 100 
				Send +{Click right 4}
				return 

		; middle click at caret 
			:*:xseicx:: 
			:*:xsicx:: 
				sleep 100 
				MouseGetPos,X,Y
				MouseMove,(A_CaretX),(A_CaretY)
				Send +{Click middle}
				MouseMove,(X),(Y)
				return 

			:*:xsdicx:: ; 2016-03-29 18.49 can not be shortened to one c at end
				sleep 100 
				MouseGetPos,X,Y
				MouseMove,(A_CaretX),(A_CaretY)
				Send +{Click middle 2}  
				MouseMove,(X),(Y)
				return 

			:*:xsticx:: ; 2016-03-29 18.49 can not be shortened to one c at end
				sleep 100 
				MouseGetPos,X,Y
				MouseMove,(A_CaretX),(A_CaretY)
				Send +{Click middle 3}  
				MouseMove,(X),(Y)
				return 

			:*:xsqicx:: 
				sleep 100 
				MouseGetPos,X,Y
				MouseMove,(A_CaretX),(A_CaretY)
				Send +{Click middle 4}  
				MouseMove,(X),(Y)
				return 

		; middle click at mouse 
			:*:xseimx:: 
				sleep 100 
				Send +{Click middle}
				return 

			:*:xsdimx:: ; 2016-03-29 18.49 can not be shortened to one c at end
				sleep 100 
				Send +{Click middle 2}
				return 

			:*:xstimx:: ; 2016-03-29 18.49 can not be shortened to one c at end
				sleep 100 
				Send +{Click middle 3}
				return 

			:*:xsqimx:: 
				sleep 100 
				Send +{Click middle 4}
				return 

		}
			;############End +click 

		{	;##############  #click
		; left click at caret 
			:*:xwecx:: 
				sleep 100 
				MouseGetPos,X,Y
				MouseMove,(A_CaretX),(A_CaretY)
				Send #{Click}
				MouseMove,(X),(Y)
				return 

			:*:xwdcx:: ; 2016-03-29 18.49 can not be shortened to one c at end
				sleep 100 
				MouseGetPos,X,Y
				MouseMove,(A_CaretX),(A_CaretY)
				Send #{Click 2}  
				MouseMove,(X),(Y)
				return 

			:*:xwtcx:: ; 2016-03-29 18.49 can not be shortened to one c at end
				sleep 100 
				MouseGetPos,X,Y
				MouseMove,(A_CaretX),(A_CaretY)
				Send #{Click 3}  
				MouseMove,(X),(Y)
				return 

			:*:xwqcx:: 
				sleep 100 
				MouseGetPos,X,Y
				MouseMove,(A_CaretX),(A_CaretY)
				Send #{Click 4}  
				MouseMove,(X),(Y)
				return 

		; left click at mouse 
			:*:xwemx:: 
				sleep 100 
				Send #{Click}
				return 

			:*:xwdmx:: ; 2016-03-29 18.49 can not be shortened to one c at end
				sleep 100 
				Send #{Click 2}
				return 

			:*:xwtmx:: ; 2016-03-29 18.49 can not be shortened to one c at end
				sleep 100 
				Send #{Click 3}
				return 

			:*:xwqmx:: 
				sleep 100 
				Send #{Click 4}
				return 

		; right click at caret 
			:*:xwercx:: 
			:*:xwrcx:: 
				sleep 100 
				MouseGetPos,X,Y
				MouseMove,(A_CaretX),(A_CaretY)
				Send #{Click right}
				MouseMove,(X),(Y)
				return 

			:*:xwdrcx:: ; 2016-03-29 18.49 can not be shortened to one c at end
				sleep 100 
				MouseGetPos,X,Y
				MouseMove,(A_CaretX),(A_CaretY)
				Send #{Click right 2}  
				MouseMove,(X),(Y)
				return 

			:*:xwtrcx:: ; 2016-03-29 18.49 can not be shortened to one c at end
				sleep 100 
				MouseGetPos,X,Y
				MouseMove,(A_CaretX),(A_CaretY)
				Send #{Click right 3}  
				MouseMove,(X),(Y)
				return 

			:*:xwqrcx:: 
				sleep 100 
				MouseGetPos,X,Y
				MouseMove,(A_CaretX),(A_CaretY)
				Send #{Click right 4}  
				MouseMove,(X),(Y)
				return 

		; right click at mouse 
			:*:xwermx:: 
				sleep 100 
				Send #{Click right}
				return 

			:*:xwdrmx:: ; 2016-03-29 18.49 can not be shortened to one c at end
				sleep 100 
				Send #{Click right 2}
				return 

			:*:xwtrmx:: ; 2016-03-29 18.49 can not be shortened to one c at end
				sleep 100 
				Send #{Click right 3}
				return 

			:*:xwqrmx:: 
				sleep 100 
				Send #{Click right 4}
				return 

		; middle click at caret 
			:*:xweicx:: 
			:*:xwicx:: 
				sleep 100 
				MouseGetPos,X,Y
				MouseMove,(A_CaretX),(A_CaretY)
				Send #{Click middle}
				MouseMove,(X),(Y)
				return 

			:*:xwdicx:: ; 2016-03-29 18.49 can not be shortened to one c at end
				sleep 100 
				MouseGetPos,X,Y
				MouseMove,(A_CaretX),(A_CaretY)
				Send #{Click middle 2}  
				MouseMove,(X),(Y)
				return 

			:*:xwticx:: ; 2016-03-29 18.49 can not be shortened to one c at end
				sleep 100 
				MouseGetPos,X,Y
				MouseMove,(A_CaretX),(A_CaretY)
				Send #{Click middle 3}  
				MouseMove,(X),(Y)
				return 

			:*:xwqicx:: 
				sleep 100 
				MouseGetPos,X,Y
				MouseMove,(A_CaretX),(A_CaretY)
				Send #{Click middle 4}  
				MouseMove,(X),(Y)
				return 

		; middle click at mouse 
			:*:xweimx:: 
				sleep 100 
				Send #{Click middle}
				return 

			:*:xwdimx:: ; 2016-03-29 18.49 can not be shortened to one c at end
				sleep 100 
				Send #{Click middle 2}
				return 

			:*:xwtimx:: ; 2016-03-29 18.49 can not be shortened to one c at end
				sleep 100 
				Send #{Click middle 3}
				return 

			:*:xwqimx:: 
				sleep 100 
				Send #{Click middle 4}
				return 

		}
			;############End #click 

		{	;##############  draw using mouse   ##############
		return 
		; ::ahktest::
		; The following example opens MS Paint and draws a little house:
			Run, mspaint.exe
			WinWaitActive, ahk_class MSPaintApp,, 2
			if ErrorLevel
				return
			MouseClickDrag, L, 150, 350, 150, 250
			MouseClickDrag, L, 150, 250, 200, 200
			MouseClickDrag, L, 200, 200, 250, 250
			MouseClickDrag, L, 250, 250, 150, 250
			MouseClickDrag, L, 150, 250, 250, 350
			MouseClickDrag, L, 250, 350, 250, 250
			MouseClickDrag, L, 250, 250, 150, 350
			MouseClickDrag, L, 150, 350, 250, 350
			return 
		
		}
			;############End draw using mouse   ############## 
			
		}
			;############End control mouse with caret (AKA input Caret) 
			
		{	;##############  scrolling  ##############
		; Scroll left.
			CapsLock & 6:: 
			ControlGetFocus, fcontrol, A
			Loop 2  ; <-- Increase this value to scroll faster.
				SendMessage, 0x114, 0, 0, %fcontrol%, A  ; 0x114 is WM_HSCROLL and the 0 after it is SB_LINELEFT.
			return

			~LShift & WheelUp::  
				ControlGetFocus, fcontrol, A
			Loop 2  ; <-- Increase this value to scroll faster.
				SendMessage, 0x114, 0, 0, %fcontrol%, A  ; 0x114 is WM_HSCROLL and the 0 after it is SB_LINELEFT.
			return

		;Scroll right. 
			CapsLock & 7:: 
			ControlGetFocus, fcontrol, A
			Loop 2  ; <-- Increase this value to scroll faster.
				SendMessage, 0x114, 1, 0, %fcontrol%, A  ; 0x114 is WM_HSCROLL and the 1 after it is SB_LINERIGHT.
			return
			~LShift & WheelDown::  
			ControlGetFocus, fcontrol, A
			Loop 2  ; <-- Increase this value to scroll faster.
				SendMessage, 0x114, 1, 0, %fcontrol%, A  ; 0x114 is WM_HSCROLL and the 1 after it is SB_LINERIGHT.
			return
			; example using click: 
			;Send +{Click 100, 200}  ; Shift+LeftClick
			;Send ^{Click 100, 200, right}  ; Control+RightClick
			;Click  ; Click left mouse button at mouse Caret's current position.
		
		}
			;############End scrolling  ############## 

		{	;##############  Moving mouse and/or clicking  ##############
		; Only the nonspecific ones are here, rest in each program 

		; example:
			; :*:xwec:: 
				; sleep 100 
				; MouseGetPos,X,Y
				; MouseMove,(A_CaretX),(A_CaretY)
				; Send #{Click}
				; MouseMove,(X),(Y)
				; return 

		:*:4rswp::
			{
			Click 1901, 54, 1  ; Click left mouse button at specified coordinates.
			RETURN 
			}

		:*:4rsw1p::
		:*:4rs1p:: 
			{
			Click 1901, 54, 1  ; Click left mouse button at specified coordinates.
			sleep 100
			Click 1901, 164, 1  ; Click left mouse button at specified coordinates.
			RETURN 
			}

		}
			;############End Moving mouse and/or clicking  ############## 
				
		}
			;############End Control mouse  ############## 
			
		;##############  available mouse abbreviations

			; RButton & MButton::Send {Media_Play_Pause}; available 
			; MButton & RButton::send 33s ; this works, never need it = available 

;##############  Specific programs 
	/*
	Organized by category when controlling several related programs 
	RefInfo: rahk --> ifwinActive 
	*/

	; Template newprogramname template 
		{	;##############  Archive Template newprogramname (
			/*
			Templates that should not be part of Newprogramname 
			Things not useful at the moment kept here for future reference 
			2018-01-24 12.10
				moved Strokeit gestures from template here since it is not always useful (and sometimes conflict, should probably update template to send same keys to make sure no conflict 
				
			*/

			{	;##############  Strokeit Gestures (
			/*

			*/
			

			; ; Strokeit Always program specific gestures 
			; !+F1::			;T upside
				; ; 2014-10-02 14.45 - had very strange issue with this changing the projector settings (after realising it it was easy to change it back (win+p, wait 2 secs, press enter, repeat if necessary)) 
				; sleep 100
				; ; send available 
				; return

			; ^+s::			;Down Up
				; sleep 100
				; ; send available 
				; return

			; ^!+s::			;left right
				; sleep 100
				; ; send available 
				; return

			; ^!+f1::			;Left
				; sleep 100
				; ; send available 
				; return

			; ^!+f2::			;Right
				; sleep 100
				; ; send available 
				; return

			; ^!+f4::			;up down up
				; sleep 100
				; ; send available 
				; return

			; ^!+f5::			;Up
				; sleep 100
				; ; send available 
				; return

			; ^!+f6::			;Down
				; sleep 100
				; ; send available 
				; return

			; ; ^!+f9::			; Down up down AND Rotate right surface dial
				; ; sleep 100
				; ; ; send available 
				; ; return

			; ; ^!+f10::		;left right left
				; ; sleep 100
				; send available 
				; ; return

			; ^!+f11::		;right down 
				; sleep 100
				; ; send available 
				; return

			; ^!+f12::		;right up program specific
				; sleep 100
				; ; send available 
				; return

			; +#M::			;/ Up - / DownRestore All 
				; sleep 100
				; ; send available 
				; return


			}
				;############End Strokeit Gestures )

			{	;##############  surface pen commands Template (

			/*
			below from https://www.reddit.com/r/Surface/comments/3356za/a_little_script_for_onenote_and_powerpoint/
			2017-10-12 20.50
				updating to use single click as undo 
			2017-08-29 12.07
				updated this with PenCounter 
			*/

			; PenCounternewprogramname = 1 
			; PenCounternewprogramnameDclick = 1 
				/*

				2017-08-29 12.10
					this should be correct to have here for use with surface pen counter 
					this way it is reset each time AutoHotkey is restarted but unique for each program it is used within 
				*/
			
			; #F20:: ; Single click surface pen in newprogramname

			; advanced version 
				; PenCounternewprogramname ++

				; If PenCounternewprogramname >= 4 
					; {
					; Sleep 10
					; PenCounternewprogramname = 1
					; StuckKeyUp()
					; msgbox %PenCounternewprogramname% ; test to confirm everything is working correctly 
					; ; Send !%PenCounternewprogramname%
					; }
				; else If PenCounternewprogramname = 2
					; {
					; msgbox %PenCounternewprogramname% ; test to confirm everything is working correctly 
					; StuckKeyUp()
					; }

				; else if PenCounternewprogramname = 3 
					; {
					; msgbox %PenCounternewprogramname% ; test to confirm everything is working correctly 
					; }

			; Return

			; simple version 
				; ; PenCounternewprogramname ++
				; ; If PenCounternewprogramname = 5
					; ; PenCounternewprogramname = 1
				; ; StuckKeyUp()
				; ; ; Send {LAlt Down}%PenCounternewprogramname%{LAlt Up}
				; ; ; msgbox %PenCounternewprogramname% ; test to confirm everything is working correctly 
				; ; StuckKeyUp()
				; ; Return

			; #F19:: ; Doble click surface pen in newprogramname

			; OneNote 2017-09-06 version 
				; PenCounterOneNoteDClick ++
				; If PenCounterOneNoteDClick < 5 ; should not be required but is for unknown reason 
					; PenCounterOneNoteDClick = 5
				; If PenCounterOneNoteDClick = 7
					; PenCounterOneNoteDClick = 5
				; StuckKeyUp()
				; Send !%PenCounterOneNoteDClick%
				; ; msgbox %PenCounterOneNoteDClick% ; test to confirm everything is working correctly 
				; StuckKeyUp()
				; Return


			; old version 
				; PenCounternewprogramnameDClick ++
				; If PenCounternewprogramnameDClick = 4
					; PenCounternewprogramnameDClick = 1
				; StuckKeyUp()
				; ; Send !%PenCounternewprogramnameDClick%
				; ; msgbox %PenCounternewprogramnameDClick% ; test to confirm everything is working correctly 
				; StuckKeyUp()
				; Return

			; #F18:: ; long press surface pen in newprogramname
				; sleep 300
				; sendraw ava
				; sleep 100
				; return

			}
				;############End surface pen commands Template ) 

		}
			;############End Archive Template newprogramname )


		/*

		Documentation 
			2018-04-15 13.59
				started updating this template to work with Visual Studio Code. several things left to do 
			
			2018-01-20 12.08
				removed mouse commands, surface pen, and move mouse pointer (copy and paste when needed as the default is preferred in most cases (DRY))
			2017-08-30 12.38
				updated Strokeit gestures 

		Innstructions 
			; 1. copy and paste directly below here (oe9, ^+b) into temp.ahk
			; 2. replace newprogramname with program name (has to be as one word no space)
			; 3. replace newprogramnamwinTitle (if necessary)
			; 4. go to the instruction section directly below the ifwinActive command for further instructions 
			*/

		; ############## newprogramname
			/*
			newprogramname RefInfo
			Documentation
			*/

			;##############  newprogramname active(
				; possible to use  more specific name using ahk_class (find using xwinspy) 
				#IfwinActive, newprogramnamwinTitle 
				; surface dial commands inside newprogramname
					^!+f8:: ; rotate left surface dial AND 
						sleep 300
						msgbox testLeft
						sleep 100
						return

					^!+f9:: ; Rotate right surface dial AND Down up down
						sleep 300
						msgbox testRight
						sleep 100
						return

					^!+f10:: ; click surface dial
						sleep 300
						msgbox testClick
						sleep 100
						return


				§ & a:: ; [comment here "theme of this hotkey"] 
					{
					/*

					Themes
						""	
						^	
						+	reverse 
						#	
						!	
						
					Add comments here using "ncmtli" (performs ^d, li9, ncmth)
					
					*/ 

					GetKeyState, stateLCtrl, LCtrl
					GetKeyState, stateLAlt, LAlt
					GetKeyState, stateLShift, LShift
					GetKeyState, stateLWin, LWin
					GetKeyState, stateRCtrl, RCtrl
					GetKeyState, stateRAlt, RAlt
					GetKeyState, stateRShift, RShift
					GetKeyState, stateRWin, RWin
					GetKeyState, stateScrollLock, ScrollLock
					if stateLCtrl=D
						if stateLAlt=D
							if stateLShift=D
								if stateLWin=D ; ^!+#{x} 
									sendraw ^!+#{x} 
								else ; ^!+{x} 
									sendraw ^!+{x} 
							else if stateLWin=D ; ^!#{x} 
								sendraw ^!#{x} 
							else ; ^!{x}
								sendraw ^!{x}
						else if stateLShift=D
							if stateLWin=D ; ^+#{x} 
								sendraw ^+#{x} 
							else ; ^+{x}
								sendraw ^+{x}
						else if stateLWin=D ; ^#{x} 
							sendraw ^#{x} 
						else ; ^{x}
							sendraw ^{x}

					else if stateLAlt=D
							if stateLShift=D
								if stateLWin=D ; !+#{x} 
									sendraw !+#{x} 
								else ; !+{x} 
									sendraw !+{x} 
							else if stateLWin=D ; !#{x} 
								sendraw !#{x} 
							else ; !{x}
								sendraw !{x}
						else if stateLShift=D
							if stateLWin=D ; +#{x} 
								sendraw +#{x} 
							else ; +{x} 
								sendraw +{x}
						else if stateLWin=D ; #{x} 
							; There is an issue with § and # alone. 
							; 2017-06-01 might not be a problem when pressing § first 
							; 2016-06-30 have tried to fix it but given up for now, avoid it for now 
							sendraw #{x} 
						else ; {x} 
							{ 
							sendraw {x} 
							}
					StuckKeyUp() ; 2018-01-21 20.11 moved it here, not evaluated 
					return 
					}

				§ & o:: ; [comment here "theme of this hotkey"] 
					{
					/*

					Themes
						""	
						^	
						+	reverse 
						#	
						!	
						
					Add comments here using "ncmtli" (performs ^d, li9, ncmth)
					
					*/ 

					GetKeyState, stateLCtrl, LCtrl
					GetKeyState, stateLAlt, LAlt
					GetKeyState, stateLShift, LShift
					GetKeyState, stateLWin, LWin
					GetKeyState, stateRCtrl, RCtrl
					GetKeyState, stateRAlt, RAlt
					GetKeyState, stateRShift, RShift
					GetKeyState, stateRWin, RWin
					GetKeyState, stateScrollLock, ScrollLock
					if stateLCtrl=D
						if stateLAlt=D
							if stateLShift=D
								if stateLWin=D ; ^!+#{x} 
									sendraw ^!+#{x} 
								else ; ^!+{x} 
									sendraw ^!+{x} 
							else if stateLWin=D ; ^!#{x} 
								sendraw ^!#{x} 
							else ; ^!{x}
								sendraw ^!{x}
						else if stateLShift=D
							if stateLWin=D ; ^+#{x} 
								sendraw ^+#{x} 
							else ; ^+{x}
								sendraw ^+{x}
						else if stateLWin=D ; ^#{x} 
							sendraw ^#{x} 
						else ; ^{x}
							sendraw ^{x}

					else if stateLAlt=D
							if stateLShift=D
								if stateLWin=D ; !+#{x} 
									sendraw !+#{x} 
								else ; !+{x} 
									sendraw !+{x} 
							else if stateLWin=D ; !#{x} 
								sendraw !#{x} 
							else ; !{x}
								sendraw !{x}
						else if stateLShift=D
							if stateLWin=D ; +#{x} 
								sendraw +#{x} 
							else ; +{x} 
								sendraw +{x}
						else if stateLWin=D ; #{x} 
							; There is an issue with § and # alone. 
							; 2017-06-01 might not be a problem when pressing § first 
							; 2016-06-30 have tried to fix it but given up for now, avoid it for now 
							sendraw #{x} 
						else ; {x} 
							{ 
							sendraw {x} 
							}
					StuckKeyUp() ; 2018-01-21 20.11 moved it here, not evaluated 
					return 
					}

				§ & x:: ; [comment here "theme of this hotkey"]
					{
					/*
					Themes
						""	
						^	
						+	reverse 
						#	
						!	
						
					Add comments here using "ncmtli" (performs ^d, li9, ncmth)
					*/ 

					GetKeyState, stateLCtrl, LCtrl
					GetKeyState, stateLAlt, LAlt
					GetKeyState, stateLShift, LShift
					GetKeyState, stateLWin, LWin
					GetKeyState, stateRCtrl, RCtrl
					GetKeyState, stateRAlt, RAlt
					GetKeyState, stateRShift, RShift
					GetKeyState, stateRWin, RWin
					GetKeyState, stateScrollLock, ScrollLock
					if stateLCtrl=D
						if stateLAlt=D
							if stateLShift=D
								if stateLWin=D ; ^!+#{x} 
									sendraw ^!+#{x} 
								else ; ^!+{x} 
									sendraw ^!+{x} 
							else if stateLWin=D ; ^!#{x} 
								sendraw ^!#{x} 
							else ; ^!{x}
								sendraw ^!{x}
						else if stateLShift=D
							if stateLWin=D ; ^+#{x} 
								sendraw ^+#{x} 
							else ; ^+{x}
								sendraw ^+{x}
						else if stateLWin=D ; ^#{x} 
							sendraw ^#{x} 
						else ; ^{x}
							sendraw ^{x}

					else if stateLAlt=D
							if stateLShift=D
								if stateLWin=D ; !+#{x} 
									sendraw !+#{x} 
								else ; !+{x} 
									sendraw !+{x} 
							else if stateLWin=D ; !#{x} 
								sendraw !#{x} 
							else ; !{x}
								sendraw !{x}
						else if stateLShift=D
							if stateLWin=D ; +#{x} 
								sendraw +#{x} 
							else ; +{x} 
								sendraw +{x}
						else if stateLWin=D ; #{x} 
							; There is an issue with § and # alone. 
							; 2017-06-01 might not be a problem when pressing § first 
							; 2016-06-30 have tried to fix it but given up for now, avoid it for now 
							sendraw #{x} 
						else ; {x} 
							{ 
							sendraw {x} 
							}
					StuckKeyUp() ; 2018-01-21 20.11 moved it here, not evaluated 
					return 
					}

				CapsLock & a:: ; [comment here "theme of this hotkey"]
					{
					/*

					Themes
						""	
						^	
						+	reverse 
						#	
						!	
						
					Add comments here using "ncmtli" (performs ^d, li9, ncmth)
					
					*/ 

					GetKeyState, stateLCtrl, LCtrl
					GetKeyState, stateLAlt, LAlt
					GetKeyState, stateLShift, LShift
					GetKeyState, stateLWin, LWin
					GetKeyState, stateRCtrl, RCtrl
					GetKeyState, stateRAlt, RAlt
					GetKeyState, stateRShift, RShift
					GetKeyState, stateRWin, RWin
					GetKeyState, stateScrollLock, ScrollLock
					if stateLCtrl=D
						if stateLAlt=D
							if stateLShift=D
								if stateLWin=D ; ^!+#{x} 
									sendraw ^!+#{x} 
								else ; ^!+{x} 
									sendraw ^!+{x} 
							else if stateLWin=D ; ^!#{x} 
								sendraw ^!#{x} 
							else ; ^!{x}
								sendraw ^!{x}
						else if stateLShift=D
							if stateLWin=D ; ^+#{x} 
								sendraw ^+#{x} 
							else ; ^+{x}
								sendraw ^+{x}
						else if stateLWin=D ; ^#{x} 
							sendraw ^#{x} 
						else ; ^{x}
							sendraw ^{x}

					else if stateLAlt=D
							if stateLShift=D
								if stateLWin=D ; !+#{x} 
									sendraw !+#{x} 
								else ; !+{x} 
									sendraw !+{x} 
							else if stateLWin=D ; !#{x} 
								sendraw !#{x} 
							else ; !{x}
								sendraw !{x}
						else if stateLShift=D
							if stateLWin=D ; +#{x} 
								sendraw +#{x} 
							else ; +{x} 
								sendraw +{x}
						else if stateLWin=D ; #{x} 
							; There is an issue with § and # alone. 
							; 2017-06-01 might not be a problem when pressing § first 
							; 2016-06-30 have tried to fix it but given up for now, avoid it for now 
							sendraw #{x} 
						else ; {x} 
							{ 
							sendraw {x} 
							}
					StuckKeyUp() ; 2018-01-21 20.11 moved it here, not evaluated 
					return 
					}

				CapsLock & w:: ; [comment here "theme of this hotkey"]
					{
					/*

					Themes
						""	
						^	
						+	reverse 
						#	
						!	
						
					Add comments here using "ncmtli" (performs ^d, li9, ncmth)
					
					*/ 

					GetKeyState, stateLCtrl, LCtrl
					GetKeyState, stateLAlt, LAlt
					GetKeyState, stateLShift, LShift
					GetKeyState, stateLWin, LWin
					GetKeyState, stateRCtrl, RCtrl
					GetKeyState, stateRAlt, RAlt
					GetKeyState, stateRShift, RShift
					GetKeyState, stateRWin, RWin
					GetKeyState, stateScrollLock, ScrollLock
					if stateLCtrl=D
						if stateLAlt=D
							if stateLShift=D
								if stateLWin=D ; ^!+#{x} 
									sendraw ^!+#{x} 
								else ; ^!+{x} 
									sendraw ^!+{x} 
							else if stateLWin=D ; ^!#{x} 
								sendraw ^!#{x} 
							else ; ^!{x}
								sendraw ^!{x}
						else if stateLShift=D
							if stateLWin=D ; ^+#{x} 
								sendraw ^+#{x} 
							else ; ^+{x}
								sendraw ^+{x}
						else if stateLWin=D ; ^#{x} 
							sendraw ^#{x} 
						else ; ^{x}
							sendraw ^{x}

					else if stateLAlt=D
							if stateLShift=D
								if stateLWin=D ; !+#{x} 
									sendraw !+#{x} 
								else ; !+{x} 
									sendraw !+{x} 
							else if stateLWin=D ; !#{x} 
								sendraw !#{x} 
							else ; !{x}
								sendraw !{x}
						else if stateLShift=D
							if stateLWin=D ; +#{x} 
								sendraw +#{x} 
							else ; +{x} 
								sendraw +{x}
						else if stateLWin=D ; #{x} 
							; There is an issue with § and # alone. 
							; 2017-06-01 might not be a problem when pressing § first 
							; 2016-06-30 have tried to fix it but given up for now, avoid it for now 
							sendraw #{x} 
						else ; {x} 
							{ 
							sendraw {x} 
							}
					StuckKeyUp() ; 2018-01-21 20.11 moved it here, not evaluated 
					return 
					}


				^#h::
					return 

				^!#h::
					return 

				+#h::
					sleep 300 
					send {end 3}
					send +{home 3}
					sleep 300 
					send {f9} 
					return 


				return 
				#ifwinactive 

			;##############  Outside newprogramname
			; Activate newprogramname
			; :*:xl4newprogramabr::
				; ahkOpennewprogramname()
				; return 

				; ahkOpennewprogramname(){
					; IfWinExist, newprogramnamwinTitle
					; {
						; WinActivate  ; Automatically uses the window found above.
						; WinMaximize  
						; return
					; }
					; else
					; {
						; winactivate newprogramnamwinTitle
						; WinMove, 40, 40  ; Move window to a new position.
						; return
					; }			
				; }

			;##############  Archive newprogramname
				/*
				Things not useful at the moment kept here for future reference 
				*/


	{	;##############  should be first to get priority (
			; Controls activated by placing the mouse over the taskbar mouse over taskbar commands 
				#If MouseIsOver("ahk_class Shell_TrayWnd")
				WheelUp::Send {Volume_Up}
				WheelDown::Send {Volume_Down}
				MButton::Send {Media_Play_Pause}
				f23::
				:*:åå1::
					{	
					send {Media_Prev}
					StuckKeyUp()
					return 
					}
				f24::
				:*:åå2::
					{	
					send {Media_Next}
					StuckKeyUp()
					return 
					}
				f13::
				:*:öö1::
					Run, https://www.facebook.com/lists/10150802422500311 
					return 
				f14::
				:*:öö2::
					{
					send !'
					StuckKeyUp()
					return 
					}
				MouseIsOver(WinTitle) {
					MouseGetPos,,, Win
					return WinExist(WinTitle . " ahk_id " . Win)
				}
				#IF

		}
			;############End should be first to get priority ) 

	{	;##############  Adobe Acrobat Pro 
		#IfWinActive Acrobat
		:*:xhx:: ; yyy temporary or window specific 
			CopySelectedAltTabMolcAltTab()
			return 

		:*:xmolsw::
			sleep 500 
			send ^c
			sleep 100 
			xahkmolcb()
			sleep 100
			AhkSaveAsAdobe()
			return 

		^+!s::
			sleep 100 
			; send ^c
			AhkSaveAsAdobe()
			return 

		^+s::
			sleep 100 
			; send ^c
			AhkSaveAs()
			return 

		#ifwinActive 

		}
		;############End Adobe Acrobat Pro 


	{	;##############  Breevy  
		/*
		2017-06-17 10.58
			worked on 4bnx 
				moved it here 
		2017-04-05 14.07
			added second Breevy activation method (not working at the moment)
		*/

		; /in-/activate Breevy toggle Breevy active 
			:*:4bonx:: 
			:*:4boff:: 
			:*:4btog:: 
			:*:4bactv:: 
			:*:4bacv: 
				sleep 500 
				send !{F10}
				;Send {alt Down}
				;sleep 100
				;Send {f10 Down} 
				;sleep 100
				;Send {alt Up}{f10 Up}
				return

		; Activate Breevy 
			; >+space::
				; BreevyActivate()
				; return 

			BreevyActivate(){
				/*
				
				2017-06-21 11.16
					changed it to use "run Breevy.exe" instead 
				2017-06-21 11.11
					changed it to use ^{space} (works correctly when using ^{space})
				*/
		
				; send ^{space} 
					; 2017-06-21 11.14 this works but prefer using run command 
				; WinActivate ahk_class gdkWindowToplevel 
					; if window isn't open this is not enough 

				; run *RunAs Breevy.exe 
					; I think *RunAs causes more problem 
				run Breevy.exe ; seems to work both when window open and closed, although Breevy starting up is too slow to use when Breevy is not running 
				WinWaitActive, ahk_class gdkWindowToplevel,, 2
					if ErrorLevel
						{
						; run Breevy.exe 
						MsgBox, WinWait timed out. Breevy not running? ; 2017-08-20 working Correctly
						return
						}
					return
				
			return 
			}

		{	;##############  Breevy active(

			; SetTitleMatchMode, 2 
			#IfwinActive ahk_class gdkWindowToplevel ; seems to work correctly 
			; #IfwinActive, Breevy ; works 2016-02-10 10.10 but no document can have the title "Breevy" 
			; #IfwinActive Breevy 

			; Breevy add clipboard to current abbreviations 

			:*:4bcbx::
				sleep 100 
				BreevyAddCbToAbr(){
					sleep 300
					send !a
					sleep 100 
					send {home}
					sleep 100 
					send ^v
					sleep 100 
					sendraw |
					sleep 100
					return
					}
				StuckKeyUp()
				return 

			; :*:4b8:: ; 2017-10-01 15.47 AutoHotkey does not work correctly in OneNote at the moment, keeping it in Breevy until then 
				; sleep 300 
				; BreevyActivate()
				; send +{home}
				; sleep 100 
				; send ^x
				; BreevyAddCbToAbr()
				; return 

			; Breevy add s to newly created command 
			:*:4bnsc::
				sleep 300 
				BreevyNewSCommand()
				return 

			BreevyNewSCommand(){
				sleep 300
				send ^n
				sleep 100
				send !r
				sleep 100
				send ^v
				sleep 300 ; should not need this long delay 
				send s
				sleep 100
				send !a
				sleep 100
				send ^+!#2 ; using Ditto second entry 
				sleep 1100 ; Ditto is slow
				send ^a
				sleep 1100
				BreevyAddAbrEndingHighlighted()
				sleep 1100
				send s
				sleep 300
				; send !t ; does not work as ClipboardReplace is AutoHotkey 
				CbrRepl()
				sleep 100
				return
				}

			; Breevy add r to newly created command 
			:*:4bnrc::
				sleep 300 
				BreevyNewRCommand()
				return 

			BreevyNewRCommand(){
				sleep 300
				send ^n
				sleep 100
				send !r
				sleep 100
				send ^v
				sleep 300 ; should not need this long delay 
				send r
				sleep 100
				send !a
				sleep 100
				send ^+!#2 ; using Ditto second entry 
				sleep 1100 ; Ditto is slow
				send ^a
				sleep 1100
				BreevyAddAbrEndingHighlighted()
				sleep 1100
				send r
				sleep 300
				; send !t ; does not work as ClipboardReplace is AutoHotkey 
				CbrRepl()
				sleep 100
				return
				}

			:*:4btee::
			:*:4btex::
			:*:4btx::
			:*:4batx::
			:*:4bax::
				sleep 100 
				click 688, 114 ; Breevy focus top entry 
				send !a
				sleep 100 
				return 

			:*:4bbx::
			:*:4btx::
			:*:4bbtx::
				sleep 100 
				click 688, 114 ; Breevy focus top entry 
				send {down}
				sleep 100 
				send !a
				sleep 100 
				return 

			:*:4bcx::
			:*:4bctx::
				sleep 100 
				click 688, 114 ; Breevy focus top entry 
				send {down 2}
				sleep 100 
				send !a
				sleep 100 
				return 

			:*:4bdx::
			:*:4bdtx::
				sleep 100 
				click 688, 114 ; Breevy focus top entry 
				send {down 3}
				sleep 100 
				send !a
				sleep 100 
				return 

			:*:4bex::
			:*:4betx::
				sleep 100 
				click 688, 114 ; Breevy focus top entry 
				send {down 4}
				sleep 100 
				send !a
				sleep 100 
				return 

			:*:4bduc::
			:*:4bduca::
			:*:4bducac::
				sleep 100 
				BreevyDuplicate()
				return 

			BreevyDuplicate(){
				sleep 100 
				click right 688, 114 ; Breevy right click top entry 
				sleep 100 
				send u 
				sleep 100 
				send !a
				sleep 100 
				click 688, 114 ; Breevy right click top entry 
				sleep 100 
				send !a
				return 
				}

			{	;##############  move mouse pointer commands (
			/*
			This is the default version of MoveMouse 

			To be done
				[right middle] click 

			2017-06-25 20.52
				started this 
			*/

			:*:mmtlx::
				Click 100, 225, 0  ; Move the mouse without clicking. 
				return 
			:*:mmtmx::
				Click 670, 106, 0  ; Move the mouse without clicking. 
				return 
			:*:mmtrx::
				Click 1700, 225, 0  ; Move the mouse without clicking. 
				return 

			:*:mmmlx::
				Click 100, 500, 0  ; Move the mouse without clicking. 
				return 
			:*:mmmx::
			:*:mmmmx::
				Click 900, 500, 0  ; Move the mouse without clicking. 
				return 
			:*:mmmrx::
				Click 1700, 500, 0  ; Move the mouse without clicking. 
				return 

			:*:mmblx::
				Click 83, 827, 0  ; Move the mouse without clicking. 
				return 
			:*:mmbmx::
				Click 900, 1100, 0  ; Move the mouse without clicking. 
				return 
			:*:mmbrx::
				Click 1700, 1100, 0  ; Move the mouse without clicking. 
				return 

			}
				;############End move mouse pointer commands )

			§ & a::
				{
				GetKeyState, stateLCtrl, LCtrl
				GetKeyState, stateLAlt, LAlt
				GetKeyState, stateLShift, LShift
				GetKeyState, stateLWin, LWin
				GetKeyState, stateRCtrl, RCtrl
				GetKeyState, stateRAlt, RAlt
				GetKeyState, stateRShift, RShift
				GetKeyState, stateRWin, RWin
				GetKeyState, stateScrollLock, ScrollLock

				if stateLCtrl=D
					if stateLAlt=D
						if stateLShift=D
							if stateLWin=D ; ^!+#{x} 
								sendraw ^!+#{x} 
							else ; ^!+{x} 
								sendraw ^!+{x} 
						else if stateLWin=D ; ^!#{x} 
							sendraw ^!#{x} 
						else ; ^!{x}
							sendraw ^!{x}
					else if stateLShift=D
						if stateLWin=D ; ^+#{x} 
							sendraw ^+#{x} 
						else ; ^+{x}
							sendraw ^+{x}
					else if stateLWin=D ; ^#{x} 
						sendraw ^#{x} 
					else ; ^{x}
						{	
						sleep 100 
						click right 688, 114
						sleep 100 
						send u 
						sleep 100 
						send !a 
						return 
						}

				else if stateLAlt=D
						if stateLShift=D
							if stateLWin=D ; !+#{x} 
								sendraw !+#{x} 
							else ; !+{x} 
								sendraw !+{x} 
						else if stateLWin=D ; !#{x} 
							sendraw !#{x} 
						else ; !{x}
							sendraw !{x}
					else if stateLShift=D
						if stateLWin=D ; +#{x} 
							sendraw +#{x} 
						else ; +{x} 
							{
							BreevyCutAbbreviation()
							click 
							sleep 100 
							send !a 
							send {right}
							sendraw |
							sleep 100 
							send ^v 
							return 
							}
					else if stateLWin=D ; #{x} ; there is an issue with § and # alone (but all other combinations seem fine, possibly due to differences in how # behaviors compared to other modifiers). 
						; 2016-06-30 have tried to fix it but given up for now, avoid it for now 
						sendraw #{x} 
					else ; {x} 
					{
					BreevyCutAbbreviation()
					click 405, 125 ; focus second from top entry 
					; send ^{numpad8}
					sleep 100 
					send !a 
					send {right}
					sendraw |
					sleep 100 
					send ^v 
					return 
					}
				return 
				}

				BreevyCutAbbreviation(){
					sleep 200 
					send !a 
					sleep 200 
					send ^a 
					send ^x 
					sleep 100 
					}

			§ & x:: ; temporary things frequently updated 
				{
				GetKeyState, stateLCtrl, LCtrl
				GetKeyState, stateLAlt, LAlt
				GetKeyState, stateLShift, LShift
				GetKeyState, stateLWin, LWin
				GetKeyState, stateRCtrl, RCtrl
				GetKeyState, stateRAlt, RAlt
				GetKeyState, stateRShift, RShift
				GetKeyState, stateRWin, RWin
				GetKeyState, stateScrollLock, ScrollLock

				if stateLCtrl=D
					if stateLAlt=D
						if stateLShift=D
							if stateLWin=D ; ^!+#{x} 
								sendraw ^!+#{x} 
							else ; ^!+{x} 
								sendraw ^!+{x} 
						else if stateLWin=D ; ^!#{x} 
							sendraw ^!#{x} 
						else ; ^!{x}
							sendraw ^!{x}
					else if stateLShift=D
						if stateLWin=D ; ^+#{x} 
							sendraw ^+#{x} 
						else ; ^+{x}
							sendraw ^+{x}
					else if stateLWin=D ; ^#{x} 
						sendraw ^#{x} 
					else ; ^{x}
						sendraw ^{x}

				else if stateLAlt=D
						if stateLShift=D
							if stateLWin=D ; !+#{x} 
								sendraw !+#{x} 
							else ; !+{x} 
								sendraw !+{x} 
						else if stateLWin=D ; !#{x} 
							sendraw !#{x} 
						else ; !{x}
								{
								sleep 300
								sendraw available
								sleep 100
								return
								}
					else if stateLShift=D
						if stateLWin=D ; +#{x} 
							sendraw +#{x} 
						else ; +{x} 
							; loop, 3 
								{
								sleep 300
								sendraw ava
								sleep 100
								return
								}
					else if stateLWin=D ; #{x} ; there is an issue with § and # alone (but all other combinations seem fine, possibly due to differences in how # behaviors compared to other modifiers). 
						; 2016-06-30 have tried to fix it but given up for now, avoid it for now 
						sendraw #{x} 
					else ; {x} 
					
					{
					sleep 300 
					click 
					send !a 
					sleep 200 
					send {home}
					sleep 200 
					send {del}
					sleep 200 
					send {end}
					sleep 200 
					sendraw x 
					sleep 100 
					return 
					}
				return 
				}

			^g:: 
				send ^c
				sleep 100 ; to prevent ^ to be stuck 
				Cbreplm() 
				sleep 50
				send, {lshift down}¨¨{lshift up} ; 2015-11-15 only known way to send start with using the send command 
				sleep 100
				send {backspace}
				sendraw ^||\|	; 2018-03-12 11.00 version 
				; sendraw |(\|) ; prior to 2018-03-12 11.00 
				sleep 50
				; send !x
				send !w
				send $0			; 2018-03-12 10.57 changed from $1 to $0
				send {end}
				return 

			^r:: 
				sleep 100 
				BreevyAddAbrEndingHighlighted()
				return

			BreevyAddAbrEndingHighlighted(){
				sleep 100
				send ^c
				sleep 100
				Cbreplm()
				BreevyPause()  
				sleep 300
				; send (\|)|($)
				; send ([0-9])(\|)|(\|)|($)
				sendRaw ([0-9]\|)|(\|)
				sendraw |($) 
					; 2016-03-28 17.18 since Breevy expands special characters as if they were normal characters, it is best to inactivate Breevy when sendig long strings of text 
					; 2016-03-28 09.41 might be working when I split it up like above 
					; 2016-03-27 13.24 still not working 
					; 2016-02-29 15.04 testing this 
					; found that it is probably due to Breevy testing inactivating it 
				; send ([0-9]\|)|(\|)|($) ; 2016-02-29 15.04 having problems with keys stuck with this 
				sleep 300
				; send !x
				send !w
				send $1$2
				send {home}
				BreevyPause() ; unpause 
				return 
				}

			^h:: 
				send ^c
				sleep 100
				Cbreplm() 
				sleep 50
				; send !x
				send !f
				return 
			#v:: 
				sleep 100
				xahkrmvmepc()
				return 

			:*:4bmvsa::
				{
				; Click right 144, 1109, 1  ; Right click at specified coordinates once
				sleep 300
				Click 616, 104, 1 
				sleep 300
				send ^a
				Click right 616, 104, 1 
				sleep 300
				send m
				; sleep 300
				; send right
				sleep 300
				send {down 4}
				sleep 300
				send {right}
				sleep 300
				send {up}
				sleep 300
				send {enter}
				sleep 300
				send {tab 6}
				sleep 300
				send {right}
				sleep 300
				send {up}
				; sleep 300
				; send {delete}
				; Click right 616, 104, 1 
				RETURN 
				}

			:*:4bi::
				sleep 100 
				send !e
				sleep 300 
				send !t
				sleep 300 
				send {up 5}
				sleep 300 
				send ^+{tab}
				sleep 300 
				send !p
				sleep 300 
				return 

			{	;##############  Working inside Breevy  

			:*:4enfx::
				sleep 50 
				click 100, 340, 1
				sleep 50 
				click 670, 106, 1
				return 

			:*:4encx::
				sleep 50 
				click 100, 340, 1
				return 

			:*:faafx::
			:*:fafx::
			:*:aaffx::
				sleep 50 
				click 122, 223, 1
				sleep 50 
				click 670, 106, 1
				return 

			; creating different affixes (prefix and suffixes) 

				BreevyANCcb(){
					sleep 100 
					send ^n
					sleep 100 
					send !r
					sleep 100 
					send ^v
					sleep 100 
					return 
					}

			BreevyANCSecondcb(){
					sleep 100 
					send !a
					sleep 100 
					send ^+!#2	
					sleep 300 
					send ^a
					sleep 100 
					return 
					}
				
			:*:4bmsc::
				BreevyANCcb()
				send s		
				sleep 100 
				BreevyANCSecondcb()
				ahkrpipespipepcb() 
				return 

			:*:4bmedc::
				BreevyANCcb()
				send ed		
				sleep 100 
				BreevyANCSecondcb()
				ahkrpipedpipepcb() 
				return 

			:*:4bmdc:: 
			:*:4bmodc:: ; only d 
				BreevyANCcb()
				send d	
				sleep 100 
				BreevyANCSecondcb()
				ahkrpipedpipepcb() 
				return 

			:*:4bmgc::
				BreevyANCcb()
				send ing		
				sleep 100 
				BreevyANCSecondcb()
				ahkrpipegpipepcb() 
				return
			
			:*:4bmdogc:: ; delete one using backspace 
			:*:4bmdgc::
				BreevyANCcb()
				send {backspace}
				send ing
				sleep 100 
				BreevyANCSecondcb()
				ahkrpipegpipepcb() 
				return 



			}
				;############End Working inside Breevy  

			#ifwinactive 

			}
			;############End Breevy active)

		{	;##############  Breevy create many versions of abbreviation(

			:*:44bnsc::
				sleep 300 
				BreevyActivate()
				sleep 300 
				BreevyNewSCommand()
				StuckKeyUp()
				return 

			{	;##############  ahkClipboard 1(
			/*

			ahkClipboard1 AKA ClipboardMemory clipboard AutoHotkey clipboard ahkc5 ahkcb5 

			2018-01-25 11.05
				made ahkClipboard1 into template 

			Instructions 
				copy and paste 
				remove § & 7
				search and replace ahkClipboard1 

			*/
			

			§ & 7::
				sleep 300 
				SaveHighlightedToAhkClipboard1()
				StuckKeyUp()
				return 

			:*:a9::
				sleep 100 
				SaveClipboardToAhkClipboard1()
				StuckKeyUp()
				return 

			:*:a8::
				sleep 100 
				send ^+{left}
				SaveHighlightedToAhkClipboard1()
				return 

			:*:ai8:: 
				sleep 100 
				send +{home}
				SaveHighlightedToAhkClipboard1()
				return 

			:*:ai9::
				sleep 100 
				send +{end}
				SaveHighlightedToAhkClipboard1()
				return 

			:*:x9:: 
				PasteAhkClipboard1()
				return 
			

				SaveHighlightedToAhkClipboard1(){
				clipboard = ; Empty the clipboard
				send ^c
				ClipWait, 2
					if ErrorLevel
					{
						MsgBox, The attempt to copy text onto the clipboard failed.
						return
					}

				SaveClipboardToAhkClipboard1()
				return 
				}

				SaveClipboardToAhkClipboard1(){
				FileDelete, clipboard\ahkClipboard1.txt ; this is needed when  
				Fileappend, %Clipboard%, clipboard\ahkClipboard1.txt ; this appends the file with clipboard (without formatting)
				; Fileappend, %ClipboardAll%, ahkClipboard1.txt ; this replaces the file with clipboard (including formatting)
				; MsgBox, clipboard = %clipboard%	; confirmation everything works 
				return 
				}

				PasteAhkClipboard1(){
					LoadAhkClipboard1()
					sleep 100 
					send ^v
					return 
					}

				LoadAhkClipboard1(){
				clipboard = 
				; FileRead, Clipboard, *c ahkClipboard1.txt ; Note the use of *c, which must precede the filename.
				FileRead, Clipboard, clipboard\ahkClipboard1.txt ; this works when saving "clipboard" instead of "clipboardAll"
				if ErrorLevel
						{
							MsgBox, copy text to ahkClipboard1 failed.
							return
						}
					
				return 
				}

				; clipboard := ahkClipboard1.txt 
				; FileRead, Clipboard, *c ahkClipboard1.txt ; Note the use of *c, which must precede the filename.
				; FileRead, Clipboard, *c C:\Company Logo.clip ; Note the use of *c, which must precede the filename.


			}
				;############End ahkClipboard 1)  

			{	;##############  ahkClipboard 2(
			/*

			ahkClipboard2 AKA ClipboardMemory clipboard AutoHotkey clipboard ahkc5 ahkcb5 

			2018-01-25 11.05
				made ahkClipboard1 into template 

			Instructions 
				copy and paste 
				remove § & 7
				search and replace ahkClipboard1 with ahkClipboard2
				search and replace 9 with 29
				search and replace 8 with 28

			*/

			:*:a29::
				sleep 100 
				SaveClipboardToahkClipboard2()
				StuckKeyUp()
				return 

			:*:a28::
				sleep 100 
				send ^+{left}
				SaveHighlightedToahkClipboard2()
				return 

			:*:ai28::
				sleep 100 
				send +{home}
				SaveHighlightedToahkClipboard2()
				return 

			:*:ai29::
				sleep 100 
				send +{end}
				SaveHighlightedToahkClipboard2()
				return 

			:*:x29:: 
				PasteahkClipboard2()
				return 
			

				SaveHighlightedToahkClipboard2(){
				clipboard = ; Empty the clipboard
				send ^c
				ClipWait, 2
					if ErrorLevel
					{
						MsgBox, The attempt to copy text onto the clipboard failed.
						return
					}

				SaveClipboardToahkClipboard2() 
				return 
				}

				SaveClipboardToahkClipboard2(){ 
				; FileDelete, clipboard\ahkClipboard2.txt ; this is not needed when using ClipboardAll
				Fileappend, %ClipboardAll%, clipboard\ahkClipboard2.txt ; this replaces the file with clipboard (including formatting, even images possible)
				; FileAppend, %ClipboardAll%, C:\Company Logo.clip ; The file extension does not matter. 
				return 
				}

				PasteahkClipboard2(){
					LoadahkClipboard2()
					sleep 100 
					send ^v
					return 
					}

				LoadahkClipboard2(){
				clipboard = 
				FileRead, Clipboard, *c clipboard\ahkClipboard2.txt ; Note the use of *c, which must precede the filename.
				; FileRead, Clipboard, clipboard\ahkClipboard2.txt ; this works when saving "clipboard" instead of "clipboardAll"
				if ErrorLevel
						{
							MsgBox, copy text to ahkClipboard2 failed.
							return
						}

					
				return 
				}




			}
				;############End ahkClipboard 2)  

			:*:ahk4bnnxcb:: ; this is the primary way to add abbreviations to Breevy (directly after cutting what you want to expand 
			; :*:4bnxxcb:: 
			; :*:4bnxxc:: 
			/*

			2017-08-31 17.53
				issues with BreevyNewCommand, modified it 
			2017-07-05 12.19
				added AltTabph
			2017-07-04 13.58
				speed of this is now decent enough 
			2017-07-04 13.56
				removed the following from the Breevy command that activates this (4bnnxcb|4bnxxcb|4bnxxc)
					%(abbreviation bvymdelay)%(key ctrl+space)%(abbreviation bvysdelay)
					should speed up the script 
			*/
			
				sleep 300 
				; BreevyActivate() ; 2017-06-20 16.14 testing having ^{space} in Breevy instead of this due to this seeming to be slow 
				BreevyNewCommand()
				ahkLowercb()
				ahkrsppastecb()
				sleep 700 ; this delay might be necessary in order to give Breevy enough time (although would be strange 
				send !r
				sleep 700 
				LoadAhkClipboard1() ; changed to LoadAhkClipboard1 for speed 
				sleep 300 
				ahkrmvecb() ; 2017-07-04 12.29 Adding to remove end trailing spaces everything works before adding this 
				sleep 100 
				send ^v
				sleep 1100 
				AltTabph() ; when this is added more delay seems to be needed before it 
				; send ^!+#3 ; 2017-06-20 16.16 Due to Ditto being too slow it seems to be 3 or 4 that is needed depending on how fast it is. 
				; send {space}
				; send ^a
				; sleep 700 ; 2017-06-20 12.10 still working on making it 
				; send ^v
				return 

			:*:4bnxc:: ; this is the primary way to add abbreviations to Breevy 
			; :*:4bnxx::
				sleep 100 
				; BreevyActivate() ; 2017-06-20 16.14 testing having ^{space} in Breevy instead of this due to this seeming to be slow 
				BreevyNewCommand()
				ahkLowercb()
				ahkrsppastecb()
				send !r
				return 
			

			}
			;############End Breevy create many versions of abbreviation) 

		{	;##############  Breevy add phrases 

			; to be used with
				; "[abbreviation of phrase as one word][space]long phrase that I want to have abbreviation of"

			; 2017-03-12 13.51 
				; below and initialize phrase versions works 

			; Breevy add phrases 
			; Everything documented in rahk 
			; e.g. 4beq 4be2q 4b2eq 

			:*:44bduc::
			:*:44bduca::
			:*:44bducac::
				sleep 100 
				BreevyActivate()
				sleep 300 
				BreevyDuplicate()
				return 

			:*:4bq8::
				ahkSelShiftHomeCopy() 
				ahknewphrasecb()
				return 
				
				
			:*:4bqc::
			:*:4bnqc::
				sleep 100 
				ahknewphrasecb()
				return 
			
			ahknewphrasecb()
				{
				ahkrmclsscb()
				ahkrmvsecb()
				ahkOpenBreevyNC()
				sleep 700 
				send ^{home}
				send ^{right} ; only difference with number version 
				send {del} 
				send +{home}
				send ^x 
				clipwait
				send !a
				sleep 700 
				send ^v
				return 
				}

			; For numbers 
			:*:4bxq::
			:*:4bqx8::
			:*:4bqxi8::
			:*:4bqn8::
			:*:4bnq8::

				ahkSelShiftHomeCopy() 
				ahknphraseNumbercb()
				return 
				
				
			:*:4bqnc::
				ahknphraseNumbercb()
				return 

			ahknphraseNumbercb()
				{
				ahkrmclsscb()
				ahkrmvsecb()
				ahkOpenBreevyNC()
				sleep 700 
				send ^{home}
				send ^{right 2} ; only difference with number version 
				send {del} 
				send +{home}
				send ^x 
				clipwait
				send !a
				sleep 700 
				send ^v
				return 
				}

			; removes one letter and word 
			:*:4be8:: ; works 2017-03-13 17.58  
				ahkSelShiftHomeCopy()
				ahknewphrasecb()
				RemoveLetterWordPastecb()
				return 
				
			ahkSelShiftHomeCopy(){ ; 2017-04-26 11.46 seems to work. ; 2017-04-26 11.52 implemented everywhere 
				sleep 100 
				send +{home}
				send ^c
				sleep 100 
				}

			:*:4b2e8:: 
			:*:4b2eq8::
				ahkSelShiftHomeCopy() 
				ahknewphrasecb()
				RemoveLetterWordPastecb()
				RemoveLetterWordPastecb()
				return 
				
			:*:4b3e8::
			:*:4b3eq8::
				ahkSelShiftHomeCopy() 
				ahknewphrasecb()
				RemoveLetterWordPastecb()
				RemoveLetterWordPastecb()
				RemoveLetterWordPastecb()
				return 
				
			:*:4bex::
			:*:4becx::
				sleep 100 
				ahknewphrasecb()
				RemoveLetterWordPastecb()
				return 
			
			RemoveLetterWordPastecb()
				{
				send !r
				send ^a
				send ^c
				send !a
				send ^c
				send ^n
				send ^v
				send {backspace} 
				send !r
				send ^+!#2
				sleep 700 
				send ^+{left}
				send {del}
				send {backspace}
				send {home}
				send ^+{right} 
				send {del 2} 
				return 
				}

			; removes two letters and one word 
			:*:4be28::
				ahkSelShiftHomeCopy() 
				ahknewphrasecb()
				RemoveTwoLettersOneWordPastecb()
				return 
				
			RemoveTwoLettersOneWordPastecb()
				{
				send !r
				send ^a
				send ^c
				send !a
				send ^c
				send ^n
				send ^v
				send {backspace 2} 
				send !r
				send ^+!#2
				sleep 700 
				send ^+{left}
				send {del}
				send {backspace}
				send {home}
				send ^+{right} 
				send {del 2} 
				return 
				}

			; removes one number and one word 
			:*:4ben8::
				ahkSelShiftHomeCopy() 
				ahknphraseNumbercb()
				RemoveOneLetterOneWordPastecb()
				return 
				
			RemoveOneLetterOneWordPastecb()
				{
				send !r
				send ^a
				send ^c
				send !a
				send ^c
				send ^n
				send ^v
				send {backspace 2} 
				send !r
				send ^+!#2
				sleep 700 
				send ^+{left}
				send {del}
				send {backspace}
				send {home}
				send ^+{right} 
				send {del 3} 
				return 
				}

			}
			;############End Breevy add phrases 
		
		{	;##############  Breevy new initialized phrase  

			; to be used with
				; "long phrase that I want to initialize"

			; new initialized phrase ending on 2 
			:*:4bni8::
				ahkSelShiftHomeCopy()
				ahknicb()
				return 
					
			:*:4bnic::
				sleep 100 
				ahknicb()
				return 

				ahknicb(){
					ahkrmpecialsc()
					ahkrmvsecb()
					; msgbox step two
					ahkOpenBreevyNC()
					sleep 700 
					ahkKeepInitial()
					sleep 700 
					send !a
					sleep 700 
					send ^v
					sleep 700 
					sendraw 2|
					send ^v
					return 
					}

			; new initialized phrase ending on 3
			:*:4bnsi8::
			:*:4bsi8::
				ahkSelShiftHomeCopy() 
				ahknsicb()
				return 
					
			:*:4bnsic::
				sleep 100 
				ahknsicb()
				return 

				ahknsicb(){
					ahkrmpecialsc()
					ahkrmvsecb()
					ahkOpenBreevyNC()
					sleep 700 
					ahkKeepInitial()
					sleep 700 
					send !a
					sleep 700 
					send ^v
					sleep 700 
					sendraw 3|
					send ^v
					return 
					}

			; new initialized phrase ending on 4 work related initialism abbreviation 
			:*:4bnwi8::
				ahkSelShiftHomeCopy() 
				ahknwicb()
				return 
					
			:*:4bnwic::
				sleep 100 
				ahknwicb()
				return 

				ahknwicb(){
					ahkrmpecialsc()
					ahkrmvsecb()
					ahkOpenBreevyNC()
					sleep 700 
					ahkKeepInitial()
					sleep 700 
					send !a
					sleep 700 
					send ^v
					sleep 700 
					sendraw 4|
					send ^v
					return 
					}

			}
			;############End Breevy new initialized phrase

		{	;##############  Breevy new new phrase with abbreviation  
			/*


			To do 
				make it work well with special characters e.g. (IL-6) 


			*/
			
			; to be used with
				; "term (abbreviation)"
			; 2016-12-09 09.24 	need to solve issue with numbers in term and abbreviation 

			:*:4bnli8::
				ahkSelShiftHomeCopy() 
				ahknlcb()
				return 
				
			:*:4bnlw::
				sleep 100 
				send ^c
				sleep 100 
				ahknlcb()
				return 
				
			:*:4bnlc::
				sleep 100 
				ahknlcb()
				return 

			:*:4bnvlc::
				sleep 100 
				ahknvlcb()
				return 

			ahknvlcb()
				{
				Open4nppNew()
				sleep 100 
				send ^v
				sleep 100
				send {enter}
				ahkKeepInPara()
				sleep 100
				ahkLowercb()

				sleep 100
				send ^v
				sleep 1100 // temporary long 
				sendraw 00
				sleep 2200 // temporary long 
				send +{home}
				send ^x
				send {BackSpace}
				send +{home}
				sleep 100
				send ^x
				sleep 300 
				CloseNotepadTab()
				sleep 2100 
				ahkOpenBreevyNSecdCb()
				sleep 700 
				send !a
				sleep 700 
				send ^+!#1
				sleep 1100

				; ahknlcb() // to be added 
				return 
				}

			ahknlcb()
				{
				sleep 200 
				ahkrmpecialsc() 
				sleep 100 
				ahkrmvecb()
				; old  method 
					; sleep 100
					; send ^v
					; sleep 100
					; send {enter}
					; ahkKeepInPara()
					; sleep 100
					; ahkLowercb()

					; sleep 100
					; send ^v
					; sendraw 0
					; sleep 100
					; send +{home}
					; send ^x
					; send {BackSpace}
					; send +{home}
					; sleep 100
					; send ^x
					; sleep 300 
					; CloseNotepadTab()
					; sleep 2100 
				ahkOpenBreevyNC() 
				sleep 1100 
				send !a
				sleep 100 
				ahkKeepInPara()
				sleep 100 
				send ^+!#1 
				sleep 1100
				send 0
				sleep 100 
				BreevyN4C()
				; sleep 2200
				BreevyN5C()
				sleep 100 
				return 
				}

			ahknlWriteAbbreviationcb() ; For when you want to write the abbreviation yourself 
				{
				Open4nppNew()
				sleep 100 
				ahkrmclsscb()
				sleep 100 
				ahkrmvecb()
				sleep 100
				send ^v
				sleep 100
				send {enter}
				ahkKeepInPara()

				sleep 100
				send ^v
				sendraw 0
				sleep 100
				send +{home}
				send ^x
				send {BackSpace}
				send ^+{left}
				send ^+{right}
				send {del}
				send +{home}
				sleep 100
				send ^x
				sleep 300 
				CloseNotepadTab()
				sleep 2100 
				ahkOpenBreevyNC()
				sleep 700 
				send !a
				sleep 700 
				send ^+!#2
				sleep 1100
				BreevyN4C()
				sleep 1100
				BreevyN5C()
				sleep 100 
				return 
				}

			CloseNotepadTab()
				{
				send ^a
				sleep 300 
				send {del}
				sleep 300 
				send ^w
				return 
				}

			}
			;############End Breevy new new phrase with abbreviation  

		{	;##############  Breevy functions (

			ahkKeepInPara()
				{
				;remove new line 
					haystack := Clipboard
					needle := "[\s]{1,}"
					replacement := " "
					result01 := RegExReplace(haystack, needle, replacement)
				;Perform the second RegEx find and replace operation
					haystack := result01
					needle := "^[\s]{1,}"
					replacement := ""
					result02 := RegExReplace(haystack, needle, replacement)
				;keep things inside parentheses 
					haystack := result02
					needle := ".*[(](.*)[)$].*" ; simplified
					; needle := ".*[(]([a-zA-Z,-]*)[)$].*" ; want back to 2016-12-10 version on 2017-01-17 
					; needle := ".*\(([a-zA-Z.-,]*)\).*" ; 2017-01-17 problem I think 
					; needle := ".*[(]*([a-zA-Z.-,]*)[)].*" ; 2017-01-17 problem I think 
					replacement := "$1"
					result03 := RegExReplace(haystack, needle, replacement)
				; ;Perform the fourth RegEx find and replace operation
					; haystack := result03
					; needle := "[\s]{1,}"
					; replacement := "$1"
					; result04 := RegExReplace(haystack, needle, replacement)
				; ;Perform the fourth RegEx find and replace operation
					; haystack := result04
					; needle := "([A-Z]*)"
					; replacement := "$L1"
					; result05 := RegExReplace(haystack, needle, replacement)
				;Perform the next RegEx find and replace operation
					haystack := result03
					needle := "[ \-\(\)\{\}\[\]=/\\|]\h{0,}" ; remove special characters  
					replacement := ""
					result := RegExReplace(haystack, needle, replacement)
					Clipboard =
					Clipboard := result
					ClipWait, 1
						if ErrorLevel
						{
							MsgBox, copy text to clipboard failed.
							return
						}
					send {<# up} ; solved some issues 
				return
				}

			:*:ahkicb::
			:*:ahkicx::
			:*:ahknic::
			:*:ahkinc::
			:*:ahkicx::
			:*:ahkix::
			:*:ahkkicb::
			:*:ahkkicx::
			:*:ahkknic::
			:*:ahkkinc::
			:*:ahkkicx::
			:*:ahkkix::
			:*:ahkkic::
			:*:ahkkpic::

			:*:xminilc::
			:*:xinilc::
			:*:inilcx::

				ahkKeepInitial()
				sleep 100
				send ^v
				sleep 100 
				return 

			ahkKeepInitial()
				{
					haystack := Clipboard
					needle := "[\s]{1,}"
					replacement := " "
					result01 := RegExReplace(haystack, needle, replacement)
				;Perform the second RegEx find and replace operation
					haystack := result01
					needle := "^[\s]{1,}"
					replacement := ""
					result02 := RegExReplace(haystack, needle, replacement)
				;Perform the third RegEx find and replace operation
					haystack := result02
					needle := "([a-zA-Z0-9åäöÅÄÖ_-])[a-zA-Z0-9åäöÅÄÖ_-]*$"
					replacement := "$1"
					result03 := RegExReplace(haystack, needle, replacement)
				;Perform the fourth RegEx find and replace operation
					haystack := result03
					needle := "([a-zA-Z0-9åäöÅÄÖ_-])[a-zA-Z0-9åäöÅÄÖ_-]* "
					replacement := "$1"
					result04 := RegExReplace(haystack, needle, replacement)
				;Perform the fourth RegEx find and replace operation
					haystack := result04
					needle := "[ \-\(\)\{\}\[\]=/\\|]\h{0,}" ; escaping special characters is needed 
					replacement := ""
					result := RegExReplace(haystack, needle, replacement)
					Clipboard =
					Clipboard := result
					ClipWait
					send {<# up} ; solved some issues 
				return
				}

			BreevyN4C()
				{
				send ^n
				sleep 700 
				send ^+!#1  
				sleep 1100
				; send {backspace}
				sleep 100 
				send 4
				sleep 700 
				send !r
				sleep 700 
				send ^+!#2 
				sleep 700 
				send ^+{left 2}
				sleep 700 
				send ^+{right}
				sleep 700 
				send {del}
				sleep 700 
				return 
				}

			BreevyN5C()
				{
				send ^n
				sleep 700 
				send ^+!#1
				sleep 700 
				; send {backspace}
				sleep 100 
				send 5
				sleep 700 
				send !r
				sleep 700 

				send ^+!#1
				sleep 700 
				send ^a
				sleep 100 
				; send {delete}
				sleep 700 
				ahkupperc()
				sleep 700 
				send ^v
				sleep 700 
				; send {backspace}
				sleep 700 
				return 
				}

			:*:ahkobvyx::
			:*:aobvyx::
				ahkOpenBreevyNC() 
				return 

			; Open Breevy and add clipboard 
			ahkOpenBreevyNC(){
				/*

				2017-06-30 13.20
					improved speed by making it not go to "almost all folders" 
				2017-06-22 10.03
					updated BreevyNewCommand to only? method of opening Breevy 
				2017-06-21 11.01
					still issues with opening Breevy 
				2017-06-17 11.16
					updated this 
				2017-04-26 11.57
					may be issues here 
				works 2017-03-12 22.06 
				2017-01-17 modified seems to work now 
				*/

				; send ^{space} ; 2017-03-13 17.58 should not be needed, have had issues without it 
				; winactivate Breevy 
				; send ^{space} ; 2017-03-12 modified to be faster 
				BreevyNewCommand()
				send !r
				send ^v
				return 
				}

			BreevyNewCommand(){
			/*
			2018-04-21 10.07
				made speed improvements 
			2017-09-03 15.22
				seems to be working correctly 
			2017-08-31 17.50
				added more sleep to make it work better with Breevy 
			*/
			
				; sleep 100 ; 2018-04-21 10.04 commented out 
				BreevyActivate()
				sleep 100 
				click 75 225 ; 2017-07-21 17.59 added this back due to Breevy bug 
				sleep 100 
				click 75 225 ; 2017-09-01 11.43 added another click to make sure Breevy has correct focus (seems to have solved issue) 
				sleep 300 ; seems needed sometimes due to Breevy being slow 
				send ^n
				sleep 100 
				return 
				}

			ahkOpenBreevyNSecdCb() 
				{
				BreevyNewCommand()
				send !r
				sleep 1100 
				send ^+!#2 ; Ditto is very slow so requires a lot of waiting for this 
				sleep 1100 
				return 
				}

			}
			;############End Breevy functions )  

		}
		;############End Breevy 

	{	;##############  BSPlayer 
			; 4bslp 4bpl 4bs 
			#IfWinActive BSPlayer
				;Available 
					{
					<^>!down::Send {PgDn} 
					<^>!up::Send {PgUp}
					>+down::Send {PgDn} 
					>+up::Send {PgUp}
					}
					
			{	;##############  Inactivating things when in bsplayer 
				:*:t1::
					return  
				:*:t2::
					return  
				:*:t3::
					return  
				:*:t4::
					return  
				:*:t5::
					return  
				:*:t6::
					return  
				:*:t7::
					return  
				:*:t8::
					return  
				:*:t9::
					return  
				:*:c0:: 
					return  
				:*:c1::
					return  
				:*:c2::
					return  
				:*:c3::
					return  
				:*:c4::
					return  
				:*:c5::
					return  
				:*:c6::
					return  
				:*:c7::
					return  
				:*:c8::
					return  
				:*:c9::
					return  
				:*:c0:: 
					return  		

			;	send D
				;send {left}{right}
				;send {space}
				;return
				
			}
				;############End Inactivating things when in bsplayer
										
			^tab:: ; rewind 
				sleep 300
				send {left}
				sleep 50 
				send {left}
				sleep 50 
				send {left}
				sleep 50 
				send {left}
				sleep 50 
				send {left}
				sleep 50 
				send {left}
				sleep 50 
				send {left}
				sleep 50 
				send {left}
				sleep 50 
				return 
				
			^+tab:: ; skip forward 
				sleep 300
				send {right} 
				sleep 50 
				send {right} 
				sleep 50 
				send {right} 
				sleep 50 
				send {right} 
				sleep 50 
				return 

			^n::
				sleep 100
				send ^t
				sleep 500 
				send +{tab} 
				sleep 100 
				send 5
				return 
			^l::
			; #F20::
				send ^l
				sleep 900
				send ^6
				sleep 900
				send !f
				sleep 900
				send {down 2}
				sleep 500
				send {enter}
				return	
			^+s::
				sleep 600 
				send !f
				sleep 300
				send {down 3}
				sleep 300
				send {enter}
				WinWait, Save As
				;sleep 500
				send {right}
				sleep 100
				send ^{left}
				sleep 100
				send {left}
				sleep 100
				send ^+{left 5}
				sleep 300
					ahkDaTi2()
				sleep 100
				send {enter}
				Return 
			^!+s::
				sleep 500 
				send !f
				sleep 300
				send a
				sleep 700 
				send {home} 
				send ^{right} 
				Return 
			^+#s::
				send !f
				sleep 300
				send a
				sleep 300 
				send ^{left} 
				send {left}
				Return 
			^!F1:: send ^F1
			^!F2:: 
			^!F3:: 
			^!F4:: 
			^!F5:: 
			^!F6:: 
			^!F7:: 
			^!F8:: 
			^!F9:: 
			^!F10:: 
			^!F11:: send {Volume_Up}{Volume_Up}{Volume_Up}
			^!F12:: send {Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}

			!+F2:: send ^T
			!+F1:: 
				;SetTimer, CloseContextMenu, 50
				!f
				Return

			!+F3:: 
			!+F4:: 
			!+F5:: 
			!+F6:: 
			!+F7:: 
			!+F8:: 
			!+F9:: 
			!+F10:: 
			;!+F11:: send {Volume_Up}{Volume_Up}{Volume_Up}
			;!+F12:: send {Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}

			;^!+PgUp:: send x 
			;PgDn:: send x 

			^!+F1:: 			
				send !t
				return 
			^!+F2:: 
				sleep 300
				send !easo
				sleep 300 
				send !eae
				sleep 300
				send {tab}
				;sleep 300 ; not fully tested yet (2015-02-21 19.16 it has been working sofar)
				;send {space}
				return 
				^!+F3:: 
				sleep 500 
				send !f
				sleep 300
				send a
				sleep 300 
				send {home} 
				send ^{right}
				;send {backspace} 
				Return 
			; up down up:
			^!+F4:: 
			return
			^!+F5:: 
			return
			^!+F6:: 
			return
			;^!+F7::  taken for media next 
			^!+F8:: 
			return
			^!+F9:: 
				send !eaa
				sleep 300
				send +{tab}
				send 5
				return 
			^!+F10:: 
			^!+F11:: 
				send 3cd3  
				sleep 100
				send p
			^!+F12:: 
				send 3c3  
				sleep 100
				send p
			#ifwinactive
			}
		;########### End BSPlayer 

	{	;##############  cmd (
		/*
		cmd RefInfo 

		2017-05-19 10.04
			created 
		*/

		{	;##############  cmd active(
		; possible to use winnamex or winidx to change ifwinactive to more specific id 
		#IfwinActive, ahk_class ConsoleWindowClass 


		; Close Command Window with Ctrl+w
		$^w::
		WinGetTitle sTitle
		If (InStr(sTitle, "-")=0) { 
			Send EXIT{Enter}
		} else {
			Send ^w
		}

		return 


		; Ctrl+up / Down to scroll command window back and forward
		^Up::
		Send {WheelUp}
		return

		^Down::
		Send {WheelDown}
		return


		; Paste in command window
		^V::
		Send !{Space}ep
		return


		; § & a:: ; [comment here "theme of this hotkey"] 
			; /*

			; Add comments here using ncmth system 
			; */ 
			; {
			; GetKeyState, stateLCtrl, LCtrl
			; GetKeyState, stateLAlt, LAlt
			; GetKeyState, stateLShift, LShift
			; GetKeyState, stateLWin, LWin
			; GetKeyState, stateRCtrl, RCtrl
			; GetKeyState, stateRAlt, RAlt
			; GetKeyState, stateRShift, RShift
			; GetKeyState, stateRWin, RWin
			; GetKeyState, stateScrollLock, ScrollLock
			; if stateLCtrl=D
				; if stateLAlt=D
					; if stateLShift=D
						; if stateLWin=D ; ^!+#{x} 
							; sendraw ^!+#{x} 
						; else ; ^!+{x} 
							; sendraw ^!+{x} 
					; else if stateLWin=D ; ^!#{x} 
						; sendraw ^!#{x} 
					; else ; ^!{x}
						; sendraw ^!{x}
				; else if stateLShift=D
					; if stateLWin=D ; ^+#{x} 
						; sendraw ^+#{x} 
					; else ; ^+{x}
						; sendraw ^+{x}
				; else if stateLWin=D ; ^#{x} 
					; sendraw ^#{x} 
				; else ; ^{x}
					; sendraw ^{x}

			; else if stateLAlt=D
					; if stateLShift=D
						; if stateLWin=D ; !+#{x} 
							; sendraw !+#{x} 
						; else ; !+{x} 
							; sendraw !+{x} 
					; else if stateLWin=D ; !#{x} 
						; sendraw !#{x} 
					; else ; !{x}
						; sendraw !{x}
				; else if stateLShift=D
					; if stateLWin=D ; +#{x} 
						; sendraw +#{x} 
					; else ; +{x} 
						; sendraw +{x}
				; else if stateLWin=D ; #{x} ; there is an issue with § and # alone (but all other combinations seem fine, possibly due to differences in how # behaviors compared to other modifiers). 
					; ; 2016-06-30 have tried to fix it but given up for now, avoid it for now 
					; sendraw #{x} 
				; else ; {x} 
					; sendraw {x} 
					; ; {
					; ; sleep 300
					; ; sendraw test
					; ; sleep 100
					; ; return
					; ; }
			; return 
			; }

		; § & x:: ; temporary things frequently updated 
			; {
			; GetKeyState, stateLCtrl, LCtrl
			; GetKeyState, stateLAlt, LAlt
			; GetKeyState, stateLShift, LShift
			; GetKeyState, stateLWin, LWin
			; GetKeyState, stateRCtrl, RCtrl
			; GetKeyState, stateRAlt, RAlt
			; GetKeyState, stateRShift, RShift
			; GetKeyState, stateRWin, RWin
			; GetKeyState, stateScrollLock, ScrollLock

			; if stateLCtrl=D
				; if stateLAlt=D
					; if stateLShift=D
						; if stateLWin=D ; ^!+#{x} 
							; sendraw ^!+#{x} 
						; else ; ^!+{x} 
							; sendraw ^!+{x} 
					; else if stateLWin=D ; ^!#{x} 
						; sendraw ^!#{x} 
					; else ; ^!{x}
						; sendraw ^!{x}
				; else if stateLShift=D
					; if stateLWin=D ; ^+#{x} 
						; sendraw ^+#{x} 
					; else ; ^+{x}
						; sendraw ^+{x}
				; else if stateLWin=D ; ^#{x} 
					; sendraw ^#{x} 
				; else ; ^{x}
					; sendraw ^{x}

			; else if stateLAlt=D
					; if stateLShift=D
						; if stateLWin=D ; !+#{x} 
							; sendraw !+#{x} 
						; else ; !+{x} 
							; sendraw !+{x} 
					; else if stateLWin=D ; !#{x} 
						; sendraw !#{x} 
					; else ; !{x}
						; sendraw !{x}
				; else if stateLShift=D
					; if stateLWin=D ; +#{x} 
						; sendraw +#{x} 
					; else ; +{x} 
			
						; {
						; sleep 300
						; sendraw ava
						; sleep 100
						; return
						; }
				; else if stateLWin=D ; #{x} ; there is an issue with § and # alone (but all other combinations seem fine, possibly due to differences in how # behaviors compared to other modifiers). 
					; ; 2016-06-30 have tried to fix it but given up for now, avoid it for now 
					; sendraw #{x} 
				; else ; {x} 
				
				; {
				; sleep 300 
				; click 
				; send !a 
				; sleep 200 
				; send {home}
				; sleep 200 
				; send {del}
				; sleep 200 
				; send {end}
				; sleep 200 
				; sendraw x 
				; sleep 100 
				; return 
				; }
			; return 
			; }


		; CapsLock & w::
			; {
			; GetKeyState, stateLCtrl, LCtrl
			; GetKeyState, stateLAlt, LAlt
			; GetKeyState, stateLShift, LShift
			; GetKeyState, stateLWin, LWin
			; GetKeyState, stateRCtrl, RCtrl
			; GetKeyState, stateRAlt, RAlt
			; GetKeyState, stateRShift, RShift
			; GetKeyState, stateRWin, RWin
			; GetKeyState, stateScrollLock, ScrollLock

			; if stateLCtrl=D
				; if stateLAlt=D
					; if stateLShift=D
						; if stateLWin=D ; ^!+#{f5} 
							; send ^!+#{f5} 
						; else ; ^!+{f5} 
							; send ^!+{f5} 
					; else if stateLWin=D ; ^!#{f5} 
						; send ^!#{f5} 
					; else ; ^!{f5}
						; send ^!{f5}
				; else if stateLShift=D
					; if stateLWin=D ; ^+#{f5} 
						; send ^+#{f5} 
					; else ; ^+{f5}
						; send ^+{f5}
				; else if stateLWin=D ; ^#{f5} 
					; send ^#{f5} 
				; else ; ^{f5}
					; send ^{f5}

			; else if stateLAlt=D
					; if stateLShift=D
						; if stateLWin=D ; !+#{f5} 
							; send !+#{f5} 
						; else ; !+{f5} 
							; send !+{f5} 
					; else if stateLWin=D ; !#{f5} 
						; {
						; sleep 300
						; Selecline()  
						; send {F9}
						; sleep 1500
						; send #7
						; return
						; } 
					; else ; !{f5}
						; send !{f5}
				; else if stateLShift=D
					; if stateLWin=D ; +#{f5} 
						; send +#{f5} 
					; else ; +{f5} 
						; ; send +{f5}
						; {
						; sleep 500
						; send {F9}
						; }

				; else if stateLWin=D ; #{f5} ; there is an issue with § and # alone (but all other combinations seem fine, possibly due to differences in how # behaviors compared to other modifiers). 
					; ; 2016-06-30 have tried to fix it but given up for now, avoid it for now 
					; {
					; sleep 500
					; send {F9}
					; sleep 1500
					; send #7
					; }
				; else ; {f5} 
					; {
					; sleep 500
					; send {F9}
					; sleep 1500
					; send #7
					; }

			; return 
			; }

		; § & numpad1:: ; [comment here "theme of this hotkey"] 
			; /*

			; Add comments here using ncmth system 
			; */ 
			; {
			; GetKeyState, stateLCtrl, LCtrl
			; GetKeyState, stateLAlt, LAlt
			; GetKeyState, stateLShift, LShift
			; GetKeyState, stateLWin, LWin
			; GetKeyState, stateRCtrl, RCtrl
			; GetKeyState, stateRAlt, RAlt
			; GetKeyState, stateRShift, RShift
			; GetKeyState, stateRWin, RWin
			; GetKeyState, stateScrollLock, ScrollLock
			; if stateLCtrl=D
				; if stateLAlt=D
					; if stateLShift=D
						; if stateLWin=D ; ^!+#{x} 
							; sendraw ^!+#{x} 
						; else ; ^!+{x} 
							; sendraw ^!+{x} 
					; else if stateLWin=D ; ^!#{x} 
						; sendraw ^!#{x} 
					; else ; ^!{x}
						; sendraw ^!{x}
				; else if stateLShift=D
					; if stateLWin=D ; ^+#{x} 
						; sendraw ^+#{x} 
					; else ; ^+{x}
						; sendraw ^+{x}
				; else if stateLWin=D ; ^#{x} 
					; sendraw ^#{x} 
				; else ; ^{x}
					; sendraw ^{x}

			; else if stateLAlt=D
					; if stateLShift=D
						; if stateLWin=D ; !+#{x} 
							; sendraw !+#{x} 
						; else ; !+{x} 
							; sendraw !+{x} 
					; else if stateLWin=D ; !#{x} 
						; sendraw !#{x} 
					; else ; !{x}
						; sendraw !{x}
				; else if stateLShift=D
					; if stateLWin=D ; +#{x} 
						; sendraw +#{x} 
					; else ; +{x} 
						; sendraw +{x}
				; else if stateLWin=D ; #{x} ; there is an issue with § and # alone (but all other combinations seem fine, possibly due to differences in how # behaviors compared to other modifiers). 
					; ; 2016-06-30 have tried to fix it but given up for now, avoid it for now 
					; sendraw #{x} 
				; else ; {x} 
					; sendraw {x} 
					; ; {
					; ; sleep 300
					; ; sendraw test
					; ; sleep 100
					; ; return
					; ; }
			; return 
			; }

		; ^#h::
			; return 

		; ^!#h::
			; return 

		; +#h::
			; sleep 300 
			; send {end 3}
			; send +{home 3}
			; sleep 300 
			; send {f9} 
			; return 

		; ^!+F1:: 			
			; sleep 300
			; send !p
			; sleep 300
			; send {left}
			; sleep 300
			; send {down 2}
			; sleep 300
			; send {right}
			; sleep 700
			; send {up 4}
			; sleep 700
			; send {enter}
			; ; send ! 
			; return 

		; ^!+F2:: 
			; sleep 300
			; send !easo
			; return 

		; ^!+F3:: 
			; sleep 500 
			; Return 

		; ^!+F4:: 
		; return

		; ^!+F5:: 
			; sleep 500 

		; ^!+F6:: 
			; sleep 500 
			; send {Pgdn}
			; return

		; ;^!+F7::  taken for media next 

		; ^!+F8:: 
			; return

		; ^!+F9:: 
			; return 

		; ^!+F10:: 
			; return
			
		; ^!+F11:: 
			; return

		; ^!+F12:: 
			; return



		return 

		#ifwinactive 
		}
			;############end cmd active) 

		{	;##############  Outside cmd(

		; Activate cmd
		; :*:xl4newprogramabr::
			; ahkOpencmd()
			; return 

			; ahkOpencmd(){
				; IfWinExist, newprogramnamwinTitle
				; {
					; WinActivate  ; Automatically uses the window found above.
					; WinMaximize  
					; Send, Example text.{Enter} 
					; return
				; }
				; else
				; {
					; winactivate newprogramnamwinTitle
					WinMove, 40, 40  ; Move window to a new position.
					; return
				; }			
			; }

		}
			;############End Outside cmd) 

		{	;##############  Archive cmd(
		/*
		Things not useful at the moment kept here for future reference 
			
		*/
		
		}
			;############End Archive cmd) 

		}
		;############End cmd )

	{	;##############  Chrome 
		/*
		Including tab specific 
			Amazon 					not unique ifwinActive
			Facebook 				#IfwinActive, Messenger - Google Chrome 
			Remember the Milk 		#IfwinActive, Remember The Milk - Google Chrome

		Those with unique ifwinActive comes after Chrome specific 
		2018-02-08 09.31
			added Facebook specific 
		*/


		{	;##############  Facebook (
				/*
				Facebook RefInfo 
					
				Facebook Documentation 
					
				*/


			{	;##############  Facebook (messenger) active(
			; possible to use  more specific name using ahk_class (find using xwinspy)

			#IfwinActive, Messenger - Google Chrome 

			<^>!k::
				sleep 300
				send ^{numpaddiv}
				sleep 300
				Send, {Asc 0033} 
				sleep 300
				send ^{numpaddiv}
				sleep 300
				Exit
				return


			+#h::
				sleep 300 
				send {end 3}
				send +{home 3}
				sleep 300 
				send {f9} 
				return 


			return 

			#ifwinactive 
			}
				;############end Facebook (messenger) active)

			}
			;############End Facebook )

		{	;##############  Remember the Milk 
			#ifwinActive Remember The Milk - Google Chrome

			:*:äösc::
			:*:äöcx::
				sleep 100 
				RTMSrch()
				sleep 300 
				send ^v
				sleep 100 
				send {enter}
				return 


			; search Remember the Milk 
			; § up::
			; capslock up::
			:*:äösr::
			:*:srx::
			:*:xx::
			; ^,::
				sleep 100 
				RTMSrch()
				return 

				RTMSrch(){
				sleep 300 
				; send / ; does not work to focus search box 
				send {esc}
				sleep 100 
				send f
				sleep 300
				send ea
				sleep 100
				return
				}
			return 

			#IfWinActive 

			{	;##############  Not IfWinActive section  (



			:*:xlrömc::
			:*:xl4römc::
			:*:xl4rtmc::
			:*:xnrömc::
			:*:xadrömc::
			:*:xsarömc:: 
			:*:pastertmc::
			:*:xrtmpc::
			:*:rtmxc::
			:*:rtmxpc::
			:*:paste4rtmc::
			:*:x4rtmpc::
			:*:4rtmxc::
			:*:4rtmxpc::
			:*:xarömc::
			:*:xrömcb::
			:*:xsrömc::

			!#b::
				sleep 100 
				send ^c
				sleep 100 
				FocusChromeRTM()
				sleep 100 
				send ^v
				return 

			!#m::
				sleep 100 
				FocusChromeRTM()
				sleep 100 
				send ^v
				return 

			}
				;############End Not IfWinActive section  )  

			}
			;############End Remember the Milk 

		{	;##############  Chrome active(
			#ifwinActive ahk_exe chrome.exe ; 2017-07-20 works 
			; #ifwinActive ahk_class Chrome_WidgetWin_1 ; not specific enough - cause issue with Visual Studio Code 2017-07-20 
			; #ifwinActive ahk_class Chrome ; 2017-06-12 seems to not solve issue of specificity 
			; #IfWinActive Chrome ; 2017-06-12 also affects e.g. Word document with Chrome in title 

			{	;##############  Amazon 
			; Also see Vimium section for searching inside Amazon 

			; Go to next page by editing Amazon URL 

			:*:4amnpag::
			:*:4amnxtp::
			:*:4amupag::
			:*:4ampagu::
			:*:4ampag::
			:*:4amnxt::
			:*:4amnx::

				{
				sleep 300
				send ^f 
				sleep 100 
				send next page
				sleep 100 
				send {esc}
				sleep 100
				send {enter}
				return
				}

				; send !d
				; sleep 200
				; send ^c
				; sleep 100
				; Cbreplm() 
				; sleep 50
				; send (page\=)[0-9]{1,3}
				; sleep 50
				; ; send !x
				; send !w
				; send $1
				; ; send {end}
				; return 

			:*:4amrews::
			:*:4amrew::
			:*:4amrw::
			:*:4amratg::
				sleep 300 
				send {esc}
				sendraw j
				sleep 300 
				sendraw \s[1-9][0-9]{2,3}[^^.a-zA-Z]
				sleep 300 
				return 
			return
			}
				;############End Amazon 


			{ ; surface dial 
			^!+f8:: ;rotate left surface dial
				sleep 300
				sendraw test
				sleep 100
				return

			^!+f9:: ;rotate right surface dial
				sleep 300
				sendraw test
				sleep 100
				return

			^!+f10:: ;click surface dial
				sleep 300
				sendraw test
				sleep 100
				return


			; Strokeit program specific gestures 

			^!+f11:: ; Strokeit right up 
				sleep 100
				sendraw ava
				return

			^!+f12:: ; Strokeit right down 
				sleep 100
				sendraw ava
				return
			}

			§ & a:: ; activate search bar 
				{
				/*

				Add comments here using ncmth system 
				*/ 
				
				GetKeyState, stateLCtrl, LCtrl
				GetKeyState, stateLAlt, LAlt
				GetKeyState, stateLShift, LShift
				GetKeyState, stateLWin, LWin
				GetKeyState, stateRCtrl, RCtrl
				GetKeyState, stateRAlt, RAlt
				GetKeyState, stateRShift, RShift
				GetKeyState, stateRWin, RWin
				GetKeyState, stateScrollLock, ScrollLock
				if stateLCtrl=D
					if stateLAlt=D
						if stateLShift=D
							if stateLWin=D ; ^!+#{x} 
								sendraw ^!+#{x} 
							else ; ^!+{x} 
								sendraw ^!+{x} 
						else if stateLWin=D ; ^!#{x} 
							sendraw ^!#{x} 
						else ; ^!{x}
							sendraw ^!{x}
					else if stateLShift=D
						if stateLWin=D ; ^+#{x} 
							sendraw ^+#{x} 
						else ; ^+{x}
							sendraw ^+{x}
					else if stateLWin=D ; ^#{x} 
						sendraw ^#{x} 
					else ; ^{x}
						sendraw ^{x}

				else if stateLAlt=D
						if stateLShift=D
							if stateLWin=D ; !+#{x} 
								sendraw !+#{x} 
							else ; !+{x} 
								sendraw !+{x} 
						else if stateLWin=D ; !#{x} 
							sendraw !#{x} 
						else ; !{x}
							sendraw !{x} ; 
					else if stateLShift=D
						if stateLWin=D ; +#{x} 
							sendraw +#{x} 
						else ; +{x} 
							sendraw +{x}
					else if stateLWin=D ; #{x} ; there is an issue with § and # alone (but all other combinations seem fine, possibly due to differences in how # behaviors compared to other modifiers). 
						; 2016-06-30 have tried to fix it but given up for now, avoid it for now 
						sendraw #{x} 
					else ; {x} ; reattach previously popped out window (tab opened in a new window) 
						{
						sleep 300
						send !d
						sleep 100
						send ^c
						sleep 100
						send ^w
						sleep 100
						winactivate Chrome 
						sleep 100
						send +P
						sleep 100
						return
						}
				return 
				}

			§ & s:: ; search related  
				/*

				Add comments here using ncmth system 
				*/ 
				{
				GetKeyState, stateLCtrl, LCtrl
				GetKeyState, stateLAlt, LAlt
				GetKeyState, stateLShift, LShift
				GetKeyState, stateLWin, LWin
				GetKeyState, stateRCtrl, RCtrl
				GetKeyState, stateRAlt, RAlt
				GetKeyState, stateRShift, RShift
				GetKeyState, stateRWin, RWin
				GetKeyState, stateScrollLock, ScrollLock
				if stateLCtrl=D
					if stateLAlt=D
						if stateLShift=D
							if stateLWin=D ; ^!+#{x} 
								sendraw ^!+#{x} 
							else ; ^!+{x} 
								sendraw ^!+{x} 
						else if stateLWin=D ; ^!#{x} 
							sendraw ^!#{x} 
						else ; ^!{x}
							sendraw ^!{x}
					else if stateLShift=D
						if stateLWin=D ; ^+#{x} 
							sendraw ^+#{x} 
						else ; ^+{x}
							sendraw ^+{x}
					else if stateLWin=D ; ^#{x} 
						sendraw ^#{x} 
					else ; ^{x}
						sendraw ^{x}

				else if stateLAlt=D
						if stateLShift=D
							if stateLWin=D ; !+#{x} 
								sendraw !+#{x} 
							else ; !+{x} 
								sendraw !+{x} 
						else if stateLWin=D ; !#{x} 
							sendraw !#{x} 
						else ; !{x}
							sendraw !{x}
					else if stateLShift=D
						if stateLWin=D ; +#{x} 
							sendraw +#{x} 
						else ; +{x} 
							{
							sleep 300
							send ^f
							sleep 100
							send English 
							sleep 100
							send ^{enter}
							sleep 100
							send {esc} 
							sleep 100
							send {enter}
							return
							}
					else if stateLWin=D ; #{x} ; there is an issue with § and # alone (but all other combinations seem fine, possibly due to differences in how # behaviors compared to other modifiers). 
						; 2016-06-30 have tried to fix it but given up for now, avoid it for now 
						sendraw #{x} 
					else ; {x} ; reattach previously popped out window (tab opened in a new window) 
						{
						sleep 300
						send ^f
						sleep 100
						send svenska
						sleep 100
						send ^{enter}
						sleep 100
						send {esc} 
						sleep 100
						send {enter}
						return
						}
				return 
				}

			§ & x:: ; temporary things frequently updated 
				/*
				
				2017-04-22 14.06
					using for online viewing of The Daily Show Last Week Tonight Full Frontal with Samantha Bee 
				*/
				{
				GetKeyState, stateLCtrl, LCtrl
				GetKeyState, stateLAlt, LAlt
				GetKeyState, stateLShift, LShift
				GetKeyState, stateLWin, LWin
				GetKeyState, stateRCtrl, RCtrl
				GetKeyState, stateRAlt, RAlt
				GetKeyState, stateRShift, RShift
				GetKeyState, stateRWin, RWin
				GetKeyState, stateScrollLock, ScrollLock

				if stateLCtrl=D
					if stateLAlt=D
						if stateLShift=D
							if stateLWin=D ; ^!+#{x} 
								sendraw ^!+#{x} 
							else ; ^!+{x} 
								sendraw ^!+{x} 
						else if stateLWin=D ; ^!#{x} 
							sendraw ^!#{x} 
						else ; ^!{x}
							sendraw ^!{x}
					else if stateLShift=D
						if stateLWin=D ; ^+#{x} 
							sendraw ^+#{x} 
						else ; ^+{x}
							sendraw ^+{x}
					else if stateLWin=D ; ^#{x} 
						sendraw ^#{x} 
					else ; ^{x}
						sendraw ^{x}

				else if stateLAlt=D
						if stateLShift=D
							if stateLWin=D ; !+#{x} 
								sendraw !+#{x} 
							else ; !+{x} 
								sendraw !+{x} 
						else if stateLWin=D ; !#{x} 
							sendraw !#{x} 
						else ; !{x}
							sendraw !{x}
					else if stateLShift=D
						if stateLWin=D ; +#{x} 
							sendraw +#{x} 
						else ; +{x} 
							{
							sleep 300 
							Loop, 3 
								{
								sleep 300
								FindAndOpenLink()
								sleep 100 
								send ^{tab}
								sleep 100 
								}
							return 
								
							}
					else if stateLWin=D ; #{x} ; there is an issue with § and # alone (but all other combinations seem fine, possibly due to differences in how # behaviors compared to other modifiers). 
						; 2016-06-30 have tried to fix it but given up for now, avoid it for now 
						sendraw #{x} 
					else ; {x} 
						{
						sleep 300
						FindAndOpenLink()
						return 
						}

				return 
				}

			<^<!d:: 
				sleep 300 
				click 3499, 94, 1
				sleep 100 
				click 2884, 210, 1
				sleep 4444 
				send {return}
				sleep 100 
				return 

			^o:: 
				sleep 300 
				send ^c
				send xnpbc
				return 

			^l::
				sleep 500
				send {f11}
				sleep 500
				return	

			; ^m::
			; ^+m::

			^!m::
				sleep 300 
				send ^f
				send {enter}
				sleep 300 
				send {enter}
				send {esc}
				sleep 500
				send {enter}
				return 
			*F14:: SendEvent ^{=}
			*F15:: SendEvent ^{-}
			#F20:: 
				sleep 100 
				send ^{Tab}
				return 

			:*:öö1::
				Send !{left}
				Return

			:*:öö2::
				Send !{right}
				Return

			:*:öö3::
				Send ^{f4}
				Return
				
			:*:öö4::
				Send !{f4}
				Return

			; :*:öö5:: ; 
				; Send !{right}
				; Return

			:*:öö6::
				Send !#h
				Return
				
			:*:öö7::
				Send !'
				; Send {Media_Play_Pause} ; old before 171201 
				Return

			:*:åå1::
				Send ^+{tab}
				Return

			:*:åå2::
				Send ^{tab}
				Return
				

			:*:öö5öö1::
				; send ^WheelDown ; zoom out
				NumpadSub:: Send, {CTRLDOWN}{NumpadSub}{CTRLUP}
				Return

			:*:öö5öö2::
				NumpadAdd:: Send, {CTRLDOWN}{NumpadAdd}{CTRLUP}
				; send ^WheelUp ; zoom in
				; send ^WheelDown ; zoom out

				; ^WheelUp,,,3,0,D,R ; zoom in
				Return

			:*:öö5öö3::
				Send {end}
				Return
				
			:*:öö5öö4::
				Send {home}
				Return

			; :*:öö5öö5:: 
				; Send !{right}
				; Return

			:*:öö5öö6::
				Send !#h
				Return
				
			:*:öö5öö7::
				Send {Media_Play_Pause}
				Return

			:*:öö5åå1::
				Send ^+{tab}
				Return

			:*:öö5åå2::
				Sendraw test 
				Return
			


			; %(key numpad3)%(abbreviation bvyldelay)v%(abbreviation bvyldelay)%(key right)%(key lalt+s)%(delay 1000)%(key numpad3)%(abbreviation bvymdelay)%(key esc)%(key ctrl+w)

			{	;##############  Various (

			; CapsLock & space:: ; auto completion 
				; {	
				; GetKeyState, stateLCtrl, LCtrl
				; GetKeyState, stateLShift, LShift
				; GetKeyState, stateLWin, LWin
				; GetKeyState, stateLAlt, LAlt
				; GetKeyState, stateRCtrl, RCtrl
				; GetKeyState, stateRShift, RShift
				; GetKeyState, stateRWin, RWin
				; GetKeyState, stateRAlt, RAlt
				; if stateLCtrl=D
					; if stateLShift=D
						; if stateLWin=D
							; if stateLAlt=D
								; send ^!+#{del} 
							; else
								; send ^+#{del} 
						; else if stateLAlt=D
							; send ^+!{del} 
						; else
							; send ^+{del}
					; else if stateLWin=D
						; if stateLAlt=D
							; send ^!#{del} ;^!#{del} behaviors incorrectly 
						; else
							; send ^#{del}
					; else if stateLAlt=D
							; send x ; ^!{del} does work, but is not needed nor wanted 
					; else
						; send ^{del}
				; else if stateLShift=D
						; if stateLWin=D
							; if stateLAlt=D
								; send +#!{del} 
							; else
								; send +#{del} 
						; else if stateLAlt=D
							; send +!{del} 
						; else
							; send +{del}
					; else if stateLWin=D
						; if stateLAlt=D
							; send !#{del} ;!#{del} behaviors incorrectly 
						; else
							; send #{del}
					; else if stateLAlt=D
						; send !{del}
					; else
						; send {tab}
						; sleep 100 
						; send {space}
				; return 
				; }

			; CapsLock & v:: 
				; {
				; GetKeyState, stateLCtrl, LCtrl
				; GetKeyState, stateLAlt, LAlt
				; GetKeyState, stateLShift, LShift
				; GetKeyState, stateLWin, LWin
				; GetKeyState, stateRCtrl, RCtrl
				; GetKeyState, stateRAlt, RAlt
				; GetKeyState, stateRShift, RShift
				; GetKeyState, stateRWin, RWin
				; GetKeyState, stateScrollLock, ScrollLock

				; if stateLCtrl=D
					; if stateLAlt=D
						; if stateLShift=D
							; if stateLWin=D ; ^!+#{f3} 
								; send ^!+#{f3} 
							; else ; ^!+{f3} 
								; send ^!+{f3} 
						; else if stateLWin=D ; ^!#{f3} 
							; send ^!#{f3} 
						; else ; ^!{f3}
							; send ^!{f3}
					; else if stateLShift=D
						; if stateLWin=D ; ^+#{f3} 
							; send ^+#{f3} 
						; else ; ^+{f3}
							; send ^+{f3}
					; else if stateLWin=D ; ^#{f3} 
						; send ^#{f3} 
					; else ; ^{f3}
						; send ^{f3}

				; else if stateLAlt=D
						; if stateLShift=D
							; if stateLWin=D ; !+#{f3} 
								; send !+#{f3} 
							; else ; !+{f3} 
								; send !+{f3} 
						; else if stateLWin=D ; !#{f3} 
							; {
								; sleep 300
								; Selecline()  
								; send {F9}
								; return
							; }
						; else ; !{f3}
							; send !{f3}
					; else if stateLShift=D
						; if stateLWin=D ; +#{f3} 
							; send +#{f3} 
						; else ; +{f3} 
							; send +{f3}
					; else if stateLWin=D ; #{f3} ; there is an issue with § and # alone (but all other combinations seem fine, possibly due to differences in how # behaviors compared to other modifiers). 
						; ; 2016-06-30 have tried to fix it but given up for now, avoid it for now 
							; {
							; sleep 500
							; send {F9}
							; return
							; }
					; else ; {f3} 
						; send {f3} 
				; return 
				; }

			; CapsLock & w::
				; {
				; GetKeyState, stateLCtrl, LCtrl
				; GetKeyState, stateLAlt, LAlt
				; GetKeyState, stateLShift, LShift
				; GetKeyState, stateLWin, LWin
				; GetKeyState, stateRCtrl, RCtrl
				; GetKeyState, stateRAlt, RAlt
				; GetKeyState, stateRShift, RShift
				; GetKeyState, stateRWin, RWin
				; GetKeyState, stateScrollLock, ScrollLock

				; if stateLCtrl=D
					; if stateLAlt=D
						; if stateLShift=D
							; if stateLWin=D ; ^!+#{f5} 
								; send ^!+#{f5} 
							; else ; ^!+{f5} 
								; send ^!+{f5} 
						; else if stateLWin=D ; ^!#{f5} 
							; send ^!#{f5} 
						; else ; ^!{f5}
							; send ^!{f5}
					; else if stateLShift=D
						; if stateLWin=D ; ^+#{f5} 
							; send ^+#{f5} 
						; else ; ^+{f5}
							; send ^+{f5}
					; else if stateLWin=D ; ^#{f5} 
						; send ^#{f5} 
					; else ; ^{f5}
						; send ^{f5}

				; else if stateLAlt=D
						; if stateLShift=D
							; if stateLWin=D ; !+#{f5} 
								; send !+#{f5} 
							; else ; !+{f5} 
								; send !+{f5} 
						; else if stateLWin=D ; !#{f5} 
							; {
							; sleep 300
							; Selecline()  
							; send {F9}
							; sleep 1500
							; send #7
							; return
							; } 
						; else ; !{f5}
							; send !{f5}
					; else if stateLShift=D
						; if stateLWin=D ; +#{f5} 
							; send +#{f5} 
						; else ; +{f5} 
							; ; send +{f5}
							; {
							; sleep 500
							; send {F9}
							; }

					; else if stateLWin=D ; #{f5} ; there is an issue with § and # alone (but all other combinations seem fine, possibly due to differences in how # behaviors compared to other modifiers). 
						; ; 2016-06-30 have tried to fix it but given up for now, avoid it for now 
						; {
						; sleep 500
						; send {F9}
						; sleep 1500
						; send #7
						; }
					; else ; {f5} 
						; {
						; sleep 500
						; send {F9}
						; sleep 1500
						; send #7
						; }

				; return 
				; }


			}
				;############End Various ) 

			; Save images 
			; Save x number of images using user input 
			:*:4hspx::
			:*:4hsvimgx::
			:*:4hsimgx::
			:*:4hdlimgx::
			:*:4hdlix::
			:*:4hsvix::
			:*:4hsix::
			:*:4hsvix::
			:*:4hsvpx::
			:*:4hspicx::
			:*:4hsvpicx::
				sleep 100 
				Input, UserInput, L1 ; Input will wait for one (L1 means maximum length of string is 1 character) keystroke. 
					Loop, %UserInput%
					{
					ChromeSaveImage()
					}
				return
			return

			ChromeSaveImage(){
				sleep 300
				click right 
				sleep 1100
				send v
				WinWait, Save As,, 3
					if ErrorLevel
						{
						MsgBox, WinWait timed out. 
						return
						}
				sleep 100 
				send !n
				send {right}
				send {enter}
				sleep 1100 
				click right
				sleep 100 
				send {esc}
				send ^w
				return 
				}

			; archive version that also works 
			; :*:4hdlix::
				; sleep 300
				; click, right 
				; sleep 100
				; send {down 2}
				; sleep 100
				; send {enter} 
				; WinWait, Save As,, 3
					; if ErrorLevel
						; {
						; MsgBox, WinWait timed out. 
						; return
						; }
				; sleep 100 
				; send !s
				; sleep 100 
				; return 

			return 

			#ifwinactive 
			}
			;############end Chrome active)

		{	;############## Not IfWinActive section  

			:*:4h01::
				sleep 100
				ChromeBookmarksMain()
				sleep 700
				StuckKeyUp()
				send {tab 3}
				sleep 100
				send {down 3}
				sleep 100
				send {enter}
				sleep 100
				send {end}
				sleep 100
				return 

			:*:4h02::
				sleep 100
				ChromeBookmarksMain()
				sleep 700
				StuckKeyUp()
				send {tab 3}
				sleep 100
				send {down 4}
				sleep 100
				send {enter}
				sleep 100
				send {end}
				sleep 100
				return 

			:*:4h03::
				sleep 100
				ChromeBookmarksMain()
				sleep 700
				StuckKeyUp()
				send {tab 3}
				sleep 100
				send {down 5}
				sleep 100
				send {enter}
				sleep 100
				send {end}
				sleep 100
				return 

			:*:4h04::
				sleep 100
				ChromeBookmarksMain()
				sleep 700
				StuckKeyUp()
				send {tab 3}
				sleep 100
				send {down 6}
				sleep 100
				send {enter}
				sleep 100
				send {end}
				sleep 100
				return 

			:*:4h0e::
				sleep 100
				ChromeBookmarksMain()
				sleep 700
				StuckKeyUp()
				send {tab 3}
				sleep 100
				send {down 7}
				sleep 100
				send {enter}
				sleep 100
				send {end}
				sleep 100
				return 

			:*:4h0f::
				sleep 100
				ChromeBookmarksMain()
				sleep 700
				StuckKeyUp()
				send {tab 3}
				sleep 100
				send {down 8}
				sleep 100
				send {enter}
				sleep 100
				send {end}
				sleep 100
				return 

				ChromeBookmarksMain(){
				sleep 300
				WinActivate Chrome 
				sleep 100 
				send ^t
				sleep 100 
				send ^+o ; this opens the bookmarks tab, activating any open bookmarks tab 
				; sendraw chrome://bookmarks/
				sleep 100 
				sendraw #1
				sleep 100 
				send {enter}
				; Run, bookmarks/#1
				return 
				}

			:*:4h0set::
				sleep 100 
				ChromeSettings()
				StuckKeyUp()
				return 

				ChromeSettings(){
				sleep 300
				WinActivate Chrome 
				send ^t
				sleep 100 
				sendraw chrome://settings/
				sleep 100 
				send {enter}
				; Run, bookmarks/#1
				return 
				}

			return ; 2017-12-15 is needed 

			; %(key ctrl+t)chrome://bookmarks/#1%(key enter)%(delay 2000ms)%(key tab 4)%(key down 8)%(key enter)%(abbreviation bvysdelay)%(key end)

			{	;##############  borderless browsing   

			; 2016-05-04 08.31 
				; found below as a solution to get borderless browsing in a separate window (only works when using the "Chrome as App" below, and it has flaws making it bad to use at the moment)
				
			;Open Chrome as App
			:*:xl4cbl::
				run, C:\Program Files (x86)\Google\Chrome\Application\chrome.exe --app="http://www.google.com"
				winwait, ahk_class Chrome_WidgetWin_1 
				winwait, Google
				sleep 1100 ; should be enough with winwait but isn't 

			; make it Borderless Window
				; WinSet, AlwaysOntop, Toggle, A
				WinSet, Style, ^0xC00000, A ;removes title bar ^ is a toggle
				WinSet, Style, ^0x40000, A ;removes resize border ^ is a toggle
				return

			; make any window Borderless
			:*:xborderl::
			:*:xbrdrl::
			:*:xmborderl::
			:*:xmbrdrl::
			^!+z::
				; WinSet, AlwaysOntop, Toggle, A
				WinSet, Style, ^0xC00000, A ;removes title bar ^ is a toggle
				WinSet, Style, ^0x40000, A ;removes resize border ^ is a toggle
				return

			}
				;############End borderless browsing   

			}
			;###########End Not IfWinActive section  

		}
			;###########End Chrome 

	{	;##############  Endnote   
		; 2016-07-06 18.22 
			; moved several Adobe Acrobat specific things to that section 
		; 2016-07-05 09.00 

		{	;##############  Endnote active  

		#ifwinActive ahk_exe EndNote.EXE ; 2018-03-09 14.09 new method 
		; #ifwinActive ahk_class EndNote X8 Frame ; 2018-03-09 used to work 

		:*:4erssrch::
		:*:4ersx::
		:*:4erssx::
		:*:4esstnd::
		:*:4estndds::
		:*:4esdef::
		:*:4edefx::
		:*:4esstnd::
			sleep 100 
			ahkEndnoteDefaultSearch()
			return 

		; Search any field local library 
		:*:4esrx::
		:*:4eslx:: 
			sleep 50 
			ahkEndnoteFocusAllReferences() 
			ahkEndnoteFindAnyField()
			sleep 50
			return 

		; Search title local library 
		:*:4estlx:: 
			sleep 50 
			ahkEndnoteFocusAllReferences() 
			ahkEndnoteFindTitle()
			sleep 50
			return 

		; Search for author in local library in Endnote 
		:*:4esalx:: 
		:*:4esaulx::
			sleep 50 
			ahkEndnoteFocusAllReferences() 
			ahkEndnoteFindAuthor()
			return 

		:*:4esonlix:: ; Search PubMed in Endnote 
		:*:4espubmx::
		:*:4esncx::
			sleep 50 
			click 244, 648, 1
			sleep 111 
			click 240, 1148, 1
			sleep 111 
			click 240, 1148, 1
			sleep 111 
			click 205, 1081, 1
			sleep 500 
			ahkEndnoteFindTitle()
			sleep 1100 
			send {enter}
			sleep 1100 
			ahkEndnoteDownloadTopSearchHit()
			sleep 100 
			return 

		:*:4e4wos:: ; search web of science 
			sleep 50 
			; click 240, 548, 1
			sleep 111 
			; click 130, 1099, 1
			sleep 500 
			ahkEndnoteFindTitle() 
			sleep 50
			return 

		; Search web of science inside Endnote 
		/*

		2018-03-09 14.28
			updated to work in Windows 10 
		*/
		
		:*:4eswos:: 
		:*:4ewos:: 
			sleep 50 
			click 225, 1022, 1
			sleep 111 
			click 230, 1022, 1
			sleep 111 
			sleep 111 
			click 100, 940, 1
			sleep 500 
			ahkEndnoteDefaultSearch()
			sleep 500 
			ahkEndnoteFindTitle()
			sleep 50
			return 


		:*:4earn:: ; Add research note AKA Endnote comment Endnote 
		:*:4earnx::
		:*:4eernx::
		:*:4ernx::
		:*:4enerno::
		:*:4enern::
		:*:4egtrn::
		:*:4eernc::
		:*:4eeditrn::
		:*:4eerno::
		:*:4eacmtx::
		:*:4eadcx::


			sleep 50 
			click 1606, 94, 1
			sleep 1111 

			Loop, 22
				{
				click 1913, 1155, 1
				sleep 50
				}

				; Loop
					; {
					; GetKeyState, state, LButton
					; if state = U
						; {
						; break
						; }
					; }

			click 1830, 1150, 1
			sleep 500
			send +{tab 11}
			sleep 50
			return 

		::4eatc::
		::4earnc::
			sleep 50 
			click 1919, 1138, 1
			sleep 111 
			click 1919, 1138, 1
			sleep 111 
			click 1919, 1138, 1
			sleep 111 
			click 1830, 1150, 1
			sleep 500 
			send +{tab 11}
			sleep 50
			send ^v
			sleep 50
			return

		:*:4ecna::
		:*:4ecan::
		:*:4ecpan::
		:*:4ecpname::
		:*:4ecname::
		:*:4ecpnm::
			
			ahkEndnoteCopyTitle()
			return 

		ahkEndnoteCopyTitle()
			{
			sleep 50 
			click 1919, 140, 1
			sleep 50 
			click 1919, 140, 1
			sleep 50 
			click 1919, 140, 1
			sleep 50 
			click 1830, 211, 1
			sleep 500 
			send {tab 2}
			sleep 50
			send ^c
			sleep 500
			}

		:*:4efp:: ; find PDF For reference 
		:*:4efft::
		:*:4efpdf::
		:*:4egpdf::
		:*:4edlp::
		:*:4epdf::
		:*:4edlpdf::
			sleep 50 
			click 465, 60, 1
			sleep 50 
			return 

		ahkEndnoteDefaultSearch(){
			sleep 100 
			click 388, 105, 1
			sleep 333 
			send {down 4} 
			sleep 111 
			send {enter} 
			}


		ahkEndnoteFocusAllReferences(){
			sleep 100 
			click 244, 105, 1
			sleep 333 
			click 244, 105, 1
			sleep 111 
			click 244, 105, 1
			sleep 111 
			click 176, 120, 1
			sleep 50
			}

		ahkEndnoteDownloadTopSearchHit() 
			{
			send {f6}
			sleep 1100 
			send {up}
			send {down}
			sleep 1100 
			click 457, 67, 1
			sleep 50
			}

		::4efafc:: ; search clipboard for title 
		::4esafc::
			ahkEndnoteFindAnyField()
			return 

		ahkEndnoteFindAnyField() 
			{
			sleep 50 
			send ^f
			sleep 50 
			send ^a
			sleep 50 
			xahkmosclcb()
			sleep 300
			send ^v
			sleep 50 
			send {enter}
			sleep 50  
			}

		::4efauc:: ; search clipboard for title 
		::4esauc::
			ahkEndnoteFindAuthor()
			return 

		ahkEndnoteFindAuthor() 
			{
			sleep 50 
			send ^f
			sleep 50 
			send {tab 6}
			sleep 50 
			send ^a
			sleep 50 
			xahkmosclcb()
			sleep 300
			send ^v
			sleep 50 
			send {enter}
			sleep 50  
			}

		::4eftc:: ; search clipboard for title 
		::4estcb::
		::4estc::
			ahkEndnoteFindTitle()
			return 

		ahkEndnoteFindTitle() ; 2016-07-24 13.28 only works when using two screens and Endnote is to the left 
			{
			sleep 50 
			click 770, 180, 1
			sleep 50 
			send ^a
			sleep 50 
			xahkmosclcb()
			sleep 300
			send ^v
			sleep 50 
			send {enter}
			sleep 50 
			}

		^+h:: ; automatically accept all updates for references 
		; requires restart of AutoHotkey as it uses a neverending loop 
		; 2016-07-14 works, from http://community.thomsonreuters.com/t5/EndNote-Product-Suggestions/automatically-update-references/td-p/50643 

			start:
			WinWaitActive Review Available Updates
			click 430,130
			sleep 250
			Click 615,415
			Sleep 1000
			Goto start
			return 

		#ifwinActive

		}
			;############End Endnote active  

		{	;##############  Endnote not active  
		; everything here assumes Endnote is on right hand monitor and both screens have resolution 1920x1080 

		:*:4eslib:: ; Search local library in Endnote 
			sleep 50 
			click 2168, 105, 1
			sleep 333 
			click 244, 105, 1
			sleep 111 
			click 244, 105, 1
			sleep 111 
			click 176, 120, 1
			sleep 500 
			ahkEndnoteFindAnyField()
			sleep 50
			return 

		:*:4esonli:: ; Search PubMed in Endnote 
		:*:4espubm::
		:*:4esnc::
			sleep 50 
			click 2160, 1148, 1
			sleep 333 
			click 240, 1148, 1
			sleep 111 
			click 240, 1148, 1
			sleep 111 
			click 130, 1075, 1
			sleep 500 
			ahkEndnoteFindTitle()
			sleep 50
			return 

		:*:4eswos:: ; Search web of science inside Endnote 
		:*:4ewos:: 
		:*:4e4wos:: 
			sleep 50 
			click 2160, 1148, 1
			sleep 333
			click 240, 1148, 1
			sleep 111 
			click 240, 1148, 1
			sleep 111 
			click 130, 1099, 1
			sleep 500 
			ahkEndnoteFindTitle()
			sleep 50
			return 

		}
			;############End Endnote not active  

		{	;##############  archive (

		; can open pfd by using ^!p instead 
			; !#o:: 
			; :*:4eopdf::
			; :*:4elpdf::
			; :*:4eoado::
			; :*:4elado::
				; sleep 222 
				; ahkEndnoteOpenPDF()
				; return 

			; ahkEndnoteOpenPDF() 
				; {
				; click right 1749, 97, 1
				; sleep 50 
				; send {down}
				; sleep 111 
				; send {enter}
				; sleep 50
				; return 
				; }



		}
			;############End archive )  

		}
		;############End Endnote   

	{	;##############  Everything 
		; this is the program Everything and related programs like wox (primarily in its own section at the end of this h document 
		; 2017-03-21 yyy finish making this as generalizable template for "[chwl]?[[iäö]?[89]]?" and document in rahk 

		#!space::
			xahksrchevthw()
			return 

		:*:xl8:: 
		:*:xlev8:: 
			sleep 100 
			send +^{left}
			xahksrchevthw()
			return 

		:*:xli8::
		:*:xlevi8::
			sleep 100 
			send +{home}
			xahksrchevthw()
			return 

		:*:xli9::
		:*:xlevli9::
			sleep 100 
			send {end 3}
			send +{home 3}
			xahksrchevthw()
			return 
			
		:*:xlwx::
		:*:xlevwx::
			xahksrchevthw()
			return 

			xahksrchevthw(){
			sleep 100 
			send ^c
			sleep 100 
			ClipWait, 1
				if ErrorLevel
				{
					MsgBox, copy text to clipboard failed.
					return
				}
			xahksrchevthcb()
			return 
			}

		:*:xl9::		
		:*:xlcx::		
		; ::xlec::		
		; :*:xlevc::		
		; :*:xlevthc::		
			xahksrchevthcb()
			return 
		
			xahksrchevthcb(){
				xahkrmwsscb()
				sleep 100 
				xahklaunchEvth()
				sleep 100
				send aoeu
				send ^a
				sleep 100 
				send ^v
				sleep 100
				send ^6
				sleep 100
				Winset, Alwaysontop, Off ; updated 2017-08-28 08.29 
				sleep 100
				return 
				}

			xahklaunchEvth(){
				run c:\Program Files (x86)\Everything\Everything.exe 
				WinWait, Everything
				return 
				}
		}
		;############End Everything 

		{	;############## Excel (
		/*
		Excel RefInfo 

		2017-04-15
			created this 
		*/
		
		{	;##############  Excel active 
		; possible to use winnamex or winidx to change ifwinactive to more specific id 

		#IfwinActive ahk_class XLMAIN ; seems to work correctly 
		; #IfwinActive - Excel 

		
		; surface dial commands inside newprogramname
		^!+f8:: ; rotate left surface dial
			sleep 300
			msgbox testLeft
			sleep 100
			return

		^!+f9:: ; Rotate right surface dial AND Down up down
			sleep 300
			msgbox testRight
			sleep 100
			return

		^!+f10:: ; click surface dial
			sleep 300
			msgbox testClick
			sleep 100
			return


		§ & a::
			{
		/*

		2017-04-15 13.42
			added Copy cell range using name box with ^
		*/ 
			GetKeyState, stateLCtrl, LCtrl
			GetKeyState, stateLAlt, LAlt
			GetKeyState, stateLShift, LShift
			GetKeyState, stateLWin, LWin
			GetKeyState, stateRCtrl, RCtrl
			GetKeyState, stateRAlt, RAlt
			GetKeyState, stateRShift, RShift
			GetKeyState, stateRWin, RWin
			GetKeyState, stateScrollLock, ScrollLock
			if stateLCtrl=D
				if stateLAlt=D
					if stateLShift=D
						if stateLWin=D ; ^!+#{x} 
							sendraw ^!+#{x} 
						else ; ^!+{x} 
							sendraw ^!+{x} 
					else if stateLWin=D ; ^!#{x} 
						sendraw ^!#{x} 
					else ; ^!{x}
						sendraw ^!{x}
				else if stateLShift=D
					if stateLWin=D ; ^+#{x} 
						sendraw ^+#{x} 
					else ; ^+{x}
						sendraw ^+{x}
				else if stateLWin=D ; ^#{x} 
					sendraw ^#{x} 
				else ; ^{x}
					sendraw ^{x}

			else if stateLAlt=D
					if stateLShift=D
						if stateLWin=D ; !+#{x} 
							sendraw !+#{x} 
						else ; !+{x} 
							sendraw !+{x} 
					else if stateLWin=D ; !#{x} 
						sendraw !#{x} 
					else ; !{x}
						sendraw !{x}
				else if stateLShift=D
					if stateLWin=D ; +#{x} 
						sendraw +#{x} 
					else ; +{x} 
						sendraw +{x}
				else if stateLWin=D ; #{x} ; there is an issue with § and # alone (but all other combinations seem fine, possibly due to differences in how # behaviors compared to other modifiers). 
					; 2016-06-30 have tried to fix it but given up for now, avoid it for now 
					sendraw #{x} 
				else ; {x} 
					{
					sleep 300 ; activate name box 
					click 83, 173
					sleep 100
					return
					}
			return 
			}

		§ & o:: ; [comment here "theme of this hotkey"] 
			{
			/*

			Add comments here using ncmth system 
			*/ 
			GetKeyState, stateLCtrl, LCtrl
			GetKeyState, stateLAlt, LAlt
			GetKeyState, stateLShift, LShift
			GetKeyState, stateLWin, LWin
			GetKeyState, stateRCtrl, RCtrl
			GetKeyState, stateRAlt, RAlt
			GetKeyState, stateRShift, RShift
			GetKeyState, stateRWin, RWin
			GetKeyState, stateScrollLock, ScrollLock


			if stateLCtrl=D
				if stateLAlt=D
					if stateLShift=D
						if stateLWin=D ; ^!+#{x} 
							sendraw ^!+#{x} 
						else ; ^!+{x} 
							sendraw ^!+{x} 
					else if stateLWin=D ; ^!#{x} 
						sendraw ^!#{x} 
					else ; ^!{x}
						sendraw ^!{x}
				else if stateLShift=D
					if stateLWin=D ; ^+#{x} 
						sendraw ^+#{x} 
					else ; ^+{x}
						sendraw ^+{x}
				else if stateLWin=D ; ^#{x} 
					sendraw ^#{x} 
				else ; ^{x}
					sendraw ^{x}

			else if stateLAlt=D
					if stateLShift=D
						if stateLWin=D ; !+#{x} 
							sendraw !+#{x} 
						else ; !+{x} 
							sendraw !+{x} 
					else if stateLWin=D ; !#{x} 
						sendraw !#{x} 
					else ; !{x}
						sendraw !{x}
				else if stateLShift=D
					if stateLWin=D ; +#{x} 
						sendraw +#{x} 
					else ; +{x} 
						sendraw +{x}
				else if stateLWin=D ; #{x} ; there is an issue with § and # alone (but all other combinations seem fine, possibly due to differences in how # behaviors compared to other modifiers). 
					; 2016-06-30 have tried to fix it but given up for now, avoid it for now 
					sendraw #{x} 
				else ; {x} 
					
					sendraw {x} 
					; {
					; sleep 300
					; sendraw test
					; sleep 100
					; return
					; }

			return 
			}

		§ & x:: ; [comment here "theme of this hotkey"]
			{
			GetKeyState, stateLCtrl, LCtrl
			GetKeyState, stateLAlt, LAlt
			GetKeyState, stateLShift, LShift
			GetKeyState, stateLWin, LWin
			GetKeyState, stateRCtrl, RCtrl
			GetKeyState, stateRAlt, RAlt
			GetKeyState, stateRShift, RShift
			GetKeyState, stateRWin, RWin
			GetKeyState, stateScrollLock, ScrollLock

			if stateLCtrl=D
				if stateLAlt=D
					if stateLShift=D
						if stateLWin=D ; ^!+#{x} 
							sendraw ^!+#{x} 
						else ; ^!+{x} 
							sendraw ^!+{x} 
					else if stateLWin=D ; ^!#{x} 
						sendraw ^!#{x} 
					else ; ^!{x}
						sendraw ^!{x}
				else if stateLShift=D
					if stateLWin=D ; ^+#{x} 
						sendraw ^+#{x} 
					else ; ^+{x}
						sendraw ^+{x}
				else if stateLWin=D ; ^#{x} 
					sendraw ^#{x} 
				else ; ^{x}
					sendraw ^{x}

			else if stateLAlt=D
					if stateLShift=D
						if stateLWin=D ; !+#{x} 
							sendraw !+#{x} 
						else ; !+{x} 
							sendraw !+{x} 
					else if stateLWin=D ; !#{x} 
						sendraw !#{x} 
					else ; !{x}
						sendraw !{x}
				else if stateLShift=D
					if stateLWin=D ; +#{x} 
						sendraw +#{x} 
					else ; +{x} 
			
						{
						sleep 300
						sendraw ava
						sleep 100
						return
						}
				else if stateLWin=D ; #{x} ; there is an issue with § and # alone (but all other combinations seem fine, possibly due to differences in how # behaviors compared to other modifiers). 
					; 2016-06-30 have tried to fix it but given up for now, avoid it for now 
					sendraw #{x} 
				else ; {x} 
				
				{
				sleep 300 
				click 
				send !a 
				sleep 200 
				send {home}
				sleep 200 
				send {del}
				sleep 200 
				send {end}
				sleep 200 
				sendraw x 
				sleep 100 
				return 
				}
			return 
			}

		CapsLock & w:: ; [comment here "theme of this hotkey"]
			{
			GetKeyState, stateLCtrl, LCtrl
			GetKeyState, stateLAlt, LAlt
			GetKeyState, stateLShift, LShift
			GetKeyState, stateLWin, LWin
			GetKeyState, stateRCtrl, RCtrl
			GetKeyState, stateRAlt, RAlt
			GetKeyState, stateRShift, RShift
			GetKeyState, stateRWin, RWin
			GetKeyState, stateScrollLock, ScrollLock

			if stateLCtrl=D
				if stateLAlt=D
					if stateLShift=D
						if stateLWin=D ; ^!+#{f5} 
							send ^!+#{f5} 
						else ; ^!+{f5} 
							send ^!+{f5} 
					else if stateLWin=D ; ^!#{f5} 
						send ^!#{f5} 
					else ; ^!{f5}
						send ^!{f5}
				else if stateLShift=D
					if stateLWin=D ; ^+#{f5} 
						send ^+#{f5} 
					else ; ^+{f5}
						send ^+{f5}
				else if stateLWin=D ; ^#{f5} 
					send ^#{f5} 
				else ; ^{f5}
					send ^{f5}

			else if stateLAlt=D
					if stateLShift=D
						if stateLWin=D ; !+#{f5} 
							send !+#{f5} 
						else ; !+{f5} 
							send !+{f5} 
					else if stateLWin=D ; !#{f5} 
						{
						sleep 300
						Selecline()  
						send {F9}
						sleep 1500
						send #7
						return
						} 
					else ; !{f5}
						send !{f5}
				else if stateLShift=D
					if stateLWin=D ; +#{f5} 
						send +#{f5} 
					else ; +{f5} 
						; send +{f5}
						{
						sleep 500
						send {F9}
						}

				else if stateLWin=D 
					{
					sleep 500
					send {F9}
					sleep 1500
					send #7
					}
				else ; {f5} 
					{
					sleep 500
					send {F9}
					sleep 1500
					send #7
					}

			return 
			}

		§ & f1::
			sleep 100 
			ExcelAddFormula()
			return 

			ExcelAddFormula(){
			sleep 300 
			; send / ; does not work to focus search box 
			send {esc}
			sleep 100 
			send {f2}
			sleep 100
			send ^!q
			sleep 100
			Click 
			return
			}
		return 

		; ^#h::
		; 	return 

		; ^!#h::
		; 	return 

		+#h::
			sleep 300 
			send {end 3}
			send +{home 3}
			sleep 300 
			send {f9} 
			return 

		{	;##############  Strokeit Gestures (
		/*

		*/
		
		; Strokeit Always program specific gestures 

		; ^!+f1::			;Left
			; sleep 100
			; ; send available 
			; return

		; ^!+f2::			;Right
			; sleep 100
			; ; send available 
			; return

		; ^!+f4::			;up down up
			; sleep 100
			; ; send available 
			; return

		; ^!+f5::			;Up
			; sleep 100
			; ; send available 
			; return

		; ^!+f6::			;Down
			; sleep 100
			; ; send available 
			; return


		}
			; ############End Strokeit Gestures )

		return 

		#ifwinactive 
		}
			;############end Excel active  

		{	;##############  Outside Excel  

		; Activate Excel
		; :*:xl4newprogramabr::
			; ahkOpenExcel()
			; return 

			; ahkOpenExcel(){
				; IfWinExist, ahk_class Excel
				; {
					; WinActivate  ; Automatically uses the window found above.
					; WinMaximize  
					; Send, Example text.{Enter} 
					; return
				; }
				; else
				; {
					; winactivate ahk_class Excel
					WinMove, 40, 40  ; Move window to a new position.
					; return
				; }			
			; }

		}
			;############End Outside Excel  

		}
		;###########End Excel )  

	{	;##############  GraphPad active 
		; possible to use winnamex or winidx to change ifwinactive to more specific id 
		#IfwinActive, GraphPad
		; § & a:: ; combine the top two commands into one 
		; ^g:: 
		; ^r:: 
		; ^h:: 
			return 

		^+s::
		:*:222s::
			{
			sleep 300
			send !f
			send {enter}
			send a
			return
			}

		^+!s::
		:*:33s::
		:*:22s::
			{
			sleep 300
			send !f
			send {enter}
			send a
			WinWait, Save ; GraphPad is flawed in many ways, does not follow conventions 
			;sleep 500
			;break 
			send {right}
			sleep 100
			send ^{left}
			sleep 100
			send {left}
			sleep 100
			send ^+{left 5}
			sleep 300
				ahkDaTi2()
			sleep 100
			send {enter}
			return
			}

		#ifwinactive 

		ahkDaTi2()
			{
			FormatTime, CurrentDateTime,, yyyy-MM-dd HH.mm
			SendInput %CurrentDateTime% 
			return
			}
		{	;##############  Outside GraphPad  


		}
			;############End Outside GraphPad  


		}
		;############end GraphPad active  

	{	;##############  IrfanView (
		/*
		IrfanView RefInfo 
			
		IrfanView Documentation 
			
		*/


		{	;##############  IrfanView active(
		; possible to use  more specific name using ahk_class (find using xwinspy)

		#IfwinActive, IrfanView 
		; instructions: 
			(; 1. select everything within parentheses starting on this line 
			; 2. uncomment everything within these parentheses 
			; 3. remove these instructions 

		{	;############## move mouse pointer inside IrfanView (
		/*
			to be created: a default version 

		2017-06-25 20.52
			started this 
		*/

		:*:mmtlx::
			Click 100, 225, 0  ; Move the mouse without clicking. 
			return 
		:*:mmtmx::
			Click 670, 106, 0  ; Move the mouse without clicking. 
			return 
		:*:mmtrx::
			Click 1700, 225, 0  ; Move the mouse without clicking. 
			return 

		:*:mmmlx::
			Click 100, 500, 0  ; Move the mouse without clicking. 
			return 
		:*:mmmx::
			Click 900, 500, 0  ; Move the mouse without clicking. 
			return 
		:*:mmmrx::
			Click 1700, 500, 0  ; Move the mouse without clicking. 
			return 

		:*:mmblx::
			Click 100, 1100, 0  ; Move the mouse without clicking. 
			return 
		:*:mmbmx::
			Click 900, 1100, 0  ; Move the mouse without clicking. 
			return 
		:*:mmbrx::
			Click 1700, 1100, 0  ; Move the mouse without clicking. 
			return 

		}
			;###########End move mouse pointer inside IrfanView )

		{	;##############  surface pen commands (

		/*
		below from https://www.reddit.com/r/Surface/comments/3356za/a_little_script_for_onenote_and_powerpoint/
		2017-10-12 20.50
			updating to use single click as undo 
		2017-08-29 12.07
			updated this with PenCounter 
		*/

		; PenCounterIrfanView = 1 
		; PenCounterIrfanViewDclick = 1 
			/*
			
			2017-08-29 12.10
				this should be correct to have here for use with surface pen counter 
				this way it is reset each time AutoHotkey is restarted but unique for each program it is used within 
			*/
		
		; #F20:: ; Single click surface pen in IrfanView

		; advanced version 
			; PenCounterIrfanView ++

			; If PenCounterIrfanView >= 4 
				; {
				; Sleep 10
				; PenCounterIrfanView = 1
				; StuckKeyUp()
				; msgbox %PenCounterIrfanView% ; test to confirm everything is working correctly 
				; ; Send !%PenCounterIrfanView%
				; }
			; else If PenCounterIrfanView = 2
				; {
				; msgbox %PenCounterIrfanView% ; test to confirm everything is working correctly 
				; StuckKeyUp()
				; }

			; else if PenCounterIrfanView = 3 
				; {
				; msgbox %PenCounterIrfanView% ; test to confirm everything is working correctly 
				; }

		; Return

		; simple version 
			; ; PenCounterIrfanView ++
			; ; If PenCounterIrfanView = 5
				; ; PenCounterIrfanView = 1
			; ; StuckKeyUp()
			; ; ; Send {LAlt Down}%PenCounterIrfanView%{LAlt Up}
			; ; ; msgbox %PenCounterIrfanView% ; test to confirm everything is working correctly 
			; ; StuckKeyUp()
			; ; Return

		; #F19:: ; Doble click surface pen in IrfanView

		; OneNote 2017-09-06 version 
			; PenCounterOneNoteDClick ++
			; If PenCounterOneNoteDClick < 5 ; should not be required but is for unknown reason 
				; PenCounterOneNoteDClick = 5
			; If PenCounterOneNoteDClick = 7
				; PenCounterOneNoteDClick = 5
			; StuckKeyUp()
			; Send !%PenCounterOneNoteDClick%
			; ; msgbox %PenCounterOneNoteDClick% ; test to confirm everything is working correctly 
			; StuckKeyUp()
			; Return


		; old version 
			; PenCounterIrfanViewDClick ++
			; If PenCounterIrfanViewDClick = 4
				; PenCounterIrfanViewDClick = 1
			; StuckKeyUp()
			; ; Send !%PenCounterIrfanViewDClick%
			; ; msgbox %PenCounterIrfanViewDClick% ; test to confirm everything is working correctly 
			; StuckKeyUp()
			; Return

		; #F18:: ; long press surface pen in IrfanView
			; sleep 300
			; sendraw ava
			; sleep 100
			; return

		}
			;############End surface pen commands )


		; surface dial commands 
		^!+f8:: ; rotate left surface dial
			sleep 300
			sendraw testLeft
			sleep 100
			return

		^!+f9:: ; rotate right surface dial
			sleep 300
			sendraw testRight
			sleep 100
			return

		^!+f10:: ; click surface dial
			sleep 300
			sendraw testClick
			sleep 100
			return

		; Strokeit Always program specific gestures 
		!+F1::			;T upside
			; 2014-10-02 14.45 - had very strange issue with this changing the projector settings (after realising it it was easy to change it back (win+p, wait 2 secs, press enter, repeat if necessary)) 
			sleep 100
			; send available 
			return

		^+s::			;Down Up
			sleep 100
			send {del}
			sleep 100
			send {enter}
			sleep 100
			send {right}
			return

		^!+s::			;left right
			sleep 100
			send {del}
			sleep 100
			send {right}
			return

		^!+f1::			;Left
			sleep 100
			; send available 
			return

		^!+f2::			;Right
			sleep 100
			; send available 
			return

		^!+f4::			;up down up
			sleep 100
			; send available 
			return

		^!+f5::			;Up
			sleep 100
			; send available 
			return

		^!+f6::			;Down
			sleep 100
			; send available 
			return

		^!+f9::			;down up down
			sleep 100
			; send available 
			return

		^!+f10::		;left right left
			sleep 100
			; send available 
			return

		^!+f11::		;right down 
			sleep 100
			; send available 
			return

		^!+f12::		;right up program specific
			sleep 100
			; send available 
			return

		+#M::			;/ Up - / DownRestore All 
			sleep 100
			; send available 
			return


		; § & a:: ; [comment here "theme of this hotkey"] 
			; {
			/*

			Add comments here using ncmth system 
			*/ 
			; GetKeyState, stateLCtrl, LCtrl
			; GetKeyState, stateLAlt, LAlt
			; GetKeyState, stateLShift, LShift
			; GetKeyState, stateLWin, LWin
			; GetKeyState, stateRCtrl, RCtrl
			; GetKeyState, stateRAlt, RAlt
			; GetKeyState, stateRShift, RShift
			; GetKeyState, stateRWin, RWin
			; GetKeyState, stateScrollLock, ScrollLock

			; sleep 300 
			; Input, UserInput, L1 ; Input will wait for one (L1 means maximum length of string is 1 character) keystroke. 
			; to use with loop: 
				; Loop, %UserInput%
				; {
				; msgbox, Hi
				; }

			; if stateLCtrl=D
				; if stateLAlt=D
					; if stateLShift=D
						; if stateLWin=D ; ^!+#{x} 
							; sendraw ^!+#{x} 
						; else ; ^!+{x} 
							; sendraw ^!+{x} 
					; else if stateLWin=D ; ^!#{x} 
						; sendraw ^!#{x} 
					; else ; ^!{x}
						; sendraw ^!{x}
				; else if stateLShift=D
					; if stateLWin=D ; ^+#{x} 
						; sendraw ^+#{x} 
					; else ; ^+{x}
						; sendraw ^+{x}
				; else if stateLWin=D ; ^#{x} 
					; sendraw ^#{x} 
				; else ; ^{x}
					; sendraw ^{x}

			; else if stateLAlt=D
					; if stateLShift=D
						; if stateLWin=D ; !+#{x} 
							; sendraw !+#{x} 
						; else ; !+{x} 
							; sendraw !+{x} 
					; else if stateLWin=D ; !#{x} 
						; sendraw !#{x} 
					; else ; !{x}
						; sendraw !{x}
				; else if stateLShift=D
					; if stateLWin=D ; +#{x} 
						; sendraw +#{x} 
					; else ; +{x} 
						; sendraw +{x}
				; else if stateLWin=D ; #{x} ; there is an issue with § and # alone (but all other combinations seem fine, possibly due to differences in how # behaviors compared to other modifiers). 
					; ; 2016-06-30 have tried to fix it but given up for now, avoid it for now 
					; sendraw #{x} 
				; else ; {x} 
					
					; sendraw {x} 
					; ; {
					; ; sleep 300
					; ; sendraw test
					; ; sleep 100
					; ; return
					; ; }

			; return 
			; }

		; § & o:: ; [comment here "theme of this hotkey"] 
			; {
			; /*

			; Add comments here using ncmth system 
			; */ 
			; GetKeyState, stateLCtrl, LCtrl
			; GetKeyState, stateLAlt, LAlt
			; GetKeyState, stateLShift, LShift
			; GetKeyState, stateLWin, LWin
			; GetKeyState, stateRCtrl, RCtrl
			; GetKeyState, stateRAlt, RAlt
			; GetKeyState, stateRShift, RShift
			; GetKeyState, stateRWin, RWin
			; GetKeyState, stateScrollLock, ScrollLock

			; ; sleep 300 
			; ; Input, UserInput, L1 ; Input will wait for one (L1 means maximum length of string is 1 character) keystroke. 
			; ; ; to use with loop: 
				; ; Loop, %UserInput%
				; ; {
				; ; msgbox, Hi
				; ; }

			; if stateLCtrl=D
				; if stateLAlt=D
					; if stateLShift=D
						; if stateLWin=D ; ^!+#{x} 
							; sendraw ^!+#{x} 
						; else ; ^!+{x} 
							; sendraw ^!+{x} 
					; else if stateLWin=D ; ^!#{x} 
						; sendraw ^!#{x} 
					; else ; ^!{x}
						; sendraw ^!{x}
				; else if stateLShift=D
					; if stateLWin=D ; ^+#{x} 
						; sendraw ^+#{x} 
					; else ; ^+{x}
						; sendraw ^+{x}
				; else if stateLWin=D ; ^#{x} 
					; sendraw ^#{x} 
				; else ; ^{x}
					; sendraw ^{x}

			; else if stateLAlt=D
					; if stateLShift=D
						; if stateLWin=D ; !+#{x} 
							; sendraw !+#{x} 
						; else ; !+{x} 
							; sendraw !+{x} 
					; else if stateLWin=D ; !#{x} 
						; sendraw !#{x} 
					; else ; !{x}
						; sendraw !{x}
				; else if stateLShift=D
					; if stateLWin=D ; +#{x} 
						; sendraw +#{x} 
					; else ; +{x} 
						; sendraw +{x}
				; else if stateLWin=D ; #{x} ; there is an issue with § and # alone (but all other combinations seem fine, possibly due to differences in how # behaviors compared to other modifiers). 
					; ; 2016-06-30 have tried to fix it but given up for now, avoid it for now 
					; sendraw #{x} 
				; else ; {x} 
					
					; sendraw {x} 
					; ; {
					; ; sleep 300
					; ; sendraw test
					; ; sleep 100
					; ; return
					; ; }

			; return 
			; }

		; § & x:: ; temporary things frequently updated 
			; {
			; GetKeyState, stateLCtrl, LCtrl
			; GetKeyState, stateLAlt, LAlt
			; GetKeyState, stateLShift, LShift
			; GetKeyState, stateLWin, LWin
			; GetKeyState, stateRCtrl, RCtrl
			; GetKeyState, stateRAlt, RAlt
			; GetKeyState, stateRShift, RShift
			; GetKeyState, stateRWin, RWin
			; GetKeyState, stateScrollLock, ScrollLock

			; if stateLCtrl=D
				; if stateLAlt=D
					; if stateLShift=D
						; if stateLWin=D ; ^!+#{x} 
							; sendraw ^!+#{x} 
						; else ; ^!+{x} 
							; sendraw ^!+{x} 
					; else if stateLWin=D ; ^!#{x} 
						; sendraw ^!#{x} 
					; else ; ^!{x}
						; sendraw ^!{x}
				; else if stateLShift=D
					; if stateLWin=D ; ^+#{x} 
						; sendraw ^+#{x} 
					; else ; ^+{x}
						; sendraw ^+{x}
				; else if stateLWin=D ; ^#{x} 
					; sendraw ^#{x} 
				; else ; ^{x}
					; sendraw ^{x}

			; else if stateLAlt=D
					; if stateLShift=D
						; if stateLWin=D ; !+#{x} 
							; sendraw !+#{x} 
						; else ; !+{x} 
							; sendraw !+{x} 
					; else if stateLWin=D ; !#{x} 
						; sendraw !#{x} 
					; else ; !{x}
						; sendraw !{x}
				; else if stateLShift=D
					; if stateLWin=D ; +#{x} 
						; sendraw +#{x} 
					; else ; +{x} 
			
						; {
						; sleep 300
						; sendraw ava
						; sleep 100
						; return
						; }
				; else if stateLWin=D ; #{x} ; there is an issue with § and # alone (but all other combinations seem fine, possibly due to differences in how # behaviors compared to other modifiers). 
					; ; 2016-06-30 have tried to fix it but given up for now, avoid it for now 
					; sendraw #{x} 
				; else ; {x} 
				
				; {
				; sleep 300 
				; click 
				; send !a 
				; sleep 200 
				; send {home}
				; sleep 200 
				; send {del}
				; sleep 200 
				; send {end}
				; sleep 200 
				; sendraw x 
				; sleep 100 
				; return 
				; }
			; return 
			; }


		; CapsLock & w::
			; {
			; GetKeyState, stateLCtrl, LCtrl
			; GetKeyState, stateLAlt, LAlt
			; GetKeyState, stateLShift, LShift
			; GetKeyState, stateLWin, LWin
			; GetKeyState, stateRCtrl, RCtrl
			; GetKeyState, stateRAlt, RAlt
			; GetKeyState, stateRShift, RShift
			; GetKeyState, stateRWin, RWin
			; GetKeyState, stateScrollLock, ScrollLock

			; if stateLCtrl=D
				; if stateLAlt=D
					; if stateLShift=D
						; if stateLWin=D ; ^!+#{f5} 
							; send ^!+#{f5} 
						; else ; ^!+{f5} 
							; send ^!+{f5} 
					; else if stateLWin=D ; ^!#{f5} 
						; send ^!#{f5} 
					; else ; ^!{f5}
						; send ^!{f5}
				; else if stateLShift=D
					; if stateLWin=D ; ^+#{f5} 
						; send ^+#{f5} 
					; else ; ^+{f5}
						; send ^+{f5}
				; else if stateLWin=D ; ^#{f5} 
					; send ^#{f5} 
				; else ; ^{f5}
					; send ^{f5}

			; else if stateLAlt=D
					; if stateLShift=D
						; if stateLWin=D ; !+#{f5} 
							; send !+#{f5} 
						; else ; !+{f5} 
							; send !+{f5} 
					; else if stateLWin=D ; !#{f5} 
						; {
						; sleep 300
						; Selecline()  
						; send {F9}
						; sleep 1500
						; send #7
						; return
						; } 
					; else ; !{f5}
						; send !{f5}
				; else if stateLShift=D
					; if stateLWin=D ; +#{f5} 
						; send +#{f5} 
					; else ; +{f5} 
						; ; send +{f5}
						; {
						; sleep 500
						; send {F9}
						; }

				; else if stateLWin=D ; #{f5} ; there is an issue with § and # alone (but all other combinations seem fine, possibly due to differences in how # behaviors compared to other modifiers). 
					; ; 2016-06-30 have tried to fix it but given up for now, avoid it for now 
					; {
					; sleep 500
					; send {F9}
					; sleep 1500
					; send #7
					; }
				; else ; {f5} 
					; {
					; sleep 500
					; send {F9}
					; sleep 1500
					; send #7
					; }

			; return 
			; }

		; § & numpad1:: ; [comment here "theme of this hotkey"] 
			; /*

			; Add comments here using ncmth system 
			; */ 
			; {
			; GetKeyState, stateLCtrl, LCtrl
			; GetKeyState, stateLAlt, LAlt
			; GetKeyState, stateLShift, LShift
			; GetKeyState, stateLWin, LWin
			; GetKeyState, stateRCtrl, RCtrl
			; GetKeyState, stateRAlt, RAlt
			; GetKeyState, stateRShift, RShift
			; GetKeyState, stateRWin, RWin
			; GetKeyState, stateScrollLock, ScrollLock
			; if stateLCtrl=D
				; if stateLAlt=D
					; if stateLShift=D
						; if stateLWin=D ; ^!+#{x} 
							; sendraw ^!+#{x} 
						; else ; ^!+{x} 
							; sendraw ^!+{x} 
					; else if stateLWin=D ; ^!#{x} 
						; sendraw ^!#{x} 
					; else ; ^!{x}
						; sendraw ^!{x}
				; else if stateLShift=D
					; if stateLWin=D ; ^+#{x} 
						; sendraw ^+#{x} 
					; else ; ^+{x}
						; sendraw ^+{x}
				; else if stateLWin=D ; ^#{x} 
					; sendraw ^#{x} 
				; else ; ^{x}
					; sendraw ^{x}

			; else if stateLAlt=D
					; if stateLShift=D
						; if stateLWin=D ; !+#{x} 
							; sendraw !+#{x} 
						; else ; !+{x} 
							; sendraw !+{x} 
					; else if stateLWin=D ; !#{x} 
						; sendraw !#{x} 
					; else ; !{x}
						; sendraw !{x}
				; else if stateLShift=D
					; if stateLWin=D ; +#{x} 
						; sendraw +#{x} 
					; else ; +{x} 
						; sendraw +{x}
				; else if stateLWin=D ; #{x} ; there is an issue with § and # alone (but all other combinations seem fine, possibly due to differences in how # behaviors compared to other modifiers). 
					; ; 2016-06-30 have tried to fix it but given up for now, avoid it for now 
					; sendraw #{x} 
				; else ; {x} 
					; sendraw {x} 
					; ; {
					; ; sleep 300
					; ; sendraw test
					; ; sleep 100
					; ; return
					; ; }
			; return 
			; }

		; ^#h::
			; return 

		; ^!#h::
			; return 

		; +#h::
			; sleep 300 
			; send {end 3}
			; send +{home 3}
			; sleep 300 
			; send {f9} 
			; return 

		; ^!+F1:: 			
			; sleep 300
			; send !p
			; sleep 300
			; send {left}
			; sleep 300
			; send {down 2}
			; sleep 300
			; send {right}
			; sleep 700
			; send {up 4}
			; sleep 700
			; send {enter}
			; ; send ! 
			; return 

		; ^!+F2:: 
			; sleep 300
			; send !easo
			; return 

		; ^!+F3:: 
			; sleep 500 
			; Return 

		; ^!+F4:: 
		; return

		; ^!+F5:: 
			; sleep 500 

		; ^!+F6:: 
			; sleep 500 
			; send {Pgdn}
			; return

		; ;^!+F7::  taken for media next 

		; ^!+F8:: 
			; return

		; ^!+F9:: 
			; return 

		; ^!+F10:: 
			; return
			
		; ^!+F11:: 
			; return

		; ^!+F12:: 
			; return 

		) ; remove this after uncommenting 

		return 

		#ifwinactive 
		}
			;############end IrfanView active)

		{	;##############  IrfanView Subfolders active (
		/*

		2017-05-01 19.13
			created 
		*/
		
		#ifwinactive, Browse Subfolders ; 2017-05-01 19.28 works to activate correct IrfanView window 

		^!+f11 ;right down program specific IrfanView: move between folders inside full screen mode (once "browse subfolders" is active). i.e. move to next folder (downwards) 
			{
			sleep 300
			send {left}
			sleep 100
			send {down}
			sleep 100
			send {right}
			sleep 100
			send {right}
			sleep 100
			return
			}

		#ifwinactive 

		}
			;############End IrfanView Subfolders active )

		{	;##############  Outside IrfanView(

		; Activate IrfanView
		; :*:xl4newprogramabr::
			; ahkOpenIrfanView()
			; return 

			; ahkOpenIrfanView(){
				; IfWinExist, IrfanView
				; {
					; WinActivate  ; Automatically uses the window found above.
					; WinMaximize  
					; return
				; }
				; else
				; {
					; winactivate IrfanView
					; WinMove, 40, 40  ; Move window to a new position.
					; return
				; }			
			; }

		}
			;############End Outside IrfanView) 

		{	;##############  Archive IrfanView(
		/*
		Things not useful at the moment kept here for future reference 
			
		*/
		

		}
			;############End Archive IrfanView) 

		}
		;############End IrfanView )

	{	;##############  ISAcreator  ##############
		:*:4ictod:: 
			send f2
			sleep 50
			send enter 
			
			return 	
		}
		;########### End ISAcreator  ##############

	{	;##############  MediaMonkey ##############
		#IfWinActive MediaMonkey

		;These r available to be used for something else: 
			; {
			; <^>!down::Send {PgDn} 
			; <^>!up::Send {PgUp}
			; >+down::Send {PgDn} 
			; >+up::Send {PgUp}
			; }

		§ & a:: ; Creating playlists  
			{
			/*

			2017-06-19 16.08
				create this based on Breevy commands (rmusic) 
			*/ 
			GetKeyState, stateLCtrl, LCtrl
			GetKeyState, stateLAlt, LAlt
			GetKeyState, stateLShift, LShift
			GetKeyState, stateLWin, LWin
			GetKeyState, stateRCtrl, RCtrl
			GetKeyState, stateRAlt, RAlt
			GetKeyState, stateRShift, RShift
			GetKeyState, stateRWin, RWin
			GetKeyState, stateScrollLock, ScrollLock
			if stateLCtrl=D
				if stateLAlt=D
					if stateLShift=D
						if stateLWin=D ; ^!+#{x} 
							sendraw ^!+#{x} 
						else ; ^!+{x} 
							sendraw ^!+{x} 
					else if stateLWin=D ; ^!#{x} 
						sendraw ^!#{x} 
					else ; ^!{x}
						sendraw ^!{x}
				else if stateLShift=D
					if stateLWin=D ; ^+#{x} 
						sendraw ^+#{x} 
					else ; ^+{x}
						sendraw ^+{x}
				else if stateLWin=D ; ^#{x} 
					sendraw ^#{x} 
				else ; ^{x}
					{
					sleep 300
					sendraw ire2
					sleep 100
					send {space}
					GoToMidleOfSongWhenInsideMediaMonkey()
					return
					}

			else if stateLAlt=D
					if stateLShift=D
						if stateLWin=D ; !+#{x} 
							sendraw !+#{x} 
						else ; !+{x} 
							sendraw !+{x} 
					else if stateLWin=D ; !#{x} 
						sendraw !#{x} 
					else ; !{x}
						{
						sleep 300
						sendraw ibkm2
						sleep 100
						send {space}
						GoToMidleOfSongWhenInsideMediaMonkey()
						return
						}
				else if stateLShift=D
					if stateLWin=D ; +#{x} 
						sendraw +#{x} 
					else ; +{x} 
						{
						sleep 300
						sendraw ibku2
						sleep 100
						send {space}
						GoToMidleOfSongWhenInsideMediaMonkey()
						return
						}
				else if stateLWin=D ; #{x} ; there is an issue with § and # alone (but all other combinations seem fine, possibly due to differences in how # behaviors compared to other modifiers). 
					; 2016-06-30 have tried to fix it but given up for now, avoid it for now 
						{
						sleep 300
						sendraw ibkn2
						sleep 100
						send {space}
						GoToMidleOfSongWhenInsideMediaMonkey()
						return
						}
				else ; {x} 
					{
					sleep 300
					sendraw ibkc2
					sleep 100
					send {space}
					GoToMidleOfSongWhenInsideMediaMonkey()
					return
					}
			return 
			}

		; ; surface dial commands inside newprogramname
		; ^!+f8:: ; rotate left surface dial
			; sleep 300
			; msgbox testLeft
			; sleep 100
			; return

		; ^!+f9:: ; Rotate right surface dial AND Down up down
			; sleep 300
			; msgbox testRight
			; sleep 100
			; return

		; ^!+f10:: ; click surface dial
			; sleep 300
			; msgbox testClick
			; sleep 100
			; return

		§ & o:: ; [comment here "theme of this hotkey"] 
			{
			/*

			Themes
				""	
				^	
				+	reverse 
				#	
				!	
				
			Add comments here using "ncmtli" (performs ^d, li9, ncmth)
			
			*/ 

			GetKeyState, stateLCtrl, LCtrl
			GetKeyState, stateLAlt, LAlt
			GetKeyState, stateLShift, LShift
			GetKeyState, stateLWin, LWin
			GetKeyState, stateRCtrl, RCtrl
			GetKeyState, stateRAlt, RAlt
			GetKeyState, stateRShift, RShift
			GetKeyState, stateRWin, RWin
			GetKeyState, stateScrollLock, ScrollLock
			if stateLCtrl=D
				if stateLAlt=D
					if stateLShift=D
						if stateLWin=D ; ^!+#{x} 
							sendraw ^!+#{x} 
						else ; ^!+{x} 
							sendraw ^!+{x} 
					else if stateLWin=D ; ^!#{x} 
						sendraw ^!#{x} 
					else ; ^!{x}
						sendraw ^!{x}
				else if stateLShift=D
					if stateLWin=D ; ^+#{x} 
						sendraw ^+#{x} 
					else ; ^+{x}
						sendraw ^+{x}
				else if stateLWin=D ; ^#{x} 
					sendraw ^#{x} 
				else ; ^{x}
					sendraw ^{x}

			else if stateLAlt=D
					if stateLShift=D
						if stateLWin=D ; !+#{x} 
							sendraw !+#{x} 
						else ; !+{x} 
							sendraw !+{x} 
					else if stateLWin=D ; !#{x} 
						sendraw !#{x} 
					else ; !{x}
						sendraw !{x}
				else if stateLShift=D
					if stateLWin=D ; +#{x} 
						sendraw +#{x} 
					else ; +{x} 
						sendraw +{x}
				else if stateLWin=D ; #{x} 
					; There is an issue with § and # alone. 
					; 2017-06-01 might not be a problem when pressing § first 
					; 2016-06-30 have tried to fix it but given up for now, avoid it for now 
					sendraw #{x} 
				else ; {x} 
					{ 
					sendraw {x} 
					}
			StuckKeyUp() ; 2018-01-21 20.11 moved it here, not evaluated 
			return 
			}

		§ & x:: ; [comment here "theme of this hotkey"]
			{
			/*

			Themes
				""	
				^	
				+	reverse 
				#	
				!	
				
			Add comments here using "ncmtli" (performs ^d, li9, ncmth)
			
			*/ 

			GetKeyState, stateLCtrl, LCtrl
			GetKeyState, stateLAlt, LAlt
			GetKeyState, stateLShift, LShift
			GetKeyState, stateLWin, LWin
			GetKeyState, stateRCtrl, RCtrl
			GetKeyState, stateRAlt, RAlt
			GetKeyState, stateRShift, RShift
			GetKeyState, stateRWin, RWin
			GetKeyState, stateScrollLock, ScrollLock
			if stateLCtrl=D
				if stateLAlt=D
					if stateLShift=D
						if stateLWin=D ; ^!+#{x} 
							sendraw ^!+#{x} 
						else ; ^!+{x} 
							sendraw ^!+{x} 
					else if stateLWin=D ; ^!#{x} 
						sendraw ^!#{x} 
					else ; ^!{x}
						sendraw ^!{x}
				else if stateLShift=D
					if stateLWin=D ; ^+#{x} 
						sendraw ^+#{x} 
					else ; ^+{x}
						sendraw ^+{x}
				else if stateLWin=D ; ^#{x} 
					sendraw ^#{x} 
				else ; ^{x}
					sendraw ^{x}

			else if stateLAlt=D
					if stateLShift=D
						if stateLWin=D ; !+#{x} 
							sendraw !+#{x} 
						else ; !+{x} 
							sendraw !+{x} 
					else if stateLWin=D ; !#{x} 
						sendraw !#{x} 
					else ; !{x}
						sendraw !{x}
				else if stateLShift=D
					if stateLWin=D ; +#{x} 
						sendraw +#{x} 
					else ; +{x} 
						sendraw +{x}
				else if stateLWin=D ; #{x} 
					; There is an issue with § and # alone. 
					; 2017-06-01 might not be a problem when pressing § first 
					; 2016-06-30 have tried to fix it but given up for now, avoid it for now 
					sendraw #{x} 
				else ; {x} 
					{ 
					sendraw {x} 
					}
			StuckKeyUp() ; 2018-01-21 20.11 moved it here, not evaluated 
			return 
			}

		CapsLock & a:: ; Cut Paste special 
			{
			/*

			Themes
				""	f2, left, home, paste, +end, cut
				^	
				+	
				#	save to clipboard 
				!	
				
			Add comments here using "ncmtli" (performs ^d, li9, ncmth)
			
			*/ 

			GetKeyState, stateLCtrl, LCtrl
			GetKeyState, stateLAlt, LAlt
			GetKeyState, stateLShift, LShift
			GetKeyState, stateLWin, LWin
			GetKeyState, stateRCtrl, RCtrl
			GetKeyState, stateRAlt, RAlt
			GetKeyState, stateRShift, RShift
			GetKeyState, stateRWin, RWin
			GetKeyState, stateScrollLock, ScrollLock
			if stateLCtrl=D
				if stateLAlt=D
					if stateLShift=D
						if stateLWin=D ; ^!+#{x} 
							sendraw ^!+#{x} 
						else ; ^!+{x} 
							sendraw ^!+{x} 
					else if stateLWin=D ; ^!#{x} 
						sendraw ^!#{x} 
					else ; ^!{x}
						sendraw ^!{x}
				else if stateLShift=D
					if stateLWin=D ; ^+#{x} 
						sendraw ^+#{x} 
					else ; ^+{x}
						sendraw ^+{x}
				else if stateLWin=D ; ^#{x} 
					sendraw ^#{x} 
				else ; ^{x}
					sendraw ^{x}

			else if stateLAlt=D
					if stateLShift=D
						if stateLWin=D ; !+#{x} 
							sendraw !+#{x} 
						else ; !+{x} 
							sendraw !+{x} 
					else if stateLWin=D ; !#{x} 
						sendraw !#{x} 
					else ; !{x}
						sendraw !{x}
				else if stateLShift=D
					if stateLWin=D ; +#{x} 
						sendraw +#{x} 
					else ; +{x} 
						sendraw +{x}
				else if stateLWin=D ; #{x} 
					{ 
					send {f2} 
					send ^c
					send {esc} 
					}
				else ; {x} 
					{ 
					send {f2} 
					send {left} 
					send {home} 
					send ^v
					send +{end}
					sleep 100 
					SaveHighlightedToAhkClipboard1()
					send {del} 
					send {enter} 
					}

			StuckKeyUp() ; 2018-01-21 20.11 moved it here, not evaluated 
			return 
			}

		CapsLock & w:: ; [comment here "theme of this hotkey"]
			{
			/*

			Themes
				""	
				^	
				+	reverse 
				#	
				!	
				
			Add comments here using "ncmtli" (performs ^d, li9, ncmth)
			
			*/ 

			GetKeyState, stateLCtrl, LCtrl
			GetKeyState, stateLAlt, LAlt
			GetKeyState, stateLShift, LShift
			GetKeyState, stateLWin, LWin
			GetKeyState, stateRCtrl, RCtrl
			GetKeyState, stateRAlt, RAlt
			GetKeyState, stateRShift, RShift
			GetKeyState, stateRWin, RWin
			GetKeyState, stateScrollLock, ScrollLock
			if stateLCtrl=D
				if stateLAlt=D
					if stateLShift=D
						if stateLWin=D ; ^!+#{x} 
							sendraw ^!+#{x} 
						else ; ^!+{x} 
							sendraw ^!+{x} 
					else if stateLWin=D ; ^!#{x} 
						sendraw ^!#{x} 
					else ; ^!{x}
						sendraw ^!{x}
				else if stateLShift=D
					if stateLWin=D ; ^+#{x} 
						sendraw ^+#{x} 
					else ; ^+{x}
						sendraw ^+{x}
				else if stateLWin=D ; ^#{x} 
					sendraw ^#{x} 
				else ; ^{x}
					sendraw ^{x}

			else if stateLAlt=D
					if stateLShift=D
						if stateLWin=D ; !+#{x} 
							sendraw !+#{x} 
						else ; !+{x} 
							sendraw !+{x} 
					else if stateLWin=D ; !#{x} 
						sendraw !#{x} 
					else ; !{x}
						sendraw !{x}
				else if stateLShift=D
					if stateLWin=D ; +#{x} 
						sendraw +#{x} 
					else ; +{x} 
						sendraw +{x}
				else if stateLWin=D ; #{x} 
					; There is an issue with § and # alone. 
					; 2017-06-01 might not be a problem when pressing § first 
					; 2016-06-30 have tried to fix it but given up for now, avoid it for now 
					sendraw #{x} 
				else ; {x} 
					{ 
					sendraw {x} 
					}
			StuckKeyUp() ; 2018-01-21 20.11 moved it here, not evaluated 
			return 
			}



		^#h::
			; return 

		^!#h::
			; return 

		+#h::
			sleep 300 
			send {end 3}
			send +{home 3}
			sleep 300 
			send {f9} 
			return 

		::bm2:: ; inbkm2 background mellow (less calm than calm) 
			sleep 300 
			sendraw inbkgrm2 
			send {space}
			sleep 2200 
			GoToMidleOfSongWhenInsideMediaMonkey()
			sleep 300 
			return 

		; yyy working here update to switch from using inbkgrm2 to use function below 
			; %(abbreviation p9)%(abbreviation i8)Instrumental%(key tab)%(abbreviation bkgr2)%(key tab)%(abbreviation bkgrm2)%(key enter)%(key shift+left 2)%(key down)%(key enter)%(key f2)%(abbreviation p9)


		::bc2:: ; inbkc2 background calm 
			sleep 300 
			sendraw ibkc2 
			send {space}
			sleep 2200 
			GoToMidleOfSongWhenInsideMediaMonkey(){
				sleep 1100 ; almost always want one second of hearing the beginning of the song 
				MouseMove,900,1190 ; middle of MediaMonkey on right screen
				sleep 900 
				Send {Click}
				sleep 100 
				return 
				}
			sleep 300 
			return 

		::bu2:: ; inbku2 
			sleep 300 
			sendraw ibkgru2
			send {space}
			sleep 2200 
			GoToMidleOfSongWhenInsideMediaMonkey()
			sleep 300 
			return 

		::bn2:: ; inbkn2 
			sleep 300 
			sendraw ibkgrn2
			send {space}
			sleep 2200 
			GoToMidleOfSongWhenInsideMediaMonkey()
			sleep 300 
			return 

		::su2:: ; singing uplifting  
		::singu2:: ; singing uplifting  
			sleep 300 
			sendraw singuplg 
			send {space}
			sleep 2200 
			GoToMidleOfSongWhenInsideMediaMonkey()
			sleep 300 
			return 

		::se2:: ; singing 
		::singe2:: ; singing easy
			sleep 300 
			sendraw singinge
			send {space}
			sleep 2200 
			GoToMidleOfSongWhenInsideMediaMonkey()
			sleep 300 
			return 

		::sue2:: ; singing uplifting and easy 
			sleep 300 
			send +{home}
			sleep 300 
			sendraw singu
			sleep 300 
			send {space}
			sleep 300 
			send {tab}
			sendraw singinge
			send {space}
			sleep 300 
			send {home}
			sleep 200 
			send {del}
			sleep 200 
			send {enter}
			sleep 200 
			send +{left}
			sleep 200 
			send {down}
			sleep 700 
			send {enter}
			sleep 1100 
			GoToMidleOfSongWhenInsideMediaMonkey()
			sleep 300 
			return 

		::nb2:: ; not instrumental not background 
			sleep 300 
			sendraw nibkgr2
			send {space}
			sleep 2200 
			GoToMidleOfSongWhenInsideMediaMonkey()
			sleep 300 
			return 

		^n::
			sleep 100
			send ^t
			sleep 500 
			send +{tab} 
			sleep 100 
			send 5
			return 
		^l::
		#F20::
			sleep 500
			send ^l
			sleep 1000
			send ^6
			sleep 2200
			send !f
			sleep 500
			send {down 2}
			sleep 500
			send {enter}
			return	
		^+a::
			sleep 300
			send +{enter}
			sleep 900
			send ^{tab 2}
			sleep 500
			send {tab 5}
			send xxbkgrda2
			sleep 500 
			return 
		^+o::
			sleep 300
			send +{enter}
			sleep 900
			send ^{tab 2}
			sleep 500
			send {tab 5}
			send xxreda2
			sleep 500 
			return 				

		; ^+s::
			; sleep 600 
			; send !f
			; sleep 300
			; send {down 3}
			; sleep 300
			; send {enter}
			; winwait, save as
			; ;sleep 500
			; send {right}
			; sleep 100
			; send ^{left}
			; sleep 100
			; send {left}
			; sleep 100
			; send ^+{left 5}
			; sleep 300
				; ahkdati2()
			; sleep 100
			; send {enter}
			; return 

		^!+s::
			sleep 500 
			send !f
			sleep 300
			send a
			sleep 700 
			send {home} 
			send ^{right 3}
			send {left}
			Return 

		^+#s::
			send !f
			sleep 300
			send a
			sleep 300 
			send ^{left} 
			send {left}
			Return 
		^!F1:: send ^F1
		^!F2:: send l 
		^!F3:: 
			send ht5
			return 
		^!F4:: 
		^!F5:: 
		^!F6:: 
		^!F7:: 
		^!F8:: 
		^!F9:: 
		^!F10:: 
		^!F11:: send {Volume_Up}{Volume_Up}{Volume_Up}
		^!F12:: send {Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}

		!+F1:: ; go to last page with annotation 
			sleep 200
			send !gl
			sleep 700
			send !gw
			return 

		!+F2:: send ^T
		!+F3::		
		!+F4:: 
		!+F5:: 
		!+F6:: 
		!+F7:: 
		!+F8:: 
		!+F9:: 
		!+F10:: 
		;!+F11:: send {Volume_Up}{Volume_Up}{Volume_Up}
		;!+F12:: send {Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}

		;^!+PgUp:: send x ; never send x in PDF Annotator 
		;PgDn:: send x ; never send x in PDF Annotator 

		^!+F1:: 			
			send !t
			return 
		^!+F2:: ; delete pages without annotation 
			; only works when in normal mode 
			sleep 300
			send !easo
			sleep 300 
			send !eae
			sleep 300
			send {tab}
			;send {space}
			return 
		^!+F3:: 
			sleep 500 
			send !f
			sleep 300
			send a
			sleep 300 
			send {home} 
			send ^{right}
			;send {backspace} 
			Return 
		; up down up:
		^!+F4:: 
		return
		^!+F5:: 
			sleep 500 
			send {Pgup}
			sleep 300
			send {down 3}
			return
		^!+F6:: 
			sleep 500 
			send {Pgdn}
			sleep 300
			send {up 3}
			return
		;^!+F7::  taken for media next 

		:*:4mmms:: 
		:*:4mmcms:: 
			sleep 100 
			MouseMove,1100,1190 ; middle of MediaMonkey on right screen
			sleep 100 
			Send {Click}
			return 

		:*:öö7::
			sleep 100 
			MouseMove,1100,1190 ; middle of MediaMonkey on right screen
			sleep 100 
			Send {Click}
			return 

		#ifwinactive


		; SC056 & å:: ; MediaMonkey Previous song 
		; SC056 & ö:: ; MediaMonkey next song 
		; SC056 & .:: ; MediaMonkey skip 5 seconds backwards 
		; SC056 & q:: ; MediaMonkey skip 5 seconds forward 

		:*:4mmms:: 
		:*:4mmcms:: 
			sleep 100 
			WinActivate, MediaMonkey // Added this so it does not have to be on top on second monitor (takes first window with this title)
			sleep 100 
			MouseMove,948,1190 ; Once MediaMonkey is active this should go to middle of MediaMonkey song progression bar on right screen
			sleep 100 
			Send {Click}
			return 


		}
		;########### End MediaMonkey ##############
		
	{	;##############  Notepad++  

		/*
		2018-04-22 11.57
			Continuously moving things to VSCode to prevent duplication 
		2018-04-18 16.17
			moved many things to VSCode section 
		*/
			 
		{	;##############  Notepad++ active 
		/*
		Almost everything that is activated when inside Notepad++ should be organized here 

		*/ 
		; SetTitleMatchMode, 2 
		#IfwinActive ahk_exe notepad++.exe ; changed to this 2018-02-26 16.36 
		; #IfwinActive Notepad++ [Administrator] ; works 2017-03-29 10.23 
			; requires always being administrator 
		; using "#IfwinActive ahk_class Notepad++, Notepad++" does not work at all 
		; #IfwinActive Notepad++, Notepad++, Test, Tes ; does not work 
		; #IfwinActive Notepad++ & #IfwinNotActive xls ; does not work 

		:*:4sbrcx::
		:*:ccc9::
		:*:ccb9::

			{
			sleep 100 
			Click 3695, 145, 1  ; Click left mouse button at specified coordinates.
			sleep 100 
			send ^v
			sleep 100 
			RETURN 
			}

		:*:4sbrx::
		:*:cc9::
			{
			Click 3695, 145, 1  ; Click left mouse button at specified coordinates.
			RETURN 
			}

	
		#ifwinactive

		}
			;############End Notepad++ active ############## 

		; launching Stata launch Stata 
		:*:xl4s::
			sleep 300 
			send #8 ; 2018-04-18 15.41 changed to this to have Breevy work inside Stata 
			; run, C:\Program Files (x86)\Stata14\StataMP-64.exe ; works but runs it as admin f unknown reason 
			sleep 700 
			WinWaitActive, Stata/MP
			sleep 300 
			send #{left} 
			sleep 300 
			send browse
			sleep 300  
			send {enter}
			sleep 1500 
			send #{right}
			sleep 100 
			return 


		{ 	;##############  activate AutoHotkey tab in Notepad++  ##############
		;currently requires AutoHotkey script in separate window, should be possible to switch between tabs in Notepad++ instead
		:*:0ufoc::
		:*:0uedahk::
		:*:0uedi:: 
			sleep 300 
			AutoHotkeyMainScriptFocus()
			return 

		AutoHotkeyMainScriptFocus(){
			sleep 300
			IfWinExist AutoHotkey.ahk ; 
				{
					WinActivate, AutoHotkey.ahk
					WinWait AutoHotkey.ahk
					; msgbox testing 
					return 
				}
			
			; IfWinExist Notepad++ ; this is not ideal as of 2015-01-12 13.57 
				; { 
					; WinActivate, AutoHotkey.ahk
					; c
					; ;sleep 500 
					; msgbox test
					; ;Send {enter} 
					; WinActivate, Notepad++ 
					; return 
				; }
			Else 
				{
				WinActivate, Notepad++ 
				; msgbox AutoHotkey script is not focused
				sleep 100 
				return 
				}
			return 
			}


		return 

		}
			;########### END activate AutoHotkey tab in Notepad++  ##############
		}
		;############End Notepad++  

	{ 	;##############  OneNote  ##############

		; #ifwinactive OneNote
		#ifwinactive ahk_class Framework::CFrame ;only works if main desktop OneNote window is active. 
			; 2017-08-29 11.21 works on wrkpc and stesurf5
			; 2016-04-06 18.13 only works on wrkpc. Inactivating this has no impact on surface 

		{	;##############  OneNote Movement  ##############


		; capslock & h:: test that should always be inactive 
			; sleep 300
			; sendraw test
			; sleep 100
			; return


		capslock & c::
			{
			GetKeyState, stateLCtrl, LCtrl
			GetKeyState, stateLShift, LShift
			GetKeyState, stateLWin, LWin
			GetKeyState, stateLAlt, LAlt
			GetKeyState, stateRCtrl, RCtrl
			GetKeyState, stateRShift, RShift
			GetKeyState, stateRWin, RWin
			GetKeyState, stateRAlt, RAlt
			GetKeyState, stateSC056, SC056
			GetKeyState("SC056") 
			GetKeyState, stateCaps, CapsLock
			GetKeyState, stateScrollLock, ScrollLock
			if stateLCtrl=D
				if stateLShift=D
					if stateLWin=D
						if stateLAlt=D
							SendPlay ^!+#{up} 
						else
							SendPlay ^+#{up} 
					else if stateLAlt=D
						SendPlay ^+!{up} 
					else
						SendPlay ^+{up}
				else if stateLWin=D
					if stateLAlt=D
						SendPlay ^!#{up} 
					else
						SendPlay ^#{up}
				else if stateLAlt=D
						SendPlay ^!{up}
				else
					SendPlay ^{up}
			else if stateLShift=D
					if stateLWin=D
						if stateLAlt=D
							SendPlay +#!{up} 
						else
							SendPlay +#{up} 
					else if stateLAlt=D
						SendPlay +!{up} 
					else
						SendPlay +{up}
				else if stateLWin=D
					if stateLAlt=D
						SendPlay !#{up} 
					else
						SendPlay #{up}
				else if stateLAlt=D
					SendPlay !{up}
				else
					SendPlay {up}
			return 
			}

		CapsLock & t::
			{
			GetKeyState, stateRCtrl, RCtrl
			GetKeyState, stateRShift, RShift
			GetKeyState, stateRWin, RWin
			GetKeyState, stateRAlt, RAlt
			GetKeyState, stateSC056, SC056 
			GetKeyState, stateLCtrl, LCtrl
			GetKeyState, stateLShift, LShift
			GetKeyState, stateLWin, LWin
			GetKeyState, stateLAlt, LAlt
			if stateLCtrl=D
				if stateLShift=D
					if stateLWin=D
						if stateLAlt=D
							SendPlay ^!+#{down} ; Ctrl + SHIFT + alt + Win + down
						else
							SendPlay ^+#{down} ; Ctrl + SHIFT + Win + down
					else if stateLAlt=D
						SendPlay ^!+{down} ; Ctrl + SHIFT + alt + down
					else
						SendPlay ^+{down}	; Ctrl + SHIFT + down
				else if stateLWin=D
						if stateLAlt=D
							SendPlay ^+#{down} ; Ctrl + shift + Win + down
						else
							SendPlay ^#{down}	; Ctrl + win + down
				else if stateLAlt=D
					if stateLWin=D
						SendPlay ^!#{down} ; Ctrl + alt + win + down
					else
						SendPlay ^!{down} ; Ctrl + alt + down
				else if stateLWin=D
						SendPlay ^#{down} ; Ctrl + win + down 
				else
					SendPlay ^{down}	; Ctrl down
				else if stateLShift=D
					if stateLWin=D
						if stateLAlt=D
							SendPlay !+#{down} ; SHIFT + alt + Win + down
						else
							SendPlay +#{down} ; SHIFT + Win + down
					else if stateLAlt=D
						SendPlay !+{down} ; SHIFT + alt + down
					else
						SendPlay +{down} ; SHIFT + down
				else if stateLWin=D
					if stateLAlt=D
							SendPlay !#{down} ; alt + Win + down
					else
						SendPlay #{down} ; Win + down
				else if stateLAlt=D
					SendPlay !{down} ; Alt + down
				else
					SendPlay {down} ; down
			return
			}

		}
			;############End OneNote Movement  ############## 

		{	;##############  rotate images commands   

		; 2017-02-20 
			; started this 

		§ & h::
			{
			GetKeyState, stateLCtrl, LCtrl
			GetKeyState, stateLAlt, LAlt
			GetKeyState, stateLShift, LShift
			GetKeyState, stateLWin, LWin
			GetKeyState, stateRCtrl, RCtrl
			GetKeyState, stateRAlt, RAlt
			GetKeyState, stateRShift, RShift
			GetKeyState, stateRWin, RWin
			GetKeyState, stateScrollLock, ScrollLock

			if stateLCtrl=D
				if stateLAlt=D
					if stateLShift=D
						if stateLWin=D ; ^!+#{x} 
							sendraw ^!+#{x} 
						else ; ^!+{x} 
							sendraw ^!+{x} 
					else if stateLWin=D ; ^!#{x} 
						sendraw ^!#{x} 
					else ; ^!{x}
						sendraw ^!{x}
				else if stateLShift=D
					if stateLWin=D ; ^+#{x} 
						sendraw ^+#{x} 
					else ; ^+{x}
						sendraw ^+{x}
				else if stateLWin=D ; ^#{x} 
					sendraw ^#{x} 
				else ; ^{x}
					sendraw ^{x}

			else if stateLAlt=D
					if stateLShift=D
						if stateLWin=D ; !+#{x} 
							sendraw !+#{x} 
						else ; !+{x} 
							sendraw !+{x} 
					else if stateLWin=D ; !#{x} 
						sendraw !#{x} 
					else ; !{x} ; rotate image 90 degrees to the left 
						{
						sleep 300 
						send {appskey} ; i.e. menu key 
						send oo
						send {right}
						send l
						return 
						}
				else if stateLShift=D
					if stateLWin=D ; +#{x} 
						sendraw +#{x} 
					else ; +{x} 
						sendraw +{x}
				else if stateLWin=D ; #{x} ; there is an issue with § and # alone (but all other combinations seem fine, possibly due to differences in how # behaviors compared to other modifiers). 
					; 2016-06-30 have tried to fix it but given up for now, avoid it for now 
					sendraw #{x} 
				else ; {x} 
					send {numpad4}  
			return 
			}

		§ & n::
			{
			GetKeyState, stateLCtrl, LCtrl
			GetKeyState, stateLAlt, LAlt
			GetKeyState, stateLShift, LShift
			GetKeyState, stateLWin, LWin
			GetKeyState, stateRCtrl, RCtrl
			GetKeyState, stateRAlt, RAlt
			GetKeyState, stateRShift, RShift
			GetKeyState, stateRWin, RWin
			GetKeyState, stateScrollLock, ScrollLock

			if stateLCtrl=D
				if stateLAlt=D
					if stateLShift=D
						if stateLWin=D ; ^!+#{x} 
							sendraw ^!+#{x} 
						else ; ^!+{x} 
							sendraw ^!+{x} 
					else if stateLWin=D ; ^!#{x} 
						sendraw ^!#{x} 
					else ; ^!{x}
							{
							sleep 300 
							send {appskey}
							send oo
							send {right}
							send r
							sleep 100 
							send {esc}				
							sleep 300 
							send {down}
							sleep 300 
							send {down}
							sleep 100 
							return 
							}

				else if stateLShift=D
					if stateLWin=D ; ^+#{x} 
						sendraw ^+#{x} 
					else ; ^+{x}
						sendraw ^+{x}
				else if stateLWin=D ; ^#{x} 
					sendraw ^#{x} 
				else ; ^{x}
					sendraw ^{x}

			else if stateLAlt=D
					if stateLShift=D
						if stateLWin=D ; !+#{x} 
							sendraw !+#{x} 
						else ; !+{x} 
							sendraw !+{x} 
					else if stateLWin=D ; !#{x} 
						sendraw !#{x} 
					else ; !{x}
						{
						sleep 300 
						send {appskey}
						send oo
						send {right}
						send r
						return 
						}
				else if stateLShift=D
					if stateLWin=D ; +#{x} 
						sendraw +#{x} 
					else ; +{x} 
						sendraw +{x}
				else if stateLWin=D ; #{x} ; there is an issue with § and # alone (but all other combinations seem fine, possibly due to differences in how # behaviors compared to other modifiers). 
					; 2016-06-30 have tried to fix it but given up for now, avoid it for now 
					sendraw #{x} 
				else ; {x} 
					send {numpad6}  
			return 
			}

		}
			;############End rotate images commands   

		{	;##############  Various remappings  ##############

		PenCounterOneNote = 1
		PenCounterOneNoteDClick = 4
		; 2017-09-03 15.31 not sure where this should be placed 

		#F20:: ; Single click surface pen in OneNote 
		/*
		below from https://www.reddit.com/r/Surface/comments/3356za/a_little_script_for_onenote_and_powerpoint/

		2017-08-29 13.13
			works as desired 
		2017-08-29 12.07
			updated this with PenCounter 
		*/
		
			PenCounterOneNote ++
			If PenCounterOneNote >= 4
				PenCounterOneNote = 1
			StuckKeyUp()
			Send !%PenCounterOneNote%
			; msgbox %PenCounterOneNote% ; test to confirm everything is working correctly 
			StuckKeyUp()
			Return


		; if counter >=1   ; If an IF has more than one line, enclose those lines in braces:
		; {
			; WinClose, Untitled - Notepad
			; Sleep 10
		; }

		; if MyVar = %MyVar2%
			; MsgBox The contents of MyVar and MyVar2 are identical.

		; else if MyVar =
		; {
			; MsgBox, 4,, MyVar is empty/blank. Continue?
			; IfMsgBox, No
				; Return
		; }
		; else if MyVar <> ,
			; MsgBox The value in MyVar is not a comma.
		; else
			; MsgBox The value in MyVar is a comma.

		; if Done
			; MsgBox The variable Done is neither empty nor zero.


		#F19:: ; Doble click surface pen 
		
			PenCounterOneNoteDClick ++
			If PenCounterOneNoteDClick < 5 ; should not be required but is for unknown reason 
				PenCounterOneNoteDClick = 5
			If PenCounterOneNoteDClick = 7
				PenCounterOneNoteDClick = 5
			StuckKeyUp()
			Send !%PenCounterOneNoteDClick%
			; msgbox %PenCounterOneNoteDClick% ; test to confirm everything is working correctly 
			StuckKeyUp()
			Return



			; sleep 300 
			; send ^c
			; FocusChromeNewTab()
			; sleep 100 
			; send define
			; PerformChromeAdressbarSearch()
			; return 

			; sleep 300 
			; send ^c
			; FocusChromeNewTab()
			; sleep 100 
			; PerformChromeAdressbarSearch()
			; return 

			; send {alt} ;activate menu ; 2017-08-29 12.21 does not always work 
			; sleep 150 ;wait for menu to activate
			; send dp ;select draw=>pens. 
			; return 

		#F18:: ; long press surface pen 
			sleep 300 
			send {F11}
			return

		; 2016-03-02 
			; ^[F1-12] are working 
			; updating 
				; ^!+[F1-12]
			; f5:: 
				; sleep 300
				; send x
				; return
			*F14:: SendEvent ^{=}
			*F15:: SendEvent ^{-}
			^l::
				sleep 300 
				send {F11}
				return
			; !left::
				; send !{left}
				; sleep 300 
				; send {backspace}
			; !right::
				; send !{right}
				; sleep 300 
				; send {backspace} ;yyy possibly issue 
			; ^o:: 
				; sleep 300 
				; return 
			; ^s:: available (2016-03-02 17.12)
				; sleep 300 
				; send {alt}
				; sleep 100 
				; send 07 
				; return

			; ^!+s:: available (2016-03-02 17.12)
				; sleep 600 
				; send x
				; Return 
			; ^+#s:: available (2016-03-02 17.12)
				; sleep 300   
				; send x
				; Return 
			^F1:: ; used by OneNote to show/hide tabs 
				sleep 700
				send ^{F1} ; this only works on surface (with and without this cmd)
				return 
				
			^F2:: 
				sleep 300  
				send {alt}	
				sleep 300
				send 5
				Return 
			^F3::
				sleep 300
				send {alt}
				sleep 300
				send 6
				Return 
			^F4::
				sleep 300
				send {alt}
				sleep 300
				send 7
				Return 
			^F5::
				sleep 300
				send {alt}
				sleep 300
				send 8
				Return 
			^F6::
				sleep 300
				send {alt}
				sleep 300
				send 9
				Return 
			^F7::
				sleep 300
				send {alt}
				sleep 300
				send 09
				Return 
			^F8::
				sleep 300
				send {alt}
				sleep 300
				send 08
				Return 
			^F9::
				sleep 300
				send {alt}
				sleep 300
				send 07
				Return  
			^F10:: 
				sleep 300 
				send ^{f10}
				sleep 300 ; pause is needed probably due to MediaMonkey limitation  
				send ^{f10} ; sending this twise should make it play and pause 4mm
				send {alt}
				sleep 300
				send 06			
				return 
			^F11::
				sleep 300
				send {alt}
				sleep 300
				send 05
				Return 
			^F12::
				sleep 300
				send {alt}
				sleep 300
				send 04
				Return 
			; ^!F1:: send x
			^!F2:: 
				sleep 300
				send {alt}
				sleep 300
				send 03
				return 
			^!F3:: 
				sleep 300
				send {alt}
				sleep 300
				send 02
				return 
			^!F4:: 
				sleep 300
				send {alt}
				sleep 300
				send 01
				return 
			^!F5:: 
				sleep 300
				send {alt}
				sleep 300
				send 0a
				return 
			^!F6:: 
				sleep 300
				send {alt}
				sleep 300
				send 0b
				return 
			^!F7:: 
				sleep 300
				send {alt}
				sleep 300
				send 0c
				return 
			^!F8:: 
				sleep 300
				send {alt}
				sleep 300
				send 0d
				return 
			^!F9:: 
				sleep 300
				send {alt}
				sleep 300
				send 0e
				return 
			^!F10:: 
				sleep 300
				send {alt}
				sleep 300
				send 0f
				return 
			^!F11:: 
				sleep 300
				send {alt}
				sleep 300
				send 0g
				return 
			^!F12:: 
				sleep 300
				send {alt}
				sleep 300
				send 0h
				return 
			
			; !+right::
				; sleep 200
				; send !gl
				; sleep 700
				; send !gw
				; return 
			; !+F1:: ; used in OneNote 

			!+F2:: 
				sleep 300
				send {alt}
				sleep 300
				send 0f
				return 
			!+F3::		
				sleep 300
				send {alt}
				sleep 300
				send 0g
				return
				; !+F4:: 
			!+F5:: 
				sleep 300
				send {alt}
				sleep 300
				send 0h
				return
			!+F6:: 
				sleep 300
				send {alt}
				sleep 300
				send 0i
				return
			!+F7:: 
				sleep 300
				send {alt}
				sleep 300
				send 0j
				return
			!+F8:: 
				sleep 300
				send {alt}
				sleep 300
				send 0
				return
			!+F9:: 
				sleep 300
				send {alt}
				sleep 300
				send 0
				return
			!+F10:: 
				sleep 300
				send {alt}
				sleep 300
				send 0
				return
			!+F11:: 
				sleep 300
				send {alt}
				sleep 300
				send 0
				return
			;!+F12:: send {Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}
			;^!+PgUp:: send x ; never send available in PDF Annotator 
			;PgDn:: send x 

			^!+F1:: 			
				sleep 300
				send {alt}
				sleep 300
				send 4
				return	
			^!+F2:: ; delete pages without annotation 
				; only works when in normal mode 
				sleep 300
				send !easo
				sleep 300 
				send !eae
				sleep 300
				send {tab}
				;send {space}
				return 
			^!+F3:: 
				sleep 500 
				send !f
				sleep 300
				send a
				sleep 300 
				send {home} 
				send ^{right}
				;send {backspace} 
				Return 
			; ^!+F4:: 
				; return
			^!+F5:: 
				sleep 500 
				send {Pgup}
				sleep 300
				send {down 3}
				return
			^!+F6:: 
				sleep 500 
				send {Pgdn}
				sleep 300
				send {up 3}
				return
			;^!+F7::  taken for media next 
			; ^!+F8:: 
			; return
			; ^!+F9:: 
				; return 
			; ^!+F10:: 
				; sleep 300
				; send !eaa ;open append one page window  		
				; sleep 500 
				; send +{tab} 
				; sleep 300 
				; return
			; ^!+F11:: 
				; send 3cd3  
				; sleep 300
				; send p
				; return
			; ^!+F12:: 
				; send 3c3  
				; sleep 300
				; send p
				; return 

		}
			;############End Various remappings  ############## 
			#ifwinactive


		{	;##############  Outside of OneNote  ##############
		; Run, onenote /hyperlink onenote:///
		; :*:g4onva:: 
			; Run https://d.docs.live.net/8cfce8021ced6d68/Documents/Markus's%20Notebook/Quick%20Notes.one#VariousOneNotePhone&section-id={43390400-4917-4001-B61A-22254D4AA4C2}&page-id={BF123FC1-4773-4525-96BD-C0FBB18CCFBF}&end
			
			; Run, onenote /hyperlink onenote:https://d.docs.live.net/8cfce8021ced6d68/Documents/Markus's%20Notebook/Quick%20Notes.one#VariousOneNotePhone&section-id={43390400-4917-4001-B61A-22254D4AA4C2}&page-id={BF123FC1-4773-4525-96BD-C0FBB18CCFBF}&end
			; return 
			
		; %(Launch "onenote:https://d.docs.live.net/8cfce8021ced6d68/Documents/Markus's%20Notebook/Quick%20Notes.one#VariousOneNotePhone&section-id={43390400-4917-4001-B61A-22254D4AA4C2}&page-id={BF123FC1-4773-4525-96BD-C0FBB18CCFBF}&end")%(delay 2000ms)y 

		}
			;############End Outside of OneNote  ############## 


		} 
		;########### End OneNote  ##############

	{	;##############  Powerpoint ##############

			#IfWinActive PowerPoint
		^+s::
		:*:33s::
			sleep 600 
			send !f
			sleep 300
			;%(key lalt+f)%(delay 300ms)%(key a)%(delay 300ms)%(delay 1500ms)b%(delay 1100ms)%(key ctrl+left)%(key left)%(abbreviation öcu58)%(abbreviation dati2)%(key enter)
			send a
			sleep 1100
			send c
			sleep 1100
			send b
			WinWait, Save As
			;sleep 500
			;break 
			send {right}
			sleep 100
			send ^{left}
			sleep 100
			send {left}
			sleep 100
			send ^+{left 5}
			sleep 300
				ahkDaTi2()
			sleep 100
			send {enter}
			Return 
		^!+s::
			sleep 600 
			send !f
			sleep 300
			send a
			sleep 1100
			send c
			sleep 1100
			send b
			WinWait, Save As
			;sleep 700 
			; send {home} 
			; send ^{right} 
			Return 

		;MButton:: ; remove comments in Microsoft Word 2013 (worked 2014-10-30)
			;click, right  
			;sleep 300 
			;send ddd
			;sleep 300
			;send {enter} 
			;Return 

		^!F1:: send ^F1
		^!F2::  
		^!F3::  
		^!F4::  
		^!F5::  
		^!F6::  
		^!F7:: send x 
		^!F8:: send x 
		^!F9:: send x 
		^!F10:: send x 
		^!F11:: send {Volume_Up}{Volume_Up}{Volume_Up}
		^!F12:: send {Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}

		!+F2:: send ^T
		!+F1:: 
			!f
			Return

		!+F3:: send x 
		!+F4:: send x 
		!+F5:: send x 
		!+F6:: send x 
		!+F7:: send x 
		!+F8:: send x 
		!+F9:: send x 
		!+F10:: send x 
		!+F11:: send {Volume_Up}{Volume_Up}{Volume_Up}
		!+F12:: send {Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}

		;^!+PgUp:: send x 
		;PgDn:: send x 

		^!+F1:: 
			SetTimer, CloseContextMenu, 50
			send left
			send left
			send left
			send left
			send left			
			return 

		^!+F2:: a
		^!+F3:: 
			sleep 300 
			send {alt down} 
			sleep 50
			Send {Tab}
			sleep 50
			send {alt up} 
			return
		^!+F4:: send x 
		^!+F5:: send x 
		^!+F6:: send x 
		;^!+F7::  taken for media next 
		^!+F11:: send 3cd3  
		^!+F12:: 
			SetTimer, CloseContextMenu, 50
			send 3c5
			return 

		:*:bau9:: 
			sleep 50 
			ahkBackupGlobal()
			sleep 2260 
			ahkSaveAgainWithY()
			return 

		return 

		#ifwinactive
				
		; {	;##############  making the standard keys work on Svorak   
			; ^+>!r:: ; this works only if you release keys within 300ms 
				; ; send ^+!l
				; sleep 300
				; send !h
				; send f
				; send g
			; return 

			; ^+>!l:: 
				; ; send ^+!l
				; sleep 300
				; send !h
				; send f
				; send k
			; return 

		; }
			; ;############End making the standard keys work on Svorak  

		}
		;########### End Powerpoint ##############

	{	;##############  PDF Annotator 4pdfa ##############
		#IfWinActive PDF Annotator

		; surface dial commands inside PDF Annotator 
			{

			^!+f8:: ;rotate left surface dial
				sleep 300
				sendraw test
				sleep 100
				return

			^!+f9:: ;rotate right surface dial
				sleep 300
				sendraw test
				sleep 100
				return

			^!+f10:: ;click surface dial
				sleep 300
				sendraw test
				sleep 100
				return
			
			}

			;These r available to be used for something else: 
				{
				<^>!down::Send {PgDn} 
				<^>!up::Send {PgUp}
				>+down::Send {PgDn} 
				>+up::Send {PgUp}
				}

		{	;##############  Inactivating things when in PDF Annotator pdfa 
			:*:t1::
				return  
			:*:t2::
				return  
			:*:t3::
				return  
			:*:t4::
				return  
			:*:t5::
				return  
			:*:t6::
				return  
			:*:t7::
				return  
			:*:t8::
				return  
			:*:t9::
				return  
			:*:c0:: 
				return  
			:*:c1::
				return  
			:*:c2::
				return  
			:*:c3::
				return  
			:*:c4::
				return  
			:*:c5::
				return  
			:*:c6::
				return  
			:*:c7::
				return  
			:*:c8::
				return  
			:*:c9::
				return  
			:*:c0:: 
				return  		

		;	send D
			;send {left}{right}
			;send {space}
			;return
			
		}
			;############End Inactivating things when in PDF Annotator pdfa   
				
		{	;##############  surface pen commands (

		/*
		below from https://www.reddit.com/r/Surface/comments/3356za/a_little_script_for_onenote_and_powerpoint/

		2017-08-29 12.07
			updated this with PenCounter 
		*/

		PenCounterPDFa = 1 
		PenCounterPDFaDclick = 1 
			/*

			2017-08-29 12.10
				this should be correct to have here for use with surface pen counter 
				this way it is reset each time AutoHotkey is restarted but unique for each program it is used within 
			*/
		
		#F20:: ; Single click surface pen in newprogramname

			PenCounterPDFa ++

			If PenCounterPDFa >= 4
				{
				Sleep 10
				PenCounterPDFa = 1
				; msgbox %PenCounterPDFa% ; test to confirm everything is working correctly 
				Send ^{f1}
				Sleep 10
				}
			else If PenCounterPDFa = 2
				{
				Sleep 10
				Send ^{f2}
				; msgbox %PenCounterPDFa% ; test to confirm everything is working correctly 
				Sleep 10
				}

			else if PenCounterPDFa = 3 
				{
				Sleep 10
				Send ^{f3}
				; msgbox %PenCounterPDFa% ; test to confirm everything is working correctly 
				Sleep 10
				}

		StuckKeyUp()
		Return

		; simple version 
			; ; PenCounterPDFa ++
			; ; If PenCounterPDFa = 5
				; ; PenCounterPDFa = 1
			; ; StuckKeyUp()
			; ; ; Send {LAlt Down}%PenCounterPDFa%{LAlt Up}
			; ; ; msgbox %PenCounterPDFa% ; test to confirm everything is working correctly 
			; ; StuckKeyUp()
			; ; Return

		#F19:: ; Doble click surface pen in newprogramname

			PenCounterPDFaDClick ++
			If PenCounterPDFaDClick >= 4 
				{
				Sleep 100
				PenCounterPDFaDClick = 1
				; msgbox %PenCounterPDFaDClick% ; test to confirm everything is working correctly 
				Send s
				Sleep 100
				}
			else If PenCounterPDFaDClick = 2
				{
				Sleep 100
				Send ^{f9}
				; msgbox %PenCounterPDFaDClick% ; test to confirm everything is working correctly 
				Sleep 100
				}

			else if PenCounterPDFaDClick = 3 
				{
				Sleep 100
				Send ^{f3}
				; msgbox %PenCounterPDFaDClick% ; test to confirm everything is working correctly 
				Sleep 100
				}

		StuckKeyUp()
		Return

		#F18:: ; long press surface pen in PDF Annotator 
			sleep 300
			send ^z
			sleep 100
			return

		}
			;############End surface pen commands )


		; Strokeit Always program specific gestures 
		!+F1::			;T upside
			; go to last page with annotation 
			sleep 200
			send !gl
			sleep 700
			send !gw
			return 

		^+s::			;Down Up
			sleep 600 
			send !f
			sleep 300
			send {down 3}
			sleep 300
			send {enter}
			WinWait, Save As
			; send {home} 
			; send ^{right 3}
			; send {left}
			Return 

		^!+s::			;left right
			sleep 600 
			send !f
			sleep 300
			send {down 3}
			sleep 300
			send {enter}
			WinWait, Save As
			;sleep 500
			send {right}
			sleep 100
			send ^{left}
			sleep 100
			send {left}
			sleep 100
			send ^+{left 5}
			sleep 300
				ahkDaTi2() 
			sleep 100
			send {enter}
			Return 

		^!+f1::			;Left
			send !t
			; send available 
			return

		^!+f2::			;Right
			send ^T
			; send available 
			return

		^!+f4::			;up down up
			sleep 100
			; send available 
			return

		^!+f5::			;Up
			sleep 500 
			send {Pgup}
			sleep 300
			send {down 3}
			return

		^!+f6::			;Down
			sleep 500 
			send {Pgdn}
			sleep 300
			send {up 3}
			return

		f11::		;right down 
			send 3cd3  
			sleep 100
			send p
			return

		^!+f12::		;right up program specific
			send 3c3  
			sleep 100
			send p
			return

		+#M::			;/ Up - / DownRestore All 
			sleep 100
			; send available 
			return

		; !#h:: ; invert colors in PDF Annotator 
			; sleep 300 ; add delay to give time to send keup events (alt sometimes gets stuck otherwise)
			; send !#h
			; sleep 100
			; return 

		f5::
			sleep 100
			send {home}
			return
		^n::
			sleep 100
			send ^t
			sleep 500 
			send +{tab} 
			sleep 100 
			send 5
			return 
		^l::
			sleep 500
			send ^l
			sleep 1000
			send ^6
			sleep 2200
			send !f
			sleep 500
			send {down 2}
			sleep 500
			send {enter}
			return	

		^+#s::
			send !f
			sleep 300
			send a
			sleep 300 
			send ^{left} 
			send {left}
			Return 

		; ^F1:: ; these are taken care of elsewhere 
		; ^F2::
		; ^F3::
		; ^F4::
		; ^F5::
		; ^F6::
		; ^F7::
		; ^F8::
		; ^F9::

		^F10::
			; 170813	updated to be faster  
			; 170124 	updated to be faster  
			sleep 200
			send ^{f10}
			sleep 700 ; pause seems to be needed (probably due to MediaMonkey limitation)
			return 
			; send ^{f10 2} ; this does not work due to MediaMonkey 
			return 

		; ^F11::
		; ^F12::
				; send x 
				; return 					
		^!F1:: send ^F1
		^!F2:: send l 
		^!F3:: 
			send ^+{esc}
			sleep 500
			send ht5
			return 
		^!F11:: send {Volume_Up}{Volume_Up}{Volume_Up}
		^!F12:: send {Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}

		!+right:
			sleep 200
			send !gl
			sleep 700
			send !gw
			return 

			; { ;##############  also works  ##############
				; sleep 200
				; send !g
				; sleep 200
				; send l
				; sleep 200
				; send !g
				; sleep 200
				; send w
				; return 		
			; } 
			; ;########### END also works  ##############}

		^!+F3:: 
			sleep 500 
			send !f
			sleep 300
			send a
			sleep 300 
			send {home} 
			send ^{right}
			;send {backspace} 
			Return 

		; up down up:

		#ifwinactive
		}
		;########### End PDF Annotator 4pdfa ##############

	{ 	;##############  Python ############## 

		{ ;code used to run iPython directly from Notepad++: (2014-12-06 this is up to date)
		;reference information: http://cyrille.rossant.net/python-ide-windows/ (at end)
		::xpath4ip:: c:\Anaconda\Python\learningPython.py

		{ ;##############  Only active when working with iPython##############
		;:*:xrpy:: 
		;!#c:: ; available (2014-12-06): ^!#
		return 
		{
			IfWinExist ipython ;OR IfWinExist iPython ;including everything after "OR" causes problems 
			{
				WinActivate, ipython 
				WinWait ipython 
				;sleep 500 
				send {up} 
				;Send `%run c:\Anaconda\Python\learningPython.py` ;using this script, but keeping this version for future reference 
				Send {enter} 
				WinActivate, Notepad++ 
				return 
			}

			IfWinExist IPython ;OR IfWinExist iPython ;including everything after "OR" causes problems 
			{
				WinActivate, IPython 
				WinWait IPython 
				;sleep 500 
				send {up} 
				;Send `%run c:\Anaconda\Python\learningPython.py` ;using this script, but keeping this version for future reference 
				Send {enter} 
				WinActivate, VSCode 
				
			}

			Else 
			{
				sleep 1000
				send {LWin}
						
				; still not correct, but this will be useful for quickly testing scripts and closing itself again  
				return 
				;Run, C:\Anaconda\Scripts/ipython-script.py ; this starts anaconda version of Python
				;Run, c:\Anaconda\Scripts\ipython.exe this starts anaconda version of Python
			}	
		}
		}
			;########### END Only active when working with iPython##############


		}

		}
		;############END Python ############## 

	{	;##############  RStudio ##############
		{	;##############  RStudio specific commands  ##############
			#IfWinActive RStudio	
			:*:x::
				sleep 100 
				send {esc}
				sleep 100 
				send /
				; sleep 50 
				;SendInput {LShift up}{RShift up}{LCtrl up}{RCtrl up}{LWin up}{RWin up} ; had issues with key stuck, this does not solve it 
				return 
			
		{	;##############  not working as of 2015-08-15 16.57  ##############
		; the main issue is that it overrides iwfinactive so can't be used like this 
		; #If GetKeyState("Alt") and GetKeyState("Ctrl") and GetKeyState("CapsLock")
		; #If GetKeyState("Alt") and GetKeyState("Ctrl")
		; *f:: 
			; sleep 500 
			; send !l
		; return
		; *+f::
			; sleep 300 
			; send +!l
			; return 
		; #If 
		}
			;############End not working as of 2015-08-15 16.57  ############## 
			
		{	;##############  pipe command   ##############
			<^>!m:: ; in order for this to work I have to keep pressing altgr until it is over (no idea why)
				sleep 100 
				{
				Send {space}
				Send % Chr(0x0025) ;using unicode ("u+0025")
				Send % Chr(0x003E)
				Send % Chr(0x0025)
				Send % Chr(0x0023)
				Send % Chr(0x0023)
				send {space}{enter}
				;SendInput {LShift up}{RShift up}{LCtrl up}{RCtrl up}{LWin up}{RWin up} ; had issues with key stuck, this does not solve it 
				return 
				}
		}
			;############End pipe command   ############## 
			
		{	;##############  Inactive when programming in RStudio  ##############

		:C:Dfc::
			send Dfc
			send {left}{right}
			send {space}
			return
		:C:dfc::
			send dfc
			send {left}{right}
			send {space}
			return
		:C:E::
			send E
			send {left}{right}
			send {space}
			return
		:C:e::
			send e
			send {left}{right}
			send {space}
			return
		:C:F::
			send F
			send {left}{right}
			send {space}
			return
		:C:f::
			send f
			send {left}{right}
			send {space}
			return
		:C:I::
			send I
			send {left}{right}
			send {space}
			return 
		:C:i::
			send i
			send {left}{right}
			send {space}
			return
		:C:m::
			send m
			send {left}{right}
			send {space}
			return
		:C:M::
			send M
			send {left}{right}
			send {space}
			return
		:C:nm::
			send nm
			send {left}{right}
			send {space}
			return
		:C:Nm::
			send Nm
			send {left}{right}
			send {space}
			return
		:C:nmd::
			send nmd
			send {left}{right}
			send {space}
			return
		:C:Nmd::
			send Nmd
			send {left}{right}
			send {space}
			return
		:C:o::
			send o
			send {left}{right}
			send {space}
			return
		:C:O::
			send O
			send {left}{right}
			send {space}
			return
		:C:r::
			send r
			send {left}{right}
			send {space}
			return
		:C:R::
			send R
			send {left}{right}
			send {space}
			return
		:C:stru::
			send stru
			send {left}{right}
			send {space}
			return
		:C:Stru::
			send Stru
			send {left}{right}
			send {space}
			return
		:C:u::
			send u
			send {left}{right}
			send {space}
			return
		:C:U::
			send U
			send {left}{right}
			send {space}
			return
		:C:t::
			send t
			send {left}{right}
			send {space}
			return
		:C:T::
			send T
			send {left}{right}
			send {space}
			return
		:C:t,::
			send t,
			send {left}{right}
			send {space}
			return
		:C:T,::
			send T,
			send {left}{right}
			send {space}
			return
		:C:y::
			send y
			send {left}{right}
			send {space}
			return
		:C:Y::
			send Y
			send {left}{right}
			send {space}
			return
			}
			;###########END  Inactive when programming in RStudio  ##############
		}
			;############End RStudio specific commands  ############## 
			#ifwinactive
		}
		;########### End RStudio ##############

	{	;##############  Slack   

		; 2016-08-24 the following does not work, possibly due to Slack issues (will get back to this later, for now use reference file instead)
		:*:4slshtc::
		:*:4slshtk::
		:*:4slshtcs::
		:*:4slshtks::
			; send {SC02B down}
			send {esc}
			sleep 100 
			send ^{/}
			sleep 100 
			send {esc}
			sleep 100 
			send ^{\}
			sleep 100 
			; send {SC02B up}
			sleep 100 
			return 
		

		}
		;############End Slack   

	{	;##############  Stata  
		/*
		2017-03-29 
			created this section to fix cc9
		*/

		{	;##############  Stata active 
			#IfwinActive, Stata/SE 13.1 ; works 2017-04-18 

			; § & a:: 
				; {
				; sleep 300
				; sendraw test
				; sleep 100
				; return
				; }

			; #v:: 

			#ifwinactive 

			}
			;############End Stata active ############## 

		{	;##############  Data editor active 
			; SetTitleMatchMode, 2 
			#IfwinActive, Data Editor ; works 2017-04-18 

			§ & a:: ; combine the top two commands into one 
			:*:4sbrcx::
			:*:ccc9::
			:*:ccb9::
				{
				Click 839, 145, 1  ; Click left mouse button at specified coordinates.
				sleep 300 
				send ^v
				sleep 100 
				RETURN 
				}

			:*:4sbrx::
			:*:cc9::
				{
				Click 839, 145, 1  ; Click left mouse button at specified coordinates.
				RETURN 
				}

			#v:: 
			:*:4enfx::
			:*:4encx::
			:*:faafx::
			:*:fafx::
			:*:aaffx::
				return 

			#ifwinactive 

			}
			;############End Data editor active ############## 
		}


	{	;##############  Total Commander  
		/*

		*/ 

		{	;##############  Total Commander active 
		; possible to use winnamex or winidx to change ifwinactive to more specific id 
		#IfwinActive, Total Commander
		; § & a:: ; combine the top two commands into one 
		; ^g:: 
		; ^r:: 
		; ^h:: 
			return 


		:*:4tsal::
			{
			send ^{numpadadd} 
			sleep 100
			return
			}

		:*:4tsno::
			{
			send {esc}
			sleep 100
			send {alt down} 
			sleep 100
			send {alt up} 
			sleep 100
			send mn
			sleep 100
			return
			}

		:*:0å::
			{
			send ^q
			sleep 100 
			return
			}

		#ifwinactive 

		{	;##############  Outside Total Commander  

		}
			;############End Outside Total Commander  


		}
			;############end Total Commander active  

		}
		;############End Total Commander  

	{	;##############  VLC 

		#IfWinActive ahk_class QWidget
			;Available 
				{
				<^>!down::Send {PgDn} 
				<^>!up::Send {PgUp}
				>+down::Send {PgDn} 
				>+up::Send {PgUp}
				}
				
		{	;##############  Inactivating things when in VLC 
			:*:t1::
				return  
			:*:t2::
				return  
			:*:t3::
				return  
			:*:t4::
				return  
			:*:t5::
				return  
			:*:t6::
				return  
			:*:t7::
				return  
			:*:t8::
				return  
			:*:t9::
				return  
			:*:c0:: 
				return  
			:*:c1::
				return  
			:*:c2::
				return  
			:*:c3::
				return  
			:*:c4::
				return  
			:*:c5::
				return  
			:*:c6::
				return  
			:*:c7::
				return  
			:*:c8::
				return  
			:*:c9::
				return  
			:*:c0:: 
				return  		

		;	send D
			;send {left}{right}
			;send {space}
			;return
			
		}
			;############End Inactivating things when in VLC
									
		^tab:: ; rewind 
			sleep 300
			send {left}
			sleep 50 
			send {left}
			sleep 50 
			send {left}
			sleep 50 
			send {left}
			sleep 50 
			send {left}
			sleep 50 
			send {left}
			sleep 50 
			send {left}
			sleep 50 
			send {left}
			sleep 50 
			return 
			
		^+tab:: ; skip forward 
			sleep 300
			send {right} 
			sleep 50 
			send {right} 
			sleep 50 
			send {right} 
			sleep 50 
			send {right} 
			sleep 50 
			return 

		^n::
			sleep 100
			send ^t
			sleep 500 
			send +{tab} 
			sleep 100 
			send 5
			return 
		^l::
		; #F20::
			send ^l
			sleep 900
			send ^6
			sleep 900
			send !f
			sleep 900
			send {down 2}
			sleep 500
			send {enter}
			return	
		^+s::
			sleep 600 
			send !f
			sleep 300
			send {down 3}
			sleep 300
			send {enter}
			WinWait, Save As
			;sleep 500
			send {right}
			sleep 100
			send ^{left}
			sleep 100
			send {left}
			sleep 100
			send ^+{left 5}
			sleep 300
				ahkDaTi2()
			sleep 100
			send {enter}
			Return 
		^!+s::
			sleep 500 
			send !f
			sleep 300
			send a
			sleep 700 
			send {home} 
			send ^{right} 
			Return 
		^+#s::
			send !f
			sleep 300
			send a
			sleep 300 
			send ^{left} 
			send {left}
			Return 
		^!F1:: send ^F1
		^!F2:: 
		^!F3:: 
		^!F4:: 
		^!F5:: 
		^!F6:: 
		^!F7:: 
		^!F8:: 
		^!F9:: 
		^!F10:: 
		^!F11:: send {Volume_Up}{Volume_Up}{Volume_Up}
		^!F12:: send {Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}

		!+F2:: send ^T
		!+F1:: 
			;SetTimer, CloseContextMenu, 50
			!f
			Return

		!+F3:: 
		!+F4:: 
		!+F5:: 
		!+F6:: 
		!+F7:: 
		!+F8:: 
		!+F9:: 
		!+F10:: 
		;!+F11:: send {Volume_Up}{Volume_Up}{Volume_Up}
		;!+F12:: send {Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}

		;^!+PgUp:: send x 
		;PgDn:: send x 

		^!+F1:: 			
			send !t
			return 
		^!+F2:: 
			sleep 300
			send !easo
			sleep 300 
			send !eae
			sleep 300
			send {tab}
			;sleep 300 ; not fully tested yet (2015-02-21 19.16 it has been working sofar)
			;send {space}
			return 
			^!+F3:: 
			sleep 500 
			send !f
			sleep 300
			send a
			sleep 300 
			send {home} 
			send ^{right}
			;send {backspace} 
			Return 
		; up down up:
		^!+F4:: 
		return
		^!+F5:: 
		return
		^!+F6:: 
		return
		;^!+F7::  taken for media next 

		^!+F9:: 
			send !eaa
			sleep 300
			send +{tab}
			send 5
			return 
		^!+F10:: 
		^!+F11:: 
			send 3cd3  
			sleep 100
			send p
		^!+F12:: 
			send 3c3  
			sleep 100
			send p
		#ifwinactive
		}
	{	;##############	 VSCode
		/*
			VSCode RefInfo
				2018-04-22 12.02
					Most things moved from Notepad++ version 
			Documentation
				2018-04-22 12.02

				2018-04-16 13.49 
					yyy working here updating save system to use GitHub 
					updated save system to reload on save 
				2018-04-15 
					created this 
			*/
			#IfwinActive, ahk_exe Code.exe 
		;##############  VSCode behavior 

			~^s:: 
				reload	;Save and reload Current AutoHotkey scripts
				return
			; Changing layout in Visual Studio Code 
				; Sending ^k 
					; u & h:: ; this causes words like but to require slower typing, or it will come out as "bt" 
					3 & h:: ; this causes "3t" to require slower typing, or it will come out as "t" 
					; ö & h:: ; this causes "ö9" to require slower typing, or it will come out as "t" 
						send ^k
						return 
					$*3::send {Blind}{3} 
					$*ö::send {Blind}{ö} 
					; $*u::send {Blind}{u} ; this breakes "#) --> reload", bt only inside VSCode 

			; surface dial commands inside VSCode
				^!+f8:: ; rotate left surface dial AND 
					sleep 300
					msgbox testLeft
					sleep 100
					return

				^!+f9:: ; Rotate right surface dial AND Down up down
					sleep 300
					msgbox testRight
					sleep 100
					return

				^!+f10:: ; click surface dial
					sleep 300
					msgbox testClick
					sleep 100
					return
			
		
			§ & a:: ; [comment here "theme of this hotkey"] 
				{
				/*

				Themes
					""	
					^	
					+	reverse 
					#	
					!	
					
				Add comments here using "ncmtli" (performs ^d, li9, ncmth)
				
				*/ 

				GetKeyState, stateLCtrl, LCtrl
				GetKeyState, stateLAlt, LAlt
				GetKeyState, stateLShift, LShift
				GetKeyState, stateLWin, LWin
				GetKeyState, stateRCtrl, RCtrl
				GetKeyState, stateRAlt, RAlt
				GetKeyState, stateRShift, RShift
				GetKeyState, stateRWin, RWin
				GetKeyState, stateScrollLock, ScrollLock
				if stateLCtrl=D
					if stateLAlt=D
						if stateLShift=D
							if stateLWin=D ; ^!+#{x} 
								sendraw ^!+#{x} 
							else ; ^!+{x} 
								sendraw ^!+{x} 
						else if stateLWin=D ; ^!#{x} 
							sendraw ^!#{x} 
						else ; ^!{x}
							sendraw ^!{x}
					else if stateLShift=D
						if stateLWin=D ; ^+#{x} 
							sendraw ^+#{x} 
						else ; ^+{x}
							sendraw ^+{x}
					else if stateLWin=D ; ^#{x} 
						sendraw ^#{x} 
					else ; ^{x}
						sendraw ^{x}

				else if stateLAlt=D
						if stateLShift=D
							if stateLWin=D ; !+#{x} 
								sendraw !+#{x} 
							else ; !+{x} 
								sendraw !+{x} 
						else if stateLWin=D ; !#{x} 
							sendraw !#{x} 
						else ; !{x}
							sendraw !{x}
					else if stateLShift=D
						if stateLWin=D ; +#{x} 
							sendraw +#{x} 
						else ; +{x} 
							sendraw +{x}
					else if stateLWin=D ; #{x} 
						; There is an issue with § and # alone. 
						; 2017-06-01 might not be a problem when pressing § first 
						; 2016-06-30 have tried to fix it but given up for now, avoid it for now 
						sendraw #{x} 
					else ; {x} 
						{ 
						sendraw {x} 
						}
				StuckKeyUp() ; 2018-01-21 20.11 moved it here, not evaluated 
				return 
				}

			§ & o:: ; [comment here "theme of this hotkey"] 
				{
				/*

				Themes
					""	
					^	
					+	reverse 
					#	
					!	
					
				Add comments here using "ncmtli" (performs ^d, li9, ncmth)
				
				*/ 

				GetKeyState, stateLCtrl, LCtrl
				GetKeyState, stateLAlt, LAlt
				GetKeyState, stateLShift, LShift
				GetKeyState, stateLWin, LWin
				GetKeyState, stateRCtrl, RCtrl
				GetKeyState, stateRAlt, RAlt
				GetKeyState, stateRShift, RShift
				GetKeyState, stateRWin, RWin
				GetKeyState, stateScrollLock, ScrollLock
				if stateLCtrl=D
					if stateLAlt=D
						if stateLShift=D
							if stateLWin=D ; ^!+#{x} 
								sendraw ^!+#{x} 
							else ; ^!+{x} 
								sendraw ^!+{x} 
						else if stateLWin=D ; ^!#{x} 
							sendraw ^!#{x} 
						else ; ^!{x}
							sendraw ^!{x}
					else if stateLShift=D
						if stateLWin=D ; ^+#{x} 
							sendraw ^+#{x} 
						else ; ^+{x}
							sendraw ^+{x}
					else if stateLWin=D ; ^#{x} 
						sendraw ^#{x} 
					else ; ^{x}
						sendraw ^{x}

				else if stateLAlt=D
						if stateLShift=D
							if stateLWin=D ; !+#{x} 
								sendraw !+#{x} 
							else ; !+{x} 
								sendraw !+{x} 
						else if stateLWin=D ; !#{x} 
							sendraw !#{x} 
						else ; !{x}
							sendraw !{x}
					else if stateLShift=D
						if stateLWin=D ; +#{x} 
							sendraw +#{x} 
						else ; +{x} 
							sendraw +{x}
					else if stateLWin=D ; #{x} 
						; There is an issue with § and # alone. 
						; 2017-06-01 might not be a problem when pressing § first 
						; 2016-06-30 have tried to fix it but given up for now, avoid it for now 
						sendraw #{x} 
					else ; {x} 
						{ 
						sendraw {x} 
						}
				StuckKeyUp() ; 2018-01-21 20.11 moved it here, not evaluated 
				return 
				}

			§ & x:: ; [comment here "theme of this hotkey"]
				{
				/*
				Themes
					""	
					^	
					+	reverse 
					#	
					!	
					
				Add comments here using "ncmtli" (performs ^d, li9, ncmth)
				*/ 

				GetKeyState, stateLCtrl, LCtrl
				GetKeyState, stateLAlt, LAlt
				GetKeyState, stateLShift, LShift
				GetKeyState, stateLWin, LWin
				GetKeyState, stateRCtrl, RCtrl
				GetKeyState, stateRAlt, RAlt
				GetKeyState, stateRShift, RShift
				GetKeyState, stateRWin, RWin
				GetKeyState, stateScrollLock, ScrollLock
				if stateLCtrl=D
					if stateLAlt=D
						if stateLShift=D
							if stateLWin=D ; ^!+#{x} 
								sendraw ^!+#{x} 
							else ; ^!+{x} 
								sendraw ^!+{x} 
						else if stateLWin=D ; ^!#{x} 
							sendraw ^!#{x} 
						else ; ^!{x}
							sendraw ^!{x}
					else if stateLShift=D
						if stateLWin=D ; ^+#{x} 
							sendraw ^+#{x} 
						else ; ^+{x}
							sendraw ^+{x}
					else if stateLWin=D ; ^#{x} 
						sendraw ^#{x} 
					else ; ^{x}
						sendraw ^{x}

				else if stateLAlt=D
						if stateLShift=D
							if stateLWin=D ; !+#{x} 
								sendraw !+#{x} 
							else ; !+{x} 
								sendraw !+{x} 
						else if stateLWin=D ; !#{x} 
							sendraw !#{x} 
						else ; !{x}
							sendraw !{x}
					else if stateLShift=D
						if stateLWin=D ; +#{x} 
							sendraw +#{x} 
						else ; +{x} 
							sendraw +{x}
					else if stateLWin=D ; #{x} 
						; There is an issue with § and # alone. 
						; 2017-06-01 might not be a problem when pressing § first 
						; 2016-06-30 have tried to fix it but given up for now, avoid it for now 
						sendraw #{x} 
					else ; {x} 
						{ 
						sendraw {x} 
						}
				StuckKeyUp() ; 2018-01-21 20.11 moved it here, not evaluated 
				return 
				}

			CapsLock & a:: ; [comment here "theme of this hotkey"]
				{
				/*

				Themes
					""	
					^	
					+	reverse 
					#	
					!	
					
				Add comments here using "ncmtli" (performs ^d, li9, ncmth)
				
				*/ 

				GetKeyState, stateLCtrl, LCtrl
				GetKeyState, stateLAlt, LAlt
				GetKeyState, stateLShift, LShift
				GetKeyState, stateLWin, LWin
				GetKeyState, stateRCtrl, RCtrl
				GetKeyState, stateRAlt, RAlt
				GetKeyState, stateRShift, RShift
				GetKeyState, stateRWin, RWin
				GetKeyState, stateScrollLock, ScrollLock
				if stateLCtrl=D
					if stateLAlt=D
						if stateLShift=D
							if stateLWin=D ; ^!+#{x} 
								sendraw ^!+#{x} 
							else ; ^!+{x} 
								sendraw ^!+{x} 
						else if stateLWin=D ; ^!#{x} 
							sendraw ^!#{x} 
						else ; ^!{x}
							sendraw ^!{x}
					else if stateLShift=D
						if stateLWin=D ; ^+#{x} 
							sendraw ^+#{x} 
						else ; ^+{x}
							sendraw ^+{x}
					else if stateLWin=D ; ^#{x} 
						sendraw ^#{x} 
					else ; ^{x}
						sendraw ^{x}

				else if stateLAlt=D
						if stateLShift=D
							if stateLWin=D ; !+#{x} 
								sendraw !+#{x} 
							else ; !+{x} 
								sendraw !+{x} 
						else if stateLWin=D ; !#{x} 
							sendraw !#{x} 
						else ; !{x}
							sendraw !{x}
					else if stateLShift=D
						if stateLWin=D ; +#{x} 
							sendraw +#{x} 
						else ; +{x} 
							sendraw +{x}
					else if stateLWin=D ; #{x} 
						; There is an issue with § and # alone. 
						; 2017-06-01 might not be a problem when pressing § first 
						; 2016-06-30 have tried to fix it but given up for now, avoid it for now 
						sendraw #{x} 
					else ; {x} 
						{ 
						sendraw {x} 
						}
				StuckKeyUp() ; 2018-01-21 20.11 moved it here, not evaluated 
				return 
				}

			:*:4nclone::
			:*:4nww::
			:*:4npww::
			:*:4nsbs::
				send !v
				send e 
				send e 
				send {enter} 
				return 

			:*:4nmv::
			:*:4npmv::
			:*:4npmov::
				send !v
				send m
				send {right} 
				send {down} 
				send {enter} 
				return 

			; :*:j8:: 	
			; :*:åå1:: ; AutoHotkey supersedes Breevy here
			; 	Send, {Browser_Back} ; Switch to the adjacent tab to the left
			; 	Return

			; :*:j9::
			; :*:åå2::
			; 	Send, {Browser_Forward} ; Switch to the adjacent tab to the right
			; 	Return
			
			f23:: ; Scroll wheel left
				sleep 100 
				Send ^{PgUp}
				Return

			f24:: ; Scroll wheel right
				Send ^{PgDn}
				; Send ^{tab}
				Return

			CapsLock & v:: ; some differences in VSCode to interact with Stata
				{
				GetKeyState, stateLCtrl, LCtrl
				GetKeyState, stateLAlt, LAlt
				GetKeyState, stateLShift, LShift
				GetKeyState, stateLWin, LWin
				GetKeyState, stateRCtrl, RCtrl
				GetKeyState, stateRAlt, RAlt
				GetKeyState, stateRShift, RShift
				GetKeyState, stateRWin, RWin
				GetKeyState, stateScrollLock, ScrollLock

				if stateLCtrl=D
					if stateLAlt=D
						if stateLShift=D
							if stateLWin=D ; ^!+#{f3} 
								send ^!+#{f3} 
							else ; ^!+{f3} 
								send ^!+{f3} 
						else if stateLWin=D ; ^!#{f3} 
							send ^!#{f3} 
						else ; ^!{f3}
							send ^!{f3}
					else if stateLShift=D
						if stateLWin=D ; ^+#{f3} 
							send ^+#{f3} 
						else ; ^+{f3}
							send ^+{f3}
					else if stateLWin=D ; ^#{f3} 
						send ^#{f3} 
					else ; ^{f3}
						send ^{f3}

				else if stateLAlt=D
						if stateLShift=D
							if stateLWin=D ; !+#{f3} 
								send !+#{f3} 
							else ; !+{f3} 
								send !+{f3} 
						else if stateLWin=D ; !#{f3} 
							{
								sleep 300
								Selecline()  
								send {F9}
								return
							}
						else ; !{f3}
							send !{f3}
					else if stateLShift=D
						if stateLWin=D ; +#{f3} 
							send +#{f3} 
						else ; +{f3} 
							send +{f3}
					else if stateLWin=D ; #{f3} ; there is an issue with § and # alone (but all other combinations seem fine, possibly due to differences in how # behaviors compared to other modifiers). 
						; 2016-06-30 have tried to fix it but given up for now, avoid it for now 
							{
							sleep 500
							send {F9}
							return
							}
					else ; {f3} 
						send {f3} 
				return 
				}

			CapsLock & w::
				{
				GetKeyState, stateLCtrl, LCtrl
				GetKeyState, stateLAlt, LAlt
				GetKeyState, stateLShift, LShift
				GetKeyState, stateLWin, LWin
				GetKeyState, stateRCtrl, RCtrl
				GetKeyState, stateRAlt, RAlt
				GetKeyState, stateRShift, RShift
				GetKeyState, stateRWin, RWin
				GetKeyState, stateScrollLock, ScrollLock

				if stateLCtrl=D
					if stateLAlt=D
						if stateLShift=D
							if stateLWin=D ; ^!+#{f5} 
								send ^!+#{f5} 
							else ; ^!+{f5} 
								send ^!+{f5} 
						else if stateLWin=D ; ^!#{f5} 
							send ^!#{f5} 
						else ; ^!{f5}
							send ^!{f5}
					else if stateLShift=D
						if stateLWin=D ; ^+#{f5} 
							send ^+#{f5} 
						else ; ^+{f5}
							send ^+{f5}
					else if stateLWin=D ; ^#{f5} 
						send ^#{f5} 
					else ; ^{f5}
						send ^{f5}

				else if stateLAlt=D
						if stateLShift=D
							if stateLWin=D ; !+#{f5} 
								send !+#{f5} 
							else ; !+{f5} 
								send !+{f5} 
						else if stateLWin=D ; !#{f5} 
							{
							sleep 300
							Selecline()  
							send {F9}
							sleep 1500
							send #7
							return
							} 
						else ; !{f5}
							send !{f5}
					else if stateLShift=D
						if stateLWin=D ; +#{f5} 
							send +#{f5} 
						else ; +{f5} 
							; send +{f5}
							{
							sleep 500
							send {F9}
							}

					else if stateLWin=D ; #{f5} ; there is an issue with § and # alone (but all other combinations seem fine, possibly due to differences in how # behaviors compared to other modifiers). 
						; 2016-06-30 have tried to fix it but given up for now, avoid it for now 
						{
						sleep 500
						send {F9}
						sleep 1500
						send #7
						}
					else ; {f5} 
						{
						sleep 500
						send {F9}
						sleep 1500
						send #7
						}

				return 
				}

		;##############  R specific (inside VSCode)##############
				{	;##############  pipe command   ##############
					<^>!m:: ; in order for this to work inside RStudio I have to keep pressing altgr until it is over (no idea why)
						sleep 100 
						{
						Send % Chr(0x0025) ;using unicode ("u+0025")
						Send % Chr(0x003E)
						Send % Chr(0x0025)
						Send % Chr(0x0023)
						Send % Chr(0x0023)
						send {space}{enter}{tab}
						;SendInput {LShift up}{RShift up}{LCtrl up}{RCtrl up}{LWin up}{RWin up} ; had issues with key stuck, this does not solve it 
						return 
						}
				}
					;############End pipe command   ############## 
					

				:*:4rrx:: ; Running R code
				:*:4rxr:: 
					SelectTextBetweenParen()
					sleep 1100 
					send {f8} ; 2016-03-30 18.06 This does not work for unknown reason 
					sleep 300 
					; sleep 1500
					; send #7
					return 

				:*:4rhcx:: ; view R help file for what is in inclipboard 
				:*:4rhlpcx::
				:*:4rhlpx:: 
				:*:4rhfilx::  
				:*:4rhfilex::  
					ViewRHelpFile()
					sleep 300 
					return 

		;##############  running Stata code   ##############

			; Focus Stata main window 
			StataFocus(){
				sleep 300
				winactivate Stata/MP
				; sleep 1100 
				; send {enter}
				sleep 300 
				return
				}

			AhkRunHighlightedCodeInStataAndReturn()
				{
				sleep 300 
				CopySelected()
				StataFocus()
				sleep 300 
				send ^v
				sleep 300
				send {enter}
				sleep 300
				send #7
				return 
				}

			; Run Stata code at caret and open main results 
				§ & f9::
                :*:4srlmx:: 
                :*:4srmrx:: 
                    sleep 300
                    SelectTextBetweenParen()
                    sleep 300 
                    AhkRunHighlightedCodeInStataAndReturn()
                    sleep 11100 ; waiting x seconds since Stata code can take > 22 s 
                    MainResultsStart()
                    return 

			^#h::
				sleep 300 
				AhkRunHighlightedCodeInStataAndReturn()
				return 

			^!#h::
				sleep 300 
				send {end 3}
				send +{home 3}
				AhkRunHighlightedCodeInStataAndReturn()
				return 

			; run Stata code at caret 
				+#h::
				:*:4srlx:: 
				:*:4slix:: 
				:*:4srli9::
				:*:4sli9::
				:*:4sli9:: 
				:*:4srlix:: 
				:*:4srx::
					sleep 300
					SelectTextBetweenParen()
					sleep 300 
					AhkRunHighlightedCodeInStataAndReturn()
					return 

			; Close table2 then run Stata code at caret 
				:*:4srrx::
				:*:4sclrx::
				:*:4sctrx::
					sleep 300
					StataFocus()
					sendraw file close table2
					sleep 500
					send {enter}
					sleep 1500
					send #7
					sleep 2200
					SelectTextBetweenParen()
					sleep 100 
					AhkRunHighlightedCodeInStataAndReturn()
					return 

			:*:4srlrax:: ; run Stata line then all code 
				sleep 300 
				send {end 3}
				send +{home 3}
				AhkRunHighlightedCodeInStataAndReturn()
				sleep 2200
				SelectTextBetweenParen()
				sleep 100 
				AhkRunHighlightedCodeInStataAndReturn()
				return 

			#ifwinactive 
		}

	{	;##############  Windows 7 Windows 10 

		{	;##############  Middle-click on title bar to minimize  

		; http://www.autohotkey.com/forum/topic16364.html

		; ~MButton::
			; CoordMode, Mouse, Window
			; MouseGetPos, ClickX, ClickY, WindowUnderMouseID
			; WinActivate, ahk_id %WindowUnderMouseID%
			; WinGetClass, class, A
			; MouseGetPos, ClickX, ClickY, WindowUnderMouseID
			; WinGetPos, x, y, w, h, ahk_id %WindowUnderMouseID%

			; ; check if title bar, with an exception for Firefox with tabs in title bar that can be middle-clicked to close
			; if (ClickX < w  and ClickY < 24 and ClickY > 0 and ClickX > 0 and class != "MozillaWindowClass")
			; {
				; WinMinimize, A
			; }
			; Return

		}
			;############End Middle-click on title bar to minimize   

		; launching windows settings 
		; unable to find path 
		:*:xlsetg::
		:*:xlwinsetg::
		:*:xlwinds::
			return 


		}
		;############End Windows 7 Windows 10 

	{	;##############  Windows Photo Viewer ##############

		#ifwinactive Windows Photo Viewer 
		SC056 & h::
			sleep 500 
			send {f11}
			return 
		SC056 & t::
			sleep 500 
			send {ctrl down}
			sleep 300 
			send .
			sleep 300
			send {ctrl up}
			sleep 300 
			return 		
		#ifwinactive
		}
		;############End Windows Photo Viewer ##############

	{	;##############  Word  
		; ifwinactive Microsoft Word 2013 

		{	;##############  Word active   
		#ifwinActive ahk_class OpusApp ; updated 2017-06-19 12.14 
		; #ifwinActive - Word ; this works as it includes a dash, but not ideal 

		§ & a:: ; work with headings
			{
			/*
			"" indent heading 
			^ available 
			+ to to do reverse/undo 

			2017-06-19 13.11
				made proper version 
				added create table hotkey on ^
			*/ 
			GetKeyState, stateLCtrl, LCtrl
			GetKeyState, stateLAlt, LAlt
			GetKeyState, stateLShift, LShift
			GetKeyState, stateLWin, LWin
			GetKeyState, stateRCtrl, RCtrl
			GetKeyState, stateRAlt, RAlt
			GetKeyState, stateRShift, RShift
			GetKeyState, stateRWin, RWin
			GetKeyState, stateScrollLock, ScrollLock
			if stateLCtrl=D
				if stateLAlt=D
					if stateLShift=D
						if stateLWin=D ; ^!+#{x} 
							sendraw ^!+#{x} 
						else ; ^!+{x} 
							sendraw ^!+{x} 
					else if stateLWin=D ; ^!#{x} 
						sendraw ^!#{x} 
					else ; ^!{x}
						sendraw ^!{x}
				else if stateLShift=D
					if stateLWin=D ; ^+#{x} 
						sendraw ^+#{x} 
					else ; ^+{x}
						sendraw ^+{x}
				else if stateLWin=D ; ^#{x} 
					sendraw ^#{x} 
				else ; ^{x}
					sendraw ^x

			else if stateLAlt=D
					if stateLShift=D
						if stateLWin=D ; !+#{x} 
							sendraw !+#{x} 
						else ; !+{x} 
							sendraw !+{x} 
					else if stateLWin=D ; !#{x} 
						sendraw !#{x} 
					else ; !{x}
						sendraw !{x}
				else if stateLShift=D
					if stateLWin=D ; +#{x} 
						sendraw +#{x} 
					else ; +{x} 
						{
						sleep 300
						Click right 
						sleep 100 
						send s
						sleep 300 
						send !+{left}
						sleep 100 
						return
						}
				else if stateLWin=D ; #{x} ; there is an issue with § and # alone (but all other combinations seem fine, possibly due to differences in how # behaviors compared to other modifiers). 
					; 2016-06-30 have tried to fix it but given up for now, avoid it for now 
					sendraw #{x} 
				else ; {x} 
					{
					sleep 300
					Click right  ; Click the right mouse button.
					sleep 100 
					send s
					sleep 300 
					send !+{right}
					sleep 100 
					return
					}
			return 
			}
			
		§ & o:: ; Work with tables 
			{
			/*

			"" 	create table based on highlighted 
			^ 	make table default style 
			^+ 	both 
			#	insert row above 
			!	insert row below 
			
			2017-08-04 12.32
				created this 
			*/ 
			GetKeyState, stateLCtrl, LCtrl
			GetKeyState, stateLAlt, LAlt
			GetKeyState, stateLShift, LShift
			GetKeyState, stateLWin, LWin
			GetKeyState, stateRCtrl, RCtrl
			GetKeyState, stateRAlt, RAlt
			GetKeyState, stateRShift, RShift
			GetKeyState, stateRWin, RWin
			GetKeyState, stateScrollLock, ScrollLock

			; sleep 300 
			; Input, UserInput, L1 ; Input will wait for one (L1 means maximum length of string is 1 character) keystroke. 
			; ; to use with loop: 
				; Loop, %UserInput%
				; {
				; msgbox, Hi
				; }

			if stateLCtrl=D
				if stateLAlt=D
					if stateLShift=D
						if stateLWin=D ; ^!+#{x} 
							sendraw ^!+#{x} 
						else ; ^!+{x} 
							sendraw ^!+{x} 
					else if stateLWin=D ; ^!#{x} 
						sendraw ^!#{x} 
					else ; ^!{x}
						sendraw ^!{x}
				else if stateLShift=D
					if stateLWin=D ; ^+#{x} 
						sendraw ^+#{x} 
					else ; ^+{x}
						{
						sleep 100 
						WordCreateTableHighlighted()
						sleep 100 
						WordMakeTableDefault()
						return
						}
				else if stateLWin=D ; ^#{x} 
					sendraw ^#{x} 
				else ; ^{x}
					{
					; sendraw ^#{x} 
					sleep 100 
					WordMakeTableDefault()
					return
					}
			
			else if stateLAlt=D
					if stateLShift=D
						if stateLWin=D ; !+#{x} 
							sendraw !+#{x} 
						else ; !+{x} 
							sendraw !+{x} 
					else if stateLWin=D ; !#{x} 
						sendraw !#{x} 
					else ; !{x}
						sendraw !{x}
				else if stateLShift=D
					if stateLWin=D ; +#{x} 
						sendraw +#{x} 
					else ; +{x} 
						sendraw +{x}
				else if stateLWin=D ; #{x} ; there is an issue with § and # alone (but all other combinations seem fine, possibly due to differences in how # behaviors compared to other modifiers). 
					; 2016-06-30 have tried to fix it but given up for now, avoid it for now 
					sendraw #{x} 
				else ; {x} 
					{
					sleep 100 
					WordCreateTableHighlighted()
					return
					}
			return 
			}

		WordCreateTableHighlighted(){
			sleep 300
			send !n
			sleep 100
			send tv
			sleep 1100
			send {enter}
			sleep 100
			}

		WordMakeTableDefault(){
			sleep 300
			sleep 100
			send !j
			sleep 100
			send lfw
			sleep 100
			}

		; MakeBorderless(){
			; sleep 100 
			; send !j
			; sleep 100
			; send tbn
			; }


		:*:9onbmi8::
		:*:4bbmi8::
		:*:4bnbmi8::
		:*:4bnbkmi8::

			WordBookmarki8()
			sleep 100 
			BreevyBookmark()
			return 

		:*:9onbm8::
			WordBookmark8()
			sleep 100 
			BreevyBookmark()
			return 

		; :*:test22:: ; test to confirm below works 
			; sleep 100 
			; BreevyBookmark()
			; return 

			BreevyBookmark(){
				sleep 100
				ahkOpenBreevyNC()
				haystack := Clipboard
				ClipWait, 1
				send ^a
				sleep 100
				send !{f10} 
				sleep 1100 
				sendraw `%(abbreviation bvymdelay)`%(key ctrl+shift+f5)`%(abbreviation bvymdelay)
				send %haystack%
				sendraw `%(abbreviation gotobookmark)
				send !a 
				sendraw 9o
				send !{f10} 
				sleep 300 
				return 
				}
			return 



		; %(key shift+home)%(delay 300ms)%(key ralt+b)(key ctrl+shift+f5)%(key ralt+b)(delay 700ms)%(key ctrl+v)%(abbreviation bvymdelay)%(key ralt+b)(abbreviation gotobookmark)%(key lalt+a)9o

		; create new commands in AutoHotkey for Word bookmarks 
		:*:9ob8:: ; makes a bookmark of previous word 
			sleep 100
			WordBookmark8()
			sleep 100 
			return 

		WordBookmark8(){
				sleep 300
				send ^+{left}
				CopyAndBookmark()
				return 
				}

		:*:9obi8:: ; makes a CamelCase independent bookmark that does not require that the thing bookmarked is CamelCase (based on entire line)
			sleep 100 
			WordBookmarki8(){
				sleep 300
				send +{home}
				CopyAndBookmark()
				sleep 300
				return 
				}
			return 

		CopyAndBookmark()
				{
				sleep 300
				send ^c
				sleep 300
				send ^+{f5}
				sleep 700
				xahkmolnpcb()
				sleep 700
				send !a
				return 
				}

		^#h:: ; make link from clipboard 
			sleep 300
			send ^k
			sleep 300
			send ^v
			send {enter}
			return 

		; :*:9og::
			; send ^{z}
			; send ^{z}
			; send ^!+p
			; return 
		; %(key ctrl+z 2)%(key lctrl+lshift+lalt+p)


		#ifwinActive 

		}
			;############End Word active   

		}
			;############End Word  

;##############  Media, music 
    {	;##############  Using mouse to control music ##############
            ;most are in Breevy via AutoHotkey (e.g. music abbreviations are like that)
            
            ;$RButton::Send {RButton} ; 2014-12-10 - this is not tested, but could be a solution for issue with rbutton commands I have had working here 
            ; Below is working and without this right click is inactive (I think issue with RButton alone due to missing command)

            ~F17 & WheelUp::
                    ; 2016-02-13 added Strokeit to wrkpc, now requires moving mouse with right click pressed (in order to inactivate Strokeit) before using this 
                Send {Volume_Up}
                return

            ~F17 & WheelDown::
                    ; 2016-02-13 added Strokeit to wrkpc, now requires moving mouse with right click pressed (in order to inactivate Strokeit) before using this 
                Send {Volume_Down}
                return

            ; ~F21 & WheelUp::
                    ; ; 2016-02-13 added Strokeit to wrkpc, now requires moving mouse with right click pressed (in order to inactivate Strokeit) before using this 
                ; Send {Volume_Up}
                ; SetTimer, CloseContextMenu, 50
                ; return

            ~RButton & WheelUp::
                    ; 2016-02-13 added Strokeit to wrkpc, now requires moving mouse with right click pressed (in order to inactivate Strokeit) before using this 
                Send {Volume_Up}
                SetTimer, CloseContextMenu, 50
                return
            ~RButton  & WheelDown::
                    send {Volume_Down}
                    SetTimer, CloseContextMenu, 50
                    return
            ~!WheelUp:: ; available 
                Send {Volume_Up}
                SetTimer, CloseContextMenu, 50
                return
            ~!WheelDown:: ; available 
                    send {Volume_Down}
                    SetTimer, CloseContextMenu, 50
                    return
            
            CloseContextMenu: ;; function which closes the context menue 
                    ; 2016-02-10 works almost always 
                    KeyWait, RButton, R
                    Send, {ALT Down}
                    Sleep, 30
                    Send, {ALT Up}
                    Send {RCtrl DOWN}{Alt DOWN}{Alt UP}{RCtrl UP}
                    SetTimer, CloseContextMenu, off
                    return
            
            ; LButton & WheelUp; bad due to normal user conflict 
            ; LButton & WheelDown; bad due to normal user conflict 
            ; MButton & LButton::Send taken by media next 
            ; RButton::
                ; if (A_TimeSincePriorHotkey > 600)
                    ; Return ; No double click, so stop!
                ; Sleep, 100
                ; Send, {Esc}
                ; Sleep, 100
                ; Click, Middle
                ; return


        :*:aau8::{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}
        :*:oou8::{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}
        :*:aou8::{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}{Volume_Up}
        :*:aau9::{Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}
        :*:oou9::{Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}
        :*:aou9::{Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}{Volume_Down}

                
        }
        ;########### END Using mouse to control music ##############
        
        { ;VOLUME CONTROL (Ctrl and PgUp/Down - plus Windows key to mute/unmute)
        CapsLock & 0::Send {Volume_Up} ;TO BE UPDATED with new keystate checking system! 
        CapsLock & +::Send {Volume_Down}
        Rshift & 0::Send {Volume_Up}
        Rshift & +::Send {Volume_Down}
        Rshift & v::Send !{f4}
        Rshift & z::Send ^{w}
        ; Rshift & s::Send ^{s}
        ; Rshift & '::Send {f5}

        }

        { ;Media movement 
        ; MButton & LButton::
        !å::
        :*:öö7åå2::
            sleep 300
            Send {Media_Next}
            return 

        :*:öö7åå1::
            sleep 300
            Send {Media_Prev}
            return 
        ; Rshift & ,::
        ; CapsLock & ,::
        <^>!w::
            Send {Media_Play_Pause}
            return 

        SC056 & o::
            {
            GetKeyState, stateLCtrl, LCtrl
            GetKeyState, stateLShift, LShift
            GetKeyState, stateLWin, LWin
            GetKeyState, stateLAlt, LAlt
            GetKeyState, stateRCtrl, RCtrl
            GetKeyState, stateRShift, RShift
            GetKeyState, stateRWin, RWin
            GetKeyState, stateRAlt, RAlt
            GetKeyState, stateSC056, SC056
            GetKeyState("SC056") 
            GetKeyState, stateCaps, CapsLock
            GetKeyState, stateScrollLock, ScrollLock

            if stateLCtrl=D
                if stateLShift=D
                    if stateLWin=D
                        if stateLAlt=D
                            send ^!+#{PgDn} ; Ctrl + SHIFT + alt + Win +PgDn
                        else
                            Send ^+#{PgDn} ; Ctrl + SHIFT + Win +PgDn
                    else if stateLAlt=D
                        send ^!+{PgDn} ; Ctrl + SHIFT + alt +PgDn
                    else
                        Send ^+{PgDn}	; Ctrl + SHIFT +PgDn
                else if stateLWin=D
                        if stateLAlt=D
                            send ^+#{PgDn} ; Ctrl + shift + Win +PgDn
                        else
                            Send ^#{PgDn}	; Ctrl + win +PgDn
                else if stateLAlt=D
                    if stateLWin=D
                        send ^!#{PgDn} ; Ctrl + alt + win +PgDn
                    else
                        send ^!{PgDn} ; Ctrl + alt +PgDn
                else if stateLWin=D
                        send ^#{PgDn} ; Ctrl + win +PgDn
                else
                    Send ^{PgDn}	; CtrlPgDn
            else if stateLShift=D
                    if stateLWin=D
                        if stateLAlt=D
                            send !+#{PgDn} ; SHIFT + alt + Win +PgDn
                        else
                            Send +#{PgDn} ; SHIFT + Win +PgDn
                    else if stateLAlt=D
                        send !+{PgDn} ; SHIFT + alt +PgDn
                    else
                        Send {Media_Play_Pause} 
            else if stateLWin=D
                    if stateLAlt=D
                            send !#{PgDn} ; alt + Win +PgDn
                    else
                        Send ^+#o ; Ctrl + shift + Win
            else if stateLAlt=D
                Send {Media_Play_Pause}
            else
                Send {Media_Prev} 
            return
            }

        SC056 & e::
            {
            GetKeyState, stateLCtrl, LCtrl
            GetKeyState, stateLShift, LShift
            GetKeyState, stateLWin, LWin
            GetKeyState, stateLAlt, LAlt
            GetKeyState, stateRCtrl, RCtrl
            GetKeyState, stateRShift, RShift
            GetKeyState, stateRWin, RWin
            GetKeyState, stateRAlt, RAlt
            GetKeyState, stateSC056, SC056
            GetKeyState("SC056") 
            GetKeyState, stateCaps, CapsLock
            GetKeyState, stateScrollLock, ScrollLock

            if stateLCtrl=D
                if stateLShift=D
                    if stateLWin=D
                        if stateLAlt=D
                            send ^!+#{PgDn} ; Ctrl + SHIFT + alt + Win +PgDn
                        else
                            Send ^+#{PgDn} ; Ctrl + SHIFT + Win +PgDn
                    else if stateLAlt=D
                        send ^!+{PgDn} ; Ctrl + SHIFT + alt +PgDn
                    else
                        Send ^+{PgDn}	; Ctrl + SHIFT +PgDn
                else if stateLWin=D
                        if stateLAlt=D
                            send ^+#{PgDn} ; Ctrl + shift + Win +PgDn
                        else
                            Send ^#{PgDn}	; Ctrl + win +PgDn
                else if stateLAlt=D
                    if stateLWin=D
                        send ^!#{PgDn} ; Ctrl + alt + win +PgDn
                    else
                        send ^!{PgDn} ; Ctrl + alt +PgDn
                else if stateLWin=D
                        send ^#{PgDn} ; Ctrl + win +PgDn
                else
                    Send ^{PgDn}	; CtrlPgDn
            else if stateLShift=D
                    if stateLWin=D
                        if stateLAlt=D
                            send !+#{PgDn} ; SHIFT + alt + Win +PgDn
                        else
                            Send +#{PgDn} ; SHIFT + Win +PgDn
                    else if stateLAlt=D
                        send !+{PgDn} ; SHIFT + alt +PgDn
                    else
                        Send +{PgDn} ; SHIFT +PgDn
            else if stateLWin=D
                    if stateLAlt=D
                            send !#{PgDn} ; alt + Win +PgDn
                    else
                        Send ^+#e ; Ctrl + shift + Win +e
            else if stateLAlt=D
                Sendraw "available"
            else
                Send {Media_Next} 
            return
            }
            
        } 

        Return
  
;##############  Microsoft Surface Pro  
	{	;##############  Surface refinfo  ##############
		;From (http://icosidodecahedron.com/?p=5908)
		;From http://icosidodecahedron.com/?p=5897 
		
		;Surface Pro has a one-piece volume rocker flimsy enough that you can press both buttons at once, a power button, a capacitive Start button, and a capacitive touch-screen. 		
		;Microsoft got around some limitations by including their own hotkeys and implementing some good touch events.
		;Keys and associated scan codes in AutoHotKey:
			; remap surface pen button to launch any program
			;surface pen button: #F20
			;Volume Up: SC130
			;Volume Down: SC12E
			;Tap and hold: RButton
			; Pen Button Once: #F20
			; Pen Button Twice: #F19
			; Windows Button and Volume Up: ^#F14
			; Windows Button and Volume Down: #F15
			;Start Button: LWin
			;Tap the screen: LButton
			;Pinch: Ctrl + WheelDown
			;Spread: Ctrl + WheelUp
			;Start + Volume Up: LControl + LWin + F14 (Assistive Tech)
			;Start + Volume Down: LWin + F15 (Save screenshot)
			;Start + Power Button: LAlt + LControl + Delete
		;possible combinations:
			;#F20 
			;SC130 (Volume Up)
			;C12E (Volume Down)===
			;LWin (Start button)
			;SC130 & LWin (Volume Up and Start)
			;SC12E & LWin (Volume Down and Start)
			;*F14 (Start and Volume Up)
	
			;LWin & F15 (Start and Volume Down)
			;LButton (Tap)
			;RButton (Tap and hold)
			;LButton & LWin (Tap and Start)
			;RButton & LWin (Tap-and-hold and Start)
			;SC130 & LButton
			;SC130 & RButton
			;SC12E & LButton
			;SC12E & RButton
			;LButton & SC130
			;RButton & SC130
			;LButton & SC12E
			;RButton & SC12E
			;^WheelDown (Pinch together)
			;^WheelUp (Pinch apart)
			;!^Delete (Start and Power)
			;24 possibilities. 15 Good abbreviations.
			;(You don't want to put LButton or RButton first, or your taps won't do anything. Also, the Ctrl+Alt+Del combo sends that even when you change it, so you'll always be confronted ;with the annoying option screen.)
			;
			;Note that the Start button cannot be held down. It only activates when you release it, ignores touches it thinks you made by mistake, and only activates once every half-second with ;repeated taps.
			;
			;Obviously, using LButton & Something else means your clicks are going to be intercepted and you won't be able to click on anything. Likewise with RButton, but in something like ;Chrome that's already disabled.		
	;scripts to test (and then move to script I am using below) with Microsoft Surface Pro:
		;Various
			; By pressing Alt and the volume key, it acts normally (note you need the ˜virtual key' code as well as the scan codes)
				;!SC12E:: SendEvent {VKAESC12E}
				;!SC130:: SendEvent {VKAFSC130} ; Just making sure that I can swipe open the charm bar anytime I want to change the volume
				; #IfWinActive Charm Bar - this makes CapsLock useless! no idea why.... PROBLEM!
				;SC130::SendEvent {VKAFSC130}			
						;!SC12E:: SendEvent {VKAESC12E}
				;!SC130:: SendEvent {VKAFSC130}
				;SC130:: SendEvent ^{Tab}
				;SC12E:: SendEvent ^+{Tab}
				;SC130 & LButton:: MouseMove, 4, 4, 1, R
				;SC12E & LButton:: SendEvent {RButton}
				;SC130 & RButton:: SendEvent {MButton}
				;SC12E & RButton:: SendEvent ^{0}
				;LWin:: SendEvent {F11}
				;LWin & Space::SendEvent {LWin}
				;RButton & SC12E:: SendEvent !{Left}
				;RButton & SC130:: SendEvent !{Right}
				;RButton & LWin:: SendEvent {RButton}
				;^a:: 
					;sleep 300 
					;send {tab 2} 
					;send {right} 
					;return 
				;from various, not that good sources:
			;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			;#Escape::SendMessage 0x112, 0xF170, 2, , Program Manager
			;; ============= EVERY OTHER PROGRAM SECTION =====================
			;#IfWinActive
			;$LWin::
				;Critical, on
				;;SoundBeep, 300, 100
				;if ( interdictWin == 1 ) {
					;interdictWin := 3
					;Input, , T0.0
					;; Kill input capture, make note {LWin Down} exists
				;}
				;else interdictWin := 2
					;; Make note {#)LWin Down} exists
					
				;Send {Blind}{LWin down}
				;Critical, off
				;Sleep -1
			;return

			;$LWin up::
				;;SoundBeep, 400,100
			;				
				;if ( interdictWin == 1 ) {
					;Input, , T0.0
					;return
					;; If Interdiction active, terminate Input grabber
					;; ( There is no {LWin Down} to need a {LWin Up} )
				;}
				;Send {Blind}{LWin up}
				;interdictWin:=
			;				
			;return
			;}
		
		;Windows 8 reference information:			
		;some new Windows 8 combos. Pressing 
		;Win+D returns you to the desktop. 
		;Win+T takes you to the taskbar, and 
		;Win+B takes you to the notification area. 
		;Win+X opens a menu with a bunch of options for administering your computer, 
		;Win+C is the charms, while Win+I goes right to the Settings charm. 
		;Win+Q searches apps, Win+W searches settings, and 
		;Win+F searches files. Win+E opens a new Explorer window, and 
		;Win+O toggles orientation lock. Nice.
		}
		;############End Surface refinfo  ############## 
			SC12E::SendEvent {VKAESC12E}
			;SetTitleMatchMode 2
			;#InstallKeybdHook 

;##############  keyboard modifiers 
	/*
	Reminders 
		should not use altgr - causes several problems
		should not combine main keyboard modifiers
			better to keep them separate as it would make it impossible to have them in separate sections otherwise (i.e. capslock & g would block SC056 & g from executing)

	2017-12-02 09.47
		created for ööhotstrings 
	2017-10-12 13.36
		created altgr, under evaluation 
	2016-05-05 10.19
		confirmed that template01 should not be changed for now (still not complete but good enough)
	*/

	{	;###########Template01 for making use of multiple modifiers
	/*

	2017-07-04 10.44
		added StuckKeyUp here 
	2017-02-20 
		changed it to be sendraw in order to prevent !x to close windows 
	2017-02-19 
		"below is the most up to date (have not implement "right control key" ^!+#). 
		Changed order to be ^!+# (I think this is the praxis most use) 
		Organize by keyboard shortcut 

	2016-05-12 11.27 
		updated due to previous version having # misplaced 
	2016-05-05 09.33 

	*/ 

	; primary multiple modifier template below 
	; last updated 2017-04-11 
	; copy using oä59 starting directly below here 	
		
	; CapsLock & x:: ;	Theme of Hotkey 
	; CapsLock & F13::; Theme of Hotkey 
	;F11:: ; Does not work 
	;F13:: ; Does not work 
	; SC056 & x::
	; § & x::
	::replaceThisWithOneOfTheAbove::
		{
		/*

		Themes
			""	
			^	
			+	reverse 
			#	
			!	
			
		Add comments here using "ncmtli" (performs ^d, li9, ncmth)
		
		*/ 


		GetKeyState, stateLCtrl, LCtrl
		GetKeyState, stateLAlt, LAlt
		GetKeyState, stateLShift, LShift
		GetKeyState, stateLWin, LWin
		GetKeyState, stateRCtrl, RCtrl
		GetKeyState, stateRAlt, RAlt
		GetKeyState, stateRShift, RShift
		GetKeyState, stateRWin, RWin
		GetKeyState, stateScrollLock, ScrollLock
		if stateLCtrl=D
			if stateLAlt=D
				if stateLShift=D
					if stateLWin=D ; ^!+#{x} 
						sendraw ^!+#{x} 
					else ; ^!+{x} 
						sendraw ^!+{x} 
				else if stateLWin=D ; ^!#{x} 
					sendraw ^!#{x} 
				else ; ^!{x}
					sendraw ^!{x}
			else if stateLShift=D
				if stateLWin=D ; ^+#{x} 
					sendraw ^+#{x} 
				else ; ^+{x}
					sendraw ^+{x}
			else if stateLWin=D ; ^#{x} 
				sendraw ^#{x} 
			else ; ^{x}
				sendraw ^{x}


		else if stateLAlt=D
				if stateLShift=D 
					if stateLWin=D ; !+#{x} 
						sendraw !+#{x} 
					else ; !+{x} 
						sendraw !+{x} 
				else if stateLWin=D ; !#{x} 
					sendraw !#{x} 
				else ; !{x}
					sendraw !{x}
			else if stateLShift=D
				if stateLWin=D ; +#{x} 
					sendraw +#{x} 
				else ; +{x} 
					sendraw +{x}
			else if stateLWin=D ; #{x} 
				; There is an issue with § and # alone. 
				; 2017-06-01 might not be a problem when pressing § first 
				; 2016-06-30 have tried to fix it but given up for now, avoid it for now 
				sendraw #{x} 
			else ; {x} 
				{ 
				sendraw {x} 
				}
		StuckKeyUp() ; 2018-01-21 20.11 moved it here, not evaluated 
		return 
		}

	; copy ending directly above here 	


	}
		;#######End Template01 for making use of multiple modifiers  

	{	;###########old Template01 for making use of multiple modifiers
	; archive template below is from before 2016-01-16 12.08

	; CapsLock & xxx::
	; ::tiisoldtempl::
	; {
	; GetKeyState, stateLCtrl, LCtrl
	; GetKeyState, stateLShift, LShift
	; GetKeyState, stateLWin, LWin
	; GetKeyState, stateLAlt, LAlt
	; GetKeyState, stateRCtrl, RCtrl
	; GetKeyState, stateRShift, RShift
	; GetKeyState, stateRWin, RWin
	; GetKeyState, stateRAlt, RAlt
	; GetKeyState, stateSC056, SC056 ; 160505 this should never be combined 
	; GetKeyState("SC056") ; 160505 this should never be combined 
	; GetKeyState, stateCaps, CapsLock ; 160505 this should never be combined 
	; GetKeyState, stateScrollLock, ScrollLock
	; if stateLCtrl=D
		; if stateLShift=D
			; if stateLWin=D
				; if stateLAlt=D
					; send ^!+#{x} 
				; else
					; send ^+#{x} 
			; else if stateLAlt=D
				; send ^+!{x} 
			; else
				; send ^+{x}
		; else if stateLWin=D
			; if stateLAlt=D
				; send ^!#{x} 
			; else
				; send ^#{x}
		; else if stateLAlt=D
				; send ^!{x}
		; else
			; send ^{x}
	; else if stateLShift=D
			; if stateLWin=D
				; if stateLAlt=D
					; send +#!{x} 
				; else
					; send +#{x} 
			; else if stateLAlt=D
				; send +!{x} 
			; else
				; send +{x}
		; else if stateLWin=D
			; if stateLAlt=D
				; send !#{x} 
			; else
				; send #{x}
		; else if stateLAlt=D
			; send !{x}
		; else
			; send {x}
	; return 
	; }  

	}
		;#######End Old Template01 for making use of multiple modifiers  

	{	;##############  CapsLock commands ##############
	; All capslock commands should be here except when organized in categories (e.g. music)

	{	;##############  Example of making use of multiple modifiers  
		;#If GetKeyState("Shift") and GetKeyState("Ctrl") and GetKeyState("CapsLock")
		;*a:: 
			;Keywait % A_ThisHotkey
			;if (A_PriorHotkey = A_ThisHotkey and A_TimeSincePriorHotkey < 500)
				;msgbox, short
			;else
				;return ; too long
			;return 
	}
		;############End Example of making use of multiple modifiers  

	; CapsLock & .:: ;taken for controlling music 

	Capslock & SC011::send ^w
	Capslock & 1:: ; Cut and paste 
		{
			/*
			Copy and paste (§ & w) is template for 
				cut and paste (capslock & 1)
			When updating either, make sure both are updated 
			
			2017-09-25 11.16
				copied and pasted this as template for cut and paste using capslock & 1 
			2017-06-17 08.49
				merged § 1 and § w 
			2017-05-19 11.25
				added xahkrmvmepc()
			2017-05-18 11.06
				updated everything 
			*/
			
		GetKeyState, stateLCtrl, LCtrl
		GetKeyState, stateLAlt, LAlt
		GetKeyState, stateLShift, LShift
		GetKeyState, stateLWin, LWin
		GetKeyState, stateRCtrl, RCtrl
		GetKeyState, stateRAlt, RAlt
		GetKeyState, stateRShift, RShift
		GetKeyState, stateRWin, RWin
		GetKeyState, stateScrollLock, ScrollLock

		if stateLCtrl=D ; Includes enter after pasting 
			if stateLAlt=D
				if stateLShift=D
					if stateLWin=D
						; sendraw ^!+#{x} 
						sendraw ^!+#{x} 
					else
						; sendraw ^!+{x} 
						sendraw ^!+{x} 
				else if stateLWin=D
					; sendraw ^!#{x} 
					{
					CutSelected() 
					AltTabph()
					sleep 100 
					send {down}
					}
				else
					; sendraw ^!{x}
					{
					CutSelectedAltTabPasteAltTab()
					}
			else if stateLShift=D
				if stateLWin=D
					; sendraw ^+#{x} 
					{
					CutSelected() 
					AltTabf()
					xahkmosclpcb()
					send {enter}
					sleep 50 
					AltTabf()
					}

				else
					; sendraw ^+{x}
					{
					CutSelected() 
					AltTabph() 
					sleep 100 
					send {enter}
					sleep 50 
					AltTabf()
					}

			else if stateLWin=D
				; sendraw ^#{x} 
				{
				CutSelected() 
				AltTabf()
				xahkmosclpcb()
				send {enter}
				}
			else
				; sendraw ^{x}
				{
				CutSelected() 
				AltTabph() 
				sleep 100 
				send {enter}
				sleep 50 
				; AltTabf()
				}

		else if stateLAlt=D 
				if stateLShift=D
					if stateLWin=D 
						; sendraw !+#{x} 
						sendraw !+#{x} 
					else
						; sendraw !+{x} 
						{
						CutSelected() 
						sleep 50 
						AltTabf()
						xahkrmvmoepc()
						AltTabf()
						}
				else if stateLWin=D
					; sendraw !#{x} 
					Open4nppNewp() ; there is an issue with § and # (also together with ! , possibly due to differences in how # behaviors compared to other modifiers)
				else
					; sendraw !{x}
					{
					CutSelected() 
					sleep 50 
					AltTabf()
					xahkrmvmoepc()
					}

			else if stateLShift=D
				if stateLWin=D
					; sendraw +#{x} 
					{
					CutSelected() 
					AltTabf()
					xahkmosclpcb()
					AltTabf()
					}

				else
					; sendraw +{x} 
					{
					CutSelected() 
					AltTabph() 
					AltTabf()
					}
			else if stateLWin=D
				; sendraw #{x} ; there is an issue with § and # (also together with ! , possibly due to differences in how # behaviors compared to other modifiers)
					{
					CutSelected() 
					AltTabf()
					xahkmosclpcb()
					}
			else
				{
				CutSelected() 
				AltTabph()
				}
		StuckKeyUp()
		return 

		}

	Capslock & 2::
	Capslock & 3::
	Capslock & 4::
	Capslock & 5::
	return 
	; Capslock & 6:: ; Scroll Left 
	; Capslock & 7:: ; Scroll Right 

	CapsLock & 8:: ; scroll Up
		{
		GetKeyState, stateLCtrl, 	LCtrl
		GetKeyState, stateLShift, 	LShift
		GetKeyState, stateLWin, 	LWin
		GetKeyState, stateLAlt, 	LAlt
		GetKeyState, stateRCtrl, 	RCtrl
		GetKeyState, stateRShift, 	RShift
		GetKeyState, stateRWin, 	RWin
		GetKeyState, stateRAlt, 	RAlt
		GetKeyState, stateScroll, 	ScrollLock
		if stateLCtrl=D
			if stateLShift=D
				if stateLWin=D
					if stateLAlt=D ; ^!+#{up} 
						MouseClick,WheelUp,,,50,0,D,R return ; Biggest 
					else ; ^+#{up} 
						Send x 
				else if stateLAlt=D ; ^!+{up} 
					{
					send ^f
					sleep 700 
					send föregåe
					sleep 700
					send {enter}
					sleep 700
					send {esc}
					sleep 300
					send {enter} 
					}
				else ; ^+{up} 
					{
					send ^f
					sleep 700 
					send previou
					sleep 700
					send {enter}
					sleep 700
					send {esc}
					sleep 300
					send {enter} 
					}
			else if stateLWin=D
					if stateLAlt=D
						send y ; ^+#{up} ;
					else
						Send z ; ^#{up}	;
			else if stateLAlt=D
				if stateLWin=D
					send ^!#{up} ;
				else ; ^!x
					{
					send ^f
					sleep 700 
					send föregåe
					sleep 700
					send {enter}
					sleep 700
					send {esc}
					sleep 300
					send {enter} 
					}
			else if stateLWin=D ; ^#{x} 
				MouseClick,WheelUp,,,2,0,D,R ; 
			else ; ^{up} 
				MouseClick,WheelUp,,,3,0,D,R ;

		else if stateLShift=D 
				if stateLWin=D
					if stateLAlt=D 
						MouseClick,WheelUp,,,1,0,D,R ;
					else
						MouseClick,WheelUp,,,2,0,D,R ;
				else if stateLAlt=D
					{
					send ^f
					sleep 700 
					send previous
					sleep 700
					send {esc}
					sleep 300
					send {tab}
					sleep 300
					send {enter} 
					}
				else ; +{x} 
					{
					send {left 5}
					}
		else if stateLWin=D
				if stateLAlt=D
						send x ; MouseClick,WheelUp,,,100,0,D,R ;
				else
					send x ; MouseClick,WheelUp,,,50,0,D,R ;
		else if stateLAlt=D
					{
					send ^f
					sleep 700 
					send föregåe
					sleep 700
					send {esc}
					sleep 300
					send {enter} 
					}
		else
			MouseClick,WheelUp,,,5,0,D,R ;
		return
		}

	CapsLock & 9::  ; Scroll Down 
		{
		GetKeyState, stateLCtrl, 	LCtrl
		GetKeyState, stateLShift, 	LShift
		GetKeyState, stateLWin, 	LWin
		GetKeyState, stateLAlt, 	LAlt
		GetKeyState, stateRCtrl, 	RCtrl
		GetKeyState, stateRShift, 	RShift
		GetKeyState, stateRWin, 	RWin
		GetKeyState, stateRAlt, 	RAlt
		GetKeyState, stateScroll, 	ScrollLock
		if stateLCtrl=D
			if stateLShift=D
				if stateLWin=D
					if stateLAlt=D
						Send x ; MouseClick,WheelUp,,,50,0,D,R return ; Biggest 
					else
						Send x ; ^+#{up} ; 
				else if stateLAlt=D
					{
					send ^f
					sleep 700 
					send nästa
					sleep 700
					send {enter}
					sleep 700
					send {esc}
					sleep 300
					send {enter} 
					}
				else
					{
					send ^f
					sleep 700 
					send next
					sleep 700
					send {enter}
					sleep 700
					send {esc}
					sleep 300
					send {enter} 
					}
			else if stateLWin=D
					if stateLAlt=D
						send y ; ^+#{up} ;
					else
						Send z ; ^#{up}	;
			else if stateLAlt=D
				if stateLWin=D
					send ^!#{up} ;
				else ; ^!
					{
					send ^f
					sleep 700 
					send nästa
					sleep 700
					send {enter}
					sleep 700
					send {esc}
					sleep 300
					send {enter} 
					}
			else if stateLWin=D
				Send x ; MouseClick,WheelUp,,,2,0,D,R ; 
			else ; ^
				MouseClick,WheelDown,,,2,0,D,R ; using for zoom
		else if stateLShift=D 
				if stateLWin=D
					if stateLAlt=D 
						Send x ;MouseClick,WheelUp,,,1,0,D,R ;
					else
						Send x ;MouseClick,WheelUp,,,2,0,D,R ;
				else if stateLAlt=D
					{
					send ^f
					sleep 700 
					send next
					sleep 700
					send {esc}
					sleep 300
					send {tab}
					sleep 300
					send {enter} 
					}
				else ; +{x} 
					{
					send {right 5}
					}
		else if stateLWin=D
				if stateLAlt=D
						send x ; MouseClick,WheelUp,,,100,0,D,R ;
				else
					send x ; MouseClick,WheelUp,,,50,0,D,R ;
		else if stateLAlt=D
					{
					send ^f
					sleep 700 
					send nästa
					sleep 700
					send {esc}
					sleep 300
					send {enter} 
					}
		else
			MouseClick,WheelDown,,,5,0,D,R ;
		return
		}	

	; CapsLock & a:: ; Program specific

	CapsLock & b:: ; del
		{	
		GetKeyState, stateLCtrl, LCtrl
		GetKeyState, stateLShift, LShift
		GetKeyState, stateLWin, LWin
		GetKeyState, stateLAlt, LAlt
		GetKeyState, stateRCtrl, RCtrl
		GetKeyState, stateRShift, RShift
		GetKeyState, stateRWin, RWin
		GetKeyState, stateRAlt, RAlt
		if stateLCtrl=D
			if stateLShift=D
				if stateLWin=D
					if stateLAlt=D
						send ^!+#{del} 
					else
						send ^+#{del} 
				else if stateLAlt=D
					send ^+!{del} 
				else
					send ^+{del}
			else if stateLWin=D
				if stateLAlt=D
					send ^!#{del} ;^!#{del} behaviors incorrectly 
				else
					send ^#{del}
			else if stateLAlt=D
					send x ; ^!{del} does work, but is not needed nor wanted 
			else
				send ^{del}
		else if stateLShift=D
				if stateLWin=D
					if stateLAlt=D
						send +#!{del} 
					else
						send +#{del} 
				else if stateLAlt=D
					send +!{del} 
				else
					send +{del}
			else if stateLWin=D
				if stateLAlt=D
					send !#{del} ;!#{del} behaviors incorrectly 
				else
					send #{del}
			else if stateLAlt=D
				send !{del}
			else
				send {del}
		return 
		}  

	CapsLock & c::
		{
		GetKeyState, stateLCtrl, LCtrl
		GetKeyState, stateLShift, LShift
		GetKeyState, stateLWin, LWin
		GetKeyState, stateLAlt, LAlt
		GetKeyState, stateRCtrl, RCtrl
		GetKeyState, stateRShift, RShift
		GetKeyState, stateRWin, RWin
		GetKeyState, stateRAlt, RAlt
		GetKeyState, stateSC056, SC056
		GetKeyState("SC056") 
		GetKeyState, stateCaps, CapsLock
		GetKeyState, stateScrollLock, ScrollLock
		if stateLCtrl=D
			if stateLShift=D
				if stateLWin=D
					if stateLAlt=D
						send ^!+#{up} 
					else
						send ^+#{up} 
				else if stateLAlt=D
					send ^+!{up} 
				else
					send ^+{up}
			else if stateLWin=D
				if stateLAlt=D
					send ^!#{up} 
				else
					send ^#{up}
			else if stateLAlt=D
					send ^!{up}
			else
				send ^{up}
		else if stateLShift=D
				if stateLWin=D
					if stateLAlt=D
						send +#!{up} 
					else
						send +#{up} 
				else if stateLAlt=D
					send +!{up} 
				else
					send +{up}
			else if stateLWin=D
				if stateLAlt=D
					send !#{up} 
				else
					send #{up}
			else if stateLAlt=D
				send !{up}
			else
				send {up}
		return 
		} 

	CapsLock & d:: ; Backspace 
		{	
		GetKeyState, stateLCtrl, LCtrl
		GetKeyState, stateLShift, LShift
		GetKeyState, stateLWin, LWin
		GetKeyState, stateLAlt, LAlt
		GetKeyState, stateRCtrl, RCtrl
		GetKeyState, stateRShift, RShift
		GetKeyState, stateRWin, RWin
		GetKeyState, stateRAlt, RAlt
		if stateLCtrl=D
			if stateLShift=D
				if stateLWin=D
					if stateLAlt=D
						send ^!+#{backspace} 
					else
						send ^+#{backspace} 
				else if stateLAlt=D
					send ^+!{backspace} 
				else
					send ^+{backspace}
			else if stateLWin=D
					if stateLAlt=D
						send ^+#{backspace} 
					else
						send ^#{backspace} 
			else if stateLAlt=D
					if stateLWin=D
					send x
			else
				send ^{backspace}
		else if stateLShift=D
				if stateLWin=D
					if stateLAlt=D
						send x
					else
						send x
				else if stateLAlt=D
					send x
				else
					send x
		else if stateLWin=D
				if stateLAlt=D
						send x
				else
					send x
		else if stateLAlt=D
			send !{backspace}
		else
			send ^{backspace} ;duplicate? 
		else
			send {backspace}
		return 
		}  

	CapsLock & e:: ; Volume Down 
		{
		/*

	Themes
		""	
		^	
		+	reverse 
		#	
		!	
		
		Add comments here using "ncmtli" (performs ^d, li9, ncmth)
		*/ 

		GetKeyState, stateLCtrl, LCtrl
		GetKeyState, stateLAlt, LAlt
		GetKeyState, stateLShift, LShift
		GetKeyState, stateLWin, LWin
		GetKeyState, stateRCtrl, RCtrl
		GetKeyState, stateRAlt, RAlt
		GetKeyState, stateRShift, RShift
		GetKeyState, stateRWin, RWin
		GetKeyState, stateScrollLock, ScrollLock
		if stateLCtrl=D
			if stateLAlt=D
				if stateLShift=D
					if stateLWin=D ; ^!+#{x} 
						sendraw ^!+#{x} 
					else ; ^!+{x} 
						sendraw ^!+{x} 
				else if stateLWin=D ; ^!#{x} 
					sendraw ^!#{x} 
				else ; ^!{x}
					sendraw ^!{x}
			else if stateLShift=D
				if stateLWin=D ; ^+#{x} 
					sendraw ^+#{x} 
				else ; ^+{x}
					sendraw ^+{x}
			else if stateLWin=D ; ^#{x} 
				sendraw ^#{x} 
			else ; ^{x}
				sendraw ^{x}

		else if stateLAlt=D
				if stateLShift=D
					if stateLWin=D ; !+#{x} 
						sendraw !+#{x} 
					else ; !+{x} 
						sendraw !+{x} 
				else if stateLWin=D ; !#{x} 
					sendraw !#{x} 
				else ; !{x}
					sendraw !{x}
			else if stateLShift=D
				if stateLWin=D ; +#{x} 
					sendraw +#{x} 
				else ; +{x} 
					sendraw +{x}
			else if stateLWin=D ; #{x} 
				; There is an issue with § and # alone. 
				; 2017-06-01 might not be a problem when pressing § first 
				; 2016-06-30 have tried to fix it but given up for now, avoid it for now 
				sendraw #{x} 
			else ; {x} 
				send {Volume_Down}
		StuckKeyUp()
		return 
		}

	CapsLock & f::  ;	Find (Search) 
		{
		/*

		Themes
			""	close window (!f4)
			^	SearchWordAtCaret
			+	Reverse 
			#	SearchClipboardHere
			!	SearchWordAtPointer
			
		Add comments here using "ncmtli" (performs ^d, li9, ncmth)
		
		*/ 


		GetKeyState, stateLCtrl, LCtrl
		GetKeyState, stateLAlt, LAlt
		GetKeyState, stateLShift, LShift
		GetKeyState, stateLWin, LWin
		GetKeyState, stateRCtrl, RCtrl
		GetKeyState, stateRAlt, RAlt
		GetKeyState, stateRShift, RShift
		GetKeyState, stateRWin, RWin
		GetKeyState, stateScrollLock, ScrollLock
		if stateLCtrl=D
			if stateLAlt=D
				if stateLShift=D
					if stateLWin=D ; ^!+#{x} 
						sendraw ^!+#{x} 
					else ; ^!+{x} 
						sendraw ^!+{x} 
				else if stateLWin=D ; ^!#{x} 
					sendraw ^!#{x} 
				else ; ^!{x}
					sendraw ^!{x}
			else if stateLShift=D
				if stateLWin=D ; ^+#{x} 
					sendraw ^+#{x} 
				else ; ^+{x}
					sendraw ^+{x}
			else if stateLWin=D ; ^#{x} 
				sendraw ^#{x} 
			else ; ^{x}
				SearchWordAtCaret()

		else if stateLAlt=D
				if stateLShift=D 
					if stateLWin=D ; !+#{x} 
						sendraw !+#{x} 
					else ; !+{x} 
						sendraw !+{x} 
				else if stateLWin=D ; !#{x} 
					sendraw !#{x} 
				else ; !{x}
					SearchWordAtPointer()
			else if stateLShift=D
				if stateLWin=D ; +#{x} 
					sendraw +#{x} 
				else ; +{x} 
					sendraw +{x}
			else if stateLWin=D ; #{x} 
				; There is an issue with § and # alone. 
				; 2017-06-01 might not be a problem when pressing § first 
				; 2016-06-30 have tried to fix it but given up for now, avoid it for now 
				SearchClipboardHere() 
			else ; {x} 
				{ 
				WinClose,A 
				}
		StuckKeyUp() ; 2018-01-21 20.11 moved it here, not evaluated 
		return 
		}

	SearchWordAtPointer(){
		sleep 100 
		Send {Click 2}
		sleep 300 
		send ^c
		SearchClipboardHere()
		return 
		}

	CapsLock & g:: ; Enter
		{
		GetKeyState, stateLCtrl, LCtrl
		GetKeyState, stateLShift, LShift
		GetKeyState, stateLWin, LWin
		GetKeyState, stateLAlt, LAlt
		GetKeyState, stateRCtrl, RCtrl
		GetKeyState, stateRShift, RShift
		GetKeyState, stateRWin, RWin
		GetKeyState, stateRAlt, RAlt
		GetKeyState, stateSC056, SC056
		GetKeyState("SC056") 
		if stateLCtrl=D
			if stateLShift=D 
				if stateLWin=D
					if stateLAlt=D
						send x   
					else
						send x   
				else if stateLAlt=D
					send ^!+{enter}  
				else
					Send ^+{enter}	
			else if stateLWin=D
					if stateLAlt=D
						send ^+#{enter}  
					else
						Send ^#{enter}	
			else if stateLAlt=D
				if stateLWin=D
					send ^!#{enter}  
				else
					send ^!{enter} 
			else if stateLWin=D
					send ^#{enter} 
			else
				Send ^{enter}	 
		else if stateLShift=D
				if stateLWin=D
					if stateLAlt=D
						send !+#{enter} ; SHIFT + alt + Win +  available 
					else
						Send +#{enter} ; SHIFT + Win +  available 
				else if stateLAlt=D
					send !+{enter} ; SHIFT + alt +  available 
				else
					Send +{enter} ; SHIFT +  available 
		else if stateLWin=D
				if stateLAlt=D
						send !#{enter} ; alt + Win +  available 
				else
					Send #{enter} ; Win +  available 
		else if stateLAlt=D
			Send !{enter} ; Alt +  available 
		else if stateRCtrl=D
			send {enter} ; available 			
		else
			send {enter} ; available 
			return 
		}

	CapsLock & h:: ; Left 
	{
	GetKeyState, stateLCtrl, LCtrl
	GetKeyState, stateLShift, LShift
	GetKeyState, stateLWin, LWin
	GetKeyState, stateLAlt, LAlt
	if stateLCtrl=D
		if stateLShift=D
			if stateLWin=D
				if stateLAlt=D
					send ^!+#{left} ; Ctrl + SHIFT + alt + Win + left
				else
					Send ^+#{left} ; Ctrl + SHIFT + Win + left
			else if stateLAlt=D
				send ^!+{left} ; Ctrl + SHIFT + alt + left
			else
				Send ^+{left}	; Ctrl + SHIFT + left
		else if stateLWin=D
				if stateLAlt=D
					send ^!#{left} ; Ctrl + shift + Win + left
				else
					send ^#{left}
		else if stateLAlt=D
			if stateLWin=D
				send ^!#{left} ; Ctrl + alt + win + left
			else
				send ^!{left} ; Ctrl + alt + left
		else if stateLWin=D
				send ^#{left} ; Ctrl + win + left
		else
			Send ^{left}	; Ctrl left
	else if stateLShift=D
			if stateLWin=D
				if stateLAlt=D
					send !+#{left} ; SHIFT + alt + Win + left
				else
					Send +#{left} ; SHIFT + Win + left
			else if stateLAlt=D
				send !+{left} ; SHIFT + alt + left
			else
				Send +{left} ; SHIFT + left
	else if stateLWin=D
			if stateLAlt=D
					send !#{left} ; alt + Win + left
			else
				Send #{left} ; Win + left
	else if stateLAlt=D
		Send !{left} ; Alt + left
	else
		Send {left} ; left
	return
	}

	CapsLock & i:: ;	Available 
		{
		/*

	Themes
		""	
		^	
		+	reverse 
		#	
		!	
		
		Add comments here using "ncmtli" (performs ^d, li9, ncmth)
		*/ 

		GetKeyState, stateLCtrl, LCtrl
		GetKeyState, stateLAlt, LAlt
		GetKeyState, stateLShift, LShift
		GetKeyState, stateLWin, LWin
		GetKeyState, stateRCtrl, RCtrl
		GetKeyState, stateRAlt, RAlt
		GetKeyState, stateRShift, RShift
		GetKeyState, stateRWin, RWin
		GetKeyState, stateScrollLock, ScrollLock
		if stateLCtrl=D
			if stateLAlt=D
				if stateLShift=D
					if stateLWin=D ; ^!+#{x} 
						sendraw ^!+#{x} 
					else ; ^!+{x} 
						sendraw ^!+{x} 
				else if stateLWin=D ; ^!#{x} 
					sendraw ^!#{x} 
				else ; ^!{x}
					sendraw ^!{x}
			else if stateLShift=D
				if stateLWin=D ; ^+#{x} 
					sendraw ^+#{x} 
				else ; ^+{x}
					sendraw ^+{x}
			else if stateLWin=D ; ^#{x} 
				sendraw ^#{x} 
			else ; ^{x}
				sendraw ^{x}

		else if stateLAlt=D
				if stateLShift=D
					if stateLWin=D ; !+#{x} 
						sendraw !+#{x} 
					else ; !+{x} 
						sendraw !+{x} 
				else if stateLWin=D ; !#{x} 
					sendraw !#{x} 
				else ; !{x}
					sendraw !{x}
			else if stateLShift=D
				if stateLWin=D ; +#{x} 
					sendraw +#{x} 
				else ; +{x} 
					sendraw +{x}
			else if stateLWin=D ; #{x} 
				; There is an issue with § and # alone. 
				; 2017-06-01 might not be a problem when pressing § first 
				; 2016-06-30 have tried to fix it but given up for now, avoid it for now 
				sendraw #{x} 
			else ; {x} 
				{ 
				sendraw {x} 
				StuckKeyUp()
				}
		return 
		}

	CapsLock & j:: ;	Available 
		{
		/*

	Themes
		""	
		^	
		+	reverse 
		#	
		!	
		
		Add comments here using "ncmtli" (performs ^d, li9, ncmth)
		*/ 

		GetKeyState, stateLCtrl, LCtrl
		GetKeyState, stateLAlt, LAlt
		GetKeyState, stateLShift, LShift
		GetKeyState, stateLWin, LWin
		GetKeyState, stateRCtrl, RCtrl
		GetKeyState, stateRAlt, RAlt
		GetKeyState, stateRShift, RShift
		GetKeyState, stateRWin, RWin
		GetKeyState, stateScrollLock, ScrollLock
		if stateLCtrl=D
			if stateLAlt=D
				if stateLShift=D
					if stateLWin=D ; ^!+#{x} 
						sendraw ^!+#{x} 
					else ; ^!+{x} 
						sendraw ^!+{x} 
				else if stateLWin=D ; ^!#{x} 
					sendraw ^!#{x} 
				else ; ^!{x}
					sendraw ^!{x}
			else if stateLShift=D
				if stateLWin=D ; ^+#{x} 
					sendraw ^+#{x} 
				else ; ^+{x}
					sendraw ^+{x}
			else if stateLWin=D ; ^#{x} 
				sendraw ^#{x} 
			else ; ^{x}
				sendraw ^{x}

		else if stateLAlt=D
				if stateLShift=D
					if stateLWin=D ; !+#{x} 
						sendraw !+#{x} 
					else ; !+{x} 
						sendraw !+{x} 
				else if stateLWin=D ; !#{x} 
					sendraw !#{x} 
				else ; !{x}
					sendraw !{x}
			else if stateLShift=D
				if stateLWin=D ; +#{x} 
					sendraw +#{x} 
				else ; +{x} 
					sendraw +{x}
			else if stateLWin=D ; #{x} 
				; There is an issue with § and # alone. 
				; 2017-06-01 might not be a problem when pressing § first 
				; 2016-06-30 have tried to fix it but given up for now, avoid it for now 
				sendraw #{x} 
			else ; {x} 
				{ 
				sendraw {x} 
				}
		StuckKeyUp()
		return 
		}

	CapsLock & k:: ;	Available 
		{
		/*

	Themes
		""	
		^	
		+	reverse 
		#	
		!	
		
		Add comments here using "ncmtli" (performs ^d, li9, ncmth)
		*/ 

		GetKeyState, stateLCtrl, LCtrl
		GetKeyState, stateLAlt, LAlt
		GetKeyState, stateLShift, LShift
		GetKeyState, stateLWin, LWin
		GetKeyState, stateRCtrl, RCtrl
		GetKeyState, stateRAlt, RAlt
		GetKeyState, stateRShift, RShift
		GetKeyState, stateRWin, RWin
		GetKeyState, stateScrollLock, ScrollLock
		if stateLCtrl=D
			if stateLAlt=D
				if stateLShift=D
					if stateLWin=D ; ^!+#{x} 
						sendraw ^!+#{x} 
					else ; ^!+{x} 
						sendraw ^!+{x} 
				else if stateLWin=D ; ^!#{x} 
					sendraw ^!#{x} 
				else ; ^!{x}
					sendraw ^!{x}
			else if stateLShift=D
				if stateLWin=D ; ^+#{x} 
					sendraw ^+#{x} 
				else ; ^+{x}
					sendraw ^+{x}
			else if stateLWin=D ; ^#{x} 
				sendraw ^#{x} 
			else ; ^{x}
				sendraw ^{x}

		else if stateLAlt=D
				if stateLShift=D
					if stateLWin=D ; !+#{x} 
						sendraw !+#{x} 
					else ; !+{x} 
						sendraw !+{x} 
				else if stateLWin=D ; !#{x} 
					sendraw !#{x} 
				else ; !{x}
					sendraw !{x}
			else if stateLShift=D
				if stateLWin=D ; +#{x} 
					sendraw +#{x} 
				else ; +{x} 
					sendraw +{x}
			else if stateLWin=D ; #{x} 
				; There is an issue with § and # alone. 
				; 2017-06-01 might not be a problem when pressing § first 
				; 2016-06-30 have tried to fix it but given up for now, avoid it for now 
				sendraw #{x} 
			else ; {x} 
				{ 
				sendraw {x} 
				}
		StuckKeyUp()
		return 
		}

	CapsLock & l:: ;	Available 
		{
		/*

	Themes
		""	
		^	
		+	reverse 
		#	
		!	
		
		Add comments here using "ncmtli" (performs ^d, li9, ncmth)
		*/ 

		GetKeyState, stateLCtrl, LCtrl
		GetKeyState, stateLAlt, LAlt
		GetKeyState, stateLShift, LShift
		GetKeyState, stateLWin, LWin
		GetKeyState, stateRCtrl, RCtrl
		GetKeyState, stateRAlt, RAlt
		GetKeyState, stateRShift, RShift
		GetKeyState, stateRWin, RWin
		GetKeyState, stateScrollLock, ScrollLock
		if stateLCtrl=D
			if stateLAlt=D
				if stateLShift=D
					if stateLWin=D ; ^!+#{x} 
						sendraw ^!+#{x} 
					else ; ^!+{x} 
						sendraw ^!+{x} 
				else if stateLWin=D ; ^!#{x} 
					sendraw ^!#{x} 
				else ; ^!{x}
					sendraw ^!{x}
			else if stateLShift=D
				if stateLWin=D ; ^+#{x} 
					sendraw ^+#{x} 
				else ; ^+{x}
					sendraw ^+{x}
			else if stateLWin=D ; ^#{x} 
				sendraw ^#{x} 
			else ; ^{x}
				sendraw ^{x}

		else if stateLAlt=D
				if stateLShift=D
					if stateLWin=D ; !+#{x} 
						sendraw !+#{x} 
					else ; !+{x} 
						sendraw !+{x} 
				else if stateLWin=D ; !#{x} 
					sendraw !#{x} 
				else ; !{x}
					sendraw !{x}
			else if stateLShift=D
				if stateLWin=D ; +#{x} 
					sendraw +#{x} 
				else ; +{x} 
					sendraw +{x}
			else if stateLWin=D ; #{x} 
				; There is an issue with § and # alone. 
				; 2017-06-01 might not be a problem when pressing § first 
				; 2016-06-30 have tried to fix it but given up for now, avoid it for now 
				sendraw #{x} 
			else ; {x} 
				{ 
				sendraw {x} 
				}
		StuckKeyUp()
		return 
		}

	CapsLock & m:: ; Click 
	{
	GetKeyState, stateLCtrl, LCtrl
	GetKeyState, stateLAlt, LAlt
	GetKeyState, stateLShift, LShift
	GetKeyState, stateLWin, LWin
	GetKeyState, stateRCtrl, RCtrl
	GetKeyState, stateRAlt, RAlt
	GetKeyState, stateRShift, RShift
	GetKeyState, stateRWin, RWin
	GetKeyState, stateScrollLock, ScrollLock

	if stateLCtrl=D
		if stateLAlt=D
			if stateLShift=D
				if stateLWin=D ;^!+#{x} 
					sendraw ^!+#{x} 
				else ;^!+{x} 
					sendraw ^!+{x} 
			else if stateLWin=D ;^!#{x} 
				sendraw ^!#{x} 
			else ;^!{x}
				sendraw ^!{x}
		else if stateLShift=D
			if stateLWin=D ;^+#{x} 
				sendraw ^+#{x} 
			else ;^+{x}
				send ^+{f6} 
		else if stateLWin=D ;^#{x} 
			sendraw ^#{x} 
		else ;^{x}
			send ^{f6} 
	
	else if stateLAlt=D
			if stateLShift=D
				if stateLWin=D ;!+#{x} 
					sendraw !+#{x} 
				else ;!+{x} 
					send +{f6} 
			else if stateLWin=D ;!#{x} 
				sendraw !#{x} 
			else ;!{x}
				send {f6}
		else if stateLShift=D
			if stateLWin=D ;+#{x} 
				sendraw +#{x} 
			else ;+{x} 
				send +{f6}
		else if stateLWin=D ;#{x} ; there is an issue with § and # alone (but all other combinations seem fine, possibly due to differences in how # behaviors compared to other modifiers)

			{
			sleep 500 
			send  {f6}
			}
		else ;{x} 
			{
			; sleep 500 
			; send  te
			Click
			}
		return 
	return 
	}

	CapsLock & n:: ; Right 
	{
	GetKeyState, stateLCtrl, LCtrl
	GetKeyState, stateLShift, LShift
	GetKeyState, stateLWin, LWin
	GetKeyState, stateLAlt, LAlt
	if stateLCtrl=D
		if stateLShift=D
			if stateLWin=D
				if stateLAlt=D
					send ^!+#{right} ; Ctrl + SHIFT + alt + Win + right
				else
					Send ^+#{right} ; Ctrl + SHIFT + Win + right
			else if stateLAlt=D
				send ^!+{right} ; Ctrl + SHIFT + alt + right
			else
				Send ^+{right}	; Ctrl + SHIFT + right
		else if stateLWin=D
				if stateLAlt=D
					send ^!#{right} ; Ctrl + alt + Win + right
				else
					; send ^#{right} ; Ctrl + shift + Win + right
					{
					send ^#{right}
					return 
					}
		else if stateLAlt=D
			if stateLWin=D
				send ^!#{right} ; Ctrl + alt + win + right
			else
				send ^!{right} ; Ctrl + alt + right
		else if stateLWin=D
					send x 
		else
			Send ^{right}	; Ctrl right
	else if stateLShift=D
			if stateLWin=D
				if stateLAlt=D
					send !+#{right} ; SHIFT + alt + Win + right
				else
					Send +#{right} ; SHIFT + Win + right
			else if stateLAlt=D
				send !+{right} ; SHIFT + alt + right
			else
				Send +{right} ; SHIFT + right
	else if stateLWin=D
			if stateLAlt=D
					send !#{right} ; alt + Win + right
			else
				Send #{right} ; Win + right
	else if stateLAlt=D
		Send !{right} ; Alt + right
	else
		Send {right} ; right
	return
	
	}

	CapsLock & o:: ; Volume Up
		{
		/*

	Themes
		""	
		^	
		+	reverse 
		#	
		!	
		
		Add comments here using "ncmtli" (performs ^d, li9, ncmth)
		*/ 

		GetKeyState, stateLCtrl, LCtrl
		GetKeyState, stateLAlt, LAlt
		GetKeyState, stateLShift, LShift
		GetKeyState, stateLWin, LWin
		GetKeyState, stateRCtrl, RCtrl
		GetKeyState, stateRAlt, RAlt
		GetKeyState, stateRShift, RShift
		GetKeyState, stateRWin, RWin
		GetKeyState, stateScrollLock, ScrollLock
		if stateLCtrl=D
			if stateLAlt=D
				if stateLShift=D
					if stateLWin=D ; ^!+#{x} 
						sendraw ^!+#{x} 
					else ; ^!+{x} 
						sendraw ^!+{x} 
				else if stateLWin=D ; ^!#{x} 
					sendraw ^!#{x} 
				else ; ^!{x}
					sendraw ^!{x}
			else if stateLShift=D
				if stateLWin=D ; ^+#{x} 
					sendraw ^+#{x} 
				else ; ^+{x}
					sendraw ^+{x}
			else if stateLWin=D ; ^#{x} 
				sendraw ^#{x} 
			else ; ^{x}
				sendraw ^{x}

		else if stateLAlt=D
				if stateLShift=D
					if stateLWin=D ; !+#{x} 
						sendraw !+#{x} 
					else ; !+{x} 
						sendraw !+{x} 
				else if stateLWin=D ; !#{x} 
					sendraw !#{x} 
				else ; !{x}
					sendraw !{x}
			else if stateLShift=D
				if stateLWin=D ; +#{x} 
					sendraw +#{x} 
				else ; +{x} 
					sendraw +{x}
			else if stateLWin=D ; #{x} 
				; There is an issue with § and # alone. 
				; 2017-06-01 might not be a problem when pressing § first 
				; 2016-06-30 have tried to fix it but given up for now, avoid it for now 
				sendraw #{x} 
			else ; {x} 
				send {volume_Up}
		StuckKeyUp()
		return 
		}

	CapsLock & p:: ;	Available   
		{
		/*

	Themes
		""	
		^	
		+	reverse 
		#	
		!	
		
		Add comments here using "ncmtli" (performs ^d, li9, ncmth)
		*/ 

		GetKeyState, stateLCtrl, LCtrl
		GetKeyState, stateLAlt, LAlt
		GetKeyState, stateLShift, LShift
		GetKeyState, stateLWin, LWin
		GetKeyState, stateRCtrl, RCtrl
		GetKeyState, stateRAlt, RAlt
		GetKeyState, stateRShift, RShift
		GetKeyState, stateRWin, RWin
		GetKeyState, stateScrollLock, ScrollLock
		if stateLCtrl=D
			if stateLAlt=D
				if stateLShift=D
					if stateLWin=D ; ^!+#{x} 
						sendraw ^!+#{x} 
					else ; ^!+{x} 
						sendraw ^!+{x} 
				else if stateLWin=D ; ^!#{x} 
					sendraw ^!#{x} 
				else ; ^!{x}
					sendraw ^!{x}
			else if stateLShift=D
				if stateLWin=D ; ^+#{x} 
					sendraw ^+#{x} 
				else ; ^+{x}
					sendraw ^+{x}
			else if stateLWin=D ; ^#{x} 
				sendraw ^#{x} 
			else ; ^{x}
				sendraw ^{x}

		else if stateLAlt=D
				if stateLShift=D
					if stateLWin=D ; !+#{x} 
						sendraw !+#{x} 
					else ; !+{x} 
						sendraw !+{x} 
				else if stateLWin=D ; !#{x} 
					sendraw !#{x} 
				else ; !{x}
					sendraw !{x}
			else if stateLShift=D
				if stateLWin=D ; +#{x} 
					sendraw +#{x} 
				else ; +{x} 
					sendraw +{x}
			else if stateLWin=D ; #{x} 
				; There is an issue with § and # alone. 
				; 2017-06-01 might not be a problem when pressing § first 
				; 2016-06-30 have tried to fix it but given up for now, avoid it for now 
				sendraw #{x} 
			else ; {x} 
				{ 
				Pause  ; Press Ctrl+Alt+P to pause. Press it again to resume.
				}
		StuckKeyUp()
		return 
		}
	CapsLock & q:: ;	Available 
		{
		/*

	Themes
		""	
		^	
		+	reverse 
		#	
		!	
		
		Add comments here using "ncmtli" (performs ^d, li9, ncmth)
		*/ 

		GetKeyState, stateLCtrl, LCtrl
		GetKeyState, stateLAlt, LAlt
		GetKeyState, stateLShift, LShift
		GetKeyState, stateLWin, LWin
		GetKeyState, stateRCtrl, RCtrl
		GetKeyState, stateRAlt, RAlt
		GetKeyState, stateRShift, RShift
		GetKeyState, stateRWin, RWin
		GetKeyState, stateScrollLock, ScrollLock
		if stateLCtrl=D
			if stateLAlt=D
				if stateLShift=D
					if stateLWin=D ; ^!+#{x} 
						sendraw ^!+#{x} 
					else ; ^!+{x} 
						sendraw ^!+{x} 
				else if stateLWin=D ; ^!#{x} 
					sendraw ^!#{x} 
				else ; ^!{x}
					sendraw ^!{x}
			else if stateLShift=D
				if stateLWin=D ; ^+#{x} 
					sendraw ^+#{x} 
				else ; ^+{x}
					sendraw ^+{x}
			else if stateLWin=D ; ^#{x} 
				sendraw ^#{x} 
			else ; ^{x}
				sendraw ^{x}

		else if stateLAlt=D
				if stateLShift=D
					if stateLWin=D ; !+#{x} 
						sendraw !+#{x} 
					else ; !+{x} 
						sendraw !+{x} 
				else if stateLWin=D ; !#{x} 
					sendraw !#{x} 
				else ; !{x}
					sendraw !{x}
			else if stateLShift=D
				if stateLWin=D ; +#{x} 
					sendraw +#{x} 
				else ; +{x} 
					sendraw +{x}
			else if stateLWin=D ; #{x} 
				; There is an issue with § and # alone. 
				; 2017-06-01 might not be a problem when pressing § first 
				; 2016-06-30 have tried to fix it but given up for now, avoid it for now 
				sendraw #{x} 
			else ; {x} 
				{ 
				sendraw {x} 
				}
		StuckKeyUp()
		return 
		}

	CapsLock & r:: ; Menu AppsKey 
	{	
	GetKeyState, stateLCtrl, LCtrl
	GetKeyState, stateLShift, LShift
	GetKeyState, stateLWin, LWin
	GetKeyState, stateLAlt, LAlt
	GetKeyState, stateRCtrl, RCtrl
	GetKeyState, stateRShift, RShift
	GetKeyState, stateRWin, RWin
	GetKeyState, stateRAlt, RAlt
	if stateLCtrl=D
		if stateLShift=D
			if stateLWin=D
				if stateLAlt=D
					send ^!+#{appskey} ; i.e. menu key 
				else
					send ^+#{appskey} 
			else if stateLAlt=D
				send ^+!{appskey} 
			else
				send ^+{appskey}
		else if stateLWin=D
			if stateLAlt=D
				send ^!#{appskey} 
			else
				send ^#{appskey}
		else if stateLAlt=D
				send x 
		else
			send ^{appskey}
	else if stateLShift=D
			if stateLWin=D
				if stateLAlt=D
					send +#!{appskey} 
				else
					send +#{appskey} 
			else if stateLAlt=D
				send +!{appskey} 
			else
				send +{appskey}
		else if stateLWin=D
			if stateLAlt=D
				send !#{appskey} 
			else
				{
				sleep 500 
				send öcp8 
				sleep 1100  
				Cbreplm() 
				sleep 300 
				send test
				sleep 500 
				}		
		else if stateLAlt=D
				{
				sleep 500
				send xlcbrubvy ; yyy send this text, which sends another text which launches ClipboardReplace (this is a terrible workaround 
				sleep 300  
				}
		else
			send {appskey}
	return 
	}  

	CapsLock & s:: ; Space 
	{
		/*

		Themes
			""	
			^	add 's (expand abbreviations beforehand)
			+	reverse 
			#	
			!	
			
		Add comments here using "ncmtli" (performs ^d, li9, ncmth)
		
		*/ 

	GetKeyState, stateLCtrl, LCtrl
	GetKeyState, stateLAlt, LAlt
	GetKeyState, stateLShift, LShift
	GetKeyState, stateLWin, LWin
	GetKeyState, stateRCtrl, RCtrl
	GetKeyState, stateRAlt, RAlt
	GetKeyState, stateRShift, RShift
	GetKeyState, stateRWin, RWin
	GetKeyState, stateScrollLock, ScrollLock

	if stateLCtrl=D
		if stateLAlt=D
			if stateLShift=D
				if stateLWin=D ;^!+#{x} 
					sendraw ^!+#{x} 
				else ;^!+{x} 
					sendraw ^!+{x} 
			else if stateLWin=D ;^!#{x} 
				sendraw ^!#{x} 
			else ;^!{x}
				sendraw ^!{x}
		else if stateLShift=D
			if stateLWin=D ;^+#{x} 
				sendraw ^+#{x} 
			else ;^+{x}
				sendraw ^+{x}
		else if stateLWin=D ;^#{x} 
			sendraw ^#{x} 
		else ;^{x}
			{
				sleep 300 ; prevent key stuck ; 2017-01-13 changed from 700 to 300 for speed  
				send {space}
				sleep 400 ; give Breevy time to expand abbreviation 
				Send {left} ; left
				sendraw 's
				send {space}
				return  
			}

	else if stateLAlt=D
			if stateLShift=D
				if stateLWin=D ;!+#{x} 
					sendraw !+#{x} 
				else ;!+{x} 
					sendraw !+{x} 
			else if stateLWin=D ;!#{x} 
				sendraw !#{x} 
			else
				{
				sleep 400 ; prevent key stuck 
				Send {left} ; left
				Send {right} ; right 
				return  
				}	
		else if stateLShift=D
			if stateLWin=D ;+#{x} 
				sendraw +#{x} 
			else ;+{x} 
				AltTabph() 
		else if stateLWin=D ;#{x} ; there is an issue with § and # alone (but all other combinations seem fine, possibly due to differences in how # behaviors compared to other modifiers)
			sendraw #{x} ; there is an issue with § and # alone (but all other combinations seem fine, possibly due to differences in how # behaviors compared to other modifiers)
		else ;{x} 
			{
				sleep 300 ; prevent key stuck ; 2017-01-13 changed from 700 to 300 for speed  
				Send {left} ; left
				Send {right} ; right 
				send {space}
				return  
			}
		return 
	}

	CapsLock & t:: ; Down
	{
	GetKeyState, stateRCtrl, RCtrl
	GetKeyState, stateRShift, RShift
	GetKeyState, stateRWin, RWin
	GetKeyState, stateRAlt, RAlt
	GetKeyState, stateSC056, SC056 ; got this to work 2014-10-02, but then it stopped working again (not sure why)
	GetKeyState, stateLCtrl, LCtrl
	GetKeyState, stateLShift, LShift
	GetKeyState, stateLWin, LWin
	GetKeyState, stateLAlt, LAlt
				
	if stateLCtrl=D
		if stateLShift=D
			if stateLWin=D
				if stateLAlt=D
					send ^!+#{down} ; Ctrl + SHIFT + alt + Win + down
				else
					Send ^+#{down} ; Ctrl + SHIFT + Win + down
			else if stateLAlt=D
				send ^!+{down} ; Ctrl + SHIFT + alt + down
			else
				Send ^+{down}	; Ctrl + SHIFT + down
		else if stateLWin=D
				if stateLAlt=D
					send ^+#{down} ; Ctrl + shift + Win + down
				else
					Send ^#{down}	; Ctrl + win + down
		else if stateLAlt=D
			if stateLWin=D
				send ^!#{down} ; Ctrl + alt + win + down
			else
				send ^!{down} ; Ctrl + alt + down
		else if stateLWin=D
				send ^#{down} ; Ctrl + win + down 
		else
			Send ^{down}	; Ctrl down
		else if stateLShift=D
			if stateLWin=D
				if stateLAlt=D
					send !+#{down} ; SHIFT + alt + Win + down
				else
					Send +#{down} ; SHIFT + Win + down
			else if stateLAlt=D
				send !+{down} ; SHIFT + alt + down
			else
				Send +{down} ; SHIFT + down
		else if stateLWin=D
			if stateLAlt=D
					send !#{down} ; alt + Win + down
			else
				Send #{down} ; Win + down
		else if stateLAlt=D
			Send !{down} ; Alt + down
		else
			Send {down} ; down
	return
	}

	CapsLock & u:: ;	Available 
		{
		/*

	Themes
		""	
		^	
		+	reverse 
		#	
		!	
		
		Add comments here using "ncmtli" (performs ^d, li9, ncmth)
		*/ 

		GetKeyState, stateLCtrl, LCtrl
		GetKeyState, stateLAlt, LAlt
		GetKeyState, stateLShift, LShift
		GetKeyState, stateLWin, LWin
		GetKeyState, stateRCtrl, RCtrl
		GetKeyState, stateRAlt, RAlt
		GetKeyState, stateRShift, RShift
		GetKeyState, stateRWin, RWin
		GetKeyState, stateScrollLock, ScrollLock
		if stateLCtrl=D
			if stateLAlt=D
				if stateLShift=D
					if stateLWin=D ; ^!+#{x} 
						sendraw ^!+#{x} 
					else ; ^!+{x} 
						sendraw ^!+{x} 
				else if stateLWin=D ; ^!#{x} 
					sendraw ^!#{x} 
				else ; ^!{x}
					sendraw ^!{x}
			else if stateLShift=D
				if stateLWin=D ; ^+#{x} 
					sendraw ^+#{x} 
				else ; ^+{x}
					sendraw ^+{x}
			else if stateLWin=D ; ^#{x} 
				sendraw ^#{x} 
			else ; ^{x}
				sendraw ^{x}

		else if stateLAlt=D
				if stateLShift=D
					if stateLWin=D ; !+#{x} 
						sendraw !+#{x} 
					else ; !+{x} 
						sendraw !+{x} 
				else if stateLWin=D ; !#{x} 
					sendraw !#{x} 
				else ; !{x}
					sendraw !{x}
			else if stateLShift=D
				if stateLWin=D ; +#{x} 
					sendraw +#{x} 
				else ; +{x} 
					sendraw +{x}
			else if stateLWin=D ; #{x} 
				; There is an issue with § and # alone. 
				; 2017-06-01 might not be a problem when pressing § first 
				; 2016-06-30 have tried to fix it but given up for now, avoid it for now 
				sendraw #{x} 
			else ; {x} 
				{ 
				sendraw {x} 
				}
		StuckKeyUp()
		return 
		}

	CapsLock & v:: ; F3
	{
	GetKeyState, stateLCtrl, LCtrl
	GetKeyState, stateLAlt, LAlt
	GetKeyState, stateLShift, LShift
	GetKeyState, stateLWin, LWin
	GetKeyState, stateRCtrl, RCtrl
	GetKeyState, stateRAlt, RAlt
	GetKeyState, stateRShift, RShift
	GetKeyState, stateRWin, RWin
	GetKeyState, stateScrollLock, ScrollLock

	if stateLCtrl=D
		if stateLAlt=D
			if stateLShift=D
				if stateLWin=D ; ^!+#{f3} 
					send ^!+#{f3} 
				else ; ^!+{f3} 
					send ^!+{f3} 
			else if stateLWin=D ; ^!#{f3} 
				send ^!#{f3} 
			else ; ^!{f3}
				send ^!{f3}
		else if stateLShift=D
			if stateLWin=D ; ^+#{f3} 
				send ^+#{f3} 
			else ; ^+{f3}
				send ^+{f3}
		else if stateLWin=D ; ^#{f3} 
			send ^#{f3} 
		else ; ^{f3}
			send ^{f3}

	else if stateLAlt=D
			if stateLShift=D
				if stateLWin=D ; !+#{f3} 
					send !+#{f3} 
				else ; !+{f3} 
					send !+{f3} 
			else if stateLWin=D ; !#{f3} 
				send !#{f3} 
			else ; !{f3}
				send !{f3}
		else if stateLShift=D
			if stateLWin=D ; +#{f3} 
				send +#{f3} 
			else ; +{f3} 
				send +{f3}
		else if stateLWin=D ; #{f3} ; there is an issue with § and # alone (but all other combinations seem fine, possibly due to differences in how # behaviors compared to other modifiers). 
			; 2016-06-30 have tried to fix it but given up for now, avoid it for now 
			send #{f3} 
		else ; {f3} 
			send {f3} 
	return 
	}

	CapsLock & w:: ; F5 
	{
	GetKeyState, stateLCtrl, LCtrl
	GetKeyState, stateLAlt, LAlt
	GetKeyState, stateLShift, LShift
	GetKeyState, stateLWin, LWin
	GetKeyState, stateRCtrl, RCtrl
	GetKeyState, stateRAlt, RAlt
	GetKeyState, stateRShift, RShift
	GetKeyState, stateRWin, RWin
	GetKeyState, stateScrollLock, ScrollLock

	if stateLCtrl=D
		if stateLAlt=D
			if stateLShift=D
				if stateLWin=D ; ^!+#{f5} 
					send ^!+#{f5} 
				else ; ^!+{f5} 
					send ^!+{f5} 
			else if stateLWin=D ; ^!#{f5} 
				send ^!#{f5} 
			else ; ^!{f5}
				send ^!{f5}
		else if stateLShift=D
			if stateLWin=D ; ^+#{f5} 
				send ^+#{f5} 
			else ; ^+{f5}
				send ^+{f5}
		else if stateLWin=D ; ^#{f5} 
			send ^#{f5} 
		else ; ^{f5}
			send ^{f5}

	else if stateLAlt=D
			if stateLShift=D
				if stateLWin=D ; !+#{f5} 
					send !+#{f5} 
				else ; !+{f5} 
					send !+{f5} 
			else if stateLWin=D ; !#{f5} 
				send !#{f5} 
			else ; !{f5}
				send !{f5}
		else if stateLShift=D
			if stateLWin=D ; +#{f5} 
				send +#{f5} 
			else ; +{f5} 
				send +{f5}
		else if stateLWin=D ; #{f5} ; there is an issue with § and # alone (but all other combinations seem fine, possibly due to differences in how # behaviors compared to other modifiers). 
			; 2016-06-30 have tried to fix it but given up for now, avoid it for now 
			send #{f5} 
		else ; {f5} 
			send {f5} 
	return 
	}

	CapsLock & x:: ; Available 
		{
		/*

	Themes
		""	
		^	
		+	reverse 
		#	
		!	
		
		Add comments here using "ncmtli" (performs ^d, li9, ncmth)
		*/ 

		GetKeyState, stateLCtrl, LCtrl
		GetKeyState, stateLAlt, LAlt
		GetKeyState, stateLShift, LShift
		GetKeyState, stateLWin, LWin
		GetKeyState, stateRCtrl, RCtrl
		GetKeyState, stateRAlt, RAlt
		GetKeyState, stateRShift, RShift
		GetKeyState, stateRWin, RWin
		GetKeyState, stateScrollLock, ScrollLock
		if stateLCtrl=D
			if stateLAlt=D
				if stateLShift=D
					if stateLWin=D ; ^!+#{x} 
						sendraw ^!+#{x} 
					else ; ^!+{x} 
						sendraw ^!+{x} 
				else if stateLWin=D ; ^!#{x} 
					sendraw ^!#{x} 
				else ; ^!{x}
					sendraw ^!{x}
			else if stateLShift=D
				if stateLWin=D ; ^+#{x} 
					sendraw ^+#{x} 
				else ; ^+{x}
					sendraw ^+{x}
			else if stateLWin=D ; ^#{x} 
				sendraw ^#{x} 
			else ; ^{x}
				sendraw ^{x}

		else if stateLAlt=D
				if stateLShift=D
					if stateLWin=D ; !+#{x} 
						sendraw !+#{x} 
					else ; !+{x} 
						sendraw !+{x} 
				else if stateLWin=D ; !#{x} 
					sendraw !#{x} 
				else ; !{x}
					sendraw !{x}
			else if stateLShift=D
				if stateLWin=D ; +#{x} 
					sendraw +#{x} 
				else ; +{x} 
					sendraw +{x}
			else if stateLWin=D ; #{x} 
				; There is an issue with § and # alone. 
				; 2017-06-01 might not be a problem when pressing § first 
				; 2016-06-30 have tried to fix it but given up for now, avoid it for now 
				sendraw #{x} 
			else ; {x} 
				{ 
				sendraw {x} 
				}
		StuckKeyUp()
		return 
		}

	CapsLock & y:: ; Available 
		{
		/*

	Themes
		""	
		^	
		+	reverse 
		#	
		!	
		
		Add comments here using "ncmtli" (performs ^d, li9, ncmth)
		*/ 

		GetKeyState, stateLCtrl, LCtrl
		GetKeyState, stateLAlt, LAlt
		GetKeyState, stateLShift, LShift
		GetKeyState, stateLWin, LWin
		GetKeyState, stateRCtrl, RCtrl
		GetKeyState, stateRAlt, RAlt
		GetKeyState, stateRShift, RShift
		GetKeyState, stateRWin, RWin
		GetKeyState, stateScrollLock, ScrollLock
		if stateLCtrl=D
			if stateLAlt=D
				if stateLShift=D
					if stateLWin=D ; ^!+#{x} 
						sendraw ^!+#{x} 
					else ; ^!+{x} 
						sendraw ^!+{x} 
				else if stateLWin=D ; ^!#{x} 
					sendraw ^!#{x} 
				else ; ^!{x}
					sendraw ^!{x}
			else if stateLShift=D
				if stateLWin=D ; ^+#{x} 
					sendraw ^+#{x} 
				else ; ^+{x}
					sendraw ^+{x}
			else if stateLWin=D ; ^#{x} 
				sendraw ^#{x} 
			else ; ^{x}
				sendraw ^{x}

		else if stateLAlt=D
				if stateLShift=D
					if stateLWin=D ; !+#{x} 
						sendraw !+#{x} 
					else ; !+{x} 
						sendraw !+{x} 
				else if stateLWin=D ; !#{x} 
					sendraw !#{x} 
				else ; !{x}
					sendraw !{x}
			else if stateLShift=D
				if stateLWin=D ; +#{x} 
					sendraw +#{x} 
				else ; +{x} 
					sendraw +{x}
			else if stateLWin=D ; #{x} 
				; There is an issue with § and # alone. 
				; 2017-06-01 might not be a problem when pressing § first 
				; 2016-06-30 have tried to fix it but given up for now, avoid it for now 
				sendraw #{x} 
			else ; {x} 
				{ 
				sendraw {x} 
				}
		StuckKeyUp()
		return 
		}

	CapsLock & z:: ; ^F4
	{	
	GetKeyState, stateLCtrl, LCtrl
	GetKeyState, stateLShift, LShift
	GetKeyState, stateLWin, LWin
	GetKeyState, stateLAlt, LAlt
							
	if stateLCtrl=D
		if stateLShift=D
			if stateLWin=D
				if stateLAlt=D
					send ^x
				else
					send ^x
			else if stateLAlt=D
				send ^x
			else
				send ^x
		else if stateLWin=D
				if stateLAlt=D
					send ^x
				else
					send ^x
		else if stateLAlt=D
			if stateLWin=D
				send ^x
			else
				send ^x
		else if stateLWin=D
				send ^x
		else
			send ^x
	else if stateLShift=D
			if stateLWin=D
				if stateLAlt=D
					send ^x
				else
					send ^x
			else if stateLAlt=D
				send ^x
			else
				send ^x
	else if stateLWin=D
			if stateLAlt=D
					send ^x
			else
				send ^x
	else if stateLAlt=D
		send !{f4}
	else
		send ^{f4}
	return
	}

	CapsLock & mbutton:: ; Available 
	{	
	GetKeyState, stateLCtrl, LCtrl
	GetKeyState, stateLShift, LShift
	GetKeyState, stateLWin, LWin
	GetKeyState, stateLAlt, LAlt
							
	if stateLCtrl=D
		if stateLShift=D
			if stateLWin=D
				if stateLAlt=D
					send x
				else
					send x
			else if stateLAlt=D
				send x
			else
				send x
		else if stateLWin=D
				if stateLAlt=D
					send x
				else
					send x
		else if stateLAlt=D
			if stateLWin=D
				send x
			else
				send x
		else if stateLWin=D
				send x
		else
			send x
	else if stateLShift=D
			if stateLWin=D
				if stateLAlt=D
					send x
				else
					send x
			else if stateLAlt=D
				send x
			else
				send ^z
	else if stateLWin=D
			if stateLAlt=D
					send x
			else
				{
					Send {AppsKey}
					send ddd
					send {enter}
					return 
				}	
				
	else if stateLAlt=D
		{
			Send {AppsKey}
			send e 
			return 
		}	
		
	else
		send {AppsKey} 
		
	return 
	}

	capslock & LButton:: ; Copy 
	{	
	GetKeyState, stateLCtrl, LCtrl
	GetKeyState, stateLShift, LShift
	GetKeyState, stateLWin, LWin
	GetKeyState, stateLAlt, LAlt

	GetKeyState, stateRCtrl, RCtrl
	GetKeyState, stateRShift, RShift
	GetKeyState, stateRWin, RWin
	GetKeyState, stateRAlt, RAlt
							
	if stateLCtrl=D
		if stateLShift=D
			if stateLWin=D
				if stateLAlt=D
					send x
				else
					send x
			else if stateLAlt=D
				send x
			else
				send x
		else if stateLWin=D
				if stateLAlt=D
					send x
				else
					send x
		else if stateLAlt=D
			if stateLWin=D
				send x
			else
				send x
		else if stateLWin=D
				send x
		else
			send x
	else if stateLShift=D
			if stateLWin=D
				if stateLAlt=D
					send x
				else
					send x
			else if stateLAlt=D
				send x
			else
				send x
	else if stateLWin=D
			if stateLAlt=D
					send x
			else
				send ^x
	else if stateLAlt=D
		send ^v
	else
		send ^c
	return
	}

	capslock & RButton:: ; Paste 
	{	
	GetKeyState, stateLCtrl, LCtrl
	GetKeyState, stateLShift, LShift
	GetKeyState, stateLWin, LWin
	GetKeyState, stateLAlt, LAlt

	GetKeyState, stateRCtrl, RCtrl
	GetKeyState, stateRShift, RShift
	GetKeyState, stateRWin, RWin
	GetKeyState, stateRAlt, RAlt
							
	if stateLCtrl=D
		if stateLShift=D
			if stateLWin=D
				if stateLAlt=D
					send x
				else
					send x
			else if stateLAlt=D
				send x
			else
				send x
		else if stateLWin=D
				if stateLAlt=D
					send x
				else
					send x
		else if stateLAlt=D
			if stateLWin=D
				send x
			else
				send x
		else if stateLWin=D
				send x
		else
			send x
	else if stateLShift=D
			if stateLWin=D
				if stateLAlt=D
					send x
				else
					send x
			else if stateLAlt=D
				send x
			else
				send x
	else if stateLWin=D
			if stateLAlt=D
					send x
			else
				send ^x
	else if stateLAlt=D
		send ^v
	else
		send ^v
	return
	}

	CapsLock & -:: ; Space 
	{	
		GetKeyState, stateLCtrl, LCtrl
		GetKeyState, stateLShift, LShift
		GetKeyState, stateLWin, LWin
		GetKeyState, stateLAlt, LAlt
		GetKeyState, stateRCtrl, RCtrl
		GetKeyState, stateRShift, RShift
		GetKeyState, stateRWin, RWin
		GetKeyState, stateRAlt, RAlt
			if stateLCtrl=D
				if stateLShift=D
					if stateLWin=D
						if stateLAlt=D
							send x
						else
							send x
					else if stateLAlt=D
						send x
					else
						send x
				else if stateLWin=D
						if stateLAlt=D
							send x
						else
							send x
				else if stateLAlt=D
					if stateLWin=D
						send x
					else
						send x
				else if stateLWin=D
						send x
				else
					send x
			else if stateLShift=D
					if stateLWin=D
						if stateLAlt=D
							send x
						else
							send x
					else if stateLAlt=D
						send x
					else
						send x
			else if stateLWin=D
					if stateLAlt=D
							send x
					else
						send xy
			else if stateLAlt=D
				send yx
			else
				sleep 300 
				send {space}
				sleep 300 
				send {backspace} 
				
	return
	}  

	}
		;########### END CapsLock commands ##############

	{	;##############  SC056 commands ##############
	/*
	ALL global commands should be here, including outside MediaMonkey control music commands 

	2017-12-16 10.26
		
	*/
	

	Sc056 & 1::
		{
		GetKeyState, stateLCtrl, LCtrl
		GetKeyState, stateLAlt, LAlt
		GetKeyState, stateLShift, LShift
		GetKeyState, stateLWin, LWin
		GetKeyState, stateRCtrl, RCtrl
		GetKeyState, stateRAlt, RAlt
		GetKeyState, stateRShift, RShift
		GetKeyState, stateRWin, RWin
		GetKeyState, stateScrollLock, ScrollLock

		if stateLCtrl=D
			if stateLAlt=D
				if stateLShift=D
					if stateLWin=D ; ^!+#{x} 
						sendraw ^!+#{x} 
					else ; ^!+{x} 
						sendraw ^!+{x} 
				else if stateLWin=D ; ^!#{x} 
					sendraw ^!#{x} 
				else ; ^!{x}
					sendraw ^!{x}
			else if stateLShift=D
				if stateLWin=D ; ^+#{x} 
					sendraw ^+#{x} 
				else ; ^+{x}
					sendraw ^+{x}
			else if stateLWin=D ; ^#{x} 
				sendraw ^#{x} 
			else ; ^{x}
				sendraw ^{x}

		else if stateLAlt=D
				if stateLShift=D
					if stateLWin=D ; !+#{x} 
						sendraw !+#{x} 
					else ; !+{x} 
						sendraw !+{x} 
				else if stateLWin=D ; !#{x} 
					sendraw !#{x} 
				else ; !{x}
					sendraw !{x}
			else if stateLShift=D
				if stateLWin=D ; +#{x} 
					sendraw +#{x} 
				else ; +{x} 
					{
					sleep 300
					send ^!#1
					sleep 500
					StuckKeyUp()
					}
			else if stateLWin=D ; #{x} ; there is an issue with § and # alone (but all other combinations seem fine, possibly due to differences in how # behaviors compared to other modifiers). 
				; 2016-06-30 have tried to fix it but given up for now, avoid it for now 
				sendraw #{x} 
			else ; {x} 
				{
				sleep 300
				send ^!#1	;MediaMonkey give rating 1 (to be deleted)
				sleep 100
				send ^!+#n ; MediaMonkey next song 
				sleep 500
				StuckKeyUp()
				}
		return 
		}
			
	Sc056 & 2::
		{
		GetKeyState, stateLCtrl, LCtrl
		GetKeyState, stateLAlt, LAlt
		GetKeyState, stateLShift, LShift
		GetKeyState, stateLWin, LWin
		GetKeyState, stateRCtrl, RCtrl
		GetKeyState, stateRAlt, RAlt
		GetKeyState, stateRShift, RShift
		GetKeyState, stateRWin, RWin
		GetKeyState, stateScrollLock, ScrollLock

		if stateLCtrl=D
			if stateLAlt=D
				if stateLShift=D
					if stateLWin=D ; ^!+#{x} 
						sendraw ^!+#{x} 
					else ; ^!+{x} 
						sendraw ^!+{x} 
				else if stateLWin=D ; ^!#{x} 
					sendraw ^!#{x} 
				else ; ^!{x}
					sendraw ^!{x}
			else if stateLShift=D
				if stateLWin=D ; ^+#{x} 
					sendraw ^+#{x} 
				else ; ^+{x}
					sendraw ^+{x}
			else if stateLWin=D ; ^#{x} 
				sendraw ^#{x} 
			else ; ^{x}
				sendraw ^{x}

		else if stateLAlt=D
				if stateLShift=D
					if stateLWin=D ; !+#{x} 
						sendraw !+#{x} 
					else ; !+{x} 
						sendraw !+{x} 
				else if stateLWin=D ; !#{x} 
					sendraw !#{x} 
				else ; !{x}
					sendraw !{x}
			else if stateLShift=D
				if stateLWin=D ; +#{x} 
					sendraw +#{x} 
				else ; +{x} 
					{
					sleep 300
					send ^!#2 
					sleep 500
					StuckKeyUp()
					}
			else if stateLWin=D ; #{x} ; there is an issue with § and # alone (but all other combinations seem fine, possibly due to differences in how # behaviors compared to other modifiers). 
				; 2016-06-30 have tried to fix it but given up for now, avoid it for now 
				sendraw #{x} 
			else ; {x} 
				{
				send ^!#2	;MediaMonkey give rating 5 (lowest ok)
				sleep 300
				send ^!+#n ; MediaMonkey next song 
				; Send {Media_Next} stopped working to change song in MediaMonkey ~2017-12-16 
				sleep 500
				StuckKeyUp()
				}
		return 
		}
			
	Sc056 & 3::
		{
		GetKeyState, stateLCtrl, LCtrl
		GetKeyState, stateLAlt, LAlt
		GetKeyState, stateLShift, LShift
		GetKeyState, stateLWin, LWin
		GetKeyState, stateRCtrl, RCtrl
		GetKeyState, stateRAlt, RAlt
		GetKeyState, stateRShift, RShift
		GetKeyState, stateRWin, RWin
		GetKeyState, stateScrollLock, ScrollLock

		if stateLCtrl=D
			if stateLAlt=D
				if stateLShift=D
					if stateLWin=D ; ^!+#{x} 
						sendraw ^!+#{x} 
					else ; ^!+{x} 
						sendraw ^!+{x} 
				else if stateLWin=D ; ^!#{x} 
					sendraw ^!#{x} 
				else ; ^!{x}
					sendraw ^!{x}
			else if stateLShift=D
				if stateLWin=D ; ^+#{x} 
					sendraw ^+#{x} 
				else ; ^+{x}
					sendraw ^+{x}
			else if stateLWin=D ; ^#{x} 
				sendraw ^#{x} 
			else ; ^{x}
				sendraw ^{x}

		else if stateLAlt=D
				if stateLShift=D
					if stateLWin=D ; !+#{x} 
						sendraw !+#{x} 
					else ; !+{x} 
						sendraw !+{x} 
				else if stateLWin=D ; !#{x} 
					sendraw !#{x} 
				else ; !{x}
					sendraw !{x}
			else if stateLShift=D
				if stateLWin=D ; +#{x} 
					sendraw +#{x} 
				else ; +{x} 
					{
					sleep 300
					send ^!#3
					sleep 500
					StuckKeyUp()
					}
			else if stateLWin=D ; #{x} ; there is an issue with § and # alone (but all other combinations seem fine, possibly due to differences in how # behaviors compared to other modifiers). 
				; 2016-06-30 have tried to fix it but given up for now, avoid it for now 
				sendraw #{x} 
			else ; {x} 
				{
				send ^!#3	;MediaMonkey give rating 6 
				sleep 300
				send ^!+#n ; MediaMonkey next song 
				sleep 500
				StuckKeyUp()
				}
		return 
		}		

	Sc056 & 4::
		{
		GetKeyState, stateLCtrl, LCtrl
		GetKeyState, stateLAlt, LAlt
		GetKeyState, stateLShift, LShift
		GetKeyState, stateLWin, LWin
		GetKeyState, stateRCtrl, RCtrl
		GetKeyState, stateRAlt, RAlt
		GetKeyState, stateRShift, RShift
		GetKeyState, stateRWin, RWin
		GetKeyState, stateScrollLock, ScrollLock

		if stateLCtrl=D
			if stateLAlt=D
				if stateLShift=D
					if stateLWin=D ; ^!+#{x} 
						sendraw ^!+#{x} 
					else ; ^!+{x} 
						sendraw ^!+{x} 
				else if stateLWin=D ; ^!#{x} 
					sendraw ^!#{x} 
				else ; ^!{x}
					sendraw ^!{x}
			else if stateLShift=D
				if stateLWin=D ; ^+#{x} 
					sendraw ^+#{x} 
				else ; ^+{x}
					sendraw ^+{x}
			else if stateLWin=D ; ^#{x} 
				sendraw ^#{x} 
			else ; ^{x}
				sendraw ^{x}

		else if stateLAlt=D
				if stateLShift=D
					if stateLWin=D ; !+#{x} 
						sendraw !+#{x} 
					else ; !+{x} 
						sendraw !+{x} 
				else if stateLWin=D ; !#{x} 
					sendraw !#{x} 
				else ; !{x}
					sendraw !{x}
			else if stateLShift=D
				if stateLWin=D ; +#{x} 
					sendraw +#{x} 
				else ; +{x} 
					{
					sleep 300
					send ^!#4
					sleep 500
					StuckKeyUp()
					}
			else if stateLWin=D ; #{x} ; there is an issue with § and # alone (but all other combinations seem fine, possibly due to differences in how # behaviors compared to other modifiers). 
				; 2016-06-30 have tried to fix it but given up for now, avoid it for now 
				sendraw #{x} 
			else ; {x} 
				{
				send ^!#4
				sleep 300
				send ^!+#n ; MediaMonkey next song 
				sleep 500
				StuckKeyUp()
				}
		return 
		}		

	Sc056 & 5::
		{
		GetKeyState, stateLCtrl, LCtrl
		GetKeyState, stateLAlt, LAlt
		GetKeyState, stateLShift, LShift
		GetKeyState, stateLWin, LWin
		GetKeyState, stateRCtrl, RCtrl
		GetKeyState, stateRAlt, RAlt
		GetKeyState, stateRShift, RShift
		GetKeyState, stateRWin, RWin
		GetKeyState, stateScrollLock, ScrollLock

		if stateLCtrl=D
			if stateLAlt=D
				if stateLShift=D
					if stateLWin=D ; ^!+#{x} 
						sendraw ^!+#{x} 
					else ; ^!+{x} 
						sendraw ^!+{x} 
				else if stateLWin=D ; ^!#{x} 
					sendraw ^!#{x} 
				else ; ^!{x}
					sendraw ^!{x}
			else if stateLShift=D
				if stateLWin=D ; ^+#{x} 
					sendraw ^+#{x} 
				else ; ^+{x}
					sendraw ^+{x}
			else if stateLWin=D ; ^#{x} 
				sendraw ^#{x} 
			else ; ^{x}
				sendraw ^{x}

		else if stateLAlt=D
				if stateLShift=D
					if stateLWin=D ; !+#{x} 
						sendraw !+#{x} 
					else ; !+{x} 
						sendraw !+{x} 
				else if stateLWin=D ; !#{x} 
					sendraw !#{x} 
				else ; !{x}
					sendraw !{x}
			else if stateLShift=D
				if stateLWin=D ; +#{x} 
					sendraw +#{x} 
				else ; +{x} 
					{
					sleep 300
					send ^!#5
					sleep 500
					StuckKeyUp()
					}
			else if stateLWin=D ; #{x} ; there is an issue with § and # alone (but all other combinations seem fine, possibly due to differences in how # behaviors compared to other modifiers). 
				; 2016-06-30 have tried to fix it but given up for now, avoid it for now 
				sendraw #{x} 
			else ; {x} 
				{
				send ^!#5
				sleep 300
				send ^!+#n ; MediaMonkey next song 
				sleep 500
				StuckKeyUp()
				}
		return 
		}

	Sc056 & 6::
		{
		GetKeyState, stateLCtrl, LCtrl
		GetKeyState, stateLAlt, LAlt
		GetKeyState, stateLShift, LShift
		GetKeyState, stateLWin, LWin
		GetKeyState, stateRCtrl, RCtrl
		GetKeyState, stateRAlt, RAlt
		GetKeyState, stateRShift, RShift
		GetKeyState, stateRWin, RWin
		GetKeyState, stateScrollLock, ScrollLock

		if stateLCtrl=D
			if stateLAlt=D
				if stateLShift=D
					if stateLWin=D ; ^!+#{x} 
						sendraw ^!+#{x} 
					else ; ^!+{x} 
						sendraw ^!+{x} 
				else if stateLWin=D ; ^!#{x} 
					sendraw ^!#{x} 
				else ; ^!{x}
					sendraw ^!{x}
			else if stateLShift=D
				if stateLWin=D ; ^+#{x} 
					sendraw ^+#{x} 
				else ; ^+{x}
					sendraw ^+{x}
			else if stateLWin=D ; ^#{x} 
				sendraw ^#{x} 
			else ; ^{x}
				sendraw ^{x}

		else if stateLAlt=D
				if stateLShift=D
					if stateLWin=D ; !+#{x} 
						sendraw !+#{x} 
					else ; !+{x} 
						sendraw !+{x} 
				else if stateLWin=D ; !#{x} 
					sendraw !#{x} 
				else ; !{x}
					sendraw !{x}
			else if stateLShift=D
				if stateLWin=D ; +#{x} 
					sendraw +#{x} 
				else ; +{x} 
					{
					sleep 300
					send ^!#6
					sleep 500
					StuckKeyUp()
					}
			else if stateLWin=D ; #{x} ; there is an issue with § and # alone (but all other combinations seem fine, possibly due to differences in how # behaviors compared to other modifiers). 
				; 2016-06-30 have tried to fix it but given up for now, avoid it for now 
				sendraw #{x} 
			else ; {x} 
				{
				send ^!#6
				sleep 300
				send ^!+#n ; MediaMonkey next song 
				sleep 500
				StuckKeyUp()
				}
		return 
		}

	Sc056 & 7::
		{
		GetKeyState, stateLCtrl, LCtrl
		GetKeyState, stateLAlt, LAlt
		GetKeyState, stateLShift, LShift
		GetKeyState, stateLWin, LWin
		GetKeyState, stateRCtrl, RCtrl
		GetKeyState, stateRAlt, RAlt
		GetKeyState, stateRShift, RShift
		GetKeyState, stateRWin, RWin
		GetKeyState, stateScrollLock, ScrollLock

		if stateLCtrl=D
			if stateLAlt=D
				if stateLShift=D
					if stateLWin=D ; ^!+#{x} 
						sendraw ^!+#{x} 
					else ; ^!+{x} 
						sendraw ^!+{x} 
				else if stateLWin=D ; ^!#{x} 
					sendraw ^!#{x} 
				else ; ^!{x}
					sendraw ^!{x}
			else if stateLShift=D
				if stateLWin=D ; ^+#{x} 
					sendraw ^+#{x} 
				else ; ^+{x}
					sendraw ^+{x}
			else if stateLWin=D ; ^#{x} 
				sendraw ^#{x} 
			else ; ^{x}
				sendraw ^{x}

		else if stateLAlt=D
				if stateLShift=D
					if stateLWin=D ; !+#{x} 
						sendraw !+#{x} 
					else ; !+{x} 
						sendraw !+{x} 
				else if stateLWin=D ; !#{x} 
					sendraw !#{x} 
				else ; !{x}
					sendraw !{x}
			else if stateLShift=D
				if stateLWin=D ; +#{x} 
					sendraw +#{x} 
				else ; +{x} 
					{
					sleep 300
					send ^!#7
					sleep 500
					StuckKeyUp()
					}
			else if stateLWin=D ; #{x} ; there is an issue with § and # alone (but all other combinations seem fine, possibly due to differences in how # behaviors compared to other modifiers). 
				; 2016-06-30 have tried to fix it but given up for now, avoid it for now 
				sendraw #{x} 
			else ; {x} 
				{
				send ^!#7
				sleep 300
				send ^!+#n ; MediaMonkey next song 
				sleep 500
				StuckKeyUp()
				}
		return 
		}


	SC056 & a:: ; MediaMonkey play/pause 

		{
		/*

	Themes
		""	
		^	
		+	reverse 
		#	
		!	
		
		Add comments here using "ncmtli9" (performs ^d, li9, ncmth)
		*/ 

		GetKeyState, stateLCtrl, LCtrl
		GetKeyState, stateLAlt, LAlt
		GetKeyState, stateLShift, LShift
		GetKeyState, stateLWin, LWin
		GetKeyState, stateRCtrl, RCtrl
		GetKeyState, stateRAlt, RAlt
		GetKeyState, stateRShift, RShift
		GetKeyState, stateRWin, RWin
		GetKeyState, stateScrollLock, ScrollLock
		if stateLCtrl=D
			if stateLAlt=D
				if stateLShift=D
					if stateLWin=D ; ^!+#{x} 
						sendraw ^!+#{x} 
					else ; ^!+{x} 
						sendraw ^!+{x} 
				else if stateLWin=D ; ^!#{x} 
					sendraw ^!#{x} 
				else ; ^!{x}
					sendraw ^!{x}
			else if stateLShift=D
				if stateLWin=D ; ^+#{x} 
					sendraw ^+#{x} 
				else ; ^+{x}
					sendraw ^+{x}
			else if stateLWin=D ; ^#{x} 
				sendraw ^#{x} 
			else ; ^{x}
				sendraw ^{x}

		else if stateLAlt=D
				if stateLShift=D
					if stateLWin=D ; !+#{x} 
						sendraw !+#{x} 
					else ; !+{x} 
						sendraw !+{x} 
				else if stateLWin=D ; !#{x} 
					sendraw !#{x} 
				else ; !{x}
					sendraw !{x}
			else if stateLShift=D
				if stateLWin=D ; +#{x} 
					sendraw +#{x} 
				else ; +{x} 
					sendraw +{x}
			else if stateLWin=D ; #{x} 
				; There is an issue with § and # alone. 
				; 2017-06-01 might not be a problem when pressing § first 
				; 2016-06-30 have tried to fix it but given up for now, avoid it for now 
				sendraw #{x} 
			else ; {x} 
				send ^+#o
		return 
		}

	SC056 & g:: ; available 
		{
		GetKeyState, stateLCtrl, LCtrl
		GetKeyState, stateLShift, LShift
		GetKeyState, stateLWin, LWin
		GetKeyState, stateLAlt, LAlt
		GetKeyState, stateRCtrl, RCtrl
		GetKeyState, stateRShift, RShift
		GetKeyState, stateRWin, RWin
		GetKeyState, stateRAlt, RAlt
		GetKeyState, stateCapsl, CapsLock
		if stateLCtrl=D
				if stateLShift=D
					if stateLWin=D
						if stateLAlt=D
							send x1   
						else
							send x2   
					else if stateLAlt=D
						send x3  
					else
						send x4	
				else if stateLWin=D
						if stateLAlt=D
							send x5  
						else
							send x6	
				else if stateLAlt=D
					if stateLWin=D
						send x7  
					else
						send x8 
				else if stateLWin=D
						send x9 
				else
					send x10	 
			else if stateLShift=D
					if stateLWin=D
						if stateLAlt=D
							send x10 ; SHIFT + alt + Win +  available 
						else
							send x11 ; SHIFT + Win +  available 
					else if stateLAlt=D
						send x12 ; SHIFT + alt +  available 
					else
						send x13 ; SHIFT +  available 
			else if stateLWin=D
					if stateLAlt=D
							send x14 ; alt + Win +  available 
					else
						send x15 ; Win +  available 
			else if stateLAlt=D
				send x16 ; Alt +  available 
			else if stateRCtrl=D
				MsgBox test17 
			else if stateCapsl=D
				MsgBox test19 
			else
				;Send {left} ; if I use these, I get problems in Total Commander, were there is a difference 
				;send {right}
				send x 18  ;  available 
		return
		}

	SC056 & t:: ; page down
		{
		GetKeyState, stateLCtrl, LCtrl
		GetKeyState, stateLShift, LShift
		GetKeyState, stateLWin, LWin
		GetKeyState, stateLAlt, LAlt
		GetKeyState, stateRCtrl, RCtrl
		GetKeyState, stateRShift, RShift
		GetKeyState, stateRWin, RWin
		GetKeyState, stateRAlt, RAlt
		GetKeyState, stateSC056, SC056
		GetKeyState("SC056") 
		GetKeyState, stateCaps, CapsLock
		GetKeyState, stateScrollLock, ScrollLock
			if stateLCtrl=D
				if stateLShift=D
					if stateLWin=D
						if stateLAlt=D
							send ^!+#{PgDn} ; Ctrl + SHIFT + alt + Win +PgDn
						else
							Send ^+#{PgDn} ; Ctrl + SHIFT + Win +PgDn
					else if stateLAlt=D
						send ^!+{PgDn} ; Ctrl + SHIFT + alt +PgDn
					else
						Send ^+{PgDn}	; Ctrl + SHIFT +PgDn
				else if stateLWin=D
						if stateLAlt=D
							send ^+#{PgDn} ; Ctrl + shift + Win +PgDn
						else
							Send ^#{PgDn}	; Ctrl + win +PgDn
				else if stateLAlt=D
					if stateLWin=D
						send ^!#{PgDn} ; Ctrl + alt + win +PgDn
					else
						send ^!{PgDn} ; Ctrl + alt +PgDn
				else if stateLWin=D
						send ^#{PgDn} ; Ctrl + win +PgDn
				else
					Send ^{PgDn}	; CtrlPgDn
			else if stateLShift=D
					if stateLWin=D
						if stateLAlt=D
							send !+#{PgDn} ; SHIFT + alt + Win +PgDn
						else
							Send +#{PgDn} ; SHIFT + Win +PgDn
					else if stateLAlt=D
						send !+{PgDn} ; SHIFT + alt +PgDn
					else
						Send +{PgDn} ; SHIFT +PgDn
			else if stateLWin=D
					if stateLAlt=D
							send !#{PgDn} ; alt + Win +PgDn
					else
						Send #{PgDn} ; Win +PgDn
			else if stateLAlt=D
				Send !{PgDn} ; Alt +PgDn
			else if stateRCtrl=D
				MsgBox tester ; Alt +PgDn
			else
				Send {PgDn} ;PgDn
		return
		} 

	SC056 & c:: ; PgUp 
		{
		GetKeyState, stateLCtrl, LCtrl
		GetKeyState, stateLShift, LShift
		GetKeyState, stateLWin, LWin
		GetKeyState, stateLAlt, LAlt
		GetKeyState, stateRCtrl, RCtrl
		GetKeyState, stateRShift, RShift
		GetKeyState, stateRWin, RWin
		GetKeyState, stateRAlt, RAlt
		GetKeyState, stateSC056, SC056
		GetKeyState("SC056") 
		GetKeyState, stateCaps, CapsLock
		GetKeyState, stateScrollLock, ScrollLock
			if stateLCtrl=D
				if stateLShift=D
					if stateLWin=D
						if stateLAlt=D
							send ^!+#{PgUp} ; Ctrl + SHIFT + alt + Win + PgUp
						else
							Send ^+#{PgUp} ; Ctrl + SHIFT + Win + PgUp
					else if stateLAlt=D
						send ^!+{PgUp} ; Ctrl + SHIFT + alt + PgUp
					else
						Send ^+{PgUp}	; Ctrl + SHIFT + PgUp
				else if stateLWin=D
						if stateLAlt=D
							send ^+#{PgUp} ; Ctrl + shift + Win + PgUp
						else
							Send ^#{PgUp}	; Ctrl + win + PgUp
				else if stateLAlt=D
					if stateLWin=D
						send ^!#{PgUp} ; Ctrl + alt + win + PgUp
					else
						send ^!{PgUp} ; Ctrl + alt + PgUp
				else if stateLWin=D
						send ^#{PgUp} ; Ctrl + win + PgUp
				else
					Send ^{PgUp}	; Ctrl PgUp
			else if stateLShift=D
					if stateLWin=D
						if stateLAlt=D
							send !+#{PgUp} ; SHIFT + alt + Win + PgUp
						else
							Send +#{PgUp} ; SHIFT + Win + PgUp
					else if stateLAlt=D
						send !+{PgUp} ; SHIFT + alt + PgUp
					else
						Send +{PgUp} ; SHIFT + PgUp
			else if stateLWin=D
					if stateLAlt=D
							send !#{PgUp} ; alt + Win + PgUp
					else
						Send #{PgUp} ; Win + PgUp
			else if stateLAlt=D
				Send !{PgUp} ; Alt + PgUp
			else
				Send {PgUp} ; PgUp
		return
		}

	SC056 & n:: ; end 
		{
		GetKeyState, stateLCtrl, LCtrl
		GetKeyState, stateLShift, LShift
		GetKeyState, stateLWin, LWin
		GetKeyState, stateLAlt, LAlt
		GetKeyState, stateRCtrl, RCtrl
		GetKeyState, stateRShift, RShift
		GetKeyState, stateRWin, RWin
		GetKeyState, stateRAlt, RAlt
		GetKeyState, stateSC056, SC056
		GetKeyState("SC056") 
		GetKeyState, stateCaps, CapsLock
		GetKeyState, stateScrollLock, ScrollLock
			if stateLCtrl=D
				if stateLShift=D
					if stateLWin=D
						if stateLAlt=D
							send ^!+#{end} ; Ctrl + SHIFT + alt + Win + end
						else
							Send ^+#{end} ; Ctrl + SHIFT + Win + end
					else if stateLAlt=D
						send ^!+{end} ; Ctrl + SHIFT + alt + end
					else
						Send ^+{end}	; Ctrl + SHIFT + end
				else if stateLWin=D
						if stateLAlt=D
							send ^+#{end} ; Ctrl + shift + Win + end
						else
							Send ^#{end}	; Ctrl + win + end
				else if stateLAlt=D
					if stateLWin=D
						send ^!#{end} ; Ctrl + alt + win + end
					else
						send ^!{end} ; Ctrl + alt + end
				else if stateLWin=D
						send ^#{end} ; Ctrl + win + end
				else
					Send ^{end}	; Ctrl end
			else if stateLShift=D
					if stateLWin=D
						if stateLAlt=D
							send !+#{end} ; SHIFT + alt + Win + end
						else
							Send +#{end} ; SHIFT + Win + end
					else if stateLAlt=D
						send !+{end} ; SHIFT + alt + end
					else
						Send +{end} ; SHIFT + end
			else if stateLWin=D
					if stateLAlt=D
							send !#{end} ; alt + Win + end
					else
						Send #{end} ; Win + end
			else if stateLAlt=D
				Send !{end} ; Alt + end
			else
				Send {end} ; end
		return
		} 

	SC056 & h:: ; Home 
		{
		GetKeyState, stateLCtrl, LCtrl
		GetKeyState, stateLShift, LShift
		GetKeyState, stateLWin, LWin
		GetKeyState, stateLAlt, LAlt
		GetKeyState, stateRCtrl, RCtrl
		GetKeyState, stateRShift, RShift
		GetKeyState, stateRWin, RWin
		GetKeyState, stateRAlt, RAlt
		GetKeyState, stateSC056, SC056
		GetKeyState("SC056") 
		GetKeyState, stateCaps, CapsLock
		GetKeyState, stateScrollLock, ScrollLock
			if stateLCtrl=D
				if stateLShift=D
					if stateLWin=D
						if stateLAlt=D
							send ^!+#{home} ; Ctrl + SHIFT + alt + Win + home
						else
							Send ^+#{home} ; Ctrl + SHIFT + Win + home
					else if stateLAlt=D
						send ^!+{home} ; Ctrl + SHIFT + alt + home
					else
						Send ^+{home}	; Ctrl + SHIFT + home
				else if stateLWin=D
						if stateLAlt=D
							send ^+#{home} ; Ctrl + shift + Win + home
						else
							Send ^#{home}	; Ctrl + win + home
				else if stateLAlt=D
					if stateLWin=D
						send ^!#{home} ; Ctrl + alt + win + home
					else
						send ^!{home} ; Ctrl + alt + home
				else if stateLWin=D
						send ^#{home} ; Ctrl + win + home
				else
					Send ^{home}	; Ctrl home
			else if stateLShift=D
					if stateLWin=D
						if stateLAlt=D
							send !+#{home} ; SHIFT + alt + Win + home
						else
							Send +#{home} ; SHIFT + Win + home
					else if stateLAlt=D
						send !+{home} ; SHIFT + alt + home
					else
						Send +{home} ; SHIFT + home
			else if stateLWin=D
					if stateLAlt=D
							send !#{home} ; alt + Win + home
					else
						Send #{home} ; Win + home
			else if stateLAlt=D
				Send !{home} ; Alt + home
			else
				Send {home} ; home
		return
		}

	SC056 & å:: ; MediaMonkey Previous song 
		{		
		GetKeyState, stateLCtrl, 	LCtrl
		GetKeyState, stateLShift, 	LShift
		GetKeyState, stateLWin, 	LWin
		GetKeyState, stateLAlt, 	LAlt
		GetKeyState, stateRCtrl, 	RCtrl
		GetKeyState, stateRShift, 	RShift
		GetKeyState, stateRWin, 	RWin
		GetKeyState, stateRAlt, 	RAlt
		GetKeyState, stateSC056, 	SC056
		;GetKeyState, stateCaps, 	CapsLock ;seems to be something wrong here (at least when using MediaMonkey)
		GetKeyState, stateScroll, 	ScrollLock
		if stateCtrl=D
			if stateShift=D
				if stateWin=D
					if stateAlt=D
						send ^!+#. 
					else
						Send ^+#. 
				else if stateAlt=D
					send ^!+. 
				else
					Send ^+.	
			else if stateWin=D
					if stateAlt=D
						send ^+#. 
					else
						Send ^#.	
			else if stateAlt=D
				if stateWin=D
					send ^!#. 
				else
					send ^!. 
			else if stateWin=D
					send ^#. 
			else
				send #!a{Media_Next}
		else if stateShift=D
				if stateWin=D
					if stateAlt=D
						send !+#. 
					else
						Send +#. 
				else if stateAlt=D
					send !+. 
				else
					Send +. 
		else if stateWin=D
				if stateAlt=D
						send !#. 
				else
					Send #. 
		else if stateAlt=D
				send #!a{Media_Next}			
		else
			send ^!+#h

		return
		}

	SC056 & ö:: ; MediaMonkey next song 
		{
		GetKeyState, stateLCtrl, 	LCtrl
		GetKeyState, stateLShift, 	LShift
		GetKeyState, stateLWin, 	LWin
		GetKeyState, stateLAlt, 	LAlt
		GetKeyState, stateRCtrl, 	RCtrl
		GetKeyState, stateRShift, 	RShift
		GetKeyState, stateRWin, 	RWin
		GetKeyState, stateRAlt, 	RAlt
		GetKeyState, stateSC056, 	SC056
		;GetKeyState, stateCaps, 	CapsLock
		GetKeyState, stateScroll, 	ScrollLock
		if stateCtrl=D
			if stateShift=D
				if stateWin=D
					if stateAlt=D
						send ^!+#q 
					else
						Send ^+#q 
				else if stateAlt=D
					send ^!+q 
				else
					Send ^+q	
			else if stateWin=D
					if stateAlt=D
						send ^+#q 
					else
						Send ^#q	
			else if stateAlt=D
				if stateWin=D
					send ^!#q 
				else
					send ^!q 
			else if stateWin=D
					send ^#q 
			else
				Send ^q	; Ctrl enter
		else if stateShift=D
				if stateWin=D
					if stateAlt=D
						send !+#q 
					else
						Send +#q 
				else if stateAlt=D
					send !+q 
				else
					Send +q 
		else if stateWin=D
				if stateAlt=D
						send !#q 
				else
					Send #q 
		else if stateAlt=D
				send #!a{Media_Next} 
				;Send !q 
		else
				send ^!+#n

		return 
		} 


	SC056 & .:: ; MediaMonkey skip 5 seconds backwards 

		{
		/*

	Themes
		""	
		^	
		+	reverse 
		#	
		!	
		
		Add comments here using "ncmtli9" (performs ^d, li9, ncmth)
		*/ 

		GetKeyState, stateLCtrl, LCtrl
		GetKeyState, stateLAlt, LAlt
		GetKeyState, stateLShift, LShift
		GetKeyState, stateLWin, LWin
		GetKeyState, stateRCtrl, RCtrl
		GetKeyState, stateRAlt, RAlt
		GetKeyState, stateRShift, RShift
		GetKeyState, stateRWin, RWin
		GetKeyState, stateScrollLock, ScrollLock
		if stateLCtrl=D
			if stateLAlt=D
				if stateLShift=D
					if stateLWin=D ; ^!+#{x} 
						sendraw ^!+#{x} 
					else ; ^!+{x} 
						sendraw ^!+{x} 
				else if stateLWin=D ; ^!#{x} 
					sendraw ^!#{x} 
				else ; ^!{x}
					sendraw ^!{x}
			else if stateLShift=D
				if stateLWin=D ; ^+#{x} 
					sendraw ^+#{x} 
				else ; ^+{x}
					sendraw ^+{x}
			else if stateLWin=D ; ^#{x} 
				sendraw ^#{x} 
			else ; ^{x}
				sendraw ^{x}

		else if stateLAlt=D
				if stateLShift=D
					if stateLWin=D ; !+#{x} 
						sendraw !+#{x} 
					else ; !+{x} 
						sendraw !+{x} 
				else if stateLWin=D ; !#{x} 
					sendraw !#{x} 
				else ; !{x}
					sendraw !{x}
			else if stateLShift=D
				if stateLWin=D ; +#{x} 
					sendraw +#{x} 
				else ; +{x} 
					sendraw +{x}
			else if stateLWin=D ; #{x} 
				; There is an issue with § and # alone. 
				; 2017-06-01 might not be a problem when pressing § first 
				; 2016-06-30 have tried to fix it but given up for now, avoid it for now 
				sendraw #{x} 
			else ; {x} 
				send ^+#.
		return 
		}

	SC056 & q:: ; MediaMonkey skip 5 seconds forward 
		{
		GetKeyState, stateLCtrl, 	LCtrl
		GetKeyState, stateLShift, 	LShift
		GetKeyState, stateLWin, 	LWin
		GetKeyState, stateLAlt, 	LAlt
		GetKeyState, stateRCtrl, 	RCtrl
		GetKeyState, stateRShift, 	RShift
		GetKeyState, stateRWin, 	RWin
		GetKeyState, stateRAlt, 	RAlt
		GetKeyState, stateSC056, 	SC056
		;GetKeyState, stateCaps, 	CapsLock
		GetKeyState, stateScroll, 	ScrollLock
		if stateCtrl=D
			if stateShift=D
				if stateWin=D
					if stateAlt=D
						send ^!+#q 
					else
						Send ^+#q 
				else if stateAlt=D
					send ^!+q 
				else
					Send ^+q	
			else if stateWin=D
					if stateAlt=D
						send ^+#q 
					else
						Send ^#q	
			else if stateAlt=D
				if stateWin=D
					send ^!#q 
				else
					send ^!q 
			else if stateWin=D
					send ^#q 
			else
				Send ^q	; Ctrl enter
		else if stateShift=D
				if stateWin=D
					if stateAlt=D
						send !+#q 
					else
						Send +#q 
				else if stateAlt=D
					send !+q 
				else
					Send +q 
		else if stateWin=D
				if stateAlt=D
						send !#q 
				else
					Send #q 
		else if stateAlt=D
				send #!a{Media_Next} 
		else
			send ^+#q
		return 
		} 


	SC056 & w:: ; available 
		{
		GetKeyState, stateLCtrl, LCtrl
		GetKeyState, stateLShift, LShift
		GetKeyState, stateLWin, LWin
		GetKeyState, stateLAlt, LAlt
		GetKeyState, stateRCtrl, RCtrl
		GetKeyState, stateRShift, RShift
		GetKeyState, stateRWin, RWin
		GetKeyState, stateRAlt, RAlt
		GetKeyState, stateCapsl, CapsLock
		if stateLCtrl=D
				if stateLShift=D
					if stateLWin=D
						if stateLAlt=D
							send x1   
						else
							send x2   
					else if stateLAlt=D
						send x3  
					else
						send x4	
				else if stateLWin=D
						if stateLAlt=D
							send x5  
						else
							send x6	
				else if stateLAlt=D
					if stateLWin=D
						send x7  
					else
						send x8 
				else if stateLWin=D
						send x9 
				else
					send x10	 
			else if stateLShift=D
					if stateLWin=D
						if stateLAlt=D
							send x10 ; SHIFT + alt + Win +  available 
						else
							send x11 ; SHIFT + Win +  available 
					else if stateLAlt=D
						send x12 ; SHIFT + alt +  available 
					else
						send x13 ; SHIFT +  available 
			else if stateLWin=D
					if stateLAlt=D
							send x14 ; alt + Win +  available 
					else
						send x15 ; Win +  available 
			else if stateLAlt=D
				send x16 ; Alt +  available 
			else if stateRCtrl=D
				send test17 
			else
				;Send {left} ; if I use these, I get problems in Total Commander, were there is a difference 
				;send {right}
				send x 18  ;  available 
		return
		}

	}
		;########### END SC056 commands ##############

	{	;##############  § commands ##############


	; 2017-12-14 17.46 	commented out this (was not used as it existed " §::§ " prior to this 
	; 2015-03-01 10.12 	I think this was causing problems 
	; 2017-03-13 			has worked without problems for quite some time 



	; § & 1:: ; see § & w
	§ & 2::
		/*

		-	change always on top 
		+	available  
		+#	available  
		*/ 
		{
		GetKeyState, stateLCtrl, LCtrl
		GetKeyState, stateLAlt, LAlt
		GetKeyState, stateLShift, LShift
		GetKeyState, stateLWin, LWin
		GetKeyState, stateRCtrl, RCtrl
		GetKeyState, stateRAlt, RAlt
		GetKeyState, stateRShift, RShift
		GetKeyState, stateRWin, RWin
		GetKeyState, stateScrollLock, ScrollLock
		if stateLCtrl=D
			if stateLAlt=D
				if stateLShift=D
					if stateLWin=D ; ^!+#{x} 
						sendraw ^!+#{x} 
					else ; ^!+{x} 
						sendraw ^!+{x} 
				else if stateLWin=D ; ^!#{x} 
					sendraw ^!#{x} 
				else ; ^!{x}
					sendraw ^!{x}
			else if stateLShift=D
				if stateLWin=D ; ^+#{x} 
					sendraw ^+#{x} 
				else ; ^+{x}
					sendraw ^+{x}
			else if stateLWin=D ; ^#{x} 
				sendraw ^#{x} 
			else ; ^{x}
				sendraw ^{x}

		else if stateLAlt=D
				if stateLShift=D
					if stateLWin=D ; !+#{x} 
						sendraw !+#{x} 
					else ; !+{x} 
						sendraw !+{x} 
				else if stateLWin=D ; !#{x} 
					sendraw !#{x} 
				else ; !{x}
					sendraw !{x}
			else if stateLShift=D
				if stateLWin=D ; +#{x} 
					sendraw +#{x} 
				else ; +{x} 
					sendraw +{x}
			else if stateLWin=D ; #{x} ; there is an issue with § and # alone (but all other combinations seem fine, possibly due to differences in how # behaviors compared to other modifiers). 
				; 2016-06-30 have tried to fix it but given up for now, avoid it for now 
				sendraw #{x} 
			else ; {x} 
				Winset, Alwaysontop, , A ; make window always on top (toggles)
		return 
		}


	§ & 3::WinSet, Transparent, Off, A ; turn off window transparrent 
	§ & 4::WinSet, Transparent, 200, A ; make any window transparrent 
	§ & 5::WinSet, Transparent, 100, A ; make any window transparrent 
	§ & 6::WinSet, TransColor, White, A ; 
	;§ & 6::WinSet, Region, 50-0 W200 H250, WinTitle  ; Make all parts of the window outside this rectangle invisible.
	; § & 7:: used for ahkClipboard1
		; previously 
		; WinSet, Region,, WinTitle ; Restore the window to its original/default display area.

	§ & 8:: ; ClipboardReplace combination (yy: expand this section) 
	{
	GetKeyState, stateLCtrl, LCtrl
	GetKeyState, stateLAlt, LAlt
	GetKeyState, stateLShift, LShift
	GetKeyState, stateLWin, LWin
	GetKeyState, stateRCtrl, RCtrl
	GetKeyState, stateRAlt, RAlt
	GetKeyState, stateRShift, RShift
	GetKeyState, stateRWin, RWin
	GetKeyState, stateScrollLock, ScrollLock

	if stateLCtrl=D
		if stateLAlt=D
			if stateLShift=D
				if stateLWin=D ; ^!+#{x} 
					send ^!+#{x} 
				else ; ^!+{x} 
					send ^!+{x} 
			else if stateLWin=D ; ^!#{x} 
				send ^!#{x} 
			else ; ^!{x}
				send ^!{x}
		else if stateLShift=D
			if stateLWin=D ; ^+#{x} 
				send ^+#{x} 
			else ; ^+{x}
				send ^+{x}
		else if stateLWin=D ; ^#{x} 
			send ^#{x} 
		else ; ^{x}
			send ^{x}

	else if stateLAlt=D
			if stateLShift=D
				if stateLWin=D ; !+#{x} 
					send !+#{x} 
				else ; !+{x} 
					send !+{x} 
			else if stateLWin=D ; !#{x} 
				send !#{x} 
			else ; !{x}
				send !{x}
		else if stateLShift=D
			if stateLWin=D ; +#{x} 
				send +#{x} 
			else ; +{x} 
				{
				sleep 100
				Cbreplm() 
				sleep 50
				; send !x
				send !f 
				}
		else if stateLWin=D ; #{x} ; there is an issue with § and # alone (but all other combinations seem fine, possibly due to differences in how # behaviors compared to other modifiers). 
			; 2016-06-30 have tried to fix it but given up for now, avoid it for now 
			send #{x} 
		else ; {x} 
			{
			send ^c
			sleep 100
			Cbreplm() 
			sleep 50
			send !f 
			}

	return 
	}
	; § & 9:: available 

	; Backup Global
	:*:bu9::
	:*:bau9::
	§ & f1:: ; left handed backup method 
	§ & s:: ; save backup 

		/*
		2018-04-17 13.56
			updated for Visual Studio Code 
		2018-01-08 11.35
			yyyyyyy TO BE DONE Change Visual Studio 2017 Settings (f12 open save as menu) to work with below 
		*/
	
		{
		sleep 50 
		ahkBackupGlobal()
		sleep 2260  
			If WinActive("ahk_class XLMAIN") OR WinActive("ahk_class PPTFrameClass") OR WinActive("ahk_exe Code.exe") 
				ahkSaveAgainWithY()
			else
				ahkSaveAgainWithEnter()
			return 
		}
		return 

	; § & a:: ; program specific (avoid using here) 

	§ & c:: ; VSCode specific (global) 
	{
	GetKeyState, stateLCtrl, LCtrl
	GetKeyState, stateLAlt, LAlt
	GetKeyState, stateLShift, LShift
	GetKeyState, stateLWin, LWin
	GetKeyState, stateRCtrl, RCtrl
	GetKeyState, stateRAlt, RAlt
	GetKeyState, stateRShift, RShift
	GetKeyState, stateRWin, RWin
	GetKeyState, stateScrollLock, ScrollLock

	if stateLCtrl=D
		if stateLAlt=D
			if stateLShift=D
				if stateLWin=D
					; sendraw ^!+#{x} 
					sendraw ^!+#{x} 
				else
					; sendraw ^!+{x} 
					sendraw ^!+{x} 
			else if stateLWin=D
				; sendraw ^!#{x} 
				sendraw ^!#{x} 
			else
				; sendraw ^!{x}
				sendraw ^!{x}
		else if stateLShift=D
			if stateLWin=D
				; sendraw ^+#{x} 
				sendraw ^+#{x} 
			else
				; sendraw ^+{x}
				sendraw ^+{x}
		else if stateLWin=D
			; sendraw ^#{x} 
			sendraw ^#{x} 
		else
			; sendraw ^{x}
			CtrTabph()

	else if stateLAlt=D
			if stateLShift=D
				if stateLWin=D 
					; sendraw !+#{x} 
					sendraw !+#{x} 
				else
					; sendraw !+{x} 
					Open4nppNewp()
			else if stateLWin=D
				; sendraw !#{x} 
				Open4nppNewp() ; there is an issue with § and # (also together with ! , possibly due to differences in how # behaviors compared to other modifiers)
			else
				; sendraw !{x}
				Open4nppAndPasteHere()
		else if stateLShift=D
			if stateLWin=D
				; sendraw +#{x} 
				sendraw +#{x} 
			else
				; sendraw +{x} 
				AltTabph() 
		else if stateLWin=D
			; sendraw #{x} ; there is an issue with § and # (also together with ! , possibly due to differences in how # behaviors compared to other modifiers)
			Open4nppNewp()
		else
			send {numpad8} 
	return 
	}

	§ & d:: ; Available 
	§ & f:: ; Available
	return 

	§ & g::
	{
	GetKeyState, stateLCtrl, LCtrl
	GetKeyState, stateLAlt, LAlt
	GetKeyState, stateLShift, LShift
	GetKeyState, stateLWin, LWin
	GetKeyState, stateRCtrl, RCtrl
	GetKeyState, stateRAlt, RAlt
	GetKeyState, stateRShift, RShift
	GetKeyState, stateRWin, RWin
	GetKeyState, stateScrollLock, ScrollLock

	if stateLCtrl=D
		if stateLAlt=D
			if stateLShift=D
				if stateLWin=D ; ^!+#{click} 
					send ^!+#{click} 
				else ; ^!+{click} 
					send ^!+{click} 
			else if stateLWin=D ; ^!#{click} 
				send ^!#{click} 
			else ; ^!{click}
				send ^!{click}
		else if stateLShift=D
			if stateLWin=D ; ^+#{click} 
				send ^+#{click} 
			else ; ^+{click}
				send ^+{click}
		else if stateLWin=D ; ^#{click} 
			send ^#{click} 
		else ; ^{click}
			send ^{click} 

	else if stateLAlt=D
			if stateLShift=D
				if stateLWin=D ; !+#{click} 
					send !+#{click} 
				else ; !+{click} 
					send !+{click} 
			else if stateLWin=D ; !#{click} 
				send !#{click} 
			else ; !{click}
				send !{click} 
		else if stateLShift=D
			if stateLWin=D ; +#{click} 
				send +#{click} 
			else ; +{click} 
				{
				send {LShift Down}
				CLICK 
				send {LShift up}
				return 
				}
		else if stateLWin=D ; #{click} ; there is an issue with § and # alone (but all other combinations seem fine, possibly due to differences in how # behaviors compared to other modifiers)
			send #{click} ; there is an issue with § and # alone (but all other combinations seem fine, possibly due to differences in how # behaviors compared to other modifiers)
		else ; {x} 
			Click
	return 
	}

	§ & h::
	{	
		GetKeyState, stateLCtrl, LCtrl
		GetKeyState, stateLShift, LShift
		GetKeyState, stateLWin, LWin
		GetKeyState, stateLAlt, LAlt
		GetKeyState, stateRCtrl, RCtrl
		GetKeyState, stateRShift, RShift
		GetKeyState, stateRWin, RWin
		GetKeyState, stateRAlt, RAlt
									
			if stateLCtrl=D
				if stateLShift=D
					if stateLWin=D
						if stateLAlt=D
							send x
						else
							send x
					else if stateLAlt=D
						send x
					else
						send x
				else if stateLWin=D
						if stateLAlt=D
							send x
						else
							send x
				else if stateLAlt=D
					if stateLWin=D
						send x
					else
						send x
				else if stateLWin=D
						send x
				else
					send x
			else if stateLShift=D
					if stateLWin=D
						if stateLAlt=D
							send x
						else
							send x
					else if stateLAlt=D
						send x
					else
						send #{NumPad4}
			else if stateLWin=D
					if stateLAlt=D
							send x
					else
						send #{NumPad4}
			else if stateLAlt=D
				send x
			else
				send {NumPad4}
		return
	}  

	§ & n::
		; ! is used to rotate images to the right 
		{
		GetKeyState, stateLCtrl, LCtrl
		GetKeyState, stateLAlt, LAlt
		GetKeyState, stateLShift, LShift
		GetKeyState, stateLWin, LWin
		GetKeyState, stateRCtrl, RCtrl
		GetKeyState, stateRAlt, RAlt
		GetKeyState, stateRShift, RShift
		GetKeyState, stateRWin, RWin
		GetKeyState, stateScrollLock, ScrollLock

		if stateLCtrl=D
			if stateLAlt=D
				if stateLShift=D
					if stateLWin=D ; ^!+#{x} 
						sendraw ^!+#{x} 
					else ; ^!+{x} 
						sendraw ^!+{x} 
				else if stateLWin=D ; ^!#{x} 
					sendraw ^!#{x} 
				else ; ^!{x}
					sendraw ^!{x}
			else if stateLShift=D
				if stateLWin=D ; ^+#{x} 
					sendraw ^+#{x} 
				else ; ^+{x}
					sendraw ^+{x}
			else if stateLWin=D ; ^#{x} 
				sendraw ^#{x} 
			else ; ^{x}
				sendraw ^{x}

		else if stateLAlt=D
				if stateLShift=D
					if stateLWin=D ; !+#{x} 
						sendraw !+#{x} 
					else ; !+{x} 
						sendraw !+{x} 
				else if stateLWin=D ; !#{x} 
					sendraw !#{x} 
				else ; !{x}
					sendraw !{x}
			else if stateLShift=D
				if stateLWin=D ; +#{x} 
					sendraw +#{x} 
				else ; +{x} 
					sendraw +{x}
			else if stateLWin=D ; #{x} ; there is an issue with § and # alone (but all other combinations seem fine, possibly due to differences in how # behaviors compared to other modifiers). 
				; 2016-06-30 have tried to fix it but given up for now, avoid it for now 
				sendraw #{x} 
			else ; {x} 
				send {numpad6}  
		return 
		}

	§ & r:: click right
	§ & t::send {numpad2}  

	; change power plans shortkey on Surface Pro, [source: http://lifehacker.com/5857286/change-windows-power-plans-with-a-keyboard-shortcut (powercfg -l)] 
	; 2015-03-01 10.11 it is very rare that I switch from the standard, and I don't think that it is worth it
	; § & p::Run, powercfg -s 5de8ca9f-7de8-4e1b-8492-e2b49c22d9ec
	; § & y::Run, powercfg -s 134bebd5-7d7e-427d-8599-973b05aa6b98
	; § & f::Run, powercfg -s 381b4222-f694-41f0-9685-ff5bb260df2e

	§ & v::
	{
	GetKeyState, stateLCtrl, LCtrl
	GetKeyState, stateLAlt, LAlt
	GetKeyState, stateLShift, LShift
	GetKeyState, stateLWin, LWin
	GetKeyState, stateRCtrl, RCtrl
	GetKeyState, stateRAlt, RAlt
	GetKeyState, stateRShift, RShift
	GetKeyState, stateRWin, RWin
	GetKeyState, stateScrollLock, ScrollLock

	if stateLCtrl=D
		if stateLAlt=D
			if stateLShift=D
				if stateLWin=D
					; sendraw ^!+#{x} 
					sendraw ^!+#{x} 
				else
					; sendraw ^!+{x} 
					sendraw ^!+{x} 
			else if stateLWin=D
				; sendraw ^!#{x} 
				sendraw ^!#{x} 
			else
				; sendraw ^!{x}
				sendraw ^!{x}
		else if stateLShift=D
			if stateLWin=D
				; sendraw ^+#{x} 
				sendraw ^+#{x} 
			else
				; sendraw ^+{x}
				sendraw ^+{x}
		else if stateLWin=D
			; sendraw ^#{x} 
			sendraw ^#{x} 
		else
			; sendraw ^{x}
			sendraw ^{x}

	else if stateLAlt=D
			if stateLShift=D
				if stateLWin=D
					; sendraw !+#{x} 
					sendraw !+#{x} 
				else
					; sendraw !+{x} 
					sendraw !+{x} 
			else if stateLWin=D
				; sendraw !#{x} 
				sendraw !#{x} 
			else
				; sendraw !{x}
				sendraw !{x}
		else if stateLShift=D
			if stateLWin=D
				; sendraw +#{x} 
				sendraw +#{x} 
			else
				; sendraw +{x} 
				AltTabph() 
		else if stateLWin=D
			; sendraw #{x} ; there is an issue with § and # alone (but all other combinations seem fine, possibly due to differences in how # behaviors compared to other modifiers)
			sendraw #{x} ; there is an issue with § and # alone (but all other combinations seem fine, possibly due to differences in how # behaviors compared to other modifiers)
		else
			; sendraw {x} 
			sendraw {x} 
	return 
	}
	
	; copy paste (right- and left-handed)
	§ & 1:: 
	§ & w:: 
		{
			/*
			Copy and paste (§ & w) is template for 
				cut and paste (capslock & 1)
			When updating either, make sure both are updated 
			
			2017-10-17 17.34
				updated comment next time GetKeyState below 
			2017-09-25 11.16
				copied and pasted this as template for cut and paste using capslock & 1 
			2017-06-17 08.49
				merged § 1 and § w 
			2017-05-19 11.25
				added xahkrmvmepc()
			2017-05-18 11.06
				updated everything 
			*/

		GetKeyState, stateLCtrl, LCtrl 		; Add enter after pasting 
		GetKeyState, stateLAlt, LAlt		; replace enter with ", "
		GetKeyState, stateLShift, LShift	; alt tab back 
		GetKeyState, stateLWin, LWin		; make one line removing special characters molw molcb 
		GetKeyState, stateRCtrl, RCtrl		; 
		GetKeyState, stateRAlt, RAlt		; 
		GetKeyState, stateRShift, RShift	; 
		GetKeyState, stateRWin, RWin		; 

		if stateLCtrl=D ; Includes enter after pasting 
			if stateLAlt=D
				if stateLShift=D
					if stateLWin=D
						; sendraw ^!+#{x} 
						sendraw ^!+#{x} 
					else
						; sendraw ^!+{x} 
						sendraw ^!+{x} 
				else if stateLWin=D
					; sendraw ^!#{x} 
					{
					CopySelected() 
					AltTabph()
					sleep 100 
					send {down}
					}
				else
					; sendraw ^!{x}
					{
					CopySelectedAltTabPasteAltTab()
					}
			else if stateLShift=D
				if stateLWin=D
					; sendraw ^+#{x} 
					{
					CopySelected() 
					AltTabf()
					xahkmosclpcb()
					send {enter}
					sleep 50 
					AltTabf()
					}

				else
					; sendraw ^+{x}
					{
					CopySelected() 
					AltTabph() 
					sleep 100 
					send {enter}
					sleep 50 
					AltTabf()
					}

			else if stateLWin=D
				; sendraw ^#{x} 
				{
				CopySelected() 
				AltTabf()
				xahkmosclpcb()
				send {enter}
				}
			else
				; sendraw ^{x}
				{
				CopySelected() 
				AltTabph() 
				sleep 100 
				send {enter}
				sleep 50 
				; AltTabf()
				}

		else if stateLAlt=D 
				if stateLShift=D
					if stateLWin=D 
						; sendraw !+#{x} 
						sendraw !+#{x} 
					else
						; sendraw !+{x} 
						{
						CopySelected() 
						sleep 50 
						AltTabf()
						xahkrmvmoepc()
						AltTabf()
						}
				else if stateLWin=D
					; sendraw !#{x} 
					Open4nppNewp() ; there is an issue with § and # (also together with ! , possibly due to differences in how # behaviors compared to other modifiers)
				else
					; sendraw !{x}
					{
					CopySelected() 
					sleep 50 
					AltTabf()
					xahkrmvmoepc()
					}

			else if stateLShift=D
				if stateLWin=D
					; sendraw +#{x} 
					{
					CopySelected() 
					AltTabf()
					xahkmosclpcb()
					AltTabf()
					}

				else
					; sendraw +{x} 
					{
					CopySelected() 
					AltTabph() 
					AltTabf()
					}
			else if stateLWin=D
				; sendraw #{x} ; there is an issue with § and # (also together with ! , possibly due to differences in how # behaviors compared to other modifiers)
					{
					CopySelected() 
					AltTabf()
					xahkmosclpcb()
					}
			else
				{
				CopySelected() 
				AltTabph()
				}
		return 

		}


	}
		;########### END § commands ##############

	{	;##############  ^ commands  



	}
		;############End ^ commands  

	{	;##############  +[0-9] commands  

	return 


	}
		;############End +[0-9] commands  

	{	;##############  !# commands  

	; !#0::
	; !#1::
	; !#2::
	; !#3::
	; !#4::
	; !#5::
	; !#6::
	; !#7::
	; !#8::
	; !#9::

	!#a::
		sleep 300 
		send ^c
		FocusChromeNewTab()
		sleep 100 
		send 4am
		PerformChromeAdressbarSearch()
		return 

	; !#b:: taken by Breevy 

	!#c::
		sleep 300 
		send ^c
		FocusChromeNewTab()
		sleep 100 
		send 4amde
		PerformChromeAdressbarSearch()
		return 

	!#d::
		sleep 300 
		send ^c
		FocusChromeNewTab()
		sleep 100 
		send define
		PerformChromeAdressbarSearch()
		return 

	!#f:: ; Perform search select word (based on Caret, like capslock & !f (capslock!f)
	/*

	2018-04-07 12.03
		created this (changed from searching Filmtipset) 
	*/
	; yyy working here 

	SearchWordAtCaret()
	return 

	SearchWordAtCaret(){
		sleep 100 
		DoubleClickAtCaret()
		sleep 300 
		send ^c
		SearchClipboardHere()
		return 
		}

	SearchClipboardHere(){
			sleep 1100 
			send ^f
			sleep 1100 
			send ^v
			sleep 100 
			send {enter} 
			sleep 100 
			return 
			}


	!#g::
		sleep 300 
		send ^c
		FocusChromeNewTab()
		sleep 100 
		PerformChromeAdressbarSearch()
		return 

	!#i::
		sleep 300 
		send ^c
		FocusChromeNewTab()
		sleep 100 
		send imdb
		PerformChromeAdressbarSearch()
		return 

	; !#j::
	; !#k::
	; !#l::
	; !#m::
	!#n:: ; wiktionary 

		sleep 300 
		send ^c
		FocusChromeNewTab()
		sleep 100 
		send 4wn
		PerformChromeAdressbarSearch()
		return 

	!#o::
		sleep 300 
		send ^c
		FocusChromeNewTab()
		sleep 100 
		send 4wb
		PerformChromeAdressbarSearch()
		return 

	!#p::
		sleep 300 
		send ^c
		FocusChromeNewTab()
		sleep 100 
		sendraw filetype:PDF
		send {left}
		send {right}
		sleep 100 
		PerformChromeAdressbarSearch()
		return 

	; !#q::

	!#r::
		sleep 300 
		send ^c
		FocusChromeNewTab()
		sleep 100 
		send review 
		send {space}
		PerformChromeAdressbarSearch()
		return 

	!#s:: ; svenska wiktionary 
		sleep 300 
		send ^c
		FocusChromeNewTab()
		sleep 100 
		send 4swn
		PerformChromeAdressbarSearch()
		return 

	!#t:: ; translate from [detected] to English 
		sleep 300 
		send ^c
		FocusChromeNewTab()
		sleep 100 
		send xngtc
		; PerformChromeAdressbarSearch()
		return 

	!#u::
		sleep 300 
		send ^c
		FocusChromeNewTab()
		sleep 100 
		send 4amu
		PerformChromeAdressbarSearch()
		return 

	!#v:: ; Swedish Wikipedia (svenska) 
		sleep 300 
		send ^c
		FocusChromeNewTab()
		sleep 100 
		send 4sw
		PerformChromeAdressbarSearch()
		return 

	!#w:: ; Wikipedia 
		sleep 300 
		send ^c
		sleep 300 
		FocusChromeNewTab()
		sleep 100 
		send 4w
		PerformChromeAdressbarSearch()
		return 

	; !#x::
	!#y::
		sleep 300 
		send ^c
		FocusChromeNewTab()
		sleep 100 
		send 4ut
		PerformChromeAdressbarSearch()
		return 

	; !#Z::
	; !#å::
	; !#ä::
	; !#ö::

		; sleep 300 
		; send ^c
		; FocusChromeNewTab()
		; sleep 100 
		; send 4w
		; PerformChromeAdressbarSearch()
		; return 

	}
		;############End !# commands  

	{	;##############  AltGr commands  
	/*
	avoid altgr
	Should not use template system for AltGr 


	2017-10-12 13.36
		created this due to issue with "altgr+g --> ?" in svorak05 not sending "?" in Chrome, need to evaluate if this workaround works 
	*/
	
	; <^>!d:: send * // 2017-12-22 13.29 this causes issues with # in Breevy 
	; <^>!t:: 
		; sendraw * ; 2018-02-26 17.26 this is causing StuckKey issues 
			; This caused a lot of problems, found no solution other than removing it 
		; StuckKeyUp()
		; return 
	<^>!v:: send {volume_Up}
	<^>!z:: send {volume_Down}
	<^>!h:: send {esc} ; useful for many 
	; <^>!h::send <-{space} ; useful for R assignment 

	
	; <^>!g:: ; none of the following works for getting ? to send the correct "?" in StackOverflow 
		; sleep 300
		; sendraw ?
		; sleep 100
		; send ?
		; sleep 100
		; send +{SC00C}
		; sleep 100
		; return

	; <^>!m:: ; in order for this to work I have to keep pressing altgr until it is over (no idea why)
		; {
		; sleep 100 
		; Send {space}
		; Send % Chr(0x0025) ;using unicode ("u+0025")
		; Send % Chr(0x003E)
		; Send % Chr(0x0025)
		; Send % Chr(0x0023)
		; Send % Chr(0x0023)
		; send {space}{enter}
		; ;SendInput {LShift up}{RShift up}{LCtrl up}{RCtrl up}{LWin up}{RWin up} ; had issues with key stuck, this does not solve it 
		; return 
		; }
		
	; <^>!down::Send {PgDn} 
	; <^>!up::Send {PgUp}
			

	}
		;############End altgr commands  

;##############  Rest 
	
	{	;##############  Regular expression  
		;program specific first, then by category, various at end 
		; Should not be further developed - ClipboardReplace is a better implementation of this for everything that is not very simple

		{	;##############  Sort related  ##############
		; everything sorting related 

		{	;##############  reverse sort order  ##############

		:*:xmrsortec:: ; reverse sort order based on enter
		:*:xrsortec:: 
			xahkmrsortecb() 
				sleep 100
				send ^v
				sleep 100
				return 

			xahkmrsortecb()
				{
					result := Clipboard
					Sort, result, F ReverseDirection D`n	; 	D`n = use "`n" as delimiter
					Clipboard =
					Clipboard := result
					ClipWait
					send {<# up} 
					return
				}

		:*:xmrsortcc:: ; reverse sort order based on comma 
		:*:xrsortcc:: 
			ahkmrsortccb() 
				sleep 100
				send ^v
				sleep 100
				return 

			ahkmrsortccb()
				{
					result := Clipboard
					Sort, result, F ReverseDirection D,	; 	D, = use "," as delimiter
					Clipboard =
					Clipboard := result
					ClipWait
					send {<# up} 
					return
				}
				
		}
			;############End reverse sort order  ############## 
		}
			;############End Sort related  ############## 

		{	;##############  Template LARGE RegEx replace regular expressions 
		; This is RegEx replace template for making future advanced RegEx replace 
		; if command initiation is commented out it causes issues when reloading the AutoHotkey script (it runs every time AutoHotkey is reloaded 

		; template below is from 2016-06-19 
		; copy starting directly below here 	

		:*:thisshouldneverbecommentedout::
			;RegEx replace (. with (0.
				haystack := Clipboard
				needle := "\(\."
				replacement := "(0."
				result01 := RegExReplace(haystack, needle, replacement)
			;RegEx replace (0. with (0%
				needle := "\(0\.\%"
				replacement := "(0%"
				result02 := RegExReplace(result01, needle, replacement)
			;RegEx replace ([0-9]) with ([0-9.0])
				needle := "(\([0-9])\)"
				replacement := "$1.0)"
				result03 := RegExReplace(result02, needle, replacement)
			;RegEx replace (.[0-9]) with (0.[0-9.0])
				needle := "\(\.([0-9]{1,})"
				replacement := "(0.$1)"
				result04 := RegExReplace(result03, needle, replacement)
			;RegEx replace " .[0-9])" with ( .[0-9.0])
				needle := "([\-\s])(\.[0-9]{1,})"
				replacement := "$10$2"
				result05 := RegExReplace(result04, needle, replacement)
			;RegEx replace ^.[0-9] with 0.[0-9
				needle := "(^\.[0-9]{1,})"
				replacement := "0$1"
				result06 := RegExReplace(result05, needle, replacement)
			;RegEx replace " .[0-9]" with 0.[0-9]  
				needle := "([\s]{1,})\.([0-9]{1,})"
				replacement := "$10.$2"
				result := RegExReplace(result06, needle, replacement)
				Clipboard =
				Clipboard := result
				ClipWait
				sleep 100
			send ^v
			sleep 100 
				send {<# up} ; solved some issues 
			return

		; copy ending directly above here 	

		}
			;############End Template LARGE RegEx replace regular expressions 

		{	;##############  Breevy specific RegEx ##############

		{	;##############  functions specific to Breevy  ##############

		BreevyPause(){
			; 2016-03-28 17.18 since Breevy expands special characters as if they were normal characters, it is best to inactivate Breevy when sendig long strings of text 

				sleep 300 ; 
					; 2016-02-09 14.41 had issues when using "4scb", which launched Breevy (^space) for unknown reason, changing this had no impact, it appears to be an issue with AutoHotkey sending (^space), and changing the Breevy hotkey "^space" removed the issue.
				send !{f10} 
				sleep 300
			}


		}

			;############End functions specific to Breevy  ############## 

		{	;##############  SMALL RegEx replace regular expressions #############
		; 2015-11-18 13.31 starting now I will add new small regular expressions here directly for simplicity
			; :*:xrcamelsc::
			; :*:xcamelsc::
				haystack := Clipboard
				needle := "(^|[\s+][a-z])" ; works  
				replacement := "$U1"
				result := RegExReplace(haystack, needle, replacement)
				Clipboard =
				Clipboard := result+
				ClipWait
			sleep 100
			send ^v
			sleep 100 
				send {<# up} ; solved some issues 
				return
		}
			;############End SMALL RegEx replace regular expressions #############

		{	;##############  replace "\|" with "s\|" ##############
			:*:xrpspc::
			:*:xraspc::
			:*:xraasc::
			:*:xrasc::
			:*:xaaspc::
				ahkrpipespipepcb()
				sleep 100 
				return 
					
				ahkrpipespipepcb(){
					sleep 100
					ahkrpipespipecb()
					sleep 100
					send ^v
					sleep 100
					return 
					}

		ahkrpipespipecb(){
				haystack := Clipboard
				needle := "\|"
				replacement := "s$0"
				result := RegExReplace(haystack, needle, replacement)
			;RegEx 
				haystack := result
				needle := "$"
				replacement := "s"
				result := RegExReplace(haystack, needle, replacement)
				Clipboard =
				Clipboard := result
				ClipWait
				sleep 100
				send {<# up} ; solved some issues 
				return
				} 

		}
			;############End replace "\|" with "s\|"  ############## 

		{	;##############  replace "\|" with "j\|" ##############
			:*:xrpjpc::
				ahkrpipejpipepcb()
				sleep 100 
				return 
					
				ahkrpipejpipepcb(){
					sleep 100
					ahkrpipejpipecb()
					sleep 100
					send ^v
					sleep 100
					return 
					}

		ahkrpipejpipecb(){
				haystack := Clipboard
				needle := "\|"
				replacement := "j$0"
				result := RegExReplace(haystack, needle, replacement)
			;RegEx 
				haystack := result
				needle := "$"
				replacement := "j"
				result := RegExReplace(haystack, needle, replacement)
				Clipboard =
				Clipboard := result
				ClipWait
				sleep 100
				send {<# up} ; solved some issues 
				return
				} 

		}
			;############End replace "\|" with "j\|"  ############## 

		{	;##############  replace "\|" with "g\|"  #############
			:*:xrpgpc::
			:*:xragpc::
			:*:xraagc::
			:*:xragc::
			:*:xaagpc::
				ahkrpipegpipepcb()
				sleep 100 
				return 
					
				ahkrpipegpipepcb(){
					sleep 100
					ahkrpipegpipecb()
					sleep 100
					send ^v
					sleep 100
					return 
					}
				
		ahkrpipegpipecb(){
			;RegEx
				haystack := Clipboard
				needle := "\|"
				replacement := "g$0"
				result01 := RegExReplace(haystack, needle, replacement)
			;RegEx 
				needle := "$"
				replacement := "g"
				result := RegExReplace(result01, needle, replacement)
				Clipboard =
				Clipboard := result
				ClipWait
				sleep 100
				send {<# up} ; solved some issues 
				return
			}
		}
			;############End replace "\|" with "g\|"  #############
			
		{	;##############  replace "\|" with "d\|" ##############
			:*:xrpdpc::
			:*:xradpc::
			:*:xraadc::
			:*:xradc::
			:*:xaadpc::
				ahkrpipedpipepcb()
				sleep 100 
				return 
					
				ahkrpipedpipepcb(){
					sleep 100
					ahkrpipedpipecb()
					sleep 100
					send ^v
					sleep 100
					return 
					}

		ahkrpipedpipecb(){
				haystack := Clipboard
				needle := "\|"
				replacement := "d$0"
				result := RegExReplace(haystack, needle, replacement)
			;Perform the RegEx find and replace operation
				haystack := result
				needle := "$"
				replacement := "d"
				result := RegExReplace(haystack, needle, replacement)
				Clipboard =
				Clipboard := result
				ClipWait
				sleep 100
				send {<# up} ; solved some issues 
			return
			}

		}
			;############End replace "\|" with "d\|"  ############## 

		}
			;############End Breevy specific RegEx ############## 

		{	;##############  Stata specific  ##############
			{	;##############  overlap with R specific  ##############
				{	;##############  rpath make R style paths 
				; this is the same as spath make Stata style paths a4spath
				:*:xrrpathc::
				:*:xrpath::
				:*:xmrpath::
				:*:xmspath::
				:*:xm4spath::
				:*:xm4rpath::
				:*:xm4spathc::
				:*:x4spathc::
				:*:4spathc::
				:*:4rkrpathc:: 
				:*:4rpathc::
				:*:4rpathc::
					haystack := Clipboard
					needle := "\\"
					replacement := "/"
					result := RegExReplace(haystack, needle, replacement)
					Clipboard =
					Clipboard := result
					ClipWait
					sleep 100
					send ^v
					sleep 100 
					send {<# up} ; solved some issues 
				return

				}
					;############End rpath make R style paths 

				{	;##############  rrpath reverse R style paths 
				:*:xumrpath::
				:*:xumrpath::
					haystack := Clipboard
					needle := "/"
					replacement := "\"
					result := RegExReplace(haystack, needle, replacement)
					Clipboard =
					Clipboard := result
					ClipWait
				
					sleep 100
					send ^v
					sleep 100 
					send {<# up} ; solved some issues 
				return

				}
					;############End rrpath reverse R style paths	
				}
				;############End overlap with R specific  ############## 

			{	;##############  4s switch C++ commenting system old to new  
			; making it possible to more easily switch between 4scb and 4socb 
			; yyy does not work as of 2016-01-24 20.54 

				:*:xr4sotnsc:: 
				:*:xr4sotncsc:: 
				:*:xr4sonsc:: 
				:*:xr4soncsc:: 
				:*:xr4snsc:: 
				:*:xr4sonsc::
				:*:xr4sronsc::
				:*:xr4sconcb::
				:*:xrsconcb::
				:*:xr4sonccb::
				:*:x4soncsc::
				:*:4soncsc::
				:*:xsoncsc::
				:*:x4sonsc::

					haystack := Clipboard
					needle := "([^*]\{\s{1,}\*\#{1,} )"
					replacement := "*$1"
					result01 := RegExReplace(haystack, needle, replacement)
				;Perform the second RegEx find and replace operation
					haystack := result01
					needle := "(\}[\s\r\n]{1,}\*\#{1,})"
					replacement := "*$1"
					result02 := RegExReplace(haystack, needle, replacement)
				; ;Perform the third RegEx find and replace operation
					haystack := result02 
					needle := "[*]{2,}"
					; replacement := "\/\/"
					replacement := "//"
					result := RegExReplace(haystack, needle, replacement)
				;Perform the fourth RegEx find and replace operation
					; haystack := result03
					; needle := "[=/\\|]\h{0,}"
					; replacement := ""
					; result := RegExReplace(haystack, needle, replacement)
					Clipboard =
					Clipboard := result
					ClipWait
				
				sleep 100
				send ^v
				sleep 100 
				
					send {<# up} ; solved some issues 
				return


			}
				;############End 4s switch C++ commenting system old to new  ############## 

			{	;##############  4s switch C++ commenting system new to old 
			; 2016-02-12 16.04 does not work yet 
			; making it possible to more easily switch between 4scb and 4socb 

				:*:4srntosc:: 
				:*:4srntocsc:: 
				:*:4srnosc:: 
				:*:4srnocsc:: 
				:*:4srnocb::
				:*:4srrnocb::
				:*:4snocsc::
				:*:4sxnocsc::
				:*:4sonwcsc::
				:*:4sonscb::
					haystack := Clipboard
					needle := "\*([{}])"
					replacement := "$1"
					result01 := RegExReplace(haystack, needle, replacement)
				; Perform the second RegEx find and replace operation
					haystack := result01
					needle := "(\h)?\/\/"
					replacement := "$1*"
					result := RegExReplace(haystack, needle, replacement)
				; ; ;Perform the third RegEx find and replace operation
					; haystack := result02
					; ; needle := "x"
					; ; replacement := "x"
					; needle := "\*([^{}#]{1,3})"
					; replacement := "$1\/\/$2"
					; result := RegExReplace(haystack, needle, replacement)
				;Perform the fourth RegEx find and replace operation
					; haystack := result03
					; needle := "[=/\\|]\h{0,}"
					; replacement := ""
					; result := RegExReplace(haystack, needle, replacement)
					Clipboard =
					Clipboard := result
					ClipWait
				
				sleep 100
				send ^v
				sleep 100 
				
					send {<# up} ; solved some issues 
				return


			}
				;############End 4s switch C++ commenting system new to old ############## 

			{	;##############  4s make (. into (0. add decimal 0 ##############
				:*:xrhk4sdecim0::  
				:*:xr4sdecim0::
				:*:xr4sdec0::
				:*:xr4sadd0::
				:*:xr4sad0::

					haystack := Clipboard
					needle := "\(\."
					replacement := "(0."
					result01 := RegExReplace(haystack, needle, replacement)
				;perform second regular expression 
					haystack := result01
					needle := "\(0\.\%"
					replacement := "(0%"
					result := RegExReplace(haystack, needle, replacement)
					Clipboard =
					Clipboard := result
					ClipWait
				
				sleep 100
				send ^v
				sleep 100 
				
					send {<# up} ; solved some issues 
				return

			}
				;############End 4s make (. into (0. add decimal 0 ############## 

			{	;##############  4s make [0-9]) into [0-9].0) add .decimal 
				:*:xrhk4sdecimd0::  
				:*:xr4sdecimd0::
				:*:xr4sdecd0::
				:*:xr4saddd0::
				:*:xr4sddec0::
				:*:4sad1dc::
				:*:4saddc::
				:*:xr4saddc::

					haystack := Clipboard
					needle := "(\([0-9])\)"
					replacement := "$1.0)"
					result := RegExReplace(haystack, needle, replacement)
					Clipboard =
					Clipboard := result
					ClipWait
				
				sleep 100
				send ^v
				sleep 100 
				
					send {<# up} ; solved some issues 
				return

			}
				;############End 4s make [0-9]) into [0-9].0) add .decimal ############## 

			{	;############  4s make ([0-9].[0-9]) into [0-9].[0-9]0) add second decimal
				:*:xr4sdn0::
				:*:xr4sdndec0::
				:*:xr4sscd0::
				:*:xr4sdn0::
				:*:x4sdn0::
				:*:xr4sdecn0::
				:*:xrnd0cb::
				:*:xrnumdcb::
				:*:xrnumd0c::
				:*:xadd0cb::
				:*:x4snd0cb::
				:*:xr4snd0c::
				:*:xradsdecc::
					haystack := Clipboard
					; needle := "(\(?[0-9]\.[0-9]))(\)?)"
					needle := "([0-9]\.[0-9])([,)(;\s])"
					replacement := "$10$2"
					result := RegExReplace(haystack, needle, replacement)
					Clipboard =
					Clipboard := result
					ClipWait
				
				sleep 100
				send ^v
				sleep 100 
				
					send {<# up} ; solved some issues 
				return

			}
				;##########End 4s make ([0-9].[0-9]) into [0-9].[0-9]0) add second decimal  

			{	;#####  4s make ([0-9].[0-9][0-9]) into [0-9].[0-9][0-9]0 add third decimal
				:*:xr4sad3d::
				:*:xr4sdndp::
				:*:xr4sadndnn0::
				:*:xr4sandnn0::
				:*:xr4sdnn0::
					haystack := Clipboard
					; needle := "(\(?[0-9]\.[0-9]))(\)?)"
					needle := "([0-9]\.[0-9][0-9])([,)(;\s])"
					replacement := "$10$2"
					result := RegExReplace(haystack, needle, replacement)
					Clipboard =
					Clipboard := result
					ClipWait
				
				sleep 100
				send ^v
				sleep 100 
				
					send {<# up} ; solved some issues 
				return

			}
				;###End 4s make ([0-9].[0-9][0-9]) into [0-9].[0-9][0-9]0 add third decimal  
				
			{	;##############  4s make correct decimals ##############

			/*

			2018-01-23 16.49
				updated below to have NA instead of 0% 
				updated below to not add extra 0 at end (changed RegEx replace 1)
			*/
			
				:*:4sfix::
				:*:xr4sfix::

				;RegEx replace 1 adding 0 after decimal
					haystack := Clipboard
					needle := "(\.[0-9]{1,1})([^0-9])"
					replacement := "$1$2"
					result := RegExReplace(haystack, needle, replacement)
				;RegEx replace 2 adding 0 after decimal 
					; haystack := result
					; needle := "(\.[0-9]{2})([^0-9])"
					; replacement := "$10$2"
					; resultx01 := RegExReplace(haystack, needle, replacement)
				;RegEx replace (. with (0.
					haystack := result
					needle := "\(\."
					replacement := "(0."
					result01 := RegExReplace(haystack, needle, replacement)
				;RegEx replace (0.% with (0%
					needle := "\(0\.\%"
					replacement := "(0%"
					result02 := RegExReplace(result01, needle, replacement)
				;RegEx replace ([0-9]) with ([0-9.0])
					needle := "(\([0-9])\)"
					replacement := "$1.0)"
					result03 := RegExReplace(result02, needle, replacement)
				;RegEx replace "(.[0-9])" with "(0.[0-9.0])"
					needle := "\(\.([0-9]{1,})"
					replacement := "(0.$1)"
					result04 := RegExReplace(result03, needle, replacement)
				;RegEx replace " .[0-9])" with " 0.[0-9]"
					needle := "([\-\s])+(\.[0-9]{1,})"
					replacement := "$10$2"
					result05 := RegExReplace(result04, needle, replacement)
				;RegEx replace ^.[0-9] with 0.[0-9
					needle := "(^\.[0-9]{1,})"
					replacement := "0$1"
					result06 := RegExReplace(result05, needle, replacement)
				;RegEx replace " .[0-9]" with 0.[0-9]  
					needle := "([\s]{1,})\.([0-9]{1,})"
					replacement := "$10.$2"
					result07 := RegExReplace(result06, needle, replacement)
				;RegEx replace " 1," with 0.[0-9]  
					needle := "([\s]{1,})1,"
					replacement := "$11.0" 
					result08 := RegExReplace(result07, needle, replacement)
				;RegEx replace " .[0-9]" with NA
					needle := "([\s-]+)0([^.0-9])"
					replacement := "$1NA" ; 
					result09 := RegExReplace(result08, needle, replacement)
				;RegEx replace "(0%)" with ""  
					needle := "\(0\%\)"
					replacement := "" ; 
					result := RegExReplace(result09, needle, replacement)
					Clipboard =
					Clipboard := result
					ClipWait
					;SendInput, %Clipboard%
					send {<# up} ; solved some issues 
				return
			}
				;############End 4s make correct decimals ############## 
				
			{	;##############  4s make [0-9]) into [0-9]%) add % percent ##############
				:*:xrhk4spercc::  
				:*:xr4spercc::
					haystack := Clipboard
					needle := "([0-9])\)"
					replacement := "$1%)"
					result := RegExReplace(haystack, needle, replacement)
					Clipboard =
					Clipboard := result
					ClipWait
				
				sleep 100
				send ^v
				sleep 100 
				
					send {<# up} ; solved some issues 
				return

			}
				;############End 4s make [0-9]) into [0-9]%) add % percent ############## 
			}
			;############End Stata specific  ############## 

		{	;##############  all removal of character  ##############

			{	;##############  remove enter


			; 2017-03-21 09.54 	updated to handle trailing space not followed by new line 
			; also removes preceding horizontal space (trim lines) 
			:*:xrmvec:: 
				ahkrmvecb() 
				sleep 100
				send ^v
				sleep 100
				return 
						
				ahkrmvecb()
					{
					needle := "[\h]*[\r\n]{1,}" 
					replacement := ""
					haystack := Clipboard
					result01 := RegExReplace(haystack, needle, replacement)
					needle := "[\h]*[\r\n]*$" ; to remove trailing space not followed by new line 
					replacement := ""
					haystack := result01
					result := RegExReplace(haystack, needle, replacement)
					Clipboard =
					Clipboard := result
					ClipWait
					send {<# up} ; solved some issues 
					return
					}

			}
				;########### END remove enter 


			{	;##############  remove space at end (trimp) or space and enter


			; also removes preceding horizontal space (trim lines) 
			:*:xrmvsec:: 
				ahkrmvsecb() 
				sleep 100
				send ^v
				sleep 100
				return 
						
				ahkrmvsecb()
					{
					needle := "[\h]*[\r\n]{1,}"
					replacement := " "
					haystack := Clipboard
					result := RegExReplace(haystack, needle, replacement)
					Clipboard =
					Clipboard := result
					ClipWait
					send {<# up} ; solved some issues 
					return
					}

			}
				;########### END remove space at end (trimp) or space and enter

			{	;##############  remove after first enter
			:*:xrmvafec:: 
				xahkrmvafecb() 
				sleep 100
				send ^v
				sleep 100
				return 
						
			xahkrmvafecb()
				{
				needle := "[\r\n]{1,}.*"
				replacement := ""
				haystack := Clipboard
				result := RegExReplace(haystack, needle, replacement)
				Clipboard =
				Clipboard := result
				ClipWait
				send {<# up} ; solved some issues 
				return
				}
			}
				;########### END remove after first enter 
			
			{	;##############  remove horizontal space \h 

			:*:xrmvsc:: 
			:*:Xrmvhspc::
			:*:xrmvhsc::
			:*:xrmhsc::
			:*:xrmvhc::
				xahkrmvscb() 
				send ^v
				sleep 100
				return 
						
			xahkrmvscb()
				{
				haystack := Clipboard
				needle := "([\h]){1,}"
				replacement := ""
				result := RegExReplace(haystack, needle, replacement)
				Clipboard =
				Clipboard := result
				ClipWait
				send {<# up} ; solved some issues 
				return
				}
			}
				;########### END remove horizontal space \h 

			{	;##############  remove multiple horizontal space \h 
			:*:xrmvmsc:: 
			:*:xrmvmhsc::
			:*:xrmvmhc::

				xahkrmvmscb() 
				sleep 100
				send ^v
				sleep 100
				return 
						
			xahkrmvmscb()
				{
				needle := "([\h]){2,}"
				replacement := ""
				haystack := Clipboard
				result := RegExReplace(haystack, needle, replacement)
				Clipboard =
				Clipboard := result
				ClipWait
				send {<# up} ; solved some issues 
				return
				}
			}
				;########### END remove multiple horizontal space \h 

			{	;##############  remove whitespace (\s)
			:*:xrmvwsc::
				xahkrmvwscb() 
					sleep 100
					send ^v
					sleep 100
					return 
						
				xahkrmvwscb()
					{
					needle := "\s{1,}"
					replacement := ""
					haystack := Clipboard
					result := RegExReplace(haystack, needle, replacement)
					Clipboard =
					Clipboard := result
					ClipWait
					send {<# up} ; solved some issues 
					return
					}
			}
				;########### END remove whitespace (\s)

			{	;##############  remove multiple whitespace (\s)
			:*:xrmvmwsc::
				xahkrmvmwscb() 
					sleep 100
					send ^v
					sleep 100
					return 
						
				xahkrmvmwscb()
					{
					needle := "\s{1,}"
					replacement := ""
					haystack := Clipboard
					result := RegExReplace(haystack, needle, replacement)
					Clipboard =
					Clipboard := result
					ClipWait
					send {<# up} ; solved some issues 
					return
					}
			}
				;########### END remove multiple whitespace (\s)

			{	;##############  remove dash 
				:*:xrmvdashc:: 
					xahkrmvdashcb() ; to be used whenever removing all \h 
					sleep 100
					send ^v
					sleep 100
					return 
							
				xahkrmvdashcb()
				{
					haystack := Clipboard
						needle := "([-]){1,}" ; works 2016-03-05 12.41 
						replacement := ""
						result := RegExReplace(haystack, needle, replacement)
						Clipboard =
						Clipboard := result
						ClipWait
					;SendInput, %Clipboard%
						send {<# up} ; solved some issues 
					return

				}
			}
				;########### END remove dash 

			{	;##############  remove comma 
				:*:xrmvcc:: 
					xahkrmvccb() ; to be used whenever removing all \h 
					sleep 100
					send ^v
					sleep 100
					return 
							
				xahkrmvccb()
				{
						haystack := Clipboard
						needle := "([,]){1,}"
						replacement := ""
						result := RegExReplace(haystack, needle, replacement)
						Clipboard =
						Clipboard := result
						ClipWait
						send {<# up} ; solved some issues 
					return
				}
			}
				;########### END remove comma

			{	;##############  remove after comma 
				:*:xrmvafcc:: 
					xahkrmvafccb() 
					sleep 100
					send ^v
					sleep 100
					return 
							
				xahkrmvafccb()
				{
						haystack := Clipboard
						needle := "([,]){1,}.*"
						replacement := ""
						result := RegExReplace(haystack, needle, replacement)
						Clipboard =
						Clipboard := result
						ClipWait
						send {<# up} ; solved some issues 
					return
				}
			}
				;########### END remove after comma

			{ 	;##############  remove tab   
				:*:xrmvtc:: 
					xahkrmvtcb() 
					sleep 100
					send ^v
					sleep 100
					return 
						
				xahkrmvtcb()
					{
					needle := "\t{1,}"
					replacement := ""
					haystack := Clipboard
					result := RegExReplace(haystack, needle, replacement)
					Clipboard =
					Clipboard := result
					ClipWait
					send {<# up} ; solved some issues 
					return
					}
			}
				;########### END remove tab   

			{	;##############  remove after tab
				:*:xrmvaftc:: 
					xahkrmvaftcb() 
					sleep 100
					send ^v
					sleep 100
					return 
							
				xahkrmvaftcb()
				{
						haystack := Clipboard
						needle := "[\t]{1,}.*"
						replacement := ""
						result := RegExReplace(haystack, needle, replacement)
						Clipboard =
						Clipboard := result
						ClipWait
						send {<# up} ; solved some issues 
					return
				}
			}
				;########### END remove after tab

			{	;##############  remove all [\W] 
				:*:xrmvnwc:: 
					xahkrmvnwcb() ; to be used whenever removing all enter
					sleep 100
					send ^v
					sleep 100
					return 
							
				xahkrmvnwcb()
				{
						needle := "[\W]"
						replacement := ""
						haystack := Clipboard
						result := RegExReplace(haystack, needle, replacement)
						Clipboard =
						Clipboard := result
						ClipWait
						send {<# up} ; solved some issues 
					return

				}
			}
				;########### END remove all [\W]

			{	;##############  remove everything after first space 
			; remove everything after first hspace hrzl horils hrizls horizontal space  (including the white space)
				:*:xrmvafsc::
				:*:xrmvafwsc::
				:*:xrmvafhsc::
					xahkrmvafscb() 
					sleep 100
					send ^v
					sleep 100
					return 
						
				xahkrmvafscb()
					{
					haystack := Clipboard
					needle := "\h.*"
					replacement := ""
					result := RegExReplace(haystack, needle, replacement)
					Clipboard =
					Clipboard := result
					ClipWait
					send {<# up} ; solved some issues 
					return
					}
			}
				;############End remove everything after first space 

			{	;##############  remove everything after first number 

			:*:xrmvafnc::
			:*:xrmvaffnc::
					xrmvafncb() 
					sleep 100
					send ^v
					sleep 100
					return 
						
				xrmvafncb()
					{
					haystack := Clipboard
					needle := "[0-9].*"
					replacement := ""
					result := RegExReplace(haystack, needle, replacement)
					Clipboard =
					Clipboard := result
					ClipWait
					send {<# up} ; solved some issues 
					return
					}

			}
				;############End remove everything after first number 

			{	;##############  remove lines starting with number 

			:*:xrmvlswnc::
			:*:xrswinc:: 
			:*:xrmswinc:: 
			:*:xrmvswnc:: 
			:*:xrmstawnc:: 
			:*:xrmvstawnc:: 
					xrmvlswnc() 
					sleep 100
					send ^v
					sleep 100
					return 
						
				xrmvlswnc()
					{
					haystack := Clipboard
					needle := "([\n\r]{1,})[0-9].*"
					replacement := ""
					result := RegExReplace(haystack, needle, replacement)
					Clipboard =
					Clipboard := result
					ClipWait
					send {<# up} ; solved some issues 
					return
					}

			}
				;############End remove everything after first number 

			}
			;############End all removal of character  ############## 
			
		{	;##############  all forms of space replacement ##############

			{	;##############  Trim clipboard  

			{	;##############  trim everything 
				:*:xtrimbac::
				:*:xtrimc::
				:*:xtrimsc::
				:*:xtrimhc::
				:*:xrmvbac::
					xahktrimc() ; to be used whenever removing completely empty rows
					sleep 100
					send ^v
					sleep 100
					return 
					
				xahktrimc() 
					{
						haystack := Clipboard
						result := Trim(haystack) ; 2017-01-02 does not work 
						Clipboard =
						Clipboard := result
						ClipWait
						send {<# up} 
						return
					}
				
			}
				;########### END trim everything

			}
				;############End Trim clipboard  

			{	;##############  enter  ##############
			; 2016-03-20 15.32 making complete list of possible combinations and using it as template 
			
			{	;##############  replace multiple enter with enter
				:*:xrmvmec::
				:*:xrmeec::
				:*:xrmvelc::
				:*:xrmvenlc::
				:*:xrmvehc::
				:*:xrmvehsc::

					xahkrmvmepc() ; to be used whenever removing completely empty rows
					sleep 100
					return 

					xahkrmvmepc(){
					sleep 100
					xahkrmvmec()
					sleep 100
					send ^v
					sleep 100
					return 
					}

				xahkrmvmec(){
						haystack := Clipboard
						needle := "([\n\r]{1})[\n\r\h]{1,}" ;removes enter followed by enter and/or horizontal space 
						replacement := "`n"
						result := RegExReplace(haystack, needle, replacement)
						Clipboard =
						Clipboard := result
						ClipWait
						send {<# up} 
						return
					}
				
			}
				;########### END replace multiple enter with enter 
				
			{	;##############  replace multiple only enter with enter
				:*:xrmvmoec::
				:*:xrmoeec::
					xahkrmvmoepc() ; to be used whenever removing completely empty rows
					sleep 100
					return 

					xahkrmvmoepc(){
					sleep 100
					xahkrmvmoec()
					sleep 100
					send ^v
					sleep 100
					return 
					}

				xahkrmvmoec() 
					{
						haystack := Clipboard
						needle := "([\n\r]{1})[\n\r]{1,}" ;removes enter followed by enter 
						replacement := "`n"
						result := RegExReplace(haystack, needle, replacement)
						Clipboard =
						Clipboard := result
						ClipWait
						send {<# up} 
						return
					}	
				
			}
				;########### END replace multiple only enter with enter 
				
			{ 	;#######  replace multiple enter and space with enter
			:*:xrmesec:: 
			:*:xrmsesec:: 
			:*:xrmsesec:: 
				xahkrmvmescb()
				sleep 100
				send ^v
				sleep 100
				return 

			xahkrmvmescb() 
				{
					haystack := Clipboard
					needle := "[\s]*([\n\r]{1})[\s]*" 
					replacement := "$1"
					result := RegExReplace(haystack, needle, replacement)
					Clipboard =
					Clipboard := result
					ClipWait
					send {<# up} ; solved some issues 
					return
				}
			}
				;#### end replace multiple enter and space with enter

			{ 	;#######  replace enter with tab enter

			:*:xadtabec::
			:*:xatec::
			:*:xtabec::
			:*:xadtaec::
			:*:xretec:: 
			:*:xretabec:: 
			:*:xitabaec:: 
			:*:xitaec:: 
				xahkretecb()
				sleep 100
				; xahkrmvmec() ; 2017-01-25 not needed after updating needle of xahkretec
				sleep 100
				send ^v
				sleep 100
				return 

			xahkretecb() 
				{
					haystack := Clipboard
					needle := "([\n\r]{1,})" 
					replacement := "`t$1"
					result := RegExReplace(haystack, needle, replacement)
					Clipboard =
					Clipboard := result
					ClipWait
					send {<# up} ; solved some issues 
					return
				}
			}
				;#####end replace enter with tab enter

			{ 	;##############  replace enter with one space   
			; replace multiple enter with space (" ")
			; also removes all trailing spaces 

			:*:xresc:: 
			:*:xrmesc:: 
				xahkrmescb() 
				sleep 100
				send ^v
				sleep 100
				return 
				
			xahkrmescb() 
				{
					needle := "[\s]*[\r\n]{1,}[\s]*" ;also remove all \s connected to enter 
					replacement := " "
					haystack := Clipboard
					result := RegExReplace(haystack, needle, replacement)
					Clipboard =
					Clipboard := result
					ClipWait
					send {<# up} 
					return
				}	

			}
				;########### END replace enter with one space   

			{ 	;##############  replace enter with one space   
			; replace multiple enter with one tab
			; also removes all trailing spaces 

			:*:xretc:: 
			:*:xrmetc:: 
				xahkrmetcb() 
				sleep 100
				send ^v
				sleep 100
				return 
				
			xahkrmetcb() 
				{
					needle := "[\s]*[\r\n]{1,}[\s]*" ;also remove all \s connected to enter 
					replacement := "`t"
					haystack := Clipboard
					result := RegExReplace(haystack, needle, replacement)
					Clipboard =
					Clipboard := result
					ClipWait
					send {<# up} 
					return
				}	

			}
				;########### END replace enter with one space   

			{ 	;##############  replace enter with one comma and space (", ")
			:*:xrmecsc::		
			:*:xrecsc::		
				xahkrmecscb() 
					sleep 100
					send ^v
					sleep 100
					return 

			xahkrmecscb()
					{
					needle := "\s*[\r\n]+\s*" ;replaces all \s connected to enter 
					replacement := ", "
					haystack := Clipboard
					result := RegExReplace(haystack, needle, replacement)
					Clipboard =
					Clipboard := result
					ClipWait
					send {<# up} 
					return
					}

			}
				;########### END replace enter with one comma and space (", ")

			{ 	;##############  replace comma and space (", ") with space 
			:*:xrmclssc::		
			:*:xrclssc::		
			:*:xrcssc::		
			:*:xrmcssc::		
				ahkrmclsscb() 
				sleep 100
				send ^v
				sleep 100
				return 

			ahkrmclsscb()
				{
				needle := ",\h" 
				replacement := " "
				haystack := Clipboard
				result := RegExReplace(haystack, needle, replacement)
				Clipboard =
				Clipboard := result
				ClipWait
				send {<# up} 
				return
				}

			}
				;########### END replace comma and space (", ") with space 

			{ 	;##############  remove special spaces
			:*:xrspecialsc::		
			:*:xrmspecialsc::		
				sleep 100
				ahkrmpecialsc() 
				sleep 100
				send ^v
				sleep 100
				return 

			ahkrmpecialsc(){
					needle := "[^a-zA-Z0-9åäöÅÄÖ_-\|]*\h" ; updated 2017-09-05 18.43 
					; needle := "[^a-zA-Z0-9åäöÅÄÖ_-\()\\\|]*\h" ; updated 2017-08-29 16.41 to not remove "( " 
						; 2017-09-01 11.17 I think this caused it to stop working 
						; 2017-09-05 18.42 not working correctly 
					replacement := " "
					haystack := Clipboard
					result := RegExReplace(haystack, needle, replacement)
				;Remove ending space
					haystack := result
					needle := "\s{1,}$"
					replacement :=""
					result01 := RegExReplace(haystack, needle, replacement)

					Clipboard =
					Clipboard := result01
					ClipWait
					send {<# up} 
					return
					}

			}
				;########### END remove special spaces

			{ 	;##############  replace multiple enter with "; "  
				:*:xresmicc::
					needle := "\s{0,}[\r\n]{1,}\s{0,}"
					replacement := "; "
						haystack := Clipboard
						result := RegExReplace(haystack, needle, replacement)
						Clipboard =
						Clipboard := result
						ClipWait
						send {<# up} 

						sleep 100
						send ^v
						sleep 100
						return 
			}
				;########### END replace multiple enter with "; "
			}
				;############End enter  ############## 

			{	;##############  Tab (

			; replace multiple tab with enter   
			:*:xrmtec::
				sleep 100 
				xahkrmtecb(){
					haystack := Clipboard
					needle := "[\t]{1,}"
					replacement := "`n"
					result := RegExReplace(haystack, needle, replacement)
					Clipboard =
					Clipboard := result
					ClipWait
					StuckKeyUp()
					return
					}
				sleep 100
				send ^v
				sleep 100 
				StuckKeyUp()
				sleep 100 
				return 

			; replace tab with enter   
			:*:xrtec::
				sleep 100 
				xahkrtecb(){
					haystack := Clipboard
					needle := "[\t]"
					replacement := "`n"
					result := RegExReplace(haystack, needle, replacement)
					Clipboard =
					Clipboard := result
					ClipWait
					StuckKeyUp()
					return
					}
				sleep 100
				send ^v
				sleep 100 
				StuckKeyUp()
				sleep 100 
				return 

			; replace multiple tab with one comma   
				:*:xrmtcc::
					haystack := Clipboard
					needle := "[\t]{1,}"
					replacement := ","
						haystack := Clipboard
						result := RegExReplace(haystack, needle, replacement)
						Clipboard =
						Clipboard := result
						ClipWait
						send {<# up} 
						return

			{ 	;##############  replace multiple tab with ", "   
				:*:xrmtcsc::
					haystack := Clipboard
					needle := "[\t]{1,}"
					replacement := ", "
					result := RegExReplace(haystack, needle, replacement)
					Clipboard =
					Clipboard := result
					ClipWait
					sleep 100
					send ^v
					sleep 100 
					send {<# up}
				return
				}
				;########### END replace multiple tab with ", "   

			{ 	;##############  replace multiple tab with "; "   
				:*:xrmtsmicc::
					haystack := Clipboard
					needle := "[\t]{1,}"
					replacement := "; "
					result := RegExReplace(haystack, needle, replacement)
					Clipboard =
					Clipboard := result
					ClipWait
					sleep 100
					send ^v
					sleep 100 
					send {<# up}
				return
				}
				;########### END replace multiple tab with "; "   

			{ 	;##############  replace multiple tab with one tab   
				:*:xrmttc::
					haystack := Clipboard
					needle := "[\t]{1,}"
					replacement := "`t"
					result := RegExReplace(haystack, needle, replacement)
					Clipboard =
					Clipboard := result
					ClipWait
					sleep 100
					send ^v
					sleep 100 
					send {<# up}
				return
				}
				;########### END replace multiple tab with one tab   

			{ 	;##############  replace multiple tab with one comma space   
				:*:xrtcsc::
					haystack := Clipboard
					needle := "[\t]{1,}"
					replacement := ", "
					result := RegExReplace(haystack, needle, replacement)
					Clipboard =
					Clipboard := result
					ClipWait
					sleep 100	
					send ^v
					sleep 100 
					send {<# up}
				return
				}
				;########### END replace multiple tab with one comma space   
				
			{ 	;##############  replace multiple tabs with one space 
				:*:xrmtsc::
					haystack := Clipboard
					needle := "\t{1,}"
					replacement := " "
					result := RegExReplace(haystack, needle, replacement)
					Clipboard =
					Clipboard := result
					ClipWait
					send {<# up} ; solved some issues 
				return
			}
				;########### END replace multiple tabs with one space   

			{ 	;##############  replace one tab with one space
				:*:xrtsc::
					haystack := Clipboard
					needle := "\t"
					replacement := " "
					result := RegExReplace(haystack, needle, replacement)
					Clipboard =
					Clipboard := result
					ClipWait
					send {<# up} ; solved some issues 
				return
			}
				;########### END replace one tab with one space


			}
				;############End Tab )  

			; replace multiple comma (no spaces) with one space
			:*:xrmcsc::
			:*:xrmcssc::
			:*:xrcssc::
				haystack := Clipboard
				needle := "[,]{1,}"
				replacement := " "
				result := RegExReplace(haystack, needle, replacement)
				Clipboard =
				Clipboard := result
				ClipWait
				send {<# up}
				return

			{ 	;##############  replace multiple comma (no spaces) with one tab   
				:*:xrmctc::
					haystack := Clipboard
					needle := "[,]{1,}"
					replacement := "`t"
					result := RegExReplace(haystack, needle, replacement)
					Clipboard =
					Clipboard := result
					ClipWait
					send {<# up}
				return
				}
				;########### END replace multiple comma (no spaces)with one tab   

			{ 	;##############  replace multiple comma with one enter   
				:*:xrcec::
				:*:xrcsec::
				:*:xrmcec::
					haystack := Clipboard
					needle := "[\h]{0,}[,]{1,}[\h]{0,}"
					replacement := "`n"
					result := RegExReplace(haystack, needle, replacement)
					Clipboard =
					Clipboard := result
					ClipWait
					send {<# up}
				return
				}
				;########### END replace multiple comma with one enter 

			{ 	;##############  replace multiple comma (and spaces) with one tab   
				:*:xrcstc::
				:*:xrsctc::
				:*:xrscstc::
					haystack := Clipboard
					needle := "[\h]{0,}[,]{1,}[\h]{0,}"
					replacement := "`t"
					result := RegExReplace(haystack, needle, replacement)
					Clipboard =
					Clipboard := result
					ClipWait
				sleep 100
				send ^v
				sleep 100 
					send {<# up}
				return
				}
				;########### END replace multiple comma (and spaces)with one tab   

			{ 	;##############  replace multiple comma (and spaces) with enter   

			; replace comma with enter 
			:*:xrcsec::
			:*:xrscec::
			:*:xrscsec::
				sleep 100 
				xahkrmcsecb(){
					haystack := Clipboard
					needle := "[\h]{0,}[,]{1,}[\h]{0,}"
					replacement := "`n"
					result := RegExReplace(haystack, needle, replacement)
					Clipboard =
					Clipboard := result
					ClipWait
					StuckKeyUp()
					return
					}
				sleep 100
				send ^v
				sleep 100 
				StuckKeyUp()
				sleep 100 
				return 


			}
				;########### END replace multiple comma (and spaces) with enter    

			{ 	;##############  replace multiple comma with one new line    
				:*:xrcnlc::
				:*:xrconlc::
					haystack := Clipboard
					needle := "\h{0,}[,]{1,}\h{0,}" ; also replace surrounding spaces
					replacement := "`n"
					result := RegExReplace(haystack, needle, replacement)
					Clipboard =
					Clipboard := result
					ClipWait
				sleep 100
				send ^v
				sleep 100 
					send {<# up}
				return
				}
				;########### END replace multiple comma with one tab   
				
			{	;##############  separate things on space 
			; split everything that contains space and send it to clipboard 
				:*:xsonspace::
					haystack := Clipboard
					needle := "\s.*"
					replacement := ""
					result := RegExReplace(haystack, needle, replacement)
					Clipboard =
					Clipboard := result
					ClipWait
				sleep 100
				send ^v
				sleep 100 
				;Perform the RegEx find and replace operation
				sleep 300 
					needle := "(.*\s)(.*)"
					replacement := "$2"
					result := RegExReplace(haystack, needle, replacement)	
					Clipboard =
					Clipboard := result
					ClipWait
				send {<# up} ; solved some issues 
				return
			}
				;############End separate things on space 
				
			{ 	;##############  replace multiple spaces with one comma   
				:*:xrhcoc::
				:*:xrmhcoc:: 
				:*:xrscoc::
				:*:xrscsc::
				:*:xrmscoc::
				:*:xrhxcc::
				:*:xrmhxcc::		
				:*:xrsxcc::
				:*:xrmsxcc::
				:*:xrsccb::
				:*:arsccb::
				:*:xrspaccb::
				:*:xrmsccb::
				:*:armsccb::
				:*:xrmspaccb::
					haystack := Clipboard
					needle := "[\s]{1,}"
					replacement := ", "
					result := RegExReplace(haystack, needle, replacement)
					Clipboard =
					Clipboard := result
					ClipWait
				sleep 100
				send ^v
				sleep 100 
					send {<# up}
				return
			}
				;########### END replace multiple spaces with one comma   
			
			{	;##############  replace >=1 whitespace (\s) with space (" ")
			:*:xrmwssc::
			:*:xrmvwsc::
			:*:xrmvsc::
					xahkrmwsscb() 
						sleep 100
						send ^v
						sleep 100
						return 
				
				xahkrmwsscb()
					{
					haystack := Clipboard
					needle := "\s{1,}"
					replacement := " "
					result := RegExReplace(haystack, needle, replacement)
					Clipboard =
					Clipboard := result
					ClipWait
					send {<# up} ; solved some issues 
					return
					}
			}
				;########### END replace >=1 whitespace (\s) with space (" ")

			{	;##############  replace 1 whitespace (\s) with space (" ")
			:*:xrwssc::
					haystack := Clipboard
					needle := "\s"
					replacement := " "
					result := RegExReplace(haystack, needle, replacement)
					Clipboard =
					Clipboard := result
					ClipWait
				send {<# up} ; solved some issues 
				return
			}
				;########### END replace 1 whitespace (\s) with space (" ")

			{	;##############  replace multiple space (\h) with space 
			:*:xrmvhsc::
			:*:xrmhssc::
			:*:xrmssc::
					haystack := Clipboard
					needle := "\h{1,}"
					replacement := " "
					result := RegExReplace(haystack, needle, replacement)
					Clipboard =
					Clipboard := result
					ClipWait
				send {<# up} ; solved some issues 
				return
			}
				;########### END remove space (\h)

			{ 	;##############  replace all \s connected to enter with space
				:*:xrwsesc:: 
				:*:xrmwsesc::
					haystack := Clipboard
					needle := "[\s]*[\r\n]{1,}[\s]*" ;replaces all \s connected to enter 
					replacement := " "
					result := RegExReplace(haystack, needle, replacement)
					Clipboard =
					Clipboard := result
					ClipWait
				SendInput, %Clipboard%
					send {<# up}
				return
			}
				;########### END replace all \s connected to enter with space
				
			{ 	;##############  replace all "\s[.,:;]" with [.,:;]
				:*:xrmvspc::
				:*:xrsppc::
					xahkrsppcb()
					sleep 100
					send ^v
					return 

				xahkrsppcb()
				{
					haystack := Clipboard
					needle := "[\s]*([.,.?!()<>[]{}:;'/\=*])" ;replaces all \s connected to enter 
					replacement := "$1"
					result := RegExReplace(haystack, needle, replacement)
					Clipboard =
					Clipboard := result
					ClipWait
					send {<# up}
				return
				}
			}
				;########### END replace all "\s[.,:;]" with [.,:;]
				
			{ 	;##############  replace multiple whitespace (and enter) with pipe   

				:*:xrsspc::	; perform "replace space with pipe" on the second thing in clipboard
				:*:xrsndspc::		
				:*:xrsecdspc::		

					ahkmoveSecondClipboardFirst()
					xahkrspcb()
					sleep 100
					send ^v
					return 

					ahkmoveSecondClipboardFirst(){
					send #.
					winwait, Ditto, , 3
						if ErrorLevel
						{
							MsgBox, WinWait timed out.
							return
						}
						else
							sleep 100 
							send {down}
					}
					return 


				:*:xrspc::		
				; :*:xrhpc::
				; :*:xrhkrspcb::
				; :*:xrhkspcb::
				; :*:xrhksspc::
				; :*:xrhkrspc::
				; :*:replhpc::
				; :*:xrhkretspc::
				; :*:xretspc::
				; :*:xrhkrtespc::
				; :*:xrtespc::
				; :*:xrhkrsspc::
				; :*:xrssspc::
				; :*:xrssspc::

					ahkrsppastecb()
					return 

				ahkrsppastecb(){
						xahkrspcb()
						sleep 100 ; 2017-06-30 13.23 decreased delay 
						send ^v
						return 
						}

				xahkrspcb(){
						haystack := Clipboard
						needle := "([\r\n])[\s]{1,}"
						replacement := " "
						result01 := RegExReplace(haystack, needle, replacement)
					;Perform the second RegEx find and replace operation
						haystack := result01
						needle := "[\h]{1,}"
						replacement := "|"
						result02 := RegExReplace(haystack, needle, replacement)
					;Perform the third RegEx find and replace operation
						haystack := result02
						needle := "[|\|][\s]{0,}$"
						replacement := ""
						result := RegExReplace(haystack, needle, replacement)
						Clipboard =
						Clipboard := result
						ClipWait, 2
						sleep 100
						send {<# up} ; solved some issues 
					return
					}
					
			}
				;########### END replace multiple whitespace (and enter) with pipe   

			{ 	;##############  replace pipe (and enter) with new line    
				:*:xrpnlc::
					{
						haystack := Clipboard
						needle := "([\r\n])[\s]{1,}"
						replacement := " "
						result01 := RegExReplace(haystack, needle, replacement)
					;Perform the second RegEx find and replace operation
						haystack := result01
						needle := "[\|]{1,}"
						replacement := "`n"
						result := RegExReplace(haystack, needle, replacement)
						Clipboard =
						Clipboard := result
						ClipWait
					sleep 100
				send ^v
				sleep 100 
						send {<# up} ; solved some issues 
					return
					}
				
			}
				;########### END replace pipe (and enter) with new line 

			{ 	;##############  replace multiple space (not enter) with tab   
				:*:xrmstc::
				;Perform the RegEx 
					haystack := Clipboard
					needle := "[\h]{2,}" ; this is correct but Cbreplm() has issues 
					replacement := "`t" 
					result := RegExReplace(haystack, needle, replacement)
					Clipboard =
					Clipboard := result
					ClipWait
				sleep 100
				send ^v
				sleep 100 
					send {<# up} ; solved some issues 
				return
			}
				;########### END replace multiple whitespace (not enter) with tab    

			{	;##############  replace multiple space at end of line with nothing 
			/*
			Remove trailing space on multiple line clipboard 

			2017-07-04 12.27
				works 
			*/

				:*:xrmvtsc::
				:*:xrhkrmtsc:: 
				:*:xrhkrtsnc:: 
				:*:xrtsnc:: 
				:*:xrmvtsnc::
					ahkrmvtscb() 
					sleep 100
					send ^v
					sleep 100
					return 
							
				ahkrmvtscb(){
					haystack := Clipboard
					needle := "[\h]{1,}([\r\n]){1,}"
					replacement := "`n"
					result := RegExReplace(haystack, needle, replacement)
					Clipboard =
					Clipboard := result
					ClipWait
					sleep 100 
					send {<# up} ; solved some issues 
					return
					}

			}
				;########### END replace multiple space at end of line with nothing 

			{	;##############  replace one or multiple whitespace with enter 

				:*:xrmwsec::
				:*:xrmwsnlc:

					xahkrmwsnlcb() 
					sleep 100
					send ^v
					sleep 100
					return 
							
				xahkrmwsnlcb()
				{
					needle := "([\s]){1,}"
					replacement := "`n"
					haystack := Clipboard
					result := RegExReplace(haystack, needle, replacement)
					Clipboard =
					Clipboard := result
					ClipWait
					send {<# up} ; solved some issues 
					return

				}
			}
				;########### END replace one or multiple whitespace with enter 

			{	;##############  replace one whitespace with enter 

				:*:xrwsec::
				:*:xrwsnlc:

					xahkrwsnlcb() 
					sleep 100
					send ^v
					sleep 100
					return 
							
				xahkrwsnlcb()
				{
					needle := "([\s]){1,}"
					replacement := "`n"
					haystack := Clipboard
					result := RegExReplace(haystack, needle, replacement)
					Clipboard =
					Clipboard := result
					ClipWait
					send {<# up} ; solved some issues 
					return

				}
			}
				;########### END replace one whitespace with enter 

			{	;##############  replace one horizontal space \h with tab 

				; :*:xrwstc::
				:*:xrstc::
				:*:xrhstc::
				:*:xrstabc::
				:*:xrhstabc::

					xahkrhstabcb() 
					sleep 100
					send ^v
					sleep 100
					return 
							
				xahkrhstabcb()
				{
					needle := "([\h])"
					replacement := "`t"
					haystack := Clipboard
					result := RegExReplace(haystack, needle, replacement)
					Clipboard =
					Clipboard := result
					ClipWait
					send {<# up} ; solved some issues 
					return

				}

			}
				;########### END replace one horizontal space \h with tab 

			{	;##############  replace multiple horizontal space \h with one tab 

				; :*:xrwstc::
				:*:xrmstc::
				:*:xrmhstc::
				:*:xrmstabc::
				:*:xrmhstabc::

					xahkrmhstabcb() 
					sleep 100
					send ^v
					sleep 100
					return 
							
				xahkrmhstabcb()
				{
					needle := "([\h]){1,}"
					replacement := "`t"
					haystack := Clipboard
					result := RegExReplace(haystack, needle, replacement)
					Clipboard =
					Clipboard := result
					ClipWait
					send {<# up} ; solved some issues 
					return

				}

			}
				;########### END replace multiple horizontal space \h with one tab 

			{	;##############  replace one horizontal space \h with enter 

				; :*:xrwstc::
				:*:xrsec::
				:*:xrhsec::
				:*:xrsnlc::
				:*:xrhsnlc::

					xahkrhsecb() 
					sleep 100
					send ^v
					sleep 100
					return 
							
				xahkrhsecb()
				{
					needle := "([\h])"
					replacement := "`n"
					haystack := Clipboard
					result := RegExReplace(haystack, needle, replacement)
					Clipboard =
					Clipboard := result
					ClipWait
					send {<# up} ; solved some issues 
					return

				}

			}
				;########### END replace one horizontal space \h with enter 

			{	;##############  replace multiple horizontal space \h with one tab 

				; :*:xrwstc::
				:*:xrmsec::
				:*:xrmhsec::

					xahkrmhsecb() 
					sleep 100
					send ^v
					sleep 100
					return 
							
				xahkrmhsecb()
				{
					needle := "([\h]){1,}"
					replacement := "`t"
					haystack := Clipboard
					result := RegExReplace(haystack, needle, replacement)
					Clipboard =
					Clipboard := result
					ClipWait
					send {<# up} ; solved some issues 
					return

				}

			}
				;########### END multiple horizontal space \h with one tab 

			{ 	;##############  replace multiple new line with one new line    
				:*:xrmmnlc::
				:*:xrmmnlnlc::
					haystack := Clipboard
					needle := "\h{0,}[\r\n]{1,}\h{0,}" ; also remove surrounding spaces
					replacement := "`n"
					result := RegExReplace(haystack, needle, replacement)
					Clipboard =
					Clipboard := result
					ClipWait
				sleep 100
				send ^v
				sleep 100 
					send {<# up}
				return
			}
				;########### END replace multiple comma with one tab   

			{ 	;##############  replace multiple new line with two new line    
			; add new line add enter 
				:*:xadrrc::
				:*:xadnlcb::
				:*:xaddnlcb::
				:*:xranlcb::
			haystack := Clipboard
					needle := "\h{0,}[\r\n]{1,}\h{0,}" ; also replace surrounding spaces
					replacement := "`n`n"
					result := RegExReplace(haystack, needle, replacement)
					Clipboard =
					Clipboard := result
					ClipWait
				sleep 100
				send ^v
				sleep 100 
					send {<# up}
				return
			}
				;########### END replace multiple comma with one tab   
				
			}
			;############End all forms of space replacement ############## 

		{	;##############  special characters replacement ##############
		{ 	;##############  replace multiple para with one tab   
			:*:xrptc::
			:*:xrmptc::
				haystack := Clipboard
				needle := "[\h]{0,}[\(]{1,}[\h]{0,}"
				replacement := "`t"
				result := RegExReplace(haystack, needle, replacement)
				Clipboard =
				Clipboard := result
				ClipWait
			SendInput, %Clipboard%
				send {<# up}
			return
			}
			;########### END replace multiple para with one tab

		{ 	;##############  replace multiple dash with one space   ##############
			:*:xrmdashsc::
				haystack := Clipboard
				needle := "[\h]*[\-]+"
				replacement := " "
				result := RegExReplace(haystack, needle, replacement)
				Clipboard =
				Clipboard := result
				ClipWait
			sleep 100 
			send ^v
			sleep 100
				send {<# up} ; solved some issues 
			return
		}
			;########### END replace multiple dash with one space   ##############

		{ 	;##############  replace one dash with one space
			:*:xrdashsc::
				haystack := Clipboard
				needle := "\-"
				replacement := " "
				result := RegExReplace(haystack, needle, replacement)
				Clipboard =
				Clipboard := result
				ClipWait
				send ^v
				send {<# up} ; solved some issues 
			return
		}
			;########### END replace one dash with one space   

		{ 	;##############  replace multiple dash with tab   
			:*:xrmdashtc::	
			:*:xrm-tc::
			;Perform the RegEx 
				haystack := Clipboard
				needle := "[-]{1,}"
				replacement := "`t" 
				result := RegExReplace(haystack, needle, replacement)
				Clipboard =
				Clipboard := result
				ClipWait
			sleep 100
			send ^v
			sleep 100 
				send {<# up} ; solved some issues 
			return
		}
			;########### END replace multiple dash with tab   
		
		{ 	;##############  replace multiple underscore with one space   
			:*:xrmuscosc::
			:*:xrmussc::
			:*:xrm_sc::
				haystack := Clipboard
				needle := "[\h]*[\_]+"
				replacement := " "
				result := RegExReplace(haystack, needle, replacement)
				Clipboard =
				Clipboard := result
				ClipWait
				send {<# up} ; solved some issues 
			return
		}
			;########### END replace multiple underscore with one space   

		{ 	;##############  replace one underscore with one space   
			:*:xruscsc::
			:*:xrussc::
			; :*:xr_sc::
				haystack := Clipboard
				needle := "\_"
				replacement := " "
				result := RegExReplace(haystack, needle, replacement)
				Clipboard = 
				Clipboard := result
				ClipWait
				send {<# up} ; solved some issues 
			return
		}
			;########### END replace one underscore with one space   

		{	;##############  replace "([0-9]\))[^0-9]*" with "$1" 
		; remove everything inside a numbered list 
			:*:xrtxtnc::
			:*:xrmtxtc::
			:*:xkpnumc::
			:*:xknumc::
			:*:xknlc::
				haystack := Clipboard
				needle := "([0-9]\))[^0-9]*"
				; needle := "([0-9]\))[a-zA-Z \-]*" ; 2015-11-18 this is suboptimal 		
				replacement := "$1 "
				result := RegExReplace(haystack, needle, replacement)
				Clipboard =
				Clipboard := result
				ClipWait
			sleep 100
			send ^v
			sleep 100 
			send {<# up} ; solved some issues 
			return
		}
			;############End replace "([0-9]\))[^0-9]*" with "$1" 

		{	;##############  EscapeSpecialCharacters 
			; aregex clipboard regular expression cb escape special characters 
			:*:xescscc::
			:*:xesscc::
			:*:xaescc::
			:*:xabsescc::
			:*:xaescscc::
			:*:xesccb::
			:*:xaescscc::
				haystack := Clipboard
				needle := "([\#\+\*\?\[\^\]\$\(\)\{\}\=\!\<\>\|\:\-\\\%])" ; what to use here changes depending on context! 
				; needle := "([\W\S])" ; what to use here changes depending on context! 
				; needle := "([\W\S])" ; this gives completely incorrect result 
				replacement := "\$1"
				result := RegExReplace(haystack, needle, replacement)
			; ;Perform the second RegEx find and replace operation
				; haystack := result01
				; needle := "^ "
				; replacement := ""
				; result02 := RegExReplace(haystack, needle, replacement)
			; ;Perform the third RegEx find and replace operation
				; haystack := result02
				; needle := "[:;]"
				; replacement := "-"
				; result03 := RegExReplace(haystack, needle, replacement)
			; ;Perform the fourth RegEx find and replace operation
				; haystack := result03
				; needle := "[=/\\|]\h{0,}"
				; replacement := ""
				; result := RegExReplace(haystack, needle, replacement)
				Clipboard =
				Clipboard := result
				ClipWait
			
				sleep 100
				send ^v
				sleep 100 

				send {<# up} ; solved some issues 
			return

			}
			;############End EscapeSpecialCharacters 
		}
			;############End special characters replacement ############## 

		{	;##############  change case of text  ##############
		{	;##############  replace upper case with lower case  

				:*:lwrcx::
				:*:xrlowerc::
				:*:xrlwrc::
				:*:xruploc::
				:*:xmlowerc::
				:*:xlowerc::
				:*:lowercx::
					ahkLowercb()
					send ^v
					sleep 100 
					return 

			:*:xlowernpc::
					ahkLowercb()
					sleep 100 
					return 

				ahkLowercb()
					{
					haystack := Clipboard
					needle := "([A-ZÅÄÖ]*)"
					; needle := "([A-Z]*)" ; 2017-04-26 11.37 added ÅÄÖ
					; needle := "([0-9]\))[a-zA-Z \-]*" ; 2015-11-18 this is suboptimal 		
					replacement := "$L1"
					result := RegExReplace(haystack, needle, replacement)
					Clipboard =
					Clipboard := result
					ClipWait
					sleep 100
					send {<# up} ; solved some issues 
					return
					}
			}
			;############End replace upper case with lower case  

		{	;##############  replace lower case with upper case 
			:*:xrloupc::
			:*:xmupperc::
			:*:xmcapsc::
			:*:xcapsc::
				ahkupperc() 
					sleep 100
					send ^v
					return 

				ahkupperc() {
				haystack := Clipboard
				needle := "([a-zåäö]*)"
				; needle := "([0-9]\))[a-zA-Z \-]*" ; 2015-11-18 this is suboptimal 		
				replacement := "$U1"
				result := RegExReplace(haystack, needle, replacement)
				Clipboard =
				Clipboard := result
				ClipWait
				sleep 100 
				send {<# up} ; solved some issues 
				return
				}
		}
			;############End replace lower case with upper case 

		{	;##############  make "Camel Case" sentence case 

		; Camel Case with spaces
			:*:xmcamelsc::
			:*:xcamelsc::
				haystack := Clipboard
				needle := "\h*([a-zA-Zåäö])([a-zåäö]*)\h*" ; this deals with åäö correctly and keeps new lines (2016-03-06 13.09)
				replacement := "$U1$2 "
				result := RegExReplace(haystack, needle, replacement)
				Clipboard =
				Clipboard := result
				ClipWait
			sleep 100
			send ^v
			sleep 100 
			send {<# up} ; solved some issues 
			return
		
		; Camel Case with spaces 
			:*:xmcamelsi8::
			:*:xcamelsi8::
			:*:xcamels8::
				CopyFromCaretToStartOfLine()
				ahkcamelspc() 
					return 

		; CamelCase without spaces
			:*:xmcamelpc::
			:*:xcamelpc::
				ahkcamelpc() 
					return 

		
		; CamelCase without spaces 
			:*:xmcamelc::
			:*:xcamelc::
				sleep 100
				ahkcamelc() 
					sleep 100
					send ^v
					return 

		; CamelCase without spaces PascalCase
			:*:xpas8::
			:*:xpasc8::
			:*:xpai8::
			:*:xpasi8::
			:*:xpasci8::
			:*:xmcameli8::
			:*:xcameli8::
			:*:xpasci8::
			:*:xcamel8::
				CopyFromCaretToStartOfLine()
				ahkcamelpc() 
					return 

		; Reverse "CamelCase" to "lower case with spaces"
			:*:xmrcamelpc::
			:*:xrcamelpc::
			:*:Xrcsccb::
			:*:Xucamelc::
			:*:Xuncamelc::
			:*:Xucamelc::
			:*:Xrcamelc::
				ahkrcamelpc() 
					return 

				ahkrcamelpc() {
					haystack := Clipboard
					needle := "\h*([A-ZÅÄÖ])([a-zåäö]*)\h*" 
					replacement := " $L1$2"
					result := RegExReplace(haystack, needle, replacement)
					Clipboard =
					Clipboard := result
					ClipWait
					sleep 100
					send ^v
					sleep 100 
					send {<# up} ; solved some issues 
					return
				}

				ahkcamelc() {
					haystack := Clipboard
					needle := "\h*([a-zA-Zåäö])([a-zåäö]*)\h*" 
					replacement := "$U1$2"
					result := RegExReplace(haystack, needle, replacement)
					Clipboard =
					Clipboard := result
					ClipWait
					sleep 100 
					send {<# up} ; solved some issues 
					return
				}

				ahkcamelpc() {
					clipwait 
					sleep 100 
					haystack := Clipboard
					needle := "\h*([a-zA-Zåäö])([a-zåäö]*)\h*" 
					replacement := "$U1$2"
					result := RegExReplace(haystack, needle, replacement)
					Clipboard =
					Clipboard := result
					ClipWait
					sleep 100
					send ^v
					sleep 100 
					send {<# up} ; solved some issues 
					return
				}

				ahkcamelspc() {
					clipwait 
					sleep 100 
					haystack := Clipboard
					needle := "\h*([a-zA-Zåäö])([a-zåäö]*)\h*" 
					replacement := "$U1$2 "
					result := RegExReplace(haystack, needle, replacement)
					Clipboard =
					Clipboard := result
					ClipWait
					sleep 100
					send ^v
					sleep 100 
					send {<# up} ; solved some issues 
					return
				}

				ahkcamelsc() {
					clipwait 
					sleep 100 
					haystack := Clipboard
					needle := "\h*([a-zA-Zåäö])([a-zåäö]*)\h*" 
					replacement := "$U1$2 "
					result := RegExReplace(haystack, needle, replacement)
					Clipboard =
					Clipboard := result
					ClipWait
					sleep 100
					send {<# up} ; solved some issues 
					return
				}

		}
			;############End make "Camel Case" sentence case 

		}
			;############End change case of text  ############## 

		{	;##############  Various replace regular expressions  ##############

		{ 	;##############  replace : with g4   
			:*:xrcog4c::
			:*:xrcog4c::
			:*:xrcg4cb::
			:*:xrco4cb::
			:*:xrc4cb::
				haystack := Clipboard
				needle := "\:"
				replacement := "g4"
				result := RegExReplace(haystack, needle, replacement)
				Clipboard =
				Clipboard := result
				ClipWait
			sleep 100
			send ^v
			sleep 100 
				send {<# up}
			return
		} 
			;########### END replace : with g4   

		{ 	;##############  replace g4 with :   
			:*:xrg4coc::
			:*:xrg4coc::
			:*:xrmg4ccb::
			:*:xrg4ccb::
			:*:xrg4ccb::
			:*:xr4cocb::
			:*:xrm4cc::
			:*:xr4ccb::
			:*:xr4br4cc::
			:*:xr4cocb::
				haystack := Clipboard
				needle := "g4"
				replacement := ":"
				result := RegExReplace(haystack, needle, replacement)
				Clipboard =
				Clipboard := result
				ClipWait
			sleep 100
			send ^v
			sleep 100 
			
				send {<# up}
			return
		} 
			;########### END replace g4 with :   

		{ 	;##############  replace 4 with 5   
			:*:xr45c::
				haystack := Clipboard
				needle := "4"
				replacement := "5"
				result := RegExReplace(haystack, needle, replacement)
				Clipboard =
				Clipboard := result
				ClipWait
			sleep 100
			send ^v
			sleep 100 
				send {<# up}
			return
		} 
			;########### END replace 4 with 5   

		{	;##############  replace 5 with 4   
			:*:xr54c::
				haystack := Clipboard
				needle := "5"
				replacement := "4"
				result := RegExReplace(haystack, needle, replacement)
				Clipboard =
				Clipboard := result
				ClipWait
			sleep 100
			send ^v
			sleep 100 
				send {<# up}
			return
		}
			;########### END replace 5 with 4   

		{	;##############  replace r with d   
			:*:xrrdcb::
				haystack := Clipboard
				needle := "r"
				replacement := "d"
				result := RegExReplace(haystack, needle, replacement)
				Clipboard =
				Clipboard := result
				ClipWait
			sleep 100
				send ^v
			sleep 100 
				send {<# up}
			return
		}
			;########### END replace r with d   

		{	;##############  replace d with r   
			:*:xrdrcb::
				haystack := Clipboard
				needle := "d"
				replacement := "r"
				result := RegExReplace(haystack, needle, replacement)
				Clipboard =
				Clipboard := result
				ClipWait
			sleep 100
				send ^v
			sleep 100 
				send {<# up}
			return
		}
			;########### END replace d with r   

		{	;##############  replace g4 with xl  
		:*:xrg4xlc::
		:*:xrg4xlc::
		:*:xrmg4xlcb::
		:*:xrg4xlcb::
		:*:xrg4xlcb::
		:*:xr4xlcb::
		:*:xrm4xlc::
		:*:xr4xlcb::
		:*:xr4br4xlc::
		:*:xr4xlcb::
				haystack := Clipboard
			needle := "g4"
			replacement := "xl"
			result := RegExReplace(haystack, needle, replacement)
			Clipboard =
			Clipboard := result
			ClipWait

			sleep 100
			send ^v
			sleep 100 
		
			send {<# up}
		return
		}
			;############End replace g4 with xl  

		{	;##############  remove plural s 
		; remove all "s" at end of words 
		; to be done: update to use correct regular expression for this 
			:*:xrmvpsc::
					haystack := Clipboard
					needle := "s"
					replacement := ""
					result := RegExReplace(haystack, needle, replacement)
					Clipboard =
					Clipboard := result
					ClipWait
				
				sleep 100
				send ^v
				sleep 100 
				
					send {<# up}
				return 
			}
			;########### END remove plural s 

		{	;##############  replace c with w   
			:*:xrcwc::
				haystack := Clipboard
				needle := "c"
				replacement := "w"
				result := RegExReplace(haystack, needle, replacement)
				Clipboard =
				Clipboard := result
				ClipWait
			sleep 100
			send ^v
			sleep 100 
				send {<# up} ; solved some issues 
			return
		}
			;########### END replace c with w   

		{	;##############  replace w with c   

			:*:xrwcc::
				haystack := Clipboard
				needle := "w"
				replacement := "c"
				result := RegExReplace(haystack, needle, replacement)
				Clipboard =
				Clipboard := result
				ClipWait
			sleep 100
			send ^v
			sleep 100 
				send {<# up} ; solved some issues 
			return
		}
			;########### END replace w with c   


		{	;##############  remove numbers [0-9]{1,}\h{0,} 

			:*:xrhkrnumc:: 
			:*:xrhkrmnumc:: 
			:*:xrmvnumc::
			:*:xrmnumc::
			:*:xrnumc::
			:*:xrmnumc::
				haystack := Clipboard
				; I want to both remove numbered list and any unnecessary spaces after 
				needle := "[0-9]{1,}\h{0,}"
				replacement := ""
				result := RegExReplace(haystack, needle, replacement)
				Clipboard =
				Clipboard := result
				ClipWait
			sleep 100
			send ^v
			sleep 100 
				send {<# up} ; solved some issues 
			return
		}
			;########### END remove numbers [0-9]{1,}\h{0,}

		{ 	;##############  remove numbered list on new line 
			; "\r\n1" and 1. or 1] or 1,))  
			:*:xrhkrenlc:: 
			:*:xrhkrmenlc:: 
			:*:xrmenlsc::
			:*:xrmenlc::
				haystack := Clipboard
				; I want to both remove numbered list and any unnecessary spaces after 
				needle := "[\r\n]{1,}[0-9]{1,}[\.\)\,\(]\h{0,}"
				replacement := "`n"  
				result1 := RegExReplace(haystack, needle, replacement)
			;Perform the RegEx find and replace operation
				haystack := result1
				needle := "^[0-9]{1,}[\.\)\,\(]\h{0,}"
				replacement := ""  
				result := RegExReplace(haystack, needle, replacement)
				Clipboard =
				Clipboard := result
				ClipWait
			sleep 100
			send ^v
			sleep 100 
				send {<# up} ; solved some issues 
			return
		}
			;########### END remove numbered list on new line 
		
		{	;##############  remove numbered list (e.g. 1) or 1. or 1] or 1,) 
		/*

		2017-04-14 15.08
			updated from 
				needle := "\h{0,}[0-9iI]{1,}[\.\)\,\(]\h{2,}"
			to 
				needle := "\h{0,}[0-9iI]{1,}[\.\)\,\(]\h{1,}"
		2017-04-05 10.53
			added a. to e.
		2017-02-22 
			added "I." and i. types 
		*/

			:*:xrnlc::
			:*:xrmvnlc::
			:*:xrhkrnlc:: 
			:*:xrhkrmnlc:: 
			:*:xrnlsc::
			:*:xrmnlsc::
			:*:xrmnlc::
				haystack := Clipboard
				; Removes numbered list and any unnecessary spaces after 
				needle := "\h{0,}[0-9iI]{1,}[\.\)\,\(]\h{1,}"
				replacement := ""
				result01 := RegExReplace(haystack, needle, replacement)
			;find and remove "[a-eA-E][\)\.]  
				haystack := result01
				needle := "\h{0,}[a-eA-E][\)\.]\h{2,}"
				replacement := ""
				result := RegExReplace(haystack, needle, replacement)
				Clipboard =
				Clipboard := result
				ClipWait
			sleep 100
			send ^v
			sleep 100 
				send {<# up} ; solved some issues 
			return
		}
			;########### end remove numbered list (e.g. 1) or 1. or 1] or 1,) 

		{	;##############  remove citation e.g. [11] or (11)
		/*

		2017-10-17 19.17
			created 
		*/

		:*:Xrmvncb::
		:*:xrmvncb::
		:*:xrmvcitc::
		:*:xrmcitc::
				haystack := Clipboard
				; Removes numbered list and any unnecessary spaces after 
				needle := "\h{0,}[\({\[]{1,}[0-9]{1,}[\)}\]]\h{0,}"
				replacement := ""
				result01 := RegExReplace(haystack, needle, replacement)
			;find and remove "[a-eA-E][\)\.]  
				haystack := result01
				needle := "\h{0,}[a-eA-E][\)\.]\h{2,}"
				replacement := ""
				result := RegExReplace(haystack, needle, replacement)
				Clipboard =
				Clipboard := result
				ClipWait
			sleep 100
			send ^v
			sleep 100 
				send {<# up} ; solved some issues 
			return
		}
			;########### end remove citation e.g. [11] or (11)

		{	;##############  remove rows with only numbers 

			:*:xrhkrnwc::
			:*:xrhkrmnwc::
			:*:xrnwc::
			:*:xrnwsc::
			:*:xrmnwsc::
			:*:xrmnwc::
				haystack := Clipboard
				; I want to both remove numbered rows and any unnecessary spaces around 
				needle := "[\r\n]\s*[0-9]+\s*[\r\n]"
				replacement := "`n"
				result := RegExReplace(haystack, needle, replacement)
				Clipboard =
				Clipboard := result
				ClipWait
			sleep 100
			send ^v
			sleep 100 
				send {<# up} ; solved some issues 
			return
		}
			;###########end  remove rows with only numbers 

		{ 	;##############  replace numbered list (e.g. 1) or 1. or 1]) with enter 
		:*:xrhkrnlec:: 
		:*:xrnlec::
		:*:xrnec::
		:*:xrlec::
				haystack := Clipboard
			; I want to both remove numbered list and any unnecessary spaces after 
			needle := "[0-9]+[\.\)\(]\h{0,}"
			replacement := "`n"
			result := RegExReplace(haystack, needle, replacement)
			Clipboard =
			Clipboard := result
			ClipWait
			sleep 100
			send ^v
			sleep 100 
			send {<# up} ; solved some issues 
		return
		}
			;########### END replace numbered list (e.g. 1) or 1. or 1]) with enter 

		{ 	;##############  replace enter with numbered list (e.g. 1) or 1. or 1]) 
		:*:xrhkrnlec:: 
		:*:xrnlec::
		:*:xrnec::
		:*:xrlec::
			haystack := Clipboard
			; I want to both remove numbered list and any unnecessary spaces after 
			needle := "`n"
			replacement := "NotSure" ; not sure if this is possible
			result := RegExReplace(haystack, needle, replacement)
			Clipboard =
			Clipboard := result
			ClipWait
			sleep 100
			send ^v
			sleep 100 
			send {<# up} ; solved some issues 
		return
		}
			;########### END replace enter with numbered list (e.g. 1) or 1. or 1]) 

		{	;##############  create AutoHotkey commands   

		; on clipboard 
		:*:xrhkncmc::
		:*:xrhkncc::
		:*:xrhkncmdc::
		:*:xrncmdc::
		:*:xrncmc::
		:*:xrscmd::
		:*:xrmcmdc::
		:*:xrmkcmdc::
		:*:ancmdcx::
		:*:ancmcx::
		:*:xancc::
		:*:ahkncc::
		:*:xahkncc::
		:*:xancmdcx::
		:*:xncmdcx::
		:*:xancx::
		:*:xnccbx::
		:*:ahknccbx::
		:*:ahkncmdc::
			ahkNCommandCb()
			return 

			ahkNCommandCb(){
					haystack := Clipboard
					needle := "[\s]{0,}([a-zA-Z0-9åäöÅÄÖ_-]+)[\s]{0,}"
					replacement := ":*:$1::`n"
					result01 := RegExReplace(haystack, needle, replacement)
				;Perform the second RegEx find and replace operation
					haystack := result01
					needle := "[\h]{1,}"
					replacement := "|"
					result := RegExReplace(haystack, needle, replacement)
					Clipboard =
					Clipboard := result
					ClipWait
				sleep 100
				send ^v
				sleep 100 
					send {<# up} ; solved some issues 
				return
				}

		}
			;########### END create AutoHotkey commands   	
		
		{	;##############  molcb make one line with special characters clipboard  
		; used for searching PubMed, Google Scholar, web of science etc, and to copy and paste from PDF to Microsoft Word, so should only remove excess whitespace 

		; 2016-07-07 12.13 
			; still issues with the following special characters 
				; fi (the letters) turn into special character FF (Adobe Acrobat issue) 
				; -- (i.e. long dash) 

			:*:Xmsclc::
			:*:xmolscc::
			:*:xmosclc::
				xahkmosclcb()
				sleep 100
				send ^v
				sleep 100 
				return 

		xahkmosclpcb(){
				xahkmosclcb()
				sleep 100
				send ^v
				sleep 100 
				return 
				}

			xahkmosclcb(){
					haystack := Clipboard
					needle := "[\s]{1,}"
					replacement := " "
					result01 := RegExReplace(haystack, needle, replacement)
				;Perform the second RegEx find and replace operation
					haystack := result01
					needle := "^ "
					replacement := ""
					result02 := RegExReplace(haystack, needle, replacement)
				;Perform the third RegEx find and replace operation
					haystack := result02
					needle := "" ; 2017-03-13 21.03 solves strange Adobe Acrobat issue with ff being considered a different character 
					replacement := "ff"
					result03 := RegExReplace(haystack, needle, replacement)
				;Perform the fourth RegEx find and replace operation
					haystack := result03
					needle := "" ; 2017-03-13 21.48 Rates I Time scales I Modelling rates, using Poisson regression I Interactions and parameterisation I Confounding by timedid not solve it, result04 version did 
					replacement := "fi"
					result04 := RegExReplace(haystack, needle, replacement)
				;Perform the fourth RegEx find and replace operation
					haystack := result04
					needle := "modi[\s.]{1,3}cation"
					replacement := "modification"
					result := RegExReplace(haystack, needle, replacement)
					Clipboard =
					Clipboard := result
					ClipWait
					send {<# up} ; solved some issues 
				return
			}
		}
			;############End molcb make one line with special characters clipboard  

		
		{	;##############  molcb make one word clipboard  
		; used for making bookmarks in Microsoft Word, should not be changed 

		:*:xmolnc::
			xahkmolnpcb()
			return 

		xahkmolnpcb()
			{
			xahkmolncb()
			sleep 100
			send ^v
			sleep 100 
			return 
			}

		xahkmolncb()
			{
				haystack := Clipboard
				needle := "[\s]{1,}"
				replacement := " "
				result01 := RegExReplace(haystack, needle, replacement)
			;Perform the second RegEx find and replace operation
				haystack := result01
				needle := "^ "
				replacement := ""
				result02 := RegExReplace(haystack, needle, replacement)
			;Perform the third RegEx find and replace operation
				haystack := result02
				needle := "[:;]"
				replacement := "-"
				result03 := RegExReplace(haystack, needle, replacement)
			;Perform the fourth RegEx find and replace operation
				haystack := result03
				needle := "[?]"
				replacement := " qmk"
				result04 := RegExReplace(haystack, needle, replacement)
			;Perform the fourth RegEx find and replace operation
				haystack := result04
				needle := "[ \-\(\)\{\}\[\]=/\\|]\h{0,}" ; escaping special characters is needed 
				replacement := ""
				result := RegExReplace(haystack, needle, replacement)
				Clipboard =
				Clipboard := result
				ClipWait
				send {<# up} ; solved some issues 
			return
			}
		}
			;############End molcb make one word clipboard  

		{	;##############  molcb make one line clipboard  
		; used for making filenames, and therefore only changes Windows 10 illegal filename marks 

		:*:xrmvescc::
		:*:xmolc::
			xahkmolpcb()
			return 


		xahkmolpcb()
			{
			xahkmolcb()
			sleep 100
			xahkrsppcb()
			sleep 100
			send ^v
			sleep 100 
			return 
			}

		xahkmolcb()
			{
				haystack := Clipboard
				needle := "-[\r\n]{1,}[\s]{0,}"
				replacement := ""
				result01a := RegExReplace(haystack, needle, replacement) ; 2016-07-01 16.14 added to solve words broken by line break 
			;Perform the second RegEx find and replace operation
				haystack := result01a
				needle := "[\s]{1,}"
				replacement := " "
				result01 := RegExReplace(haystack, needle, replacement)
			;Perform the second RegEx find and replace operation
				haystack := result01
				needle := "^ "
				replacement := ""
				result02 := RegExReplace(haystack, needle, replacement)
			;Perform the third RegEx find and replace operation
				haystack := result02
				needle := "[:;]"
				replacement := "-"
				result03 := RegExReplace(haystack, needle, replacement)
			;Perform the fourth RegEx find and replace operation
				haystack := result03
				needle := "[?]"
				replacement := "(qmk)"
				result04 := RegExReplace(haystack, needle, replacement)
			;Perform the fourth RegEx find and replace operation
				haystack := result04
				needle := "[=/\\|]\h{0,}"
				replacement := ""
				result := RegExReplace(haystack, needle, replacement)
				Clipboard =
				Clipboard := result
				ClipWait
				send {<# up} ; solved some issues 
			return
			}
		}
			;############End molcb make one line clipboard  

		{	;##############  molcb make one comma separated line clipboard  

			:*:Xmocsc::
			:*:xmcsc::
			:*:xmcslc::
			:*:xmocslc::

				xahkrmvmescb() 
				sleep 100
				xahkmocslcb()
				sleep 100
				send ^v
				sleep 100 
				return 

			xahkmocslcb()
			{
					haystack := Clipboard
					needle := "[\n\r]{1,}"
					replacement := ", "
					result01 := RegExReplace(haystack, needle, replacement)
				;Perform the second RegEx find and replace operation
					haystack := result01
					needle := "^ "
					replacement := ""
					result02 := RegExReplace(haystack, needle, replacement)
				;Perform the third RegEx find and replace operation
					haystack := result02
					needle := "[:;]"
					replacement := "-"
					result03 := RegExReplace(haystack, needle, replacement)
				;Perform the fourth RegEx find and replace operation
					haystack := result03
					needle := "[?]"
					replacement := " qmk"
					result04 := RegExReplace(haystack, needle, replacement)
				;Perform the fourth RegEx find and replace operation
					haystack := result04
					needle := "[=/\\|]\h{0,}"
					replacement := ""
					result := RegExReplace(haystack, needle, replacement)
					Clipboard =
					Clipboard := result
					ClipWait
					send {<# up} ; solved some issues 
				return
			}
		}
			;############End molcb make one comma separated line clipboard  

		{	;##############  molcb make one comma separated line clipboard  

			:*:xmowc::
			:*:xmonewc::
				xahkrmvmescb() 
				sleep 100
				xahkmonewcb()
				sleep 100
				send ^v
				sleep 100 
				return 

			xahkmonewcb()
			{
					haystack := Clipboard
					needle := "[\n\r]{1,}"
					replacement := ""
					result01 := RegExReplace(haystack, needle, replacement)
				;Perform the second RegEx find and replace operation
					haystack := result01
					needle := """"
					replacement := ""
					result02 := RegExReplace(haystack, needle, replacement)
				;Perform the third RegEx find and replace operation
					haystack := result02
					needle := "\s"
					replacement := ""
					result03 := RegExReplace(haystack, needle, replacement)
				;Perform the fourth RegEx find and replace operation
					haystack := result03
					needle := "[?]"
					replacement := "qmk"
					result04 := RegExReplace(haystack, needle, replacement)
				;Perform the fourth RegEx find and replace operation
					haystack := result04
					needle := "[-,.`:;\(\)\{\}\[\]=/\\|]{0,}"
					replacement := ""
					result := RegExReplace(haystack, needle, replacement)
					Clipboard =
					Clipboard := result
					ClipWait
					send {<# up} ; solved some issues 
				return
			}
		}
			;############End molcb make one comma separated line clipboard  

		{	;##############  molw make one line word  
			:*:4hmolw:: 
			:*:xrmolw::
			:*:xmolw::
				sleep 500 
				send ^c
				sleep 100 
				xahkmolcb()
				sleep 100
				send ^v
				sleep 100 
				return 

		}
			;############End molw mark one line word  

		{	;##############  reverse order of clipboard 

			:*:xmrsortc::
			:*:xrevsortc::
			:*:xrsortc::
				xahkrevsortcb()
				sleep 100
				send ^v
				sleep 100 
				return 

			xahkrevsortcb()
			{
					haystack := Clipboard
					; xahkreccb() 
					Sort, haystack, F ReverseDirection D,  ; Reverses the list so that it contains 3,9,7,5
					sleep 100 
					Clipboard =
					Clipboard := haystack
					ClipWait
					send {<# up} 
				return
			}

		} 
			;############End reverse order of clipboard 


		}
			;############End Various replace regular expressions  ############## 

		}

	{	;##############  Various things  ##############

		{	;##############  email people directly  ##############
		; works as of 2016-02-26 16.28 but takes for ever to load Gmail. Also usually prefer to respond to current email so as to have a running conversation.
		::xem5jä:: 
		::xemt5jä:: 
			Run, mailto:johan.arnlov@medsci.uu.se?subject=This is the subject line&body=This is the message body's text.
			return 
			
		}
			;############End email people directly  ############## 
			
		
		}
		;############End Various things  ############## 
		
	{	;##############  Example reference Scripts  ##############
		; short in the begining, longer at end 
			;<^<!m::MsgBox You pressed LeftControl+LeftAlt+m.
			;#i::Run, www.website.com 
			;^!#c::Run calc.exe
			;############################
			;to get a key that stops working to work by itself again 
			;XButton1 & XButton2:: whatever you want <- this might prevent xbutton from working 
			;############################
			;CapsLock::
			;+CapsLock::Send {CapsLock} 
			;CapsLock & f12::soundplay,D:\data\sounds\SMB\Coin.wav
			;#e:: return ; inactivating Windows shortkeys inactivates #e

		{	;##############  Looping (
			:*:ahklooping1:: ; this works but Input is preferred to get loop number 2017-06-19 09.59 
				InputBox, UserInput, Loop Number, Enter loop count., , 640, 480
				if ErrorLevel
					MsgBox, CANCEL was pressed.
				else
					Loop, %UserInput%
					{
					msgbox, Hi
					}
					return 
				return 

			:*:looping2:: ; this works but Input and/or InputBox is preferred to get loop number 2017-06-19 09.59 
			Gui, Add, text, , Enter #:
				Gui, Add, Edit, vNum
				Gui, Add, Button, default, OK
				Gui, Show
				Return

				13GuiClose:
				ButtonOK:
				Gui, Submit

				Loop, %Num%
					{
					msgbox, Hello
					}
				Gui, Destroy
				Return


			}
			;############End Looping ) 

		{ 	;############## to get the active window get wintitle gtwintitle get title active window ############## 

			;^a::
			;WinGetTitle, Title, A
			;MsgBox, The active window is "%Title%".
			;return
			} 
			;############## end to get the active window get wintitle gtwintitle get title active window ############ 

			; ; Example #3: Detection of single, double, and triple-presses of a hotkey. This
			; ; allows a hotkey to perform a different operation depending on how many times
			; ; you press it:
			; #c::
			; if winc_presses > 0 ; SetTimer already started, so we log the keypress instead.
			; {
				; winc_presses += 1
				; return
			; }
			; ; Otherwise, this is the first press of a new series. Set count to 1 and start
			; ; the timer:
			; winc_presses = 1
			; SetTimer, KeyWinC, 400 ; Wait for more presses within a 400 millisecond window.
			; return

			; KeyWinC:
			; SetTimer, KeyWinC, off
			; if winc_presses = 1 ; The key was pressed once.
			; {
				; Run, m:\  ; Open a folder.
			; }
			; else if winc_presses = 2 ; The key was pressed twice.
			; {
				; Run, m:\multimedia  ; Open a different folder.
			; }
			; else if winc_presses > 2
			; {
				; MsgBox, Three or more clicks detected.
			; }
			; ; Regardless of which action above was triggered, reset the count to
			; ; prepare for the next series of presses:
			; winc_presses = 0
			; return
			
			; ; Example #4: Detects when a key has been double-pressed (similar to double-click).
			; ; KeyWait is used to stop the keyboard's auto-repeat feature from creating an unwanted
			; ; double-press when you hold down the RControl key to modify another key.  It does this by
			; ; keeping the hotkey's thread running, which blocks the auto-repeats by relying upon
			; ; #MaxThreadsPerHotkey being at its default setting of 1.
			; ; Note: There is a more elaborate script to distinguish between single, double, and
			; ; triple-presses at the bottom of the SetTimer page.
			; ~RControl::
			; if (A_PriorHotkey <> "~RControl" or A_TimeSincePriorHotkey > 400)
			; {
				; ; Too much time between presses, so this isn't a double-press.
				; KeyWait, RControl
				; return
			; }
			; MsgBox You double-pressed the right control key.
			; return

		}
		;############End Example reference Scripts  ############## 

	{	;##############  settings files that can/have to be in the end
			; settings information, AutoHotkey relaterad scrips etc 
			#Hotstring EndChars -()[]{}:'/\,.?!`n `t  ;Need to add special ones: ;"   optional: 
			; considered adding 2015-04-18, but ended up not to as Breevy was the culprit: <>:;"'=*
			; $MButton::Send {MButton} 
				; 2017-11-06 08.48 had to remove this due to changes made to solve mbutton issues 
				;needed due to combinations I am using with mbutton 
			;$RButton::Send {RButton} ; 2014-12-10 - this is not tested, but could be a solution for issue with rbutton commands I have had
			#InstallKeybdHook

		{	;##############  AutoHotkey Specific  ##############

		:*:#):: ; save AutoHotkey main script and reload it (when in any program)
			reload, ;Reload AutoHotkey File
			Return
			
		;+Esc::ExitApp  ;Escape key will exit... place this at the bottom of the script due to "messing with the Auto-execute Section" otherwise 

		; View AutoHotkey key history 	
			::keyhist::
			:*:4ahkkh::
			:*:4akhist::
			:*:4keyhist:: 
			;#MenuMaskKey vk07  ; vk07 is unassigned.
			;#UseHook
			;#Space::
			;!Space::
				KeyWait LWin
				KeyWait RWin
				KeyWait Alt
				KeyHistory ; Display the key history of most recently pressed keys info in a new window.
				return

		}
			;############End AutoHotkey Specific  ############## 
		}
		;########### END settings files that can/have to be in the end

	{	;##############  special characters, keys ##############
			;hotstring abbreviations (abbreviation expand words strings text expands): 
				;::btw::by the way 
				;<^>!2::send {AppsKey}  ;NOT Working 
				; ^!#del::send {Insert}  ;NOT Working 

			; 2015-03-01 09.59 might be causing problems to have the § below
				; ::xsipara::§ ; § commands below have to be separate due to use of § as modifier 
				; ::xsipar::§
				; ::xsipa::§
				; ::xsiparag::§
				; ::xparag::§
				; ::parasig::§
				; ::pparagraph::§
				; ::pparag::§
					;2015-11-17 11.42 inactivated due to issues with conflict with Breevy 

				§::§ ; this makes it possible for Breevy to use pparag for paragraph (still possible to use § as modifier)
					; 2016-05-12 noticed some issues, this is not the pproblem, Breevy is.
					; 2015-11-16 changed it so AutoHotkey does all abbreviations for §. 

				; ::f::for 
					; does not always work (2016-12-04) 
					; too frequently problematic 

				; prior to this I had " r"=" are", but this required that previous word was not expanded using the preceding space 

			:*:ahkidowin::
			:*:ahkwinid::
			:*:ahkidwin::
			:*:idowinx::
			:*:winidx::
			:*:idwinx::
						; WinGetTitle, Title, A
						; MsgBox, The active window is "%Title%".
						id := WinExist("A")
						MsgBox % id
						return 


			:*:ahknowin::
			:*:ahkwinname::
			:*:ahknamewin::
			:*:nowinx::
			:*:winnamex::
			:*:namewinx::
						WinGetTitle, Title, A
						MsgBox, The active window is "%Title%".
						return 


			::xsisqd::
			::xssqd::
			::xsipt::   
			::xssq::
			::xsisq::
			send ²
			return 

			:*:xsieks::
			:*:xsiekl::
			:*:xsiex::
			:*:xsigm::
			sendraw !
			return 

			::xsiqubd::
			::xsqubd::
			::xsiqu::   
			::xsqu::
			send ³
			return 
			::xsirsqd::
			::rsqd5::
			::rsq5::
			::xsrsqd::
			::xsirpt::
			::xsrpt::
			send R²
			return 	

			::cpar::
			::rpar::
			::opar::
			::lpar::
				send )
				return  

			::xsiobrack::
			::xsiopenb::
			::xsiob::
			::xsiopb::
			::xsiobr::
			::xsiopenb::
			::xsiopenbracket::
				sendraw test 
				Send {U+005b} ; works asci conversion to send correct Unicode symbol 
				Send {ASC 0055} ; does not work as asci code for most signs (but works for some)
				return  

			::xsipf::
				Clipboard=??

				send ^v
				Send {U+1F44C} 
				Send {U+044C} 
				Send {U+F44C} 
				Send {U+1F44} 
				SendUnicodeChar(0x0125)
				SendUnicodeChar(U+1F44C)
				SendUnicodeChar(1F44C)
				SendUnicodeChar(0F44C)
				return  

			SendUnicodeChar(charCode)
			{
				VarSetCapacity(ki, 28 * 2, 0)
				EncodeInteger(&ki + 0, 1)
				EncodeInteger(&ki + 6, charCode)
				EncodeInteger(&ki + 8, 4)
				EncodeInteger(&ki +28, 1)
				EncodeInteger(&ki +34, charCode)
				EncodeInteger(&ki +36, 4|2)

				DllCall("SendInput", "UInt", 2, "UInt", &ki, "Int", 28)
			}

			EncodeInteger(ref, val)
			{
				DllCall("ntdll\RtlFillMemoryUlong", "Uint", ref, "Uint", 4, "Uint", val)
			}

			::xc:: ; updated 2016-08-29, and 2016-09-06 when previous version stopped working
				SendInput {Raw}^^
				sleep 100 
				send {space}
				sleep 100 
				send {backspace 2}
				sleep 100 
				return 

			{	;##############  dashes   

			dashCount := 0
			!-::
				dashCount++
				if(dashCount = 1) {
					SetTimer, WaitForAlt, -1
				}
			return

			WaitForAlt:
				KeyWait, Alt
				if(dashCount = 2) {
					; Send {ASC 0150} ; does not work as asci code for most signs (but works for some), use {U+005b} instead 
					send –
					sleep 100 
					send {left}
					send {right}
				} else if(dashCount = 3) {
					; Send {ASC 0151}
					send —
					sleep 100 
					send {left}
					send {right}
				}
				dashCount := 0
			return

			}
				;############End dashes   

			}
			;########### END special characters, keys ##############
