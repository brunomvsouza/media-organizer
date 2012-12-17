class OSWalk

  def initialize(target_dir)
    @target_dir = target_dir
  end

  def walk_files(ext_filter=[])
    filtered_files = []
    self.walk[:files].each do |file|
      p file
      filtered_files << file if ext_filter.include? file.extname.downcase
    end
    filtered_files
  end

  def walk
    root = Pathname(@target_dir)
    files, dirs = [], []
    Pathname(root).find do |path|
      unless path == root
        dirs << path if path.directory?
        files << path if path.file?
      end
    end
    {root: root, files: files, dirs: dirs}
  end

end