class Video

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
    @pathname.mtime
  end

end