#!/usr/bin/env ruby

require "levenshtein"
require "nkf"

class String
  def normalize_ja
    NKF.nkf( "-wZ1", self ).gsub( /[\!-\/\[-`:-@「」―\s]/, "" )
  end
end

def distance( str1, str2 )
  str1 = str1.normalize_ja
  str2 = str2.normalize_ja
  #p str1, str2
  size_common = [ str1.size, str2.size ].min
  size_diff = ( str1.size - str2.size ).abs
  dist = Levenshtein.distance( str1, str2 )
  result = ( dist - size_diff ) / size_common.to_f
  #puts "diff: #{size_diff}, common: #{size_common}"
  #puts "dist: #{dist}, normalized dist: #{dist-size_diff}/#{size_common} = #{result}"
  result
end

ARGF.gets
ARGF.each do |line|
  # 著者名  論文名  雑誌名  ISSN    出版者名        出版日付        巻      号      ページ  URL     URL(DOI)
  author, title, jtitle, issn, publisher, date, vol, num, page, url, doi, = line.chomp.split( /\t/ )
  puts line
  open( "ares_article.txt" ).each do |line2|
    bid, title2, jtitle, authors, = line2.chomp.split( /\t/ )
    puts [ bid, title, title2 ].join(" :: " ) if distance( title, title2 ) < 0.3
  end
end
