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
    private Gtk.SizeGroup author_group;
    private Gtk.SizeGroup title_group;
    private Gtk.SizeGroup comments_group;
    private Gtk.SizeGroup score_group;

    public PostList () {
        activate_on_single_click = true;
        set_selection_mode (Gtk.SelectionMode.NONE);

        author_group = new Gtk.SizeGroup (Gtk.SizeGroupMode.BOTH);
        title_group = new Gtk.SizeGroup (Gtk.SizeGroupMode.BOTH);
        comments_group = new Gtk.SizeGroup (Gtk.SizeGroupMode.BOTH);
        score_group = new Gtk.SizeGroup (Gtk.SizeGroupMode.BOTH);

        row_selected.connect ((row) => {
            MainWindow.load_page (((PostEntry) row).post.story_uri);
        });

        load.begin ();
    }

    private async void load () {
        var settings = new GLib.Settings ("com.github.mdh34.hackup");
        var type = settings.get_string ("listtype");
        var top = yield Stories.get_posts (type);
        for (int i = 0; i < int.min (top.length, 40); i++) {
            add (new PostEntry(top[i], score_group, title_group, comments_group, author_group));
        }

        show_all ();
    }
}