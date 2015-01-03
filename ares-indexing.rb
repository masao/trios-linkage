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
          title string,
          title_norm string
	);
	create table trigrams (
	  bid integer not null,
	  trigram string not null
	);
EOF

  db.transaction do |db|
    ARGF.each do |line|
      bid, title, jtitle, = line.chomp.split( /\t/ )
      title_norm = title.normalize_ja

      db.execute( "insert into article ( bid, title, title_norm ) VALUES ( ?, ?, ? )",
                  [ bid, title, title_norm ] )
      trigrams = title_norm.trigrams.uniq
      p [ bid, title, trigrams ]
      trigrams.each do |t|
        db.execute( "insert into trigrams ( bid, trigram ) VALUES ( ?, ? )",
                    [ bid, t ] )
      end
    end
    db.execute( "create index t on trigrams( trigram )" )
  end
end
