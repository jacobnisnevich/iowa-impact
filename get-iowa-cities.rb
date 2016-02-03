require 'nokogiri'
require 'open-uri'

wiki = Nokogiri::HTML(open("https://en.wikipedia.org/wiki/List_of_cities_in_Iowa"))
wiki_table = wiki.css(".wikitable")[1]

p "City,County,Population,Size"

wiki_table.css("tr").each_with_index do |row, index|
  if index > 1
    city_row = row.css("th").css("th").text + "," +
               row.css("td")[0].text.split("\n")[0] + "," +
               row.css("td")[1].text.tr(",", "") + "," + 
               row.css("td")[2].text
    p city_row
  end
end
