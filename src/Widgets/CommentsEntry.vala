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

public class CommentEntry : Gtk.ListBoxRow {
    public Post post;

    private Gtk.Label author_label;
    private Gtk.Label score_label;
    private Gtk.Label content_label;

    public CommentEntry (int64 id, Gtk.SizeGroup score_group, Gtk.SizeGroup content_group, Gtk.SizeGroup author_group) {
        author_label = new Gtk.Label (null);
        var author_context = author_label.get_style_context ();
        author_context.add_class (Gtk.STYLE_CLASS_DIM_LABEL);



        score_label = new Gtk.Label (null);
        var score_context = score_label.get_style_context ();
        score_context.add_class (Gtk.STYLE_CLASS_DIM_LABEL);
        score_context.add_class (Granite.STYLE_CLASS_ACCENT);

        content_label = new Gtk.Label (null);
        content_label.use_markup = true;
        content_label.xalign = 0;

        this.activate.connect (() => {
            if (post.story_uri != null) {
                MainWindow.load_page (post.story_uri);
            }
        });

        content_group.add_widget (content_label);
        score_group.add_widget (score_label);
        author_group.add_widget (author_label);

        var info_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 5);
        info_box.pack_start (author_label);
        info_box.pack_start (score_label);


        var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 5);
        box.pack_start (content_label);
        box.pack_start (info_box,true, true);
        add (box);

        post = new Post (id);
        post.load.begin ((obj, res) => {
            try {
                post.load.end (res);
            } catch (Error e) {
                warning ("Error getting post: %s, trying again...", e.message);
                post.load.begin (() => update ());
            }
            update ();
        });
    }

    private void update () {
        author_label.label = post.author;
        var comments_html = "<a href=\"" + post.comment_uri + "\">";
        score_label.label = _("Score: ") + post.score.to_string ();
        content_label.label = post.content;
    }
}