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
    static View view;
    public static Gtk.ScrolledWindow comments_view;
    public static Gtk.Stack stack;
    public MainWindow (Gtk.Application application) {
        Object (
            application: application,
            icon_name: "com.github.mdh34.hackup",
            title: "HackUp"
        );
    }

    static construct {
        view = new View ();
        comments_view = new Gtk.ScrolledWindow (null,null);
        stack = new Gtk.Stack ();
        stack.add_named (view, "view");
        stack.add_named (comments_view, "comments_view");
    }

    construct {
        set_position (Gtk.WindowPosition.CENTER);

        var header = new Gtk.HeaderBar ();
        header.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
        header.set_show_close_button (true);
        set_titlebar (header);

        var views_buttons = new Granite.Widgets.ModeButton ();
        views_buttons.append_text (_ ("Top"));
        views_buttons.append_text (_ ("Best"));
        views_buttons.append_text (_ ("New"));
        switch (HackUp.settings.get_string ("listtype")) {
          case "top":
            views_buttons.selected = 0;
            break;
          case "best":
            views_buttons.selected = 1;
            break;
          case "new":
            views_buttons.selected = 2;
            break;
        }
        header.pack_start (views_buttons);

        if (!check_online ()) {
            var offline_view = new Granite.Widgets.AlertView (_("Unable to reach Hacker News"), _("Please connect to the internet to use HackUp"), "applications-internet");
            add (offline_view);
            show_all ();
            return;
        }
        var settings_popover = new SettingsPopover (view);

        var settings_button = new Gtk.MenuButton ();
        settings_button.image = new Gtk.Image.from_icon_name ("open-menu-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
        settings_button.popover = settings_popover;
        settings_button.set_tooltip_text (_("Settings"));
        header.pack_end (settings_button);

        var back_button = new Gtk.Button ();
        back_button.get_style_context ().add_class (Granite.STYLE_CLASS_BACK_BUTTON);
        back_button.no_show_all = true;
        header.pack_start (back_button);

        PostList list;
        var gtk_settings = Gtk.Settings.get_default ();
        var theme_switch = new Granite.ModeSwitch.from_icon_name ("display-brightness-symbolic", "weather-clear-night-symbolic");
        theme_switch.row_homogeneous = true;
        theme_switch.active = HackUp.settings.get_boolean ("dark");
        theme_switch.bind_property ("active", gtk_settings, "gtk_application_prefer_dark_theme");
        theme_switch.notify["active"].connect (() => {
            if (theme_switch.active) {
                list.get_style_context ().add_class ("dark");
            } else {
                list.get_style_context ().remove_class ("dark");
            }
        });
        header.pack_end (theme_switch);

        var window_width = HackUp.settings.get_int ("width");
        var window_height = HackUp.settings.get_int ("height");
        set_default_size (window_width, window_height);

        var window_x = HackUp.settings.get_int ("x");
        var window_y = HackUp.settings.get_int ("y");
        if (window_x != -1 || window_y != -1) {
            move (window_x, window_y);
        }

        list = new PostList ();
        var scroller = new Gtk.ScrolledWindow (null, null);
        scroller.hscrollbar_policy = Gtk.PolicyType.NEVER;
        scroller.add (list);

        var dark = HackUp.settings.get_boolean ("dark");
        if (dark) {
            gtk_settings.set ("gtk-application-prefer-dark-theme", true);
            list.get_style_context ().add_class ("dark");
        }

        views_buttons.mode_changed.connect (() => {
          string list_sorting;
          stdout.printf ("%d",views_buttons.selected);
            switch (views_buttons.selected) {
              case 0:
                list_sorting = "top";
                break;
              case 1:
                list_sorting = "best";
                break;
              case 2:
                list_sorting = "new";
                break;
            }
            HackUp.settings.set_string ("listtype", list_sorting);
            if (settings_popover.current_sort != list_sorting) {
                var new_list = new PostList ();
                scroller.remove (scroller.get_child ());
                scroller.add (new_list);
                settings_popover.current_sort = list_sorting;

                show_all ();
                new_list.set_selection_mode (Gtk.SelectionMode.SINGLE);
            }
        });

        view.setup_cookies (HackUp.settings.get_boolean ("cookies"));

        var pane = new Gtk.Paned (Gtk.Orientation.HORIZONTAL);
        pane.pack1 (scroller, false, false);
        pane.add2 (stack);
        pane.set_position (HackUp.settings.get_int ("position"));
        add (pane);
        show_all ();

        list.set_selection_mode (Gtk.SelectionMode.SINGLE);

        this.delete_event.connect (() => {
            int current_x, current_y, width, height;
            get_position (out current_x, out current_y);
            get_size (out width, out height);
            HackUp.settings.set_boolean ("dark", theme_switch.active);
            HackUp.settings.set_int ("x", current_x);
            HackUp.settings.set_int ("y", current_y);
            HackUp.settings.set_int ("width", width);
            HackUp.settings.set_int ("height", height);
            HackUp.settings.set_int ("position", pane.get_position ());
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
}
