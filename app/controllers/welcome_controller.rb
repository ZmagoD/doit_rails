class WelcomeController < ApplicationController

  def index
    # the URL used originally return returned too much data. I changed it for the one provided by Sam 
    #response = HTTParty.get("https://api.do-it.org/v1/opportunities\?lat\=51.567526\&lng\=-0.182308\&miles\=2 ")
    host = "https://api.do-it.org"
    href = "/v1/opportunities\?lat\=51.567526\&lng\=-0.182308\&miles\=2 "
    js_items = Array.new         # to aggreate the items of all requests -- only the 3 fields used for the map are kept
    @locations_count = Hash.new  # to count the number of items by location
    # Loop until the is no "next.href" link returned in the request
    collect_all_items(host, href, js_items, @locations_count)
    gon.orgs = js_items
    @total_markers_count = js_items.length
    # Collect statistics from the response
    response = HTTParty.get(host+href)
    @items_per_page = JSON.parse(response.body)["meta"]["items_per_page"]
    @total_items = JSON.parse(response.body)["meta"]["total_items"]
    @total_pages = JSON.parse(response.body)["meta"]["total_pages"]
  end

  def collect_all_items (host, href, js_items, locations_count)
    while href do
      url = host + href
      response = HTTParty.get(url)
      respItems = JSON.parse(response.body)["data"]["items"]
      count_locations(respItems, js_items, @locations_count)
      nextHash = JSON.parse(response.body)["links"]["next"]
      href = nextHash ? nextHash["href"] : nil 
    end
  end

  def count_locations(respItems, js_items, locations_count)
    respItems.each do |item|
      js_items.push( { "lat" => item["lat"], "lng" => item["lng"], "title" => item["title"] } )
      location_key = "lat #{format("%.6f", item["lat"])}, lng #{format("%.6f", item["lng"])}"
      locations_count[location_key] = (@locations_count.has_key? location_key) ?  @locations_count[location_key]+1 : 1
    end
  end
end
