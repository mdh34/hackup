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
        var cookies_switch = new Gtk.Switch ();
        HackUp.settings.bind ("cookies", cookies_switch, "active", SettingsBindFlags.DEFAULT);

        var contrast_switch = new Gtk.Switch ();
        HackUp.settings.bind ("accent", contrast_switch, "active", SettingsBindFlags.DEFAULT);

        var cookies_label = new Gtk.Label (_("Cookies"));
        var switch_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 5);
        switch_box.pack_start (cookies_label);
        switch_box.pack_start (cookies_switch);

        var contrast_icon = new Gtk.Image.from_icon_name ("preferences-color", Gtk.IconSize.LARGE_TOOLBAR);
        var contrast_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 5);
        contrast_box.homogeneous = true;
        contrast_box.pack_start (contrast_icon);
        contrast_box.pack_start (contrast_switch);

        var settings_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 5);
        settings_box.border_width = 10;
        settings_box.pack_start (contrast_box);
        settings_box.pack_start (switch_box);
        
        settings_box.show_all ();
        add (settings_box);

        this.closed.connect (() => {
            view.setup_cookies (cookies_switch.active);
        });
    }
}
