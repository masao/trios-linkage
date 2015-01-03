#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require "nkf"
require "sqlite3"
require "levenshtein"

require_relative "util.rb"

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
  db = SQLite3::Database.new( "ares_article.db", readonly: true )
  ARGF.gets # skip headers
  ARGF.each do |line|
    # 著者名  論文名  雑誌名  ISSN    出版者名        出版日付        巻      号      ページ  URL     URL(DOI)
    author, title, jtitle, issn, publisher, date, vol, num, page, url, doi, = line.chomp.split( /\t/ )
    #puts line
    naid = $1 if url =~ /\/([^\/]+)\/?$/
    title_norm = title.normalize_ja
    t_trigrams = title_norm.trigrams.uniq
    subquery = t_trigrams.map{|e| "trigram = ?" }.join( " or " )
    results = db.execute( "select bid from trigrams where #{ subquery }", *t_trigrams )
    #puts "	searching #{ bids.size } docs..."
    h = Hash.new( 0 )
    results.each do |bid,|
      h[ bid ] += 1
    end
    h.each do |bid, val|
      next if val < 2
      bib_id, ares_title, ares_title_norm, = db.get_first_row( "select * from article where bid = ?", bid )
      similarity = val.to_f / [ ares_title_norm.normalize_ja.trigrams.size, t_trigrams.size ].min
      puts [ naid, bib_id, [ title, ares_title ].join(" :: "), similarity ].join("\t") if similarity > 0.3
      #p [ bid, val, similarity ]
    end
  end
end
