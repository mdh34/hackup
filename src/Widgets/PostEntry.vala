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

public class PostEntry : Gtk.Box {
    public PostEntry (string id, Gtk.SizeGroup author_group, Gtk.SizeGroup title_group) {
        var post = new Post (id);
        this.spacing = 5;
        var author_label = new Gtk.Label (post.author);
        var title_label = new Gtk.Label (post.title);
        var open_button = new Gtk.Button.from_icon_name ("window-new");
        open_button.hexpand = false;
        open_button.clicked.connect (() => {
            warning ("open button clicked for id %s", id);
        });
        author_group.add_widget (author_label);
        title_group.add_widget (title_label);
        pack_start (author_label);
        pack_start (title_label);
        pack_start (open_button);
        show_all ();
    }

}