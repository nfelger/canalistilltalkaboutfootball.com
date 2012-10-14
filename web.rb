require 'sinatra'
require 'open-uri'
require 'nokogiri'

configure do
  require 'redis'
  uri = URI.parse(ENV["REDISTOGO_URL"])
  REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
end

get '/' do
  erb :'index.html', :locals => {:goals => REDIS.get("torres_goals").to_i}
end

get '/refresh_score' do
  url = 'http://news.bbc.co.uk/sport1/shared/bsp/hi/football/statistics/players/t/torres_250968.stm'
  html = open(url) { |file| file.read}
  doc = Nokogiri::HTML(html)
  torres_goals = doc.css('table.protables')[3].css('tr')[1].css('.c4').text
  REDIS.set("torres_goals", torres_goals)
  redirect '/'
end
