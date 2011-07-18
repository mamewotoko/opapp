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
import stdlib.system

type message = { author: string
                 text: string
                 loginp: bool }

db /chatlog : intmap(message)
db /chatlog[_]/loginp = { false }

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

send_message(message) =
               do /chatlog[?] <- message
               Network.broadcast(message, room)

broadcast(author, message) =
               do send_message({~author; text=message; loginp={false}})
               Dom.clear_value(#entry)

broadcast_login(author) =
               send_message({~author; text=""; loginp={true}})

@server post_login(author) =
               do Network.add_callback(user_update, room)
               history_list = IntMap.To.val_list(/chatlog)
               do List.iter(user_update, history_list)
               broadcast_login(author)

start_main(author) =
        xhtml_content =
        <>
          <div id=#header><input type="hidden" value={author} id="myname" /><div id=#logo></>
             <input id=#entry onnewline={_ -> broadcast(author,Dom.get_value(#entry))} />
             <div class="button" onclick={_ -> broadcast(author,Dom.get_value(#entry))}>Post</>
          </>
          <div style="border: solid 3px black;" id=#conversation onready={_ -> post_login(author)}></>
          <div id=#footer>...</>
        </>
        Resource.html("Chat!!", xhtml_content)

@server
rest(author) =
       match HttpRequest.get_method() with
       | {some=method} ->
              match method with
              | {post} -> //TODO: login check!!
                     do broadcast(author, HttpRequest.get_body()?"none....")
                     Resource.raw_response("ok!", "text/plain", {success})
              | _ -> Resource.raw_status({bad_request})
              end
       | _ -> Resource.raw_status({method_not_allowed})

@server
start(r: Uri.relative) = match r with
      | {path = ["_rest_" | _] ~query ...} -> rest(List.assoc("author",query)?"ghost")
      | _ -> start_main(Random.string(8)) //TODO: use given author name!!

server = Server.simple_dispatch(start)

