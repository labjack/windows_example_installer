
Function CreateSMGroupShortcut
    Exch $R0 ;PATH
    Exch
    Exch $R1 ;NAME
    Push $R2
    StrCpy $R2 $StartMenuGroup 1
    StrCmp $R2 ">" no_smgroup
        SetOutPath $SMPROGRAMS\$StartMenuGroup
        CreateShortcut "$SMPROGRAMS\$StartMenuGroup\$R1.lnk" $R0
    no_smgroup:
    Pop $R2
    Pop $R1
    Pop $R0
FunctionEnd

Function un.DeleteSMGroupShortcut
    Exch $R1 ;NAME
    Push $R2
    StrCpy $R2 $StartMenuGroup 1
    StrCmp $R2 ">" no_smgroup
        Delete /REBOOTOK "$SMPROGRAMS\$StartMenuGroup\$R1.lnk"
    no_smgroup:
    Pop $R2
    Pop $R1
FunctionEnd
