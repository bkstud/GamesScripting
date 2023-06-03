package.path = '/usr/local/share/lua/5.1/lapis/?.lua;' .. package.path

lapis = require "lapis"
import Model from require "lapis.db.model"
import respond_to, json_params from require "lapis.application"

import Model from require "lapis.db.model"

class Items extends Model
  @relations: {
    {"category", belongs_to: "Categories"}
  }

class Categories extends Model
  @relations: {
    {"items", has_many: "items"}
  }

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
      required = {"name", "price", "category_id"}
      for req in *required
        if not @params[req]
          @write status: 404, json: {"missing required parameter: #{req}"}
          return
      it = Items\create {
        name: @params.name,
        price: @params.price,
        picture_url: @params.picture_url
        category_id: @params.category_id
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

  "/category": respond_to {
    GET: =>
      categories = Categories\select!
      if not categories then categories={}
      json: categories
    
    -- handle post single category
    POST: json_params =>
      required = {"name"}
      for req in *required
        if not @params[req]
          @write status: 404, json: {"missing required parameter: #{req}"}
          return
      cat = Categories\create {
        name: @params.name,
        price: @params.price,
        picture_url: @params.picture_url
      }
      json: cat
    
  }

  "/category/:id": respond_to {
    before: =>
      @category = Categories\find @params.id
      @write status: 422, json: {"category '#{@params.id}' not found"} unless @category

    GET: =>
      json: @category
    
    -- Handle update single category
    PUT: json_params =>
      cat = @category
      updatable = {"name"}
      to_update = {k, @params[k] for k in *updatable when @params[k]}
      cat\update(to_update)
      json: cat

    -- handle delete single category
    DELETE: =>
      category = @category
      category\delete!
      json: category
  }
