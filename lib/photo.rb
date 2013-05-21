class Photo

  def initialize(pathname)
    @pathname = pathname
    @md5sum = Digest::MD5.file(full_path).hexdigest
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

  def md5sum
    @md5sum
  end

  def creation_datetime

    unless ['.jpg', 'jpeg'].include? ext
      return @pathname.mtime
    end

    exif_file = EXIFR::JPEG.new @pathname.to_s
    #p exif_file.exif
    #p exif_file.date_time_original
    #p exif_file.date_time
    #system.exit 0

    if exif_file.exif?
      # Apple iPhone
      if not exif_file.date_time_original.to_s.empty?
        return_valid_exif_date exif_file.date_time_original
      # Generic Camera
      elsif not exif_file.date_time.to_s.empty?
        return_valid_exif_date exif_file.date_time
      # Apple iPhone
      elsif not exif_file.date_time_digitized.to_s.empty?
        return_valid_exif_date exif_file.date_time_digitized
      else
        @pathname.mtime
      end
    else
      @pathname.mtime
    end
  end

  def return_valid_exif_date(date_time)
    if (date_time.is_a? String)
      # Workaroud for dates in old Motorola phones
      if (date_time.to_s.count(':') == 5)
        DateTime.parse(date_time.sub(':', '-').sub(':', '-').sub(':', ' '))
      else
        DateTime.parse(date_time)
      end
    else
      date_time
    end
  end

end
