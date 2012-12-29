class Video

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
    @pathname.mtime
  end

end