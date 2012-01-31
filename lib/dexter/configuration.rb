module Dexter
  def self.config
    @config ||= Configuration.new
  end

  def self.configure(&block)
    block.call(config)
  end

  class Configuration
    attr_accessor :basedir
    attr_accessor :force_rename

    def format(&block)
      @format = block
    end

    def reset_format
      @format = nil
    end

    def format_block
      @format
    end

  end
end
