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
    private Gtk.Label last_label;
    private Gtk.ListBox comments_box;
    private Post post;
    public CommentsList (Post parent, int64 last) {
        post = parent;
        author_group = new Gtk.SizeGroup (Gtk.SizeGroupMode.BOTH);

        var back_button = new Gtk.Button.with_label (_("Back"));
        back_button.get_style_context ().add_class (Granite.STYLE_CLASS_BACK_BUTTON);
        if (last == parent.id) {
            back_button.no_show_all = true;
        } else {
            back_button.clicked.connect (() => {
                MainWindow.stack.set_visible_child_name (last.to_string ());
            });
        }

        last_label = new Gtk.Label (_("Replies to ")+  post.author);

        var top_bar = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 5);
        top_bar.pack_start (back_button, false, false);
        top_bar.pack_start (last_label);

        comments_box = new Gtk.ListBox ();
        comments_box.activate_on_single_click = true;
        comments_box.set_selection_mode (Gtk.SelectionMode.NONE);

        var container = new Gtk.Box (Gtk.Orientation.VERTICAL, 5);
        container.pack_start (top_bar, false, false);
        container.pack_start (comments_box);
        add (container);
        load.begin ();
    }

    private async void load () {
        int64[] list = {};
        list = post.get_children ();
        for (int i = 0; i < list.length; i++) {
            comments_box.add (new CommentEntry (list[i], post.id, author_group));
        }

        foreach (Gtk.Widget child in get_children ()) {
            if (child.visible == false) {
                remove (child);
            }
        }

        show_all ();
    }
}