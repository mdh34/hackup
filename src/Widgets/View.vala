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

public class View : WebKit.WebView {
    public void clear_cookies () {
        string path = Path.build_filename (Environment.get_user_data_dir (), "com.github.mdh34.hackup", "cookies");
        if (GLib.FileUtils.test (path, GLib.FileTest.EXISTS)) {
            var file = File.new_for_path (path);
            file.delete_async.begin (Priority.DEFAULT, null, (obj, res) => {
                try {
                    file.delete_async.end (res);
                } catch (Error e) {
                    warning ("Error deleting cookies: %s", e.message);
                }
            });
        }
    }

    public void setup_cookies (bool status) {
        var context = this.get_context ();
        var cookies = context.get_cookie_manager ();
        if (status) {
            string folder = Path.build_filename (Environment.get_user_data_dir (), "com.github.mdh34.hackup");
            string path = Path.build_filename (folder, "cookies");

            if (!GLib.FileUtils.test (folder, GLib.FileTest.IS_DIR)) {
                var file = File.new_for_path (folder);
                try {
                    file.make_directory ();
                } catch (Error e) {
                    warning ("Unable to create cookies directory: %s", e.message);
                }
            }
            cookies.set_accept_policy (WebKit.CookieAcceptPolicy.ALWAYS);
            cookies.set_persistent_storage (path, WebKit.CookiePersistentStorage.SQLITE);
        } else {
            clear_cookies ();
            cookies.set_accept_policy (WebKit.CookieAcceptPolicy.NEVER);
        }
    }
}