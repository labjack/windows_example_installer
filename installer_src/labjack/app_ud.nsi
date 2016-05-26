; LabJack application files for UD
;
; Prerequisites:
;  - $INSDIR must be set
;  - CREATE_SMGROUP_SHORTCUT macro

!ifndef no_labjack_apps

Section "UD Applications" SEC0010
    SetShellVarContext "all"
    SetOverwrite on

    SetOutPath $INSTDIR\Applications
    File Files\32-bit\LJControlPanel.exe
    File Files\32-bit\LJLogUD.exe
    File Files\32-bit\LJSelfUpgrade.exe
    File Files\32-bit\LJStreamUD.exe

    !insertmacro CREATE_SMGROUP_SHORTCUT LJControlPanel $INSTDIR\Applications\LJControlPanel.exe
    !insertmacro CREATE_SMGROUP_SHORTCUT LJLogUD $INSTDIR\Applications\LJLogUD.exe
    !insertmacro CREATE_SMGROUP_SHORTCUT LJSelfUpgrade $INSTDIR\Applications\LJSelfUpgrade.exe
    !insertmacro CREATE_SMGROUP_SHORTCUT LJStreamUD $INSTDIR\Applications\LJStreamUD.exe
SectionEnd

!endif
