module Dexter
  # Your code goes here...
  def self.load_files(files)
    files.collect do |file|
      matchers.each do |matcher|
        matcher.new(file) if matcher.allowed?(file)
      end
    end
  end

  def self.matchers
    [Matchers::Video]
  end

  module FileUtils
    def self.extension(filename)
      filename =~ /.+\.([0-9A-z].+)$/
      $1
    end
  end

  class AbstractMatcher

    EXTENSIONS = []

    def self.allowed?(filename) 
      self::EXTENSIONS.include? FileUtils.extension(filename)
    end

    def initialize(filename)
      @filename = filename
    end
    
    def extension
      FileUtils.extension(@filename)
    end
  end

  module Matchers
    class Video < AbstractMatcher
      EXTENSIONS = ['avi', 'mkv']
    end
  end
end
