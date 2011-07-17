/*
    Copyright (C) 2011 Takashi Masuyama <mamewotoko@gmail.com>

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as
    published by the Free Software Foundation, either version 3 of the
    License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

type message = { author: string; text: string; loginp: bool; }

room = Network.cloud("room"): Network.network(message);

user_update(x: message) =
               line = match x.loginp
               { true } -> 
                  if Dom.get_value(#myname) == x.author then
                     <div class="user">{x.author} welcome!</div>
                  else
                     <div class="user">{x.author} is now login!</div>
             | { false } ->
               <div class="line">
                    <div class="user">{x.author}:</div>
                    <div class="message">{x.text}</div>
               </div>
               do Dom.transform([#conversation -<- line])
               Dom.scroll_to_bottom(#conversation)

broadcast(author) =
               do Network.broadcast({~author; text=Dom.get_value(#entry); loginp={false}}, room)
               Dom.clear_value(#entry)

broadcast_login(author) =
               Network.broadcast({~author; text=""; loginp={true}}, room)

post_login(author) =
               do Network.add_callback(user_update, room)
               broadcast_login(author)
           
start() =
        author = Random.string(8)
        <div id=#header><input type="hidden" value={author} id="myname" /><div id=#logo></>
             <input id=#entry onnewline={_ -> broadcast(author)} />
             <div class="button" onclick={_ -> broadcast(author)}>Post</>
        </>
        <div style="border: solid 3px black;" id=#conversation onready={_ -> post_login(author)}></>
        <div id=#footer>...</>

server = Server.one_page_server("Chat simple: ", start)
