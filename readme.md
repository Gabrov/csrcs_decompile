# CSRCS decompilation

# CSRCS vírus AutoIt scriptjének visszafejtett forrása.

A vírus viselkedésének jellemzői:  
  * cftuon.exe, cftu.exe, csrcs.exe néven fut, lehet, hogy használta az alokium.exe nevet is. Lemásolja magát a gyökérkönyvtárba egy futtatható fájlba, aminek a neve véletlenszerűen generált 6 karakter hosszú alfabetikus karakterlánc.
  * A TeaTimer.exe -t, ami a Spybot - Search & Destroy része, folyamatosan ellenőrzi és ha fut, bezárja. A TeaTimer feladata a rendszer beállítások módosításának ellenőrzése/megakadályozása.
  * A regisztrációs adatbázisba a HKLM\Software\Microsoft\DRM\amty kulcs alá írja be a saját értékeit.
  * A temp mappában létrehozott s.cmd fájllal takarít maga után.

# Decompiled source of AutoIt script virus named CSRCS

Main aspects of the behaviour of the virus:
* Runs with the filenames cftuon.exe, cftu.exe, csrcs.exe, probably used alokium.exe name too. It copies itself into the root folder as an executable file whose name is randomly generated, 6 characters long alphabetical.
* It constantly checks for the running of TeaTimer.exe, which is part of Spybot - Search & Destroy and if it is found then will be closed. TeaTimer supposed to control/prevent modifying system setting changes.
* It writes its own settings to the registry under the key HKLM\Software\Microsoft\DRM\amty.
* It cleans up with an s.cmd batch file created in the temp folder.
