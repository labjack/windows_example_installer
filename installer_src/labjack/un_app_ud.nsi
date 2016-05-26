; Uninstall LabJack application files for UD

!ifndef no_labjack_apps

Section "un.UD Applications"
    SetShellVarContext "all"

    !insertmacro DELETE_SMGROUP_SHORTCUT LJStreamUD
    !insertmacro DELETE_SMGROUP_SHORTCUT LJLogUD
    !insertmacro DELETE_SMGROUP_SHORTCUT LJControlPanel
	!insertmacro DELETE_SMGROUP_SHORTCUT LJSelfUpgrade
    !insertmacro DELETE_SMGROUP_SHORTCUT LJLogUD

    Delete /REBOOTOK $INSTDIR\Applications\LJStreamUD.exe
    Delete /REBOOTOK $INSTDIR\Applications\LJLogUD.exe
SectionEnd

!endif
