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
    p @pathname.to_s

    unless ['.jpg', 'jpeg'].include? ext
      return @pathname.mtime
    end

    exif_file = EXIFR::JPEG.new @pathname.to_s
    # TODO Refatorar esses ifs feios :/
    if exif_file.exif? and not exif_file.date_time.to_s.empty?
      if (exif_file.date_time.is_a? String)
        if (exif_file.date_time.to_s.count(':') == 5)
          DateTime.parse(exif_file.date_time.sub(':', '-').sub(':', '-').sub(':', ' '))
        else
          DateTime.parse(exif_file.date_time)
        end
      else
        exif_file.date_time
      end
    else
      @pathname.mtime
    end
  end

end
