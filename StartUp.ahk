#Requires AutoHotkey v2.0

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
}
else
{
    win1:="Notion"
    win2:="ChatGPT"
    win3:="Google Chrome"
    win4:="Visual Studio Code"
    win5:="エクスプローラー"
    MsgBox("env.txtが見つかりません。`nexeファイルとenv.txtは同じ階層にある必要があります。`nwin1~5はデフォルトの設定になります")
}
GroupAdd "MainWindows",win1
GroupAdd "MainWindows",win2
GroupAdd "MainWindows",win3
GroupAdd "MainWindows",win4
GroupAdd "MainWindows",win5

;タスクバーの高さを取得
WinGetPos ,,,&taskbarHeight,"ahk_class Shell_TrayWnd"
windowHeight := A_ScreenHeight-taskbarHeight

