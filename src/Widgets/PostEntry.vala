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

public class PostEntry : Gtk.ListBoxRow {
    public Post post;

    private Gtk.Label author_label;
    private Gtk.Label comments_label;
    private Gtk.Label score_label;
    private Gtk.Label title_label;

    public PostEntry (int64 id, Gtk.SizeGroup score_group, Gtk.SizeGroup title_group, Gtk.SizeGroup comments_group, Gtk.SizeGroup author_group) {
        author_label = new Gtk.Label (null);
        var author_context = author_label.get_style_context ();
        author_context.add_class (Gtk.STYLE_CLASS_DIM_LABEL);

        comments_label = new Gtk.Label (null);
        comments_label.set_use_markup (true);
        comments_label.activate_link.connect ((uri) => {
            if (MainWindow.stack.get_child_by_name (post.id.to_string ()) == null) {
                MainWindow.stack.add_named (new CommentsList (post, post.id), post.id.to_string ());
            }
            MainWindow.stack.set_visible_child_name (post.id.to_string ());
            MainWindow.stack.show_all ();
            return true;
        });

        var comments_context = comments_label.get_style_context ();
        comments_context.add_class (Gtk.STYLE_CLASS_DIM_LABEL);
        comments_context.add_class (Granite.STYLE_CLASS_ACCENT);

        score_label = new Gtk.Label (null);
        var score_context = score_label.get_style_context ();
        score_context.add_class (Gtk.STYLE_CLASS_DIM_LABEL);
        score_context.add_class (Granite.STYLE_CLASS_ACCENT);

        title_label = new Gtk.Label (null);
        title_label.get_style_context ().add_class ("h4");
        title_label.get_style_context ().add_class ("titlesize");
        title_label.set_ellipsize (Pango.EllipsizeMode.END);
        title_label.xalign = 0;

        this.activate.connect (() => {
            if (post.story_uri != null) {
                MainWindow.load_page (post.story_uri);
                MainWindow.stack.set_visible_child_name ("view");
            }
        });

        title_group.add_widget (title_label);
        score_group.add_widget (score_label);
        comments_group.add_widget (comments_label);
        author_group.add_widget (author_label);

        var info_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 5);
        info_box.pack_start (author_label);
        info_box.pack_start (score_label);
        info_box.pack_start (comments_label);

        var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 5);
        box.pack_start (title_label);
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
        comments_label.label = comments_html + _("Comments: ") + post.comments.to_string () + "</a>";
        score_label.label = _("Score: ") + post.score.to_string ();
        title_label.label = post.title;
        title_label.set_tooltip_text (title_label.label);
    }
}