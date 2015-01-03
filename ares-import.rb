#!/usr/bin/env ruby

# COPY ares_ab_cache (ivid, vid, deleted, status, aid, rid, author_seq, researcher_seq, achievement_class, achievement_subclass, btype, ibid, bid, peer_review, cid, trios_pub, read_pub, achieve_seq, achieve_date, note, latest_f, created, updated, sid, rsid, update_uid, confirm_uid, document_title, journal_title, handle_id, doi, volume, issue, start_page, end_page, language, main_aid, bib_created, bib_updated, host_city, host_country, starting_day, ending_day, authors, publish_date, hold, error_count, repository_requested, check_requested, sherpa_romeo, scpj

ab_cache = false
h = {}

ARGF.each do |line|
  if !ab_cache
    ab_cache = true if line =~ /^COPY ares_ab_cache/
    next
  end
  ivid, vid, deleted, status, aid, rid, author_seq, researcher_seq, achievement_class, achievement_subclass, btype, ibid, bid, peer_review, cid, trios_pub, read_pub, achieve_seq, achieve_date, note, latest_f, created, updated, sid, rsid, update_uid, confirm_uid, document_title, journal_title, handle_id, doi, volume, issue, start_page, end_page, language, main_aid, bib_created, bib_updated, host_city, host_country, starting_day, ending_day, authors, publish_date, hold, error_count, repository_requested, check_requested, sherpa_romeo, scpj, = line.chomp.split( /\t/ )
  next if document_title == '\N' or document_title.to_s.empty?
  if btype == "1" and deleted == "0"
    if not h[ bid ]
      puts [ bid, document_title, journal_title, authors ].join( "\t" )
      h[ bid ] = true
    end
    #if h[ document_title ]
    #  p [ ivid, vid, deleted, status, aid, rid, author_seq, researcher_seq, achievement_class, achievement_subclass, btype, ibid, bid, peer_review, cid, trios_pub, read_pub, achieve_seq, achieve_date, note, latest_f, created, updated, sid, rsid, update_uid, confirm_uid, document_title, journal_title, handle_id, doi, volume, issue, start_page, end_page, language, main_aid, bib_created, bib_updated, host_city, host_country, starting_day, ending_day, authors, publish_date, hold, error_count, repository_requested, check_requested, sherpa_romeo, scpj ]
    #  p h[ document_title ]
    #  exit
    #else
    #  h[ document_title ] = [ ivid, vid, deleted, status, aid, rid, author_seq, researcher_seq, achievement_class, achievement_subclass, btype, ibid, bid, peer_review, cid, trios_pub, read_pub, achieve_seq, achieve_date, note, latest_f, created, updated, sid, rsid, update_uid, confirm_uid, document_title, journal_title, handle_id, doi, volume, issue, start_page, end_page, language, main_aid, bib_created, bib_updated, host_city, host_country, starting_day, ending_day, authors, publish_date, hold, error_count, repository_requested, check_requested, sherpa_romeo, scpj ]
    #end
  else
  end
end
