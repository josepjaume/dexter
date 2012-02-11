require_relative 'parser'

module Dexter
  class Detective
    def initialize(data)
      @data = data
    end

    def report
      result = Parser.new.parse(@data)
      normalizer = Parser::Normalizer.new(result)
      data = normalizer.apply
      data.merge!(origin: @data)
      Episode.new data
    end
  end
end

require_relative 'detective/episode'
