module View {
  function page_template() {
    <div>
    <audio id=audio controls></audio>
    <ul id=container class=list-group>
    </ul>
      
    <button onclick={function(_) { episode_update(1) }} >Push</button>
    </div>
  }

  function episode_template(episode info){
//    <div class="episode_icon"></div><div><div class="episode_title">{info.title}</div><div class="episode_controller">{info.link_url}</div></div> 
    <li class="list-group-item episode" data-source={info.link_url}>{info.title} {info.pubdate}</li>
  }

  function default_page(){
    Resource.page("Episode", page_template())
  }

  function episode_update(_) {
   info = { title: "This Morning With Gordon Deal Podcast",
           link_url: "http://feedproxy.google.com/~r/thismorningamericasfirstnews/~3/QNQFYp72UnY/programhighlights",
	   pubdate: "Mon, 23 May 2016 12:00:00 PDT",
	   icon_url: ""
    }    
    line = episode_template(info)
      Log.info("episode_update", "episode_update")
//      title = "This Morning With Gordon Deal Podcast"
//      link_url = "http://feedproxy.google.com/~r/thismorningamericasfirstnews/~3/QNQFYp72UnY/programhighlights"
    #container += line
    //<div class="episode_icon"></div><div><div class="episode_title">{title}</div><div class="episode_controller">{link_url}</div></div>

  }
}
