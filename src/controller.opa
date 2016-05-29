import stdlib.web.client

type episode = {
  string title, 
  string link_url,
  string pubdate,
  string icon_url
}

module Controller {
  // URL dispatcher of your application; add URL handling as needed
  dispatcher = {
    parser {
      case (.*) : View.default_page()
    }
  }
}

resources = @static_resource_directory("resources")

podcast_list = [ "http://www.nhk.or.jp/rj/podcast/rss/english.xml",
                 "http://downloads.bbc.co.uk/podcasts/worldservice/tae/rss.xml",
                 "http://feeds.wsjonline.com/wsj/podcast_wall_street_journal_this_morning?format=xml",
                 "http://learningenglish.voanews.com/podcast/" ]

// podcast_parser =
//   recursive episode = xml_parser {
//     case !_ : { title: "", link_url: "", pubdate: "", icon_url: ""}
//     case <title>title={Xml.Rule.string}</title>: { episode with ~title }
//     case <pubdate>pubdate={Xml.Rule.string}</pubdate>: { episode with ~pubdate }
//     case <link>link={Xml.Rule.string}</link>: { episode with ~link }
//   }
//   recursive items = xml_parser {
//     case !_ : []  
//     case <item>episode={episode}</item> t={items}: [episode|t]
//     case (| !<item/> _ : void)* r={items}: r
//   }
//   xml_parser {
//     case <rss><channel>items={items}</channel></rss>:
//         l = List.length(items)
//         Log.info("item", "size: {l}")
//   }

// function fetch_podcast(podcast_url){
//   url = Uri.of_string(podcast_url)
//   match (url) {
//     case ~{some}:
//       WebClient.Get.try_get_async(some, function(res) {
//         match(res) {
//           case ~{success}:
// //            parsed_xml = Xmlns.try_parse_document(success.content)
// //            episode_list = Option.switch(function(parsed_xml){Xml_parser.try_parse(podcast_parser, parsed_xml.element)}, none, parsed_xml)
//             episode_list = %%podcast_parser.parse_podcast%%(success.content)
//             l = List.length(episode_list)
//             Log.info("item", "size: {l}")
//           default: Log.info("failed", "failed")
//         }
//       })
//     default:
//       Log.info("parse failed", "parse failed")
//   }
// }

database episodes {
   episode /episode[{link_url}]
}

//mongo
@async function fetch_podcast(){
   list(episode) all_episode = DbMongoSet.to_list(/episodes/episode[])
   List.iter(function(x){Log.info("episode", x.title)}, all_episode)
}

//List.iter(fetch_podcast, podcast_list)
fetch_podcast()

Server.start(Server.http, [
  { register:
    [ { doctype: { html5 } },
      { js: [ "/resources/js/jquery-2.2.3.min.js", "resources/js/player.js" ] },
      //{ css: [ "/resources/css/style.css"] }
      { css: [ ] }
    ]
  },
  { ~resources },
  { custom: Controller.dispatcher }
])
