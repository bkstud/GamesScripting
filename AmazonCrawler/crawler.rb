#! /usr/bin/env ruby

require 'nokogiri'
require 'open-uri'
require "net/https"
require "uri"

HEADERS = {
    'dnt' => '1',
    'upgrade-insecure-requests' => '1',
    'user-agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.61 Safari/537.36',
    'accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
    'sec-fetch-site' => 'same-origin',
    'sec-fetch-mode' => 'navigate',
    'sec-fetch-user' => '?1',
    'sec-fetch-dest' => 'document',
    'referer' => 'https://www.amazon.com/',
    'accept-language' => 'en-GB,en-US;q=0.9,en;q=0.8',
}

BASE_PAGE = "https://amazon.com"

# search keyword
keyword = "graphics card"
# TODO: base on keyword
search_url = 'https://www.amazon.com/s?k=graphics+card'
# number of pages to fetch from
number_of_pages = 1


puts search_url
# open uri
call = URI.open(search_url, **HEADERS)
puts call.status
#File.open("out.html", 'w') { |file| file.write(call.read()) }
# Parse HTML document
doc = Nokogiri::HTML(call)

i = 0

doc.css('div[data-component-type="s-search-result"]').each do |item|
  link = item.css('h2 a.a-link-normal.a-text-normal')
  title = link.text
  url = BASE_PAGE + link.attribute('href').value
  price = item.css('span.a-price:nth-of-type(1) span.a-offscreen')
  price = price.text

  item_call = URI.open(url, **HEADERS)
  item_doc = Nokogiri::HTML(item_call)
  description = item_doc.css('#productDescription')
  if ! description
    puts "failed to find desc"
  else
    description = description.text.lstrip
  end
  
  puts "number: " + String(i)

  puts title
  puts price
  puts url
  puts description

  i += 1
end
