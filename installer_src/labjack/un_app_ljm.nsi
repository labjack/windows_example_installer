; Uninstall LabJack application files for LJM

!ifndef no_labjack_apps

Section "un.LJM Applications"
    SetShellVarContext "all"
    
    !insertmacro DELETE_SMGROUP_SHORTCUT Kipling
    !insertmacro DELETE_SMGROUP_SHORTCUT LJLogM
    !insertmacro DELETE_SMGROUP_SHORTCUT LJStreamM
    !insertmacro DELETE_SMGROUP_SHORTCUT Otero

    RmDir /r /REBOOTOK $INSTDIR\Applications\Kipling
    Delete /REBOOTOK $INSTDIR\Applications\LJLogM.exe
    Delete /REBOOTOK $INSTDIR\Applications\LJStreamM.exe
    Delete /REBOOTOK $INSTDIR\Applications\Otero.exe
SectionEnd

!endif
