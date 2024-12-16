#Requires AutoHotkey v2.0

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

WIN_ERROR_TXT1:="ウインドウ:"
WIN_ERROR_TXT2:="が見つかりません`n`n文字列があってるか確認して下さい。`nenv.txtを変更したらその後起動しなおしてください。`n文字コードはutf-8でお願いします。`n`n`n※※※※※※※※※※※※※※`nこのエラーメッセージは`n`nウィンドウ:XXXが見つかりません`n`nの形式で送ってるので、`n`nウィンドウ:XXX`nが見つかりません`n`nとかだったら変な改行が入っちゃってるかも。`n※※※※※※※※※※※※※※"
UNEXPECTED_ERROR:="未知のバグです。報告をお願いします。"

WrapWinMoveActive(x,y,width,height,wintitle){
    try{
        WinMove x,y,width,height, wintitle
        WinActivate wintitle
    }catch TargetError as Terr{
        MsgBox(WIN_ERROR_TXT1 . Terr.Extra . WIN_ERROR_TXT2)
    }catch as err{
        MsgBox(UNEXPECTED_ERROR)
    }
}

WrapWinActive(wintitle){
    try{
        WinActivate wintitle
    }catch TargetError as Terr{
        MsgBox(WIN_ERROR_TXT1 . Terr.Extra . WIN_ERROR_TXT2)
    }catch as err{
        MsgBox(UNEXPECTED_ERROR)
    }
}