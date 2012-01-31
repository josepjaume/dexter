require_relative 'parser'

module Dexter
  class Detective
    def initialize(data)
      @data = data
    end

    def report
      result = Parser.new.parse(@data)
      normalizer = Parser::Normalizer.new(result)
      Episode.new normalizer.apply
    end
  end
end

require_relative 'detective/episode'
