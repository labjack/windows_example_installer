; LabJack application files for both UD and LJM
;
; Prerequisites:
;  - $INSDIR must be set
;  - CREATE_SMGROUP_SHORTCUT macro

!ifndef no_labjack_apps

Section -labjack_app_shared
    SetShellVarContext "all"
    SetOverwrite on

    ; Ensure the LabVIEW Run-Time 7.1 is installed
    ClearErrors
    ReadRegStr \
        $R0 \
        HKLM \
        "SOFTWARE\National Instruments\LabVIEW Run-Time\7.1" \
        "Path"
    StrCmp $R0 "" 0 doneRT2
        SetOutPath $INSTDIR\Applications\LVRTE
        File Files\32-bit\LVRunTimeEng.exe
        ExecWait '$INSTDIR\Applications\LVRTE\LVRunTimeEng.exe'
    doneRT2:

    SetOutPath $INSTDIR\Icons
    File icons\LabJackIcon.ico

    StrCpy $R2 $StartMenuGroup 1
    StrCmp $R2 ">" no_smgroup
        SetOutPath $SMPROGRAMS\$StartMenuGroup
        CreateShortcut \
            "$SMPROGRAMS\$StartMenuGroup\LabJack Support.lnk" \
            https://labjack.com/support \
            "" \
            $INSTDIR\Icons\LabJackIcon.ico \
            ""
    no_smgroup:
SectionEnd

!endif
