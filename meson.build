project(
        'com.github.tudo75.thunar-extension-vala',
        ['vala', 'c'],
        version: '0.0.1',
      )

# Configure gettext for translations handling
i18n = import('i18n')
add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format (meson.project_name()), language:'c')


thunar_dep = dependency('thunarx-3')
gtk_dep = dependency('gtk+-3.0')

vapi_dir = meson.current_source_dir() / 'vapi'
add_project_arguments(['--vapidir', vapi_dir], language: 'vala')

# A Thunar plugin must be installed into a specific system folder to work.
# We ask the 'thunarx-3' dependency where that folder is.
# This ensures that even if your distro changes paths, the build script finds the right place.
extensions_dir = thunar_dep.get_variable('extensionsdir')
# Usually prints something like: /usr/lib/x86_64-linux-gnu/thunarx-3

shared_library(
  'thunar-extension-vala-plugin',
  sources: ['src/main.vala'],
  dependencies: [thunar_dep, gtk_dep],
  install: true,
  install_dir: extensions_dir, # Tells Meson to install it to the Thunar extensions folder
  name_prefix: '', # Prevents Meson from adding an extra 'lib' prefix if Thunar doesn't expect it (optional)
)

# 8 SUBDIR INCLUSIONS
subdir('po')
