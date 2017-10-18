CSRCS decompilation

CSRCS vírus AutoIt scriptjének visszafejtett forrása.

A vírus viselkedésének jellemzői:  
  * cftuon.exe, cftu.exe, csrcs.exe néven fut, lehet, hogy használta az alokium.exe nevet is. Lemásolja magát egy véletlenszerűen generált 6 karakter hosszú .exe fájlba is.
  * A TeaTimer.exe -t, ami a Spybot - Search & Destroy része, folyamatosan ellenőrzi és ha fut, bezárja. A TeaTimer feladata a rendszer beállítások módosításának megakadályozása.
  * A regisztrációs adatbázisba a HKLM\Software\Microsoft\DRM\amty kulcs alá írja be a saját értékeit.
  * A temp mappában létrehozott s.cmd fájllal takarít maga után.
