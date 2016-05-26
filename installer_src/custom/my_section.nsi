; Add your installer code here
Section "-my_section"
    SetShellVarContext "all"
    SetOverwrite on

    ; Example: If InstallDir is set to by myName, the following installs
    ; myapp.exe to somewhere like:
    ;     C:\Program Files (x86)\myName\myapp.exe
    ; SetOutPath $INSTDIR
    ; File Files\myapp.exe
SectionEnd

; Add your uninstaller code here
Section "-un.my_section"
	; Example:
	;   Removes myapp.exe from the directory where the uninstaller is
    ; Delete "$INSTDIR\myapp.exe"
SectionEnd
