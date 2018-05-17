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

public class Post {
    public string author;
    public string title;
    public string text;
    private Soup.Session session;

    public Post (string item) {
        var uri = "https://hacker-news.firebaseio.com/v0/item/" + item + ".json?print=pretty";
        var message = new Soup.Message ("GET", uri);
        session = new Soup.Session ();
        session.send_message (message);

        try {
            var parser = new Json.Parser ();
            parser.load_from_data ((string) message.response_body.flatten ().data, -1);
            var root_object = parser.get_root ().get_object ();
            author = root_object.get_string_member ("by");
            title = root_object.get_string_member ("title");
            text = root_object.get_string_member ("text");
        } catch (Error e) {
            warning ("Error parsing data: %s", e.message);
        }

    }
}