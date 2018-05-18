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
namespace Stories {
    public string[] get_posts (string type) {
        var uri = "https://hacker-news.firebaseio.com/v0/" + type + "stories.json?print=pretty";
        var message = new Soup.Message ("GET", uri);
        var session = new Soup.Session ();
        session.send_message (message);

        var data = (string) message.response_body.flatten ().data;
        data = data.delimit ("[]", ' ');
        data = data._strip ();
        string [] array = data.split (", ");
        return array;

    }
}
