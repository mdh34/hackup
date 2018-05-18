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

        var settings_popover = new SettingsPopover ();

        var settings_button = new Gtk.MenuButton ();
        settings_button.image = new Gtk.Image.from_icon_name ("open-menu", Gtk.IconSize.SMALL_TOOLBAR);
        settings_button.popover = settings_popover;
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

        var pane = new Gtk.Paned(Gtk.Orientation.HORIZONTAL);
        pane.wide_handle = true;
        pane.pack1 (scroller, true, false);
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

}