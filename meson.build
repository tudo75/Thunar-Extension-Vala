# project name and programming language
project('com.github.tudo75.thunar-extension-vala', ['vala', 'c'], version: '0.0.1')

i18n = import('i18n')

add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format (meson.project_name()), language:'c')

prefix = get_option('prefix')
bindir = get_option('bindir')
# datadir -> /usr/share
datadir = get_option('datadir')
libdir = get_option('libdir')
includedir = get_option('includedir')
libexecdir = get_option('libexecdir')
include_dirs = include_directories('.', './headers')
vapidir = get_option('datadir') / 'vala' / 'vapi' 

vapi_dir = meson.current_source_dir() / 'vapi'
add_project_arguments(['--vapidir', vapi_dir], language: 'vala')
add_project_arguments(['--enable-experimental'], language: 'vala')


dependencies = [
	dependency('gtk+-3.0', version: '>= 3.20'),
	dependency('glib-2.0'),
	dependency('thunarx-3'),
]

pkgconfig = import('pkgconfig')

PKGCONFIG_DEPS = [
    'gtk+-3.0',
    'glib-2.0',
    'thunarx-3',
]

# subdir('po')
subdir('src')
