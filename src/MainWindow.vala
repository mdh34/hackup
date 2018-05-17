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
    Gtk.Stack stack;

    public MainWindow (Gtk.Application application) {
        Object (
            application: application,
            icon_name: "com.github.mdh34.hackup",
            title: "HackUp"
        );
    }

    static construct {
        settings = new GLib.Settings ("com.github.mdh34.hackup");
    }
    construct {
        set_position (Gtk.WindowPosition.CENTER);

        var header = new Gtk.HeaderBar ();
        header.set_show_close_button (true);
        var header_context = header.get_style_context ();
        header_context.add_class (Gtk.STYLE_CLASS_FLAT);
        header_context.add_class ("default-decoration");
        set_titlebar (header);

        stack = new Gtk.Stack ();
        stack.set_transition_type (Gtk.StackTransitionType.SLIDE_LEFT_RIGHT);

        var window_width = settings.get_int ("width");
        var window_height = settings.get_int ("height");
        set_default_size (window_width, window_height);

        var window_x = settings.get_int ("x");
        var window_y = settings.get_int ("y");
        if (window_x != -1 || window_y != -1) {
            move (window_x, window_y);
        }

        var list = new PostList ();
        stack.add_titled (list, "scroller", "HN");
        add (stack);
        show_all ();

    }
}