/*
 * Copyright (c) 2018 Matt Harris
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public
 * License along with this program; if not, write to the
 * Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1301 USA
 *
 * Authored by: Matt Harris <matth281@outlook.com>
 */

public class MainWindow : Gtk.Window {
    static GLib.Settings settings;
    static WebKit.WebView view;
    public MainWindow (Gtk.Application application) {
        Object (
            application: application,
            icon_name: "com.github.mdh34.hackup",
            title: "HackUp"
        );
    }

    static construct {
        settings = new GLib.Settings ("com.github.mdh34.hackup");
        view = new WebKit.WebView ();
    }
    construct {
        set_position (Gtk.WindowPosition.CENTER);

        var header = new Gtk.HeaderBar ();
        header.get_style_context ().add_class ("default-decoration");
        header.set_show_close_button (true);
        set_titlebar (header);

        if (!check_online ()) {
            var offline_view = new Granite.Widgets.AlertView (_("Unable to reach Hacker News"), _("Please connect to the internet to use HackUp"), "applications-internet");
            add (offline_view);
            show_all ();
            return;
        }
        var settings_popover = new SettingsPopover ();

        var settings_button = new Gtk.MenuButton ();
        settings_button.image = new Gtk.Image.from_icon_name ("open-menu-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
        settings_button.popover = settings_popover;
        settings_button.set_tooltip_text (_("Settings"));
        header.pack_end (settings_button);

        var window_width = settings.get_int ("width");
        var window_height = settings.get_int ("height");
        set_default_size (window_width, window_height);

        var window_x = settings.get_int ("x");
        var window_y = settings.get_int ("y");
        if (window_x != -1 || window_y != -1) {
            move (window_x, window_y);
        }

        var list = new PostList ();
        var scroller = new Gtk.ScrolledWindow (null, null);
        scroller.hscrollbar_policy = Gtk.PolicyType.NEVER;
        scroller.add (list);

        settings_popover.closed.connect (() => {
            var list_sorting = settings.get_string ("listtype");
            if (settings_popover.current_sort != list_sorting) {
                var new_list = new PostList ();
                scroller.remove (scroller.get_child ());
                scroller.add (new_list);
                settings_popover.current_sort = list_sorting;

                show_all ();
                new_list.set_selection_mode (Gtk.SelectionMode.SINGLE);
            }
        });

        setup_cookies (settings.get_boolean ("cookies"));

        var pane = new Gtk.Paned(Gtk.Orientation.HORIZONTAL);
        pane.pack1 (scroller, false, false);
        pane.add2 (view);
        pane.set_position (settings.get_int ("position"));
        add (pane);
        show_all ();

        list.set_selection_mode (Gtk.SelectionMode.SINGLE);

        this.delete_event.connect (() => {
            int current_x, current_y, width, height;
            get_position (out current_x, out current_y);
            get_size (out width, out height);
            settings.set_int ("x", current_x);
            settings.set_int ("y", current_y);
            settings.set_int ("width", width);
            settings.set_int ("height", height);
            settings.set_int ("position", pane.get_position ());
            return false;
        });

    }

    public static void load_page (string uri) {
        view.load_uri (uri);
    }

    public bool check_online () {
        var host = "news.ycombinator.com";
        try {
            var resolve = Resolver.get_default ();
            resolve.lookup_by_name (host, null);
            return true;
        } catch {
            return false;
        }
    }

    public void setup_cookies (bool status) {
        var context = view.get_context ();
        var cookies = context.get_cookie_manager ();
        if (status) {
            string folder = Path.build_filename (Environment.get_user_data_dir (), "com.github.mdh34.hackup");
            string path = Path.build_filename (folder, "cookies");

            if (!GLib.FileUtils.test (folder, GLib.FileTest.IS_DIR)) {
                var file = File.new_for_path (folder);
                try {
                    file.make_directory ();
                } catch (Error e) {
                    warning ("Unable to create config directory: %s", e.message);
                }
            }
            cookies.set_accept_policy (WebKit.CookieAcceptPolicy.ALWAYS);
            cookies.set_persistent_storage (path, WebKit.CookiePersistentStorage.SQLITE);
        } else {
            cookies.set_accept_policy (WebKit.CookieAcceptPolicy.NEVER);
        }
    }
}