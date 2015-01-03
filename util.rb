#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require "nkf"

class String
  def normalize_ja
    NKF.nkf( "-wZ1", self ).gsub( /[\!-\/\[-`:-@「」―\s]/, "" )
  end

  def trigrams
    results = []
    ( self.size - 1 ).times do |i|
      results << self[i, 3]
    end
    results
  end
end
