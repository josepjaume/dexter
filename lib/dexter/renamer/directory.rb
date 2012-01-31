require 'dexter/detective'
require 'dexter/configuration'
require_relative 'file'

module Dexter
  module Renamer
    class Directory
      attr_accessor :dirname

      def initialize(dirname)
        unless ::File.directory?(dirname)
          raise "#{dirname} is not a directory!"
        end
        self.dirname = dirname
      end

      def file_list
        @file_list ||= Dir.glob(::File.join dirname, '**/*').select do |entry|
          ::File.file? entry
        end
      end

      def files
        @files ||= file_list.map{|f| File.new f}
      end

      def destination_exists?
        files.any?(&:destination_exists?)
      end
    end
  end
end
