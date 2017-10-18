rem az elérési utak változókból jönnek a fájl kiírása során, ez csak példa
:loop
del \windows\system32\csrcs.exe
if exist \windows\system32\csrcs.exe goto loop
del \temp\s.cmd
