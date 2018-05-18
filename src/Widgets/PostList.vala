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

public class PostList : Gtk.ListBox {
    public PostList () {
        activate_on_single_click = true;
        set_selection_mode (Gtk.SelectionMode.SINGLE);

        var settings = new GLib.Settings ("com.github.mdh34.hackup");
        var type = settings.get_string ("listtype");
        var top = Stories.get_posts (type);

        var author_group = new Gtk.SizeGroup (Gtk.SizeGroupMode.BOTH);
        var title_group = new Gtk.SizeGroup (Gtk.SizeGroupMode.BOTH);
        var comments_group = new Gtk.SizeGroup (Gtk.SizeGroupMode.BOTH);

        for (int i = 0; i < 40; i++) {
            add (new PostEntry(top[i], author_group, title_group, comments_group));
        }

        row_selected.connect ((row) => {
             MainWindow.load_page (((PostEntry) row).post.story_uri);
        });
    }
}