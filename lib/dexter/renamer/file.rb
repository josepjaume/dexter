require 'dexter/detective'
require 'dexter/configuration'

module Dexter
  module Renamer
    class File
      attr_accessor :filename

      def initialize(filename)
        self.filename = filename
      end

      def format
        Dexter.config.format_block || Proc.new do
          "#{show}/S#{padded_season}/#{show} - S#{padded_season}E#{padded_episode}.#{extension}"
        end
      end

      def destination_filename
        episode.instance_eval(&format)
      end

      def basedir
        ::File.expand_path(
          Dexter.config.basedir || '.'
        )
      end

      def create_dir
        destination_directory = ::File.dirname(destination)
        ::FileUtils.mkdir_p(destination_directory) unless ::File.exists?(destination_directory)
      end

      def destination
        ::File.join(basedir, destination_filename)
      end

      def episode
        @episode ||= Detective.new(@filename).report
      end

      def rename(options = {})
        options[:force] ||= Dexter.config.force_rename
        return false if destination_exists? && !options[:force]
        create_dir
        ::File.rename(filename, destination)
      end

      def destination_exists?
        ::File.exists?(destination)
      end
    end
  end
end
