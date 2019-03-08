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
    private Gtk.TextView content_label;
    private Gtk.CheckButton sub_button;
    private Gtk.Box info_box;
    private Gtk.Revealer revealer;

    public CommentEntry (int64 id, int64 last, Gtk.SizeGroup author_group) {
        author_label = new Gtk.Label (null);
        author_label.xalign = 0;
        var author_context = author_label.get_style_context ();
        author_context.add_class (Gtk.STYLE_CLASS_DIM_LABEL);
        author_context.add_class (Granite.STYLE_CLASS_ACCENT);
        author_group.add_widget (author_label);

        selectable = false;

        content_label = new Gtk.TextView ();
        content_label.wrap_mode = Gtk.WrapMode.WORD;
        content_label.editable = false;

        revealer = new Gtk.Revealer ();

        this.activate.connect (() => {
            if (post.story_uri != null) {
                MainWindow.load_page (post.story_uri);
            }
        });

        sub_button = new Gtk.CheckButton.with_label (_("Replies"));
        sub_button.toggled.connect (() => {
                if (revealer.get_child () == null) {
                  revealer.add (new CommentsList (post, last));
                }
                if (sub_button.active) {
                  revealer.reveal_child = true; 
                } else {
                  revealer.reveal_child = false;
                }
        });

        info_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 5);
        info_box.pack_start (author_label);
        info_box.pack_start (sub_button, false, false);

        var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 5);
        box.pack_start (content_label);
        box.pack_start (info_box,true, true);
        box.pack_start (revealer);
        add (box);

        post = new Post (id);
        post.load.begin ((obj, res) => {
            try {
                post.load.end (res);
            } catch (Error e) {
                warning ("Error getting post: %s, trying again…", e.message);
                post.load.begin (() => update ());
            }
            update ();
        });
    }

    private void update () {
        author_label.label = post.author;

        Gtk.TextIter iter;
        content_label.buffer.get_start_iter (out iter);
        if (post.content != null) {
            content_label.buffer.insert_markup (ref iter, remove_html_tags (post.content), -1);
        } else {
            this.set_visible (false);
        }

        if (post.get_children () == null) {
            foreach (Gtk.Widget item in info_box.get_children ()) {
                if (item is Gtk.Button) {
                    info_box.remove (item);
                }
            }
        }
    }

    // Remove HTML tags so buffer is presented properly
    // Taken from https://gitlab.gnome.org/GNOME/geary/blob/master/src/engine/util/util-html.vala
    private string remove_html_tags (string input) {
        try {
            string output = input;

            unichar c;
            uint64 less_than = 0;
            uint64 greater_than = 0;
            for (int i = 0; output.get_next_char (ref i, out c);) {
                if (c == '<')
                    less_than++;
                else if (c == '>')
                    greater_than++;
            }

            if (less_than == greater_than + 1) {
                output += ">";
                greater_than++;
            }

            if (less_than != greater_than)
                return input;

            Regex script = new Regex ("<script[^>]*?>[\\s\\S]*?<\\/script>", RegexCompileFlags.CASELESS);
            output = script.replace (output, -1, 0, "");

            Regex style = new Regex ("<style[^>]*?>[\\s\\S]*?<\\/style>", RegexCompileFlags.CASELESS);
            output = style.replace (output, -1, 0, "");

            Regex tags = new Regex ("<(.|\n)*?>", RegexCompileFlags.CASELESS);
            return tags.replace (output, -1, 0, "");
        } catch (Error e) {
            debug ("Error stripping HTML tags: %s", e.message);
        }

        return input;
    }
}
