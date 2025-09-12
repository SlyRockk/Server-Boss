#MaxMem 512
#NoEnv  						;Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance ignore			;Skips the dialog box
#KeyHistory 0
Process, Priority, , H          ;Makes the script to run as high priority
SetBatchLines -1                ;Run script at max speed(May affect cpu usage)
ListLines Off
SendMode Input					;Recommended for new scripts due to its superior speed and reliability.
SetTitleMatchMode 2
SetTitleMatchMode Fast
SetKeyDelay, -1, -1, Play
SetMouseDelay, -1
SetWinDelay, 0
SetControlDelay, 0
SetDefaultMouseSpeed, 0
DetectHiddenWindows, on
DetectHiddenText, on
SetWorkingDir %A_ScriptDir%  	;Ensures a consistent starting directory.
OnExit("ExitFunc")

/*======================================================================================
Name: 			Server Boss v0.1.0
Date created: 	19.08.2024
Last edit:		12.09.2025
Made by:		SlyRockk
Project link: 	https://github.com/SlyRockk/Server-Boss
License:        GPL v3
AHK version:    1.1

Server Boss fundations:
For those who wish to continue or improve my work, I leave these eight guiding principles to help you understand what makes this tool unique
1. Customizable - the user must be able to personalize their own server - (this can be achieved by offering more options/features)
2. Flexible - an action or a function sould be achievable by more than one way - (ex: a map can be added from the file browser but can also be added by drag and drop)
3. User-friendly - if a kid can understand it then everyone could - (the ui should be simple to the point that at a first glance everybody can know what each button does)
4. Seamless - no details should be overlooked
5. Smart - if an action can be automated to the point of a single click then it should be - (Don't overdo it)
7. Stable - a software that doesn't work at all is no different than one that doesn't exist
8. Experimental - the most important feature. The power to come up with new solutions to a problem no matter how silly or dumb they can be
*/======================================================================================

;Invert contex menu colors
;_______________________________________________________________________________________
contextcolor()
contextcolor(color := 2)
{
    static uxtheme := DllCall("GetModuleHandle", "str", "uxtheme", "ptr")
    static SetPreferredAppMode := DllCall("GetProcAddress", "ptr", uxtheme, "ptr", 135, "ptr")
    static FlushMenuThemes := DllCall("GetProcAddress", "ptr", uxtheme, "ptr", 136, "ptr")
    DllCall(SetPreferredAppMode, "int", color)
    DllCall(FlushMenuThemes)
}

;Remove ahk's default tray menu setup
;---------------------------------------------------------------------------------------
if FileExist(A_ScriptDir . "\Server Boss All\Images\Icons\Server boss.ico")     	  ;Check for custom tray icon
try Menu, Tray, Icon, %A_ScriptDir%\Server Boss All\Images\Icons\Server boss.ico
try menu, tray, NoStandard                                                                ;Remove ahk's default tray menu
try menu, tray, add, Exit, CloseProgram						                              ;Close Server Boss completely if exit is selected in the tray menu
;---------------------------------------------------------------------------------------

;Unpack images/gifs/settings etc.
;---------------------------------------------------------------------------------------
if !FileExist(A_ScriptDir . "\Server Boss All") and (A_IsCompiled = 1)
{
	FileInstall, Server Boss All.zip, %A_ScriptDir%\Server Boss All.zip, 0
	UnzipWithCMDCode := "cd" . A_Space . A_ScriptDir . A_Space . "&& tar -xf" . A_Space . Chr(34) . "Server Boss All.zip" . Chr(34)
	RunWait, %comspec% /k %UnzipWithCMDCode% && exit,, Hide							   ;Use DOS to unzip the file
	FileDelete, %A_ScriptDir%\Server Boss All.zip
}

;____________________________________Splash_Screen______________________________________
gui, SplashGUIWindow:new, -Caption +AlwaysOnTop, Splash image
SplashImageSize := A_ScreenDpi / 96 * 256
gui, SplashGUIWindow:Margin, 0, 0
gui, SplashGUIWindow:Add, ActiveX, x0 y0 w256 h256 border vWB, about:<!DOCTYPE html><meta http-equiv="X-UA-Compatible" content="IE=edge">

HTMLPercent := "%"
HTMLScript =
(
<!DOCTYPE html>
<html>
<head>
<style>
@keyframes rotate {
	from { transform: rotate(0deg); }
	to { transform: rotate(360deg); }
}
</style>
</head>
<body style="background: linear-gradient(140deg, #77352a, #3f2b23); background-size: cover; background-attachment: fixed; background-repeat: no-repeat;">
<img src="%A_ScriptDir%/Server Boss All/Images/Splash image/Transparent_cog.png" style=" position:absolute; width:22%HTMLPercent%; height:22%HTMLPercent%; margin-top: 8%HTMLPercent%; margin-left: 14%HTMLPercent%; animation: rotate 5s linear 0s infinite normal ;">
<img src="%A_ScriptDir%/Server Boss All/Images/Splash image/Transparent_cog.png" style=" position:absolute; width:22%HTMLPercent%; height:22%HTMLPercent%; margin-top: 37%HTMLPercent%; margin-left: 59%HTMLPercent%; animation: rotate 5s linear 0s infinite normal ;">
<img src="%A_ScriptDir%/Server Boss All/Images/Splash image/Front image.png" style="position:absolute;left:0;top:0" width="%SplashImageSize%" height="%SplashImageSize%">
</body>
</html>
)

WB.Document.write(HTMLScript)
WB.Document.close()
gui, SplashGUIWindow:Add, progress, y+0 w256 h20 vLoadingVar cebe2ca BackGround333333 border, 5
gui, SplashGUIWindow:show

;__________________________________About______________________________________
gui, AboutWindow:new, -caption +border, About
gui, AboutWindow:font, cece5cb s14 norm, Impact
gui, AboutWindow:Color, 5f372d, 221f1c
gui, AboutWindow:add, progress, x0 y0 w500 h30 disabled c2d2824 section, 100
gui, AboutWindow:add, picture, xp+20 yp+5 w20 h20 BackgroundTrans border, %A_ScriptDir%\Server Boss All\Images\Icons\Server boss.ico
gui, AboutWindow:add, text, 0x200 x+20 yp-5 w395 h30 gMoveUI BackgroundTrans, About
gui, AboutWindow:add, picture, x+5 yp+5 w20 h20 vAboutWindowCloseWindowPictureButtonVar gAboutWindowCloseWindowPictureButton BackgroundTrans border, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Toolbar_close.png
gui, AboutWindow:Add, ActiveX, xs ys+30 w256 h256 border vAboutActiveXVar, about:<!DOCTYPE html><meta http-equiv="X-UA-Compatible" content="IE=edge">
AboutActiveXVar.Document.write(HTMLScript)
AboutActiveXVar.Document.close()
gui, AboutWindow:add, text, x+25 yp+10 w245 h200, Server Boss`nVersion: 0.1.0`nAHK version: 1.1`nBuild: alpha`nCreation date: 19.08.2024`nLast update: 9.11.2025`nLicense: GPL v3`nMade by: SlyRockk
gui, AboutWindow:add, link, xp y+5 w200 h30, <a href="https://github.com/SlyRockk/Server-Boss">Github</a>

;__________________________________License____________________________________
gui, LicenseWindow:new, -caption +border, License
gui, LicenseWindow:font, cece5cb s14, Impact
gui, LicenseWindow:Color, 5f372d, 221f1c
gui, LicenseWindow:add, progress, x0 y0 w540 h30 disabled c2d2824 section, 100
gui, LicenseWindow:add, picture, xp+20 yp+5 w20 h20 BackgroundTrans border, %A_ScriptDir%\Server Boss All\Images\Icons\Server boss.ico
gui, LicenseWindow:add, text, 0x200 x+20 yp-5 w430 h30 gMoveUI BackgroundTrans, License
gui, LicenseWindow:font, c10900d s14 bold, MS Gothic
gui, LicenseWindow:add, picture, x+5 yp+5 w20 h20 vLicenseWindowClosePictureButtonVar gLicenseWindowClosePictureButton BackgroundTrans border, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Toolbar_close.png
gui, LicenseWindow:add, picture, xs+20 ys+40 w500 h25 BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_image_overlay_top_only.png
gui, LicenseWindow:add, picture, xp y+0 w30 h500 BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_image_overlay_left_only.png
FileRead, LicenseVar, %A_ScriptDir%\Server Boss All\License.txt
gui, LicenseWindow:add, edit, x+0 yp w440 h500 vLicenseWindowEditVar gLicenseWindowEdit -Vscroll -E0x200, % LicenseVar
gui, LicenseWindow:add, picture, x+0 yp w30 h500 BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_image_overlay_right_only.png
gui, LicenseWindow:add, picture, xp-470 y+0 w500 h25 BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_image_overlay_bottom_only.png

;___________________________________Game______________________________________
gui, MainWindow:new, -caption border, Server Boss
gui, MainWindow:font, cece5cb s12, Impact
gui, MainWindow:Color, 653d33, 221f1c
gui, MainWindow:add, progress, x0 y0 w20 h50 disabled c3a2f2d Background3a2f2d, 100
gui, MainWindow:add, progress, xp y+0 w20 h10 disabled c000000 Background000000, 100
gui, MainWindow:add, progress, x0 y+0 w20 h640 disabled c3a2f2d Background3a2f2d, 100        ;Outter left - bar bottom brown
gui, MainWindow:add, progress, x20 y0 w5 h45 disabled c573227 Background573227, 100            ;Inner left - bar top red
gui, MainWindow:add, progress, x20 y45 w1010 h10 disabled c000000 Background000000, 100                                                              ;Middle black bar
gui, MainWindow:add, progress, x1025 y0 w5 h45 disabled c573227 Background573227, 100          ;Inner right - bar top red
gui, MainWindow:add, progress, x+0 yp w20 h50 disabled c3a2f2d Background3a2f2d, 100
gui, MainWindow:add, progress, xp y+0 w20 h10 disabled c000000 Background000000, 100
gui, MainWindow:add, progress, x20 y55 w5 h645 disabled c573227 Background573227, 100          ;Inner left - bar red
gui, MainWindow:add, progress, x1025 yp w5 h640 disabled c573227 Background573227, 100         ;Inner right - bar bottom red
gui, MainWindow:add, progress, x+0 yp+5 w20 h640 disabled c3a2f2d Background3a2f2d, 100      ;Outter right - bar bottom brown
gui, MainWindow:add, progress, x25 y695 w1005 h5 disabled c573227 Background573227, 100        ;Middle red - bar
gui, MainWindow:add, progress, x0 y+0 w1050 h5 disabled c3a2f2d Background3a2f2d, 100        ;Middle brown bar

gui, MainWindow:add, picture, x50 y10 w25 h25 vToolbarIconVar border, %A_ScriptDir%\Server Boss All\Images\Icons\Server boss.ico
gui, MainWindow:add, text, 0x200 x+25 yp w200 h25 gMoveUI BackgroundTrans, Server Boss v0.1.0 - alpha
gui, MainWindow:add, text, 0x200 x+0 yp w95 h25 vToolbarStatusTextVar gMoveUI BackgroundTrans, Status: Idle
gui, MainWindow:add, text, 0x200 x+0 yp w10 h25 gMoveUI BackgroundTrans, |
gui, MainWindow:add, text, 0x200 x+0 yp w125 h25 vToolbarServerTypeTextVar gMoveUI BackgroundTrans, Server type: SDR
gui, MainWindow:add, text, 0x200 x+0 yp w10 h25 gMoveUI BackgroundTrans, |
gui, MainWindow:add, text, 0x200 x+0 yp w225 h25 vToolbarServerExeHostTextVar gMoveUI BackgroundTrans, Host : Dedicated32BitServer
gui, MainWindow:add, text, 0x200 x+25 yp w50 h25 vToolbarRepoTextVar gOpenRepo BackgroundTrans center, Repo
gui, MainWindow:add, text, 0x200 x+0 yp w40 h25 vToolbarPinWindowTextVar gToolbarPinWindowText BackgroundTrans center, Pin
gui, MainWindow:add, text, 0x200 x+0 yp w80 h25 vToolbarMinimizeWindowTextVar gToolbarMinimizeWindowText BackgroundTrans center, Minimize
gui, MainWindow:add, text, 0x200 x+0 yp w45 h25 vToolbarHideWindowTextVar gToolbarHideWindowText BackgroundTrans center, Hide
gosub, SetToolBarSettings

gui, MainWindow:font, cece5cb s16, Impact
gui, MainWindow:add, tab3, vMainWindowTab3Var gMainWindowTab3 x40 y65 w970 h620 Buttons section, Game||Console| | | | | | | |Paths|
gui, MainWindow:add, picture, xs+15 ys+60 w70 h50 vGameShowMapsListPictureVar gGameShowMapsListPicture section, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_menu_pic_button.png
gui, MainWindow:add, picture, xp y+5 w70 h50 vGameAddMapPictureVar gGameAddMapPicture, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Game_add_map_pic_button.png
gui, MainWindow:add, picture, xp y+5 w70 h50 vGameRemoveMapPictureVar gGameRemoveMapPicture, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Game_delete_map_pic_button.png
gui, MainWindow:add, picture, xp y+5 w70 h50 vGameOpenMapFolderPictureVar gGameOpenMapFolderPicture, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Game_open_map_location_pic_button.png
gui, MainWindow:add, picture, xp y+5 w70 h50 vGameSetMapCyclePictureVar gGameSetMapCyclePicture, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Game_mapcycle_list_pic_button.png
gui, MainWindow:add, picture, xp y+5 w70 h50 vGameFilterMapsPictureVar gGameFilterMapsPicture, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Game_filter_pic_button.png
gui, MainWindow:add, picture, xp y+5 w70 h50 vGameShowMapInfoPictureVar gGameShowMapInfoPicture, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Game_map_info_pic_button.png
gui, MainWindow:add, picture, xp y+5 w70 h50 vGameOpenMapWikiPictureVar gGameOpenMapWikiPicture, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Game_open_wiki_map_page_pic_button.png
gui, MainWindow:add, picture, xp y+5 w70 h50 vGameOpenMapWorkshopPagePictureVar gGameOpenMapWorkshopPagePicture, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Game_open_workshop_map_page_pic_button.png
gui, MainWindow:add, picture, xp y+5 w70 h50 vGameSelectRandomMapPictureVar gGameSelectRandomMapPicture, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Game_pick_random_map_pic_button.png
gui, MainWindow:add, text, 0x200 x+25 ys w390 h40 center section, Choose map:
gui, MainWindow:add, text, 0x200 x+20 yp w430 h40 vGameMapNameTextVar center, Map name
gui, MainWindow:add, picture, xs y+20 w390 h35 BackgroundTrans section, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Vertical_console_image_overlay_top_only.png
gui, MainWindow:add, picture, xs y+0 w35 h415 BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Vertical_console_image_overlay_left_only.png
gui, MainWindow:font, c10900d s14 bold, MS Gothic
gui, MainWindow:add, listbox, 0x100 x+0 yp w321 h385 vGameMapsListLBVar gGameMapsListLB -VScroll -border -E0x200
gosub, ScanForMaps
gui, MainWindow:font, c10900d s14 bold, MS Gothic
gui, MainWindow:add, Progress, xp y+0 w30 h30 vGameMapsPreviousPageProgressVar c221f1c Background221f1c disabled -border
gui, MainWindow:add, text, xp yp w30 h30 vGameMapsPreviousPageTextVar gGameMapsPreviousPageText c646464 center BackgroundTrans border, % Chr(0x2B06)
gui, MainWindow:add, Progress, x+0 yp w30 h30 vGameMapsNextPageProgressVar c221f1c Background221f1c disabled -border
gui, MainWindow:add, text, xp yp w30 h30 vGameMapsNextPageTextVar gGameMapsNextPageText c646464 center BackgroundTrans border, % Chr(0x2B07)
gui, MainWindow:add, edit, x+0 yp w240 h30 vGameMapsSearchMapEditVar gGameMapsSearchMapEdit -Vscroll -E0x200 border
gui, MainWindow:font, ceee4be s14 norm, Impact
gui, MainWindow:add, Progress, x+0 yp w20 h30 vGameMapsClearMapSearchProgressVar Background221f1c disabled
gui, MainWindow:add, text, 0x200 xp yp w20 h30 vGameMapsClearMapSearchTextVar gGameMapsClearMapSearchText c646464 center BackgroundTrans border, x
gui, MainWindow:add, picture, x+0 ys+35 w35 h415 BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Vertical_console_image_overlay_right_only.png
gui, MainWindow:add, picture, xs y+0 w390 h35 BackgroundTrans , %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Vertical_console_image_overlay_bottom_only.png
gui, MainWindow:add, picture, x+35 ys w400 h40 BackgroundTrans disabled section, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_image_overlay_2_top_only.png
gui, MainWindow:add, picture, xs ys+40 w55 h205 BackgroundTrans disabled, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_image_overlay_2_left_only.png
gui, MainWindow:add, ActiveX, x+0 yp w290 h205 vGameMapsDisplayImageActiveXVar, about:<!DOCTYPE html><meta http-equiv="X-UA-Compatible" content="IE=edge">
gui, MainWindow:add, picture, x+0 yp w55 h205 BackgroundTrans disabled, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_image_overlay_2_right_only.png
gui, MainWindow:add, picture, xs y+0 w400 h40 BackgroundTrans disabled, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_image_overlay_2_bottom_only.png
gui, MainWindow:font, cece5cb s16 norm, Impact
gui, MainWindow:add, text, 0x200 xs-15 y+25 w120 h30 section, Server name
gui, MainWindow:font, cece5cb s14 norm, Impact
gui, MainWindow:add, edit, x+10 yp w190 h30 vGameServerNameEditVar gGameServerNameEdit
gui, MainWindow:font, cece5cb s16 norm, Impact
gui, MainWindow:add, text, 0x200 xs y+5 w120 h30, Max. players
gui, MainWindow:font, cece5cb s14 norm, Impact
gui, MainWindow:add, edit, x+10 yp w50 h30 vGameMaxPlayersEditVar gGameMaxPlayersEdit number limit2
gui, MainWindow:font, ceee4be s12 norm, Impact
gui, MainWindow:add, Progress, x+0 yp w80 h30 vGameSetMaxPlayersForCasualProgressVar c221f1c disabled, 100
gui, MainWindow:add, text, 0x200 xp yp w80 h30 vGameSetMaxPlayersForCasualTextVar gGameSetMaxPlayersForCasualText c646464 center BackgroundTrans, Casual
gui, MainWindow:add, Progress, x+0 yp w60 h30 vGameSetMaxPlayersForMVMProgressVar c221f1c disabled, 100
gui, MainWindow:add, text, 0x200 xp yp w60 h30 vGameSetMaxPlayersForMVMTextVar gGameSetMaxPlayersForMVMText c646464 center BackgroundTrans, MVM
gui, MainWindow:font, cece5cb s16 norm, Impact
gui, MainWindow:add, text, 0x200 xs y+5 w120 h30, Password
gui, MainWindow:font, cece5cb s14 norm, Impact
gui, MainWindow:add, edit, x+10 yp w160 h30 vGameServerPasswordEditVar gGameServerPasswordEdit
gui, MainWindow:font, ceee4be s12 norm, Impact
gui, MainWindow:add, Progress, x+0 yp w30 h30 vGameGenerateServerPasswordProgressVar c221f1c disabled, 100
gui, MainWindow:add, text, 0x200 xp yp w30 h30 vGameGenerateServerPasswordTextVar gGameGenerateServerPasswordText c646464 center BackgroundTrans, % Chr(0x2699)
gui, MainWindow:add, picture, x+20 ys+5 w90 h90 vGameServerPasswordPictureButtonVar gGameServerPasswordPictureButton BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Rotary_switch_state_1_pic_button.png
gui, MainWindow:font, cece5cb s16, Impact
gui, MainWindow:add, picture, xs ys+125 w70 h50 vGameAddImageWindowVar gGameAddImageWindow, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Game_add_picture_pic_button.png
gui, MainWindow:add, picture, x+20 yp w70 h50 vGameShowAdvancedWindowVar gGameShowAdvancedWindow, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Paths_cog_wheel_pic_button.png
gui, MainWindow:add, picture, x+20 yp w70 h50 vGameRestartServerVar gGameRestartServer, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Game_restart_server_pic_button.png
gui, MainWindow:add, picture, x+20 yp w70 h50 vGameStopServerVar gGameStopServer, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Game_stop_server_pic_button.png
gui, MainWindow:add, picture, x+20 yp w70 h50 vGameStartServerVar gGameStartServer, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Game_start_server_pic_button.png
GuiControl, SplashGUIWindow:, LoadingVar, 15

gui, GameSearchForMapsOnlineWindow:new, -caption +border, Search for maps online
gui, GameSearchForMapsOnlineWindow:font, cece5cb s12 norm, Impact
gui, GameSearchForMapsOnlineWindow:Color, 653d33, 221f1c
gui, GameSearchForMapsOnlineWindow:add, progress, x0 y0 w310 h30 disabled c2d2824 section, 100
gui, GameSearchForMapsOnlineWindow:add, text, 0x200 xp+20 yp w280 h30 gMoveUI BackgroundTrans, Map options
gui, GameSearchForMapsOnlineWindow:font, cece5cb s12, Impact
gui, GameSearchForMapsOnlineWindow:add, picture, xs+20 ys+50 w270 h20 section, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_image_overlay_top_only.png
gui, GameSearchForMapsOnlineWindow:add, picture, xp y+0 w15 h160, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_image_overlay_left_only.png
gui, GameSearchForMapsOnlineWindow:font, c10900d s11 bold underline, Courier New
gui, GameSearchForMapsOnlineWindow:add, Progress, x+0 yp w240 h20 c221f1c Background221f1c disabled -border
gui, GameSearchForMapsOnlineWindow:add, text, 0x200 xp yp w240 h20 BackgroundTrans, Websites                                    _
gui, GameSearchForMapsOnlineWindow:font, c10900d s11 bold norm, Courier New
gui, GameSearchForMapsOnlineWindow:add, listbox, 0x100 xp y+0 w240 h140 vGameSearchForMapsOpenWebsiteLBVar gGameSearchForMapsOpenWebsiteLB -Vscroll -E0x200, Gamebanana|TF2 Map Archive|17buddies|Rotabland
gui, GameSearchForMapsOnlineWindow:add, picture, x+0 yp-20 w15 h160, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_image_overlay_right_only.png
gui, GameSearchForMapsOnlineWindow:add, picture, xp-255 y+0 w270 h20, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_image_overlay_bottom_only.png
gui, GameSearchForMapsOnlineWindow:add, picture, xs y+20 w70 h50 vGameSearchForMapsRescanMapsPictureButtonVar gGameSearchForMapsRescanMapsPictureButton, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Game_rescan_maps_pic_button.png
gui, GameSearchForMapsOnlineWindow:font, ceee4be s12 norm, Impact
gui, GameSearchForMapsOnlineWindow:add, text, x+10 yp w200 h30, Rescan all maps


gui, GameDeleteMapWindow:new, -caption +border, Delete map
gui, GameDeleteMapWindow:font, cece5cb s14 norm, Impact
gui, GameDeleteMapWindow:Color, 5f372d, 221f1c
gui, GameDeleteMapWindow:add, progress, x0 y0 w570 h30 disabled c2d2824 section, 100
gui, GameDeleteMapWindow:add, text, 0x200 xp+20 yp w445 h30 gMoveUI BackgroundTrans, Delete map
gui, GameDeleteMapWindow:add, picture, x+10 yp+5 w20 h20 vGameDeleteMapAlwaysOnTopWindowPictureButtonVar gGameDeleteMapAlwaysOnTopWindowPictureButton BackgroundTrans border, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Toolbar_pin_window_off.png
gui, GameDeleteMapWindow:add, picture, x+5 yp w20 h20 vGameDeleteMapMinimizeWindowPictureButtonVar gGameDeleteMapMinimizeWindowPictureButton BackgroundTrans border, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Toolbar_minimize.png
gui, GameDeleteMapWindow:add, picture, x+5 yp w20 h20 vGameDeleteMapCloseWindowPictureButtonVar gGameDeleteMapCloseWindowPictureButton BackgroundTrans border, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Toolbar_close.png
gui, GameDeleteMapWindow:font, c10900d s12 bold norm, Courier New
gui, GameDeleteMapWindow:add, picture, xs+20 y+20 w440 h25 section, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_image_overlay_top_only.png
gui, GameDeleteMapWindow:add, picture, xp y+0 w25 h260, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_image_overlay_left_only.png
gui, GameDeleteMapWindow:add, edit, x+0 yp w390 h260 vGameDeleteMapWindowEditVar -VScroll -E0x200
gui, GameDeleteMapWindow:add, picture, x+0 ys+25 w25 h260, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_image_overlay_right_only.png
gui, GameDeleteMapWindow:add, picture, xs y+0 w440 h25, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_image_overlay_bottom_only.png
gui, GameDeleteMapWindow:add, picture, x+20 ys+20 w70 h50 vGameDeleteMapWindowDeleteMapPictureButtonVar gGameDeleteMapWindowDeleteMapPictureButton, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Accept_pic_button.png
gui, GameDeleteMapWindow:add, picture, xp y+10 w70 h50 vGameDeleteMapWindowCloseWindowPictureButtonVar gGameDeleteMapWindowCloseWindowPictureButton, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Cancel_pic_button.png

gui, GameMapCycleWindow:new, -caption +border, Map cycle
gui, GameMapCycleWindow:font, cece5cb s14 norm, Impact
gui, GameMapCycleWindow:Color, 5f372d, 221f1c
gui, GameMapCycleWindow:add, progress, x0 y0 w750 h30 disabled c2d2824 section, 100
gui, GameMapCycleWindow:add, text, 0x200 xp+20 yp w625 h30 gMoveUI BackgroundTrans, Add/remove maps from map cycle
gui, GameMapCycleWindow:add, picture, x+5 yp+5 w20 h20 vGameMapCycleAlwaysOnTopWindowPictureButtonVar gGameMapCycleAlwaysOnTopWindowPictureButton BackgroundTrans border, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Toolbar_pin_window_off.png
gui, GameMapCycleWindow:add, picture, x+5 yp w20 h20 vGameMapCycleMinimizeWindowPictureButtonVar gGameMapCycleMinimizeWindowPictureButton BackgroundTrans border, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Toolbar_minimize.png
gui, GameMapCycleWindow:add, picture, x+5 yp w20 h20 vGameMapCycleCloseWindowPictureButtonVar gGameMapCycleCloseWindowPictureButton BackgroundTrans border, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Toolbar_close.png
gui, GameMapCycleWindow:font, c10900d s12 bold norm, Courier New
gui, GameMapCycleWindow:add, picture, xs+20 y+20 w240 h25 section, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Vertical_console_image_overlay_top_only.png
gui, GameMapCycleWindow:add, picture, xp y+0 w20 h260, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Vertical_console_image_overlay_left_only.png
gui, GameMapCycleWindow:font, c10900d s11 bold underline, Courier New
gui, GameMapCycleWindow:add, Progress, x+0 yp w200 h20 c221f1c Background221f1c disabled -border
gui, GameMapCycleWindow:add, text, 0x200 xp yp w200 h20 BackgroundTrans, Map list                                    _
gui, GameMapCycleWindow:font, c10900d s11 bold norm, Courier New
gui, GameMapCycleWindow:add, listbox, 0x100 xp y+0 w200 h215 vGameMapCycleWindowLBVar gGameMapCycleWindowLB -Vscroll -E0x200
gui, GameMapCycleWindow:add, edit, xp y+0 w180 h25 vGameMapCycleWindowSearchMapEditVar gGameMapCycleWindowSearchMapEdit -E0x200 border
gui, GameMapCycleWindow:font, ceee4be s12 norm, Impact
gui, GameMapCycleWindow:add, Progress, x+0 yp w20 h25 vGameMapCycleClearSearchMapProgressVar Background221f1c disabled
gui, GameMapCycleWindow:add, text, 0x200 xp yp w20 h25 vGameMapCycleClearSearchMapEditVar gGameMapCycleClearSearchMapEdit c646464 center BackgroundTrans border, x
gui, GameMapCycleWindow:font, c10900d s11 bold norm, Courier New
gui, GameMapCycleWindow:add, picture, x+0 yp-235 w20 h260, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Vertical_console_image_overlay_right_only.png
gui, GameMapCycleWindow:add, picture, xp-220 y+0 w240 h25, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Vertical_console_image_overlay_bottom_only.png
gui, GameMapCycleWindow:add, picture, xs+260 ys+95 w70 h50 vGameAddMapToMapCyclePictureButtonVar gGameAddMapToMapCyclePictureButton, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Add_pic_button.png
gui, GameMapCycleWindow:add, picture, xp y+10 w70 h50 vGameRemoveMapToMapCyclePictureButtonVar gGameRemoveMapToMapCyclePictureButton, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Remove_pic_button.png
gui, GameMapCycleWindow:add, picture, x+20 ys w360 h20 section, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_image_overlay_top_only.png
gui, GameMapCycleWindow:add, picture, xp y+0 w20 h270, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_image_overlay_left_only.png
gui, GameMapCycleWindow:add, edit, x+0 yp w320 h270 vGameMapCycleListEditVar gGameMapCycleListEdit -Vscroll -E0x200
gui, GameMapCycleWindow:add, picture, x+0 yp w20 h270, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_image_overlay_right_only.png
gui, GameMapCycleWindow:add, picture, xp-340 y+0 w360 h20, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_image_overlay_bottom_only.png

gui, GameFilterMapsWindow:new, -caption +border, Filter maps
gui, GameFilterMapsWindow:font, cece5cb s12 norm, Impact
gui, GameFilterMapsWindow:Color, 653d33, 221f1c
gui, GameFilterMapsWindow:add, progress, x0 y0 w310 h30 disabled c2d2824 section, 100
gui, GameFilterMapsWindow:add, text, 0x200 xp+20 yp w280 h30 gMoveUI BackgroundTrans, Filter maps
gui, GameFilterMapsWindow:font, cece5cb s12, Impact
gui, GameFilterMapsWindow:add, picture, xs+20 ys+50 w270 h20 section, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_image_overlay_top_only.png
gui, GameFilterMapsWindow:add, picture, xp y+0 w15 h160, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_image_overlay_left_only.png
gui, GameFilterMapsWindow:font, c10900d s11 bold underline, Courier New
gui, GameFilterMapsWindow:add, Progress, x+0 yp w240 h20 c221f1c Background221f1c disabled -border
gui, GameFilterMapsWindow:add, text, 0x200 xp yp w240 h20 BackgroundTrans, Gamemodes                                    _
gui, GameFilterMapsWindow:font, c10900d s11 bold norm, Courier New
gui, GameFilterMapsWindow:add, listbox, 0x100 xp y+0 w240 h140 vGameFilterMapsLBVar gGameFilterMapsLB -Vscroll -E0x200, arena_|cp_|ctf_|koth_|mvm_|pass_|pd_|pl_|plr_|sd_|rd_|tc_|vsh_|zi_
gui, GameFilterMapsWindow:add, picture, x+0 yp-20 w15 h160, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_image_overlay_right_only.png
gui, GameFilterMapsWindow:add, picture, xp-255 y+0 w270 h20, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_image_overlay_bottom_only.png
GuiControl, SplashGUIWindow:, LoadingVar, 25

gosub, ReadAdvancedSettingsFromINI
IniWrite, 0, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, ToggleGameAdvancedWindowOnTop
gui, GameAdvancedWindow:new, -caption +border, Advanced
gui, GameAdvancedWindow:font, cece5cb s14 norm, Impact
gui, GameAdvancedWindow:Color, 5f372d, 221f1c
gui, GameAdvancedWindow:add, progress, x0 y0 w1560 h30 disabled c2d2824 section, 100
gui, GameAdvancedWindow:add, text, 0x200 xp+20 yp w1370 h30 gMoveUI BackgroundTrans, Advanced
gui, GameAdvancedWindow:add, picture, x+10 yp+5 w20 h20 vGameAdvancedWindowHostsPictureButtonVar gGameAdvancedWindowHostsPictureButton BackgroundTrans border, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Toolbar_servers.png
gui, GameAdvancedWindow:add, picture, x+5 yp w20 h20 vGameAdvancedWindowSettingsPictureButtonVar gGameAdvancedWindowSettingsPictureButton BackgroundTrans border, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Toolbar_more_settings_window.png
gui, GameAdvancedWindow:add, picture, x+5 yp w20 h20 vGameAdvancedWindowAlwaysOnTopWindowPictureButtonVar gGameAdvancedWindowAlwaysOnTopWindowPictureButton BackgroundTrans border, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Toolbar_pin_window_off.png
gui, GameAdvancedWindow:add, picture, x+5 yp w20 h20 vGameAdvancedWindowMinimizeWindowPictureButtonVar gGameAdvancedWindowMinimizeWindowPictureButton BackgroundTrans border, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Toolbar_minimize.png
gui, GameAdvancedWindow:add, picture, x+5 yp w20 h20 vGameAdvancedWindowCloseWindowPictureButtonVar gGameAdvancedWindowCloseWindowPictureButton BackgroundTrans border, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Toolbar_close.png
gui, GameAdvancedWindow:font, cece5cb s18 norm, Impact

gui, GameAdvancedWindow:add, tab2, x40 y65 w190 h660 vAdvancedWindowTab2Var gAdvancedWindowTab2 Buttons section +wrap, Server|Connection|SourceTV|Votes|Map| | | | | | | | | | | |
gui, GameAdvancedWindow:tab, Server
gui, GameAdvancedWindow:font, cece5cb s16 norm, Impact
gui, GameAdvancedWindow:add, groupbox, xs+220 yp-15 w790 h530 section, Server
gui, GameAdvancedWindow:font, cece5cb s12 norm, Impact
gui, GameAdvancedWindow:add, picture, xs+30 yp+40 w40 h95 vAdvancedWindowAllowDownloadPictureButtonVar gAdvancedWindowAllowDownloadPictureButton BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png
gui, GameAdvancedWindow:add, picture, x+5 yp w40 h95 vAdvancedWindowAllowUploadPictureButtonVar gAdvancedWindowAllowUploadPictureButton BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png
gui, GameAdvancedWindow:add, picture, x+5 yp w40 h95 vAdvancedWindowHideServerPictureButtonVar gAdvancedWindowHideServerPictureButton BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png
gui, GameAdvancedWindow:add, picture, x+5 yp w40 h95 vAdvancedWindowDisableVACPictureButtonVar gAdvancedWindowDisableVACPictureButton BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png
gui, GameAdvancedWindow:add, picture, x+5 yp w40 h95 vAdvancedWindowEnableAllTalkPictureButtonVar gAdvancedWindowEnableAllTalkPictureButton BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png
gui, GameAdvancedWindow:add, picture, x+5 yp w40 h95 vAdvancedWindowEnableCheatsPictureButtonVar gAdvancedWindowEnableCheatsPictureButton BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png
gui, GameAdvancedWindow:add, picture, xs+30 y+20 w40 h95 vAdvancedWindowEmptyToggle1PictureButtonVar gAdvancedWindowEmptyToggle1PictureButton BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button_empty.png
gui, GameAdvancedWindow:add, picture, x+5 yp w40 h95 vAdvancedWindowEmptyToggle2PictureButtonVar gAdvancedWindowEmptyToggle2PictureButton BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button_empty.png
gui, GameAdvancedWindow:add, picture, x+5 yp w40 h95 vAdvancedWindowEmptyToggle3PictureButtonVar gAdvancedWindowEmptyToggle3PictureButton BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button_empty.png
gui, GameAdvancedWindow:add, picture, x+5 yp w40 h95 vAdvancedWindowEmptyToggle4PictureButtonVar gAdvancedWindowEmptyToggle4PictureButton BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button_empty.png
gui, GameAdvancedWindow:add, picture, x+5 yp w40 h95 vAdvancedWindowEmptyToggle5PictureButtonVar gAdvancedWindowEmptyToggle5PictureButton BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button_empty.png
gui, GameAdvancedWindow:add, picture, x+5 yp w40 h95 vAdvancedWindowEmptyToggle6PictureButtonVar gAdvancedWindowEmptyToggle6PictureButton BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button_empty.png
gui, GameAdvancedWindow:add, listview, xs+30 y+25 w265 h235 vAdvancedWindowServerTogglesInfoLVVar gAdvancedWindowServerTogglesInfoLV Background573227 -E0x200 0x2000 -multi center -hdr Altsubmit border, Text
LV_ModifyCol(1, 500)
LV_Add("", "(1) Allow customization downloads")
LV_Add("", "(2) Allow customization uploads")
LV_Add("", "(3) Hide server")
LV_Add("", "(4) Disable V.A.C")
LV_Add("", "(5) Enable alltalk")
LV_Add("", "(6) Enable cheats")
LV_Add("", "(7) n/a")
LV_Add("", "(8) n/a")
LV_Add("", "(9) n/a")
gui, GameAdvancedWindow:add, groupbox, xs+320 ys+30 w440 h220 center
gui, GameAdvancedWindow:add, text, 0x200 xp+30 yp+30 w120 h30 vAdvancedWindowServerTagsTextVar gAdvancedWindowServerTagsText, Server tags
gui, MainWindow:font, c10900d s12 bold, MS Gothic
gui, GameAdvancedWindow:add, edit, x+10 yp w250 h30 vAdvancedWindowServerTagsEditVar gAdvancedWindowServerTagsEdit
gui, GameAdvancedWindow:font, cece5cb s12 norm, Impact
gui, GameAdvancedWindow:add, text, 0x200 xp-130 y+5 w120 h30 vAdvancedWindowServerTokenTextVar gAdvancedWindowServerTokenText, Server token
gui, MainWindow:font, c10900d s12 bold, MS Gothic
gui, GameAdvancedWindow:add, edit, x+10 yp w250 h30 vAdvancedWindowServerTokenEditVar gAdvancedWindowServerTokenEdit
gui, GameAdvancedWindow:font, cece5cb s12 norm, Impact
gui, GameAdvancedWindow:add, text, 0x200 xp-130 y+5 w120 h30 vAdvancedWindowFastDLURLTextVar gAdvancedWindowFastDLURLText, FastDL url
gui, MainWindow:font, c10900d s12 bold, MS Gothic
gui, GameAdvancedWindow:add, edit, x+10 yp w250 h30 vAdvancedWindowFastDLURLEditVar gAdvancedWindowFastDLURLEdit
gui, GameAdvancedWindow:font, cece5cb s12 norm, Impact
gui, GameAdvancedWindow:add, text, 0x200 xp-130 y+5 w120 h30 vAdvancedWindowRconPasswordTextVar gAdvancedWindowRconPasswordText, Rcon password
gui, MainWindow:font, c10900d s12 bold, MS Gothic
gui, GameAdvancedWindow:add, edit, x+10 yp w220 h30 vAdvancedWindowRconPasswordEditVar gAdvancedWindowRconPasswordEdit
gui, GameAdvancedWindow:add, Progress, x+0 yp w30 h30 vAdvancedWindowGenerateRconPasswordProgressVar c221f1c Background221f1c disabled border
gui, GameAdvancedWindow:add, text, 0x200 xp yp w30 h30 vAdvancedWindowGenerateRconPasswordTextVar gAdvancedWindowGenerateRconPasswordText c646464 center BackgroundTrans, % Chr(0x2699)
gui, GameAdvancedWindow:add, progress, xp-350 y+10 w380 h25 disabled Background573227 border c573227, 100
gui, GameAdvancedWindow:font, cece5cb s11 norm, Impact
gui, GameAdvancedWindow:add, text, 0x200 xp+20 yp w220 h25 vAdvancedWindowIDForTF2TextVar gAdvancedWindowIDForTF2Text BackgroundTrans, ID for Team Fortress 2 is: 440
gui, GameAdvancedWindow:add, groupbox, xs+320 ys+270 w440 h235 center, Server purity
gui, GameAdvancedWindow:add, picture, xp+30 yp+75 w90 h90 vAdvancedWindowSVPurePictureVar gAdvancedWindowSVPurePicture, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Rotary_radio_switch_state_3_pic_button.png
gui, GameAdvancedWindow:font, cece5cb s12 norm, Impact
gui, GameAdvancedWindow:add, text, 0x200 xp+85 yp-30 w165 h25 vAdvancedWindowSVPureMinus1TextVar gAdvancedWindowSVPureMinus1Text center BackgroundTrans, Allow file modifications
gui, GameAdvancedWindow:font, cffffff s12, Impact
gui, GameAdvancedWindow:add, text, 0x200 xp+25 y+20 w220 h25 vAdvancedWindowSVPure0TextVar gAdvancedWindowSVPure0Text center BackgroundTrans, Ban specific user modifications
gui, GameAdvancedWindow:font, cece5cb s12 norm, Impact
gui, GameAdvancedWindow:add, text, 0x200 xp yp+45 w275 h25 vAdvancedWindowSVPure1TextVar gAdvancedWindowSVPure1Text center BackgroundTrans, Allow only whitelisted user modifications
gui, GameAdvancedWindow:add, text, 0x200 xp-55 yp+40 w245 h25 vAdvancedWindowSVPure2TextVar gAdvancedWindowSVPure2Text center BackgroundTrans, Ban all user modifications

gui, GameAdvancedWindow:tab, Connection
gui, GameAdvancedWindow:font, cece5cb s16 norm, Impact
gui, GameAdvancedWindow:add, groupbox, xs ys w790 h530, Connection
gui, GameAdvancedWindow:font, cece5cb s12 norm, Impact
gui, GameAdvancedWindow:add, groupbox, xs+30 ys+30 w205 h215 center, Server type
gui, GameAdvancedWindow:add, picture, xp+50 yp+80 w95 h95 vAdvancedWindowServerTypePictureVar gAdvancedWindowServerTypePicture, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Rotary_radio_switch_state_10_pic_button.png
gui, GameAdvancedWindow:font, cffffff s12, Impact
gui, GameAdvancedWindow:add, text, 0x200 xp-25 yp-30 w45 h25 vAdvancedWindowServerTypeSDRTextVar gAdvancedWindowServerTypeSDRText BackgroundTrans center, SDR
gui, GameAdvancedWindow:font, cece5cb s12 norm, Impact
gui, GameAdvancedWindow:add, text, 0x200 x+5 yp-10 w50 h25 vAdvancedWindowServerTypePublicTextVar gAdvancedWindowServerTypePublicText BackgroundTrans center, Public
gui, GameAdvancedWindow:add, text, 0x200 x+0 yp+10 w60 h25 vAdvancedWindowServerTypeLocalTextVar gAdvancedWindowServerTypeLocalText BackgroundTrans center, Local
gui, GameAdvancedWindow:font, cece5cb s12 norm, Impact
gui, GameAdvancedWindow:add, groupbox, xs+250 ys+30 w310 h215 center, Region
gui, GameAdvancedWindow:add, picture, xp+115 yp+80 w65 h65 vAdvancedWindowRegionPictureVar gAdvancedWindowRegionPicture, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Rotary_radio_switch_state_1_pic_button.png
gui, GameAdvancedWindow:font, cffffff s12, Impact
gui, GameAdvancedWindow:add, text, 0x200 xp+5 yp-35 w55 h25 vAdvancedWindowRegionWorldTextVar gAdvancedWindowRegionWorldText BackgroundTrans center, World
gui, GameAdvancedWindow:font, cece5cb s11 norm, Impact
gui, GameAdvancedWindow:add, text, 0x200 x+0 yp+10 w60 h25 vAdvancedWindowRegionUSEastTextVar gAdvancedWindowRegionUSEastText BackgroundTrans center, US-East
gui, GameAdvancedWindow:add, text, 0x200 xp+15 y+5 w65 h25 vAdvancedWindowRegionUSWestTextVar gAdvancedWindowRegionUSWestText BackgroundTrans center, US-West
gui, GameAdvancedWindow:add, text, 0x200 xp y+5 w110 h25 vAdvancedWindowRegionSouthAmericaTextVar gAdvancedWindowRegionSouthAmericaText BackgroundTrans center, South America
gui, GameAdvancedWindow:add, text, 0x200 xp-25 y+5 w75 h25 vAdvancedWindowRegionEuropeTextVar gAdvancedWindowRegionEuropeText BackgroundTrans center, Europe
gui, GameAdvancedWindow:add, text, 0x200 xp-40 yp+10 w45 h25 vAdvancedWindowRegionAsiaTextVar gAdvancedWindowRegionAsiaText BackgroundTrans center, Asia
gui, GameAdvancedWindow:add, text, 0x200 xp-75 yp-10 w75 h25 vAdvancedWindowRegionAustraliaTextVar gAdvancedWindowRegionAustraliaText BackgroundTrans center, Australia
gui, GameAdvancedWindow:add, text, 0x200 xp-35 yp-30 w90 h25 vAdvancedWindowRegionMiddleEastTextVar gAdvancedWindowRegionMiddleEastText BackgroundTrans center, Middle East
gui, GameAdvancedWindow:add, text, 0x200 xp+35 yp-30 w60 h25 vAdvancedWindowRegionAfricaTextVar gAdvancedWindowRegionAfricaText BackgroundTrans center, Africa
gui, GameAdvancedWindow:font, cece5cb s12 norm, Impact
gui, GameAdvancedWindow:add, groupbox, xs+575 ys+30 w185 h210 center, Maxrate
gui, GameAdvancedWindow:add, picture, xp+45 yp+45 w95 h95 vAdvancedWindowMaxRatePictureVar gAdvancedWindowMaxRatePicture BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Rotary_switch_state_1_pic_button.png
gui, GameAdvancedWindow:add, edit, xp y+20 w95 h25 vAdvancedWindowMaxRateEditVar gAdvancedWindowMaxRateEdit number
gui, GameAdvancedWindow:add, groupbox, xs+30 ys+250 w135 h210 center, Minrate
gui, GameAdvancedWindow:add, picture, xp+20 yp+45 w95 h95 vAdvancedWindowMinRatePictureVar gAdvancedWindowMinRatePicture BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Rotary_switch_state_1_pic_button.png
gui, GameAdvancedWindow:add, edit, xp y+20 w95 h25 vAdvancedWindowMinRateEditVar gAdvancedWindowMinRateEdit number
gui, GameAdvancedWindow:add, groupbox, xs+180 ys+250 w130 h210 center, Maxupdaterate
gui, GameAdvancedWindow:add, picture, xp+20 yp+45 w95 h95 vAdvancedWindowMaxUpdateRatePictureVar gAdvancedWindowMaxUpdateRatePicture BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Rotary_switch_state_1_pic_button.png
gui, GameAdvancedWindow:add, edit, xp y+20 w95 h25 vAdvancedWindowMaxUpdateRateEditVar gAdvancedWindowMaxUpdateRateEdit number
gui, GameAdvancedWindow:add, groupbox, xs+325 ys+250 w135 h210 center, Minupdaterate
gui, GameAdvancedWindow:add, picture, xp+20 yp+45 w95 h95 vAdvancedWindowMinUpdateRatePictureVar gAdvancedWindowMinUpdateRatePicture BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Rotary_switch_state_1_pic_button.png
gui, GameAdvancedWindow:add, edit, xp y+20 w95 h25 vAdvancedWindowMinUpdateRateEditVar gAdvancedWindowMinUpdateRateEdit number
gui, GameAdvancedWindow:add, groupbox, xs+475 ys+250 w135 h210 center, Maxcmdrate
gui, GameAdvancedWindow:add, picture, xp+20 yp+45 w95 h95 vAdvancedWindowMaxCMDRatePictureVar gAdvancedWindowMaxCMDRatePicture BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Rotary_switch_state_1_pic_button.png
gui, GameAdvancedWindow:add, edit, xp y+20 w95 h25 vAdvancedWindowMaxCMDRateEditVar gAdvancedWindowMaxCMDRateEdit number
gui, GameAdvancedWindow:add, groupbox, xs+625 ys+250 w135 h210 center, Mincmdrate
gui, GameAdvancedWindow:add, picture, xp+20 yp+45 w95 h95 vAdvancedWindowMinCMDRatePictureVar gAdvancedWindowMinCMDRatePicture BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Rotary_switch_state_1_pic_button.png
gui, GameAdvancedWindow:add, edit, xp y+20 w95 h25 vAdvancedWindowMinCMDRateEditVar gAdvancedWindowMinCMDRateEdit number
gui, GameAdvancedWindow:font, cece5cb s12 norm, Impact
gui, GameAdvancedWindow:add, text, 0x200 xs+30 ys+475 w140 h30, Custom address
gui, GameAdvancedWindow:add, edit, x+10 yp w280 h30 vAdvancedWindowCustomAddressEditVar gAdvancedWindowCustomAddressEdit
gui, GameAdvancedWindow:add, text, 0x200 x+20 yp w135 h30, Custom UDP port
gui, GameAdvancedWindow:add, edit, x+10 yp w135 h30 vAdvancedWindowUDPPortEditVar gAdvancedWindowUDPPortEdit number limit5

gui, GameAdvancedWindow:tab, SourceTV
gui, GameAdvancedWindow:font, cece5cb s16 norm, Impact
gui, GameAdvancedWindow:add, groupbox, xs ys w790 h530, SourceTV
gui, GameAdvancedWindow:font, cece5cb s12 norm, Impact
gui, GameAdvancedWindow:add, picture, xs+30 yp+40 w40 h95 vAdvancedWindowEnableSourceTvPictureButtonVar gAdvancedWindowEnableSourceTvPictureButton BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png
gui, GameAdvancedWindow:add, picture, x+5 yp w40 h95 vAdvancedWindowUsePlayersAsCameraPictureButtonVar gAdvancedWindowUsePlayersAsCameraPictureButton BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png
gui, GameAdvancedWindow:add, picture, x+5 yp w40 h95 vAdvancedWindowPlayVoicePictureButtonVar gAdvancedWindowPlayVoicePictureButton BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png
gui, GameAdvancedWindow:add, picture, x+5 yp w40 h95 vAdvancedWindowAutoRecordAllGamesPictureButtonVar gAdvancedWindowAutoRecordAllGamesPictureButton BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png
gui, GameAdvancedWindow:add, picture, x+5 yp w40 h95 vAdvancedWindowTransmitAllEntitiesPictureButtonVar gAdvancedWindowTransmitAllEntitiesPictureButton BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png
gui, GameAdvancedWindow:add, picture, x+5 yp w40 h95 vAdvancedWindowDelayMapChangePictureButtonVar gAdvancedWindowDelayMapChangePictureButton BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png
gui, GameAdvancedWindow:add, picture, x+5 yp w40 h95 vAdvancedWindowEmptyToggle7PictureButtonVar gAdvancedWindowEmptyToggle7PictureButton  BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button_empty.png
gui, GameAdvancedWindow:add, picture, xs+30 y+20 w40 h95 vAdvancedWindowEmptyToggle8PictureButtonVar gAdvancedWindowEmptyToggle8PictureButton  BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button_empty.png
gui, GameAdvancedWindow:add, picture, x+5 yp w40 h95 vAdvancedWindowEmptyToggle9PictureButtonVar gAdvancedWindowEmptyToggle9PictureButton  BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button_empty.png
gui, GameAdvancedWindow:add, picture, x+5 yp w40 h95 vAdvancedWindowEmptyToggle10PictureButtonVar gAdvancedWindowEmptyToggle10PictureButton  BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button_empty.png
gui, GameAdvancedWindow:add, picture, x+5 yp w40 h95 vAdvancedWindowEmptyToggle11PictureButtonVar gAdvancedWindowEmptyToggle11PictureButton  BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button_empty.png
gui, GameAdvancedWindow:add, picture, x+5 yp w40 h95 vAdvancedWindowEmptyToggle12PictureButtonVar gAdvancedWindowEmptyToggle12PictureButton  BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button_empty.png
gui, GameAdvancedWindow:add, picture, x+5 yp w40 h95 vAdvancedWindowEmptyToggle13PictureButtonVar gAdvancedWindowEmptyToggle13PictureButton  BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button_empty.png
gui, GameAdvancedWindow:add, picture, x+5 yp w40 h95 vAdvancedWindowEmptyToggle14PictureButtonVar gAdvancedWindowEmptyToggle14PictureButton  BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button_empty.png
gui, GameAdvancedWindow:add, listview, xp-270 y+25 w310 h230 vAdvancedWindowSTVTogglesInfoLVVar gAdvancedWindowSTVTogglesInfoLV Background573227 -E0x200 0x2000 -multi center -hdr Altsubmit border, Text
LV_ModifyCol(1, 500)
LV_Add("", "(1) Enable SourceTV")
LV_Add("", "(2) Use players as the camera")
LV_Add("", "(3) Play voice")
LV_Add("", "(4) Auto-Record all games")
LV_Add("", "(5) Transmit all entities")
LV_Add("", "(6) Delays map change until broadcast is")
LV_Add("", "complete")
LV_Add("", "(7) n/a")
LV_Add("", "(8) n/a")

gui, GameAdvancedWindow:add, groupbox, xs+365 ys+30 w395 h220
gui, GameAdvancedWindow:add, text, 0x200 xp+30 yp+30 w120 h30 vAdvancedWindowSTVNameTextVar gAdvancedWindowSTVNameText, STV name
gui, MainWindow:font, c10900d s12 bold, MS Gothic
gui, GameAdvancedWindow:add, edit, x+10 yp w205 h30 vAdvancedWindowSTVNameEditVar gAdvancedWindowSTVNameEdit
gui, GameAdvancedWindow:font, cece5cb s12 norm, Impact
gui, GameAdvancedWindow:add, text, 0x200 xp-130 y+5 w120 h30 vAdvancedWindowSTVPasswordTextVar gAdvancedWindowSTVPasswordText, STV password
gui, MainWindow:font, c10900d s12 bold, MS Gothic
gui, GameAdvancedWindow:add, edit, x+10 yp w175 h30 vAdvancedWindowSTVPasswordEditVar gAdvancedWindowSTVPasswordEdit

gui, GameAdvancedWindow:add, Progress, x+0 yp w30 h30 vAdvancedWindowGenerateSTVPasswordProgressVar c221f1c Background221f1c disabled border
gui, GameAdvancedWindow:add, text, 0x200 xp yp w30 h30 vAdvancedWindowGenerateSTVPasswordTextVar gAdvancedWindowGenerateSTVPasswordText c646464 center BackgroundTrans, % Chr(0x2699)

gui, GameAdvancedWindow:font, cece5cb s12 norm, Impact
gui, GameAdvancedWindow:add, text, 0x200 xp-305 y+5 w120 h30 vAdvancedWindowSTVSnapShotRateTextVar gAdvancedWindowSTVSnapShotRateText, STV snapshotrate
gui, MainWindow:font, c10900d s12 bold, MS Gothic
gui, GameAdvancedWindow:add, edit, x+10 yp w205 h30 vAdvancedWindowSTVSnapShotRateEditVar gAdvancedWindowSTVSnapShotRateEdit
gui, GameAdvancedWindow:font, cece5cb s12 norm, Impact
gui, GameAdvancedWindow:add, text, 0x200 xp-130 y+5 w120 h30 vAdvancedWindowSTVDelayTextVar gAdvancedWindowSTVDelayText, STV delay
gui, MainWindow:font, c10900d s12 bold, MS Gothic
gui, GameAdvancedWindow:add, edit, x+10 yp w205 h30 vAdvancedWindowSTVDelayEditVar gAdvancedWindowSTVDelayEdit
gui, GameAdvancedWindow:font, cece5cb s12 norm, Impact
gui, GameAdvancedWindow:add, text, 0x200 xp-130 y+5 w120 h30 vAdvancedWindowSTVPortTextVar gAdvancedWindowSTVPortText, STV port
gui, MainWindow:font, c10900d s12 bold, MS Gothic
gui, GameAdvancedWindow:add, edit, x+10 yp w205 h30 vAdvancedWindowSTVPortEditVar gAdvancedWindowSTVPortEdit number limit5
gui, GameAdvancedWindow:font, cece5cb s12 norm, Impact
gui, GameAdvancedWindow:add, groupbox, xs+365 ys+270 w190 h235 center, Timeout
gui, GameAdvancedWindow:add, picture, xp+40 yp+50 w110 h110 vAdvancedWindowTimeoutPictureVar gAdvancedWindowTimeoutPicture BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Rotary_switch_state_1_pic_button.png
gui, GameAdvancedWindow:add, edit, xp y+20 w110 h25 vAdvancedWindowTimeoutEditVar gAdvancedWindowTimeoutEdit number
gui, GameAdvancedWindow:add, groupbox, xs+570 ys+270 w190 h235 center, Max num. of clients
gui, GameAdvancedWindow:add, picture, xp+40 yp+50 w110 h110 vAdvancedWindowMaxNumOfClientsPictureVar gAdvancedWindowMaxNumOfClientsPicture BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Rotary_switch_state_1_pic_button.png
gui, GameAdvancedWindow:add, edit, xp y+20 w110 h25 vAdvancedWindowMaxNumOfClientsEditVar gAdvancedWindowMaxNumOfClientsEdit number
gui, GameAdvancedWindow:tab, Votes
gui, GameAdvancedWindow:font, cece5cb s16 norm, Impact
gui, GameAdvancedWindow:add, groupbox, xs ys w790 h530, Votes
gui, GameAdvancedWindow:font, cece5cb s12 norm, Impact
gui, GameAdvancedWindow:add, picture, xs+30 yp+50 w40 h95 vAdvancedWindowAllowVotingPictureButtonVar gAdvancedWindowAllowVotingPictureButton BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png
gui, GameAdvancedWindow:add, picture, x+5 yp w40 h95 vAdvancedWindowAllowSpectatorsToVotePictureButtonVar gAdvancedWindowAllowSpectatorsToVotePictureButton BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png
gui, GameAdvancedWindow:add, picture, x+5 yp w40 h95 vAdvancedWindowAllowBotsToVotePictureButtonVar gAdvancedWindowAllowBotsToVotePictureButton BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png
gui, GameAdvancedWindow:add, picture, x+5 yp w40 h95 vAdvancedWindowEnableAutoTeamBalanceVotesPictureButtonVar gAdvancedWindowEnableAutoTeamBalanceVotesPictureButton BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png
gui, GameAdvancedWindow:add, picture, x+5 yp w40 h95 vAdvancedWindowAllowChangeLevelVotesPictureButtonVar gAdvancedWindowAllowChangeLevelVotesPictureButton BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png
gui, GameAdvancedWindow:add, picture, xs+30 y+20 w40 h95 vAdvancedWindowAllowPerClassLimitVotesPictureButtonVar gAdvancedWindowAllowPerClassLimitVotesPictureButton BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png
gui, GameAdvancedWindow:add, picture, x+5 yp w40 h95 vAdvancedWindowAllowNextLevelVotesPictureButtonVar gAdvancedWindowAllowNextLevelVotesPictureButton BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png
gui, GameAdvancedWindow:add, picture, x+5 yp w40 h95 vAdvancedWindowEnableVoteKickPictureButtonVar gAdvancedWindowEnableVoteKickPictureButton BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png
gui, GameAdvancedWindow:add, picture, x+5 yp w40 h95 vAdvancedWindowAllowVoteKickSpectatorsInMvMPictureButtonVar gAdvancedWindowAllowVoteKickSpectatorsInMvMPictureButton BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png
gui, GameAdvancedWindow:add, picture, x+5 yp w40 h95 vAdvancedWindowAllowSetMvMChallengeLevelVotesPictureButtonVar gAdvancedWindowAllowSetMvMChallengeLevelVotesPictureButton BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png
gui, GameAdvancedWindow:add, picture, xs+30 y+20 w40 h95 vAdvancedWindowAutomaticallyChooseYesForVoteCallersPictureButtonVar gAdvancedWindowAutomaticallyChooseYesForVoteCallersPictureButton BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png
gui, GameAdvancedWindow:add, picture, x+5 yp w40 h95 vAdvancedWindowAllowExtendCurrentMapVotesPictureButtonVar gAdvancedWindowAllowExtendCurrentMapVotesPictureButton BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png
gui, GameAdvancedWindow:add, picture, x+5 yp w40 h95 vAdvancedWindowPresentTheLowestPlaytimeMapsListPictureButtonVar gAdvancedWindowPresentTheLowestPlaytimeMapsListPictureButton BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png
gui, GameAdvancedWindow:add, picture, x+5 yp w40 h95 vAdvancedWindowPreventNextLevelVotesIfOneHasBeenSetPictureButtonVar gAdvancedWindowPreventNextLevelVotesIfOneHasBeenSetPictureButton BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png
gui, GameAdvancedWindow:add, picture, x+5 yp w40 h95 vAdvancedWindowAllowRestartGameVotesPictureButtonVar gAdvancedWindowAllowRestartGameVotesPictureButton BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png
gui, GameAdvancedWindow:add, picture, xs+30 y+20 w40 h95 vAdvancedWindowAllowVoteScramblePictureButtonVar gAdvancedWindowAllowVoteScramblePictureButton BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png
gui, GameAdvancedWindow:add, picture, x+5 yp w40 h95 vAdvancedWindowShowDisabledVotesInTheVoteMenuPictureButtonVar gAdvancedWindowShowDisabledVotesInTheVoteMenuPictureButton BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png
gui, GameAdvancedWindow:add, picture, x+5 yp w40 h95 vAdvancedWindowAllowPauseGameVotesPictureButtonVar gAdvancedWindowAllowPauseGameVotesPictureButton BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png
gui, GameAdvancedWindow:add, picture, x+5 yp w40 h95 vAdvancedWindowEmptyToggle15PictureButtonVar gAdvancedWindowEmptyToggle15PictureButton BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button_empty.png
gui, GameAdvancedWindow:add, picture, x+5 yp w40 h95 vAdvancedWindowEmptyToggle16PictureButtonVar gAdvancedWindowEmptyToggle16PictureButton BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button_empty.png

gui, GameAdvancedWindow:add, listview, x+25 ys+50 w485 h440 vAdvancedWindowVotesTogglesLVVar gAdvancedWindowVotesTogglesLV Background573227 -E0x200 0x2000 -multi center -hdr Altsubmit border, Text
LV_ModifyCol(1, 500)
LV_Add("", "(1) Allow voting")
LV_Add("", "(2) Allow spectators to vote")
LV_Add("", "(3) Allow bots to vote or not")
LV_Add("", "(4) Allow enable or disable auto team balance votes")
LV_Add("", "(5) Allow players to vote on changing levels")
LV_Add("", "(6) Allow enable or disable per-class limits votes")
LV_Add("", "(7) Allow players to vote on choosing the next level")
LV_Add("", "(8) Allow players to call vote kick other players")
LV_Add("", "(9) Allow players to kick spectators in MvM")
LV_Add("", "(10) Allow players to call votes to set the challenge level in mvm")
LV_Add("", "(11) Automatically choose 'Yes' for vote callers")
LV_Add("", "(12) Allow players to extend the current map")
LV_Add("", "(13) Present players with a list of lowest playtime maps to choose from")
LV_Add("", "(14) Not allowed to vote for a nextlevel if one has")
LV_Add("", "(15) Allow players to call votes to restart the game")
LV_Add("", "(16) Allow players to vote to scramble the teams")
LV_Add("", "(17) Suppress listing of disabled issues in the vote setup screen")
LV_Add("", "(18) Allow players to call votes to pause the game")


gui, GameAdvancedWindow:tab, Map
GameAdvancedMapOptionsPage := 1                    ;Required for emulating a monitor in Advanced > Map > Listview(with no scrollbars)
gui, GameAdvancedWindow:font, cece5cb s16 norm, Impact
gui, GameAdvancedWindow:add, groupbox, xs ys w790 h530, Map
gui, GameAdvancedWindow:add, picture, xs+65 ys+40 w660 h40 vGameAdvancedMapOptionsTopImageOverlayPictureVar gGameAdvancedMapOptionsTopImageOverlayPicture, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_image_overlay_top_only.png
gui, GameAdvancedWindow:add, picture, xp y+0 w40 h390 vGameAdvancedMapOptionsLeftImageOverlayPictureVar gGameAdvancedMapOptionsLeftImageOverlayPicture, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_image_overlay_left_only.png
gui, GameAdvancedWindow:font, c10900d s13 bold underline, Courier New
gui, GameAdvancedWindow:add, Progress, x+0 yp w580 h35 c221f1c Background221f1c disabled -border
gui, GameAdvancedWindow:add, text, 0x200 xp yp w580 h35 vGameAdvancedMapOptionsTopTextVar gGameAdvancedMapOptionsTopText BackgroundTrans, Options                                          Value           _
gui, GameAdvancedWindow:font, c10900d s13 bold norm, Courier New
gui, GameAdvancedWindow:add, listview, xp y+0 w580 h295 vGameAdvancedMapOptionsPageLVVar gGameAdvancedMapOptionsPageOptionsLV 0x2000 -E0x200 -multi -hdr Altsubmit, Checked|Name|Value
gosub, ReadAdvancedSettingsFromINI
gosub, GameAdvancedMapOptionsPageNextListOfOptions
gui, GameAdvancedWindow:add, Progress, xp y+0 w30 h30 vGameAdvancedMapOptionsPageOptionsPreviousPageProgressVar c221f1c Background221f1c disabled -border
gui, GameAdvancedWindow:add, text, xp yp w30 h30 vGameAdvancedMapOptionsPageOptionsPreviousPageTextVar gGameAdvancedMapOptionsPageOptionsPreviousPageText c646464 center BackgroundTrans border, % Chr(0x2B06)
gui, GameAdvancedWindow:add, Progress, x+0 yp w30 h30 vGameAdvancedMapOptionsPageOptionsNextPageProgressVar c221f1c Background221f1c disabled -border
gui, GameAdvancedWindow:add, text, xp yp w30 h30 vGameAdvancedMapOptionsPageOptionsNextPageTextVar gGameAdvancedMapOptionsPageOptionsNextPageText c646464 center BackgroundTrans border, % Chr(0x2B07)
gui, GameAdvancedWindow:add, edit, x+0 yp w490 h30 vGameAdvancedMapOptionsModifyValueEditVar -Vscroll -E0x200 border
gui, GameAdvancedWindow:font, ceee4be s16 norm, Impact
gui, GameAdvancedWindow:add, Progress, x+0 yp w30 h30 vGameAdvancedMapOptionsModifyValueProgressVar c221f1c Background221f1c disabled -border
gui, GameAdvancedWindow:add, text, 0x200 xp yp w30 h30 vGameAdvancedMapOptionsModifyValueTextVar gGameAdvancedMapOptionsModifyValueText c646464 center BackgroundTrans border, % Chr(0x270F)
gui, GameAdvancedWindow:font, c10900d s10 bold underline, Courier New
gui, GameAdvancedWindow:add, Progress, xp-550 y+0 w580 h30 c221f1c Background221f1c disabled -border
gui, GameAdvancedWindow:add, text, 0x200 xp yp w580 h30 vGameAdvancedMapOptionsPageOptionsTextVar gGameAdvancedMapOptionsPageOptionsText BackgroundTrans, Double - click to enable/disable an option            Page: %GameAdvancedMapOptionsPage%                                                        _
gui, GameAdvancedWindow:add, picture, x+0 yp-360 w40 h390 vGameAdvancedMapOptionsRightImageOverlayPictureVar gGameAdvancedMapOptionsRightImageOverlayPicture, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_image_overlay_right_only.png
gui, GameAdvancedWindow:add, picture, xp-620 y+0 w660 h40 vGameAdvancedMapOptionsBottomImageOverlayPictureVar gGameAdvancedMapOptionsBottomImageOverlayPicture, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_image_overlay_bottom_only.png
gui, GameAdvancedWindow:tab

gui, GameAdvancedWindow:font, cece5cb s12 norm, Impact
gui, GameAdvancedWindow:add, text, 0x200 xs ys+550 w130 h30, Launch options
gui, GameAdvancedWindow:add, edit, x+10 yp w590 h30 vGameAdvancedLaunchOptionsEditVar gGameAdvancedLaunchOptionsEdit
gui, GameAdvancedWindow:add, Progress, x+0 yp w30 h30 vGameAdvancedLaunchOptionsCopyToClipboardProgressVar Background221f1c disabled border
gui, GameAdvancedWindow:add, text, 0x200 xp yp w30 h30 vGameAdvancedLaunchOptionsCopyToClipboardTextVar gGameAdvancedLaunchOptionsCopyToClipboardText c646464 center BackgroundTrans, % Chr(0x1F4CB)
gui, GameAdvancedWindow:add, Progress, x+0 yp w30 h30 vGameAdvancedLaunchOptionsRestoreProgressVar Background221f1c disabled border
gui, GameAdvancedWindow:add, text, 0x200 xp yp w30 h30 vGameAdvancedLaunchOptionsRestoreTextVar gGameAdvancedLaunchOptionsRestoreText c646464 center BackgroundTrans, % Chr(0x1F504)
gui, GameAdvancedWindow:font, cece5cb s14 norm, Impact
gui, GameAdvancedWindow:add, picture, xp-760 y+20 w70 h50 vGameAdvancedOpenReplaysGuidePictureButtonVar gGameAdvancedOpenReplaysGuidePictureButton, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Game_advanced_replays_guide_pic_button.png
gui, GameAdvancedWindow:add, picture, x+20 yp w70 h50 vGameAdvancedOpenPortForwardGuidePictureButtonVar gGameAdvancedOpenPortForwardGuidePictureButton, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Game_advanced_port_forward_guide_pic_button.png
gui, GameAdvancedWindow:add, picture, x+20 yp w70 h50 vGameAdvancedOpenFastDLGuidePictureButtonVar gGameAdvancedOpenFastDLGuidePictureButton, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Game_advanced_fast_dl_pic_button.png
gui, GameAdvancedWindow:add, picture, x+20 yp w70 h50 vGameAdvancedOpenConsoleCommandsListPictureButtonVar gGameAdvancedOpenConsoleCommandsListPictureButton, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Game_advanced_console_commands_pic_button.png
gui, GameAdvancedWindow:add, picture, x+20 yp w70 h50 vGameAdvancedOpenLaunchOptionsListPictureButtonVar gGameAdvancedOpenLaunchOptionsListPictureButton, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Game_advanced_launch_options_pic_button.png
gui, GameAdvancedWindow:add, picture, x+20 yp w70 h50 vGameAdvancedOpenServerTokenPictureButtonVar gGameAdvancedOpenServerTokenPictureButton, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Game_advanced_server_token_pic_button.png
gui, GameAdvancedWindow:add, picture, x+20 yp w70 h50 vGameAdvancedEmpty1PictureButtonVar gGameAdvancedEmpty1PictureButton, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_empty_pic_button.png
gui, GameAdvancedWindow:add, picture, x+20 yp w70 h50 vGameAdvancedEmpty2PictureButtonVar gGameAdvancedEmpty2PictureButton, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_empty_pic_button.png
gui, GameAdvancedWindow:add, picture, x+20 yp w70 h50 vGameAdvancedEmpty3PictureButtonVar gGameAdvancedEmpty3PictureButton, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_empty_pic_button.png

gui, GameAdvancedWindow:add, picture, x+30 ys+10 w440 h25 vGameAdvancedCustomCFGCommandsTopImageOverlayPictureVar gGameAdvancedCustomCFGCommandsTopImageOverlayPicture  section, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_image_overlay_top_only.png
gui, GameAdvancedWindow:add, picture, xp y+0 w25 h260 vGameAdvancedCustomCFGCommandsLeftImageOverlayPictureVar gGameAdvancedCustomCFGCommandsLeftImageOverlayPicture, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_image_overlay_left_only.png
gui, GameAdvancedWindow:font, c10900d s13 bold underline, Courier New
gui, GameAdvancedWindow:add, Progress, x+0 yp w390 h30 c221f1c Background221f1c disabled -border
gui, GameAdvancedWindow:add, text, 0x200 xp yp w390 h30 BackgroundTrans, Custom startup commands                                                     _
gui, GameAdvancedWindow:font, c10900d s12 bold norm, Courier New
gui, GameAdvancedWindow:add, edit, xp y+0 w390 h230 vGameAdvancedCustomCFGCommandsEditVar gGameAdvancedCustomCFGCommandsEdit -VScroll -E0x200
gui, GameAdvancedWindow:add, picture, x+0 yp-30 w25 h260 vGameAdvancedCustomCFGCommandsRightImageOverlayPictureVar gGameAdvancedCustomCFGCommandsRightImageOverlayPicture, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_image_overlay_right_only.png
gui, GameAdvancedWindow:add, picture, xs y+0 w440 h25 vGameAdvancedCustomCFGCommandsBottomImageOverlayPictureVar gGameAdvancedCustomCFGCommandsBottomImageOverlayPicture, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_image_overlay_bottom_only.png
gui, GameAdvancedWindow:add, picture, xs y+20 w440 h25 vAdvancedWindowInfoBoxTopImageOverlayPictureVar gAdvancedWindowInfoBoxTopImageOverlayPicture section, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_image_overlay_top_only.png
gui, GameAdvancedWindow:add, picture, xp y+0 w25 h260 vAdvancedWindowInfoBoxLeftImageOverlayPictureVar gAdvancedWindowInfoBoxLeftImageOverlayPicture, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_image_overlay_left_only.png
gui, GameAdvancedWindow:font, c10900d s13 bold underline, Courier New
gui, GameAdvancedWindow:add, Progress, x+0 yp w390 h30 c221f1c Background221f1c disabled -border
gui, GameAdvancedWindow:add, text, 0x200 xp yp w390 h30 BackgroundTrans, Information                                                                _
gui, GameAdvancedWindow:font, c10900d s12 bold norm, Courier New
gui, GameAdvancedWindow:add, edit, xp y+0 w390 h230 -VScroll -E0x200 vAdvancedWindowInfoBoxEditVar gAdvancedWindowInfoBoxEdit
gui, GameAdvancedWindow:add, picture, x+0 yp-30 w25 h260 vAdvancedWindowInfoBoxRightImageOverlayPictureVar gAdvancedWindowInfoBoxRightImageOverlayPicture, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_image_overlay_right_only.png
gui, GameAdvancedWindow:add, picture, xs y+0 w440 h25 vAdvancedWindowInfoBoxBottomImageOverlayPictureVar gAdvancedWindowInfoBoxBottomImageOverlayPicture, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_image_overlay_bottom_only.png

;______________________________Advanced_window_presets__________________________________
gui, GameAdvancedWindowPresets:new, -caption +border, Advanced window presets
gui, GameAdvancedWindowPresets:font, cece5cb s12 norm, Impact
gui, GameAdvancedWindowPresets:Color, 653d33, 221f1c
gui, GameAdvancedWindowPresets:add, progress, x0 y0 w550 h30 disabled c2d2824 section, 100
gui, GameAdvancedWindowPresets:add, text, 0x200 xp+20 yp w500 h30 gMoveUI BackgroundTrans, Advanced - settings
gui, GameAdvancedWindowPresets:font, cece5cb s12, Impact
gui, GameAdvancedWindowPresets:add, picture, xs+20 ys+50 w230 h20 section, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Vertical_console_image_overlay_top_only.png
gui, GameAdvancedWindowPresets:add, picture, xp y+0 w20 h260, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Vertical_console_image_overlay_left_only.png
gui, GameAdvancedWindowPresets:font, c10900d s11 bold underline, Courier New
gui, GameAdvancedWindowPresets:add, Progress, x+0 yp w190 h20 c221f1c Background221f1c disabled -border
gui, GameAdvancedWindowPresets:add, text, 0x200 xp yp w190 h20 BackgroundTrans, Presets                                                                _
gui, GameAdvancedWindowPresets:font, c10900d s11 bold norm, Courier New
gui, GameAdvancedWindowPresets:add, listbox, 0x100 xp y+0 w190 h200 vSelectServerPresetListListboxVar -Vscroll -E0x200, Quickplay
gui, GameAdvancedWindowPresets:add, edit, xp y+0 w130 h20 -E0x200 border vSelectServerPresetNameEditVar
gui, GameAdvancedWindowPresets:font, ceee4be s12 norm, Impact
gui, GameAdvancedWindowPresets:add, Progress, x+0 yp w20 h20 vSelectServerPresetRemovePresetProgressVar c221f1c Background221f1c disabled -border
gui, GameAdvancedWindowPresets:add, text, 0x200 xp yp w20 h20 vSelectServerPresetRemovePresetPictureButtonVar gSelectServerPresetRemovePresetPictureButton c646464 center BackgroundTrans border, -
gui, GameAdvancedWindowPresets:add, Progress, x+0 yp w20 h20 vSelectServerPresetAddPresetProgressVar c221f1c Background221f1c disabled -border
gui, GameAdvancedWindowPresets:add, text, 0x200 xp yp w20 h20 vSelectServerPresetAddPresetPictureButtonVar gSelectServerPresetAddPresetPictureButton c646464 center BackgroundTrans border, +
gui, GameAdvancedWindowPresets:add, Progress, x+0 yp w20 h20 vSelectServerPresetApplyPresetProgressVar c221f1c Background221f1c disabled -border
gui, GameAdvancedWindowPresets:add, text, 0x200 xp yp w20 h20 vSelectServerPresetApplyPresetPictureButtonVar gSelectServerPresetApplyPresetPictureButton c646464 center BackgroundTrans border, % Chr(0x2935)
gui, GameAdvancedWindowPresets:font, c10900d s10 bold underline, Courier New
gui, GameAdvancedWindowPresets:add, Progress, xp-170 y+0 w190 h20 c221f1c Background221f1c disabled -border
gui, GameAdvancedWindowPresets:add, text, 0x200 xp yp w190 h20 BackgroundTrans, -/+ delete/save preset                                                             _
gui, GameAdvancedWindowPresets:add, picture, x+0 yp-240 w20 h260, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Vertical_console_image_overlay_right_only.png
gui, GameAdvancedWindowPresets:add, picture, xp-210 y+0 w230 h20, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Vertical_console_image_overlay_bottom_only.png
gui, GameAdvancedWindowPresets:font, cece5cb s12 norm, Impact
gui, GameAdvancedWindowPresets:add, text, 0x200 xs+250 ys w260 h25 center BackgroundTrans section, Custom preset name
gui, GameAdvancedWindowPresets:add, edit, xs y+5 w235 h25 vSelectServerPresetCustomPresetNameEditVar
gui, GameAdvancedWindowPresets:add, Progress, x+0 yp w25 h25 vSelectServerPresetClearCustomPresetNameProgressVar c221f1c disabled, 100
gui, GameAdvancedWindowPresets:font, ceee4be s14 norm, Impact
gui, GameAdvancedWindowPresets:add, text, xp yp w25 h25 vSelectServerPresetClearCustomPresetNameTextVar gSelectServerPresetClearCustomPresetNameText c646464 center BackgroundTrans, x
gui, GameAdvancedWindowPresets:font, ceee4be s12 norm, Impact
gui, GameAdvancedWindowPresets:add, picture, xs y+10 w70 h50 vSelectServerPresetApplyCustomPresetCodePictureButtonVar gSelectServerPresetApplyCustomPresetCodePictureButton BackgroundTrans section, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Left_arrow_pic_button.png
gui, GameAdvancedWindowPresets:add, text, 0x200 x+10 yp w180 h20, Add custom preset
gui, GameAdvancedWindowPresets:add, Edit, xp y+5 w155 h25 vSelectServerPresetCustomPresetEditVar
gui, GameAdvancedWindowPresets:add, Progress, x+0 yp w25 h25 vSelectServerPresetCopyCustomPresetToClipboardProgressVar c221f1c disabled, 100
gui, GameAdvancedWindowPresets:add, text, 0x200 xp yp w25 h25 vSelectServerPresetCopyCustomPresetToClipboardTextVar gSelectServerPresetCopyCustomPresetToClipboardText c646464 center BackgroundTrans, % Chr(0x1F4CB)
gui, GameAdvancedWindowPresets:add, picture, xs y+10 w70 h50 vSelectServerPresetGeneratePresetCodePictureButtonVar gSelectServerPresetGeneratePresetCodePictureButton BackgroundTrans section, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Paths_cog_wheel_pic_button.png
gui, GameAdvancedWindowPresets:add, text, 0x200 x+10 yp w180 h20, Generate preset code
gui, GameAdvancedWindowPresets:add, Edit, xp y+5 w155 h25 vSelectServerHostGeneratePresetCodeEditVar
gui, GameAdvancedWindowPresets:add, Progress, x+0 yp w25 h25 vSelectServerPresetCopyGeneratePresetCodeToClipboardProgressVar c221f1c disabled, 100
gui, GameAdvancedWindowPresets:add, text, 0x200 xp yp w25 h25 vSelectServerPresetCopyGeneratePresetCodeToClipboardTextVar gSelectServerPresetCopyGeneratePresetCodeToClipboardText c646464 center BackgroundTrans, % Chr(0x1F4CB)
gui, GameAdvancedWindowPresets:add, picture, xs y+10 w70 h50 vSelectServerPresetRestoreAllAdvancedTabPictureButtonVar gSelectServerPresetRestoreAllAdvancedTabPictureButton BackgroundTrans section, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Game_advanced_restore_defaults_pic_button.png
gui, GameAdvancedWindowPresets:add, text, 0x200 x+10 yp w180 h20, Restore all tabs
gui, GameAdvancedWindowPresets:add, picture, xs y+40 w70 h50 vSelectServerPresetRestoreCurrentAdvancedTabPictureButtonVar gSelectServerPresetRestoreCurrentAdvancedTabPictureButton BackgroundTrans section, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Restore_pic_button.png
gui, GameAdvancedWindowPresets:add, text, 0x200 x+10 yp w180 h20, Restore current tab
gosub, SetRotarySwitchStatesInINI
gosub, ScanAdvancedSettingsForPresets
gosub, ApplyAdvancedSettingsFromINI
gosub, ApplyCustomStartupCommands
AdvancedWindowCurrentTab := "Server"
GuiControl, SplashGUIWindow:, LoadingVar, 50

;______________________________________Console__________________________________________
gui, MainWindow:tab, Console
gui, MainWindow:font, cece5cb s16 norm, Impact
gui, MainWindow:add, picture, x60 y120 w690 h35 BackgroundTrans section, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_image_overlay_top_only.png
gui, MainWindow:add, picture, xs y+0 w40 h395 BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_image_overlay_left_only.png
IniRead, ConsoleSizeFromINI, %A_scriptdir%\Server Boss All\Settings.ini, MainWindow, ConsoleSize
IniRead, ConsoleColorFromINI, %A_scriptdir%\Server Boss All\Settings.ini, MainWindow, ConsoleColor
gui, MainWindow:font, c%ConsoleColorFromINI% s%ConsoleSizeFromINI% bold, MS Gothic
gui, MainWindow:add, edit, x+0 yp w610 h365 vConsoleEditVar -VScroll -E0x200
gui, MainWindow:font, c10900d s14 bold, MS Gothic
gui, MainWindow:add, edit, xp y+0 w580 h30 vConsoleInputEditVar -Vscroll -E0x200 border
gui, MainWindow:font, ceee4be s14, Impact
gui, MainWindow:add, Progress, x+0 yp w30 h30 vConsoleSendInputProgressVar Background221f1c disabled
gui, MainWindow:add, text, 0x200 xp yp w30 h30 vConsoleSendInputTextVar gConsoleSendInputText c646464 center BackgroundTrans border, >
gui, MainWindow:add, picture, x+0 ys+35 w40 h395 BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_image_overlay_right_only.png
gui, MainWindow:add, picture, xs y+0 w690 h35 BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_image_overlay_bottom_only.png
gui, MainWindow:add, picture, xs y+30 w70 h50 vConsoleOpenConsoleLogFilePictureButtonVar gConsoleOpenConsoleLogFilePictureButton BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_file_pic_button.png
gui, MainWindow:add, picture, x+20 yp w70 h50 vConsoleEmpty1PictureButtonVar gConsoleEmpty1PictureButton BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_empty_pic_button.png
gui, MainWindow:add, picture, x+20 yp w70 h50 vConsoleEmpty2PictureButtonVar gConsoleEmpty2PictureButton BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_empty_pic_button.png
gui, MainWindow:add, picture, x+20 yp w70 h50 vConsoleEmpty3PictureButtonVar gConsoleEmpty3PictureButton BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_empty_pic_button.png
gui, MainWindow:add, progress, x+20 yp-10 w335 h70 c393837 Background393837 disabled -E0x0200, 100
gui, MainWindow:add, picture, xp+10 yp+10 w30 h20 vConsoleSetColorRedVar gConsoleSetColorRed section, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_set_color_red_pic_button.png
gui, MainWindow:add, picture, x+10 yp w30 h20 vConsoleSetColorBrownVar gConsoleSetColorBrown, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_set_color_brown_pic_button.png
gui, MainWindow:add, picture, x+10 yp w30 h20 vConsoleSetColorOrangeVar gConsoleSetColorOrange, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_set_color_orange_pic_button.png
gui, MainWindow:add, picture, x+10 yp w30 h20 vConsoleSetColorYellowVar gConsoleSetColorYellow, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_set_color_yellow_pic_button.png
gui, MainWindow:add, picture, x+10 yp w30 h20 vConsoleSetColorGreenVar gConsoleSetColorGreen, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_set_color_green_pic_button.png
gui, MainWindow:add, picture, x+10 yp w30 h20 vConsoleSetColorDarkGreenVar gConsoleSetColorDarkGreen, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_set_color_dark_green_pic_button.png
gui, MainWindow:add, picture, x+10 yp w30 h20 vConsoleSetColorCyanVar gConsoleSetColorCyan, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_set_color_cyan_pic_button.png
gui, MainWindow:add, picture, x+10 yp w30 h20 vConsoleSetColorBlueVar gConsoleSetColorBlue, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_set_color_dark_blue_pic_button.png
gui, MainWindow:add, picture, xs y+10 w30 h20 vConsoleSetColorPurpleVar gConsoleSetColorPurple section, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_set_color_purple_pic_button.png
gui, MainWindow:add, picture, x+10 yp w30 h20 vConsoleSetColorPinkVar gConsoleSetColorPink, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_set_color_pink_pic_button.png
gui, MainWindow:add, picture, x+10 yp w30 h20 vConsoleSetColorLightPinkVar gConsoleSetColorLightPink, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_set_color_light_pink_pic_button.png
gui, MainWindow:add, picture, x+10 yp w30 h20 vConsoleSetColorDarkGrayVar gConsoleSetColorDarkGray, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_set_color_dark_gray_pic_button.png
gui, MainWindow:add, picture, x+10 yp w30 h20 vConsoleSetColorGrayVar gConsoleSetColorGray, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_set_color_gray_pic_button.png
gui, MainWindow:add, picture, x+10 yp w30 h20 vConsoleSetColorLightGrayVar gConsoleSetColorLightGray, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_set_color_light_gray_pic_button.png
gui, MainWindow:add, picture, x+10 yp w30 h20 vConsoleSetColorLightYellowVar gConsoleSetColorLightYellow, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_set_color_light_yellow_pic_button.png
gui, MainWindow:add, picture, x+10 yp w30 h20 vConsoleSetColorWhiteVar gConsoleSetColorWhite, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_set_color_white_pic_button.png

gui, MainWindow:add, picture, x+30 ys-495 w70 h50 vConsoleShowConsolePictureButtonVar gConsoleShowConsolePictureButton section, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_server_console_show_pic_button.png
gui, MainWindow:add, picture, x+5 yp w70 h50 vConsoleShowServerInBrowserPictureButtonVar gConsoleShowServerInBrowserPictureButton BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_server_show_pic_button.png
gui, MainWindow:add, picture, x+5 yp w70 h50 vConsoleDisableServerCheatsPictureButtonVar gConsoleDisableServerCheatsPictureButton BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_cheats_off_pic_button.png
gui, MainWindow:add, picture, xs y+5 w70 h50 vConsoleHideConsolePictureButtonVar gConsoleHideConsolePictureButton BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_server_console_hide_pic_button.png
gui, MainWindow:add, picture, x+5 yp w70 h50 vConsoleHideServerInBrowserPictureButtonVar gConsoleHideServerInBrowserPictureButton BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_server_hide_pic_button.png
gui, MainWindow:add, picture, x+5 yp w70 h50 vConsoleEnableServerCheatsPictureButtonVar gConsoleEnableServerCheatsPictureButton BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_cheats_on_pic_button.png
gui, MainWindow:add, picture, xs y+30 w70 h50 vConsoleShowFetchIPWindowPictureButtonVar gConsoleShowFetchIPWindowPictureButton BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_ip_fetch_pic_button.png
gui, MainWindow:add, picture, x+5 yp w70 h50 vConsoleEmpty4PictureButtonVar gConsoleEmpty4PictureButton BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_empty_pic_button.png
gui, MainWindow:add, picture, x+5 yp w70 h50 vConsoleEmpty5PictureButtonVar gConsoleEmpty5PictureButton BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_empty_pic_button.png
gui, MainWindow:add, picture, xs y+5 w70 h50 vConsoleEmpty6PictureButtonVar gConsoleEmpty6PictureButton BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_empty_pic_button.png
gui, MainWindow:add, picture, x+5 yp w70 h50 vConsoleEmpty7PictureButtonVar gConsoleEmpty7PictureButton BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_empty_pic_button.png
gui, MainWindow:add, picture, x+5 yp w70 h50 vConsoleEmpty8PictureButtonVar gConsoleEmpty8PictureButton BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_empty_pic_button.png
gui, MainWindow:add, picture, xs y+5 w70 h50 vConsoleEmpty9PictureButtonVar gConsoleEmpty9PictureButton BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_empty_pic_button.png
gui, MainWindow:add, picture, x+5 yp w70 h50 vConsoleEmpty10PictureButtonVar gConsoleEmpty10PictureButton BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_empty_pic_button.png
gui, MainWindow:add, picture, x+5 yp w70 h50 vConsoleEmpty11PictureButtonVar gConsoleEmpty11PictureButton BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_empty_pic_button.png
gui, MainWindow:add, picture, xs y+5 w70 h50 vConsoleEmpty12PictureButtonVar gConsoleEmpty12PictureButton BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_empty_pic_button.png
gui, MainWindow:add, picture, x+5 yp w70 h50 vConsoleEmpty13PictureButtonVar gConsoleEmpty13PictureButton BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_empty_pic_button.png
gui, MainWindow:add, picture, x+5 yp w70 h50 vConsoleEmpty14PictureButtonVar gConsoleEmpty14PictureButton BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_empty_pic_button.png
gui, MainWindow:add, picture, xs y+5 w70 h50 vConsoleEmpty15PictureButtonVar gConsoleEmpty15PictureButton BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_empty_pic_button.png
gui, MainWindow:add, picture, x+5 yp w70 h50 vConsoleEmpty16PictureButtonVar gConsoleEmpty16PictureButton BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_empty_pic_button.png
gui, MainWindow:add, picture, x+5 yp w70 h50 vConsoleEmpty17PictureButtonVar gConsoleEmpty17PictureButton BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_empty_pic_button.png
gui, MainWindow:add, picture, xs+25 y+20 w95 h95 vConsoleTextSizePictureVar gConsoleTextSizePicture BackgroundTrans, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Rotary_switch_state_1_pic_button.png ;Use tooltip instead and ctrl+wheel up and down for that and the wheel down idea
gui, MainWindow:add, picture, x+30 yp+5 w40 h85 vConsoleToggleConsoleLogFileMonitoringVar gConsoleToggleConsoleLogFileMonitoring, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png
gosub, ApplyConsoleToggleConsoleLogFileMonitoringFromINI

gui, ConsoleFetchIPWindow:new, -caption +border, Fetch IP
gui, ConsoleFetchIPWindow:font, cece5cb s14 norm, Impact
gui, ConsoleFetchIPWindow:Color, 5f372d, 221f1c
gui, ConsoleFetchIPWindow:add, progress, x0 y0 w580 h30 disabled c2d2824 section, 100
gui, ConsoleFetchIPWindow:add, text, 0x200 xp+20 yp w450 h30 gMoveUI BackgroundTrans, Fetch IP
gui, ConsoleFetchIPWindow:add, picture, x+10 yp+5 w20 h20 vConsoleFetchIPAlwaysOnTopWindowPictureButtonVar gConsoleFetchIPAlwaysOnTopWindowPictureButton BackgroundTrans border, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Toolbar_pin_window_off.png
gui, ConsoleFetchIPWindow:add, picture, x+5 yp w20 h20 vConsoleFetchIPWindowMinimizeWindowPictureButtonVar gConsoleFetchIPWindowMinimizeWindowPictureButton BackgroundTrans border, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Toolbar_minimize.png
gui, ConsoleFetchIPWindow:add, picture, x+5 yp w20 h20 vConsoleFetchIPWindowCloseWindowPictureButtonVar gConsoleFetchIPWindowCloseWindowPictureButton BackgroundTrans border, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Toolbar_close.png
gui, ConsoleFetchIPWindow:add, text, 0x200 xs+30 ys+50 w100 h30 section, Private IP
gui, ConsoleFetchIPWindow:add, edit, x+10 yp w380 h30 vConsoleFetchIPWindowPrivateIPEditVar readonly
gui, ConsoleFetchIPWindow:add, Progress, x+0 yp w30 h30 vConsoleCopyPrivateIPToClipboardProgressVar Background221f1c disabled border
gui, ConsoleFetchIPWindow:add, text, 0x200 xp yp w30 h30 vConsoleCopyPrivateIPToClipboardTextVar gConsoleCopyPrivateIPToClipboardText c646464 center BackgroundTrans, % Chr(0x1F4CB)
gui, ConsoleFetchIPWindow:add, text, 0x200 xs y+10 w100 h30, Public IP
gui, ConsoleFetchIPWindow:add, edit, x+10 yp w380 h30 vConsoleFetchIPWindowPublicIPEditVar readonly
gui, ConsoleFetchIPWindow:add, Progress, x+0 yp w30 h30 vConsoleCopyPublicIPToClipboardProgressVar Background221f1c disabled border
gui, ConsoleFetchIPWindow:add, text, 0x200 xp yp w30 h30 vConsoleCopyPublicIPToClipboardTextVar gConsoleCopyPublicIPToClipboardText c646464 center BackgroundTrans, % Chr(0x1F4CB)
gui, ConsoleFetchIPWindow:add, text, 0x200 xs y+10 w100 h30, Fake IP
gui, ConsoleFetchIPWindow:add, edit, x+10 yp w380 h30 vConsoleFetchIPWindowFakeIPEditVar readonly
gui, ConsoleFetchIPWindow:add, Progress, x+0 yp w30 h30 vConsoleCopyFakeIPToClipboardProgressVar Background221f1c disabled border
gui, ConsoleFetchIPWindow:add, text, 0x200 xp yp w30 h30 vConsoleCopyFakeIPToClipboardTextVar gConsoleCopyFakeIPToClipboardText c646464 center BackgroundTrans, % Chr(0x1F504)
GuiControl, SplashGUIWindow:, LoadingVar, 60

;_______________________________________Paths___________________________________________
gui, MainWindow:tab, Paths
gui, MainWindow:font, cece5cb s16 norm, Impact
gui MainWindow:default
gui, MainWindow:add, picture, x65 y135 w440 h25 section , %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_image_overlay_top_only.png
gui, MainWindow:add, picture, xp y+0 w25 h260, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_image_overlay_left_only.png
gui, MainWindow:font, c10900d s13 bold underline, Courier New
gui, MainWindow:add, Progress, x+0 yp w390 h30 c221f1c Background221f1c disabled -border
gui, MainWindow:add, text, 0x200 xp yp w390 h30 BackgroundTrans, Hosts                                                                _
gui, MainWindow:font, c10900d s12 bold norm, Courier New
gui, MainWindow:add, listbox, 0x100 xp y+0 w390 h170 vPathsHostsListboxVar gPathsHostsListbox -VScroll -E0x200
gui, MainWindow:add, edit, xp y+0 w330 h30 vPathsAddHostEditVar -Vscroll -E0x200 border
gui, MainWindow:font, ceee4be s16 norm, Impact
gui, MainWindow:add, Progress, x+0 yp w30 h30 vPathsRemoveHostProgressVar c221f1c Background221f1c disabled -border
gui, MainWindow:add, text, 0x200 xp yp w30 h30 vPathsRemoveHostListboxVar gPathsRemoveHostListbox c646464 center BackgroundTrans border, -
gui, MainWindow:add, Progress, x+0 yp w30 h30 vPathsAddHostProgressVar c221f1c Background221f1c disabled -border
gui, MainWindow:add, text, 0x200 xp yp w30 h30 vPathsAddHostTextButtonVar gPathsAddHostTextButton c646464 center BackgroundTrans border, +
gui, MainWindow:font, c10900d s10 bold underline, Courier New
gui, MainWindow:add, Progress, xs+25 y+0 w390 h30 c221f1c Background221f1c disabled -border
gui, MainWindow:add, text, 0x200 xp yp w390 h30 vPathsSelectedHostTextVar BackgroundTrans, del - remove host, Enter - add host           _
gui, MainWindow:add, picture, x+0 ys+25 w25 h260 , %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_image_overlay_right_only.png
gui, MainWindow:add, picture, xs y+0 w440 h25, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_image_overlay_bottom_only.png
gui, MainWindow:add, picture, xs+480 ys w440 h25 section , %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_image_overlay_top_only.png
gui, MainWindow:add, picture, xp y+0 w25 h260 , %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_image_overlay_left_only.png
gui, MainWindow:font, c10900d s13 bold underline, Courier New
gui, MainWindow:add, Progress, x+0 yp w390 h30 c221f1c Background221f1c disabled -border
gui, MainWindow:add, text, 0x200 xp yp w390 h30 BackgroundTrans, Name                    Path                      _
gui, MainWindow:font, c10900d s12 bold norm, Courier New
gui, MainWindow:add, listview, xp y+0 w390 h170 vPathsChangePathInINILVVar gPathsChangePathLV 0x2000 -E0x200 -multi -hdr Altsubmit Tooltip, Name|Path
LV_ModifyCol(1, 235)
LV_ModifyCol(2, 150)
Iniread, EXEPathFromINI, %A_scriptdir%\Server Boss All\Hosts\%FirstLoopedHostNameNoExt%.ini, Paths, Exe
LV_Add("", "exe host file", (EXEPathFromINI != "ERROR") ? (EXEPathFromINI) : (""))
Iniread, TFPathFromINI, %A_scriptdir%\Server Boss All\Hosts\%FirstLoopedHostNameNoExt%.ini, Paths, Tf
LV_Add("", "Tf folder", (TFPathFromINI != "ERROR") ? (TFPathFromINI) : (""))
Iniread, MapsPathFromINI, %A_scriptdir%\Server Boss All\Hosts\%FirstLoopedHostNameNoExt%.ini, Paths, Maps
LV_Add("", "Maps folder", (MapsPathFromINI != "ERROR") ? (MapsPathFromINI) : (""))
Iniread, CFGPathFromINI, %A_scriptdir%\Server Boss All\Hosts\%FirstLoopedHostNameNoExt%.ini, Paths, Cfg
LV_Add("", "Cfg folder", (CFGPathFromINI != "ERROR") ? (CFGPathFromINI) : (""))
Iniread, GameWorkshopPathFromINI, %A_scriptdir%\Server Boss All\Hosts\%FirstLoopedHostNameNoExt%.ini, Paths, GameWorkshop
LV_Add("", "Steam workshop folder", (GameWorkshopPathFromINI != "ERROR") ? (GameWorkshopPathFromINI) : (""))
Iniread, MapDownloadsPathFromINI, %A_scriptdir%\Server Boss All\Hosts\%FirstLoopedHostNameNoExt%.ini, Paths, MapDownloads
LV_Add("", "Game download folder", (MapDownloadsPathFromINI != "ERROR") ? (MapDownloadsPathFromINI) : (""))
gui, MainWindow:add, edit, xp y+0 w300 h30 vPathsChangePathEditVar -Vscroll -E0x200 border
gui, MainWindow:font, ceee4be s16 norm, Impact
gui, MainWindow:add, Progress, x+0 yp w30 h30 vPathsEditPathProgressVar c221f1c Background221f1c disabled -border
gui, MainWindow:add, text, 0x200 xp yp w30 h30 vPathsEditPathTextVar gPathsEditPathText c646464 center BackgroundTrans border, % Chr(0x270F)
gui, MainWindow:add, Progress, x+0 yp w30 h30 vPathOpenPathProgressVar c221f1c Background221f1c disabled -border
gui, MainWindow:add, text, 0x200 xp yp w30 h30 vPathOpenPathTextVar gPathOpenPathText c646464 center BackgroundTrans border, % Chr(0x1F4C2)
gui, MainWindow:add, Progress, x+0 yp w30 h30 vPathInfoProgressVar c221f1c Background221f1c disabled -border
gui, MainWindow:add, text, 0x200 xp yp w30 h30 vPathInfoTextVar gPathInfoText c646464 center BackgroundTrans border, ?
gui, MainWindow:font, c10900d s10 bold underline, Courier New
gui, MainWindow:add, Progress, xs+25 y+0 w390 h30 c221f1c Background221f1c disabled -border
gui, MainWindow:add, text, 0x200 xp yp w390 h30 vPathsSelectedPathTextVar BackgroundTrans, Selected path:                                       _
gui, MainWindow:font, ceee4be s16 norm, Impact
gui, MainWindow:add, picture, x+0 ys+25 w25 h260, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_image_overlay_right_only.png
gui, MainWindow:add, picture, xs y+0 w440 h25, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_image_overlay_bottom_only.png
gui, MainWindow:add, picture, xs-480 ys+360 w70 h50 vPathsAddGameEXEPictureButtonVar gPathsAddGameEXEPictureButton section, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Paths_find_dedicated_server_files_and_paths_x32_bit_pic_button.png
gui, MainWindow:add, picture, x+5 yp w70 h50 vPathsAddGame64EXEPictureButtonVar gPathsAddGame64EXEPictureButton, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Paths_find_dedicated_server_files_and_paths_x64_bit_pic_button.png
gui, MainWindow:add, picture, x+5 yp w70 h50 vPathsAddGameTF32EXEPictureButtonVar gPathsAddGameTF32EXEPictureButton, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Paths_find_game_tf2_files_and_paths_x32_bit_pic_button.png
gui, MainWindow:add, picture, x+5 yp w70 h50 vPathsAddGameTF64EXEPictureButtonVar gPathsAddGameTF64EXEPictureButton, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Paths_find_game_tf2_files_and_paths_x64_bit_pic_button.png
gui, MainWindow:add, picture, x+5 yp w70 h50 vPathsInstallServerPictureButtonVar gPathsInstallServerPictureButton, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Paths_install_dedicated_server_pic_button.png
gui, MainWindow:add, picture, x+5 yp w70 h50 vPathsUpdateServerPictureButtonVar gPathsUpdateServerPictureButton, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Paths_update_server_pic_button.png
gui, MainWindow:add, picture, xs y+5 w70 h50 vPathsEmpty1PictureButtonVar gPathsEmpty1PictureButton, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_empty_pic_button.png
gui, MainWindow:add, picture, x+5 yp w70 h50 vPathsEmpty2PictureButtonVar gPathsEmpty2PictureButton, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_empty_pic_button.png
gui, MainWindow:add, picture, x+5 yp w70 h50 vPathsEmpty3PictureButtonVar gPathsEmpty3PictureButton, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_empty_pic_button.png
gui, MainWindow:add, picture, x+5 yp w70 h50 vPathsEmpty4PictureButtonVar gPathsEmpty4PictureButton, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_empty_pic_button.png
gui, MainWindow:add, picture, x+5 yp w70 h50 vPathsEmpty5PictureButtonVar gPathsEmpty5PictureButton, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_empty_pic_button.png
gui, MainWindow:add, picture, x+5 yp w70 h50 vPathsEmpty6PictureButtonVar gPathsEmpty6PictureButton, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_empty_pic_button.png
gui, MainWindow:add, picture, xs y+5 w70 h50 vPathsEmpty7PictureButtonVar gPathsEmpty7PictureButton, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_empty_pic_button.png
gui, MainWindow:add, picture, x+5 yp w70 h50 vPathsEmpty8PictureButtonVar gPathsEmpty8PictureButton, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_empty_pic_button.png
gui, MainWindow:add, picture, x+5 yp w70 h50 vPathsEmpty9PictureButtonVar gPathsEmpty9PictureButton, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_empty_pic_button.png
gui, MainWindow:add, picture, x+5 yp w70 h50 vPathsEmpty10PictureButtonVar gPathsEmpty10PictureButton, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_empty_pic_button.png
gui, MainWindow:add, picture, x+5 yp w70 h50 vPathsEmpty11PictureButtonVar gPathsEmpty11PictureButton, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_empty_pic_button.png
gui, MainWindow:add, picture, x+5 yp w70 h50 vPathsEmpty12PictureButtonVar gPathsEmpty12PictureButton, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_empty_pic_button.png
gui, MainWindow:add, picture, x+30 ys w70 h50 vPathsAddGame32EXEPathPictureButtonVar gPathsAddGame32EXEPathPictureButton section, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Paths_find_game_x32_bit_pic_button.png
gui, MainWindow:add, picture, x+5 yp w70 h50 vPathsAddGame64EXEPathPictureButtonVar gPathsAddGame64EXEPathPictureButton, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Paths_find_game_x64_bit_pic_button.png
gui, MainWindow:add, picture, x+5 yp w70 h50 vPathsAddSRCDS32EXEPathPictureButtonVar gPathsAddSRCDS32EXEPathPictureButton, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Paths_find_dedicated_server_x32_bit_pic_button.png
gui, MainWindow:add, picture, x+5 yp w70 h50 vPathsAddSRCDS64EXEPathPictureButtonVar gPathsAddSRCDS64EXEPathPictureButton, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Paths_find_dedicated_server_x64_bit_pic_button.png
gui, MainWindow:add, picture, x+5 yp w70 h50 vPathsEmpty13PictureButtonVar gPathsEmpty13PictureButton, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_empty_pic_button.png
gui, MainWindow:add, picture, x+5 yp w70 h50 vPathsEmpty14PictureButtonVar gPathsEmpty14PictureButton, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_empty_pic_button.png
gui, MainWindow:add, picture, xs y+5 w70 h50 vPathsAddGameTFFolderPictureButtonVar gPathsAddGameTFFolderPictureButton, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Paths_tf_folder_pic_button.png
gui, MainWindow:add, picture, x+5 yp w70 h50 vPathsAddGameTFMapsFolderPictureButtonVar gPathsAddGameTFMapsFolderPictureButton, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Paths_maps_folder_pic_button.png
gui, MainWindow:add, picture, x+5 yp w70 h50 vPathsAddGameTFCfgFolderPictureButtonVar gPathsAddGameTFCfgFolderPictureButton, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Paths_cfg_folder_pic_button.png
gui, MainWindow:add, picture, x+5 yp w70 h50 vPathsAddGameWorkshopFolderPictureButtonVar gPathsAddGameWorkshopFolderPictureButton, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Paths_game_workshop_folder_pic_button.png
gui, MainWindow:add, picture, x+5 yp w70 h50 vPathsAddGameDownloadFolderPictureButtonVar gPathsAddGameDownloadFolderPictureButton, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Paths_maps_download_folder_pic_button.png
gui, MainWindow:add, picture, x+5 yp w70 h50 vPathsEmpty15PictureButtonVar gPathsEmpty15PictureButton, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_empty_pic_button.png
gui, MainWindow:add, picture, xs y+5 w70 h50 vPathsEmpty16PictureButtonVar gPathsEmpty16PictureButton, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_empty_pic_button.png
gui, MainWindow:add, picture, x+5 yp w70 h50 vPathsEmpty17PictureButtonVar gPathsEmpty17PictureButton, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_empty_pic_button.png
gui, MainWindow:add, picture, x+5 yp w70 h50 vPathsEmpty18PictureButtonVar gPathsEmpty18PictureButton, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_empty_pic_button.png
gui, MainWindow:add, picture, x+5 yp w70 h50 vPathsEmpty19PictureButtonVar gPathsEmpty19PictureButton, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_empty_pic_button.png
gui, MainWindow:add, picture, x+5 yp w70 h50 vPathsEmpty20PictureButtonVar gPathsEmpty20PictureButton, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_empty_pic_button.png
gui, MainWindow:add, picture, x+5 yp w70 h50 vPathsEmpty21PictureButtonVar gPathsEmpty21PictureButton, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_empty_pic_button.png
GuiControl, SplashGUIWindow:, LoadingVar, 70

;_________________________________Scan_window_________________________________
gui, ScanWindow:new, +border -caption, Scan for dedicated servers
gui, ScanWindow:font, cece5cb s14 norm, Impact
gui, ScanWindow:Color, 5f372d, 221f1c
gui, ScanWindow:add, progress, x0 y0 w570 h30 disabled c2d2824 section, 100
gui, ScanWindow:add, text, 0x200 xp+20 yp w440 h30 vScanWindowTitleTextVar gMoveUI BackgroundTrans
gui, ScanWindow:add, picture, x+10 yp+5 w20 h20 vScanWindowAlwaysOnTopWindowPictureButtonVar gScanWindowAlwaysOnTopWindowPictureButton BackgroundTrans border, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Toolbar_pin_window_off.png
gui, ScanWindow:add, picture, x+5 yp w20 h20 vScanWindowMinimizeWindowPictureButtonVar gScanWindowMinimizeWindowPictureButton BackgroundTrans border, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Toolbar_minimize.png
gui, ScanWindow:add, picture, x+5 yp w20 h20 vScanWindowCloseWindowPictureButtonVar gScanWindowCloseWindowPictureButton BackgroundTrans border, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Toolbar_close.png
gui, ScanWindow:font, c10900d s12 bold norm, Courier New
gui, ScanWindow:add, picture, xs+20 y+20 w440 h25 section, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_image_overlay_top_only.png
gui, ScanWindow:add, picture, xp y+0 w25 h260, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_image_overlay_left_only.png
gui, ScanWindow:add, edit, x+0 yp w390 h260 vConfirmationEditVar -VScroll -E0x200
gui, ScanWindow:add, picture, x+0 ys+25 w25 h260, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_image_overlay_right_only.png
gui, ScanWindow:add, picture, xs y+0 w440 h25, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_image_overlay_bottom_only.png
gui, ScanWindow:add, picture, x+20 ys+20 w70 h50 vScanWindowStartScanningPictureButtonVar gScanWindowStartScanningPictureButton, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Accept_pic_button.png
gui, ScanWindow:add, picture, xp y+10 w70 h50 vScanWindowAbortPictureButtonVar gScanWindowAbortPictureButton, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Cancel_pic_button.png

;______________________________Server_install_________________________________
gui, InstallServerWindow:new, +border -caption, Install dedicated server
gui, InstallServerWindow:font, cece5cb s14 norm, Impact
gui, InstallServerWindow:Color, 5f372d, 221f1c
gui, InstallServerWindow:add, progress, x0 y0 w840 h30 disabled c2d2824 section, 100
gui, InstallServerWindow:add, text, 0x200 xp+20 yp w715 h30 vScanWindowTitleTextVar gMoveUI BackgroundTrans, Setup dedicated server
gui, InstallServerWindow:add, picture, x+10 yp+5 w20 h20 vInstallWindowAlwaysOnTopWindowPictureButtonVar gInstallWindowAlwaysOnTopWindowPictureButton BackgroundTrans border, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Toolbar_pin_window_off.png
gui, InstallServerWindow:add, picture, x+5 yp w20 h20 vInstallWindowMinimizeWindowPictureButtonVar gInstallWindowMinimizeWindowPictureButton BackgroundTrans border, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Toolbar_minimize.png
gui, InstallServerWindow:add, picture, x+5 yp w20 h20 vInstallWindowCloseWindowPictureButtonVar gInstallWindowCloseWindowPictureButton BackgroundTrans border, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Toolbar_close.png
gui, InstallServerWindow:font, c10900d s12 bold norm, Courier New
gui, InstallServerWindow:add, picture, xs+20 y+20 w710 h30 section, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_image_overlay_top_only.png
gui, InstallServerWindow:add, picture, xp y+0 w40 h400, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_image_overlay_left_only.png
gui, InstallServerWindow:add, edit, x+0 yp w630 h400 vInstallServerEditVar -VScroll -E0x200
gui, InstallServerWindow:add, picture, x+0 yp w40 h400, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_image_overlay_right_only.png
gui, InstallServerWindow:add, picture, xs y+0 w710 h30, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_image_overlay_bottom_only.png
gui, InstallServerWindow:add, picture, x+20 ys+20 w70 h50 vInstallServerSetupServerVar gInstallServerSetupServer, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Accept_pic_button.png
gui, InstallServerWindow:add, picture, xp y+10 w70 h50 vInstallServerAbortVar gInstallServerAbort, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Cancel_pic_button.png
gui, InstallServerWindow:add, picture, xp y+360 w70 h50 vInstallServerRestorePathVar gInstallServerRestorePath, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Game_restart_server_pic_button.png
gui, InstallServerWindow:font, cece5cb s14 norm, Impact
gui, InstallServerWindow:add, text, 0x200 xs ys+480 w150 h30 section, Install location
gui, InstallServerWindow:font, c10900d s12 bold norm, Courier New
gui, InstallServerWindow:add, edit, x+10 yp w550 h30 vInstallServerInstallPathEditVar gInstallServerInstallPathEdit, % A_ScriptDir
gui, InstallServerWindow:font, cece5cb s14 norm, Impact
gui, InstallServerWindow:add, text, 0x200 xs y+10 w150 h30, 32 - bit host name
gui, InstallServerWindow:font, c10900d s12 bold norm, Courier New
gui, InstallServerWindow:add, edit, x+10 yp w185 h30 vInstallServer32BitHostNameEditVar, Dedicated32BitServer
gui, InstallServerWindow:font, cece5cb s14 norm, Impact
gui, InstallServerWindow:add, text, 0x200 x+20 yp w150 h30, 64 - bit host name
gui, InstallServerWindow:font, c10900d s12 bold norm, Courier New
gui, InstallServerWindow:add, edit, x+10 yp w185 h30 vInstallServer64BitHostNameEditVar, Dedicated64BitServer

;______________________________Server_update_________________________________
gui, UpdateServerWindow:new, +border -caption, Update server
gui, UpdateServerWindow:font, cece5cb s14 norm, Impact
gui, UpdateServerWindow:Color, 5f372d, 221f1c
gui, UpdateServerWindow:add, progress, x0 y0 w510 h30 disabled c2d2824 section, 100
gui, UpdateServerWindow:add, text, 0x200 xp+20 yp w385 h30 gMoveUI BackgroundTrans, Update server
gui, UpdateServerWindow:add, picture, x+10 yp+5 w20 h20 vUpdateWindowAlwaysOnTopWindowPictureButtonVar gUpdateWindowAlwaysOnTopWindowPictureButton BackgroundTrans border, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Toolbar_pin_window_off.png
gui, UpdateServerWindow:add, picture, x+5 yp w20 h20 vUpdateWindowMinimizeWindowPictureButtonVar gUpdateWindowMinimizeWindowPictureButton BackgroundTrans border, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Toolbar_minimize.png
gui, UpdateServerWindow:add, picture, x+5 yp w20 h20 vUpdateWindowCloseWindowPictureButtonVar gUpdateWindowCloseWindowPictureButton BackgroundTrans border, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Toolbar_close.png
gui, UpdateServerWindow:add, picture, xs+20 y+20 w380 h30 section, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Vertical_console_image_overlay_top_only.png
gui, UpdateServerWindow:add, picture, xp y+0 w35 h400, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Vertical_console_image_overlay_left_only.png

gui, UpdateServerWindow:font, c10900d s13 bold underline, Courier New
gui, UpdateServerWindow:add, Progress, x+0 yp w310 h30 c221f1c Background221f1c disabled -border
gui, UpdateServerWindow:add, text, 0x200 xp yp w310 h30 BackgroundTrans, Dedicated servers hosts                                                _
gui, UpdateServerWindow:font, c10900d s12 bold norm, Courier New
gui, UpdateServerWindow:add, listview, 0x100 xp y+0 w310 h340 vUpdateServerLVVar gUpdateServerLV -VScroll -E0x200 altsubmit -hdr, Name|Path|Pid
LV_ModifyCol(1, 290)
LV_ModifyCol(2, 1)
LV_ModifyCol(3, 1)
gui, UpdateServerWindow:font, c10900d s11 bold underline, Courier New
gui, UpdateServerWindow:add, Progress, xp y+0 w310 h30 c221f1c Background221f1c disabled -border
gui, UpdateServerWindow:add, text, 0x200 xp yp vUpdateServerHostStatusVar w310 h30 BackgroundTrans, Selected host:                              _
gui, UpdateServerWindow:add, picture, x+0 ys+20 w35 h400, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Vertical_console_image_overlay_right_only.png
gui, UpdateServerWindow:add, picture, xs y+0 w380 h30, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Vertical_console_image_overlay_bottom_only.png
gui, UpdateServerWindow:add, picture, x+20 ys+20 w70 h50 vUpdateServer gUpdateServer, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Accept_pic_button.png
gui, UpdateServerWindow:add, picture, xp y+10 w70 h50 vUpdateServerAbortVar gUpdateServerAbort, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Cancel_pic_button.png

;______________________________Selected_Host____________________________________
gui, ServerHosts:new, -caption +border, Server hosts
gui, ServerHosts:font, cece5cb s12 norm, Impact
gui, ServerHosts:Color, 653d33, 221f1c
gui, ServerHosts:add, progress, x0 y0 w370 h30 disabled c2d2824 section, 100
gui, ServerHosts:add, text, 0x200 xp+20 yp w350 h30 gMoveUI BackgroundTrans, Server exe host
gui, ServerHosts:font, cece5cb s12, Impact
gui, ServerHosts:add, picture, xs+20 y+20 w330 h20 section, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_image_overlay_top_only.png
gui, ServerHosts:add, picture, xp y+0 w20 h180, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_image_overlay_left_only.png
gui, ServerHosts:font, c10900d s11 bold underline, Courier New
gui, ServerHosts:add, Progress, x+0 yp w290 h20 c221f1c Background221f1c disabled -border
gui, ServerHosts:add, text, 0x200 xp yp w290 h20 BackgroundTrans, Hosts                                                                _
gui, ServerHosts:font, c10900d s11 bold norm, Courier New
gui, ServerHosts:add, listbox, 0x100 xp y+0 w290 h140 -Vscroll -E0x200 vSelectServerHostListboxVar gSelectServerHostListbox
gui, ServerHosts:add, Progress, xp y+0 w290 h20 c221f1c Background221f1c disabled -border
gui, ServerHosts:add, text, 0x200 xp yp w290 h20 vSelectServerHostCurrentHostTextVar BackgroundTrans, Current host:                                                                _
gui, ServerHosts:add, picture, x+0 yp-160 w20 h180, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_image_overlay_right_only.png
gui, ServerHosts:add, picture, xp-310 y+0 w330 h20, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Console_image_overlay_bottom_only.png

;Custom tray menu
;___________________________________Tray_menu______________________________________
try menu, tray, delete, Exit
try menu, tray, click, 1                                                ;Open server tab with one click
try menu, tray, add, Server Boss, OpenAboutTab
try menu, tray, add                                                     ;Add separator line
try menu, tray, add, License, OpenLicense
try menu, tray, icon, License, %A_ScriptDir%\Server Boss All\Images\Icons\License.ico, 0
try menu, tray, add                                                     ;Add separator line
try menu, tray, icon, Server Boss, %A_ScriptDir%\Server Boss All\Images\Icons\Server boss.ico, 0
try menu, tray, add, Game, OpenGameTab
try menu, tray, icon, Game, %A_ScriptDir%\Server Boss All\Images\Icons\Game.ico, 0
try menu, tray, add, Console, OpenConsoleTab
try menu, tray, icon, Console, %A_ScriptDir%\Server Boss All\Images\Icons\Console.ico, 0
try menu, tray, add, Paths, OpenPathsTab
try menu, tray, icon, Paths, %A_ScriptDir%\Server Boss All\Images\Icons\Paths.ico, 0
try menu, tray, add
try menu, tray, add, Open repository, OpenRepo
try menu, tray, icon, Open repository, %A_ScriptDir%\Server Boss All\Images\Icons\Repository.ico, 0
try menu, tray, add
try menu, tray, add, Exit, CloseProgram						                                 ;Close Server Boss
try menu, tray, icon, Exit, %A_ScriptDir%\Server Boss All\Images\Icons\Exit.ico, 0
try menu, tray, default, Game
GuiControl, SplashGUIWindow:, LoadingVar, 80

gosub, ReadMainWindowSettingsFromINI
gosub, ApplyMainWindowSettingsFromINI
gosub, ScanForHosts
gosub, SetLastSavedHostsAndPaths
gui, MainWindow:font, ceee4be s16 norm, Impact
GuiControl, SplashGUIWindow:, LoadingVar, 100
Gui, SplashGUIWindow:hide
gui, MainWindow:show, w1050 h705
gosub, GameMapsListLB                                                                               ;Fix the image of the selected map upon launch
SetTimer, UpdateAllUpDownValuesInINI, 1000                                                          ;Perform a 1 second delay to safely save all values set by a rotary button using mouse wheelup:: or mouse wheeldown::
SetTimer, UpdateAllUpDownValuesInINI, Off
FixBrokenLVColumns("GameAdvancedWindow", "GameAdvancedMapOptionsPageLVVar", 30, 455, 90, 0, 0)
OnMessage(0x200, "WM_MOUSEMOVE")
return

;About window
;----------------------------------------------------------------------------------------------
AboutWindowCloseWindowPictureButton:
EmulateButtonPress(A_ScriptDir "\Server Boss All\Images\Custom UI controls\Toolbar_close", "AboutWindow", "AboutWindowCloseWindowPictureButtonVar")
Gui, AboutWindow:hide
return

;License window
;----------------------------------------------------------------------------------------------
LicenseWindowClosePictureButton:
EmulateButtonPress(A_ScriptDir "\Server Boss All\Images\Custom UI controls\Toolbar_close", "LicenseWindow", "LicenseWindowClosePictureButtonVar")
Gui, LicenseWindow:hide
return

LicenseWindowEdit:
GuiControl, LicenseWindow:, LicenseWindowEditVar, % LicenseVar
return

;Game tab
;----------------------------------------------------------------------------------------------
ScanForMaps:
GuiControl, MainWindow:, GameMapsListLBVar, |
gui, MainWindow:submit, nohide
Iniread, HostFromINI, %A_scriptdir%\Server Boss All\Settings.ini, SelectedServerHost, Host
FileRead, CurrentHostMapCycleList, %A_ScriptDir%\Server Boss All\Map cycles\%HostFromINI%.txt
ListBoxMapsList := ""
ListOfMapsArray := {}
ListOfWorkshopMapIDsArray := {}
loop, files, %A_ScriptDir%\Server Boss All\Hosts\*.ini
{
    IniRead, MapsPathFromINI, %A_LoopFileFullPath%, Paths, Maps
    IniRead, MapsDownloadsPathFromINI, %A_LoopFileFullPath%, Paths, MapDownloads
    IniRead, WorkshopMapsPathFromINI, %A_LoopFileFullPath%, Paths, GameWorkshop
    loop, files, %MapsPathFromINI%\*.bsp, F
    {
        SplitPath, A_LoopFileFullPath,,,, MapOutNameNoExt
        ListOfMapsArray[MapOutNameNoExt] := A_LoopFileFullPath
    }
    loop, files, %MapsDownloadsPathFromINI%\*.bsp, F
    {
        SplitPath, A_LoopFileFullPath,,,, MapOutNameNoExt
        ListOfMapsArray[MapOutNameNoExt] := A_LoopFileFullPath
    }
    loop, files, %A_ScriptDir%\Server Boss All\Dropped files\maps\*.bsp, F
    {
        SplitPath, A_LoopFileFullPath,,,, MapOutNameNoExt
        ListOfMapsArray[MapOutNameNoExt] := A_LoopFileFullPath
    }
    loop, files, %WorkshopMapsPathFromINI%\*.bsp, FR
    {
        SplitPath, A_LoopFileFullPath,, MapOutDir,, MapOutNameNoExt
        SplitPath, MapOutDir,,,, MapID
        ListOfMapsArray[MapOutNameNoExt] := A_LoopFileFullPath
        ListOfWorkshopMapIDsArray[MapOutNameNoExt] := MapID
    }
}
for MapName, value in ListOfMapsArray
ListBoxMapsList .= MapName . "|"
ListBoxMapsList .= "Random"
GuiControl, MainWindow:, GameMapsListLBVar, % ListBoxMapsList
return

ToolbarPinWindowText:
if (ToggleMainWindowAlwaysOnTop != 1)
{
    Gui, MainWindow:+AlwaysOnTop
    GuiControl, MainWindow:, GameAdvancedWindowAlwaysOnTopWindowPictureButtonVar, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Toolbar_pin_window_on.png

    Gui, MainWindow:font, cffffff s12, Impact
    GuiControl, MainWindow:font, ToolbarPinWindowTextVar
    GuiControl, MainWindow:+cffffff, ToolbarPinWindowTextVar

    ToggleMainWindowAlwaysOnTop := 1
    IniWrite, 1, %A_scriptdir%\Server Boss All\Settings.ini, MainWindow, ToggleMainWindowAlwaysOnTop
}
else if  (ToggleMainWindowAlwaysOnTop = 1)
{
    Gui, MainWindow:-AlwaysOnTop
    GuiControl, MainWindow:, GameAdvancedWindowAlwaysOnTopWindowPictureButtonVar, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Toolbar_pin_window_off.png

    Gui, MainWindow:font, cece5cb s12, Impact
    GuiControl, MainWindow:font, ToolbarPinWindowTextVar
    GuiControl, MainWindow:+cece5cb, ToolbarPinWindowTextVar

    ToggleMainWindowAlwaysOnTop := 0
    IniWrite, 0, %A_scriptdir%\Server Boss All\Settings.ini, MainWindow, ToggleMainWindowAlwaysOnTop
}
return

ToolbarMinimizeWindowText:
gui, MainWindow:minimize
return

ToolbarHideWindowText:
gui, MainWindow:hide
return

SetToolBarSettings:
IniRead, ServerTypeFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, ServerType
if (ServerTypeFromINI = "10")
GuiControl, MainWindow:, ToolbarServerTypeTextVar, Server type: SDR
else if (ServerTypeFromINI = "1")
GuiControl, MainWindow:, ToolbarServerTypeTextVar, Server type: Public
else if (ServerTypeFromINI = "2")
GuiControl, MainWindow:, ToolbarServerTypeTextVar, Server type: Local
IniRead, ExeHostFromINI, %A_scriptdir%\Server Boss All\Settings.ini, SelectedServerHost, Host
GuiControl, MainWindow:, ToolbarServerExeHostTextVar, Host : %ExeHostFromINI%
return

GameShowMapsListPicture:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Console_menu_pic_button", "MainWindow", "GameShowMapsListPictureVar")
ShowPopUpWindow("Search for maps online", "GameSearchForMapsOnlineWindow", 20, 20, false, 310, 340, true)
return

GameAddMapPicture:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Game_add_map_pic_button", "MainWindow", "GameAddMapPictureVar")
FileSelectFile, AddCustomMapToMapList, 3, RootDir, Add new map, Select map file (*.bsp)
if (AddCustomMapToMapList != "")
{
    FileFromFileExplorer := true
    CustomFileBrowserFilePath := AddCustomMapToMapList
    gosub, MainWindowGuiDropFiles
}
return

GameRemoveMapPicture:
gui, MainWindow:submit, nohide
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Game_delete_map_pic_button", "MainWindow", "GameRemoveMapPictureVar")
if (GameMapsListLBVar = "")
{
    DisplayTooltip("Map not selected!", 3)
    return
}
FileGetSize, MapSizeInMB, % ListOfMapsArray[GameMapsListLBVar], M
AnimateInformation("Do you want to delete" . A_Space . GameMapsListLBVar . ".bsp?`n`nLocation:" . A_Space . ListOfMapsArray[GameMapsListLBVar] . "`n`nSize:" . A_Space . MapSizeInMB . "MB", 40, "Delete map", "GameDeleteMapWindow", "GameDeleteMapWindowEditVar", 570, 380, "NoCustomCoordinates")
SetMapForDeletion := GameMapsListLBVar
return

GameOpenMapFolderPicture:
gui, MainWindow:submit, nohide
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Game_open_map_location_pic_button", "MainWindow", "GameOpenMapFolderPictureVar")
if (GameMapsListLBVar = "")
{
    DisplayTooltip("Map not selected!", 3)
    return
}
Run, % "explorer.exe /select," . Chr(34) . ListOfMapsArray[GameMapsListLBVar] . Chr(34)
return

GameSetMapCyclePicture:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Game_mapcycle_list_pic_button", "MainWindow", "GameSetMapCyclePictureVar")
Iniread, SelectedHostFromINI, %A_scriptdir%\Server Boss All\Settings.ini, SelectedServerHost, Host
FileRead, MapCycleList, %A_ScriptDir%\Server Boss All\Map cycles\%SelectedHostFromINI%.txt
GuiControl, GameMapCycleWindow:, GameMapCycleWindowLBVar, |
GuiControl, GameMapCycleWindow:, GameMapCycleWindowLBVar, % ListBoxMapsList
GuiControl, GameMapCycleWindow:, GameMapCycleListEditVar, % MapCycleList
gui, GameMapCycleWindow:show, w750 h375
return

GameFilterMapsPicture:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Game_filter_pic_button", "MainWindow", "GameFilterMapsPictureVar")
ShowPopUpWindow("Filter maps", "GameFilterMapsWindow", 20, 20, false, 310, 270, true)
return

GameShowMapInfoPicture:
gui, MainWindow:submit, nohide
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Game_map_info_pic_button", "MainWindow", "GameShowMapInfoPictureVar")
if (GameMapsListLBVar = "")
{
    DisplayTooltip("Map not selected!", 3)
    return
}
FileGetSize, MapSizeInMB, % ListOfMapsArray[GameMapsListLBVar], M
FileGetTime, MapModificationTime, % ListOfMapsArray[GameMapsListLBVar], M
FileGetTime, MapCreationTime, % ListOfMapsArray[GameMapsListLBVar], C
FileGetTime, MapLastAccessTime, % ListOfMapsArray[GameMapsListLBVar], A
FormatTime, MapModificationTime, MapModificationTime
FormatTime, MapCreationTime, MapCreationTime
FormatTime, MapLastAccessTime, MapLastAccessTime
(ListOfWorkshopMapIDsArray[GameMapsListLBVar] != "") ? (MapID := ListOfWorkshopMapIDsArray[GameMapsListLBVar]) : (MapID := "")
DisplayTooltip("Map name:" . A_Space . GameMapsListLBVar . "`nPath:" . A_Space . ListOfMapsArray[GameMapsListLBVar] . "`nSize:" . A_Space . MapSizeInMB . "MB`nModification time:" . A_Space . MapModificationTime . "`nCreation time:" . A_Space . MapCreationTime . "`nLast access time:" . A_Space . MapLastAccessTime . "`nWorkshop ID:" . A_Space . MapID, 5)
return

GameOpenMapWikiPicture:
gui, MainWindow:submit, nohide
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Game_open_wiki_map_page_pic_button", "MainWindow", "GameOpenMapWikiPictureVar")
if (GameMapsListLBVar = "")
{
    DisplayTooltip("Map not selected!", 3)
    return
}
run, https://wiki.teamfortress.com/wiki/%GameMapsListLBVar%
return

GameOpenMapWorkshopPagePicture:
gui, MainWindow:submit, nohide
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Game_open_workshop_map_page_pic_button", "MainWindow", "GameOpenMapWorkshopPagePictureVar")
if (GameMapsListLBVar = "")
{
    DisplayTooltip("Map not selected!", 3)
    return
}
if (ListOfWorkshopMapIDsArray[GameMapsListLBVar] = "")
DisplayTooltip("Map id not found!", 3)
else
{
    WorkshopMapID := ListOfWorkshopMapIDsArray[GameMapsListLBVar]
    run, https://steamcommunity.com/sharedfiles/filedetails/?id=%WorkshopMapID%&searchtext=
}
return

GameSelectRandomMapPicture:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Game_pick_random_map_pic_button", "MainWindow", "GameSelectRandomMapPictureVar")
GuiControl, MainWindow:choose, GameMapsListLBVar, Random
gosub, GameMapsListLB
return

MainWindowGuiDropFiles:
if (FileFromFileExplorer = true)
{
    SplitPath, CustomFileBrowserFilePath,, MapOutDir, MapOutExtension, MapOutNameNoExt
    if (ListOfMapsArray[MapOutNameNoExt] != "")
    {
        GuiControl, MainWindow:choose, GameMapsListLBVar, % MapOutNameNoExt
        gosub, GameMapsListLB
        FileFromFileExplorer := false
        return
    }
    else
    {
        FileCopy, %CustomFileBrowserFilePath%, %A_ScriptDir%\Server Boss All\Dropped files\maps\%MapOutNameNoExt%.bsp, 1
        ListOfMapsArray[MapOutNameNoExt] := A_ScriptDir . "\Server Boss All\Dropped files\maps\" . MapOutNameNoExt . ".bsp"
        ListBoxMapsList :=
        for MapName, value in ListOfMapsArray
        ListBoxMapsList .= MapName . "|"
        ListBoxMapsList .= "Random"
        GuiControl, MainWindow:, GameMapsListLBVar, |
        GuiControl, MainWindow:, GameMapsListLBVar, % ListBoxMapsList
        GuiControl, MainWindow:choose, GameMapsListLBVar, % MapOutNameNoExt
    }
}
else
{
    SplitPath, A_GuiEvent,, MapOutDir, MapOutExtension, MapOutNameNoExt
    if (ListOfMapsArray[MapOutNameNoExt] != "")
    {
        GuiControl, MainWindow:choose, GameMapsListLBVar, % MapOutNameNoExt
        gosub, GameMapsListLB
        FileFromFileExplorer := false
        return
    }
    else
    {
        FileCopy, %A_GuiEvent%, %A_ScriptDir%\Server Boss All\Dropped files\maps\%MapOutNameNoExt%.bsp, 1
        ListOfMapsArray[MapOutNameNoExt] := A_ScriptDir . "\Server Boss All\Dropped files\maps\" . MapOutNameNoExt . ".bsp"
        ListBoxMapsList :=
        for MapName, value in ListOfMapsArray
        ListBoxMapsList .= MapName . "|"
        ListBoxMapsList .= "Random"
        GuiControl, MainWindow:, GameMapsListLBVar, |
        GuiControl, MainWindow:, GameMapsListLBVar, % ListBoxMapsList
        GuiControl, MainWindow:choose, GameMapsListLBVar, % MapOutNameNoExt
    }
}
FileFromFileExplorer := false
return

GameMapsListLB:
gui, MainWindow:submit, nohide
IniWrite, %GameMapsListLBVar%, %A_scriptdir%\Server Boss All\Settings.ini, GameSettings, Map

GuiControl, MainWindow:, GameMapNameTextVar, % GameMapsListLBVar

BGImgOverlay := RegExReplace(A_ScriptDir, "\\", "/") . "/Server Boss All/Images/Custom UI controls/TV_image_overlay.png"

if FileExist(RegExReplace(A_ScriptDir, "\\", "/") . "/Server Boss All/Images/Map images/" . GameMapsListLBVar . ".jpg")
BGImg := RegExReplace(A_ScriptDir, "\\", "/") . "/Server Boss All/Images/Map images/" . GameMapsListLBVar . ".jpg"
else if FileExist(RegExReplace(A_ScriptDir, "\\", "/") . "/Server Boss All/Images/Map images/" . GameMapsListLBVar . ".png")
BGImg := RegExReplace(A_ScriptDir, "\\", "/") . "/Server Boss All/Images/Map images/" . GameMapsListLBVar . ".png"
else if FileExist(RegExReplace(A_ScriptDir, "\\", "/") . "/Server Boss All/Images/Map images/" . GameMapsListLBVar . ".bmp")
BGImg := RegExReplace(A_ScriptDir, "\\", "/") . "/Server Boss All/Images/Map images/" . GameMapsListLBVar . ".bmp"
else if FileExist(RegExReplace(A_ScriptDir, "\\", "/") . "/Server Boss All/Images/Map images/" . GameMapsListLBVar . ".gif")
BGImg := RegExReplace(A_ScriptDir, "\\", "/") . "/Server Boss All/Images/Map images/" . GameMapsListLBVar . ".gif"
else
BGImg := RegExReplace(A_ScriptDir, "\\", "/") . "/Server Boss All/Animations/tv_static.gif"

PercentageSign := "%"
HTMLImageScript =
(
<!DOCTYPE html>
<html>
<head>
</head>
<style>
body {
    grayscale(1);
    background-image: url('%BGImgOverlay%'), url('%BGImg%');
    background-repeat: no-repeat;
    background-attachment: fixed;
    background-size: cover;
}

</style>
<body>
</body>
</html>
)

GameMapsDisplayImageActiveXVar.Document.write(HTMLImageScript)
GameMapsDisplayImageActiveXVar.Document.close()
GameMapsDisplayImageActiveXVar.Refresh()
return

GameMapsPreviousPageText:
EmulateConsoleButtonPress("MainWindow", "GameMapsPreviousPageTextVar", Chr(0x2B06))
ControlSend, ListBox1, {PgUp}, Server Boss
return

GameMapsNextPageText:
EmulateConsoleButtonPress("MainWindow", "GameMapsNextPageTextVar", Chr(0x2B07))
ControlSend, ListBox1, {PgDn}, Server Boss
return

GameMapsSearchMapEdit:
gui, MainWindow:submit, nohide
GuiControl, MainWindow:choose, GameMapsListLBVar, % GameMapsSearchMapEditVar
gosub, GameMapsListLB
return

GameMapsClearMapSearchText:
EmulateConsoleButtonPress("MainWindow", "GameMapsClearMapSearchTextVar", "x")
GuiControl, MainWindow:, GameMapsSearchMapEditVar
return

GameServerNameEdit:
gui, MainWindow:submit, nohide
IniWrite, %GameServerNameEditVar%, %A_scriptdir%\Server Boss All\Settings.ini, GameSettings, ServerName
return

GameMaxPlayersEdit:
gui, MainWindow:submit, nohide
IniWrite, %GameMaxPlayersEditVar%, %A_scriptdir%\Server Boss All\Settings.ini, GameSettings, MaxPlayers
return

GameSetMaxPlayersForCasualText:
EmulateConsoleButtonPress("MainWindow", "GameSetMaxPlayersForCasualTextVar", "Casual")
GuiControl, MainWindow:, GameMaxPlayersEditVar, 24
IniWrite, 24, %A_scriptdir%\Server Boss All\Settings.ini, GameSettings, MaxPlayers
return

GameSetMaxPlayersForMVMText:
EmulateConsoleButtonPress("MainWindow", "GameSetMaxPlayersForMVMTextVar", "MVM")
GuiControl, MainWindow:, GameMaxPlayersEditVar, 32
IniWrite, 32, %A_scriptdir%\Server Boss All\Settings.ini, GameSettings, MaxPlayers
return

GameServerPasswordEdit:
gui, MainWindow:submit, nohide
IniWrite, %GameServerPasswordEditVar%, %A_scriptdir%\Server Boss All\Settings.ini, GameSettings, ServerPassword
return

GameGenerateServerPasswordText:
EmulateConsoleButtonPress("MainWindow", "GameGenerateServerPasswordTextVar", Chr(0x2699))
NewServerPassword := GeneratePassword("12")
GuiControl, MainWindow:, GameServerPasswordEditVar, % NewServerPassword
IniWrite, %NewServerPassword%, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, ServerPassword
return

GameServerPasswordPictureButton:
return

ReadMainWindowSettingsFromINI:
IniRead, MapFromINI, %A_scriptdir%\Server Boss All\Settings.ini, GameSettings, Map
IniRead, ServerNameFromINI, %A_scriptdir%\Server Boss All\Settings.ini, GameSettings, ServerName
IniRead, MaxPlayersFromINI, %A_scriptdir%\Server Boss All\Settings.ini, GameSettings, MaxPlayers
IniRead, ServerPasswordFromINI, %A_scriptdir%\Server Boss All\Settings.ini, GameSettings, ServerPassword
return

ApplyMainWindowSettingsFromINI:
GuiControl, MainWindow:choose, GameMapsListLBVar, % MapFromINI
GuiControl, MainWindow:, GameServerNameEditVar, % ServerNameFromINI
GuiControl, MainWindow:, GameMapNameTextVar, % ServerNameFromINI
GuiControl, MainWindow:, GameMaxPlayersEditVar, % MaxPlayersFromINI
GuiControl, MainWindow:, GameServerPasswordEditVar, % ServerPasswordFromINI
return

;Hotkeys
;----------------------------------------------------------------------------------------------
~Enter::
gui, MainWindow:submit, nohide
ControlGetFocus, CurrentFocusedGuiControl, Server Boss
if (MainWindowTab3Var = "Console") and (CurrentFocusedGuiControl = "Edit6")
SendConsoleInput(ConsoleInputEditVar, Tf2ServerPID)
return

~WheelUp::
gui, MainWindow:submit, nohide
gui, GameAdvancedWindow:submit, nohide
MouseGetPos,,, CurrentWinTitle, CurrentClassNN
WinGetTitle, WindowTitle, ahk_id %CurrentWinTitle%
if (WindowTitle = "License")
{
    ControlFocus, Edit1, License
    Send, {Up}
}
else if (WindowTitle = "Server Boss")
{
    if (CurrentA_GuiControl = "GameServerPasswordPictureButtonVar") and (ServerPasswordUpDownVar != 1)
    {
        RotarySwitchAnimation("MainWindow", "GameServerPasswordPictureButtonVar", GameMaxPlayersEditVar, "GameMaxPlayersEditVar", 1, 2)
        ServerPasswordUpDownVar := 1
    }
    else if (CurrentA_GuiControl = "GameServerPasswordPictureButtonVar") and (ServerPasswordUpDownVar = 1)
    {
        RotarySwitchAnimation("MainWindow", "GameServerPasswordPictureButtonVar", GameMaxPlayersEditVar, "GameMaxPlayersEditVar", 1, 1)
        ServerPasswordUpDownVar := 0
    }
    else if (CurrentA_GuiControl = "GameMapsListLBVar")
    ControlSend, ListBox1, {up}, Server Boss
    else if (CurrentA_GuiControl = "ConsoleEditVar")
    {
        ControlFocus, Edit5, Server Boss
        Send, {Up}
    }
    if (CurrentA_GuiControl = "ConsoleTextSizePictureVar") and (ConsoleTextSizeUpDownVar != 1)
    {
        IniRead, ConsoleSizeFromINI, %A_scriptdir%\Server Boss All\Settings.ini, MainWindow, ConsoleSize
        IniRead, ConsoleColorFromINI, %A_scriptdir%\Server Boss All\Settings.ini, MainWindow, ConsoleColor
        NewConsoleTextSize := ConsoleSizeFromINI + 1
        IniWrite, %NewConsoleTextSize%, %A_scriptdir%\Server Boss All\Settings.ini, MainWindow, ConsoleSize
        Gui, MainWindow:font, c%ConsoleColorFromINI% s%NewConsoleTextSize% bold, MS Gothic
        GuiControl, MainWindow:font, ConsoleEditVar
        GuiControl, MainWindow:+c%ConsoleColorFromINI%, ConsoleEditVar
        RotarySwitchAnimation("MainWindow", "ConsoleTextSizePictureVar", "", "", 1, 2)
        ConsoleTextSizeUpDownVar := 1
    }
    else if (CurrentA_GuiControl = "ConsoleTextSizePictureVar") and (ConsoleTextSizeUpDownVar = 1)
    {
        IniRead, ConsoleSizeFromINI, %A_scriptdir%\Server Boss All\Settings.ini, MainWindow, ConsoleSize
        IniRead, ConsoleColorFromINI, %A_scriptdir%\Server Boss All\Settings.ini, MainWindow, ConsoleColor
        NewConsoleTextSize := ConsoleSizeFromINI + 1
        IniWrite, %NewConsoleTextSize%, %A_scriptdir%\Server Boss All\Settings.ini, MainWindow, ConsoleSize
        Gui, MainWindow:font, c%ConsoleColorFromINI% s%NewConsoleTextSize% bold, MS Gothic
        GuiControl, MainWindow:font, ConsoleEditVar
        GuiControl, MainWindow:+c%ConsoleColorFromINI%, ConsoleEditVar
        RotarySwitchAnimation("MainWindow", "ConsoleTextSizePictureVar", "", "", 1, 1)
        ConsoleTextSizeUpDownVar := 0
    }
}
else if (WindowTitle = "Map cycle") and (CurrentA_GuiControl = "GameMapCycleWindowLBVar")
ControlSend, ListBox1, {up}, Map cycle
else if (WindowTitle = "Map cycle") and (CurrentA_GuiControl = "GameMapCycleListEditVar")
{
    ControlFocus, Edit2, Map cycle
    Send, {up}
}
else if (WindowTitle = "Filter maps") and (CurrentA_GuiControl = "GameFilterMapsLBVar")
ControlSend, ListBox1, {up}, Filter maps
else if (WindowTitle = "Advanced")
{
    if (CurrentA_GuiControl = "AdvancedWindowMaxRatePictureVar") and (MaxRateUpDownVar != 1)
    {
        RotarySwitchAnimation("GameAdvancedWindow", "AdvancedWindowMaxRatePictureVar", AdvancedWindowMaxRateEditVar, "AdvancedWindowMaxRateEditVar", 1, 2)
        MaxRateUpDownVar := 1
    }
    else if (CurrentA_GuiControl = "AdvancedWindowMaxRatePictureVar") and (MaxRateUpDownVar = 1)
    {
        RotarySwitchAnimation("GameAdvancedWindow", "AdvancedWindowMaxRatePictureVar", AdvancedWindowMaxRateEditVar, "AdvancedWindowMaxRateEditVar", 1, 1)
        MaxRateUpDownVar := 0
    }
    if (CurrentA_GuiControl = "AdvancedWindowMinRatePictureVar") and (MinRateUpDownVar != 1)
    {
        RotarySwitchAnimation("GameAdvancedWindow", "AdvancedWindowMinRatePictureVar", AdvancedWindowMinRateEditVar, "AdvancedWindowMinRateEditVar", 1, 2)
        MinRateUpDownVar := 1
    }
    else if (CurrentA_GuiControl = "AdvancedWindowMinRatePictureVar") and (MinRateUpDownVar = 1)
    {
        RotarySwitchAnimation("GameAdvancedWindow", "AdvancedWindowMinRatePictureVar", AdvancedWindowMinRateEditVar, "AdvancedWindowMinRateEditVar", 1, 1)
        MinRateUpDownVar := 0
    }
    if (CurrentA_GuiControl = "AdvancedWindowMaxUpdateRatePictureVar") and (MaxUpdateRateUpDownVar != 1)
    {
        RotarySwitchAnimation("GameAdvancedWindow", "AdvancedWindowMaxUpdateRatePictureVar", AdvancedWindowMaxUpdateRateEditVar, "AdvancedWindowMaxUpdateRateEditVar", 1, 2)
        MaxUpdateRateUpDownVar := 1
    }
    else if (CurrentA_GuiControl = "AdvancedWindowMaxUpdateRatePictureVar") and (MaxUpdateRateUpDownVar = 1)
    {
        RotarySwitchAnimation("GameAdvancedWindow", "AdvancedWindowMaxUpdateRatePictureVar", AdvancedWindowMaxUpdateRateEditVar, "AdvancedWindowMaxUpdateRateEditVar", 1, 1)
        MaxUpdateRateUpDownVar := 0
    }
    if (CurrentA_GuiControl = "AdvancedWindowMinUpdateRatePictureVar") and (MinUpdateRateUpDownVar != 1)
    {
        RotarySwitchAnimation("GameAdvancedWindow", "AdvancedWindowMinUpdateRatePictureVar", AdvancedWindowMinUpdateRateEditVar, "AdvancedWindowMinUpdateRateEditVar", 1, 2)
        MinUpdateRateUpDownVar := 1
    }
    else if (CurrentA_GuiControl = "AdvancedWindowMinUpdateRatePictureVar") and (MinUpdateRateUpDownVar = 1)
    {
        RotarySwitchAnimation("GameAdvancedWindow", "AdvancedWindowMinUpdateRatePictureVar", AdvancedWindowMinUpdateRateEditVar, "AdvancedWindowMinUpdateRateEditVar", 1, 1)
        MinUpdateRateUpDownVar := 0
    }
    if (CurrentA_GuiControl = "AdvancedWindowMaxCMDRatePictureVar") and (MaxCMDRateUpDownVar != 1)
    {
        RotarySwitchAnimation("GameAdvancedWindow", "AdvancedWindowMaxCMDRatePictureVar", AdvancedWindowMaxCMDRateEditVar, "AdvancedWindowMaxCMDRateEditVar", 1, 2)
        MaxCMDRateUpDownVar := 1
    }
    else if (CurrentA_GuiControl = "AdvancedWindowMaxCMDRatePictureVar") and (MaxCMDRateUpDownVar = 1)
    {
        RotarySwitchAnimation("GameAdvancedWindow", "AdvancedWindowMaxCMDRatePictureVar", AdvancedWindowMaxCMDRateEditVar, "AdvancedWindowMaxCMDRateEditVar", 1, 1)
        MaxCMDRateUpDownVar := 0
    }
    if (CurrentA_GuiControl = "AdvancedWindowMinCMDRatePictureVar") and (MinCMDRateUpDownVar != 1)
    {
        RotarySwitchAnimation("GameAdvancedWindow", "AdvancedWindowMinCMDRatePictureVar", AdvancedWindowMinCMDRateEditVar, "AdvancedWindowMinCMDRateEditVar", 1, 2)
        MinCMDRateUpDownVar := 1
    }
    else if (CurrentA_GuiControl = "AdvancedWindowMinCMDRatePictureVar") and (MinCMDRateUpDownVar = 1)
    {
        RotarySwitchAnimation("GameAdvancedWindow", "AdvancedWindowMinCMDRatePictureVar", AdvancedWindowMinCMDRateEditVar, "AdvancedWindowMinCMDRateEditVar", 1, 1)
        MinCMDRateUpDownVar := 0
    }
    if (CurrentA_GuiControl = "AdvancedWindowTimeoutPictureVar") and (TimeoutUpDownVar != 1)
    {
        RotarySwitchAnimation("GameAdvancedWindow", "AdvancedWindowTimeoutPictureVar", AdvancedWindowTimeoutEditVar, "AdvancedWindowTimeoutEditVar", 1, 2)
        TimeoutUpDownVar := 1
    }
    else if (CurrentA_GuiControl = "AdvancedWindowTimeoutPictureVar") and (TimeoutUpDownVar = 1)
    {
        RotarySwitchAnimation("GameAdvancedWindow", "AdvancedWindowTimeoutPictureVar", AdvancedWindowTimeoutEditVar, "AdvancedWindowTimeoutEditVar", 1, 1)
        TimeoutUpDownVar := 0
    }
    if (CurrentA_GuiControl = "AdvancedWindowMaxNumOfClientsPictureVar") and (MaxNumOfClientsUpDownVar != 1)
    {
        RotarySwitchAnimation("GameAdvancedWindow", "AdvancedWindowMaxNumOfClientsPictureVar", AdvancedWindowMaxNumOfClientsEditVar, "AdvancedWindowMaxNumOfClientsEditVar", 1, 2)
        MaxNumOfClientsUpDownVar := 1
    }
    else if (CurrentA_GuiControl = "AdvancedWindowMaxNumOfClientsPictureVar") and (MaxNumOfClientsUpDownVar = 1)
    {
        RotarySwitchAnimation("GameAdvancedWindow", "AdvancedWindowMaxNumOfClientsPictureVar", AdvancedWindowMaxNumOfClientsEditVar, "AdvancedWindowMaxNumOfClientsEditVar", 1, 1)
        MaxNumOfClientsUpDownVar := 0
    }
    else if (CurrentA_GuiControl = "GameAdvancedMapOptionsPageLVVar")                             ;Create multiple pages for the advanced map monitor(all of this work just because of a single scrollbar...)
    {
        gui GameAdvancedWindow:default
        gui, GameAdvancedWindow:ListView, GameAdvancedMapOptionsPageLVVar
        if (LV_GetNext() > 1)
        LV_Modify(LV_GetNext() - 1, "Select")
        else if (LV_GetNext() = 1)
        {
            if (GameAdvancedMapOptionsPage > 1)
            GameAdvancedMapOptionsPage--
            LV_Delete()
            gosub, ReadAdvancedSettingsFromINI
            gosub, GameAdvancedMapOptionsPageNextListOfOptions
            LV_Modify(12, "Select")
            GuiControl, GameAdvancedWindow:, GameAdvancedMapOptionsPageOptionsTextVar, Double - click to enable/disable an option            Page: %GameAdvancedMapOptionsPage%                                                        _
        }
    }
    else if (CurrentA_GuiControl = "GameAdvancedCustomCFGCommandsEditVar")
    {
        ControlFocus, Edit22, Advanced
        Send, {Up}
    }
    else if  (CurrentA_GuiControl = "AdvancedWindowInfoBoxEditVar")
    {
        ControlFocus, Edit23, Advanced
        Send, {Up}
    }
    SetTimer, UpdateAllUpDownValuesInINI, on
}
else if (WindowTitle = "Server hosts")
ControlSend, ListBox1, {up}, Server hosts
return

~WheelDown::
Gui, GameAdvancedWindow:submit, nohide
MouseGetPos,,, CurrentWinTitle, CurrentClassNN
WinGetTitle, WindowTitle, ahk_id %CurrentWinTitle%
if (WindowTitle = "License")
{
    ControlFocus, Edit1, License
    Send, {Down}
}
else if (WindowTitle = "Server Boss")
{
    if (CurrentA_GuiControl = "GameServerPasswordPictureButtonVar") and (ServerPasswordUpDownVar != 1)
    {
        RotarySwitchAnimation("MainWindow", "GameServerPasswordPictureButtonVar", GameMaxPlayersEditVar, "GameMaxPlayersEditVar", -1, 2)
        ServerPasswordUpDownVar := 1
    }
    else if (CurrentA_GuiControl = "GameServerPasswordPictureButtonVar") and (ServerPasswordUpDownVar = 1)
    {
        RotarySwitchAnimation("MainWindow", "GameServerPasswordPictureButtonVar", GameMaxPlayersEditVar, "GameMaxPlayersEditVar", -1, 1)
        ServerPasswordUpDownVar := 0
    }
    else if (CurrentA_GuiControl = "GameMapsListLBVar")
    ControlSend, ListBox1, {down}, Server Boss
    else if (CurrentA_GuiControl = "ConsoleEditVar")
    {
        ControlFocus, Edit5, Server Boss
        Send, {Down}
    }
        if (CurrentA_GuiControl = "ConsoleTextSizePictureVar") and (ConsoleTextSizeUpDownVar != 1)
    {
        IniRead, ConsoleSizeFromINI, %A_scriptdir%\Server Boss All\Settings.ini, MainWindow, ConsoleSize
        IniRead, ConsoleColorFromINI, %A_scriptdir%\Server Boss All\Settings.ini, MainWindow, ConsoleColor
        NewConsoleTextSize := ConsoleSizeFromINI - 1
        IniWrite, %NewConsoleTextSize%, %A_scriptdir%\Server Boss All\Settings.ini, MainWindow, ConsoleSize
        Gui, MainWindow:font, c%ConsoleColorFromINI% s%NewConsoleTextSize% bold, MS Gothic
        GuiControl, MainWindow:font, ConsoleEditVar
        GuiControl, MainWindow:+c%ConsoleColorFromINI%, ConsoleEditVar
        RotarySwitchAnimation("MainWindow", "ConsoleTextSizePictureVar", "", "", -1, 2)
        ConsoleTextSizeUpDownVar := 1
    }
    else if (CurrentA_GuiControl = "ConsoleTextSizePictureVar") and (ConsoleTextSizeUpDownVar = 1)
    {
        IniRead, ConsoleSizeFromINI, %A_scriptdir%\Server Boss All\Settings.ini, MainWindow, ConsoleSize
        IniRead, ConsoleColorFromINI, %A_scriptdir%\Server Boss All\Settings.ini, MainWindow, ConsoleColor
        NewConsoleTextSize := ConsoleSizeFromINI - 1
        IniWrite, %NewConsoleTextSize%, %A_scriptdir%\Server Boss All\Settings.ini, MainWindow, ConsoleSize
        Gui, MainWindow:font, c%ConsoleColorFromINI% s%NewConsoleTextSize% bold, MS Gothic
        GuiControl, MainWindow:font, ConsoleEditVar
        GuiControl, MainWindow:+c%ConsoleColorFromINI%, ConsoleEditVar
        RotarySwitchAnimation("MainWindow", "ConsoleTextSizePictureVar", "", "", -1, 1)
        ConsoleTextSizeUpDownVar := 0
    }
}
else if (WindowTitle = "Map cycle") and (CurrentA_GuiControl = "GameMapCycleWindowLBVar")
ControlSend, ListBox1, {down}, Map cycle
else if (WindowTitle = "Map cycle") and (CurrentA_GuiControl = "GameMapCycleListEditVar")
{
    ControlFocus, Edit2, Map cycle
    Send, {down}
}
else if (WindowTitle = "Filter maps") and (CurrentA_GuiControl = "GameFilterMapsLBVar")
ControlSend, ListBox1, {down}, Filter maps
else if (WindowTitle = "Advanced")
{
    if (CurrentA_GuiControl = "AdvancedWindowMaxRatePictureVar") and (MaxRateUpDownVar != 1)
    {
        RotarySwitchAnimation("GameAdvancedWindow", "AdvancedWindowMaxRatePictureVar", AdvancedWindowMaxRateEditVar, "AdvancedWindowMaxRateEditVar", -1, 2)
        MaxRateUpDownVar := 1
    }
    else if (CurrentA_GuiControl = "AdvancedWindowMaxRatePictureVar") and (MaxRateUpDownVar = 1)
    {
        RotarySwitchAnimation("GameAdvancedWindow", "AdvancedWindowMaxRatePictureVar", AdvancedWindowMaxRateEditVar, "AdvancedWindowMaxRateEditVar", -1, 1)
        MaxRateUpDownVar := 0
    }
    if (CurrentA_GuiControl = "AdvancedWindowMinRatePictureVar") and (MinRateUpDownVar != 1)
    {
        RotarySwitchAnimation("GameAdvancedWindow", "AdvancedWindowMinRatePictureVar", AdvancedWindowMinRateEditVar, "AdvancedWindowMinRateEditVar", -1, 2)
        MinRateUpDownVar := 1
    }
    else if (CurrentA_GuiControl = "AdvancedWindowMinRatePictureVar") and (MinRateUpDownVar = 1)
    {
        RotarySwitchAnimation("GameAdvancedWindow", "AdvancedWindowMinRatePictureVar", AdvancedWindowMinRateEditVar, "AdvancedWindowMinRateEditVar", -1, 1)
        MinRateUpDownVar := 0
    }
    if (CurrentA_GuiControl = "AdvancedWindowMaxUpdateRatePictureVar") and (MaxUpdateRateUpDownVar != 1)
    {
        RotarySwitchAnimation("GameAdvancedWindow", "AdvancedWindowMaxUpdateRatePictureVar", AdvancedWindowMaxUpdateRateEditVar, "AdvancedWindowMaxUpdateRateEditVar", -1, 2)
        MaxUpdateRateUpDownVar := 1
    }
    else if (CurrentA_GuiControl = "AdvancedWindowMaxUpdateRatePictureVar") and (MaxUpdateRateUpDownVar = 1)
    {
        RotarySwitchAnimation("GameAdvancedWindow", "AdvancedWindowMaxUpdateRatePictureVar", AdvancedWindowMaxUpdateRateEditVar, "AdvancedWindowMaxUpdateRateEditVar", -1, 1)
        MaxUpdateRateUpDownVar := 0
    }
    if (CurrentA_GuiControl = "AdvancedWindowMinUpdateRatePictureVar") and (MinUpdateRateUpDownVar != 1)
    {
        RotarySwitchAnimation("GameAdvancedWindow", "AdvancedWindowMinUpdateRatePictureVar", AdvancedWindowMinUpdateRateEditVar, "AdvancedWindowMinUpdateRateEditVar", -1, 2)
        MinUpdateRateUpDownVar := 1
    }
    else if (CurrentA_GuiControl = "AdvancedWindowMinUpdateRatePictureVar") and (MinUpdateRateUpDownVar = 1)
    {
        RotarySwitchAnimation("GameAdvancedWindow", "AdvancedWindowMinUpdateRatePictureVar", AdvancedWindowMinUpdateRateEditVar, "AdvancedWindowMinUpdateRateEditVar", -1, 1)
        MinUpdateRateUpDownVar := 0
    }
    if (CurrentA_GuiControl = "AdvancedWindowMaxCMDRatePictureVar") and (MaxCMDRateUpDownVar != 1)
    {
        RotarySwitchAnimation("GameAdvancedWindow", "AdvancedWindowMaxCMDRatePictureVar", AdvancedWindowMaxCMDRateEditVar, "AdvancedWindowMaxCMDRateEditVar", -1, 2)
        MaxCMDRateUpDownVar := 1
    }
    else if (CurrentA_GuiControl = "AdvancedWindowMaxCMDRatePictureVar") and (MaxCMDRateUpDownVar = 1)
    {
        RotarySwitchAnimation("GameAdvancedWindow", "AdvancedWindowMaxCMDRatePictureVar", AdvancedWindowMaxCMDRateEditVar, "AdvancedWindowMaxCMDRateEditVar", -1, 1)
        MaxCMDRateUpDownVar := 0
    }
    if (CurrentA_GuiControl = "AdvancedWindowMinCMDRatePictureVar") and (MinCMDRateUpDownVar != 1)
    {
        RotarySwitchAnimation("GameAdvancedWindow", "AdvancedWindowMinCMDRatePictureVar", AdvancedWindowMinCMDRateEditVar, "AdvancedWindowMinCMDRateEditVar", -1, 2)
        MinCMDRateUpDownVar := 1
    }
    else if (CurrentA_GuiControl = "AdvancedWindowMinCMDRatePictureVar") and (MinCMDRateUpDownVar = 1)
    {
        RotarySwitchAnimation("GameAdvancedWindow", "AdvancedWindowMinCMDRatePictureVar", AdvancedWindowMinCMDRateEditVar, "AdvancedWindowMinCMDRateEditVar", -1, 1)
        MinCMDRateUpDownVar := 0
    }
    if (CurrentA_GuiControl = "AdvancedWindowTimeoutPictureVar") and (TimeoutUpDownVar != 1)
    {
        RotarySwitchAnimation("GameAdvancedWindow", "AdvancedWindowTimeoutPictureVar", AdvancedWindowTimeoutEditVar, "AdvancedWindowTimeoutEditVar", -1, 2)
        TimeoutUpDownVar := 1
    }
    else if (CurrentA_GuiControl = "AdvancedWindowTimeoutPictureVar") and (TimeoutUpDownVar = 1)
    {
        RotarySwitchAnimation("GameAdvancedWindow", "AdvancedWindowTimeoutPictureVar", AdvancedWindowTimeoutEditVar, "AdvancedWindowTimeoutEditVar", -1, 1)
        TimeoutUpDownVar := 0
    }
    if (CurrentA_GuiControl = "AdvancedWindowMaxNumOfClientsPictureVar") and (MaxNumOfClientsUpDownVar != 1)
    {
        RotarySwitchAnimation("GameAdvancedWindow", "AdvancedWindowMaxNumOfClientsPictureVar", AdvancedWindowMaxNumOfClientsEditVar, "AdvancedWindowMaxNumOfClientsEditVar", -1, 2)
        MaxNumOfClientsUpDownVar := 1
    }
    else if (CurrentA_GuiControl = "AdvancedWindowMaxNumOfClientsPictureVar") and (MaxNumOfClientsUpDownVar = 1)
    {
        RotarySwitchAnimation("GameAdvancedWindow", "AdvancedWindowMaxNumOfClientsPictureVar", AdvancedWindowMaxNumOfClientsEditVar, "AdvancedWindowMaxNumOfClientsEditVar", -1, 1)
        MaxNumOfClientsUpDownVar := 0
    }
    else if (CurrentA_GuiControl = "GameAdvancedMapOptionsPageLVVar")
    {
        gui GameAdvancedWindow:default
        gui, GameAdvancedWindow:ListView, GameAdvancedMapOptionsPageLVVar
        if (LV_GetNext() < LV_GetCount())
        LV_Modify(LV_GetNext() + 1, "Select")
        else if (LV_GetNext() = LV_GetCount())
        {
            if (GameAdvancedMapOptionsPage < 4)
            GameAdvancedMapOptionsPage++
            LV_Delete()
            gosub, ReadAdvancedSettingsFromINI
            gosub, GameAdvancedMapOptionsPageNextListOfOptions
            LV_Modify(1, "Select")
            GuiControl, GameAdvancedWindow:, GameAdvancedMapOptionsPageOptionsTextVar, Double - click to enable/disable an option            Page: %GameAdvancedMapOptionsPage%                                                        _
        }
    }
    else if (CurrentA_GuiControl = "GameAdvancedCustomCFGCommandsEditVar")
    {
        ControlFocus, Edit22, Advanced
        Send, {Down}
    }
    else if  (CurrentA_GuiControl = "AdvancedWindowInfoBoxEditVar")
    {
        ControlFocus, Edit23, Advanced
        Send, {Down}
    }
    SetTimer, UpdateAllUpDownValuesInINI, on
}
else if (WindowTitle = "Server hosts")
ControlSend, ListBox1, {down}, Server hosts
return

;Saving a single/all variables inside .ini file after/inside RotarySwitchAnimation() function will result in falty values. Settimer fixes the issue. The timer is set to 1 second.
;Using OnExit() will require to change the code for all custom toggle buttons that emulate a checkbox
UpdateAllUpDownValuesInINI:
Gui, GameAdvancedWindow:submit, nohide
IniWrite, %AdvancedWindowMaxRateEditVar%, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, MaxRate
IniWrite, %AdvancedWindowMinRateEditVar%, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, MinRate
IniWrite, %AdvancedWindowMaxUpdateRateEditVar%, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, MaxUpdateRate
IniWrite, %AdvancedWindowMinUpdateRateEditVar%, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, MinUpdateRate
IniWrite, %AdvancedWindowMaxCMDRateEditVar%, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, MaxCMDRate
IniWrite, %AdvancedWindowMinCMDRateEditVar%, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, MinCMDRate
IniWrite, %AdvancedWindowTimeoutEditVar%, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, Timeout
IniWrite, %AdvancedWindowMaxNumOfClientsEditVar%, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, MaxNumOfClients
SetTimer, UpdateAllUpDownValuesInINI, off
return

RotarySwitchAnimation(GuiName, RotarySwitchControlVar, RotarySwitchEditControlValue, RotarySwitchEditControlVar, PlusMinus, ImageState) {
    IniRead, SwitchStateFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, %INIKey%SwitchState
    (SwitchStateFromINI = "1") ? (ChangedSwitchState := "2") : (ChangedSwitchState := "1")
    IniWrite, %ChangedSwitchState%, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, %INIKey%SwitchState
    GuiControl, %GuiName%:, %RotarySwitchControlVar%, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Rotary_switch_state_%ImageState%_pic_button.png
    if (PlusMinus = 1)
    {
        FillEditBoxIfEmpty := 1
        OneUpDownValue := RotarySwitchEditControlValue + 1
    }
    else
    {
        FillEditBoxIfEmpty := -1
        OneUpDownValue := RotarySwitchEditControlValue - 1
    }
    if (RotarySwitchEditControlValue != "")
    GuiControl, %GuiName%:, %RotarySwitchEditControlVar%, % OneUpDownValue
    else
    GuiControl, %GuiName%:, %RotarySwitchEditControlVar%, % FillEditBoxIfEmpty
}


;Give the user info about specific control
;----------------------------------------------------------------------------------------------
~MButton::
gui, GameAdvancedWindow:Submit, nohide
MouseGetPos,,, CurrentWinTitle, CurrentClassNN
WinGetTitle, WindowTitle, ahk_id %CurrentWinTitle%
if (WindowTitle = "Advanced")
{
    switch CurrentA_GuiControl
    {
        case "AdvancedWindowAllowDownloadPictureButtonVar":
        AdvancedInformationWindowText := "Command line:`nsv_allowdownload <0/1>`n`nUsage: sv_allowdownload 1`n`nDefault value: 1`n`nDescription:`nEnable clients to download custom files`n`nDev: `nThis is a picture control that emulates a checkbox. When pressed It toggles a value of 0/1 inside Server Boss All\Settings.ini file.`n`nThe control requires two images in order to function properly.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := "AllowDownload"
        case "AdvancedWindowAllowUploadPictureButtonVar":
        AdvancedInformationWindowText := "Command line:`nsv_allowupload <0/1>`n`nUsage: sv_allowupload 1`n`nDefault value: 1`n`nDescription:`nEnable clients to upload custom files`n`nDev: `nThis is a picture control that emulates a checkbox. When pressed It toggles a value of 0/1 inside Server Boss All\Settings.ini file.`n`nThe control requires two images in order to function properly.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := "AllowUpload"
        case "AdvancedWindowHideServerPictureButtonVar":
        AdvancedInformationWindowText := "Command line:`nhide_server <0/1>`n`nUsage: hide_server 0`n`nDefault value: 0`n`nDescription:`nHide the server from the server browser`n`nDev:`nThis is a picture control that emulates a checkbox. When pressed It toggles a value of 0/1 inside Server Boss All\Settings.ini file.`n`nThe control requires two images in order to function properly.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := "HideServer"
        case "AdvancedWindowDisableVACPictureButtonVar":
        AdvancedInformationWindowText := "Launch option:`n-insecure`n`nUsage: -insecure`n`nDescription:`nDisable V.A.C`n`nDev:`nThis is a picture control that emulates a checkbox. When pressed It toggles a value of 0/1 inside Server Boss All\Settings.ini file.`n`nThe control requires two images in order to function properly.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := "Insecure"
        case "AdvancedWindowEnableAllTalkPictureButtonVar":
        AdvancedInformationWindowText := "Command line:`nsv_alltalk <0/1>`n`nUsage: sv_alltalk 1`n`nDefault value: 0`n`nDescription:`nAllow players to hear all other players on both teams.`n`nDev:`nThis is a picture control that emulates a checkbox. When pressed It toggles a value of 0/1 inside Server Boss All\Settings.ini file.`n`nThe control requires two images in order to function properly.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := "HideServer"
        case "AdvancedWindowEnableCheatsPictureButtonVar":
        AdvancedInformationWindowText := "Command line:`nsv_cheats <0/1>`n`nUsage: sv_cheats 0`n`nDefault value: 0`n`nDescription:`nAllow cheats on the server.`n`nDev:`nThis is a picture control that emulates a checkbox. When pressed It toggles a value of 0/1 inside Server Boss All\Settings.ini file.`n`nThe control requires two images in order to function properly.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := "HideServer"
        case "AdvancedWindowEmptyToggle1PictureButtonVar":
        AdvancedInformationWindowText := "N/A`n`nDev:`nThis is a picture control that emulates a checkbox. When pressed It toggles a value of 0/1 inside Server Boss All\Settings.ini file.`n`nThe control requires two images in order to function properly.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowEmptyToggle2PictureButtonVar", "AdvancedWindowEmptyToggle3PictureButtonVar", "AdvancedWindowEmptyToggle4PictureButtonVar", "AdvancedWindowEmptyToggle5PictureButtonVar", "AdvancedWindowEmptyToggle6PictureButtonVar":
        AdvancedInformationWindowText := "N/A`n`nDev:`nThis is a picture control that emulates a checkbox. When pressed It toggles a value of 0/1 inside Server Boss All\Settings.ini file.`n`nThe control requires two images in order to function properly.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowServerTogglesInfoLVVar":
        AdvancedInformationWindowText := "N/A`n`nDev:`nThis is just a listview control used to show information about the current toggle button under the mouse cursor.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowServerTagsTextVar":
        AdvancedInformationWindowText := "Command line:`nsv_tags <string>`n`nUsage: sv_tags NoCrits, AllTalk, 24/7, no_bots`n`nDefault value: `n`nDescription:`nAllows server hosts to add custom tags. These tags are only visible on the server browser.`n`nNote: separate tags with a comma. Use _ for spaces.`n`nDev:`nThis is a text control. It doesn't do anything.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowServerTokenTextVar":
        AdvancedInformationWindowText := "Command line:`nsv_setsteamaccount <string>`n`nUsage: sv_setsteamaccount`n`nDefault value: `n`nDescription:`nAllows players to favourite or blacklist a server. `nServer tokens can be obtained from https://steamcommunity.com/dev/managegameservers. Use one of the yellow buttons below for direct link to the website. ID for TF2 is 440.`n`nNote: S.D.R is not supported!`n`nDev:`nThis is a text control. It doesn't do anything.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowFastDLURLTextVar":
        AdvancedInformationWindowText := "Command line:`nsv_downloadurl <string>`n`nUsage: sv_downloadurl http://MyWebsite/CustomGameContents/`n`nDefault value: `n`nDescription:`nAllows clients to download custom contents like maps, models, sounds etc. This removes the download limit of 10KB/s and max upload of 64MB set by Net_maxfilesize(default value is 16MB).`nHosting a server can be achived by using one of the following programs: XAMPP/Apache/nginx/WampServer/Windows IIS. Templates are not available.`n`nNote: sv_allowdownload and sv_allowupload must be set to 1`n`nDev:`nThis is a text control. It doesn't do anything.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowRconPasswordTextVar":
        AdvancedInformationWindowText := "Command line:`nrcon_password <string>`n`nUsage: rcon_password My551Password999`n`nDefault value: `n`nDescription:`nSets a password for remote console allowing. This allows server owners to control their server directly from TF2.`n`nNote: Servers that use S.D.R are not supported!`n`nDev:`nThis is a text control. It doesn't do anything.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowIDForTF2Text":
        AdvancedInformationWindowText := "N/A`n`nDev:`nThis is a text control placed on top of a progress bar. To create it, use a progress bar with the same color for both the background and progress line, then overlay a text control with the BackgroundTrans option enabled. Make sure to add the option 'disabled' on the progress bar or it may cause some issues later.`n`nExample: gui, add, progress, w265 h235 disabled Background573227 c573227, 100`ngui, add, text, xp+15 yp+10 w235 h215 BackgroundTrans, My text`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowSVPurePictureVar":
        AdvancedInformationWindowText := "Button usage: click on any nearby text control to change the current option.`n`nDev:`nThis is a picture control that emulates a multiple radio buttons. The image by itself doesn't do anything.`n`nThe control requires ten images in order to function properly.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowSVPureMinus1TextVar":
        AdvancedInformationWindowText := "Command line:`nsv_pure <-1/0/1/2>`n`nUsage: sv_pure -1`n`nDefault value: `n`nDescription:`nDon't force custom content restriction on clients.`n`n[✓]Custom weapon models`n[✓]Custom huds`n[✓]Custom textures`n[✓]Custom sounds`n[✓]Custom particles`n`nDev:`nThis is a text control. It changes the image of the rotary switch closest to this control.`n`nThe control requires two images in order to function properly.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := "Insecure"
        case "AdvancedWindowSVPure0TextVar":
        AdvancedInformationWindowText := "Command line:`nsv_pure <-1/0/1/2>`n`nUsage: sv_pure 0`n`nDefault value: `n`nDescription:`nDon't force custom content restriction on clients. Same as sv_consistency 1/sv_pure -1.`n`n[✓]Custom weapon models`n[✓]Custom huds`n[✓]Custom textures`n[✓]Custom sounds`n[✓]Custom particles`n`nDev:`nThis is a text control. It changes the image of the rotary switch closest to this control.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := "Insecure"
        case "AdvancedWindowSVPure1TextVar":
        AdvancedInformationWindowText := "Command line:`nsv_pure <-1/0/1/2>`n`nUsage: sv_pure 1`n`nDefault value: `n`nDescription: Allow only custom content for clients set by pure_server_whitelist.txt(can be found in tf\cfg) folder.`n`n[?]Custom weapon models`n[?]Custom huds`n[?]Custom textures`n[?]Custom sounds`n[?]Custom particles`n`nDev:`nThis is a text control. It changes the image of the rotary switch closest to this control.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := "Insecure"
        case "AdvancedWindowSVPure2TextVar":
        AdvancedInformationWindowText := "Command line:`nsv_pure <-1/0/1/2>`n`nUsage: sv_pure 2`n`nDefault value: `n`nDescription: Block all custom content for clients except for huds.`n`n[X]Custom weapon models`n[✓]Custom huds`n[X]Custom textures`n[X]Custom sounds`n[X]Custom particles. `n`nCommonly used by official valve servers.`n`nDev:`nThis is a text control. It changes the image of the rotary switch closest to this control.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowServerTagsEditVar":
        AdvancedInformationWindowText := "Command line:`nsv_tags <string>`n`nUsage: sv_tags NoCrits, AllTalk, 24/7, no_bots`n`nDefault value: `n`nDescription:`nAllows server hosts to add custom tags. These tags are only visible on the server browser.`n`nNote: separate tags with a comma. Use _ for spaces.`n`nDev:`nThis is an edit control that stores its value in Server Boss All\Settings.ini whenever the user types a new keystroke. When the server is launched, it retrieves this value and writes it to a newly generated .cfg file located in the server host directory. The .cfg file will have the same name as the server.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowServerTokenEditVar":
        AdvancedInformationWindowText := "Command line:`nsv_setsteamaccount <string>`n`nUsage: sv_setsteamaccount`n`nDefault value: `n`nDescription:`nAllows players to favourite or blacklist a server. `nServer tokens can be obtained from https://steamcommunity.com/dev/managegameservers. Use one of the yellow buttons below for direct link to the website. ID for TF2 is 440.`n`nNote: S.D.R is not supported!`n`nDev:`nThis is an edit control that stores its value in Server Boss All\Settings.ini whenever the user types a new keystroke. When the server is launched, it retrieves this value and writes it to a newly generated .cfg file located in the server host directory. The .cfg file will have the same name as the server.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowFastDLURLEditVar":
        AdvancedInformationWindowText := "Command line:`nsv_downloadurl <string>`n`nUsage: sv_downloadurl http://MyWebsite/CustomGameContents/`n`nDefault value: `n`nDescription:`nAllows clients to download custom contents like maps, models, sounds etc. This removes the download limit of 10KB/s and max upload of 64MB set by Net_maxfilesize(default value is 16MB).`nHosting a server can be achived by using one of the following programs: XAMPP/Apache/nginx/WampServer/Windows IIS. Templates are not available.`n`nNote: sv_allowdownload and sv_allowupload must be set to 1`n`nDev:`nThis is an edit control that stores its value in Server Boss All\Settings.ini whenever the user types a new keystroke. When the server is launched, it retrieves this value and writes it to a newly generated .cfg file located in the server host directory. The .cfg file will have the same name as the server.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowRconPasswordEditVar":
        AdvancedInformationWindowText := "Command line:`nrcon_password <string>`n`nUsage: rcon_password My551Password999`n`nDefault value: `n`nDescription:`nSets a password for remote console allowing. This allows server owners to control their server directly from TF2.`n`nNote: Servers that use S.D.R are not supported!`n`nDev:`nThis is an edit control that stores its value in Server Boss All\Settings.ini whenever the user types a new keystroke. When the server is launched, it retrieves this value and writes it to a newly generated .cfg file located in the server host directory. The .cfg file will have the same name as the server.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowGenerateRconPasswordTextVar":
AdvancedInformationWindowText := "Button usage:`nPress the button to generate random rcon password.`n`nDev:`nThis is a text control placed on top of a progress bar. Chr(0x2699) emoji is used for the text.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowIDForTF2TextVar":
        AdvancedInformationWindowText := "N/A`n`nDev:`nThis is a text control placed on top of a progress bar. It doesn't do anything.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowServerTypePictureVar":
        AdvancedInformationWindowText := "N/A`n`nDev:`nThis is a picture control that emulates a multiple radio buttons. The image by itself doesn't do anything.`n`nThe control requires ten images in order to function properly.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowServerTypeSDRTextVar":
        AdvancedInformationWindowText := "Launch option:`n-enablefakeip`n`nUsage: -enablefakeip`n`nCommand line:`nsv_lan <0/1>`n`nUsage: sv_lan 0`n`nDefault value: 0`n`nDescription: Hosts a server using S.D.R(Steam data relay). Removes the need for port forwarding a server, hides the host/clients real ip's and protects against DDoS attacks.`n`nNote: rcon for S.D.R is not supported.`nClients can't favourite/blacklist servers using S.D.R`n`nDev:`nThis is a text control. It changes the image of the rotary switch closest to this control.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowServerTypePublicTextVar":
        AdvancedInformationWindowText := "Command line:`nsv_lan <0/1>`n`nUsage: sv_lan 0`n`nDefault value: 0`n`nDescription:`nSets the server to be public.`n`nNote: requires the server to be port forwarded.`n`nDev:`nThis is a text control. It changes the image of the rotary switch closest to this control.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowServerTypeLocalTextVar":
        AdvancedInformationWindowText := "Command line:`nsv_lan <0/1>`n`nUsage: sv_lan 1`n`nDefault value: 0`n`nDescription:`nSets a local server(only people connected to the same network/router can join).`n`nDev:`nThis is a text control. It changes the image of the rotary switch closest to this control.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowRegionPictureVar", "AdvancedWindowServerTypePictureVar":
        AdvancedInformationWindowText := "N/A`n`nDev:`nThis is a picture control that emulates a multiple radio buttons. The image by itself doesn't do anything.`n`nThe control requires ten images in order to function properly.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowRegionWorldTextVar":
        AdvancedInformationWindowText := "Command line:`nsv_region <0/1/2/3/4/5/6/7/255>`n`nUsage:`nsv_region 255`n`nDefault value: 255`n`nDescription:`nReports the server location as the world on the server browser.`n`nDev:`nThis is a text control. It changes the image of the rotary switch closest to this control.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowRegionUSEastTextVar":
        AdvancedInformationWindowText := "Command line:`nsv_region <0/1/2/3/4/5/6/7/255>`n`nUsage:`nsv_region 0`n`nDefault value: 255`n`nDescription:`nReports the server location as US - East on the server browser.`n`nDev:`nThis is a text control. It changes the image of the rotary switch closest to this control.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowRegionUSWestTextVar":
        AdvancedInformationWindowText := "Command line:`nsv_region <0/1/2/3/4/5/6/7/255>`n`nUsage:`nsv_region 1`n`nDefault value: 255`n`nDescription:`nReports the server location as US - West on the server browser.`n`nDev:`nThis is a text control. It changes the image of the rotary switch closest to this control.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowRegionSouthAmericaTextVar":
        AdvancedInformationWindowText := "Command line:`nsv_region <0/1/2/3/4/5/6/7/255>`n`nUsage:`nsv_region 2`n`nDefault value: 255`n`nDescription:`nReports the server location as South America on the server browser.`n`nDev:`nThis is a text control. It changes the image of the rotary switch closest to this control.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowRegionEuropeTextVar":
        AdvancedInformationWindowText := "Command line:`nsv_region <0/1/2/3/4/5/6/7/255>`n`nUsage:`nsv_region 3`n`nDefault value: 255`n`nDescription:`nReports the server location as Europe on the server browser.`n`nDev:`nThis is a text control. It changes the image of the rotary switch closest to this control.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowRegionAsiaTextVar":
        AdvancedInformationWindowText := "Command line:`nsv_region <0/1/2/3/4/5/6/7/255>`n`nUsage:`nsv_region 4`n`nDefault value: 255`n`nDescription:`nReports the server location as Asia on the server browser.`n`nDev:`nThis is a text control. It changes the image of the rotary switch closest to this control.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowRegionAustraliaTextVar":
        AdvancedInformationWindowText := "Command line:`nsv_region <0/1/2/3/4/5/6/7/255>`n`nUsage:`nsv_region 5`n`nDefault value: 255`n`nDescription:`nReports the server location as Australia on the server browser.`n`nDev:`nThis is a text control. It changes the image of the rotary switch closest to this control.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowRegionMiddleEastTextVar":
        AdvancedInformationWindowText := "Command line:`nsv_region <0/1/2/3/4/5/6/7/255>`n`nUsage:`nsv_region 6`n`nDefault value: 255`n`nDescription:`nReports the server location as Middle East on the server browser.`n`nDev:`nThis is a text control. It changes the image of the rotary switch closest to this control.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowRegionAfricaTextVar":
        AdvancedInformationWindowText := "Command line:`nsv_region <0/1/2/3/4/5/6/7/255>`n`nUsage:`nsv_region 7`n`nDefault value: 255`n`nDescription:`nReports the server location as Africa on the server browser.`n`nDev:`nThis is a text control. It changes the image of the rotary switch closest to this control.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowMaxRatePictureVar":
        AdvancedInformationWindowText := "Button usage:`nUse your mouse scroll wheel to change the value below.`n`nDev:`nThis is a picture that emulates an updown control. This control toggles between two images using the scroll wheel. It also changes the value of the edit box closest to it. WheelUp:: and WheelDown:: hotkeys obtain the ClassNN of the control below the mouse cursor when called. If it matches, it updates the nearby picture control and uses GuiControl to change the value of the edit box below.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowMaxRateEditVar":
        AdvancedInformationWindowText := "Command line:`nsv_maxrate <integer>`n`nUsage:`nsv_maxrate 0`n`nDefault value: 0`n`nDescription:`nChanges the maximum bandwidth rate allowed on a server. 0 is unlimited.`n`nDev:`nThis is an edit control that stores its value in Server Boss All\Settings.ini whenever the user types a new keystroke. When the server is launched, it retrieves this value and writes it to a newly generated .cfg file located in the server host directory. The .cfg file will have the same name as the server.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowMinRatePictureVar":
        AdvancedInformationWindowText := "Button usage:`nUse your mouse scroll wheel to change the value below.`n`nDev:`nThis is a picture that emulates an updown control. This control toggles between two images using the scroll wheel. It also changes the value of the edit box closest to it. WheelUp:: and WheelDown:: hotkeys obtain the ClassNN of the control below the mouse cursor when called. If it matches, it updates the nearby picture control and uses GuiControl to change the value of the edit box below.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowMinRateEditVar":
        AdvancedInformationWindowText := "Command line:`nsv_minrate <integer>`n`nUsage:`nsv_minrate 0`n`nDefault value: 3500`n`nDescription:`nChanges the maximum bandwidth rate allowed on a server. 0 is unlimited.`n`nDev:`nThis is an edit control that stores its value in Server Boss All\Settings.ini whenever the user types a new keystroke. When the server is launched, it retrieves this value and writes it to a newly generated .cfg file located in the server host directory. The .cfg file will have the same name as the server.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowMaxUpdateRatePictureVar":
        AdvancedInformationWindowText := "Button usage:`nUse your mouse scroll wheel to change the value below.`n`nDev:`nThis is a picture that emulates an updown control. This control toggles between two images using the scroll wheel. It also changes the value of the edit box closest to it. WheelUp:: and WheelDown:: hotkeys obtain the ClassNN of the control below the mouse cursor when called. If it matches, it updates the nearby picture control and uses GuiControl to change the value of the edit box below.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowMaxUpdateRateEditVar":
        AdvancedInformationWindowText := "Command line:`nsv_maxupdaterate <integer>`n`nUsage:`nsv_maxupdaterate 0`n`nDefault value: 66`n`nDescription:`nChanges the maximum update rate allowed on a server. 0 is unlimited.`n`nDev:`nThis is an edit control that stores its value in Server Boss All\Settings.ini whenever the user types a new keystroke. When the server is launched, it retrieves this value and writes it to a newly generated .cfg file located in the server host directory. The .cfg file will have the same name as the server.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowMinUpdateRatePictureVar":
        AdvancedInformationWindowText := "Button usage:`nUse your mouse scroll wheel to change the value below.`n`nDev:`nThis is a picture that emulates an updown control. This control toggles between two images using the scroll wheel. It also changes the value of the edit box closest to it. WheelUp:: and WheelDown:: hotkeys obtain the ClassNN of the control below the mouse cursor when called. If it matches, it updates the nearby picture control and uses GuiControl to change the value of the edit box below.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowMinUpdateRateEditVar":
        AdvancedInformationWindowText := "Command line:`nsv_minupdaterate <integer>`n`nUsage:`nsv_minupdaterate 0`n`nDefault value: 10`n`nDescription:`nChanges the minimum update rate allowed on a server. 0 is unlimited.`n`nDev:`nThis is an edit control that stores its value in Server Boss All\Settings.ini whenever the user types a new keystroke. When the server is launched, it retrieves this value and writes it to a newly generated .cfg file located in the server host directory. The .cfg file will have the same name as the server.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowMaxCMDRatePictureVar":
        AdvancedInformationWindowText := "Button usage:`nUse your mouse scroll wheel to change the value below.`n`nDev:`nThis is a picture that emulates an updown control. This control toggles between two images using the scroll wheel. It also changes the value of the edit box closest to it. WheelUp:: and WheelDown:: hotkeys obtain the ClassNN of the control below the mouse cursor when called. If it matches, it updates the nearby picture control and uses GuiControl to change the value of the edit box below.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowMaxCMDRateEditVar":
        AdvancedInformationWindowText := "Command line:`nsv_maxcmdrate <integer>`n`nUsage:`nsv_maxcmdrate 0`n`nDefault value: 66`n`nDescription:`nChanges the maximum value allowed for cl_cmdrate.`n`nDev:`nThis is an edit control that stores its value in Server Boss All\Settings.ini whenever the user types a new keystroke. When the server is launched, it retrieves this value and writes it to a newly generated .cfg file located in the server host directory. The .cfg file will have the same name as the server.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowMinCMDRatePictureVar":
        AdvancedInformationWindowText := "Button usage:`nUse your mouse scroll wheel to change the value below.`n`nDev:`nThis is a picture that emulates an updown control. This control toggles between two images using the scroll wheel. It also changes the value of the edit box closest to it. WheelUp:: and WheelDown:: hotkeys obtain the ClassNN of the control below the mouse cursor when called. If it matches, it updates the nearby picture control and uses GuiControl to change the value of the edit box below.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowMinCMDRateEditVar":
        AdvancedInformationWindowText := "Command line:`nsv_mincmdrate <integer>`n`nUsage:`nsv_mincmdrate 0`n`nDefault value: 10`n`nDescription:`nChanges the minimum value allowed for cl_cmdrate.`n`nDev:`nThis is an edit control that stores its value in Server Boss All\Settings.ini whenever the user types a new keystroke. When the server is launched, it retrieves this value and writes it to a newly generated .cfg file located in the server host directory. The .cfg file will have the same name as the server.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowCustomAddressEditVar":
        AdvancedInformationWindowText := "Command line:`nip <string>`n`nUsage:`nip 192.168.11.11(this is a random ip)`n`nDefault value: `n`nDescription:`nSets a specific ip when multiple network cards are installed.`n`nDev:`nThis is an edit control that stores its value in Server Boss All\Settings.ini whenever the user types a new keystroke. When the server is launched, it retrieves this value and writes it to a newly generated .cfg file located in the server host directory. The .cfg file will have the same name as the server.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowUDPPortEditVar":
        AdvancedInformationWindowText := "Launch option:`n-port <integer>`n`nUsage: -port 27015`n`nDescription:`nSets a specific port(27015 is set by default)`n`nDev:`nThis is an edit control that stores its value in Server Boss All\Settings.ini whenever the user types a new keystroke. When the server is launched, it retrieves this value and writes it to a newly generated .cfg file located in the server host directory. The .cfg file will have the same name as the server.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowEnableSourceTvPictureButtonVar":
        AdvancedInformationWindowText := "Command line:`ntv_enable <0/1>`n`nUsage: tv_enable 1`n`nDefault value:0`n`nDescription:`nEnable SourceTv on the server. This allows clients to spectate the game. It can also be used by server owners to record demo files.`n`nDev: `nThis is a picture control that emulates a checkbox. When pressed It toggles a value of 0/1 inside Server Boss All\Settings.ini file.`n`nThe control requires two images in order to function properly.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowUsePlayersAsCameraPictureButtonVar":
        AdvancedInformationWindowText := "Command line:`ntv_allow_camera_man <0/1>`n`nUsage: tv_allow_camera_man 1`n`nDefault value:1`n`nDescription:`nUses spectators as a camera.`n`nDev: `nThis is a picture control that emulates a checkbox. When pressed It toggles a value of 0/1 inside Server Boss All\Settings.ini file.`n`nThe control requires two images in order to function properly.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowPlayVoicePictureButtonVar":
        AdvancedInformationWindowText := "Command line:`ntv_relayvoice <0/1>`n`nUsage: tv_relayvoice 1`n`nDefault value:1`n`nDescription:`nIt allows player voice chat to be broadcasted.`n`nDev: `nThis is a picture control that emulates a checkbox. When pressed It toggles a value of 0/1 inside Server Boss All\Settings.ini file.`n`nThe control requires two images in order to function properly.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowAutoRecordAllGamesPictureButtonVar":
        AdvancedInformationWindowText := "Command line:`ntv_autorecord <0/1>`n`nUsage: tv_autorecord 0`n`nDefault value:0`n`nDescription:`nAutomatically record a server demo at the end of the game.`n`nDev: `nThis is a picture control that emulates a checkbox. When pressed It toggles a value of 0/1 inside Server Boss All\Settings.ini file.`n`nThe control requires two images in order to function properly.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowTransmitAllEntitiesPictureButtonVar":
        AdvancedInformationWindowText := "Command line:`ntv_transmitall <0/1>`n`nUsage: tv_transmitall 1`n`nDefault value:0`n`nDescription:`nShow all entities.`n`nDev: `nThis is a picture control that emulates a checkbox. When pressed It toggles a value of 0/1 inside Server Boss All\Settings.ini file.`n`nThe control requires two images in order to function properly.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowDelayMapChangePictureButtonVar":
        AdvancedInformationWindowText := "Command line:`ntv_delaymapchange <0/1>`n`nUsage: tv_delaymapchange 0`n`nDefault value:0`n`nDescription:`nPrevents the server from changing maps until the broadcast is completed.`n`nDev: `nThis is a picture control that emulates a checkbox. When pressed It toggles a value of 0/1 inside Server Boss All\Settings.ini file.`n`nThe control requires two images in order to function properly.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowEmptyToggle7PictureButtonVar":
        AdvancedInformationWindowText := "N/A`n`nDev:`nThis is a picture control that emulates a checkbox. When pressed It toggles a value of 0/1 inside Server Boss All\Settings.ini file.`n`nThe control requires two images in order to function properly.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowEmptyToggle8PictureButtonVar":
        AdvancedInformationWindowText := "N/A`n`nDev:`nThis is a picture control that emulates a checkbox. When pressed It toggles a value of 0/1 inside Server Boss All\Settings.ini file.`n`nThe control requires two images in order to function properly.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowEmptyToggle9PictureButtonVar":
        AdvancedInformationWindowText := "N/A`n`nDev:`nThis is a picture control that emulates a checkbox. When pressed It toggles a value of 0/1 inside Server Boss All\Settings.ini file.`n`nThe control requires two images in order to function properly.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowEmptyToggle10PictureButtonVar":
        AdvancedInformationWindowText := "N/A`n`nDev:`nThis is a picture control that emulates a checkbox. When pressed It toggles a value of 0/1 inside Server Boss All\Settings.ini file.`n`nThe control requires two images in order to function properly.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowEmptyToggle11PictureButtonVar":
        AdvancedInformationWindowText := "N/A`n`nDev:`nThis is a picture control that emulates a checkbox. When pressed It toggles a value of 0/1 inside Server Boss All\Settings.ini file.`n`nThe control requires two images in order to function properly.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowEmptyToggle12PictureButtonVar":
        AdvancedInformationWindowText := "N/A`n`nDev:`nThis is a picture control that emulates a checkbox. When pressed It toggles a value of 0/1 inside Server Boss All\Settings.ini file.`n`nThe control requires two images in order to function properly.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowEmptyToggle13PictureButtonVar":
        AdvancedInformationWindowText := "N/A`n`nDev:`nThis is a picture control that emulates a checkbox. When pressed It toggles a value of 0/1 inside Server Boss All\Settings.ini file.`n`nThe control requires two images in order to function properly.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowEmptyToggle14PictureButtonVar":
        AdvancedInformationWindowText := "N/A`n`nDev:`nThis is a picture control that emulates a checkbox. When pressed It toggles a value of 0/1 inside Server Boss All\Settings.ini file.`n`nThe control requires two images in order to function properly.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowSTVTogglesInfoLVVar":
        AdvancedInformationWindowText := "N/A`n`nDev:`nThis is just a listview control used to show information about the current toggle button under the mouse cursor.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowSTVNameTextVar":
        AdvancedInformationWindowText := "Command line:`ntv_name <string>`n`nUsage: tv_name Camera`n`nDefault value: `n`nDescription:`nChanges the name of the SourceTV host. Can be seen on the game scoreboard.`n`nDev:`nThis is a text control. It doesn't do anything.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowSTVPasswordTextVar":
        AdvancedInformationWindowText := "Command line:`ntv_password <string>`n`nUsage: tv_password password`n`nDefault value: `n`nDescription:`nChanges the SourceTv password.`n`nDev:`nThis is a text control. It doesn't do anything.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowSTVSnapShotRateTextVar":
        AdvancedInformationWindowText := "Command line:`ntv_snapshotrate <integer>`n`nUsage: tv_snapshotrate 16`n`nDefault value: 16`n`nDescription:`nChanges the snapshots broadcasted per second.`n`nDev:`nThis is a text control. It doesn't do anything.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowSTVDelayTextVar":
        AdvancedInformationWindowText := "Command line:`ntv_delay <integer>`n`nUsage: tv_delay 0`n`nDefault value: 30`n`nDescription:`nDelays the SourceTv broadcast(in seconds).`n`nDev:`nThis is a text control. It doesn't do anything.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowSTVPortTextVar":
        AdvancedInformationWindowText := "Command line:`ntv_port <integer>`n`nUsage: tv_port 27020`n`nDefault value: 27020`n`nDescription:`nChanges the SourceTv port.`n`nDev:`nThis is a text control. It doesn't do anything.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowSTVNameEditVar":
        AdvancedInformationWindowText :=  "Command line:`ntv_name <string>`n`nUsage: tv_name Camera`n`nDefault value: `n`nDescription:`nChanges the name of the SourceTV host. Can be seen on the game scoreboard.`n`nDev:`nThis is an edit control that stores its value in Server Boss All\Settings.ini whenever the user types a new keystroke. When the server is launched, it retrieves this value and writes it to a newly generated .cfg file located in the server host directory. The .cfg file will have the same name as the server.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowSTVPasswordEditVar":
        AdvancedInformationWindowText :=  "Command line:`ntv_password <string>`n`nUsage: tv_password password`n`nDefault value: `n`nDescription:`nChanges the SourceTv password.`n`nDev:`nThis is an edit control that stores its value in Server Boss All\Settings.ini whenever the user types a new keystroke. When the server is launched, it retrieves this value and writes it to a newly generated .cfg file located in the server host directory. The .cfg file will have the same name as the server.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowGenerateSTVPasswordTextVar":
AdvancedInformationWindowText := "Button usage:`nPress the button to generate random stv password.`n`nDev:`nThis is a text control placed on top of a progress bar. Chr(0x2699) emoji is used for the text.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowSTVSnapShotRateEditVar":
        AdvancedInformationWindowText :=  "Command line:`ntv_snapshotrate <integer>`n`nUsage: tv_snapshotrate 16`n`nDefault value: 16`n`nDescription:`nChanges the snapshots broadcasted per second.`n`nDev:`nThis is an edit control that stores its value in Server Boss All\Settings.ini whenever the user types a new keystroke. When the server is launched, it retrieves this value and writes it to a newly generated .cfg file located in the server host directory. The .cfg file will have the same name as the server.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowSTVDelayEditVar":
        AdvancedInformationWindowText :=  "Command line:`ntv_delay <integer>`n`nUsage: tv_delay 0`n`nDefault value: 30`n`nDescription:`nDelays the SourceTv broadcast(in seconds).`n`nDev:`nThis is an edit control that stores its value in Server Boss All\Settings.ini whenever the user types a new keystroke. When the server is launched, it retrieves this value and writes it to a newly generated .cfg file located in the server host directory. The .cfg file will have the same name as the server.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowSTVPortEditVar":
        AdvancedInformationWindowText :=  "Command line:`ntv_port <integer>`n`nUsage: tv_port 27020`n`nDefault value: 27020`n`nDescription:`nChanges the SourceTv port.`n`nDev:`nThis is an edit control that stores its value in Server Boss All\Settings.ini whenever the user types a new keystroke. When the server is launched, it retrieves this value and writes it to a newly generated .cfg file located in the server host directory. The .cfg file will have the same name as the server.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowTimeoutEditVar":
        AdvancedInformationWindowText := "Command line:`ntv_timeout <integer>`n`nUsage:`ntv_timeout 30`n`nDefault value: 30`n`nDescription:`nChanges the SourceTv connection timeout(in seconds)`n`nDev:`nThis is an edit control that stores its value in Server Boss All\Settings.ini whenever the user types a new keystroke. When the server is launched, it retrieves this value and writes it to a newly generated .cfg file located in the server host directory. The .cfg file will have the same name as the server.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowTimeoutPictureVar":
        AdvancedInformationWindowText := "Button usage:`nUse your mouse scroll wheel to change the value below.`n`nDev:`nThis is a picture that emulates an updown control. This control toggles between two images using the scroll wheel. It also changes the value of the edit box closest to it. WheelUp:: and WheelDown:: hotkeys obtain the ClassNN of the control below the mouse cursor when called. If it matches, it updates the nearby picture control and uses GuiControl to change the value of the edit box below.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowMaxNumOfClientsEditVar":
        AdvancedInformationWindowText := "Command line:`ntv_maxclients <0-255>`n`nUsage: tv_maxclients 0`n`nDefault value:128`n`nDescription:`nControls the number of clients that can spectate from SourceTv. Setting the value to 0 will prevent people from spectating the game. This is useful for recording server demos.`n`nDev: `nThis is a picture control that emulates a checkbox. When pressed It toggles a value of 0/1 inside Server Boss All\Settings.ini file.`n`nThe control requires two images in order to function properly.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowMaxNumOfClientsPictureVar":
        AdvancedInformationWindowText := "Button usage:`nUse your mouse scroll wheel to change the value below.`n`nDev:`nThis is a picture that emulates an updown control. This control toggles between two images using the scroll wheel. It also changes the value of the edit box closest to it. WheelUp:: and WheelDown:: hotkeys obtain the ClassNN of the control below the mouse cursor when called. If it matches, it updates the nearby picture control and uses GuiControl to change the value of the edit box below.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowAllowVotingPictureButtonVar":
        AdvancedInformationWindowText := "Command line:`nsv_allow_votes <0/1>`n`nUsage: sv_allow_votes 1`n`nDefault value: 1`n`nDescription:`nAllow clients to vote.`n`nDev: `nThis is a picture control that emulates a checkbox. When pressed It toggles a value of 0/1 inside Server Boss All\Settings.ini file.`n`nThe control requires two images in order to function properly.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowAllowSpectatorsToVotePictureButtonVar":
        AdvancedInformationWindowText := "Command line:`nsv_vote_allow_spectators <0/1>`n`nUsage: sv_vote_allow_spectators 1`n`nDefault value: 0`n`nDescription:`nAllows spectators to vote.`n`nDev: `nThis is a picture control that emulates a checkbox. When pressed It toggles a value of 0/1 inside Server Boss All\Settings.ini file.`n`nThe control requires two images in order to function properly.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowAllowBotsToVotePictureButtonVar":
        AdvancedInformationWindowText := "Command line:`nsv_vote_bots_allowed <0/1>`n`nUsage: sv_vote_bots_allowed 1`n`nDefault value: 0`n`nDescription:`nAllows bots to vote.`n`nDev: `nThis is a picture control that emulates a checkbox. When pressed It toggles a value of 0/1 inside Server Boss All\Settings.ini file.`n`nThe control requires two images in order to function properly.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowEnableAutoTeamBalanceVotesPictureButtonVar":
        AdvancedInformationWindowText := "Command line:`nsv_vote_issue_autobalance_allowed <0/1>`n`nUsage: sv_vote_issue_autobalance_allowed 1`n`nDefault value: 0`n`nDescription:`nAllow players to call votes to enable or disable auto team balance.`n`nDev: `nThis is a picture control that emulates a checkbox. When pressed It toggles a value of 0/1 inside Server Boss All\Settings.ini file.`n`nThe control requires two images in order to function properly.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowAllowChangeLevelVotesPictureButtonVar":
        AdvancedInformationWindowText := "Command line:`nsv_vote_issue_changelevel_allowed <0/1>; sv_vote_issue_changelevel_allowed_mvm <0/1>`n`nUsage: sv_vote_issue_changelevel_allowed 1; sv_vote_issue_changelevel_allowed_mvm 1`n`nDefault value: 0, 0`n`nDescription:`nAllow players to call votes to change the current level(this applies to mvm maps as well).`n`nDev: `nThis is a picture control that emulates a checkbox. When pressed It toggles a value of 0/1 inside Server Boss All\Settings.ini file.`n`nThe control requires two images in order to function properly.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowAllowPerClassLimitVotesPictureButtonVar":
        AdvancedInformationWindowText := "Command line:`nsv_vote_issue_classlimits_allowed <0/1>; sv_vote_issue_classlimits_allowed_mvm <0/1>`n`nUsage: sv_vote_issue_classlimits_allowed 1; sv_vote_issue_classlimits_allowed_mvm 1`n`nDefault value: 0, 0`n`nDescription:`nAllow players to call votes to enable class limits(this applies to mvm maps as well).`n`nDev: `nThis is a picture control that emulates a checkbox. When pressed It toggles a value of 0/1 inside Server Boss All\Settings.ini file.`n`nThe control requires two images in order to function properly.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowAllowNextLevelVotesPictureButtonVar":
        AdvancedInformationWindowText := "Command line:`nsv_vote_issue_nextlevel_allowed <0/1>`n`nUsage: sv_vote_issue_nextlevel_allowed 1`n`nDefault value: 1`n`nDescription:`nAllow players to call votes to choose the next level.`n`nDev: `nThis is a picture control that emulates a checkbox. When pressed It toggles a value of 0/1 inside Server Boss All\Settings.ini file.`n`nThe control requires two images in order to function properly.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowEnableVoteKickPictureButtonVar":
        AdvancedInformationWindowText := "Command line:`nsv_vote_issue_kick_allowed <0/1>; sv_vote_issue_kick_allowed_mvm <0/1>`n`nUsage: sv_vote_issue_kick_allowed 1; sv_vote_issue_kick_allowed_mvm 1`n`nDefault value: 0, 0`n`nDescription:`nAllow players to vote kick other players(this applies to mvm maps as well).`n`nDev: `nThis is a picture control that emulates a checkbox. When pressed It toggles a value of 0/1 inside Server Boss All\Settings.ini file.`n`nThe control requires two images in order to function properly.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowAllowVoteKickSpectatorsInMvMPictureButtonVar":
        AdvancedInformationWindowText := "Command line:`nsv_vote_issue_kick_spectators_mvm <0/1>`n`nUsage: sv_vote_issue_kick_spectators_mvm 1`n`nDefault value: 0`n`nDescription:`nAllow players to vote to set the challenge level in mvm.`n`nDev: `nThis is a picture control that emulates a checkbox. When pressed It toggles a value of 0/1 inside Server Boss All\Settings.ini file.`n`nThe control requires two images in order to function properly.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowAllowSetMvMChallengeLevelVotesPictureButtonVar":
        AdvancedInformationWindowText := "Command line:`nsv_vote_issue_mvm_challenge_allowed <0/1>`n`nUsage: sv_vote_issue_mvm_challenge_allowed 1`n`nDefault value: 1`n`nDescription:`nAllow players to vote to change the current mvm level.`n`nDev: `nThis is a picture control that emulates a checkbox. When pressed It toggles a value of 0/1 inside Server Boss All\Settings.ini file.`n`nThe control requires two images in order to function properly.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowAutomaticallyChooseYesForVoteCallersPictureButtonVar":
        AdvancedInformationWindowText := "Command line:`nsv_vote_holder_may_vote_no <0/1>`n`nUsage: sv_vote_holder_may_vote_no 0`n`nDefault value: 0`n`nDescription:`nVote callers won't be forced to vote 'Yes' when calling a vote.`n`nDev: `nThis is a picture control that emulates a checkbox. When pressed It toggles a value of 0/1 inside Server Boss All\Settings.ini file.`n`nThe control requires two images in order to function properly.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowAllowExtendCurrentMapVotesPictureButtonVar":
        AdvancedInformationWindowText := "Command line:`nsv_vote_issue_nextlevel_allowextend <0/1>`n`nUsage: sv_vote_issue_nextlevel_allowextend 1`n`nDefault value: 0`n`nDescription:`nAllow players to vote to extend the current map.`n`nDev: `nThis is a picture control that emulates a checkbox. When pressed It toggles a value of 0/1 inside Server Boss All\Settings.ini file.`n`nThe control requires two images in order to function properly.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowPresentTheLowestPlaytimeMapsListPictureButtonVar":
        AdvancedInformationWindowText := "Command line:`nsv_vote_issue_nextlevel_choicesmode <0/1>`n`nUsage: sv_vote_issue_nextlevel_choicesmode 1`n`nDefault value: 0`n`nDescription:`nGive players a list with the lowest play time maps to choose from.`n`nDev: `nThis is a picture control that emulates a checkbox. When pressed It toggles a value of 0/1 inside Server Boss All\Settings.ini file.`n`nThe control requires two images in order to function properly.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowPreventNextLevelVotesIfOneHasBeenSetPictureButtonVar":
        AdvancedInformationWindowText := "Command line:`nsv_vote_issue_nextlevel_prevent_change <0/1>`n`nUsage: sv_vote_issue_nextlevel_prevent_change 1`n`nDefault value: 1`n`nDescription:`nPrevent players to vote to change to the next level if one has already been set.`n`nDev: `nThis is a picture control that emulates a checkbox. When pressed It toggles a value of 0/1 inside Server Boss All\Settings.ini file.`n`nThe control requires two images in order to function properly.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowAllowRestartGameVotesPictureButtonVar":
        AdvancedInformationWindowText := "Command line:`nsv_vote_issue_restart_game_allowed <0/1>; sv_vote_issue_restart_game_allowed_mvm <0/1>`n`nUsage: sv_vote_issue_restart_game_allowed 1; sv_vote_issue_restart_game_allowed_mvm 1`n`nDefault value: 0, 1`n`nDescription:`nAllow players to vote to restart the game(this applies to mvm maps as well).`n`nDev: `nThis is a picture control that emulates a checkbox. When pressed It toggles a value of 0/1 inside Server Boss All\Settings.ini file.`n`nThe control requires two images in order to function properly.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowAllowVoteScramblePictureButtonVar":
        AdvancedInformationWindowText := "Command line:`nsv_vote_issue_scramble_teams_allowed <0/1>`n`nUsage: sv_vote_issue_scramble_teams_allowed 1`n`nDefault value: 1`n`nDescription:`nAllow players to vote to scramble the teams.`n`nDev: `nThis is a picture control that emulates a checkbox. When pressed It toggles a value of 0/1 inside Server Boss All\Settings.ini file.`n`nThe control requires two images in order to function properly.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowShowDisabledVotesInTheVoteMenuPictureButtonVar":
        AdvancedInformationWindowText := "Command line:`nsv_vote_ui_hide_disabled_issues <0/1>`n`nUsage: sv_vote_ui_hide_disabled_issues 1`n`nDefault value: 0`n`nDescription:`nHide vote issues that are disabled in the vote menu.`n`nDev: `nThis is a picture control that emulates a checkbox. When pressed It toggles a value of 0/1 inside Server Boss All\Settings.ini file.`n`nThe control requires two images in order to function properly.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowAllowPauseGameVotesPictureButtonVar":
        AdvancedInformationWindowText := "Command line:`nsv_vote_issue_pause_game_allowed <0/1>`n`nUsage: sv_vote_issue_pause_game_allowed 1`n`nDefault value: 0`n`nDescription:`nAllow players to call votes to pause the game.`n`nDev: `nThis is a picture control that emulates a checkbox. When pressed It toggles a value of 0/1 inside Server Boss All\Settings.ini file.`n`nThe control requires two images in order to function properly.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowEmptyToggle15PictureButtonVar", "AdvancedWindowEmptyToggle16PictureButtonVar":
        AdvancedInformationWindowText := "N/A`n`nDev: `nThis is a picture control that emulates a checkbox. When pressed It toggles a value of 0/1 inside Server Boss All\Settings.ini file.`n`nThe control requires two images in order to function properly.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowVotesTogglesLVVar":
        AdvancedInformationWindowText := "N/A`n`nDev:`nThis is just a listview control used to show information about the current toggle button under the mouse cursor.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "GameAdvancedMapOptionsBottomImageOverlayPictureVar", "GameAdvancedMapOptionsTopImageOverlayPictureVar", "GameAdvancedMapOptionsLeftImageOverlayPictureVar", "GameAdvancedMapOptionsRightImageOverlayPictureVar":
        AdvancedInformationWindowText := "N/A`n`nDev:`nThis is a picture control. It doesn't do anything.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "GameAdvancedMapOptionsTopTextVar", "GameAdvancedMapOptionsPageOptionsTextVar":
        AdvancedInformationWindowText := "N/A`n`nDev:`nThis is a text control control on top of a progress bar. It doesn't do anything.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "GameAdvancedMapOptionsPageOptionsPreviousPageTextVar":
        AdvancedInformationWindowText := "Button usage: Press the button to go to the previous page.`n`nDev:`nThis is a text control placed on top of a progress bar. To create it, use a progress bar with the same color for both the background and progress line, then overlay a text control with the BackgroundTrans option enabled. Make sure to add the option 'disabled' on the progress bar or it may cause some issues later.`n`nExample: gui, add, progress, w265 h235 disabled Background10900d c10900d, 100`ngui, add, text, xp+15 yp+10 w235 h215 BackgroundTrans, My text`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "GameAdvancedMapOptionsPageOptionsNextPageTextVar":
        AdvancedInformationWindowText := "Button usage: Press the button to go to the next page.`n`nDev:`nThis is a text control placed on top of a progress bar. To create it, use a progress bar with the same color for both the background and progress line, then overlay a text control with the BackgroundTrans option enabled. Make sure to add the option 'disabled' on the progress bar or it may cause some issues later.`n`nExample: gui, add, progress, w265 h235 disabled Background10900d c10900d, 100`ngui, add, text, xp+15 yp+10 w235 h215 BackgroundTrans, My text`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "GameAdvancedMapOptionsModifyValueTextVar":
        AdvancedInformationWindowText := "Button usage: Type a number in the edit box and press the button to change the value of the selected option.`n`nDev:`nThis is a text control placed on top of a progress bar. To create it, use a progress bar with the same color for both the background and progress line, then overlay a text control with the BackgroundTrans option enabled. Make sure to add the option 'disabled' on the progress bar or it may cause some issues later.`n`nExample: gui, add, progress, w265 h235 disabled Background10900d c10900d, 100`ngui, add, text, xp+15 yp+10 w235 h215 BackgroundTrans, My text`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "GameAdvancedMapOptionsPageLVVar":
        {
            gui GameAdvancedWindow:default
            gui, GameAdvancedWindow:ListView, GameAdvancedMapOptionsPageLVVar
            LV_GetText(AdvancedSelectedMapOption, LV_GetNext(), 2)
            if (AdvancedSelectedMapOption = "Allow spectators")
            CommandInfo := "Command line:`nmp_allowspectators <0/1>`n`nUsage: mp_allowspectators 1`n`nDefault value: 1`n`nDescription:`nAllow spectators on the server."
            else if (AdvancedSelectedMapOption = "Show voice chat icons")
            CommandInfo := "Command line:`nmp_show_voice_icons <0/1>`n`nUsage: mp_show_voice_icons 1`n`nDefault value: 1`n`nDescription:`nAllow voice chat icon to appear above the player's head."
            else if (AdvancedSelectedMapOption = "Disable respawn time")
            CommandInfo := "Command line:`nmp_disable_respawn_times <0/1>`n`nUsage: mp_disable_respawn_times 0`n`nDefault value: 0`n`nDescription:`nRespawn times will be reduced to 3 seconds for all players."
            else if (AdvancedSelectedMapOption = "Restrict to 1 class only")
            CommandInfo := "Command line:`nmp_highlander <0/1>`n`nUsage: mp_highlander 0`n`nDefault value: 0`n`nDescription:`nAllows only one of each player class type to be played."
            else if (AdvancedSelectedMapOption = "Enable teammates push away")
            CommandInfo := "Command line:`ntf_avoidteammates_pushaway <0/1>`n`nUsage: tf_avoidteammates_pushaway 1`n`nDefault value: 1`n`nDescription:`nAllow players to push each other when the same space is occupied."
            else if (AdvancedSelectedMapOption = "Enable random crits")
            CommandInfo := "Command line:`ntf_weapon_criticals <0/1>; tf_weapon_criticals_melee <0/1/2>`n`nUsage: tf_weapon_criticals 1; tf_weapon_criticals_melee 1`n`nDefault value: 1, 1`n`nDescription:`nAllow random crits on the server."
            else if (AdvancedSelectedMapOption = "Spawn beach ball on round start")
            CommandInfo := "Command line:`ntf_birthday_ball_chance <0-100>`n`nUsage: tf_birthday_ball_chance 100`n`nDefault value: 100, 1`n`nDescription:`nSpawn a beach ball at the start of the server."
            else if (AdvancedSelectedMapOption = "Enable grappling hook")
            CommandInfo := "Command line:`ntf_grapplinghook_enable <0/1>`n`nUsage: tf_grapplinghook_enable 1`n`nDefault value: 0, 1`n`nDescription:`nEnable grappling hooks on the server."
            else if (AdvancedSelectedMapOption = "Enable mannpower mode")
            CommandInfo := "Command line:`ntf_powerup_mode <0/1>`n`nUsage: tf_powerup_mode 0`n`nDefault value: 0, 1`n`nDescription:`nEnable mannpower on the server."
            else if (AdvancedSelectedMapOption = "Enable medieval mode")
            CommandInfo := "Command line:`ntf_medieval <0/1>`n`nUsage: tf_medieval 0`n`nDefault value: 0`n`nDescription:`nEnables medieval mode on the server. Players will be forced to use melee weapons and bows."
            else if (AdvancedSelectedMapOption = "Enable medieval autorp")
            CommandInfo := "Command line:`ntf_medieval_autorp <0/1>`n`nUsage: tf_medieval_autorp 0`n`nDefault value: 0`n`nDescription:`nEnables medieval auto - roleplaying. Words typed in the chat will be modified."
            else if (AdvancedSelectedMapOption = "Fade to black for spectators")
            CommandInfo := "Command line:`nmp_fadetoblack <0/1>`n`nUsage: mp_fadetoblack 0`n`nDefault value: 0`n`nDescription:`nMake player's screen fade to black upon death."
            else if (AdvancedSelectedMapOption = "Enable friendly fire")
            CommandInfo := "Command line:`nmp_friendlyfire <0/1>`n`nUsage: mp_friendlyfire 0`n`nDefault value: 0`n`nDescription:`nEnable friendly fire on the server."
            else if (AdvancedSelectedMapOption = "Enable taunt sliding")
            CommandInfo := "Command line:`ntf_allow_sliding_taunt <0/1>`n`nUsage: tf_allow_sliding_taunt 0`n`nDefault value: 0`n`nDescription:`nAllow players to slide for a bit after they taunt."
            else if (AdvancedSelectedMapOption = "Allow weapon switch while taunting")
            CommandInfo := "Command line:`ntf_allow_taunt_switch <0/1/2>`n`nUsage: tf_allow_taunt_switch 0`n`nDefault value: 0`n`nDescription:`nAllow players to switch weapons while they are taunting."
            else if (AdvancedSelectedMapOption = "Enable bullet spread")
            CommandInfo := "Command line:`ntf_use_fixed_weaponspreads <0/1>`n`nUsage: tf_use_fixed_weaponspreads 0`n`nDefault value: 0`n`nDescription:`nDisable bullet spread."
            else if (AdvancedSelectedMapOption = "Allows living players to hear dead players using text/voice chat")
            CommandInfo := "Command line:`ntf_gravetalk <0/1>`n`nUsage: tf_gravetalk 1`n`nDefault value: 1`n`nDescription:`nAllow players to hear dead player in both voice and game chat."
            else if (AdvancedSelectedMapOption = "Allows truce during boss battle")
            CommandInfo := "Command line:`ntf_halloween_allow_truce_during_boss_event <0/1>`n`nUsage: tf_halloween_allow_truce_during_boss_event 0`n`nDefault value: 0`n`nDescription:`nPrevent both teams from injuring one another during boss battle."
            else if (AdvancedSelectedMapOption = "Prevent player movement during startup")
            CommandInfo := "Command line:`ntf_player_movement_restart_freeze <0/1>`n`nUsage: tf_player_movement_restart_freeze 1`n`nDefault value: 1`n`nDescription:`nPrevent players from moving during round startup."
            else if (AdvancedSelectedMapOption = "Turn players into losers")
            CommandInfo := "Command line:`ntf_always_loser <0/1>`n`nUsage: tf_always_loser 0`n`nDefault value: 0`n`nNote: cheats must be enabled on the server(sv_cheats 1)`n`nDescription:`nTurns all players into loosers."
            else if (AdvancedSelectedMapOption = "Enable spells")
            CommandInfo := "Command line:`ntf_spells_enabled <0/1>`n`nUsage: tf_spells_enabled 0`n`nDefault value: 0`n`nDescription:`nAllow spells to be dropped and used by the players."
            else if (AdvancedSelectedMapOption = "Enable team balancing")
            CommandInfo := "Command line:`nmp_autoteambalance <0/1/2>`n`nUsage: mp_autoteambalance 1`n`nDefault value: 1`n`nDescription:`nEnable auto - balance on the server. 0 disables auto - balance, 1 force players to be auto - balanced, 2 ask for volunteers to be auto - balanced."
            else if (AdvancedSelectedMapOption = "Enable sudden death")
            CommandInfo := "Command line:`nmp_stalemate_enable <0/1>`n`nUsage: mp_stalemate_enable 0`n`nDefault value: 0`n`nDescription:`nEnable sudden death on the server. If the round limit runs out, players will be forced to fight to the death without being able to respawn."
            else if (AdvancedSelectedMapOption = "Restart round after X number of sec.")
            CommandInfo := "Command line:`nmp_restartgame <integer>`n`nUsage: mp_restartgame 0`n`nDefault value: 0`n`nDescription:`nRestart the game after <integer> number of seconds. 0=disabled."
            else if (AdvancedSelectedMapOption = "Max. idle time(in min.)")
            CommandInfo := "Command line:`nmp_idlemaxtime <integer>`n`nUsage: mp_idlemaxtime 10`n`nDefault value: 3`n`nDescription:`nMove the player to spectators if they are idle for <integer> number of minutes."
            else if (AdvancedSelectedMapOption = "Set gravity")
            CommandInfo := "Command line:`nsv_gravity <integer>`n`nUsage: sv_gravity 800`n`nDefault value: 800`n`nDescription:`nSet the map gravity. Higher values = stronger gravity."
            else if (AdvancedSelectedMapOption = "Set air acceleration")
            CommandInfo := "Command line:`nsv_airaccelerate <integer>`n`nUsage: sv_airaccelerate 10`n`nDefault value: 10`n`nDescription:`nSet air acceleration."
            else if (AdvancedSelectedMapOption = "Set player acceleration")
            CommandInfo := "Command line:`nsv_accelerate <integer>`n`nUsage: sv_accelerate 10`n`nDefault value: 10`n`nDescription:`nSet player acceleration."
            else if (AdvancedSelectedMapOption = "Player roll angle")
            CommandInfo := "Command line:`nsv_rollangle <integer>`n`nUsage: sv_rollangle 0`n`nDefault value: 0`n`nDescription:`nSet the maximum player view roll angle."
            else if (AdvancedSelectedMapOption = "Roll angle speed")
            CommandInfo := "Command line:`nsv_rollspeed <integer>`n`nUsage: sv_rollspeed 200`n`nDefault value: 200`n`nDescription:`nSet roll angle speed."
            else if (AdvancedSelectedMapOption = "Blue team dmg. multiplier")
            CommandInfo := "Command line:`ntf_damage_multiplier_blue <decimal>`n`nUsage: tf_damage_multiplier_blue 1.0`n`nDefault value: 1.0`n`nNote: cheats must be enabled on the server(sv_cheats 1)`n`nDescription:`nMultiply the damage received for blue team."
            else if (AdvancedSelectedMapOption = "Red team dmg. multiplier")
            CommandInfo := "Command line:`ntf_damage_multiplier_red <decimal>`n`nUsage: tf_damage_multiplier_red 1.0`n`nDefault value: 1.0`n`nNote: cheats must be enabled on the server(sv_cheats 1)`n`nDescription:`nMultiply the damage received for red team."
            else if (AdvancedSelectedMapOption = "Timescale")
            CommandInfo := "Command line:`nhost_timescale <decimal>`n`nUsage: host_timescale 1.0`n`nDefault value: 1.0`n`nNote: cheats must be enabled on the server(sv_cheats 1)`n`nDescription:`nPrescale the clock. Great for moking the entire server running in slow motion."
            else if (AdvancedSelectedMapOption = "Team balance limit")
            CommandInfo := "Command line:`nmp_teams_unbalance_limit <integer>`n`nUsage: mp_teams_unbalance_limit 1`n`nDefault value: 1`n`nDescription:`nPerform an auto - balance if the enemy team has more than <integer> number of players."
            else if (AdvancedSelectedMapOption = "Round limit")
            CommandInfo := "Command line:`nmp_winlimit <integer>`n`nUsage: mp_winlimit 0`n`nDefault value: 0`n`nDescription:`nSet the maximum score one team can reach before server changes maps."
            else if (AdvancedSelectedMapOption = "Map timelimit")
            CommandInfo := "Command line:`nmp_timelimit <integer>`n`nUsage: mp_timelimit 0`n`nDefault value: 0`n`nDescription:`nSet the map time limit."
            else if (AdvancedSelectedMapOption = "Stalemate time limit - (sec.)")
            CommandInfo := "Command line:`nmp_stalemate_timelimit <integer>`n`nUsage: mp_stalemate_timelimit 240`n`nDefault value: 240`n`nDescription:`nSet stalemate timelimit(in seconds)."
            else if (AdvancedSelectedMapOption = "N/A")
            CommandInfo := AdvancedSelectedMapOption
            AdvancedInformationWindowText := "Listview usage:`nDouble-click on any option to check/uncheck it. All options that are checked will get included in the .cfg server file.`n`n" . CommandInfo . "`n`nDev:`nThis is a listview control with 3 columns. The first column is an emoji (0x1F7E9) that emulates a checkbox. The value of the first column is toggled between 1 and 0 which is stored inside the Server Boss All\Settings.ini file. Value of 0 changes the emoji to: 0x2610, while a value of 1 changes the emoji to: (0x2705). The second column are just the options set by the program. The third column stores the values of all rows inside the Server Boss All\Settings.ini file. When the server is launched the options that are stored in Server Boss All\Settings.ini are added in the server .cfg file.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        }
        case "GameAdvancedMapOptionsModifyValueEditVar":
        AdvancedInformationWindowText := "N/A`n`nDev:`nThis is an edit control. It doesn't do anything.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "GameAdvancedMapOptionsModifyValueTextVar":
        AdvancedInformationWindowText := "Button usage:`nPress the button to change the value of the selected option.`n`nThis is a text control placed on top of a progress bar. To create it, use a progress bar with the same color for both the background and progress line, then overlay a text control with the BackgroundTrans option enabled. Make sure to add the option 'disabled' on the progress bar or it may cause some issues later.`n`nExample: gui, add, progress, w265 h235 disabled Background10900d c10900d, 100`ngui, add, text, xp+15 yp+10 w235 h215 BackgroundTrans, My text`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "GameAdvancedLaunchOptionsEditVar":
        AdvancedInformationWindowText := "Set custom launch options for the game.exe file when launched.`n`nDev:`nThis is an edit control that stores its value in Server Boss All\Settings.ini whenever the user types a new keystroke. When the server is launched, it retrieves this value and writes it in a variable that launches the server .exe file.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "GameAdvancedCustomCFGCommandsEditVar":
        AdvancedInformationWindowText :=  "Edit box usage: type any custom console command in a different row. `n`nExample:`n`ntf_bot_add 23`ntf_allow_taunt_switch 1`ntv_enable 1`n`nDev:`nThis is an edit control that stores its value in Server Boss All\Settings.ini whenever the user types a new keystroke. When the server is launched, it retrieves this value and writes it to a newly generated .cfg file located in the server host directory. The .cfg file will have the same name as the server.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "GameAdvancedCustomCFGCommandsRightImageOverlayPictureVar", "GameAdvancedCustomCFGCommandsTopImageOverlayPictureVar", "GameAdvancedCustomCFGCommandsLeftImageOverlayPictureVar", "GameAdvancedCustomCFGCommandsBottomImageOverlayPictureVar", "AdvancedWindowInfoBoxTopImageOverlayPictureVar", "AdvancedWindowInfoBoxBottomImageOverlayPictureVar", "AdvancedWindowInfoBoxLeftImageOverlayPictureVar", "AdvancedWindowInfoBoxRightImageOverlayPictureVar":
        AdvancedInformationWindowText := "N/A`n`nDev:`nThis is a picture control. It doesn't do anything.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowTab2Var":
        AdvancedInformationWindowText := "Tab usage: press on any button to change the current tab.`n`nDev:`nThis is a tab2 control. It only changes tabs.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "GameAdvancedOpenReplaysGuidePictureButtonVar":
        AdvancedInformationWindowText := "Open a website with a guide for replays.`n`nDev: `nThis is a picture control that emulates a checkbox. When pressed it opens up a website specified by the program.`n`nThe control requires two images in order to function properly.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "GameAdvancedOpenPortForwardGuidePictureButtonVar":
        AdvancedInformationWindowText := "Open a website with a guide for port forwarding.`n`nDev: `nThis is a picture control that emulates a checkbox. When pressed it opens up a website specified by the program.`n`nThe control requires two images in order to function properly.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "GameAdvancedOpenFastDLGuidePictureButtonVar":
        AdvancedInformationWindowText := "Open a website with a guide for FastDL.`n`nDev: `nThis is a picture control that emulates a checkbox. When pressed it opens up a website specified by the program.`n`nThe control requires two images in order to function properly.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "GameAdvancedOpenConsoleCommandsListPictureButtonVar":
        AdvancedInformationWindowText := "Open a website with a list for all tf2 console commands.`n`nDev: `nThis is a picture control that emulates a checkbox. When pressed it opens up a website specified by the program.`n`nThe control requires two images in order to function properly.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "GameAdvancedOpenLaunchOptionsListPictureButtonVar":
        AdvancedInformationWindowText := "Open a website with a list for all tf2 launch options.`n`nDev: `nThis is a picture control that emulates a checkbox. When pressed it opens up a website specified by the program.`n`nThe control requires two images in order to function properly.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "GameAdvancedOpenServerTokenPictureButtonVar":
        AdvancedInformationWindowText := "Open a website for obtaining a game server token.`n`nDev: `nThis is a picture control that emulates a checkbox. When pressed it opens up a website specified by the program.`n`nThe control requires two images in order to function properly.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "GameAdvancedEmpty1PictureButtonVar", "GameAdvancedEmpty2PictureButtonVar", "GameAdvancedEmpty2PictureButtonVar":
        AdvancedInformationWindowText := "N/A`n`nDev: `nThis is a picture control that emulates a checkbox. It doesn't do anything.`n`nThe control requires two images in order to function properly.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
        case "AdvancedWindowInfoBoxEdit":
        AdvancedInformationWindowText := "Middle click on any button/text/image/listbox/listview control to obtain infomation.`n`nDev: `nThis is an edit control. It shows information about specific control when the Mouse3 button is pressed on top of it.`n`nClassNN:" . A_Space . CurrentClassNN, OptionName := ""
    }
    gosub, AnimateAdvancedInformationWindow
}
VarSetCapacity(Text, 0)
VarSetCapacity(OptionName, 0)
VarSetCapacity(AddLoopText, 0)
return

;Advanced window
;----------------------------------------------------------------------------------------------
AdvancedWindowAllowDownloadPictureButton:
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "AllowDownload", "AdvancedWindowAllowDownloadPictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
return

AdvancedWindowAllowUploadPictureButton:
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "AllowUpload", "AdvancedWindowAllowUploadPictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
return

AdvancedWindowHideServerPictureButton:
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "HideServer", "AdvancedWindowHideServerPictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
return

AdvancedWindowDisableVACPictureButton:
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "DisableVAC", "AdvancedWindowDisableVACPictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
return

AdvancedWindowEnableAllTalkPictureButton:
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "EnableAllTalk", "AdvancedWindowEnableAllTalkPictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
return

AdvancedWindowEnableCheatsPictureButton:
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "EnableCheats", "AdvancedWindowEnableCheatsPictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
return

AdvancedWindowEmptyToggle1PictureButton:
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "EmptyToggle1", "AdvancedWindowEmptyToggle1PictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button_empty.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button_empty.png")
return

AdvancedWindowEmptyToggle2PictureButton:
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "EmptyToggle2", "AdvancedWindowEmptyToggle2PictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button_empty.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button_empty.png")
return

AdvancedWindowEmptyToggle3PictureButton:
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "EmptyToggle3", "AdvancedWindowEmptyToggle3PictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button_empty.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button_empty.png")
return

AdvancedWindowEmptyToggle4PictureButton:
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "EmptyToggle4", "AdvancedWindowEmptyToggle4PictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button_empty.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button_empty.png")
return

AdvancedWindowEmptyToggle5PictureButton:
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "EmptyToggle5", "AdvancedWindowEmptyToggle5PictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button_empty.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button_empty.png")
return

AdvancedWindowEmptyToggle6PictureButton:
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "EmptyToggle6", "AdvancedWindowEmptyToggle6PictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button_empty.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button_empty.png")
return

AdvancedWindowServerTogglesInfoLV:
gui GameAdvancedWindow:default
gui, GameAdvancedWindow:ListView, AdvancedWindowServerTogglesInfoLVVar
LV_Modify(LV_GetNext(), "-Select")
return

AdvancedWindowServerTagsText:
return

AdvancedWindowServerTagsEdit:
gui, GameAdvancedWindow:submit, nohide
IniWrite, %AdvancedWindowServerTagsEditVar%, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, ServerTags
return

AdvancedWindowServerTokenEdit:
gui, GameAdvancedWindow:submit, nohide
IniWrite, %AdvancedWindowServerTokenEditVar%, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, ServerToken
return

AdvancedWindowServerTokenText:
return

AdvancedWindowFastDLURLEdit:
gui, GameAdvancedWindow:submit, nohide
IniWrite, %AdvancedWindowFastDLURLEditVar%, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, FastDLURL
return

AdvancedWindowFastDLURLText:
return

AdvancedWindowRconPasswordEdit:
gui, GameAdvancedWindow:submit, nohide
IniWrite, %AdvancedWindowRconPasswordEditVar%, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, RconPassword
return

AdvancedWindowGenerateRconPasswordText:
EmulateConsoleButtonPress("GameAdvancedWindow", "AdvancedWindowGenerateRconPasswordTextVar", Chr(0x2699))
NewGeneratedRconPassword := GeneratePassword("11")
GuiControl, GameAdvancedWindow:, AdvancedWindowRconPasswordEditVar, % NewGeneratedRconPassword
IniWrite, %NewGeneratedRconPassword%, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, RconPassword
return

AdvancedWindowRconPasswordText:
AdvancedWindowIDForTF2Text:
AdvancedWindowSVPurePicture:
return

AdvancedWindowSVPureMinus1Text:
IniWrite, 2, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, SVPure
RotaryFixedSwitchAnimation("GameAdvancedWindow", "2", "AdvancedWindowSVPurePictureVar", "", "AdvancedWindowSVPureMinus1TextVar", "AdvancedWindowSVPure0TextVar", "AdvancedWindowSVPure1TextVar", "AdvancedWindowSVPure2TextVar", "", "", "", "", "", "","Allow file modifications", "Ban specific user modifications", "Allow only whitelisted user modifications", "Ban all user modifications", "", "", "", "", "")
return

AdvancedWindowSVPure0Text:
IniWrite, 3, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, SVPure
RotaryFixedSwitchAnimation("GameAdvancedWindow", "3", "AdvancedWindowSVPurePictureVar", "", "AdvancedWindowSVPureMinus1TextVar", "AdvancedWindowSVPure0TextVar", "AdvancedWindowSVPure1TextVar", "AdvancedWindowSVPure2TextVar", "", "", "", "", "", "","Allow file modifications", "Ban specific user modifications", "Allow only whitelisted user modifications", "Ban all user modifications", "", "", "", "", "")
return

AdvancedWindowSVPure1Text:
IniWrite, 4, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, SVPure
RotaryFixedSwitchAnimation("GameAdvancedWindow", "4", "AdvancedWindowSVPurePictureVar", "", "AdvancedWindowSVPureMinus1TextVar", "AdvancedWindowSVPure0TextVar", "AdvancedWindowSVPure1TextVar", "AdvancedWindowSVPure2TextVar", "", "", "", "", "", "","Allow file modifications", "Ban specific user modifications", "Allow only whitelisted user modifications", "Ban all user modifications", "", "", "", "", "")
return

AdvancedWindowSVPure2Text:
IniWrite, 5, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, SVPure
RotaryFixedSwitchAnimation("GameAdvancedWindow", "5", "AdvancedWindowSVPurePictureVar", "", "AdvancedWindowSVPureMinus1TextVar", "AdvancedWindowSVPure0TextVar", "AdvancedWindowSVPure1TextVar", "AdvancedWindowSVPure2TextVar", "", "", "", "", "", "","Allow file modifications", "Ban specific user modifications", "Allow only whitelisted user modifications", "Ban all user modifications", "", "", "", "", "")
return

AdvancedWindowServerTypePicture:
return

AdvancedWindowServerTypeSDRText:
IniWrite, 10, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, ServerType
GuiControl, MainWindow:, ToolbarServerTypeTextVar, Server type: SDR
RotaryFixedSwitchAnimation("GameAdvancedWindow", "10", "AdvancedWindowServerTypePictureVar", "AdvancedWindowServerTypePublicTextVar", "AdvancedWindowServerTypeLocalTextVar", "", "", "", "", "", "", "", "AdvancedWindowServerTypeSDRTextVar", "Public", "Local", "", "", "", "", "", "", "", "SDR")
return

AdvancedWindowServerTypePublicText:
IniWrite, 1, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, ServerType
GuiControl, MainWindow:, ToolbarServerTypeTextVar, Server type: Public
RotaryFixedSwitchAnimation("GameAdvancedWindow", "1", "AdvancedWindowServerTypePictureVar", "AdvancedWindowServerTypePublicTextVar", "AdvancedWindowServerTypeLocalTextVar", "", "", "", "", "", "", "", "AdvancedWindowServerTypeSDRTextVar", "Public", "Local", "", "", "", "", "", "", "", "SDR")
return

AdvancedWindowServerTypeLocalText:
IniWrite, 2, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, ServerType
GuiControl, MainWindow:, ToolbarServerTypeTextVar, Server type: Local
RotaryFixedSwitchAnimation("GameAdvancedWindow", "2", "AdvancedWindowServerTypePictureVar", "AdvancedWindowServerTypePublicTextVar", "AdvancedWindowServerTypeLocalTextVar", "", "", "", "", "", "", "", "AdvancedWindowServerTypeSDRTextVar", "Public", "Local", "", "", "", "", "", "", "", "SDR")
return

AdvancedWindowRegionPicture:
return

AdvancedWindowRegionWorldText:
IniWrite, 1, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, Region
RotaryFixedSwitchAnimation("GameAdvancedWindow", "1", "AdvancedWindowRegionPictureVar","AdvancedWindowRegionWorldTextVar", "AdvancedWindowRegionUSEastTextVar", "AdvancedWindowRegionUSWestTextVar", "AdvancedWindowRegionSouthAmericaTextVar", "AdvancedWindowRegionEuropeTextVar", "AdvancedWindowRegionAsiaTextVar", "AdvancedWindowRegionAustraliaTextVar", "AdvancedWindowRegionMiddleEastTextVar", "AdvancedWindowRegionAfricaTextVar", "", "World", "US-East", "US-West", "South America", "Europe", "Asia", "Australia", "Middle East", "Africa", "")
return

AdvancedWindowRegionUSEastText:
IniWrite, 2, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, Region
RotaryFixedSwitchAnimation("GameAdvancedWindow", "2", "AdvancedWindowRegionPictureVar", "AdvancedWindowRegionWorldTextVar", "AdvancedWindowRegionUSEastTextVar", "AdvancedWindowRegionUSWestTextVar", "AdvancedWindowRegionSouthAmericaTextVar", "AdvancedWindowRegionEuropeTextVar", "AdvancedWindowRegionAsiaTextVar", "AdvancedWindowRegionAustraliaTextVar", "AdvancedWindowRegionMiddleEastTextVar", "AdvancedWindowRegionAfricaTextVar", "", "World", "US-East", "US-West", "South America", "Europe", "Asia", "Australia", "Middle East", "Africa", "")
return

AdvancedWindowRegionUSWestText:
IniWrite, 3, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, Region
RotaryFixedSwitchAnimation("GameAdvancedWindow", "3", "AdvancedWindowRegionPictureVar", "AdvancedWindowRegionWorldTextVar", "AdvancedWindowRegionUSEastTextVar", "AdvancedWindowRegionUSWestTextVar", "AdvancedWindowRegionSouthAmericaTextVar", "AdvancedWindowRegionEuropeTextVar", "AdvancedWindowRegionAsiaTextVar", "AdvancedWindowRegionAustraliaTextVar", "AdvancedWindowRegionMiddleEastTextVar", "AdvancedWindowRegionAfricaTextVar", "", "World", "US-East", "US-West", "South America", "Europe", "Asia", "Australia", "Middle East", "Africa", "")
return

AdvancedWindowRegionSouthAmericaText:
IniWrite, 4, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, Region
RotaryFixedSwitchAnimation("GameAdvancedWindow", "4", "AdvancedWindowRegionPictureVar", "AdvancedWindowRegionWorldTextVar", "AdvancedWindowRegionUSEastTextVar", "AdvancedWindowRegionUSWestTextVar", "AdvancedWindowRegionSouthAmericaTextVar", "AdvancedWindowRegionEuropeTextVar", "AdvancedWindowRegionAsiaTextVar", "AdvancedWindowRegionAustraliaTextVar", "AdvancedWindowRegionMiddleEastTextVar", "AdvancedWindowRegionAfricaTextVar", "", "World", "US-East", "US-West", "South America", "Europe", "Asia", "Australia", "Middle East", "Africa", "")
return

AdvancedWindowRegionEuropeText:
IniWrite, 5, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, Region
RotaryFixedSwitchAnimation("GameAdvancedWindow", "5", "AdvancedWindowRegionPictureVar", "AdvancedWindowRegionWorldTextVar", "AdvancedWindowRegionUSEastTextVar", "AdvancedWindowRegionUSWestTextVar", "AdvancedWindowRegionSouthAmericaTextVar", "AdvancedWindowRegionEuropeTextVar", "AdvancedWindowRegionAsiaTextVar", "AdvancedWindowRegionAustraliaTextVar", "AdvancedWindowRegionMiddleEastTextVar", "AdvancedWindowRegionAfricaTextVar", "", "World", "US-East", "US-West", "South America", "Europe", "Asia", "Australia", "Middle East", "Africa", "")
return

AdvancedWindowRegionAsiaText:
IniWrite, 6, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, Region
RotaryFixedSwitchAnimation("GameAdvancedWindow", "6", "AdvancedWindowRegionPictureVar", "AdvancedWindowRegionWorldTextVar", "AdvancedWindowRegionUSEastTextVar", "AdvancedWindowRegionUSWestTextVar", "AdvancedWindowRegionSouthAmericaTextVar", "AdvancedWindowRegionEuropeTextVar", "AdvancedWindowRegionAsiaTextVar", "AdvancedWindowRegionAustraliaTextVar", "AdvancedWindowRegionMiddleEastTextVar", "AdvancedWindowRegionAfricaTextVar", "", "World", "US-East", "US-West", "South America", "Europe", "Asia", "Australia", "Middle East", "Africa", "")
return

AdvancedWindowRegionAustraliaText:
IniWrite, 7, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, Region
RotaryFixedSwitchAnimation("GameAdvancedWindow", "7", "AdvancedWindowRegionPictureVar", "AdvancedWindowRegionWorldTextVar", "AdvancedWindowRegionUSEastTextVar", "AdvancedWindowRegionUSWestTextVar", "AdvancedWindowRegionSouthAmericaTextVar", "AdvancedWindowRegionEuropeTextVar", "AdvancedWindowRegionAsiaTextVar", "AdvancedWindowRegionAustraliaTextVar", "AdvancedWindowRegionMiddleEastTextVar", "AdvancedWindowRegionAfricaTextVar", "", "World", "US-East", "US-West", "South America", "Europe", "Asia", "Australia", "Middle East", "Africa", "")
return

AdvancedWindowRegionMiddleEastText:
IniWrite, 8, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, Region
RotaryFixedSwitchAnimation("GameAdvancedWindow", "8", "AdvancedWindowRegionPictureVar", "AdvancedWindowRegionWorldTextVar", "AdvancedWindowRegionUSEastTextVar", "AdvancedWindowRegionUSWestTextVar", "AdvancedWindowRegionSouthAmericaTextVar", "AdvancedWindowRegionEuropeTextVar", "AdvancedWindowRegionAsiaTextVar", "AdvancedWindowRegionAustraliaTextVar", "AdvancedWindowRegionMiddleEastTextVar", "AdvancedWindowRegionAfricaTextVar", "", "World", "US-East", "US-West", "South America", "Europe", "Asia", "Australia", "Middle East", "Africa", "")
return

AdvancedWindowRegionAfricaText:
IniWrite, 9, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, Region
RotaryFixedSwitchAnimation("GameAdvancedWindow", "9", "AdvancedWindowRegionPictureVar", "AdvancedWindowRegionWorldTextVar", "AdvancedWindowRegionUSEastTextVar", "AdvancedWindowRegionUSWestTextVar", "AdvancedWindowRegionSouthAmericaTextVar", "AdvancedWindowRegionEuropeTextVar", "AdvancedWindowRegionAsiaTextVar", "AdvancedWindowRegionAustraliaTextVar", "AdvancedWindowRegionMiddleEastTextVar", "AdvancedWindowRegionAfricaTextVar", "", "World", "US-East", "US-West", "South America", "Europe", "Asia", "Australia", "Middle East", "Africa", "")
return

;These labels are required for A_guicontrol to work
AdvancedWindowMaxRatePicture:
AdvancedWindowMinRatePicture:
AdvancedWindowMaxUpdateRatePicture:
AdvancedWindowMinUpdateRatePicture:
AdvancedWindowMaxCMDRatePicture:
AdvancedWindowMinCMDRatePicture:
AdvancedWindowTimeoutPicture:
AdvancedWindowMaxNumOfClientsPicture:
return

AdvancedWindowMaxRateEdit:
gui, GameAdvancedWindow:submit, nohide
IniWrite, %AdvancedWindowMaxRateEditVar%, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, MaxRate
return

AdvancedWindowMinRateEdit:
gui, GameAdvancedWindow:submit, nohide
IniWrite, %AdvancedWindowMinRateEditVar%, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, MinRate
return

AdvancedWindowMaxUpdateRateEdit:
gui, GameAdvancedWindow:submit, nohide
IniWrite, %AdvancedWindowMaxUpdateRateEditVar%, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, MaxUpdateRate
return

AdvancedWindowMinUpdateRateEdit:
gui, GameAdvancedWindow:submit, nohide
IniWrite, %AdvancedWindowMinUpdateRateEditVar%, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, MinUpdateRate
return

AdvancedWindowMaxCMDRateEdit:
gui, GameAdvancedWindow:submit, nohide
IniWrite, %AdvancedWindowMaxCMDRateEditVar%, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, MaxCMDRate
return

AdvancedWindowMinCMDRateEdit:
gui, GameAdvancedWindow:submit, nohide
IniWrite, %AdvancedWindowMinCMDRateEditVar%, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, MinCMDRate
return

AdvancedWindowCustomAddressEdit:
gui, GameAdvancedWindow:submit, nohide
IniWrite, %AdvancedWindowCustomAddressEditVar%, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, CustomAddress
return

AdvancedWindowUDPPortEdit:
gui, GameAdvancedWindow:submit, nohide
IniWrite, %AdvancedWindowUDPPortEditVar%, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, UDPPort
return

AdvancedWindowEnableSourceTvPictureButton:
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "EnableSourceTv", "AdvancedWindowEnableSourceTvPictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
return

AdvancedWindowUsePlayersAsCameraPictureButton:
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "UsePlayerAsCamera", "AdvancedWindowUsePlayersAsCameraPictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
return

AdvancedWindowPlayVoicePictureButton:
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "PlayVoice", "AdvancedWindowPlayVoicePictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
return

AdvancedWindowAutoRecordAllGamesPictureButton:
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "AutoRecordAllGames", "AdvancedWindowAutoRecordAllGamesPictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
return

AdvancedWindowTransmitAllEntitiesPictureButton:
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "TransmitAllEntities", "AdvancedWindowTransmitAllEntitiesPictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
return

AdvancedWindowDelayMapChangePictureButton:
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "DelayMapChange", "AdvancedWindowDelayMapChangePictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
return

AdvancedWindowEmptyToggle7PictureButton:
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "EmptyToggle7", "AdvancedWindowEmptyToggle7PictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button_empty.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button_empty.png")
return

AdvancedWindowEmptyToggle8PictureButton:
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "EmptyToggle8", "AdvancedWindowEmptyToggle8PictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button_empty.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button_empty.png")
return

AdvancedWindowEmptyToggle9PictureButton:
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "EmptyToggle9", "AdvancedWindowEmptyToggle9PictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button_empty.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button_empty.png")
return

AdvancedWindowEmptyToggle10PictureButton:
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "EmptyToggle10", "AdvancedWindowEmptyToggle10PictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button_empty.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button_empty.png")
return

AdvancedWindowEmptyToggle11PictureButton:
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "EmptyToggle11", "AdvancedWindowEmptyToggle11PictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button_empty.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button_empty.png")
return

AdvancedWindowEmptyToggle12PictureButton:
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "EmptyToggle12", "AdvancedWindowEmptyToggle12PictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button_empty.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button_empty.png")
return

AdvancedWindowEmptyToggle13PictureButton:
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "EmptyToggle13", "AdvancedWindowEmptyToggle13PictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button_empty.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button_empty.png")
return

AdvancedWindowEmptyToggle14PictureButton:
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "EmptyToggle14", "AdvancedWindowEmptyToggle14PictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button_empty.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button_empty.png")
return

AdvancedWindowSTVTogglesInfoLV:
gui GameAdvancedWindow:default
gui, GameAdvancedWindow:ListView, AdvancedWindowSTVTogglesInfoLVVar
LV_Modify(LV_GetNext(), "-Select")
return

AdvancedWindowSTVNameText:
return

AdvancedWindowSTVNameEdit:
gui, GameAdvancedWindow:submit, nohide
IniWrite, %AdvancedWindowSTVNameEditVar%, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, STVName
return

AdvancedWindowSTVPasswordText:
return

AdvancedWindowSTVPasswordEdit:
gui, GameAdvancedWindow:submit, nohide
IniWrite, %AdvancedWindowSTVPasswordEditVar%, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, STVPassword
return

AdvancedWindowGenerateSTVPasswordText:
EmulateConsoleButtonPress("GameAdvancedWindow", "AdvancedWindowGenerateSTVPasswordTextVar", Chr(0x2699))
NewGeneratedSTVPassword := GeneratePassword("11")
GuiControl, GameAdvancedWindow:, AdvancedWindowSTVPasswordEditVar, % NewGeneratedSTVPassword
IniWrite, %NewGeneratedSTVPassword%, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, STVPassword
return

AdvancedWindowSTVSnapShotRateText:
return

AdvancedWindowSTVSnapShotRateEdit:
gui, GameAdvancedWindow:submit, nohide
IniWrite, %AdvancedWindowSTVSnapShotRateEditVar%, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, STVSnapShotRate
return

AdvancedWindowSTVDelayText:
return

AdvancedWindowSTVDelayEdit:
gui, GameAdvancedWindow:submit, nohide
IniWrite, %AdvancedWindowSTVDelayEditVar%, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, STVDelay
return

AdvancedWindowSTVPortText:
return

AdvancedWindowSTVPortEdit:
gui, GameAdvancedWindow:submit, nohide
IniWrite, %AdvancedWindowSTVPortEditVar%, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, STVPort
return

AdvancedWindowTimeoutEdit:
gui, GameAdvancedWindow:submit, nohide
IniWrite, %AdvancedWindowTimeoutEditVar%, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, Timeout
return

AdvancedWindowMaxNumOfClientsEdit:
gui, GameAdvancedWindow:submit, nohide
IniWrite, %AdvancedWindowMaxNumOfClientsEditVar%, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, MaxNumOfClients
return

AdvancedWindowAllowVotingPictureButton:
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "AllowVoting", "AdvancedWindowAllowVotingPictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
return

AdvancedWindowAllowSpectatorsToVotePictureButton:
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "AllowSpectatorsToVote", "AdvancedWindowAllowSpectatorsToVotePictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
return

AdvancedWindowAllowBotsToVotePictureButton:
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "AllowBotsToVote", "AdvancedWindowAllowBotsToVotePictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
return

AdvancedWindowEnableAutoTeamBalanceVotesPictureButton:
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "EnableAutoTeamBalanceVotes", "AdvancedWindowEnableAutoTeamBalanceVotesPictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
return

AdvancedWindowAllowChangeLevelVotesPictureButton:
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "AllowChangeLevelVotes", "AdvancedWindowAllowChangeLevelVotesPictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
return

AdvancedWindowAllowPerClassLimitVotesPictureButton:
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "AllowPerClassLimitVotes", "AdvancedWindowAllowPerClassLimitVotesPictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
return

AdvancedWindowAllowNextLevelVotesPictureButton:
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "AllowNextLevelVotes", "AdvancedWindowAllowNextLevelVotesPictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
return

AdvancedWindowEnableVoteKickPictureButton:
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "EnableVoteKick", "AdvancedWindowEnableVoteKickPictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
return

AdvancedWindowAllowVoteKickSpectatorsInMvMPictureButton:
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "AllowVoteKickSpectatorsInMvM", "AdvancedWindowAllowVoteKickSpectatorsInMvMPictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
return

AdvancedWindowAllowSetMvMChallengeLevelVotesPictureButton:
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "AllowSetMvMChallengeLevelVotes", "AdvancedWindowAllowSetMvMChallengeLevelVotesPictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
return

AdvancedWindowAutomaticallyChooseYesForVoteCallersPictureButton:
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "ForceYesForVoteCallers", "AdvancedWindowAutomaticallyChooseYesForVoteCallersPictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
return

AdvancedWindowAllowExtendCurrentMapVotesPictureButton:
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "AllowExtendCurrentLevelVotes", "AdvancedWindowAllowExtendCurrentMapVotesPictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
return

AdvancedWindowPresentTheLowestPlaytimeMapsListPictureButton:
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "PresentTheLowestPlaytimeMapsList", "AdvancedWindowPresentTheLowestPlaytimeMapsListPictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
return

AdvancedWindowPreventNextLevelVotesIfOneHasBeenSetPictureButton:
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "PreventNextLevelVotesIfOneHasBeenSet", "AdvancedWindowPreventNextLevelVotesIfOneHasBeenSetPictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
return

AdvancedWindowAllowRestartGameVotesPictureButton:
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "AllowRestartGameVotes", "AdvancedWindowAllowRestartGameVotesPictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
return

AdvancedWindowAllowVoteScramblePictureButton:
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "AllowVoteScramble", "AdvancedWindowAllowVoteScramblePictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
return

AdvancedWindowShowDisabledVotesInTheVoteMenuPictureButton:
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "ShowDisabledVotesInTheVoteMenu", "AdvancedWindowShowDisabledVotesInTheVoteMenuPictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
return

AdvancedWindowAllowPauseGameVotesPictureButton:
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "AllowPauseGameVotes", "AdvancedWindowAllowPauseGameVotesPictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
return

AdvancedWindowEmptyToggle15PictureButton:
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "EmptyToggle15", "AdvancedWindowEmptyToggle15PictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button_empty.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button_empty.png")
return

AdvancedWindowEmptyToggle16PictureButton:
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "EmptyToggle16", "AdvancedWindowEmptyToggle16PictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button_empty.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button_empty.png")
return

AdvancedWindowVotesTogglesLV:
gui GameAdvancedWindow:default
gui, GameAdvancedWindow:ListView, AdvancedWindowVotesTogglesLVVar
LV_Modify(LV_GetNext(), "-Select")
return

GameAdvancedMapOptionsTopImageOverlayPicture:
GameAdvancedMapOptionsLeftImageOverlayPicture:
GameAdvancedMapOptionsRightImageOverlayPicture:
GameAdvancedMapOptionsBottomImageOverlayPicture:
GameAdvancedMapOptionsTopText:
GameAdvancedMapOptionsPageOptionsText:
return

GameAdvancedMapOptionsPageOptionsLV:
gui GameAdvancedWindow:default
gui, GameAdvancedWindow:ListView, GameAdvancedMapOptionsPageLVVar
if (A_GuiEvent = "DoubleClick")
{
    LV_GetText(SelectedMapOptionCheck, LV_GetNext(), 1)
    LV_GetText(SelectedMapOption, LV_GetNext(), 2)
    LV_GetText(SelectedMapOptionValue, LV_GetNext(), 3)
    SelectedRowNumber := LV_GetNext()
    switch SelectedMapOption
    {
        case "Allow spectators":
        ToggleListboxCheckbox("GameAdvancedWindow", "Advanced", "AllowSpectators", SelectedRowNumber, 1)
        case "Show voice chat icons":
        ToggleListboxCheckbox("GameAdvancedWindow", "Advanced", "ShowVoiceChatIcons", SelectedRowNumber, 1)
        case "Disable respawn time":
        ToggleListboxCheckbox("GameAdvancedWindow", "Advanced", "DisableRespawnTime", SelectedRowNumber, 1)
        case "Enable teammates push away":
        ToggleListboxCheckbox("GameAdvancedWindow", "Advanced", "EnableTeammatesPushAway", SelectedRowNumber, 1)
        case "Enable random crits":
        ToggleListboxCheckbox("GameAdvancedWindow", "Advanced", "EnableRandomCrits", SelectedRowNumber, 1)
        case "Spawn beach ball on round start":
        ToggleListboxCheckbox("GameAdvancedWindow", "Advanced", "SpawnBeachBallOnRoundStart", SelectedRowNumber, 1)
        case "Enable grappling hook":
        ToggleListboxCheckbox("GameAdvancedWindow", "Advanced", "EnableGrapplingHook", SelectedRowNumber, 1)
        case "Enable mannpower mode":
        ToggleListboxCheckbox("GameAdvancedWindow", "Advanced", "EnableMannpowerMode", SelectedRowNumber, 1)
        case "Restrict to 1 class only":
        ToggleListboxCheckbox("GameAdvancedWindow", "Advanced", "RestrictTo1ClassOnly", SelectedRowNumber, 1)
        case "Enable medieval mode":
        ToggleListboxCheckbox("GameAdvancedWindow", "Advanced", "EnableMedievalMode", SelectedRowNumber, 1)
        case "Enable medieval autorp":
        ToggleListboxCheckbox("GameAdvancedWindow", "Advanced", "EnableMedievalAutorp", SelectedRowNumber, 1)
        case "Fade to black for spectators":
        ToggleListboxCheckbox("GameAdvancedWindow", "Advanced", "FadeToBlackForSpectators", SelectedRowNumber, 1)
        case "Enable friendly fire":
        ToggleListboxCheckbox("GameAdvancedWindow", "Advanced", "EnableFriendlyFire", SelectedRowNumber, 1)
        case "Enable taunt sliding":
        ToggleListboxCheckbox("GameAdvancedWindow", "Advanced", "EnableTauntSliding", SelectedRowNumber, 1)
        case "Allow weapon switch while taunting":
        ToggleListboxCheckbox("GameAdvancedWindow", "Advanced", "AllowWeaponSwitchWhileTaunting", SelectedRowNumber, 1)
        case "Enable bullet spread":
        ToggleListboxCheckbox("GameAdvancedWindow", "Advanced", "EnableBulletSpread", SelectedRowNumber, 1)
        case "Allows living players to hear dead players using text/voice chat":
        ToggleListboxCheckbox("GameAdvancedWindow", "Advanced", "AllowsLivingPlayersToHearDeadPlayers", SelectedRowNumber, 1)
        case "Allows truce during boss battle":
        ToggleListboxCheckbox("GameAdvancedWindow", "Advanced", "AllowsTruceDuringBossBattle", SelectedRowNumber, 1)
        case "Turn players into losers":
        ToggleListboxCheckbox("GameAdvancedWindow", "Advanced", "TurnPlayersIntoLosers", SelectedRowNumber, 1)
        case "Prevent player movement during startup":
        ToggleListboxCheckbox("GameAdvancedWindow", "Advanced", "PreventPlayerMovementDuringStartup", SelectedRowNumber, 1)
        case "Enable spells":
        ToggleListboxCheckbox("GameAdvancedWindow", "Advanced", "EnableSpells", SelectedRowNumber, 1)
        case "Enable team balancing":
        ToggleListboxCheckbox("GameAdvancedWindow", "Advanced", "EnableTeamBalancing", SelectedRowNumber, 1)
        case "Enable sudden death":
        ToggleListboxCheckbox("GameAdvancedWindow", "Advanced", "EnableSuddenDeath", SelectedRowNumber, 1)
        case "Restart round after X number of sec.":
        ToggleListboxCheckbox("GameAdvancedWindow", "Advanced", "RestartRoundAfterXNumberOfSec", SelectedRowNumber, 1)
        case "Max. idle time(in min.)":
        ToggleListboxCheckbox("GameAdvancedWindow", "Advanced", "MaxIdleTime", SelectedRowNumber, 1)
        case "Set gravity":
        ToggleListboxCheckbox("GameAdvancedWindow", "Advanced", "SetGravity", SelectedRowNumber, 1)
        case "Set air acceleration":
        ToggleListboxCheckbox("GameAdvancedWindow", "Advanced", "SetAirAcceleration", SelectedRowNumber, 1)
        case "Set player acceleration":
        ToggleListboxCheckbox("GameAdvancedWindow", "Advanced", "SetPlayerAcceleration", SelectedRowNumber, 1)
        case "Player roll angle":
        ToggleListboxCheckbox("GameAdvancedWindow", "Advanced", "PlayerRollAngle", SelectedRowNumber, 1)
        case "Roll angle speed":
        ToggleListboxCheckbox("GameAdvancedWindow", "Advanced", "RollAngleSpeed", SelectedRowNumber, 1)
        case "Red team dmg. multiplier":
        ToggleListboxCheckbox("GameAdvancedWindow", "Advanced", "RedTeamDmgMultiplier", SelectedRowNumber, 1)
        case "Blue team dmg. multiplier":
        ToggleListboxCheckbox("GameAdvancedWindow", "Advanced", "BlueTeamDmgMultiplier", SelectedRowNumber, 1)
        case "Timescale":
        ToggleListboxCheckbox("GameAdvancedWindow", "Advanced", "Timescale", SelectedRowNumber, 1)
        case "Team balance limit":
        ToggleListboxCheckbox("GameAdvancedWindow", "Advanced", "TeamBalanceLimit", SelectedRowNumber, 1)
        case "Round limit":
        ToggleListboxCheckbox("GameAdvancedWindow", "Advanced", "RoundLimit", SelectedRowNumber, 1)
        case "Map timelimit":
        ToggleListboxCheckbox("GameAdvancedWindow", "Advanced", "MapTimelimit", SelectedRowNumber, 1)
        case "Stalemate time limit - (sec.)":
        ToggleListboxCheckbox("GameAdvancedWindow", "Advanced", "StalemateTimelimit", SelectedRowNumber, 1)
    }
}
return

GameAdvancedMapOptionsPageOptionsPreviousPageText:
GuiControl, GameAdvancedWindow:+cffffff, GameAdvancedMapOptionsPageOptionsPreviousPageTextVar
GuiControl, GameAdvancedWindow:, GameAdvancedMapOptionsPageOptionsPreviousPageTextVar, % Chr(0x2B06)
KeyWait, LButton
gui, GameAdvancedWindow:submit, nohide
gui GameAdvancedWindow:default
gui, GameAdvancedWindow:ListView, GameAdvancedMapOptionsPageLVVar
if (GameAdvancedMapOptionsPage > 0)
{
    if (GameAdvancedMapOptionsPage > 1)
    GameAdvancedMapOptionsPage--
    LV_Delete()
    gosub, ReadAdvancedSettingsFromINI
    gosub, GameAdvancedMapOptionsPageNextListOfOptions
    GuiControl, GameAdvancedWindow:, GameAdvancedMapOptionsPageOptionsTextVar, Double - click to enable/disable an option            Page: %GameAdvancedMapOptionsPage%                                                        _
}
GuiControl, GameAdvancedWindow:+c221f1c, GameAdvancedMapOptionsPageOptionsPreviousPageTextVar
GuiControl, GameAdvancedWindow:, GameAdvancedMapOptionsPageOptionsPreviousPageTextVar, % Chr(0x2B06)
return

GameAdvancedMapOptionsPageOptionsNextPageText:
GuiControl, GameAdvancedWindow:+cffffff, GameAdvancedMapOptionsPageOptionsNextPageTextVar
GuiControl, GameAdvancedWindow:, GameAdvancedMapOptionsPageOptionsNextPageTextVar, % Chr(0x2B07)
KeyWait, LButton
gui, GameAdvancedWindow:submit, nohide
gui GameAdvancedWindow:default
gui, GameAdvancedWindow:ListView, GameAdvancedMapOptionsPageLVVar
if (GameAdvancedMapOptionsPage < 5)
{
    if (GameAdvancedMapOptionsPage < 4)
    GameAdvancedMapOptionsPage++
    LV_Delete()
    gosub, ReadAdvancedSettingsFromINI
    gosub, GameAdvancedMapOptionsPageNextListOfOptions
    GuiControl, GameAdvancedWindow:, GameAdvancedMapOptionsPageOptionsTextVar, Double - click to enable/disable an option            Page: %GameAdvancedMapOptionsPage%                                                        _
}
GuiControl, GameAdvancedWindow:+c221f1c, GameAdvancedMapOptionsPageOptionsNextPageTextVar
GuiControl, GameAdvancedWindow:, GameAdvancedMapOptionsPageOptionsNextPageTextVar, % Chr(0x2B07)
return

GameAdvancedMapOptionsModifyValueText:
GuiControl, GameAdvancedWindow:+cffffff, GameAdvancedMapOptionsModifyValueTextVar
GuiControl, GameAdvancedWindow:, GameAdvancedMapOptionsModifyValueTextVar, % Chr(0x270F)
KeyWait, LButton
gui, GameAdvancedWindow:submit, nohide
gui GameAdvancedWindow:default
gui, GameAdvancedWindow:ListView, GameAdvancedMapOptionsPageLVVar
LV_GetText(SelectedMapOption, LV_GetNext(), 2)
if (GameAdvancedMapOptionsModifyValueEditVar = "")
{
    AdvancedInformationWindowText := "Edit box is empty!"
    gosub, AnimateAdvancedInformationWindow
}
else if RegExMatch(SelectedMapOption, "i)^(Allow spectators|Show voice chat icons|Disable respawn time|Restrict to 1 class only|Enable teammates push away|Enable random crits|Spawn beach ball on round start|Enable grappling hook|Enable mannpower mode|Enable medieval mode|Enable medieval autorp|Fade to black for spectators|Enable friendly fire|Enable taunt sliding|Allow weapon switch while taunting|Enable bullet spread|Allows living players to hear dead players using text/voice chat|Allows truce during boss battle|Prevent player movement during startup|Turn players into losers|Enable spells|Enable team balancing|Enable sudden death)$")
{
    AdvancedInformationWindowText := "The value of this option cannot be changed."
    gosub, AnimateAdvancedInformationWindow
}
else if (SelectedMapOption = "Name")
{
    AdvancedInformationWindowText := "No option selected."
    gosub, AnimateAdvancedInformationWindow
}
else if (SelectedMapOption = "N/A")
{
    AdvancedInformationWindowText := "This option has not been implemented yet."
    gosub, AnimateAdvancedInformationWindow
}
else
LV_Modify(LV_GetNext(),,,, GameAdvancedMapOptionsModifyValueEditVar)

switch SelectedMapOption
{
    case "Restart round after X number of sec.":
    IniWrite, %GameAdvancedMapOptionsModifyValueEditVar%, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, RestartRoundAfterXNumberOfSecValue
    case "Max. idle time(in min.)":
    IniWrite, %GameAdvancedMapOptionsModifyValueEditVar%, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, MaxIdleTimeValue
    case "Set gravity":
    IniWrite, %GameAdvancedMapOptionsModifyValueEditVar%, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, SetGravityValue
    case "Set air acceleration":
    IniWrite, %GameAdvancedMapOptionsModifyValueEditVar%, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, SetAirAccelerationValue
    case "Set player acceleration":
    IniWrite, %GameAdvancedMapOptionsModifyValueEditVar%, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, SetPlayerAccelerationValue
    case "Player roll angle":
    IniWrite, %GameAdvancedMapOptionsModifyValueEditVar%, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, PlayerRollAngleValue
    case "Roll angle speed":
    IniWrite, %GameAdvancedMapOptionsModifyValueEditVar%, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, RollAngleSpeedValue
    case "Red team dmg. multiplier":
    IniWrite, %GameAdvancedMapOptionsModifyValueEditVar%, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, RedTeamDmgMultiplierValue
    case "Blue team dmg. multiplier":
    IniWrite, %GameAdvancedMapOptionsModifyValueEditVar%, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, BlueTeamDmgMultiplierValue
    case "Timescale":
    IniWrite, %GameAdvancedMapOptionsModifyValueEditVar%, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, TimescaleValue
    case "Team balance limit":
    IniWrite, %GameAdvancedMapOptionsModifyValueEditVar%, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, TeamBalanceLimitValue
    case "Round limit":
    IniWrite, %GameAdvancedMapOptionsModifyValueEditVar%, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, RoundLimitValue
    case "Map timelimit":
    IniWrite, %GameAdvancedMapOptionsModifyValueEditVar%, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, MapTimelimitValue
    case "Stalemate time limit - (sec.)":
    IniWrite, %GameAdvancedMapOptionsModifyValueEditVar%, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, StalemateTimelimitValue
}
GuiControl, GameAdvancedWindow:+c221f1c, GameAdvancedMapOptionsModifyValueTextVar
GuiControl, GameAdvancedWindow:, GameAdvancedMapOptionsModifyValueTextVar, % Chr(0x270F)
return

AnimateAdvancedInformationWindow:
GuiControl, GameAdvancedWindow:, AdvancedWindowInfoBoxEditVar
loop, Parse, AdvancedInformationWindowText, % " "
{
    AddLoopText .= A_LoopField . A_Space
    GuiControl, GameAdvancedWindow:, AdvancedWindowInfoBoxEditVar, % AddLoopText . "▮"
    Sleep, 40
}
GuiControl, GameAdvancedWindow:, AdvancedWindowInfoBoxEditVar, % AddLoopText
VarSetCapacity(AddLoopText, 0)
return

GameAdvancedLaunchOptionsEdit:
gui, GameAdvancedWindow:submit, nohide
Iniread, SelectedHostFromINI, %A_scriptdir%\Server Boss All\Settings.ini, SelectedServerHost, Host
Iniread, SelectedHostExePathFromINI, %A_scriptdir%\Server Boss All\Hosts\%SelectedHostFromINI%.ini, Paths, Exe
IniWrite, %GameAdvancedLaunchOptionsEditVar%, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, LaunchOptions
if !InStr(GameAdvancedLaunchOptionsEditVar, "-console")
AdvancedInformationWindowText := "Launch option (-console) is missing!`n`nServer boss won't be able send commands to the game console without this argument."
else if !InStr(GameAdvancedLaunchOptionsEditVar, "-game tf") and InStr(SelectedHostExePathFromINI, "srcds.exe") or InStr(SelectedHostExePathFromINI, "srcds_win64.exe")
AdvancedInformationWindowText := "Launch option (-game tf) is missing!`n`nThe game server won't be able to launch."
else if InStr(GameAdvancedLaunchOptionsEditVar, "-game tf") and InStr(SelectedHostExePathFromINI, "tf.exe") or InStr(SelectedHostExePathFromINI, "tf_win64.exe")
AdvancedInformationWindowText := "Launch option (-game tf) is found!`n`nServers hosted with tf2 will crash if -game tf launch option is used."
else if !InStr(GameAdvancedLaunchOptionsEditVar, "-condebug")
AdvancedInformationWindowText := "Launch option (-condebug) is missing!`n`nServer boss won't be able to display the server logs in the console tab."
else if !InStr(GameAdvancedLaunchOptionsEditVar, "+exec" . A_Space . chr(45) . "A_SerserExeHost" . chr(45))
AdvancedInformationWindowText := "Launch option (+exec %A_SerserExeHost%) is missing!`n`nServer boss will fail to execute all console commands set by the advanced window."
else
AdvancedInformationWindowText := "Launch option (-condebug) is missing!`n`nServer boss won't be able to display the server logs in the console tab."

AdvancedInformationWindowText := ""
gosub, AnimateAdvancedInformationWindow
return

GameAdvancedLaunchOptionsCopyToClipboardText:
EmulateConsoleButtonPress("GameAdvancedWindow", "GameAdvancedLaunchOptionsCopyToClipboardTextVar", Chr(0x1F4CB))
gui, GameAdvancedWindow:submit, nohide
Clipboard := GameAdvancedLaunchOptionsEditVar
return

GameAdvancedLaunchOptionsRestoreText:
EmulateConsoleButtonPress("GameAdvancedWindow", "GameAdvancedLaunchOptionsRestoreTextVar", Chr(0x1F504))
Iniread, SelectedHostFromINI, %A_scriptdir%\Server Boss All\Settings.ini, SelectedServerHost, Host
Iniread, SelectedHostExePathFromINI, %A_scriptdir%\Server Boss All\Hosts\%SelectedHostFromINI%.ini, Paths, Exe
if InStr(SelectedHostExePathFromINI, "tf.exe") or InStr(SelectedHostExePathFromINI, "tf_win64.exe")
{
    GuiControl, GameAdvancedWindow:, GameAdvancedLaunchOptionsEditVar, % "-console -condebug -conclearlog -novid +exec %A_ServerExeHost%"
    IniWrite, % "-console -condebug -conclearlog -novid +exec %A_ServerExeHost%", %A_scriptdir%\Server Boss All\Settings.ini, Advanced, LaunchOptions
}
else
{
    GuiControl, GameAdvancedWindow:, GameAdvancedLaunchOptionsEditVar, % "-console -game tf -condebug -conclearlog +exec %A_ServerExeHost%"
    IniWrite, % "-console -game tf -condebug -conclearlog +exec %A_ServerExeHost%", %A_scriptdir%\Server Boss All\Settings.ini, Advanced, LaunchOptions
}
return

GameAdvancedOpenReplaysGuidePictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Game_advanced_replays_guide_pic_button", "GameAdvancedWindow", "GameAdvancedOpenReplaysGuidePictureButtonVar")
run, https://wiki.teamfortress.com/wiki/Replay_server_configuration
return

GameAdvancedOpenPortForwardGuidePictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Game_advanced_port_forward_guide_pic_button", "GameAdvancedWindow", "GameAdvancedOpenPortForwardGuidePictureButtonVar")
run, https://portforward.com/how-to-port-forward/
return

GameAdvancedOpenFastDLGuidePictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Game_advanced_fast_dl_pic_button", "GameAdvancedWindow", "GameAdvancedOpenFastDLGuidePictureButtonVar")
run, https://developer.valvesoftware.com/wiki/FastDL
return

GameAdvancedOpenConsoleCommandsListPictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Game_advanced_console_commands_pic_button", "GameAdvancedWindow", "GameAdvancedOpenConsoleCommandsListPictureButtonVar")
run, https://developer.valvesoftware.com/wiki/List_of_Team_Fortress_2_console_commands_and_variables
return

GameAdvancedOpenLaunchOptionsListPictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Game_advanced_launch_options_pic_button", "GameAdvancedWindow", "GameAdvancedOpenLaunchOptionsListPictureButtonVar")
run, https://developer.valvesoftware.com/wiki/Command_line_options
return

GameAdvancedOpenServerTokenPictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Game_advanced_server_token_pic_button", "GameAdvancedWindow", "GameAdvancedOpenServerTokenPictureButtonVar")
run, https://steamcommunity.com/dev/managegameservers
return

GameAdvancedEmpty1PictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Console_empty_pic_button", "GameAdvancedWindow", "GameAdvancedEmpty1PictureButtonVar")
return

GameAdvancedEmpty2PictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Console_empty_pic_button", "GameAdvancedWindow", "GameAdvancedEmpty2PictureButtonVar")
return

GameAdvancedEmpty3PictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Console_empty_pic_button", "GameAdvancedWindow", "GameAdvancedEmpty3PictureButtonVar")
return

GameAdvancedCustomCFGCommandsEdit:
gui, GameAdvancedWindow:submit, nohide
FileDelete, %A_scriptdir%\Server Boss All\Custom startup commands.cfg
FileAppend, % GameAdvancedCustomCFGCommandsEditVar, %A_scriptdir%\Server Boss All\Custom startup commands.cfg
return

GameAdvancedCustomCFGCommandsRightImageOverlayPicture:
GameAdvancedCustomCFGCommandsBottomImageOverlayPicture:
GameAdvancedCustomCFGCommandsLeftImageOverlayPicture:
GameAdvancedCustomCFGCommandsTopImageOverlayPicture:
AdvancedWindowInfoBoxTopImageOverlayPicture:
AdvancedWindowInfoBoxRightImageOverlayPicture:
AdvancedWindowInfoBoxBottomImageOverlayPicture:
AdvancedWindowInfoBoxLeftImageOverlayPicture:
AdvancedWindowInfoBoxEdit:
return

SelectServerPresetRemovePresetPictureButton:
EmulateConsoleButtonPress("GameAdvancedWindowPresets", "SelectServerPresetRemovePresetPictureButtonVar", "-")
gui, GameAdvancedWindowPresets:submit, nohide
FileDelete, %A_ScriptDir%/Server Boss All/Presets/Advanced/%SelectServerPresetListListboxVar%.txt
gosub, ScanAdvancedSettingsForPresets
return

SelectServerPresetAddPresetPictureButton:
EmulateConsoleButtonPress("GameAdvancedWindowPresets", "SelectServerPresetAddPresetPictureButtonVar", "+")
gui, GameAdvancedWindowPresets:submit, nohide
if (SelectServerPresetNameEditVar = "")
DisplayTooltip("Edit box is empty!", 3)
else
{
    GuiControl, GameAdvancedWindowPresets:, SelectServerPresetListListboxVar, % SelectServerPresetNameEditVar
    if !FileExist(A_ScriptDir . "/Server Boss All/Presets/Advanced/" . SelectServerPresetNameEditVar . ".txt")
    {
        gosub, ReadAdvancedSettingsFromINI
        gosub, AdvancedGeneratePresetCode
        FileAppend, %PresetCode%, %A_ScriptDir%/Server Boss All/Presets/Advanced/%SelectServerPresetNameEditVar%.txt
    }
    GuiControl, GameAdvancedWindowPresets:, SelectServerPresetNameEditVar
}
return

SelectServerPresetApplyPresetPictureButton:
EmulateConsoleButtonPress("GameAdvancedWindowPresets", "SelectServerPresetApplyPresetPictureButtonVar", Chr(0x2935))
gui, GameAdvancedWindowPresets:submit, nohide
gui GameAdvancedWindow:default
gui, GameAdvancedWindow:ListView, GameAdvancedMapOptionsPageLVVar
if (SelectServerPresetListListboxVar = "")
{
    DisplayTooltip("Preset not selected!", 3)
    return
}
GuiControl, GameAdvancedWindowPresets:disable, SelectServerPresetListListboxVar
FileRead, PresetCodeRead, %A_scriptdir%\Server Boss All\Presets\Advanced\%SelectServerPresetListListboxVar%.txt
loop, Parse, PresetCodeRead, |
{
    switch A_Index
    {
        case 1:
        Iniwrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, AllowDownload
        case 2:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, AllowUpload
        case 3:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, HideServer
        case 4:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, DisableVAC
        case 5:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EnableAllTalk
        case 6:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EnableCheats
        case 7:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EmptyToggle1
        case 8:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EmptyToggle2
        case 9:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EmptyToggle3
        case 10:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EmptyToggle4
        case 11:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EmptyToggle5
        case 12:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EmptyToggle6
        case 13:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, ServerTags
        case 14:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, ServerToken
        case 15:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, FastDLURL
        case 16:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, RconPassword
        case 17:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, SVPure
        case 18:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, ServerType
        case 19:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, Region
        case 20:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, MaxRate
        case 21:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, MinRate
        case 22:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, MaxUpdateRate
        case 23:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, MinUpdateRate
        case 24:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, MaxCMDRate
        case 25:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, MinCMDRate
        case 26:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, CustomAddress
        case 27:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, UDPPort
        case 28:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EnableSourceTv
        case 29:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, UsePlayerAsCamera
        case 30:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, PlayVoice
        case 31:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, AutoRecordAllGames
        case 32:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, TransmitAllEntities
        case 33:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, DelayMapChange
        case 34:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EmptyToggle7
        case 35:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EmptyToggle8
        case 36:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EmptyToggle9
        case 37:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EmptyToggle10
        case 38:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EmptyToggle11
        case 39:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EmptyToggle12
        case 40:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EmptyToggle13
        case 41:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EmptyToggle14
        case 42:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, STVName
        case 43:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, STVPassword
        case 44:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, STVSnapShotRate
        case 45:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, STVDelay
        case 46:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, STVPort
        case 47:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, Timeout
        case 48:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, MaxNumOfClients
        case 49:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, AllowVoting
        case 50:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, AllowSpectatorsToVote
        case 51:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, AllowBotsToVote
        case 52:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EnableAutoTeamBalanceVotes
        case 53:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, AllowChangeLevelVotes
        case 54:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, AllowPerClassLimitVotes
        case 55:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, AllowNextLevelVotes
        case 56:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EnableVoteKick
        case 57:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, AllowVoteKickSpectatorsInMvM
        case 58:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, AllowSetMvMChallengeLevelVotes
        case 59:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, ForceYesForVoteCallers
        case 60:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, AllowExtendCurrentLevelVotes
        case 61:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, PresentTheLowestPlaytimeMapsList
        case 62:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, PreventNextLevelVotesIfOneHasBeenSet
        case 63:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, AllowRestartGameVotes
        case 64:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, AllowVoteScramble
        case 65:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, ShowDisabledVotesInTheVoteMenu
        case 66:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, AllowPauseGameVotes
        case 67:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EmptyToggle15
        case 68:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EmptyToggle16
        case 69:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EmptyToggle17
        case 70:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EmptyToggle18
        case 71:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EmptyToggle19
        case 72:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EmptyToggle20
        case 73:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EmptyToggle21
        case 74:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EmptyToggle22
        case 75:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EmptyToggle23
        case 76:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EmptyToggle24
        case 77:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, AllowSpectators
        if (GameAdvancedMapOptionsPage = "1")
        (A_LoopField = "1") ? (LV_Modify(1,, chr(0x2705))) : (LV_Modify(1,, chr(0x1F7E9)))
        case 78:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, ShowVoiceChatIcons
        if (GameAdvancedMapOptionsPage = "1")
        (A_LoopField = "1") ? (LV_Modify(2,, chr(0x2705))) : (LV_Modify(2,, chr(0x1F7E9)))
        case 79:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, DisableRespawnTime
        if (GameAdvancedMapOptionsPage = "1")
        (A_LoopField = "1") ? (LV_Modify(3,, chr(0x2705))) : (LV_Modify(3,, chr(0x1F7E9)))
        case 80:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, RestrictTo1ClassOnly
        if (GameAdvancedMapOptionsPage = "1")
        (A_LoopField = "1") ? (LV_Modify(4,, chr(0x2705))) : (LV_Modify(4,, chr(0x1F7E9)))
        case 81:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EnableTeammatesPushAway
        if (GameAdvancedMapOptionsPage = "1")
        (A_LoopField = "1") ? (LV_Modify(5,, chr(0x2705))) : (LV_Modify(5,, chr(0x1F7E9)))
        case 82:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EnableRandomCrits
        if (GameAdvancedMapOptionsPage = "1")
        (A_LoopField = "1") ? (LV_Modify(6,, chr(0x2705))) : (LV_Modify(6,, chr(0x1F7E9)))
        case 83:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, SpawnBeachBallOnRoundStart
        if (GameAdvancedMapOptionsPage = "1")
        (A_LoopField = "1") ? (LV_Modify(7,, chr(0x2705))) : (LV_Modify(7,, chr(0x1F7E9)))
        case 84:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EnableGrapplingHook
        if (GameAdvancedMapOptionsPage = "1")
        (A_LoopField = "1") ? (LV_Modify(8,, chr(0x2705))) : (LV_Modify(8,, chr(0x1F7E9)))
        case 85:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EnableMannpowerMode
        if (GameAdvancedMapOptionsPage = "1")
        (A_LoopField = "1") ? (LV_Modify(9,, chr(0x2705))) : (LV_Modify(9,, chr(0x1F7E9)))
        case 86:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EnableMedievalMode
        if (GameAdvancedMapOptionsPage = "1")
        (A_LoopField = "1") ? (LV_Modify(10,, chr(0x2705))) : (LV_Modify(10,, chr(0x1F7E9)))
        case 87:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EnableMedievalAutorp
        if (GameAdvancedMapOptionsPage = "1")
        (A_LoopField = "1") ? (LV_Modify(11,, chr(0x2705))) : (LV_Modify(11,, chr(0x1F7E9)))
        case 88:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, FadeToBlackForSpectators
        if (GameAdvancedMapOptionsPage = "1")
        (A_LoopField = "1") ? (LV_Modify(12,, chr(0x2705))) : (LV_Modify(12,, chr(0x1F7E9)))
        case 89:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EnableFriendlyFire
        if (GameAdvancedMapOptionsPage = "2")
        (A_LoopField = "1") ? (LV_Modify(1,, chr(0x2705))) : (LV_Modify(1,, chr(0x1F7E9)))
        case 90:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EnableTauntSliding
        if (GameAdvancedMapOptionsPage = "2")
        (A_LoopField = "1") ? (LV_Modify(2,, chr(0x2705))) : (LV_Modify(2,, chr(0x1F7E9)))
        case 91:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, AllowWeaponSwitchWhileTaunting
        if (GameAdvancedMapOptionsPage = "2")
        (A_LoopField = "1") ? (LV_Modify(3,, chr(0x2705))) : (LV_Modify(3,, chr(0x1F7E9)))
        case 92:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EnableBulletSpread
        if (GameAdvancedMapOptionsPage = "2")
        (A_LoopField = "1") ? (LV_Modify(4,, chr(0x2705))) : (LV_Modify(4,, chr(0x1F7E9)))
        case 93:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, AllowsLivingPlayersToHearDeadPlayers
        if (GameAdvancedMapOptionsPage = "2")
        (A_LoopField = "1") ? (LV_Modify(5,, chr(0x2705))) : (LV_Modify(5,, chr(0x1F7E9)))
        case 94:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, AllowsTruceDuringBossBattle
        if (GameAdvancedMapOptionsPage = "2")
        (A_LoopField = "1") ? (LV_Modify(6,, chr(0x2705))) : (LV_Modify(6,, chr(0x1F7E9)))
        case 95:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, TurnPlayersIntoLosers
        if (GameAdvancedMapOptionsPage = "2")
        (A_LoopField = "1") ? (LV_Modify(7,, chr(0x2705))) : (LV_Modify(7,, chr(0x1F7E9)))
        case 96:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, PreventPlayerMovementDuringStartup
        if (GameAdvancedMapOptionsPage = "2")
        (A_LoopField = "1") ? (LV_Modify(8,, chr(0x2705))) : (LV_Modify(8,, chr(0x1F7E9)))
        case 97:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EnableSpells
        if (GameAdvancedMapOptionsPage = "2")
        (A_LoopField = "1") ? (LV_Modify(9,, chr(0x2705))) : (LV_Modify(9,, chr(0x1F7E9)))
        case 98:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EnableTeamBalancing
        if (GameAdvancedMapOptionsPage = "2")
        (A_LoopField = "1") ? (LV_Modify(10,, chr(0x2705))) : (LV_Modify(10,, chr(0x1F7E9)))
        case 99:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EnableSuddenDeath
        if (GameAdvancedMapOptionsPage = "2")
        (A_LoopField = "1") ? (LV_Modify(11,, chr(0x2705))) : (LV_Modify(11,, chr(0x1F7E9)))
        case 100:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, RestartRoundAfterXNumberOfSec
        if (GameAdvancedMapOptionsPage = "2")
        (A_LoopField = "1") ? (LV_Modify(12,, chr(0x2705))) : (LV_Modify(12,, chr(0x1F7E9)))
        case 101:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, MaxIdleTime
        if (GameAdvancedMapOptionsPage = "3")
        (A_LoopField = "1") ? (LV_Modify(1,, chr(0x2705))) : (LV_Modify(1,, chr(0x1F7E9)))
        case 102:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, SetGravity
        if (GameAdvancedMapOptionsPage = "3")
        (A_LoopField = "1") ? (LV_Modify(2,, chr(0x2705))) : (LV_Modify(2,, chr(0x1F7E9)))
        case 103:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, SetAirAcceleration
        if (GameAdvancedMapOptionsPage = "3")
        (A_LoopField = "1") ? (LV_Modify(3,, chr(0x2705))) : (LV_Modify(3,, chr(0x1F7E9)))
        case 104:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, SetPlayerAcceleration
        if (GameAdvancedMapOptionsPage = "3")
        (A_LoopField = "1") ? (LV_Modify(4,, chr(0x2705))) : (LV_Modify(4,, chr(0x1F7E9)))
        case 105:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, PlayerRollAngle
        if (GameAdvancedMapOptionsPage = "3")
        (A_LoopField = "1") ? (LV_Modify(5,, chr(0x2705))) : (LV_Modify(5,, chr(0x1F7E9)))
        case 106:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, RollAngleSpeed
        if (GameAdvancedMapOptionsPage = "3")
        (A_LoopField = "1") ? (LV_Modify(6,, chr(0x2705))) : (LV_Modify(6,, chr(0x1F7E9)))
        case 107:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, RedTeamDmgMultiplier
        if (GameAdvancedMapOptionsPage = "3")
        (A_LoopField = "1") ? (LV_Modify(7,, chr(0x2705))) : (LV_Modify(7,, chr(0x1F7E9)))
        case 108:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, BlueTeamDmgMultiplier
        if (GameAdvancedMapOptionsPage = "3")
        (A_LoopField = "1") ? (LV_Modify(8,, chr(0x2705))) : (LV_Modify(8,, chr(0x1F7E9)))
        case 109:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, Timescale
        if (GameAdvancedMapOptionsPage = "3")
        (A_LoopField = "1") ? (LV_Modify(9,, chr(0x2705))) : (LV_Modify(9,, chr(0x1F7E9)))
        case 110:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, TeamBalanceLimit
        if (GameAdvancedMapOptionsPage = "3")
        (A_LoopField = "1") ? (LV_Modify(10,, chr(0x2705))) : (LV_Modify(10,, chr(0x1F7E9)))
        case 111:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, RoundLimit
        if (GameAdvancedMapOptionsPage = "3")
        (A_LoopField = "1") ? (LV_Modify(11,, chr(0x2705))) : (LV_Modify(11,, chr(0x1F7E9)))
        case 112:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, MapTimelimit
        if (GameAdvancedMapOptionsPage = "3")
        (A_LoopField = "1") ? (LV_Modify(12,, chr(0x2705))) : (LV_Modify(12,, chr(0x1F7E9)))
        case 113:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, StalemateTimelimit
        if (GameAdvancedMapOptionsPage = "4")
        (A_LoopField = "1") ? (LV_Modify(1,, chr(0x2705))) : (LV_Modify(1,, chr(0x1F7E9)))
        case 114:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, RestartRoundAfterXNumberOfSecValue
        if (GameAdvancedMapOptionsPage = "2")
        LV_Modify(12,,,, A_LoopField)
        case 115:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, MaxIdleTimeValue
        if (GameAdvancedMapOptionsPage = "3")
        LV_Modify(1,,,, A_LoopField)
        case 116:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, SetGravityValue
        case 117:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, SetAirAccelerationValue
        case 118:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, SetPlayerAccelerationValue
        case 119:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, PlayerRollAngleValue
        case 120:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, RollAngleSpeedValue
        case 121:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, RedTeamDmgMultiplierValue
        case 122:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, BlueTeamDmgMultiplierValue
        case 123:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, TimescaleValue
        case 124:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, TeamBalanceLimitValue
        case 125:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, RoundLimitValue
        case 126:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, MapTimelimitValue
        case 127:
        IniWrite, % A_LoopField, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, StalemateTimelimitValue
        case 128:
        FileDelete, %A_ScriptDir%/Server Boss All/Custom startup commands.cfg
        FileAppend, % RegExReplace(A_LoopField, "&", "`n"), %A_ScriptDir%/Server Boss All/Custom startup commands.cfg
    }
}
gosub, ReadAdvancedSettingsFromINI
gosub, ApplyAdvancedSettingsFromINI
gosub, ApplyCustomStartupCommands
GuiControl, GameAdvancedWindowPresets:enable, SelectServerPresetListListboxVar
GuiControl, GameAdvancedWindowPresets:enable, SelectServerPresetApplyPresetPictureButtonVar
return

SelectServerPresetClearCustomPresetNameText:
EmulateConsoleButtonPress("GameAdvancedWindowPresets", "SelectServerPresetClearCustomPresetNameTextVar", "x")
GuiControl, GameAdvancedWindowPresets:, SelectServerPresetCustomPresetNameEditVar
return

SelectServerPresetApplyCustomPresetCodePictureButton:
gui, GameAdvancedWindowPresets:submit, nohide
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Left_arrow_pic_button", "GameAdvancedWindowPresets", "SelectServerPresetApplyCustomPresetCodePictureButtonVar")
if (SelectServerPresetCustomPresetNameEditVar = "")
DisplayTooltip("Custom preset name is empty!", 3)
else if (SelectServerPresetCustomPresetEditVar = "")
DisplayTooltip("Custom preset code field is empty!", 3)
else
{
    guiControl, GameAdvancedWindowPresets:, SelectServerPresetListListboxVar, % SelectServerPresetCustomPresetNameEditVar
    FileDelete, %A_ScriptDir%/Server Boss All/Presets/Advanced/%SelectServerPresetCustomPresetNameEditVar%.txt
    FileAppend, %PresetCode%, %A_ScriptDir%/Server Boss All/Presets/Advanced/%SelectServerPresetCustomPresetNameEditVar%.txt
    guicontrol, GameAdvancedWindowPresets:, SelectServerPresetCustomPresetNameEditVar
}
return

SelectServerPresetCopyCustomPresetToClipboardText:
gui, GameAdvancedWindowPresets:submit, nohide
EmulateConsoleButtonPress("GameAdvancedWindowPresets", "SelectServerPresetCopyCustomPresetToClipboardTextVar", Chr(0x1F4CB))
Clipboard := SelectServerPresetCustomPresetEditVar
return

SelectServerPresetCopyGeneratePresetCodeToClipboardText:
gui, GameAdvancedWindowPresets:submit, nohide
EmulateConsoleButtonPress("GameAdvancedWindowPresets", "SelectServerPresetCopyGeneratePresetCodeToClipboardTextVar", Chr(0x1F4CB))
Clipboard := SelectServerHostGeneratePresetCodeEditVar
return

SelectServerPresetRestoreAllAdvancedTabPictureButton:
GuiControl, GameAdvancedWindowPresets:, SelectServerPresetRestoreAllAdvancedTabPictureButtonVar, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Game_advanced_restore_defaults_pic_button_pressed.png
GuiControl, GameAdvancedWindowPresets:disable, SelectServerPresetRestoreCurrentAdvancedTabPictureButtonVar
gosub, RestoreAdvancedServerTab
gosub, RestoreAdvancedConnectionTab
gosub, RestoreAdvancedSourceTVTab
gosub, RestoreAdvancedVotesTab
gosub, RestoreAdvancedMapTab
GuiControl, GameAdvancedWindowPresets:, SelectServerPresetRestoreAllAdvancedTabPictureButtonVar, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Game_advanced_restore_defaults_pic_button_pressed.png
GuiControl, GameAdvancedWindowPresets:enable, SelectServerPresetRestoreCurrentAdvancedTabPictureButtonVar
return

SelectServerPresetRestoreCurrentAdvancedTabPictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Restore_pic_button", "GameAdvancedWindowPresets", "SelectServerPresetRestoreCurrentAdvancedTabPictureButtonVar")
if (AdvancedWindowCurrentTab = "Server")
gosub, RestoreAdvancedServerTab
else if (AdvancedWindowCurrentTab = "Connection")
gosub, RestoreAdvancedConnectionTab
else if (AdvancedWindowCurrentTab = "SourceTV")
gosub, RestoreAdvancedSourceTVTab
else if (AdvancedWindowCurrentTab = "Votes")
gosub, RestoreAdvancedVotesTab
else if (AdvancedWindowCurrentTab = "Map")
gosub, RestoreAdvancedMapTab
return

RestoreAdvancedServerTab:
IniWrite, 0, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, AllowDownload
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "AllowDownload", "AdvancedWindowAllowDownloadPictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
IniWrite, 0, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, AllowUpload
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "AllowUpload", "AdvancedWindowAllowUploadPictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
IniWrite, 1, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, HideServer
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "HideServer", "AdvancedWindowHideServerPictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
IniWrite, 1, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, DisableVAC
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "DisableVAC", "AdvancedWindowDisableVACPictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
IniWrite, 0, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EnableAllTalk
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "EnableAllTalk", "AdvancedWindowEnableAllTalkPictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
IniWrite, 1, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EnableCheats
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "EnableCheats", "AdvancedWindowEnableCheatsPictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
IniWrite, 0, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EmptyToggle1
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "EmptyToggle1", "AdvancedWindowEmptyToggle1PictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button_empty.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
IniWrite, 0, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EmptyToggle2
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "EmptyToggle2", "AdvancedWindowEmptyToggle2PictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button_empty.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
IniWrite, 0, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EmptyToggle3
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "EmptyToggle3", "AdvancedWindowEmptyToggle3PictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button_empty.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
IniWrite, 0, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EmptyToggle4
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "EmptyToggle4", "AdvancedWindowEmptyToggle4PictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button_empty.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
IniWrite, 0, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EmptyToggle5
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "EmptyToggle5", "AdvancedWindowEmptyToggle5PictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button_empty.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
IniWrite, 0, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EmptyToggle6
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "EmptyToggle6", "AdvancedWindowEmptyToggle6PictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button_empty.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
GuiControl, GameAdvancedWindow:, AdvancedWindowServerTagsEditVar
IniWrite, % "", %A_scriptdir%\Server Boss All\Settings.ini, Advanced, ServerTags
GuiControl, GameAdvancedWindow:, AdvancedWindowServerTokenEditVar
IniWrite, % "", %A_scriptdir%\Server Boss All\Settings.ini, Advanced, ServerToken
GuiControl, GameAdvancedWindow:, AdvancedWindowFastDLURLEditVar
IniWrite, % "", %A_scriptdir%\Server Boss All\Settings.ini, Advanced, FastDLURL
GuiControl, GameAdvancedWindow:, AdvancedWindowRconPasswordEditVar, password
IniWrite, % "password", %A_scriptdir%\Server Boss All\Settings.ini, Advanced, RconPassword
gosub, AdvancedWindowSVPureMinus1Text
return

RestoreAdvancedConnectionTab:
gosub, AdvancedWindowServerTypeSDRText
gosub, AdvancedWindowRegionWorldText
GuiControl, GameAdvancedWindow:, AdvancedWindowMaxRateEditVar
IniWrite, % "", %A_scriptdir%\Server Boss All\Settings.ini, Advanced, MaxRate
GuiControl, GameAdvancedWindow:, AdvancedWindowMinRateEditVar
IniWrite, % "", %A_scriptdir%\Server Boss All\Settings.ini, Advanced, MinRate
GuiControl, GameAdvancedWindow:, AdvancedWindowMaxUpdateRateEditVar
IniWrite, % "", %A_scriptdir%\Server Boss All\Settings.ini, Advanced, MaxUpdateRate
GuiControl, GameAdvancedWindow:, AdvancedWindowMinUpdateRateEditVar
IniWrite, % "", %A_scriptdir%\Server Boss All\Settings.ini, Advanced, MinUpdateRate
GuiControl, GameAdvancedWindow:, AdvancedWindowMaxCMDRateEditVar
IniWrite, % "", %A_scriptdir%\Server Boss All\Settings.ini, Advanced, MaxCMDRate
GuiControl, GameAdvancedWindow:, AdvancedWindowMinCMDRateEditVar
IniWrite, % "", %A_scriptdir%\Server Boss All\Settings.ini, Advanced, MinCMDRate
GuiControl, GameAdvancedWindow:, AdvancedWindowCustomAddressEditVar
IniWrite, % "", %A_scriptdir%\Server Boss All\Settings.ini, Advanced, CustomAddress
GuiControl, GameAdvancedWindow:, AdvancedWindowUDPPortEditVar
IniWrite, % "", %A_scriptdir%\Server Boss All\Settings.ini, Advanced, UDPPortFromINI
return

RestoreAdvancedSourceTVTab:
IniWrite, 0, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EnableSourceTv
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "EnableSourceTv", "AdvancedWindowEnableSourceTvPictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
IniWrite, 0, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, UsePlayerAsCamera
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "UsePlayerAsCamera", "AdvancedWindowUsePlayersAsCameraPictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
IniWrite, 0, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, PlayVoice
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "PlayVoice", "AdvancedWindowPlayVoicePictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
IniWrite, 1, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, AutoRecordAllGames
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "AutoRecordAllGames", "AdvancedWindowAutoRecordAllGamesPictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
IniWrite, 0, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, TransmitAllEntities
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "TransmitAllEntities", "AdvancedWindowTransmitAllEntitiesPictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
IniWrite, 1, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, DelayMapChange
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "DelayMapChange", "AdvancedWindowDelayMapChangePictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
IniWrite, 0, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EmptyToggle7
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "EmptyToggle7", "AdvancedWindowEmptyToggle7PictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button_empty.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button_empty.png")
IniWrite, 0, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EmptyToggle8
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "EmptyToggle8", "AdvancedWindowEmptyToggle8PictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button_empty.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button_empty.png")
IniWrite, 0, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EmptyToggle9
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "EmptyToggle9", "AdvancedWindowEmptyToggle9PictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button_empty.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button_empty.png")
IniWrite, 0, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EmptyToggle10
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "EmptyToggle10", "AdvancedWindowEmptyToggle10PictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button_empty.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button_empty.png")
IniWrite, 0, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EmptyToggle11
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "EmptyToggle11", "AdvancedWindowEmptyToggle11PictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button_empty.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button_empty.png")
IniWrite, 0, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EmptyToggle12
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "EmptyToggle12", "AdvancedWindowEmptyToggle12PictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button_empty.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button_empty.png")
IniWrite, 0, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EmptyToggle13
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "EmptyToggle13", "AdvancedWindowEmptyToggle13PictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button_empty.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button_empty.png")
IniWrite, 0, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EmptyToggle14
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "EmptyToggle14", "AdvancedWindowEmptyToggle14PictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button_empty.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button_empty.png")
GuiControl, GameAdvancedWindow:, AdvancedWindowSTVNameEditVar, Camera
IniWrite, % "Camera", %A_scriptdir%\Server Boss All\Settings.ini, Advanced, STVName
GuiControl, GameAdvancedWindow:, AdvancedWindowSTVPasswordEditVar, password
IniWrite, % "password", %A_scriptdir%\Server Boss All\Settings.ini, Advanced, STVPassword
GuiControl, GameAdvancedWindow:, AdvancedWindowSTVSnapShotRateEditVar
IniWrite, % "", %A_scriptdir%\Server Boss All\Settings.ini, Advanced, STVSnapShotRate
GuiControl, GameAdvancedWindow:, AdvancedWindowSTVDelayEditVar
IniWrite, % "", %A_scriptdir%\Server Boss All\Settings.ini, Advanced, STVDelay
GuiControl, GameAdvancedWindow:, AdvancedWindowSTVPortEditVar
IniWrite, % "", %A_scriptdir%\Server Boss All\Settings.ini, Advanced, STVPort
GuiControl, GameAdvancedWindow:, AdvancedWindowTimeoutEditVar
IniWrite, % "", %A_scriptdir%\Server Boss All\Settings.ini, Advanced, Timeout
GuiControl, GameAdvancedWindow:, AdvancedWindowMaxNumOfClientsEditVar, 0
IniWrite, % "0", %A_scriptdir%\Server Boss All\Settings.ini, Advanced, MaxNumOfClients
return

RestoreAdvancedVotesTab:
IniWrite, 0, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, AllowVoting
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "AllowVoting", "AdvancedWindowAllowVotingPictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
IniWrite, 1, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, AllowSpectatorsToVote
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "AllowSpectatorsToVote", "AdvancedWindowAllowSpectatorsToVotePictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
IniWrite, 1, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, AllowBotsToVote
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "AllowBotsToVote", "AdvancedWindowAllowBotsToVotePictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
IniWrite, 1, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EnableAutoTeamBalanceVotes
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "EnableAutoTeamBalanceVotes", "AdvancedWindowEnableAutoTeamBalanceVotesPictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
IniWrite, 0, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, AllowChangeLevelVotes
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "AllowChangeLevelVotes", "AdvancedWindowAllowChangeLevelVotesPictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
IniWrite, 1, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, AllowPerClassLimitVotes
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "AllowPerClassLimitVotes", "AdvancedWindowAllowPerClassLimitVotesPictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
IniWrite, 0, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, AllowNextLevelVotes
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "AllowNextLevelVotes", "AdvancedWindowAllowNextLevelVotesPictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
IniWrite, 0, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EnableVoteKick
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "EnableVoteKick", "AdvancedWindowEnableVoteKickPictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
IniWrite, 1, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, AllowVoteKickSpectatorsInMvM
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "AllowVoteKickSpectatorsInMvM", "AdvancedWindowAllowVoteKickSpectatorsInMvMPictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
IniWrite, 0, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, AllowSetMvMChallengeLevelVotes
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "AllowSetMvMChallengeLevelVotes", "AdvancedWindowAllowSetMvMChallengeLevelVotesPictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
IniWrite, 0, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, ForceYesForVoteCallers
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "ForceYesForVoteCallers", "AdvancedWindowAutomaticallyChooseYesForVoteCallersPictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
IniWrite, 0, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, AllowExtendCurrentLevelVotes
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "AllowExtendCurrentLevelVotes", "AdvancedWindowAllowExtendCurrentMapVotesPictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
IniWrite, 0, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, PresentTheLowestPlaytimeMapsList
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "PresentTheLowestPlaytimeMapsList", "AdvancedWindowPresentTheLowestPlaytimeMapsListPictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
IniWrite, 0, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, PreventNextLevelVotesIfOneHasBeenSet
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "PreventNextLevelVotesIfOneHasBeenSet", "AdvancedWindowPreventNextLevelVotesIfOneHasBeenSetPictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
IniWrite, 0, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, AllowRestartGameVotes
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "AllowRestartGameVotes", "AdvancedWindowAllowRestartGameVotesPictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
IniWrite, 0, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, AllowVoteScramble
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "AllowVoteScramble", "AdvancedWindowAllowVoteScramblePictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
IniWrite, 0, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, ShowDisabledVotesInTheVoteMenu
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "ShowDisabledVotesInTheVoteMenu", "AdvancedWindowShowDisabledVotesInTheVoteMenuPictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
IniWrite, 1, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, AllowPauseGameVotes
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "AllowPauseGameVotes", "AdvancedWindowAllowPauseGameVotesPictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
IniWrite, 0, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EmptyToggle15
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "EmptyToggle15", "AdvancedWindowEmptyToggle15PictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button_empty.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button_empty.png")
IniWrite, 0, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EmptyToggle16
ToggleButtonAnimation("GameAdvancedWindow", "Advanced", "EmptyToggle16", "AdvancedWindowEmptyToggle16PictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button_empty.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button_empty.png")
IniWrite, 0, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EmptyToggle17
return

RestoreAdvancedMapTab:
gui GameAdvancedWindow:default
gui, GameAdvancedWindow:ListView, GameAdvancedMapOptionsPageLVVar
IniWrite, 1, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, AllowSpectators
IniWrite, 1, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, ShowVoiceChatIcons
IniWrite, 0, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, DisableRespawnTime
IniWrite, 0, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, RestrictTo1ClassOnly
IniWrite, 1, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EnableTeammatesPushAway
IniWrite, 1, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EnableRandomCrits
IniWrite, 0, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, SpawnBeachBallOnRoundStart
IniWrite, 0, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EnableGrapplingHook
IniWrite, 0, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EnableMannpowerMode
IniWrite, 0, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EnableMedievalMode
IniWrite, 0, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EnableMedievalAutorp
IniWrite, 0, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, FadeToBlackForSpectators

IniWrite, 0, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EnableFriendlyFire
IniWrite, 0, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EnableTauntSliding
IniWrite, 0, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, AllowWeaponSwitchWhileTaunting
IniWrite, 0, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EnableBulletSpread
IniWrite, 1, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, AllowsLivingPlayersToHearDeadPlayers
IniWrite, 0, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, AllowsTruceDuringBossBattle
IniWrite, 0, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, TurnPlayersIntoLosers
IniWrite, 1, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, PreventPlayerMovementDuringStartup
IniWrite, 0, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EnableSpells
IniWrite, 1, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EnableTeamBalancing
IniWrite, 1, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EnableSuddenDeath
IniWrite, 0, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, RestartRoundAfterXNumberOfSec

IniWrite, 1, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, MaxIdleTime
IniWrite, 0, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, SetGravity
IniWrite, 0, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, SetAirAcceleration
IniWrite, 0, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, SetPlayerAcceleration
IniWrite, 0, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, PlayerRollAngle
IniWrite, 0, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, RollAngleSpeed
IniWrite, 0, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, RedTeamDmgMultiplier
IniWrite, 0, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, BlueTeamDmgMultiplier
IniWrite, 0, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, Timescale
IniWrite, 1, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, TeamBalanceLimit
IniWrite, 1, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, RoundLimit
IniWrite, 1, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, MapTimelimit

IniWrite, 1, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, StalemateTimelimit

IniWrite, 0, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, RestartRoundAfterXNumberOfSecValue
IniWrite, 10, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, MaxIdleTimeValue
IniWrite, 800, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, SetGravityValue
IniWrite, 10, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, SetAirAccelerationValue
IniWrite, 10, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, SetPlayerAccelerationValue
IniWrite, 0, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, PlayerRollAngleValue
IniWrite, 200, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, RollAngleSpeedValue
IniWrite, 1.0, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, RedTeamDmgMultiplierValue
IniWrite, 1.0, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, BlueTeamDmgMultiplierValue
IniWrite, 1.0, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, TimescaleValue
IniWrite, 1, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, TeamBalanceLimitValue
IniWrite, 0, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, RoundLimitValue
IniWrite, 180, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, MapTimelimitValue
IniWrite, 240, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, StalemateTimelimitValue

if (GameAdvancedMapOptionsPage = "1")
{
    LV_Modify(1,, chr(0x1F7E9))
    LV_Modify(2,, chr(0x2705))
    LV_Modify(3,, chr(0x1F7E9))
    LV_Modify(4,, chr(0x1F7E9))
    LV_Modify(5,, chr(0x2705))
    LV_Modify(6,, chr(0x2705))
    LV_Modify(7,, chr(0x1F7E9))
    LV_Modify(8,, chr(0x1F7E9))
    LV_Modify(9,, chr(0x1F7E9))
    LV_Modify(10,, chr(0x1F7E9))
    LV_Modify(11,, chr(0x1F7E9))
    LV_Modify(12,, chr(0x1F7E9))
}
else if (GameAdvancedMapOptionsPage = "2")
{
    LV_Modify(1,, chr(0x1F7E9))
    LV_Modify(2,, chr(0x1F7E9))
    LV_Modify(3,, chr(0x1F7E9))
    LV_Modify(4,, chr(0x1F7E9))
    LV_Modify(5,, chr(0x2705))
    LV_Modify(6,, chr(0x1F7E9))
    LV_Modify(7,, chr(0x2705))
    LV_Modify(8,, chr(0x1F7E9))
    LV_Modify(9,, chr(0x1F7E9))
    LV_Modify(10,, chr(0x2705))
    LV_Modify(11,, chr(0x2705))
    LV_Modify(12,, chr(0x1F7E9))
}
else if (GameAdvancedMapOptionsPage = "3")
{
    LV_Modify(1,, chr(0x2705))
    LV_Modify(2,, chr(0x1F7E9))
    LV_Modify(3,, chr(0x1F7E9))
    LV_Modify(4,, chr(0x1F7E9))
    LV_Modify(5,, chr(0x1F7E9))
    LV_Modify(6,, chr(0x1F7E9))
    LV_Modify(7,, chr(0x1F7E9))
    LV_Modify(8,, chr(0x1F7E9))
    LV_Modify(9,, chr(0x1F7E9))
    LV_Modify(10,, chr(0x2705))
    LV_Modify(11,, chr(0x2705))
    LV_Modify(12,, chr(0x2705))
}
else if (GameAdvancedMapOptionsPage = "4")
{
    LV_Modify(1,, chr(0x2705))
}
return

SelectServerPresetGeneratePresetCodePictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Paths_cog_wheel_pic_button", "GameAdvancedWindowPresets", "SelectServerPresetGeneratePresetCodePictureButtonVar")
gosub, ReadAdvancedSettingsFromINI
gosub, AdvancedGeneratePresetCode
GuiControl, GameAdvancedWindowPresets:, SelectServerHostGeneratePresetCodeEditVar, % PresetCode
return

ToggleListboxCheckbox(GuiName, INISection, INIKey, ListviewRowNumber, ListviewColumnNumber) {
    gui, %GuiName%:submit, nohide
    IniRead, ListboxCheckboxValue, %A_scriptdir%\Server Boss All\Settings.ini, %INISection%, %INIKey%
    if (ListboxCheckboxValue = "1")
    {
        IniWrite, 0, %A_scriptdir%\Server Boss All\Settings.ini, %INISection%, %INIKey%
        LV_Modify(ListviewRowNumber, ListviewColumnNumber, chr(0x1F7E9))
    }
    else
    {
        IniWrite, 1, %A_scriptdir%\Server Boss All\Settings.ini, %INISection%, %INIKey%
        LV_Modify(ListviewRowNumber, ListviewColumnNumber, chr(0x2705))
    }
}

RotaryFixedSwitchAnimation(GuiName, ActiveOption, RotarySwitchPictureVar, Text1Var, Text2Var, Text3Var, Text4Var, Text5Var, Text6Var, Text7Var, Text8Var, Text9Var, Text10Var, Text1, Text2, Text3, Text4, Text5, Text6, Text7, Text8, Text9, Text10) {
    GuiControl, %GuiName%:, %RotarySwitchPictureVar%, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Rotary_radio_switch_state_%ActiveOption%_pic_button.png

    gui, %GuiName%:font, cece5cb s12 norm, Impact
    GuiControl, %GuiName%:+cece5cb, % Text1Var
    GuiControl, %GuiName%:, %Text1Var%, % Text1
    GuiControl, %GuiName%:+cece5cb, % Text2Var
    GuiControl, %GuiName%:, %Text2Var%, % Text2
    GuiControl, %GuiName%:+cece5cb, % Text3Var
    GuiControl, %GuiName%:, %Text3Var%, % Text3
    GuiControl, %GuiName%:+cece5cb, % Text4Var
    GuiControl, %GuiName%:, %Text4Var%, % Text4
    GuiControl, %GuiName%:+cece5cb, % Text5Var
    GuiControl, %GuiName%:, %Text5Var%, % Text5
    GuiControl, %GuiName%:+cece5cb, % Text6Var
    GuiControl, %GuiName%:, %Text6Var%, % Text6
    GuiControl, %GuiName%:+cece5cb, % Text7Var
    GuiControl, %GuiName%:, %Text7Var%, % Text7
    GuiControl, %GuiName%:+cece5cb, % Text8Var
    GuiControl, %GuiName%:, %Text8Var%, % Text8
    GuiControl, %GuiName%:+cece5cb, % Text9Var
    GuiControl, %GuiName%:, %Text9Var%, % Text9
    GuiControl, %GuiName%:+cece5cb, % Text10Var
    GuiControl, %GuiName%:, %Text10Var%, % Text10

    switch ActiveOption
    {
        case 1:
        gui, %GuiName%:font, cffffff s12, Impact
        GuiControl, %GuiName%:+cffffff, % Text1Var
        GuiControl, %GuiName%:, %Text1Var%, % Text1
        case 2:
        gui, %GuiName%:font, cffffff s12, Impact
        GuiControl, %GuiName%:+cffffff, % Text2Var
        GuiControl, %GuiName%:, %Text2Var%, % Text2
        case 3:
        gui, %GuiName%:font, cffffff s12, Impact
        GuiControl, %GuiName%:+cffffff, % Text3Var
        GuiControl, %GuiName%:, %Text3Var%, % Text3
        case 4:
        gui, %GuiName%:font, cffffff s12, Impact
        GuiControl, %GuiName%:+cffffff, % Text4Var
        GuiControl, %GuiName%:, %Text4Var%, % Text4
        case 5:
        gui, %GuiName%:font, cffffff s12, Impact
        GuiControl, %GuiName%:+cffffff, % Text5Var
        GuiControl, %GuiName%:, %Text5Var%, % Text5
        case 6:
        gui, %GuiName%:font, cffffff s12, Impact
        GuiControl, %GuiName%:+cffffff, % Text6Var
        GuiControl, %GuiName%:, %Text6Var%, % Text6
        case 7:
        gui, %GuiName%:font, cffffff s12, Impact
        GuiControl, %GuiName%:+cffffff, % Text7Var
        GuiControl, %GuiName%:, %Text7Var%, % Text7
        case 8:
        gui, %GuiName%:font, cffffff s12, Impact
        GuiControl, %GuiName%:+cffffff, % Text8Var
        GuiControl, %GuiName%:, %Text8Var%, % Text8
        case 9:
        gui, %GuiName%:font, cffffff s12, Impact
        GuiControl, %GuiName%:+cffffff, % Text9Var
        GuiControl, %GuiName%:, %Text9Var%, % Text9
        case 10:
        gui, %GuiName%:font, cffffff s12, Impact
        GuiControl, %GuiName%:+cffffff, % Text10Var
        GuiControl, %GuiName%:, %Text10Var%, % Text10
    }
    gui, %GuiName%:font, cece5cb s12 norm, Impact
}

ToggleButtonAnimation(GuiName, INISection, INIKey, ControlName, OnImage, OffImage) {
    gui, %GuiName%:submit, nohide
    Iniread, ControlVariableFromINI, %A_scriptdir%\Server Boss All\Settings.ini, %INISection%, %INIKey%
    if (ControlVariableFromINI = "1")
    {
        GuiControl, %GuiName%:, %ControlName%, % OffImage
        IniWrite, 0, %A_scriptdir%\Server Boss All\Settings.ini, %INISection%, %INIKey%
    }
    else if (ControlVariableFromINI != "1")
    {
        GuiControl, %GuiName%:, %ControlName%, % OnImage
        IniWrite, 1, %A_scriptdir%\Server Boss All\Settings.ini, %INISection%, %INIKey%
    }
    VarSetCapacity(ControlVariableFromINI, 0)
}

;Fix broken listview tabs
;----------------------------------------------------------------------------------------------
FixBrokenLVColumns(DefaultWindow, ListviewInGui, Tab1, Tab2, Tab3, Tab4, Tab5) {
    gui %DefaultWindow%:default
    gui, %DefaultWindow%:ListView, %ListviewInGui%
    LV_ModifyCol(1, Tab1)
    LV_ModifyCol(2, Tab2)
    LV_ModifyCol(3, Tab3)
    LV_ModifyCol(4, Tab4)
    LV_ModifyCol(5, Tab5)
}
;The listview columns may fail to adjust when overlapped with a groupbox

;Close SteamCMD if server boss is closed
;----------------------------------------------------------------------------------------------
ExitFunc(SteamCMDPID) {
    DetectHiddenWindows, on
    WinClose, ahk_pid %SteamCMDPID%
    Process, Close, %SteamCMDPID%
}

;Move window on mouse drag
;----------------------------------------------------------------------------------------------
MoveUI:
PostMessage, 0xA1, 2,,, A
return

;Animate button hover effect
;----------------------------------------------------------------------------------------------
WM_MOUSEMOVE()  {
    gui, MainWindow:submit, nohide
    ;~ if !WinActive("Advanced window presets") and !WinActive("Advanced")
    ;~ {
        ;~ return
    ;~ }
    global CurrentA_GuiControl := A_GuiControl
	static PreviousHoveredControl
    If (A_GuiControl != PreviousHoveredControl)
    {
        RestoreServerToggleButtonsInfoBox := "(1) Allow customization downloads`n(2) Allow customization uploads`n(3) Hide server`n(4) Disable V.A.C`n(5) Enable alltalk`n(6) Enable cheats`n(7) n/a`n(8) n/a`n(9) n/a`n(10) n/a"

		switch PreviousHoveredControl
		{
            case "ToolbarRepoTextVar":
            GuiControl, MainWindow:, ToolbarRepoTextVar, Repo
            case "ToolbarPinWindowTextVar":
            GuiControl, MainWindow:, ToolbarPinWindowTextVar, Pin
            case "ToolbarMinimizeWindowTextVar":
            GuiControl, MainWindow:, ToolbarMinimizeWindowTextVar, Minimize
            case "ToolbarHideWindowTextVar":
            GuiControl, MainWindow:, ToolbarHideWindowTextVar, Hide

            case "GameMapsPreviousPageTextVar":
			GuiControl, MainWindow:+Background221f1c, GameMapsPreviousPageProgressVar
			GuiControl, MainWindow:+c646464, GameMapsPreviousPageTextVar
			GuiControl, MainWindow:, GameMapsPreviousPageTextVar, % Chr(0x2B06)
            case "GameMapsNextPageTextVar":
			GuiControl, MainWindow:+Background221f1c, GameMapsNextPageProgressVar
			GuiControl, MainWindow:+c646464, GameMapsNextPageTextVar
			GuiControl, MainWindow:, GameMapsNextPageTextVar, % Chr(0x2B07)
            case "GameMapsClearMapSearchTextVar":
			GuiControl, MainWindow:+Background221f1c, GameMapsClearMapSearchProgressVar
			GuiControl, MainWindow:+c646464, GameMapsClearMapSearchTextVar
			GuiControl, MainWindow:, GameMapsClearMapSearchTextVar, x
            case "GameSetMaxPlayersForCasualTextVar":
			GuiControl, MainWindow:+c221f1c, GameSetMaxPlayersForCasualProgressVar
			GuiControl, MainWindow:+c646464, GameSetMaxPlayersForCasualTextVar
			GuiControl, MainWindow:, GameSetMaxPlayersForCasualTextVar, Casual
            case "GameSetMaxPlayersForMVMTextVar":
			GuiControl, MainWindow:+c221f1c, GameSetMaxPlayersForMVMProgressVar
			GuiControl, MainWindow:+c646464, GameSetMaxPlayersForMVMTextVar
			GuiControl, MainWindow:, GameSetMaxPlayersForMVMTextVar, MVM
            case "GameGenerateServerPasswordTextVar":
			GuiControl, MainWindow:+c221f1c, GameGenerateServerPasswordProgressVar
			GuiControl, MainWindow:+c646464, GameGenerateServerPasswordTextVar
			GuiControl, MainWindow:, GameGenerateServerPasswordTextVar, % Chr(0x2699)

            case "AdvancedWindowAllowDownloadPictureButtonVar":
            gui GameAdvancedWindow:default
            gui, GameAdvancedWindow:ListView, AdvancedWindowServerTogglesInfoLVVar
            LV_Modify(1, "", "(1) Allow customization downloads")
            case "AdvancedWindowAllowUploadPictureButtonVar":
            gui GameAdvancedWindow:default
            gui, GameAdvancedWindow:ListView, AdvancedWindowServerTogglesInfoLVVar
            LV_Modify(2, "", "(2) Allow customization uploads")
            case "AdvancedWindowHideServerPictureButtonVar":
            gui GameAdvancedWindow:default
            gui, GameAdvancedWindow:ListView, AdvancedWindowServerTogglesInfoLVVar
            LV_Modify(3, "", "(3) Hide server")
            case "AdvancedWindowDisableVACPictureButtonVar":
            gui GameAdvancedWindow:default
            gui, GameAdvancedWindow:ListView, AdvancedWindowServerTogglesInfoLVVar
            LV_Modify(4, "", "(4) Disable V.A.C")
            case "AdvancedWindowEnableAllTalkPictureButtonVar":
            gui GameAdvancedWindow:default
            gui, GameAdvancedWindow:ListView, AdvancedWindowServerTogglesInfoLVVar
            LV_Modify(5, "", "(5) Enable alltalk")
            case "AdvancedWindowEnableCheatsPictureButtonVar":
            gui GameAdvancedWindow:default
            gui, GameAdvancedWindow:ListView, AdvancedWindowServerTogglesInfoLVVar
            LV_Modify(6, "", "(6) Enable cheats")
            case "AdvancedWindowEmptyToggle1PictureButtonVar":
            gui GameAdvancedWindow:default
            gui, GameAdvancedWindow:ListView, AdvancedWindowServerTogglesInfoLVVar
            LV_Modify(7, "", "(7) n/a")
            case "AdvancedWindowEmptyToggle2PictureButtonVar":
            gui GameAdvancedWindow:default
            gui, GameAdvancedWindow:ListView, AdvancedWindowServerTogglesInfoLVVar
            LV_Modify(8, "", "(8) n/a")
            case "AdvancedWindowEmptyToggle3PictureButtonVar":
            gui GameAdvancedWindow:default
            gui, GameAdvancedWindow:ListView, AdvancedWindowServerTogglesInfoLVVar
            LV_Modify(9, "", "(9) n/a")

            case "AdvancedWindowGenerateRconPasswordTextVar":
			GuiControl, GameAdvancedWindow:+Background221f1c, AdvancedWindowGenerateRconPasswordProgressVar
			GuiControl, GameAdvancedWindow:+c646464, AdvancedWindowGenerateRconPasswordTextVar
			GuiControl, GameAdvancedWindow:, AdvancedWindowGenerateRconPasswordTextVar, % Chr(0x2699)

            case "AdvancedWindowSVPureMinus1TextVar":
            GuiControl, GameAdvancedWindow:, AdvancedWindowSVPureMinus1TextVar, Allow file modifications
            case "AdvancedWindowSVPure0TextVar":
            GuiControl, GameAdvancedWindow:, AdvancedWindowSVPure0TextVar, Ban specific user modifications
            case "AdvancedWindowSVPure1TextVar":
            GuiControl, GameAdvancedWindow:, AdvancedWindowSVPure1TextVar, Allow only whitelisted user modifications
            case "AdvancedWindowSVPure2TextVar":
            GuiControl, GameAdvancedWindow:, AdvancedWindowSVPure2TextVar, Ban all user modifications

            case "AdvancedWindowServerTypeSDRTextVar":
            GuiControl, GameAdvancedWindow:, AdvancedWindowServerTypeSDRTextVar, SDR
            case "AdvancedWindowServerTypePublicTextVar":
            GuiControl, GameAdvancedWindow:, AdvancedWindowServerTypePublicTextVar, Public
            case "AdvancedWindowServerTypeLocalTextVar":
            GuiControl, GameAdvancedWindow:, AdvancedWindowServerTypeLocalTextVar, Local

            case "AdvancedWindowRegionWorldTextVar":
            GuiControl, GameAdvancedWindow:, AdvancedWindowRegionWorldTextVar, World
            case "AdvancedWindowRegionUSEastTextVar":
            GuiControl, GameAdvancedWindow:, AdvancedWindowRegionUSEastTextVar, US-East
            case "AdvancedWindowRegionUSWestTextVar":
            GuiControl, GameAdvancedWindow:, AdvancedWindowRegionUSWestTextVar, US-West
            case "AdvancedWindowRegionSouthAmericaTextVar":
            GuiControl, GameAdvancedWindow:, AdvancedWindowRegionSouthAmericaTextVar, South America
            case "AdvancedWindowRegionEuropeTextVar":
            GuiControl, GameAdvancedWindow:, AdvancedWindowRegionEuropeTextVar, Europe
            case "AdvancedWindowRegionAsiaTextVar":
            GuiControl, GameAdvancedWindow:, AdvancedWindowRegionAsiaTextVar, Asia
            case "AdvancedWindowRegionAustraliaTextVar":
            GuiControl, GameAdvancedWindow:, AdvancedWindowRegionAustraliaTextVar, Australia
            case "AdvancedWindowRegionMiddleEastTextVar":
            GuiControl, GameAdvancedWindow:, AdvancedWindowRegionMiddleEastTextVar, Middle East
            case "AdvancedWindowRegionAfricaTextVar":
            GuiControl, GameAdvancedWindow:, AdvancedWindowRegionAfricaTextVar, Africa

            case "AdvancedWindowEnableSourceTvPictureButtonVar":
            gui GameAdvancedWindow:default
            gui, GameAdvancedWindow:ListView, AdvancedWindowSTVTogglesInfoLVVar
            LV_Modify(1, "", "(1) Enable SourceTV")
            case "AdvancedWindowUsePlayersAsCameraPictureButtonVar":
            gui GameAdvancedWindow:default
            gui, GameAdvancedWindow:ListView, AdvancedWindowSTVTogglesInfoLVVar
            LV_Modify(2, "", "(2) Use players as the camera")
            case "AdvancedWindowPlayVoicePictureButtonVar":
            gui GameAdvancedWindow:default
            gui, GameAdvancedWindow:ListView, AdvancedWindowSTVTogglesInfoLVVar
            LV_Modify(3, "", "(3) Play voice")
            case "AdvancedWindowAutoRecordAllGamesPictureButtonVar":
            gui GameAdvancedWindow:default
            gui, GameAdvancedWindow:ListView, AdvancedWindowSTVTogglesInfoLVVar
            LV_Modify(4, "", "(4) Auto-Record all games")
            case "AdvancedWindowTransmitAllEntitiesPictureButtonVar":
            gui GameAdvancedWindow:default
            gui, GameAdvancedWindow:ListView, AdvancedWindowSTVTogglesInfoLVVar
            LV_Modify(5, "", "(5) Transmit all entities")
            case "AdvancedWindowDelayMapChangePictureButtonVar":
            gui GameAdvancedWindow:default
            gui, GameAdvancedWindow:ListView, AdvancedWindowSTVTogglesInfoLVVar
            LV_Modify(6, "", "(6) Delays map change until broadcast is")
            LV_Modify(7, "", "complete")
            case "AdvancedWindowEmptyToggle7PictureButtonVar":
            gui GameAdvancedWindow:default
            gui, GameAdvancedWindow:ListView, AdvancedWindowSTVTogglesInfoLVVar
            LV_Modify(8, "", "(7) n/a")
            case "AdvancedWindowEmptyToggle8PictureButtonVar":
            gui GameAdvancedWindow:default
            gui, GameAdvancedWindow:ListView, AdvancedWindowSTVTogglesInfoLVVar
            LV_Modify(9, "", "(8) n/a")

            case "AdvancedWindowGenerateSTVPasswordTextVar":
			GuiControl, GameAdvancedWindow:+Background221f1c, AdvancedWindowGenerateSTVPasswordProgressVar
			GuiControl, GameAdvancedWindow:+c646464, AdvancedWindowGenerateSTVPasswordTextVar
			GuiControl, GameAdvancedWindow:, AdvancedWindowGenerateSTVPasswordTextVar, % Chr(0x2699)

            case "AdvancedWindowAllowVotingPictureButtonVar":
            gui GameAdvancedWindow:default
            gui, GameAdvancedWindow:ListView, AdvancedWindowVotesTogglesLVVar
            LV_Modify(1, "", "(1) Allow voting")
            case "AdvancedWindowAllowSpectatorsToVotePictureButtonVar":
            gui GameAdvancedWindow:default
            gui, GameAdvancedWindow:ListView, AdvancedWindowVotesTogglesLVVar
            LV_Modify(2, "", "(2) Allow spectators to vote")
            case "AdvancedWindowAllowBotsToVotePictureButtonVar":
            gui GameAdvancedWindow:default
            gui, GameAdvancedWindow:ListView, AdvancedWindowVotesTogglesLVVar
            LV_Modify(3, "", "(3) Allow bots to vote or not")
            case "AdvancedWindowEnableAutoTeamBalanceVotesPictureButtonVar":
            gui GameAdvancedWindow:default
            gui, GameAdvancedWindow:ListView, AdvancedWindowVotesTogglesLVVar
            LV_Modify(4, "", "(4) Allow enable or disable auto team balance votes")
            case "AdvancedWindowAllowChangeLevelVotesPictureButtonVar":
            gui GameAdvancedWindow:default
            gui, GameAdvancedWindow:ListView, AdvancedWindowVotesTogglesLVVar
            LV_Modify(5, "", "(5) Allow players to vote on changing levels")
            case "AdvancedWindowAllowPerClassLimitVotesPictureButtonVar":
            gui GameAdvancedWindow:default
            gui, GameAdvancedWindow:ListView, AdvancedWindowVotesTogglesLVVar
            LV_Modify(6, "", "(6) Allow enable or disable per-class limits votes")
            case "AdvancedWindowAllowNextLevelVotesPictureButtonVar":
            gui GameAdvancedWindow:default
            gui, GameAdvancedWindow:ListView, AdvancedWindowVotesTogglesLVVar
            LV_Modify(7, "", "(7) Allow players to vote on choosing the next level")
            case "AdvancedWindowEnableVoteKickPictureButtonVar":
            gui GameAdvancedWindow:default
            gui, GameAdvancedWindow:ListView, AdvancedWindowVotesTogglesLVVar
            LV_Modify(8, "", "(8) Allow players to call vote kick other players")
            case "AdvancedWindowAllowVoteKickSpectatorsInMvMPictureButtonVar":
            gui GameAdvancedWindow:default
            gui, GameAdvancedWindow:ListView, AdvancedWindowVotesTogglesLVVar
            LV_Modify(9, "", "(9) Allow players to kick spectators in MvM")
            case "AdvancedWindowAllowSetMvMChallengeLevelVotesPictureButtonVar":
            gui GameAdvancedWindow:default
            gui, GameAdvancedWindow:ListView, AdvancedWindowVotesTogglesLVVar
            LV_Modify(10, "", "(10) Allow players to call votes to set the challenge level in mvm")
            case "AdvancedWindowAutomaticallyChooseYesForVoteCallersPictureButtonVar":
            gui GameAdvancedWindow:default
            gui, GameAdvancedWindow:ListView, AdvancedWindowVotesTogglesLVVar
            LV_Modify(11, "", "(11) Automatically choose 'Yes' for vote callers")
            case "AdvancedWindowAllowExtendCurrentMapVotesPictureButtonVar":
            gui GameAdvancedWindow:default
            gui, GameAdvancedWindow:ListView, AdvancedWindowVotesTogglesLVVar
            LV_Modify(12, "", "(12) Allow players to extend the current map")
            case "AdvancedWindowPresentTheLowestPlaytimeMapsListPictureButtonVar":
            gui GameAdvancedWindow:default
            gui, GameAdvancedWindow:ListView, AdvancedWindowVotesTogglesLVVar
            LV_Modify(13, "", "(13) Present players with a list of lowest playtime maps to choose from")
            case "AdvancedWindowPreventNextLevelVotesIfOneHasBeenSetPictureButtonVar":
            gui GameAdvancedWindow:default
            gui, GameAdvancedWindow:ListView, AdvancedWindowVotesTogglesLVVar
            LV_Modify(14, "", "(14) Not allowed to vote for a nextlevel if one has already been set")
            case "AdvancedWindowAllowRestartGameVotesPictureButtonVar":
            gui GameAdvancedWindow:default
            gui, GameAdvancedWindow:ListView, AdvancedWindowVotesTogglesLVVar
            LV_Modify(15, "", "(15) Allow players to call votes to restart the game")
            case "AdvancedWindowAllowVoteScramblePictureButtonVar":
            gui GameAdvancedWindow:default
            gui, GameAdvancedWindow:ListView, AdvancedWindowVotesTogglesLVVar
            LV_Modify(16, "", "(16) Allow players to vote to scramble the teams")
            case "AdvancedWindowShowDisabledVotesInTheVoteMenuPictureButtonVar":
            gui GameAdvancedWindow:default
            gui, GameAdvancedWindow:ListView, AdvancedWindowVotesTogglesLVVar
            LV_Modify(17, "", "(17) Suppress listing of disabled issues in the vote setup screen")
            case "AdvancedWindowAllowPauseGameVotesPictureButtonVar":
            gui GameAdvancedWindow:default
            gui, GameAdvancedWindow:ListView, AdvancedWindowVotesTogglesLVVar
            LV_Modify(18, "", "(18) Allow players to call votes to pause the game")

			case "GameAdvancedMapOptionsPageOptionsPreviousPageTextVar":
			GuiControl, GameAdvancedWindow:+Background221f1c, GameAdvancedMapOptionsPageOptionsPreviousPageProgressVar
			GuiControl, GameAdvancedWindow:+c646464, GameAdvancedMapOptionsPageOptionsPreviousPageTextVar
			GuiControl, GameAdvancedWindow:, GameAdvancedMapOptionsPageOptionsPreviousPageTextVar, % Chr(0x2B06)
  			case "GameAdvancedMapOptionsPageOptionsNextPageTextVar":
			GuiControl, GameAdvancedWindow:+Background221f1c, GameAdvancedMapOptionsPageOptionsNextPageProgressVar
			GuiControl, GameAdvancedWindow:+c646464, GameAdvancedMapOptionsPageOptionsNextPageTextVar
			GuiControl, GameAdvancedWindow:, GameAdvancedMapOptionsPageOptionsNextPageTextVar, % Chr(0x2B07)
            case "GameAdvancedMapOptionsModifyValueTextVar":
			GuiControl, GameAdvancedWindow:+Background221f1c, GameAdvancedMapOptionsModifyValueProgressVar
			GuiControl, GameAdvancedWindow:+c646464, GameAdvancedMapOptionsModifyValueTextVar
			GuiControl, GameAdvancedWindow:, GameAdvancedMapOptionsModifyValueTextVar, % Chr(0x270F)

            case "GameAdvancedLaunchOptionsCopyToClipboardTextVar":
			GuiControl, GameAdvancedWindow:+Background221f1c, GameAdvancedLaunchOptionsCopyToClipboardProgressVar
			GuiControl, GameAdvancedWindow:+c646464, GameAdvancedLaunchOptionsCopyToClipboardTextVar
			GuiControl, GameAdvancedWindow:, GameAdvancedLaunchOptionsCopyToClipboardTextVar, % Chr(0x1F4CB)
            case "GameAdvancedLaunchOptionsRestoreTextVar":
            GuiControl, GameAdvancedWindow:+Background221f1c, GameAdvancedLaunchOptionsRestoreProgressVar
			GuiControl, GameAdvancedWindow:+c646464, GameAdvancedLaunchOptionsRestoreTextVar
			GuiControl, GameAdvancedWindow:, GameAdvancedLaunchOptionsRestoreTextVar, % Chr(0x1F504)

            case "SelectServerPresetRemovePresetPictureButtonVar":
			GuiControl, GameAdvancedWindowPresets:+Background221f1c, SelectServerPresetRemovePresetProgressVar
			GuiControl, GameAdvancedWindowPresets:+c646464, SelectServerPresetRemovePresetPictureButtonVar
			GuiControl, GameAdvancedWindowPresets:, SelectServerPresetRemovePresetPictureButtonVar, -
            case "SelectServerPresetAddPresetPictureButtonVar":
			GuiControl, GameAdvancedWindowPresets:+Background221f1c, SelectServerPresetAddPresetProgressVar
			GuiControl, GameAdvancedWindowPresets:+c646464, SelectServerPresetAddPresetPictureButtonVar
			GuiControl, GameAdvancedWindowPresets:, SelectServerPresetAddPresetPictureButtonVar, +
            case "SelectServerPresetApplyPresetPictureButtonVar":
			GuiControl, GameAdvancedWindowPresets:+Background221f1c, SelectServerPresetApplyPresetProgressVar
			GuiControl, GameAdvancedWindowPresets:+c646464, SelectServerPresetApplyPresetPictureButtonVar
			GuiControl, GameAdvancedWindowPresets:, SelectServerPresetApplyPresetPictureButtonVar, % Chr(0x2935)
            case "SelectServerPresetClearCustomPresetNameTextVar":
            GuiControl, GameAdvancedWindowPresets:+c221f1c, SelectServerPresetClearCustomPresetNameProgressVar
			GuiControl, GameAdvancedWindowPresets:+c646464, SelectServerPresetClearCustomPresetNameTextVar
			GuiControl, GameAdvancedWindowPresets:, SelectServerPresetClearCustomPresetNameTextVar, x
            case "SelectServerPresetCopyCustomPresetToClipboardTextVar":
			GuiControl, GameAdvancedWindowPresets:+c221f1c, SelectServerPresetCopyCustomPresetToClipboardProgressVar
			GuiControl, GameAdvancedWindowPresets:+c646464, SelectServerPresetCopyCustomPresetToClipboardTextVar
			GuiControl, GameAdvancedWindowPresets:, SelectServerPresetCopyCustomPresetToClipboardTextVar, % Chr(0x1F4CB)
            case "SelectServerPresetCopyGeneratePresetCodeToClipboardTextVar":
			GuiControl, GameAdvancedWindowPresets:+c221f1c, SelectServerPresetCopyGeneratePresetCodeToClipboardProgressVar
			GuiControl, GameAdvancedWindowPresets:+c646464, SelectServerPresetCopyGeneratePresetCodeToClipboardTextVar
			GuiControl, GameAdvancedWindowPresets:, SelectServerPresetCopyGeneratePresetCodeToClipboardTextVar, % Chr(0x1F4CB)

            case "ConsoleSendInputTextVar":
			GuiControl, MainWindow:+Background221f1c, ConsoleSendInputProgressVar
			GuiControl, MainWindow:+c646464, ConsoleSendInputTextVar
			GuiControl, MainWindow:, ConsoleSendInputTextVar, >

            case "ConsoleCopyPrivateIPToClipboardTextVar":
			GuiControl, ConsoleFetchIPWindow:+Background221f1c, ConsoleCopyPrivateIPToClipboardProgressVar
			GuiControl, ConsoleFetchIPWindow:+c646464, ConsoleCopyPrivateIPToClipboardTextVar
			GuiControl, ConsoleFetchIPWindow:, ConsoleCopyPrivateIPToClipboardTextVar, % Chr(0x1F4CB)
            case "ConsoleCopyPublicIPToClipboardTextVar":
			GuiControl, ConsoleFetchIPWindow:+Background221f1c, ConsoleCopyPublicIPToClipboardProgressVar
			GuiControl, ConsoleFetchIPWindow:+c646464, ConsoleCopyPublicIPToClipboardTextVar
			GuiControl, ConsoleFetchIPWindow:, ConsoleCopyPublicIPToClipboardTextVar, % Chr(0x1F4CB)
            case "ConsoleCopyFakeIPToClipboardTextVar":
			GuiControl, ConsoleFetchIPWindow:+Background221f1c, ConsoleCopyFakeIPToClipboardProgressVar
			GuiControl, ConsoleFetchIPWindow:+c646464, ConsoleCopyFakeIPToClipboardTextVar
			GuiControl, ConsoleFetchIPWindow:, ConsoleCopyFakeIPToClipboardTextVar, % Chr(0x1F504)

            case "PathsRemoveHostListboxVar":
			GuiControl, MainWindow:+Background221f1c, PathsRemoveHostProgressVar
			GuiControl, MainWindow:+c646464, PathsRemoveHostListboxVar
			GuiControl, MainWindow:, PathsRemoveHostListboxVar, -
            case "PathsAddHostTextButtonVar":
			GuiControl, MainWindow:+Background221f1c, PathsAddHostProgressVar
			GuiControl, MainWindow:+c646464, PathsAddHostTextButtonVar
			GuiControl, MainWindow:, PathsAddHostTextButtonVar, +
            case "PathsEditPathTextVar":
			GuiControl, MainWindow:+Background221f1c, PathsEditPathProgressVar
			GuiControl, MainWindow:+c646464, PathsEditPathTextVar
			GuiControl, MainWindow:, PathsEditPathTextVar, % Chr(0x270F)
            case "PathOpenPathTextVar":
			GuiControl, MainWindow:+Background221f1c, PathOpenPathProgressVar
			GuiControl, MainWindow:+c646464, PathOpenPathTextVar
			GuiControl, MainWindow:, PathOpenPathTextVar,  % Chr(0x1F4C2)
            case "PathInfoTextVar":
			GuiControl, MainWindow:+Background221f1c, PathInfoProgressVar
			GuiControl, MainWindow:+c646464, PathInfoTextVar
			GuiControl, MainWindow:, PathInfoTextVar, ?
        }
        PreviousHoveredControl := A_GuiControl  ;======================================================================
		switch A_GuiControl
		{
            case "ToolbarRepoTextVar":
            GuiControl, MainWindow:, ToolbarRepoTextVar, [Repo]
            case "ToolbarPinWindowTextVar":
            GuiControl, MainWindow:, ToolbarPinWindowTextVar, [Pin]
            case "ToolbarMinimizeWindowTextVar":
            GuiControl, MainWindow:, ToolbarMinimizeWindowTextVar, [Minimize]
            case "ToolbarHideWindowTextVar":
            GuiControl, MainWindow:, ToolbarHideWindowTextVar, [Hide]

            case "GameMapsPreviousPageTextVar":
			GuiControl, MainWindow:+Background646464 , GameMapsPreviousPageProgressVar
			GuiControl, MainWindow:+c221f1c, GameMapsPreviousPageTextVar
			GuiControl, MainWindow:, GameMapsPreviousPageTextVar, % Chr(0x2B06)
            case "GameMapsNextPageTextVar":
			GuiControl, MainWindow:+Background646464 , GameMapsNextPageProgressVar
			GuiControl, MainWindow:+c221f1c, GameMapsNextPageTextVar
			GuiControl, MainWindow:, GameMapsNextPageTextVar, % Chr(0x2B07)
            case "GameMapsClearMapSearchTextVar":
			GuiControl, MainWindow:+Background646464, GameMapsClearMapSearchProgressVar
			GuiControl, MainWindow:+c221f1c, GameMapsClearMapSearchTextVar
			GuiControl, MainWindow:, GameMapsClearMapSearchTextVar, x
            case "GameSetMaxPlayersForCasualTextVar":
			GuiControl, MainWindow:+c646464, GameSetMaxPlayersForCasualProgressVar
			GuiControl, MainWindow:+c221f1c, GameSetMaxPlayersForCasualTextVar
			GuiControl, MainWindow:, GameSetMaxPlayersForCasualTextVar, Casual
            case "GameSetMaxPlayersForMVMTextVar":
			GuiControl, MainWindow:+c646464, GameSetMaxPlayersForMVMProgressVar
			GuiControl, MainWindow:+c221f1c, GameSetMaxPlayersForMVMTextVar
			GuiControl, MainWindow:, GameSetMaxPlayersForMVMTextVar, MVM
            case "GameGenerateServerPasswordTextVar":
			GuiControl, MainWindow:+c646464, GameGenerateServerPasswordProgressVar
			GuiControl, MainWindow:+c221f1c, GameGenerateServerPasswordTextVar
			GuiControl, MainWindow:, GameGenerateServerPasswordTextVar, % Chr(0x2699)

            case "GameMapCycleClearSearchMapEditVar":
			GuiControl, GameMapCycleWindow:+Background646464, GameMapCycleClearSearchMapProgressVar
			GuiControl, GameMapCycleWindow:+c221f1c, GameMapCycleClearSearchMapEditVar
			GuiControl, GameMapCycleWindow:, GameMapCycleClearSearchMapEditVar, x

            case "AdvancedWindowAllowDownloadPictureButtonVar":
            gui GameAdvancedWindow:default
            gui, GameAdvancedWindow:ListView, AdvancedWindowServerTogglesInfoLVVar
            LV_Modify(1, "", "(1) [Allow customization downloads]")
            case "AdvancedWindowAllowUploadPictureButtonVar":
            gui GameAdvancedWindow:default
            gui, GameAdvancedWindow:ListView, AdvancedWindowServerTogglesInfoLVVar
            LV_Modify(2, "", "(2) [Allow customization uploads]")
            case "AdvancedWindowHideServerPictureButtonVar":
            gui GameAdvancedWindow:default
            gui, GameAdvancedWindow:ListView, AdvancedWindowServerTogglesInfoLVVar
            LV_Modify(3, "", "(3) [Hide server]")
            case "AdvancedWindowDisableVACPictureButtonVar":
            gui GameAdvancedWindow:default
            gui, GameAdvancedWindow:ListView, AdvancedWindowServerTogglesInfoLVVar
            LV_Modify(4, "", "(4) [Disable V.A.C]")
            case "AdvancedWindowEnableAllTalkPictureButtonVar":
            gui GameAdvancedWindow:default
            gui, GameAdvancedWindow:ListView, AdvancedWindowServerTogglesInfoLVVar
            LV_Modify(5, "", "(5) [Enable alltalk]")
            case "AdvancedWindowEnableCheatsPictureButtonVar":
            gui GameAdvancedWindow:default
            gui, GameAdvancedWindow:ListView, AdvancedWindowServerTogglesInfoLVVar
            LV_Modify(6, "", "(6) [Enable cheats]")
            case "AdvancedWindowEmptyToggle1PictureButtonVar":
            gui GameAdvancedWindow:default
            gui, GameAdvancedWindow:ListView, AdvancedWindowServerTogglesInfoLVVar
            LV_Modify(7, "", "(7) [n/a]")
            case "AdvancedWindowEmptyToggle2PictureButtonVar":
            gui GameAdvancedWindow:default
            gui, GameAdvancedWindow:ListView, AdvancedWindowServerTogglesInfoLVVar
            LV_Modify(8, "", "(8) [n/a]")
            case "AdvancedWindowEmptyToggle3PictureButtonVar":
            gui GameAdvancedWindow:default
            gui, GameAdvancedWindow:ListView, AdvancedWindowServerTogglesInfoLVVar
            LV_Modify(9, "", "(9) [n/a]")

            case "AdvancedWindowGenerateRconPasswordTextVar":
			GuiControl, GameAdvancedWindow:+Background646464, AdvancedWindowGenerateRconPasswordProgressVar
			GuiControl, GameAdvancedWindow:+c221f1c, AdvancedWindowGenerateRconPasswordTextVar
			GuiControl, GameAdvancedWindow:, AdvancedWindowGenerateRconPasswordTextVar, % Chr(0x2699)

            case "AdvancedWindowSVPureMinus1TextVar":
            GuiControl, GameAdvancedWindow:, AdvancedWindowSVPureMinus1TextVar, [Allow file modifications]
            case "AdvancedWindowSVPure0TextVar":
            GuiControl, GameAdvancedWindow:, AdvancedWindowSVPure0TextVar, [Ban specific user modifications]
            case "AdvancedWindowSVPure1TextVar":
            GuiControl, GameAdvancedWindow:, AdvancedWindowSVPure1TextVar, [Allow only whitelisted user modifications]
            case "AdvancedWindowSVPure2TextVar":
            GuiControl, GameAdvancedWindow:, AdvancedWindowSVPure2TextVar, [Ban all user modifications]

            case "AdvancedWindowServerTypeSDRTextVar":
            GuiControl, GameAdvancedWindow:, AdvancedWindowServerTypeSDRTextVar, [SDR]
            case "AdvancedWindowServerTypePublicTextVar":
            GuiControl, GameAdvancedWindow:, AdvancedWindowServerTypePublicTextVar, [Public]
            case "AdvancedWindowServerTypeLocalTextVar":
            GuiControl, GameAdvancedWindow:, AdvancedWindowServerTypeLocalTextVar, [Local]

            case "AdvancedWindowRegionWorldTextVar":
            GuiControl, GameAdvancedWindow:, AdvancedWindowRegionWorldTextVar, [World]
            case "AdvancedWindowRegionUSEastTextVar":
            GuiControl, GameAdvancedWindow:, AdvancedWindowRegionUSEastTextVar, [US-East]
            case "AdvancedWindowRegionUSWestTextVar":
            GuiControl, GameAdvancedWindow:, AdvancedWindowRegionUSWestTextVar, [US-West]
            case "AdvancedWindowRegionSouthAmericaTextVar":
            GuiControl, GameAdvancedWindow:, AdvancedWindowRegionSouthAmericaTextVar, [South America]
            case "AdvancedWindowRegionEuropeTextVar":
            GuiControl, GameAdvancedWindow:, AdvancedWindowRegionEuropeTextVar, [Europe]
            case "AdvancedWindowRegionAsiaTextVar":
            GuiControl, GameAdvancedWindow:, AdvancedWindowRegionAsiaTextVar, [Asia]
            case "AdvancedWindowRegionAustraliaTextVar":
            GuiControl, GameAdvancedWindow:, AdvancedWindowRegionAustraliaTextVar, [Australia]
            case "AdvancedWindowRegionMiddleEastTextVar":
            GuiControl, GameAdvancedWindow:, AdvancedWindowRegionMiddleEastTextVar, [Middle East]
            case "AdvancedWindowRegionAfricaTextVar":
            GuiControl, GameAdvancedWindow:, AdvancedWindowRegionAfricaTextVar, [Africa]

            case "AdvancedWindowEnableSourceTvPictureButtonVar":
            gui GameAdvancedWindow:default
            gui, GameAdvancedWindow:ListView, AdvancedWindowSTVTogglesInfoLVVar
            LV_Modify(1, "", "(1) [Enable SourceTV]")
            case "AdvancedWindowUsePlayersAsCameraPictureButtonVar":
            gui GameAdvancedWindow:default
            gui, GameAdvancedWindow:ListView, AdvancedWindowSTVTogglesInfoLVVar
            LV_Modify(2, "", "(2) [Use players as the camera]")
            case "AdvancedWindowPlayVoicePictureButtonVar":
            gui GameAdvancedWindow:default
            gui, GameAdvancedWindow:ListView, AdvancedWindowSTVTogglesInfoLVVar
            LV_Modify(3, "", "(3) [Play voice]")
            case "AdvancedWindowAutoRecordAllGamesPictureButtonVar":
            gui GameAdvancedWindow:default
            gui, GameAdvancedWindow:ListView, AdvancedWindowSTVTogglesInfoLVVar
            LV_Modify(4, "", "(4) [Auto-Record all games]")
            case "AdvancedWindowTransmitAllEntitiesPictureButtonVar":
            gui GameAdvancedWindow:default
            gui, GameAdvancedWindow:ListView, AdvancedWindowSTVTogglesInfoLVVar
            LV_Modify(5, "", "(5) [Transmit all entities]")
            case "AdvancedWindowDelayMapChangePictureButtonVar":
            gui GameAdvancedWindow:default
            gui, GameAdvancedWindow:ListView, AdvancedWindowSTVTogglesInfoLVVar
            LV_Modify(6, "", "(6) [Delays map change until broadcast is")
            LV_Modify(7, "", "complete]")
            case "AdvancedWindowEmptyToggle7PictureButtonVar":
            gui GameAdvancedWindow:default
            gui, GameAdvancedWindow:ListView, AdvancedWindowSTVTogglesInfoLVVar
            LV_Modify(8, "", "(7) [n/a]")
            case "AdvancedWindowEmptyToggle8PictureButtonVar":
            gui GameAdvancedWindow:default
            gui, GameAdvancedWindow:ListView, AdvancedWindowSTVTogglesInfoLVVar
            LV_Modify(9, "", "(8) [n/a]")

            case "AdvancedWindowAllowVotingPictureButtonVar":
            gui GameAdvancedWindow:default
            gui, GameAdvancedWindow:ListView, AdvancedWindowVotesTogglesLVVar
            LV_Modify(1, "", "(1) [Allow voting]")
            case "AdvancedWindowAllowSpectatorsToVotePictureButtonVar":
            gui GameAdvancedWindow:default
            gui, GameAdvancedWindow:ListView, AdvancedWindowVotesTogglesLVVar
            LV_Modify(2, "", "(2) [Allow spectators to vote]")
            case "AdvancedWindowAllowBotsToVotePictureButtonVar":
            gui GameAdvancedWindow:default
            gui, GameAdvancedWindow:ListView, AdvancedWindowVotesTogglesLVVar
            LV_Modify(3, "", "(3) [Allow bots to vote or not]")
            case "AdvancedWindowEnableAutoTeamBalanceVotesPictureButtonVar":
            gui GameAdvancedWindow:default
            gui, GameAdvancedWindow:ListView, AdvancedWindowVotesTogglesLVVar
            LV_Modify(4, "", "(4) [Allow enable or disable auto team balance votes]")
            case "AdvancedWindowAllowChangeLevelVotesPictureButtonVar":
            gui GameAdvancedWindow:default
            gui, GameAdvancedWindow:ListView, AdvancedWindowVotesTogglesLVVar
            LV_Modify(5, "", "(5) [Allow players to vote on changing levels]")
            case "AdvancedWindowAllowPerClassLimitVotesPictureButtonVar":
            gui GameAdvancedWindow:default
            gui, GameAdvancedWindow:ListView, AdvancedWindowVotesTogglesLVVar
            LV_Modify(6, "", "(6) [Allow enable or disable per-class limits votes]")
            case "AdvancedWindowAllowNextLevelVotesPictureButtonVar":
            gui GameAdvancedWindow:default
            gui, GameAdvancedWindow:ListView, AdvancedWindowVotesTogglesLVVar
            LV_Modify(7, "", "(7) [Allow players to vote on choosing the next level]")
            case "AdvancedWindowEnableVoteKickPictureButtonVar":
            gui GameAdvancedWindow:default
            gui, GameAdvancedWindow:ListView, AdvancedWindowVotesTogglesLVVar
            LV_Modify(8, "", "(8) [Allow players to call vote kick other players]")
            case "AdvancedWindowAllowVoteKickSpectatorsInMvMPictureButtonVar":
            gui GameAdvancedWindow:default
            gui, GameAdvancedWindow:ListView, AdvancedWindowVotesTogglesLVVar
            LV_Modify(9, "", "(9) [Allow players to kick spectators in MvM]")
            case "AdvancedWindowAllowSetMvMChallengeLevelVotesPictureButtonVar":
            gui GameAdvancedWindow:default
            gui, GameAdvancedWindow:ListView, AdvancedWindowVotesTogglesLVVar
            LV_Modify(10, "", "(10) [Allow players to call votes to set the challenge level in mvm]")
            case "AdvancedWindowAutomaticallyChooseYesForVoteCallersPictureButtonVar":
            gui GameAdvancedWindow:default
            gui, GameAdvancedWindow:ListView, AdvancedWindowVotesTogglesLVVar
            LV_Modify(11, "", "(11) [Automatically choose 'Yes' for vote callers]")
            case "AdvancedWindowAllowExtendCurrentMapVotesPictureButtonVar":
            gui GameAdvancedWindow:default
            gui, GameAdvancedWindow:ListView, AdvancedWindowVotesTogglesLVVar
            LV_Modify(12, "", "(12) [Allow players to extend the current map]")
            case "AdvancedWindowPresentTheLowestPlaytimeMapsListPictureButtonVar":
            gui GameAdvancedWindow:default
            gui, GameAdvancedWindow:ListView, AdvancedWindowVotesTogglesLVVar
            LV_Modify(13, "", "(13) [Present players with a list of lowest playtime maps to choose from]")
            case "AdvancedWindowPreventNextLevelVotesIfOneHasBeenSetPictureButtonVar":
            gui GameAdvancedWindow:default
            gui, GameAdvancedWindow:ListView, AdvancedWindowVotesTogglesLVVar
            LV_Modify(14, "", "(14) [Not allowed to vote for a nextlevel if one has already been set]")
            case "AdvancedWindowAllowRestartGameVotesPictureButtonVar":
            gui GameAdvancedWindow:default
            gui, GameAdvancedWindow:ListView, AdvancedWindowVotesTogglesLVVar
            LV_Modify(15, "", "(15) [Allow players to call votes to restart the game]")
            case "AdvancedWindowAllowVoteScramblePictureButtonVar":
            gui GameAdvancedWindow:default
            gui, GameAdvancedWindow:ListView, AdvancedWindowVotesTogglesLVVar
            LV_Modify(16, "", "(16) [Allow players to vote to scramble the teams]")
            case "AdvancedWindowShowDisabledVotesInTheVoteMenuPictureButtonVar":
            gui GameAdvancedWindow:default
            gui, GameAdvancedWindow:ListView, AdvancedWindowVotesTogglesLVVar
            LV_Modify(17, "", "(17) [Suppress listing of disabled issues in the vote setup screen]")
            case "AdvancedWindowAllowPauseGameVotesPictureButtonVar":
            gui GameAdvancedWindow:default
            gui, GameAdvancedWindow:ListView, AdvancedWindowVotesTogglesLVVar
            LV_Modify(18, "", "(18) [Allow players to call votes to pause the game]")

            case "AdvancedWindowGenerateSTVPasswordTextVar":
			GuiControl, GameAdvancedWindow:+Background646464, AdvancedWindowGenerateSTVPasswordProgressVar
			GuiControl, GameAdvancedWindow:+c221f1c, AdvancedWindowGenerateSTVPasswordTextVar
			GuiControl, GameAdvancedWindow:, AdvancedWindowGenerateSTVPasswordTextVar, % Chr(0x2699)

			case "GameAdvancedMapOptionsPageOptionsPreviousPageTextVar":
			GuiControl, GameAdvancedWindow:+Background646464, GameAdvancedMapOptionsPageOptionsPreviousPageProgressVar
			GuiControl, GameAdvancedWindow:+c221f1c, GameAdvancedMapOptionsPageOptionsPreviousPageTextVar
			GuiControl, GameAdvancedWindow:, GameAdvancedMapOptionsPageOptionsPreviousPageTextVar, % Chr(0x2B06)
            case "GameAdvancedMapOptionsPageOptionsNextPageTextVar":
			GuiControl, GameAdvancedWindow:+Background646464, GameAdvancedMapOptionsPageOptionsNextPageProgressVar
			GuiControl, GameAdvancedWindow:+c221f1c, GameAdvancedMapOptionsPageOptionsNextPageTextVar
			GuiControl, GameAdvancedWindow:, GameAdvancedMapOptionsPageOptionsNextPageTextVar, % Chr(0x2B07)
            case "GameAdvancedMapOptionsModifyValueTextVar":
			GuiControl, GameAdvancedWindow:+Background646464, GameAdvancedMapOptionsModifyValueProgressVar
			GuiControl, GameAdvancedWindow:+c221f1c, GameAdvancedMapOptionsModifyValueTextVar
			GuiControl, GameAdvancedWindow:, GameAdvancedMapOptionsModifyValueTextVar, % Chr(0x270F)

            case "GameAdvancedLaunchOptionsCopyToClipboardTextVar":
			GuiControl, GameAdvancedWindow:+Background646464, GameAdvancedLaunchOptionsCopyToClipboardProgressVar
			GuiControl, GameAdvancedWindow:+c221f1c, GameAdvancedLaunchOptionsCopyToClipboardTextVar
			GuiControl, GameAdvancedWindow:, GameAdvancedLaunchOptionsCopyToClipboardTextVar, % Chr(0x1F4CB)
            case "GameAdvancedLaunchOptionsRestoreTextVar":
            GuiControl, GameAdvancedWindow:+Background646464, GameAdvancedLaunchOptionsRestoreProgressVar
			GuiControl, GameAdvancedWindow:+c221f1c, GameAdvancedLaunchOptionsRestoreTextVar
			GuiControl, GameAdvancedWindow:, GameAdvancedLaunchOptionsRestoreTextVar, % Chr(0x1F504)

            case "SelectServerPresetRemovePresetPictureButtonVar":
			GuiControl, GameAdvancedWindowPresets:+Background646464, SelectServerPresetRemovePresetProgressVar
			GuiControl, GameAdvancedWindowPresets:+c221f1c, SelectServerPresetRemovePresetPictureButtonVar
			GuiControl, GameAdvancedWindowPresets:, SelectServerPresetRemovePresetPictureButtonVar, -
            case "SelectServerPresetAddPresetPictureButtonVar":
			GuiControl, GameAdvancedWindowPresets:+Background646464, SelectServerPresetAddPresetProgressVar
			GuiControl, GameAdvancedWindowPresets:+c221f1c, SelectServerPresetAddPresetPictureButtonVar
			GuiControl, GameAdvancedWindowPresets:, SelectServerPresetAddPresetPictureButtonVar, +
            case "SelectServerPresetApplyPresetPictureButtonVar":
			GuiControl, GameAdvancedWindowPresets:+Background646464, SelectServerPresetApplyPresetProgressVar
			GuiControl, GameAdvancedWindowPresets:+c221f1c, SelectServerPresetApplyPresetPictureButtonVar
			GuiControl, GameAdvancedWindowPresets:, SelectServerPresetApplyPresetPictureButtonVar, % Chr(0x2935)
            case "SelectServerPresetClearCustomPresetNameTextVar":
            GuiControl, GameAdvancedWindowPresets:+c646464, SelectServerPresetClearCustomPresetNameProgressVar
			GuiControl, GameAdvancedWindowPresets:+c221f1c, SelectServerPresetClearCustomPresetNameTextVar
			GuiControl, GameAdvancedWindowPresets:, SelectServerPresetClearCustomPresetNameTextVar, x
            case "SelectServerPresetCopyCustomPresetToClipboardTextVar":
			GuiControl, GameAdvancedWindowPresets:+c646464, SelectServerPresetCopyCustomPresetToClipboardProgressVar
			GuiControl, GameAdvancedWindowPresets:+c221f1c, SelectServerPresetCopyCustomPresetToClipboardTextVar
			GuiControl, GameAdvancedWindowPresets:, SelectServerPresetCopyCustomPresetToClipboardTextVar, % Chr(0x1F4CB)
            case "SelectServerPresetCopyGeneratePresetCodeToClipboardTextVar":
			GuiControl, GameAdvancedWindowPresets:+c646464, SelectServerPresetCopyGeneratePresetCodeToClipboardProgressVar
			GuiControl, GameAdvancedWindowPresets:+c221f1c, SelectServerPresetCopyGeneratePresetCodeToClipboardTextVar
			GuiControl, GameAdvancedWindowPresets:, SelectServerPresetCopyGeneratePresetCodeToClipboardTextVar, % Chr(0x1F4CB)

            case "ConsoleSendInputTextVar":
			GuiControl, MainWindow:+Background646464, ConsoleSendInputProgressVar
			GuiControl, MainWindow:+c221f1c, ConsoleSendInputTextVar
			GuiControl, MainWindow:, ConsoleSendInputTextVar, >
            case "ConsoleCopyPrivateIPToClipboardTextVar":
			GuiControl, ConsoleFetchIPWindow:+Background646464, ConsoleCopyPrivateIPToClipboardProgressVar
			GuiControl, ConsoleFetchIPWindow:+c221f1c, ConsoleCopyPrivateIPToClipboardTextVar
			GuiControl, ConsoleFetchIPWindow:, ConsoleCopyPrivateIPToClipboardTextVar, % Chr(0x1F4CB)
            case "ConsoleCopyPublicIPToClipboardTextVar":
			GuiControl, ConsoleFetchIPWindow:+Background646464, ConsoleCopyPublicIPToClipboardProgressVar
			GuiControl, ConsoleFetchIPWindow:+c221f1c, ConsoleCopyPublicIPToClipboardTextVar
			GuiControl, ConsoleFetchIPWindow:, ConsoleCopyPublicIPToClipboardTextVar, % Chr(0x1F4CB)
            case "ConsoleCopyFakeIPToClipboardTextVar":
			GuiControl, ConsoleFetchIPWindow:+Background646464, ConsoleCopyFakeIPToClipboardProgressVar
			GuiControl, ConsoleFetchIPWindow:+c221f1c, ConsoleCopyFakeIPToClipboardTextVar
			GuiControl, ConsoleFetchIPWindow:, ConsoleCopyFakeIPToClipboardTextVar, % Chr(0x1F504)

            case "PathsRemoveHostListboxVar":
			GuiControl, MainWindow:+Background646464, PathsRemoveHostProgressVar
			GuiControl, MainWindow:+c221f1c, PathsRemoveHostListboxVar
			GuiControl, MainWindow:, PathsRemoveHostListboxVar, -
            case "PathsAddHostTextButtonVar":
			GuiControl, MainWindow:+Background646464, PathsAddHostProgressVar
			GuiControl, MainWindow:+c221f1c, PathsAddHostTextButtonVar
			GuiControl, MainWindow:, PathsAddHostTextButtonVar, +
            case "PathsEditPathTextVar":
			GuiControl, MainWindow:+Background646464, PathsEditPathProgressVar
			GuiControl, MainWindow:+c221f1c, PathsEditPathTextVar
			GuiControl, MainWindow:, PathsEditPathTextVar, % Chr(0x270F)
            case "PathOpenPathTextVar":
			GuiControl, MainWindow:+Background646464, PathOpenPathProgressVar
			GuiControl, MainWindow:+c221f1c, PathOpenPathTextVar
			GuiControl, MainWindow:, PathOpenPathTextVar,  % Chr(0x1F4C2)
            case "PathInfoTextVar":
			GuiControl, MainWindow:+Background646464, PathInfoProgressVar
			GuiControl, MainWindow:+c221f1c, PathInfoTextVar
			GuiControl, MainWindow:, PathInfoTextVar, ?
        }
        return
    }
}

;Animate information
;----------------------------------------------------------------------------------------------
AnimateInformation(TextToAnimate, AnimationDelay, Title, GUIWindow, WindowControl, Width, Height, ShowLocation) {
    GuiControl, %GUIWindow%:, ScanWindowTitleTextVar, % Title
    CoordMode, mouse, screen
    MouseGetPos, MouseXPos, MouseYPos
    if (ShowLocation != "NoCustomCoordinates")
    Gui, %GUIWindow%:show, x%MouseXPos% y%MouseYPos% w%Width% h%Height%
    else
    Gui, %GUIWindow%:show, w%Width% h%Height%
    global AddLoopText := ""
    loop, Parse, TextToAnimate, % " "
    {
        AddLoopText .= A_LoopField . A_Space
        GuiControl, %GUIWindow%:, %WindowControl%, % AddLoopText . "▮"
        Sleep, % AnimationDelay
    }
    GuiControl, %GUIWindow%:, %WindowControl%, % AddLoopText
}

;Perform deep scan
;Create the ignore list like system32 and other paths that are unlikely to have srcds installed
;----------------------------------------------------------------------------------------------
ScanForFile(FileName, ScanMode, Path, Extention) {
    if (ScanMode := "Full scan")
    {
        DriveGet, ListOfAllDrives, List
        loop, Parse, ListOfAllDrives
        {
            ListOfAllScannedItems := []
            loop, Files, %A_LoopField%:\*.%Extention%, FR
            {
                global ScanInProgress := true
                IniRead, AbortScanFromINI, %A_scriptdir%\Server Boss All\Settings.ini, ScanForServers, AbortScan
                if (AbortScanFromINI = "True")
                {
                    ScanInProgress := false
                    return 0
                }
                GuiControl, ScanWindow:, ConfirmationEditVar, % "Searching for" . A_Space . FileName . A_Space . "in:`n`n" . A_LoopFileFullPath
                if InStr(A_LoopFileFullPath, A_WinDir)
                continue
                if InStr(A_LoopFileFullPath, A_AppData)
                continue
                if InStr(A_LoopFileFullPath, FileName)
                ListOfAllScannedItems.push(A_LoopFileFullPath)
            }
        }
        Gui, ScanWindow:hide
        return ListOfAllScannedItems
    }
    else if (ScanMode := "Partial scan")
    {
        loop, Files, %Path%:\*.%Extention%, FR
        {
            if InStr(A_LoopFileFullPath, FileName)
            return A_LoopFileFullPath
            break
        }
    }
    ScanInProgress := false
}

;Find map name inside demo file's binary
;------------------------------------------------------------------------
FindDemoFileMapFromBinary(Path)
{
    FileRead, BinaryContents, *c %Path%
    Loop 1000
    {
        if (Chr(NumGet(BinaryContents, A_Index - 1, "Char")) = "")
        BinaryContentsNoMachinaLanguage .= " "
        if RegExMatch(Chr(NumGet(BinaryContents, A_Index - 1, "Char")), "i)^[a-zA-Z0-9._:/]$")
        BinaryContentsNoMachinaLanguage .= Chr(NumGet(BinaryContents, A_Index - 1, "Char"))
    }
    Loop, Parse, % RegExReplace(BinaryContentsNoMachinaLanguage, "\s+", " "), " "
    {
        if (A_Index = 4)
        {
            return % A_LoopField
            break
        }
    }
}

;Find tf2 installation path
;------------------------------------------------------------------------
FindTF2InstallPath(Game) {
    RegRead, SteamPath, HKEY_CURRENT_USER\Software\Valve\Steam, SteamPath
    if (ErrorLevel = 0)
    {
        return StrReplace(SteamPath, "/", "\") . "\steamapps\common\Team Fortress 2\" . Game
    }
}

;Dedicated server scan window
;------------------------------------------------------------------------
ScanWindowAlwaysOnTopWindowPictureButton:
if (ToggleScanWindowOnTop != 1)
{
    Gui, ScanWindow:+AlwaysOnTop
    GuiControl, ScanWindow:, ScanWindowAlwaysOnTopWindowPictureButtonVar, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Toolbar_pin_window_on.png
    ToggleScanWindowOnTop := 1
}
else if  (ToggleScanWindowOnTop = 1)
{
    Gui, ScanWindow:-AlwaysOnTop
    GuiControl, ScanWindow:, ScanWindowAlwaysOnTopWindowPictureButtonVar, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Toolbar_pin_window_off.png
    ToggleScanWindowOnTop := 0
}
return

ScanWindowMinimizeWindowPictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Toolbar_minimize", "ScanWindow", "ScanWindowMinimizeWindowPictureButtonVar")
Gui, ScanWindow:minimize
return

ScanWindowCloseWindowPictureButton:
EmulateButtonPress(A_ScriptDir "\Server Boss All\Images\Custom UI controls\Toolbar_close", "ScanWindow", "ScanWindowCloseWindowPictureButtonVar")
Gui, ScanWindow:hide
return

ScanWindowStartScanningPictureButton:
gui, MainWindow:submit, nohide
gui MainWindow:default
gui, MainWindow:ListView, PathsHostsLVVar
IniWrite, False, %A_scriptdir%\Server Boss All\Settings.ini, ScanForServers, AbortScan
FoundExeHostPath := ScanForFile(ScanTarget . ".exe", "Full scan", "", "exe")
if (FoundExeHostPath = "")
{
    return
}
gosub, UpdateHostList
return

UpdateHostList:
loop, % FoundExeHostPath.count()
{
    FileCreateDir, %A_scriptdir%\Server Boss All\Hosts
    SplitPath, % FoundExeHostPath[A_Index],, ExeHostOutDir
    SplitPath, ExeHostOutDir,, CommonOutDir
    SplitPath, CommonOutDir,, SteamAppsOutDir
    IniWrite, % FoundExeHostPath[A_Index], %A_scriptdir%\Server Boss All\Hosts\%ScanTarget%_%A_index%.ini, Paths, Exe
    IniWrite, % ExeHostOutDir . "\tf", %A_scriptdir%\Server Boss All\Hosts\%ScanTarget%_%A_index%.ini, Paths, Tf
    IniWrite, % ExeHostOutDir . "\tf\maps", %A_scriptdir%\Server Boss All\Hosts\%ScanTarget%_%A_index%.ini, Paths, Maps
    IniWrite, % ExeHostOutDir . "\tf\cfg", %A_scriptdir%\Server Boss All\Hosts\%ScanTarget%_%A_index%.ini, Paths, Cfg
    IniWrite, % SteamAppsOutDir . "\workshop\content\440", %A_scriptdir%\Server Boss All\Hosts\%ScanTarget%_%A_index%.ini, Paths, GameWorkshop
    IniWrite, % ExeHostOutDir . "\tf\download", %A_scriptdir%\Server Boss All\Hosts\%ScanTarget%_%A_index%.ini, Paths, MapDownloads
    GuiControl, MainWindow:, PathsHostsListboxVar, |
    guiControl, ServerHosts:, SelectServerHostListboxVar, |

    if !RegExMatch(HostsList, CheckForExistingHost.HasKey(ScanTarget . "_" . A_Index))
    TotalHosts += 1
    LookForHostsList := HostsList
    LookForExistingHost := CheckForExistingHost
    HostsList := ""
    CheckForExistingHost := {}
    loop, Files, %A_ScriptDir%\Server Boss All\Hosts\*.ini, F
    {
        SplitPath, A_LoopFileFullPath,,,, HostOutNameNoExt
        HostsList .= HostOutNameNoExt . "|"
        CheckForExistingHost[HostOutNameNoExt] := "1"
    }

    GuiControl, MainWindow:, PathsHostsListboxVar, % HostsList
    guiControl, ServerHosts:, SelectServerHostListboxVar, % HostsList
    GuiControl, MainWindow:choose, PathsHostsListboxVar, % ScanTarget . "_" . [A_Index]
    VarSetCapacity(HostOutNameNoExt, 0)
    LV_Modify(1, "",, FoundExeHostPath[A_Index])
    LV_Modify(2, "",, ExeHostOutDir . "\tf")
    LV_Modify(3, "",, ExeHostOutDir . "\tf\maps")
    LV_Modify(4, "",, ExeHostOutDir . "\tf\cfg")
    if FileExist(SteamAppsOutDir . "\workshop\content\440")
    LV_Modify(5, "",, SteamAppsOutDir . "\workshop\content\440")
    else
    LV_Modify(5, "",, "")
    LV_Modify(6, "",, ExeHostOutDir . "\tf\download")
    GuiControl, MainWindow:, PathsSelectedHostTextVar, % "Total hosts:" . TotalHosts . A_tab . "Selected host:" . A_Space . ScanTarget . "_" . A_Index . "                                            _"
    IniWrite, %ScanTarget%_%A_Index%, %A_scriptdir%\Server Boss All\Settings.ini, LastUsedSettings, PathsHost
}
return

ScanWindowAbortPictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Cancel_pic_button", "ScanWindow", "ScanWindowAbortPictureButtonVar")
IniWrite, True, %A_scriptdir%\Server Boss All\Settings.ini, ScanForServers, AbortScan
if (ScanInProgress = true)
{
    GuiControl, ScanWindow:, ConfirmationEditVar, Scan aborted!
    Sleep, 3000
    AnimateInformation("Do you want server boss to scan for dedicated servers on your computer?`n`nTarget >> srcds.exe`n`nMode: Full scan(Server boss will scan the entire pc for srcds.exe)[Not recommended]`nScan speed: slow" . A_Space . SelectedSavedPath, 40, "Scan for" . A_Space ScanTarget . ".exe", "ScanWindow", "ConfirmationEditVar", 570, 375, "NoCustomCoordinates")
}
return

;Game
;------------------------------------------------------------------------
GameAddImageWindow:
gui, MainWindow:submit, nohide
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Game_add_picture_pic_button", "MainWindow", "GameAddImageWindowVar")
if (GameMapsListLBVar = "")
{
    DisplayTooltip("Map not selected!", 3)
    return
}
FileSelectFile, AddMapImageImage, 3, RootDir, Add map image, Select image file (*.png; *.jpg; *.bmp; *.gif)
SplitPath, AddMapImageImage,,, ImageOutExtension
if (AddMapImageImage = "")
{
    return
}
FileDelete, %A_ScriptDir%\Server Boss All\Images\Map images\%GameMapsListLBVar%.png
FileDelete, %A_ScriptDir%\Server Boss All\Images\Map images\%GameMapsListLBVar%.bmp
FileDelete, %A_ScriptDir%\Server Boss All\Images\Map images\%GameMapsListLBVar%.jpg
FileDelete, %A_ScriptDir%\Server Boss All\Images\Map images\%GameMapsListLBVar%.gif
FileCopy, %AddMapImageImage%, %A_ScriptDir%\Server Boss All\Images\Map images\%GameMapsListLBVar%.%ImageOutExtension%, 1
gosub, GameMapsListLB
return

GameShowAdvancedWindow:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Paths_cog_wheel_pic_button", "MainWindow", "GameShowAdvancedWindowVar")
Gui, GameAdvancedWindow:show, w1560 h740
AdvancedInformationWindowText := "Middle click on any button/text/image/listbox/listview control to obtain infomation.`n`nDev: `nThis is an edit control. It shows information about specific control when the Mouse3 button is pressed on top of it.`n`nClassNN: Edit23"
gosub, AnimateAdvancedInformationWindow
return

GameRestartServer:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Game_restart_server_pic_button", "MainWindow", "GameRestartServerVar")
WinClose, ahk_pid %Tf2ServerPID%
GamePreventStartButtonAnimation := true
gosub, GameStartServer
return

GameStopServer:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Game_stop_server_pic_button", "MainWindow", "GameStopServerVar")
Menu, Tray, Icon, %A_ScriptDir%\Server Boss All\Images\Icons\Server boss.ico
GuiControl, MainWindow:, ToolbarStatusTextVar, Status: Idle
WinClose, ahk_pid %Tf2ServerPID%
Process, Close, %Tf2ServerPID%
GuiControl, MainWindow:, ConsoleEditVar
SetTimer, MonitorConsoleLogFile, Delete
return

GameStartServer:
gui, MainWindow:submit, nohide
gui, GameAdvancedWindow:submit, nohide
gui, GameMapCycleWindow:submit, nohide

if (GamePreventStartButtonAnimation != true)
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Game_start_server_pic_button", "MainWindow", "GameStartServerVar")
GamePreventStartButtonAnimation := false
if !WinExist("ahk_pid" . A_Space . Tf2ServerPID)
{
    PreviousConsoleLengthVar := ""
    Menu, Tray, Icon, %A_ScriptDir%\Server Boss All\Images\Icons\Server boss - Active.ico
    GuiControl, MainWindow:, ToolbarStatusTextVar, Status: Active
    IniRead, HostFromINI, %A_scriptdir%\Server Boss All\Settings.ini, SelectedServerHost, Host
    IniRead, HostExeFromINI, %A_scriptdir%\Server Boss All\Hosts\%HostFromINI%.ini, Paths, Exe
    IniRead, HostCFGFromINI, %A_scriptdir%\Server Boss All\Hosts\%HostFromINI%.ini, Paths, Cfg
    IniRead, HostMapsFromINI, %A_scriptdir%\Server Boss All\Hosts\%HostFromINI%.ini, Paths, Maps
    IniRead, HostTFFromINI, %A_scriptdir%\Server Boss All\Hosts\%HostFromINI%.ini, Paths, Tf
    gosub, ReadAdvancedSettingsFromINI
    gosub, GenerateServerCFGFile
    gosub, GenerateServerLaunchOptions
    FileDelete, %HostTFFromINI%\console.log
    FileDelete, %HostCFGFromINI%\mapcycle.txt
    FileRead, CopyMapCycleListPreset, %A_ScriptDir%\Server Boss All\Map cycles\%HostFromINI%.txt
    FileAppend, %CopyMapCycleListPreset%, %HostCFGFromINI%\mapcycle.txt
    if !FileExist(HostMapsFromINI . "\" . GameMapsListLBVar . ".bsp")
    FileCopy, % ListOfMapsArray[GameMapsListLBVar], % HostMapsFromINI . "\" . GameMapsListLBVar . ".bsp"
    FileDelete, % HostCFGFromINI . "\Server_boss_" . HostFromINI . ".cfg"
    FileAppend, %CFGFileCode%, % HostCFGFromINI . "\Server_boss_" . HostFromINI . ".cfg"
    SetTimer, MonitorConsoleLogFile, 250
    SetTimer, HideServerConsole, -2000
    GuiControl, MainWindow:choose, MainWindowTab3Var, Console
    ConsoleLogFilePath := HostTFFromINI
    RunWait, %HostExeFromINI% %LaunchOptionsCode%,, min, Tf2ServerPID
    gosub, GameStopServer
}
else
GuiControl, MainWindow:choose, MainWindowTab3Var, Console
return

HideServerConsole:
if !InStr(HostExeFromINI, "tf.exe") and !InStr(HostExeFromINI, "tf_win64.exe")
WinHide, ahk_pid %Tf2ServerPID%
return

MonitorConsoleLogFile:
gui, MainWindow:submit, nohide
IniRead, ToggleConsoleLogFileMonitoringFromINI, %A_scriptdir%\Server Boss All\Settings.ini, MainWindow, ToggleConsoleLogFileMonitoring
FileRead, ConsoleLogFullList, %ConsoleLogFilePath%\console.log
if (PreviousConsoleLengthVar < StrLen(ConsoleLogFullList)) and (ToggleConsoleLogFileMonitoringFromINI = "1")
{
    PreviousConsoleLengthVar := StrLen(ConsoleLogFullList)
    DetectHiddenWindows, off
    GuiControl, MainWindow:, ConsoleEditVar, % ConsoleLogFullList
    SendMessage, 0x115, 7, 0, Edit5, Server Boss
    DetectHiddenWindows, on
}
return

GenerateServerCFGFile:
if (GameMapsListLBVar != "Random") ? (AddMap := "map" . A_Space . GameMapsListLBVar) : (AddMap := "map randommap")

if (SVPureFromINI = "2")
AddSVPure := "sv_pure -1"
else if (SVPureFromINI = "3")
AddSVPure := "sv_pure 0"
else if (SVPureFromINI = "4")
AddSVPure := "sv_pure 1"
else if (SVPureFromINI = "5")
AddSVPure := "sv_pure 2"
if (ServerTypeFromINI = "10")
{
    AddServerTypeToLaunchOptions := true
    AddServerType := "sv_lan 0"
    ServerTypeInfo := "SDR"
}
else if (ServerTypeFromINI = "1")
{
    AddServerType := "sv_lan 0"
    ServerTypeInfo := "Public"
}
else if (ServerTypeFromINI = "2")
{
    AddServerType := "sv_lan 1"
    ServerTypeInfo := "Local"
}
if (RegionFromINI = "1")
AddRegion := "sv_region 255"
else if (RegionFromINI = "2")
AddRegion := "sv_region 0"
else if (RegionFromINI = "3")
AddRegion := "sv_region 1"
else if (RegionFromINI = "4")
AddRegion := "sv_region 2"
else if (RegionFromINI = "5")
AddRegion := "sv_region 3"
else if (RegionFromINI = "6")
AddRegion := "sv_region 4"
else if (RegionFromINI = "7")
AddRegion := "sv_region 5"
else if (RegionFromINI = "8")
AddRegion := "sv_region 6"
else if (RegionFromINI = "9")
AddRegion := "sv_region 7"
if (ServerTagsFromINI != "")
AddServerTags := "sv_tags" . A_Space . ServerTagsFromINI
else
AddServerTags := "// sv_tags" . A_Space . ServerTagsFromINI
if (ServerTokenFromINI != "")
AddServerToken := "sv_setsteamaccount" . A_Space . ServerTokenFromINI
else
AddServerToken := "// sv_setsteamaccount" . A_Space . ServerTokenFromINI
if (FastDLURLFromINI != "")
AddFastDLURL := "sv_downloadurl" . A_Space . FastDLURLFromINI
else
AddFastDLURL := "// sv_downloadurl" . A_Space . FastDLURLFromINI
if (RconPasswordFromINI != "")
AddRconPassword := "rcon_password" . A_Space . RconPasswordFromINI
else
AddRconPassword := "// rcon_password" . A_Space . RconPasswordFromINI
if (MaxRateFromINI != "")
AddMaxRate := "sv_maxrate" . A_Space . MaxRateFromINI
else
AddMaxRate := "// sv_maxrate" . A_Space . MaxRateFromINI
if (MinRateFromINI != "")
AddMinRate := "sv_minrate" . A_Space . MinRateFromINI
else
AddMinRate := "// sv_minrate" . A_Space . MinRateFromINI
if (MaxUpdateRateFromINI != "")
AddMaxUpdateRate := "sv_maxupdaterate" . A_Space . MaxUpdateRateFromINI
else
AddMaxUpdateRate := "// sv_maxupdaterate" . A_Space . MaxUpdateRateFromINI
if (MinUpdateRateFromINI != "")
AddMinUpdateRate := "sv_minupdaterate" . A_Space . MinUpdateRateFromINI
else
AddMinUpdateRate := "// sv_minupdaterate" . A_Space . MinUpdateRateFromINI
if (MaxCMDRateFromINI != "")
AddMaxCMDRate := "sv_maxcmdrate" . A_Space . MaxCMDRateFromINI
else
AddMaxCMDRate := "// sv_maxcmdrate" . A_Space . MaxCMDRateFromINI
if (MinCMDRateFromINI != "")
AddMinCMDRate := "sv_mincmdrate" . A_Space . MinCMDRateFromINI
else
AddMinCMDRate := "// sv_mincmdrate" . A_Space . MinCMDRateFromINI
if (CustomAddressFromINI != "")
AddCustomAddress := "ip" . A_Space . CustomAddressFromINI
else
AddCustomAddress := "// ip" . A_Space . CustomAddressFromINI
if (STVNameFromINI != "")
AddSTVName := "tv_name" . A_Space . STVNameFromINI
else
AddSTVName := "// tv_name" . A_Space . STVNameFromINI
if (STVPasswordFromINI != "")
AddSTVPassword := "tv_password" . A_Space . STVPasswordFromINI
else
AddSTVPassword := "// tv_password" . A_Space . STVPasswordFromINI
if (STVSnapShotRateFromINI != "")
AddSTVSnapShotRate := "tv_snapshotrate" . A_Space . STVSnapShotRateFromINI
else
AddSTVSnapShotRate := "// tv_snapshotrate" . A_Space . STVSnapShotRateFromINI
if (STVDelayFromINI != "")
AddSTVDelay := "tv_delay " . A_Space . STVDelayFromINI
else
AddSTVDelay := "// tv_delay " . A_Space . STVDelayFromINI
if (STVPortFromINI != "")
AddSTVPort := "tv_port" . A_Space . STVPortFromINI
else
AddSTVPort := "// tv_port" . A_Space . STVPortFromINI
if (TimeoutFromINI != "")
AddTimeout := "tv_timeout" . A_Space . TimeoutFromINI
else
AddTimeout := "// tv_timeout" . A_Space . TimeoutFromINI
if (MaxNumOfClientsFromINI != "")
AddMaxNumOfClients := "tv_maxclients" . A_Space . MaxNumOfClientsFromINI
else
AddMaxNumOfClients := "// tv_maxclients" . A_Space . MaxNumOfClientsFromINI
if (AllowSpectatorsFromINI != "")
AddAllowSpectators := "mp_allowspectators" . A_Space . AllowSpectatorsFromINI
else
AddAllowSpectators := "// mp_allowspectators" . A_Space . AllowSpectatorsFromINI
if (ShowVoiceChatIconsFromINI != "")
AddShowVoiceChatIcons := "mp_show_voice_icons" . A_Space . ShowVoiceChatIconsFromINI
else
AddShowVoiceChatIcons := "// mp_show_voice_icons" . A_Space . ShowVoiceChatIconsFromINI
if (DisableRespawnTimeFromINI != "")
AddDisableRespawnTime := "mp_disable_respawn_times" . A_Space . DisableRespawnTimeFromINI
else
AddDisableRespawnTime := "// mp_disable_respawn_times" . A_Space . DisableRespawnTimeFromINI
if (RestrictTo1ClassOnlyFromINI != "")
AddRestrictTo1ClassOnly := "mp_highlander" . A_Space . RestrictTo1ClassOnlyFromINI
else
AddRestrictTo1ClassOnly := "// mp_highlander" . A_Space . RestrictTo1ClassOnlyFromINI
if (EnableTeammatesPushAwayFromINI != "")
AddEnableTeammatesPushAway := "tf_avoidteammates_pushaway" . A_Space . EnableTeammatesPushAwayFromINI
else
AddEnableTeammatesPushAway := "// tf_avoidteammates_pushaway" . A_Space . EnableTeammatesPushAwayFromINI
if (EnableRandomCritsFromINI != "")
AddEnableRandomCrits := "tf_weapon_criticals" . A_Space . EnableRandomCritsFromINI . "`ntf_weapon_criticals_melee " . A_Space . EnableRandomCritsFromINI
else
AddEnableRandomCrits := "// tf_weapon_criticals" . A_Space . EnableRandomCritsFromINI . "`ntf_weapon_criticals_melee " . A_Space . EnableRandomCritsFromINI
if (SpawnBeachBallOnRoundStartFromINI != "")
AddSpawnBeachBallOnRoundStart := "tf_birthday_ball_chance 100"
else
AddSpawnBeachBallOnRoundStart := "// tf_birthday_ball_chance 100"
if (EnableGrapplingHookFromINI != "")
AddEnableGrapplingHook := "tf_grapplinghook_enable" . A_Space . EnableGrapplingHookFromINI
else
AddEnableGrapplingHook := "// tf_grapplinghook_enable" . A_Space . EnableGrapplingHookFromINI
if (EnableMannpowerModeFromINI != "")
AddEnableMannpowerMode := "tf_powerup_mode" . A_Space . EnableMannpowerModeFromINI
else
AddEnableMannpowerMode := "// tf_powerup_mode" . A_Space . EnableMannpowerModeFromINI
if (EnableMedievalModeFromINI != "")
AddEnableMedievalMode := "tf_medieval" . A_Space . EnableMedievalModeFromINI
else
AddEnableMedievalMode := "// tf_medieval" . A_Space . EnableMedievalModeFromINI
if (EnableMedievalAutorpFromINI != "")
AddEnableMedievalAutorp := "tf_medieval_autorp" . A_Space . EnableMedievalAutorpFromINI
else
AddEnableMedievalAutorp := "// tf_medieval_autorp" . A_Space . EnableMedievalAutorpFromINI
if (FadeToBlackForSpectatorsFromINI != "")
AddFadeToBlackForSpectators := "mp_fadetoblack" . A_Space . FadeToBlackForSpectatorsFromINI
else
AddFadeToBlackForSpectators := "// mp_fadetoblack" . A_Space . FadeToBlackForSpectatorsFromINI
if (EnableFriendlyFireFromINI != "")
AddEnableFriendlyFire := "mp_friendlyfire" . A_Space . EnableFriendlyFireFromINI
else
AddEnableFriendlyFire := "// mp_friendlyfire" . A_Space . EnableFriendlyFireFromINI
if (EnableTauntSlidingFromINI != "")
AddEnableTauntSliding := "tf_allow_sliding_taunt" . A_Space . EnableTauntSlidingFromINI
else
AddEnableTauntSliding := "// tf_allow_sliding_taunt" . A_Space . EnableTauntSlidingFromINI
if (AllowWeaponSwitchWhileTauntingFromINI != "")
AddAllowWeaponSwitchWhileTaunting := "tf_allow_taunt_switch" . A_Space . AllowWeaponSwitchWhileTauntingFromINI
else
AddAllowWeaponSwitchWhileTaunting := "// tf_allow_taunt_switch" . A_Space . AllowWeaponSwitchWhileTauntingFromINI
if (EnableBulletSpreadFromINI != "")
AddEnableBulletSpread := "tf_use_fixed_weaponspreads" . A_Space . EnableBulletSpreadFromINI
else
AddEnableBulletSpread := "// tf_use_fixed_weaponspreads" . A_Space . EnableBulletSpreadFromINI
if (AllowsLivingPlayersToHearDeadPlayersFromINI != "")
AddAllowsLivingPlayersToHearDeadPlayers := "tf_gravetalk" . A_Space . AllowsLivingPlayersToHearDeadPlayersFromINI
else
AddAllowsLivingPlayersToHearDeadPlayers := "// tf_gravetalk" . A_Space . AllowsLivingPlayersToHearDeadPlayersFromINI
if (AllowsTruceDuringBossBattleFromINI != "")
AddAllowsTruceDuringBossBattle := "tf_halloween_allow_truce_during_boss_event" . A_Space . AllowsTruceDuringBossBattleFromINI
else
AddAllowsTruceDuringBossBattle := "// tf_halloween_allow_truce_during_boss_event" . A_Space . AllowsTruceDuringBossBattleFromINI
if (PreventPlayerMovementDuringStartupFromINI != "")
AddPreventPlayerMovementDuringStartup := "tf_player_movement_restart_freeze" . A_Space . PreventPlayerMovementDuringStartupFromINI
else
AddPreventPlayerMovementDuringStartup := "// tf_player_movement_restart_freeze" . A_Space . PreventPlayerMovementDuringStartupFromINI
if (TurnPlayersIntoLosersFromINI != "")
AddTurnPlayersIntoLosers := "tf_always_loser" . A_Space . TurnPlayersIntoLosersFromINI
else
AddTurnPlayersIntoLosers := "// tf_always_loser" . A_Space . TurnPlayersIntoLosersFromINI
if (EnableSpellsFromINI != "")
AddEnableSpells := "tf_spells_enabled" . A_Space . EnableSpellsFromINI
else
AddEnableSpells := "// tf_spells_enabled" . A_Space . EnableSpellsFromINI
if (EnableTeamBalancingFromINI != "")
AddEnableTeamBalancing := "mp_autoteambalance" . A_Space . EnableTeamBalancingFromINI
else
AddEnableTeamBalancing := "// mp_autoteambalance" . A_Space . EnableTeamBalancingFromINI
if (EnableSuddenDeathFromINI != "")
AddEnableSuddenDeath := "mp_stalemate_enable" . A_Space . EnableSuddenDeathFromINI
else
AddEnableSuddenDeath := "// mp_stalemate_enable" . A_Space . EnableSuddenDeathFromINI
if (RestartRoundAfterXNumberOfSecFromINI != "")
AddRestartRoundAfterXNumberOfSec := "mp_restartgame" . A_Space . RestartRoundAfterXNumberOfSecValueFromINI
else
AddRestartRoundAfterXNumberOfSec := "// mp_restartgame" . A_Space . RestartRoundAfterXNumberOfSecValueFromINI
if (MaxIdleTimeFromINI != "")
AddMaxIdleTime := "mp_idlemaxtime" . A_Space . MaxIdleTimeValueFromINI
else
AddMaxIdleTime := "// mp_idlemaxtime" . A_Space . MaxIdleTimeValueFromINI
if (SetGravityFromINI != "")
AddSetGravity := "sv_gravity" . A_Space . SetGravityValueFromINI
else
AddSetGravity := "// sv_gravity" . A_Space . SetGravityValueFromINI
if (SetAirAccelerationFromINI != "")
AddSetAirAcceleration := "sv_airaccelerate" . A_Space . SetAirAccelerationValueFromINI
else
AddSetAirAcceleration := "// sv_airaccelerate" . A_Space . SetAirAccelerationValueFromINI
if (SetPlayerAccelerationFromINI != "")
AddSetPlayerAcceleration := "sv_accelerate" . A_Space . SetPlayerAccelerationValueFromINI
else
AddSetPlayerAcceleration := "// sv_accelerate" . A_Space . SetPlayerAccelerationValueFromINI
if (PlayerRollAngleFromINI != "")
AddPlayerRollAngle := "sv_rollangle" . A_Space . PlayerRollAngleValueFromINI
else
AddPlayerRollAngle := "// sv_rollangle" . A_Space . PlayerRollAngleValueFromINI
if (RollAngleSpeedFromINI != "")
AddRollAngleSpeed := "sv_rollspeed" . A_Space . RollAngleSpeedValueFromINI
else
AddRollAngleSpeed := "// sv_rollspeed" . A_Space . RollAngleSpeedValueFromINI
if (RedTeamDmgMultiplierFromINI != "")
AddRedTeamDmgMultiplier := "tf_damage_multiplier_red" . A_Space . RedTeamDmgMultiplierValueFromINI
else
AddRedTeamDmgMultiplier := "// tf_damage_multiplier_red" . A_Space . RedTeamDmgMultiplierValueFromINI
if (BlueTeamDmgMultiplierFromINI != "")
AddBlueTeamDmgMultiplier := "tf_damage_multiplier_blue" . A_Space . BlueTeamDmgMultiplierValueFromINI
else
AddBlueTeamDmgMultiplier := "// tf_damage_multiplier_blue" . A_Space . BlueTeamDmgMultiplierValueFromINI
if (TimescaleFromINI != "")
AddTimescale := "host_timescale" . A_Space . TimescaleValueFromINI
else
AddTimescale := "// host_timescale" . A_Space . TimescaleValueFromINI
if (TeamBalanceLimitFromINI != "")
AddTeamBalanceLimit := "mp_teams_unbalance_limit" . A_Space . TeamBalanceLimitValueFromINI
else
AddTeamBalanceLimit := "// mp_teams_unbalance_limit" . A_Space . TeamBalanceLimitValueFromINI
if (RoundLimitFromINI != "")
AddRoundLimit := "mp_winlimit" . A_Space . RoundLimitValueFromINI
else
AddRoundLimit := "// mp_winlimit" . A_Space . RoundLimitValueFromINI
if (MapTimelimitFromINI != "")
AddMapTimelimit := "mp_timelimit" . A_Space . MapTimelimitValueFromINI
else
AddMapTimelimit := "// mp_timelimit" . A_Space . MapTimelimitValueFromINI
if (StalemateTimelimitFromINI != "")
AddStalemateTimelimit := "mp_stalemate_timelimit" . A_Space . StalemateTimelimitValueFromINI
else
AddStalemateTimelimit := "// mp_stalemate_timelimit" . A_Space . StalemateTimelimitValueFromINI
Quotes := Chr(34)

CFGLocation := HostCFGFromINI . "\Server_boss_" . HostFromINI . ".cfg"
FileGetTime, CFGCreationTime, % CFGLocation, C
FormatTime, CFGCreationTime, CFGCreationTime
(GameServerPasswordEditVar != "") ? (ServerIsPasswordProtected := "Yes") : (ServerIsPasswordProtected := "No")

CFGFileCode =
(
echo " ___                      ___                   __   _   __  "
echo "/ __| ___ _ ___ _____ _ _| _ ) ___ ______ __ __/  \ / | /  \ "
echo "\__ \/ -_) '_\ V / -_) '_| _ \/ _ (_-<_-< \ V / () || || () |"
echo "|___/\___|_|  \_/\___|_| |___/\___/__/__/  \_/ \__(_)_(_)__/ "
echo "============================================================="
echo "cfg file: executed"
echo "cfg creation date: %CFGCreationTime%"
echo "cfg location: %CFGLocation%"
echo "Server host type: %ServerTypeInfo%"
echo "Server name: %GameServerNameEditVar%"
echo "Max palyers: %GameMaxPlayersEditVar%"
echo "Map: %GameMapsListLBVar%"
echo "Password protected: %ServerIsPasswordProtected%"
echo "---------------------------------------------------------"`n

// Main window
%AddMap%
hostname %Quotes%%GameServerNameEditVar%%Quotes%
maxplayers %GameMaxPlayersEditVar%
sv_password %GameServerPasswordEditVar%

// Advanced - server
sv_allowdownload %AllowDownloadFromINI%
sv_allowupload %AllowUploadFromINI%
hide_server %HideServerFromINI%
sv_alltalk %EnableAllTalkFromINI%
sv_cheats %EnableCheatsFromINI%
%AddServerTags%
%AddServerToken%
%AddFastDLURL%
%AddRconPassword%
%AddSVPure%

// Advanced - connection
%AddServerType%
%AddRegion%
%AddMaxRate%
%AddMinRate%
%AddMaxUpdateRate%
%AddMinUpdateRate%
%AddMaxCMDRate%
%AddMinCMDRate%

// Advanced - source tv
tv_enable %EnableSourceTvFromINI%
tv_allow_camera_man %UsePlayerAsCameraFromINI%
tv_relayvoice %PlayVoiceFromINI%
tv_autorecord %AutoRecordAllGamesFromINI%
tv_transmitall %TransmitAllEntitiesFromINI%
tv_delaymapchange %DelayMapChangeFromINI%
%AddSTVName%
%AddSTVPassword%
%AddSTVSnapShotRate%
%AddSTVDelay%
%AddSTVPort%
%AddTimeout%
%AddMaxNumOfClients%

// Advanced - votes
sv_allow_votes %AllowVotingFromINI%
sv_vote_allow_spectators %AllowSpectatorsToVoteFromINI%
sv_vote_bots_allowed %AllowBotsToVoteFromINI%
sv_vote_issue_autobalance_allowed %EnableAutoTeamBalanceVotesFromINI%
sv_vote_issue_changelevel_allowed %AllowChangeLevelVotesFromINI%
sv_vote_issue_changelevel_allowed_mvm %AllowChangeLevelVotesFromINI%
sv_vote_issue_classlimits_allowed %AllowPerClassLimitVotesFromINI%
sv_vote_issue_classlimits_allowed_mvm %AllowPerClassLimitVotesFromINI%
sv_vote_issue_nextlevel_allowed %AllowNextLevelVotesFromINI%
sv_vote_issue_kick_allowed %EnableVoteKickFromINI%
sv_vote_issue_kick_allowed_mvm %EnableVoteKickFromINI%
sv_vote_issue_kick_spectators_mvm %AllowVoteKickSpectatorsInMvMFromINI%
sv_vote_issue_mvm_challenge_allowed %AllowSetMvMChallengeLevelVotesFromINI%
sv_vote_holder_may_vote_no %ForceYesForVoteCallersFromINI%
sv_vote_issue_nextlevel_allowextend %AllowExtendCurrentLevelVotesFromINI%
sv_vote_issue_nextlevel_choicesmode %PresentTheLowestPlaytimeMapsListFromINI%
sv_vote_issue_nextlevel_prevent_change %PreventNextLevelVotesIfOneHasBeenSetFromINI%
sv_vote_issue_restart_game_allowed %AllowRestartGameVotesFromINI%
sv_vote_issue_restart_game_allowed_mvm %AllowRestartGameVotesFromINI%
sv_vote_issue_scramble_teams_allowed %AllowVoteScrambleFromINI%
sv_vote_ui_hide_disabled_issues %ShowDisabledVotesInTheVoteMenuFromINI%
sv_vote_issue_pause_game_allowed %AllowPauseGameVotesFromINI%

// Advanced - map
%AddAllowSpectators%
%AddShowVoiceChatIcons%
%AddDisableRespawnTime%
%AddRestrictTo1ClassOnly%
%AddEnableTeammatesPushAway%
%AddEnableRandomCrits%
%AddSpawnBeachBallOnRoundStart%
%AddEnableGrapplingHook%
%AddEnableMannpowerMode%
%AddEnableMedievalMode%
%AddEnableMedievalAutorp%
%AddFadeToBlackForSpectators%
%AddEnableFriendlyFire%
%AddEnableTauntSliding%
%AddAllowWeaponSwitchWhileTaunting%
%AddEnableBulletSpread%
%AddAllowsLivingPlayersToHearDeadPlayers%
%AddAllowsTruceDuringBossBattle%
%AddPreventPlayerMovementDuringStartup%
%AddTurnPlayersIntoLosers%
%AddEnableSpells%
%AddEnableTeamBalancing%
%AddEnableSuddenDeath%
%AddRestartRoundAfterXNumberOfSec%
%AddMaxIdleTime%
%AddSetGravity%
%AddSetAirAcceleration%
%AddSetPlayerAcceleration%
%AddPlayerRollAngle%
%AddRollAngleSpeed%
%AddRedTeamDmgMultiplier%
%AddBlueTeamDmgMultiplier%
%AddTimescale%
%AddTeamBalanceLimit%
%AddRoundLimit%
%AddMapTimelimit%
%AddStalemateTimelimit%

// Advanced - custom console commands
%GameAdvancedCustomCFGCommandsEditVar%
)
return

GenerateServerLaunchOptions:
(DisableVACFromINI = "1") ? (AddDisableVAC := "-insecure" . A_Space) : (AddDisableVAC := "")
if (AddServerTypeToLaunchOptions = true)
AddServerTypeToLaunchOptionsCode := "-enablefakeip" . A_Space
if (UDPPortFromINI != "")
AddUDPPort := "-port" . A_Space . UDPPortFromINI . A_Space
else
AddUDPPort := ""

LaunchOptionsCode := LaunchOptionsFromINI . A_Space . AddDisableVAC . AddServerTypeToLaunchOptionsCode . AddUDPPort
LaunchOptionsCode := RegExReplace(LaunchOptionsCode, "%A_ServerExeHost%", "Server_boss_" . HostFromINI)
return

GameSearchForMapsOpenWebsiteLB:
gui, GameSearchForMapsOnlineWindow:submit, nohide
if (GameSearchForMapsOpenWebsiteLBVar = "Gamebanana")
run, https://gamebanana.com/mods/cats/5371 	;why is the link for tf2 maps called cats???
else if (GameSearchForMapsOpenWebsiteLBVar = "TF2 Map Archive")
run, https://maps.mevl2.duckdns.org/
else if (GameSearchForMapsOpenWebsiteLBVar = "17buddies")
run, https://www.17buddies.rocks/17b2/View/Maps/Gam/2/Mod/14/Cat/0/All/0/Pag/1/index.html
else if (GameSearchForMapsOpenWebsiteLBVar = "Rotabland")
run, https://www.rotabland.eu/maps/maps.php
gui, GameSearchForMapsOnlineWindow:hide
return

GameSearchForMapsRescanMapsPictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Game_rescan_maps_pic_button", "GameSearchForMapsOnlineWindow", "GameSearchForMapsRescanMapsPictureButtonVar")
gosub, ScanForMaps
return

GameDeleteMapAlwaysOnTopWindowPictureButton:
if (ToggleDeleteMapAlwaysOnTopWindow != 1)
{
    Gui, GameDeleteMapWindow:+AlwaysOnTop
    GuiControl, GameDeleteMapWindow:, GameDeleteMapAlwaysOnTopWindowPictureButtonVar, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Toolbar_pin_window_on.png
    ToggleDeleteMapAlwaysOnTopWindow := 1
    IniWrite, 1, %A_scriptdir%\Server Boss All\Settings.ini, MainWindow, ToggleDeleteMapAlwaysOnTopWindow
}
else if  (ToggleDeleteMapAlwaysOnTopWindow = 1)
{
    Gui, GameDeleteMapWindow:-AlwaysOnTop
    GuiControl, GameDeleteMapWindow:, GameDeleteMapAlwaysOnTopWindowPictureButtonVar, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Toolbar_pin_window_off.png
    ToggleDeleteMapAlwaysOnTopWindow := 0
    IniWrite, 0, %A_scriptdir%\Server Boss All\Settings.ini, MainWindow, ToggleDeleteMapAlwaysOnTopWindow
}
return

GameDeleteMapMinimizeWindowPictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Toolbar_minimize", "GameDeleteMapWindow", "GameDeleteMapMinimizeWindowPictureButtonVar")
Gui, GameDeleteMapWindow:minimize
return

GameDeleteMapCloseWindowPictureButton:
EmulateButtonPress(A_ScriptDir "\Server Boss All\Images\Custom UI controls\Toolbar_close", "GameDeleteMapWindow", "GameDeleteMapCloseWindowPictureButtonVar")
Gui, GameDeleteMapWindow:hide
return

GameDeleteMapWindowDeleteMapPictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Accept_pic_button", "GameDeleteMapWindow", "GameDeleteMapWindowDeleteMapPictureButtonVar")
FileDelete, % ListOfMapsArray[SetMapForDeletion]
GuiControl, MainWindow:, GameMapsListLBVar, |
ListOfMapsArray.delete(SetMapForDeletion)
ListBoxMapsList := ""
for MapName, value in ListOfMapsArray
ListBoxMapsList .= MapName . "|"
ListBoxMapsList .= "Random"
GuiControl, MainWindow:, GameMapsListLBVar, % ListBoxMapsList
GuiControl, MainWindow:choose, GameMapsListLBVar, 1
Gui, GameDeleteMapWindow:hide
return

GameDeleteMapWindowCloseWindowPictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Cancel_pic_button", "GameDeleteMapWindow", "GameDeleteMapWindowCloseWindowPictureButtonVar")
Gui, GameDeleteMapWindow:hide
return

GameMapCycleAlwaysOnTopWindowPictureButton:
if (ToggleMapCycleAlwaysOnTopWindow != 1)
{
    Gui, GameMapCycleWindow:+AlwaysOnTop
    GuiControl, GameMapCycleWindow:, GameMapCycleAlwaysOnTopWindowPictureButtonVar, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Toolbar_pin_window_on.png
    ToggleMapCycleAlwaysOnTopWindow := 1
    IniWrite, 1, %A_scriptdir%\Server Boss All\Settings.ini, MainWindow, ToggleMapCycleAlwaysOnTopWindow
}
else if  (ToggleMapCycleAlwaysOnTopWindow = 1)
{
    Gui, GameMapCycleWindow:-AlwaysOnTop
    GuiControl, GameMapCycleWindow:, GameMapCycleAlwaysOnTopWindowPictureButtonVar, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Toolbar_pin_window_off.png
    ToggleMapCycleAlwaysOnTopWindow := 0
    IniWrite, 0, %A_scriptdir%\Server Boss All\Settings.ini, MainWindow, ToggleMapCycleAlwaysOnTopWindow
}
return

GameMapCycleMinimizeWindowPictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Toolbar_minimize", "GameMapCycleWindow", "GameMapCycleMinimizeWindowPictureButtonVar")
Gui, GameMapCycleWindow:minimize
return

GameMapCycleCloseWindowPictureButton:
EmulateButtonPress(A_ScriptDir "\Server Boss All\Images\Custom UI controls\Toolbar_close", "GameMapCycleWindow", "GameMapCycleCloseWindowPictureButtonVar")
Gui, GameMapCycleWindow:hide
return

GameMapCycleWindowLB:
return

GameMapCycleWindowSearchMapEdit:
gui, GameMapCycleWindow:submit, nohide
GuiControl, GameMapCycleWindow:choose, GameMapCycleWindowLBVar, % GameMapCycleWindowSearchMapEditVar
return

GameMapCycleClearSearchMapEdit:
EmulateConsoleButtonPress("GameMapCycleWindow", "GameMapCycleClearSearchMapEditVar", "x")
GuiControl, GameMapCycleWindow:, GameMapCycleWindowSearchMapEditVar
return

GameAddMapToMapCyclePictureButton:
gui, GameMapCycleWindow:submit, nohide
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Add_pic_button", "GameMapCycleWindow", "GameAddMapToMapCyclePictureButtonVar")
if !RegExMatch(GameMapCycleListEditVar, GameMapCycleWindowLBVar)
{
    NewMapCycleList := GameMapCycleListEditVar . "`n" . GameMapCycleWindowLBVar
    GuiControl, GameMapCycleWindow:, GameMapCycleListEditVar, % NewMapCycleList
    gosub, GameMapCycleListEdit
}
return

GameRemoveMapToMapCyclePictureButton:
gui, GameMapCycleWindow:submit, nohide
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Remove_pic_button", "GameMapCycleWindow", "GameRemoveMapToMapCyclePictureButtonVar")
NewMapCycleList := RegExReplace(GameMapCycleListEditVar, "`n" . GameMapCycleWindowLBVar, "")
GuiControl, GameMapCycleWindow:, GameMapCycleListEditVar, % NewMapCycleList
gosub, GameMapCycleListEdit
return

GameMapCycleListEdit:
gui, GameMapCycleWindow:submit, nohide
Iniread, SelectedHostFromINI, %A_scriptdir%\Server Boss All\Settings.ini, SelectedServerHost, Host
FileDelete, %A_ScriptDir%\Server Boss All\Map cycles\%SelectedHostFromINI%.txt
FileAppend, % GameMapCycleListEditVar, %A_ScriptDir%\Server Boss All\Map cycles\%SelectedHostFromINI%.txt
return

GameFilterMapsLB:
gui, GameFilterMapsWindow:submit, nohide
if (GameFilterMapsLBVar = "arena_")
GuiControl, MainWindow:, GameMapsSearchMapEditVar, arena_
else if (GameFilterMapsLBVar = "cp_")
GuiControl, MainWindow:, GameMapsSearchMapEditVar, cp_
else if (GameFilterMapsLBVar = "ctf_")
GuiControl, MainWindow:, GameMapsSearchMapEditVar, ctf_
else if (GameFilterMapsLBVar = "koth_")
GuiControl, MainWindow:, GameMapsSearchMapEditVar, koth_
else if (GameFilterMapsLBVar = "mvm_")
GuiControl, MainWindow:, GameMapsSearchMapEditVar, mvm_
else if (GameFilterMapsLBVar = "pass_")
GuiControl, MainWindow:, GameMapsSearchMapEditVar, pass_
else if (GameFilterMapsLBVar = "pd_")
GuiControl, MainWindow:, GameMapsSearchMapEditVar, pd_
else if (GameFilterMapsLBVar = "pl_")
GuiControl, MainWindow:, GameMapsSearchMapEditVar, pl_
else if (GameFilterMapsLBVar = "plr_")
GuiControl, MainWindow:, GameMapsSearchMapEditVar, plr_
else if (GameFilterMapsLBVar = "sd_")
GuiControl, MainWindow:, GameMapsSearchMapEditVar, sd_
else if (GameFilterMapsLBVar = "rd_")
GuiControl, MainWindow:, GameMapsSearchMapEditVar, rd_
else if (GameFilterMapsLBVar = "tc_")
GuiControl, MainWindow:, GameMapsSearchMapEditVar, tc_
else if (GameFilterMapsLBVar = "vsh_")
GuiControl, MainWindow:, GameMapsSearchMapEditVar, vsh_
else if (GameFilterMapsLBVar = "zi_")
GuiControl, MainWindow:, GameMapsSearchMapEditVar, zi_
return

GameAdvancedWindowHostsPictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Toolbar_servers", "GameAdvancedWindow", "GameAdvancedWindowHostsPictureButtonVar")
ShowPopUpWindow("Server hosts", "ServerHosts", 40, 40, false, 370, 290, true)
return

GameAdvancedWindowSettingsPictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Toolbar_more_settings_window", "GameAdvancedWindow", "GameAdvancedWindowSettingsPictureButtonVar")
ShowPopUpWindow("Advanced window presets", "GameAdvancedWindowPresets", 30, 20, false, 550, 370, true)
return

GameAdvancedWindowAlwaysOnTopWindowPictureButton:
if (ToggleGameAdvancedWindowOnTop != 1)
{
    Gui, GameAdvancedWindow:+AlwaysOnTop
    GuiControl, GameAdvancedWindow:, GameAdvancedWindowAlwaysOnTopWindowPictureButtonVar, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Toolbar_pin_window_on.png
    ToggleGameAdvancedWindowOnTop := 1
    IniWrite, 1, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, ToggleGameAdvancedWindowOnTop
}
else if  (ToggleGameAdvancedWindowOnTop = 1)
{
    Gui, GameAdvancedWindow:-AlwaysOnTop
    GuiControl, GameAdvancedWindow:, GameAdvancedWindowAlwaysOnTopWindowPictureButtonVar, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Toolbar_pin_window_off.png
    ToggleGameAdvancedWindowOnTop := 0
    IniWrite, 0, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, ToggleGameAdvancedWindowOnTop
}
return

GameAdvancedWindowMinimizeWindowPictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Toolbar_minimize", "GameAdvancedWindow", "GameAdvancedWindowMinimizeWindowPictureButtonVar")
Gui, GameAdvancedWindow:minimize
return

GameAdvancedWindowCloseWindowPictureButton:
EmulateButtonPress(A_ScriptDir "\Server Boss All\Images\Custom UI controls\Toolbar_close", "GameAdvancedWindow", "GameAdvancedWindowCloseWindowPictureButtonVar")
Gui, GameAdvancedWindow:hide
return

AdvancedWindowTab2:
Gui, GameAdvancedWindow:submit, nohide
AdvancedWindowCurrentTab := AdvancedWindowTab2Var
return

;Install server
;--------------------------------------------------------------------------------------------
InstallServerSetupServer:
gui, InstallServerWindow:submit, nohide
gui, MainWindow:submit, nohide
gui MainWindow:default
gui, MainWindow:ListView, PathsHostsLVVar
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Accept_pic_button", "InstallServerWindow", "InstallServerSetupServerVar")
if (InstallServerInstallPathEditVar = "")
{
    DisplayTooltip("Install path is empty!", 3)
    return
}
if (InstallServer32BitHostNameEditVar = "")
{
    DisplayTooltip("32 - bit host name is empty!", 3)
    return
}
if (InstallServer64BitHostNameEditVar = "")
{
    DisplayTooltip("64 - bit host name is empty!", 3)
    return
}
if !FileExist(A_ScriptDir . "\Server Boss All\Downloads\SteamCMD\steamcmd.exe")         ;Download SteamCMD and unzip it
{
    GuiControl, InstallServerWindow:, InstallServerEditVar, Downloading SteamCMD...
    FileCreateDir, %A_ScriptDir%\Server Boss All
    FileCreateDir, %A_ScriptDir%\Server Boss All\Downloads
    FileCreateDir, %A_ScriptDir%\Server Boss All\Downloads\SteamCMD
    SteamCMDExeDownloadPath := A_ScriptDir . "\" . "steamcmd.zip"
    UrlDownloadToFile, https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip, %SteamCMDExeDownloadPath%
    UnzipWithCMDCode := "tar -xf" . A_Space . Chr(34) . SteamCMDExeDownloadPath . Chr(34) . A_Space . "-C" . A_Space . Chr(34) . A_ScriptDir . "\Server Boss All\Downloads\SteamCMD" . Chr(34)
    RunWait, %comspec% /k %UnzipWithCMDCode% && exit,, Hide							   ;Use DOS to unzip the file
    GuiControl, InstallServerWindow:, InstallServerEditVar, Unzipping files...
    FileDelete, %SteamCMDExeDownloadPath%
}
GuiControl, InstallServerWindow:, InstallServerEditVar, Launching SteamCMD...
SteamCmdExePath := Chr(34) . A_ScriptDir . "\Server Boss All\Downloads\SteamCMD\" . "steamcmd.exe" . Chr(34) . A_Space
ForceInstallDirPath := "+force_install_dir" . A_Space . Chr(34) . SelectedHostExePathOutDir . Chr(34) . A_Space
ForceInstallDirPath := "+force_install_dir" . A_Space . Chr(34) . InstallServerInstallPathEditVar . Chr(34) . A_Space
UpdateCode :=  "+login anonymous" . A_Space . "+app_update 232250 validate" . A_Space . "+quit"
SetTimer, MonitorSteamCMDOutput, 1000
MsgBox % SteamCmdExePath ForceInstallDirPath UpdateCode
RunWait, % SteamCmdExePath ForceInstallDirPath UpdateCode,, Hide, SteamCMDPID

FileCreateDir, %A_scriptdir%\Server Boss All\Hosts
if !FileExist(A_scriptdir . "\Server Boss All\Hosts\" . InstallServer32BitHostNameEditVar . ".ini")
{
    guiControl, MainWindow:, PathsHostsListboxVar, % InstallServer32BitHostNameEditVar
    guiControl, ServerHosts:, SelectServerHostListboxVar, % InstallServer32BitHostNameEditVar
    TotalHosts += 1
}
if !FileExist(A_scriptdir . "\Server Boss All\Hosts\" . InstallServer32BitHostNameEditVar . ".ini")
{
    guiControl, MainWindow:, PathsHostsListboxVar, % InstallServer64BitHostNameEditVar
    guiControl, ServerHosts:, SelectServerHostListboxVar, % InstallServer64BitHostNameEditVar
    TotalHosts += 1
}
guiControl, MainWindow:choose, PathsHostsListboxVar, % InstallServer64BitHostNameEditVar

GuiControl, MainWindow:, PathsSelectedHostTextVar, % "Total hosts:" . TotalHosts . A_tab . "Selected host:" . A_Space . InstallServer64BitHostNameEditVar . "                                            _"

IniWrite, %InstallServerInstallPathEditVar%\srcds.exe, %A_scriptdir%\Server Boss All\Hosts\%InstallServer32BitHostNameEditVar%.ini, Paths, Exe
IniWrite, %InstallServerInstallPathEditVar%\tf, %A_scriptdir%\Server Boss All\Hosts\%InstallServer32BitHostNameEditVar%.ini, Paths, Tf
IniWrite, %InstallServerInstallPathEditVar%\tf\maps, %A_scriptdir%\Server Boss All\Hosts\%InstallServer32BitHostNameEditVar%.ini, Paths, Maps
IniWrite, %InstallServerInstallPathEditVar%\tf\cfg, %A_scriptdir%\Server Boss All\Hosts\%InstallServer32BitHostNameEditVar%.ini, Paths, Cfg
IniWrite, %InstallServerInstallPathEditVar%\download, %A_scriptdir%\Server Boss All\Hosts\%InstallServer32BitHostNameEditVar%.ini, Paths, MapDownloads
IniWrite, %InstallServerInstallPathEditVar%\srcds_win64.exe, %A_scriptdir%\Server Boss All\Hosts\%InstallServer64BitHostNameEditVar%.ini, Paths, Exe
IniWrite, %InstallServerInstallPathEditVar%\tf, %A_scriptdir%\Server Boss All\Hosts\%InstallServer64BitHostNameEditVar%.ini, Paths, Tf
IniWrite, %InstallServerInstallPathEditVar%\tf\maps, %A_scriptdir%\Server Boss All\Hosts\%InstallServer64BitHostNameEditVar%.ini, Paths, Maps
IniWrite, %InstallServerInstallPathEditVar%\tf\cfg, %A_scriptdir%\Server Boss All\Hosts\%InstallServer64BitHostNameEditVar%.ini, Paths, Cfg
IniWrite, %InstallServerInstallPathEditVar%\download, %A_scriptdir%\Server Boss All\Hosts\%InstallServer64BitHostNameEditVar%.ini, Paths, MapDownloads

LV_Modify(1, "",, InstallServerInstallPathEditVar . "\srcds_win64.exe")
LV_Modify(2, "",, InstallServerInstallPathEditVar . "\tf")
LV_Modify(3, "",, InstallServerInstallPathEditVar . "\tf\maps")
LV_Modify(4, "",, InstallServerInstallPathEditVar . "\tf\cfg")
LV_Modify(5, "",, "")
LV_Modify(6, "",, InstallServerInstallPathEditVar . "\tf\download")

SelectedHostNameNoExt := InstallServer64BitHostNameEditVar
IniWrite, %InstallServer64BitHostNameEditVar%, %A_scriptdir%\Server Boss All\Settings.ini, LastUsedSettings, PathsHost
SetTimer, MonitorSteamCMDOutput, Delete
VarSetCapacity(SteamCMDPID, 0)
VarSetCapacity(SteamCMDExeDownloadPath, 0)
VarSetCapacity(UnzipWithCMDCode, 0)
VarSetCapacity(SteamCmdExePath, 0)
VarSetCapacity(ForceInstallDirPath, 0)
VarSetCapacity(UpdateCode, 0)
VarSetCapacity(LoggingSteamCMD, 0)
gui, InstallServerWindow:hide
return

MonitorSteamCMDOutput:
if FileExist(A_ScriptDir . "\Server Boss All\Downloads\SteamCMD\logs\bootstrap_log.txt") and !FileExist(A_ScriptDir . "\Server Boss All\Downloads\SteamCMD\logs\console_log.txt")
{
    FileRead, LoggingSteamCMD, %A_ScriptDir%\Server Boss All\Downloads\SteamCMD\logs\bootstrap_log.txt
    GuiControl, InstallServerWindow:, InstallServerEditVar, % LoggingSteamCMD
}
else
{
    FileRead, LoggingSteamCMD, %A_ScriptDir%\Server Boss All\Downloads\SteamCMD\logs\console_log.txt
    GuiControl, InstallServerWindow:, InstallServerEditVar, % LoggingSteamCMD
}
SendMessage, 0x115, 7, 0, Edit1, Install dedicated server                             ;Move scrollbar at bottom
return

InstallServerAbort:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Cancel_pic_button", "InstallServerWindow", "InstallServerAbortVar")
DetectHiddenWindows, On
if WinExist("ahk_pid" . A_Space . SteamCMDPID)
WinClose, ahk_pid %SteamCMDPID%
else
{
    return
}
DetectHiddenWindows, Off
SetTimer, MonitorSteamCMDOutput, Delete
GuiControl, InstallServerWindow:, InstallServerEditVar, Installation aborted!
Sleep, 3000
AnimateInformation("Do you want to setup a tf2 dedicated server?`n`nDownload target >> SteamCMD`n`nRequired space: 13GB`nAvailable space" . A_Space . ObtainDriveFreeSpaceInGB(InstallServerInstallPathEditVar) . "GB`nInstall path:" . A_Space . InstallServerInstallPathEditVar, 40, "Setup dedicated server", "InstallServerWindow", "InstallServerEditVar", 840, 575, "NoCustomCoordinates")
VarSetCapacity(FreeDriveSpace, 0)
return

InstallServerRestorePath:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Game_restart_server_pic_button", "InstallServerWindow", "InstallServerRestorePathVar")
GuiControl, InstallServerWindow:, InstallServerEditVar, % "Do you want to setup a tf2 dedicated server?`n`nDownload target >> SteamCMD`n`nRequired space: 13GB`nAvailable space" . A_Space . ObtainDriveFreeSpaceInGB(InstallServerInstallPathEditVar) . "GB`nInstall path:" . A_Space . A_ScriptDir
GuiControl, InstallServerWindow:, InstallServerInstallPathEditVar, % A_ScriptDir
return

InstallServerInstallPathEdit:
Gui, InstallServerWindow:submit, nohide
GuiControl, InstallServerWindow:, InstallServerEditVar, % "Do you want to setup a tf2 dedicated server?`n`nDownload target >> SteamCMD`n`nRequired space: 13GB`nAvailable space" . A_Space . ObtainDriveFreeSpaceInGB(InstallServerInstallPathEditVar) . "GB`nInstall path:" . A_Space . InstallServerInstallPathEditVar
return

InstallWindowAlwaysOnTopWindowPictureButton:
if (ToggleInstallWindowOnTop != 1)
{
    Gui, InstallServerWindow:+AlwaysOnTop
    GuiControl, InstallServerWindow:, InstallWindowAlwaysOnTopWindowPictureButtonVar, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Toolbar_pin_window_on.png
    ToggleInstallWindowOnTop := 1
}
else if  (ToggleInstallWindowOnTop = 1)
{
    Gui, InstallServerWindow:-AlwaysOnTop
    GuiControl, InstallServerWindow:, InstallWindowAlwaysOnTopWindowPictureButtonVar, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Toolbar_pin_window_off.png
    ToggleInstallWindowOnTop := 0
}
return

InstallWindowMinimizeWindowPictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Toolbar_minimize", "InstallServerWindow", "InstallWindowMinimizeWindowPictureButtonVar")
Gui, InstallServerWindow:minimize
return

InstallWindowCloseWindowPictureButton:
EmulateButtonPress(A_ScriptDir "\Server Boss All\Images\Custom UI controls\Toolbar_close", "InstallServerWindow", "InstallWindowCloseWindowPictureButtonVar")
Gui, InstallServerWindow:hide
return

;Update server
;-----------------------------------------------------------------
UpdateWindowAlwaysOnTopWindowPictureButton:
if (ToggleUpdateWindowOnTop != 1)
{
    Gui, UpdateServerWindow:+AlwaysOnTop
    GuiControl, UpdateServerWindow:, UpdateWindowAlwaysOnTopWindowPictureButtonVar, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Toolbar_pin_window_on.png
    ToggleUpdateWindowOnTop := 1
}
else if  (ToggleUpdateWindowOnTop = 1)
{
    Gui, UpdateServerWindow:-AlwaysOnTop
    GuiControl, UpdateServerWindow:, UpdateWindowAlwaysOnTopWindowPictureButtonVar, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Toolbar_pin_window_off.png
    ToggleUpdateWindowOnTop := 0
}
return

UpdateWindowMinimizeWindowPictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Toolbar_minimize", "UpdateServerWindow", "UpdateWindowMinimizeWindowPictureButtonVar")
Gui, UpdateServerWindow:minimize
return

UpdateWindowCloseWindowPictureButton:
EmulateButtonPress(A_ScriptDir "\Server Boss All\Images\Custom UI controls\Toolbar_close", "UpdateServerWindow", "UpdateWindowCloseWindowPictureButtonVar")
Gui, UpdateServerWindow:hide
return

UpdateServerLV:
gui UpdateServerWindow:default
gui, UpdateServerWindow:ListView, UpdateServerLVVar
LV_GetText(SelectedHost, LV_GetNext(), 1)
GuiControl, UpdateServerWindow:, UpdateServerHostStatusVar, % "Selected host:" . A_Space . SelectedHost . "                          _"
return

UpdateServer:
gui UpdateServerWindow:default
gui, UpdateServerWindow:ListView, UpdateServerLVVar
UpdateAborted := false
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Accept_pic_button", "UpdateServerWindow", "UpdateServerVar")
LV_GetText(UpdateHostName, LV_GetNext(), 1)
if (UpdateHostName = "")
{
    return
}
UpdateHostRowNumber := LV_GetNext()
LV_Modify(LV_GetNext(), "", "Updating...")
FileCreateDir, %A_ScriptDir%\Server Boss All
FileCreateDir, %A_ScriptDir%\Server Boss All\Downloads
FileCreateDir, %A_ScriptDir%\Server Boss All\Downloads\SteamCMD
SteamCMDExeDownloadPath := A_ScriptDir . "\" . "steamcmd.zip"
UrlDownloadToFile, https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip, %SteamCMDExeDownloadPath%
UnzipWithCMDCode := "tar -xf" . A_Space . Chr(34) . SteamCMDExeDownloadPath . Chr(34) . A_Space . "-C" . A_Space . Chr(34) . A_ScriptDir . "\Server Boss All\Downloads\SteamCMD" . Chr(34)
RunWait, %comspec% /k %UnzipWithCMDCode% && exit,, Hide							   ;Use DOS to unzip the file
FileDelete, %SteamCMDExeDownloadPath%
SteamCmdExePath := Chr(34) . A_ScriptDir . "\Server Boss All\Downloads\SteamCMD\" . "steamcmd.exe" . Chr(34) . A_Space
Iniread, SelectedHostFromINI, %A_scriptdir%\Server Boss All\Settings.ini, SelectedServerHost, Host
Iniread, SelectedHostExePathFromINI, %A_scriptdir%\Server Boss All\Hosts\%SelectedHostFromINI%.ini, Paths, Exe
SplitPath, SelectedHostExePathFromINI,, SelectedHostExePathOutDir
ForceInstallDirPath := "+force_install_dir" . A_Space . Chr(34) . SelectedHostExePathOutDir . Chr(34) . A_Space
UpdateCode :=  "+login anonymous" . A_Space . "+app_update 232250 validate" . A_Space . "+quit"
RunWait, % SteamCmdExePath ForceInstallDirPath UpdateCode,, hide, SteamCMDUpdatePID     ;Pc needs to be restarted and no server to be launched when server boss is opened in order for the update to work(cause: unknown)
if (UpdateAborted = false)
LV_Modify(UpdateHostRowNumber, "", UpdateHostName)
else
{
    LV_Modify(UpdateHostRowNumber, "", "Aborted!")
    Sleep, 2000
}
VarSetCapacity(UpdateAborted, 0)
VarSetCapacity(UpdateHostName, 0)
VarSetCapacity(UpdateHostRowNumber, 0)
VarSetCapacity(SteamCMDExeDownloadPath, 0)
VarSetCapacity(UnzipWithCMDCode, 0)
VarSetCapacity(SteamCmdExePath, 0)
VarSetCapacity(UpdateCode, 0)
return

UpdateServerAbort:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Cancel_pic_button", "UpdateServerWindow", "UpdateServerAbortVar")
UpdateAborted := true
DetectHiddenWindows, On
WinClose, ahk_pid %SteamCMDUpdatePID%
DetectHiddenWindows, Off
return

SelectServerHostListbox:
gui, ServerHosts:submit, nohide
IniWrite, %SelectServerHostListboxVar%, %A_scriptdir%\Server Boss All\Settings.ini, SelectedServerHost, Host
GuiControl, ServerHosts:, SelectServerHostCurrentHostTextVar, Current host: %SelectServerHostListboxVar%                                                               _
GuiControl, MainWindow:, ToolbarServerExeHostTextVar, Host : %SelectServerHostListboxVar%
return

;Obtain drive free space in GB
;---------------------------------------------------------------------------
ObtainDriveFreeSpaceInGB(Path) {
    DriveSpaceFree, FreeDriveSpace, % path
    DotPos := InStr(FreeDriveSpace / 1024, ".")                     ;Convert the available space in GB
    if (DotPos > 0)
    {
        return FreeDriveSpaceInGB := SubStr(FreeDriveSpace, 1, DotPos - 1)
    }
    VarSetCapacity(FreeDriveSpace, 0)
    VarSetCapacity(DotPos, 0)
}

;Emulate button press
;____________________________________________________________________________________________
EmulateButtonPress(ImagePath, Window, ControlVariable) {
    GuiControl, %Window%:, %ControlVariable%, % ImagePath . "_pressed.png"
    KeyWait, LButton
    GuiControl, %Window%:, %ControlVariable%, % ImagePath . ".png"
}

;Emulate console button press
;____________________________________________________________________________________________
EmulateConsoleButtonPress(GuiName, ControlVariable, ControlText) {
    GuiControl, %GuiName%:+cffffff, %ControlVariable%
    GuiControl, %GuiName%:, %ControlVariable%, % ControlText
    KeyWait, LButton
    GuiControl, %GuiName%:+c221f1c, %ControlVariable%
    GuiControl, %GuiName%:, %ControlVariable%, % ControlText
}

;Display tooltip information
;____________________________________________________________________________________________
DisplayTooltip(Text, Duration) {
    Tooltip, % Text
    SetTimer, HideTooltip, % "-" . Duration * 1000
}

HideTooltip:
ToolTip
return

;Generate password
;____________________________________________________________________________________________
GeneratePassword(Lenght) {
    GeneratedPass := ""
    loop, % Lenght
    {
        LowerCaseAlphabet := ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
        UpperCaseAlphabet := ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
        Random, CharacterType, 1, 3
        Random, CharacterNumber, 1, 26
        Random, RandomNumber, 0, 9
        if (CharacterType = "1")
        GeneratedPass .= LowerCaseAlphabet[CharacterNumber]
        else if (CharacterType = "2")
        GeneratedPass .= UpperCaseAlphabet[CharacterNumber]
        else
        GeneratedPass .= RandomNumber

    }
    return GeneratedPass
}

;Console
;---------------------------------------------------------------------------------------------
ConsoleOpenConsoleLogFilePictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Console_file_pic_button", "MainWindow", "ConsoleOpenConsoleLogFilePictureButtonVar")
Iniread, SelectedHostFromINI, %A_scriptdir%\Server Boss All\Settings.ini, SelectedServerHost, Host
Iniread, SelectedHostExePathFromINI, %A_scriptdir%\Server Boss All\Hosts\%SelectedHostFromINI%.ini, Paths, Tf
if FileExist(SelectedHostExePathFromINI)
run, % SelectedHostExePathFromINI . "\console.log"
else
DisplayTooltip("Console.log not found!", 3)
return

ConsoleEmpty1PictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Console_empty_pic_button", "MainWindow", "ConsoleEmpty1PictureButtonVar")
return

ConsoleEmpty2PictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Console_empty_pic_button", "MainWindow", "ConsoleEmpty2PictureButtonVar")
return

ConsoleEmpty3PictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Console_empty_pic_button", "MainWindow", "ConsoleEmpty3PictureButtonVar")
return

ConsoleSetColorRed:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Console_set_color_red_pic_button", "MainWindow", "ConsoleSetColorRedVar")
SetConsoleFontColorSize("8f4343")
return

ConsoleSetColorBrown:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Console_set_color_brown_pic_button", "MainWindow", "ConsoleSetColorBrownVar")
SetConsoleFontColorSize("8f5b43")
return

ConsoleSetColorOrange:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Console_set_color_orange_pic_button", "MainWindow", "ConsoleSetColorOrangeVar")
SetConsoleFontColorSize("8f6f43")
return

ConsoleSetColorYellow:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Console_set_color_yellow_pic_button", "MainWindow", "ConsoleSetColorYellowVar")
SetConsoleFontColorSize("8f8b43")
return

ConsoleSetColorGreen:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Console_set_color_green_pic_button", "MainWindow", "ConsoleSetColorGreenVar")
SetConsoleFontColorSize("628f43")
return

ConsoleSetColorDarkGreen:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Console_set_color_dark_green_pic_button", "MainWindow", "ConsoleSetColorDarkGreenVar")
SetConsoleFontColorSize("10900d")
return

ConsoleSetColorCyan:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Console_set_color_cyan_pic_button", "MainWindow", "ConsoleSetColorCyanVar")
SetConsoleFontColorSize("438f89")
return

ConsoleSetColorBlue:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Console_set_color_dark_blue_pic_button", "MainWindow", "ConsoleSetColorBlueVar")
SetConsoleFontColorSize("435d8f")
return

ConsoleSetColorPurple:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Console_set_color_purple_pic_button", "MainWindow", "ConsoleSetColorPurpleVar")
SetConsoleFontColorSize("4d438f")
return

ConsoleSetColorPink:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Console_set_color_pink_pic_button", "MainWindow", "ConsoleSetColorPinkVar")
SetConsoleFontColorSize("8b438f")
return

ConsoleSetColorLightPink:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Console_set_color_light_pink_pic_button", "MainWindow", "ConsoleSetColorLightPinkVar")
SetConsoleFontColorSize("8f435d")
return

ConsoleSetColorDarkGray:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Console_set_color_dark_gray_pic_button", "MainWindow", "ConsoleSetColorDarkGrayVar")
SetConsoleFontColorSize("444444")
return

ConsoleSetColorGray:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Console_set_color_gray_pic_button", "MainWindow", "ConsoleSetColorGrayVar")
SetConsoleFontColorSize("929292")
return

ConsoleSetColorLightGray:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Console_set_color_light_gray_pic_button", "MainWindow", "ConsoleSetColorLightGrayVar")
SetConsoleFontColorSize("bbbbbb")
return

ConsoleSetColorLightYellow:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Console_set_color_light_yellow_pic_button", "MainWindow", "ConsoleSetColorLightYellowVar")
SetConsoleFontColorSize("eae3c9")
return

ConsoleSetColorWhite:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Console_set_color_white_pic_button", "MainWindow", "ConsoleSetColorWhiteVar")
SetConsoleFontColorSize("fdfdfd")
return


ConsoleShowConsolePictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Console_server_console_show_pic_button", "MainWindow", "ConsoleShowConsolePictureButtonVar")
if !WinExist("ahk_pid" . A_Space . Tf2ServerPID)
{
    DisplayTooltip("Server is powered off!", 3)
    return
}
Winshow, ahk_pid %Tf2ServerPID%
WinActivate, % "ahk_pid" . A_Space . Tf2ServerPID
return

ConsoleShowServerInBrowserPictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Console_server_show_pic_button", "MainWindow", "ConsoleShowServerInBrowserPictureButtonVar")
if !WinExist("ahk_pid" . A_Space . Tf2ServerPID)
{
    DisplayTooltip("Server is powered off!", 3)
    return
}
SendConsoleInput("hide_server 0", Tf2ServerPID)
return

ConsoleDisableServerCheatsPictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Console_cheats_off_pic_button", "MainWindow", "ConsoleDisableServerCheatsPictureButtonVar")
if !WinExist("ahk_pid" . A_Space . Tf2ServerPID)
{
    DisplayTooltip("Server is powered off!", 3)
    return
}
SendConsoleInput("sv_cheats 1", Tf2ServerPID)
return

ConsoleHideConsolePictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Console_server_console_hide_pic_button", "MainWindow", "ConsoleHideConsolePictureButtonVar")
if !WinExist("ahk_pid" . A_Space . Tf2ServerPID)
{
    DisplayTooltip("Server is powered off!", 3)
    return
}
Winhide, ahk_pid %Tf2ServerPID%
return

ConsoleHideServerInBrowserPictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Console_server_hide_pic_button", "MainWindow", "ConsoleHideServerInBrowserPictureButtonVar")
if !WinExist("ahk_pid" . A_Space . Tf2ServerPID)
{
    DisplayTooltip("Server is powered off!", 3)
    return
}
SendConsoleInput("hide_server 1", Tf2ServerPID)
return

ConsoleEnableServerCheatsPictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Console_cheats_on_pic_button", "MainWindow", "ConsoleEnableServerCheatsPictureButtonVar")
if !WinExist("ahk_pid" . A_Space . Tf2ServerPID)
{
    DisplayTooltip("Server is powered off!", 3)
    return
}
SendConsoleInput("sv_cheats 1", Tf2ServerPID)
return

ConsoleShowFetchIPWindowPictureButton:
gui, MainWindow:submit, nohide
gui, GameAdvancedWindow:submit, nohide
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Console_ip_fetch_pic_button", "MainWindow", "ConsoleShowFetchIPWindowPictureButtonVar")
(GameServerPasswordEditVar != "") ? (AddServerPassword := ";password" . A_Space . GameServerPasswordEditVar) : (AddServerPassword := "")
PrivateIPVar := "Connect" A_Space . A_IPAddress1 . AddServerPassword
GuiControl, ConsoleFetchIPWindow:, ConsoleFetchIPWindowPrivateIPEditVar, % PrivateIPVar
(AdvancedWindowUDPPortEditVar != "") ? (AddPort := ":" . AdvancedWindowUDPPortEditVar) : (AddPort := "")
PublicIPVar := "Connect" . A_Space . GetIP("http://www.netikus.net/show_ip.html") . AddPort . AddServerPassword
GuiControl, ConsoleFetchIPWindow:, ConsoleFetchIPWindowPublicIPEditVar, % PublicIPVar
gosub, GetFakeIP
gui, ConsoleFetchIPWindow:show, w580 h180
return

ConsoleEmpty4PictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Console_empty_pic_button", "MainWindow", "ConsoleEmpty4PictureButtonVar")
return

ConsoleEmpty5PictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Console_empty_pic_button", "MainWindow", "ConsoleEmpty5PictureButtonVar")
return

ConsoleEmpty6PictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Console_empty_pic_button", "MainWindow", "ConsoleEmpty6PictureButtonVar")
return

ConsoleEmpty7PictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Console_empty_pic_button", "MainWindow", "ConsoleEmpty7PictureButtonVar")
return

ConsoleEmpty8PictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Console_empty_pic_button", "MainWindow", "ConsoleEmpty8PictureButtonVar")
return

ConsoleEmpty9PictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Console_empty_pic_button", "MainWindow", "ConsoleEmpty9PictureButtonVar")
return

ConsoleEmpty10PictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Console_empty_pic_button", "MainWindow", "ConsoleEmpty10PictureButtonVar")
return

ConsoleEmpty11PictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Console_empty_pic_button", "MainWindow", "ConsoleEmpty11PictureButtonVar")
return

ConsoleEmpty12PictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Console_empty_pic_button", "MainWindow", "ConsoleEmpty12PictureButtonVar")
return

ConsoleEmpty13PictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Console_empty_pic_button", "MainWindow", "ConsoleEmpty13PictureButtonVar")
return

ConsoleEmpty14PictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Console_empty_pic_button", "MainWindow", "ConsoleEmpty14PictureButtonVar")
return

ConsoleEmpty15PictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Console_empty_pic_button", "MainWindow", "ConsoleEmpty15PictureButtonVar")
return

ConsoleEmpty16PictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Console_empty_pic_button", "MainWindow", "ConsoleEmpty16PictureButtonVar")
return

ConsoleEmpty17PictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Console_empty_pic_button", "MainWindow", "ConsoleEmpty17PictureButtonVar")
return

ConsoleTextSizePicture:
return

ApplyConsoleToggleConsoleLogFileMonitoringFromINI:
IniRead, ToggleConsoleLogFileMonitoringFromINI, %A_scriptdir%\Server Boss All\Settings.ini, MainWindow, ToggleConsoleLogFileMonitoring
if (ToggleConsoleLogFileMonitoringFromINI = "1")
GuiControl, MainWindow:, ConsoleToggleConsoleLogFileMonitoringVar, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png
else
GuiControl, MainWindow:, ConsoleToggleConsoleLogFileMonitoringVar, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png
return

ConsoleToggleConsoleLogFileMonitoring:
ToggleButtonAnimation("MainWindow", "MainWindow", "ToggleConsoleLogFileMonitoring", "ConsoleToggleConsoleLogFileMonitoringVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
return

GetIP(URL) {
	http:=ComObjCreate("WinHttp.WinHttpRequest.5.1")
	http.Open("GET",URL,1)
	http.Send()
    try	http.WaitForResponse
	try If (http.ResponseText="Error")
	{
		Return
	}
    try	return http.ResponseText
}

GetFakeIP:
gui, MainWindow:submit, nohide
IniRead, HostFromINI, %A_scriptdir%\Server Boss All\Settings.ini, SelectedServerHost, Host
IniRead, HostTFFromINI, %A_scriptdir%\Server Boss All\Hosts\%HostFromINI%.ini, Paths, Tf
if WinExist("ahk_pid" . A_Space . Tf2ServerPID)
{
    Loop, read, %HostTFFromINI%\console.log
    {
        If InStr(A_LoopReadLine, "FakeIP allocation succeeded:")
        {
            RegExMatch(A_LoopReadLine, "FakeIP allocation succeeded: (\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}:\d+)", Match)
            FakeIPVar := "Connect" . A_Space . Match1 . AddServerPassword
        }
    }
    GuiControl, ConsoleFetchIPWindow:, ConsoleFetchIPWindowFakeIPEditVar, % FakeIPVar
}
return

ConsoleSendInputText:
gui, MainWindow:submit, nohide
EmulateConsoleButtonPress("MainWindow", "ConsoleSendInputTextVar", ">")
if !WinExist("ahk_pid" . A_Space . Tf2ServerPID)
{
    DisplayTooltip("Server is powered off!", 3)
    return
}
SendConsoleInput(ConsoleInputEditVar, Tf2ServerPID)
return

ConsoleFetchIPAlwaysOnTopWindowPictureButton:
if (ToggleConsoleFetchIPAlwaysOnTop != 1)
{
    Gui, ConsoleFetchIPWindow:+AlwaysOnTop
    GuiControl, ConsoleFetchIPWindow:, ConsoleFetchIPAlwaysOnTopWindowPictureButtonVar, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Toolbar_pin_window_on.png
    ToggleConsoleFetchIPAlwaysOnTop := 1
}
else if  (ToggleConsoleFetchIPAlwaysOnTop = 1)
{
    Gui, ConsoleFetchIPWindow:-AlwaysOnTop
    GuiControl, ConsoleFetchIPWindow:, ConsoleFetchIPAlwaysOnTopWindowPictureButtonVar, %A_ScriptDir%\Server Boss All\Images\Custom UI controls\Toolbar_pin_window_off.png
    ToggleConsoleFetchIPAlwaysOnTop := 0
}
return

ConsoleFetchIPWindowMinimizeWindowPictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Toolbar_minimize", "ConsoleFetchIPWindow", "ConsoleFetchIPWindowMinimizeWindowPictureButtonVar")
Gui, ConsoleFetchIPWindow:minimize
return

ConsoleFetchIPWindowCloseWindowPictureButton:
EmulateButtonPress(A_ScriptDir "\Server Boss All\Images\Custom UI controls\Toolbar_close", "ConsoleFetchIPWindow", "ConsoleFetchIPWindowCloseWindowPictureButtonVar")
Gui, ConsoleFetchIPWindow:hide
return

ConsoleCopyPrivateIPToClipboardText:
gui, ConsoleFetchIPWindow:submit, nohide
EmulateConsoleButtonPress("ConsoleFetchIPWindow", "ConsoleCopyPrivateIPToClipboardTextVar", Chr(0x1F4CB))
Clipboard := ConsoleFetchIPWindowPrivateIPEditVar
DisplayTooltip("Private IP copied to Clipboard!", 3)
return

ConsoleCopyPublicIPToClipboardText:
gui, ConsoleFetchIPWindow:submit, nohide
EmulateConsoleButtonPress("ConsoleFetchIPWindow", "ConsoleCopyPublicIPToClipboardTextVar", Chr(0x1F4CB))
Clipboard := ConsoleFetchIPWindowPublicIPEditVar
DisplayTooltip("Public IP copied to Clipboard!", 3)
return

ConsoleCopyFakeIPToClipboardText:
gui, ConsoleFetchIPWindow:submit, nohide
EmulateConsoleButtonPress("ConsoleFetchIPWindow", "ConsoleCopyFakeIPToClipboardTextVar", Chr(0x1F504))
gosub, GetFakeIP
Clipboard := ConsoleFetchIPWindowFakeIPEditVar
DisplayTooltip("Fake IP copied to Clipboard!", 3)
return

SendConsoleInput(ConsoleInputCode, ServerPID) {
    AllClipboardContentsSavedToVar := ClipboardAll  ;Save all clipboard contents inside a variable
    Clipboard := "echo" . A_Space . ConsoleInputCode . ";" ConsoleInputCode
    DetectHiddenWindows, on
    ControlSend, , ^v, % "ahk_pid" . A_Space . ServerPID
    ControlSend, , {Enter}, % "ahk_pid" . A_Space . ServerPID
    Clipboard := AllClipboardContentsSavedToVar
    GuiControl, MainWindow:, ConsoleInputEditVar
}

SetConsoleFontColorSize(Color) {
    IniRead, ConsoleSizeFromINI, %A_scriptdir%\Server Boss All\Settings.ini, MainWindow, ConsoleSize
    Gui, MainWindow:font, c%Color% s%ConsoleSizeFromINI% bold, MS Gothic
    GuiControl, MainWindow:font, ConsoleEditVar
    GuiControl, MainWindow:+c%Color%, % ConsoleSetColorRedVar
    IniWrite, %Color%, %A_scriptdir%\Server Boss All\Settings.ini, MainWindow, ConsoleColor
}

;Paths
;----------------------------------------------------------------------------------------------
ScanForHosts:
HostsList := ""
NoHosts := 0
CheckForExistingHost := {}
Loop, files, %A_scriptdir%\Server Boss All\Hosts\*.ini, F
{
    SplitPath, A_LoopFileFullPath,,,, HostNameNoExt
    if (A_index = 1) and (FirstFoundHost != True)
    {
        GuiControl, MainWindow:, PathsSelectedHostTextVar, % HostNameNoExt . "                          _"
        FirstFoundHost := True
        SelectedHostNameNoExt := HostNameNoExt
        PathsHostsListboxVar := HostNameNoExt
    }
    HostsList .= HostNameNoExt . "|"
    CheckForExistingHost[HostNameNoExt] := "1"
    TotalHosts := A_index
    NoHosts := A_index
}
if (NoHosts = 0)
{
    TotalHosts := NoHosts
    PathsHostsListboxVar := ""
}
Iniread, SelectedHostFromINI, %A_scriptdir%\Server Boss All\Settings.ini, SelectedServerHost, Host
GuiControl, MainWindow:, PathsHostsListboxVar, % HostsList
GuiControl, MainWindow:, PathsSelectedHostTextVar, % "Total hosts:" . TotalHosts . A_tab . "Selected host:" . A_Space . PathsHostsListboxVar . "                                            _"
GuiControl, ServerHosts:, SelectServerHostListboxVar, |
GuiControl, ServerHosts:, SelectServerHostListboxVar, % HostsList
GuiControl, ServerHosts:, SelectServerHostCurrentHostTextVar, Current host: %SelectedHostFromINI%                                                                _
GuiControl, ServerHosts:choose, SelectServerHostListboxVar, %SelectedHostFromINI%
return

SetLastSavedHostsAndPaths:
IniRead, PathsLastSavedHostFromINI, %A_scriptdir%\Server Boss All\Settings.ini, LastUsedSettings, PathsHost
GuiControl, MainWindow:choose, PathsHostsListboxVar, % PathsLastSavedHostFromINI
gosub, PathsHostsListbox
return

PathsHostsListbox:
gui, MainWindow:submit, nohide
gui MainWindow:default
gui, MainWindow:ListView, PathsHostsLVVar
Iniread, EXEPathFromINI, %A_scriptdir%\Server Boss All\Hosts\%PathsHostsListboxVar%.ini, Paths, Exe
Iniread, TFPathFromINI, %A_scriptdir%\Server Boss All\Hosts\%PathsHostsListboxVar%.ini, Paths, Tf
Iniread, MapsPathFromINI, %A_scriptdir%\Server Boss All\Hosts\%PathsHostsListboxVar%.ini, Paths, Maps
Iniread, CFGPathFromINI, %A_scriptdir%\Server Boss All\Hosts\%PathsHostsListboxVar%.ini, Paths, Cfg
Iniread, GameWorkshopPathFromINI, %A_scriptdir%\Server Boss All\Hosts\%PathsHostsListboxVar%.ini, Paths, GameWorkshop
Iniread, MapDownloadsPathFromINI, %A_scriptdir%\Server Boss All\Hosts\%PathsHostsListboxVar%.ini, Paths, MapDownloads
LV_Modify(1, "",, (EXEPathFromINI != "ERROR") ? (EXEPathFromINI) : (""))
LV_Modify(2, "",, (TFPathFromINI != "ERROR") ? (TFPathFromINI) : (""))
LV_Modify(3, "",, (MapsPathFromINI != "ERROR") ? (MapsPathFromINI) : (""))
LV_Modify(4, "",, (CFGPathFromINI != "ERROR") ? (CFGPathFromINI) : (""))
LV_Modify(5, "",, (GameWorkshopPathFromINI != "ERROR") ? (GameWorkshopPathFromINI) : (""))
LV_Modify(6, "",, (MapDownloadsPathFromINI != "ERROR") ? (MapDownloadsPathFromINI) : (""))
GuiControl, MainWindow:, PathsSelectedHostTextVar, % "Total hosts:" . TotalHosts . A_tab . "Selected host:" . A_Space . PathsHostsListboxVar . "                                            _"
SelectedHostNameNoExt := PathsHostsListboxVar
IniWrite, %PathsHostsListboxVar%, %A_scriptdir%\Server Boss All\Settings.ini, LastUsedSettings, PathsHost
return

PathsRemoveHostListbox:
EmulateConsoleButtonPress("MainWindow", "PathsRemoveHostListboxVar", "-")
gui, MainWindow:submit, nohide
FileDelete, %A_scriptdir%\Server Boss All\Hosts\%PathsHostsListboxVar%.ini
GuiControl, MainWindow:, PathsHostsListboxVar, |
gosub, ScanForHosts
return

PathsAddHostTextButton:
EmulateConsoleButtonPress("MainWindow", "PathsAddHostTextButtonVar", "+")
gui, MainWindow:submit, nohide
if (PathsAddHostEditVar = "") or FileExist(A_ScriptDir . "\Server Boss All\Hosts\" . PathsAddHostEditVar . ".ini")
{
    return
}
FileCreateDir, %A_scriptdir%\Server Boss All\Hosts
Filedelete, %A_scriptdir%\Server Boss All\Hosts\%PathsAddHostEditVar%.ini
FileAppend,, %A_scriptdir%\Server Boss All\Hosts\%PathsAddHostEditVar%.ini
guiControl, MainWindow:, PathsHostsListboxVar, % PathsAddHostEditVar
guiControl, MainWindow:, PathsAddHostEditVar                                    ;Empty edit field on button press
TotalHosts += 1
guicontrol, MainWindow:choose, PathsHostsListboxVar, % TotalHosts
GuiControl, MainWindow:, PathsSelectedHostTextVar, % "Total hosts:" . TotalHosts . A_tab . "Selected host:" . A_Space . PathsHostsListboxVar . "                                            _"
guiControl, ServerHosts:, SelectServerHostListboxVar, % PathsAddHostEditVar
gosub, PathsHostsListbox
return

PathsChangePathLV:
gui, MainWindow:submit, nohide
gui MainWindow:default
gui, MainWindow:ListView, PathsChangePathInINILVVar
if (A_GuiEvent = "I") and InStr(ErrorLevel, "S", false)				    		;Execute code if selected
{
    LV_GetText(SelectedPath, LV_GetNext(), 1)
    GuiControl, MainWindow:, PathsSelectedPathTextVar, % "Selected path:" . A_Space . SelectedPath . "                                           _"
}
return

PathsEditPathText:
EmulateConsoleButtonPress("MainWindow", "PathsEditPathTextVar", Chr(0x270F))
gui, MainWindow:submit, nohide
gui MainWindow:default
gui, MainWindow:ListView, PathsChangePathInINILVVar
LV_GetText(SelectedPath, LV_GetNext(), 1)
if (SelectedPath = "exe host file")
{
    LV_Modify(1, "",, PathsChangePathEditVar)
    IniWrite, %PathsChangePathEditVar%, %A_scriptdir%\Server Boss All\Hosts\%SelectedHostNameNoExt%.ini, Paths, Exe
}
else if (SelectedPath = "Tf folder")
{
    LV_Modify(2, "",, PathsChangePathEditVar)
    IniWrite, %PathsChangePathEditVar%, %A_scriptdir%\Server Boss All\Hosts\%SelectedHostNameNoExt%.ini, Paths, Tf
}
else if (SelectedPath = "Maps folder")
{
    LV_Modify(3, "",, PathsChangePathEditVar)
    IniWrite, %PathsChangePathEditVar%, %A_scriptdir%\Server Boss All\Hosts\%SelectedHostNameNoExt%.ini, Paths, Maps
}
else if (SelectedPath = "Cfg folder")
{
    LV_Modify(4, "",, PathsChangePathEditVar)
    IniWrite, %PathsChangePathEditVar%, %A_scriptdir%\Server Boss All\Hosts\%SelectedHostNameNoExt%.ini, Paths, Cfg
}
else if (SelectedPath = "Steam workshop folder")
{
    LV_Modify(5, "",, PathsChangePathEditVar)
    IniWrite, %PathsChangePathEditVar%, %A_scriptdir%\Server Boss All\Hosts\%SelectedHostNameNoExt%.ini, Paths, GameWorkshop
}
else if (SelectedPath = "Game download folder")
{
    LV_Modify(6, "",, PathsChangePathEditVar)
    IniWrite, %PathsChangePathEditVar%, %A_scriptdir%\Server Boss All\Hosts\%SelectedHostNameNoExt%.ini, Paths, MapDownloads
}
GuiControl, MainWindow:, PathsChangePathEditVar
return

PathOpenPathText:
EmulateConsoleButtonPress("MainWindow", "PathOpenPathTextVar", Chr(0x1F4C2))
gui, MainWindow:submit, nohide
gui MainWindow:default
gui, MainWindow:ListView, PathsChangePathInINILVVar
LV_GetText(SelectedPathName, LV_GetNext(), 1)
LV_GetText(SelectedPath, LV_GetNext(), 2)
if !FileExist(SelectedPath)
{
    DisplayTooltip("Path not found!", 3)
    return
}
if FileExist(SelectedPath) and (SelectedPathName = "exe host file")
try Run, % "explorer.exe /select," . Chr(34) . SelectedPath . Chr(34)
else
try run, % SelectedPath
return

PathInfoText:
EmulateConsoleButtonPress("MainWindow", "PathInfoTextVar", "?")
gui, MainWindow:submit, nohide
gui MainWindow:default
gui, MainWindow:ListView, PathsChangePathInINILVVar
LV_GetText(SelectedPath, LV_GetNext(), 1)
LV_GetText(SelectedSavedPath, LV_GetNext(), 2)
if (SelectedPath = "exe host file")
DisplayTooltip("Path to exe host.`nEx: C:\Program Files (x86)\Steam\steamapps\common\Team Fortress 2\tf_win64.exe`nEx: D:\My tf2 server\srcds.exe`n`nCurrent path:" . A_Space . SelectedSavedPath, 5)
else if (SelectedPath = "Tf folder")
DisplayTooltip("Path to tf folder.`nEx: C:\Program Files (x86)\Steam\steamaps\common\Team Fortress 2\tf`nEx: D:\My dedicated tf2 server\tf`n`nCurrent path:" . A_Space . SelectedSavedPath, 5)
else if (SelectedPath = "Maps folder")
DisplayTooltip("Path to tf\maps folder.`nEx: C:\Program Files (x86)\Steam\steamaps\common\Team Fortress 2\tf\maps`nEx: D:\My dedicated tf2 server\tf\maps`n`nCurrent path:" . A_Space . SelectedSavedPath, 5)
else if (SelectedPath = "Cfg folder")
DisplayTooltip("Path to tf\cfg folder.`nEx: C:\Program Files (x86)\Steam\steamaps\common\Team Fortress 2\tf\cfg`nEx: D:\My dedicated tf2 server\tf\cfg`n`nCurrent path:" . A_Space . SelectedSavedPath, 5)
else if (SelectedPath = "Steam workshop folder")
DisplayTooltip("Path to tf2 workshop folder.`nEx: C:\Program Files (x86)\Steam\steamapps\workshop\content\440`n`nCurrent path:" . A_Space . SelectedSavedPath, 5)
else if (SelectedPath = "Game download folder")
DisplayTooltip("Path to tf\download folder.`nEx: C:\Program Files (x86)\Steam\steamaps\common\Team Fortress 2\tf\download`nEx: D:\My dedicated tf2 server\tf\download`n`nCurrent path:" . A_Space . SelectedSavedPath, 5)
return

PathsAddGameEXEPictureButton:
ScanTarget := "srcds"
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Paths_find_dedicated_server_files_and_paths_x32_bit_pic_button", "MainWindow", "PathsAddGameEXEPictureButtonVar")
if (ScanInProgress = true)
{
    gui, ScanWindow:show
    return
}
AnimateInformation("Do you want server boss to scan for dedicated servers on your computer?`n`nTarget >> srcds.exe`n`nMode: Full scan(Server boss will scan the entire pc for srcds.exe)[Not recommended]`nScan speed: slow" . A_Space . SelectedSavedPath, 40, "Scan for srcds.exe", "ScanWindow", "ConfirmationEditVar", 570, 375, "NoCustomCoordinates")
return

PathsAddGame64EXEPictureButton:
ScanTarget := "srcds_win64"
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Paths_find_dedicated_server_files_and_paths_x64_bit_pic_button", "MainWindow", "PathsAddGame64EXEPictureButtonVar")
if (ScanInProgress = true)
{
    gui, ScanWindow:show
    return
}
AnimateInformation("Do you want server boss to scan for dedicated servers on your computer?`n`nTarget >> srcds_win64.exe`n`nMode: Full scan(Server boss will scan the entire pc for srcds_win64.exe)[Not recommended]`nScan speed: slow" . A_Space . SelectedSavedPath, 40, "Scan for srcds_win64.exe", "ScanWindow", "ConfirmationEditVar", 570, 375, "NoCustomCoordinates")
return

PathsAddGameTF32EXEPictureButton:
gui, MainWindow:submit, nohide
gui MainWindow:default
gui, MainWindow:ListView, PathsHostsLVVar
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Paths_find_game_tf2_files_and_paths_x32_bit_pic_button", "MainWindow", "PathsAddGameTF32EXEPictureButtonVar")
FoundExeHostPath := [FindTF2InstallPath("tf.exe")]
ScanTarget := "tf"
gosub, UpdateHostList
return

PathsAddGameTF64EXEPictureButton:
gui, MainWindow:submit, nohide
gui MainWindow:default
gui, MainWindow:ListView, PathsHostsLVVar
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Paths_find_game_tf2_files_and_paths_x64_bit_pic_button", "MainWindow", "PathsAddGameTF64EXEPictureButtonVar")
FoundExeHostPath := [FindTF2InstallPath("tf_win64.exe")]
ScanTarget := "tf_win64"
gosub, UpdateHostList
return

PathsInstallServerPictureButton:
gui, InstallServerWindow:submit, nohide
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Paths_install_dedicated_server_pic_button", "MainWindow", "PathsInstallServerPictureButtonVar")
if WinExist("ahk_pid" . A_Space . SteamCMDPID)
{
    gui, InstallServerWindow:show
    return
}
AnimateInformation("Do you want to setup a tf2 dedicated server?`n`nDownload target >> SteamCMD`n`nRequired space: 13GB`nAvailable space" . A_Space . ObtainDriveFreeSpaceInGB(InstallServerInstallPathEditVar) . "GB`nInstall path:" . A_Space . InstallServerInstallPathEditVar, 40, "Setup dedicated server", "InstallServerWindow", "InstallServerEditVar", 840, 615, "NoCustomCoordinates")
VarSetCapacity(FreeDriveSpace, 0)
return

PathsUpdateServerPictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Paths_update_server_pic_button", "MainWindow", "PathsUpdateServerPictureButtonVar")
gui UpdateServerWindow:default
gui, UpdateServerWindow:ListView, UpdateServerLVVar
LV_Delete()
loop, Files, %A_scriptdir%\Server Boss All\Hosts\*.ini, F
{
    SplitPath, A_LoopFileFullPath,,,, HostOutNameNoExt
    Iniread, HostEXEPathFromINI, %A_LoopFileFullPath%, Paths, Exe
    SplitPath, HostEXEPathFromINI,, HostEXEOutDir,, HostEXEOutNameNoExt
    if (HostEXEOutNameNoExt = "srcds") or (HostEXEOutNameNoExt = "srcds_win64")
    LV_Add("", HostOutNameNoExt, HostEXEOutDir)
}
gui, UpdateServerWindow:show, w510 h520
return

PathsEmpty1PictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Console_empty_pic_button", "MainWindow", "PathsEmpty1PictureButtonVar")
return

PathsEmpty2PictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Console_empty_pic_button", "MainWindow", "PathsEmpty2PictureButtonVar")
return

PathsEmpty3PictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Console_empty_pic_button", "MainWindow", "PathsEmpty3PictureButtonVar")
return

PathsEmpty4PictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Console_empty_pic_button", "MainWindow", "PathsEmpty4PictureButtonVar")
return

PathsEmpty5PictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Console_empty_pic_button", "MainWindow", "PathsEmpty5PictureButtonVar")
return

PathsEmpty6PictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Console_empty_pic_button", "MainWindow", "PathsEmpty6PictureButtonVar")
return

PathsEmpty7PictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Console_empty_pic_button", "MainWindow", "PathsEmpty7PictureButtonVar")
return

PathsEmpty8PictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Console_empty_pic_button", "MainWindow", "PathsEmpty8PictureButtonVar")
return

PathsEmpty9PictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Console_empty_pic_button", "MainWindow", "PathsEmpty9PictureButtonVar")
return

PathsEmpty10PictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Console_empty_pic_button", "MainWindow", "PathsEmpty10PictureButtonVar")
return

PathsEmpty11PictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Console_empty_pic_button", "MainWindow", "PathsEmpty11PictureButtonVar")
return

PathsEmpty12PictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Console_empty_pic_button", "MainWindow", "PathsEmpty12PictureButtonVar")
return

PathsAddGame32EXEPathPictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Paths_find_game_x32_bit_pic_button", "MainWindow", "PathsAddGame32EXEPathPictureButtonVar")
gui, MainWindow:submit, nohide
gui MainWindow:default
gui, MainWindow:ListView, PathsChangePathInINILVVar
LV_Modify(1, "",, FindTF2InstallPath("tf.exe"))
IniWrite, % FindTF2InstallPath("tf.exe"), %A_scriptdir%\Server Boss All\Hosts\%SelectedHostNameNoExt%.ini, Paths, Exe
return

PathsAddGame64EXEPathPictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Paths_find_game_x64_bit_pic_button", "MainWindow", "PathsAddGame64EXEPathPictureButtonVar")
gui, MainWindow:submit, nohide
gui MainWindow:default
gui, MainWindow:ListView, PathsChangePathInINILVVar
LV_Modify(1, "",, FindTF2InstallPath("tf_win64.exe"))
IniWrite, % FindTF2InstallPath("tf_win64.exe"), %A_scriptdir%\Server Boss All\Hosts\%SelectedHostNameNoExt%.ini, Paths, Exe
return

PathsAddSRCDS32EXEPathPictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Paths_find_dedicated_server_x32_bit_pic_button", "MainWindow", "PathsAddSRCDS32EXEPathPictureButtonVar")
gui, MainWindow:submit, nohide
gui MainWindow:default
gui, MainWindow:ListView, PathsChangePathInINILVVar
loop, files, %A_ScriptDir%\*.exe, FR
{
    if (A_LoopFileName = "srcds.exe")
    {
        LV_Modify(1, "",, A_LoopFileFullPath)
        IniWrite, %A_LoopFileFullPath%, %A_scriptdir%\Server Boss All\Hosts\%SelectedHostNameNoExt%.ini, Paths, Exe
        break
    }
}
return

PathsAddSRCDS64EXEPathPictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Paths_find_dedicated_server_x64_bit_pic_button", "MainWindow", "PathsAddSRCDS64EXEPathPictureButtonVar")
gui, MainWindow:submit, nohide
gui MainWindow:default
gui, MainWindow:ListView, PathsChangePathInINILVVar
loop, files, %A_ScriptDir%\*.exe, FR
{
    if (A_LoopFileName = "srcds_win64.exe")
    {
        LV_Modify(1, "",, A_LoopFileFullPath)
        IniWrite, %A_LoopFileFullPath%, %A_scriptdir%\Server Boss All\Hosts\%SelectedHostNameNoExt%.ini, Paths, Exe
        break
    }
}
return

PathsEmpty13PictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Console_empty_pic_button", "MainWindow", "PathsEmpty13PictureButtonVar")
return

PathsEmpty14PictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Console_empty_pic_button", "MainWindow", "PathsEmpty14PictureButtonVar")
return

PathsAddGameTFFolderPictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Paths_tf_folder_pic_button", "MainWindow", "PathsAddGameTFFolderPictureButtonVar")
gui, MainWindow:submit, nohide
gui MainWindow:default
gui, MainWindow:ListView, PathsChangePathInINILVVar
LV_GetText(HostEXEPath, 1, 2)
SplitPath, HostEXEPath,, TfGamePath
if FileExist(TfGamePath . "\tf")
LV_Modify(2, "",, TfGamePath . "\tf")
IniWrite, %TfGamePath%\tf, %A_scriptdir%\Server Boss All\Hosts\%SelectedHostNameNoExt%.ini, Paths, Tf
VarSetCapacity(TfGamePath, 0)
return

PathsAddGameTFMapsFolderPictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Paths_maps_folder_pic_button", "MainWindow", "PathsAddGameTFMapsFolderPictureButtonVar")
gui, MainWindow:submit, nohide
gui MainWindow:default
gui, MainWindow:ListView, PathsChangePathInINILVVar
LV_GetText(HostEXEPath, 1, 2)
SplitPath, HostEXEPath,, TfGamePath
if FileExist(TfGamePath . "\tf\maps")
LV_Modify(3, "",, TfGamePath . "\tf\maps")
IniWrite, %TfGamePath%\tf\maps, %A_scriptdir%\Server Boss All\Hosts\%SelectedHostNameNoExt%.ini, Paths, Maps
VarSetCapacity(TfGamePath, 0)
return

PathsAddGameTFCfgFolderPictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Paths_cfg_folder_pic_button", "MainWindow", "PathsAddGameTFCfgFolderPictureButtonVar")
gui, MainWindow:submit, nohide
gui MainWindow:default
gui, MainWindow:ListView, PathsChangePathInINILVVar
LV_GetText(HostEXEPath, 1, 2)
SplitPath, HostEXEPath,, TfGamePath
if FileExist(TfGamePath . "\tf\cfg")
LV_Modify(4, "",, TfGamePath . "\tf\cfg")
IniWrite, %TfGamePath%\tf\cfg, %A_scriptdir%\Server Boss All\Hosts\%SelectedHostNameNoExt%.ini, Paths, Cfg
VarSetCapacity(TfGamePath, 0)
return

PathsAddGameWorkshopFolderPictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Paths_game_workshop_folder_pic_button", "MainWindow", "PathsAddGameWorkshopFolderPictureButtonVar")
gui, MainWindow:submit, nohide
gui MainWindow:default
gui, MainWindow:ListView, PathsChangePathInINILVVar
LV_GetText(HostEXEPath, 1, 2)
SplitPath, HostEXEPath,, TeamFortress2Folder
SplitPath, TeamFortress2Folder,, CommonsFolder
SplitPath, CommonsFolder,, SteamAppsFolder
if FileExist(SteamAppsFolder . "\workshop\content\440")
LV_Modify(5, "",, SteamAppsFolder . "\workshop\content\440")
IniWrite, %SteamAppsFolder%\workshop\content\440, %A_scriptdir%\Server Boss All\Hosts\%SelectedHostNameNoExt%.ini, Paths, GameWorkshop
VarSetCapacity(SteamAppsFolder, 0)
return

PathsAddGameDownloadFolderPictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Paths_maps_download_folder_pic_button", "MainWindow", "PathsAddGameDownloadFolderPictureButtonVar")
gui, MainWindow:submit, nohide
gui MainWindow:default
gui, MainWindow:ListView, PathsChangePathInINILVVar
LV_GetText(HostEXEPath, 1, 2)
SplitPath, HostEXEPath,, TfGamePath
if FileExist(TfGamePath . "\tf\download")
LV_Modify(6, "",, TfGamePath . "\tf\download")
IniWrite, %TfGamePath%\tf\download, %A_scriptdir%\Server Boss All\Hosts\%SelectedHostNameNoExt%.ini, Paths, MapDownloads
VarSetCapacity(TfGamePath, 0)
return

PathsEmpty15PictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Console_empty_pic_button", "MainWindow", "PathsEmpty15PictureButtonVar")
return

PathsEmpty16PictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Console_empty_pic_button", "MainWindow", "PathsEmpty16PictureButtonVar")
return

PathsEmpty17PictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Console_empty_pic_button", "MainWindow", "PathsEmpty17PictureButtonVar")
return

PathsEmpty18PictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Console_empty_pic_button", "MainWindow", "PathsEmpty18PictureButtonVar")
return

PathsEmpty19PictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Console_empty_pic_button", "MainWindow", "PathsEmpty19PictureButtonVar")
return

PathsEmpty20PictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Console_empty_pic_button", "MainWindow", "PathsEmpty20PictureButtonVar")
return

PathsEmpty21PictureButton:
EmulateButtonPress(A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Console_empty_pic_button", "MainWindow", "PathsEmpty21PictureButtonVar")
return

;Read/Apply saved settings
;----------------------------------------------------------------------------
ReadAdvancedSettingsFromINI:
Iniread, AllowDownloadFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, AllowDownload
Iniread, AllowUploadFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, AllowUpload
Iniread, HideServerFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, HideServer
Iniread, DisableVACFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, DisableVAC
Iniread, EnableAllTalkFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EnableAllTalk
Iniread, EnableCheatsFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EnableCheats
Iniread, EmptyToggle1FromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EmptyToggle1
Iniread, EmptyToggle2FromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EmptyToggle2
Iniread, EmptyToggle3FromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EmptyToggle3
Iniread, EmptyToggle4FromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EmptyToggle4
Iniread, EmptyToggle5FromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EmptyToggle5
Iniread, EmptyToggle6FromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EmptyToggle6
Iniread, ServerTagsFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, ServerTags
Iniread, ServerTokenFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, ServerToken
Iniread, FastDLURLFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, FastDLURL
Iniread, RconPasswordFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, RconPassword
Iniread, SVPureFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, SVPure
Iniread, ServerTypeFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, ServerType
Iniread, RegionFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, Region
Iniread, MaxRateFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, MaxRate
Iniread, MinRateFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, MinRate
Iniread, MaxUpdateRateFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, MaxUpdateRate
Iniread, MinUpdateRateFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, MinUpdateRate
Iniread, MaxCMDRateFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, MaxCMDRate
Iniread, MinCMDRateFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, MinCMDRate
Iniread, CustomAddressFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, CustomAddress
Iniread, UDPPortFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, UDPPort
Iniread, EnableSourceTvFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EnableSourceTv
Iniread, UsePlayerAsCameraFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, UsePlayerAsCamera
Iniread, PlayVoiceFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, PlayVoice
Iniread, AutoRecordAllGamesFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, AutoRecordAllGames
Iniread, TransmitAllEntitiesFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, TransmitAllEntities
Iniread, DelayMapChangeFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, DelayMapChange
Iniread, EmptyToggle7FromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EmptyToggle7
Iniread, EmptyToggle8FromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EmptyToggle8
Iniread, EmptyToggle9FromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EmptyToggle9
Iniread, EmptyToggle10FromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EmptyToggle10
Iniread, EmptyToggle11FromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EmptyToggle11
Iniread, EmptyToggle12FromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EmptyToggle12
Iniread, EmptyToggle13FromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EmptyToggle13
Iniread, EmptyToggle14FromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EmptyToggle14
Iniread, STVNameFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, STVName
Iniread, STVPasswordFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, STVPassword
Iniread, STVSnapShotRateFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, STVSnapShotRate
Iniread, STVDelayFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, STVDelay
Iniread, STVPortFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, STVPort
Iniread, TimeoutFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, Timeout
Iniread, MaxNumOfClientsFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, MaxNumOfClients
Iniread, AllowVotingFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, AllowVoting
Iniread, AllowSpectatorsToVoteFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, AllowSpectatorsToVote
Iniread, AllowBotsToVoteFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, AllowBotsToVote
Iniread, EnableAutoTeamBalanceVotesFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EnableAutoTeamBalanceVotes
Iniread, AllowChangeLevelVotesFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, AllowChangeLevelVotes
Iniread, AllowPerClassLimitVotesFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, AllowPerClassLimitVotes
Iniread, AllowNextLevelVotesFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, AllowNextLevelVotes
Iniread, EnableVoteKickFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EnableVoteKick
Iniread, AllowVoteKickSpectatorsInMvMFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, AllowVoteKickSpectatorsInMvM
Iniread, AllowSetMvMChallengeLevelVotesFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, AllowSetMvMChallengeLevelVotes
Iniread, ForceYesForVoteCallersFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, ForceYesForVoteCallers
Iniread, AllowExtendCurrentLevelVotesFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, AllowExtendCurrentLevelVotes
Iniread, PresentTheLowestPlaytimeMapsListFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, PresentTheLowestPlaytimeMapsList
Iniread, PreventNextLevelVotesIfOneHasBeenSetFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, PreventNextLevelVotesIfOneHasBeenSet
Iniread, AllowRestartGameVotesFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, AllowRestartGameVotes
Iniread, AllowVoteScrambleFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, AllowVoteScramble
Iniread, ShowDisabledVotesInTheVoteMenuFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, ShowDisabledVotesInTheVoteMenu
Iniread, AllowPauseGameVotesFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, AllowPauseGameVotes
Iniread, EmptyToggle15FromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EmptyToggle15
Iniread, EmptyToggle16FromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EmptyToggle16
Iniread, EmptyToggle17FromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EmptyToggle17
Iniread, EmptyToggle18FromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EmptyToggle18
Iniread, EmptyToggle19FromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EmptyToggle19
Iniread, EmptyToggle20FromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EmptyToggle20
Iniread, EmptyToggle21FromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EmptyToggle21
Iniread, EmptyToggle22FromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EmptyToggle22
Iniread, EmptyToggle23FromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EmptyToggle23
Iniread, EmptyToggle24FromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EmptyToggle24
IniRead, AllowSpectatorsFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, AllowSpectators
IniRead, ShowVoiceChatIconsFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, ShowVoiceChatIcons
IniRead, DisableRespawnTimeFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, DisableRespawnTime
IniRead, RestrictTo1ClassOnlyFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, RestrictTo1ClassOnly
IniRead, EnableTeammatesPushAwayFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EnableTeammatesPushAway
IniRead, EnableRandomCritsFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EnableRandomCrits
IniRead, SpawnBeachBallOnRoundStartFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, SpawnBeachBallOnRoundStart
IniRead, EnableGrapplingHookFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EnableGrapplingHook
IniRead, EnableMannpowerModeFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EnableMannpowerMode
IniRead, EnableMedievalModeFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EnableMedievalMode
IniRead, EnableMedievalAutorpFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EnableMedievalAutorp
IniRead, FadeToBlackForSpectatorsFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, FadeToBlackForSpectators
IniRead, EnableFriendlyFireFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EnableFriendlyFire
IniRead, EnableTauntSlidingFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EnableTauntSliding
IniRead, AllowWeaponSwitchWhileTauntingFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, AllowWeaponSwitchWhileTaunting
IniRead, EnableBulletSpreadFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EnableBulletSpread
IniRead, AllowsLivingPlayersToHearDeadPlayersFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, AllowsLivingPlayersToHearDeadPlayers
IniRead, AllowsTruceDuringBossBattleFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, AllowsTruceDuringBossBattle
IniRead, TurnPlayersIntoLosersFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, TurnPlayersIntoLosers
IniRead, PreventPlayerMovementDuringStartupFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, PreventPlayerMovementDuringStartup
IniRead, EnableSpellsFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EnableSpells
IniRead, EnableTeamBalancingFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EnableTeamBalancing
IniRead, EnableSuddenDeathFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, EnableSuddenDeath
IniRead, RestartRoundAfterXNumberOfSecFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, RestartRoundAfterXNumberOfSec
IniRead, MaxIdleTimeFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, MaxIdleTime
IniRead, SetGravityFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, SetGravity
IniRead, SetAirAccelerationFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, SetAirAcceleration
IniRead, SetPlayerAccelerationFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, SetPlayerAcceleration
IniRead, PlayerRollAngleFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, PlayerRollAngle
IniRead, RollAngleSpeedFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, RollAngleSpeed
IniRead, RedTeamDmgMultiplierFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, RedTeamDmgMultiplier
IniRead, BlueTeamDmgMultiplierFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, BlueTeamDmgMultiplier
IniRead, TimescaleFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, Timescale
IniRead, TeamBalanceLimitFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, TeamBalanceLimit
IniRead, RoundLimitFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, RoundLimit
IniRead, MapTimelimitFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, MapTimelimit
IniRead, StalemateTimelimitFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, StalemateTimelimit
IniRead, RestartRoundAfterXNumberOfSecValueFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, RestartRoundAfterXNumberOfSecValue
IniRead, MaxIdleTimeValueFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, MaxIdleTimeValue
IniRead, SetGravityValueFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, SetGravityValue
IniRead, SetAirAccelerationValueFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, SetAirAccelerationValue
IniRead, SetPlayerAccelerationValueFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, SetPlayerAccelerationValue
IniRead, PlayerRollAngleValueFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, PlayerRollAngleValue
IniRead, RollAngleSpeedValueFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, RollAngleSpeedValue
IniRead, RedTeamDmgMultiplierValueFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, RedTeamDmgMultiplierValue
IniRead, BlueTeamDmgMultiplierValueFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, BlueTeamDmgMultiplierValue
IniRead, TimescaleValueFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, TimescaleValue
IniRead, TeamBalanceLimitValueFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, TeamBalanceLimitValue
IniRead, RoundLimitValueFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, RoundLimitValue
IniRead, MapTimelimitValueFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, MapTimelimitValue
IniRead, StalemateTimelimitValueFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, StalemateTimelimitValue
IniRead, LaunchOptionsFromINI, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, LaunchOptions
return

AdvancedGeneratePresetCode:
gui, GameAdvancedWindow:submit, nohide
PresetCode := AllowDownloadFromINI . "|" . AllowUploadFromINI . "|" . HideServerFromINI . "|" . DisableVACFromINI . "|" . EnableAllTalkFromINI . "|" . EnableCheatsFromINI . "|" . EmptyToggle1FromINI . "|" . EmptyToggle2FromINI . "|" . EmptyToggle3FromINI . "|" . EmptyToggle4FromINI . "|" . EmptyToggle5FromINI . "|" . EmptyToggle6FromINI . "|" . ServerTagsFromINI . "|" . ServerTokenFromINI . "|" . FastDLURLFromINI . "|" . RconPasswordFromINI . "|" . SVPureFromINI . "|" . ServerTypeFromINI . "|" . RegionFromINI . "|" . MaxRateFromINI . "|" . MinRateFromINI . "|" . MaxUpdateRateFromINI . "|" . MinUpdateRateFromINI . "|" . MaxCMDRateFromINI . "|" . MinCMDRateFromINI . "|" . CustomAddressFromINI . "|" . UDPPortFromINI . "|" . EnableSourceTvFromINI . "|" . UsePlayerAsCameraFromINI . "|" . PlayVoiceFromINI . "|" . AutoRecordAllGamesFromINI . "|" . TransmitAllEntitiesFromINI . "|" . DelayMapChangeFromINI . "|" . EmptyToggle7FromINI . "|" . EmptyToggle8FromINI . "|" . EmptyToggle9FromINI . "|" . EmptyToggle10FromINI . "|" . EmptyToggle11FromINI . "|" . EmptyToggle12FromINI . "|" . EmptyToggle13FromINI . "|" . EmptyToggle14FromINI . "|" . STVNameFromINI . "|" . STVPasswordFromINI . "|" . STVSnapShotRateFromINI . "|" . STVDelayFromINI . "|" . STVPortFromINI . "|" . TimeoutFromINI . "|" . MaxNumOfClientsFromINI . "|" . AllowVotingFromINI "|" . AllowSpectatorsToVoteFromINI . "|" . AllowBotsToVoteFromINI . "|" . EnableAutoTeamBalanceVotesFromINI . "|" . AllowChangeLevelVotesFromINI . "|" . AllowPerClassLimitVotesFromINI . "|" . AllowNextLevelVotesFromINI . "|" . EnableVoteKickFromINI .  "|" . AllowVoteKickSpectatorsInMvMFromINI . "|" . AllowSetMvMChallengeLevelVotesFromINI . "|" . ForceYesForVoteCallersFromINI . "|" . AllowExtendCurrentLevelVotesFromINI . "|" . PresentTheLowestPlaytimeMapsListFromINI . "|" . PreventNextLevelVotesIfOneHasBeenSetFromINI . "|" . AllowRestartGameVotesFromINI . "|" . AllowVoteScrambleFromINI . "|" . ShowDisabledVotesInTheVoteMenuFromINI . "|" . AllowPauseGameVotesFromINI "|" . EmptyToggle15FromINI . "|" . EmptyToggle16FromINI . "|" . EmptyToggle17FromINI . "|" . EmptyToggle18FromINI . "|" . EmptyToggle19FromINI . "|" . EmptyToggle20FromINI . "|" . EmptyToggle21FromINI . "|" . EmptyToggle22FromINI . "|" . EmptyToggle23FromINI . "|" . EmptyToggle24FromINI . "|" . AllowSpectatorsFromINI . "|" . ShowVoiceChatIconsFromINI . "|" . DisableRespawnTimeFromINI "|" . RestrictTo1ClassOnlyFromINI . "|" . EnableTeammatesPushAwayFromINI . "|" . EnableRandomCritsFromINI . "|" . SpawnBeachBallOnRoundStartFromINI . "|" . EnableGrapplingHookFromINI . "|" . EnableMannpowerModeFromINI . "|" . EnableMedievalModeFromINI . "|" . EnableMedievalAutorpFromINI . "|" . FadeToBlackForSpectatorsFromINI . "|" . EnableFriendlyFireFromINI . "|" . EnableTauntSlidingFromINI . "|" . AllowWeaponSwitchWhileTauntingFromINI . "|" . EnableBulletSpreadFromINI . "|" . AllowsLivingPlayersToHearDeadPlayersFromINI . "|" . AllowsTruceDuringBossBattleFromINI . "|" . TurnPlayersIntoLosersFromINI . "|" . PreventPlayerMovementDuringStartupFromINI . "|" . EnableSpellsFromINI . "|" . EnableTeamBalancingFromINI . "|" . EnableSuddenDeathFromINI "|" . RestartRoundAfterXNumberOfSecFromINI . "|" . MaxIdleTimeFromINI "|" . SetGravityFromINI "|" . SetAirAccelerationFromINI . "|" . SetPlayerAccelerationFromINI . "|" . PlayerRollAngleFromINI . "|" . RollAngleSpeedFromINI . "|" . RedTeamDmgMultiplierFromINI . "|" . BlueTeamDmgMultiplierFromINI . "|" . TimescaleFromINI . "|" . TeamBalanceLimitFromINI . "|" . RoundLimitFromINI . "|" . MapTimelimitFromINI . "|" . StalemateTimelimitFromINI . "|" . RestartRoundAfterXNumberOfSecValueFromINI . "|" . MaxIdleTimeValueFromINI . "|" . SetGravityValueFromINI . "|" . SetAirAccelerationValueFromINI . "|" . SetPlayerAccelerationValueFromINI . "|" . PlayerRollAngleValueFromINI . "|" . RollAngleSpeedValueFromINI . "|" . RedTeamDmgMultiplierValueFromINI "|" . BlueTeamDmgMultiplierValueFromINI . "|" . TimescaleValueFromINI . "|" . TeamBalanceLimitValueFromINI . "|" . RoundLimitValueFromINI . "|" . MapTimelimitValueFromINI . "|" . StalemateTimelimitValueFromINI
PresetCode .= "|" . RegExReplace(GameAdvancedCustomCFGCommandsEditVar, "`n", "&")
RegExReplace(PresetCode, "ERROR", "")
return

ApplyAdvancedSettingsFromINI:
ApplyToggleButtonAnimation("GameAdvancedWindow", "Advanced", "AllowDownload", "AdvancedWindowAllowDownloadPictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
ApplyToggleButtonAnimation("GameAdvancedWindow", "Advanced", "AllowUpload", "AdvancedWindowAllowUploadPictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
ApplyToggleButtonAnimation("GameAdvancedWindow", "Advanced", "HideServer", "AdvancedWindowHideServerPictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
ApplyToggleButtonAnimation("GameAdvancedWindow", "Advanced", "DisableVAC", "AdvancedWindowDisableVACPictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
ApplyToggleButtonAnimation("GameAdvancedWindow", "Advanced", "EnableAllTalk", "AdvancedWindowEnableAllTalkPictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
ApplyToggleButtonAnimation("GameAdvancedWindow", "Advanced", "EnableCheats", "AdvancedWindowEnableCheatsPictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
ApplyToggleButtonAnimation("GameAdvancedWindow", "Advanced", "EmptyToggle1", "AdvancedWindowEmptyToggle1PictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button_empty.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button_empty.png")
ApplyToggleButtonAnimation("GameAdvancedWindow", "Advanced", "EmptyToggle2", "AdvancedWindowEmptyToggle2PictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button_empty.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button_empty.png")
ApplyToggleButtonAnimation("GameAdvancedWindow", "Advanced", "EmptyToggle3", "AdvancedWindowEmptyToggle3PictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button_empty.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button_empty.png")
ApplyToggleButtonAnimation("GameAdvancedWindow", "Advanced", "EmptyToggle4", "AdvancedWindowEmptyToggle4PictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button_empty.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button_empty.png")
ApplyToggleButtonAnimation("GameAdvancedWindow", "Advanced", "EmptyToggle5", "AdvancedWindowEmptyToggle5PictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button_empty.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button_empty.png")
ApplyToggleButtonAnimation("GameAdvancedWindow", "Advanced", "EmptyToggle6", "AdvancedWindowEmptyToggle6PictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button_empty.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button_empty.png")
GuiControl, GameAdvancedWindow:, AdvancedWindowServerTagsEditVar, % (ServerTagsFromINI != "ERROR") ? (ServerTagsFromINI) : ("")
GuiControl, GameAdvancedWindow:, AdvancedWindowServerTokenEditVar, % (ServerTokenFromINI != "ERROR") ? (ServerTokenFromINI) : ("")
GuiControl, GameAdvancedWindow:, AdvancedWindowFastDLURLEditVar, % (FastDLURLFromINI != "ERROR") ? (FastDLURLFromINI) : ("")
GuiControl, GameAdvancedWindow:, AdvancedWindowRconPasswordEditVar, % (RconPasswordFromINI != "ERROR") ? (RconPasswordFromINI) : ("")
RotaryFixedSwitchAnimation("GameAdvancedWindow", SVPureFromINI, "AdvancedWindowSVPurePictureVar", "", "AdvancedWindowSVPureMinus1TextVar", "AdvancedWindowSVPure0TextVar", "AdvancedWindowSVPure1TextVar", "AdvancedWindowSVPure2TextVar", "", "", "", "", "", "","Allow file modifications", "Ban specific user modifications", "Allow only whitelisted user modifications", "Ban all user modifications", "", "", "", "", "")
RotaryFixedSwitchAnimation("GameAdvancedWindow", ServerTypeFromINI, "AdvancedWindowServerTypePictureVar", "AdvancedWindowServerTypePublicTextVar", "AdvancedWindowServerTypeLocalTextVar", "", "", "", "", "", "", "", "AdvancedWindowServerTypeSDRTextVar", "Public", "Local", "", "", "", "", "", "", "", "SDR")
RotaryFixedSwitchAnimation("GameAdvancedWindow", RegionFromINI, "AdvancedWindowRegionPictureVar","AdvancedWindowRegionWorldTextVar", "AdvancedWindowRegionUSEastTextVar", "AdvancedWindowRegionUSWestTextVar", "AdvancedWindowRegionSouthAmericaTextVar", "AdvancedWindowRegionEuropeTextVar", "AdvancedWindowRegionAsiaTextVar", "AdvancedWindowRegionAustraliaTextVar", "AdvancedWindowRegionMiddleEastTextVar", "AdvancedWindowRegionAfricaTextVar", "", "World", "US-East", "US-West", "South America", "Europe", "Asia", "Australia", "Middle East", "Africa", "")
GuiControl, GameAdvancedWindow:, AdvancedWindowMaxRateEditVar, % (MaxRateFromINI != "ERROR") ? (MaxRateFromINI) : ("")
GuiControl, GameAdvancedWindow:, AdvancedWindowMinRateEditVar, % (MinRateFromINI != "ERROR") ? (MinRateFromINI) : ("")
GuiControl, GameAdvancedWindow:, AdvancedWindowMaxUpdateRateEditVar, % (MaxUpdateRateFromINI != "ERROR") ? (MaxUpdateRateFromINI) : ("")
GuiControl, GameAdvancedWindow:, AdvancedWindowMinUpdateRateEditVar, % (MinUpdateRateFromINI != "ERROR") ? (MinUpdateRateFromINI) : ("")
GuiControl, GameAdvancedWindow:, AdvancedWindowMaxCMDRateEditVar, % (MaxCMDRateFromINI != "ERROR") ? (MaxCMDRateFromINI) : ("")
GuiControl, GameAdvancedWindow:, AdvancedWindowMinCMDRateEditVar, % (MinCMDRateFromINI != "ERROR") ? (MinCMDRateFromINI) : ("")
GuiControl, GameAdvancedWindow:, AdvancedWindowCustomAddressEditVar, % (CustomAddressFromINI != "ERROR") ? (CustomAddressFromINI) : ("")
GuiControl, GameAdvancedWindow:, AdvancedWindowUDPPortEditVar, % (UDPPortFromINI != "ERROR") ? (UDPPortFromINI) : ("")
ApplyToggleButtonAnimation("GameAdvancedWindow", "Advanced", "EnableSourceTv", "AdvancedWindowEnableSourceTvPictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
ApplyToggleButtonAnimation("GameAdvancedWindow", "Advanced", "UsePlayerAsCamera", "AdvancedWindowUsePlayersAsCameraPictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
ApplyToggleButtonAnimation("GameAdvancedWindow", "Advanced", "PlayVoice", "AdvancedWindowPlayVoicePictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
ApplyToggleButtonAnimation("GameAdvancedWindow", "Advanced", "AutoRecordAllGames", "AdvancedWindowAutoRecordAllGamesPictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
ApplyToggleButtonAnimation("GameAdvancedWindow", "Advanced", "TransmitAllEntities", "AdvancedWindowTransmitAllEntitiesPictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
ApplyToggleButtonAnimation("GameAdvancedWindow", "Advanced", "DelayMapChange", "AdvancedWindowDelayMapChangePictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
ApplyToggleButtonAnimation("GameAdvancedWindow", "Advanced", "EmptyToggle7", "AdvancedWindowEmptyToggle7PictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button_empty.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button_empty.png")
ApplyToggleButtonAnimation("GameAdvancedWindow", "Advanced", "EmptyToggle8", "AdvancedWindowEmptyToggle8PictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button_empty.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button_empty.png")
ApplyToggleButtonAnimation("GameAdvancedWindow", "Advanced", "EmptyToggle9", "AdvancedWindowEmptyToggle9PictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button_empty.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button_empty.png")
ApplyToggleButtonAnimation("GameAdvancedWindow", "Advanced", "EmptyToggle10", "AdvancedWindowEmptyToggle10PictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button_empty.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button_empty.png")
ApplyToggleButtonAnimation("GameAdvancedWindow", "Advanced", "EmptyToggle11", "AdvancedWindowEmptyToggle11PictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button_empty.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button_empty.png")
ApplyToggleButtonAnimation("GameAdvancedWindow", "Advanced", "EmptyToggle12", "AdvancedWindowEmptyToggle12PictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button_empty.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button_empty.png")
ApplyToggleButtonAnimation("GameAdvancedWindow", "Advanced", "EmptyToggle13", "AdvancedWindowEmptyToggle13PictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button_empty.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button_empty.png")
ApplyToggleButtonAnimation("GameAdvancedWindow", "Advanced", "EmptyToggle14", "AdvancedWindowEmptyToggle14PictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button_empty.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button_empty.png")
GuiControl, GameAdvancedWindow:, AdvancedWindowSTVNameEditVar, % (STVNameFromINI != "ERROR") ? (STVNameFromINI) : ("")
GuiControl, GameAdvancedWindow:, AdvancedWindowSTVPasswordEditVar, % (STVPasswordFromINI != "ERROR") ? (STVPasswordFromINI) : ("")
GuiControl, GameAdvancedWindow:, AdvancedWindowSTVSnapShotRateEditVar, % (STVSnapShotRateFromINI != "ERROR") ? (STVSnapShotRateFromINI) : ("")
GuiControl, GameAdvancedWindow:, AdvancedWindowSTVDelayEditVar, % (STVDelayFromINI != "ERROR") ? (STVDelayFromINI) : ("")
GuiControl, GameAdvancedWindow:, AdvancedWindowSTVPortEditVar, % (STVPortFromINI != "ERROR") ? (STVPortFromINI) : ("")
GuiControl, GameAdvancedWindow:, AdvancedWindowTimeoutEditVar, % (TimeoutFromINI != "ERROR") ? (TimeoutFromINI) : ("")
GuiControl, GameAdvancedWindow:, AdvancedWindowMaxNumOfClientsEditVar, % (MaxNumOfClientsFromINI != "ERROR") ? (MaxNumOfClientsFromINI) : ("")
ApplyToggleButtonAnimation("GameAdvancedWindow", "Advanced", "AllowVoting", "AdvancedWindowAllowVotingPictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
ApplyToggleButtonAnimation("GameAdvancedWindow", "Advanced", "AllowSpectatorsToVote", "AdvancedWindowAllowSpectatorsToVotePictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
ApplyToggleButtonAnimation("GameAdvancedWindow", "Advanced", "AllowBotsToVote", "AdvancedWindowAllowBotsToVotePictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
ApplyToggleButtonAnimation("GameAdvancedWindow", "Advanced", "EnableAutoTeamBalanceVotes", "AdvancedWindowEnableAutoTeamBalanceVotesPictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
ApplyToggleButtonAnimation("GameAdvancedWindow", "Advanced", "AllowChangeLevelVotes", "AdvancedWindowAllowChangeLevelVotesPictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
ApplyToggleButtonAnimation("GameAdvancedWindow", "Advanced", "AllowPerClassLimitVotes", "AdvancedWindowAllowPerClassLimitVotesPictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
ApplyToggleButtonAnimation("GameAdvancedWindow", "Advanced", "AllowNextLevelVotes", "AdvancedWindowAllowNextLevelVotesPictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
ApplyToggleButtonAnimation("GameAdvancedWindow", "Advanced", "EnableVoteKick", "AdvancedWindowEnableVoteKickPictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
ApplyToggleButtonAnimation("GameAdvancedWindow", "Advanced", "AllowVoteKickSpectatorsInMvM", "AdvancedWindowAllowVoteKickSpectatorsInMvMPictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
ApplyToggleButtonAnimation("GameAdvancedWindow", "Advanced", "AllowSetMvMChallengeLevelVotes", "AdvancedWindowAllowSetMvMChallengeLevelVotesPictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
ApplyToggleButtonAnimation("GameAdvancedWindow", "Advanced", "ForceYesForVoteCallers", "AdvancedWindowAutomaticallyChooseYesForVoteCallersPictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
ApplyToggleButtonAnimation("GameAdvancedWindow", "Advanced", "AllowExtendCurrentLevelVotes", "AdvancedWindowAllowExtendCurrentMapVotesPictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
ApplyToggleButtonAnimation("GameAdvancedWindow", "Advanced", "PresentTheLowestPlaytimeMapsList", "AdvancedWindowPresentTheLowestPlaytimeMapsListPictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
ApplyToggleButtonAnimation("GameAdvancedWindow", "Advanced", "PreventNextLevelVotesIfOneHasBeenSet", "AdvancedWindowPreventNextLevelVotesIfOneHasBeenSetPictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
ApplyToggleButtonAnimation("GameAdvancedWindow", "Advanced", "AllowRestartGameVotes", "AdvancedWindowAllowRestartGameVotesPictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
ApplyToggleButtonAnimation("GameAdvancedWindow", "Advanced", "AllowVoteScramble", "AdvancedWindowAllowVoteScramblePictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
ApplyToggleButtonAnimation("GameAdvancedWindow", "Advanced", "ShowDisabledVotesInTheVoteMenu", "AdvancedWindowShowDisabledVotesInTheVoteMenuPictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
ApplyToggleButtonAnimation("GameAdvancedWindow", "Advanced", "AllowPauseGameVotes", "AdvancedWindowAllowPauseGameVotesPictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button.png")
ApplyToggleButtonAnimation("GameAdvancedWindow", "Advanced", "EmptyToggle15", "AdvancedWindowEmptyToggle15PictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button_empty.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button_empty.png")
ApplyToggleButtonAnimation("GameAdvancedWindow", "Advanced", "EmptyToggle16", "AdvancedWindowEmptyToggle16PictureButtonVar", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_on_pic_button_empty.png", A_ScriptDir . "\Server Boss All\Images\Custom UI controls\Vertival_toggle_off_pic_button_empty.png")
GuiControl, GameAdvancedWindow:, GameAdvancedLaunchOptionsEditVar, % LaunchOptionsFromINI
return

ApplyCustomStartupCommands:
FileRead, AllCustomConsoleCommands, %A_ScriptDir%/Server Boss All/Custom startup commands.cfg
GuiControl, GameAdvancedWindow:, GameAdvancedCustomCFGCommandsEditVar, % AllCustomConsoleCommands
return

SetRotarySwitchStatesInINI:
IniWrite, 1, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, MaxRateSwitchState
IniWrite, 1, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, MinRateSwitchState
IniWrite, 1, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, MaxUpdateRateSwitchState
IniWrite, 1, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, MinUpdateRateSwitchState
IniWrite, 1, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, MaxCMDRateSwitchState
IniWrite, 1, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, MinCMDRateSwitchState
IniWrite, 1, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, TimeoutSwitchState
IniWrite, 1, %A_scriptdir%\Server Boss All\Settings.ini, Advanced, MaxNumOfClientsSwitchState
return

ScanAdvancedSettingsForPresets:
AdvancedPrestsList := ""
loop, Files, %A_ScriptDir%\Server Boss All\Presets\Advanced\*.txt, F
{
    SplitPath, A_LoopFileFullPath,,,, PresetNameNoExt
    AdvancedPrestsList .= PresetNameNoExt . "|"
}
GuiControl, GameAdvancedWindowPresets:, SelectServerPresetListListboxVar, |
GuiControl, GameAdvancedWindowPresets:, SelectServerPresetListListboxVar, % AdvancedPrestsList
return

GameAdvancedMapOptionsPageNextListOfOptions:
switch GameAdvancedMapOptionsPage
{
    case 1:
    LV_Add("", (AllowSpectatorsFromINI = "1") ? (chr(0x2705)) : (chr(0x1F7E9)), "Allow spectators")
    LV_Add("", (ShowVoiceChatIconsFromINI = "1") ? (chr(0x2705)) : (chr(0x1F7E9)), "Show voice chat icons")
    LV_Add("", (DisableRespawnTimeFromINI = "1") ? (chr(0x2705)) : (chr(0x1F7E9)), "Disable respawn time")
    LV_Add("", (RestrictTo1ClassOnlyFromINI = "1") ? (chr(0x2705)) : (chr(0x1F7E9)), "Restrict to 1 class only")
    LV_Add("", (EnableTeammatesPushAwayFromINI = "1") ? (chr(0x2705)) : (chr(0x1F7E9)), "Enable teammates push away")
    LV_Add("", (EnableRandomCritsFromINI = "1") ? (chr(0x2705)) : (chr(0x1F7E9)), "Enable random crits")
    LV_Add("", (SpawnBeachBallOnRoundStartFromINI = "1") ? (chr(0x2705)) : (chr(0x1F7E9)), "Spawn beach ball on round start")
    LV_Add("", (EnableGrapplingHookFromINI = "1") ? (chr(0x2705)) : (chr(0x1F7E9)), "Enable grappling hook")
    LV_Add("", (EnableMannpowerModeFromINI = "1") ? (chr(0x2705)) : (chr(0x1F7E9)), "Enable mannpower mode")
    LV_Add("", (EnableMedievalModeFromINI = "1") ? (chr(0x2705)) : (chr(0x1F7E9)), "Enable medieval mode")
    LV_Add("", (EnableMedievalAutorpFromINI = "1") ? (chr(0x2705)) : (chr(0x1F7E9)), "Enable medieval autorp")
    LV_Add("", (FadeToBlackForSpectatorsFromINI = "1") ? (chr(0x2705)) : (chr(0x1F7E9)), "Fade to black for spectators")
    case 2:
    LV_Add("", (EnableFriendlyFireFromINI = "1") ? (chr(0x2705)) : (chr(0x1F7E9)), "Enable friendly fire")
    LV_Add("", (EnableTauntSlidingFromINI = "1") ? (chr(0x2705)) : (chr(0x1F7E9)), "Enable taunt sliding")
    LV_Add("", (AllowWeaponSwitchWhileTauntingFromINI = "1") ? (chr(0x2705)) : (chr(0x1F7E9)), "Allow weapon switch while taunting")
    LV_Add("", (EnableBulletSpreadFromINI = "1") ? (chr(0x2705)) : (chr(0x1F7E9)), "Enable bullet spread")
    LV_Add("", (AllowsLivingPlayersToHearDeadPlayersFromINI = "1") ? (chr(0x2705)) : (chr(0x1F7E9)), "Allows living players to hear dead players using text/voice chat")
    LV_Add("", (AllowsTruceDuringBossBattleFromINI = "1") ? (chr(0x2705)) : (chr(0x1F7E9)), "Allows truce during boss battle")
    LV_Add("", (PreventPlayerMovementDuringStartupFromINI = "1") ? (chr(0x2705)) : (chr(0x1F7E9)), "Prevent player movement during startup")
    LV_Add("", (TurnPlayersIntoLosersFromINI = "1") ? (chr(0x2705)) : (chr(0x1F7E9)), "Turn players into losers")
    LV_Add("", (EnableSpellsFromINI = "1") ? (chr(0x2705)) : (chr(0x1F7E9)), "Enable spells")
    LV_Add("", (EnableTeamBalancingFromINI = "1") ? (chr(0x2705)) : (chr(0x1F7E9)), "Enable team balancing")
    LV_Add("", (EnableSuddenDeathFromINI = "1") ? (chr(0x2705)) : (chr(0x1F7E9)), "Enable sudden death")
    LV_Add("", (RestartRoundAfterXNumberOfSecFromINI = "1") ? (chr(0x2705)) : (chr(0x1F7E9)), "Restart round after X number of sec.", RestartRoundAfterXNumberOfSecValueFromINI)
    case 3:
    LV_Add("", (MaxIdleTimeFromINI = "1") ? (chr(0x2705)) : (chr(0x1F7E9)), "Max. idle time(in min.)", MaxIdleTimeValueFromINI)
    LV_Add("", (SetGravityFromINI = "1") ? (chr(0x2705)) : (chr(0x1F7E9)), "Set gravity", SetGravityValueFromINI)
    LV_Add("", (SetAirAccelerationFromINI = "1") ? (chr(0x2705)) : (chr(0x1F7E9)), "Set air acceleration", SetAirAccelerationValueFromINI)
    LV_Add("", (SetPlayerAccelerationFromINI = "1") ? (chr(0x2705)) : (chr(0x1F7E9)), "Set player acceleration", SetPlayerAccelerationValueFromINI)
    LV_Add("", (PlayerRollAngleFromINI = "1") ? (chr(0x2705)) : (chr(0x1F7E9)), "Player roll angle", PlayerRollAngleValueFromINI)
    LV_Add("", (RollAngleSpeedFromINI = "1") ? (chr(0x2705)) : (chr(0x1F7E9)), "Roll angle speed", RollAngleSpeedValueFromINI)
    LV_Add("", (RedTeamDmgMultiplierFromINI = "1") ? (chr(0x2705)) : (chr(0x1F7E9)), "Red team dmg. multiplier", RedTeamDmgMultiplierValueFromINI)
    LV_Add("", (BlueTeamDmgMultiplierFromINI = "1") ? (chr(0x2705)) : (chr(0x1F7E9)), "Blue team dmg. multiplier", BlueTeamDmgMultiplierValueFromINI)
    LV_Add("", (TimescaleFromINI = "1") ? (chr(0x2705)) : (chr(0x1F7E9)), "Timescale", TimescaleValueFromINI)
    LV_Add("", (TeamBalanceLimitFromINI = "1") ? (chr(0x2705)) : (chr(0x1F7E9)), "Team balance limit", TeamBalanceLimitValueFromINI)
    LV_Add("", (RoundLimitFromINI = "1") ? (chr(0x2705)) : (chr(0x1F7E9)), "Round limit", RoundLimitValueFromINI)
    LV_Add("", (MapTimelimitFromINI = "1") ? (chr(0x2705)) : (chr(0x1F7E9)), "Map timelimit", MapTimelimitValueFromINI)
    case 4:
    LV_Add("", (StalemateTimelimitFromINI = "1") ? (chr(0x2705)) : (chr(0x1F7E9)), "Stalemate time limit - (sec.)", StalemateTimelimitValueFromINI)
    LV_Add("", "", "N/A")
    LV_Add("", "", "N/A")
    LV_Add("", "", "N/A")
    LV_Add("", "", "N/A")
    LV_Add("", "", "N/A")
    LV_Add("", "", "N/A")
    LV_Add("", "", "N/A")
    LV_Add("", "", "N/A")
    LV_Add("", "", "N/A")
    LV_Add("", "", "N/A")
    LV_Add("", "", "N/A")
}
return

ApplyToggleButtonAnimation(GuiName, INISection, INIKey, ControlName, OnImage, OffImage) {
    Iniread, ControlVariableFromINI, %A_scriptdir%\Server Boss All\Settings.ini, %INISection%, %INIKey%
    if (ControlVariableFromINI = "1")
    GuiControl, %GuiName%:, %ControlName%, % OnImage
    else if (ControlVariableFromINI != "1")
    GuiControl, %GuiName%:, %ControlName%, % OffImage
    VarSetCapacity(ControlVariableFromINI, 0)
}

;Show a popup window that stays active as long as the mouse is inside it
;----------------------------------------------------------------------------
ShowPopUpWindow(GUIWindowTitle, GUIWindowShowName, OffSetX, OffSetY, TransparentOnOff, Width, Height, CustomWidth) {
    CoordMode, Mouse, Screen
    MouseGetPos, posX, posY, CurrentWinTitle
    posX -= OffSetX, posY -= OffSetY
    if (CustomWidth != true)
    gui, %GUIWindowShowName%:show, x%posX% y%posY%
    else
    gui, %GUIWindowShowName%:show, x%posX% y%posY% w%Width% h%Height%
    if (TransparentOnOff = true)
    WinSet, TransColor, 653d33, %GUIWindowTitle%
    Loop
    {
        Sleep, 100
        CoordMode, Mouse, Screen
        MouseGetPos, posX, posY, CurrentWinTitle
        WinGetTitle, WindowTitle, ahk_id %CurrentWinTitle%
        If (WindowTitle = GUIWindowTitle) and (TrackMouseOutWindow = false)
        TrackMouseOutWindow := true
        else if (WindowTitle != GUIWindowTitle) and (TrackMouseOutWindow := true)
        {
            gui, %GUIWindowShowName%:hide
            break
        }
    }
}

;Tray manu
;----------------------------------------------------------------------------------------------
MainWindowTab3:
gui MainWindow:submit, nohide
if (MainWindowTab3Var != "About") and (MainWindowTab3Var != " ")
menu, tray, default, %MainWindowTab3Var%
else
menu, tray, default, Game
return

OpenAboutTab:
gui, AboutWindow:show, w500 h285
return

OpenLicense:
gui, LicenseWindow:show, w540 h600
return

OpenGameTab:
gui, MainWindow:show, w1050 h705
GuiControl, MainWindow:choose, MainWindowTab3Var, Game
menu, tray, default, Game
return

OpenConsoleTab:
gui, MainWindow:show, w1050 h705
GuiControl, MainWindow:choose, MainWindowTab3Var, Console
menu, tray, default, Console
return

OpenPathsTab:
gui, MainWindow:show, w1050 h705
GuiControl, MainWindow:choose, MainWindowTab3Var, Paths
menu, tray, default, Paths
return

OpenRepo:
run, https://github.com/SlyRockk/Server-Boss
return

CloseProgram:
DetectHiddenWindows, on
WinClose, ahk_pid %Tf2ServerPID%
Process, Close, %Tf2ServerPID%
ExitApp
return






































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































