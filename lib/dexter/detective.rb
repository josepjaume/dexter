require_relative 'parser'

module Dexter
  class Detective
    def initialize(data)
      @data = data
    end

    def report
      result = parsed
      result.merge!(origin: @data)
      Episode.new result
    end

    def parsed
      return @parsed if @parsed
      result = Parser.new.parse(@data)
      normalizer = Parser::Normalizer.new(result)
      @parsed = normalizer.apply
    rescue
      raise "Episode not valid"
    end
  end
end

require_relative 'detective/episode'
