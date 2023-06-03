package.path = '/usr/local/share/lua/5.1/lapis/?.lua;' .. package.path

lapis = require "lapis"
import Model from require "lapis.db.model"
import open from require "lapis.db.sqlite"
import create_table, types from require "lapis.db.schema"
import respond_to, json_params from require "lapis.application"


class Items extends Model


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
      required = {"name", "price"}
      for req in *required
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
    PUT: json_params =>
      it = @item
      updatable = {"name", "price", "picture_url"}
      to_update = {k, @params[k] for k in *updatable when @params[k]}
      it\update(to_update)
      json: it

    -- handle delete single item
    DELETE: =>
      item = @item
      item\delete!
      json: item
  }
