#! /usr/bin/env ruby

require 'nokogiri'
require 'open-uri'
require "net/https"
require "uri"

BASE_PAGE = "https://amazon.com"
# https://www.amazon.com/s?k=graphics+card
keyword = "graphics card"
#url = "https://www.amazon.com/s?i=specialty-aps&bbn=16225009011&rh=n%3A%2116225009011%2Cn%3A541966&ref=nav_em__nav_desktop_sa_intl_computers_and_accessories_0_2_5_6"
url = 'https://www.amazon.com/s?k=graphics+card'

headers = {
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

puts url
# open uri
call = URI.open(url, **headers)
puts call.status
#File.open("out.html", 'w') { |file| file.write(call.read()) }
# Parse HTML document
doc = Nokogiri::HTML(call)

i = 0

doc.css('div[data-component-type="s-search-result"]').each do |item|
  link = item.css('h2 a.a-link-normal.a-text-normal')
  title = link.text
  url = link.attribute('href').value
  puts i
  puts title
  puts url
  i += 1
end
