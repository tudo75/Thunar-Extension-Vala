conf = configuration_data()
conf.set('prefix', get_option('prefix'))
conf.set('libdir', get_option ('libdir'))
conf.set('PROJECT_NAME', 'com.github.tudo75.thunar-extension-vala')
conf.set('PROJECT_VERSION', meson.project_version())

pluginsdatadir = join_paths(datadir, 'thunarx-3')
pluginslibdir = join_paths(libdir, 'thunarx-3')

sources = files(
    'fooextension.vala',
)

libsessionsaver = library(
    'thunar-extension-vala',
    sources,
    vala_header: 'fooextension.h',
    dependencies : dependencies,
    vala_args: [
        '--abi-stability'
    ],
    install: true,
    include_directories: include_dirs,
    install_rpath: join_paths(prefix, libdir, 'thunarx-3'),
    install_dir: [
        pluginslibdir,
        true,
        vapidir,
    ]
)
