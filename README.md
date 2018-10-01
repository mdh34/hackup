# ![Icon](https://github.com/mdh34/hackup/raw/master/data/icons/64/com.github.mdh34.hackup.svg?sanitize=true) HackUp
[![build](https://travis-ci.org/mdh34/hackup.svg?branch=master)](https://travis-ci.org/mdh34/hackup)

Read Hacker News from the desktop

![Screenshot](https://raw.githubusercontent.com/mdh34/hackup/master/data/images/screenshot-1.png)

## Build Dependencies:
 - libgranite-dev >= 5.0
 - libgtk-3-dev
 - libjson-glib-dev
 - libsoup-2.4
 - libwebkit2gtk-4.0-dev
 - meson
 - valac

## Install:
### Flatpak:
 HackUp is avaliable on Flathub, install it by running:
 ```
 flatpak install flathub com.github.mdh34.hackup
 ```

### Arch Linux
Arch Linux users can find Hackup under the name [hackup-git](https://aur.archlinux.org/packages/hackup-git/) in the **AUR**:

`$ aurman -S hackup-git`


### From Source:
```
sudo apt install libgranite-dev libgtk-3-dev libjson-glib-dev libwebkit2gtk-4.0-dev meson valac
git clone https://github.com/mdh34/hackup.git
cd ./hackup/
meson build --prefix=/usr
cd build
ninja
sudo ninja install
```
