

module Controller {

// URL dispatcher of your application; add URL handling as needed
  dispatcher = {
    parser {
      case (.*) : View.default_page()
    }
  }

}

resources = @static_resource_directory("resources")

podcast_list = [
        "http://www.nhk.or.jp/rj/podcast/rss/english.xml",
        "http://downloads.bbc.co.uk/podcasts/worldservice/tae/rss.xml",
        "http://feeds.wsjonline.com/wsj/podcast_wall_street_journal_this_morning?format=xml",
        "http://learningenglish.voanews.com/podcast/"
	]

url = Uri.of_string("http://www.nhk.or.jp/rj/podcast/rss/english.xml")
match (url) {
  case ~{some}:
    WebClient.Get.try_get_async(some, function(res) {
      match(res) {
        case ~{success}: Log.info("success", success.content)
        default: Log.info("failed", "failed")
      }
    })
  default:
   Log.info("parse failed", "parse failed")
}

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
