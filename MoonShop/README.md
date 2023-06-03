# Simple shop api lua - lapis - moon

## Features
- CRUD endpoints for categories and products 
- Models created via lapis.db.model - and saved in local sqlite3 database
- Written in MoonScript (4.0)

## Running
Install dependencies manually or build docker image.
In app directory run:
```
moonc .
lapis migrate
lapis serve
```

## Demo
![](demo.gif)
