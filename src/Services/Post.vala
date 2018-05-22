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
    public string? author;
    public string? comment_uri;
    public string? story_uri;
    public string? title;
    public int64 comments;
    public int64 score;

    private string item;

    static Soup.Session session;

    static construct {
        session = new Soup.Session ();
    }

    public Post (string item) {
        this.item = item;
    }

    public async void load () {
        var uri = "https://hacker-news.firebaseio.com/v0/item/" + item + ".json";
        var message = new Soup.Message ("GET", uri);

        session.queue_message (message, (session, msg) => {
            parse_response ((string)(msg.response_body.flatten ().data));
            Idle.add (load.callback);
        });

        yield;
    }

    private void parse_response (string response) {
        try {
            var parser = new Json.Parser ();
            parser.load_from_data (response, -1);
            var root_object = parser.get_root ().get_object ();
            if (root_object != null) {
                if (root_object.has_member ("by")) {
                    author = root_object.get_string_member ("by");
                }
                if (root_object.has_member ("title")) {
                    title = root_object.get_string_member ("title");
                }
                if (root_object.has_member ("url")) {
                    story_uri = root_object.get_string_member ("url");
                }
                if (root_object.has_member ("score")) {
                    score = root_object.get_int_member ("score");
                }
                if (root_object.has_member ("descendants")) {
                    comments = root_object.get_int_member ("descendants");
                }
            }
            comment_uri = "https://news.ycombinator.com/item?id=" + item;
        } catch (Error e) {
            warning ("Error parsing data: %s", e.message);
        }
    }
}