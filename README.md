# HackUp
[![build](https://travis-ci.org/mdh34/hackup.svg?branch=master)](https://travis-ci.org/mdh34/hackup)

Read Hacker News from the desktop

![Screenshot](https://raw.githubusercontent.com/mdh34/hackup/master/data/images/screenshot-1.png)

## Build Dependencies:
 - libgranite-dev
 - libgtk-3-dev
 - libjson-glib-dev
 - libwebkit2gtk-4.0-dev
 - meson
 - valac
 
## Install:
```
sudo apt install libgranite-dev libgtk-3-dev libjson-glib-dev libwebkit2gtk-4.0-dev meson valac
git clone https://github.com/mdh34/hackup.git
cd ./hackup/
meson build --prefix=/usr
cd build
ninja
sudo ninja install
```
