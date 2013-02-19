#!/usr/bin/env ruby

require "pathname"
require "fileutils"
require "digest"
require "exifr"
require "date"
require "./lib/os_walk"
require "./lib/photo"

class PhotoOrganizer

  def initialize(source_dir, destination_dir)
    source_dir << "#{File::SEPARATOR}" if source_dir[-1] != "#{File::SEPARATOR}"
    destination_dir << "#{File::SEPARATOR}" if destination_dir[-1] != "#{File::SEPARATOR}"
    @source_dir = source_dir
    @destination_dir = destination_dir
    @metadata_base_folder = "#{destination_dir}.photo_organizer_metadata#{
File::SEPARATOR}"
    @photo_extensions = ['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.psd', '.cdr']
  end

  def run
    OSWalk.new(@source_dir).walk_files(@photo_extensions).each do |photo_path|
      copy_photo_to_destination_dir Photo.new(photo_path)
    end
  end

  private

  def metadata_folder(photo_md5sum)
    "#{photo_md5sum[0]}#{File::SEPARATOR}"
  end

  def photo_duplicated?(photo)
    photo_md5sum = Digest::MD5.file(photo.full_path).hexdigest
    check_path = "#{@metadata_base_folder}#{metadata_folder(photo_md5sum)}"
    FileUtils.mkdir_p check_path

    check_file = "#{check_path}#{photo_md5sum}"
    ret = true

    unless File.exists? check_file
      FileUtils.touch check_file
      ret = false
    end

    ret
  end

  def copy_photo_to_destination_dir(photo)
    dest_full_path = "#{@destination_dir}#{
      photo.creation_datetime.year}#{File::SEPARATOR}#{photo.creation_datetime
      .month}#{File::SEPARATOR}"

    if photo_duplicated? photo
      dest_full_path = "#{@destination_dir}duplicated#{
        File::SEPARATOR}#{photo.creation_datetime.year}#{File::SEPARATOR}#{
        photo.creation_datetime.month}#{File::SEPARATOR}"
    end

    FileUtils.mkdir_p dest_full_path
    FileUtils.mv photo.full_path, "#{dest_full_path}#{
      photo.creation_datetime.strftime("%Y%m%dT%H%M")}#{photo.ext}"
  end
end

PhotoOrganizer.new(ARGV[0].dup, ARGV[1].dup).run
