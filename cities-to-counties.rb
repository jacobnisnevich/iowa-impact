require 'csv'

CSV::Converters[:blank_to_nil] = lambda do |field|
  field && field.empty? ? nil : field
end

iowa_city_views_csv = CSV.new(File.read('iowa-city-views.csv'), :headers => true, :converters => [:all, :blank_to_nil])
iowa_city_views = iowa_city_views_csv.to_a.map {|row| row.to_hash }

iowa_cities_csv = CSV.new(File.read('iowa-cities.csv'), :headers => true, :converters => [:all, :blank_to_nil])
iowa_cities = iowa_cities_csv.to_a.map {|row| row.to_hash }

county_views = {}

iowa_city_views.each do |city_views|
  city = iowa_cities.find { |x| x['City'] == city_views['City']}
  if county_views[city['County']].nil?
    county_views[city['County']] = {
      'Sessions' => city_views['Sessions']
    }
  else
    county_views[city['County']]['Sessions'] += city_views['Sessions']
  end
end

print "County,Sessions\n"

county_views.each do |county, sessions|
  print "#{county},#{sessions['Sessions']}\n"
end