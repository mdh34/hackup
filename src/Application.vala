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

public class HackUp : Gtk.Application {
    public static GLib.Settings settings;
    static construct {
        settings = new GLib.Settings ("com.github.mdh34.hackup");
    }

    public HackUp () {
        Object (
            application_id: "com.github.mdh34.hackup",
            flags: ApplicationFlags.FLAGS_NONE
        );
    }
    public override void activate () {
        var window = new MainWindow (this);

        var provider = new Gtk.CssProvider ();
        provider.load_from_resource ("/com/github/mdh34/hackup/Application.css");
        
        var contrast_provider = new Gtk.CssProvider ();
        contrast_provider.load_from_resource ("/com/github/mdh34/hackup/contrast.css");

        if (settings.get_boolean ("accent")) {
            change_provider (provider);
        } else {
            change_provider (contrast_provider);
        }

        settings.changed["accent"].connect(()=> {
            if (settings.get_boolean ("accent")) {
                change_provider (provider);
            } else {
                change_provider (contrast_provider);
            }
        });
        
        var quit_action = new SimpleAction ("quit", null);
        add_action (quit_action);
        set_accels_for_action ("app.quit", {"<Control>q"});
        quit_action.activate.connect (() => {
            window.destroy ();
        });
    }

    public static int main (string[] args) {
        var app = new HackUp ();
        return app.run (args);
    }

    public void change_provider (Gtk.CssProvider provider) {
        Gtk.StyleContext.add_provider_for_screen (Gdk.Screen.get_default (), provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);
    }
}
