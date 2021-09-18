# live-build
Build Ubuntu or Linux Mint custom live-systems with Debian scripts

Based on Debian live-build_20190311.

Source: https://salsa.debian.org/live-team/live-build

Documentation: https://live-team.pages.debian.net/live-manual/html/live-manual/index.en.html

Wer sich ein maßgeschneidertes Live-System wünscht, kann es selbst erstellen. Auf der Basis von Ubuntu lässt es sich mit beliebigen Desktop-Umgebungen, Anwendungen und Tools ausstatten oder es zeigt als besonders schlankes System nach dem Start nur ein Terminal.

Bei diesem Projekt geht es um Live-Systeme, die sich vielfältig nutzen lassen. Es handelt sich nicht um aktualisierte Installationssysteme, obwohl auch das mit den Scripten möglich ist.

Ein Build-System, das aus einer Reihe von Bash-Scripten besteht, ist unter dem Namen „live-build“ in den Standard-Repositorien von Ubuntu und Linux Mint enthalten. Das Paket ist jedoch veraltet und unterstützt beispielsweise den Bootloader Grub nicht. Wir haben ein neueres Paket, das von Debian stammt, für Ubuntu 20.04 und Linux Mint 20 angepasst. Laden Sie die Version nach einem Klick auf "Releases" herunter und installieren Sie das deb-Paket.

Die Version wurde unter Ubuntu 18.04, 20.04 und Linux Mint 20 gestestet und kann Systeme auf der Basis von Ubuntu 20.04 erstellen.

Danach erstellt man ein Arbeitsverzeichnis, beispielsweise "~/live-build". In diesem Verzeichnis lässt sich das Script lb starten, das drei Haupoptionen kennt:

**sudo lb config:** Erstellt die Konfiguration für ein Ubuntu-Basissystem (zurzeit 20.04, "focal") ohne Desktop-Umgebung.

**sudo lb build:** Erzeugt die Datei "live-image-amd64.hybrid.iso" für das Live-System im Arbeitsverzeichnis

**sudo lb clean:** Wer den Build erneut ausführen möchte, etwa nach Änderungen in der Konfiguration, startet "sudo lb clean"
Damit werden alle Ordner entfernt, bis auf "cache" und "config". In „.build“ wird der Inhalt gelöscht. Im Ordner "cache" verbleiben die heruntergeladenen Dateien, die daher nicht erneut heruntergeladen werden müssen.

## Beispielscripte

Im Ordner "examples" liegen einige Beispiele. Kopieren Sie beispielsweise die Datei "lb_build.sh" aus dem Ordner "examples/Kubuntu" in ein neues Arbeitsverzeichnin und starten Sie das Bash-Script. Es erstellt eine angepasste Konfiguration inklusive der Paketliste für ein Kubuntu-System. Danach startet man *lb build*.

In die Paketliste in der Datei "config/package-lists/extra.list.chroot" kann man zusätzliche Pakete einbauen und das System danach neu erstellen.
