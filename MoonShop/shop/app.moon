package.path = '/usr/local/share/lua/5.1/lapis/?.lua;' .. package.path

lapis = require "lapis"
import Model from require "lapis.db.model"
import open from require "lapis.db.sqlite"
import create_table, types from require "lapis.db.schema"
import respond_to from require "lapis.application"


create_table "items", {
  {"id", "INTEGER"}
  {"name", "TEXT"}
  {"price", "INTEGER"}
  {"picture_url", "TEXT"}
  
  "PRIMARY KEY(id)"
}
class Items extends Model

-- add test data
Items\create {
  name: "water"
  price: 10
  picture_url: "https://media.istockphoto.com/id/105951730/pl/zdj%C4%99cie/butelka-wody-gazowanej-z-pust%C4%85-etykiet%C4%99.webp?s=2048x2048&w=is&k=20&c=19-Wdy3dnNIU7N61PrqaO_fO_rmH4Mf4AeegkKYKF7s="
}
Items\create {
  name: "item"
  price: 2
  picture_url: "url"
}


class extends lapis.Application
  "/demo": =>
    "Welcome to Lapis #{require "lapis.version"}!"
  
  "/item": respond_to {
    GET: =>
      items = Items\select!
      json: items
    
    -- handle post single item
    POST: =>
      print("POST /item")
      json: {"POST /item/"}
    
    -- handle delete single item
    DELETE: =>
      print("DELETE /item")
      json: {"DELETE /item/"}
  }

  "/item/:id": respond_to {
    GET: => 
      id = @params.id
      item = Items\find id
      json: item
    
    -- Handle update single item
    PATCH: =>
      id = @params.id
      print("PATCH /item/#{id}")
      json: {"PATCH /item/#{id}"}
  }