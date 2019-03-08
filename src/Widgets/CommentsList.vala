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

public class CommentsList : Gtk.ListBox {
    private Gtk.SizeGroup author_group;
    private Post post;
    public CommentsList (Post parent, int64 last) {
        post = parent;
        author_group = new Gtk.SizeGroup (Gtk.SizeGroupMode.BOTH);

        if (last != parent.id) {
          margin_start = 20;
        }

        load.begin ();
    }

    private async void load () {
        int64[] list = {};
        list = post.get_children ();
        for (int i = 0; i < list.length; i++) {
            add (new CommentEntry (list[i], post.id, author_group));
        }

        show_all ();
    }
}
