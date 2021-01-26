; Extract Child Files
; Author: Nico Covert - nicovert
; Version: 1.0

Loop %0%
{
	pathIn := %A_Index%

	FileGetAttrib, Attributes, % pathIn
	IfNotInString, Attributes, D
	{
		MsgBox Please select a directory.
		Exit
	}

	lastSlash := InStr(pathIn,"\",false,0)
	pathParent := SubStr(pathIn,1,lastSlash-1)
	pathChild := pathIn . "\*.*"
	;MsgBox % "og: " . pathIn . "`nSlash: " . lastSlash . "`nParent: " . pathParent . "`nChild: " . pathChild

	ErrorCount := MoveFilesAndFolders(pathChild, pathParent)
	if (ErrorCount != 0)
    	MsgBox %ErrorCount% files/folders could not be copied.
	ErrorRecycle := Recycle(pathIn)
	if (ErrorRecycle !=0)
		Msgbox %ErrorRecycle% files/folders could not be recycled.
	Send, {F5}
}

;From AHK docs
MoveFilesAndFolders(SourcePattern, DestinationFolder, DoOverwrite = false)
; Copies all files and folders matching SourcePattern into the folder named DestinationFolder and
; returns the number of files/folders that could not be copied.
{
    ; First move all the files (but not the folders):
    FileMove, %SourcePattern%, %DestinationFolder%, %DoOverwrite%
    ErrorCount := ErrorLevel
    ; Now move all the folders:
    Loop, %SourcePattern%, 2  ; 2 means "retrieve folders only".
    {
        FileMoveDir, %A_LoopFileFullPath%, %DestinationFolder%\%A_LoopFileName%, %DoOverwrite%
        ErrorCount += ErrorLevel
        if ErrorLevel  ; Report each problem folder by name.
            MsgBox Could not move %A_LoopFileFullPath% into %DestinationFolder%.
    }
    return ErrorCount
}

Recycle(SourcePattern)
{
	FileRecycle, %SourcePattern%
	ErrorRecycle := ErrorLevel
	return ErrorRecycle
}