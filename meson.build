# 1. PROJECT SETUP
# project name and programming language
project(
'com.github.tudo75.thunar-extension-vala',
['vala', 'c'],
        version: '0.0.1',
        meson_version: '>= 0.50.0',)

# 2. TRANSLATIONS
# Configure gettext for translations handling
i18n = import('i18n')
add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format (meson.project_name()), language:'c')


# 3. DEPENDENCIES
# In your command, you used '--pkg=thunarx-3' and '--pkg=gtk+-3.0'.
# Meson uses the 'dependency()' function to find these libraries on your system
# (similar to what pkg-config does in your gcc command).
thunar_dep = dependency('thunarx-3')
gtk_dep = dependency('gtk+-3.0')

# 4. COMPILER ARGUMENTS (Optional but good practice)
# You used '--vapidir=.'. If you have custom .vapi files in this folder,
# you would uncomment the lines below to tell the Vala compiler to look here.
vapi_dir = meson.current_source_dir() / 'vapi'
add_project_arguments(['--vapidir', vapi_dir], language: 'vala')

# 5. INSTALLATION DIRECTORY
# A Thunar plugin must be installed into a specific system folder to work.
# We ask the 'thunarx-3' dependency where that folder is.
# This ensures that even if your distro changes paths, the build script finds the right place.
extensions_dir = thunar_dep.get_pkgconfig_variable('extensionsdir')
# Usually prints something like: /usr/lib/x86_64-linux-gnu/thunarx-3

# 6. BUILD TARGET
# You used 'gcc -shared ... -o libhello-plugin.so'.
# In Meson, 'shared_library' tells it to build a .so file.
# Note: Meson automatically handles 'valac -C' (Vala to C) behind the scenes.
shared_library('hello-plugin',
  sources: ['src/main.vala'],
  dependencies: [thunar_dep, gtk_dep],
  install: true,
  install_dir: extensions_dir, # Tells Meson to install it to the Thunar extensions folder
  # prefix: '', # Prevents Meson from adding an extra 'lib' prefix if Thunar doesn't expect it (optional)
)

# 7. OUTPUT MESSAGE
# Just a helper to let you know where things will go when you configure.
message('Thunar extension directory detected as: ' + extensions_dir)

# 8 SUBDIR INCLUSIONS
# subdir('po')
# subdir('src')
