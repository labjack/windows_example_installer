; LabJack application files for LJM
;
; Prerequisites:
;  - $INSDIR must be set
;  - CREATE_SMGROUP_SHORTCUT macro

!ifndef no_labjack_apps

Section "LJM Applications" SEC0011
    SetShellVarContext "all"
    SetOverwrite on

    SetOutPath $INSTDIR\Applications
    File Files\32-bit\LJLogM.exe
    File Files\32-bit\LJStreamM.exe
    File Files\32-bit\Otero.exe

    SetOutPath $INSTDIR\Applications\Kipling
    File /r Files\32-bit\Kipling\*

    !insertmacro CREATE_SMGROUP_SHORTCUT Kipling $INSTDIR\Applications\Kipling\Kipling.exe
    !insertmacro CREATE_SMGROUP_SHORTCUT LJLogM $INSTDIR\Applications\LJLogM.exe
    !insertmacro CREATE_SMGROUP_SHORTCUT LJStreamM $INSTDIR\Applications\LJStreamM.exe
    !insertmacro CREATE_SMGROUP_SHORTCUT Otero $INSTDIR\Applications\Otero.exe

    IfFileExists $INSTDIR\..\Kipling\unins000.exe 0 no_run_kipling_uninstaller
        MessageBox MB_OKCANCEL|MB_ICONEXCLAMATION \
        "Kipling has been installed in $INSTDIR\Applications\Kipling, but a \
        previous version of Kipling is installed in $INSTDIR\..\Kipling. \
        Select 'OK' to remove the previous version." \
        IDCANCEL no_run_kipling_uninstaller

        Exec '"$INSTDIR\..\Kipling\unins000.exe"  /VERYSILENT'
    no_run_kipling_uninstaller:
SectionEnd

!endif
