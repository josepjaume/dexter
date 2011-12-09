require 'parslet'
require 'dexter/parslet_extensions'

module Dexter
  class Parser < Parslet::Parser

    rule(:separator){ space.repeat(0) >> match('[-\s]').maybe >> space.repeat(0) }
    rule(:letter) { match("[0-9A-Za-z\.'_]") }
    rule(:word) { letter.repeat(1) }
    rule(:words) { word >> (space >> word).repeat(0) }
    rule(:space) { match('[\s_\.]') }
    rule(:number) { match('[0-9]').repeat(1) }
    rule(:folder_separator) { match('[\\\\/]')}
    rule(:resolution) { (match('[0-9]').repeat(1).as(:resolution) >> match('[IiPp]')) }

    rule(:season_with_letter) { stri('s') >> number.as(:season) }
    rule(:episode_with_letter) { stri('e') >> number.as(:episode) }
    rule(:episode_and_season) {
      number.as(:season) >> match('[Xx]') >> number.as(:episode) |
      season_with_letter >> episode_with_letter
    }

    rule(:show) {
      (letter >>
        (space.maybe >> episode_and_season.absent? >> letter).repeat(0)
      ).as(:show)
    }

    rule(:extension) { match('\.') >> match('[A-z]').repeat(1,3).as(:extension) >> any.absent? }

    rule(:single_file) {
      (
        show >> separator >> episode_and_season >> (separator >> resolution).maybe |
        (number.as(:episode) >> (extension.absent? >> any).repeat >> extension)
      ) >> (extension.absent? >> any).repeat >> extension.maybe
    }

    rule(:show_path) {
      sample_path.absent? >> season_path.absent? >> words.as(:show) >> folder_separator
    }
    rule(:season_path) {
      (
        season_with_letter | number.as(:season) |
        stri('season') >> space.maybe >> number.as(:season)
      ) >> folder_separator
    }

    rule(:sample_path) {
      stri('sample').as(:sample) >> folder_separator
    }

    rule(:path) { show_path.maybe >> season_path.maybe >> sample_path.maybe }

    rule(:file) do
      (path.maybe >> single_file)
    end

    root :file

    def parse(*args)
      result = super(*args)
      Normalizer.new(result).apply
    end

    class Normalizer < Parslet::Transform
      def initialize(result)
        @result = result
      end

      def apply
        @result.inject({}) do |result, pair|
          key, value = pair
          value = (respond_to?(key)) ? send(key, value) : value
          result[key] = value
          result
        end
      end

      def episode(episode)
        Integer(episode)
      end

      def season(season)
        Integer(season)
      end

      def resolution(resolution)
        Integer(resolution)
      end

      def show(show)
        show.to_s.gsub(/[\._-]/, " ").strip
      end

      def sample(value)
        value ? true : false
      end
    end
  end
end
