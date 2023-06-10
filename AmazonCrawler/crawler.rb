#! /usr/bin/env ruby

require 'nokogiri'
require 'open-uri'
require "net/https"
require "uri"
require 'sqlite3'
require 'optparse'

options = {number_of_pages: 1}
OptionParser.new do |opts|
  opts.banner = "Usage: crawler.rb [options]"

  opts.on('-k', '--keyword KEYWORD', 'Keyword to search for. (required)') { |v| options[:keyword] = v }
  opts.on('-n', '--number_page NUMBER', 'Number of pages to fetch information from. (optional default: 1)') { |v| options[:number_of_pages] = Integer(v) }

end.parse!

required_options = [:keyword,]
missing_options = required_options - options.keys
unless missing_options.empty?
  fail "Missing required options: #{missing_options}"
end



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

db = SQLite3::Database.open 'amazon_items.sqlite'

db.execute "CREATE TABLE IF NOT EXISTS results(
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  url TEXT NOT NULL,
  price TEXT NOT NULL,
  page_url TEXT NOT NULL,
  description TEXT)"

# search keyword
keyword = options[:keyword]
search = keyword.gsub ' ', '+'

search_url = "https://www.amazon.com/s?k=#{search}"

# number of pages to fetch from
number_of_pages = options[:number_of_pages]


puts "Will scrape #{number_of_pages} page from url: '#{search_url}'"

fetched_num = 0

(1..number_of_pages).each do |page_num|

  search_url += "&page=#{page_num}"

  begin
    call = URI.open(search_url, **HEADERS)
  rescue OpenURI::HTTPError => e
    STDERR.puts "Failed to fetch url: '#{search_url}'.\nException: '#{e}'"
    next
  end 

  doc = Nokogiri::HTML(call)

  it = 0
  doc.css('div[data-component-type="s-search-result"]').each do |item|
    link = item.css('h2 a.a-link-normal.a-text-normal')
    title = link.text
    url = BASE_PAGE + link.attribute('href').value
    price = item.css('span.a-price:nth-of-type(1) span.a-offscreen')
    price = price.text

    description = ""
    begin
      item_call = URI.open(url, **HEADERS)
      item_doc = Nokogiri::HTML(item_call)
      description = item_doc.css('#productDescription')
    rescue OpenURI::HTTPError => e
      STDERR.puts "Failed to fetch url: '#{url}'. Error status: '#{item_call.status.join ' '}'"
    end

    if description == ""
      STDERR.puts "Failed to find desc for '#{link}'"
    else
      description = description.text.lstrip
    end
    
    puts "Fetching page #{page_num} item number: #{it} into db..." 

    db.execute "INSERT INTO results (title, url, price, page_url, description) " \
      "VALUES (?, ?, ?, ?, ?)", \
      title, url, price, search_url, description

    it += 1
  end
  fetched_num += it
end

db.close if db

puts "Success! Fetched #{fetched_num} of rows into database."

