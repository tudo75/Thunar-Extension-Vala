# Thunar-Extension-Vala
Boilerplate to write Thunar extensions in Vala

## Requirements
First of all the system must support threads.

To compile some libraries are needed:

* meson
* ninja-build
* valac
* libgtk-3-dev
* libthunarx-3-dev

To install on Ubuntu based distros:

    sudo apt install meson ninja-build build-essential valac cmake libgtk-3-dev libthunarx-3-dev

## Install
Clone the repository:
	
	git clone https://github.com/tudo75/Thunar-Extension-Vala.git
	cd PdfToCbr

And from inside the cloned folder:
	
	meson setup build --prefix=/usr
	ninja -v -C build com.github.tudo75.thunar-extension-vala-gmo
	ninja -v -C build thuanr-extension-vala-plugin
	sudo ninja -v -C build install
    sudo chmod 644 /usr/lib/x86_64-linux-gnu/thunarx-3/thunar-extension-vala-plugin.so

## Uninstall
To uninstall and remove all added files, go inside the cloned folder and:

	sudo ninja -v -C build uninstall