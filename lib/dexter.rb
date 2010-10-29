require 'fileutils'

module Dexter

  def self.verbose; @verbose; end
  def self.verbose=(level);@verbose=level;end

  def self.organize!(input_path, output_path)

    if File.file?(input_path)
      files = self.load_files([input_path])
    else
      files = self.load_from_directory(input_path)
    end

    files.each do |file|
      output_file = file.organize!(output_path)
      puts "Organizing: \"#{file.filename}\" ~> \"#{output_file}\"" if Dexter.verbose
    end

  end

  def self.load_from_directory(path)
    self.load_files self.list_all_files_within_directory(path)
  end

  def self.load_files(files)
    result = []
    files.each do |file|
      matchers.each do |matcher|
         result << matcher.new(file) if matcher.allowed?(file)
      end
    end
    return result.compact
  end

  def self.matchers
    [Matchers::Video]
  end

  def self.list_all_files_within_directory(path)
    expression = "#{path}/**/*.{#{Dexter.matchers.collect{|m| m::EXTENSIONS}.flatten.join(',')}}"
    Dir.glob(expression)
  end


  module Matchers
    class AbstractMatcher

      EXTENSIONS = []

      def self.allowed?(filename) 
        self::EXTENSIONS.include? File.extname(filename).gsub(/^\./,"")
      end

      def initialize(filename)
        raise "Not an allowed format!" unless self.class.allowed?(filename)
        @filename = filename
      end

      def organize!
        raise "It's up to the subclass to implement this"
      end
      
      def extension
        File.extname(@filename).gsub(/^\./,"")
      end

      def filename
        @filename
      end
    end

    class Video < AbstractMatcher

      EXTENSIONS = ['avi', 'mkv']

      def self.output_format
        @output ||= ':name/S:season/:name S:seasonE:episode.:extension'
      end
      
      def self.allowed?(filename) 
        if !super(filename)
          return false
        end
        filename.downcase =~ /([0-9A-z\s\.]+)\s?\.?-?\s?\.?(s[0-9]+e[0-9]+|[0-9]+x[0-9]+).*/
        return !!$1
      end

      def self.output_format=(options)
        @output = options
      end

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
        filename.downcase =~ /[\s\.]?([0-9]+)x[0-9]+/ if $1.nil?
        return nil if $1.nil?
        $1.to_i
      end

      def episode
        filename.downcase =~ /[\s\.]?s[0-9]{2}e([0-9]{2})/
        filename.downcase =~ /[\s\.]?[0-9]+x([0-9]+)/ if $1.nil?
        return nil if $1.nil?
        $1.to_i
      end

      def output(path)
        options = {
          :season => season.to_s.rjust(2,'0'),
          :episode => episode.to_s.rjust(2,'0'),
          :name => name,
          :path => path,
          :extension => extension
        }
        options.inject(':path/' + self.class.output_format){ |output, object|
          output = (output.gsub(":#{object[0]}", object[1]) || output)
        }
      end

      def organize!(path)
        output_path = File.dirname(output(path))
        FileUtils.mkdir_p(output_path)
        FileUtils.mv(@filename, output(path))
        return output(path)
      end

    end
  end
end
