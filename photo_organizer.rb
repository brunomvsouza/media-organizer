#!/usr/bin/env ruby

require "pathname"
require "fileutils"
require "digest"
require "exifr"
require "./lib/os_walk"
require "./lib/photo"

class PhotoOrganizer

  def initialize(source_dir, destination_dir, tmp_file_folder="/tmp/fileutils")
    @source_dir = source_dir
    @destination_dir = destination_dir
    @tmp_file_folder = tmp_file_folder
    @photo_extensions = ['.jpg', '.jpeg']
  end

  def run
    at_exit {
      remove_tmp_file_folder @tmp_file_folder
    }

    create_tmp_file_folder @tmp_file_folder

    OSWalk.new(@source_dir).walk_files(@photo_extensions).each do |photo_path|
      copy_photo_to_destination_dir Photo.new(photo_path)
    end

    remove_tmp_file_folder @tmp_file_folder

  end

  private
  def create_tmp_file_folder(path)
    FileUtils.mkdir_p path
  end

  def remove_tmp_file_folder(path)
    FileUtils.rm_rf path
  end

  def photo_duplicated?(photo)
    check_file = "#{@tmp_file_folder}#{File::SEPARATOR}#{
      Digest::MD5.file(photo.full_path).hexdigest}"
    ret = true

    unless File.exists? check_file
      FileUtils.touch check_file
      ret = false
    end

    ret
  end

  def copy_photo_to_destination_dir(photo)
    dest_full_path = "#{@destination_dir}#{File::SEPARATOR}#{File::SEPARATOR}#{
      photo.creation_datetime.year}#{File::SEPARATOR}#{photo.creation_datetime
      .month}"

    if photo_duplicated? photo
      dest_full_path = "#{@destination_dir}#{File::SEPARATOR}duplicated#{
        File::SEPARATOR}#{photo.creation_datetime.year}#{File::SEPARATOR}#{
        photo.creation_datetime.month}"
    end

    FileUtils.mkdir_p dest_full_path
    FileUtils.mv photo.full_path, "#{dest_full_path}#{File::SEPARATOR}#{
      photo.creation_datetime.strftime("%Y%m%dT%H%M")}.jpg"
  end
end

PhotoOrganizer.new(ARGV[0], ARGV[1]).run