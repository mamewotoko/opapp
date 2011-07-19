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

start = _ ->
     str = match Uri.of_string("http://www002.upp.so-net.ne.jp/mamewo/") with
     | {none=_} -> "URI error"
     | {some=uri}->
          match WebClient.Get.try_get(uri) with
          |{failure=_} -> "error"
          |{~success} -> match WebClient.Result.get_class(success) with
                      | {success} -> success.content
                      | _ -> "Error {success.code}"
                      end
           end
     Resource.raw_response(str, "text/html", {success})

server = Server.simple_dispatch(start)

