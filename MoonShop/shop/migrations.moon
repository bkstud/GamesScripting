import create_table, types from require "lapis.db.schema"
db = require "lapis.db"
schema = require "lapis.db.schema"
{
  [1685791782]: =>
    create_table "items", {
      {"id", "INTEGER"}
      {"name", "TEXT"}
      {"price", "INTEGER"}
      {"picture_url", "TEXT"}
      {"category_id", "INTEGER"}
      
      "PRIMARY KEY(id)"
    }

    create_table "categories", {
      {"id", "INTEGER"}
      {"name", "TEXT"}
      
      "PRIMARY KEY(id)"
    }
}
