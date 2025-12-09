#!/bin/bash

# vapigen --pkg glib-2.0 --pkg gtk+-3.0 --library thunarx-3 Thunarx-3.0.gir

vapigen --library=thunarx-3.0 --pkg=gtk+-3.0 --pkg=gio-2.0 /usr/share/gir-1.0/Thunarx-3.0.gir
