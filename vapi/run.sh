#!/bin/bash

# 1. Generate C code
valac -C --vapidir=. --pkg=thunarx-3 --pkg=gtk+-3.0 ../src/main.vala

# 2. Compile
gcc -shared -fPIC -o libhello-plugin.so $(pkg-config --cflags --libs gtk+-3.0 thunarx-3) main.c

# 3. Install
sudo cp libhello-plugin.so /usr/lib/x86_64-linux-gnu/thunarx-3/
