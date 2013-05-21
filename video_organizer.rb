#!/usr/bin/env ruby

require "pathname"
require "fileutils"
require "digest"
require "exifr"
require "./lib/os_walk"
require "./lib/video"

class VideoOrganizer

  def initialize(source_dir, destination_dir)
    source_dir << "#{File::SEPARATOR}" if source_dir[-1] != "#{File::SEPARATOR}"
    destination_dir << "#{File::SEPARATOR}" if destination_dir[-1] != "#{File::SEPARATOR}"
    @source_dir = source_dir
    @destination_dir = destination_dir
    @metadata_base_folder = "#{destination_dir}.video_organizer_metadata#{
    File::SEPARATOR}"
    @video_extensions = ['.mp4', '.mov', '.3gp']
  end

  def run
    OSWalk.new(@source_dir).walk_files(@video_extensions).each do |video_path|
      move_video_to_destination_dir Video.new(video_path)
    end
  end

  private

  def metadata_folder(video_md5sum)
    "#{video_md5sum[0..1]}#{File::SEPARATOR}#{video_md5sum[2..3]}#{File::SEPARATOR}#{video_md5sum[4..5]}#{File::SEPARATOR}"
  end

  def video_duplicated?(video)
    video_md5sum = video.md5sum
    check_path = "#{@metadata_base_folder}#{metadata_folder(video_md5sum)}"
    FileUtils.mkdir_p check_path

    check_file = "#{check_path}#{video_md5sum}"
    ret = true

    unless File.exists? check_file
      FileUtils.touch check_file
      ret = false
    end

    ret
  end

  def move_video_to_destination_dir(video)
    dest_full_path = "#{@destination_dir}#{
      video.creation_datetime.year}#{File::SEPARATOR}#{
      video.creation_datetime.month}#{File::SEPARATOR}"

    if video_duplicated? video
      dest_full_path = "#{@destination_dir}duplicated#{
      File::SEPARATOR}#{video.creation_datetime.year}#{File::SEPARATOR}#{
      video.creation_datetime.month}#{File::SEPARATOR}"
    end

    FileUtils.mkdir_p dest_full_path

    p "#{video.full_path} -> #{dest_full_path}#{
      video.creation_datetime.strftime("%Y%m%dT%H%M%S%z")}#{video.ext}"

    FileUtils.mv video.full_path, "#{dest_full_path}#{
      video.creation_datetime.strftime("%Y%m%dT%H%M%S%z")}#{video.ext}"
  end
end

VideoOrganizer.new(ARGV[0].dup, ARGV[1].dup).run