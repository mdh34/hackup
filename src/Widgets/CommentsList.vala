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

public class CommentsList : Gtk.ScrolledWindow {
    private Gtk.SizeGroup author_group;
    private Gtk.SizeGroup content_group;
    private Gtk.SizeGroup score_group;
    private Gtk.ListBox box;
    private Post post;

    public CommentsList (Post parent) {
        box = new Gtk.ListBox ();
        post = parent;
        box.activate_on_single_click = true;
        box.set_selection_mode (Gtk.SelectionMode.NONE);

        author_group = new Gtk.SizeGroup (Gtk.SizeGroupMode.BOTH);
        content_group = new Gtk.SizeGroup (Gtk.SizeGroupMode.BOTH);
        score_group = new Gtk.SizeGroup (Gtk.SizeGroupMode.BOTH);
        add (box);
        load.begin ();
    }

    private async void load () {
        int64[] list = {};
        list = post.get_children ();
        for (int i = 1; i < int.min (list.length, 40); i++) {
            box.add (new CommentEntry (list[i], score_group ,content_group, author_group));
        }

        show_all ();
    }
}