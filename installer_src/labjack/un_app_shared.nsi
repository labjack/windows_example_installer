; Uninstall LabJack application files for both UD and LJM
;
; Prerequisites:
;   - "un.LJM Applications"
;   - "un.UD Applications"

!ifndef no_labjack_apps

Section -un.labjack_app_shared
    !insertmacro DELETE_SMGROUP_SHORTCUT "LabJack Support"

    Delete /REBOOTOK $INSTDIR\Icons\LabJackIcon.ico
    RmDir /r /REBOOTOK $INSTDIR\Icons

    Delete /REBOOTOK $INSTDIR\Applications\LVRTE\LVRunTimeEng.exe
    RmDir /r /REBOOTOK $INSTDIR\Applications
SectionEnd

!endif
