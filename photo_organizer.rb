#!/usr/bin/env ruby

require "pathname"
require "./lib/os_walk"

class PhotoOrganizer
  def run(argv)

    walker = OSWalk.new argv
    p walker.walk_files.each do |photo|



    end


  end
end

PhotoOrganizer.new.run ARGV[0]