package.path = '/usr/local/share/lua/5.1/lapis/?.lua;' .. package.path

lapis = require "lapis"
import Model from require "lapis.db.model"
import open from require "lapis.db.sqlite"
import create_table, types from require "lapis.db.schema"
import respond_to, json_params from require "lapis.application"


class Items extends Model

init = ->
  -- add test data
  Items\create {
    name: "water"
    price: 10
    picture_url: "https://media.istockphoto.com/id/105951730/pl/zdj%c4%99cie/butelka-wody-gazowanej-z-pust%c4%85-etykiet%c4%99.webp?s=2048x2048&w=is&k=20&c=19-wdy3dnniu7n61prqao_fo_rmh4mf4aeegkkykf7s="
  }
  Items\create {
    name: "item"
    price: 2
    picture_url: "url"
  }

--init()

class App extends lapis.Application

  "/demo": =>
    "Welcome to Lapis #{require "lapis.version"}!"
  
  "/item": respond_to {
    GET: =>
      items = Items\select!
      if not item then item={}
      json: items
    
    -- handle post single item
    POST: json_params =>
      print("POST /item")
      required = {"name", "price"}
      for req in *required
        print("param:=", @params[req])
        if not @params[req]
          @write status: 404, json: {"missing required parameter: #{req}"}
          return
      it = Items\create {
        name: @params.name,
        price: @params.price,
        picture_url: @params.picture_url
      }
      json: it
    
  }

  "/item/:id": respond_to {
    before: =>
      @item = Items\find @params.id
      @write status: 422, json: {"item '#{@params.id}' not found"} unless @item

    GET: =>
      json: @item
    
    -- Handle update single item
    PUT: =>
      id = @params.id
      print("PUT /item/#{id}")
      json: {"PUT /item/#{id}", @item}

    -- handle delete single item
    DELETE: =>
      item = @item
      item\delete!
      json: item
  }
