require 'sinatra'
require 'open-uri'
require 'nokogiri'

configure do
  require 'redis'
  uri = URI.parse(ENV["REDISTOGO_URL"])
  REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
end

get '/' do
  erb :'index.html', :locals => {:goals => REDIS.get("torres_goals")}
end

get '/refresh_score' do
  html = open('http://news.bbc.co.uk/sport1/hi/football/eng_prem/top_scorers/default.stm') { |file| file.read}
  doc = Nokogiri::HTML(html)
  torres_goals = doc.css('table.fulltable tr:contains("Torres")').first.text.split.last
  REDIS.set("torres_goals", torres_goals)
  redirect '/'
end
