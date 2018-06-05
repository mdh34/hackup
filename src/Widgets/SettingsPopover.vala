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
public class SettingsPopover : Gtk.Popover {
    public string current_sort;
    public SettingsPopover (View view) {
        var settings = new GLib.Settings ("com.github.mdh34.hackup");
        current_sort = settings.get_string ("listtype");

        var settings_label = new Gtk.Label (_("Sort stories by:"));
        var top_radio = new Gtk.RadioButton.with_label (null, _("Top"));
        top_radio.toggled.connect (() => {
            toggled ("top");
        });
        var best_radio = new Gtk.RadioButton.with_label_from_widget (top_radio, _("Best"));
        best_radio.toggled.connect (() => {
            toggled ("best");
        });
        var new_radio = new Gtk.RadioButton.with_label_from_widget (top_radio, _("New"));
        new_radio.toggled.connect (() => {
            toggled ("new");
        });

        switch (current_sort) {
            case "top":
                top_radio.active = true;
                break;
            case "best":
                best_radio.active = true;
                break;
            case "new":
                new_radio.active = true;
                break;
        }

        var cookies_switch = new Gtk.Switch ();
        settings.bind ("cookies", cookies_switch, "active", SettingsBindFlags.DEFAULT);

        var cookies_label = new Gtk.Label (_("Cookies"));
        var switch_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 5);
        switch_box.pack_start (cookies_label);
        switch_box.pack_start (cookies_switch);

        var settings_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 5);
        settings_box.border_width = 10;
        settings_box.pack_start (switch_box);
        settings_box.pack_start (new Gtk.Separator (Gtk.Orientation.HORIZONTAL));
        settings_box.pack_start (settings_label);
        settings_box.pack_start (top_radio);
        settings_box.pack_start (best_radio);
        settings_box.pack_start (new_radio);
        settings_box.show_all ();
        add (settings_box);

        this.closed.connect (() => {
            view.setup_cookies (cookies_switch.active);
        });
    }

    private void toggled (string new_sort) {
        var settings = new GLib.Settings ("com.github.mdh34.hackup");
        settings.set_string ("listtype", new_sort);
    }
}