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

public class PostList : Gtk.ScrolledWindow {
    public PostList () {
        hscrollbar_policy = Gtk.PolicyType.NEVER;
        var box = new Gtk.Box (Gtk.Orientation.VERTICAL, 10);
        var top = TopStories.get_top ();
        var author_group = new Gtk.SizeGroup (Gtk.SizeGroupMode.BOTH);
        var title_group = new Gtk.SizeGroup (Gtk.SizeGroupMode.BOTH);
        for (int i = 0; i < 40; i++) {
            box.pack_start (new PostEntry(top[i], author_group, title_group));
        }
        add (box);
    }
}