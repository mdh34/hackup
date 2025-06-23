##  This project has been archived and is no longer maintained!

# ![Icon](https://github.com/mdh34/hackup/raw/master/data/icons/64/com.github.mdh34.hackup.svg?sanitize=true) HackUp


Read Hacker News from the desktop

![Screenshot](https://raw.githubusercontent.com/mdh34/hackup/master/data/images/screenshot-1.png)

## Build Dependencies:
 - libgranite-dev >= 5.0
 - libgtk-3-dev
 - libjson-glib-dev
 - libsoup2.4-dev
 - libwebkit2gtk-4.0-dev
 - meson
 - valac

## Install:
### Flatpak:
 HackUp is avaliable on Flathub, install it by running:
 ```
 flatpak install flathub com.github.mdh34.hackup
 ```
### From Source:
```
sudo apt install libgranite-dev libgtk-3-dev libjson-glib-dev libsoup2.4-dev libwebkit2gtk-4.0-dev meson valac
git clone https://github.com/mdh34/hackup.git
cd ./hackup/
meson build --prefix=/usr
cd build
ninja
sudo ninja install
```
