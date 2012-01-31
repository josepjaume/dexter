require_relative '../detective'

module Dexter
  class Detective
    class Episode
      def initialize(data)
        @data = data
      end

      def padded_episode
        "#{episode}".to_s.rjust(2, "0")
      end

      def padded_season
        "#{season}".to_s.rjust(2, "0")
      end

      def [](key)
        @data[key]
      end

      def method_missing(m, *args, &block)
        key = m.to_sym
        @data.has_key?(key) ? @data[key] : nil
      end
    end
  end
end
