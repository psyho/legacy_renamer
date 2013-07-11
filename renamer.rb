#!/usr/bin/env ruby

require 'json'
require 'open-uri'

unless ARGV.size == 3
  puts 'Usage: renamer.rb title input output'
  exit 1
end

episodes = JSON.parse(open("http://mymovieapi.com/?title=#{ARGV[0]}&type=json&episode=1&limit=1&lang=en-US").read)[0]["episodes"]

Dir.entries(ARGV[1]).select { |f| File.file?(File.expand_path(f, ARGV[1])) }.each do |f|
  f.match(/s(\d+)e(\d+)/) do |m|
    episode = episodes.find do |e|
      e['season'] == m[1].to_i && e['episode'] == m[2].to_i
    end

    number = "%02dx%02d" % [episode['season'], episode['episode']]
    name = "#{ARGV[0]} - #{number} - #{episode['title']}.avi"
    FileUtils.mkdir_p(ARGV[2])
    FileUtils.cp(File.expand_path(f, ARGV[1]), File.expand_path(name, ARGV[2]))
  end
end
