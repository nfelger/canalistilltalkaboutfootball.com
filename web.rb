require 'sinatra'
require 'open-uri'
require 'nokogiri'

get '/' do
  erb :'index.html'
end

get '/torres_score.json' do
  html = open('http://news.bbc.co.uk/sport1/hi/football/eng_prem/top_scorers/default.stm') { |file| file.read}
  doc = Nokogiri::HTML(html)
  torres_goals = doc.css('table.fulltable tr:contains("Torres")').first.text.split.last
  "{score: #{torres_goals}}"
end
