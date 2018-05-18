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
    public PostEntry (string id, Gtk.SizeGroup author_group, Gtk.SizeGroup title_group) {
        var grid = new Gtk.Grid ();
        grid.row_spacing = 5;

        post = new Post (id);

        var author_label = new Gtk.Label (post.author);
        author_label.set_halign (Gtk.Align.CENTER);
        author_label.get_style_context ().add_class (Gtk.STYLE_CLASS_DIM_LABEL);

        var score_label = new Gtk.Label ("Score: " + post.score.to_string ());
        score_label.set_halign (Gtk.Align.START);
        score_label.get_style_context ().add_class (Gtk.STYLE_CLASS_DIM_LABEL);

        var title_label = new Gtk.Label (post.title);
        title_label.get_style_context ().add_class ("h3");
        title_label.set_ellipsize (Pango.EllipsizeMode.END);
        var comment_button = new Gtk.Button.from_icon_name ("edit");
        comment_button.clicked.connect (() => {
            MainWindow.load_page (post.comment_uri);
        });


        this.activate.connect (() => {
            MainWindow.load_page (post.story_uri);
        });

        title_group.add_widget (title_label);
        author_group.add_widget (score_label);

        grid.attach (author_label, 0, 2, 1, 1);
        grid.attach (title_label, 0, 1, 1, 1);
        grid.attach (score_label, 1, 2, 1, 1);
        grid.attach (comment_button, 2, 2, 1, 1);
        add (grid);
    }

}