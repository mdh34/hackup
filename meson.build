project('com.github.mdh34.hackup', 'vala', 'c')

i18n = import('i18n')

add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format (meson.project_name()), language:'c')

subdir('src')
subdir('data')
subdir('po')
meson.add_install_script('meson/post_install.py')