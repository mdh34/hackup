executable(
    meson.project_name(),
    'Application.vala',
    'MainWindow.vala',
    'Services/Post.vala',
    'Services/TopStories.vala',
    'Widgets/PostEntry.vala',
    'Widgets/PostList.vala',
    dependencies: [
    	dependency('granite'),
        dependency('gtk+-3.0'),
        dependency('libsoup-2.4'),
        dependency('json-glib-1.0'),
        dependency('webkit2gtk-4.0'),
    ],
    install: true
)