#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require "nkf"
require "sqlite3"
require "levenshtein"

require_relative "util.rb"

if $0 == __FILE__
  db = SQLite3::Database.new( "ares_article.db", readonly: true )
  naid = nil
  ARGF.gets # skip headers
  ARGF.each do |line|
    # 著者名  論文名  雑誌名  ISSN    出版者名        出版日付        巻      号      ページ  URL     URL(DOI)
    author, title, jtitle, issn, publisher, date, vol, num, page, url, doi, = line.chomp.split( /\t/ )
    #puts line
    if url =~ /\/([^\/]+)\/?$/
      naid = $1
    end
    title_norm = title.normalize_ja
    prefix = title_norm[0, 5]
    postfix = title_norm[-5, 5]
    sql = "select * from article where title like ?"
    params = [ "#{ prefix }%" ]
    if title_norm.size > 5
      sql << " or title like ?"
      params << "%#{ postfix }"
    end
    results = db.execute( "select * from article where title_norm like ? or title_norm like ?", params )
    results.each do |bib_id, ares_title|
      puts [ naid, bib_id, [ title, ares_title ].join(" :: ") ].join("\t") 
    end
    STDERR.puts " Skip: "+line if results.size == 0
  end
end
