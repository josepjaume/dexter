module Dexter
  class Detective
    def initialize(string)
      @data = data
    end

    def report
      result = Parser.new.parse(@data)
      Normalizer.new.apply(result)
    end
  end
end
