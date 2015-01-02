#!/usr/bin/env ruby

require "nkf"
require "sqlite3"
require "levenshtein"

require_relative "ares-indexing.rb"

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

if $0 == __FILE__
  db = SQLite3::Database.new( "ares_article.db" )
  ARGF.gets # skip headers
  ARGF.each do |line|
    # 著者名  論文名  雑誌名  ISSN    出版者名        出版日付        巻      号      ページ  URL     URL(DOI)
    author, title, jtitle, issn, publisher, date, vol, num, page, url, doi, = line.chomp.split( /\t/ )
    puts line
    t_trigrams = title.trigrams
    subquery = t_trigrams.map{|e| "trigram = ?" }.join( " or " )
    trigrams = db.execute( "select * from inv_trigrams where #{ subquery } order by freq", *t_trigrams )
    #p trigrams
    t_trigrams = []
    sum = 0
    trigrams.each do |trigram, freq|
      sum += freq
      break if sum > 1000
      t_trigrams << trigram
    end
    subquery = t_trigrams.map{|e| "trigram = ?" }.join( " or " )
    bids = db.execute( "select distinct bid from trigrams where #{ subquery }", *t_trigrams )
    puts "	searching #{ bids.size } docs..."
    bids.each do |bid|
      bib_id, ares_title, = db.get_first_row( "select * from article where bid = ?", bid )
      distance = distance( title, ares_title )
      puts [ bid, [ title, ares_title ].join(" :: "), distance ].join(", ") if distance < 0.4
    end
  end
end
