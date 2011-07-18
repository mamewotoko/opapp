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
ADMIN_ACCOUNT = { twitter="mamewotoko"
                  git="https://mamewotoko@github.com/mamewotoko/opapp.git" }

tracker_div() =
              <div><input type="button" value="add" /></div>

twitter_div() =
              <a href="http://twitter.com/{ADMIN_ACCOUNT.twitter}" class="twitter-follow-button" data-show-count="false" data-lang="ja">Follow @{ADMIN_ACCOUNT.twitter}</a><script src="http://platform.twitter.com/widgets.js" type="text/javascript"></script>

day_counter() =
            now = Date.now()
            //TODO: modify time zone!
            deadline = Date.of_human_readable({ year=2011; month={ august }; day=31; h=23; min=59; s=59; ms=0 ; wday={ monday }} )
            timelimit = Date.between(now, deadline)
            {now=now; timelimit=timelimit}

page() = 
     tm = day_counter()
     //TODO: ceil days!
     (<><div>{Date.to_string(tm.now)}</><div>{Duration.in_days(tm.timelimit)} days</>
     Hello world<hr/><address>
     <img src="resource/IMG_0090.JPG" alt="tora - tiger" />Takashi Masuyama: &lt;mamewotoko _AT_ gmail.com&gt; {twitter_div()}
     <div>Powered by Opa. (<a href="http://opalang.org/resources/doc/index.html">API document</a>)</>
     <div><a href="{ADMIN_ACCOUNT.git}">Fork me on GitHub!</></></address></>)

server =
        Server.one_page_bundle("Welcome to Opapp", [@static_resource_directory("resource")], [], page)
