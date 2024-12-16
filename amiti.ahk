#Requires AutoHotkey v2.0
#UseHook true
;#SingleInstance Force 配布では使わない方が良いかも
#Include Function.ahk
#Include StartUp.ahk

;非修飾キーのリマップ
sc03A::sc001    ;capslockをescに　
;+sc03A::&      ;shift+capslockを&に shiftのリマップの場所に記述
sc070::sc03A    ;カタカナひらがなローマ字キーをcapslockに
Shift::sc073    ;shiftキーを\キーに
^::\            ;^キーと¥キーの入れ替え
\::^
#SuspendExempt
    RControl::Suspend  ;右Ctrをahk停止/再開に
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
*^f::ModifierdKey("{Backspace}")	;backspace 
*^d::ModifierdKey("{Delete}")		;delete
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
^sc03A::ModifierdKey("{Home}")     ;Home
^+sc03A::ModifierdKey("+{Home}")    
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
;vscodeはこのコマンドでタブ移動するらしい
#HotIf WinActive("ahk_exe Code.exe")
    #h::ModifierdKey("^{PgUp}")
    #l::ModifierdKey("^{PgDn}")
#HotIf

#w::WinClose("A")   ;wでウィンドウを閉じる
;画面サイズ変更
#sc03A::WinMaximize "A" ;最大
#e::{
    WinRestore "A"
    WinMove 0,0,A_ScreenWidth/2,windowHeight,"A" ;eで画面左半分表示
}
#r::{
    WinRestore "A" 
    winmove A_ScreenWidth/2,0,A_ScreenWidth/2,windowHeight,"A" ;rで画面右半分表示
}

;aでwin1を左半分に開く、sで右半分に開く
#a::WrapWinMoveActive(0,0,A_ScreenWidth/2,windowHeight,win1)
#s::WrapWinMoveActive(A_ScreenWidth/2,0,A_ScreenWidth/2,windowHeight,win1)
;dでwin2を左半分、fで右半分に開く
#d::WrapWinMoveActive(0,0,A_ScreenWidth/2,windowHeight,win2)
#f::WrapWinMoveActive(A_ScreenWidth/2,0,A_ScreenWidth/2,windowHeight,win2)
;ウィンドウアクティブ
#n::WrapWinActive(win3)
#i::WrapWinActive(win4)
#o::WrapWinActive(win5)

;pでwin1~5以外のウィンドウを切り替える
#p::{
    static priorWindow
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
        MsgBox("このコマンドはまだ動作が不安定です。いつか良い感じにします。`n`n" . err.Message)
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
;例えば、無変換+Space+qを送ろうとしたらパソコンは無変換+Space+無変換を受け取っていた
TRIPLE_PRESS_ERROR:="このキーは使えません`n多分キーボードの問題です`nメンブレンキーボードを使っている場合は3つ同時押しのキーで使えないキーがある可能性があります`nこのコマンドは我慢してください`n`n※3つ同時押しをしていないのにこのメッセージが出た場合はわかりません。`n報告してもらえると助かります"

^+sc07B::MsgBox(TRIPLE_PRESS_ERROR)

^+sc079::MsgBox(TRIPLE_PRESS_ERROR)

#HotIf WinActive("ahk_exe chrome.exe") ;Chromeがアクティブの時はctrl+sをctrl+lにする
    ^s::ModifierdKey("^l")
#HotIf
