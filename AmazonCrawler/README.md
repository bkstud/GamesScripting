# Amazon.com scraper

## Features
- Fetches base product information and product page details, saves product url.
- Searching is done based on user given keywords.
- Stores results in local SQLite3 database. (5.0 requirements done)

## Running
Install dependencies manually or build docker image.
### Usage:
```
./crawler.rb -h
Usage: crawler.rb [options]
    -k, --keyword KEYWORD            Keyword to search for. (required)
    -n, --number_page NUMBER         Number of pages to fetch information from. (optional default: 1)

```
## Demo:
![](demo.gif)
