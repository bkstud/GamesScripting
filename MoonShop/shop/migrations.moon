-- migrations module - seems not be working for in memory sqlite
-- in case of calling lapis migrate
import create_table, types from require "lapis.db.schema"
create_table "items", {
  {"id", "INTEGER"}
  {"name", "TEXT"}
  {"price", "INTEGER"}
  {"picture_url", "TEXT"}
  
  "PRIMARY KEY(id)"
}
