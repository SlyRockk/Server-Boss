#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force
;~ SetTitleMatchMode, fast
;~ DetectHiddenWindows, on ;conflicts with the console edit control (sendmessage scroll down will fail if enabled)

;---------------------------------------------------------------------------------------
;Server Boss v0.1 - Alpha
;Date created: 19.08.2024
;Last edit: 29.08.2024
;Made by: SlyRockk
;Latest changes:
;Bugs: DPI scale doesn't work properly if set to 125%
;To do:

;Software dependencies:
;SteamCMD https://developer.valvesoftware.com/wiki/SteamCMD

;cmd alternative to .bat for startup - "C:\Users\User\Desktop\Server Boss V1 debug\srcds_win64.exe" -console -game tf -port 27015 -tickrate 66 -heartbeat +sv_pure 0 +map cp_dustbowl +maxplayers 24 net_maxfilesize 64 -condebug -conclearlog -enablefakeip

;---------------------------------------------------------------------------------------

;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;Server Commands:
;tf_bot_add <1-100> <scout/soldier/pyro/demoman/heavy/engineer/medic/sniper/spy> <red/blue> <0-3> <Custom bot name> - adds x amount of bots to the server. Example: tf_bot_add 24 scout red 1 dave; Custom bot names only apply to a single bot, meaning that only one of the 24 bots will have custom name set by the command
;tf_bot_difficulty <0-3> - changes the difficulty of all bots. 0 easy, 1 normal 2 hard 3 expert. Example: tf_bot_difficulty 1
;tf_bot_force_class <scout/soldier/pyro/demoman/heavy/engineer/medic/sniper/spy> - forces all bots to switch to specific class after death. Example: tf_bot_force_class scout
;tf_bot_join_after_player <0/1> - if 1 bots will join after a player joins the game, if 0 bots join immediately, even if no human players are present
;tf_bot_keep_class_after_death <0/1> - if 1 bots will retain their class after death, if 0 bots may change their class after respawn
;tf_bot_kick <Bot name/All> - kicks specific or all bots
;tf_bot_prefix_name_with_difficulty <0/1> - if set to 1 all newly added bots will have their difficulty displayed before their name
;tf_bot_quota <1-100> - number of bots that are added automatically on the server

;tf_bot_quota_mode<normal/fill/match> -
;normal - The number of bots on the server equals bot_quota
;fill - The server is filled with bots until there are at least bot_quota players on the server (humans + bots). Human players joining cause an existing bot to be kicked, human players leaving might cause a bot to be added
;match - The number of bots on the server equals the number of human players times bot_quota

;tf_bot_taunt_victim_chance <0-100> - causes the bots to taunt after fill, 0 = 0% chance while 100 = 100% chance to taunt
;tf_bot_melee_only <0/1> - is set to 0 it will forces all bots to use melee weapons
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

DllCall("SetThreadDpiAwarenessContext", "ptr", -4, "ptr") ;doesn't work well...

;DPIscale temporary gui fix
;////////////////////////////////////////////////////
;100% dpi
If (A_ScreenDPI != 120)
{
	lbr := 17
	picw := 385
	pich := 246
	enamex := 40
	enamew := 235
	decpicx := 42
	pcountw := 47
	rpassx := 16
	rpassw := 235
	sserverw := 235

	econw := 630
	econh := 396
	sayw := 85
	ecodew := 476
	freezew := 114
}
;125% dpi
else
{
	lbr := 16
	picw := 379
	pich := 235
	enamex := 35
	enamew := 230
	decpicx := 38
	pcountw := 42
	rpassx := 10
	rpassw := 230
	sserverw := 229

	econw := 618
	econh := 390
	sayw := 87
	ecodew := 460
	freezew := 115
}
;////////////////////////////////////////////////////

;Change menu tray icon
IfExist, %A_ScriptDir%\Server Boss icon.ico
Menu, Tray, Icon, %A_ScriptDir%\Server Boss icon.ico

;Invert contex menu colors
contextcolor()
contextcolor(color:=2)
	{
    static uxtheme := DllCall("GetModuleHandle", "str", "uxtheme", "ptr")
    static SetPreferredAppMode := DllCall("GetProcAddress", "ptr", uxtheme, "ptr", 135, "ptr")
    static FlushMenuThemes := DllCall("GetProcAddress", "ptr", uxtheme, "ptr", 136, "ptr")
    DllCall(SetPreferredAppMode, "int", color)
    DllCall(FlushMenuThemes)
	}

gosub, ReadAdvancedSettings

;Create a custom windows tray menu
menu, tray, NoStandard
menu, tray, Add, Server, OpenServerWindow
menu, tray, Add, Exit, CloseApp

gui, main:new,, Server Boss
gui, main:font, dpi("cece5cb s16"), Impact
gui, main:Color, 36312d, 221f1c

gui, main:add, tab3, vMainTabVar, Server|Console
gui, main:add, text, section, Choose map:
gui, main:add, text, x+246 w379 vPickedMapText,
gui, main:add, listbox, xs w350 h450 r%lbr% cece5cb vPickedMapVar gPickedMap,
gui, main:add, picture, x+10 w%picw% h%pich% border vMapImage, %MapPic%
gui, main:add, text, y+15 section, Server name
gui, main:add, edit, x+%enamex% w%enamew% vPickedNameVar gPickedName, Loading...
gui, main:add, text, xs, Max. players
gui, main:add, picture, x+%decpicx% w30 h35 gDecreasePlayerCount, %A_ScriptDir%\Images\Custom gui controls\arrowLeftButton.png
gui, main:add, edit, x+5 w%pcountw% h35 limit2 number vPickedPlayerCountVar gPickedPlayerCount, L...
gui, main:add, picture, x+5 w30 h35 gIncreasePlayerCount, %A_ScriptDir%\Images\Custom gui controls\arrowRightButton.png
gui, main:add, picture, x+5 w113 h35 gReturnTo24p, %A_ScriptDir%\Images\Custom gui controls\restoreButton.png
gui, main:add, text, xs, RCON Password
gui, main:add, edit, x+%rpassx% w%rpassw% vRconPasswordVar password,
gui, main:add, button, xs y+15 w140 h42 gToggleAdvancedWindow, Options
gui, main:add, button, x+10 yp w%sserverw% h42 vStartServerVar gStartServer, Start Server

gui, advanced:new, +AlwaysOnTop, Server Boss
gui, advanced:font, cece5cb s12, Arial bold
gui, advanced:Color, 36312d,
gui, advanced:add, dropdownlist, vLanInternetVar gWriteAdvancedSettings section, Lan|Internet
gui, advanced:add, text, , UDP port
gui, advanced:add, edit, x+10 c000000 vPortVar gWriteAdvancedSettings, 27015
gui, advanced:add, dropdownlist, xs vSVpureVar gWriteAdvancedSettings, sv_pure -1|sv_pure 0|sv_pure 1|sv_pure 2
gui, advanced:add, dropdownlist, xs vSVlanVar gWriteAdvancedSettings, sv_lan 0|sv_lan 1 ;for some reason guicontrol can't choose numbers 0|1|2 etc.
gui, advanced:add, checkbox, xs vFakeIPVar gWriteAdvancedSettings checked%FakeIPVar%, Enable FakeIp

gui, main:tab, Console
gui, main:add, edit, w%econw% h%econh% section vConsoleEditControl,
gui, main:add, picture, x+15 yp+7 w96 h20 border, %A_ScriptDir%\Images\Custom gui controls\upArrowButton.png
gui, main:add, picture, y+10 w96 h95 border gBotControlGui, %A_ScriptDir%\Images\Custom gui controls\botButton.png
gui, main:add, picture, y+10 w96 h95 border gKickPlayerGui, %A_ScriptDir%\Images\Custom gui controls\kickButton.png
gui, main:add, picture, y+10 w96 h95 border gToggleConsole, %A_ScriptDir%\Images\Custom gui controls\consoleButton.png
gui, main:add, picture, y+10 w96 h20 border, %A_ScriptDir%\Images\Custom gui controls\downArrowButton.png
gui, main:add, text, xs section, Text color
gui, main:add, picture, x+8 yp+2 w25 h25 border c%CCVar% gBlueConsoleColor, %A_ScriptDir%\Images\Custom gui controls\blueColor.png
gui, main:add, picture, x+5 yp w25 h25 border c%CCVar% gGreenConsoleColor, %A_ScriptDir%\Images\Custom gui controls\greenColor.png
gui, main:add, picture, x+5 yp w25 h25 border c%CCVar% gAquaConsoleColor, %A_ScriptDir%\Images\Custom gui controls\aquaColor.png
gui, main:add, picture, x+5 yp w25 h25 border c%CCVar% gRedConsoleColor, %A_ScriptDir%\Images\Custom gui controls\redColor.png
gui, main:add, picture, x+5 yp w25 h25 border c%CCVar% gPurpleConsoleColor, %A_ScriptDir%\Images\Custom gui controls\purpleColor.png
gui, main:add, picture, x+5 yp w25 h25 border c%CCVar% gYellowConsoleColor, %A_ScriptDir%\Images\Custom gui controls\yellowColor.png
gui, main:add, picture, x+5 yp w25 h25 border c%CCVar% gWhiteConsoleColor, %A_ScriptDir%\Images\Custom gui controls\whiteColor.png
gui, main:add, picture, x+5 yp w25 h25 border c%CCVar% gGrayConsoleColor, %A_ScriptDir%\Images\Custom gui controls\grayColor.png
gui, main:add, picture, x+5 yp w25 h25 border c%CCVar% gLightBlueConsoleColor, %A_ScriptDir%\Images\Custom gui controls\lightBlueColor.png
gui, main:add, picture, x+5 yp w25 h25 border c%CCVar% gLightGreenConsoleColor, %A_ScriptDir%\Images\Custom gui controls\lightGreenColor.png
gui, main:add, picture, x+5 yp w25 h25 border c%CCVar% gLightAquaConsoleColor, %A_ScriptDir%\Images\Custom gui controls\lightAquaColor.png
gui, main:add, picture, x+5 yp w25 h25 border c%CCVar% gLightRedConsoleColor, %A_ScriptDir%\Images\Custom gui controls\lightRedColor.png
gui, main:add, picture, x+5 yp w25 h25 border c%CCVar% gLightPurpleConsoleColor, %A_ScriptDir%\Images\Custom gui controls\lightPurpleColor.png
gui, main:add, picture, x+5 yp w25 h25 border c%CCVar% gLightYellowConsoleColor, %A_ScriptDir%\Images\Custom gui controls\lightYellowColor.png
gui, main:add, picture, x+5 yp w25 h25 border c%CCVar% gBrightWhiteConsoleColor, %A_ScriptDir%\Images\Custom gui controls\brightWhiteColor.png
gui, main:add, picture, x+5 yp w25 h25 border c%CCVar% gDefaultConsoleColor, %A_ScriptDir%\Images\Custom gui controls\DefaultColor.png
gui, main:add, picture, x+5 yp w25 h25 border c%CCVar% gCustomConsoleColor, %A_ScriptDir%\Images\Custom gui controls\eyeDropperButton.png
gui, main:add, picture, x+6 yp-5 w30 h35 gDecreaseCMDTextSize, %A_ScriptDir%\Images\Custom gui controls\arrowLeftButton.png
gui, main:add, edit, x+5 w44 limit2 number readonly vPickedTextCMDSizeVar gPickedTextCMDSize, L...
gui, main:add, picture, x+5 w30 h35 gIncreaseCMDTextSize, %A_ScriptDir%\Images\Custom gui controls\arrowRightButton.png
gui, main:add, dropdownlist, xs y+8 w%sayw% vExtraConsoleCode, None||say|rcon|echo
gui, main:add, edit, x+6 w%ecodew% h35 vUserCode,
gui, main:add, picture, x+6 w58 h35 gSendConsoleCode, %A_ScriptDir%\Images\Custom gui controls\sendButton.png
gui, main:add, picture, x+6 w%freezew% h35 vfreezeButtonPicVar gToggleConsoleUpdates, %A_ScriptDir%\Images\Custom gui controls\unfreezeButton.png

gui, botgui:new, +AlwaysOnTop, Bot Control
gui, botgui:font, cece5cb s12, Arial bold
gui, botgui:Color, 36312d,
gui, botgui:add, text, section, Fix bots that do not move(Map will restart)
gui, botgui:add, button, x+10 gNavGenerate, Generate Navigation
gui, botgui:add, text, xs, Add bots
gui, botgui:add, edit, x+16 w45 limit2 c000000 vAddBotNumber, 1
gui, botgui:add, dropdownlist, x+10 w100 vAddBotClass, Random||Scout|Soldier|Pyro|Demoman|Heavy|Engineer|Medic|Sniper|Spy
gui, botgui:add, dropdownlist, x+10 w100 vAddBotTeam, Any||Red|Blue
gui, botgui:add, dropdownlist, x+10 w100 vAddBotDifficulty, None||Easy|Normal|Hard|Expert
gui, botgui:add, edit, x+10 w150 c000000 vAddBotName, Bot name
gui, botgui:add, button, x+10 c000000 gAddtfBot, Add
gui, botgui:add, text, xs, Remove bot
gui, botgui:add, edit, x+12 w137 c000000 vKickBotNameVar, Bot name
gui, botgui:add, button, x+10 gKickBot, Kick
gui, botgui:add, button, x+10 gKickAllBots, Kick All bots
gui, botgui:add, text, xs, Change difficulty
gui, botgui:add, dropdownlist, x+11 w100 vChangeBotDifficultyVar gChangeBotDifficulty, None|Easy|Normal||Hard|Expert
gui, botgui:add, text, x+10, Force class
gui, botgui:add, dropdownlist, x+23 w100 vForceBotClassVar gForceBotClass, None||Scout|Soldier|Pyro|Demoman|Heavy|Engineer|Medic|Sniper|Spy
gui, botgui:add, text, x+10, Taunt on kill
gui, botgui:add, edit, x+13 w45 number limit2 c000000 vBotTauntOnKillChanceVar, 25
gui, botgui:add, button, x+10 w42 gBotTauntOnKillChance, Set
gui, botgui:add, text, xs, Bot quota
gui, botgui:add, edit, x+10 w45 number limit2 c000000 vBotQuotaVar, 1
gui, botgui:add, text, x+10, Bot quota mode
gui, botgui:add, dropdownlist, x+10 w78 vBotQuotaFillModeVar, normal|fill||match
gui, botgui:add, button, x+10 w100 gBotQuota, Set Quota
gui, botgui:add, checkbox, xs vBotJoinAfterPlayerVar gBotJoinAfterPlayer, Join after player
gui, botgui:add, checkbox, x+10 vChangeBotClassOnDeathVar gChangeBotClassOnDeath, Change class on death
gui, botgui:add, checkbox, x+10 vShowBotDifficultyVar gShowBotDifficulty, Show difficulty
gui, botgui:add, checkbox, x+10 vForceBotMeleeOnlyVar gForceBotMeleeOnly, Enable melee only
;~ gui, botgui:add, text, +0x10 xs y+10 w675,
;~ gui, botgui:add, checkbox, xs yp+10, Show info on mouse hover

gui, kickgui:new, +AlwaysOnTop, Kick Player
gui, kickgui:font, cece5cb s12, Arial bold
gui, kickgui:Color, 36312d,

gui, kickgui:add, text, section, Player name
gui, kickgui:add, edit, x+10 c000000 vKickPlayerVar,
gui, kickgui:add, button, x+10 gKickPlayer, Kick player

gui, eyedropperColor:new, +AlwaysOnTop -caption, eyedropperTool
gui, eyedropperText:new, +AlwaysOnTop -caption, eyedropperTool
gui, eyedropperText:font, cece5cb s10, Impact
gui, eyedropperText:Color, 36312d, 221f1c
gui, eyedropperText:add, text, w60 vHexValue cece5cb


;Check for srcds_win64.exe. If not present, install SteamCMD and setup a tf2 server.
srcdsPath := A_ScriptDir . "\srcds_win64.exe"
SplitPath, srcdsPath, nameExt, OutDir
if FileExist(nameExt)
{
	gosub, OpenServerWindow
	gosub, ScanForMaps
	if (OpenLastMap = "")
	{
		IniRead, LastSavedMap, Settings.ini, LastSettings, map
		IniRead, LastSavedNameVar, Settings.ini, LastSettings, name
		IniRead, LastSavedPlayerCountVar, Settings.ini, LastSettings, playercount
		GuiControl, main:choose, PickedMapVar, %LastSavedMap%
		GuiControl, main:, PickedPlayerCountVar, %LastSavedPlayerCountVar%
		GuiControl, main:, PickedNameVar, %LastSavedNameVar%

		IniRead, LastSavedTextCMDSizeVar, Settings.ini, LastSettings, cmdTextSize
		GuiControl, main:, PickedTextCMDSizeVar, %LastSavedTextCMDSizeVar%
		Gui, main:font, s%LastSavedTextCMDSizeVar%
		GuiControl, main:font, ConsoleEditControl
		IniRead, LastSavedCMDColorVar, Settings.ini, LastSettings, cmdColor
		Gui, main:font, c%LastSavedCMDColorVar%
		GuiControl, main:font, ConsoleEditControl

		gosub, PickedMap
		OpenLastMap++
	}
}
else
{
	gosub, InstallTFServer
}

SetTimer, WatchLogFile, 1000    ;Check the console.log file every second
SetTimer, WatchLogFile, off
SetTimer, SendOnEnter, 1000		;Allow users to send console commands by pressing enter

;~ PID := DllCall("GetCurrentProcessId")
;~ PID := "ahk_pid" . A_Space . PID
return

;Send console commands with enter
~Enter::
if (focusedControl = "Edit6")
gosub, SendConsoleCode
else if WinActive("Kick Player")
gosub, KickPlayer
return


;Functions, labels and stopwatches
;---------------------------------------------------------------------------------------

;Show/hide window
OpenServerWindow:
If (ServerGuiOpen != 1)
{
ServerGuiOpen := 1
gui main:show
}
else if (ServerGuiOpen = 1)
{
gui main:hide
ServerGuiOpen := 0
}
return

ToggleAdvancedWindow:
If (AdvancedGuiOpen != 1)
{
AdvancedGuiOpen := 1
gui advanced:show
gosub, ApplyAdvancedSettings
}
else if (AdvancedGuiOpen = 1)
{
gui advanced:submit
AdvancedGuiOpen := 0
}
return

mainGuiClose:
gosub, OpenServerWindow
return

advancedGuiClose:
gosub, ToggleAdvancedWindow
return

;Close srcds_win64.exe
CloseApp:
Winshow, ahk_exe srcds_win64.exe
loop, 5
{
WinClose, ahk_exe srcds_win64.exe
}
ExitApp
return


InstallTFServer:
MsgBox, 4, Setup SteamCMD, srcds.exe not found!`nWould you like to setup a server?
IfMsgBox Yes
{
	DownloadPath := A_ScriptDir . "\" . "steamcmd.zip"
	UrlDownloadToFile, https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip, %DownloadPath%	;For some reason UrlDownloadToFile won't download a file in a path other than A_scriptdir
	UnzipWithCMDCode := "tar -xf" . A_Space . Chr(34) . DownloadPath . Chr(34)
	RunWait,%comspec% /k %UnzipWithCMDCode% && exit,, Hide							;Use windows cmd to unzip the file
	FileDelete, %DownloadPath%
	TempFolder := A_ScriptDir . "\" . "SteamCMD"
	FileCreateDir, %TempFolder%
	MoveSteamCmdToTemp := A_ScriptDir . "\" . "steamcmd.exe"
	FileMove, %MoveSteamCmdToTemp%, %TempFolder%, 1
	SteamCmdExePath := Chr(34) . TempFolder . "\" . "steamcmd.exe" . Chr(34)
	ForceInstallDirPath := A_Space . "+" . "force_install_dir" . A_Space . Chr(34) . A_ScriptDir . "\" . Chr(34)
	UpdateCode :=  A_Space . "+login anonymous" . A_Space . "+app_update 232250 validate" . A_Space . "+quit"
	Tf2ServerCode := Chr(34) . SteamCmdExePath ForceInstallDirPath UpdateCode . Chr(34) ;Make sure that the whole code is enclosed with quotes otherwise steamcmd won't open
	RunWait, %comspec% /k %Tf2ServerCode%
	IfExist, %A_ScriptDir%\srcds_win64.exe
	Reload	;quick fix for map scanning and guicontrol setup
	else
	ExitApp
}
IfMsgBox No
ExitApp
return

;Add image in \Images\Map images on drag and drop and .bsp files in \tf\maps
mainGuiDropFiles:
SplitPath, A_GuiEvent,,, DroppedFileExtention, DroppedFileNameNoExt
if (DroppedFileExtention = "bsp")
{
		checkMap := A_ScriptDir . "\tf\maps\" . DroppedFileNameNoExt . ".bsp"
		noImagePath := A_ScriptDir . "\Images\Custom gui controls\Custom Image.png"
		if !FileExist(checkMap)
		{
			FileCopy, %A_GuiEvent%, %A_ScriptDir%\tf\maps, 1
			GuiControl, main:, PickedMapVar, %DroppedFileNameNoExt%
			GuiControl, main:choose, PickedMapVar, %DroppedFileNameNoExt%
			GuiControl, main:, MapImage, %noImagePath%
			GuiControl, main:, PickedMapText, %DroppedFileNameNoExt%
			IniWrite, %noImagePath%, Settings.ini, Maps, %DroppedFileNameNoExt%
			IniWrite, %DroppedFileNameNoExt%, Settings.ini, LastSettings, map
		}
		else
		{
			GuiControl, main:choose, PickedMapVar, %DroppedFileNameNoExt%
			IniRead, MapImagePath, Settings.ini, Maps, %DroppedFileNameNoExt%
			GuiControl, main:, MapImage, %MapImagePath%
			GuiControl, main:, PickedMapText, %DroppedFileNameNoExt%
			IniWrite, %DroppedFileNameNoExt%, Settings.ini, LastSettings, map
		}
}
else if (DroppedFileExtention = "png" or DroppedFileExtention = "jpg" or DroppedFileExtention = "bmp" or DroppedFileExtention = "jpeg")
{
	copyImageNewName := A_ScriptDir . "\Images\Map images\" . PickedMapVar . "." . DroppedFileExtention
	FileCopy, %A_GuiEvent%, %copyImageNewName%, 1
	IniWrite, %copyImageNewName%, Settings.ini, Maps, %PickedMapVar%
	GuiControl, main:, MapImage, %copyImageNewName%
}
return

;Scan tf\maps folder for maps
ScanForMaps:
Loop, %A_ScriptDir%\tf\maps\*.*, 0, 1
{
	SplitPath, A_LoopFileName,,,, OutNameNoExt
	loop, %A_ScriptDir%\Images\Map images\%OutNameNoExt%*.*, 0, 1
	{
		SplitPath, A_LoopFileFullPath,,, OutExtension
	}
	imagePath := A_ScriptDir . "\Images\Map images\" . OutNameNoExt . "." . OutExtension
	noImagePath := A_ScriptDir . "\Images\Custom gui controls\Custom Image.png"
	IfExist, %imagePath%
	imgFound := 1
	else
	imgFound := 0
	if (imgFound = "1")
	{
		GuiControl, main:, PickedMapVar, %OutNameNoExt%
		IniWrite, %imagePath%, Settings.ini, Maps, %OutNameNoExt%
	}
	else if (imgFound = "0")
	{
		GuiControl, main:, PickedMapVar, %OutNameNoExt%
		IniWrite, %noImagePath%, Settings.ini, Maps, %OutNameNoExt%
	}
}
return

PickedMap:
gui main:submit, nohide
IniWrite, %PickedMapVar%, Settings.ini, LastSettings, map
IniRead, MapPic, Settings.ini, Maps, %PickedMapVar%
GuiControl, main:, MapImage, %MapPic%
GuiControl, main:, PickedMapText, %PickedMapVar%
return

PickedName:
gui main:submit, nohide
IniWrite, %PickedNameVar%, Settings.ini, LastSettings, name
return

;Player count controls
PickedPlayerCount:
gui main:submit, nohide
IniWrite, %PickedPlayerCountVar%, Settings.ini, LastSettings, playercount
return

DecreasePlayerCount:
gui main:submit, nohide
if (PickedPlayerCountVar > 1)
{
PickedPlayerCountVar--
GuiControl, main:, PickedPlayerCountVar, %PickedPlayerCountVar%
}
return

IncreasePlayerCount:
gui main:submit, nohide
if (PickedPlayerCountVar < 100)
{
PickedPlayerCountVar++
GuiControl, main:, PickedPlayerCountVar, %PickedPlayerCountVar%
}
return

ReturnTo24p:
gui main:submit, nohide
GuiControl, main:, PickedPlayerCountVar, 24
return

;CMD text size labels
DecreaseCMDTextSize:
gui main:submit, nohide
if (PickedTextCMDSizeVar > 6)
{
PickedTextCMDSizeVar--
Gui, main:font, s%PickedTextCMDSizeVar%
GuiControl, main:, PickedTextCMDSizeVar, %PickedTextCMDSizeVar%
GuiControl, main:font, ConsoleEditControl
}
return

IncreaseCMDTextSize:
gui main:submit, nohide
if (PickedTextCMDSizeVar < 24)
{
	PickedTextCMDSizeVar++
	Gui, main:font, s%PickedTextCMDSizeVar%
	GuiControl, main:, PickedTextCMDSizeVar, %PickedTextCMDSizeVar%
	GuiControl, main:font, ConsoleEditControl
}
return

PickedTextCMDSize:
gui main:submit, nohide
IniWrite, %PickedTextCMDSizeVar%, Settings.ini, LastSettings, cmdTextSize
return

;Start srcds_win64.exe, hide the console, fetch public or fake ip and move to console tab
StartServer:
gui main:submit, nohide
LogStatus := 1
presetCode := A_Space . "-console -game tf -tickrate 66 -heartbeat net_maxfilesize 64 -condebug -conclearlog"
customMap := "+map" . A_Space . PickedMapVar . A_Space
customServerName := "+hostname" . A_Space . PickedNameVar . A_Space
customPlayerSize := "+maxplayers" . A_Space . PickedPlayerCountVar . A_Space
if (RconPasswordVar != "")
customRCONPass := "+rcon_password" . A_Space . RconPasswordVar . A_Space
customPort := "-port" . A_Space . PortVar . . A_Space
customSVPure := SVpureVar . A_Space
customSVLan := SVlanVar . A_Space
if (FakeIPVar = 1)
customFakeIP := "-enablefakeip"
else
customFakeIP := ""

If (ServerToggle != 1)
{
	GuiControl, main:, StartServerVar, Stop Server
	GuiControl, main:choose, MainTabVar, Console
	SetTimer, WatchLogFile, on
	GuiControl, main:, freezeButtonPicVar, %A_ScriptDir%\Images\Custom gui controls\freezeButton.png
	CustomCode := customMap . customServerName . customPlayerSize . customRCONPass . customPort . customSVPure . customSVLan . customFakeIP
	startCommands := Chr(34) . srcdsPath . Chr(34) . presetCode . A_Space . CustomCode
	run, %comspec% /k %startCommands% && Exit,, Hide
	WinWaitActive, ahk_exe srcds_win64.exe
	WinHide, ahk_exe srcds_win64.exe
		if (FakeIPVar = 0)
		{
			clipboard := "Connect" . A_Space . GetIP("http://www.netikus.net/show_ip.html") . ":" . PortVar
		}
		else if (FakeIPVar = 1)
		SetTimer, FetchFakeIP, -1000
	ServerToggle := 1
}
else if (ServerToggle = 1)
{
	GuiControl, main:, StartServerVar, Start Server
	SetTimer, WatchLogFile, off
	LogStatus := 1
	gosub, ToggleConsoleUpdates
	DetectHiddenWindows, on
	WinClose, ahk_exe srcds_win64.exe
	DetectHiddenWindows, off
	ServerToggle := 0
	SetTimer, FetchFakeIP, Delete
}
return

;Get public ip(function by Autohotkey gurus)
GetIP(URL)
{
	http:=ComObjCreate("WinHttp.WinHttpRequest.5.1")
	http.Open("GET",URL,1)
	http.Send()
	http.WaitForResponse
	ToolTip, Public IP copied to Clipboard!
	Sleep, 2000
	ToolTip
	If (http.ResponseText="Error"){
	MsgBox 16, IP Address, Sorry, your public IP address could not be detected
	Return
}
	return http.ResponseText
}

;Watch console.log file for updates every second(-condebug MUST be added when server starts)
WatchLogFile:
	global PreviousContent := ""
    FileRead, LogContent, %A_ScriptDir%\tf\console.log
    if (LogContent != PreviousContent)
    {
        NewContent := SubStr(LogContent, StrLen(PreviousContent) + 1)
        GuiControlGet, CurrentContent, , ConsoleEditControl
        GuiControl, main:, ConsoleEditControl, % CurrentContent . NewContent
        PreviousContent := LogContent
    }
	SendMessage, 0x115, 7, 0, Edit4, Server Boss		;Make edit to scroll at the bottom on update
return

;Change Console text color
BlueConsoleColor:
Gui, main:font, c0037da
GuiControl, main:font, ConsoleEditControl
IniWrite, 0037da, Settings.ini, LastSettings, cmdColor
return

GreenConsoleColor:
Gui, main:font, c13a10e
GuiControl, main:font, ConsoleEditControl
IniWrite, 13a10e, Settings.ini, LastSettings, cmdColor
return

AquaConsoleColor:
Gui, main:font, c3a96dd
GuiControl, main:font, ConsoleEditControl
IniWrite, 3a96dd, Settings.ini, LastSettings, cmdColor
return

RedConsoleColor:
Gui, main:font, cc50f1f
GuiControl, main:font, ConsoleEditControl
IniWrite, c50f1f, Settings.ini, LastSettings, cmdColor
return

PurpleConsoleColor:
Gui, main:font, c881798
GuiControl, main:font, ConsoleEditControl
IniWrite, 881798, Settings.ini, LastSettings, cmdColor
return

YellowConsoleColor:
Gui, main:font, cc19c00
GuiControl, main:font, ConsoleEditControl
IniWrite, c19c00, Settings.ini, LastSettings, cmdColor
return

WhiteConsoleColor:
Gui, main:font, ccccccc
GuiControl, main:font, ConsoleEditControl
IniWrite, cccccc, Settings.ini, LastSettings, cmdColor
return

GrayConsoleColor:
Gui, main:font, c767676
GuiControl, main:font, ConsoleEditControl
IniWrite, 767676, Settings.ini, LastSettings, cmdColor
return

LightBlueConsoleColor:
Gui, main:font, c3b78ff
GuiControl, main:font, ConsoleEditControl
IniWrite, 3b78ff, Settings.ini, LastSettings, cmdColor
return

LightGreenConsoleColor:
Gui, main:font, c16c60c
GuiControl, main:font, ConsoleEditControl
IniWrite, 16c60c, Settings.ini, LastSettings, cmdColor
return

LightAquaConsoleColor:
Gui, main:font, c61d6d6
GuiControl, main:font, ConsoleEditControl
IniWrite, 61d6d6, Settings.ini, LastSettings, cmdColor
return

LightRedConsoleColor:
Gui, main:font, ce74856
GuiControl, main:font, ConsoleEditControl
IniWrite, e74856, Settings.ini, LastSettings, cmdColor
return

LightPurpleConsoleColor:
Gui, main:font, cb4009e
GuiControl, main:font, ConsoleEditControl
IniWrite, b4009e, Settings.ini, LastSettings, cmdColor
return

LightYellowConsoleColor:
Gui, main:font, cf9f1a5
GuiControl, main:font, ConsoleEditControl
IniWrite, f9f1a5, Settings.ini, LastSettings, cmdColor
return

BrightWhiteConsoleColor:
Gui, main:font, cf2f2f2
GuiControl, main:font, ConsoleEditControl
IniWrite, f2f2f2, Settings.ini, LastSettings, cmdColor
return

DefaultConsoleColor:
Gui, main:font, cece5cb
GuiControl, main:font, ConsoleEditControl
IniWrite, ece5cb, Settings.ini, LastSettings, cmdColor
return

;Grab a custom Hex value under mouse cursor
CustomConsoleColor:
KeyWait, LButton
gosub, OpenServerWindow
SetTimer, UpdateColor, 10	   ;Eyedropper tool timer
return

UpdateColor:
CoordMode, mouse, screen
CoordMode, Pixel, Screen
MouseGetPos, posX, posY
PixelGetColor, color, posX, posY, RGB
color := SubStr(color, 3, 6)
Gui, eyedropperColor:Color, %color%
posX += 40
posY += 40
posXtext := posX + 45
Gui, eyedropperColor:Show, x%posX% y%posY% w30 h30
Gui, eyedropperText:Show, x%posXtext% y%posY% w60 h30
GuiControl, eyedropperText:, HexValue, %color%
GetKeyState, state, LButton, P
If (state = "D")
{
Gui, eyedropperColor:hide
Gui, eyedropperText:hide
Gui, main:font, c%color%
GuiControl, main:font, ConsoleEditControl
IniWrite, %color%, Settings.ini, LastSettings, cmdColor
gosub, OpenServerWindow
SetTimer, UpdateColor, Delete
}
return

;Freeze console updates
ToggleConsoleUpdates:
if (LogStatus != 1)
{
	SetTimer, WatchLogFile, on
	GuiControl, main:, freezeButtonPicVar, %A_ScriptDir%\Images\Custom gui controls\freezeButton.png
	LogStatus := 1
}
else if (LogStatus = 1)
{
	SetTimer, WatchLogFile, off
	GuiControl, main:, freezeButtonPicVar, %A_ScriptDir%\Images\Custom gui controls\unfreezeButton.png
	LogStatus := 0
}
return


SendConsoleCode:
gui main:submit, nohide
DetectHiddenWindows, on	;(DetectHiddenWindows, on) conflicts with the console edit control when it needs to scroll down(keep it disabled by default)
if WinExist("ahk_exe srcds_win64.exe")
{
	if (ExtraConsoleCode != "None")
	prefixCode := ExtraConsoleCode . A_Space
	sendCode := prefixCode . UserCode
	SavedClip := ClipboardAll  ;Save all clipboard contents inside a variable, send the code to the srcds console and restore all clipboard contents
	Clipboard := sendCode
	ControlSend, , ^v, ahk_exe srcds_win64.exe
	ControlSend, , {Enter}, ahk_exe srcds_win64.exe
	Clipboard := SavedClip
	GuiControl, main:, UserCode
}
DetectHiddenWindows, off
return


;Track current active control
SendOnEnter:
ControlGetFocus, focusedControl, Server Boss
return


;Grab fakeIP from console.log
FetchFakeIP:
FileRead, fileContents, %OutDir%\tf\console.log
lineNumber := 0
ipPort := ""
Loop, Parse, fileContents, `n, `r
{
	lineNumber++
	If InStr(A_LoopField, "FakeIP allocation succeeded:")
	{
		RegExMatch(A_LoopField, "FakeIP allocation succeeded: (\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}:\d+)", Match)
		ipPort := Match1
		Clipboard := "Connect" . A_Space . ipPort
		ToolTip, Fake IP copied to Clipboard! `nIP: %ipPort%
		SetTimer, hideTooltip, -3000
		SetTimer, FetchFakeIP, Delete
		break
	}
	If ErrorLevel 1
	SetTimer, FetchFakeIP, -1000
}
return


WriteAdvancedSettings:
gui advanced:submit, nohide
IniWrite, %LanInternetVar%, Settings.ini, LastSettings, LanInternetVar
IniWrite, %PortVar%, Settings.ini, LastSettings, PortVar
IniWrite, %SVpureVar%, Settings.ini, LastSettings, SVpureVar
IniWrite, %SVlanVar%, Settings.ini, LastSettings, SVlanVar
IniWrite, %FakeIPVar%, Settings.ini, LastSettings, FakeIPVar
return

ReadAdvancedSettings:
Iniread, LanInternetVar, Settings.ini, LastSettings, LanInternetVar
Iniread, PortVar, Settings.ini, LastSettings, PortVar
Iniread, SVpureVar, Settings.ini, LastSettings, SVpureVar
Iniread, SVlanVar, Settings.ini, LastSettings, SVlanVar
Iniread, FakeIPVar, Settings.ini, LastSettings, FakeIPVar
return

ApplyAdvancedSettings:
GuiControl, advanced:Choose, LanInternetVar, %LanInternetVar%
GuiControl, advanced:, PortVar, %PortVar%
GuiControl, advanced:Choose, SVpureVar, %SVpureVar%
GuiControl, advanced:Choose, SVlanVar, %SVlanVar%
GuiControl, advanced:, FakeIPVar, %FakeIPVar%
return


botguiGuiClose:
gosub, BotControlGui
return

BotControlGui:
DetectHiddenWindows, on
If WinExist("ahk_exe srcds_win64.exe")
{
	If (BotControlGuiOpen != 1)
	{
		BotControlGuiOpen := 1
		gui botgui:show
	}
	else if (BotControlGuiOpen = 1)
	{
		gui botgui:hide
		BotControlGuiOpen := 0
	}
}
else
{
	ToolTip, Server not running!
	SetTimer, hideTooltip, -2000
}
DetectHiddenWindows, off
return


kickguiGuiClose:
gosub, KickPlayerGui
return

KickPlayerGui:
DetectHiddenWindows, on
If WinExist("ahk_exe srcds_win64.exe")
{
	If (toggleKickPlayerGui != 1)
	{
		gui kickgui:show
		toggleKickPlayerGui := 1
	}
	else if (toggleKickPlayerGui = 1)
	{
		gui kickgui:hide
		toggleKickPlayerGui := 0
	}
}
else
{
	ToolTip, Server not running!
	SetTimer, hideTooltip, -2000
}
DetectHiddenWindows, off
return

NavGenerate:
DetectHiddenWindows, on
SavedClip := ClipboardAll
Clipboard := "sv_cheats 1; nav_generate"
ControlSend, , ^v, ahk_exe srcds_win64.exe
ControlSend, , {Enter}, ahk_exe srcds_win64.exe
Clipboard := SavedClip
DetectHiddenWindows, off
return

AddtfBot:
gui botgui:submit, nohide
DetectHiddenWindows, on
AddBotNumberTx := ""
AddBotClassTx := ""
AddBotTeamTx := ""
AddBotDifficultyTx := ""
AddBotNameTx := ""
if (AddBotNumber != "")
AddBotNumberTx := AddBotNumber . A_Space
if (AddBotClass != "Random")
AddBotClassTx := AddBotClass . A_Space
if (AddBotTeam != "Any")
AddBotTeamTx := AddBotTeam . A_Space
if (AddBotDifficulty != "None")
AddBotDifficultyTx := AddBotDifficulty . A_Space
if (AddBotName != "")
AddBotNameTx := AddBotName . A_Space
Addbot := "tf_bot_add" . A_Space . AddBotNumberTx . AddBotClassTx . AddBotTeamTx . AddBotDifficultyTx . AddBotNameTx
SavedClip := ClipboardAll  ;Save all clipboard contents inside a variable
Clipboard := Addbot
ControlSend, , ^v, ahk_exe srcds_win64.exe
ControlSend, , {Enter}, ahk_exe srcds_win64.exe
Clipboard := SavedClip
DetectHiddenWindows, off
return

KickBot:
gui botgui:submit, nohide
DetectHiddenWindows, on
KickBotNameVar := "Kick" . A_Space . KickBotNameVar
SavedClip := ClipboardAll  ;Save all clipboard contents inside a variable
Clipboard := KickBotNameVar
ControlSend, , ^v, ahk_exe srcds_win64.exe
ControlSend, , {Enter}, ahk_exe srcds_win64.exe
Clipboard := SavedClip
GuiControl, botgui:, KickBotNameVar,
DetectHiddenWindows, off
return

KickAllBots:
DetectHiddenWindows, on
SavedClip := ClipboardAll  ;Save all clipboard contents inside a variable
Clipboard := "tf_bot_kick all"
ControlSend, , ^v, ahk_exe srcds_win64.exe
ControlSend, , {Enter}, ahk_exe srcds_win64.exe
Clipboard := SavedClip
DetectHiddenWindows, off
return

ChangeBotDifficulty:
gui botgui:submit, nohide
DetectHiddenWindows, on
if (ChangeBotDifficultyVar = "None")
ChangeBotDifficultySend := ""
if (ChangeBotDifficultyVar = "Easy")
ChangeBotDifficultySend := "tf_bot_difficulty 0"
if (ChangeBotDifficultyVar = "Normal")
ChangeBotDifficultySend := "tf_bot_difficulty 1"
if (ChangeBotDifficultyVar = "Hard")
ChangeBotDifficultySend := "tf_bot_difficulty 2"
if (ChangeBotDifficultyVar = "Expert")
ChangeBotDifficultySend := "tf_bot_difficulty 3"
SavedClip := ClipboardAll  ;Save all clipboard contents inside a variable
Clipboard := ChangeBotDifficultySend
ControlSend, , ^v, ahk_exe srcds_win64.exe
ControlSend, , {Enter}, ahk_exe srcds_win64.exe
Clipboard := SavedClip
DetectHiddenWindows, off
return

ForceBotClass:
gui botgui:submit, nohide
DetectHiddenWindows, on
ForceBotClassSend := "tf_bot_force_class" . A_Space . ForceBotClassVar
if (ForceBotClassVar = "None")
ForceBotClassSend := ""
SavedClip := ClipboardAll  ;Save all clipboard contents inside a variable
Clipboard := ForceBotClassSend
ControlSend, , ^v, ahk_exe srcds_win64.exe
ControlSend, , {Enter}, ahk_exe srcds_win64.exe
Clipboard := SavedClip
DetectHiddenWindows, off
return

BotTauntOnKillChance:
gui botgui:submit, nohide
DetectHiddenWindows, on
BotTauntOnKillChanceSend := "tf_bot_taunt_victim_chance" . A_Space . BotTauntOnKillChanceVar
SavedClip := ClipboardAll  ;Save all clipboard contents inside a variable
Clipboard := BotTauntOnKillChanceSend
ControlSend, , ^v, ahk_exe srcds_win64.exe
ControlSend, , {Enter}, ahk_exe srcds_win64.exe
Clipboard := SavedClip
DetectHiddenWindows, off
return

BotQuota:
gui botgui:submit, nohide
DetectHiddenWindows, on
BotQuotaSend := "tf_bot_quota" . A_Space . BotQuotaVar
BotQuotaFillModeSend := "tf_bot_quota_mode" . A_Space . BotQuotaFillModeVar
quotaSend := BotQuotaSend . ";" . A_Space . BotQuotaFillModeSend
SavedClip := ClipboardAll  ;Save all clipboard contents inside a variable
Clipboard := quotaSend
ControlSend, , ^v, ahk_exe srcds_win64.exe
ControlSend, , {Enter}, ahk_exe srcds_win64.exe
Clipboard := SavedClip
DetectHiddenWindows, off
return

BotJoinAfterPlayer:
gui botgui:submit, nohide
DetectHiddenWindows, on
BotJoinAfterPlayerSend := "tf_bot_join_after_player" . A_Space . BotJoinAfterPlayerVar
SavedClip := ClipboardAll  ;Save all clipboard contents inside a variable
Clipboard := BotJoinAfterPlayerSend
ControlSend, , ^v, ahk_exe srcds_win64.exe
ControlSend, , {Enter}, ahk_exe srcds_win64.exe
Clipboard := SavedClip
DetectHiddenWindows, off
return

ChangeBotClassOnDeath:
gui botgui:submit, nohide
DetectHiddenWindows, on
ChangeBotClassOnDeathSend := "tf_bot_keep_class_after_death" . A_Space . ChangeBotClassOnDeathVar
SavedClip := ClipboardAll  ;Save all clipboard contents inside a variable
Clipboard := ChangeBotClassOnDeathSend
ControlSend, , ^v, ahk_exe srcds_win64.exe
ControlSend, , {Enter}, ahk_exe srcds_win64.exe
Clipboard := SavedClip
DetectHiddenWindows, off
return

ShowBotDifficulty:
gui botgui:submit, nohide
DetectHiddenWindows, on
ShowBotDifficultySend := "tf_bot_prefix_name_with_difficulty" . A_Space . ShowBotDifficultyVar
SavedClip := ClipboardAll  ;Save all clipboard contents inside a variable
Clipboard := ShowBotDifficultySend
ControlSend, , ^v, ahk_exe srcds_win64.exe
ControlSend, , {Enter}, ahk_exe srcds_win64.exe
Clipboard := SavedClip
DetectHiddenWindows, off
return

ForceBotMeleeOnly:
gui botgui:submit, nohide
DetectHiddenWindows, on
ForceBotMeleeOnlySend := "tf_bot_melee_only" . A_Space . ForceBotMeleeOnlyVar
SavedClip := ClipboardAll  ;Save all clipboard contents inside a variable
Clipboard := ForceBotMeleeOnlySend
ControlSend, , ^v, ahk_exe srcds_win64.exe
ControlSend, , {Enter}, ahk_exe srcds_win64.exe
Clipboard := SavedClip
DetectHiddenWindows, off
return

KickPlayer:
gui kickgui:submit, nohide
DetectHiddenWindows, on
KickPlayerVar := "Kick" . A_Space . KickPlayerVar
SavedClip := ClipboardAll  ;Save all clipboard contents inside a variable
Clipboard := KickPlayerVar
ControlSend, , ^v, ahk_exe srcds_win64.exe
ControlSend, , {Enter}, ahk_exe srcds_win64.exe
Clipboard := SavedClip
GuiControl, kickgui:, KickPlayerVar,
DetectHiddenWindows, off
return

ToggleConsole:
DetectHiddenWindows, on
If WinExist("ahk_exe srcds_win64.exe")
{
	If (toggleSrcdsConsole != 1)
	{
		WinShow, ahk_exe srcds_win64.exe
		WinActivate, ahk_exe srcds_win64.exe
		toggleSrcdsConsole := 1
	}
	else if (toggleSrcdsConsole = 1)
	{
		WinHide, ahk_exe srcds_win64.exe
		toggleSrcdsConsole := 0
	}
}
else
{
	ToolTip, Server not running!
	SetTimer, hideTooltip, -2000
}
DetectHiddenWindows, off
return


hideTooltip:
ToolTip
return

