module Dexter
  def self.load_files(files)
    files.collect do |file|
      matchers.each do |matcher|
        matcher.new(file) if matcher.allowed?(file)
      end
    end.compact
  end

  def self.matchers
    [Matchers::Video, Matchers::Subtitle]
  end

  module FileUtils
    def self.extension(filename)
      filename =~ /.+\.([0-9A-z].+)$/
      $1
    end

    def self.list_all_files_within_directory(path)
      expression = "#{path}/**/*.{#{Dexter.matchers.collect{|m| m::EXTENSIONS}.flatten.join(',')}}"
      Dir.glob(expression)
    end
  end

  class AbstractMatcher

    EXTENSIONS = []

    def self.allowed?(filename) 
      self::EXTENSIONS.include? FileUtils.extension(filename)
    end

    def initialize(filename)
      raise "Not an allowed format!" unless self.class.allowed?(filename)
      @filename = filename
    end

    def organize!
      raise "It's up to the subclass to implement this"
    end
    
    def extension
      FileUtils.extension(@filename)
    end
  end

  module Matchers
    class Video < AbstractMatcher

      EXTENSIONS = ['avi', 'mkv']

      def name
        filename.downcase =~ /([0-9A-z\s\.]+)\s?\.?-?\s?\.?(s[0-9]+e[0-9]+|[0-9]+x[0-9]+).*/
        return nil if $1.nil?
        return $1.gsub('.', ' ')   \
          .split(' ')              \
          .collect(&:capitalize)   \
          .join(' ')               \
          .strip
      end

      def season
        filename.downcase =~ /[\s\.]?s([0-9]{2})e[0-9]{2}/
        filename.downcase =~ /([\s\.]?[0-9])+x[0-9]+/ if $1.nil?
        return nil if $1.nil?
        $1.to_i
      end

      def episode
        filename.downcase =~ /[\s\.]?s[0-9]{2}e([0-9]{2})/
        filename.downcase =~ /[\s\.]?[0-9]+x([0-9]+)/ if $1.nil?
        return nil if $1.nil?
        $1.to_i
      end

    end
    class Subtitle < Video
      EXTENSIONS = ['sub', 'srt']
    end
  end
end
