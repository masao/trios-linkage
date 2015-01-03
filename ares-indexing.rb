#!/usr/bin/env ruby

require "fileutils"
require "sqlite3"

require_relative "util.rb"

if $0 == __FILE__
  FileUtils.rm_f( "ares_article.db" )
  db = SQLite3::Database.new( "ares_article.db" )
  db.execute_batch( <<EOF )
	create table article (
	  bid integer unique,
	  title string
	);
	create table trigrams (
	  bid integer,
	  trigram string
	);
EOF

  db.transaction do |db|
    ARGF.each do |line|
      bid, title, jtitle, = line.chomp.split( /\t/ )

      db.execute( "insert into article ( bid, title ) VALUES ( ?, ? )",
                  [ bid, title ] )
      trigrams = title.trigrams
      p [ bid, title, trigrams ]
      trigrams.each do |t|
        db.execute( "insert into trigrams ( bid, trigram ) VALUES ( ?, ? )",
                    [ bid, t ] )
      end
    end
    db.execute( "create index t on trigrams( trigram )" )
  end
end
