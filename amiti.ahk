#Requires AutoHotkey v2.0
#UseHook true
#SingleInstance Force

;環境変数(ショートカットで操作するウィンドウの名前)を読み込む
FilePath := A_ScriptDir . "\env.txt"

if FileExist(FilePath)
{
    FileContent := FileRead("env.txt","UTF-8")
    
	splitContent := StrSplit(FileContent,"`r`n")

	win1 := Trim(splitContent[1])
	win2 := Trim(splitContent[2])
	win3 := Trim(splitContent[3])
	win4 := Trim(splitContent[4])
	win5 := Trim(splitContent[5]) 
    GroupAdd "MainWindows",win1
    GroupAdd "MainWindows",win2
    GroupAdd "MainWindows",win3
    GroupAdd "MainWindows",win4
    GroupAdd "MainWindows",win5
}
else
{
    MsgBox("env.txtが見つかりません。`nexeファイルとenv.txtは同じ階層にある必要があります。")
}

;タスクバーの高さを取得
WinGetPos ,,,&taskbarHeight,"ahk_class Shell_TrayWnd"
windowHeight := A_ScreenHeight-taskbarHeight

;非修飾キーのリマップ
sc03A::sc001    ;capslockをescに　
;+sc03A::&      ;shift+capslockを&に shiftのリマップの場所に記述
sc070::sc03A    ;カタカナひらがなローマ字キーをcapslockに
Shift::sc073    ;shiftキーを\キーに
^::\            ;^キーと¥キーの入れ替え
\::^
#SuspendExempt
    sc029::Suspend  ;半角全角をahk停止/再開に
#SuspendExempt false 

;2ストローク
;g2回で最初の行に移動
g::{
    SendInput("g")
    if(A_PriorHotkey ==  ThisHotkey and A_Priorkey == "g" and A_TimeSincePriorHotkey > 60 and A_TimeSincePriorHotkey < 400){
        SendInput("{BackSpace 2}^{Home}")
    }
}

;修飾キーのリマップ
;修飾キーと同時に押されているときにSendするとその修飾キーと一緒に送られたことになってしまうので修飾キーを一時的に押されていないことにする
ModifierdKey(sendkey){
    sendStr := sendKey
    if(GetKeyState("Shift")){
        sendStr := "{Shift Up}" . sendStr . "{Shift Down}"
    }
    if(GetKeyState("Ctrl")){
       sendStr := "{Ctrl up}" . sendStr . "{Ctrl down}"
    }
    if(GetKeyState("LWin")){
        sendStr := "{Ctrl down}{Ctrl up}{LWin up}" . sendStr . "{LWin down}"
    }
    SendInput(sendStr)
}

timeout:= 300
pressedAt:= 0

;単押しの場合の挙動を持たせる
SinglePress(lastkey,sendkey,is_prior_empty:=false) {
    pressedAt:=A_TickCount
    KeyWait lastkey
    if(A_TickCount - pressedAt > timeout){
        return
    }

    if (!is_prior_empty && A_PriorKey==lastkey)
    {
	    Send sendkey

    }else if(is_prior_empty && A_PriorKey=='')
    {
	    Send sendkey
    }
    return
}

;無変換キーを単押しで半角全角、長押しでshiftキーにする 
*sc07B:: {
    SendInput "{Shift Down}"
    SinglePress("sc07B","{sc029}",true)
}

*sc07B up:: {
    SendInput "{Shift Up}"
}

;spaceを単押しでspace,長押しでctrlキー
*sc039::{
    SendInput "{Ctrl Down}"
    SinglePress("Space","{sc039}")
}

*sc039 up::{
    SendInput "{Ctrl Up}"
} 

;変換キーを単押しでEnterキー、長押しでWinキー
*sc079::{
    SendInput "{LWin Down}"
    SinglePress("sc079","{Enter}",true)
}

*sc079 up::{
    SendInput "{Ctrl Down}{Ctrl Up}{LWin Up}" ;winキーはデフォルトで単押しの挙動があるのでctrlキーを押して単押しじゃなくする
}

;shiftキーリマップ
+sc03A::&

;ctrlキーショートカット
^f::ModifierdKey("{Backspace}")	;backspace 
^d::ModifierdKey("{Delete}")		;delete
^h::ModifierdKey("{left}")		;上下左右キー
^j::ModifierdKey("{down}")	
^k::ModifierdKey("{up}")
^l::ModifierdKey("{right}")
^+h::ModifierdKey("+{left}")
^+j::ModifierdKey("+{down}") 
^+k::ModifierdKey("+{up}")  
^+l::ModifierdKey("+{right}")
^u::ModifierdKey("{up 2}")
^n::ModifierdKey("{down 2}")
^q::ModifierdKey("{Home}")     ;Home
^e::ModifierdKey("{End}")		;End
^+e::ModifierdKey("+{End}")
^+g::ModifierdKey("^{End}")    ;最終行に移動
^o::ModifierdKey("{End}+{Enter}") ;下に空行を入れてそこから書き始める
^+o::ModifierdKey("{Home}+{Enter}{up}") ;上に空行を入れて書き始める
^g::ModifierdKey("^{Backspace}")  ;単語単位で削除
^p::ModifierdKey("{AppsKey}")     ;右クリックメニューの起動
^m::MouseMove A_ScreenWidth/2-100,A_ScreenHeight-200 ;mouse移動

;winキーショートカット
#h::ModifierdKey("^+{tab}")   ;hでctrl+shift+tab
#l::ModifierdKey("^{tab}")    ;lでctrl+tab

;画面サイズ変更
#w::WinMaximize "A" ;最大
#e::{
    WinRestore "A"
    WinMove 0,0,A_ScreenWidth/2,windowHeight,"A" ;eで画面左半分表示
}
#r::{
    WinRestore "A" 
    winmove A_ScreenWidth/2,0,A_ScreenWidth/2,windowHeight,"A" ;rで画面右半分表示
}

winErrorTxt1:="ウインドウ:"
winErrorTxt2:="が見つかりません`n`n文字列があってるか確認して下さい。`nenv.txtを変更したらその後起動しなおしてください。`n文字コードはutf-8でお願いします。`n`n`n※※※※※※※※※※※※※※`nこのエラーメッセージは`n`nウィンドウ:XXXが見つかりません`n`nの形式で送ってるので、`n`nウィンドウ:XXX`nが見つかりません`n`nとかだったら変な改行が入っちゃってるかも。`n※※※※※※※※※※※※※※"
unExpectedTxt:="未知のバグです。報告をお願いします。"
;aでwin1を左半分に開く、sで右半分に開く
#a::{
    try{
        WinMove 0,0,A_ScreenWidth/2,windowHeight, win1
        WinActivate win1
    }catch TargetError as Terr{
        MsgBox(winErrorTxt1 . Terr.Extra . winErrorTxt2)
    }catch as err{
        MsgBox(unExpectedTxt)
    }
}

#s::{
    try{
        WinMove A_ScreenWidth/2,0,A_ScreenWidth/2,windowHeight, win1
        WinActivate win1
    }catch TargetError as Terr{
        MsgBox(winErrorTxt1 . Terr.Extra . winErrorTxt2)
    }catch as err{
        MsgBox(unExpectedTxt)
    }
} 

;dでwin2を左半分、fで右半分に開く
#d::{
    try{
        WinMove 0,0,A_ScreenWidth/2,windowHeight,win2
        WinActivate win2    
    }catch TargetError as Terr{
        MsgBox(winErrorTxt1 . Terr.Extra . winErrorTxt2)
    }catch as err{
        MsgBox(unExpectedTxt)
    }
}

#f::{
    try{
        WinMove A_ScreenWidth/2,0,A_ScreenWidth/2,windowHeight,win2
        WinActivate win2
    }catch TargetError as Terr{
        MsgBox(winErrorTxt1 . Terr.Extra . winErrorTxt2)
    }catch as err{
        MsgBox(unExpectedTxt)
    }
}
;ウィンドウアクティブ
#n::{
    try{
        WinActivate win3
    }catch TargetError as Terr{
        MsgBox(winErrorTxt1 . Terr.Extra . winErrorTxt2)
    }catch as err{
        MsgBox(unExpectedTxt)
    }
}
#i::{
    try{
        WinActivate win4
    }catch TargetError as Terr{
        MsgBox(winErrorTxt1 . Terr.Extra . winErrorTxt2)
    }catch as err{
        MsgBox(unExpectedTxt)
    }		
}
#o::{
    MsgBox(A_PriorHotkey)
    try{
        WinActivate win5
    }catch TargetError as Terr{
        MsgBox(winErrorTxt1 . Terr.Extra . winErrorTxt2)
    }catch as err{
        MsgBox(unExpectedTxt)
    }
}
;pでwin1~5以外のウィンドウを切り替える
priorWindow:=""
#p::{
    global
    try{
        if(A_PriorHotkey!=ThisHotkey){
            GroupDeactivate "MainWindows","R"
        }else{
            GroupDeactivate "MainWindows"
        }

        tempWindow:=WinGetTitle("A")
        if(A_PriorHotkey==ThisHotkey and tempWindow != priorWindow){
            WinMoveBottom(priorWindow)
        }
        priorWindow:=tempWindow
    }catch as err{
        MsgBox("このコマンドはまだ動作が不安定です。いつかいい感じにします。`n`n" . err.Message)
    }
}
;音量操作
#m::ModifierdKey("{Volume_Mute}")  
#sc027::ModifierdKey("{Volume_Down}") 
#sc028::ModifierdKey("{Volume_Up}")	
;スクロール
#j::{
    WinGetClientPos ,,&width,&height,"A"
    MouseMove width*3/5,height*2/5
    ModifierdKey("{WheelDown}")
}
#k::{
    WinGetClientPos ,,&width,&height,"A"
    MouseMove width*3/5,height*2/5
    ModifierdKey("{WheelUp}")
}
;一行コピー、切り取り、一行下に貼り付け
#x::ModifierdKey("{Home}+{End}^x{Delete}")
#c::ModifierdKey("{Home}+{End}^c")
#v::ModifierdKey("{End}+{Enter}^v")
#+v::ModifierdKey("{Home}^v+{Enter}")
#z::ModifierdKey("^z")
#y::ModifierdKey("^y")

;3つ同時押しの場合のエラーハンドリング
ErrorMessage:="このキーは使えません`n多分キーボードの問題です`nメンブレンキーボードを使っている場合は3つ同時押しのキーで使えないキーがある可能性があります`nこのコマンドは我慢してください`n`n※3つ同時押しをしていないのにこのメッセージが出た場合はわかりません。`n報告してもらえると助かります"

^+sc07B::{
    MsgBox(ErrorMessage)
}

^+sc079::{
    MsgBox(ErrorMessage)
}

#HotIf WinActive("Google Chrome") ;Chromeがアクティブの時はctrl+sをctrl+lにする
    ^s::ModifierdKey("^l")
#HotIf
