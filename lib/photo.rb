class Photo

  def initialize(pathname)
    @pathname = pathname
  end

  def ext
    @pathname.extname.downcase
  end

  def name
    @pathname.basename
  end

  def full_path
    @pathname.to_s
  end

  def creation_datetime
    exif_file = EXIFR::JPEG.new @pathname.to_s
    if exif_file.exif? and not exif_file.date_time.to_s.empty?
      exif_file.date_time
    else
      @pathname.mtime
    end
  end

end