require_relative '../spec_helper'
require 'dexter/configuration'

describe Dexter::Configuration do
  describe ".config" do
    it "returns a new configuration" do
      config = Dexter.config
      config.must_be_kind_of Dexter::Configuration
    end

    it "should return the same instance every time" do
      config = Dexter.config
      Dexter.config.must_equal config
    end
  end
end
